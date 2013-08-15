/* _NVRM_COPYRIGHT_BEGIN_
 *
 * Copyright 1999-2001 by NVIDIA Corporation.  All rights reserved.  All
 * information contained herein is proprietary and confidential to NVIDIA
 * Corporation.  Any use, reproduction, or disclosure without the written
 * permission of NVIDIA Corporation is prohibited.
 *
 * _NVRM_COPYRIGHT_END_
 */

#include "nv-misc.h"
#include "os-interface.h"
#include "nv-linux.h"
#include "nv_compiler.h"
#include "os-agp.h"
#include "nv-vm.h"

#if defined(MODULE_LICENSE)
MODULE_LICENSE("NVIDIA");
#endif
#if defined(MODULE_INFO)
MODULE_INFO(supported, "external");
#endif

#ifdef MODULE_ALIAS_CHARDEV_MAJOR
MODULE_ALIAS_CHARDEV_MAJOR(NV_MAJOR_DEVICE_NUMBER);
#endif

#if defined(KERNEL_2_4) && (defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE))
extern int i2c_add_adapter (struct i2c_adapter *) __attribute__ ((weak));
extern int i2c_del_adapter (struct i2c_adapter *) __attribute__ ((weak));
#endif

#include "patches.h"

/*
 * our global state; one per device
 */

static U032 num_nv_devices = 0;
static U032 num_probed_nv_devices = 0;

nv_linux_state_t nv_linux_devices[NV_MAX_DEVICES];
EXPORT_SYMBOL(nv_linux_devices);

#if defined(NV_PM_SUPPORT_OLD_STYLE_APM)
static struct pm_dev *apm_nv_dev[NV_MAX_DEVICES] = { 0 };
#endif

int nv_pat_mode = NV_PAT_MODE_DISABLED;

#if defined(NVCPU_X86) || defined(NVCPU_X86_64)
NvU64 __nv_supported_pte_mask = ~_PAGE_NX;
#endif

/*
 * And one for the control device
 */

nv_linux_state_t nv_ctl_device = { { 0 } };
wait_queue_head_t nv_ctl_waitqueue;

#ifdef CONFIG_PROC_FS
struct proc_dir_entry *proc_nvidia;
struct proc_dir_entry *proc_nvidia_warnings;
struct proc_dir_entry *proc_nvidia_patches;
#endif

static const char *__README_warning = \
    "The NVIDIA graphics driver tries to detect potential problems\n"
    "with the host system and warns about them using the system's\n"
    "logging mechanisms. Important warning message are also logged\n"
    "to dedicated text files in this directory.\n";

static const char *__README_patches = \
    "The NVIDIA graphics driver's kernel interface files can be\n"
    "patched to improve compatibility with new Linux kernels or to\n"
    "fix bugs in these files. When applied, each official patch\n"
    "provides a short text file with a short description of itself\n"
    "in this directory.\n";

#if defined(NV_SWIOTLB)
static const char *__swiotlb_warning = \
    "You are probably using the kernel's SWIOTLB interface.\n\n"
    "Be very careful with this interface, as it is easy to exhaust\n"
    "its memory buffer, at which point it may panic the kernel.\n"
    "Please increase the default size of this buffer by specifying\n"
    "a larger buffer size with the \"swiotlb\" kernel parameter,\n"
    "e.g.: \"swiotlb=16384\".\n";
#endif

#if defined(NV_CHANGE_PAGE_ATTR_BUG_PRESENT)
static const char *__cpgattr_warning = \
    "Your Linux kernel has known problems in its implementation of\n"
    "the change_page_attr() kernel interface.\n\n"
    "The NVIDIA graphics driver will attempt to work around these\n"
    "problems, but system stability may be adversely affected.\n"
    "It is recommended that you update to Linux 2.6.11 (or a newer\n"
    "Linux kernel release).\n";

static const char *__cpgattr_warning_2 = \
    "Your Linux kernel's version and architecture indicate that it\n"
    "may have an implementation of the change_page_attr() kernel\n"
    "kernel interface known to have problems. The NVIDIA graphics\n"
    "driver made an attempt to determine whether your kernel is\n"
    "affected, but could not. It will assume the interface does not\n"
    "work correctly and attempt to employ workarounds.\n"
    "This may adversely affect system stability.\n"
    "It is recommended that you update to Linux 2.6.11 (or a newer\n"
    "Linux kernel release).\n";
#endif

static const char *__mmconfig_warning = \
    "Your current system configuration has known problems when\n"
    "accessing PCI Configuration Space that can lead to accesses\n"
    "to the PCI Configuration Space of the wrong PCI device. This\n"
    "is known to cause instabilities with the NVIDIA graphics driver.\n\n"
    "Please see the MMConfig section in the readme for more information\n"
    "on how to work around this problem.\n";

#if defined(NV_SG_MAP_BUFFERS)
int nv_swiotlb = 0;
#if defined(NV_NEED_REMAP_CHECK)
unsigned int nv_remap_count;
unsigned int nv_remap_limit;
#endif
#endif

int nv_update_memory_types = 1;
static int nv_mmconfig_failure_detected = 0;

static void *nv_pte_t_cache = NULL;

// allow an easy way to convert all debug printfs related to events
// back and forth between 'info' and 'errors'
#if defined(NV_DBG_EVENTS)
#define NV_DBG_EVENTINFO NV_DBG_ERRORS
#else
#define NV_DBG_EVENTINFO NV_DBG_INFO
#endif

/***
 *** STATIC functions, only in this file
 ***/

/* nvos_ functions.. do not take a state device parameter  */
static int      nvos_post_vbios(void *, int);
static void     nvos_proc_create(void);
static void     nvos_proc_add_text_file(struct proc_dir_entry *,
                    const char *, const char *);
static void     nvos_proc_remove_all(struct proc_dir_entry *);
static void     nvos_proc_remove(void);
static int      nvos_count_devices(void);

static nv_alloc_t  *nvos_create_alloc(struct pci_dev *, int);
static int          nvos_free_alloc(nv_alloc_t *);

/* nvl_ functions.. take a linux state device pointer */
static nv_alloc_t  *nvl_find_alloc(nv_linux_state_t *, unsigned long, unsigned long);
static int          nvl_add_alloc(nv_linux_state_t *, nv_alloc_t *);
static int          nvl_remove_alloc(nv_linux_state_t *, nv_alloc_t *);

/* lock-related functions that should only be called from this file */
static void nv_lock_init_locks(nv_state_t *nv);


/***
 *** EXPORTS to Linux Kernel
 ***/

/* nv_kern_* functions, driver interfaces called by the Linux kernel */
static void   nv_kern_vma_open(struct vm_area_struct *);
static void   nv_kern_vma_release(struct vm_area_struct *);

int           nv_kern_open(struct inode *, struct file *);
int           nv_kern_close(struct inode *, struct file *);
int           nv_kern_mmap(struct file *, struct vm_area_struct *);
unsigned int  nv_kern_poll(struct file *, poll_table *);
int           nv_kern_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
long          nv_kern_unlocked_ioctl(struct file *, unsigned int, unsigned long);
long          nv_kern_compat_ioctl(struct file *, unsigned int, unsigned long);
void          nv_kern_isr_bh(unsigned long);
#if !defined(NV_IRQ_HANDLER_T_PRESENT) || (NV_IRQ_HANDLER_T_ARGUMENT_COUNT == 3)
irqreturn_t   nv_kern_isr(int, void *, struct pt_regs *);
#else
irqreturn_t   nv_kern_isr(int, void *);
#endif
void          nv_kern_rc_timer(unsigned long);
#if defined(NV_PM_SUPPORT_OLD_STYLE_APM)
static int    nv_kern_apm_event(struct pm_dev *, pm_request_t, void *);
#endif

static int    nv_kern_read_cardinfo(char *, char **, off_t off, int, int *, void *);
static int    nv_kern_read_status(char *, char **, off_t off, int, int *, void *);
static int    nv_kern_read_registry(char *, char **, off_t off, int, int *, void *);       
static int    nv_kern_read_agpinfo(char *, char **, off_t off, int, int *, void *);
static int    nv_kern_read_version(char *, char **, off_t off, int, int *, void *);
static int    nv_kern_read_text_file(char *, char **, off_t off, int, int *, void *);

int           nv_kern_ctl_open(struct inode *, struct file *);
int           nv_kern_ctl_close(struct inode *, struct file *);
unsigned int  nv_kern_ctl_poll(struct file *, poll_table *);

int nv_kern_probe(struct pci_dev *, const struct pci_device_id *);

#if defined(NV_PM_SUPPORT_DEVICE_DRIVER_MODEL)
static int    nv_kern_suspend(struct pci_dev *, pm_message_t);
static int    nv_kern_resume(struct pci_dev *);
#endif

/***
 *** see nv.h for functions exported to other parts of resman
 ***/

static struct pci_device_id nv_pci_table[] = {
    { 
        .vendor      = PCI_VENDOR_ID_NVIDIA,
        .device      = PCI_ANY_ID,
        .subvendor   = PCI_ANY_ID,
        .subdevice   = PCI_ANY_ID,
        .class       = (PCI_CLASS_DISPLAY_VGA << 8),
        .class_mask  = ~0
    },
    { 
        .vendor      = PCI_VENDOR_ID_NVIDIA,
        .device      = PCI_ANY_ID,
        .subvendor   = PCI_ANY_ID,
        .subdevice   = PCI_ANY_ID,
        .class       = (PCI_CLASS_DISPLAY_3D << 8),
        .class_mask  = ~0
    },
    { }
};

MODULE_DEVICE_TABLE(pci, nv_pci_table);

static struct pci_driver nv_pci_driver = {
    .name     = "nvidia",
    .id_table = nv_pci_table,
    .probe    = nv_kern_probe,
#if defined(NV_PM_SUPPORT_DEVICE_DRIVER_MODEL)
    .suspend  = nv_kern_suspend,
    .resume   = nv_kern_resume,
#endif
};

/* character driver entry points */

static struct file_operations nv_fops = {
    .owner     = THIS_MODULE,
    .poll      = nv_kern_poll,
#if defined(NV_FILE_OPERATIONS_HAS_IOCTL)
    .ioctl     = nv_kern_ioctl,
#endif
#if defined(NV_FILE_OPERATIONS_HAS_UNLOCKED_IOCTL)
    .unlocked_ioctl = nv_kern_unlocked_ioctl,
#endif
#if defined(NVCPU_X86_64) && defined(NV_FILE_OPERATIONS_HAS_COMPAT_IOCTL)
    .compat_ioctl = nv_kern_compat_ioctl,
#endif
    .mmap      = nv_kern_mmap,
    .open      = nv_kern_open,
    .release   = nv_kern_close,
};

// Our reserved major device number.
int nv_major = NV_MAJOR_DEVICE_NUMBER;

// pull in the pointer to the NVID stamp from the binary module
extern const char *pNVRM_ID;

#if defined(VM_CHECKER)
/* kernel virtual memory usage/allocation information */
U032 vm_usage = 0;
struct mem_track_t *vm_list = NULL;
nv_spinlock_t vm_lock;
#endif

#if defined(KM_CHECKER)
/* kernel logical memory usage/allocation information */
U032 km_usage = 0;
struct mem_track_t *km_list = NULL;
nv_spinlock_t km_lock;
#endif


/***
 *** STATIC functions
 ***/

/* specify that this card needs it's vbios posted */
static int nvos_post_vbios(void *args, int size)
{
    nv_ioctl_post_vbios_t *info;
    U032 i;

    if (size != sizeof(nv_ioctl_post_vbios_t))
        return -EINVAL;

    info = args;
    for (i = 0; i < num_nv_devices; i++)
    {
        nv_state_t *nv = NV_STATE_PTR(&nv_linux_devices[i]);
        if (nv->bus == info->bus && nv->slot == info->slot)
        {
            // we assume any device was already posted and rely on
            // X to tell us which cards need posting. But if we've
            // already manually posted a card, it doesn't need to 
            // be reposted again.
            if (!(nv->flags & NV_FLAG_WAS_POSTED || nv->flags & NV_FLAG_OPEN))
            {
                nv->flags |= NV_FLAG_NEEDS_POSTING;
            }
        }
    }

    return 0;
}

static 
nv_alloc_t *nvos_create_alloc(
    struct pci_dev *dev,
    int num_pages
)
{
    nv_alloc_t *at;
    unsigned int pt_size, i;

    NV_KMALLOC(at, sizeof(nv_alloc_t));
    if (at == NULL)
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: failed to allocate alloc info\n");
        return NULL;
    }

    memset(at, 0, sizeof(nv_alloc_t));

    pt_size = num_pages *  sizeof(nv_pte_t *);
    if (os_alloc_mem((void **)&at->page_table, pt_size) != RM_OK)
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: failed to allocate page table\n");
        NV_KFREE(at, sizeof(nv_alloc_t));
        return NULL;
    }

    memset(at->page_table, 0, pt_size);
    at->num_pages = num_pages;
    NV_ATOMIC_SET(at->usage_count, 0);

    for (i = 0; i < at->num_pages; i++)
    {
        NV_KMEM_CACHE_ALLOC(at->page_table[i], nv_pte_t_cache, nv_pte_t);
        if (at->page_table[i] == NULL)
        {
            nv_printf(NV_DBG_ERRORS,
                      "NVRM: failed to allocate page table entry\n");
            nvos_free_alloc(at);
            return NULL;
        }
        memset(at->page_table[i], 0, sizeof(nv_pte_t));
    }

    at->pid = os_get_current_process();

    return at;
}

static 
int nvos_free_alloc(
    nv_alloc_t *at
)
{
    unsigned int i;

    if (at == NULL)
        return -1;

    if (NV_ATOMIC_READ(at->usage_count))
        return 1;

    for (i = 0; i < at->num_pages; i++)
    {
        if (at->page_table[i] != NULL)
            NV_KMEM_CACHE_FREE(at->page_table[i], nv_pte_t, nv_pte_t_cache);
    }
    os_free_mem(at->page_table);

    NV_KFREE(at, sizeof(nv_alloc_t));

    return 0;
}

static u8 nvos_find_agp_capability(struct pci_dev *dev)
{
    u16 status;
    u8  cap_ptr, cap_id;

    pci_read_config_word(dev, PCI_STATUS, &status);
    status &= PCI_STATUS_CAP_LIST;
    if (!status)
        return 0;

    switch (dev->hdr_type) {
        case PCI_HEADER_TYPE_NORMAL:
        case PCI_HEADER_TYPE_BRIDGE:
            pci_read_config_byte(dev, PCI_CAPABILITY_LIST, &cap_ptr);
            break;
        default:
            return 0;
    }

    do {
        cap_ptr &= 0xfc;
        pci_read_config_byte(dev, cap_ptr + PCI_CAP_LIST_ID, &cap_id);
        if (cap_id == PCI_CAP_ID_AGP)
            return cap_ptr;
        pci_read_config_byte(dev, cap_ptr + PCI_CAP_LIST_NEXT, &cap_ptr);
    } while (cap_ptr && cap_id != 0xff);

    return 0;
}

static u8 nvos_find_pci_express_capability(struct pci_dev *dev)
{
    u16 status;
    u8  cap_ptr, cap_id;

    pci_read_config_word(dev, PCI_STATUS, &status);
    status &= PCI_STATUS_CAP_LIST;
    if (!status)
        return 0;

    switch (dev->hdr_type) {
        case PCI_HEADER_TYPE_NORMAL:
        case PCI_HEADER_TYPE_BRIDGE:
            pci_read_config_byte(dev, PCI_CAPABILITY_LIST, &cap_ptr);
            break;
        default:
            return 0;
    }

    do {
        cap_ptr &= 0xfc;
        pci_read_config_byte(dev, cap_ptr + PCI_CAP_LIST_ID, &cap_id);
        if (cap_id == PCI_CAP_ID_EXP)
            return cap_ptr;
        pci_read_config_byte(dev, cap_ptr + PCI_CAP_LIST_NEXT, &cap_ptr);
    } while (cap_ptr && cap_id != 0xff);

    return 0;
}

static struct pci_dev* nvos_get_agp_device_by_class(unsigned int class)
{
    struct pci_dev *dev, *fdev;
    u32 slot, func, fn;

    dev = NV_PCI_GET_CLASS(class << 8, NULL);
    while (dev) {
        slot = NV_PCI_SLOT_NUMBER(dev);
        for (func = 0; func < 8; func++) {
            fn = PCI_DEVFN(slot, func);
            fdev = NV_PCI_GET_SLOT(NV_PCI_BUS_NUMBER(dev), fn);
            if (!fdev)
                continue;
            if (nvos_find_agp_capability(fdev)) {
                NV_PCI_DEV_PUT(dev);
                return fdev;
            }
            NV_PCI_DEV_PUT(fdev);
        }
        dev = NV_PCI_GET_CLASS(class << 8, dev);
    }

    return NULL;
}

static struct pci_dev* nv_get_pci_device(nv_state_t *nv)
{
    struct pci_dev *dev;

    dev = NV_PCI_GET_DEVICE(nv->vendor_id, nv->device_id, NULL);
    while (dev) {
        if (NV_PCI_SLOT_NUMBER(dev) == nv->slot
                && NV_PCI_BUS_NUMBER(dev) == nv->bus)
            return dev;
        dev = NV_PCI_GET_DEVICE(nv->vendor_id, nv->device_id, dev);
    }

    return NULL;
}

static void nvos_proc_create(void)
{
#ifdef CONFIG_PROC_FS
    struct pci_dev *dev;
    U032 j, i = 0;
    char name[6];

    struct proc_dir_entry *entry;
    struct proc_dir_entry *proc_nvidia_agp, *proc_nvidia_cards;

    /* world readable directory */
    int d_flags = S_IFDIR | S_IRUGO | S_IXUGO;

    /* world readable file */
    int flags = S_IFREG | S_IRUGO;

    nv_state_t *nv;
    nv_linux_state_t *nvl;

    proc_nvidia = create_proc_entry("driver/nvidia", d_flags, NULL);
    if (!proc_nvidia)
        goto failed;

    proc_nvidia_cards = create_proc_entry("cards", d_flags, proc_nvidia);
    if (!proc_nvidia_cards)
        goto failed;

    proc_nvidia_warnings = create_proc_entry("warnings", d_flags, proc_nvidia);
    if (!proc_nvidia_warnings)
        goto failed;

    proc_nvidia_patches = create_proc_entry("patches", d_flags, proc_nvidia);
    if (!proc_nvidia_patches)
        goto failed;

    /*
     * Set the module owner to ensure that the reference
     * count reflects accesses to the proc files.
     */
#if defined(NV_PROC_DIR_ENTRY_HAS_OWNER)
    proc_nvidia->owner = THIS_MODULE;
    proc_nvidia_cards->owner = THIS_MODULE;
    proc_nvidia_warnings->owner = THIS_MODULE;
    proc_nvidia_patches->owner = THIS_MODULE;
#endif

    for (j = 0; j < num_nv_devices; j++)
    {
        nvl = &nv_linux_devices[j];
        nv = NV_STATE_PTR(nvl);

        dev = nv_get_pci_device(nv);
        if (!dev)
            break;

        sprintf(name, "%d", i++);
        entry = create_proc_entry(name, flags, proc_nvidia_cards);
        if (!entry) {
            NV_PCI_DEV_PUT(dev);
            goto failed;
        }

        entry->data = nv;
        entry->read_proc = nv_kern_read_cardinfo;
#if defined(NV_PROC_DIR_ENTRY_HAS_OWNER)
        entry->owner = THIS_MODULE;
#endif

        if (nvos_find_agp_capability(dev)) {
            /*
             * Create the /proc/driver/nvidia/agp/{status,host-bridge,card}
             * entries now that we know there's AGP hardware.
             */
            entry = create_proc_entry("agp", d_flags, proc_nvidia);
            if (!entry) {
                NV_PCI_DEV_PUT(dev);
                goto failed;
            }

#if defined(NV_PROC_DIR_ENTRY_HAS_OWNER)
            entry->owner = THIS_MODULE;
#endif
            proc_nvidia_agp = entry;

            entry = create_proc_entry("status", flags, proc_nvidia_agp);
            if (!entry) {
                NV_PCI_DEV_PUT(dev);
                goto failed;
            }

            entry->data = nv;
            entry->read_proc = nv_kern_read_status;
#if defined(NV_PROC_DIR_ENTRY_HAS_OWNER)
            entry->owner = THIS_MODULE;
#endif

            entry = create_proc_entry("host-bridge", flags, proc_nvidia_agp);
            if (!entry) {
                NV_PCI_DEV_PUT(dev);
                goto failed;
            }

            entry->data = NULL;
            entry->read_proc = nv_kern_read_agpinfo;
#if defined(NV_PROC_DIR_ENTRY_HAS_OWNER)
            entry->owner = THIS_MODULE;
#endif

            entry = create_proc_entry("card", flags, proc_nvidia_agp);
            if (!entry) {
                NV_PCI_DEV_PUT(dev);
                goto failed;
            }

            entry->data = nv;
            entry->read_proc = nv_kern_read_agpinfo;
#if defined(NV_PROC_DIR_ENTRY_HAS_OWNER)
            entry->owner = THIS_MODULE;
#endif
        }

        NV_PCI_DEV_PUT(dev);
    }

    entry = create_proc_entry("version", flags, proc_nvidia);
    if (!entry)
        goto failed;

    entry->read_proc = nv_kern_read_version;
#if defined(NV_PROC_DIR_ENTRY_HAS_OWNER)
    entry->owner = THIS_MODULE;
#endif

    entry = create_proc_entry("registry", flags, proc_nvidia);
    if (!entry)
        goto failed;

    entry->read_proc = nv_kern_read_registry;
#if defined(NV_PROC_DIR_ENTRY_HAS_OWNER)
    entry->owner = THIS_MODULE;
#endif

    return;

failed:
    nv_printf(NV_DBG_ERRORS, "NVRM: failed to create /proc entries!\n");
    nvos_proc_remove_all(proc_nvidia);
#endif
}

static void
nvos_proc_add_text_file(
    struct proc_dir_entry *parent,
    const char *filename,
    const char *text
)
{
#ifdef CONFIG_PROC_FS
    struct proc_dir_entry *entry;

    /* world readable file */
    int flags = S_IFREG | S_IRUGO;

    entry = create_proc_entry(filename, flags, parent);
    if (!entry) return;

    entry->data = (void *)text;
    entry->read_proc = nv_kern_read_text_file;
#if defined(NV_PROC_DIR_ENTRY_HAS_OWNER)
    entry->owner = THIS_MODULE;
#endif
#endif
}

#ifdef CONFIG_PROC_FS
static void nvos_proc_remove_all(struct proc_dir_entry *entry)
{
    while (entry) {
        struct proc_dir_entry *next = entry->next;
        if (entry->subdir)
            nvos_proc_remove_all(entry->subdir);
        remove_proc_entry(entry->name, entry->parent);
        if (entry == proc_nvidia)
            break;
        entry = next;
    }
}
#endif

static void nvos_proc_remove(void)
{
#ifdef CONFIG_PROC_FS
    nvos_proc_remove_all(proc_nvidia);
#endif
}

/*
 * Given a physical address (within the AGP aperture, plain physical
 * or 32-bit DMA'able within the IOMMU), find and return the 'at' that
 * owns the address, then return it to the caller.
 */
static nv_alloc_t *nvl_find_alloc(
    nv_linux_state_t    *nvl,
    unsigned long  address,
    unsigned long  flags
)
{
    nv_alloc_t *at;

    for (at = nvl->alloc_queue; at; at = at->next)
    {
        unsigned int i;

        // make sure this 'at' matches the flags the caller provided
        // ie, don't mistake a pci allocation with an agp allocation
        if (!(at->flags & flags))
            continue;

        // most mappings will be found based on the 'key'
        if (address == ((unsigned long) at->key_mapping))
            return at;

        // if agp, allow the address to fall within this range 
        if (NV_ALLOC_MAPPING_AGP(at->flags) &&
            (address >= (unsigned long) at->key_mapping) &&
            (address + PAGE_SIZE <= (unsigned long) at->key_mapping + at->num_pages * PAGE_SIZE))
            return at;

        for (i = 0; i < at->num_pages; i++)
        {
            nv_pte_t *page_ptr = at->page_table[i];

            if ((address >= page_ptr->phys_addr) &&
                    ((address - page_ptr->phys_addr) < PAGE_SIZE))
                return at;
            if ((address >= page_ptr->dma_addr) &&
                    ((address - page_ptr->dma_addr) < PAGE_SIZE))
                return at;
        }
    }

    /* failure is not necessarily an error if the caller
       was just probing an address */
    nv_printf(NV_DBG_INFO, "NVRM: could not find map for vm 0x%lx\n", address);
    return NULL;
}

static int nvl_add_alloc(
    nv_linux_state_t *nvl, 
    nv_alloc_t *at
)
{
    down(&nvl->at_lock);
    at->next = nvl->alloc_queue;
    nvl->alloc_queue = at;
    up(&nvl->at_lock);
    return 0;
}

static int nvl_remove_alloc(
    nv_linux_state_t *nvl, 
    nv_alloc_t *at
)
{
    nv_alloc_t *tmp, *prev;

    if (nvl->alloc_queue == at)
    {
        nvl->alloc_queue = nvl->alloc_queue->next;
        return 0;
    }

    for (tmp = prev = nvl->alloc_queue; tmp; prev = tmp, tmp = tmp->next)
    {
        if (tmp == at)
        {
            prev->next = tmp->next;
            return 0;
        }
    }

    return -1;
}

static int   __nv_enable_pat_support   (void);
static void  __nv_disable_pat_support  (void);

#if defined(NV_ENABLE_PAT_SUPPORT)
/*
 * Private PAT support for use by the NVIDIA driver. This is used on
 * kernels that do not modify the PAT to include a write-combining
 * entry.
 */
static int   __determine_pat_mode      (void);
static void  __nv_setup_pat_entries    (void *);
static void  __nv_restore_pat_entries  (void *);

#define NV_READ_PAT_ENTRIES(pat1, pat2)   rdmsr(0x277, (pat1), (pat2))
#define NV_WRITE_PAT_ENTRIES(pat1, pat2)  wrmsr(0x277, (pat1), (pat2))
#define NV_PAT_ENTRY(pat, index) \
    (((pat) & (0xff << ((index)*8))) >> ((index)*8))

static inline void __nv_disable_caches(unsigned long *cr4)
{
    unsigned long cr0 = read_cr0();
    write_cr0(((cr0 & (0xdfffffff)) | 0x40000000));
    wbinvd();
    *cr4 = read_cr4();
    if (*cr4 & 0x80) write_cr4(*cr4 & ~0x80);
    __flush_tlb();
}

static inline void __nv_enable_caches(unsigned long cr4)
{
    unsigned long cr0 = read_cr0();
    wbinvd();
    __flush_tlb();
    write_cr0((cr0 & 0x9fffffff));
    if (cr4 & 0x80) write_cr4(cr4);
}

static int __determine_pat_mode()
{
    unsigned int pat1, pat2, i;
    U008 PAT_WC_index;

    if (!test_bit(X86_FEATURE_PAT,
            (volatile unsigned long *)&boot_cpu_data.x86_capability))
    {
        if ((boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) ||
                (boot_cpu_data.cpuid_level < 1) ||
                ((cpuid_edx(1) & (1 << 16)) == 0) ||
                (boot_cpu_data.x86 != 6) || (boot_cpu_data.x86_model >= 15))
        {
            nv_printf(NV_DBG_ERRORS,
                "NVRM: CPU does not support the PAT, falling back to MTRRs.\n");
            return NV_PAT_MODE_DISABLED;
        }
    }

    NV_READ_PAT_ENTRIES(pat1, pat2);
    PAT_WC_index = 0xf;

    for (i = 0; i < 4; i++)
    {
        if (NV_PAT_ENTRY(pat1, i) == 0x01)
        {
            PAT_WC_index = i;
            break;
        }

        if (NV_PAT_ENTRY(pat2, i) == 0x01)
        {
            PAT_WC_index = (i + 4);
            break;
        }
    }

    if (PAT_WC_index == 1)
        return NV_PAT_MODE_KERNEL;
    else if (PAT_WC_index != 0xf)
    {
        nv_printf(NV_DBG_ERRORS,
            "NVRM: PAT configuration unsupported, falling back to MTRRs.\n");
        return NV_PAT_MODE_DISABLED;
    }
    else
        return NV_PAT_MODE_BUILTIN;
}

static unsigned long orig_pat1, orig_pat2;

static void __nv_setup_pat_entries(void *info)
{
    unsigned long pat1, pat2, cr4;
    unsigned long eflags;

#if defined(CONFIG_HOTPLUG_CPU)
    int cpu = (NvUPtr)info;
    if ((cpu != 0) && (cpu != (int)smp_processor_id()))
        return;
#endif

    NV_SAVE_FLAGS(eflags);
    NV_CLI();
    __nv_disable_caches(&cr4);

    NV_READ_PAT_ENTRIES(pat1, pat2);

    pat1 &= 0xffff00ff;
    pat1 |= 0x00000100;

    NV_WRITE_PAT_ENTRIES(pat1, pat2);

    __nv_enable_caches(cr4);
    NV_RESTORE_FLAGS(eflags);
}

static void __nv_restore_pat_entries(void *info)
{
    unsigned long cr4;
    unsigned long eflags;

#if defined(CONFIG_HOTPLUG_CPU)
    int cpu = (NvUPtr)info;
    if ((cpu != 0) && (cpu != (int)smp_processor_id()))
        return;
#endif

    NV_SAVE_FLAGS(eflags);
    NV_CLI();
    __nv_disable_caches(&cr4);

    NV_WRITE_PAT_ENTRIES(orig_pat1, orig_pat2);

    __nv_enable_caches(cr4);
    NV_RESTORE_FLAGS(eflags);
}
#endif

static int __nv_enable_pat_support()
{
#if defined(NV_ENABLE_PAT_SUPPORT)
    unsigned long pat1, pat2;

    if (nv_pat_mode != NV_PAT_MODE_DISABLED)
        return 1;

    nv_pat_mode = __determine_pat_mode();

    switch (nv_pat_mode)
    {
        case NV_PAT_MODE_DISABLED:
            /* avoid the PAT if unavailable/unusable */
            return 0;
        case NV_PAT_MODE_KERNEL:
            /* inherit the kernel's PAT layout */
            return 1;
        case NV_PAT_MODE_BUILTIN:
            /* use builtin code to modify the PAT layout */
            break;
    }

    NV_READ_PAT_ENTRIES(orig_pat1, orig_pat2);
    nv_printf(NV_DBG_SETUP, "saved orig pats as 0x%lx 0x%lx\n", orig_pat1, orig_pat2);

    if (nv_execute_on_all_cpus(__nv_setup_pat_entries, NULL) != 0)
    {
        nv_execute_on_all_cpus(__nv_restore_pat_entries, NULL);
        return 0;
    }

    NV_READ_PAT_ENTRIES(pat1, pat2);
    nv_printf(NV_DBG_SETUP, "changed pats to 0x%lx 0x%lx\n", pat1, pat2);
#endif
    return 1;
}

static void __nv_disable_pat_support()
{
#if defined(NV_ENABLE_PAT_SUPPORT)
    unsigned long pat1, pat2;

    if (nv_pat_mode != NV_PAT_MODE_BUILTIN)
        return;

    if (nv_execute_on_all_cpus(__nv_restore_pat_entries, NULL) != 0)
        return;

    nv_pat_mode = NV_PAT_MODE_DISABLED;

    NV_READ_PAT_ENTRIES(pat1, pat2);
    nv_printf(NV_DBG_SETUP, "restored orig pats as 0x%lx 0x%lx\n", pat1, pat2);
#endif
}

#if defined(NV_CHANGE_PAGE_ATTR_BUG_PRESENT)
/*
 * nv_verify_cpa_interface() - determine if the change_page_attr() large page
 * management accounting bug known to exist in early Linux/x86-64 kernels
 * is present in this kernel.
 *
 * There's really no good way to determine if change_page_attr() is working
 * correctly. We can't reliably use change_page_attr() on Linux/x86-64 2.6
 * kernels < 2.6.11: if we run into the accounting bug, the Linux kernel will
 * trigger a BUG() if we attempt to restore the WB memory type of a page
 * originally part of a large page.
 *
 * So if we can successfully allocate such a page, change its memory type to
 * UC and check if the accounting was done correctly, we can determine if
 * the change_page_attr() interface can be used safely.
 *
 * Return values:
 *    0 - test passed, the change_page_attr() interface works
 *    1 - test failed, the status is unclear
 *   -1 - test failed, the change_page_attr() interface is broken
 */

static inline pte_t *check_large_page(unsigned long vaddr)
{
    pgd_t *pgd = NULL;
    pmd_t *pmd = NULL;

    pgd = NV_PGD_OFFSET(vaddr, 1, NULL);
    if (!NV_PGD_PRESENT(pgd))
        return NULL;

    pmd = NV_PMD_OFFSET(vaddr, pgd);
    if (!pmd || pmd_none(*pmd))
        return NULL;

    if (!pmd_large(*pmd))
        return NULL;

    return (pte_t *) pmd;
}

#define CPA_FIXED_MAX_ALLOCS 500

int nv_verify_cpa_interface(void)
{
    unsigned int i, size;
    unsigned long large_page = 0;
    unsigned long *vaddr_list;
    size = sizeof(unsigned long) * CPA_FIXED_MAX_ALLOCS;

    NV_KMALLOC(vaddr_list, size);
    if (!vaddr_list)
    {
        nv_printf(NV_DBG_ERRORS,
            "NVRM: nv_verify_cpa_interface: failed to allocate "
            "page table\n");
        return 1;
    }

    memset(vaddr_list, 0, size);

    /* try to track down an allocation from a 2M page. */
    for (i = 0; i < CPA_FIXED_MAX_ALLOCS; i++)
    {
        vaddr_list[i] =  __get_free_page(GFP_KERNEL);
        if (!vaddr_list[i])
            continue;

#if defined(_PAGE_NX)
        if ((pgprot_val(PAGE_KERNEL) & _PAGE_NX) &&
                virt_to_phys((void *)vaddr_list[i]) < 0x400000)
            continue;
#endif

        if (check_large_page(vaddr_list[i]) != NULL)
        {
            large_page = vaddr_list[i];
            vaddr_list[i] = 0;
            break;
        }
    }

    for (i = 0; i < CPA_FIXED_MAX_ALLOCS; i++)
    {
        if (vaddr_list[i])
            free_page(vaddr_list[i]);
    }
    NV_KFREE(vaddr_list, size);

    if (large_page)
    {
        struct page *page = virt_to_page(large_page);
        struct page *kpte_page;
        pte_t *kpte;
        unsigned long kpte_val;
        pgprot_t prot;

        // lookup a pointer to our pte
        kpte = check_large_page(large_page);
        kpte_val = pte_val(*kpte);
        kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);

        prot = PAGE_KERNEL_NOCACHE;
        pgprot_val(prot) &= __nv_supported_pte_mask;

        // this should split the large page
        change_page_attr(page, 1, prot);

        // broken kernels may get confused after splitting the page and
        // restore the page before returning to us. detect that case.
        if (((pte_val(*kpte) & ~_PAGE_NX) == kpte_val) &&
            (pte_val(*kpte) & _PAGE_PSE))
        {
            if ((pte_val(*kpte) & _PAGE_NX) &&
                    (__nv_supported_pte_mask & _PAGE_NX) == 0)
                clear_bit(_PAGE_BIT_NX, kpte);
            // don't change the page back, as it's already been reverted
            put_page(kpte_page);
            free_page(large_page);
            return -1;  // yep, we're broken
        }

        // ok, now see if our bookkeeping is broken
        if (page_count(kpte_page) != 0)
            return -1;  // yep, we're broken

        prot = PAGE_KERNEL;
        pgprot_val(prot) &= __nv_supported_pte_mask;

        // everything's ok!
        change_page_attr(page, 1, prot);
        free_page(large_page);
        return 0;
    }

    return 1;
}
#endif /* defined(NV_CHANGE_PAGE_ATTR_BUG_PRESENT) */

/*
 * nv_verify_page_mappings() - verify that the kernel mapping of the specified
 * page matches the specified type. This is to help detect bugs in the Linux
 * kernel's change_page_attr() interface, early.
 *
 * This function relies on the ability to perform kernel virtul address to PFN
 * translations and therefore on 'init_mm'. Unfortunately, the latter is no
 * longer exported in recent Linux/x86 2.6 kernels. The export was removed at
 * roughtly the same time as the set_pages_{uc,wb}() change_page_attr()
 * replacement interfaces were introduced; hopefully, it will be sufficient to
 * check for their presence.
 */
int nv_verify_page_mappings(
    nv_pte_t *page_ptr,
    unsigned int cachetype
)
{
#if defined(NV_CHANGE_PAGE_ATTR_PRESENT)
    unsigned long retval = -1;
#if defined(NVCPU_X86) || defined(NVCPU_X86_64)
    pgd_t *pgd = NULL;
    pmd_t *pmd = NULL;
    pte_t *pte = NULL;
    unsigned int flags, expected;
    unsigned long address;
    static int count = 0;

    if (!nv_update_memory_types)
        return 0;

    address = (unsigned long)__va(page_ptr->phys_addr);

    pgd = NV_PGD_OFFSET(address, 1, NULL);
    if (!NV_PGD_PRESENT(pgd))
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: pgd not present for addr 0x%lx\n", address);
        goto failed;
    }

    pmd = NV_PMD_OFFSET(address, pgd);
    if (!pmd || pmd_none(*pmd))
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: pmd not present for addr 0x%lx\n", address);
        goto failed;
    }

    // account for large pages
    if (pmd_large(*pmd))
    {
        pte = (pte_t *)pmd;
        flags = pte_val(*pte) & ~(PAGE_MASK|_PAGE_PSE);
        NV_PMD_UNMAP(pmd);
    }
    else
    {
        pte = NV_PTE_OFFSET(address, pmd);
        if (!NV_PTE_PRESENT(pte))
        {
            nv_printf(NV_DBG_ERRORS, "NVRM: pte not present for addr 0x%lx\n",
                address);
            goto failed;
        }
        flags = NV_PTE_VALUE(pte) & ~(PAGE_MASK|_PAGE_PSE);
    }

    switch (cachetype)
    {
        case NV_MEMORY_CACHED:
            expected = pgprot_val(PAGE_KERNEL);
            if ((flags & ~_PAGE_NX) == (expected & ~_PAGE_NX))
                retval = 0;
            break;
        default:
            expected = pgprot_val(PAGE_KERNEL_NOCACHE);
            if ((flags & ~(_PAGE_NX | _PAGE_PWT)) == (expected & ~(_PAGE_NX | _PAGE_PWT)))
                retval = 0;
            break;
    }

    if (retval)
    {
        if (count < NV_MAX_RECURRING_WARNING_MESSAGES)
        {
            nv_printf(NV_DBG_ERRORS,
                "NVRM: bad caching on address 0x%lx: actual 0x%x != expected 0x%x\n",
                address, flags, expected);
        }

        if (count == 0)
        {
            nv_printf(NV_DBG_ERRORS, "NVRM: please see the README section on "
                "Cache Aliasing for more information\n");
        }

        count++;
    }

failed:
#endif /* defined(NVCPU_X86) || defined(NVCPU_X86_64) */
    return retval;
#else
    return 0;
#endif
}

#if defined(NV_ENABLE_PAT_SUPPORT) && defined(CONFIG_HOTPLUG_CPU)
static int
nv_kern_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
{
    unsigned int cpu = get_cpu();

    switch (action)
    {
        case CPU_DOWN_FAILED:
        case CPU_ONLINE:
            if (cpu == (NvUPtr)hcpu)
                __nv_setup_pat_entries(NULL);
            else
                NV_SMP_CALL_FUNCTION(__nv_setup_pat_entries, hcpu, 1);
            break;
        case CPU_DOWN_PREPARE:
            if (cpu == (NvUPtr)hcpu)
                __nv_restore_pat_entries(NULL);
            else
                NV_SMP_CALL_FUNCTION(__nv_restore_pat_entries, hcpu, 1);
            break;
    }

    put_cpu();

    return NOTIFY_OK;
}

static struct notifier_block nv_hotcpu_nfb = {
    .notifier_call = nv_kern_cpu_callback,
    .priority = 0
};
#endif


/***
 *** EXPORTS to Linux Kernel
 ***/

static int __init nvidia_init_module(void)
{
    int rc, disable_pat = 0;
    U032 i, count, data;
    nv_state_t *nv = NV_STATE_PTR(&nv_ctl_device);

#if defined(VM_CHECKER)
    NV_SPIN_LOCK_INIT(&vm_lock);
#endif
#if defined(KM_CHECKER)
    NV_SPIN_LOCK_INIT(&km_lock);
#endif

    count = nvos_count_devices();
    if (count == 0)
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: No NVIDIA graphics adapter found!\n");
        return -ENODEV;
    }

    if (!rm_init_rm())
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: rm_init_rm() failed!\n");
        return -EIO;
    }

    memset(nv_linux_devices, 0, sizeof(nv_linux_devices));

    if (pci_register_driver(&nv_pci_driver) < 0)
    {
        pci_unregister_driver(&nv_pci_driver); // XXX ???
        rm_shutdown_rm();
        nv_printf(NV_DBG_ERRORS, "NVRM: No NVIDIA graphics adapter found!\n");
        return -ENODEV;
    }

    if (num_probed_nv_devices != count)
    {
        nv_printf(NV_DBG_ERRORS,
            "NVRM: The NVIDIA probe routine was not called for %d device(s).\n",
            count - num_probed_nv_devices);
        nv_printf(NV_DBG_ERRORS,
            "NVRM: This can occur when a driver such as nouveau, rivafb,\n"
            "NVRM: nvidiafb, or rivatv was loaded and obtained ownership of\n"
            "NVRM: the NVIDIA device(s).\n");
        nv_printf(NV_DBG_ERRORS,
            "NVRM: Try unloading the conflicting kernel module (and/or\n"
            "NVRM: reconfigure your kernel without the conflicting\n"
            "NVRM: driver(s)), then try loading the NVIDIA kernel module\n"
            "NVRM: again.\n");
    }

    if (num_probed_nv_devices == 0)
    {
        pci_unregister_driver(&nv_pci_driver);
        rm_shutdown_rm();
        nv_printf(NV_DBG_ERRORS, "NVRM: No NVIDIA graphics adapter probed!\n");
        return -ENODEV;
    }

    if (num_probed_nv_devices != num_nv_devices)
    {
        nv_printf(NV_DBG_ERRORS,
            "NVRM: The NVIDIA probe routine failed for %d device(s).\n",
            num_probed_nv_devices - num_nv_devices);
    }

    if (num_nv_devices == 0)
    {
        pci_unregister_driver(&nv_pci_driver);
        rm_shutdown_rm();
        nv_printf(NV_DBG_ERRORS,
            "NVRM: None of the NVIDIA graphics adapters were initialized!\n");
        return -ENODEV;
    }

    nv_printf(NV_DBG_ERRORS, "NVRM: loading %s", pNVRM_ID);
    if (__nv_patches[0].short_description != NULL)
    {
        nv_printf(NV_DBG_ERRORS,
            " (applied patches: %s", __nv_patches[0].short_description);
        for (i = 1; __nv_patches[i].short_description; i++)
        {
            nv_printf(NV_DBG_ERRORS,
                ",%s", __nv_patches[i].short_description);
        }
        nv_printf(NV_DBG_ERRORS, ")");
    }
    nv_printf(NV_DBG_ERRORS, "\n");

    rc = register_chrdev(nv_major, "nvidia", &nv_fops);
    if (rc < 0)
    {
        pci_unregister_driver(&nv_pci_driver);
        rm_shutdown_rm();
        nv_printf(NV_DBG_ERRORS, "NVRM: register_chrdev() failed!\n");
        return rc;
    }

    /* instantiate tasklets */
    for (i = 0; i < num_nv_devices; i++)
    {
        /*
         * We keep one tasklet per card to avoid latency issues with more
         * than one device; no two instances of a single tasklet are ever
         * executed concurrently.
         */
        NV_ATOMIC_SET(nv_linux_devices[i].tasklet.count, 1);
    }

    // init the nvidia control device
    {
        nv_state_t *nv_ctl = NV_STATE_PTR(&nv_ctl_device);
        nv_ctl->os_state = (void *) &nv_ctl_device;
        nv_lock_init_locks(nv_ctl);
    }

#if defined(NV_PM_SUPPORT_OLD_STYLE_APM)
    for (i = 0; i < num_nv_devices; i++)
    {
        apm_nv_dev[i] = pm_register(PM_PCI_DEV, PM_SYS_VGA, nv_kern_apm_event);
    }
#endif

    NV_KMEM_CACHE_CREATE(nv_pte_t_cache, "nv_pte_t", nv_pte_t);
    if (nv_pte_t_cache == NULL)
    {
        rc = -ENOMEM;
        nv_printf(NV_DBG_ERRORS, "NVRM: pte cache allocation failed\n");
        goto failed;
    }

#if defined(NV_SG_MAP_BUFFERS) && defined(NV_NEED_REMAP_CHECK)
    rm_read_registry_dword(NV_STATE_PTR(&nv_ctl_device), "NVreg", "RemapLimit",  &nv_remap_limit);

    // allow an override, but use default if no override
    if (nv_remap_limit == 0)
        nv_remap_limit = NV_REMAP_LIMIT_DEFAULT;

    nv_remap_count = 0;
#endif

#if defined(NVCPU_X86_64) || (defined(NVCPU_X86) && defined(CONFIG_X86_PAE))
    if (boot_cpu_has(X86_FEATURE_NX))
    {
        U032 __eax, __edx;
        rdmsr(MSR_EFER, __eax, __edx);
        if ((__eax & EFER_NX) != 0)
            __nv_supported_pte_mask |= _PAGE_NX;
    }
    if (_PAGE_NX != ((NvU64)1<<63))
    {
        /*
         * Make sure we don't strip software no-execute
         * bits from PAGE_KERNEL(_NOCACHE) before calling
         * change_page_attr().
         */
        __nv_supported_pte_mask |= _PAGE_NX;
    }
#endif
 
    /* create /proc/driver/nvidia */
    nvos_proc_create();

    /*
     * Give users an opportunity to disable the driver's use of
     * the change_page_attr() and set_pages_{uc,wb}() kernel
     * interfaces.
     */
    rc = rm_read_registry_dword(nv, "NVreg", "UpdateMemoryTypes", &data);
    if ((rc == 0) && ((int)data != ~0))
    {
        nv_update_memory_types = data;
    }
#if defined(NV_CHANGE_PAGE_ATTR_BUG_PRESENT)
    /*
     * Unless we explicitely detect that the change_page_attr()
     * inteface is fixed, disable usage of the interface on
     * this kernel. Notify the user of this problem using the
     * driver's /proc warnings interface (read by the installer
     * and the bug report script).
     */
    else
    {
        rc = nv_verify_cpa_interface();
        if (rc < 0)
        {
            nv_prints(NV_DBG_ERRORS, __cpgattr_warning);
            nvos_proc_add_text_file(proc_nvidia_warnings, "change_page_attr",
                    __cpgattr_warning);
            nv_update_memory_types = 0;
        }
        else if (rc != 0)
        {
            nv_prints(NV_DBG_ERRORS, __cpgattr_warning_2);
            nvos_proc_add_text_file(proc_nvidia_warnings, "change_page_attr",
                    __cpgattr_warning_2);
            nv_update_memory_types = 0;
        }
    }
#endif /* defined(NV_CHANGE_PAGE_ATTR_BUG_PRESENT) */

#if defined(NVCPU_X86_64) && defined(CONFIG_IA32_EMULATION) && \
  !defined(NV_FILE_OPERATIONS_HAS_COMPAT_IOCTL)
    rm_register_ioctl_conversions();
#endif

    nvos_proc_add_text_file(proc_nvidia_warnings, "README", __README_warning);

    for (i = 0; __nv_patches[i].short_description; i++)
    {
        nvos_proc_add_text_file(proc_nvidia_patches,
            __nv_patches[i].short_description, __nv_patches[i].description);
    }

    nvos_proc_add_text_file(proc_nvidia_patches, "README", __README_patches);

    rc = rm_read_registry_dword(nv,
            "NVreg", "UsePageAttributeTable", &data);
    if ((rc == 0) && ((int)data != ~0))
    {
        disable_pat = (data == 0);
    }

    if (!disable_pat)
    {
        __nv_enable_pat_support();
#if defined(NV_ENABLE_PAT_SUPPORT) && defined(CONFIG_HOTPLUG_CPU)
        if (nv_pat_mode == NV_PAT_MODE_BUILTIN)
        {
            if (register_hotcpu_notifier(&nv_hotcpu_nfb) != 0)
            {
                __nv_disable_pat_support();
                rc = -EIO;
                nv_printf(NV_DBG_ERRORS,
                        "NVRM: CPU hotplug notifier registration failed!\n");
                goto failed;
            }
        }
#endif
    }
    else
    {
        nv_printf(NV_DBG_ERRORS,
            "NVRM: builtin PAT support disabled, falling back to MTRRs.\n");
    }

#if (defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)) && defined(KERNEL_2_4)
    // attempt to load the i2c modules for linux kernel
    // check to see if this is possible
    if((!i2c_add_adapter) || (!i2c_del_adapter))
    {
        // attempt to load the module
        request_module("i2c-core");
        
        // recheck for valid addresses
        if((!i2c_add_adapter) || (!i2c_del_adapter))
        {
            nv_printf(NV_DBG_ERRORS, "NVRM: Your Linux 2.4 kernel was configured to include modular\n");
            nv_printf(NV_DBG_ERRORS, "NVRM: support for the Linux/i2c infrastructure, but the NVIDIA\n");
            nv_printf(NV_DBG_ERRORS, "NVRM: Linux graphics driver was unable to locate and load the\n");
            nv_printf(NV_DBG_ERRORS, "NVRM: i2c-core.o kernel module.\n");
            nv_printf(NV_DBG_ERRORS, "NVRM: \n");
            nv_printf(NV_DBG_ERRORS, "NVRM: If you wish to take advantage of the NVIDIA driver's i2c\n");
            nv_printf(NV_DBG_ERRORS, "NVRM: support feature, please make sure the Linux/i2c kernel\n");
            nv_printf(NV_DBG_ERRORS, "NVRM: modules are installed correctly.\n");
        }
    }
#endif

    return 0;

failed:
    if (nv_pte_t_cache != NULL)
        NV_KMEM_CACHE_DESTROY(nv_pte_t_cache);

#if defined(NV_PM_SUPPORT_OLD_STYLE_APM)
    for (i = 0; i < num_nv_devices; i++)
        if (apm_nv_dev[i] != NULL) pm_unregister(apm_nv_dev[i]);
#endif

    unregister_chrdev(nv_major, "nvidia");

    for (i = 0; i < num_nv_devices; i++)
    {
        if (nv_linux_devices[i].dev)
        {
            struct pci_dev *dev = nv_linux_devices[i].dev;
            release_mem_region(NV_PCI_RESOURCE_START(dev, NV_GPU_BAR_INDEX_REGS),
                               NV_PCI_RESOURCE_SIZE(dev, NV_GPU_BAR_INDEX_REGS));
            NV_PCI_DISABLE_DEVICE(dev);
        }
    }

    pci_unregister_driver(&nv_pci_driver);
    rm_shutdown_rm();

    return rc;
}

static void __exit nvidia_exit_module(void)
{
    U032 i;
    nv_linux_state_t *nvl;
    nv_state_t *nv;

    nv_printf(NV_DBG_INFO, "NVRM: nvidia_exit_module\n");

    unregister_chrdev(nv_major, "nvidia");

    for (i = 0; i < num_nv_devices; i++)
    {
        struct pci_dev *dev;
        nvl = &nv_linux_devices[i];

        if ((dev = nvl->dev) != NULL)
        {
            rm_i2c_remove_adapters(NV_STATE_PTR(nvl));

            rm_free_private_state(NV_STATE_PTR(nvl));
            release_mem_region(NV_PCI_RESOURCE_START(dev, NV_GPU_BAR_INDEX_REGS),
                               NV_PCI_RESOURCE_SIZE(dev, NV_GPU_BAR_INDEX_REGS));
            NV_PCI_DISABLE_DEVICE(dev);
        }
    }

    pci_unregister_driver(&nv_pci_driver);

    /* remove /proc/driver/nvidia */
    nvos_proc_remove();

#if defined(NV_PM_SUPPORT_OLD_STYLE_APM)
    for (i = 0; i < num_nv_devices; i++)
    {
        if (apm_nv_dev[i] != NULL) pm_unregister(apm_nv_dev[i]);
    }
#endif

    /*
     * Make sure we freed up all the mappings. The kernel should
     * do this automatically before calling close.
     */
    for (i = 0; i < num_nv_devices; i++)
    {
        nvl = &nv_linux_devices[i];
        nv = NV_STATE_PTR(nvl);

        if (nvl->alloc_queue)
        {
            nv_alloc_t *at = nvl->alloc_queue, *next;
            while (at)
            {
                NV_PRINT_AT(NV_DBG_ERRORS, at);
                /* nv_free_pages() will free this 'at' */
                next = at->next;
                nv_free_pages(nv, at->num_pages,
                              NV_ALLOC_MAPPING_AGP(at->flags),
                              NV_ALLOC_MAPPING_CONTIG(at->flags),
                              NV_ALLOC_MAPPING(at->flags),
                              (void *)at);
                at = next;
            }
        }
    }

    // Shutdown the resource manager
    rm_shutdown_rm();

#if defined(NVCPU_X86_64) && defined(CONFIG_IA32_EMULATION) && \
  !defined(NV_FILE_OPERATIONS_HAS_COMPAT_IOCTL)
    rm_unregister_ioctl_conversions();
#endif

    if (nv_pat_mode == NV_PAT_MODE_BUILTIN)
    {
        __nv_disable_pat_support();
#if defined(NV_ENABLE_PAT_SUPPORT) && defined(CONFIG_HOTPLUG_CPU)
        unregister_hotcpu_notifier(&nv_hotcpu_nfb);
#endif
    }

#if defined(NV_ENABLE_MEM_TRACKING)
#if defined(VM_CHECKER)
    if (vm_usage != 0)
    {
        nv_list_mem("VM", vm_list);
        nv_printf(NV_DBG_ERRORS,
            "NVRM: final VM memory usage: 0x%x bytes\n", vm_usage);
    }
#endif
#if defined(KM_CHECKER)
    if (km_usage != 0)
    {
        nv_list_mem("KM", km_list);
        nv_printf(NV_DBG_ERRORS,
            "NVRM: final KM memory usage: 0x%x bytes\n", km_usage);
    }
#endif
#if defined(NV_SG_MAP_BUFFERS) && defined(NV_NEED_REMAP_CHECK)
    if (nv_remap_count != 0)
    {
        nv_printf(NV_DBG_ERRORS,
            "NVRM: final SG memory usage: 0x%x bytes\n", nv_remap_count);
    }
#endif
#endif /* NV_ENABLE_MEM_TRACKING */

    NV_KMEM_CACHE_DESTROY(nv_pte_t_cache);
}

module_init(nvidia_init_module);
module_exit(nvidia_exit_module);


/*
 * The 'struct vm_operations' open() callback is called by the Linux
 * kernel when the parent VMA is split or copied, close() when the
 * current VMA is about to be deleted.
 *
 * We implement these callbacks to keep track of the number of user
 * mappings of system memory allocations. This was motivated by a
 * subtle interaction problem between the driver and the kernel with
 * respect to the bookkeeping of pages marked reserved and later
 * mapped with mmap().
 *
 * Traditionally, the Linux kernel ignored reserved pages, such that
 * when they were mapped via mmap(), the integrity of their usage
 * counts depended on the reserved bit being set for as long as user
 * mappings existed.
 *
 * Since we mark system memory pages allocated for DMA reserved and
 * typically map them with mmap(), we need to ensure they remain
 * reserved until the last mapping has been torn down. This worked
 * correctly in most cases, but in a few, the RM API called into the
 * RM to free memory before calling munmap() to unmap it.
 *
 * In the past, we allowed nv_free_pages() to remove the 'at' from
 * the parent device's allocation list in this case, but didn't
 * release the underlying pages until the last user mapping had been
 * destroyed:
 *
 * In nv_kern_vma_release(), we freed any resources associated with
 * the allocation (IOMMU/SWIOTLB mappings, etc.) and cleared the
 * underlying pages' reserved bits, but didn't free them. The kernel
 * was expected to do this.
 *
 * This worked in practise, but made dangerous assumptions about the
 * kernel's behavior and could fail in some cases. We now handle
 * this case differently (see below).
 */
static void
nv_kern_vma_open(struct vm_area_struct *vma)
{
    NV_PRINT_VMA(NV_DBG_MEMINFO, vma);

    if (NV_VMA_PRIVATE(vma))
    {
        nv_alloc_t *at = (nv_alloc_t *) NV_VMA_PRIVATE(vma);
        NV_ATOMIC_INC(at->usage_count);

        if (!NV_ALLOC_MAPPING_AGP(at->flags))
        {
            NV_PRINT_AT(NV_DBG_MEMINFO, at);
            nv_vm_list_page_count(at->page_table, at->num_pages);
        }
    }
}

/*
 * (see above for additional information)
 *
 * If the 'at' usage count drops to zero with the updated logic, the
 * VMA's file pointer is saved; nv_kern_close() uses it to find
 * these allocations when the parent file descriptor is closed. This
 * will typically happen when the process exits.
 *
 * Since this is technically a workaround to handle possible fallout
 * from misbehaving clients, we addtionally print a warning.
 */
static void
nv_kern_vma_release(struct vm_area_struct *vma)
{
    NV_PRINT_VMA(NV_DBG_MEMINFO, vma);

    if (NV_VMA_PRIVATE(vma))
    {
        nv_alloc_t *at = (nv_alloc_t *) NV_VMA_PRIVATE(vma);

        if (NV_ATOMIC_DEC_AND_TEST(at->usage_count))
        {
            static int count = 0;
            if ((at->pid == os_get_current_process()) &&
                (count++ < NV_MAX_RECURRING_WARNING_MESSAGES))
            {
                nv_printf(NV_DBG_MEMINFO,
                    "NVRM: VM: nv_kern_vma_release: late unmap, comm: %s, 0x%p\n",
                    current->comm, at);
            }
            at->file = NV_VMA_FILE(vma);
        }

        if (!NV_ALLOC_MAPPING_AGP(at->flags))
        {
            NV_PRINT_AT(NV_DBG_MEMINFO, at);
            nv_vm_list_page_count(at->page_table, at->num_pages);
        }
    }
}

#if !defined(NV_VM_INSERT_PAGE_PRESENT)
static
struct page *nv_kern_vma_nopage(
    struct vm_area_struct *vma,
    unsigned long address,
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 1))
    int *type
#else
    int write_access
#endif
)
{
    struct page *page;

    page = pfn_to_page(vma->vm_pgoff);
    get_page(page);

    return page;
}
#endif

struct vm_operations_struct nv_vm_ops = {
    .open   = nv_kern_vma_open,
    .close  = nv_kern_vma_release,  /* "close" */
#if !defined(NV_VM_INSERT_PAGE_PRESENT)
    .nopage = nv_kern_vma_nopage,
#endif
};

static nv_file_private_t *
nv_alloc_file_private(void)
{
    nv_file_private_t *nvfp;

    NV_KMALLOC(nvfp, sizeof(nv_file_private_t));
    if (!nvfp)
        return NULL;

    memset(nvfp, 0, sizeof(nv_file_private_t));

    init_waitqueue_head(&nvfp->waitqueue);
    NV_SPIN_LOCK_INIT(&nvfp->fp_lock);

    return nvfp;
}

static void
nv_free_file_private(nv_file_private_t *nvfp)
{
    nvidia_event_t *nvet;

    if (nvfp == NULL)
        return;

    for (nvet = nvfp->event_head; nvet != NULL; nvet = nvfp->event_head)
    {
        nvfp->event_head = nvfp->event_head->next;
        NV_KFREE(nvet, sizeof(nvidia_event_t));
    }
    NV_KFREE(nvfp, sizeof(nv_file_private_t));
}


/*
** nv_kern_open
**
** nv driver open entry point.  Sessions are created here.
*/
int nv_kern_open(
    struct inode *inode,
    struct file *file
)
{
    nv_state_t *nv = NULL;
    nv_linux_state_t *nvl = NULL;
    U032 devnum;
    int rc = 0, status;

    nv_printf(NV_DBG_INFO, "NVRM: nv_kern_open...\n");

    FILE_PRIVATE(file) = nv_alloc_file_private();
    if (FILE_PRIVATE(file) == NULL)
        return -ENOMEM;

    /* for control device, just jump to its open routine */
    /* after setting up the private data */
    if (NV_IS_CONTROL_DEVICE(inode))
        return nv_kern_ctl_open(inode, file);

    /* what device are we talking about? */
    devnum = NV_DEVICE_NUMBER(inode);
    if (devnum >= num_nv_devices)
    {
        nv_free_file_private(FILE_PRIVATE(file));
        FILE_PRIVATE(file) = NULL;
        return -ENODEV;
    }

    nvl = &nv_linux_devices[devnum];
    nv = NV_STATE_PTR(nvl);

    nv_printf(NV_DBG_INFO, "NVRM: nv_kern_open on device %d\n", devnum);
    down(&nvl->ldata_lock);

    nv_verify_pci_config(nv);

    NVL_FROM_FILEP(file) = nvl;

    /*
     * map the memory and allocate isr on first open
     */

    if ( ! (nv->flags & NV_FLAG_OPEN))
    {
        if (nv->device_id == 0)
        {
            nv_printf(NV_DBG_ERRORS, "NVRM: open of nonexistent device %d\n",
                devnum);
            rc = -ENXIO;
            goto failed;
        }

        status = request_irq(nv->interrupt_line, nv_kern_isr, IRQF_SHARED,
                    "nvidia", (void *)nvl);
        if (status != 0)
        {
            if ( nv->interrupt_line && (status == -EBUSY) )
            {
                nv_printf(NV_DBG_ERRORS,
                    "NVRM: Tried to get irq %d, but another driver",
                    (unsigned int) nv->interrupt_line);
                nv_printf(NV_DBG_ERRORS, "NVRM: has it and is not sharing it.\n");
                nv_printf(NV_DBG_ERRORS, "NVRM: you may want to verify that an audio driver");
                nv_printf(NV_DBG_ERRORS, " isn't using the irq\n");
            }
            nv_printf(NV_DBG_ERRORS, "NVRM: isr request failed 0x%x\n", status);
            rc = -EIO;
            goto failed;
        }

        if ( ! rm_init_adapter(nv))
        {
            free_irq(nv->interrupt_line, (void *) nvl);
            nv_printf(NV_DBG_ERRORS, "NVRM: rm_init_adapter(%d) failed\n", devnum);
            rc = -EIO;
            goto failed;
        }

        nvl->tasklet.func = nv_kern_isr_bh;
        nvl->tasklet.data = (unsigned long) nv;
        tasklet_enable(&nvl->tasklet);

        nv->flags |= NV_FLAG_OPEN;
    }

    NV_ATOMIC_INC(nvl->usage_count);

 failed:
    up(&nvl->ldata_lock);

    if ((rc) && FILE_PRIVATE(file))
    {
        nv_free_file_private(FILE_PRIVATE(file));
        FILE_PRIVATE(file) = NULL;
    }

    return rc;
}


/*
** nv_kern_close
**
** Master driver close entry point.
*/

int nv_kern_close(
    struct inode *inode,
    struct file *file
)
{
    nv_linux_state_t *nvl = NVL_FROM_FILEP(file);
    nv_state_t *nv = NV_STATE_PTR(nvl);

    nv_verify_pci_config(nv);

    /* for control device, just jump to its open routine */
    /* after setting up the private data */
    if (NV_IS_CONTROL_DEVICE(inode))
        return nv_kern_ctl_close(inode, file);

    nv_printf(NV_DBG_INFO, "NVRM: nv_kern_close on device %d\n",
        NV_DEVICE_NUMBER(inode));

    rm_free_unused_clients(nv, (void *)file);

    down(&nvl->at_lock);
    if (nvl->alloc_queue != NULL)
    {
        nv_alloc_t *at = nvl->alloc_queue, *next;
        while (at != NULL)
        {
            /* nv_free_pages() will free this 'at' */
            next = at->next;
            if ((NV_ATOMIC_READ(at->usage_count) == 0) && (at->file == file))
            {
                NV_ATOMIC_INC(at->usage_count);
                up(&nvl->at_lock);
                if (at->pid == os_get_current_process())
                    NV_PRINT_AT(NV_DBG_MEMINFO, at);
                nv_free_pages(nv, at->num_pages,
                              NV_ALLOC_MAPPING_AGP(at->flags),
                              NV_ALLOC_MAPPING_CONTIG(at->flags),
                              NV_ALLOC_MAPPING(at->flags),
                              (void *)at);
                down(&nvl->at_lock);
                next = nvl->alloc_queue; /* start over */
            }
            at = next;
        }
    }
    up(&nvl->at_lock);

    down(&nvl->ldata_lock);
    if (NV_ATOMIC_DEC_AND_TEST(nvl->usage_count))
    {
        /*
         * The usage count for this device has dropped to zero, it can be shut
         * down safely; disable its interrupts.
         */
        rm_disable_adapter(nv);

        /*
         * Disable this device's tasklet to make sure that no bottom half will
         * run with undefined device state.
         */
        tasklet_disable(&nvl->tasklet);

        /*
         * Free the IRQ, which may block until all pending interrupt processing
         * has completed.
         */
        free_irq(nv->interrupt_line, (void *) nvl);

        rm_shutdown_adapter(nv);

        /*
         * Make sure we free all memory tied to this device. Memory freed here
         * has been leaked by the core RM, warn accordingly.
         */
        if (nvl->alloc_queue)
        {
            nv_alloc_t *at = nvl->alloc_queue, *next;
            while (at)
            {
                NV_PRINT_AT(NV_DBG_ERRORS, at);
                /* nv_free_pages() will free this 'at' */
                next = at->next;
                nv_free_pages(nv, at->num_pages,
                              NV_ALLOC_MAPPING_AGP(at->flags),
                              NV_ALLOC_MAPPING_CONTIG(at->flags),
                              NV_ALLOC_MAPPING(at->flags),
                              (void *)at);
                at = next;
            }
        }

        /* leave INIT flag alone so we don't reinit every time */
        nv->flags &= ~NV_FLAG_OPEN;
    }
    up(&nvl->ldata_lock);

    if (FILE_PRIVATE(file))
    {
        nv_free_file_private(FILE_PRIVATE(file));
        FILE_PRIVATE(file) = NULL;
    }

    return 0;
}

int nv_encode_caching(
    pgprot_t *prot,
    unsigned int cache_type,
    unsigned int memory_type
)
{
    pgprot_t tmp = __pgprot(0);

    if (prot == NULL) prot = &tmp;

    // allow setting or refusal of specific caching types
    switch (cache_type)
    {
        case NV_MEMORY_UNCACHED_WEAK:
            *prot = pgprot_noncached_weak(*prot);
            break;
        case NV_MEMORY_UNCACHED:
            *prot = pgprot_noncached(*prot);
            break;
#if defined(NVCPU_X86) || defined(NVCPU_X86_64)
        case NV_MEMORY_WRITECOMBINED:
#if defined(NV_ENABLE_PAT_SUPPORT)
            if ((nv_pat_mode != NV_PAT_MODE_DISABLED) &&
                    (memory_type != NV_MEMORY_TYPE_REGISTERS))
            {
                pgprot_val(*prot) &= ~(_PAGE_PSE | _PAGE_PCD | _PAGE_PWT);
                *prot = __pgprot(pgprot_val(*prot) | _PAGE_PWT);
                break;
            }
#endif
            /*
             * If PAT support is unavailable and the memory space isn't
             * NV_MEMORY_TYPE_AGP, we need to return an error code to
             * the caller, but do not print a warning message.
             *
             * In the case of AGP memory, we will have attempted to add
             * a WC MTRR for the AGP aperture and aborted the AGP
             * initialization if this failed, so we can safely return
             * success here.
             *
             * For frame buffer memory, callers are expected to use the
             * UC- memory type if we report WC as unsupported, which
             * translates to the effective memory type WC if a WC MTRR
             * exists or else UC.
             */
            if (memory_type == NV_MEMORY_TYPE_AGP)
                break;
            return 1;
#endif
        case NV_MEMORY_CACHED:
            /*
             * RAM is cached on Linux by default, we can assume there's
             * nothing to be done here. This is not the case for the
             * other memory spaces: as commented on above, we will have
             * added a WC MTRR for the AGP aperture (or else aborted
             * AGP initialization), and we will have made an attempt to
             * add a WC MTRR for the frame buffer.
             *
             * If a WC MTRR is present, we can't satisfy the WB mapping
             * attempt here, since the achievable effective memory
             * types in that case are WC and UC, if not it's typically
             * UC (MTRRdefType is UC); we could only satisfy WB mapping
             * requests with a WB MTRR.
             */
            if (memory_type == NV_MEMORY_TYPE_SYSTEM)
                break;
        default:
            nv_printf(NV_DBG_ERRORS,
                "NVRM: VM: memory type %d not supported for memory space %d!\n",
                cache_type, memory_type);
            return 1;
    }
    return 0;
}

int nv_kern_mmap(
    struct file  *file,
    struct vm_area_struct *vma
)
{
    unsigned int pages;
    nv_alloc_t *at;
    nv_linux_state_t *nvl = NVL_FROM_FILEP(file);
    nv_state_t *nv = NV_STATE_PTR(nvl);

    if (nv->flags & NV_FLAG_CONTROL)
        return -ENODEV;

    NV_PRINT_VMA(NV_DBG_MEMINFO, vma);

    nv_verify_pci_config(nv);

    // be a bit paranoid for now
    if ( NV_MASK_OFFSET(vma->vm_start) ||
         NV_MASK_OFFSET(vma->vm_end))
    {
        nv_printf(NV_DBG_ERRORS, 
            "NVRM: bad mmap range: %lx - %lx\n",
            vma->vm_start, vma->vm_end);
        return -EINVAL;
    }

    pages = NV_VMA_SIZE(vma) >> PAGE_SHIFT;
    NV_VMA_PRIVATE(vma) = NULL;

    vma->vm_ops = &nv_vm_ops;

#if defined(NVCPU_X86)
    if (vma->vm_pgoff & ~0xfffff)
    {
        nv_printf(NV_DBG_ERRORS, 
            "NVRM: bad mmap offset: %lx\n", vma->vm_pgoff);
        return -EINVAL;
    }
#endif

    /* NV reg space */
    if (IS_REG_OFFSET(nv, NV_VMA_OFFSET(vma), NV_VMA_SIZE(vma)))
    {
        if (nv_encode_caching(&vma->vm_page_prot,
                              NV_MEMORY_UNCACHED,
                              NV_MEMORY_TYPE_REGISTERS))
        {
            return -ENXIO;
        }

        if (NV_REMAP_PAGE_RANGE(vma->vm_start,
                             NV_VMA_OFFSET(vma),
                             NV_VMA_SIZE(vma),
                             vma->vm_page_prot))
            return -EAGAIN;

        /* mark it as IO so that we don't dump it on core dump */
        vma->vm_flags |= VM_IO;
    }

    /* NV fb space */
    else if (IS_FB_OFFSET(nv, NV_VMA_OFFSET(vma), NV_VMA_SIZE(vma)))
    {
        if (nv_encode_caching(&vma->vm_page_prot,
                              NV_MEMORY_WRITECOMBINED,
                              NV_MEMORY_TYPE_FRAMEBUFFER))
        {
            if (nv_encode_caching(&vma->vm_page_prot,
                                  NV_MEMORY_UNCACHED_WEAK,
                                  NV_MEMORY_TYPE_FRAMEBUFFER))
            {
                return -ENXIO;
            }
        }

        if (NV_REMAP_PAGE_RANGE(vma->vm_start,
                             NV_VMA_OFFSET(vma),
                             NV_VMA_SIZE(vma),
                             vma->vm_page_prot))
            return -EAGAIN;

        // mark it as IO so that we don't dump it on core dump
        vma->vm_flags |= VM_IO;
    }

    /* NV bc space */
    else if (IS_BC_OFFSET(nv, NV_VMA_OFFSET(vma), NV_VMA_SIZE(vma)))
    {
        if (nv_encode_caching(&vma->vm_page_prot,
                              NV_MEMORY_WRITECOMBINED,
                              NV_MEMORY_TYPE_FRAMEBUFFER))
            return -ENXIO;

        if (NV_REMAP_PAGE_RANGE(vma->vm_start,
                             NV_VMA_OFFSET(vma),
                             NV_VMA_SIZE(vma),
                             vma->vm_page_prot))
            return -EAGAIN;

        // mark it as IO so that we don't dump it on core dump
        vma->vm_flags |= VM_IO;
    }

    /* AGP allocator */
    else if (IS_AGP_OFFSET(nv, NV_VMA_OFFSET(vma), NV_VMA_SIZE(vma)))
    {
        unsigned int i;

        down(&nvl->at_lock);
        at = nvl_find_alloc(nvl, NV_VMA_OFFSET(vma), NV_ALLOC_TYPE_AGP);

        if (at == NULL)
        {
            static int count = 0;
            if (count++ < NV_MAX_RECURRING_WARNING_MESSAGES)
            {
                nv_printf(NV_DBG_ERRORS,
                    "NVRM: nv_kern_mmap: invalid offset: 0x%08x @ 0x%016llx (AGP)\n",
                    NV_VMA_SIZE(vma), NV_VMA_OFFSET(vma));
            }
            up(&nvl->at_lock);
            return -EINVAL;
        }

        if (nv_encode_caching(&vma->vm_page_prot,
                              NV_MEMORY_WRITECOMBINED,
                              NV_MEMORY_TYPE_AGP))
        {
            up(&nvl->at_lock);
            return -ENXIO;
        }

        NV_VMA_PRIVATE(vma) = at;
        NV_ATOMIC_INC(at->usage_count);
        up(&nvl->at_lock);

        if (NV_REMAP_PAGE_RANGE(vma->vm_start,
                                NV_VMA_OFFSET(vma),
                                NV_VMA_SIZE(vma),
                                vma->vm_page_prot))
        {
            NV_ATOMIC_DEC(at->usage_count);
            return -EAGAIN;
        }

        i = (NV_VMA_OFFSET(vma) - (NvUPtr)at->key_mapping) >> PAGE_SHIFT;

        NV_PRINT_AT(NV_DBG_MEMINFO, at);
        nv_vm_list_page_count(&at->page_table[i], pages);

        // mark it as IO so that we don't dump it on core dump
        vma->vm_flags |= VM_IO;
    }

    /* Magic allocator */
    else // if (NV_VMA_OFFSET(vma) == NV_MMAP_ALLOCATION_OFFSET)
    {
        unsigned long start = 0;
        unsigned int i, j;

        down(&nvl->at_lock);
        at = nvl_find_alloc(nvl, NV_VMA_OFFSET(vma), NV_ALLOC_TYPE_PCI);

        if (at == NULL)
        {
            static int count = 0;
            up(&nvl->at_lock);
            if (count++ < NV_MAX_RECURRING_WARNING_MESSAGES)
            {
                nv_printf(NV_DBG_ERRORS,
                    "NVRM: nv_kern_mmap: invalid offset: 0x%08x @ 0x%016llx (PCI)\n",
                    NV_VMA_SIZE(vma), NV_VMA_OFFSET(vma));
            }
            return -EINVAL;
        }

        for (i = 0; i < at->num_pages; i++)
        {
            if ((NV_VMA_OFFSET(vma) == at->page_table[i]->phys_addr)
                  || (NV_VMA_OFFSET(vma) == at->page_table[i]->dma_addr))
                break;
        }

        if (i == at->num_pages) /* sanity check */
        {
            up(&nvl->at_lock);
            return -EINVAL;
        }

        if ((i + pages) > at->num_pages)
        {
            nv_printf(NV_DBG_ERRORS,
                "NVRM: requested mapping exceeds allocation's boundary!\n");
            up(&nvl->at_lock);
            return -EINVAL;
        }

        if (nv_encode_caching(&vma->vm_page_prot,
                              NV_ALLOC_MAPPING(at->flags),
                              NV_MEMORY_TYPE_SYSTEM))
        {
            up(&nvl->at_lock);
            return -ENXIO;
        }

        NV_VMA_PRIVATE(vma) = at;
        NV_ATOMIC_INC(at->usage_count);
        up(&nvl->at_lock);

        nv_printf(NV_DBG_INFO,
            "NVRM: remapping %d system pages, index %d, for 'at' 0x%p\n", pages, i, at);

        start = vma->vm_start;
        for (j = i; j < (i + pages); j++)
        {
            nv_verify_page_mappings(at->page_table[j], NV_ALLOC_MAPPING(at->flags));
#if defined(NV_VM_INSERT_PAGE_PRESENT)
            if (NV_VM_INSERT_PAGE(vma, start,
                    NV_GET_PAGE_STRUCT(at->page_table[j]->phys_addr)))
#else
            if (NV_REMAP_PAGE_RANGE(start, at->page_table[j]->phys_addr,
                    PAGE_SIZE, vma->vm_page_prot))
#endif
            {
                NV_ATOMIC_DEC(at->usage_count);
                return -EAGAIN;
            }
            start += PAGE_SIZE;
        }

        NV_PRINT_AT(NV_DBG_MEMINFO, at);
        nv_vm_list_page_count(&at->page_table[i], pages);

        /* prevent the swapper from swapping it out */
        /* mark the memory i/o so the buffers aren't dumped on core dumps */
        vma->vm_flags |= (VM_IO | VM_LOCKED | VM_RESERVED);
    }

    NV_VMA_FILE(vma) = file;

    return 0;
}

unsigned int nv_kern_poll(
    struct file *file,
    poll_table *wait
)
{
    unsigned int mask = 0;
    nv_file_private_t *nvfp;
    nv_linux_state_t *nvl;
    unsigned long eflags;

    nvl = NVL_FROM_FILEP(file);

    if (NV_IS_CONTROL_DEVICE(file->f_dentry->d_inode))
        return nv_kern_ctl_poll(file, wait);

    nvfp = NV_GET_NVFP(file);

    if ( !(file->f_flags & O_NONBLOCK))
    {
        // add us to the list
        poll_wait(file, &nvfp->waitqueue, wait);
    }

    NV_SPIN_LOCK_IRQSAVE(&nvfp->fp_lock, eflags);

    // wake the user on any event
    if (nvfp->event_head != NULL)
    {
        nv_printf(NV_DBG_EVENTINFO, "NVRM: Hey, an event occured!\n");
        // trigger the client, when they grab the event, 
        // we'll decrement the event count
        mask |= (POLLPRI|POLLIN);
    }

    NV_SPIN_UNLOCK_IRQRESTORE(&nvfp->fp_lock, eflags);

    return mask;
}

#define NV_CTL_DEVICE_ONLY(nv)                 \
{                                              \
    if (((nv)->flags & NV_FLAG_CONTROL) == 0)  \
    {                                          \
        status = -EINVAL;                      \
        goto done;                             \
    }                                          \
}

int nv_kern_ioctl(
    struct inode *inode,
    struct file *file,
    unsigned int cmd,
    unsigned long i_arg)
{
    RM_STATUS rmStatus;
    int status = 0;
    nv_linux_state_t *nvl;
    nv_state_t *nv;
    void *arg = (void *) i_arg;
    void *arg_copy;
    int arg_size;

    nvl = NVL_FROM_FILEP(file);
    nv = NV_STATE_PTR(nvl);

    nv_printf(NV_DBG_INFO, "NVRM: ioctl(0x%x, 0x%x, 0x%x)\n",
        _IOC_NR(cmd), (unsigned int) i_arg, _IOC_SIZE(cmd));

    nv_verify_pci_config(nv);

    arg_size = _IOC_SIZE(cmd);
    NV_KMALLOC(arg_copy, arg_size);
    if (arg_copy == NULL)
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: failed to allocate ioctl memory\n");
        return -ENOMEM;
    }

    if (copy_from_user(arg_copy, arg, arg_size))
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: failed to copy in ioctl data\n");
        NV_KFREE(arg_copy, arg_size);
        return -ENOMEM;
    }

    switch (_IOC_NR(cmd))
    {
        /* pass out info about the card */
        case NV_ESC_CARD_INFO:
        {
            nv_ioctl_card_info_t *ci;
            nv_linux_state_t *tnvl;
            nv_ioctl_rm_api_old_version_t *rm_api;
            U032 i;

            NV_CTL_DEVICE_ONLY(nv);

            if (arg_size < (sizeof(*ci) * num_nv_devices))
            {
                status = -EINVAL;
                goto done;
            }

            /* the first element of card info passed from the client will have
             * the rm_api_version_magic value to show that the client is new
             * enough to support versioning. If the client is too old to 
             * support versioning, our mmap interfaces are probably different
             * enough to cause serious damage.
             * just copy in the one dword to check.
             */
            rm_api = arg_copy;
            switch (rm_api->magic)
            {
                case NV_RM_API_OLD_VERSION_MAGIC_REQ:
                case NV_RM_API_OLD_VERSION_MAGIC_LAX_REQ:
                case NV_RM_API_OLD_VERSION_MAGIC_OVERRIDE_REQ:
                    /* the client is using the old major-minor-patch
                     * API version check; reject it.
                     */
                    nv_printf(NV_DBG_ERRORS,
                              "NVRM: API mismatch: the client has the version %d.%d-%d, but\n"
                              "NVRM: this kernel module has the version %s.  Please\n"
                              "NVRM: make sure that this kernel module and all NVIDIA driver\n"
                              "NVRM: components have the same version.\n",
                              rm_api->major, rm_api->minor, rm_api->patch,
                              NV_VERSION_STRING);
                    status = -EINVAL;
                    goto done;

                case NV_RM_API_OLD_VERSION_MAGIC_IGNORE:
                    /* the client is telling us to ignore the old
                     * version scheme; it will do a version check via
                     * NV_ESC_CHECK_VERSION_STR
                     */
                    break;
                default:
                    nv_printf(NV_DBG_ERRORS, 
                        "NVRM: client does not support versioning!!\n");
                    status = -EINVAL;
                    goto done;
            }

            ci = arg_copy;
            memset(ci, 0, arg_size);
            for (i = 0; i < num_nv_devices; i++)
            {
                nv_state_t *tnv;
                tnvl = &nv_linux_devices[i];
                tnv = NV_STATE_PTR(tnvl);
                if (tnv->device_id)
                {
                    ci->flags = NV_IOCTL_CARD_INFO_FLAG_PRESENT;
                    ci->bus = tnv->bus;
                    ci->slot = tnv->slot;
                    ci->vendor_id = tnv->vendor_id;
                    ci->device_id = tnv->device_id;
                    ci->interrupt_line = tnv->interrupt_line;
                    ci->reg_address = tnv->regs->address;
                    ci->reg_size = tnv->regs->size;
                    ci->fb_address = tnv->fb->address;
                    ci->fb_size = tnv->fb->size;
                    ci++;
                }
            }
            break;
        }

        /* set a card to be posted */
        case NV_ESC_POST_VBIOS:
        {
            NV_CTL_DEVICE_ONLY(nv);

            status = nvos_post_vbios(arg_copy, arg_size);
            break;
        }

        case NV_ESC_CHECK_VERSION_STR:
        {
            NV_CTL_DEVICE_ONLY(nv);

            rmStatus = rm_perform_version_check(arg_copy, arg_size);
            status = ((rmStatus == RM_OK) ? 0 : -EINVAL);
            break;
        }

        default:
            rmStatus = rm_ioctl(nv, file, _IOC_NR(cmd), arg_copy, arg_size);
            status = ((rmStatus == RM_OK) ? 0 : -EINVAL);
            break;
    }

 done:
    if (copy_to_user(arg, arg_copy, arg_size))
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: failed to copyout ioctl data\n");
        status = -EFAULT;
    }
    NV_KFREE(arg_copy, arg_size);
    return status;
}

long nv_kern_unlocked_ioctl(
    struct file *file,
    unsigned int cmd,
    unsigned long i_arg
)
{
    return nv_kern_ioctl(file->f_dentry->d_inode, file, cmd, i_arg);
}

long nv_kern_compat_ioctl(
    struct file *file,
    unsigned int cmd,
    unsigned long i_arg
)
{
    return nv_kern_ioctl(file->f_dentry->d_inode, file, cmd, i_arg);
}

/*
 * driver receives an interrupt
 *    if someone waiting, then hand it off.
 */
irqreturn_t nv_kern_isr(
    int   irq,
    void *arg
#if !defined(NV_IRQ_HANDLER_T_PRESENT) || (NV_IRQ_HANDLER_T_ARGUMENT_COUNT == 3)
    ,struct pt_regs *regs
#endif
)
{
    nv_linux_state_t *nvl = (void *) arg;
    nv_state_t *nv = NV_STATE_PTR(nvl);
    U032 need_to_run_bottom_half = 0;
    BOOL ret;

    nv_verify_pci_config(nv);

    ret = rm_isr(nv, &need_to_run_bottom_half);
    if (need_to_run_bottom_half)
    {
        tasklet_schedule(&nvl->tasklet);
    }

    return IRQ_RETVAL(ret);
}

void nv_kern_isr_bh(
    unsigned long data
)
{
    nv_state_t *nv = (nv_state_t *) data;
    /*
     * XXX: This level of indirection is necessary to work around
     * problems with Linux kernels using a non-standard calling
     * convention, i.e. Arjan van de Ven's/RedHat's 2.6.0 kernels.
     */
    nv_verify_pci_config(nv);
    rm_isr_bh(nv);
}

void nv_kern_rc_timer(
    unsigned long data
)
{
    nv_linux_state_t *nvl = (nv_linux_state_t *) data;
    nv_state_t *nv = NV_STATE_PTR(nvl);

    // nv_printf(NV_DBG_INFO, "NVRM: rc timer\n");

    nv_verify_pci_config(nv);
    rm_run_rc_callback(nv);
    mod_timer(&nvl->rc_timer, jiffies + HZ);  /* set another timeout in 1 second */
}

#if defined(NV_PM_SUPPORT_OLD_STYLE_APM)
/* kernel calls us with a power management event */
static int
nv_kern_apm_event(
    struct pm_dev *dev,
    pm_request_t rqst,
    void *data
)
{
    nv_state_t *nv;
    nv_linux_state_t *lnv;
    U032 devnum;
    int status = RM_OK;

    nv_printf(NV_DBG_INFO, "NVRM: nv_kern_apm_event: %d (0x%p)\n", rqst, data);

    for (devnum = 0; devnum < num_nv_devices; devnum++)
    {
        if (apm_nv_dev[devnum] == dev)
        {
            break;
        }
    }

    if (devnum == num_nv_devices)
    {
        nv_printf(NV_DBG_WARNINGS, "NVRM: APM: invalid device!\n");
        return 1;
    }

    lnv = &nv_linux_devices[devnum];
    nv = NV_STATE_PTR(lnv);

    nv_verify_pci_config(nv);

    switch (rqst)
    {
        case PM_RESUME:
            nv_printf(NV_DBG_INFO, "NVRM: APM: received resume event\n");
            __nv_enable_pat_support();
            status = rm_power_management(nv, 0, NV_PM_APM_RESUME);
            break;

        case PM_SUSPEND:
            nv_printf(NV_DBG_INFO, "NVRM: APM: received suspend event\n");
            status = rm_power_management(nv, 0, NV_PM_APM_SUSPEND);
            __nv_disable_pat_support();
            break;

        // 2.4 kernels sent a PM_SAVE_STATE request when powering down via
        // ACPI. just ignore it and return success so the power down works
        case PM_SAVE_STATE:
            status = RM_OK;
            break;

        default:
            nv_printf(NV_DBG_WARNINGS, "NVRM: APM: unsupported event: %d\n", rqst);
            return 1;
    }

    if (status != RM_OK)
        nv_printf(NV_DBG_ERRORS, "NVRM: APM: failed event: %d\n", rqst);

    return status;
}
#endif /* defined(NV_PM_SUPPORT_OLD_STYLE_APM) */

/*
** nv_kern_ctl_open
**
** nv control driver open entry point.  Sessions are created here.
*/
int nv_kern_ctl_open(
    struct inode *inode,
    struct file *file
)
{
    nv_state_t *nv;
    nv_linux_state_t *nvl;
    int rc = 0;

    nvl = &nv_ctl_device;
    nv = (nv_state_t *) nvl;

    nv_printf(NV_DBG_INFO, "NVRM: nv_kern_ctl_open\n");

    down(&nvl->ldata_lock);

    /* save the nv away in file->private_data */
    NVL_FROM_FILEP(file) = nvl;

    if (NV_ATOMIC_READ(nvl->usage_count) == 0)
    {
        init_waitqueue_head(&nv_ctl_waitqueue);
    }

    nv->flags |= NV_FLAG_OPEN + NV_FLAG_CONTROL;

    /* turn off the hotkey occurred bit */
    nv->flags &= ~NV_FLAG_HOTKEY_OCCURRED;

    NV_ATOMIC_INC(nvl->usage_count);
    up(&nvl->ldata_lock);

    return rc;
}


/*
** nv_kern_ctl_close
*/
int nv_kern_ctl_close(
    struct inode *inode,
    struct file *file
)
{
    nv_linux_state_t *nvl =  NVL_FROM_FILEP(file);
    nv_state_t *nv = NV_STATE_PTR(nvl);

    nv_printf(NV_DBG_INFO, "NVRM: nv_kern_ctl_close\n");

    down(&nvl->ldata_lock);
    if (NV_ATOMIC_DEC_AND_TEST(nvl->usage_count))
    {
        nv->flags &= ~(NV_FLAG_OPEN | NV_FLAG_HOTKEY_OCCURRED);
    }
    up(&nvl->ldata_lock);

    rm_free_unused_clients(nv, (void *)file);

    if (FILE_PRIVATE(file))
    {
        nv_free_file_private(FILE_PRIVATE(file));
        FILE_PRIVATE(file) = NULL;
    }

    return 0;
}


/*
 * nv_kern_ctl_poll() - add the process to the wait queue
 */

unsigned int nv_kern_ctl_poll(
    struct file *file,
    poll_table *wait
)
{
    nv_linux_state_t *nvl;
    nv_state_t *nv;
    unsigned int ret = 0;

    nvl = NVL_FROM_FILEP(file);
    nv = NV_STATE_PTR(nvl);

    if ( !(file->f_flags & O_NONBLOCK) )
    {
        poll_wait(file, &nv_ctl_waitqueue, wait);
    }

    nv_lock_rm(nv);
    if (nv->flags & NV_FLAG_HOTKEY_OCCURRED)
    {
        nv_printf(NV_DBG_EVENTINFO, "NVRM: a hotkey event has occurred\n");
        nv->flags &= ~NV_FLAG_HOTKEY_OCCURRED;
        ret = POLLIN | POLLRDNORM;
    }
    nv_unlock_rm(nv);

    return ret;
}




/*
 * nv_set_hotkey_occurred_flag() - set the hotkey flag and wake up anybody
 * waiting on the wait queue
 */

void NV_API_CALL nv_set_hotkey_occurred_flag(void)
{
    nv_state_t *nv = NV_STATE_PTR(&nv_ctl_device);

    nv_printf(NV_DBG_EVENTINFO, "NVRM: setting the hotkey occurred flag!\n");

    nv_lock_rm(nv);
    nv_ctl_device.nv_state.flags |= NV_FLAG_HOTKEY_OCCURRED;
    nv_unlock_rm(nv);

    wake_up_interruptible(&nv_ctl_waitqueue);
}

void   NV_API_CALL  nv_set_dma_address_size(
    nv_state_t  *nv,
    U032        phys_addr_bits
)
{
    nv_linux_state_t    *nvl = NV_GET_NVL_FROM_NV_STATE(nv);

#ifdef NV_SWIOTLB
    if (swiotlb && !nv_swiotlb && phys_addr_bits<=32)
    {
        nv_prints(NV_DBG_ERRORS, __swiotlb_warning);
        nvos_proc_add_text_file(proc_nvidia_warnings, "swiotlb",
                __swiotlb_warning);
        nv_swiotlb = 1;
    }
#endif

    nvl->dev->dma_mask = (((u64)1) << phys_addr_bits) - 1;
}

static int
nv_kern_read_cardinfo(char *page, char **start, off_t off,
        int count, int *eof, void *data)
{
    struct pci_dev *dev;
    char *type, *fmt, tmpstr[NV_DEVICE_NAME_LENGTH];
    int len = 0, status;
    U032 vbios_rev1, vbios_rev2, vbios_rev3, vbios_rev4, vbios_rev5;

    nv_state_t *nv;
    nv = (nv_state_t *) data;
    *eof = 1;

    dev = nv_get_pci_device(nv);
    if (!dev)
        return 0;
    
    if (rm_get_device_name(nv, dev->device, NV_DEVICE_NAME_LENGTH,
                           tmpstr) != RM_OK) {
        strcpy (tmpstr, "Unknown");
    }
    
    len += sprintf(page+len, "Model: \t\t %s\n", tmpstr);
    len += sprintf(page+len, "IRQ:   \t\t %d\n", nv->interrupt_line);

    status = rm_get_vbios_version(nv, &vbios_rev1, &vbios_rev2,
                                  &vbios_rev3, &vbios_rev4, &vbios_rev5);

    if (status < 0) {
        /* before rm_init_adapter */
        len += sprintf(page+len, "Video BIOS: \t ??.??.??.??.??\n");
    } else {
        fmt = "Video BIOS: \t %02x.%02x.%02x.%02x.%02x\n";
        len += sprintf(page+len, fmt, vbios_rev1, vbios_rev2, vbios_rev3,
                                                  vbios_rev4, vbios_rev5);
    }

    if (nvos_find_agp_capability(dev)) type = "AGP";
    else if (nvos_find_pci_express_capability(dev)) type = "PCI-E";
    else type = "PCI";
    len += sprintf(page+len, "Card Type: \t %s\n", type);

    // Report the number of bits set in dev->dma_mask
    len += sprintf(page+len, "DMA Size: \t %d bits\n",
     nv_count_bits(dev->dma_mask));
    len += sprintf(page+len, "DMA Mask: \t 0x%llx\n", dev->dma_mask);

    NV_PCI_DEV_PUT(dev);
    return len;
}

static int
nv_kern_read_version(char *page, char **start, off_t off,
        int count, int *eof, void *data)
{
    int len = 0;
    *eof = 1;
    
    len += sprintf(page+len, "NVRM version: %s\n", pNVRM_ID);
    len += sprintf(page+len, "GCC version:  %s\n", NV_COMPILER);
    
    return len;
}

static int
nv_kern_read_agpinfo(char *page, char **start, off_t off,
        int count, int *eof, void *data)
{
    struct pci_dev *dev;
    char   *fw, *sba;
    u8     cap_ptr;
    u32    status, command, agp_rate;
    int    len = 0;
    
    nv_state_t *nv;
    nv = (nv_state_t *) data;
    *eof = 1;

    if (nv) {
        dev = nv_get_pci_device(nv);
        if (!dev)
            return 0;
    } else {
        dev = nvos_get_agp_device_by_class(PCI_CLASS_BRIDGE_HOST);
        if (!dev)
            return 0;

        len += sprintf(page+len, "Host Bridge: \t ");

#if defined(CONFIG_PCI_NAMES)
        len += sprintf(page+len, "%s\n", NV_PCI_DEVICE_NAME(dev));
#else
        len += sprintf(page+len, "PCI device %04x:%04x\n",
                dev->vendor, dev->device);
#endif
    }

    /* what can this AGP device do? */
    cap_ptr = nvos_find_agp_capability(dev);

    pci_read_config_dword(dev, cap_ptr + 4, &status);
    pci_read_config_dword(dev, cap_ptr + 8, &command);

    fw  = (status & 0x00000010) ? "Supported" : "Not Supported";
    sba = (status & 0x00000200) ? "Supported" : "Not Supported";

    len += sprintf(page+len, "Fast Writes: \t %s\n", fw);
    len += sprintf(page+len, "SBA: \t\t %s\n", sba);

    agp_rate = status & 0x7;
    if (status & 0x8) // agp 3.0
        agp_rate <<= 2;

    len += sprintf(page+len, "AGP Rates: \t %s%s%s%s\n",
            (agp_rate & 0x00000008) ? "8x " : "",
            (agp_rate & 0x00000004) ? "4x " : "",
            (agp_rate & 0x00000002) ? "2x " : "",
            (agp_rate & 0x00000001) ? "1x " : "");

    len += sprintf(page+len, "Registers: \t 0x%08x:0x%08x\n", status, command);

    NV_PCI_DEV_PUT(dev);
    return len;
}

static int
nv_kern_read_status(char *page, char **start, off_t off,
        int count, int *eof, void *data)
{
    struct pci_dev *dev;
    char   *fw, *sba, *drv;
    int    len = 0;
    u8     cap_ptr;
    u32    scratch;
    u32    status, command, agp_rate;

    nv_state_t *nv;
    nv = (nv_state_t *) data;
    *eof = 1;

    dev = nvos_get_agp_device_by_class(PCI_CLASS_BRIDGE_HOST);
    if (!dev)
        return 0;
    cap_ptr = nvos_find_agp_capability(dev);

    pci_read_config_dword(dev, cap_ptr + 4, &status);
    pci_read_config_dword(dev, cap_ptr + 8, &command);
    NV_PCI_DEV_PUT(dev);

    dev = nvos_get_agp_device_by_class(PCI_CLASS_DISPLAY_VGA);
    if (!dev)
        return 0;
    cap_ptr = nvos_find_agp_capability(dev);

    pci_read_config_dword(dev, cap_ptr + 4, &scratch);
    status &= scratch;
    pci_read_config_dword(dev, cap_ptr + 8, &scratch);
    command &= scratch;

    if (NV_AGP_ENABLED(nv) && (command & 0x100)) {
        len += sprintf(page+len, "Status: \t Enabled\n");

        drv = NV_OSAGP_ENABLED(nv) ? "AGPGART" : "NVIDIA";
        len += sprintf(page+len, "Driver: \t %s\n", drv);

        // mask off agp rate. 
        // If this is agp 3.0, we need to shift the value
        agp_rate = command & 0x7;
        if (status & 0x8) // agp 3.0
            agp_rate <<= 2;

        len += sprintf(page+len, "AGP Rate: \t %dx\n", agp_rate);

        fw = (command & 0x00000010) ? "Enabled" : "Disabled";
        len += sprintf(page+len, "Fast Writes: \t %s\n", fw);

        sba = (command & 0x00000200) ? "Enabled" : "Disabled";
        len += sprintf(page+len, "SBA: \t\t %s\n", sba);
    } else {
        int agp_config = 0;

        len += sprintf(page+len, "Status: \t Disabled\n\n");

        /*
         * If we find AGP is disabled, but the RM registry indicates it
         * was requested, direct the user to the kernel log (we, or even
         * the kernel may have printed a warning/an error message).
         *
         * Note that the "XNvAGP" registry key reflects the user request
         * and overrides the RM "NvAGP" key, if present.
         */
        rm_read_registry_dword(nv, "NVreg", "NvAGP",  &agp_config);
        rm_read_registry_dword(nv, "NVreg", "XNvAGP", &agp_config);

        if (agp_config != NVOS_AGP_CONFIG_DISABLE_AGP && NV_AGP_FAILED(nv)) {
            len += sprintf(page+len,
                  "AGP initialization failed, please check the ouput  \n"
                  "of the 'dmesg' command and/or your system log file \n"
                  "for additional information on this problem.        \n");
        }
    }

    NV_PCI_DEV_PUT(dev);
    return len;
}

extern nv_parm_t nv_parms[];
extern char *NVreg_RegistryDwords;

static int
nv_kern_read_registry(char *page, char **start, off_t off,
        int count, int *eof, void *data)
{
    unsigned int i, len = 0;
    nv_parm_t *entry;
    *eof = 1;

    for (i = 0; (entry = &nv_parms[i])->name != NULL; i++)
        len += sprintf(page+len, "%s: %u\n", entry->name, *entry->data);

    len += sprintf(page+len, "RegistryDwords: \"%s\"\n",
                (NVreg_RegistryDwords != NULL) ? NVreg_RegistryDwords : "");

    return len;
}

static int
nv_kern_read_text_file(char *page, char **start, off_t off,
        int count, int *eof, void *data)
{
    *eof = 1;
    return sprintf(page, "%s", (char *)data);
}

/***
 *** EXPORTS to rest of resman
 ***/

/*
 * Given a physical address, find the associated 'at', track down
 * the actual page within the allocation and return a kernel virtual
 * mapping to it. Make sure to save the page offset if the address
 * isn't aligned.
 *
 * If the requested mapping spans more than one page, then determine
 * the individual pages and create a mapping with vmap().
 */
void* NV_API_CALL nv_alloc_kernel_mapping(
    nv_state_t *nv,
    NvU64 address,
    U032 size,
    void **priv_data
)
{
    nv_alloc_t *at;
    nv_linux_state_t *nvl = NV_GET_NVL_FROM_NV_STATE(nv);
    U032 i, offset;

    down(&nvl->at_lock);
    at = nvl_find_alloc(nvl, address, NV_ALLOC_TYPE_PCI);
    if (at != NULL)
    {
        offset = address & ~PAGE_MASK;
        address &= PAGE_MASK;

        for (i = 0; i < at->num_pages; i++)
        {
            if ((address == at->page_table[i]->phys_addr)
                    || (address == at->page_table[i]->dma_addr))
                break;
        }

        if (i == at->num_pages) /* not found */
        {
            up(&nvl->at_lock);
            return NULL;
        }
    }
    else
    {
        at = nvl_find_alloc(nvl, address, NV_ALLOC_TYPE_AGP);
        if (at != NULL)
        {
            offset = address - (unsigned long) at->key_mapping;
            i = offset >> PAGE_SHIFT;
            offset = address & ~PAGE_MASK;

            if (at->page_table[i]->virt_addr == 0)
            {
                up(&nvl->at_lock);
                return NULL;
            }
        }
        else
        {
            up(&nvl->at_lock);
            return NULL; /* not found */
        }
    }
    up(&nvl->at_lock);

    if ((size + offset) <= PAGE_SIZE)
    {
        *priv_data = NULL;
        return (void *)(at->page_table[i]->virt_addr + offset);
    }
    else
    {
#if defined(NV_VMAP_PRESENT)
        U032 j, page_count;
        unsigned long virt_addr;
        struct page **pages;

        size += offset; /* adjust mapping size */
        page_count = (size >> PAGE_SHIFT) + ((size & ~PAGE_MASK) ? 1 : 0);

        if ((i + page_count) > at->num_pages)
        {
            nv_printf(NV_DBG_ERRORS,
                "NVRM: requested mapping exceeds allocation's boundary!\n");
            return NULL;
        }

        NV_KMALLOC(pages, sizeof(struct page *) * page_count);
        if (pages == NULL)
        {
            nv_printf(NV_DBG_ERRORS,
                "NVRM: failed to allocate vmap() page descriptor table!\n");
            return NULL;
        }

        for (j = 0; j < page_count; j++)
            pages[j] = NV_GET_PAGE_STRUCT(at->page_table[i+j]->phys_addr);

        NV_VMAP(virt_addr, pages, page_count, NV_ALLOC_MAPPING_CACHED(at->flags));
        NV_KFREE(pages, sizeof(struct page *) * page_count);
        if (virt_addr == 0)
        {
            nv_printf(NV_DBG_ERRORS, "NVRM: vmap() failed to map pages!\n");
            return NULL;
        }

        *priv_data = (void *)(unsigned long)page_count;
        return (void *)(virt_addr + offset);
#else
        nv_printf(NV_DBG_ERRORS,
            "NVRM: This version of the Linux kernel does not provide the vmap()\n"
            "NVRM: kernel interface.  If you see this message, please update\n"
            "NVRM: your kernel to Linux 2.4.22 or install a distribution kernel\n"
            "NVRM: that supports the vmap() kernel interface.\n");
#endif
    }

    return NULL;
}

int NV_API_CALL nv_free_kernel_mapping(
    nv_state_t *nv,
    void *address,
    void *priv_data
)
{
#if defined(NV_VMAP_PRESENT)
    unsigned long virt_addr;
    U032 page_count;

    virt_addr = (unsigned long)address & PAGE_MASK;

    if (virt_addr >= VMALLOC_START && virt_addr < VMALLOC_END)
    {
        page_count = (unsigned long)priv_data;
        if (page_count == 0)
        {
            nv_printf(NV_DBG_ERRORS,
                "NVRM: nv_free_kernel_mapping(): invalid page count!\n");
            return RM_ERROR;
        }

        NV_VUNMAP(virt_addr, page_count);
    }
#endif
    return RM_OK;
}


/* virtual address to physical page address */
NvU64 nv_get_phys_address(
    NvU64 address,
    BOOL kern
)
{
#if defined(NV_SET_PAGES_UC_PRESENT)
    nv_printf(NV_DBG_ERRORS,
        "NVRM: can't translate address in nv_get_phys_address()!\n");
#else
    struct mm_struct *mm;
    pgd_t *pgd = NULL;
    pmd_t *pmd = NULL;
    pte_t *pte = NULL;
    NvU64 retval;

    if (!kern)
    {
        mm = current->mm;
        down_read(&mm->mmap_sem);
    }
    else
        mm = NULL;

    pgd = NV_PGD_OFFSET(address, kern, mm);
    if (!NV_PGD_PRESENT(pgd))
        goto failed;

    pmd = NV_PMD_OFFSET(address, pgd);
    if (!NV_PMD_PRESENT(pmd))
        goto failed;

    pte = NV_PTE_OFFSET(address, pmd);
    if (!NV_PTE_PRESENT(pte))
        goto failed;

    retval = ((NV_PTE_VALUE(pte) & PAGE_MASK) | NV_MASK_OFFSET(address));

#if defined(NVCPU_X86_64) && defined(_PAGE_NX)
    // mask out the non-executable page bit for the true physical address
    retval &= ~_PAGE_NX;
#endif

    if (!kern)
        up_read(&mm->mmap_sem);
    return retval;

failed:
    if (!kern)
        up_read(&mm->mmap_sem);
#endif
    return 0;
}

NvU64 NV_API_CALL nv_get_kern_phys_address(NvU64 address)
{
    /* make sure this address is a kernel virtual address */
#if defined(DEBUG) && !defined(CONFIG_X86_4G)
    if (address < PAGE_OFFSET)
    {
        nv_printf(NV_DBG_WARNINGS,
            "NVRM: user address passed to get_kern_phys_address: 0x%llx!\n",
            address);
        return 0;
    }
#endif

    /* direct-mapped kernel address */
    if ((address > PAGE_OFFSET) && (address < VMALLOC_START))
        return __pa(address);

    return nv_get_phys_address(address, TRUE);
}

NvU64 NV_API_CALL nv_get_kern_user_address(NvU64 address)
{
    /* make sure this address is not a kernel virtual address */
#if defined(DEBUG) && !defined(CONFIG_X86_4G)
    if (address >= PAGE_OFFSET)
    {
        nv_printf(NV_DBG_WARNINGS,
            "NVRM: kernel address passed to get_user_phys_address: 0x%llx!\n",
            address);
        return 0;
    }
#endif

    return nv_get_phys_address(address, FALSE);
}


/* allocate memory for DMA push buffers */
int NV_API_CALL nv_alloc_pages(
    nv_state_t *nv,
    U032 page_count,
    U032 agp_memory,
    U032 contiguous,
    U032 cache_type,
    NvU64 *pte_array,
    void **priv_data
)
{
    nv_alloc_t *at;
    RM_STATUS rm_status = 0;
    nv_linux_state_t *nvl = NV_GET_NVL_FROM_NV_STATE(nv);
    U032 i;

    nv_printf(NV_DBG_MEMINFO, "NVRM: VM: nv_alloc_pages: %d pages\n", page_count);
    nv_printf(NV_DBG_MEMINFO, "NVRM: VM:    agp %d  contig %d  cache_type %d\n",
        agp_memory, contiguous, cache_type);

    /* if we can't support this caching, bail before we do any work */
    if (nv_encode_caching(NULL, cache_type,
        agp_memory ? NV_MEMORY_TYPE_AGP : NV_MEMORY_TYPE_SYSTEM))
        return RM_ERROR;

    page_count = RM_PAGES_TO_OS_PAGES(page_count);
    at = nvos_create_alloc(nvl->dev, page_count);
    if (at == NULL)
        return RM_ERROR;

    at->flags = nv_alloc_init_flags(cache_type, agp_memory, contiguous);
    at->nv = nv;

    if (agp_memory)
    {
        U032 offset;

        if (!NV_AGP_ENABLED(nv))
            goto failed;

        /* allocate agp-able memory */
        if (NV_OSAGP_ENABLED(nv))
        {
            /* agpgart will allocate all of the underlying memory */
            rm_status = KernAllocAGPPages(nv, page_count, priv_data, &offset);
            if (rm_status)
                goto failed;

            KernLoadAGPPages(nv, at, *priv_data);
        } else {
            rm_status = rm_alloc_agp_pages(nv, page_count, priv_data, &offset);
            if (rm_status)
                goto failed;
        }

        at->priv_data = *priv_data;
        nvl_add_alloc(nvl, at);

        pte_array[0] = (nv->agp.address + (offset << PAGE_SHIFT));
        at->key_mapping = (void *)(NvUPtr)pte_array[0];
    }
    else 
    {
        if (nv_vm_malloc_pages(nv, at))
            goto failed;

        /* 
         * must be page-aligned or mmap will fail
         * so use the first page, which is page-aligned. this way, our 
         * allocated page table does not need to be page-aligned
         */
        for (i = 0; i < ((contiguous) ? 1 : page_count); i++)
            pte_array[i] = at->page_table[i]->dma_addr;

        at->key_mapping = (void *)at->page_table[0]->phys_addr;
        nvl_add_alloc(nvl, at);
    }

    *priv_data = at;
    NV_ATOMIC_INC(at->usage_count);

    NV_PRINT_AT(NV_DBG_MEMINFO, at);

    return RM_OK;

failed:
    nvos_free_alloc(at);

    return -1;
}

int NV_API_CALL nv_free_pages(
    nv_state_t *nv,
    U032 page_count,
    U032 agp_memory,
    U032 contiguous,
    U032 cache_type,
    void *priv_data
)
{
    int rmStatus = 0;
    nv_alloc_t *at = priv_data;
    nv_linux_state_t *nvl = NV_GET_NVL_FROM_NV_STATE(nv);

    page_count = RM_PAGES_TO_OS_PAGES(page_count);
    nv_printf(NV_DBG_MEMINFO, "NVRM: VM: nv_free_pages: 0x%p 0x%x\n",
        at->key_mapping, page_count);

    /* only lock ldata while removing 'at' from the list */
    down(&nvl->at_lock);

    NV_PRINT_AT(NV_DBG_MEMINFO, at);

    /*
     * If the 'at' usage count doesn't drop to zero here, not all of
     * the user mappings have been torn down in time - we can't
     * safely free the memory. We report success back to the RM, but
     * defer the actual free until later.
     *
     * This is described in greater detail in the comments above the
     * nv_kern_vma_(open|release)() callbacks above.
     */
    if (!NV_ATOMIC_DEC_AND_TEST(at->usage_count))
    {
        up(&nvl->at_lock);
        return 0;
    }

    nvl_remove_alloc(nvl, at);
    up(&nvl->at_lock);

    if (agp_memory)
    {
        if (!NV_AGP_ENABLED(nv))
            return -1;

        if (NV_OSAGP_ENABLED(nv))
        {
            rmStatus = KernFreeAGPPages(nv, at->priv_data);
        } else {
            rmStatus = rm_free_agp_pages(nv, at->priv_data);
        }
    } else
        nv_vm_free_pages(nv, at);

    nvos_free_alloc(at);

    return rmStatus;
}

NvU64 NV_API_CALL nv_dma_to_mmap_token(
    nv_state_t *nv,
    NvU64 address
)
{
    return address;
}

static void nv_lock_init_locks
( 
    nv_state_t *nv
)
{
    nv_linux_state_t *nvl;
    nvl = NV_GET_NVL_FROM_NV_STATE(nv);

    NV_SPIN_LOCK_INIT(&nvl->rm_lock);

    NV_INIT_MUTEX(&nvl->ldata_lock);
    NV_INIT_MUTEX(&nvl->at_lock);

    NV_ATOMIC_SET(nvl->usage_count, 0);

    nvl->rm_lock_cpu = -1;
    nvl->rm_lock_count = 0;
}

void NV_API_CALL nv_lock_rm(
    nv_state_t *nv
)
{
    nv_linux_state_t *nvl;
    int cpu;

    nvl = NV_GET_NVL_FROM_NV_STATE(nv);
    cpu = get_cpu();

    if (nvl->rm_lock_cpu == cpu)
    {
        nvl->rm_lock_count++;
        put_cpu();
        return;
    }

    put_cpu();
    NV_SPIN_UNLOCK_WAIT(&nvl->rm_lock);
    NV_SPIN_LOCK_IRQ(&nvl->rm_lock);

    nvl->rm_lock_cpu = smp_processor_id();
    nvl->rm_lock_count = 1;
}

void NV_API_CALL nv_unlock_rm(
    nv_state_t *nv
)
{
    nv_linux_state_t *nvl;
    nvl = NV_GET_NVL_FROM_NV_STATE(nv);

    if (--nvl->rm_lock_count)
        return;

    nvl->rm_lock_cpu = -1;
    NV_SPIN_UNLOCK_IRQ(&nvl->rm_lock);
}

/*
** post the event
*/
 
void NV_API_CALL nv_post_event(
    nv_state_t *nv,
    nv_event_t *event,
    U032        handle,
    U032        index
)
{
    struct file *file = (struct file *) event->file;
    nv_file_private_t *nvfp = NV_GET_NVFP(file);
    unsigned long eflags;
    nvidia_event_t *nvet;

    nv_printf(NV_DBG_EVENTINFO, "NVRM: posting event on 0x%x:0x%x\n",
        event, nvfp);

    NV_KMALLOC_ATOMIC(nvet, sizeof(nvidia_event_t));

    if (nvet == NULL)
        return;

    NV_SPIN_LOCK_IRQSAVE(&nvfp->fp_lock, eflags);

    // Insert the event struct in the queue
    if (nvfp->event_tail != NULL)
        nvfp->event_tail->next = nvet;
    if (nvfp->event_head == NULL)
        nvfp->event_head = nvet;
    nvfp->event_tail = nvet;
    nvet->next = NULL;

    // copy the event into the queue
    nvet->event         = *event;

    // set the handle for this event
    nvet->event.hObject = handle;
    nvet->event.index   = index;

    wake_up_interruptible(&nvfp->waitqueue);
    NV_SPIN_UNLOCK_IRQRESTORE(&nvfp->fp_lock, eflags);
}

int NV_API_CALL nv_get_event(
    nv_state_t *nv,
    void *void_file,
    nv_event_t *event,
    U032 *more_events
)
{
    struct file *file = (struct file *) void_file;
    nv_file_private_t *nvfp = NV_GET_NVFP(file);
    nvidia_event_t *nvet;
    unsigned long eflags;

    NV_SPIN_LOCK_IRQSAVE(&nvfp->fp_lock, eflags);
    if (nvfp->event_head == NULL)
    {
        NV_SPIN_UNLOCK_IRQRESTORE(&nvfp->fp_lock, eflags);
        return -1;
    }

    nvet = nvfp->event_head;

    *event = nvet->event;
    
    if (nvfp->event_tail == nvet)
        nvfp->event_tail = NULL;
    nvfp->event_head = nvet->next;

    NV_KFREE(nvet, sizeof(nvidia_event_t));

    if (more_events)
        *more_events = (nvfp->event_head != NULL);

    nv_printf(NV_DBG_EVENTINFO, "NVRM: returning event: 0x%x\n", event);
    nv_printf(NV_DBG_EVENTINFO, "NVRM:     hParent: 0x%x\n", event->hParent);
    nv_printf(NV_DBG_EVENTINFO, "NVRM:     hObject: 0x%x\n", event->hObject);
    nv_printf(NV_DBG_EVENTINFO, "NVRM:     file:    0x%p\n", event->file);
    nv_printf(NV_DBG_EVENTINFO, "NVRM:     fd:      %d\n", event->fd);
    if (more_events)
        nv_printf(NV_DBG_EVENTINFO, "NVRM: more events: %d\n", *more_events);

    NV_SPIN_UNLOCK_IRQRESTORE(&nvfp->fp_lock, eflags);

    return 0;
}


int NV_API_CALL nv_agp_init(
    nv_state_t *nv,
    void **phys_start,
    void *agp_limit,
    U032 config         /* passed in from XF86Config file */
)
{
    U032 status = 1;
    static int old_error = 0;

    if (NV_AGP_ENABLED(nv))
        return -1;

    if (config == NVOS_AGP_CONFIG_DISABLE_AGP)
    {
        nv->agp_config = NVOS_AGP_CONFIG_DISABLE_AGP;
        nv->agp_status = NV_AGP_STATUS_DISABLED;
        return 0;
    }

    nv_printf(NV_DBG_SETUP, "NVRM: nv_agp_init\n");

    nv->agp_config = NVOS_AGP_CONFIG_DISABLE_AGP;
    nv->agp_status = NV_AGP_STATUS_FAILED;

    if (config & NVOS_AGP_CONFIG_OSAGP)
    {
        status = KernInitAGP(nv, phys_start, agp_limit);

        /* if enabling agpgart was successfull, register it,
         * and check about overrides
         */
        if (status == 0)
        {
            nv->agp_config = NVOS_AGP_CONFIG_OSAGP;
            nv->agp_status = NV_AGP_STATUS_ENABLED;

            /* make sure we apply our overrides in this case */
            rm_update_agp_config(nv);
        }

        if (status == 1 && !(config & NVOS_AGP_CONFIG_NVAGP) && !old_error)
        {
            nv_printf(NV_DBG_ERRORS,
                "NVRM: unable to initialize the Linux AGPGART driver, please \n"
                "NVRM: verify you configured your kernel to include support  \n"
                "NVRM: for AGPGART (either statically linked, or as a kernel \n"
                "NVRM: module). Please also make sure you selected support   \n"
                "NVRM: for your AGP chipset.                                 \n");
#if !defined(KERNEL_2_4)
            nv_printf(NV_DBG_ERRORS,
                "NVRM:                                                       \n"
                "NVRM: note that as of Linux 2.6 AGPGART, all chipset/vendor \n"
                "NVRM: drivers are split into independent modules; make sure \n"
                "NVRM: the correct one is loaded for your chipset.           \n");
#endif
            old_error = 1;
        }

        /* if agpgart is loaded, but we failed to initialize it,
         * we'd better not attempt nvagp, or we're likely to lock
         * the machine.
         */
        if (status < 0)
            return status;
    }

    /* we're either explicitly not using agpgart,
     * or trying to use agpgart failed
     * make sure the user did not specify "use agpgart only"
     */
    if ( (!NV_AGP_ENABLED(nv)) && (config & NVOS_AGP_CONFIG_NVAGP) )
    {
        /* make sure the user does not have agpgart loaded */
#if defined(KERNEL_2_4)
        if (inter_module_get("drm_agp"))
        {
            inter_module_put("drm_agp");
            nv_printf(NV_DBG_WARNINGS, "NVRM: not using NVAGP, AGPGART is loaded!\n");
            return status;
        }
#elif defined(AGPGART)
#if (NV_AGP_BACKEND_ACQUIRE_ARGUMENT_COUNT == 1)
        if (!list_empty(&agp_bridges))
        {
            nv_printf(NV_DBG_WARNINGS,
                      "NVRM: not using NVAGP, an AGPGART backend is loaded!\n");
            return status;
        }
#else
        int error;
        /*
         * We can only safely use NvAGP when no backend has been
         * registered with the AGPGART frontend. This condition
         * is only met when the acquire function returns -EINVAL.
         *
         * Other return codes indicate that a backend is present
         * and was either acquired, busy or else unavailable.
         */
        if ((error = agp_backend_acquire()) != -EINVAL)
        {
            if (!error) agp_backend_release();
            nv_printf(NV_DBG_WARNINGS,
                      "NVRM: not using NVAGP, an AGPGART backend is loaded!\n");
            return status;
        }
#endif
#endif /* AGPGART  */
#if defined(CONFIG_X86_64) && defined(CONFIG_GART_IOMMU)
        nv_printf(NV_DBG_WARNINGS,
            "NVRM: not using NVAGP, kernel was compiled with GART_IOMMU support!!\n");
#else
        status = rm_init_agp(nv);
        if (status == RM_OK)
        {
            nv->agp_config = NVOS_AGP_CONFIG_NVAGP;
            nv->agp_status = NV_AGP_STATUS_ENABLED;
        }
#endif
    }

    if (NV_AGP_ENABLED(nv))
        old_error = 0; /* report new errors */

    return status;
}

int NV_API_CALL nv_agp_teardown(
    nv_state_t *nv
)
{
    U032 status = 1;

    nv_printf(NV_DBG_SETUP, "NVRM: nv_agp_teardown\n");

    /* little sanity check won't hurt */
    if (!NV_AGP_ENABLED(nv))
        return -1;

    if (NV_OSAGP_ENABLED(nv))
        status = KernTeardownAGP(nv);
    else if (NV_NVAGP_ENABLED(nv))
        status = rm_teardown_agp(nv);

    nv->agp_config = NVOS_AGP_CONFIG_DISABLE_AGP;
    nv->agp_status = NV_AGP_STATUS_DISABLED;

    return status;
}

int NV_API_CALL nv_int10h_call(
    nv_state_t *nv,
    U032 *eax,
    U032 *ebx,
    U032 *ecx,
    U032 *edx,
    void *buffer
)
{
    return -1;
}

/* set a timer to go off every second */
int NV_API_CALL nv_start_rc_timer(
    nv_state_t *nv
)
{
    nv_linux_state_t *nvl = NV_GET_NVL_FROM_NV_STATE(nv);

    if (nv->rc_timer_enabled)
        return -1;

    nv_printf(NV_DBG_INFO, "NVRM: initializing rc timer\n");
    init_timer(&nvl->rc_timer);
    nvl->rc_timer.function = nv_kern_rc_timer;
    nvl->rc_timer.data = (unsigned long) nv;
    nv->rc_timer_enabled = 1;
    mod_timer(&nvl->rc_timer, jiffies + HZ); /* set our timeout for 1 second */
    nv_printf(NV_DBG_INFO, "NVRM: rc timer initialized\n");

    return 0;
}

int NV_API_CALL nv_stop_rc_timer(
    nv_state_t *nv
)
{
    nv_linux_state_t *nvl = NV_GET_NVL_FROM_NV_STATE(nv);

    if (!nv->rc_timer_enabled)
        return -1;

    nv_printf(NV_DBG_INFO, "NVRM: stopping rc timer\n");
    nv->rc_timer_enabled = 0;
    del_timer_sync(&nvl->rc_timer);
    nv_printf(NV_DBG_INFO, "NVRM: rc timer stopped\n");

    return 0;
}

/* make sure the pci_driver called probe for all of our devices.
 * we've seen cases where rivafb claims the device first and our driver
 * doesn't get called.
 */
static int
nvos_count_devices(void)
{
    struct pci_dev *dev;
    int count = 0;

    dev = NV_PCI_GET_CLASS(PCI_CLASS_DISPLAY_VGA << 8, NULL);
    while (dev)
    {
        if ((dev->vendor == 0x10de) && (dev->device >= 0x20) &&
            !rm_is_legacy_device(dev->device, TRUE))
            count++;
        dev = NV_PCI_GET_CLASS(PCI_CLASS_DISPLAY_VGA << 8, dev);
    }

    dev = NV_PCI_GET_CLASS(PCI_CLASS_DISPLAY_3D << 8, NULL);
    while (dev)
    {
        if ((dev->vendor == 0x10de) && (dev->device >= 0x20) &&
            !rm_is_legacy_device(dev->device, TRUE))
            count++;
        dev = NV_PCI_GET_CLASS(PCI_CLASS_DISPLAY_3D << 8, dev);
    }

    return count;
}

/* find nvidia devices and set initial state */
int
nv_kern_probe
(
    struct pci_dev *dev,
    const struct pci_device_id *id_table
)
{
    nv_state_t *nv;
    nv_linux_state_t *nvl;
    unsigned int i, j;

    nv_printf(NV_DBG_SETUP, "NVRM: probing 0x%x 0x%x, class 0x%x\n",
        dev->vendor, dev->device, dev->class);

    if ((dev->vendor != 0x10de) || (dev->device < 0x20) || 
        ((dev->class != (PCI_CLASS_DISPLAY_VGA << 8)) &&
         (dev->class != (PCI_CLASS_DISPLAY_3D << 8))) ||
        rm_is_legacy_device(dev->device, FALSE))
    {
        return -1;
    }

    num_probed_nv_devices++;

    if (num_nv_devices == NV_MAX_DEVICES)
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: maximum device number (%d) exceeded!\n",
                  (NV_MAX_DEVICES - 1));
        return -1;
    }

    if (pci_enable_device(dev) != 0)
    {
        nv_printf(NV_DBG_ERRORS,
            "NVRM: pci_enable_device failed, aborting\n");
        return -1;
    }

    if (dev->irq == 0)
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: Can't find an IRQ for your NVIDIA card!\n");
        nv_printf(NV_DBG_ERRORS, "NVRM: Please check your BIOS settings.\n");
        nv_printf(NV_DBG_ERRORS, "NVRM: [Plug & Play OS] should be set to NO\n");
        nv_printf(NV_DBG_ERRORS, "NVRM: [Assign IRQ to VGA] should be set to YES \n");
        return -1;
    }

    // we won't always have a bar 3
    for (i = 0; i < (NV_GPU_NUM_BARS - 1); i++)
    {
        if (NV_PCI_RESOURCE_VALID(dev, i))
            continue;
        nv_printf(NV_DBG_ERRORS,
            "NVRM: This PCI I/O region assigned to your NVIDIA device is invalid:\n"
            "NVRM: BAR%d is %dM @ 0x%08x (PCI:%04x:%02x.%x)\n", i,
            NV_PCI_RESOURCE_SIZE(dev, i) >> 20, NV_PCI_RESOURCE_START(dev, i),
            NV_PCI_BUS_NUMBER(dev), NV_PCI_SLOT_NUMBER(dev), PCI_FUNC(dev->devfn));
        if (NV_PCI_RESOURCE_FLAGS(dev, i) & PCI_BASE_ADDRESS_MEM_TYPE_64)
        {
            nv_printf(NV_DBG_ERRORS,
                "NVRM: This is a 64-bit BAR, which some Linux kernels are known to\n"
                "NVRM: ignore or handle incorrectly. Please see the README section\n"
                "NVRM: on 64-bit BARs for more information.\n");
        }
        else
        {
            nv_printf(NV_DBG_ERRORS,
                "NVRM: The system BIOS may have misconfigured your graphics card.\n");
        }
        return -1;
    }

    // request ownership of our bars
    // keeps other drivers from banging our registers.
    // only do this for registers, as vesafb requests our framebuffer and will
    // keep us from working properly
    if (!request_mem_region(NV_PCI_RESOURCE_START(dev, NV_GPU_BAR_INDEX_REGS),
                            NV_PCI_RESOURCE_SIZE(dev, NV_GPU_BAR_INDEX_REGS), "nvidia"))
    {
        nv_printf(NV_DBG_ERRORS,
            "NVRM: request_mem_region failed for %dM @ 0x%08x. This can\n"
            "NVRM: occur when a driver such as rivatv is loaded and claims\n"
            "NVRM: ownership of the device's registers.\n",
            NV_PCI_RESOURCE_SIZE(dev, NV_GPU_BAR_INDEX_REGS) >> 20,
            NV_PCI_RESOURCE_START(dev, NV_GPU_BAR_INDEX_REGS));
        return -1;
    }
    pci_set_master(dev);

    /* initialize bus-dependent config state */
    nvl = &nv_linux_devices[num_nv_devices];
    nv  = NV_STATE_PTR(nvl);

    pci_set_drvdata(dev, (void *)nvl);

    /* default to 32-bit PCI bus address space */
    dev->dma_mask = 0xffffffffULL;

    nvl->dev          = dev;
    nv->vendor_id     = dev->vendor;
    nv->device_id     = dev->device;
    nv->os_state      = (void *) nvl;
    nv->bus           = NV_PCI_BUS_NUMBER(dev);
    nv->slot          = NV_PCI_SLOT_NUMBER(dev);
    nv->handle        = dev;

    nv_lock_init_locks(nv);
    
    for (i = 0, j = 0; i < NVRM_PCICFG_NUM_BARS && j < NV_GPU_NUM_BARS; i++)
    {
        if ((NV_PCI_RESOURCE_VALID(dev, i)) &&
            (NV_PCI_RESOURCE_FLAGS(dev, i) & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_MEMORY)
        {
            nv->bars[j].address = NV_PCI_RESOURCE_START(dev, i);
            nv->bars[j].size    = NV_PCI_RESOURCE_SIZE(dev, i);
            nv->bars[j].offset  = NVRM_PCICFG_BAR_OFFSET(i);
            j++;
        }
    }
    nv->regs = &nv->bars[NV_GPU_BAR_INDEX_REGS];
    nv->fb   = &nv->bars[NV_GPU_BAR_INDEX_FB];

    nv->interrupt_line = dev->irq;

#if defined(CONFIG_VGA_ARB)
#if defined(VGA_DEFAULT_DEVICE)
    vga_tryget(VGA_DEFAULT_DEVICE, VGA_RSRC_LEGACY_MASK);
#endif
    vga_set_legacy_decoding(dev, VGA_RSRC_NONE);
#endif

    if (!rm_init_private_state(nv))
    {
        nv_printf(NV_DBG_ERRORS, "NVRM: rm_init_private_state() failed!\n");
        goto err_zero_dev;
    }

    nv_printf(NV_DBG_INFO, "NVRM: %02x:%02x.%x %04x:%04x - 0x%08x [size=%dM]\n",
            nv->bus, nv->slot, PCI_FUNC(dev->devfn),
            nv->vendor_id, nv->device_id, nv->regs->address,
            nv->regs->size / (1024 * 1024));
    nv_printf(NV_DBG_INFO, "NVRM: %02x:%02x.%x %04x:%04x - 0x%08x [size=%dM]\n",
            nv->bus, nv->slot, PCI_FUNC(dev->devfn),
            nv->vendor_id, nv->device_id, nv->fb->address,
            nv->fb->size / (1024 * 1024));

    num_nv_devices++;

    return 0;

err_zero_dev:
    rm_free_private_state(nv);
    os_mem_set(nvl, 0, sizeof(nv_linux_state_t));
    release_mem_region(NV_PCI_RESOURCE_START(dev, NV_GPU_BAR_INDEX_REGS),
                       NV_PCI_RESOURCE_SIZE(dev, NV_GPU_BAR_INDEX_REGS));
    NV_PCI_DISABLE_DEVICE(dev);
    return -1;
}

int NV_API_CALL nv_no_incoherent_mappings(void)
{
#if defined(NV_CHANGE_PAGE_ATTR_PRESENT) || defined(NV_SET_PAGES_UC_PRESENT)
    return (nv_update_memory_types);
#else
    return 0;
#endif
}

#if defined(NV_PM_SUPPORT_DEVICE_DRIVER_MODEL)

static int
nv_power_management(
    struct pci_dev *dev, 
    u32 state
)
{
    nv_state_t *nv;
    nv_linux_state_t *lnv = NULL;
    int status = RM_OK;

    nv_printf(NV_DBG_INFO, "NVRM: nv_power_management: %d\n", state);
    lnv = pci_get_drvdata(dev);

    if ((!lnv) || (lnv->dev != dev))
    {
        nv_printf(NV_DBG_WARNINGS, "NVRM: PM: invalid device!\n");
        return -1;
    }

    nv = NV_STATE_PTR(lnv);

    nv_verify_pci_config(nv);

    switch (state)
    {
#if defined(NV_PM_SUPPORT_NEW_STYLE_APM)
        case PCI_D3hot:
            nv_printf(NV_DBG_INFO, "NVRM: APM: received suspend event\n");
            status = rm_power_management(nv, 0, NV_PM_APM_SUSPEND);
            __nv_disable_pat_support();
            break;

        case PCI_D0:
            nv_printf(NV_DBG_INFO, "NVRM: APM: received resume event\n");
            __nv_enable_pat_support();
            status = rm_power_management(nv, 0, NV_PM_APM_RESUME);
            break;

#else /* end of NV_PM_SUPPORT_NEW_STYLE_APM */
        case PCI_D3hot:
            nv_printf(NV_DBG_INFO, "NVRM: ACPI: received suspend event\n");
            status = rm_power_management(nv, 0, NV_PM_ACPI_STANDBY);            
            __nv_disable_pat_support();
            break;

        case PCI_D0:
            nv_printf(NV_DBG_INFO, "NVRM: ACPI: received resume event\n");
            __nv_enable_pat_support();
            status = rm_power_management(nv, 0, NV_PM_ACPI_RESUME);
            break;

#endif /* End of NV_PM_SUPPORT_NEW_STYLE_APM */

        default:
            nv_printf(NV_DBG_WARNINGS, "NVRM: PM: unsupported event: %d\n", state);
            return -1;
    }

    if (status != RM_OK)
        nv_printf(NV_DBG_ERRORS, "NVRM: PM: failed event: %d\n", state);

    return status;
}

static int nv_kern_suspend(
    struct pci_dev *dev,
    pm_message_t state
)
{
    int power_state = -1;

#if !defined(NV_PM_MESSAGE_T_PRESENT)
    power_state = state;
#elif defined(NV_PCI_CHOOSE_STATE_PRESENT)
    power_state = pci_choose_state(dev, state);
#endif

    return nv_power_management(dev, power_state);
}

static int nv_kern_resume(
    struct pci_dev *dev
)
{
    return nv_power_management(dev, PCI_D0);
}

#endif /* defined(NV_PM_SUPPORT_DEVICE_DRIVER_MODEL) */

void* NV_API_CALL nv_get_adapter_state(
    U016 bus,
    U016 slot
)
{
    unsigned int i;

    for (i = 0; i < num_nv_devices; i++)
    {
        nv_state_t *nv = NV_STATE_PTR(&nv_linux_devices[i]);
        if (nv->bus == bus && nv->slot == slot)
            return (void *) nv;
    }

    return NULL;
}

void NV_API_CALL nv_verify_pci_config(
    nv_state_t *nv
)
{
    BOOL check_the_bars;

    check_the_bars = (!nv_mmconfig_failure_detected && NV_MAY_SLEEP());
    rm_check_pci_config_space(nv, check_the_bars, &nv_mmconfig_failure_detected);

    if (nv_mmconfig_failure_detected)
    {
        if (NV_MAY_SLEEP())
        {
            nvos_proc_add_text_file(proc_nvidia_warnings, "mmconfig",
                    __mmconfig_warning);
        }
        nv_prints(NV_DBG_ERRORS, __mmconfig_warning);
    }
}

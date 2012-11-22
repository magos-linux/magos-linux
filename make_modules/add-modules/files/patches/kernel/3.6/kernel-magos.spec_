# -*- Mode: rpm-spec -*-
#
# (c) Mandriva
#

%define kernelversion	3
%define patchlevel	6
%define sublevel	2

# kernel.org -rcX patch (only the number after "rc")
%define krc		0

# kernel.org -gitX patch (only the number after "git")
%define kgit		0

# this is the releaseversion
%define mdvrelease 	1

# This is only to make life easier for people that creates derivated kernels
# a.k.a name it kernel-tmb :)
%define kname 		kernel-magos

#%define rpmtag		%distsuffix
%define rpmtag		magos

%if %krc || %kgit
%define	rpmrel		%mkrel %{?%{krc}:-rc%{krc}}%{?%{kgit}:-git%{kgit}}-%{mdvrelease}
%else
%define rpmrel		%mkrel %{mdvrelease}
%endif


# theese two never change, they are used to fool rpm/urpmi/smart
%define fakever		1
%define fakerel		%mkrel 1

# When we are using a rc/git patch
%define kversion  	%{kernelversion}.%{patchlevel}.%{sublevel}
%define tar_ver	  	%{kernelversion}.%{patchlevel}.%{sublevel}
%define kverrel   	%{kversion}-%{rpmrel}

# used for not making too long names for rpms or search paths
%if %krc || %kgit
%define buildrpmrel	0%{?%{krc}:.rc%{krc}}%{?%{kgit}:.git%{kgit}}.%{mdvrelease}%{rpmtag}
%else
%define	buildrpmrel	%{mdvrelease}%{rpmtag}
%endif

%define buildrel        %{kversion}-%{buildrpmrel}

%define magos_notice NOTE: This kernel has no Mandriva patches. It's maden for MagOS Linux distribution.

# having different top level names for packges means that you have to remove them by hard :(
%define top_dir_name    %{kname}-%{_arch}

%define build_dir       ${RPM_BUILD_DIR}/%{top_dir_name}
%define src_dir         %{build_dir}/linux-%{tar_ver}

# disable useless debug rpms...
%define _enable_debug_packages  %{nil}
%define debug_package           %{nil}

# build defines
%define build_doc 0
%define build_source 0
%define build_devel 1
%define build_headers 1
%define build_firmware 0

%define build_kernel 1

%define distro_branch %(perl -pe '/(\\d+)\\.(\\d)\\.?(\\d)?/; $_="$1.$2"' /etc/mandriva-release)

# End of user definitions
%{?_without_kernel: %global build_kernel 0}
%{?_without_doc: %global build_doc 0}
%{?_without_source: %global build_source 0}
%{?_without_devel: %global build_devel 0}

%{?_with_kernel: %global build_kernel 1}
%{?_with_doc: %global build_doc 1}
%{?_with_source: %global build_source 1}
%{?_with_devel: %global build_devel 1}

%if %(if [ -z "$CC" ] ; then echo 0; else echo 1; fi)
%define kmake %make CC="$CC"
%else
%define kmake %make
%endif
# there are places where parallel make don't work
%define smake make

# Parallelize xargs invocations on smp machines
%define kxargs xargs %([ -z "$RPM_BUILD_NCPUS" ] \\\
	&& RPM_BUILD_NCPUS="`/usr/bin/getconf _NPROCESSORS_ONLN`"; \\\
	[ "$RPM_BUILD_NCPUS" -gt 1 ] && echo "-P $RPM_BUILD_NCPUS")

# Aliases for amd64 builds (better make source links?)
%define target_cpu	%(echo %{_target_cpu} | sed -e "s/amd64/x86_64/")
%define target_arch	%(echo %{_arch} | sed -e "s/amd64/x86_64/")

# src.rpm description
Summary: 	The Linux kernel (the core of the Linux operating system)
Name:           %{kname}
Version:        %{kversion}
Release:        %{rpmrel}
License: 	GPLv2
Group: 		System/Kernel and hardware
ExclusiveArch: 	%{ix86} x86_64
ExclusiveOS: 	Linux
URL: 		http://wiki.mandriva.com/en/Docs/Howto/Mandriva_Kernels#kernel-linus

####################################################################
#
# Sources
#
### This is for full SRC RPM
Source0:        ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/linux-%{tar_ver}.tar.bz2
#Source1:        ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/linux-%{tar_ver}.tar.bz2.sign

# This is for disabling mrproper and other targets on -devel rpms
Source2:	disable-mrproper-in-devel-rpms.patch

Source4:       README.kernel-sources

# Kernel defconfigs
Source20: 	i386_defconfig
Source21: 	x86_64_defconfig


####################################################################
#
# Patches

#
# Patch0 to Patch100 are for core kernel upgrades.
#

# Pre linus patch: ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/testing

#%if %sublevel
#Patch1:         ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/patch-%{kversion}.bz2
#Source10:       ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/patch-%{kversion}.bz2.sign
#%endif
# kernel.org -git
#%if %kgit
#Patch2:         ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/snapshots/patch-%{kernelversion}.%{patchlevel}-%{sublevel}-git%{kgit}.bz2
#Source11:       ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/snapshots/patch-%{kernelversion}.%{patchlevel}-%{sublevel}-git%{kgit}.bz2.sign
#%endif
Patch1:		aufs3.6-linux.patch
Patch2:		logo_magos.patch
#Patch3:         http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.14-rt31.patch.bz2
#Patch3:         http://ck.kolivas.org/patches/bfs/3.1.0/3.2-sched-bfs-416.patch
Patch3:         3.5-sched-bfs-425.patch
#Patch4:         tuxonice-3.1.6.patch
#END
####################################################################

# Defines for the things that are needed for all the kernels
%define requires1 module-init-tools >= 3.6-12
%define requires2 mkinitrd >= 3.4.43-10
%define requires3 bootloader-utils >= 1.9
%define requires4 sysfsutils
%define requires5 kernel-firmware >= 2.6.27-0.rc2.2mdv

%define kprovides kernel = %{tar_ver}, alsa

BuildRoot: 	%{_tmppath}/%{name}-%{kversion}-build-%{_arch}
Autoreqprov: 	no
BuildRequires: 	gcc module-init-tools >= 0.9.15

%description
Source package to build the Linux kernel.

%{magos_notice}


#
# kernel: Symmetric MultiProcessing kernel
#
%if %build_kernel
%package -n %{kname}-%{buildrel}
Version:	%{fakever}
Release:	%{fakerel}
%ifarch %{ix86}
Summary:	Linux Kernel for desktop use with i586
%else
Summary:	Linux Kernel for desktop use with %{_arch}
%endif
Group:		System/Kernel and hardware
Provides:	%kprovides
Provides:	should-restart = system
Requires:	%requires1
Requires:	%requires2
Requires:	%requires3
Requires:	%requires4
Requires: 	%requires5

%ifarch %{ix86}
Conflicts:	arch(x86_64)
%endif

%description -n %{kname}-%{buildrel}
%ifarch %{ix86}
This kernel is compiled for desktop use, single or multiple i586
processor(s)/core(s) and less than 4GB RAM, using HZ_1000, voluntary
preempt, CFS cpu scheduler and cfq i/o scheduler.
This kernel relies on in-kernel smp alternatives to switch between
up & smp mode depending on detected hardware. To force the kernel
to boot in single processor mode, use the "nosmp" boot parameter.
%else
This kernel is compiled for desktop use, single or multiple %{_arch}
processor(s)/core(s), using HZ_1000, voluntary preempt, CFS cpu
scheduler and cfq i/o scheduler.
This kernel relies on in-kernel smp alternatives to switch between
up & smp mode depending on detected hardware. To force the kernel
to boot in single processor mode, use the "nosmp" boot parameter.
%endif

For instructions for update, see:
http://www.mandriva.com/en/security/kernelupdate

%{magos_notice}
%endif # build_kernel


#
# kernel-source: kernel sources
#
%if %build_source
%package -n %{kname}-source-%{buildrel}
Version:	%{fakever}
Release:	%{fakerel}
Provides:	%{kname}-source, kernel-source = %{kverrel}, kernel-devel = %{kverrel}
Provides:	%{kname}-source-%{kernelversion}.%{patchlevel}
Requires:	glibc-devel, ncurses-devel, make, gcc, perl, diffutils
Summary:	The source code for the Linux kernel
Group:		Development/Kernel
Autoreqprov: 	no
%ifarch %{ix86}
Conflicts:	arch(x86_64)
%endif

%description -n %{kname}-source-%{buildrel}
The %{kname}-source package contains the source code files for the
Linux kernel. Theese source files are only needed if you want to build
your own custom kernel that is better tuned to your particular hardware.

If you only want the files needed to build 3rdparty (nVidia, Ati, dkms-*,...)
drivers against, install the *-devel-* rpm that is matching your kernel.

For instructions for update, see:
http://www.mandriva.com/en/security/kernelupdate

%{magos_notice}
%endif #build_source


#
# kernel-devel: stripped kernel sources
#
%if %build_devel
%package -n %{kname}-devel-%{buildrel}
Version:	%{fakever}
Release:	%{fakerel}
Provides:	kernel-devel = %{kverrel}
Summary:	The %{kname} devel files for 3rdparty modules build
Group:		Development/Kernel
Autoreqprov:	no
Requires:	glibc-devel, ncurses-devel, make, gcc, perl
%ifarch %{ix86}
Conflicts:	arch(x86_64)
%endif

%description -n %{kname}-devel-%{buildrel}
This package contains the kernel-devel files that should be enough to build
3rdparty drivers against for use with the %{kname}-%{buildrel}.

If you want to build your own kernel, you need to install the full
%{kname}-source-%{buildrel} rpm.

%{magos_notice}
%endif #build_devel

#
# kernel-headers: kernel header files for userspace
#
%if %build_headers
%package -n %{kname}-headers-%{buildrel}
Version:	%{fakever}
Release:	%{fakerel}
Provides:	kernel-headers = %{kverrel}
Summary:	Linux kernel header files mostly used by your C library
Group:		System/Kernel and hardware
Autoreqprov:	no

%description -n %{kname}-headers-%{buildrel}
C header files from the Linux kernel. The header files define
structures and constants that are needed for building most
standard programs, notably the C library

This package is not suitable for building kernel modules, you
should use the 'kernel-devel' package instead

%{magos_notice}
%endif #build_headers

#
# kernel-doc: documentation for the Linux kernel
#
%if %build_doc
%package -n %{kname}-doc
Version:        %{kversion}
Release:        %{rpmrel}
Summary:	Various documentation bits found in the kernel source
Group:		Books/Computer books
Buildarch:	noarch

%description -n %{kname}-doc
This package contains documentation files form the kernel source. Various
bits of information about the Linux kernel and the device drivers shipped
with it are documented in these files. You also might want install this
package if you need a reference to the options that can be passed to Linux
kernel modules at load time.

For instructions for update, see:
http://www.mandriva.com/en/security/kernelupdate

%{magos_notice}
%endif #build_doc


#
# kernel-latest: virtual rpm
#
%if %build_kernel
%package -n %{kname}-latest
Version:        %{kversion}
Release:        %{rpmrel}
Summary: 	Virtual rpm for latest %{kname}
Group: 	  	System/Kernel and hardware
Requires: 	%{kname}-%{buildrel}
Obsoletes:	%{kname}-smp-latest
%ifarch %{ix86}
Conflicts:	arch(x86_64)
%endif

%description -n %{kname}-latest
This package is a virtual rpm that aims to make sure you always have the
latest %{kname} installed...

%{magos_notice}
%endif #build_kernel


#
# kernel-source-latest: virtual rpm
#
%if %build_source
%package -n %{kname}-source-latest
Version:        %{kversion}
Release:        %{rpmrel}
Summary: 	Virtual rpm for latest %{kname}-source
Group: 	  	System/Kernel and hardware
Requires: 	%{kname}-source-%{buildrel}
%ifarch %{ix86}
Conflicts:	arch(x86_64)
%endif

%description -n %{kname}-source-latest
This package is a virtual rpm that aims to make sure you always have the
latest %{kname}-source installed...

%{magos_notice}
%endif #build_source


#
# kernel-devel-latest: virtual rpm
#
%if %build_devel
%package -n %{kname}-devel-latest
Version:        %{kversion}
Release:        %{rpmrel}
Summary: 	Virtual rpm for latest %{kname}-devel
Group: 	  	System/Kernel and hardware
Requires: 	%{kname}-devel-%{buildrel}
Obsoletes:	%{kname}-smp-devel-latest
Obsoletes:	%{kname}-smp-headers-latest
%ifarch %{ix86}
Conflicts:	arch(x86_64)
%endif

%description -n %{kname}-devel-latest
This package is a virtual rpm that aims to make sure you always have the
latest %{kname}-devel installed...

%{magos_notice}
%endif #build_devel

%if %build_firmware
%package -n %{kname}-firmware-magos
Summary:	Linux kernel firmware files
Version:	%{kversion}
Release:	%{rpmrel}
License:	GPLv2
Group:  	System/Kernel and hardware
Conflicts:	kernel-firmware-extra < 20110310-1
Conflicts:	kernel-firmware
BuildArch:	noarch

%description -n %{kname}-firmware-magos
This package contains the firmware for in-kernel drivers that was previously
included in the kernel. It is shared by all kernels >= 2.6.27-rc1.
%endif

#
# End packages - here begins build stage
#
%prep
%setup -q -n %top_dir_name -c

pushd %src_dir
%patch1 -p1
%patch2 -p1
%patch3 -p1
popd

# PATCH END


#
# Setup Begin
#


# Install defconfigs...
install %{SOURCE20} %{build_dir}/linux-%{tar_ver}/arch/x86/configs/
install %{SOURCE21} %{build_dir}/linux-%{tar_ver}/arch/x86/configs/

# make sure the kernel has the patchlevel we know it has...
#LC_ALL=C perl -p -i -e "s/^SUBLEVEL.*/SUBLEVEL = %{sublevel}/" linux-%{tar_ver}/Makefile


%build
# Common target directories
%define _bootdir /boot
%define _modulesdir /lib/modules
%define _firmwaredir /lib/firmware
%define _kerneldir /usr/src/%{kname}-%{buildrel}
%define _develdir /usr/src/%{kname}-devel-%{buildrel}
%define _headersdir /usr/include

# Directories definition needed for building
%define temp_root %{build_dir}/temp-root
%define temp_boot %{temp_root}%{_bootdir}
%define temp_modules %{temp_root}%{_modulesdir}
%define temp_firmware %{temp_root}%{_firmwaredir}
%define temp_source %{temp_root}%{_kerneldir}
%define temp_devel %{temp_root}%{_develdir}
%define temp_headers %{temp_root}%{_headersdir}


# Create a simulacro of buildroot
rm -rf %{temp_root}
install -d %{temp_root}


# make sure we are in the directory
cd %{src_dir}

# make sure EXTRAVERSION says what we want it to say
#LC_ALL=C perl -p -i -e "s/^EXTRAVERSION.*/EXTRAVERSION = %{?%{krc}:-rc%{krc}}%{?%{kgit}:-git%{kgit}}-%{buildrpmrel}/" Makefile
sed -i /^EXTRAVERSION/s/[[:space:]]*$/-%{buildrpmrel}/ Makefile


# Prepare the kernel
%smake -s mrproper
%ifarch %{ix86} x86_64
	cp arch/x86/configs/%{target_arch}_defconfig .config
%else
	cp arch/%{target_arch}/defconfig .config
%endif
%smake ARCH=%{target_arch} oldconfig

# Build the kernel
%kmake ARCH=%{target_arch} all

# Install kernel
install -d %{temp_boot}
install -m 644 System.map %{temp_boot}/System.map-%{buildrel}
install -m 644 .config %{temp_boot}/config-%{buildrel}
cp -f arch/%{target_arch}/boot/bzImage %{temp_boot}/vmlinuz-%{buildrel}

# Install modules
install -d %{temp_modules}/%{buildrel}
%smake INSTALL_MOD_PATH=%{temp_root} KERNELRELEASE=%{buildrel} modules_install 

# OLD COMMENT: remove /lib/firmware, we use a separate kernel-firmware
# COMMENT: I add it, but clean the firmware dir, because some firmware 
#          not exist in the official firmware packages
%if %build_firmware
%else
for i in `%{_bindir}/urpmq -l kernel-firmware | /bin/sort -u | %__grep '^/lib/firmware' | %__sed "s#^/lib/firmware#%{temp_firmware}#g"` ; do
	[[ -f $i ]] && rm -f $i
done
for i in `%{_bindir}/urpmq -l kernel-firmware-extra | /bin/sort -u | %__grep '^/lib/firmware' | %__sed "s#^/lib/firmware#%{temp_firmware}#g"` ; do
	[[ -f $i ]] && rm -f $i
done
find %{temp_firmware} -type d | xargs rmdir --ignore-fail-on-non-empty
%endif

# Save devel tree
%if %build_devel
mkdir -p %{temp_devel}
for i in $(find . -name 'Makefile*'); do cp -R --parents $i %{temp_devel};done
for i in $(find . -name 'Kconfig*' -o -name 'Kbuild*' -o -name config.mk); do cp -R --parents $i %{temp_devel};done
cp -fR include %{temp_devel}
cp -fR scripts %{temp_devel}
mkdir -p %{temp_devel}/arch/x86/syscalls %{temp_devel}/tools/include/tools
%ifarch %{ix86} x86_64
	cp -fR arch/x86/kernel/asm-offsets.{c,s} %{temp_devel}/arch/x86/kernel/
	cp -fR arch/x86/kernel/asm-offsets_{32,64}.c %{temp_devel}/arch/x86/kernel/
	cp -fR arch/x86/include %{temp_devel}/arch/x86/
	cp -fR arch/x86/syscalls/syscall_{32,64}.tbl %{temp_devel}/arch/x86/syscalls/
	cp -fR arch/x86/syscalls/syscall{hdr,tbl}.sh %{temp_devel}/arch/x86/syscalls/
	cp -fR arch/x86/tools/relocs.c %{temp_devel}/arch/x86/tools
	cp -fR tools/include/tools/{l,b}e_byteshift.h %{temp_devel}/tools/include/tools/
%else
	cp -fR arch/%{target_arch}/kernel/asm-offsets.{c,s} %{temp_devel}/arch/%{target_arch}/kernel/
	cp -fR arch/%{target_arch}/include %{temp_devel}/arch/%{target_arch}/
%endif

# Needed for generation of kernel/bounds.s
cp -fR kernel/bounds.c %{temp_devel}/kernel/

# Needed for lguest
cp -fR drivers/lguest/lg.h %{temp_devel}/drivers/lguest/

cp -fR .config Module.symvers %{temp_devel}

# Needed for truecrypt build (Danny)
cp -fR drivers/md/dm.h %{temp_devel}/drivers/md/

# Needed for external dvb tree (#41418)
cp -fR drivers/media/dvb/dvb-core/*.h %{temp_devel}/drivers/media/dvb/dvb-core/
cp -fR drivers/media/dvb/frontends/lgdt330x.h %{temp_devel}/drivers/media/dvb/frontends/

# add acpica header files, needed for fglrx build
cp -fR drivers/acpi/acpica/*.h %{temp_devel}/drivers/acpi/acpica/

cp -fR Documentation/DocBook/media/*.b64 %{temp_devel}/Documentation/DocBook/media/

# Check and clean the -devel tree
pushd %{temp_devel} >/dev/null
    %smake -s prepare scripts clean
    rm -f .config.old
popd >/dev/null

# Disable mrproper and other targets
patch -p1 -d %{temp_devel} -i %{SOURCE2}

# Fix permissions
chmod -R a+rX %{temp_devel}
%endif # build_devel


# Save headers
%if %build_headers
mkdir -p %{temp_headers}
make INSTALL_HDR_PATH=$(dirname %{temp_headers}) headers_install
# Fix permissions
chmod -R a+rX %{temp_headers}
# clean headers
find %{temp_headers} -type f -name .install | xargs rm -f 
find %{temp_headers} -type f -name ..install.cmd | xargs rm -f 
%endif # build_headers


#make sure we are in the directory
cd %src_dir

# kernel-source is shipped as an unprepared tree
%smake -s mrproper


###
### Install
###
%install
install -m 644 %{SOURCE4}  .

cd %src_dir
# Directories definition needed for installing
%define target_source %{buildroot}/%{_kerneldir}
%define target_boot %{buildroot}%{_bootdir}
%define target_modules %{buildroot}%{_modulesdir}
%define target_devel %{buildroot}%{_develdir}
%define target_headers %{buildroot}%{_headersdir}

# We want to be able to test several times the install part
rm -rf %{buildroot}
cp -a %{temp_root} %{buildroot}

# Create directories infastructure
%if %build_source
install -d %{target_source}

tar cf - . | tar xf - -C %{target_source}
chmod -R a+rX %{target_source}

# we remove all the source files that we don't ship

# first architecture files
for i in alpha arm avr32 blackfin cris frv h8300 ia64 m32r mips microblaze \
	m68k m68knommu mn10300 parisc powerpc ppc s390 score sh sh64 sparc \
	tile unicore32 v850 xtensa; do
	rm -rf %{target_source}/arch/$i

%if %build_devel
	rm -rf %{target_devel}/arch/$i
%endif
done

# remove arch files based on target arch
%ifnarch %{ix86} x86_64
	rm -rf %{target_source}/arch/x86
%if %build_devel
	rm -rf %{target_devel}/arch/x86
%endif
%endif


# other misc files
rm -f %{target_source}/{.config.old,.config.cmd,.tmp_gas_check,.mailmap,.missing-syscalls.d,arch/.gitignore}

#endif %build_source
%endif


# gzipping modules disabled (xzm works much better)
#find %{target_modules} -name "*.ko" | %kxargs gzip -9

# We used to have a copy of PrepareKernel here
# Now, we make sure that the thing in the linux dir is what we want it to be

for i in %{target_modules}/*; do
  rm -f $i/build $i/source
done

# sniff, if we gzipped all the modules, we change the stamp :(
# we really need the depmod -ae here
pushd %{target_modules}
for i in *; do
	/sbin/depmod -u -ae -b %{buildroot} -r -F %{target_boot}/System.map-$i $i
	echo $?
done

for i in *; do
	pushd $i
	echo "Creating module.description for $i"
	modules=`find . -name "*.ko"`
	echo $modules | %kxargs /sbin/modinfo \
	| perl -lne 'print "$name\t$1" if $name && /^description:\s*(.*)/; $name = $1 if m!^filename:\s*(.*)\.k?o!; $name =~ s!.*/!!' > modules.description
	popd
done
popd

ln -sf /usr/src/%{kname}-devel-%{buildrel}  %{buildroot}/lib/modules/%{buildrel}/build
ln -sf /usr/src/%{kname}-devel-%{buildrel}  %{buildroot}/lib/modules/%{buildrel}/source

###
### Clean
###

%clean
rm -rf %{buildroot}
# We don't want to remove this, the whole reason of its existence is to be 
# able to do several rpm --short-circuit -bi for testing install 
# phase without repeating compilation phase
#rm -rf %{temp_root} 


###
### Scripts
###

### kernel
%if %build_kernel
%preun -n %{kname}-%{buildrel}
/sbin/installkernel -R %{buildrel}
if [ -L /lib/modules/%{buildrel}/build ]; then
    rm -f /lib/modules/%{buildrel}/build
fi
if [ -L /lib/modules/%{buildrel}/source ]; then
    rm -f /lib/modules/%{buildrel}/source
fi
pushd /boot > /dev/null
if [ -L vmlinuz ]; then
    if [ "$(readlink vmlinuz)" = "vmlinuz-%{buildrel}" ]; then
	rm -f vmlinuz
    fi
fi
if [ -L initrd.img ]; then
    if [ "$(readlink initrd.img)" = "initrd-%{buildrel}.img" ]; then
	rm -f initrd.img
    fi
fi
popd > /dev/null
exit 0

%post -n %{kname}-%{buildrel}
/sbin/installkernel -L %{buildrel}
if [ -d /usr/src/%{kname}-devel-%{buildrel} ]; then
    ln -sf /usr/src/%{kname}-devel-%{buildrel} /lib/modules/%{buildrel}/build
    ln -sf /usr/src/%{kname}-devel-%{buildrel} /lib/modules/%{buildrel}/source
fi
pushd /boot > /dev/null
if [ -L vmlinuz ]; then
    rm -f vmlinuz
fi
ln -sf vmlinuz-%{buildrel} vmlinuz
if [ -L initrd.img ]; then
    rm -f initrd.img
fi
ln -sf initrd-%{buildrel}.img initrd.img
popd > /dev/null

%postun -n %{kname}-%{buildrel}
/sbin/kernel_remove_initrd %{buildrel}
rm -rf /lib/modules/%{buildrel} >/dev/null
%endif # build_kernel


### kernel-devel
%if %build_devel
%post -n %{kname}-devel-%{buildrel}
# place /build and /source symlinks in place.
if [ -d /lib/modules/%{buildrel} ]; then
    ln -sf /usr/src/%{kname}-devel-%{buildrel} /lib/modules/%{buildrel}/build
    ln -sf /usr/src/%{kname}-devel-%{buildrel} /lib/modules/%{buildrel}/source
fi

%preun -n %{kname}-devel-%{buildrel}
# we need to delete <modules>/{build,source} at uninstall
if [ -L /lib/modules/%{buildrel}/build ]; then
    rm -f /lib/modules/%{buildrel}/build
fi
if [ -L /lib/modules/%{buildrel}/source ]; then
    rm -f /lib/modules/%{buildrel}/source
fi
exit 0
%endif #build_devel


### kernel-source
%if %build_source
%post -n %{kname}-source-%{buildrel}
for i in /lib/modules/%{buildrel}*; do
	if [ -d $i ]; then
		if [ ! -L $i/build -a ! -L $i/source ]; then
			rm -f $i/{build,source}
		        ln -sf /usr/src/%{kname}-%{buildrel} $i/build
		        ln -sf /usr/src/%{kname}-%{buildrel} $i/source
		fi
	fi
done

%preun -n %{kname}-source-%{buildrel}
for i in /lib/modules/%{buildrel}/{build,source}; do
	if [ -L $i ]; then
		if [ "$(readlink $i)" = "/usr/src/%{kname}-%{buildrel}" ]; then
			rm -f $i
		fi
	fi
done
exit 0
%endif # build_source


###
### file lists
###

# kernel
%if %build_kernel
%files -n %{kname}-%{buildrel}
%defattr(-,root,root)
%{_bootdir}/config-%{buildrel}
%{_bootdir}/vmlinuz-%{buildrel}
%{_bootdir}/System.map-%{buildrel}
%dir %{_modulesdir}/%{buildrel}/
%{_modulesdir}/%{buildrel}/kernel
%{_modulesdir}/%{buildrel}/modules.*
%{_modulesdir}/%{buildrel}/build
%{_modulesdir}/%{buildrel}/source
%if %build_firmware
%else
%dir %{_firmwaredir}
%{_firmwaredir}
%endif # build_firmware
%doc README.kernel-sources
%endif # build_kernel

# kernel-source
%if %build_source
%files -n %{kname}-source-%{buildrel}
%defattr(-,root,root)
%dir %{_kerneldir}
%dir %{_kerneldir}/arch
%dir %{_kerneldir}/include
%{_kerneldir}/.gitignore
%{_kerneldir}/COPYING
%{_kerneldir}/CREDITS
%{_kerneldir}/Documentation
%{_kerneldir}/Kbuild
%{_kerneldir}/Kconfig
%{_kerneldir}/MAINTAINERS
%{_kerneldir}/Makefile
%{_kerneldir}/README
%{_kerneldir}/REPORTING-BUGS
%{_kerneldir}/arch/Kconfig
%ifarch %{ix86} x86_64
%{_kerneldir}/arch/x86
%endif
%{_kerneldir}/arch/um
%{_kerneldir}/block
%{_kerneldir}/crypto
%{_kerneldir}/drivers
%{_kerneldir}/firmware
%{_kerneldir}/fs
%{_kerneldir}/include/Kbuild
%{_kerneldir}/include/acpi
%{_kerneldir}/include/asm-generic
%{_kerneldir}/include/crypto
%{_kerneldir}/include/drm
%{_kerneldir}/include/linux
%{_kerneldir}/include/math-emu
%{_kerneldir}/include/net
%{_kerneldir}/include/pcmcia
%{_kerneldir}/include/scsi
%{_kerneldir}/include/sound
%{_kerneldir}/include/target
%{_kerneldir}/include/trace
%{_kerneldir}/include/video
%{_kerneldir}/include/media
%{_kerneldir}/include/mtd
%{_kerneldir}/include/rxrpc
%{_kerneldir}/include/keys
%{_kerneldir}/include/rdma
%{_kerneldir}/include/xen
%{_kerneldir}/init
%{_kerneldir}/ipc
%{_kerneldir}/kernel
%{_kerneldir}/lib
%{_kerneldir}/mm
%{_kerneldir}/net
%{_kerneldir}/samples
%{_kerneldir}/scripts
%{_kerneldir}/security
%{_kerneldir}/sound
%{_kerneldir}/tools
%{_kerneldir}/usr
%{_kerneldir}/virt
%doc README.kernel-sources
%endif # build_source

# kernel-devel
%if %build_devel
%files -n %{kname}-devel-%{buildrel}
%defattr(-,root,root)
%dir %{_develdir}
%dir %{_develdir}/arch
%dir %{_develdir}/include
%{_develdir}/.config
%{_develdir}/Documentation
%{_develdir}/Kbuild
%{_develdir}/Kconfig
%{_develdir}/Makefile
%{_develdir}/Module.symvers
%{_develdir}/arch/Kconfig
%ifarch %{ix86} x86_64
%{_develdir}/arch/x86
%{_develdir}/arch/x86/syscalls
%endif
%{_develdir}/arch/um
%{_develdir}/arch/alpha
%{_develdir}/arch/arm
%{_develdir}/arch/avr32
%{_develdir}/arch/blackfin
%{_develdir}/arch/cris
%{_develdir}/arch/c6x
%{_develdir}/arch/frv
%{_develdir}/arch/h8300
%{_develdir}/arch/hexagon
%{_develdir}/arch/ia64
%{_develdir}/arch/m32r
%{_develdir}/arch/m68k
%{_develdir}/arch/microblaze
%{_develdir}/arch/mips
%{_develdir}/arch/mn10300
%{_develdir}/arch/openrisc
%{_develdir}/arch/parisc
%{_develdir}/arch/powerpc
%{_develdir}/arch/s390
%{_develdir}/arch/score
%{_develdir}/arch/sh
%{_develdir}/arch/sparc
%{_develdir}/arch/tile
%{_develdir}/arch/um
%{_develdir}/arch/unicore32
%{_develdir}/arch/x86
%{_develdir}/arch/xtensa
%{_develdir}/block
%{_develdir}/crypto
%{_develdir}/drivers
%{_develdir}/firmware
%{_develdir}/fs
%{_develdir}/include/Kbuild
%{_develdir}/include/acpi
%{_develdir}/include/asm-generic
%{_develdir}/include/config
%{_develdir}/include/crypto
%{_develdir}/include/drm
%{_develdir}/include/generated
%{_develdir}/include/keys
%{_develdir}/include/linux
%{_develdir}/include/math-emu
%{_develdir}/include/memory
%{_develdir}/include/misc
%{_develdir}/include/mtd
%{_develdir}/include/net
%{_develdir}/include/pcmcia
%{_develdir}/include/ras
%{_develdir}/include/rdma
%{_develdir}/include/scsi
%{_develdir}/include/sound
%{_develdir}/include/target
%{_develdir}/include/trace
%{_develdir}/include/video
%{_develdir}/include/media
%{_develdir}/include/rxrpc
%{_develdir}/include/xen
%{_develdir}/init
%{_develdir}/ipc
%{_develdir}/kernel
%{_develdir}/lib
%{_develdir}/mm
%{_develdir}/net
%{_develdir}/samples
%{_develdir}/scripts
%{_develdir}/security
%{_develdir}/sound
%{_develdir}/tools
%{_develdir}/tools/include/tools
%{_develdir}/usr
%{_develdir}/virt
%doc README.kernel-sources
%endif # build_devel

# kernel-headers
%if %build_headers
%files -n %{kname}-headers-%{buildrel}
%defattr(-,root,root)
%dir %{_headersdir}
%{_headersdir}/*
%endif # build_headers

%if %build_doc
%files -n %{kname}-doc
%defattr(-,root,root)
%doc linux-%{tar_ver}/Documentation/*
%endif # build_doc

%if %build_kernel
%files -n %{kname}-latest
%defattr(-,root,root)
%endif # build_kernel

%if %build_source
%files -n %{kname}-source-latest
%defattr(-,root,root)
%endif # build_source

%if %build_devel
%files -n %{kname}-devel-latest
%defattr(-,root,root)
%endif # build_devel

%if %build_firmware
%files -n %{kname}-firmware-magos
%defattr(0644,root,root,0755)
%dir %{_firmwaredir}
%{_firmwaredir}
%endif # build_firmware



%changelog
* Fri Oct 19 2012 Mikhail Zaripov <m3for@mail.ru> 3.6.2-1magos
    - linux updates

* Wed Sep 19 2012 Mikhail Zaripov <m3for@mail.ru> 3.5.4-1magos
    - linux updates

* Wed Jul 18 2012 Mikhail Zaripov <m3for@mail.ru> 3.4.5-1magos
    - linux updates

* Sun Jul 08 2012 Mikhail Zaripov <m3for@mail.ru> 3.4.4-1magos
    - linux updates

* Fri Jun 22 2012 Mikhail Zaripov <m3for@mail.ru> 3.4.3-1magos
    - linux updates

* Tue May 22 2012 Mikhail Zaripov <m3for@mail.ru> 3.3.7-1magos
    - linux updates

* Tue Apr 24 2012 Mikhail Zaripov <m3for@mail.ru> 3.3.3-1magos
    - linux updates

* Sat Mar 24 2012 Mikhail Zaripov <m3for@mail.ru> 3.2.13-1magos
    - linux updates

* Sun Mar 18 2012 Mikhail Zaripov <m3for@mail.ru> 3.2.11-1magos
    - linux updates

* Thu Feb 15 2012 Mikhail Zaripov <m3for@mail.ru> 3.2.7-1magos
    - AUFS v 3.2
    - tuxonice are excluded again
    - BFS updates

* Fri Jan 13 2012 Mikhail Zaripov <m3for@mail.ru> 3.1.8-1magos
    - AUFS v 3.1
    - tuxonice are added again
    - removed RT patch
    - added BFS
    - links /boot/{vmlinuz|inirtd}-linus changed to /boot/{vmlinuz|inirt}

* Fri Jan 06 2012 Mikhail Zaripov <m3for@mail.ru> 3.0.15-1magos
    - AUFS v 3.0
    - tuxonice are removed
    - added RT patch 
    - added BFS

* Fri Dec 30 2011 Mikhail Zaripov <m3for@mail.ru> 2.6.49.4-1magos
    - Initial release
    - based on kenel-linus-...src.spp
    - aufs 2.2 patch added
    - magos original logo added
    - default config changed

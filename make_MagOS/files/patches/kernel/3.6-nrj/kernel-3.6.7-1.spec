# -*- Mode: rpm-spec -*-
#
# This Specfile is based on kernel-tmb spec done by
# Thomas Backlund <tmb@mandriva.org>
# 
# The mkflavour() macroization done by Anssi Hannula <anssi@mandriva.org>
#
# Mageia, Mandriva, MIB and ROSA kernels use kernel.org versioning
#
# MIB header
%if %{mdvver} <= 201100
%define distsuffix mib
Vendor: MIB - Mandriva International Backports
%endif
Packager: Nicolo' Costanza <abitrules@yahoo.it>
# end MIB header
#
%define kernelversion	3
%define patchlevel	6
# sublevel is now used for -stable patches
%define sublevel	7

# Package release
%define mibrel		1

# kernel Makefile extraversion is substituted by
# kpatch wich are either 0 (empty), rc (kpatch)
%define kpatch		0
# kernel.org -gitX patch (only the number after "git")
%define kgit		0

# kernel base name (also name of srpm)
%define kname 		kernel

# Patch tarball tag
%define ktag		rosa

# define rpmtag		%{distsuffix}
%define rpmtag		%{distsuffix}
%if %kpatch
%if %kgit
%define rpmrel		%mkrel 0.%{kpatch}.%{kgit}.%{mibrel}
%else
%define rpmrel		%mkrel 0.%{kpatch}.%{mibrel}
%endif
%else
%define rpmrel		%{mibrel}
%endif

# fakerel and fakever never change, they are used to fool
# rpm/urpmi/smart
%define fakever		1
%define fakerel 	%mkrel 1

# version defines
%define kversion  	%{kernelversion}.%{patchlevel}.%{sublevel}
%define kverrel   	%{kversion}-%{rpmrel}

# When we are using a pre/rc patch, the tarball is a sublevel -1
%if %kpatch
%if %sublevel
%define tar_ver   	%{kernelversion}.%{patchlevel}
%else
%define tar_ver		%{kernelversion}.%(expr %{patchlevel} - 1)
%endif
%define patch_ver 	%{kversion}-%{kpatch}-%{ktag}%{mibrel}
%else
%define tar_ver   	%{kernelversion}.%{patchlevel}
%define patch_ver 	%{kversion}-%{ktag}%{mibrel}
%endif

# Used for not making too long names for rpms or search paths
%if %kpatch
%if %kgit
%define buildrpmrel     0.%{kpatch}.%{kgit}.%{mibrel}%{rpmtag}
%else
%define buildrpmrel     0.%{kpatch}.%{mibrel}%{rpmtag}
%endif
%else
%define buildrpmrel     %{mibrel}%{rpmtag}
%endif
%define buildrel     	%{kversion}-%{buildrpmrel}

# Having different top level names for packges means that you have to remove
# them by hard :(
%define top_dir_name 	%{kname}-%{_arch}

%define build_dir 	${RPM_BUILD_DIR}/%{top_dir_name}
%define src_dir 	%{build_dir}/linux-%{tar_ver}

# Disable useless debug rpms...
%define _enable_debug_packages 	%{nil}
%define debug_package 		%{nil}

# Build defines
%define build_doc 		1
%define build_source 		1
%define build_devel 		1

%define build_debug 		0

#
# Old Mandriva kernel flavours plus new two PAE flavours
#

# Build desktop i586 / 4GB
%ifarch %{ix86}
%define build_desktop586		0
%endif

# Build desktop (i686 / 4GB) / x86_64 / sparc64 sets
%define build_desktop			1

# Build netbook (i686 / 4GB) / x86_64
%define build_netbook			1

# Build server (i686 / 64GB)/x86_64 / sparc64 sets
%define build_server			1

# Build desktop686 pae (i686 / 64GB)
%ifarch %{ix86}
%define build_desktop_pae		1
%endif

# Build netbook686 pae (i686 / 64GB)
%ifarch %{ix86}
%define build_netbook_pae		1
%endif

#
# MIB low latency optimized flavours called "nrj"
#

# Build nrj desktop586 (i586 / 4GB)
%ifarch %{ix86}
%define build_nrj_desktop586		0
%endif

# Build nrj desktop (i686 / 4GB) / x86_64 / sparc64 sets
%define build_nrj_desktop		1

# Build nrj realtime (i686 / 4GB) / x86_64
%define build_nrj_realtime		1

# Build nrj laptop (i686 / 4GB) / x86_64
%define build_nrj_laptop		1

# Build nrj netbook (i686 / 4GB) / x86_64
%define build_nrj_netbook		1

# Build nrj desktop pae (i686 / 64GB)
%ifarch %{ix86}
%define build_nrj_desktop_pae		1
%endif

# Build nrj realtime pae (i686 / 64GB)
%ifarch %{ix86}
%define build_nrj_realtime_pae		1
%endif

# Build nrj laptop pae (i686 / 64GB)
%ifarch %{ix86}
%define build_nrj_laptop_pae		1
%endif

# Build nrj netbook686 pae (i686 / 64GB)
%ifarch %{ix86}
%define build_nrj_netbook_pae		1
%endif

#
# experimental "cpu level" optimized "nrj" flavours
#

# Build nrj netbook Intel Atom (matom / 4GB)
%ifarch %{ix86}
%define build_nrj_netbook_atom		1
%endif

# Build nrj netbook Intel Atom pae (matom / 64GB)
%ifarch %{ix86}
%define build_nrj_netbook_atom_pae	1
%endif

# Build nrj desktop Intel Core2 (mcore2 / 4GB)
%ifarch %{ix86}
%define build_nrj_desktop_core2   	1
%endif

# Build nrj desktop Intel Core2 pae (mcore2 / 64GB)
%ifarch %{ix86}
%define build_nrj_desktop_core2_pae   	1
%endif

#
# end of experimental "cpu level" optimized "nrj" flavours
#

# build perf and cpupower tools
%if %{mdvver} >= 201200
%define build_perf		1
%define build_cpupower		1
%else
%define build_perf		0
%define build_cpupower		0
%endif

# compress modules with xz
%if %{mdvver} >= 201200
%define build_modxz		0
%else
%define build_modxz		0
%endif

# ARM builds
%ifarch %{arm}
%define build_desktop		0
%define build_netbook		0
%define build_server		0
%define build_iop32x		0
%define build_kirkwood		1
%define build_versatile		1
# no cpupower tools on arm yet
%define build_cpupower		0
# arm is currently not using xz
%define build_modxz		0
%endif
# End of user definitions

# buildtime flags
%{?_without_desktop586: %global build_desktop586 0}
%{?_without_desktop: %global build_desktop 0}
%{?_without_netbook: %global build_netbook 0}
%{?_without_server: %global build_server 0}

%{?_without_desktop_pae: %global build_desktop_pae 0}
%{?_without_netbook_pae: %global build_netbook_pae 0}

%{?_without_nrj_desktop586: %global build_nrj_desktop586 0}
%{?_without_nrj_desktop: %global build_nrj_desktop 0}
%{?_without_nrj_realtime: %global build_nrj_realtime 0}
%{?_without_nrj_laptop: %global build_nrj_laptop 0}
%{?_without_nrj_netbook: %global build_nrj_netbook 0}

%{?_without_nrj_desktop_pae: %global build_nrj_desktop_pae 0}
%{?_without_nrj_realtime_pae: %global build_nrj_realtime_pae 0}
%{?_without_nrj_laptop_pae: %global build_nrj_laptop_pae 0}
%{?_without_nrj_netbook_pae: %global build_nrj_netbook_pae 0}

%{?_without_nrj_netbook_atom: %global build_nrj_netbook_atom 0}
%{?_without_nrj_netbook_atom_pae: %global build_nrj_netbook_atom_pae 0}
%{?_without_nrj_desktop_core2: %global build_nrj_desktop_core2 0}
%{?_without_nrj_desktop_core2_pae: %global build_nrj_desktop_core2_pae 0}

%{?_without_doc: %global build_doc 0}
%{?_without_source: %global build_source 0}
%{?_without_devel: %global build_devel 0}
%{?_without_debug: %global build_debug 0}
%{?_without_perf: %global build_perf 0}
%{?_without_cpupower: %global build_cpupower 0}
%{?_without_modxz: %global build_modxz 0}


%{?_with_desktop586: %global build_desktop586 1}
%{?_with_desktop: %global build_desktop 1}
%{?_with_netbook: %global build_netbook 1}
%{?_with_server: %global build_server 1}

%{?_with_desktop_pae: %global build_desktop_pae 1}
%{?_with_netbook_pae: %global build_netbook_pae 1}

%{?_with_nrj_desktop586: %global build_nrj_desktop586 1}
%{?_with_nrj_desktop: %global build_nrj_desktop 1}
%{?_with_nrj_realtime: %global build_nrj_realtime 1}
%{?_with_nrj_laptop: %global build_nrj_laptop 1}
%{?_with_nrj_netbook: %global build_nrj_netbook 1}

%{?_with_nrj_desktop_pae: %global build_nrj_desktop_pae 1}
%{?_with_nrj_realtime_pae: %global build_nrj_realtime_pae 1}
%{?_with_nrj_laptop_pae: %global build_nrj_laptop_pae 1}
%{?_with_nrj_netbook_pae: %global build_nrj_netbook_pae 1}

%{?_with_nrj_netbook_atom: %global build_nrj_netbook_atom 1}
%{?_with_nrj_netbook_atom_pae: %global build_nrj_netbook_atom_pae 1}
%{?_with_nrj_desktop_core2: %global build_nrj_desktop_core2 1}
%{?_with_nrj_desktop_core2_pae: %global build_nrj_desktop_core2_pae 1}

%{?_with_doc: %global build_doc 1}
%{?_with_source: %global build_source 1}
%{?_with_devel: %global build_devel 1}
%{?_with_debug: %global build_debug 1}
%{?_with_perf: %global build_perf 1}
%{?_with_cpupower: %global build_cpupower 1}
%{?_with_modxz: %global build_modxz 1}

# ARM builds
%{?_with_iop32x: %global build_iop32x 1}
%{?_with_kirkwood: %global build_kirkwood 1}
%{?_with_versatile: %global build_versatile 1}
%{?_without_iop32x: %global build_iop32x 0}
%{?_without_kirkwood: %global build_kirkwood 0}
%{?_without_versatile: %global build_versatile 0}

%define build_modgz                     0
%{?_with_modgz: %global build_modgz 1}
# MagOS Linux settings
%define build_for_magos 0
%{?_with_build_for_magos: %global build_for_magos 1}
%if %build_for_magos
%define build_desktop                   0
%define build_netbook                   0
%define build_server                    0
%define build_desktop_pae               0
%define build_netbook_pae               0
%define build_nrj_desktop               0
%define build_nrj_realtime              0
%define build_nrj_laptop                0
%define build_nrj_netbook               0
%define build_nrj_realtime_pae          0
%define build_nrj_laptop_pae            0
%define build_nrj_netbook_pae           0
%define build_nrj_netbook_atom          0
%define build_nrj_netbook_atom_pae      0
%define build_nrj_desktop_core2         0
%define build_nrj_desktop_core2_pae     0
%define build_doc                       0
%define build_source                    0
%define build_debug                     0
%define build_perf                      0
%define build_cpupower                  0
%define build_modxz                     0
%define build_modgz                     0
%define aufs_version                    3.6-20121119
%endif

# For the .nosrc.rpm
%define build_nosrc 	0
%{?_with_nosrc: %global build_nosrc 1}

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

# Sparc arch wants sparc64 kernels
%define target_arch    %(echo %{_arch} | sed -e 's/mips.*/mips/' -e 's/arm.*/arm/')


#
# SRC RPM description
#
Summary: 	Linux kernel built for Mandriva and ROSA
Name:		%{kname}
Version: 	%{kversion}
Release: 	%{rpmrel}
License: 	GPLv2
Group: 	 	System/Kernel and hardware
ExclusiveArch: %{ix86} x86_64 %{arm}
ExclusiveOS: 	Linux
URL:            http://www.kernel.org

####################################################################
#
# Sources
#
### This is for full SRC RPM
Source0: 	ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/linux-%{tar_ver}.tar.xz
Source1: 	ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/linux-%{tar_ver}.tar.sign
### This is for stripped SRC RPM
%if %build_nosrc
NoSource: 0
%endif
# This is for disabling *config, mrproper, prepare, scripts on -devel rpms
Source2: 	disable-mrproper-prepare-scripts-configs-in-devel-rpms.patch

Source4: 	README.kernel-sources
Source5:	kernel.rpmlintrc

# config and systemd service file from fedora
Source50:	cpupower.service
Source51:	cpupower.config

# our patch tarball
Source100: 	linux-%{patch_ver}.tar.xz

####################################################################
#
# Patches

#
# Patch0 to Patch100 are for core kernel upgrades.
#

# Pre linus patch: ftp://ftp.kernel.org/pub/linux/kernel/v3.0/testing

%if %kpatch
%if %sublevel
Patch2:		ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/stable-review/patch-%{kversion}-%{kpatch}.xz
Source11:	ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/stable-review/patch-%{kversion}-%{kpatch}.sign
%else
Patch1:		ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/testing/patch-%{kernelversion}.%{patchlevel}-%{kpatch}.xz
Source10: 	ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/testing/patch-%{kernelversion}.%{patchlevel}-%{kpatch}.sign
%endif
%endif
%if %kgit
Patch2:		ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/snapshots/patch-%{kernelversion}.%{patchlevel}-%{kpatch}-git%{kgit}.xz
Source11: 	ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/snapshots/patch-%{kernelversion}.%{patchlevel}-%{kpatch}-git%{kgit}.sign
%endif
%if %sublevel
%if %kpatch
%define prev_sublevel %(expr %{sublevel} - 1)
%if %prev_sublevel
Patch1:   	ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/patch-%{kernelversion}.%{patchlevel}.%{prev_sublevel}.xz
Source10: 	ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/patch-%{kernelversion}.%{patchlevel}.%{prev_sublevel}.sign
%endif
%else
Patch1:   	ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/patch-%{kversion}.xz
Source10: 	ftp://ftp.kernel.org/pub/linux/kernel/v%{kernelversion}.%{patchlevel}/patch-%{kversion}.sign
%endif
%endif

%if %build_for_magos
Patch101:       linux-%{patch_ver}-magos.patch
Patch102:       patch_wireless-add_back_sysfs_directory.patch
%endif

#END
####################################################################

# Defines for the things that are needed for all the kernels
#
%define common_desc_kernel The kernel package contains the Linux kernel (vmlinuz), the core of your \
Mandriva and ROSA operating system. The kernel handles the basic functions \
of the operating system: memory allocation, process allocation, device \
input and output, etc.

%define common_desc_kernel_smp This kernel relies on in-kernel smp alternatives to switch between up & smp \
mode depending on detected hardware. To force the kernel to boot in single \
processor mode, use the "nosmp" boot parameter.


### Global Requires/Provides

%if %{mdvver} == 201210
%define requires1	bootloader-utils >= 1.15-8
%define requires2	dracut >= 017-16
%define requires3	kmod >= 7-6
%define requires4	sysfsutils >=  2.1.0-12
%define requires5	kernel-firmware >=  20120219-1
%define requires6	microcode >=  0.20120313-1
%endif

%if %{mdvver} == 201200
%define requires1	bootloader-utils >= 1.15-8
%define requires2	dracut >= 017-16
%define requires3	module-init-tools >= 3.16-5
%define requires4	sysfsutils >=  2.1.0-12
%define requires5	kernel-firmware >=  20120219-1
%define requires6	microcode >=  0.20120313-1
%endif

%if %{mdvver} < 201200
%define requires1	bootloader-utils >= 1.13-1
%define requires2	mkinitrd >= 4.2.17-31
%define requires3	module-init-tools >= 3.0-7
%define requires4	sysfsutils >= 1.3.0-1
%define requires5	kernel-firmware >= 20101024-2
%define requires6	microcode >=  0.20120313-1
%endif

%define kprovides 	%{kname} = %{kverrel}, kernel = %{tar_ver}, alsa = 1.0.25
%define kprovides_server drbd-api = 88

%define	kobsoletes	dkms-r8192se <= 0019.1207.2010-2, dkms-lzma <= 4.43-32, dkms-psb <= 4.41.1-7

Autoreqprov: 		no

# might be useful too:
# Suggests:	microcode

%if %{mdvver} == 201210
BuildRequires:	kmod-devel
%else
BuildRequires:	module-init-tools
%endif

BuildRequires: 	gcc 

%if %build_for_magos
%else
# for perf, cpufreq and other tools
BuildRequires:		elfutils-devel
BuildRequires:		zlib-devel
BuildRequires:		binutils-devel
BuildRequires:		newt-devel
BuildRequires:		python-devel
BuildRequires:		perl(ExtUtils::Embed)
BuildRequires:		pciutils-devel
BuildRequires:		asciidoc
BuildRequires:		xmlto
BuildRequires:		gettext
BuildRequires:		docbook-style-xsl
BuildRequires:		pkgconfig(gtk+-2.0)
BuildRequires:		flex
BuildRequires:		bison
%endif

%ifarch %{arm}
BuildRequires:		uboot-mkimage
%endif


%description
%common_desc_kernel
%ifnarch %{arm}
%common_desc_kernel_smp
%endif

# Define obsolete/provides to help automatic upgrades of old kernel-xen-pvops
%define latest_obsoletes_server kernel-xen-pvops-latest < 3.2.1-1
%define latest_provides_server kernel-xen-pvops-latest = %{kverrel}
%define latest_obsoletes_devel_server kernel-xen-pvops-devel-latest < 3.2.1-1
%define latest_provides_devel_server kernel-xen-pvops-devel-latest = %{kverrel}

# mkflavour() name flavour processor
# name: the flavour name in the package name
# flavour: first parameter of CreateKernel()
%define mkflavour()					\
%package -n %{kname}-%{1}-%{buildrel}			\
Version:	%{fakever}				\
Release:	%{fakerel}				\
Provides:	%kprovides				\
%{expand:%%{?kprovides_%{1}:Provides: %{kprovides_%{1}}}} \
Provides:	%{kname}-%{1}				\
Requires(pre):	%requires1 %requires2 %requires3 %requires4 \
Requires:	%requires2 %requires5 %requires6	\
Obsoletes:	%kobsoletes				\
Provides:	should-restart = system			\
Suggests:	crda					\
%ifarch %{ix86}						\
Conflicts:	arch(x86_64)				\
%endif							\
Summary:	%{expand:%{summary_%(echo %{1} | sed -e "s/-/_/")}} \
Group:		System/Kernel and hardware		\
%description -n %{kname}-%{1}-%{buildrel}		\
%common_desc_kernel %{expand:%{info_%(echo %{1} | sed -e "s/-/_/")}} \
%ifnarch %{arm}						\
%common_desc_kernel_smp					\
%endif							\
							\
%if %build_devel					\
%package -n	%{kname}-%{1}-devel-%{buildrel}		\
Version:	%{fakever}				\
Release:	%{fakerel}				\
Requires:	glibc-devel ncurses-devel make gcc perl	\
Summary:	The kernel-devel files for %{kname}-%{1}-%{buildrel} \
Group:		Development/Kernel			\
Provides:	%{kname}-devel = %{kverrel} 		\
Provides:	%{kname}-%{1}-devel			\
%ifarch %{ix86}						\
Conflicts:	arch(x86_64)				\
%endif							\
%description -n %{kname}-%{1}-devel-%{buildrel}		\
This package contains the kernel files (headers and build tools) \
that should be enough to build additional drivers for   \
use with %{kname}-%{1}-%{buildrel}.                     \
							\
If you want to build your own kernel, you need to install the full \
%{kname}-source-%{buildrel} rpm.			\
							\
%endif							\
							\
%if %build_debug					\
%package -n	%{kname}-%{1}-%{buildrel}-debug		\
Version:	%{fakever}				\
Release:	%{fakerel}				\
Summary:	Files with debug info for %{kname}-%{1}-%{buildrel} \
Group:		Development/Debug			\
Provides:	kernel-debug = %{kverrel} 		\
%ifarch %{ix86}						\
Conflicts:	arch(x86_64)				\
%endif							\
%description -n %{kname}-%{1}-%{buildrel}-debug		\
This package contains the files with debug info to aid in debug tasks \
when using %{kname}-%{1}-%{buildrel}.			\
							\
If you need to look at debug information or use some application that \
needs debugging info from the kernel, this package may help. \
							\
%endif							\
							\
%package -n %{kname}-%{1}-latest			\
Version:	%{kversion}				\
Release:	%{rpmrel}				\
Summary:	Virtual rpm for latest %{kname}-%{1}	\
Group:		System/Kernel and hardware		\
Requires:	%{kname}-%{1}-%{buildrel}		\
%ifarch %{ix86}						\
Conflicts:	arch(x86_64)				\
%endif							\
%{expand:%%{?latest_obsoletes_%{1}:Obsoletes: %{latest_obsoletes_%{1}}}} \
%{expand:%%{?latest_provides_%{1}:Provides: %{latest_provides_%{1}}}} \
%description -n %{kname}-%{1}-latest			\
This package is a virtual rpm that aims to make sure you always have the \
latest %{kname}-%{1} installed...			\
							\
%if %build_devel					\
%package -n %{kname}-%{1}-devel-latest			\
Version:	%{kversion}				\
Release:	%{rpmrel}				\
Summary:	Virtual rpm for latest %{kname}-%{1}-devel \
Group:		Development/Kernel			\
Requires:	%{kname}-%{1}-devel-%{buildrel}		\
%ifarch %{ix86}						\
Conflicts:	arch(x86_64)				\
%endif							\
Provides:	%{kname}-devel-latest			\
%{expand:%%{?latest_obsoletes_devel_%{1}:Obsoletes: %{latest_obsoletes_devel_%{1}}}} \
%{expand:%%{?latest_provides_devel_%{1}:Provides: %{latest_provides_devel_%{1}}}} \
%description -n %{kname}-%{1}-devel-latest		\
This package is a virtual rpm that aims to make sure you always have the \
latest %{kname}-%{1}-devel installed...			\
							\
%endif							\
							\
%post -n %{kname}-%{1}-%{buildrel} -f kernel_files.%{1}-post \
%posttrans -n %{kname}-%{1}-%{buildrel} -f kernel_files.%{1}-posttrans \
%preun -n %{kname}-%{1}-%{buildrel} -f kernel_files.%{1}-preun \
%postun -n %{kname}-%{1}-%{buildrel} -f kernel_files.%{1}-postun \
							\
%if %build_devel					\
%post -n %{kname}-%{1}-devel-%{buildrel} -f kernel_devel_files.%{1}-post \
%preun -n %{kname}-%{1}-devel-%{buildrel} -f kernel_devel_files.%{1}-preun \
%postun -n %{kname}-%{1}-devel-%{buildrel} -f kernel_devel_files.%{1}-postun \
%endif							\
							\
%files -n %{kname}-%{1}-%{buildrel} -f kernel_files.%{1} \
%files -n %{kname}-%{1}-latest				\
							\
%if %build_devel					\
%files -n %{kname}-%{1}-devel-%{buildrel} -f kernel_devel_files.%{1} \
%files -n %{kname}-%{1}-devel-latest			\
%endif							\
							\
%if %build_debug					\
%files -n %{kname}-%{1}-%{buildrel}-debug -f kernel_debug_files.%{1} \
%endif

%ifarch %{ix86}
#
# kernel-desktop586: i586, smp-alternatives, 4GB
#
%if %build_desktop586
%define summary_desktop586 Linux kernel for desktop use with i586 & 4GB RAM
%define info_desktop586 This kernel is compiled for desktop use, single or \
multiple i586 processor(s)/core(s) and less than 4GB RAM, using HZ_1000, \
voluntary preempt, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%mkflavour desktop586
%endif
%endif

#
# kernel-desktop: i686, smp-alternatives, 4 GB / x86_64
#
%if %build_desktop
%ifarch %{ix86}
%define summary_desktop Linux Kernel for desktop use with i686 & 4GB RAM
%define info_desktop This kernel is compiled for desktop use, single or \
multiple i686 processor(s)/core(s) and less than 4GB RAM, using HZ_1000, \
voluntary preempt, CFS cpu scheduler and cfq i/o scheduler.
%else
%define summary_desktop Linux Kernel for desktop use with %{_arch}
%define info_desktop This kernel is compiled for desktop use, single or \
multiple %{_arch} processor(s)/core(s), using HZ_1000, \
voluntary preempt, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%endif
%mkflavour desktop
%endif

#
# kernel-netbook: i686, smp-alternatives, 4 GB / x86_64
#
%if %build_netbook
%ifarch %{ix86}
%define summary_netbook Linux Kernel for netbook use with i686 & 4GB RAM
%define info_netbook This kernel is compiled for netbook use, single or \
multiple i686 processor(s)/core(s) and less than 4GB RAM, using HZ_250, \
voluntary preempt, CFS cpu scheduler and cfq i/o scheduler.
%else
%define summary_netbook Linux Kernel for netbook use with %{_arch}
%define info_netbook This kernel is compiled for netbook use, single or \
multiple %{_arch} processor(s)/core(s), using HZ_250, \
voluntary preempt, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%endif
%mkflavour netbook
%endif

#
# kernel-server: i686, smp-alternatives, 64 GB / x86_64
#
%if %build_server
%ifarch %{ix86}
%define summary_server Linux Kernel for server use with i686 & 64GB RAM
%define info_server This kernel is compiled for server use, single or \
multiple i686 processor(s)/core(s) and up to 64GB RAM using PAE, using \
no preempt, HZ_100, CFS cpu scheduler and cfq i/o scheduler, PERFORMANCE governor.
%else
%define summary_server Linux Kernel for server use with %{_arch}
%define info_server This kernel is compiled for server use, single or \
multiple %{_arch} processor(s)/core(s), using no preempt, HZ_100, \
CFS cpu scheduler and cfq i/o scheduler, PERFORMANCE governor.
%endif
%mkflavour server
%endif

%ifarch %{ix86}
#
# kernel-desktop-pae: i686, smp-alternatives, 64GB
#
%if %build_desktop_pae
%define summary_desktop_pae Linux kernel for desktop use with i686 & upto 64GB RAM
%define info_desktop_pae This kernel is compiled for desktop use, single or \
multiple i686 processor(s)/core(s) and up to 64GB RAM using PAE, using HZ_1000, \
voluntary preempt, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%mkflavour desktop-pae
%endif
%endif

%ifarch %{ix86}
#
# kernel-netbook-pae: i686, smp-alternatives, 64 GB
#
%if %build_netbook_pae
%define summary_netbook_pae Linux Kernel for for netbook use with i686 & upto 64GB RAM
%define info_netbook_pae This kernel is compiled for netbook use, single or \
multiple i686 processor(s)/core(s) and up to 64GB RAM using PAE, using HZ_250, \
voluntary preempt, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%mkflavour netbook-pae
%endif
%endif

%ifarch %{ix86}
#
# kernel-nrj-desktop586: nrj, i586, smp-alternatives, 4GB
#
%if %build_nrj_desktop586
%define summary_nrj_desktop586 Linux kernel for desktop use with i586 & 4GB RAM
%define info_nrj_desktop586 This kernel is compiled for desktop use, single or \
multiple i586 processor(s)/core(s) and less than 4GB RAM, using HZ_1000, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%mkflavour nrj-desktop586
%endif
%endif

#
# kernel-nrj-desktop: nrj, i686, smp-alternatives, 4 GB / x86_64
#
%if %build_nrj_desktop
%ifarch %{ix86}
%define summary_nrj_desktop Linux Kernel for desktop use with i686 & 4GB RAM
%define info_nrj_desktop This kernel is compiled for desktop use, single or \
multiple i686 processor(s)/core(s) and less than 4GB RAM, using HZ_1000, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%else
%define summary_nrj_desktop Linux Kernel for desktop use with %{_arch}
%define info_nrj_desktop This kernel is compiled for desktop use, single or \
multiple %{_arch} processor(s)/core(s), using HZ_1000, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%endif
%mkflavour nrj-desktop
%endif

#
# kernel-nrj-realtime: nrj, i686, smp-alternatives, 4 GB / x86_64
#
%if %build_nrj_realtime
%ifarch %{ix86}
%define summary_nrj_realtime Linux Kernel for low latency use with i686 & 4GB RAM
%define info_nrj_realtime This kernel is compiled for low latency use, single or \
multiple i686 processor(s)/core(s) and less than 4GB RAM, using HZ_1000, \
full preempt, rcu boost, CFS cpu scheduler and new BFQ I/O scheduler, PERFORMANCE governor.
%else
%define summary_nrj_realtime Linux Kernel for low latency use with %{_arch}
%define info_nrj_realtime This kernel is compiled for low latency use, single or \
multiple %{_arch} processor(s)/core(s), using HZ_1000, \
full preempt, rcu boost, CFS cpu scheduler and new BFQ I/O scheduler, PERFORMANCE governor.
%endif
%mkflavour nrj-realtime
%endif

#
# kernel-nrj-laptop: nrj, i686, smp-alternatives, 4 GB / x86_64
#
%if %build_nrj_laptop
%ifarch %{ix86}
%define summary_nrj_laptop Linux Kernel for laptop use with i686 & 4GB RAM
%define info_nrj_laptop This kernel is compiled for laptop use, single or \
multiple i686 processor(s)/core(s) and less than 4GB RAM, using HZ_300, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%else
%define summary_nrj_laptop Linux Kernel for laptop use with %{_arch}
%define info_nrj_laptop This kernel is compiled for laptop use, single or \
multiple %{_arch} processor(s)/core(s), using HZ_300, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%endif
%mkflavour nrj-laptop
%endif

#
# kernel-nrj-netbook: nrj, i686, smp-alternatives, 4 GB / x86_64
#
%if %build_nrj_netbook
%ifarch %{ix86}
%define summary_nrj_netbook Linux Kernel for netbook use with i686 & 4GB RAM
%define info_nrj_netbook This kernel is compiled for netbook use, single or \
multiple i686 processor(s)/core(s) and less than 4GB RAM, using HZ_250, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%else
%define summary_nrj_netbook Linux Kernel for netbook use with %{_arch}
%define info_nrj_netbook This kernel is compiled for netbook use, single or \
multiple %{_arch} processor(s)/core(s), using HZ_250, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%endif
%mkflavour nrj-netbook
%endif

%ifarch %{ix86}
#
# kernel-nrj-desktop-pae: nrj, i686, smp-alternatives, 64GB
#
%if %build_nrj_desktop_pae
%define summary_nrj_desktop_pae Linux kernel for desktop use with i686 & upto 64GB RAM
%define info_nrj_desktop_pae This kernel is compiled for desktop use, single or \
multiple i686 processor(s)/core(s) and up to 64GB RAM using PAE, using HZ_1000, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%mkflavour nrj-desktop-pae
%endif
%endif

%ifarch %{ix86}
#
# kernel-nrj-realtime-pae: nrj, i686, smp-alternatives, 64GB
#
%if %build_nrj_realtime_pae
%define summary_nrj_realtime_pae Linux kernel for low latency use with i686 & upto 64GB RAM
%define info_nrj_realtime_pae This kernel is compiled for low latency use, single or \
multiple i686 processor(s)/core(s) and up to 64GB RAM using PAE, using HZ_1000, \
full preempt, rcu boost, CFS cpu scheduler and new BFQ I/O scheduler, PERFORMANCE governor.
%mkflavour nrj-realtime-pae
%endif
%endif

%ifarch %{ix86}
#
# kernel-nrj-laptop-pae: nrj, i686, smp-alternatives, 64 GB
#
%if %build_nrj_laptop_pae
%define summary_nrj_laptop_pae Linux Kernel for for laptop use with i686 & upto 64GB RAM
%define info_nrj_laptop_pae This kernel is compiled for laptop use, single or \
multiple i686 processor(s)/core(s) and up to 64GB RAM using PAE, using HZ_300, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%mkflavour nrj-laptop-pae
%endif
%endif

%ifarch %{ix86}
#
# kernel-nrj-netbook-pae: nrj, i686, smp-alternatives, 64 GB
#
%if %build_nrj_netbook_pae
%define summary_nrj_netbook_pae Linux Kernel for for netbook use with i686 & upto 64GB RAM
%define info_nrj_netbook_pae This kernel is compiled for netbook use, single or \
multiple i686 processor(s)/core(s) and up to 64GB RAM using PAE, using HZ_250, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%mkflavour nrj-netbook-pae
%endif
%endif

%ifarch %{ix86}
#
# kernel-nrj-netbook-atom: nrj, for Intel Atom cpu, smp-alternatives, 4 GB
#
%if %build_nrj_netbook_atom
%define summary_nrj_netbook_atom Linux Kernel for netbook use with Intel Atom cpu, less than 4GB RAM
%define info_nrj_netbook_atom This kernel is compiled for netbook use, single or \
multiple Intel Atom cpu processor(s)/core(s) and less than 4GB RAM, using HZ_250, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%mkflavour nrj-netbook-atom
%endif
%endif

%ifarch %{ix86}
#
# kernel-nrj-netbook-atom-pae: nrj, for Intel Atom cpu, smp-alternatives, 64 GB
#
%if %build_nrj_netbook_atom_pae
%define summary_nrj_netbook_atom_pae Linux Kernel for netbook use with Intel Atom cpu & upto 64GB RAM
%define info_nrj_netbook_atom_pae This kernel is compiled for netbook use, single or \
multiple Intel Atom cpu processor(s)/core(s) and up to 64GB RAM using PAE, using HZ_250, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%mkflavour nrj-netbook-atom-pae
%endif
%endif

%ifarch %{ix86}
#
# kernel-nrj-desktop-core2: nrj, Intel Core 2 and newer, smp-alternatives, 4 GB 
#
%if %build_nrj_desktop_core2
%define summary_nrj_desktop_core2 Linux Kernel for desktop use with i686 & 4GB RAM
%define info_nrj_desktop_core2 This kernel is compiled for desktop use, single or \
multiple Intel Core 2 and newer processor(s)/core(s) and less than 4GB RAM, using HZ_1000, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%mkflavour nrj-desktop-core2
%endif
%endif

%ifarch %{ix86}
#
# kernel-nrj-desktop-core2-pae: nrj, Intel Core 2 and newer, smp-alternatives, 64 GB
#
%if %build_nrj_desktop_core2_pae
%define summary_nrj_desktop_core2_pae Linux Kernel for desktop use with i686 & upto 64GB RAM
%define info_nrj_desktop_core2_pae This kernel is compiled for desktop use, single or \
multiple Intel Core 2 and newer processor(s)/core(s) and up to 64GB RAM using PAE, using HZ_1000, \
full preempt, rcu boost, CFS cpu scheduler and cfq i/o scheduler, ONDEMAND governor.
%mkflavour nrj-desktop-core2-pae
%endif
%endif

#
# ARM kernels
#
%ifarch %{arm}
%if %build_iop32x
%define summary_iop32x Linux Kernel for Arm machines based on Xscale IOP32X
%define info_iop32x This kernel is compiled for iop32x boxes. It will run on n2100 \
or ss4000e or sanmina boards.
%mkflavour iop32x
%endif
%if %build_kirkwood
%define summary_kirkwood Linux Kernel for Arm machines based on Kirkwood
%define info_kirkwood This kernel is compiled for kirkwood boxes. It will run on openrd boards.
%mkflavour kirkwood
%endif
%if %build_versatile
%define summary_versatile Linux Kernel for Versatile arm machines
%define info_versatile This kernel is compiled for Versatile boxes. It will run on Qemu for instance.
%mkflavour versatile
%endif
%endif

#
# kernel-source
#
%if %build_source
%package -n %{kname}-source-%{buildrel}
Version: 	%{fakever}
Release: 	%{fakerel}
Requires: 	glibc-devel, ncurses-devel, make, gcc, perl, diffutils
Summary: 	The Linux source code for %{kname}-%{buildrel}
Group: 		Development/Kernel
Autoreqprov: 	no
Provides: 	kernel-source = %{kverrel}
Buildarch:	noarch

%description -n %{kname}-source-%{buildrel}
The %{kname}-source package contains the source code files for the Mandriva and
ROSA kernel. Theese source files are only needed if you want to build your
own custom kernel that is better tuned to your particular hardware.

If you only want the files needed to build 3rdparty (nVidia, Ati, dkms-*,...)
drivers against, install the *-devel-* rpm that is matching your kernel.

%post -n %{kname}-source-%{buildrel}
for i in /lib/modules/%{kversion}-{desktop586,desktop,netbook,server,desktop-pae,netbook-pae,nrj-desktop586,nrj-desktop,nrj-realtime,nrj-laptop,nrj-netbook,nrj-desktop-pae,nrj-realtime-pae,nrj-laptop-pae,nrj-netbook-pae,nrj-netbook-atom,nrj-netbook-atom-pae,nrj-desktop-core2,nrj-desktop-core2-pae}-%{buildrpmrel}; do
        if [ -d $i ]; then
		if [ ! -L $i/build -a ! -L $i/source ]; then
			ln -sf /usr/src/linux-%{kversion}-%{buildrpmrel} $i/build
			ln -sf /usr/src/linux-%{kversion}-%{buildrpmrel} $i/source
		fi
        fi
done
cd /usr/src
rm -f linux
ln -snf linux-%{kversion}-%{buildrpmrel} linux

%preun -n %{kname}-source-%{buildrel}
for i in /lib/modules/%{kversion}-{desktop586,desktop,netbook,server,desktop-pae,netbook-pae,nrj-desktop586,nrj-desktop,nrj-realtime,nrj-laptop,nrj-netbook,nrj-desktop-pae,nrj-realtime-pae,nrj-laptop-pae,nrj-netbook-pae,nrj-netbook-atom,nrj-netbook-atom-pae,nrj-desktop-core2,nrj-desktop-core2-pae}-%{buildrpmrel}/{build,source}; do
	if [ -L $i ]; then
		if [ "$(readlink $i)" = "/usr/src/linux-%{kversion}-%{buildrpmrel}" ]; then
			rm -f $i
		fi
	fi
done
if [ -L /usr/src/linux ]; then
	if [ "$(readlink /usr/src/linux)" = "linux-%{kversion}-%{buildrpmrel}" ]; then
		rm -f /usr/src/linux
	fi
fi
exit 0

#
# kernel-source-latest: virtual rpm
#
%package -n %{kname}-source-latest
Version: 	%{kversion}
Release: 	%{rpmrel}
Summary: 	Virtual rpm for latest %{kname}-source
Group:   	Development/Kernel
Requires: 	%{kname}-source-%{buildrel}
Buildarch:	noarch

%description -n %{kname}-source-latest
This package is a virtual rpm that aims to make sure you always have the
latest %{kname}-source installed...
%endif

#
# kernel-doc: documentation for the Linux kernel
#
%if %build_doc
%package -n %{kname}-doc
Version: 	%{kversion}
Release: 	%{rpmrel}
Summary: 	Various documentation bits found in the %{kname} source
Group: 		Documentation
Buildarch:	noarch

%description -n %{kname}-doc
This package contains documentation files from the %{kname} source.
Various bits of information about the Linux kernel and the device drivers
shipped with it are documented in these files. You also might want install
this package if you need a reference to the options that can be passed to
Linux kernel modules at load time.
%endif

#
# kernel/tools
#
%if %{build_perf}
%package -n perf
Version:	%{kversion}
Release:	%{rpmrel}
Summary:	perf tool and the supporting documentation
Group:		System/Kernel and hardware

%description -n perf
the perf tool and the supporting documentation.
%endif

%if %{build_cpupower}
%package -n cpupower
Version:	%{kversion}
Release:	%{rpmrel}
Summary:	the cpupower tools
Group:		System/Kernel and hardware
Requires(post):  rpm-helper >= 0.24.0-3
Requires(preun): rpm-helper >= 0.24.0-3
%if %{mdvver} >= 201200
Obsoletes:	cpufreq cpufrequtils
%endif

%description -n cpupower
the cpupower tools.

%post -n cpupower
%_post_service cpupower

%preun -n cpupower
%_preun_service cpupower

%package -n cpupower-devel
Version:	%{kversion}
Release:	%{rpmrel}
Summary:	devel files for cpupower
Group:		Development/Kernel
Requires:	cpupower = %{kversion}-%{rpmrel}
Conflicts:	%{_lib}cpufreq-devel

%description -n cpupower-devel
This package contains the development files for cpupower.
%endif


#
# End packages - here begins build stage
#
%prep
%setup -q -n %top_dir_name -c
%setup -q -n %top_dir_name -D -T -a100

%define patches_dir ../%{patch_ver}/

cd %src_dir

%if %sublevel
%if %kpatch
%if %prev_sublevel
%patch1 -p1
%endif
%patch2 -p1
%else
%patch1 -p1
%endif
%else
%if %kpatch
%patch1 -p1
%endif
%endif
%if %kgit
%patch2 -p1
%endif
%if %build_for_magos
%patch101 -p1 -d %{patches_dir}
%patch102 -p1
cp -pf "%{patches_dir}queue/new for %{kversion}/AUFS3/aufs3-%{aufs_version}.patch"            %{patches_dir}patchesQL/AU01_aufs3-%{aufs_version}.patch
cp -pf "%{patches_dir}queue/new for %{kversion}/AUFS3/aufs3-base-%{aufs_version}.patch"       %{patches_dir}patchesQL/AU02_aufs3-base-%{aufs_version}.patch
cp -pf "%{patches_dir}queue/new for %{kversion}/AUFS3/aufs3-kbuild-%{aufs_version}.patch"     %{patches_dir}patchesQL/AU03_aufs3-kbuild-%{aufs_version}.patch
cp -pf "%{patches_dir}queue/new for %{kversion}/AUFS3/aufs3-loopback-%{aufs_version}.patch"   %{patches_dir}patchesQL/AU04_aufs3-loopback-%{aufs_version}.patch
cp -pf "%{patches_dir}queue/new for %{kversion}/AUFS3/aufs3-proc_map-%{aufs_version}.patch"   %{patches_dir}patchesQL/AU05_aufs3-proc_map-%{aufs_version}.patch
cp -pf "%{patches_dir}queue/new for %{kversion}/AUFS3/aufs3-standalone-%{aufs_version}.patch" %{patches_dir}patchesQL/AU06_aufs3-standalone-%{aufs_version}.patch
%endif

%{patches_dir}/scripts/apply_patchesQL
%{patches_dir}/scripts/apply_patches

# PATCH END


#
# Setup Begin
#

# Prepare all the variables for calling create_configs

%if %build_debug
%define debug --debug
%else
%define debug --no-debug
%endif


%{patches_dir}/scripts/create_configs %debug --user_cpu="%{target_arch}"

# make sure the kernel has the sublevel we know it has...
LC_ALL=C perl -p -i -e "s/^SUBLEVEL.*/SUBLEVEL = %{sublevel}/" Makefile

# get rid of unwanted files
find . -name '*~' -o -name '*.orig' -o -name '*.append' | %kxargs rm -f


%build
# Common target directories
%define _kerneldir /usr/src/linux-%{kversion}-%{buildrpmrel}
%define _bootdir /boot
%define _modulesdir /lib/modules
%define _efidir %{_bootdir}/efi/mandriva

# Directories definition needed for building
%define temp_root %{build_dir}/temp-root
%define temp_source %{temp_root}%{_kerneldir}
%define temp_boot %{temp_root}%{_bootdir}
%define temp_modules %{temp_root}%{_modulesdir}

PrepareKernel() {
	name=$1
	extension=$2
	x86_dir=arch/x86/configs

	echo "Make config for kernel $extension"

	%smake -s mrproper

	if [ "%{target_arch}" == "i386" -o "%{target_arch}" == "x86_64" ]; then
	    if [ -z "$name" ]; then
		cp ${x86_dir}/%{target_arch}_defconfig-desktop .config
	    else
		cp ${x86_dir}/%{target_arch}_defconfig-$name .config
	    fi
	else
	    if [ -z "$name" ]; then
		cp arch/%{target_arch}/defconfig-desktop .config
	    else
		cp arch/%{target_arch}/defconfig-$name .config
	    fi
	fi

	# make sure EXTRAVERSION says what we want it to say
	LC_ALL=C perl -p -i -e "s/^EXTRAVERSION.*/EXTRAVERSION = -$extension/" Makefile

	%smake oldconfig
}

BuildKernel() {
	KernelVer=$1

	echo "Building kernel $KernelVer"

	%kmake -s all

	# kirkwood boxes have u-boot
	if [ "$KernelVer" = "%{kversion}-kirkwood-%{buildrpmrel}" ]; then
		%kmake uImage
	fi

	# Start installing stuff
	install -d %{temp_boot}
	install -m 644 System.map %{temp_boot}/System.map-$KernelVer
	install -m 644 .config %{temp_boot}/config-$KernelVer
	xz -c Module.symvers > %{temp_boot}/symvers-$KernelVer.xz

	%ifarch %{arm}
		if [ -f arch/arm/boot/uImage ]; then
			cp -f arch/arm/boot/uImage %{temp_boot}/uImage-$KernelVer
		else
			cp -f arch/arm/boot/zImage %{temp_boot}/vmlinuz-$KernelVer
		fi
	%else
		cp -f arch/%{target_arch}/boot/bzImage %{temp_boot}/vmlinuz-$KernelVer
	%endif

	# modules
	install -d %{temp_modules}/$KernelVer
	%smake INSTALL_MOD_PATH=%{temp_root} KERNELRELEASE=$KernelVer modules_install

	# remove /lib/firmware, we use a separate kernel-firmware
	rm -rf %{temp_root}/lib/firmware
}

SaveDevel() {
	devel_flavour=$1

	DevelRoot=/usr/src/linux-%{kversion}-$devel_flavour-%{buildrpmrel}
	TempDevelRoot=%{temp_root}$DevelRoot

	mkdir -p $TempDevelRoot
	for i in $(find . -name 'Makefile*'); do cp -R --parents $i $TempDevelRoot;done
	for i in $(find . -name 'Kconfig*' -o -name 'Kbuild*'); do cp -R --parents $i $TempDevelRoot;done
	cp -fR include $TempDevelRoot
	cp -fR scripts $TempDevelRoot
	cp -fR kernel/bounds.c $TempDevelRoot/kernel
	cp -fR tools/include $TempDevelRoot/tools/
	%ifarch %{arm}
		cp -fR arch/%{target_arch}/tools $TempDevelRoot/arch/%{target_arch}/
	%endif
	%ifarch %{ix86} x86_64
		cp -fR arch/x86/kernel/asm-offsets.{c,s} $TempDevelRoot/arch/x86/kernel/
		cp -fR arch/x86/kernel/asm-offsets_{32,64}.c $TempDevelRoot/arch/x86/kernel/
		cp -fR arch/x86/syscalls/syscall* $TempDevelRoot/arch/x86/syscalls/
		cp -fR arch/x86/include $TempDevelRoot/arch/x86/
		cp -fR arch/x86/tools/relocs.c $TempDevelRoot/arch/x86/tools/
	%else
		cp -fR arch/%{target_arch}/kernel/asm-offsets.{c,s} $TempDevelRoot/arch/%{target_arch}/kernel/
		for f in $(find arch/%{target_arch} -name include); do cp -fR --parents $f $TempDevelRoot; done
	%endif
	cp -fR .config Module.symvers $TempDevelRoot
	cp -fR 3rdparty/mkbuild.pl $TempDevelRoot/3rdparty

	# Needed for truecrypt build (Danny)
	cp -fR drivers/md/dm.h $TempDevelRoot/drivers/md/

	# Needed for lguest
	cp -fR drivers/lguest/lg.h $TempDevelRoot/drivers/lguest/

	# Needed for lirc_gpio (#39004)
	cp -fR drivers/media/video/bt8xx/bttv{,p}.h $TempDevelRoot/drivers/media/video/bt8xx/
	cp -fR drivers/media/video/bt8xx/bt848.h $TempDevelRoot/drivers/media/video/bt8xx/
	cp -fR drivers/media/video/btcx-risc.h $TempDevelRoot/drivers/media/video/

	# Needed for external dvb tree (#41418)
	cp -fR drivers/media/dvb/dvb-core/*.h $TempDevelRoot/drivers/media/dvb/dvb-core/
	cp -fR drivers/media/dvb/frontends/lgdt330x.h $TempDevelRoot/drivers/media/dvb/frontends/

	# add acpica header files, needed for fglrx build
	cp -fR drivers/acpi/acpica/*.h $TempDevelRoot/drivers/acpi/acpica/

	# aufs2 has a special file needed
	#cp -fR fs/aufs/magic.mk $TempDevelRoot/fs/aufs

	for i in alpha avr32 blackfin c6x cris frv h8300 hexagon ia64 m32r m68k m68knommu microblaze \
		 mips mn10300 openrisc parisc powerpc s390 score sh sparc tile unicore32 xtensa; do
		rm -rf $TempDevelRoot/arch/$i
	done

	%ifnarch %{arm}
		rm -rf $TempDevelRoot/arch/arm
	%endif
	%ifnarch %{ix86} x86_64
		rm -rf $TempDevelRoot/arch/x86
	%endif

	# Clean the scripts tree, and make sure everything is ok (sanity check)
	# running prepare+scripts (tree was already "prepared" in build)
	pushd $TempDevelRoot >/dev/null
		%smake -s prepare scripts
		%smake -s clean
	popd >/dev/null
	rm -f $TempDevelRoot/.config.old

	# fix permissions
	chmod -R a+rX $TempDevelRoot

	# disable mrproper in -devel rpms
	patch -p1 --fuzz=0 -d $TempDevelRoot -i %{SOURCE2}

	kernel_devel_files=../kernel_devel_files.$devel_flavour


### Create the kernel_devel_files.*
cat > $kernel_devel_files <<EOF
%dir $DevelRoot
%dir $DevelRoot/arch
%dir $DevelRoot/include
$DevelRoot/3rdparty
$DevelRoot/Documentation
%ifarch %{arm}
$DevelRoot/arch/arm
%endif
$DevelRoot/arch/um
%ifarch %{ix86} x86_64
$DevelRoot/arch/x86
%endif
$DevelRoot/block
$DevelRoot/crypto
$DevelRoot/drivers
$DevelRoot/firmware
$DevelRoot/fs
$DevelRoot/include/Kbuild
$DevelRoot/include/acpi
$DevelRoot/include/asm-generic
$DevelRoot/include/config
$DevelRoot/include/crypto
$DevelRoot/include/drm
$DevelRoot/include/generated
$DevelRoot/include/keys
$DevelRoot/include/linux
$DevelRoot/include/math-emu
$DevelRoot/include/media
$DevelRoot/include/memory
$DevelRoot/include/misc
$DevelRoot/include/mtd
$DevelRoot/include/net
$DevelRoot/include/pcmcia
$DevelRoot/include/ras
$DevelRoot/include/rdma
$DevelRoot/include/rxrpc
$DevelRoot/include/scsi
$DevelRoot/include/sound
$DevelRoot/include/target
$DevelRoot/include/trace
$DevelRoot/include/video
$DevelRoot/include/xen
$DevelRoot/init
$DevelRoot/ipc
$DevelRoot/kernel
$DevelRoot/lib
$DevelRoot/mm
$DevelRoot/net
$DevelRoot/samples
$DevelRoot/scripts
$DevelRoot/security
$DevelRoot/sound
$DevelRoot/tools
$DevelRoot/usr
$DevelRoot/virt
$DevelRoot/.config
$DevelRoot/Kbuild
$DevelRoot/Kconfig
$DevelRoot/Makefile
$DevelRoot/Module.symvers
$DevelRoot/arch/Kconfig
%doc README.kernel-sources
EOF


### Create -devel Post script on the fly
cat > $kernel_devel_files-post <<EOF
if [ -d /lib/modules/%{kversion}-$devel_flavour-%{buildrpmrel} ]; then
	rm -f /lib/modules/%{kversion}-$devel_flavour-%{buildrpmrel}/{build,source}
	ln -sf $DevelRoot /lib/modules/%{kversion}-$devel_flavour-%{buildrpmrel}/build
	ln -sf $DevelRoot /lib/modules/%{kversion}-$devel_flavour-%{buildrpmrel}/source
fi
EOF


### Create -devel Preun script on the fly
cat > $kernel_devel_files-preun <<EOF
if [ -L /lib/modules/%{kversion}-$devel_flavour-%{buildrpmrel}/build ]; then
	rm -f /lib/modules/%{kversion}-$devel_flavour-%{buildrpmrel}/build
fi
if [ -L /lib/modules/%{kversion}-$devel_flavour-%{buildrpmrel}/source ]; then
	rm -f /lib/modules/%{kversion}-$devel_flavour-%{buildrpmrel}/source
fi
exit 0
EOF

### Create -devel Postun script on the fly
cat > $kernel_devel_files-postun <<EOF
rm -rf /usr/src/linux-%{kversion}-$devel_flavour-%{buildrpmrel} >/dev/null
EOF
}

SaveDebug() {
	debug_flavour=$1

	install -m 644 vmlinux \
	      %{temp_boot}/vmlinux-%{kversion}-$debug_flavour-%{buildrpmrel}
	kernel_debug_files=../kernel_debug_files.$debug_flavour
	echo "%{_bootdir}/vmlinux-%{kversion}-$debug_flavour-%{buildrpmrel}" \
		>> $kernel_debug_files

	find %{temp_modules}/%{kversion}-$debug_flavour-%{buildrpmrel}/kernel \
		-name "*.ko" | \
		%kxargs -I '{}' objcopy --only-keep-debug '{}' '{}'.debug
	find %{temp_modules}/%{kversion}-$debug_flavour-%{buildrpmrel}/kernel \
		-name "*.ko" | %kxargs -I '{}' \
		sh -c 'cd `dirname {}`; \
		       objcopy --add-gnu-debuglink=`basename {}`.debug \
		       --strip-debug `basename {}`'

	pushd %{temp_modules}
	find %{kversion}-$debug_flavour-%{buildrpmrel}/kernel \
		-name "*.ko.debug" > debug_module_list
	popd
	cat %{temp_modules}/debug_module_list | \
		sed 's|\(.*\)|%{_modulesdir}/\1|' >> $kernel_debug_files
	cat %{temp_modules}/debug_module_list | \
		sed 's|\(.*\)|%exclude %{_modulesdir}/\1|' \
		>> ../kernel_exclude_debug_files.$debug_flavour
	rm -f %{temp_modules}/debug_module_list
}

CreateFiles() {
	kernel_flavour=$1

	kernel_files=../kernel_files.$kernel_flavour

ker="vmlinuz"
if [ "$kernel_flavour" = "kirkwood" ]; then
       ker="uImage"
fi
### Create the kernel_files.*
cat > $kernel_files <<EOF
%{_bootdir}/System.map-%{kversion}-$kernel_flavour-%{buildrpmrel}
%{_bootdir}/symvers-%{kversion}-$kernel_flavour-%{buildrpmrel}.xz
%{_bootdir}/config-%{kversion}-$kernel_flavour-%{buildrpmrel}
%{_bootdir}/$ker-%{kversion}-$kernel_flavour-%{buildrpmrel}
%dir %{_modulesdir}/%{kversion}-$kernel_flavour-%{buildrpmrel}/
%{_modulesdir}/%{kversion}-$kernel_flavour-%{buildrpmrel}/kernel
%{_modulesdir}/%{kversion}-$kernel_flavour-%{buildrpmrel}/modules.*
%doc README.kernel-sources
EOF

%if %build_debug
    cat ../kernel_exclude_debug_files.$kernel_flavour >> $kernel_files
%endif

### Create kernel Post script
cat > $kernel_files-post <<EOF
%ifarch %{arm}
/sbin/installkernel -i -N %{kversion}-$kernel_flavour-%{buildrpmrel}
%else
/sbin/installkernel %{kversion}-$kernel_flavour-%{buildrpmrel}
pushd /boot > /dev/null
if [ -L vmlinuz-$kernel_flavour ]; then
	rm -f vmlinuz-$kernel_flavour
fi
ln -sf vmlinuz-%{kversion}-$kernel_flavour-%{buildrpmrel} vmlinuz-$kernel_flavour
if [ -L initrd-$kernel_flavour.img ]; then
	rm -f initrd-$kernel_flavour.img
fi
ln -sf initrd-%{kversion}-$kernel_flavour-%{buildrpmrel}.img initrd-$kernel_flavour.img
popd > /dev/null
%endif
%if %build_devel
# create kernel-devel symlinks if matching -devel- rpm is installed
if [ -d /usr/src/linux-%{kversion}-$kernel_flavour-%{buildrpmrel} ]; then
	rm -f /lib/modules/%{kversion}-$kernel_flavour-%{buildrpmrel}/{build,source}
	ln -sf /usr/src/linux-%{kversion}-$kernel_flavour-%{buildrpmrel} /lib/modules/%{kversion}-$kernel_flavour-%{buildrpmrel}/build
	ln -sf /usr/src/linux-%{kversion}-$kernel_flavour-%{buildrpmrel} /lib/modules/%{kversion}-$kernel_flavour-%{buildrpmrel}/source
fi
%endif
%if %build_source
# create kernel-source symlinks only if matching -devel- rpm is not installed
if [ -d /usr/src/linux-%{kversion}-%{buildrpmrel} -a ! -d /usr/src/linux-%{kversion}-$kernel_flavour-%{buildrpmrel} ]; then
	rm -f /lib/modules/%{kversion}-$kernel_flavour-%{buildrpmrel}/{build,source}
	ln -sf /usr/src/linux-%{kversion}-%{buildrpmrel} /lib/modules/%{kversion}-$kernel_flavour-%{buildrpmrel}/build
	ln -sf /usr/src/linux-%{kversion}-%{buildrpmrel} /lib/modules/%{kversion}-$kernel_flavour-%{buildrpmrel}/source
fi
%endif
EOF

### Create kernel Posttrans script
cat > $kernel_files-posttrans <<EOF
if [ -x /usr/sbin/dkms_autoinstaller -a -d /usr/src/linux-%{kversion}-$kernel_flavour-%{buildrpmrel} ]; then
    /usr/sbin/dkms_autoinstaller start %{kversion}-$kernel_flavour-%{buildrpmrel}
fi
EOF

### Create kernel Preun script on the fly
cat > $kernel_files-preun <<EOF
/sbin/installkernel -R %{kversion}-$kernel_flavour-%{buildrpmrel}
pushd /boot > /dev/null
if [ -L vmlinuz-$kernel_flavour ]; then
	if [ "$(readlink vmlinuz-$kernel_flavour)" = "vmlinuz-%{kversion}-$kernel_flavour-%{buildrpmrel}" ]; then
		rm -f vmlinuz-$kernel_flavour
	fi
fi
if [ -L initrd-$kernel_flavour.img ]; then
	if [ "$(readlink initrd-$kernel_flavour.img)" = "initrd-%{kversion}-$kernel_flavour-%{buildrpmrel}.img" ]; then
		rm -f initrd-$kernel_flavour.img
	fi
fi
popd > /dev/null
%if %build_devel
if [ -L /lib/modules/%{kversion}-$kernel_flavour-%{buildrpmrel}/build ]; then
	rm -f /lib/modules/%{kversion}-$kernel_flavour-%{buildrpmrel}/build
fi
if [ -L /lib/modules/%{kversion}-$kernel_flavour-%{buildrpmrel}/source ]; then
	rm -f /lib/modules/%{kversion}-$kernel_flavour-%{buildrpmrel}/source
fi
%endif
exit 0
EOF


### Create kernel Postun script on the fly
cat > $kernel_files-postun <<EOF
/sbin/kernel_remove_initrd %{kversion}-$kernel_flavour-%{buildrpmrel}
rm -rf /lib/modules/%{kversion}-$kernel_flavour-%{buildrpmrel} >/dev/null
if [ -d /var/lib/dkms ]; then
    rm -f /var/lib/dkms/*/kernel-%{kversion}-$devel_flavour-%{buildrpmrel}-%{_target_cpu} >/dev/null
    rm -rf /var/lib/dkms/*/*/%{kversion}-$devel_flavour-%{buildrpmrel} >/dev/null
    rm -f /var/lib/dkms-binary/*/kernel-%{kversion}-$devel_flavour-%{buildrpmrel}-%{_target_cpu} >/dev/null
    rm -rf /var/lib/dkms-binary/*/*/%{kversion}-$devel_flavour-%{buildrpmrel} >/dev/null
fi
EOF
}


CreateKernel() {
	flavour=$1

	PrepareKernel $flavour $flavour-%{buildrpmrel}

	BuildKernel %{kversion}-$flavour-%{buildrpmrel}
	%if %build_devel
		SaveDevel $flavour
	%endif
	%if %build_debug
		SaveDebug $flavour
	%endif
	CreateFiles $flavour
}


###
# DO it...
###


# Create a simulacro of buildroot
rm -rf %{temp_root}
install -d %{temp_root}


# make sure we are in the directory
cd %src_dir

%ifarch %{ix86}
%if %build_desktop586
CreateKernel desktop586
%endif
%endif

%if %build_desktop
CreateKernel desktop
%endif

%if %build_netbook
CreateKernel netbook
%endif

%if %build_server
CreateKernel server
%endif

%ifarch %{ix86}
%if %build_desktop_pae
CreateKernel desktop-pae
%endif
%endif

%ifarch %{ix86}
%if %build_netbook_pae
CreateKernel netbook-pae
%endif
%endif

%ifarch %{ix86}
%if %build_nrj_desktop586
CreateKernel nrj-desktop586
%endif
%endif

%if %build_nrj_desktop
CreateKernel nrj-desktop
%endif

%if %build_nrj_realtime
CreateKernel nrj-realtime
%endif

%if %build_nrj_laptop
CreateKernel nrj-laptop
%endif

%if %build_nrj_netbook
CreateKernel nrj-netbook
%endif

%ifarch %{ix86}
%if %build_nrj_desktop_pae
CreateKernel nrj-desktop-pae
%endif
%endif

%ifarch %{ix86}
%if %build_nrj_realtime_pae
CreateKernel nrj-realtime-pae
%endif
%endif

%ifarch %{ix86}
%if %build_nrj_laptop_pae
CreateKernel nrj-laptop-pae
%endif
%endif

%ifarch %{ix86}
%if %build_nrj_netbook_pae
CreateKernel nrj-netbook-pae
%endif
%endif

%ifarch %{ix86}
%if %build_nrj_netbook_atom
CreateKernel nrj-netbook-atom
%endif
%endif

%ifarch %{ix86}
%if %build_nrj_netbook_atom_pae
CreateKernel nrj-netbook-atom-pae
%endif
%endif

%ifarch %{ix86}
%if %build_nrj_desktop_core2
CreateKernel nrj-desktop-core2
%endif
%endif

%ifarch %{ix86}
%if %build_nrj_desktop_core2_pae
CreateKernel nrj-desktop-core2-pae
%endif
%endif

%ifarch %{arm}
%if %build_iop32x
CreateKernel iop32x
%endif
%if %build_kirkwood
CreateKernel kirkwood
%endif
%if %build_versatile
CreateKernel versatile
%endif
%endif

# set extraversion to match srpm to get nice version reported by the tools
LC_ALL=C perl -p -i -e "s/^EXTRAVERSION.*/EXTRAVERSION = -%{rpmrel}/" Makefile
# build perf
%if %{build_perf}
# perf
%make -C tools/perf -s V=1 HAVE_CPLUS_DEMANGLE=1 prefix=%{_prefix} all
%make -C tools/perf -s V=1 prefix=%{_prefix} man
%endif

%if %{build_cpupower}
# cpupower
# make sure version-gen.sh is executable.
chmod +x tools/power/cpupower/utils/version-gen.sh
%make -C tools/power/cpupower CPUFREQ_BENCH=false
%endif

# We don't make to repeat the depend code at the install phase
%if %build_source
%ifarch %{arm}
    PrepareKernel "kirkwood" %{buildrpmrel}custom
%else
    PrepareKernel "" %{buildrpmrel}custom
%endif
%smake -s mrproper
%endif


###
### install
###
%install
install -m 644 %{SOURCE4}  .

cd %src_dir

# Directories definition needed for installing
%define target_source %{buildroot}%{_kerneldir}
%define target_boot %{buildroot}%{_bootdir}
%define target_modules %{buildroot}%{_modulesdir}

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
for i in alpha avr32 blackfin c6x cris frv h8300 hexagon ia64 m32r m68k m68knommu microblaze \
	 mips openrisc parisc powerpc s390 score sh sh64 sparc tile unicore32 v850 xtensa mn10300; do
	rm -rf %{target_source}/arch/$i
done

# other misc files
rm -f %{target_source}/{.config.old,.config.cmd,.gitignore,.lst,.mailmap}
rm -f %{target_source}/{.missing-syscalls.d,arch/.gitignore,firmware/.gitignore}
rm -rf %{target_source}/.tmp_depmod/

#endif %build_source
%endif

# compressing modules
%if %{build_modxz}
find %{target_modules} -name "*.ko" | %kxargs xz -6e
%endif
%if %{build_modgz}
find %{target_modules} -name "*.ko" | %kxargs gzip -9
%endif

# We used to have a copy of PrepareKernel here
# Now, we make sure that the thing in the linux dir is what we want it to be
for i in %{target_modules}/*; do
	rm -f $i/build $i/source
done

# sniff, if we compressed all the modules, we change the stamp :(
# we really need the depmod -ae here
pushd %{target_modules}
for i in *; do
	/sbin/depmod -ae -b %{buildroot} -F %{target_boot}/System.map-$i $i
	echo $?
done

for i in *; do
	pushd $i
	echo "Creating modules.description for $i"
	modules=`find . -name "*.ko.[g,x]z"`
	echo $modules | %kxargs /sbin/modinfo \
	| perl -lne 'print "$name\t$1" if $name && /^description:\s*(.*)/; $name = $1 if m!^filename:\s*(.*)\.k?o!; $name =~ s!.*/!!' > modules.description
	popd
done
popd

# need to set extraversion to match srpm again to avoid rebuild
LC_ALL=C perl -p -i -e "s/^EXTRAVERSION.*/EXTRAVERSION = -%{rpmrel}/" Makefile
%if %{build_perf}
# perf tool binary and supporting scripts/binaries
make -C tools/perf -s V=1 DESTDIR=%{buildroot} HAVE_CPLUS_DEMANGLE=1 prefix=%{_prefix} install

# perf man pages (note: implicit rpm magic compresses them later)
make -C tools/perf  -s V=1 DESTDIR=%{buildroot} HAVE_CPLUS_DEMANGLE=1 prefix=%{_prefix} install-man
%endif

%if %{build_cpupower}
make -C tools/power/cpupower DESTDIR=%{buildroot} libdir=%{_libdir} mandir=%{_mandir} CPUFREQ_BENCH=false install
rm -f %{buildroot}%{_libdir}/*.{a,la}
%find_lang cpupower
mv cpupower.lang ../
chmod 0755 %{buildroot}%{_libdir}/libcpupower.so*
mkdir -p %{buildroot}%{_unitdir} %{buildroot}%{_sysconfdir}/sysconfig
install -m644 %{SOURCE50} %{buildroot}%{_unitdir}/cpupower.service
install -m644 %{SOURCE51} %{buildroot}%{_sysconfdir}/sysconfig/cpupower
%endif

###
### clean
###
%clean
rm -rf %{buildroot}


# We don't want to remove this, the whole reason of its existence is to be
# able to do several rpm --short-circuit -bi for testing install
# phase without repeating compilation phase
#rm -rf %{temp_root}

###
### source and doc file lists
###

%if %build_source
%files -n %{kname}-source-%{buildrel}
%dir %{_kerneldir}
%dir %{_kerneldir}/arch
%dir %{_kerneldir}/include
%{_kerneldir}/3rdparty
%{_kerneldir}/Documentation
%{_kerneldir}/arch/Kconfig
%{_kerneldir}/arch/arm
%{_kerneldir}/arch/um
%{_kerneldir}/arch/x86
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
%{_kerneldir}/include/keys
%{_kerneldir}/include/linux
%{_kerneldir}/include/math-emu
%{_kerneldir}/include/media
%{_kerneldir}/include/memory
%{_kerneldir}/include/misc
%{_kerneldir}/include/mtd
%{_kerneldir}/include/net
%{_kerneldir}/include/pcmcia
%{_kerneldir}/include/ras
%{_kerneldir}/include/rdma
%{_kerneldir}/include/rxrpc
%{_kerneldir}/include/scsi
%{_kerneldir}/include/sound
%{_kerneldir}/include/target
%{_kerneldir}/include/trace
%{_kerneldir}/include/video
%{_kerneldir}/include/xen
%{_kerneldir}/init
%{_kerneldir}/ipc
%{_kerneldir}/kernel
%{_kerneldir}/lib
%{_kerneldir}/mm
%{_kerneldir}/net
%{_kerneldir}/virt
%{_kerneldir}/samples
%{_kerneldir}/scripts
%{_kerneldir}/security
%{_kerneldir}/sound
%{_kerneldir}/tools
%{_kerneldir}/usr
%{_kerneldir}/COPYING
%{_kerneldir}/CREDITS
%{_kerneldir}/Kbuild
%{_kerneldir}/Kconfig
%{_kerneldir}/MAINTAINERS
%{_kerneldir}/Makefile
%{_kerneldir}/README
%{_kerneldir}/REPORTING-BUGS
%doc README.kernel-sources

%files -n %{kname}-source-latest
%endif

%if %build_doc
%files -n %{kname}-doc
%doc linux-%{tar_ver}/Documentation/*
%endif

%if %{build_perf}
%files -n perf
%{_bindir}/perf
%dir %{_prefix}/libexec/perf-core
%{_prefix}/libexec/perf-core/*
%{_mandir}/man[1-8]/perf*
%endif

%if %{build_cpupower}
%files -n cpupower -f cpupower.lang
%{_bindir}/cpupower
%{_libdir}/libcpupower.so.0
%{_libdir}/libcpupower.so.0.0.0
%{_unitdir}/cpupower.service
%{_mandir}/man[1-8]/cpupower*
%config(noreplace) %{_sysconfdir}/sysconfig/cpupower

%files -n cpupower-devel
%{_libdir}/libcpupower.so
%{_includedir}/cpufreq.h
%endif


%changelog

* Tue Nov 20 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.7-1
+ update to 3.6.7-1 (89 fixes all over)
- updated all patches for kernel 3.6.7: AUFS3, OverlayFS, TOI
- re-add cpufreq_ondemand_performance_optimise_default_settings.patch
- small modifies and fixes to "create_configs" and "kernel.spec" files
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

* Mon Nov 05 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.6-1
+ update to 3.6.6-1
- drop FX01_fs-ext4-fix-unjournaled-inode-bitmap-modification.patch,
- because that's already inside patch-3.6.6.bz2
- modify configuration for server flavour to DEFAULT_GOV_ONDEMAND=y
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

* Fri Nov 02 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.5-2
+ update to 3.6.5-2
- drop FX01_fix-serious-progressive-ext4-data-corruption-bug.patch
- add FX01_fs-ext4-fix-unjournaled-inode-bitmap-modification.patch
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

* Wed Oct 31 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.5-1
+ update to 3.6.5-1 (98 fixes all over)
- some fixes to the description text on all kernel flavours and source
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

* Tue Oct 30 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.5-1-0-rc1
+ update to 3.6.5-0-rc1
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

* Tue Oct 30 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.4-2
+ update to 3.6.4-2
- modify default .configs to CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

* Sun Oct 28 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.4-1
+ update to 3.6.4-1
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

* Fri Oct 26 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.4-rc1
+ update to 3.6.4-rc1
+ rc release that should fix this > https://lwn.net/Articles/521022/
- added FX01-fix-serious-progressive-ext4-data-corruption-bug.patch
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

* Mon Oct 22 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.3-1
+ update to 3.6.3 (85 fixes all over)
- add OverlayFS 
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

* Sat Oct 13 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.2-1
+ update to 3.6.2 (135 fixes all over)
- now CPU_FREQ_GOV_ONDEMAND is the predefined for -laptop and -netbook
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

* Fri Oct 12 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.1-1
+ update to 3.6.1 
- first public attempt with new kernel 3.6 serie
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

* Fri Oct 2 2012 Nicolo' Costanza <abitrules@yahoo.it> 3.6.0-1
+ new kernel 3.6.0
- first private attempt with new kernel 3.6 serie
- ---------------------------------------------------------------------
- Kernel 3.6 for mdv 2010.2, 2011.0, cooker, rosa.lts2012.0, rosa2012.1
- MIB (Mandriva International Backports) - http://mib.pianetalinux.org/
- This is -1 (mainline serie), with official kernel sources and addons,
- instead (-69) will be used for development and experimental flavours
- Yin & Yang (69) release - a very complete but experimental flavours...
- ---------------------------------------------------------------------

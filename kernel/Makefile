VERSION = 2
PATCHLEVEL = 4
SUBLEVEL = 18
EXTRAVERSION = .5-wive-ng.sf.net
KERNELRELEASE=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)

ARCH = mips
KERNELPATH=kernel-$(shell echo $(KERNELRELEASE) | sed -e "s/-//g")

CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)
TOPDIR	:= $(shell /bin/pwd)

OPTIMIZEFLAGS	= -Os -fPIC -nostdinc -g -gstabs+ -fomit-frame-pointer -fexpensive-optimizations
 
HPATH   	= $(TOPDIR)/include
FINDHPATH	= $(HPATH)/asm $(HPATH)/linux $(HPATH)/scsi $(HPATH)/net
WIVEROOT	= /opt/Wive
CROSSPATH	= /usr/local/bin/
CROSS_COMPILE 	= mips-linux-
OBJCOPY		= mips-uclibc-objcopy
STRIP		= mips-linux-strip

EXTRA_ASFLAGS	= -mips1 -mcpu=r3000
COPTS		= $(OPTIMIZEFLAGS) -DNO_IPV6 

HOSTCC  	= gcc
HOSTCFLAGS	= -O2

# Include the make variables (CC, etc...)
#

AS		= $(CROSSPATH)$(CROSS_COMPILE)as
LD		= $(CROSSPATH)$(CROSS_COMPILE)ld
CC		= $(CROSSPATH)$(CROSS_COMPILE)gcc
CPP		= $(CROSSPATH)$(CC) -E
AR		= $(CROSSPATH)$(CROSS_COMPILE)ar
NM		= $(CROSSPATH)$(CROSS_COMPILE)nm
STRIP		= $(CROSSPATH)$(CROSS_COMPILE)strip
OBJCOPY		= $(CROSSPATH)$(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSSPATH)$(CROSS_COMPILE)objdump
MAKEFILES	= $(TOPDIR)/.config
GENKSYMS	= /sbin/genksyms
DEPMOD		= /sbin/depmod
PERL		= perl

MODFLAGS	= $(OPTIMIZEFLAGS) -DMODULE
CFLAGS_KERNEL	= $(OPTIMIZEFLAGS) -DJACKSON_NET_WORK 

export	VERSION PATCHLEVEL SUBLEVEL EXTRAVERSION KERNELRELEASE ARCH \
	CONFIG_SHELL TOPDIR HPATH HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC \
	CPP AR NM STRIP OBJCOPY OBJDUMP MAKE MAKEFILES GENKSYMS MODFLAGS PERL

all:	unpack do-it-all

unpack:
	tar xvfz rtl8186.tar.gz
	$(OBJCOPY) --strip-debug --strip-unneeded rtl8186/wireless_ag_net.o
	$(OBJCOPY) --strip-debug --strip-unneeded rtl8186/ipsec.o
	$(OBJCOPY) --strip-debug --strip-unneeded rtl8186/fastpath.o
	tar xvfz rtl8196b.tar.gz
	$(OBJCOPY) --strip-debug --strip-unneeded rtl8196b/wireless_agn_net.o
	$(OBJCOPY) --strip-debug --strip-unneeded rtl8196b/fastpath.o

#
# Make "config" the default target if there is no configuration file or
# "depend" the target if there is no top-level dependency information.
#

ifeq (.config,$(wildcard .config))
include .config

ifeq (.depend,$(wildcard .depend))
include .depend
do-it-all:	Version vmlinux
else
CONFIGURATION = depend
do-it-all:	depend
endif
else
CONFIGURATION = config
do-it-all:	config
endif

# INSTALL_MOD_PATH specifies a prefix to MODLIB for module directory
# relocations required by build roots.  This is not defined in the
# makefile but the arguement can be passed to make if needed.
#

MODLIB	:= $(TOPDIR)/modules_install/$(KERNELRELEASE)
export MODLIB

#
# standard CFLAGS
#

CPPFLAGS := -D__MIPSEB__ -D__KERNEL__ -I$(HPATH)

CFLAGS := $(CPPFLAGS) $(OPTIMIZEFLAGS) -Wall -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing

AFLAGS := -D__ASSEMBLY__ $(CPPFLAGS)

#
# ROOT_DEV specifies the default root-device when making the image.
# This can be either FLOPPY, CURRENT, /dev/xxxx or empty, in which case
# the default of FLOPPY is used by 'build'.
# This is i386 specific.
#

export ROOT_DEV = CURRENT

#
# If you want to preset the SVGA mode, uncomment the next line and
# set SVGA_MODE to whatever number you want.
# Set it to -DSVGA_MODE=NORMAL_VGA if you just want the EGA/VGA mode.
# The number is the same as you would ordinarily press at bootup.
# This is i386 specific.
#

export SVGA_MODE = -DSVGA_MODE=NORMAL_VGA

#
# If you want the RAM disk device, define this to be the size in blocks.
# This is i386 specific.
#

NETWORKS	=net/network.o

LIBS		=$(TOPDIR)/lib/lib.a
ifndef CONFIG_NGPL_FREQUENCY_HOPPING
SUBDIRS		=kernel drivers mm fs net ipc lib 
CORE_FILES	=kernel/kernel.o mm/mm.o fs/fs.o ipc/ipc.o
else
SUBDIRS		=kernel drivers mm fs net ipc lib non-gpl
CORE_FILES	=kernel/kernel.o mm/mm.o fs/fs.o ipc/ipc.o non-gpl/non-gpl.o
endif

DRIVERS-n :=
DRIVERS-y :=
DRIVERS-m :=
DRIVERS-  :=

DRIVERS-$(CONFIG_ACPI) += drivers/acpi/acpi.o
DRIVERS-y += drivers/char/char.o \
	drivers/block/block.o \
	drivers/misc/misc.o \
	drivers/net/net.o \
	drivers/media/media.o 
DRIVERS-$(CONFIG_WAN) += drivers/net/wan/wan.o
DRIVERS-$(CONFIG_ATM) += drivers/atm/atm.o
DRIVERS-$(CONFIG_IDE) += drivers/ide/idedriver.o
DRIVERS-$(CONFIG_SCSI) += drivers/scsi/scsidrv.o
DRIVERS-$(CONFIG_FUSION_BOOT) += drivers/message/fusion/fusion.o
DRIVERS-$(CONFIG_PCI) += drivers/pci/driver.o
DRIVERS-$(CONFIG_MTD) += drivers/mtd/mtdlink.o
DRIVERS-$(CONFIG_PCMCIA) += drivers/pcmcia/pcmcia.o
DRIVERS-$(CONFIG_NET_PCMCIA) += drivers/net/pcmcia/pcmcia_net.o
DRIVERS-$(CONFIG_PCMCIA_CHRDEV) += drivers/char/pcmcia/pcmcia_char.o
DRIVERS-$(CONFIG_SBUS) += drivers/sbus/sbus_all.o
DRIVERS-$(CONFIG_ISAPNP) += drivers/pnp/pnp.o
DRIVERS-$(CONFIG_SGI_IP22) += drivers/sgi/sgi.a
DRIVERS-$(CONFIG_TC) += drivers/tc/tc.a
DRIVERS-$(CONFIG_INPUT) += drivers/input/inputdrv.o
DRIVERS-$(CONFIG_I2O) += drivers/message/i2o/i2o.o
DRIVERS-$(CONFIG_I2C) += drivers/i2c/i2c.o
DRIVERS-$(CONFIG_MD) += drivers/md/mddev.o

#------Realtek sources module------------------------------------
ifeq ($(CONFIG_MTD),y)
    DRIVERS-$(CONFIG_FLASH) += drivers/flash/flash.o
endif

ifeq ($(CONFIG_RTL8186),y)
    DRIVERS-$(CONFIG_RTL8186) += drivers/net/rtl8186/rtl8186.o
endif
ifeq ($(CONFIG_RTL8196_AP),y)
    DRIVERS-$(CONFIG_RTL8196_AP) += drivers/net/rtl865x/rtl865x.o
    DRIVERS-$(CONFIG_RTL8196_RTL8366) += drivers/net/rtl865x/RTL8366RB_DRIVER/rtl8366.o
endif

#------Realtek binary 8225(8185) RF driver------------------------	
ifeq ($(CONFIG_NET_WIRELESS_AG),y)
ifdef CONFIG_RTL8186_AP
    DRIVERS-$(CONFIG_NET_WIRELESS_AG) += rtl8186/wireless_ag_net.o
endif
ifdef CONFIG_RTL8196_AP
    DRIVERS-$(CONFIG_NET_WIRELESS_AG) += rtl8196b/wireless_agn_net.o
endif
endif

#-----------------REALTEK BINARY MODULES------------------------
#------ipsec speed up-------------------------------------------
ifeq ($(CONFIG_RTL_IPSEC),y)
    DRIVERS-$(CONFIG_RTL_IPSEC) += rtl8186/ipsec.o
endif
#----------------END OF REALTEK BINARY MODULES-------------------

DRIVERS := $(DRIVERS-y)


# files removed with 'make clean'
CLEAN_FILES = \
	kernel/ksyms.lst include/linux/compile.h \
	vmlinux System.map \
	.tmp* \
	drivers/char/consolemap_deftbl.c drivers/video/promcon_tbl.c \
	drivers/char/conmakehash \
	drivers/char/drm/*-mod.c \
	drivers/pci/devlist.h drivers/pci/classlist.h drivers/pci/gen-devlist \
	drivers/zorro/devlist.h drivers/zorro/gen-devlist \
	drivers/atm/fore200e_mkfirm drivers/atm/{pca,sba}*{.bin,.bin1,.bin2} \
	drivers/scsi/aic7xxx/aicasm/aicasm_gram.c \
	drivers/scsi/aic7xxx/aicasm/aicasm_scan.c \
	drivers/scsi/aic7xxx/aicasm/y.tab.h \
	drivers/scsi/aic7xxx/aicasm/aicasm \
	drivers/scsi/53c700_d.h \
	submenu* \
	rtkload/vmlinux-stripped \
	rtkload/vmlinux_img \
	rtkload/vmlinux-full \
	rtkload/vmlinux-partial \
	rtkload/linux.bin \
	rtkload/rtkrom \
	rtkload/vmlinux_img.gz \
	rtkload/memload-full \
	rtkload/memload-partial \
	arch/mips/ramdisk/ramdisk.img \
	.hdepend
# directories removed with 'make clean'
CLEAN_DIRS = \
	modules

# files removed with 'make mrproper'
MRPROPER_FILES = \
	include/linux/autoconf.h include/linux/version.h \
	drivers/atm/fore200e_*_fw.c drivers/atm/.fore200e_*.fw \
	.version .config* config.in config.old \
	scripts/tkparse scripts/kconfig.tk scripts/kconfig.tmp \
	scripts/lxdialog/*.o scripts/lxdialog/lxdialog \
	.menuconfig.log \
	include/asm \
	.hdepend scripts/mkdep scripts/split-include scripts/docproc \
	$(TOPDIR)/include/linux/modversions.h \
	kernel.spec

# directories removed with 'make mrproper'
MRPROPER_DIRS = \
	include/config \
	$(TOPDIR)/include/linux/modules


include arch/$(ARCH)/Makefile

export	CPPFLAGS CFLAGS CFLAGS_KERNEL AFLAGS AFLAGS_KERNEL

export	NETWORKS DRIVERS LIBS HEAD LDFLAGS LINKFLAGS MAKEBOOT ASFLAGS

.S.s:
	$(CPP) $(AFLAGS) $(AFLAGS_KERNEL) -traditional -o $*.s $<
.S.o:
	$(CC) $(AFLAGS) $(AFLAGS_KERNEL) -traditional -c -o $*.o $<

Version: dummy
	@rm -f include/linux/compile.h

boot: vmlinux
	@$(MAKE) CFLAGS="$(CFLAGS) $(CFLAGS_KERNEL)" -C arch/$(ARCH)/boot

vmlinux: include/linux/version.h $(CONFIGURATION) init/main.o init/version.o linuxsubdirs
	$(LD) $(LINKFLAGS) $(HEAD) init/main.o init/version.o \
		--start-group \
		$(CORE_FILES) \
		$(DRIVERS) \
		$(NETWORKS) \
		$(LIBS) \
		--end-group \
		-o vmlinux
	$(NM) vmlinux | grep -v '\(compiled\)\|\(\.o$$\)\|\( [aUw] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)' | sort > System.map

symlinks:
	rm -f include/asm
	( cd include ; ln -sf asm-$(ARCH) asm)
	@if [ ! -d include/linux/modules ]; then \
		mkdir include/linux/modules; \
	fi

oldconfig: symlinks
	$(CONFIG_SHELL) scripts/Configure -d arch/$(ARCH)/config.in

xconfig: symlinks
	$(MAKE) -C scripts kconfig.tk
	wish -f scripts/kconfig.tk

menuconfig: include/linux/version.h symlinks
	$(MAKE) -C scripts/lxdialog all
	$(CONFIG_SHELL) scripts/Menuconfig arch/$(ARCH)/config.in

config: symlinks
	$(CONFIG_SHELL) scripts/Configure arch/$(ARCH)/config.in

include/config/MARKER: scripts/split-include include/linux/autoconf.h
	scripts/split-include include/linux/autoconf.h include/config
	@ touch include/config/MARKER

linuxsubdirs: $(patsubst %, _dir_%, $(SUBDIRS))

$(patsubst %, _dir_%, $(SUBDIRS)) : dummy include/linux/version.h include/config/MARKER
	$(MAKE) CFLAGS="$(CFLAGS) $(CFLAGS_KERNEL)" -C $(patsubst _dir_%, %, $@)

$(TOPDIR)/include/linux/version.h: include/linux/version.h
$(TOPDIR)/include/linux/compile.h: include/linux/compile.h

newversion:
	. scripts/mkversion > .tmpversion
	@mv -f .tmpversion .version

include/linux/compile.h: $(CONFIGURATION) include/linux/version.h newversion
	@echo -n \#define UTS_VERSION \"\#`cat .version` > .ver
	@if [ -n "$(CONFIG_SMP)" ] ; then echo -n " SMP" >> .ver; fi
	@if [ -f .name ]; then  echo -n \-`cat .name` >> .ver; fi
	@echo ' '`date -R`'"' >> .ver
	@echo \#define LINUX_COMPILE_TIME \"`date +%T`\" >> .ver
	@echo \#define LINUX_COMPILE_BY \"wive-ng.sf.net\">>.ver
	@echo \#define LINUX_COMPILE_HOST \"`hostname`\" >> .ver
	@if [ -x /bin/dnsdomainname ]; then \
	   echo \#define LINUX_COMPILE_DOMAIN \"`dnsdomainname`\"; \
	 elif [ -x /bin/domainname ]; then \
	   echo \#define LINUX_COMPILE_DOMAIN \"`domainname`\"; \
	 else \
	   echo \#define LINUX_COMPILE_DOMAIN ; \
	 fi >> .ver
	@echo \#define LINUX_COMPILER \"`$(CC) $(CFLAGS) -v 2>&1 | tail -1`\" >> .ver
	@mv -f .ver $@

include/linux/version.h: ./Makefile
	@echo \#define UTS_RELEASE \"$(KERNELRELEASE)\" > .ver
	@echo \#define LINUX_VERSION_CODE `expr $(VERSION) \\* 65536 + $(PATCHLEVEL) \\* 256 + $(SUBLEVEL)` >> .ver
	@echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))' >>.ver
	@mv -f .ver $@

comma	:= ,

init/version.o: init/version.c include/linux/compile.h include/config/MARKER
	$(CC) $(CFLAGS) $(CFLAGS_KERNEL) -DUTS_MACHINE='"$(ARCH)"' -DKBUILD_BASENAME=$(subst $(comma),_,$(subst -,_,$(*F))) -c -o init/version.o init/version.c

init/main.o: init/main.c include/config/MARKER
	$(CC) $(CFLAGS) $(CFLAGS_KERNEL) $(PROFILING) -DKBUILD_BASENAME=$(subst $(comma),_,$(subst -,_,$(*F))) -c -o $*.o $<

fs lib mm ipc kernel drivers net: dummy
	$(MAKE) CFLAGS="$(CFLAGS) $(CFLAGS_KERNEL)" $(subst $@, _dir_$@, $@)

TAGS: dummy
	etags `find include/asm-$(ARCH) -name '*.h'`
	find include -type d \( -name "asm-*" -o -name config \) -prune -o -name '*.h' -print | xargs etags -a
	find $(SUBDIRS) init -name '*.[ch]' | xargs etags -a

# Exuberant ctags works better with -I
tags: dummy
	CTAGSF=`ctags --version | grep -i exuberant >/dev/null && echo "-I __initdata,__exitdata,EXPORT_SYMBOL,EXPORT_SYMBOL_NOVERS"`; \
	ctags $$CTAGSF `find include/asm-$(ARCH) -name '*.h'` && \
	find include -type d \( -name "asm-*" -o -name config \) -prune -o -name '*.h' -print | xargs ctags $$CTAGSF -a && \
	find $(SUBDIRS) init -name '*.[ch]' | xargs ctags $$CTAGSF -a

ifdef CONFIG_MODULES
ifdef CONFIG_MODVERSIONS
MODFLAGS += -DMODVERSIONS -include $(HPATH)/linux/modversions.h
endif

.PHONY: modules
modules: $(patsubst %, _mod_%, $(SUBDIRS))

.PHONY: $(patsubst %, _mod_%, $(SUBDIRS))
$(patsubst %, _mod_%, $(SUBDIRS)) : include/linux/version.h include/config/MARKER
	$(MAKE) -C $(patsubst _mod_%, %, $@) CFLAGS="$(CFLAGS) $(MODFLAGS)" MAKING_MODULES=1 modules

.PHONY: modules_install
modules_install: _modinst_ $(patsubst %, _modinst_%, $(SUBDIRS)) _modinst_post
    
.PHONY: _modinst_
_modinst_:
	@rm -rf $(MODLIB)/kernel
	@rm -f $(MODLIB)/build
	@mkdir -p $(MODLIB)/kernel
	@ln -s $(TOPDIR) $(MODLIB)/build

# If System.map exists, run depmod.  This deliberately does not have a
# dependency on System.map since that would run the dependency tree on
# vmlinux.  This depmod is only for convenience to give the initial
# boot a modules.dep even before / is mounted read-write.  However the
# boot script depmod is the master version.
ifeq "$(strip $(INSTALL_MOD_PATH))" ""
depmod_opts	:=
else
depmod_opts	:= -b $(INSTALL_MOD_PATH) -r
endif
.PHONY: _modinst_post
#_modinst_post: _modinst_post_pcmcia
	if [ -r System.map ]; then $(DEPMOD) -ae -F System.map $(depmod_opts)  $(KERNELRELEASE); fi

# Backwards compatibilty symlinks for people still using old versions
# of pcmcia-cs with hard coded pathnames on insmod.  Remove
# _modinst_post_pcmcia for kernel 2.4.1.
.PHONY: _modinst_post_pcmcia
_modinst_post_pcmcia:
	cd $(MODLIB); \
	mkdir -p pcmcia; \
	find kernel -path '*/pcmcia/*' -name '*.o' | xargs -i -r ln -sf ../{} pcmcia

.PHONY: $(patsubst %, _modinst_%, $(SUBDIRS))
$(patsubst %, _modinst_%, $(SUBDIRS)) :
	$(MAKE) -C $(patsubst _modinst_%, %, $@) modules_install

# modules disabled....

else
modules modules_install: dummy
	@echo
	@echo "The present kernel configuration has modules disabled."
	@echo "Type 'make config' and enable loadable module support."
	@echo "Then build a kernel with module support enabled."
	@echo
	@exit 1
endif

clean:	archclean
	find . \( -name '*.[oas]' -o -name core -o -name '.*.flags' -o -name '.depend' \) -type f -print \
		| grep -v lxdialog/ | xargs rm -f
	rm -f $(CLEAN_FILES)
	rm -rf $(CLEAN_DIRS)
	rm -rf rtl8186
	rm -rf rtl8196b
	make -C rtkload clean

mrproper: clean archmrproper
	find . \( -size 0 -o -name .depend \) -type f -print | xargs rm -f
	rm -f $(MRPROPER_FILES)
	rm -rf $(MRPROPER_DIRS)

distclean: mrproper
	find . \( -not -type d \) -and \
		\( -name core -o -name '*.orig' -o -name '*.rej' \
		-o -name '*~' -o -name '*.bak' -o -name '#*#' \
		-o -name '.*.rej' -o -name '.SUMS' -o -size 0 \
		-o -name TAGS -o -name tags \) -print | env -i xargs rm -f

backup: mrproper
	cd .. && tar cf - linux/ | gzip -9 -f > backup.gz
	sync

sgmldocs: 
	chmod 755 $(TOPDIR)/scripts/docgen
	chmod 755 $(TOPDIR)/scripts/gen-all-syms
	chmod 755 $(TOPDIR)/scripts/kernel-doc

psdocs: sgmldocs
pdfdocs: sgmldocs
htmldocs: sgmldocs

sums:
	find . -type f -print | sort | env -i xargs sum > .SUMS

dep-files: scripts/mkdep archdep include/linux/version.h
	scripts/mkdep -- init/*.c > .depend
	find $(FINDHPATH) -name SCCS -prune -o -follow -name \*.h ! -name modversions.h -print | env -i PATH="$(PATH)" HPATH="$(HPATH)" xargs scripts/mkdep -- > .hdepend
	$(MAKE) $(patsubst %,_sfdep_%,$(SUBDIRS)) _FASTDEP_ALL_SUB_DIRS="$(SUBDIRS)"
ifdef CONFIG_MODVERSIONS
	$(MAKE) update-modverfile
endif

ifdef CONFIG_MODVERSIONS
MODVERFILE := $(TOPDIR)/include/linux/modversions.h
else
MODVERFILE :=
endif
export	MODVERFILE

depend dep: dep-files

checkconfig:
	find * -name '*.[hcS]' -type f -print | sort | xargs $(PERL) -w scripts/checkconfig.pl

checkhelp:
	find * -name [cC]onfig.in -print | sort | xargs $(PERL) -w scripts/checkhelp.pl

checkincludes:
	find * -name '*.[hcS]' -type f -print | sort | xargs $(PERL) -w scripts/checkincludes.pl

ifdef CONFIGURATION
..$(CONFIGURATION):
	@echo
	@echo "You have a bad or nonexistent" .$(CONFIGURATION) ": running 'make" $(CONFIGURATION)"'"
	@echo
	$(MAKE) $(CONFIGURATION)
	@echo
	@echo "Successful. Try re-making (ignore the error that follows)"
	@echo
	exit 1

#dummy: ..$(CONFIGURATION)
dummy:

else

dummy:

endif

include Rules.make

#
# This generates dependencies for the .h files.
#

scripts/mkdep: scripts/mkdep.c
	$(HOSTCC) $(HOSTCFLAGS) -o scripts/mkdep scripts/mkdep.c

scripts/split-include: scripts/split-include.c
	$(HOSTCC) $(HOSTCFLAGS) -o scripts/split-include scripts/split-include.c

#
# RPM target
#
#	If you do a make spec before packing the tarball you can rpm -ta it
#
spec:
	. scripts/mkspec >kernel.spec

#
#	Build a tar ball, generate an rpm from it and pack the result
#	There arw two bits of magic here
#	1) The use of /. to avoid tar packing just the symlink
#	2) Removing the .dep files as they have source paths in them that
#	   will become invalid
#
rpm:	clean spec
	find . \( -size 0 -o -name .depend -o -name .hdepend \) -type f -print | xargs rm -f
	set -e; \
	cd $(TOPDIR)/.. ; \
	ln -sf $(TOPDIR) $(KERNELPATH) ; \
	tar -cvz --exclude CVS -f $(KERNELPATH).tar.gz $(KERNELPATH)/. ; \
	rm $(KERNELPATH) ; \
	cd $(TOPDIR) ; \
	. scripts/mkversion > .version ; \
	rpm -ta $(TOPDIR)/../$(KERNELPATH).tar.gz ; \
	rm $(TOPDIR)/../$(KERNELPATH).tar.gz

# @(#) generic $(MAKE)file for udpxy project
#
# Copyright 2008 Pavel V. Cherenkov
#
#  This file is part of udpxy.
#
#  udpxy is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  udpxy is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with udpxy.  If not, see <http://www.gnu.org/licenses/>.
#

.SUFFIXES : .o .c .d

EXEC := udpxy
UPXC := upxc
UDPXREC := udpxrec

MKDEPOPT := -M
DEBUG_ON := -g
CFLAGS = -Os --pedantic -W -Wall $(INCLUDES)
# -Werror
SYSTEM=$(shell uname 2>/dev/null)
ifeq ($(SYSTEM), FreeBSD)
MAKE := gmake
endif

ifeq ($(CC), gcc)
CCKIND := gcc
endif

ifeq ($(CCKIND), gcc)
CC := gcc
endif

ifeq ($(CCKIND), hp_ansicc64)
CC := cc
CFLAGS :=  -Ae +ESconstlit +w1 -z +DD64 -D_REENTRANT
MKDEPOPT :=
DEBUG_ON := -g
endif

ifeq ($(CCKIND), hp_ansicc20)
CC := cc
CFLAGS :=  -Ae +ESconstlit +w1 -z +DA2.0 -D_REENTRANT
MKDEPOPT :=
endif

ifeq ($(CCKIND), hp_ansicc11)
CC := cc
CFLAGS :=  -Ae +ESconstlit +w1 -z +DA1.1 -D_REENTRANT
MKDEPOPT :=
endif

ifeq ($(CCKIND), icc)
CC := icc
CFLAGS := -w2 -wd1419,177
endif

ifeq ($(CCKIND), suncc)
CC := suncc
CFLAGS := -v
MKDEPOPT := -xM1
endif

ifeq ($(PROFTOOL),gprof)
	CFLAGS += -pg
endif

BUILDFILE = BUILD
BUILDNO := `cat $(BUILDFILE)`

VERSIONFILE = VERSION
VERSION := `cat $(VERSIONFILE) | tr -d '"'`

CHANGEFILE := CHANGES
READMEFILE := README

DOCFILES := doc/udpxy-manual-RU.rtf

INSTALLROOT := ./filesystem

ARCDIR = ..
ARCFILE := $(ARCDIR)/$(EXEC).$(VERSION)-$(BUILDNO).tgz

COMMON_OPT :=
DEBUG_OPT  := $(COMMON_OPT) $(DEBUG_ON) -DTRACE_MODULE
PROD_OPT   := $(COMMON_OPT) -DNDEBUG -DTRACE_MODULE
LEAN_OPT   := -DNDEBUG


UTILDIR := util
MKDEP_SRC := $(UTILDIR)/mkdep.c
MKDEP_TOOL := $(UTILDIR)/mkdep

SRC := udpxy.c rparse.c util.c prbuf.c ifaddr.c ctx.c mkpg.c \
	  rtp.c uopt.c dpkt.c netop.c extrn.c udpxrec.c main.c
OBJ := ${SRC:.c=.o}

DEPFILE := $(EXEC).dep
CORES := core.* core

.PHONY: clean all debug lean verify touch incbuild tar wl-distro

.c.o :
	$(CC) $(CFLAGS) $(CDEFS) $(COPT) -c $< -o $@

release:
	@echo -e "\nMaking a [release] version (use 'debug' target as an alternative)\n"
	@$(MAKE) all "COPT=${PROD_OPT}"

debug:
	@echo -e "\nMaking a [debug] version (use 'release' target as an alternative)\n"
	@$(MAKE) all "COPT=${DEBUG_OPT}"

lean:
	@echo -e "\nMaking a [lean] version (minimal size)\n"
	@$(MAKE) all "COPT=${LEAN_OPT}"

verify:
	@echo -e "\nVerifying all build targets\n"
	@$(MAKE) clean
	@$(MAKE) lean
	@$(MAKE) clean
	@$(MAKE) release
	@$(MAKE) clean
	@$(MAKE) debug
	@$(MAKE) clean

ifneq ($(MKDEPOPT),)
make_deps := $(CC) $(CFLAGS) $(MKDEPOPT) $(SRC)
else
make_deps := HPATH='.' $(MKDEP_TOOL) -- $(SRC)
endif

all:	$(DEPFILE) $(EXEC)
# include $(UPXC) (if needed) in all target to build

$(MKDEP_TOOL): $(MKDEP_SRC)
	$(CC) -o $@ $(MKDEP_SRC)
	@ls -l $@

$(DEPFILE): $(MKDEP_TOOL) $(SRC)
	$($(MAKE)_deps) > $(DEPFILE)

$(EXEC) : $(DEPFILE) $(OBJ)
	@rm -f $(EXEC)
	$(CC) $(CFLAGS) $(COPT) -o $(EXEC) $(OBJ)
	@ls -l $(EXEC)
	@rm -f $(UDPXREC)
	ln -sf $(EXEC) $(UDPXREC)

clean:
	rm -f $(CORES) $(DEPFILE) $(OBJ) $(EXEC) $(UDPXREC)

incbuild:
	@expr `cat $(BUILDFILE)` + 1 > $(BUILDFILE)
	@echo "Set build number to: `cat $(BUILDFILE)`"
	@$(MAKE) touch

DISTRO_DIR := udpxy-$(VERSION)-$(BUILDNO)
DISTRO_FILES := $(SRC) *.h Makefile *.txt $(BUILDFILE) \
	$(VERSIONFILE) $(CHANGEFILE) $(READMEFILE) $(DOCFILES)

distro:
	@rm -fr $(DISTRO_DIR)
	@mkdir  $(DISTRO_DIR)
	@mkdir  $(DISTRO_DIR)/$(UTILDIR)

	cp -R $(DISTRO_FILES) $(DISTRO_DIR)
	cp -R $(MKDEP_SRC) $(DISTRO_DIR)/$(MKDEP_SRC)
	tar -cvzf $(ARCFILE) $(DISTRO_DIR)
	@ls -l $(ARCFILE)
	@rm -fr $(DISTRO_DIR)

install:
	@test -d $(INSTALLROOT)/bin || mkdir -p -m 755 $(INSTALLROOT)/bin
	@cp $(EXEC) $(INSTALLROOT)/bin
	@ln -sf $(INSTALLROOT)/bin/$(EXEC) $(INSTALLROOT)/bin/$(UDPXREC)
	@ls -l $(INSTALLROOT)/bin/$(EXEC) $(INSTALLROOT)/bin/$(UDPXREC)
	@echo "Installation of udpxy is complete"

uninstall:
	@rm -f $(INSTALLROOT)/bin/$(EXEC) $(INSTALLROOT)/bin/$(UDPXREC)
	@echo "udpxy successfully uninstalled"

ifneq ($(MAKECMDGOALS), clean)
-include $(DEPFILE)
endif

# __EOF__


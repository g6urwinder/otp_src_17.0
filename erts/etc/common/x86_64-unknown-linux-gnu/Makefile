#
# %CopyrightBegin%
#
# Copyright Ericsson AB 1996-2014. All Rights Reserved.
#
# The contents of this file are subject to the Erlang Public License,
# Version 1.1, (the "License"); you may not use this file except in
# compliance with the License. You should have received a copy of the
# Erlang Public License along with this software. If not, it can be
# retrieved online at http://www.erlang.org/.
#
# Software distributed under the License is distributed on an "AS IS"
# basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
# the License for the specific language governing rights and limitations
# under the License.
#
# %CopyrightEnd%
#

include $(ERL_TOP)/make/output.mk
include $(ERL_TOP)/make/target.mk

ifeq ($(findstring ose,$(TARGET)),ose)
include $(ERL_TOP)/make/$(TARGET)/ose_lm.mk
endif

ERTS_LIB_TYPEMARKER=.$(TYPE)

USING_MINGW=no
USING_VC=no

ifeq ($(TYPE),debug)
PURIFY =
TYPEMARKER = .debug
TYPE_FLAGS = -DDEBUG -g
else

ifeq ($(TYPE),purify)
PURIFY = purify
TYPEMARKER =
TYPE_FLAGS = -g -O2 -DPURIFY
else

override TYPE=opt
PURIFY =
TYPEMARKER =
ERTS_LIB_TYPEMARKER=
TYPE_FLAGS =
endif
endif

include $(ERL_TOP)/make/$(TARGET)/otp.mk
include ../../vsn.mk

ERTS_INCL = -I$(ERL_TOP)/erts/include \
            -I$(ERL_TOP)/erts/include/$(TARGET) \
            -I$(ERL_TOP)/erts/include/internal \
            -I$(ERL_TOP)/erts/include/internal/$(TARGET)

CC        = gcc
WFLAGS    = -Wall -Wstrict-prototypes -Wmissing-prototypes -Wdeclaration-after-statement
CFLAGS    = -Werror=return-type  -g -O2 -I/buildroot/otp_src_17.0/erts/x86_64-unknown-linux-gnu   -fno-tree-copyrename  -D_GNU_SOURCE -DHAVE_CONFIG_H $(TYPE_FLAGS) -Wall -Wstrict-prototypes -Wmissing-prototypes -Wdeclaration-after-statement -I$(SYSDIR) -I$(EMUDIR) \
            $(ERTS_INCL) -DOTP_SYSTEM_VERSION=\"$(SYSTEM_VSN)\"
LD        = $(CC)
LIBS      = -lutil -ldl -lm  
LDFLAGS   =  

# For clock_gettime in heart
ifneq ($(TARGET),arm-unknown-linux-androideabi)
RTLIBS = -lrt
endif

ifeq ($(TARGET),win32)
ifeq ($(TYPE),debug)
CFLAGS = $(subst -O2,-g,-Werror=return-type  -g -O2 -I/buildroot/otp_src_17.0/erts/x86_64-unknown-linux-gnu   -fno-tree-copyrename  -D_GNU_SOURCE -DHAVE_CONFIG_H $(TYPE_FLAGS) -Wall -Wstrict-prototypes -Wmissing-prototypes -Wdeclaration-after-statement -I$(SYSDIR) \
		-I$(EMUDIR) $(ERTS_INCL) -DOTP_SYSTEM_VERSION=\"$(SYSTEM_VSN)\")
LDFLAGS += -g
endif
endif
BINDIR    = $(ERL_TOP)/bin/$(TARGET)
OBJDIR    = $(ERL_TOP)/erts/obj$(TYPEMARKER)/$(TARGET)
EMUDIR    = $(ERL_TOP)/erts/emulator/beam
EMUOSDIR  = $(ERL_TOP)/erts/emulator/unix
SYSDIR    = $(ERL_TOP)/erts/emulator/sys/unix
DRVDIR    = $(ERL_TOP)/erts/emulator/drivers/unix
UXETC     = ../unix
OSEETC	  = ../ose
WINETC	  = ../win32

ifeq ($(TARGET), win32)
ETC       = $(WINETC)
else
ifeq ($(findstring ose,$(TARGET)),ose)
ETC       = $(OSEETC)
else
ETC       = $(UXETC)
endif
endif

ifeq ($(TARGET), win32)
ERLEXEC = erlexec.dll
else
ERLEXEC = erlexec
endif

# On windows we always need reentrant libraries.
ifeq ($(TARGET),win32)
ERTS_INTERNAL_LIBS=-L../../lib/internal/$(TARGET) -lerts_internal_r$(ERTS_LIB_TYPEMARKER) 
else
ERTS_INTERNAL_LIBS=-L../../lib/internal/$(TARGET) -lerts_internal$(ERTS_LIB_TYPEMARKER)  -lm
endif

ERTS_LIB = $(ERL_TOP)/erts/lib_src/obj/$(TARGET)/$(TYPE)/MADE

# ----------------------------------------------------
# Release directory specification
# ----------------------------------------------------

ifeq ($(TARGET),win32)
CFLAGS += -I$(EMUOSDIR) -I$(WINETC)
RC=rc.sh
MC=mc.sh
ERLSRV_HEADERS= \
		$(WINETC)/erlsrv/erlsrv_global.h \
		$(WINETC)/erlsrv/erlsrv_registry.h \
		$(WINETC)/erlsrv/erlsrv_util.h \
		$(WINETC)/erlsrv/erlsrv_interactive.h \
		$(WINETC)/erlsrv/erlsrv_service.h

ifeq ($(USING_VC), yes)
ERLRES_OBJ=erl.res
ERLSRV_OBJECTS= \
	$(OBJDIR)/erlsrv_registry.o \
	$(OBJDIR)/erlsrv_service.o  \
	$(OBJDIR)/erlsrv_interactive.o \
	$(OBJDIR)/erlsrv_main.o \
	$(OBJDIR)/erlsrv_util.o \
	$(OBJDIR)/erlsrv_logmess.res
MC_OUTPUTS=$(OBJDIR)/erlsrv_logmess.h $(OBJDIR)/erlsrv_logmess.rc
MT_FLAG="-MT"
else
ERLRES_OBJ=erl_res.o
ERLSRV_OBJECTS= \
	$(OBJDIR)/erlsrv_registry.o \
	$(OBJDIR)/erlsrv_service.o  \
	$(OBJDIR)/erlsrv_interactive.o \
	$(OBJDIR)/erlsrv_main.o \
	$(OBJDIR)/erlsrv_util.o \
	$(OBJDIR)/erlsrv_logmess.o
MC_OUTPUTS=$(OBJDIR)/erlsrv_logmess.h $(OBJDIR)/erlsrv_logmess.res
MT_FLAG="-MD"
endif
INET_GETHOST = $(BINDIR)/inet_gethost.exe
INSTALL_EMBEDDED_PROGS += $(BINDIR)/typer.exe $(BINDIR)/dialyzer.exe $(BINDIR)/erlc.exe $(BINDIR)/start_erl.exe $(BINDIR)/escript.exe $(BINDIR)/ct_run.exe
INSTALL_SRC = $(WINETC)/start_erl.c $(WINETC)/Nmakefile.start_erl
ERLEXECDIR=.
INSTALL_LIBS =
INSTALL_OBJS =
INSTALL_INCLUDES =
TEXTFILES = Install.ini
INSTALL_TOP = Install.ini
INSTALL_TOP_BIN = $(BINDIR)/Install.exe
INSTALL_PROGS =              \
	$(INET_GETHOST)      \
	$(BINDIR)/heart.exe   $(BINDIR)/erlsrv.exe   \
	$(BINDIR)/erl.exe $(BINDIR)/erl_log.exe \
	$(BINDIR)/werl.exe \
	$(BINDIR)/$(ERLEXEC) \
	$(INSTALL_EMBEDDED_PROGS)

ENTRY_SRC=$(WINETC)/port_entry.c
ENTRY_OBJ=$(OBJDIR)/port_entry.o
ifeq ($(USING_VC), yes)
WINDSOCK = ws2_32.lib mswsock.lib
else
WINDSOCK = -lws2_32
endif
PORT_ENTRY_POINT=erl_port_entry
ENTRY_LDFLAGS=-entry:$(PORT_ENTRY_POINT)

else
ifeq ($(findstring ose,$(TARGET)),ose)
ENTRY_LDFLAGS=
ENTRY_OBJ=
ERLSRV_OBJECTS=
MC_OUTPUTS=
INET_GETHOST =
INSTALL_EMBEDDED_PROGS = $(BINDIR)/run_erl_lm
INSTALL_EMBEDDED_DATA =
INSTALL_TOP = Install
INSTALL_TOP_BIN =
INSTALL_MISC =
INSTALL_SRC =
ERLEXECDIR = .
INSTALL_LIBS =
INSTALL_OBJS =
INSTALL_INCLUDES =
TEXTFILES = Install erl.src
INSTALL_PROGS = $(INSTALL_EMBEDDED_PROGS)
else # UNIX (!win32 && !ose)
ENTRY_LDFLAGS=
ENTRY_OBJ=
ERLSRV_OBJECTS= 
MC_OUTPUTS=
INET_GETHOST = $(BINDIR)/inet_gethost
INSTALL_EMBEDDED_PROGS += $(BINDIR)/typer $(BINDIR)/dialyzer \
 $(BINDIR)/erlc $(BINDIR)/escript $(BINDIR)/ct_run \
 $(BINDIR)/run_erl $(BINDIR)/to_erl $(BINDIR)/dyn_erl
INSTALL_EMBEDDED_DATA = $(UXETC)/start.src $(UXETC)/start_erl.src
INSTALL_TOP = Install
INSTALL_TOP_BIN = 
INSTALL_MISC = $(UXETC)/format_man_pages $(UXETC)/makewhatis
INSTALL_SRC = $(UXETC)/setuid_socket_wrap.c #delivered as an example
ERLEXECDIR = .
INSTALL_LIBS =
INSTALL_OBJS =
INSTALL_INCLUDES =
TEXTFILES = Install erl.src
INSTALL_PROGS =              \
	$(INET_GETHOST)      \
	$(BINDIR)/heart      \
	$(BINDIR)/$(ERLEXEC) \
	$(INSTALL_EMBEDDED_PROGS)
endif
endif

.PHONY: etc
etc:	$(ENTRY_OBJ) $(INSTALL_PROGS) $(INSTALL_LIBS) $(TEXTFILES) $(INSTALL_TOP_BIN)

# erlexec needs the erts_internal library...
$(ERTS_LIB):
	$(V_at)cd $(ERL_TOP)/erts/lib_src && $(MAKE) $(TYPE)

.PHONY: docs
docs:

.PHONY: clean
clean:
ifneq ($(INSTALL_PROGS),)
	rm -f $(INSTALL_PROGS)
endif
ifneq ($(ENTRY_OBJ),)
	rm -f $(ENTRY_OBJ) 
endif
ifneq ($(ERLSRV_OBJECTS),)
	rm -f $(ERLSRV_OBJECTS)
endif
ifneq ($(MC_OUTPUTS),)
	rm -f $(MC_OUTPUTS)
endif
ifneq ($(ERLRES_OBJ),)
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/$(ERLRES_OBJ)
endif
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/win_erlexec.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/init_file.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/start_erl.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/dialyzer.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/erlexec.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/erl_io.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/erlc.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/escript.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/heart.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/heart_config.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/inet_gethost.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/rdate.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/reclaim.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/run_erl.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/to_erl.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/dyn_erl.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/safe_string.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/run_erl_common.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/to_erl_common.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/typer.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/ct_run.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/vxcall.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/erl.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/erl_log.o
	rm -f $(ERL_TOP)/erts/obj*/$(TARGET)/werl.o
	rm -f $(TEXTFILES)
	rm -f *~ core

#------------------------------------------------------------------------
# Windows specific targets
# The windows platform is quite different from the others. erl/werl are small C programs
# loading a DLL. INI files are used instead of environment variables and the Install
# script is actually a program, also Install has an INI file which tells of emulator
# versions etc.
#----------------------------------------------------------------------

ifeq ($(TARGET),win32)

$(BINDIR)/$(ERLEXEC): $(OBJDIR)/erlexec.o $(OBJDIR)/win_erlexec.o $(OBJDIR)/init_file.o  $(OBJDIR)/$(ERLRES_OBJ) $(ERTS_LIB)
	$(V_LD) -dll $(LDFLAGS) -o $@ $(OBJDIR)/erlexec.o $(OBJDIR)/win_erlexec.o $(OBJDIR)/init_file.o $(OBJDIR)/$(ERLRES_OBJ) $(ERTS_INTERNAL_LIBS)

$(BINDIR)/erl: $(OBJDIR)/erl.o $(OBJDIR)/init_file.o $(OBJDIR)/$(ERLRES_OBJ)
	$(V_LD) $(LDFLAGS) -o $@ $(OBJDIR)/erl.o $(OBJDIR)/init_file.o $(OBJDIR)/$(ERLRES_OBJ) 

$(BINDIR)/werl: $(OBJDIR)/werl.o $(OBJDIR)/init_file.o $(OBJDIR)/$(ERLRES_OBJ)
	$(V_LD) $(LDFLAGS) -o $@  $(OBJDIR)/werl.o $(OBJDIR)/init_file.o $(OBJDIR)/$(ERLRES_OBJ) 

$(BINDIR)/erl_log: $(OBJDIR)/erl_log.o
	$(V_LD) $(LDFLAGS) -o $@  $(OBJDIR)/erl_log.o

$(BINDIR)/start_erl: $(OBJDIR)/start_erl.o 
	$(V_LD) $(LDFLAGS) -o $@  $(OBJDIR)/start_erl.o

$(BINDIR)/Install: $(OBJDIR)/Install.o  $(OBJDIR)/init_file.o 
	$(V_LD) $(LDFLAGS) -o $@  $(OBJDIR)/Install.o  $(OBJDIR)/init_file.o

# The service expects to be compiled with $(MT_FLAG) flag.
$(BINDIR)/erlsrv: $(ERLSRV_OBJECTS)
	$(V_LD) $(LDFLAGS) $(MT_FLAG) -o $@ $(ERLSRV_OBJECTS)

# To fix a spooky parallel make build problem on Windows there are some
# false dependencies on the $(MC), $(RC) and .o rules. The theory behind
# is that the $(MC) and/or $(RC) compilers seems to temporarily create and
# destroy a toplevel file vc100.pdb that simultaneous ordinary compilations
# (that have been by flags explicitly ordered to not use .pdb files)
# gets upset when that file vanishes from under their feet.
#
# The false dependencies are targeted to make make (pun intended) run
# the $(MC) and $(RC) compilations to completion before all others.

LOGMESS_GENERATED = $(OBJDIR)/LOGMESS-GENERATED
$(MC_OUTPUTS): $(LOGMESS_GENERATED)
$(LOGMESS_GENERATED): $(WINETC)/erlsrv/erlsrv_logmess.mc
	$(V_MC) -o $(OBJDIR) $(WINETC)/erlsrv/erlsrv_logmess.mc && \
		echo $? >$(LOGMESS_GENERATED)

$(OBJDIR)/$(ERLRES_OBJ): $(WINETC)/erl.rc $(WINETC)/erlang.ico \
		$(WINETC)/erl_icon.ico $(WINETC)/hrl_icon.ico \
		$(WINETC)/beam_icon.ico $(LOGMESS_GENERATED)
	$(V_RC) -o $@ -I$(WINETC) $(WINETC)/erl.rc

ifeq ($(USING_VC), yes)
RC_GENERATED = $(OBJDIR)/erlsrv_logmess.res
$(RC_GENERATED): $(OBJDIR)/erlsrv_logmess.rc $(OBJDIR)/$(ERLRES_OBJ)
	$(V_RC) -o $(OBJDIR)/erlsrv_logmess.res -I$(OBJDIR) $(OBJDIR)/erlsrv_logmess.rc
else
RC_GENERATED = $(OBJDIR)/erlsrv_logmess.o
$(RC_GENERATED): $(OBJDIR)/erlsrv_logmess.res $(OBJDIR)/$(ERLRES_OBJ)
	$(V_RC) -o $(OBJDIR)/erlsrv_logmess.o -I$(OBJDIR) $(OBJDIR)/erlsrv_logmess.res
endif

# The service expects to be compiled with $(MT_FLAG) flag.
$(OBJDIR)/%.o: $(WINETC)/erlsrv/%.c $(ERLSRV_HEADERS) $(RC_GENERATED)
	$(V_CC) $(CFLAGS) $(MT_FLAG) -o $@ -c $<

$(OBJDIR)/erlsrv_util.o: $(WINETC)/erlsrv/erlsrv_util.c $(ERLSRV_HEADERS) \
		$(OBJDIR)/erlsrv_logmess.h $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -I$(OBJDIR) $(MT_FLAG) -o $@ -c $<

$(OBJDIR)/werl.o: $(WINETC)/erl.c $(WINETC)/init_file.h $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -DBUILD_TYPE=\"-$(TYPE)\" -DERL_RUN_SHARED_LIB=1 \
	-DWIN32_WERL -o $@ -c $(WINETC)/erl.c

$(OBJDIR)/erl_log.o: $(WINETC)/erl_log.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -DBUILD_TYPE=\"-$(TYPE)\" -DERL_RUN_SHARED_LIB=1 \
	-o $@ -c $(WINETC)/erl_log.c

$(OBJDIR)/erl.o: $(WINETC)/erl.c $(WINETC)/init_file.h $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -DBUILD_TYPE=\"-$(TYPE)\" -DERL_RUN_SHARED_LIB=1 \
	-o $@ -c $(WINETC)/erl.c

$(OBJDIR)/erlexec.o: $(ERLEXECDIR)/erlexec.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -DBUILD_TYPE=\"-$(TYPE)\" -DERL_RUN_SHARED_LIB=1 \
	-o $@ -c $(ERLEXECDIR)/erlexec.c

$(OBJDIR)/win_erlexec.o: $(WINETC)/win_erlexec.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -DBUILD_TYPE=\"-$(TYPE)\" -DERL_RUN_SHARED_LIB=1 \
	-o $@ -c $(WINETC)/win_erlexec.c

$(OBJDIR)/init_file.o: $(WINETC)/init_file.c $(WINETC)/init_file.h $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c $(WINETC)/init_file.c

$(OBJDIR)/Install.o: $(WINETC)/Install.c $(WINETC)/init_file.h $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c $(WINETC)/Install.c

$(OBJDIR)/start_erl.o: $(WINETC)/start_erl.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c $(WINETC)/start_erl.c

$(ENTRY_OBJ): $(ENTRY_SRC) $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c $(ENTRY_SRC)

Install.ini:	../$(TARGET)/Install.src ../../vsn.mk $(TARGET)/Makefile
	$(vsn_verbose)sed -e 's;%I_VSN%;$(VSN);' \
	    -e 's;%I_SYSTEM_VSN%;$(SYSTEM_VSN);' \
          ../$(TARGET)/Install.src > Install.ini


else
RC_GENERATED =
endif
#---------------------------------------------------------
# End of windows specific targets.
#---------------------------------------------------------

$(BINDIR)/heart: $(OBJDIR)/heart.o $(ENTRY_OBJ)
	$(V_LD) $(LDFLAGS) $(ENTRY_LDFLAGS) -o $@ $(OBJDIR)/heart.o \
		$(RTLIBS) $(ENTRY_OBJ) $(WINDSOCK)

$(OBJDIR)/heart.o: heart.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c heart.c

#
# Objects & executables
#
#$(OBJDIR)/%.o: %.c
#	$(V_CC) $(CFLAGS) -o $@ -c $<
#
#$(OBJDIR)/%.o: ../unix/%.c
#	$(V_CC) $(CFLAGS) -o $@ -c $<
#
#$(BINDIR)/%: $(OBJDIR)/%.o
#	$(ld_verbose)$(PURIFY) $(LD) $(LDFLAGS) -o $@ $< $(LIBS)

$(OBJDIR)/inet_gethost.o: inet_gethost.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c inet_gethost.c

# inet_gethost
$(BINDIR)/inet_gethost: $(OBJDIR)/inet_gethost.o $(ENTRY_OBJ) $(ERTS_LIB)
	$(ld_verbose)$(PURIFY) $(LD) $(LDFLAGS) $(ENTRY_LDFLAGS) -o $@ $(OBJDIR)/inet_gethost.o $(ENTRY_OBJ) $(LIBS) $(ERTS_INTERNAL_LIBS)

# run_erl
$(BINDIR)/run_erl: $(OBJDIR)/safe_string.o $(OBJDIR)/run_erl.o $(OBJDIR)/run_erl_common.o
	$(V_LD) $(LDFLAGS) -o $@ $^ $(LIBS)
$(OBJDIR)/run_erl.o: $(ETC)/run_erl.c ../common/run_erl_common.h $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -I ../common/ -o $@ -c $(ETC)/run_erl.c
$(OBJDIR)/run_erl_common.o: ../common/run_erl_common.c ../common/run_erl_common.h $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c $<

# to_erl
$(BINDIR)/to_erl: $(OBJDIR)/safe_string.o $(OBJDIR)/to_erl.o $(OBJDIR)/to_erl_common.o
	$(V_LD) $(LDFLAGS) -o $@  $^
$(OBJDIR)/to_erl.o: $(ETC)/to_erl.c ../common/safe_string.h $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -I ../common/ -o $@ -c $(ETC)/to_erl.c
$(OBJDIR)/to_erl_common.o: ../common/to_erl_common.c ../common/to_erl_common.h $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c $<

# dyn_erl
$(BINDIR)/dyn_erl: $(OBJDIR)/safe_string.o $(OBJDIR)/dyn_erl.o
	$(V_LD) $(LDFLAGS) -o $@  $(OBJDIR)/safe_string.o $(OBJDIR)/dyn_erl.o
$(OBJDIR)/dyn_erl.o: $(UXETC)/dyn_erl.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c $(UXETC)/dyn_erl.c
$(OBJDIR)/safe_string.o: ../common/safe_string.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c ../common/safe_string.c

ifneq ($(TARGET),win32)
$(BINDIR)/$(ERLEXEC): $(OBJDIR)/$(ERLEXEC).o $(ERTS_LIB)
	$(ld_verbose)$(PURIFY) $(LD) $(LDFLAGS) -o $@ $(OBJDIR)/$(ERLEXEC).o $(ERTS_INTERNAL_LIBS)

$(OBJDIR)/$(ERLEXEC).o: $(ERLEXECDIR)/$(ERLEXEC).c $(RC_GENERATED)
	$(V_CC) -I$(EMUDIR) $(CFLAGS) -o $@ -c $(ERLEXECDIR)/$(ERLEXEC).c
endif

$(BINDIR)/erlc: $(OBJDIR)/erlc.o $(ERTS_LIB)
	$(ld_verbose)$(PURIFY) $(LD) $(LDFLAGS) -o $@ $(OBJDIR)/erlc.o -L$(OBJDIR) $(LIBS) $(ERTS_INTERNAL_LIBS)

$(OBJDIR)/erlc.o: erlc.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c erlc.c

$(BINDIR)/dialyzer: $(OBJDIR)/dialyzer.o $(ERTS_LIB)
	$(ld_verbose)$(PURIFY) $(LD) $(LDFLAGS) -o $@ $(OBJDIR)/dialyzer.o -L$(OBJDIR) $(LIBS) $(ERTS_INTERNAL_LIBS)

$(OBJDIR)/dialyzer.o: dialyzer.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c dialyzer.c

$(BINDIR)/typer: $(OBJDIR)/typer.o $(ERTS_LIB)
	$(ld_verbose)$(PURIFY) $(LD) $(LDFLAGS) -o $@ $(OBJDIR)/typer.o -L$(OBJDIR) $(LIBS) $(ERTS_INTERNAL_LIBS)

$(OBJDIR)/typer.o: typer.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c typer.c

$(BINDIR)/escript: $(OBJDIR)/escript.o $(ERTS_LIB)
	$(ld_verbose)$(PURIFY) $(LD) $(LDFLAGS) -o $@ $(OBJDIR)/escript.o -L$(OBJDIR) $(LIBS) $(ERTS_INTERNAL_LIBS)

$(OBJDIR)/escript.o: escript.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c escript.c

$(BINDIR)/ct_run: $(OBJDIR)/ct_run.o $(ERTS_LIB)
	$(ld_verbose)$(PURIFY) $(LD) $(LDFLAGS) -o $@ $(OBJDIR)/ct_run.o -L$(OBJDIR) $(LIBS) $(ERTS_INTERNAL_LIBS)

$(OBJDIR)/ct_run.o: ct_run.c $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -o $@ -c ct_run.c



Install:	$(UXETC)/Install.src ../../vsn.mk $(TARGET)/Makefile
	$(vsn_verbose)sed -e 's;%I_VSN%;$(VSN);' \
	    -e 's;%EMULATOR%;$(EMULATOR);' \
            -e 's;%EMULATOR_NUMBER%;$(EMULATOR_NUMBER);' \
	    -e 's;%I_SYSTEM_VSN%;$(SYSTEM_VSN);' \
          $(UXETC)/Install.src > Install

erl.src: $(UXETC)/erl.src.src ../../vsn.mk $(TARGET)/Makefile
	$(vsn_verbose)sed -e 's;%EMULATOR%;$(EMULATOR);' \
            -e 's;%EMULATOR_NUMBER%;$(EMULATOR_NUMBER);' \
            -e 's;%VSN%;$(VSN);' \
                  $(UXETC)/erl.src.src > erl.src

#---------------------------------------------------------
# OSE specific targets
#---------------------------------------------------------
ifeq ($(findstring ose,$(TARGET)),ose)
$(OBJDIR)/ose_confd.o: $(OSE_CONFD)
	$(V_CC) $(CFLAGS) -o $@ -c $<
$(OBJDIR)/crt0_lm.o: $(CRT0_LM)
	$(V_CC) $(CFLAGS) -o $@ -c $<
OSE_LM_OBJS += $(OBJDIR)/ose_confd.o $(OBJDIR)/crt0_lm.o

$(BINDIR)/run_erl_lm: $(OBJDIR)/run_erl_main.o $(OBJDIR)/safe_string.o $(OBJDIR)/run_erl.o $(OBJDIR)/run_erl_common.o $(OBJDIR)/to_erl_common.o $(OSE_LM_OBJS)
	$(call build-ose-load-module, $@, $^, $(LIBS), $(RUN_ERL_LMCONF))


$(OBJDIR)/run_erl_main.o: $(OSEETC)/run_erl_main.c $(OSEETC)/run_erl.h ../common/to_erl_common.h $(RC_GENERATED)
	$(V_CC) $(CFLAGS) -I ../common/ -o $@ -c $(OSEETC)/run_erl_main.c

endif

#---------------------------------------------------------
# End of ose specific targets.
#---------------------------------------------------------


# ----------------------------------------------------
# Release Target
# ---------------------------------------------------- 
include $(ERL_TOP)/make/otp_release_targets.mk

.PHONY: release_spec
release_spec: etc
ifneq ($(INSTALL_OBJS),)
	$(INSTALL_DIR) "$(RELEASE_PATH)/erts-$(VSN)/obj"
	$(INSTALL_DATA) $(INSTALL_OBJS) "$(RELEASE_PATH)/erts-$(VSN)/obj"
endif
	$(INSTALL_DIR) "$(RELEASE_PATH)/erts-$(VSN)/bin"
ifneq ($(TARGET), win32)
ifneq ($(findstring vxworks,$(TARGET)), vxworks)
ifneq ($(findstring ose,$(TARGET)), ose)
	$(INSTALL_SCRIPT) erl.src "$(RELEASE_PATH)/erts-$(VSN)/bin"
endif
endif
endif
ifneq ($(INSTALL_PROGS),)
	$(INSTALL_PROGRAM) $(INSTALL_PROGS) "$(RELEASE_PATH)/erts-$(VSN)/bin"
endif
ifneq ($(INSTALL_TOP),)
	$(INSTALL_SCRIPT) $(INSTALL_TOP) "$(RELEASE_PATH)"
endif
ifneq ($(INSTALL_TOP_BIN),)
	$(INSTALL_PROGRAM) $(INSTALL_TOP_BIN) "$(RELEASE_PATH)"
endif
ifneq ($(INSTALL_MISC),)
	$(INSTALL_DIR) "$(RELEASE_PATH)/misc"
	$(INSTALL_SCRIPT) $(INSTALL_MISC) "$(RELEASE_PATH)/misc"
endif
ifneq ($(INSTALL_SRC),)
	$(INSTALL_DIR) "$(RELEASE_PATH)/erts-$(VSN)/src"
	$(INSTALL_DATA) $(INSTALL_SRC) "$(RELEASE_PATH)/erts-$(VSN)/src"
endif
ifneq ($(INSTALL_EMBEDDED_DATA),)
	$(INSTALL_SCRIPT) $(INSTALL_EMBEDDED_DATA) "$(RELEASE_PATH)/erts-$(VSN)/bin"
endif
ifneq ($(INSTALL_LIBS),)
	$(INSTALL_DATA) $(INSTALL_LIBS) "$(RELEASE_PATH)/erts-$(VSN)/bin"
endif
ifneq ($(INSTALL_INCLUDES),)
	$(INSTALL_DIR) "$(RELEASE_PATH)/erts-$(VSN)/include"
	$(INSTALL_DATA) $(INSTALL_INCLUDES) "$(RELEASE_PATH)/erts-$(VSN)/include"
endif

.PHONY: release_docs_spec
release_docs_spec:

#
# %CopyrightBegin%
# 
# Copyright Ericsson AB 2003-2012. All Rights Reserved.
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

.PHONY : debug opt release clean distclean depend

TARGET = x86_64-unknown-linux-gnu

include $(ERL_TOP)/make/target.mk
include $(ERL_TOP)/make/$(TARGET)/otp.mk

include ../vsn.mk
VSN = $(COMMON_TEST_VSN)

# ----------------------------------------------------
# Release directory specification
# ----------------------------------------------------
ifdef TESTROOT
RELEASE_PATH=$(TESTROOT)
else
RELEASE_PATH=$(ERL_TOP)/release/$(TARGET)
endif
RELSYSDIR = $(RELEASE_PATH)/lib/common_test-$(VSN)

ifeq ($(findstring linux,$(TARGET)),linux)
XNIX = true
else
ifeq ($(findstring solaris,$(TARGET)),solaris)
XNIX = true
else
XNIX = false
endif
endif

ifneq ($(findstring win32,$(TARGET)),win32)

# ====================================================
# UNIX / LINUX
# ====================================================

#
# Files
#
FILES = vts.tool
SCRIPTS = 
IMAGES = tile1.jpg
CSS = ct_default.css
JS = jquery-latest.js jquery.tablesorter.min.js 

#
# Rules
#

include ../../test_server/vsn.mk
debug opt:
	$(V_at)sed -e 's;@CT_VSN@;$(VSN);' \
            -e 's;@TS_VSN@;$(TEST_SERVER_VSN);' \
            ../install.sh.in > install.sh
	$(V_at)chmod 775 install.sh

docs:

clean:
	$(V_at)rm -f $(SCRIPTS)


# ----------------------------------------------------
# Release Target
# ---------------------------------------------------- 
include $(ERL_TOP)/make/otp_release_targets.mk

ifeq ($(XNIX),true)
release_spec: opt
	$(INSTALL_DIR) "$(RELSYSDIR)/priv"
	$(INSTALL_DATA) $(FILES) $(IMAGES) $(CSS) $(JS) "$(RELSYSDIR)/priv"
else
release_spec: opt
	$(INSTALL_DIR) "$(RELSYSDIR)/priv"
	$(INSTALL_DATA) $(FILES) $(IMAGES) $(CSS) $(JS) "$(RELSYSDIR)/priv"
endif

release_docs_spec:

else

# ====================================================
# WIN32
# ====================================================

#
# Files
#
FILES = vts.tool 
IMAGES = tile1.jpg
CSS = ct_default.css
JS = jquery-latest.js jquery.tablesorter.min.js 

#
# Rules
#

debug opt:

docs:

clean:


# ----------------------------------------------------
# Release Target
# ---------------------------------------------------- 
include $(ERL_TOP)/make/otp_release_targets.mk

release_spec: opt
	$(INSTALL_DIR) "$(RELSYSDIR)/priv"
	$(INSTALL_DATA) $(FILES) $(IMAGES) $(CSS) $(JS) "$(RELSYSDIR)/priv"

release_docs_spec:

endif

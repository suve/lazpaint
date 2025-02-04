prefix = /usr/local
USER_DIR = $(DESTDIR)$(prefix)
BIN_DIR = $(USER_DIR)/bin
SHARE_DIR=$(USER_DIR)/share
RESOURCE_DIR=$(SHARE_DIR)/lazpaint
DOC_DIR=$(SHARE_DIR)/doc/lazpaint
SOURCE_BIN_DIR=lazpaint/release/bin
SOURCE_SCRIPT_DIR=resources/scripts
SOURCE_DEBIAN_DIR=lazpaint/release/debian
PO_FILES:=$(shell find "$(SOURCE_BIN_DIR)/i18n" -maxdepth 1 -type f -name *.po -printf "\"%f\" ")
MODEL_FILES:=$(shell find "$(SOURCE_BIN_DIR)/models" -maxdepth 1 -type f -printf "\"%f\" ")
SCRIPT_FILES:=$(shell find "$(SOURCE_SCRIPT_DIR)" -maxdepth 1 -type f -name *.py -printf "\"%f\" ")
SCRIPT_RUNTIME_FILES:=$(shell find "$(SOURCE_SCRIPT_DIR)/lazpaint" -maxdepth 1 -type f -name *.py -printf "\"%f\" ")

ifeq ($(OS),Windows_NT)     # true for Windows_NT or later
  COPY := winmake\copyfile
  REMOVE := winmake\remove
  REMOVEDIR := winmake\removedir
  THEN := &
  RUN :=
else
  COPY := cp
  REMOVE := rm -f
  REMOVEDIR := rm -rf
  THEN := ;
  RUN := ./
endif

all: compile

install: 
ifeq ($(OS),Windows_NT)     # true for Windows_NT or later
	echo Under Windows, use installation generated by InnoSetup with lazpaint/release/windows/lazpaint.iss
else ifeq ($(shell uname),Linux)
	install -D "$(SOURCE_BIN_DIR)/lazpaint" "$(BIN_DIR)/lazpaint"
	for f in $(PO_FILES); do install -D "$(SOURCE_BIN_DIR)/i18n/$$f" "${RESOURCE_DIR}/i18n/$$f"; done
	for f in $(MODEL_FILES); do install -D "$(SOURCE_BIN_DIR)/models/$$f" "${RESOURCE_DIR}/models/$$f"; done
	for f in $(SCRIPT_FILES); do install -D "$(SOURCE_SCRIPT_DIR)/$$f" "${RESOURCE_DIR}/scripts/$$f"; done
	for f in $(SCRIPT_RUNTIME_FILES); do install -D "$(SOURCE_SCRIPT_DIR)/lazpaint/$$f" "${RESOURCE_DIR}/scripts/lazpaint/$$f"; done
	install -D "$(SOURCE_DEBIAN_DIR)/applications/lazpaint.desktop" "$(SHARE_DIR)/applications/lazpaint.desktop"
	install -D "$(SOURCE_DEBIAN_DIR)/pixmaps/lazpaint.png" "$(SHARE_DIR)/pixmaps/lazpaint.png"
	install -d "$(SHARE_DIR)/man/man1"
	gzip -9 -n -c "$(SOURCE_DEBIAN_DIR)/man/man1/lazpaint.1" >"$(SHARE_DIR)/man/man1/lazpaint.1.gz"
	chmod 0644 "$(SHARE_DIR)/man/man1/lazpaint.1.gz"
	install -d "$(DOC_DIR)"
	gzip -9 -n -c "$(SOURCE_DEBIAN_DIR)/debian/changelog" >"$(DOC_DIR)/changelog.gz"
	chmod 0644 "$(DOC_DIR)/changelog.gz"
	install "$(SOURCE_DEBIAN_DIR)/debian/copyright" "$(DOC_DIR)/copyright"
	install "$(SOURCE_BIN_DIR)/readme.txt" "$(DOC_DIR)/README"
else
	echo Unhandled OS
endif

uninstall: 
ifeq ($(OS),Windows_NT)     # true for Windows_NT or later
	echo Under Windows, go to Add/Remove programs
else ifeq ($(shell uname),Linux)
	$(REMOVE) $(BIN_DIR)/lazpaint
	$(REMOVEDIR) $(RESOURCE_DIR)
	$(REMOVEDIR) $(DOC_DIR)
	$(REMOVE) "$(SHARE_DIR)/applications/lazpaint.desktop"
	$(REMOVE) "$(SHARE_DIR)/pixmaps/lazpaint.png"
	$(REMOVE) "$(SHARE_DIR)/man/man1/lazpaint.1.gz"
else
	echo Unhandled OS
endif

clean: clean_lazpaintcontrols clean_vectoredit clean_lazpaint

clean_lazpaintcontrols:
	$(REMOVEDIR) "lazpaintcontrols/lib"
	$(REMOVEDIR) "lazpaintcontrols/backup"

clean_vectoredit:
	$(REMOVEDIR) "vectoredit/lib"
	$(REMOVEDIR) "vectoredit/backup"

clean_lazpaint:
	$(REMOVEDIR) "lazpaint/debug"
	$(REMOVEDIR) "lazpaint/release/lib"
	$(REMOVE) "lazpaint/lazpaint.res"
	$(REMOVE) "lazpaint/release/bin/lazpaint"
	$(REMOVE) "lazpaint/release/bin/lazpaint32.exe"
	$(REMOVE) "lazpaint/release/bin/lazpaint_x64.exe"
	$(REMOVEDIR) "lazpaint/backup"
	$(REMOVEDIR) "lazpaint/dialog/backup"
	$(REMOVEDIR) "lazpaint/image/backup"
	$(REMOVEDIR) "lazpaint/tablet/backup"
	$(REMOVEDIR) "lazpaint/test_embedded/backup"
	$(REMOVEDIR) "lazpaint/tools/backup"

compile: lazpaintcontrols vectoredit lazpaint
lazbuild:
	#lazbuild will determine what to recompile
lazpaintcontrols: lazbuild lazpaintcontrols/lazpaintcontrols.lpk
	lazbuild lazpaintcontrols/lazpaintcontrols.lpk
vectoredit: lazbuild vectoredit/vectoredit.lpi
	lazbuild vectoredit/vectoredit.lpi
lazpaint: lazbuild lazpaint/lazpaint.lpi
	lazbuild lazpaint/lazpaint.lpi


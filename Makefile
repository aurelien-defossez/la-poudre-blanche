SRC_DIR=src
LIB_DIR=lib
ASSETS_DIR=assets

MAIN=$(SRC_DIR)/Main.as
OUTPUT=sniff.swf

all:	build

build:
	mxmlc $(MAIN) -sp $(LIB_DIR) $(ASSETS_DIR) $(SRC_DIR) -static-link-runtime-shared-libraries -o $(OUTPUT)

run:	build
	firefox $(OUTPUT)

clear:
	rm -f $(OUTPUT)

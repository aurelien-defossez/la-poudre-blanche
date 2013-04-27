SRC_DIR=src
LIB_DIR=lib
ASSETS_DIR=assets

MAIN=$(SRC_DIR)/Main.as
OUTPUT=la-poudre-blanche.swf

all:
	mxmlc $(MAIN) -sp $(LIB_DIR) $(ASSETS_DIR) $(SRC_DIR) -static-link-runtime-shared-libraries -o $(OUTPUT)

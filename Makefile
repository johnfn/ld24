MXMLC = ~/Downloads/flex_sdk_4/bin/mxmlc

#FLIXEL = ../flixel-lib
TWEENER = caurina
FATHOM = fathom
SRC = game/*.as
FSRC = fathom/*.as
MAIN = game/main.as
SWF = main.swf

$(SWF) : ./**/*.as
	$(MXMLC) -source-path=game/ -static-link-runtime-shared-libraries=true -debug=true -sp . $(FATHOM) -o $(SWF) -- $(MAIN)

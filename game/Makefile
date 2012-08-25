MXMLC = ~/Downloads/flex_sdk_4/bin/mxmlc

#FLIXEL = ../flixel-lib
TWEENER = ../caurina
FATHOM = ../fathom
SRC = *.as
MAIN = main.as
SWF = main.swf

$(SWF) : $(SRC)
	$(MXMLC) -compiler.source-path=. -static-link-runtime-shared-libraries=true -debug=true -sp $(TWEENER) $(FATHOM) -o $(SWF) -- $(MAIN)

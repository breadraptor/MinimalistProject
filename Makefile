FLEX_SDK=

APP=hello
APP_XML=$(APP).xml
ADL=$(FLEX_SDK)/bin/adl
AMXMLC=$(FLEX_SDK)/bin/amxmlc
SOURCES=src/Startup.hx

all: $(APP).swf

$(APP).swf: $(SOURCES)

	haxe \
	-cp src \
	-cp vendor \
	-swf-version 11.8 \
	-swf-header 640:240:60:ffffff \
	-main Startup \
	-swf $(APP).swf \
	-swf-lib vendor/starling.swc --macro "patchTypes('vendor/starling.patch')"
	
clean:
	rm -rf $(APP).swf
	
test: $(APP).swf
	$(ADL) -profile tv -screensize 640x240:640x240 $(APP_XML)
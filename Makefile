# Paths
PARTSDIR                    ?= ./stl

# Extensions
PART_SOURCE_EXTENSION       ?= .scad
PART_DESTINATION_EXTENSION  ?= .stl
PRESET_EXTENTION            ?= .json

# Applications
OPENSCAD                    ?= openscad

PARTS                       ?= with_pole without_pole

# Targets
.PHONY: all
all: all_parts

.PHONY: all_parts
all_parts: $(PARTS:%=$(PARTSDIR)/%$(PART_DESTINATION_EXTENSION))

.PHONY: clean_parts
clean_parts:
	rm -r $(PARTSDIR)

.PHONY: clean
clean: clean_parts

$(PARTSDIR)/%$(PART_DESTINATION_EXTENSION): H0Wubo$(PRESET_EXTENTION) H0Wubo$(PART_SOURCE_EXTENSION)
	mkdir -p $(PARTSDIR)/$(dir $*)
	$(OPENSCAD) -o $(PARTSDIR)/$*$(PART_DESTINATION_EXTENSION) -p H0Wubo$(PRESET_EXTENTION) -P $* H0Wubo$(PART_SOURCE_EXTENSION)

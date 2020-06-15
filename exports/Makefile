NAME := UsbHanger

COMMON_SRC_FILE := ../usb-hanger.scad

ALL_HOLDER := \
	${NAME}-Holder.dxf \
	${NAME}-Holder.svg

ALL_PANEL := \
	${NAME}-Panel.dxf \
	${NAME}-Panel.svg

ALL_ASSEMBLY := \
	${NAME}-Assembly.png \
	${NAME}-Assembly.stl

ALL := ${ALL_HOLDER} ${ALL_PANEL} ${ALL_ASSEMBLY}

.PHONY: all clean

all: ${ALL}

${ALL_HOLDER}: ${NAME}-Holder.scad ${COMMON_SRC_FILE}
	openscad -o $@ $<

${ALL_PANEL}: ${NAME}-Panel.scad ${COMMON_SRC_FILE}
	openscad -o $@ $<

${ALL_ASSEMBLY}: ${NAME}-Assembly.scad ${COMMON_SRC_FILE}
	openscad -o $@ $<

clean:
	rm -f ${ALL}

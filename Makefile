TOOLCHAIN=~/toolchain/gcc-arm-none-eabi-4_9-2014q4/bin
PREFIX=$(TOOLCHAIN)/arm-none-eabi-

FREERTOS=freertos

ARCHFLAGS=-mthumb -mcpu=cortex-m0plus
CFLAGS=-I. -I./includes/ -I./${FREERTOS}/include \
	   -I./${FREERTOS}/portable/GCC/ARM_CM0 -O0 -g
LDFLAGS=--specs=nano.specs -Wl,--gc-sections,-Map,$(TARGET).map,-Tlink.ld

CC=$(PREFIX)gcc
LD=$(PREFIX)gcc
OBJCOPY=$(PREFIX)objcopy
SIZE=$(PREFIX)size
RM=rm -f

TARGET=main

SRC=main.c startup.c ${FREERTOS}/list.c ${FREERTOS}/queue.c \
	${FREERTOS}/tasks.c ${FREERTOS}/portable/MemMang/heap_2.c \
	${FREERTOS}/portable/GCC/ARM_CM0/port.c
OBJ=$(patsubst %.c, %.o, $(SRC))

all: build size
build: elf srec bin
elf: $(TARGET).elf
srec: $(TARGET).srec
bin: $(TARGET).bin

clean:
	$(RM) $(TARGET).srec $(TARGET).elf $(TARGET).bin $(TARGET).map $(OBJ)

%.o: %.c
	$(CC) -c $(ARCHFLAGS) $(CFLAGS) -o $@ $<

$(TARGET).elf: $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $(OBJ)

%.srec: %.elf
	$(OBJCOPY) -O srec $< $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

size:
	$(SIZE) $(TARGET).elf

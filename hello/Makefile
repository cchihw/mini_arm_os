CROSS = aarch64-linux-gnu
CC    = $(CROSS)-gcc
LD    = $(CROSS)-ld
OBJDUMP = $(CROSS)-objdump

CFLAGS  = -O0 -ffreestanding -nostdlib -Wall -Wextra
LDFLAGS = -T linker.ld

SRCS = start.S main.c
OBJS = start.o main.o

all: kernel.elf

kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

start.o: start.S
	$(CC) $(CFLAGS) -c $< -o $@

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

run: kernel.elf
	qemu-system-aarch64 \
	  -machine virt \
	  -cpu cortex-a53 \
	  -nographic \
	  -kernel kernel.elf

dump: kernel.elf
	$(OBJDUMP) -d kernel.elf | less

clean:
	rm -f $(OBJS) kernel.elf

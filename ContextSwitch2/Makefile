CROSS = aarch64-linux-gnu
CC    = $(CROSS)-gcc

CFLAGS  = -O0 -ffreestanding -nostdlib -Wall -Wextra
LDFLAGS = -T linker.ld

TARGET = kernel.elf
SRCS   = start.S vector.S main.c uart.c enter_user.S 

all: $(TARGET)

$(TARGET): $(SRCS) linker.ld
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(SRCS)

run: $(TARGET)
	qemu-system-aarch64 \
	  -machine virt \
	  -cpu cortex-a53 \
	  -nographic \
	  -kernel $(TARGET)

clean:
	rm -f $(TARGET)

CROSS_COMPILE ?= arm-none-eabi

AOPS = --warn --fatal-warnings -g
COPS = -Wall -Werror -g -O2 -nostdlib -nostartfiles -ffreestanding 

task1.bin : task1.s task1_memmap
	$(CROSS_COMPILE)-as $(AOPS) task1.s -o task1.o
	$(CROSS_COMPILE)-ld task1.o -T task1_memmap -o task1.elf
	$(CROSS_COMPILE)-objdump -D task1.elf > task1.list
	$(CROSS_COMPILE)-objcopy task1.elf -O binary task1.bin


# run with: qemu-system-arm -S -s -M versatilepb -daemonize -m 128M -d in_asm,cpu,exec -kernel task1.bin
# gdb-multiarch --batch --command=task1.gdb
#
# qemu-system-arm launches the bare metal ARM processor emulator (along with some other devices, like a UART interface, etc.)
# the -M versatilepb indicates a particular machine mode
# the -m 128M gives the processor access to 128MB RAM
# the program is hw04.bin
# the gdb-multiarch enables a GDB connection to the QEMU system for debugging purposes
#
# to see if the given program works, once running, it should have launched a QEMU console window, then press control+alt+3, which opens the UART port


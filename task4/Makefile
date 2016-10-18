CROSS_COMPILE ?= arm-none-eabi

AOPS = --warn --fatal-warnings -g
COPS = -Wall -Werror -g -O2 -nostdlib -nostartfiles -ffreestanding 

task4.bin : task4.s task4_memmap
	$(CROSS_COMPILE)-as $(AOPS) task4.s -o task4.o
	$(CROSS_COMPILE)-ld task4.o -T task4_memmap -o task4.elf
	$(CROSS_COMPILE)-objdump -D task4.elf > task4.list
	$(CROSS_COMPILE)-objcopy task4.elf -O binary task4.bin


# run with: qemu-system-arm -S -s -M versatilepb -daemonize -m 128M -d in_asm,cpu,exec -kernel task4.bin
# gdb-multiarch --batch --command=task4.gdb
#
# qemu-system-arm launches the bare metal ARM processor emulator (along with some other devices, like a UART interface, etc.)
# the -M versatilepb indicates a particular machine mode
# the -m 128M gives the processor access to 128MB RAM
# the program is hw04.bin
# the gdb-multiarch enables a GDB connection to the QEMU system for debugging purposes
#
# to see if the given program works, once running, it should have launched a QEMU console window, then press control+alt+3, which opens the UART port


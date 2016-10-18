CROSS_COMPILE ?= arm-none-eabi

AOPS = --warn --fatal-warnings -g
COPS = -Wall -Werror -g -O2 -nostdlib -nostartfiles -ffreestanding 

task2.bin : task2.s task2_memmap
	$(CROSS_COMPILE)-as $(AOPS) task2.s -o task2.o
	$(CROSS_COMPILE)-ld task2.o -T task2_memmap -o task2.elf
	$(CROSS_COMPILE)-objdump -D task2.elf > task2.list
	$(CROSS_COMPILE)-objcopy task2.elf -O binary task2.bin


# run with: qemu-system-arm -S -s -M versatilepb -daemonize -m 128M -d in_asm,cpu,exec -kernel task2.bin
# gdb-multiarch --batch --command=task2.gdb
#
# qemu-system-arm launches the bare metal ARM processor emulator (along with some other devices, like a UART interface, etc.)
# the -M versatilepb indicates a particular machine mode
# the -m 128M gives the processor access to 128MB RAM
# the program is hw04.bin
# the gdb-multiarch enables a GDB connection to the QEMU system for debugging purposes
#
# to see if the given program works, once running, it should have launched a QEMU console window, then press control+alt+3, which opens the UART port


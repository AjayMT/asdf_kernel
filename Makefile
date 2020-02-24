
all: asdf.iso

kernel.elf: boot.o main.o
	clang --target=i386-elf -nostdlib -nostartfiles -T link.ld -o kernel.elf boot.o main.o

boot.o: boot.asm
	nasm -f elf -o boot.o boot.asm 

main.S: main.silk
	silk < main.silk | llc -mtriple=i386-elf -o main.S -

main.o: main.S
	clang --target=i386-elf -ffreestanding -o main.o -c main.S

asdf.iso: kernel.elf
	cp kernel.elf iso/boot/kernel.elf
	mkisofs -R                              \
	        -b boot/grub/stage2_eltorito    \
	        -no-emul-boot                   \
	        -boot-load-size 4               \
	        -A os                           \
	        -input-charset utf8             \
	        -quiet                          \
	        -boot-info-table                \
	        -o asdf.iso                     \
	        iso

.PHONY: run
run: asdf.iso
	qemu-system-i386 -cdrom asdf.iso

.PHONY: clean
clean:
	rm -f main.S *.elf *.o *.iso iso/boot/kernel.elf

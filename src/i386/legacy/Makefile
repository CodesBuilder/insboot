all:
	nasm -I$(PROJECT_ROOT_DIR)/include -f bin bootsec.asm -o $(BINARY_DIR)/bootsec.bin
	@$(MAKE) --no-print-directory -C conn/
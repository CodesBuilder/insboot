export BINARY_DIR=$(abspath ./out)

export PROJECT_ROOT_DIR=$(abspath .)

all:
	@$(MAKE) --no-print-directory -C src/

insbtmbr:
	clang -D _CRT_SECURE_NO_WARNINGS -D _CRT_NONSTDC_NO_WARNINGS tools/insbtmbr.c -o $(BINARY_DIR)/insbtmbr.exe
TOOLCHAIN_PATH=/usr/local/riscvmulti/bin/
PREF=$(TOOLCHAIN_PATH)riscv64-unknown-elf-
CC=$(PREF)gcc
AS=$(PREF)as
LD=$(PREF)ld

ASFLAGS=-march=rv32ifdzbb -mabi=ilp32 -g
# ASFLAGS=-march=rv32i -mabi=ilp32 -g
# ASFLAGS64=-march=rv64gc -mabi=lp64d -g

LDFLAGS=-m elf32lriscv --no-relax
# LDFLAGS64=-m elf64lriscv --no-relax

ARCH=qemu-riscv32

BUILD_DIR = build/$(ARCH)
LIB_DIR = lib/$(ARCH)
BIN_DIR = bin/$(ARCH)

# add your list of binaries here
BINARIES=q5

.PHONY: all clean

all: $(BINARIES)

clean:
	rm -rf build/ lib/ bin/ $(BINARIES)

# directories ##################################################################

$(BUILD_DIR) $(LIB_DIR) $(BIN_DIR) :
	mkdir -p $@

# assembling object files ######################################################

$(BUILD_DIR)/%.o : %.s | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

# linking ######################################################################

# TODO: complete
$(BIN_DIR)/q5: $(BUILD_DIR)/q5.o | $(BIN_DIR)
	$(LD) $(LDFLAGS) $< -o $@

# symlinks for executables #####################################################

$(BINARIES) : % : $(BIN_DIR)/%
	ln -sf $< $@

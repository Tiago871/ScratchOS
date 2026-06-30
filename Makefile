# ==========================================
# ScratchOS Build System
# ==========================================

ASM = nasm
QEMU = qemu-system-x86_64

BUILD_DIR = build

STAGE1_SRC = boot/stage1/boot.asm
STAGE2_SRC = boot/stage2/stage2.asm

STAGE1_BIN = $(BUILD_DIR)/boot.bin
STAGE2_BIN = $(BUILD_DIR)/stage2.bin
IMAGE = $(BUILD_DIR)/scratchos.img

.PHONY: all run clean

all: $(IMAGE)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(STAGE1_BIN): $(STAGE1_SRC) | $(BUILD_DIR)
	$(ASM) -I boot/stage1/ -f bin $(STAGE1_SRC) -o $(STAGE1_BIN)

$(STAGE2_BIN): $(STAGE2_SRC) | $(BUILD_DIR)
	$(ASM) -I boot/stage2/ -f bin $(STAGE2_SRC) -o $(STAGE2_BIN)
	@test $$(stat -c%s $(STAGE2_BIN)) -le 1024 || (echo "ERROR: Stage2 exceeds 1024 bytes; Stage1 currently loads two sectors only."; exit 1)

$(IMAGE): $(STAGE1_BIN) $(STAGE2_BIN)
	cat $(STAGE1_BIN) $(STAGE2_BIN) > $(IMAGE)
	truncate -s 1536 $(IMAGE)

run: $(IMAGE)
	$(QEMU) -drive format=raw,file=$(IMAGE)

clean:
	rm -f $(BUILD_DIR)/*

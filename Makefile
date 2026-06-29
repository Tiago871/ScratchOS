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

$(IMAGE): $(STAGE1_BIN) $(STAGE2_BIN)
	cp $(STAGE1_BIN) $(IMAGE)
	cat $(STAGE2_BIN) >> $(IMAGE)

run: $(IMAGE)
	$(QEMU) -drive format=raw,file=$(IMAGE)

clean:
	rm -f $(BUILD_DIR)/*

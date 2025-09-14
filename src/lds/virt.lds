/*
 * NyxOS Linker Script
 * For QEMU's 'virt' machine
 */
OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY {
    /* QEMU 'virt' machine has RAM at 0x80000000 */
    ram (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

PHDRS {
    text PT_LOAD;
    data PT_LOAD;
    bss PT_LOAD;
}

SECTIONS {
    /* Code and read-only data */
    .text : {
        PROVIDE(_text_start = .);
        *(.text.init)
        *(.text .text.*)
        PROVIDE(_text_end = .);
    } >ram AT>ram :text

    PROVIDE(_global_pointer = .);

    .rodata : {
        PROVIDE(_rodata_start = .);
        *(.rodata .rodata.*)
        PROVIDE(_rodata_end = .);
    } >ram AT>ram :text

    /* Read-write data */
    .data : {
        . = ALIGN(4096);
        PROVIDE(_data_start = .);
        *(.sdata .sdata.*)
        *(.data .data.*)
        PROVIDE(_data_end = .);
    } >ram AT>ram :data

    /* Zero-initialized data */
    .bss : {
        PROVIDE(_bss_start = .);
        *(.sbss .sbss.*)
        *(.bss .bss.*)
        PROVIDE(_bss_end = .);
    } >ram AT>ram :bss

    /* Define memory region symbols */
    PROVIDE(_memory_start = ORIGIN(ram));
    PROVIDE(_stack = _bss_end + 0x80000); /* 512 KiB stack */
    PROVIDE(_memory_end = ORIGIN(ram) + LENGTH(ram));
    PROVIDE(_heap_start = _stack);
    PROVIDE(_heap_size = _memory_end - _stack);
}

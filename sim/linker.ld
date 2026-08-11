MEMORY
{
    /* goes up to [1023] which holds test PASS/FAIL */
    imem (rx) : ORIGIN = 0x0, LENGTH = 0xFFC  
    
    /* Split because mem location 511 is testing location */
    dram_low (rwx) : ORIGIN = 0x20000000, LENGTH = 2044 /* indices 0 to 511 */
    dram_high (rwx) : ORIGIN = 0x20000800, LENGTH = 2048 /* indices 512 to 1023 */
}

SECTIONS
{
    .text : { *(.text*) } > imem

    .data : { *(.data*) } > dmem_low
    .bss  : { *(.bss*)  } > dmem_high
}   
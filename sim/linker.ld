MEMORY
{
    /* goes up to [1023] which holds test PASS/FAIL */
    imem (rx) : ORIGIN = 0x0, LENGTH = 0xFFC  
    dram (rw) : ORIGIN = 0x0, LENGTH = 0xFFC
}

SECTIONS
{
    .text : { *(.text*) } > imem
    .data : { *(.data*) } > dmem
    .bss  : { *(.bss*)  } > dmem
}   
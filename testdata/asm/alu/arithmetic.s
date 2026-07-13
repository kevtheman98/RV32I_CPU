.text
.global _start
_start:
    
    # Arithmetic Operations in ALU
    
    # test add

    addi x2, 0x, 20
    addi x3, 0x, 10

    addi x4, 0x, 30

    add x5, x2, x3  

    beq x5, x4, pass

    # test sub

    addi x2, 0x, 20
    addi x3, 0x, 10

    addi x4, 0x, 10

    sub x5, x2, x3  

    beq x5, x4, pass

    sw x0, 1024(0x)

    pass: 
        addi x31, 0x, 1
        sw x31, 1024(0x)
    

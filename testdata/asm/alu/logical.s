.text
.global _start
_start:
    
    # Logical Operations in ALU
    
    # test AND


    # test OR

    addi x2, 0x, 13 #1101
    addi x3, 0x, 14 #1110

    addi x4, 0x, 15 #1111

    or x5, x2, x3  

    beq x5, x4, pass

    # test XOR

    addi x2, 0x, 12 #1100
    addi x3, 0x, 14 #1110

    addi x4, 0x, 2 #0010

    xor x5, x2, x3  

    beq x5, x4, pass

    sw x0, 1024(0x)

    pass:
        addi x31, 0x, 1
        sw x31, 1024(0x)
    

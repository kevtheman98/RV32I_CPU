.text
.global _start
_start:
    addi x2, x0, 13 #1101
    addi x3, x0, 14 #1110

    addi x4, x0, 15 #1111

    or x5, x2, x3  

    beq x5, x4, pass

    sw x0, 1024(x0)

    pass:
        addi x31, x0, 1
        sw x31, 1024(x0)
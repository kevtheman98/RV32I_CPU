.text
.global _start
_start:

    addi x4, x0, 12 #1100

    addi x5, x0, 3 #0011

    sra x6, x4, 2

    beq x5, x6, pass

    sw x0, 1024(x0)

    pass:
        addi x31, x0, 1
        sw x31, 1024(x0)
    

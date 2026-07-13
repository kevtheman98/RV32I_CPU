.text
.global _start
_start:    
    addi x2, x0, 20
    addi x3, x0, 10

    addi x4, x0, 10

    sub x5, x2, x3  

    beq x5, x4, pass

    sw x0, 1024(x0)

    pass: 
        addi x31, x0, 1
        sw x31, 1024(x0)
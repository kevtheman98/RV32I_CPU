.text
.global _start
_start:
    
    addi x2, x0, 14
    jal x1, func

    beq x2, x6, pass

    sw x0, 2044(x0)

    fail:
        beq x0,x0, fail

    pass:
        addi x31, x0, 1
        sw x31, 2044(x0)

    func:
        addi x6, x0, 14 #1110
        jalr x0, 0(x1)

    
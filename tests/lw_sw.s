.text
.global _start
_start:

    addi x2, x0, 2 #0010
    addi x3, x0, 14 #1110

    sw x3, (x2) # Store 14 in mem[2] 
    lw x6, (x2) # Store 14 in x6

    beq x3, x6, pass

    sw x0, 2044(x0)

    fail:
        beq x0,x0, fail

    pass:
        addi x31, x0, 1
        sw x31, 2044(x0)
    
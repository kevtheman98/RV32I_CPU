.text
.global _start # lets linker see start
_start:
      jal x1, label
      addi x2, x0, 100
      addi x3, x0, 15

      add x4, x1, x2
      add x5, x2, x3
      add x6, x3, x3

      addi x7, x0, 15

      beq x3, x7, equal

      addi x8, x0, 20

      equal:
        addi x9, x0, 25
        jal x0, end

      sw x2, 4(x2)
      lw x10, 4(x2)
      label:
        addi x11, x0, 11
        jalr x0, x1, 0
        
      end:
        beq x0, x0, end
.section .text
.global _entry, test
_entry:
        la sp, stack0
        li a0, 1024*12
        # 对于一个单核系统 这里不需要考虑hartid的数量
        add sp, sp, a0
        
        call test_BSS

        call start

test:
        li t0, 0x10000000
        sb a0, 0(t0)
        ret

spin:
        j spin
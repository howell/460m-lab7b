addi $0,$0,19   # r0 <= 19      0010.0000.0000.0000.0000.0000.0001.0011
add $31,$0,$0   # r31 <= 38     0000.0000.0000.0000.1111.1000.0010.0000
sub $1,$31,$0   # r1 <= 19      0000.0011.1110.0000.0000.1000.0010.0010
xor1 $2,$31,$1  # r2 <= 53      0000.0011.1110.0001.0001.0000.0010.0110
and1 $3,$2,$0   # r3 <= 17      0000.0000.0100.0000.0001.1000.0010.0100
or1 $4,$31,$3   # r4 <= 55      0000.0011.1110.0011.0010.0000.0010.0101
slt $5,$3,$1    # r5 <= 1       0000.0000.0110.0001.0010.1000.0010.1010
shr $6,$2,1     # r6 <= 26      0000.0000.0000.0010.0011.0000.0100.0010
shl $7,$1,1     # r7 <= 38      0000.0000.0000.0001.0011.1000.0100.0000
andi $8,$2,44   # r8 <= 36      0011.0000.0100.1000.0000.0000.0010.1100
ori $9,$6,96    # r9 <= 122     0011.0100.1100.1001.0000.0000.0111.1010
lui $10,18      # r10 <= 18     0011.1100.0000.1010.0000.0000.0001.0010
mult $9,$9      # {HI,LO}<=14884 0000.0001.00101.0001.0000.0000.0001.1000
mfhi $11        # r11 <= 0      0000.0000.0000.0000.0101.1000.0001.0000
mflo $12        # r12 <= 14884  0000.0000.0000.0000.0110.0000.0001.0010
add8 $13,$9,$8  # r13 <= ?      0000.0001.0010.1000.0110.1000.0010.1101
rbit $14, $4    # r14 <= 55 reversed 0000.0001.1100.0100.0000.0000.0010.1111
rev $15, $31    # r15 <= 38 byte rev 0000.0001.1111.1111.0000.0000.0011.0000
sadd $16,$12,$12# r16 <= ?      0000.0001.1000.1100.1000.0000.0011.0001
ssub $17,$8,$7  # r17 <= 0      0000.0001.0000.0111.1000.1000.0011.0010

sw $0,0($2)    # M[53] <= 19    1010.1100.0100.0000.0000.0000.0000.0000
sw $31,31($2)  # M[54] <= 38    1010.1100.0101.1111.0000.0000.0001.1111
sw $1,1($2)    # M[54] <= 19    1010.1100.0100.0001.0000.0000.0000.0001
sw $2,2($2)    # M[55] <= 53    1010.1100.0100.0010.0000.0000.0000.0010
sw $3,3($2)    # M[56] <= 17    1010.1100.0100.0011.0000.0000.0000.0011
sw $4,4($2)    # M[57] <= 55    1010.1100.0100.0100.0000.0000.0000.0100
sw $5,5($2)    # M[58] <= 1     1010.1100.0100.0101.0000.0000.0000.0101
sw $6,6($2)    # M[59] <= 26    1010.1100.0100.0110.0000.0000.0000.0110
sw $7,7($2)    # M[60] <= 38    1010.1100.0100.0111.0000.0000.0000.0111
sw $8,8($2)    # M[61] <= 36    1010.1100.0100.1000.0000.0000.0000.1000
sw $9,9($2)    # M[62] <= 122   1010.1100.0100.1001.0000.0000.0000.1001

sw $10,10($2)  # M[63] <= 18    1010.1100.0100.1010.0000.0000.0000.1010
sw $11,11($2)  # M[64] <= 0     1010.1100.0100.1011.0000.0000.0000.1011
sw $12,12($2)  # M[65] <= 14884 1010.1100.0100.1100.0000.0000.0000.1100
sw $13,13($2)  # M[66] <= ?     1010.1100.0100.1101.0000.0000.0000.1101
sw $14,14($2)  # M[67] <= ?     1010.1100.0100.1110.0000.0000.0000.1110
sw $15,15($2)  # M[68] <= ?     1010.1100.0100.1111.0000.0000.0000.1111
sw $16,16($2)  # M[69] <= ?     1010.1100.0101.0000.0000.0000.0001.0000
sw $17,17($2)  # M[70] <= 0     1010.1100.0101.0001.0000.0000.0001.0001
sw $18,18($2)  # M[71] <=       1010.1100.0101.0010.0000.0000.0001.0010

lw $10,5($4)   # r10<=M[60]=38  1000.1100.1000.1010.0000.0000.0000.0101
sw $10,10($2)  # M[63] <= 38    1010.1100.0100.1010.0000.0000.0000.1010

# TODO - jr, lw, sw, beq, bne, j

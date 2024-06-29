/*
Preloads
R0 = 0 (i) 
R1 = 0 (j)
R2 = 16 (minDist)
R3 = 0 (maxDist)
R4 - R6 varied uses


R7 = Branch register

Memory[66] = 0 (used for resetting)


XOR, BGTE, BLTE, LDM, STR, AND, CNT, ADD

Conditional Branching,
3 bits opcode, 3 bits register2, 3 bits lookup

R7 is used as a branch register

Here is an example usage

BGTE R2 End_j -> if R7 >= R2, branch to End_j

Memory[66] = 0
Memory[67] = 64

Branching Lookup
000 -> Loop_i
001 -> Loop_j
010 -> Update_max
011 -> Update_min
100 -> End_j
101 -> 60 decimal value (1nd operand)
110 -> X
111 -> X

Loading Lookup
000 -> R0
001 -> R1
010 -> 66 decimal value
110 -> R6
111 -> R7
101 -> 67
100 -> X
011 -> X

Special instructions

ADD RX RX means to increment, i.e ADD R0 R0 means R0+=1

Confirmed to work, CNT, XOR, ADD, LDM, STM
*/

Loop_i:
    LDM R1 #66 //clear j
    ADD R1 R0 //j =i
    ADD R1 R1 //j++
    ADD R1 R1 //j = i+2
    Loop_j:
        LDM R4 R0 //R4 = Memory[i]
        LDM R5 R1 //R5 = Memory[j]
        XOR R5 R4 //R5 = R5 ^ R4
        CNT R5 R5 //R5 = Bitcount(R5)
        LDM R6 #66 //R6 = 0
        ADD R6 R0 //R6 = i
        ADD R6 R6 //R6 = i+1
        LDM R7 #66 //R7 = 0 (used as a general purpose register this time)
        ADD R7 R1 //R6 = j
        ADD R7 R7 //R7 = j+1
        LDM R4 R6 //R4 = Memory[i+1]
        LDM R7 R7 //R7 = Memory[j+1]
        XOR R4 R7 //R4 = R4 ^ R7
        CNT R4 R4 //R4 = Bitcount(R4)
        ADD R4 R5 //R4 = R4 + R5 (curDist)
        LDM R7 #66 //Reset Branch register
        ADD R7 R4 //R7 = curDist
        BGTE R3 Update_max
        BLTE R2 Update_min
        BLTE #60 End_j //Unconditionally branch to End of j loop if neither condition met. Undconditional since curDist is always < 62
        Update_max:
            LDM R3 #66 //reset max
            ADD R3 R7 //maxDist = curDist
            BLTE R2 End_j //if curDist is also < minDist, fallthrough to update min, else branch to end of j loop
        Update_min:
            LDM R2 #66 //reset min
            ADD R2 R7 //minDist = curDist, now fall through
        End_j:
            ADD R1 R1 //j++
            ADD R1 R1 //j++
            LDM R7 #66 //Reset branch register 
            ADD R7 R1 //R7 = j
            BLTE #60 Loop_j //if j <=60 branch to start of Loop_j, else fall through

    ADD R0 R0 //i++
    ADD R0 R0 //i++
    LDM R7 #66 //reset branch register
    ADD R7 R0 // R7 = i
    BLTE #60 Loop_i //branch to Loop_i if i <= 60, else fall through
LDM R0 #67 //R0 = 64
STM R0 R2 //Memory[64] = minDist
ADD R0 R0 //R0 = 65
STM R0 R3 //Memory[65] = maxDist








    


    


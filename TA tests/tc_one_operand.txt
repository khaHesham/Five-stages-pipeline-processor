#this is a comment 
#all numbers are in hexadecimal
#the reset signal is raised before this code is executed and the flags and the registers are set to zeros.
.ORG 0 #this is the interrupt code
NOT R1
INC R1
OUT R1
RTI
.ORG 200 #this is the instructions code
SETC           #C = 1
NOP            #No change
CLRC           #C = 0
IN R1          #R1= 00000005,add 00000005 on the in port,flags no change	
NOT R1         #R1= FFFFFFFB, C--> no change, N -->1,Z-->0
INC R2	       #R2 =00000001 , C = 0 , N = 0 , Z =0
INC R2         #R2 =00000002 , C = 0 , N = 0 , Z = 0
DEC R2         #R2 =00000001 , C = 0 , N = 0 , Z = 0
OUT R2         #outs 00000001 to the out port,flags no change
OUT R1         #outs FFFFFFFB to the out port,flags no change
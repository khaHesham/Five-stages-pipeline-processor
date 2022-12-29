import re

#read file and store in dectionary
dictionary = {}
with open("Assembler/Dectionary.txt") as f:
    for line in f:
        (key, val) = line.split()
        dictionary[str(key)] = val

#read code
instructions = []
with open("Assembler/code.txt") as f:
    for line in f:
        line = line.upper()
        # ignore comments and empty lines
        line = line.replace('\t', '')   # for empty lines
        line = line.strip()             # squezzing the line --> [k h a l e d] -> line.strip -> [khaled]
        if(len(line) == 0 or line[0] == ';' or line[0] == '#' or line == "\n"):
            continue

        # ignore comments in same line of instruction
        pattern = ";"
        if(re.search(pattern, line)):
            line = line.split(';')[0]
        pattern = "#"
        if(re.search(pattern, line)):
            line = line.split('#')[0]
        # ignore \n if exists
        pattern = "\n"
        if(re.search(pattern, line)):
            line = line.split("\n")[0]

        instructions.append(line)


IRCodes = [] 
addressCounter = 0
interruptAddress = 0
startAddress = 0
isAddress = False


for i,instruction in enumerate(instructions):
    IR = "0000000000000000"
    twoOperands = False
    oneOperand = False

    #handling org
    pattern = '^.ORG*'
    if(re.search(pattern,instruction)):
        skipAmount = int(instruction.split(' ')[1],16)
        if  skipAmount > addressCounter:
            for i in range(addressCounter,skipAmount + 1):
                IRCodes.append(" \n")
            addressCounter = skipAmount
        else:
            addressCounter = skipAmount

        continue

    #handling instructions
    inst = instructions[i].split(' ')[0]

    #Instruction OPcode
    code = dictionary[inst]

    if (code[0:2] == "01"):
        twoOperands = True           
    else:
        oneOperand = True

    IR = code + IR[6:]
    #cut the string after instruction
    Operands = instruction[len(inst)+1:]
    Operands = Operands.strip()

    # {* ========================= one operand & no operand ======================== *} 
    if(oneOperand):
        if(inst == "NOP" or inst == "SETC" or inst == "CLRC"):
            IR = IR[0:6] + "0000000000"
        else:
            IR = IR[0:6] + "000" + dictionary[Operands] + "0000" 
    
        IRCodes.append( IR + "\n")
        addressCounter = addressCounter + 1
        continue

    # {* ================================ two operand =============================== *}  
    if(twoOperands):
        src = Operands.split(',')[0]
        dst = Operands.split(',')[1]

        #check for special cases 
        if(inst == "LDM"):   
            IR = IR[0:6] + "000" + dictionary[src] + "0000"
            IRCodes.append( IR + "\n")
            addressCounter = addressCounter + 1
            IRCodes.append( bin(int(dst, 16))[2:].zfill(16) + "\n")  # get immediate value
            addressCounter = addressCounter + 1
            continue
        elif(inst == "SHL" or inst == "SHR"):
            shiftamount = bin(int(dst))[2:].zfill(4)
            IR = IR[0:6]  + dictionary[src] + "000" + shiftamount
            IRCodes.append( IR + "\n")
            addressCounter = addressCounter + 1
        else:
            IR = IR[0:6] + dictionary[src] + dictionary[dst]+ '0000'
            IRCodes.append( IR +"\n")
            addressCounter = addressCounter + 1
            continue
 

#writing IR codes in output file
outputFile = open("Processor/1.Fetch/memory.txt","w")
outputFile.writelines(IRCodes)
outputFile.close()
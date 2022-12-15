import re

#read file and store in dectionary
dictionary = {}
with open("Dectionary.txt") as f:
    for line in f:
        (key, val) = line.split()
        dictionary[str(key)] = val

#read code
instructions = []
with open("code.txt") as f:
    for line in f:
        line = line.upper()
        # ignore comments and empty lines
        line = line.replace('\t', '')   # for empty lines
        line = line.strip()             # squezzing the line -> [k h a l e d] -> line.strip -> [khaled]
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

        # split labels and instruction on diffrent lines
        pattern = ':'
        if(re.search(pattern,line)):
            temp = line.split(':')[1]     #label:jmp R1
            pattern = '.*[A-Z].*'
            if(re.search(pattern, temp)):
                instructions.append(line.split(':')[0]+':')
                line = line.split(':')[1]
                line=line.lstrip()
        #save the instructions   
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
    Branch = False


    #handling instructions
    inst = instructions[i].split(' ')[0]
    #Instruction OPcode
    code = dictionary[inst]
    print(code)

    twoOperands = True
    # if(code[4:6] == "10"):
    #     twoOperands = True
        
    # elif(code[4] == "0"):
    #     oneOperand = True
       
    # elif(code[4:6] == "11"):
    #     Branch= True

    IR = code + IR[6:]
    #cut the string after instruction
    Operands = instruction[len(inst)+1:]
    Operands = Operands.strip()

    # {* ========================= one operand & no operand ======================== *} 
    if(oneOperand == True):
        if(inst == "NOP" or inst == "SETC" or inst == "CLRC"):
            IR = IR[0:6] + "0000000000"
            IRCodes.append( IR + "\n")
            addressCounter = addressCounter + 1
            continue
        else:
            IR = IR[0:6] + "000" + dictionary[Operands] + "0000" 
            IRCodes.append( IR + "\n")
            addressCounter = addressCounter + 1
            continue
        
    # {* ================================ two operand ================================ *}  
    if(twoOperands == True):
        src = Operands.split(',')[0]
        dst = Operands.split(',')[1]
        #check if SHL & SHR & LDM 
        if(inst == "SHL" or inst == "SHR" or inst == "LDM"):
            IR = IR[0:6] + "000" + dictionary[src] + "0000"
            IRCodes.append( IR + "\n")
            addressCounter = addressCounter + 1
            IRCodes.append( bin(int(dst, 16))[2:].zfill(16) + "\n")  # get immediate value
            addressCounter = addressCounter + 1
            continue

        else:
            IR = IR[0:6] + dictionary[src] + dictionary[dst]+ '0000'
            IRCodes.append( IR +"\n")
            addressCounter = addressCounter + 1
            continue
 
    # {* ================================== Branch ====================================== *}  
    if(Branch == True):
        if(inst == "RTI" or inst == "RET"):
            IR = IR[0:6] + "0000000000"
        else:
            IR = IR[0:6] + "000" + dictionary[Operands] +"0000" 
        IRCodes.append( IR +"\n")
        addressCounter = addressCounter + 1


#writing IR codes in output file
outputFile = open("../Processor/1.Fetch/memory.txt","w")
outputFile.writelines(IRCodes)
outputFile.close()
import sys

file = open(sys.argv[1])
source = file.read()
file.close()

# Check for illegal symbols and mismatched [] symbols
assert len(set(source) - set("<>+-,.[]\n")) == 0
assert source.count('[') - source.count(']') == 0

tokens = list(source)

jumps = []
memory = [0] * 30000
pointer = 0
instruction_pointer = 0
while instruction_pointer < len(tokens):
    match tokens[instruction_pointer]:
        case '>':
            pointer += 1
            pointer %= 30000
        case '<':
            pointer -= 1
            pointer %= 30000
        case '+':
            memory[pointer] += 1
            memory[pointer] %= 2**8
        case '-':
            memory[pointer] -= 1
            memory[pointer] %= 2**8
        case '.':
            print(chr(memory[pointer]), end="")
        case ',':
            memory[pointer] = sys.stdin.read(1)
        case '[':
            jumps.append(instruction_pointer)
        case ']':
            if memory[pointer] != 0:
                instruction_pointer = jumps.pop()
                continue
            else:
                jumps.pop()
    # input("{}, {}".format(tokens[instruction_pointer], memory[0:10]))
    instruction_pointer += 1

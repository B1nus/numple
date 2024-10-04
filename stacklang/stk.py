import sys

source_path = sys.argv[1]

def tokenize(filepath):
    source_file = open(filepath)
    source_lines = [line.strip().split() for line in source_file.readlines() if line.strip().split()]
    source_file.close()

    return list(source_lines)

def parse(tokens):
    statements = []
    labels = {}
    for token_id, token in enumerate(tokens):
        opcode = token[0]

        if opcode.endswith(":"):
            labels[opcode[:-1]] = len(statements)
            continue

        match opcode:
            case "PUSH":
                number = int(token[1])
                statements.append((opcode, number))
            case "PRINT":
                statements.append((opcode, ' '.join(token[1:])))
            case "JUMP.EQ.0":
                statements.append((opcode, token[1]))
            case "JUMP.GT.0":
                statements.append((opcode, token[1]))
            case _:
                statements.append((opcode,))

    return statements, labels

def evaluate(statements, labels, stack_size=10):
    stack = [0] * stack_size
    statement_pointer = 0
    opcode = None
    while opcode != "HALT":
        statement = statements[statement_pointer]
        opcode = statement[0]

        match opcode:
            case "PUSH":
                stack.append(statement[1])
            case "POP":
                stack.pop()
            case "SUB":
                stack.append(-stack.pop() + stack.pop())
            case "ADD":
                stack.append(stack.pop() + stack.pop())
            case "READ":
                stack.append(int(input("READ: ")))
            case "PRINT":
                print(statement[1])
            case "JUMP.EQ.0":
                if stack[-1] == 0:
                    statement_pointer = labels[statement[1]]
                    continue
            case "JUMP.GT.0":
                if stack[-1] > 0:
                    statement_pointer = labels[statement[1]]
                    continue

        statement_pointer += 1

tokens = tokenize(source_path)
statements, labels = parse(tokens)
evaluate(statements, labels)

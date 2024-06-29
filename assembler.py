opcode_mapping = {
    'AND': '000', 'ADD': '001', 'XOR': '011', 'CNT': '100', 
    'LDM': '101', 'STM': '110', 'BGTE': '111', 'BLTE': '010'
}

register_mapping = {
    'R0': '000', 'R1': '001', 'R2': '010', 'R3': '011', 
    'R4': '100', 'R5': '101', 'R6': '110', 'R7': '111'
}

branch_lookup = {
    'Loop_i': '000', 'Loop_j': '001', 'Update_max': '010', 
    'Update_min': '011', 'End_j': '100', '62': '101'
}

load_lookup = {
    'R0': '000', 'R1': '001', '66': '010', 'R6': '110', 
    'R7': '111', '67' : '011'
}


def encode_instruction(instruction, labels):
    # Remove comments from the instruction
    if '//' in instruction:
        instruction = instruction.split('//')[0].strip()

    parts = instruction.split()
    if not parts:
        return ""  # return an empty string if the line was just a comment

    operation = parts[0]
    op_code = opcode_mapping.get(operation, '???')

    # Handle immediate values and label references in branching
    operands = []
    for part in parts[1:]:
        if part.startswith('#'):  # Immediate value handling
            operands.append(load_lookup.get(part[1:], '???'))
        elif part in labels:  # Branch label handling
            operands.append(labels[part])
        else:
            operands.append(register_mapping.get(part, '???'))

    return f"{op_code}" + "".join(operands)

def assemble_program(program):
    lines = program.strip().split('\n')
    labels = {}
    # First pass to collect labels and remove comments
    processed_lines = []
    for line in lines:
        comment_index = line.find('//')
        if comment_index != -1:
            line = line[:comment_index].strip()

        if line.endswith(':'):
            label = line[:-1]
            labels[label] = f"{len(labels):03b}"  # Binary encoding of label index
        processed_lines.append(line)

    print("Processed lines:", processed_lines)  # Debug print

    # Second pass to encode instructions
    machine_code = []
    for line in processed_lines:
        if not line.endswith(':') and line:
            encoded = encode_instruction(line, labels)
            print("Encoding:", line, "->", encoded)  # Debug print
            machine_code.append(encoded)

    return "\n".join(machine_code)

    # Second pass to encode instructions
    machine_code = []
    for line in processed_lines:
        if not line.endswith(':') and line:
            encoded = encode_instruction(line, labels)
            machine_code.append(encoded)

    return "\n".join(machine_code)

def encode_instruction(instruction, labels):
    # Remove comments from the instruction
    if '//' in instruction:
        instruction = instruction.split('//')[0].strip()

    parts = instruction.split()
    if not parts:
        return ""  # return an empty string if the line was just a comment

    operation = parts[0]
    op_code = opcode_mapping.get(operation, '???')

    # Handle immediate values and label references in branching
    operands = []
    for part in parts[1:]:
        if part.startswith('#'):  # Immediate value handling
            operands.append(load_lookup.get(part[1:], '???'))
        elif part in labels:  # Branch label handling
            operands.append(labels[part])
        else:
            operands.append(register_mapping.get(part, '???'))

    return f"{op_code}" + "".join(operands)

def read_program(file_path):
    try:
        with open(file_path, 'r') as file:
            program = file.read()
            return program
    except Exception as e:
        print(f"Failed to read file: {e}")
        return ""


def write_to_file(filename, data):
    with open(filename, 'w') as file:
        file.write(data)


file_path = 'program1.txt'
assembly_program = read_program(file_path)
machine_code = assemble_program(assembly_program)

write_to_file('mach_code.txt', machine_code)

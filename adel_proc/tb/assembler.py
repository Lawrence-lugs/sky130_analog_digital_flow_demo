def convert_to_twos_complement(value, num_bits):
    return bin((1 << num_bits) + value if value < 0 else value)[2:].zfill(num_bits)

def parse_instruction(instruction):
    register_mapping = {'R0': '00', 'R1': '01', 'R2': '10', 'R3': '11'} # Register assignment for mux/demux selectors
    operation_mapping = {'ADD': '00', 'SUB': '01', 'AND': '10', 'OR': '11'} # Operation assignment
    condition_mapping = {'EQ': '00', 'NE': '11', 'LT': '01', 'GT': '10'} # Branch condition check for PC mux selector
    
    parts = instruction.split()
    write_en = str(int(not parts[0].startswith('B'))) # Always write unless it is a branch
    operation = condition_mapping[parts[0].lstrip('B')] if parts[0].startswith('B') else operation_mapping[parts[0].rstrip('I')] # Extract the operation bits
    const_sel = str(int(not (parts[0].endswith('I') or parts[0].startswith('B')))) # Everything that ends with I is an immediate
    destreg = '00' if parts[0].startswith('B') else register_mapping[parts[1].rstrip(',')] # This is a don't care if it is a branch instruction actually
    
    # If instruction is branch, the source register is the register at index 1 (destreg), else it is at index 2 (since dest register would be at index 1)
    srcreg = register_mapping[parts[1].rstrip(',')] if parts[0].startswith('B') else register_mapping[parts[2].rstrip(',')] 
    
    if parts[0].endswith('I'):  # If the instruction is an immediate type, convert to two's complement notation
        const = convert_to_twos_complement(int(parts[3].rstrip(',')), 8)
    elif parts[0].startswith('B'): # Branch instructions have their constants on index 2 instead of 3
        const = convert_to_twos_complement(int(parts[2].rstrip(',')), 8)
    else: # If the instruction does not have a constant, then it is a purely register-based instruction
        const = '000000' + register_mapping[parts[3].rstrip(',')]

    binary_result = write_en + operation + const_sel + destreg + srcreg + const # Combine all binary into 16-bit instruction
    hex_result = hex(int(binary_result, 2))[2:].zfill(4).upper() # convert to hex
    return hex_result
# End of actual assembler function. Less than 30 lines!

# Supported instructions:
    # ADD R1, R2, R3    R1 = R2 + R3
    # ADDI R1, R2, 5    R1 = R2 + 5 (constant [-128, 127])
    # SUB R1, R2, R3    R1 = R2 - R3
    # SUBI R1, R2, 5    R1 = R2 - 5 (constant [-128, 127])
    # AND R1, R2, R3    R1 = R2 & R3 (bitwise)
    # ANDI R1, R2, 5    R1 = R2 & 5 (bitwise against a constant [-128, 127])
    # OR R1, R2, R3     R1 = R2 | R3 (bitwise)
    # ORI R1, R2, 5     R1 = R2 | 5 (bitwise against a constant [-128, 127])
    # BEQ R0, -4        If R0 = 0, jump to -4 (constant [-128, 127]) instructions from the current instruction
    # BNE R0, -4        If R0 != 0, jump to -4 (constant [-128, 127]) instructions from the current instruction
    # BLT R0, -4        If R0 < 0, jump to -4 (constant [-128, 127]) instructions from the current instruction
    # BGT R0, -4        If R0 > 0, jump to -4 (constant [-128, 127]) instructions from the current instruction
    
# Some example assembly code to test the processor
instructions_multiply = [ # Multiplication using repeated addition, R0 * R1 = R2
    "ADDI R0, R0, 15",  # Load initial value of R0 = 15, R0 = R0 + 15
    "ADDI R1, R1, 7",   # Load initial value of R1 = 7, R1 = R1 + 7
    "BEQ R1, 4",        # Check if R1 = 0, if it is, exit (go to end)
    "ADD R2, R2, R0",   # R2 = R2 + R0 (R2 is the accumulator)
    "SUBI R1, R1, 1",   # R1 = R1 - 1 (reduce this until it reaches 0)
    "BNE R1, -2",       # Loop back 3 steps backward
    "BEQ R1, 0"         # Infinite loop to halt operation
]

instructions_divide = [ # Division using repeated subtraction, R0/R1 = R2 remainder R0
    "ADDI R0, R0, 17",  # Load initial value of R0 = 17
    "ADDI R1, R1, 5",   # Load initial value of R1 = 5
    "SUB R3, R0, R1",   # Subtract R0 and R1 to check if R0 < R1
    "BLT R3, 4",        # Check if R0 < R1, if it is, exit (go to end)
    "ADDI R2, R2, 1",   # Update the quotient, R2 = R2 + 1
    "SUB R0, R0, R1",   # Update the remainder, R0 = R0 - R1
    "BGT R1, -4",       # Loop back 3 steps backward
    "BLT R3, 0"         # Infinite loop to halt operation
]

instructions_fibonacci = [ # Calculate the nth fibonacci number stored at R0, result appears on R3
    "ADDI R0, R0, 8",    # Load initial value of R0 = 5
    #"ADDI R1, R1, 0",   # Load initial value of R1 = 0
    "ADDI R2, R2, 1",   # Load initial value of R2 = 1
    "ADDI R3, R2, 0",   # Set initial value of R3, the first fibonacci number
    "SUBI R0, R0, 1",   # Decrement the fibonacci number counter
    "BEQ R0, 5",        # Check if R0 = 0, if it is, exit (go to end)
    "ADD R3, R1, R2",   # Fibonacci sequence is the sum of two previous values
    "ADDI R1, R2, 0",   # R1 gets R2 to move the two previous values
    "ADDI R2, R3, 0",   # R2 gets R3 to move the two previous values
    "BNE R0, -5",       # Loop back 5 steps backward
    "BEQ R0, 0"         # Infinite loop to halt operation
]

instructions_seven_segment = [ # Count 0 to 9 on R3 (R3 has the connection to 7 segment decoder)
    "ADDI R3, R3, 1",   # Increment R3 (R3 = R3 + 1)
    "SUBI R2, R3, 9",   # Check if R3 equals 9 (we're at the limit), store it at R2
    "BNE R2, -2",       # If R3 != 9 (R2 = R3 - 9, R2 != 0), we're good, just loop back
    "SUB R3, R3, R3",   # If R3 == 9 (R2 = R3 - 9, R2 == 0), reset R3 back to 0 (R3 = R3-R3)
    #"SUB R2, R2, R2",   # This is just an extra instruction to balance the delay before changing R3 again
    "BEQ R3, -4"        # This creates an infinite loop back to the starting point (R3 = 0 at this point)
]

instructions_two_segments = [ # Count 00 to 99 on R3 (upper 4 bits of R3 is tens, lower 4 bits of R3 is ones)
    # start:
    "SUB R3, R3, R3",   # Reset R3 to 0. (R3 = R3-R3)
    # loop:
    "ADDI R3, R3, 1",   # Increment R3 (R3 = R3 + 1).
    "ANDI R0, R3, 15",  # Check the last 4 bits of R3. AND R3 with 0x0F, put it in R0 for now.
    "SUBI R2, R0, 9",   # Subtract last 4 bits of R3 (contained in R0) with 9, to check if we are at the limit.
    "BNE R2, -3",       # If R0 != 9 (R2 = R0 - 9, R2 != 0), we're good, just loop back (BNE R2, loop)
    "SUBI R0, R3, 153", # Subtract R3 with 0x99 (153 in decimal) to check if we are at the limit
    "BEQ R0, -6",       # If R3 == 0x99 (R0 = R3 - 99, R0 == 0), loop at the start of the program to zero out R3 (BEQ R0, start)
    "ADDI R3, R3, 7",   # Else if we're not at the limit, add 7 to 9 = 16 = 0x10 (this increments the tens digit (upper 4 bits)
    "BNE R3, -7",       # then go back to the delay padding (BNE R3, loop)
]

# This is the balanced delay version of the previous code
# This ensures that all updates to R3 have equal instructions in between (in this case, 5 instructions)
# This makes the counting interval equal during simulation, especially evident if you are running the clock automatically (CTRL+K in Logisim)
instructions_two_segments_balanced = [ # Count 00 to 99 on R3 (upper 4 bits of R3 is tens, lower 4 bits of R3 is ones). 
    # start:
    "SUB R3, R3, R3",   # Reset R3 to 0. (R3 = R3-R3)
    "ADD R0, R0, R0",   # This is just a padding to balance out the delay
    # loop_tens:
    "ADD R0, R0, R0",   # This is just a padding to balance out the delay
    "ADD R0, R0, R0",   # This is just a padding to balance out the delay
    # loop_ones:
    "ADD R0, R0, R0",   # This is just a padding to balance out the delay
    "ADD R0, R0, R0",   # This is just a padding to balance out the delay
    "ADDI R3, R3, 1",   # Increment R3 (R3 = R3 + 1) after 5 instruction delay.
    "ANDI R0, R3, 15",  # Check the last 4 bits of R3. AND R3 with 0x0F, put it in R0 for now.
    "SUBI R2, R0, 9",   # Subtract last 4 bits of R3 (contained in R0) with 9, to check if we are at the limit.
    "BNE R2, -5",       # If R0 != 9 (R2 = R0 - 9, R2 != 0), we're good, just loop back (BNE R2, loop_ones)
    "SUBI R0, R3, 153", # Subtract R3 with 0x99 (153 in decimal) to check if we are at the limit
    "BEQ R0, -11",      # If R3 == 0x99 (R0 = R3 - 99, R0 == 0), loop at the start of the program to zero out R3 (BEQ R0, start)
    "ADDI R3, R3, 7",   # Else if we're not at the limit, add 7 to 9 = 16 = 0x10 (this increments the tens digit (upper 4 bits)
    "BNE R3, -11",      # then go back to the delay padding (BNE R3, loop_tens)
]

instructions_quiz = [
    "ADDI R1, R1, 2",
    "ADDI R0, R0, -1",
    "ADDI R3, R1, -88",
    "ADDI R2, R1, -121",
    "ANDI R1, R3, -16",
    "ANDI R0, R2, 15",
    "OR R0, R1, R0"
]

instructions_shotclock = [ # Count down from 24 to 0 then infinite loop at the end
    "SUB R3, R3, R3",   # Reset R3 to 0. (R3 = R3-R3)
    "ADDI R3, R3, 36",  # Load initial value of R3 = 0x24
    # loop:
    "SUBI R3, R3, 1",   # Subtract 1 from R3
    "ANDI R0, R3, 15",  # Check the last 4 bits of R3. AND R3 with 0x0F, put it in R0 for now.
    "BNE R0, -2",       # If last 4 bits are not yet 0, go back to count down
    "BEQ R3, 3",        # If R3 = 0x00 already, go to end. Otherwise, continue countdown
    "SUBI R3, R3, 7",   # Subtract 0x10 from tens digit and and add 0x09 to ones digit
    "BNE R3, -5",       # then go back to loop
    "BEQ R3, 0"         # infinite loop
]

instructions_test1 = [  # This is the sample code used in the lecture. Just plain arithmetic instructions.
    "ADDI R3, R0, 113",   # R3 = R0 + 113 = 0 + 113 = 113
    "ADDI R2, R2, 21",    # R2 = R2 + 21 = 0 + 21 = 21
    "SUB R1, R3, R2",     # R1 = R3 - R2 = 113 - 21 = 92
    "ANDI R1, R1, 15",    # R1 = R1 & 15 = 92 (0101 1100) & 15 (0000 1111) = 12 (0000 1100)
    "OR R0, R2, R1"       # R0 = R2 | R1 = 21 (0001 0101) | 12 (0000 1100) = 29 (0001 1101)
]

instructions_test2 = [  # This is the sample code used in the lecture to demonstrate a branch instruction.
    "ADDI R2, R2, 5",   # R2 = R2 + 5 = 0 + 5 = 5
    "ADDI R1, R1, 1",   # R1 = R1 + 1
    "SUBI R2, R2, 1",   # R2 = R2 - 1
    "BNE R2, -2"        # As long as R2 != 0, loop two steps backward (back to ADDI R1, R1, 1)
]

# Pick the instructions to assemble into hexcode
instructions = instructions_fibonacci
#instructions = ["SUBI R3, R1, -31"] # The 0xADE1 instruction :)
#instructions = ["ANDI R2, R1, -113"]
hex_results = [parse_instruction(instruction) for instruction in instructions]

with open('instructions.txt', 'w') as file:
    # print('v2.0 raw',file=file) # header for Logisim memory
    print(' '.join(hex_results), file=file)
    print(' '.join(hex_results))
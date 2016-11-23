# Compiler for Pipelined VHDL

def encode(instr): # take instruction string and return binary rep
	op_string = instr.split(' ', 1)

	print op_string

string add = "add 9,8,7"

encode(add)

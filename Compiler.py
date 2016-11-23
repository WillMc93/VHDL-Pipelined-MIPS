# Compiler for Pipelined VHDL
class MIPS():
	def parse(self, instr): # take instruction string and return binary rep
		instr = instr.strip() # get rid of leading/trailing spaces

		# go ahead and declare these
		label = ""
		op = ""
		rd = ""
		rs = ""
		rt = ""
		offset = ""

		# Check for and get this.label
		pos = instr.find(':') # get colon position
		if pos > 0:
			temp = instr.split(':', 1) # split the string at the label
			label = temp[0][:pos] # copy the label to the colon
			instr = temp[1].strip() # make cut; stripping leading/trailing spaces

		# Get Operation
		pos = instr.find(' ')
		if pos > 4 or pos < 1:
			print "ERROR: could not find Operation"
		else:
			instr = instr.split(' ', 1) # break up the instruction
			op = instr[0][:pos] # copy operation
			instr = instr[1].replace(' ', '') # make cut; deleting all spaces

		# Get Registers/Label
		pos = instr.find(',')
		if pos < 0:
			offset = instr;
		else:
			instr = instr.split(',') # split at all remaing commas


		print instr
		if label != "": print label
		print op
		if offset != "": print offset
		if rd != "": print rd
		if rs != "": print rs
		if rt != "": print rt


mips = MIPS()
add = "hey: addi 9 ,8 , 7"
mips.parse(add)

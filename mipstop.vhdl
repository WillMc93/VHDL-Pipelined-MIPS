library IEEE;
use ieee.std_logic_1164.all;

entity MIPS is
	generic (ADDR: integer := 16; WORD: integer := 16; ALUOP_len: integer := 3;
				REG: integer := 3; JumpOP: integer := 3; OP: integer := 4;
				IMMED: integer := 6);
	port (
		CLK: in std_logic;
		RST: in std_logic;

		Instr: in std_logic_vector(WORD - 1 downto 0);
		ReadBus: in std_logic_vector(WORD - 1 downto 0);
		WriteBus: out std_logic_vector(WORD - 1 downto 0)
	);

end entity MIPS;

architecture pipeline of MIPS is
	---------------------------
	-- Component Instantiation
	---------------------------
	-- Instruction Fetch Components
	component PC is
		generic (ADDR: integer);
		port (
			CLK: in std_logic;
			RST: in std_logic;

			PC_in: in std_logic_vector(ADDR - 1 downto 0);
			PCSrc: in std_logic;
			--JAL: in std_logic;
			--JR: in std_logic;

			PC1_out: out std_logic_vector(ADDR - 1 downto 0);
			PC_out: out std_logic_vector(ADDR - 1 downto 0)
		);
	end component PC;

	component InstrMem is
		generic (ADDR: integer; WORD: integer);
		port (
			CLK: in std_logic;
			PC_in: in std_logic_vector(ADDR - 1 downto 0);

			Instr_out: out std_logic_vector(WORD - 1 downto 0)
		);
	end component InstrMem;

	component IF_IDReg is
		generic (WORD: integer);
		port (
			CLK: in std_logic;
			RST: in std_logic;
			PC_in: in std_logic_vector(WORD - 1 downto 0);
			Instr_in: in std_logic_vector(WORD - 1 downto 0);

			PC_out: out std_logic_vector(ADDR - 1 downto 0);
			Instr_out: out std_logic_vector(WORD - 1 downto 0)
		);
	end component IF_IDReg;


	-- Instruction Decode Components
	component CtrlCircuit is
		generic (OP: integer);
		port (
			CLK: in std_logic;
			Instr: in std_logic_vector (OP - 1 downto 0);

			RegDest: out std_logic := '0';
			ALUSrc: out std_logic := '0';
			MemToReg: out std_logic := '0';
			RegWrite: out std_logic := '0';
			MemRead: out std_logic := '0';
			MemWrite: out std_logic := '0';
			Branch: out std_logic := '0';
			BranchType: out std_logic := '0';
			JumpOP: out std_logic_vector (2 downto 0):= (others => '0');
			ALUOP: out std_logic_vector (2 downto 0) := (others => '0')
		);
	end component CtrlCircuit;

	component RegFile is
		generic (WORD: integer; REG: integer);
	  	port (
	    	CLK: in std_logic; -- CLOCK
	    	RST: in std_logic; -- RESET

	    	-- inputs
	    	read1: in std_logic_vector(REG - 1 downto 0); -- register 1 address
	    	read2: in std_logic_vector(REG - 1 downto 0); -- register 2 address
	    	writeAddr: in std_logic_vector(REG - 1 downto 0); -- write register address
	    	writeData: in std_logic_vector(WORD - 1 downto 0); -- data to be written
	    	RegWrite: in std_logic; -- regWrite control

	    	-- outputs
	    	data1: out std_logic_vector(WORD - 1 downto 0); -- register 1 data
	    	data2: out std_logic_vector(WORD - 1 downto 0) -- register 2 data
	  	);
	end component RegFile;

	component SignExtend is
		generic (WORD: integer; IMMED: integer);
		port (
			CLK: in std_logic;
		
			Immediate_in: in std_logic_vector(IMMED - 1 downto 0);
			Immediate_out: out std_logic_vector(WORD - 1 downto 0)
		);
	end component SignExtend;

	component ID_EXReg is
		generic (WORD: integer; REG: integer);
		port (
			CLK: in std_logic;
			RST: in std_logic;

			-- inputs
			PC1_in: in std_logic_vector(WORD - 1 downto 0);
			RtAddr_in: in std_logic_vector(REG - 1 downto 0);
			RdAddr_in: in std_logic_vector(REG - 1 downto 0);
			Data1_in: in std_logic_vector(WORD - 1 downto 0);
			Data2_in: in std_logic_vector(WORD - 1 downto 0);
			Immediate_in: in std_logic_vector(WORD - 1 downto 0);

			-- outputs
			PC1_out: out std_logic_vector(WORD - 1 downto 0);
			RtAddr_out: out std_logic_vector(REG - 1 downto 0);
			RdAddr_out: out std_logic_vector(REG - 1 downto 0);
			Data1_out: out std_logic_vector(WORD - 1 downto 0);
			Data2_out: out std_logic_vector(WORD - 1 downto 0);
			Immediate_out: out std_logic_vector(WORD - 1 downto 0)
		);
	end component ID_EXReg;


	-- Execution Components
	component ALU is
		generic (WORD: integer; ALUOP: integer);
		port (
			CLK: in std_logic;

			Data1: in std_logic_vector(WORD - 1 downto 0);
			Data2: in std_logic_vector(WORD - 1 downto 0);
			Immed: in std_logic_vector(WORD - 1 downto 0);

			ALUSrc: in std_logic;
			Func: in std_logic_vector(ALUOP - 1 downto 0);
			ALUOP_in: in std_logic_vector(ALUOP - 1 downto 0);

			result: out std_logic_vector(WORD - 1 downto 0);
			ZERO: out std_logic
		);
	end component ALU;

	component Jumper is
		generic (WORD: integer; ADDR: integer);
		port (
			CLK: in std_logic;
			RST: in std_logic;

			Branch: in std_logic;
			BranchType: in std_logic;
			Jump: in std_logic;
			JAL_in: in std_logic;
			JR_in: in std_logic;

			PC1: in std_logic_vector(ADDR - 1 downto 0);
			Data1: in std_logic_vector(WORD - 1 downto 0);
			Data2: in std_logic_vector(WORD - 1 downto 0);
			Immed: in std_logic_vector(ADDR - 1 downto 0);

			PC_out: out std_logic_vector(ADDR - 1 downto 0);
			PCSrc: out std_logic
			--JAL_out: out std_logic;
			--JR_out: out std_logic
		);
	end component Jumper;

	component EX_MReg is
		generic(WORD: integer; REG: integer);
		port (
			CLK: in std_logic;
		    RST: in std_logic;

		    -- inputs
		    ALUresult_in: in std_logic_vector(WORD - 1 downto 0); -- careful
			Data2_in: in std_logic_vector(WORD - 1 downto 0);
			DestAddr_in: in std_logic_vector(REG - 1 downto 0);

		    -- outputs
		    ALUresult_out: out std_logic_vector(WORD - 1 downto 0);
			Data2_out: out std_logic_vector(WORD - 1 downto 0);
		    DestAddr_out: out std_logic_vector(REG - 1 downto 0)
		);
	end component EX_MReg;

	-- Memory Components
	component DataMem is
		generic(ADDR: integer; WORD: integer);
		port (
			CLK: in std_logic;
			ADDR_in: in std_logic_vector(WORD - 1 downto 0);
			Data_in: in std_logic_vector(WORD - 1 downto 0);
			MemWrite_in: in std_logic;
			MemRead_in: in std_logic;

			Data_out: out std_logic_vector(WORD - 1 downto 0)
		);
	end component DataMem;

	component M_WBReg is
		generic (WORD: integer := 16; REG: integer := 3);
	    port (
		    CLK: in std_logic;
		    RST: in std_logic;

		    -- inputs
			Data_in: in std_logic_vector(WORD - 1 downto 0);
			ALUResult_in: in std_logic_vector(WORD - 1 downto 0);
			RegWriteAddr_in: in std_logic_vector(REG - 1 downto 0);

		    -- outputs
		    Data_out: out std_logic_vector(WORD - 1 downto 0);
			ALUResult_out: out std_logic_vector(WORD - 1 downto 0);
			RegWriteAddr_out: out std_logic_vector(REg - 1 downto 0)
		);
	end component M_WBReg;

	-- WriteBack Components
	-- only a mux


	-- Control Register Components
	component ex is
		generic (ALUOP: integer; JUMPOP: integer);
		port (
			CLK: in std_logic;
	    	RST: in std_logic;

	    	-- inputs
			ALUSrc_in: in std_logic;
			RegDest_in: in std_logic;
			ALUOP_in: in std_logic_vector(ALUOP - 1 downto 0);
			JumpOP_in: in std_logic_vector(JUMPOP - 1 downto 0);
			Branch_in: in std_logic;
			BranchType_in: in std_logic;

			-- outputs
			ALUSrc_out: out std_logic;
			RegDest_out: out std_logic;
			ALUOP_out: out std_logic_vector(ALUOP - 1 downto 0);
			JumpOP_out: out std_logic_vector(JUMPOP - 1 downto 0);
			Branch_out: out std_logic;
			BranchType_out: out std_logic
	  	);
	end component ex;

	component m is
		port (
			CLK: in std_logic;
		  	RST: in std_logic;

			-- inputs
			MemWrite_in: in std_logic;
			MemRead_in: in std_logic;

			-- outputs
			MemWrite_out: out std_logic;
			MemRead_out: out std_logic
		);
	end component m;

	component wb is
		port (
			CLK: in std_logic;
			RST: in std_logic;

			-- inputs
			MemToReg_in: in std_logic;
			RegWrite_in: in std_logic;

			-- outputs
			MemToReg_out: out std_logic;
			RegWrite_out: out std_logic
		);
	end component wb;

	-- Miscellaneous Components
	component ORgate is
		port (
			A, B, C: in std_logic;
			O: out std_logic
		);
	end component ORgate;

	component genMux is
		generic (length: integer);
		port (
			I0, I1: in std_logic_vector(length - 1 downto 0);
			Sel: in std_logic;

			Outp: out std_logic_vector(length - 1 downto 0)
		);
	end component genMux;
	
	component genBuffer is
		generic (length: integer);
		port(
			CLK: in std_logic;
			inp: in std_logic_vector(length - 1 downto 0);
			outp: out std_logic_vector(length - 1 downto 0)
		);
	end component genBuffer;


	----------------------
	-- Signal Declaration
	----------------------
	-- Instruction Fetch Signals
	signal PC_in: std_logic_vector(ADDR - 1 downto 0);
	signal PCSrc: std_logic;
	--signal JAL: std_logic;
	--signal JR: std_logic;
	signal IF_PC1_out: std_logic_vector(ADDR - 1 downto 0);
	signal IF_PC_out: std_logic_vector(ADDR - 1 downto 0);
	signal IF_Instr_out: std_logic_vector(WORD - 1 downto 0);
	signal IF_IDRst: std_logic;

	-- Instruction Decode Signals
	signal ID_PC1: std_logic_vector(ADDR - 1 downto 0);
	signal ID_Instr: std_logic_vector(WORD - 1 downto 0);
	signal ID_CtrlBus: std_logic_vector(13 downto 0); -- carries control signals to pipeline register
	signal ID_data1: std_logic_vector(WORD - 1 downto 0);
	signal ID_data2: std_logic_vector(WORD - 1 downto 0);
	signal ID_Immediate: std_logic_vector(WORD - 1 downto 0);
	signal ID_EXRst: std_logic;

	-- Execution Signals
	signal ALUSrc: std_logic;
	signal RegDest: std_logic;
	signal ALUOP: std_logic_vector(ALUOP_len - 1 downto 0);
	signal Jump: std_logic;
	signal JAL: std_logic;
	signal JR: std_logic;
	--signal EX_JAL: std_logic;
	--signal EX_JR: std_logic;
	signal Branch: std_logic;
	signal BranchType: std_logic;
	signal EX_MBus: std_logic_vector(1 downto 0);
	signal EX_WBBus: std_logic_vector(1 downto 0);
	signal EX_PC1: std_logic_vector(ADDR - 1 downto 0);
	signal RtAddr: std_logic_vector(REG - 1 downto 0);
	signal RdAddr: std_logic_vector(REG - 1 downto 0);
	signal Data1: std_logic_vector(WORD - 1 downto 0);
	signal Data2: std_logic_vector(WORD - 1 downto 0);
	signal Immediate: std_logic_vector(WORD - 1 downto 0);
	signal EX_ALUResult: std_logic_vector(WORD - 1 downto 0);
	signal EX_Zero: std_logic;
	signal EX_RegWriteAddr: std_logic_vector(REG - 1 downto 0);

	-- Memory Signals
	signal MemWrite: std_logic;
	signal MemRead: std_logic;
	signal M_WBBus: std_logic_vector(1 downto 0);
	signal M_ALUResult: std_logic_vector(WORD - 1 downto 0);
	signal M_RegWriteAddr: std_logic_vector(REG - 1 downto 0);
	signal M_Data: std_logic_vector(WORD - 1 downto 0);
	signal M_lw_Data: std_logic_vector(WORD - 1 downto 0);

	-- Write Back Signals
	signal RegWriteAddr: std_logic_vector(REG - 1 downto 0);
	signal RegWriteData: std_logic_vector(WORD - 1 downto 0);
	signal RegWrite: std_logic;
	signal MemToReg: std_logic;
	signal WB_Data: std_logic_vector(WORD - 1 downto 0);
	signal WB_ALUResult: std_logic_vector(WORD - 1 downto 0);
	
	-- Buffer Signals (DARN YOU VHDL!!!)
	signal IF_PC1Buffer: std_logic_vector(WORD - 1 downto 0);
	
	signal RdBuffer: std_logic_vector(REG - 1 downto 0);
	signal RtBuffer: std_logic_vector(REG - 1 downto 0);
	signal EX_PC1Buffer: std_logic_vector(WORD - 1 downto 0);
	
	signal EX_RegWriteAddrBuffer: std_logic_vector(REG - 1 downto 0);
	signal EX_MBusBuffer: std_logic_vector(1 downto 0);
	signal EX_WBBusBuffer: std_logic_vector(1 downto 0);
	
	signal M_WBBusBuffer: std_logic_vector(1 downto 0);
	
	signal M_ALUResultBuffer: std_logic_vector(WORD - 1 downto 0);
	signal RegWriteAddrBuffer: std_logic_vector(REG - 1 downto 0);


	-------------------------
	-- Instruction Fetch Map
	-------------------------
	begin
		PrgmCntr: PC
			generic map(ADDR => ADDR)
			port map (
				CLK => CLK,
				RST => RST,

				PC_in => PC_in,
				PCSrc => PCSrc,
				--JAL => JAL,
				--JR => JR,

				PC1_out => IF_PC1_out,
				PC_out => IF_PC_out
			);
		PC1_Buffer: genBuffer
			generic map(length => WORD)
			port map(CLK, IF_PC1_out, IF_PC1Buffer);

		Instruction: InstrMem
			generic map(ADDR => ADDR, WORD => WORD)
			port map(
				CLK => CLK,
				PC_in => IF_PC_out,
				Instr_out => IF_Instr_out
			);

		IF_IDClear: ORgate
			port map (
				A => RST,
				B => PCSrc,
				C => JR,
				O => IF_IDRst
			);

		IF_IDRegister: IF_IDReg
			generic map (WORD => WORD)
			port map (
				CLK => CLK,
				RST => IF_IDRST,
				PC_in => IF_PC1Buffer,
				Instr_in => IF_Instr_out,

				PC_out => ID_PC1,
				Instr_out => ID_Instr
			);

		--------------------------
		-- Instruction Decode Map
		--------------------------
		Ctrl: CtrlCircuit
			generic map (OP => OP)
			port map (
				CLK => CLK,
				Instr => ID_Instr(15 downto 12),

				-- Execution Stage Signals
				ALUSrc => ID_CtrlBus(13),
				RegDest => ID_CtrlBus(12),
				ALUOP => ID_CtrlBus(11 downto 9),
				JumpOP => ID_CtrlBus(8 downto 6),

				-- Memory Stage Signals
				Branch => ID_CtrlBus(5),
				BranchType => ID_CtrlBus(4),
				MemWrite => ID_CtrlBus(3),
				MemRead => ID_CtrlBus(2),

				-- WriteBack Stage Signals
				MemToReg => ID_CtrlBus(1),
				RegWrite => ID_CtrlBus(0)
			);

		Registers: RegFile
			generic map (WORD => WORD, REG => REG)
			port map (
				CLK => CLK,
				RST => RST,

				read1 => ID_Instr(11 downto 9),
				read2 => ID_Instr(8 downto 6),
				writeAddr => RegWriteAddr,
				writeData => RegWriteData,
				RegWrite => RegWrite,

				-- outputs
				data1 => ID_data1,
				data2 => ID_data2
			);

		SigExt: SignExtend
			generic map (WORD => WORD, IMMED => IMMED)
			port map (
				CLK => CLK,
				
				Immediate_in => ID_Instr(5 downto 0),
				Immediate_out => ID_Immediate
			);

		ID_EXClear: ORgate
			port map (
				A => RST,
				B => PCSrc,
				C => JR,
				O => ID_EXRst
			);

		ID_EX: ex
			generic map (ALUOP => ALUOP_len, JumpOP => JumpOP)
			port map (
				CLK => CLK,
				RST => ID_EXRst,

				-- inputs
				ALUSrc_in => ID_CtrlBus(13),
				RegDest_in => ID_CtrlBus(12),
				ALUOP_in => ID_CtrlBus(11 downto 9),
				JumpOP_in => ID_CtrlBus(8 downto 6),
				Branch_in => ID_CtrlBus(5),
				BranchType_in => ID_CtrlBus(4),

				-- outputs
				ALUSrc_out => ALUSrc,
				RegDest_out => RegDest,
				ALUOP_out => ALUOP,
				JumpOP_out(2) => Jump,
				JumpOP_out(1) => JAL,
				JumpOP_out(0) => JR,
				Branch_out => Branch,
				BranchType_out => BranchType
			);
		ID_M: m
			port map (
				CLK => CLK,
				RST => ID_EXRst,

				MemWrite_in => ID_CtrlBus(3),
				MemRead_in => ID_CtrlBus(2),

				MemWrite_out => EX_MBus(1),
				MemRead_out => EX_MBus(0)
			);

		ID_WB: wb
			port map (
				CLK => CLK,
				RST => ID_EXRst,

				-- inputs
				MemToReg_in => ID_CtrlBus(1),
				RegWrite_in => ID_CtrlBus(0),

				-- outputs
				MemToReg_out => EX_WBBus(1),
				RegWrite_out => EX_WBBus(0)
			);

		ID_EXRegister: ID_EXReg
			generic map (WORD => WORD, REG => REG)
			port map (
				CLK => CLK,
				RST => ID_EXRst,

				-- inputs
				PC1_in => ID_PC1,
				RtAddr_in => ID_Instr(8 downto 6),
				RdAddr_in => ID_Instr(5 downto 3),

				Data1_in => ID_data1,
				Data2_in => ID_data2,
				Immediate_in => ID_Immediate,

				-- outputs
				PC1_out => EX_PC1Buffer,
				RtAddr_out => RtBuffer,
				RdAddr_out => RdBuffer,
				Data1_out => Data1,
				Data2_out => Data2,
				Immediate_out => Immediate
			);
			
		RtAddrBuffer: genBuffer
			generic map (length => REG)
			port map (CLK, RtBuffer, RtAddr);
		RdAddrBuffer: genBuffer
			generic map (length => REG)
			port map (CLK, RdBuffer, RdAddr);
		EX_PCOneBuffer: genBuffer
			generic map (length => WORD)
			port map (CLK, EX_PC1Buffer, EX_PC1);
			
			

		-----------------
		-- Execution Map
		-----------------
		ArithmeticUnit: ALU
			generic map (WORD => WORD, ALUOP => ALUOP_len)
			port map (
				CLK => CLK,

				Data1 => Data1,
				Data2 => Data2,
				Immed => Immediate,

				ALUSrc => ALUSrc,
				Func => Immediate(2 downto 0),
				ALUOP_in => ALUOP,

				result => EX_ALUResult,
				ZERO => EX_Zero
			);

		JumpHardware: Jumper
			generic map (WORD => WORD, ADDR => ADDR)
			port map (
				CLK => CLK,
				RST => RST,


				Jump => Jump,
				JAL_in => JAL,
				JR_in => JR,
				Branch => Branch,
				BranchType => BranchType,

				PC1 => EX_PC1,
				Data1 => Data1,
				Data2 => Data2,
				Immed => Immediate, -- arthimetic problem here

				PC_out => PC_in,
				PCSrc => PCSrc
				--JAL_out => JAL,
				--JR_out => JR
			);

		DestMux: genMux
			generic map (length => REG)
			port map (
				I0 => RtAddr,
				I1 => RdAddr,
				Sel => RegDest,

				Outp => EX_RegWriteAddrBuffer
			);
			
		EX_M_Buffer: genBuffer
			generic map (length => 2)
			port map (CLK, EX_MBus, EX_MBusBuffer);

		EX_M: m
			port map (
				CLK => CLK,
				RST => RST,

				MemWrite_in => EX_MBusBuffer(1),
				MemRead_in => EX_MBusBuffer(0),

				MemWrite_out => MemWrite,
				MemRead_out => MemRead
			);
		
		EX_WB_Buffer: genBuffer
			generic map(length => 2)
			port map(CLK, EX_WBBus, EX_WBBusBuffer);

		EX_WB: wb
			port map (
				CLK => CLK,
				RST => RST,

				-- inputs
				MemToReg_in => EX_WBBusBuffer(1),
				RegWrite_in => EX_WBBusBuffer(0),

				-- outputs
				MemToReg_out => M_WBBus(1),
				RegWrite_out => M_WBBus(0)
			);

		EX_MRegister: EX_MReg
			generic map(WORD => WORD, REG => REG)
			port map (
				CLK => CLK,
				RST => RST,

				-- inputs
				ALUresult_in => EX_ALUResult,
				Data2_in => Data2,
				DestAddr_in => EX_RegWriteAddr,

				-- outputs
				ALUresult_out => M_ALUResult,
				Data2_out => M_Data,
				DestAddr_out => M_RegWriteAddr
			);
			
		EX_WriteAddrBuffer: genBuffer
			generic map(length => REG)
			port map (CLK, EX_RegWriteAddrBuffer, EX_RegWriteAddr);

		---------------
		-- Memory Map
		---------------
		DataMemory: DataMem
			generic map (ADDR => ADDR,  WORD => WORD)
			port map (
				CLK => CLK,
				ADDR_in => M_ALUResult,
				Data_in => M_Data,
				MemWrite_in => MemWrite,
				MemRead_in => MemRead,

				Data_out => M_lw_Data
			);

		M_WB: wb
			port map (
				CLK => CLK,
				RST => RST,

				-- inputs
				MemToReg_in => M_WBBusBuffer(1),
				RegWrite_in => M_WBBusBuffer(0),

				-- outputs
				MemToReg_out => MemToReg,
				RegWrite_out => RegWrite
			);
		
		M_WB_Buffer: genBuffer
			generic map (length => 2)
			port map (CLK, M_WBBus, M_WBBusBuffer);

		M_WBRegister: M_WBReg
			generic map (WORD => WORD, REG => REG)
			port map (
				CLK => CLK,
				RST => RST,

				-- inputs
				Data_in => M_lw_Data,
				ALUResult_in => M_ALUResult,
				RegWriteAddr_in => M_RegWriteAddr,

				-- outputs
				Data_out => WB_Data,
				ALUResult_out => WB_ALUResult,
				RegWriteAddr_out => RegWriteAddr
			);
	--	WriteAddrBuffer: genBuffer
--			generic map(length => REG)
--			port map(CLK, RegWriteAddrBuffer, RegWriteAddr);
			
		DataBuffer: genBuffer
			generic map (length => WORD)
			port map (CLK, M_ALUResult, M_ALUResultBuffer);

		------------------
		-- Write Back Map
		------------------
		WB_Mux: genMux
			generic map (length => WORD)
			port map (
				I0 => WB_Data,
				I1 => WB_ALUResult,
				Sel => MemToReg,

				Outp => RegWriteData
			);

 end architecture pipeline;

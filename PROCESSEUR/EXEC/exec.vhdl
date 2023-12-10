library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXEC is
	port(
	-- Decode interface synchro
			dec2exe_empty	: in Std_logic;
			exe_pop			: out Std_logic;

	-- Decode interface operands
			dec_op1			: in Std_Logic_Vector(31 downto 0); -- first alu input
			dec_op2			: in Std_Logic_Vector(31 downto 0); -- shifter input
			dec_exe_dest	: in Std_Logic_Vector(3 downto 0); -- Rd destination     Pour le !
			dec_exe_wb		: in Std_Logic; -- Rd destination write back             Equivalent au ! (??????)
			dec_flag_wb		: in Std_Logic; -- CSPR modifiy                          Equivalent au S (??????)

	-- Decode to mem interface 
			dec_mem_data	: in Std_Logic_Vector(31 downto 0); -- data to MEM W     
			dec_mem_dest	: in Std_Logic_Vector(3 downto 0); -- Destination MEM R
			dec_pre_index 	: in Std_logic;                                        --Calcul de l'index (si dec_pre_index = 1) (????????)

			dec_mem_lw		: in Std_Logic;
			dec_mem_lb		: in Std_Logic;
			dec_mem_sw		: in Std_Logic;
			dec_mem_sb		: in Std_Logic;

	-- Shifter command
			dec_shift_lsl	: in Std_Logic;
			dec_shift_lsr	: in Std_Logic; 
			dec_shift_asr	: in Std_Logic;
			dec_shift_ror	: in Std_Logic;
			dec_shift_rrx	: in Std_Logic;
			dec_shift_val	: in Std_Logic_Vector(4 downto 0);
			dec_cy				: in Std_Logic;

	-- Alu operand selection
			dec_comp_op1	: in Std_Logic;
			dec_comp_op2	: in Std_Logic;
			dec_alu_cy 		: in Std_Logic;

	-- Alu command
			dec_alu_cmd		: in Std_Logic_Vector(1 downto 0);

	-- Exe bypass to decod
			exe_res			: out Std_Logic_Vector(31 downto 0);

			exe_c			: out Std_Logic;
			exe_v			: out Std_Logic;
			exe_n			: out Std_Logic;
			exe_z			: out Std_Logic;

			exe_dest		: out Std_Logic_Vector(3 downto 0); -- Rd destination
			exe_wb			: out Std_Logic; -- Rd destination write back
			exe_flag_wb		: out Std_Logic; -- CSPR modifiy

	-- Mem interface
			exe_mem_adr		: out Std_Logic_Vector(31 downto 0); -- Alu res register
			exe_mem_data	: out Std_Logic_Vector(31 downto 0);
			exe_mem_dest	: out Std_Logic_Vector(3 downto 0);

			exe_mem_lw		: out Std_Logic;
			exe_mem_lb		: out Std_Logic;
			exe_mem_sw		: out Std_Logic;
			exe_mem_sb		: out Std_Logic;

			exe2mem_empty	: out Std_logic;
			mem_pop			: in Std_logic;

	-- global interface
			ck				: in Std_logic;
			reset_n		: in Std_logic;
			vdd				: in bit;
			vss				: in bit);
end EXEC;

----------------------------------------------------------------------

architecture struct of EXEC is
--signaux interne pour l'ALU
signal mux_op1,mux_op2,res_alu : std_logic_vector(31 downto 0);
signal cout_alu, cout_alu_wb : std_logic;
--signaux interne pour le SHIFTER
signal dout_shift : std_logic_vector(31 downto 0);
signal cout_shift : std_logic;
--signaux interne pour l'indexation
signal mem_adr : std_logic_vector(31 downto 0); --sortie du mux entre alu et dec_op1
--singaux de gestion de la fifo ??????
signal exe_push, exe2mem_full : std_logic;

begin
--  Component instantiation.

	ALU : entity work.ALU(equ) 
	PORT MAP(op1 => mux_op1    ,
					 op2 => mux_op2    , 
					 cin => dec_alu_cy ,
					 cmd => dec_alu_cmd,
					 res => res_alu    ,
					 cout=> cout_alu   ,
					 z   => exe_z      ,
					 n   => exe_n      , 
					 v   => exe_v      , 
					 vdd => vdd        ,
					 vss => vss        );

	SHIFTER : entity work.shifter(behavior) 
	PORT MAP(shift_lsl => dec_shift_lsl,
			 shift_lsr => dec_shift_lsr,
			 shift_asr => dec_shift_asr,
			 shift_ror => dec_shift_ror,
			 shift_rrx => dec_shift_rrx,
			 shift_val => dec_shift_val,
			 din       => dec_op2      ,
			 cin       => dec_cy       ,
			 dout      => dout_shift   ,
			 cout      => cout_shift   ,
			 vdd       => vdd          ,
			 vss       => vss          );

	exec2mem : entity work.fifo(dataflow)
	port map (	din(71)	 => dec_mem_lw,
				din(70)	 => dec_mem_lb,
				din(69)	 => dec_mem_sw,
				din(68)	 => dec_mem_sb,

				din(67 downto 64) => dec_mem_dest,
				din(63 downto 32) => dec_mem_data,
				din(31 downto 0)  => mem_adr,

				dout(71) => exe_mem_lw,
				dout(70) => exe_mem_lb,
				dout(69) => exe_mem_sw,
				dout(68) => exe_mem_sb,

				dout(67 downto 64) => exe_mem_dest,
				dout(63 downto 32) => exe_mem_data,
				dout(31 downto 0)  => exe_mem_adr,

				push => exe_push,
				pop	 => mem_pop,

				empty => exe2mem_empty,
				full  => exe2mem_full,

				reset_n	=> reset_n,
				ck		=> ck,
				vdd		=> vdd,
				vss		=> vss);

--Implementation des multiplexeurs de choix des opérandes 
	mux_op1 <= dec_op1    when dec_comp_op1 = '0' else not(dec_op1);
	mux_op2 <= dout_shift when dec_comp_op2 = '0' else not(dout_shift);

--Gestion du Writeback de res_alu
	exe_wb   <= dec_exe_wb  ;
	exe_res  <= res_alu     ; --Attention quand exe_res = X"00000000";
	exe_dest <= dec_exe_dest; --Attention quand exe_dest : R0;

--Gestion du Writeback des flags C, V, Z, N
    --LE signal dec_flag_wb 
	exe_flag_wb <= dec_flag_wb;
	-- exe_v         <= v_alu      when dec_flag_wb = '1' else '0'; --Attention quand exe_v = '0';
	-- exe_z         <= z_alu      when dec_flag_wb = '1' else '0'; --Attention quand exe_z = '0';
	-- exe_n         <= n_alu      when dec_flag_wb = '1' else '0'; --Attention quand exe_n = '0';
	-- cout_alu_wb   <= cout_alu   when dec_flag_wb = '1' else '0'; --Attention quand exe_c = '0';
	-- cout_shift_wb <= cout_shift when dec_flag_wb = '1' else '0';
	--Implementation du multiplexeur du choix des cout (ALU ou shifter)
	exe_c <= '0'        when reset_n = '0'       else 
	         cout_shift when dec_alu_cmd = "01" or dec_alu_cmd = "10" or dec_alu_cmd = "11" else
					 cout_alu;

--Implementation du multiplexeur de pre/post indexation
	mem_adr <= res_alu when dec_pre_index = '1' else dec_op1;

--Gestion interface synchro
	exe_pop	<= '1' when ((not(dec2exe_empty) and not(exe2mem_full)) = '1') else '0'; 

--Gestion de la fifo
	exe_push <= '1' when (not(exe2mem_full) and (dec_mem_sb or dec_mem_sw or dec_mem_lb or dec_mem_lw)) ='1' else '0'; --ajout de condition

end struct;
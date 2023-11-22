library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DEC is
    port(
        if2dec_pop : in std_logic;
        dec2exe_push: out std_logic;
        dec2if_push: out std_logic;
        inst: in std_logic_vector(31 downto 0); 
    )
end entity;

architecture ARCHI of DEC is 
signal cond : std_logic;
signal condv : std_logic;
signal operv : std_logic;

signal regop_t : std_logic;
signal mult_t : std_logic;
signal swap_t : std_logic;
signal trans_t : std_logic;
signal mtrans_t : std_logic;
signal branch_t : std_logic;
signal and_i: std_logic;
signal eor_i : std_logic;
signal sub_i : std_logic;
signal rsb_i : std_logic;
signal add_i : std_logic;
signal adc_i : std_logic;
signal sbc_i : std_logic;
signal rsc_i : std_logic;
signal tst_i : std_logic;
signal teq_i : std_logic;
signal cmp_i : std_logic;
signal cmn_i : std_logic;
signal orr_i : std_logic;
signal mov_i : std_logic;
signal bic_i : std_logic;
signal mvn_i : std_logic;

--trans instructions
signal ldr_i : std_logic;
signal str_i : std_logic;
signal ldrb_i : std_logic;
signal strb_i : std_logic;

--mtrans instructions 
signal ldm_i : std_logic;
signal stm_i : std_logic;

--branch instructions
signal b_i : std_logic;
signal bl_i : std_logic;

--exec operands
signal op1 : std_logic_vector(31 downto 0);
signal op2 : std_logic_vector(31 downto 0);
signal alu_dest : std_logic_vector(3 downto 0);
signal alu_wb : std_logic;
signal flag_wb : std_logic;

--Shifter command 
signal shift_lsl : std_logic;
signal shift_lsr : std_logic;
signal shift_asr : std_logic;
signal shift_ror : std_logic;
signal shift_rrx : std_logic;
signal shift_val : std_logic_vector(4 downto 0);
signal cy : std_logic;

--Alu operand selection 
signal comp_op1 : std_logic;
signal comp_op2 : std_logic;
signal alu_cy : std_logic;

--Alu command 
signal alu_cmd : std_logic_vector(1 downto 0 );

--Dec to meme via exec 
signal mem_data : std_logic_vector(31 downto 0 );
signal d_dest : std_logic_vector(3 downto 0 );
signal pre_inde : std_logic;

signal mem_lw : std_logic;
signal mem_lb : std_logic;
signal mem_sw : std_logic;
signal mem_sb : std_logic;

signal dec2if_push : std_logic;
signal dec2exe_push : std_logic;
signal if2dec_pop : std_logic;

begin 



begin 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_tb is
end test_tb;

architecture struct of test_tb is
    constant clk_period : time := 2 ns;
    -- Decode interface synchro
    signal dec2exe_empty, exe_pop : std_logic;
    -- Decode interface operands
    signal dec_op1, dec_op2        : std_logic_vector(31 downto 0);
    signal dec_exe_dest            : std_logic_vector(3 downto 0);
    signal dec_exe_wb, dec_flag_wb : std_logic;
    -- Decode to mem interface
    signal dec_mem_data : std_logic_vector(31 downto 0);
    signal dec_mem_dest : std_logic_vector(3 downto 0);
    signal dec_pre_index: std_logic;
    signal dec_mem_lw, dec_mem_lb, dec_mem_sw, dec_mem_sb : std_logic;
    -- Shifter command
    signal dec_shift_lsl, dec_shift_lsr, dec_shift_asr, dec_shift_ror, dec_shift_rrx, dec_cy : std_logic;
    signal dec_shift_val : std_logic_vector(4 downto 0);
    --Alu operand selection
    signal dec_comp_op1, dec_comp_op2, dec_alu_cy : std_logic;
    --Alu command
    signal dec_alu_cmd : std_logic_vector(1 downto 0);
    --Exe bypass to decod
    signal exe_res : std_logic_vector(31 downto 0);
    signal exe_c, exe_v, exe_n, exe_z : std_logic;
    signal exe_dest : std_logic_vector(3 downto 0);
    signal exe_wb, exe_flag_wb : std_logic;
    --Mem Interface
    signal exe_mem_adr, exe_mem_data : std_logic_vector(31 downto 0);
    signal exe_mem_dest : std_logic_vector(3 downto 0);
    signal exe_mem_lw, exe_mem_lb, exe_mem_sw, exe_mem_sb, exe2mem_empty, mem_pop : std_logic;
    --global interface
    signal ck, reset_n : std_logic;
    signal vdd, vss : bit;
begin

    EXEC : entity work.exec(struct) PORT MAP(-- Decode interface synchro
                                                dec2exe_empty	=> dec2exe_empty,
			                                    exe_pop			=> exe_pop,

                                            -- Decode interface operands
                                                dec_op1			=> dec_op1     , -- first alu input
                                                dec_op2			=> dec_op2     , -- shifter input
                                                dec_exe_dest	=> dec_exe_dest, -- Rd destination     Pour le !
                                                dec_exe_wb		=> dec_exe_wb  , -- Rd destination write back             Equivalent au ! (??????)
                                                dec_flag_wb		=> dec_flag_wb , -- CSPR modifiy                          Equivalent au S (??????)

                                            -- Decode to mem interface 
                                                dec_mem_data	=> dec_mem_data , -- data to MEM W     
                                                dec_mem_dest	=> dec_mem_dest , -- Destination MEM R
                                                dec_pre_index 	=> dec_pre_index,                                        --Calcul de l'index (si dec_pre_index = 1) (????????)

                                                dec_mem_lw		=> dec_mem_lw,
                                                dec_mem_lb		=> dec_mem_lb,
                                                dec_mem_sw		=> dec_mem_sw,
                                                dec_mem_sb		=> dec_mem_sb,

                                            -- Shifter command
                                                dec_shift_lsl	=> dec_shift_lsl,
                                                dec_shift_lsr	=> dec_shift_lsr, 
                                                dec_shift_asr	=> dec_shift_asr,
                                                dec_shift_ror	=> dec_shift_ror,
                                                dec_shift_rrx	=> dec_shift_rrx,
                                                dec_shift_val	=> dec_shift_val,
                                                dec_cy			=> dec_cy       ,

                                            -- Alu operand selection
                                                dec_comp_op1	=> dec_comp_op1,
                                                dec_comp_op2	=> dec_comp_op2,
                                                dec_alu_cy 		=> dec_alu_cy  ,

                                            -- Alu command
                                                dec_alu_cmd		=> dec_alu_cmd,

                                            -- Exe bypass to decod
                                                exe_res			=> exe_res,
 
                                                exe_c			=> exe_c,
                                                exe_v			=> exe_v,
                                                exe_n			=> exe_n,
                                                exe_z			=> exe_z,
 
                                                exe_dest		=> exe_dest   , -- Rd destination
                                                exe_wb			=> exe_wb     , -- Rd destination write back
                                                exe_flag_wb		=> exe_flag_wb, -- CSPR modifiy

                                            -- Mem interface
                                                exe_mem_adr		=> exe_mem_adr , -- Alu res register
                                                exe_mem_data	=> exe_mem_data,
                                                exe_mem_dest	=> exe_mem_dest,

                                                exe_mem_lw		=> exe_mem_lw,
                                                exe_mem_lb		=> exe_mem_lb,
                                                exe_mem_sw		=> exe_mem_sw,
                                                exe_mem_sb		=> exe_mem_sb,

                                                exe2mem_empty	=> exe2mem_empty,
                                                mem_pop			=> mem_pop      ,

                                            -- global interface
                                                ck				=> ck     ,
                                                reset_n			=> reset_n,
                                                vdd				=> vdd    ,
                                                vss				=> vss);
    -- Decode interface synchro
    dec2exe_empty <= '1', '0' after 5  ns, '1' after 7  ns,
                          '0' after 9  ns, '1' after 11 ns,
                          '0' after 21 ns, '1' after 23 ns;

    --gestion fifo mem interface
    mem_pop <= '0', '1' after 6  ns, '0' after 8  ns,
                    '1' after 8.5 ns, '0' after 11 ns,
                    '1' after 18 ns, '0' after 20 ns;

    -- Decode interface operands
    dec_op1      <= X"00000000", X"F0F0F0F0" after 5 ns, X"ABCD1234" after 9 ns, X"00000000" after 21 ns;
    dec_op2      <= X"00000000", X"00001111" after 5 ns, X"00000100" after 9 ns, X"00000005" after 21 ns;   
    dec_exe_dest <= X"0", X"5" after 5 ns, X"A" after 9 ns, X"6" after 21 ns;
    dec_exe_wb   <= '0', '1' after 5 ns;
    dec_flag_wb  <= '0', '1' after 5 ns;

    -- Decode to mem interface
    dec_mem_data <= X"01000000", X"0000ABCD" after 21 ns;
    dec_mem_dest <= "0000", X"B" after 21 ns;
    dec_pre_index<= '1';

    dec_mem_lw   <= '0', '1' after 6 ns, '0' after 8 ns;
    dec_mem_lb   <= '0';
    dec_mem_sw   <= '0', '1' after 10 ns, '0' after 12 ns, '1' after 22 ns, '0' after 24 ns;
    dec_mem_sb   <= '0';

    -- Shifter command
    dec_shift_lsl <= '0', '1' after 5 ns, '0' after 7 ns;
    dec_shift_lsr <= '0';
    dec_shift_asr <= '0', '1' after 9 ns, '0' after 11 ns;
    dec_shift_ror <= '0';
    dec_shift_rrx <= '0';
    dec_shift_val <= "00000", "00101" after 5 ns, "00011" after 9 ns, "00000" after 11 ns;
    dec_cy        <= '0';

    -- Alu operand selection
    dec_comp_op1 <= '0';
    dec_comp_op2 <= '0', '1' after 21 ns;
    dec_alu_cy   <= '0', '1' after 21 ns;

    -- Alu command
    dec_alu_cmd <= "00", "01" after 9 ns, "00" after 21 ns;

    reset_n <= '0' , '1' after 2 ns;

    clk_gen:process
    begin
        ck <= '0';
        wait for clk_period/2;
        ck <= '1';
        wait for clk_period/2;
    end process;

end struct;
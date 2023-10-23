library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
end test;

architecture struct of tets is
   
begin

    EXEC : entity work.exec(struct) PORT MAP(-- Decode interface synchro
                                                dec2exe_empty	=> ,
			                                    exe_pop			=> ,

                                            -- Decode interface operands
                                                dec_op1			=> , -- first alu input
                                                dec_op2			=> , -- shifter input
                                                dec_exe_dest	=> , -- Rd destination     Pour le !
                                                dec_exe_wb		=> , -- Rd destination write back             Equivalent au ! (??????)
                                                dec_flag_wb		=> , -- CSPR modifiy                          Equivalent au S (??????)

                                            -- Decode to mem interface 
                                                dec_mem_data	=> , -- data to MEM W     
                                                dec_mem_dest	=> , -- Destination MEM R
                                                dec_pre_index 	=> ,                                        --Calcul de l'index (si dec_pre_index = 1) (????????)

                                                dec_mem_lw		=> ,
                                                dec_mem_lb		=> ,
                                                dec_mem_sw		=> ,
                                                dec_mem_sb		=> ,

                                            -- Shifter command
                                                dec_shift_lsl	=> ,
                                                dec_shift_lsr	=> , 
                                                dec_shift_asr	=> ,
                                                dec_shift_ror	=> ,
                                                dec_shift_rrx	=> ,
                                                dec_shift_val	=> ,
                                                dec_cy			=> ,

                                            -- Alu operand selection
                                                dec_comp_op1	=> ,
                                                dec_comp_op2	=> ,
                                                dec_alu_cy 		=> ,

                                            -- Alu command
                                                dec_alu_cmd		=> ,

                                            -- Exe bypass to decod
                                                exe_res			=> ,

                                                exe_c			=> ,
                                                exe_v			=> ,
                                                exe_n			=> ,
                                                exe_z			=> ,

                                                exe_dest		=> , -- Rd destination
                                                exe_wb			=> , -- Rd destination write back
                                                exe_flag_wb		=> , -- CSPR modifiy

                                            -- Mem interface
                                                exe_mem_adr		=> , -- Alu res register
                                                exe_mem_data	=> ,
                                                exe_mem_dest	=> ,

                                                exe_mem_lw		=> ,
                                                exe_mem_lb		=> ,
                                                exe_mem_sw		=> ,
                                                exe_mem_sb		=> ,

                                                exe2mem_empty	=> ,
                                                mem_pop			=> ,

                                            -- global interface
                                                ck				=> ,
                                                reset_n			=> ,
                                                vdd				=> ,
                                                vss				=>
                                            );

end struct;
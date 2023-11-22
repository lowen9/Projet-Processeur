library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DEC is
    port(
        -- Exec  operands
			dec_op1			: out Std_Logic_Vector(31 downto 0); -- first alu input
			dec_op2			: out Std_Logic_Vector(31 downto 0); -- shifter input
			dec_exe_dest	: out Std_Logic_Vector(3 downto 0); -- Rd destination
			dec_exe_wb		: out Std_Logic; -- Rd destination write back
			dec_flag_wb		: out Std_Logic; -- CSPR modifiy

	    -- Decod to mem via exec
			dec_mem_data	: out Std_Logic_Vector(31 downto 0); -- data to MEM
			dec_mem_dest	: out Std_Logic_Vector(3 downto 0);
			dec_pre_index 	: out Std_logic;

			dec_mem_lw		: out Std_Logic;
			dec_mem_lb		: out Std_Logic;
			dec_mem_sw		: out Std_Logic;
			dec_mem_sb		: out Std_Logic;

	    -- Shifter command
			dec_shift_lsl	: out Std_Logic;
			dec_shift_lsr	: out Std_Logic;
			dec_shift_asr	: out Std_Logic;
			dec_shift_ror	: out Std_Logic;
			dec_shift_rrx	: out Std_Logic;
			dec_shift_val	: out Std_Logic_Vector(4 downto 0);
			dec_cy			: out Std_Logic;

	    -- Alu operand selection
			dec_comp_op1	: out Std_Logic;
			dec_comp_op2	: out Std_Logic;
			dec_alu_cy 		: out Std_Logic;

	    -- Exec Synchro
			dec2exe_empty	: out Std_Logic;
			exe_pop			: in Std_logic;

	    -- Alu command
			dec_alu_cmd		: out Std_Logic_Vector(1 downto 0);

	    -- Exe Write Back to reg
			exe_res			: in Std_Logic_Vector(31 downto 0);

			exe_c			: in Std_Logic;
			exe_v			: in Std_Logic;
			exe_n			: in Std_Logic;
			exe_z			: in Std_Logic;

			exe_dest		: in Std_Logic_Vector(3 downto 0); -- Rd destination
			exe_wb			: in Std_Logic; -- Rd destination write back
			exe_flag_wb		: in Std_Logic; -- CSPR modifiy

	    -- Ifetch interface
			dec_pc			: out Std_Logic_Vector(31 downto 0) ;
			if_ir			: in Std_Logic_Vector(31 downto 0) ;

	    -- Ifetch synchro
			dec2if_empty	: out Std_Logic;
			if_pop			: in Std_Logic;

			if2dec_empty	: in Std_Logic;
			dec_pop			: out Std_Logic;

	    -- Mem Write back to reg
			mem_res			: in Std_Logic_Vector(31 downto 0);
			mem_dest		: in Std_Logic_Vector(3 downto 0);
			mem_wb			: in Std_Logic;
			
	    -- global interface
			ck				: in Std_Logic;
			reset_n			: in Std_Logic;
			vdd				: in bit;
			vss				: in bit
        );

    
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
signal alu_wb   : std_logic;
signal flag_wb  : std_logic;

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
signal alu_cy   : std_logic;

--Alu command 
signal alu_cmd : std_logic_vector(1 downto 0 );

--Dec to meme via exec 
signal mem_data : std_logic_vector(31 downto 0 );
signal d_dest   : std_logic_vector(3 downto 0 );
signal pre_inde : std_logic;

signal mem_lw : std_logic;
signal mem_lb : std_logic;
signal mem_sw : std_logic;
signal mem_sb : std_logic;

signal dec2if_push : std_logic;
signal dec2exe_push : std_logic;
signal if2dec_pop : std_logic;

begin 
        component REG 
        port(
            -- Write Port 1 prioritaire
                wdata1		    : in Std_Logic_Vector(31 downto 0);
                wadr1			: in Std_Logic_Vector(3 downto 0);
                wen1			: in Std_Logic;

            -- Write Port 2 non prioritaire
                wdata2		    : in Std_Logic_Vector(31 downto 0);
                wadr2			: in Std_Logic_Vector(3 downto 0);
                wen2			: in Std_Logic;

            -- Write CSPR Port
                wcry			: in Std_Logic;
                wzero			: in Std_Logic;
                wneg			: in Std_Logic;
                wovr			: in Std_Logic;
                cspr_wb		    : in Std_Logic;
                
            -- Read Port 1 32 bits
                reg_rd1		    : out Std_Logic_Vector(31 downto 0);
                radr1			: in Std_Logic_Vector(3 downto 0);
                reg_v1		    : out Std_Logic;

            -- Read Port 2 32 bits
                reg_rd2		    : out Std_Logic_Vector(31 downto 0);
                radr2			: in Std_Logic_Vector(3 downto 0);
                reg_v2		    : out Std_Logic;

            -- Read Port 3 32 bits
                reg_rd3		    : out Std_Logic_Vector(31 downto 0);
                radr3			: in Std_Logic_Vector(3 downto 0);
                reg_v3		    : out Std_Logic;

            -- read CSPR Port
                reg_cry		    : out Std_Logic;
                reg_zero		: out Std_Logic;
                reg_neg		    : out Std_Logic;
                reg_cznv		: out Std_Logic;
                reg_ovr		    : out Std_Logic;
                reg_vv		    : out Std_Logic;
                
            -- Invalidate Port 
                inval_adr1	    : in Std_Logic_Vector(3 downto 0);
                inval1		    : in Std_Logic;

                inval_adr2	    : in Std_Logic_Vector(3 downto 0);
                inval2		    : in Std_Logic;

                inval_czn	    : in Std_Logic;
                inval_ovr	    : in Std_Logic;

            -- PC
                reg_pc		    : out Std_Logic_Vector(31 downto 0);
                reg_pcv		    : out Std_Logic;
                inc_pc		    : in Std_Logic;
            
            -- global interface
                ck		        : in Std_Logic;
                reset_n		    : in Std_Logic;
                vdd			    : in bit;
                vss			    : in bit);
        end component; 
        if (reg_cznv='1' and reg_vv= '1') then
            condv <= '1';
        end if; 
        when (if_ir(31 downto 28)) = "0000" => --cond EQ 
            if reg_zero='1' then 
                cond<= '1'; 
            else 
                cond<='0';
            end if; 
        when (if_ir(31 downto 28)) = "0001" => --cond ne
            if reg_zero='0' then 
                cond<= '1'; 
            else 
                cond<='0';
            end if; 
        when (if_ir(31 downto 28)) = "0010" => --cond C=1
            if  reg_cry='1' then 
                cond= '1'; 
            else 
                cond='0';
            end if; 
        when (if_ir(31 downto 28)) = "0011" => --cond C=0 
            if reg_cry ='0' then 
                cond<= '1'; 
            else 
                cond<='0';
            end if; 
        when (if_ir(31 downto 28)) = "0100" => -- cond N=1
            if reg_neg ='1' then 
                cond<= '1'; 
            else 
                cond<='0';
            end if ; 
        when (if_ir(31 downto 28)) = "0101" =>--cond N=0 
            if reg_neg= '0 ' then 
                cond<= '1'; 
            else 
                cond<='0';
            end if; 
        when (if_ir(31 downto 28)) = "0110" => --cond ovr=1
            if reg_ovr='1' then 
                cond<= '1'; 
            else 
                cond<='0';
            end if; 
        when (if_ir(31 downto 28)) = "0111" => --cond ovr=0 
            if reg_ovr='0' then 
                cond<= '1'; 
            else 
                cond<='0';
            end if; 
        when (if_ir(31 downto 28)) = "1000" => -- cond c=1 et Z=0 
            if (reg_cry='1' and reg_zero='0') then 
                cond<= '1'; 
            else 
                cond<='0';
            end if; 
        when (if_ir(31 downto 28)) = "1001" => -- cond c=0 ou Z=1 
            if (reg_cry='0' or reg_zero='1') then 
                cond<= '1'; 
            else 
                cond<='0';
            end if; 
        when (if_ir(31 downto 28)) = "1010" => --conf sup ou egal 
            if reg_zero='1' then 
                cond<= '1'; 
            else 
                cond<='0';
            end if; 
        when (if_ir(31 downto 28)) = "1011" => --cond strictement inf 
            if reg_zero='1' then 
                cond<= '1'; 
            else 
                cond<='0';
            end if;
        when (if_ir(31 downto 28)) = "1100" => ---cond stric sup 
            if reg_zero='1' then 
                cond<= '1'; 
            else 
                cond<='0';
            end if;
        when (if_ir(31 downto 28)) = "1101" => --inf ou egal 
            if reg_zero='1' then 
                cond<= '1'; 
            else 
                cond<='0';
            end if;
        when (if_ir(31 downto 28)) = "1110" => --toujours
                cond <= '1'; 
        when (if_ir(31 downto 28)) = "1111" => --reserve 
                cond <= '0'; 
        
                


 

end ARCHI
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
			dec_mem_dest	: out Std_Logic_Vector(3 downto 0);  -- Registre d'écriture de Mem
			dec_pre_index 	: out Std_logic;                   -- P = 1 calcul de l'adresse par exec sinon non

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

architecture behavior of DEC is
--Précidat 
signal cond  : std_logic;  --fait 
signal condv : std_logic; --fait

--Opérande valide
signal operv : std_logic; --on sait pas ?

--Machine à état
signal regop_t  : std_logic; --????
signal mult_t   : std_logic;
signal swap_t   : std_logic;  --????
signal trans_t  : std_logic;
signal mtrans_t : std_logic;
signal branch_t : std_logic;

--Traitement de données
signal and_i : std_logic;
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
signal ldr_i  : std_logic;
signal str_i  : std_logic;
signal ldrb_i : std_logic;
signal strb_i : std_logic;

--mtrans instructions 
signal ldm_i : std_logic;
signal stm_i : std_logic;

--branch instructions
signal b_i  : std_logic;
signal bl_i : std_logic;

--exec operands
signal op1      : std_logic_vector(31 downto 0);
signal op2      : std_logic_vector(31 downto 0);
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

signal dec2if_push  : std_logic;
signal dec2exe_push : std_logic;
signal if2dec_pop   : std_logic;

--Signaux interne de REG
signal radr1, radr2, radr3 : std_logic_vector(3 downto 0);
signal shift_val_nt : std_logic_vector(31 downto 0);
signal opv1, opv2, opv3 : std_logic;
signal reg_cry, reg_zero, reg_neg, reg_cznv, reg_ovr, reg_vv : std_logic;
signal dec_inv_rwb  : std_logic_vector(3 downto 0);
signal alu_dest_v   : std_logic;
signal inval_czn, inval_ovr : std_logic;
signal reg_pc : std_logic_vector(31 downto 0); 
signal reg_pcv,inc_pc : std_logic;
signal EQ, NE, CS, CC, MI, PL, VS, VC, HI, LS, GE, LT, GT, LE, AL, NV : std_logic;
signal trdd, br, ams, amm : std_logic;
signal op2i : std_logic; --op2i = 1 immédiat;

begin
     REG : entity work.REG(Behavior)
     PORT MAP(
        -- Write Port 1 prioritaire
            wdata1     => exe_res    ,
            wadr1	     => exe_dest   ,
            wen1	     => exe_wb     ,
        -- Write Port 2 non prioritaire
            wdata2     => mem_res    ,	   	    
            wadr2      => mem_dest   ,   			
            wen2       => mem_wb     ,			

        -- Write CSPR Port
            wcry	     => exe_c      ,   	
            wzero	     => exe_z      ,	
            wneg	     => exe_n      ,		
            wovr	     => exe_v      ,		
            cspr_wb	   => exe_flag_wb,	    
            
        -- Read Port 1 32 bits pour lire Rn
            reg_rd1	   => op1  ,--Vers fifo	    
            radr1	     => radr1,--num R décodé par DEC
            reg_v1	   => opv1 ,	    

        -- Read Port 2 32 bits pour lire Rm
            reg_rd2	   => op2  ,--Vers fifo  
            radr2	     => radr2,--num R décodé par DEC		
            reg_v2	   => opv2 ,  

        -- Read Port 3 32 bits pour lire Rs
            reg_rd3	   => shift_val_nt,--Valeur de shift val non tronqué   
            radr3	     => radr3       ,--num R décodé par DEC		
            reg_v3	   => opv3        ,  

        -- read CSPR Port
            reg_cry	   => reg_cry	,	    
            reg_zero   => reg_zero	,
            reg_neg	   => reg_neg	,   
            reg_cznv   => reg_cznv	,
            reg_ovr	   => reg_ovr	,   
            reg_vv	   => reg_vv	,     
            
        -- Invalidate Port 
            inval_adr1 => alu_dest  , --registre Rd décodé par DEC 
            inval1	   => alu_dest_v, --validité du décodage   

            inval_adr2 => dec_inv_rwb, --registre R pour WB décodé par DEC
            inval2	   => alu_wb     , --validité du décodage   

            inval_czn  => inval_czn, --????	flag_wb déterminer 
            inval_ovr  => inval_ovr, --???? si c'est arithémique ou logique   	    

        -- PC
            reg_pc	   => reg_pc , 	    
            reg_pcv	   => reg_pcv, 	    
            inc_pc	   => inc_pc ,--quand on veut prendre 	    
                                  --l'instruction suivante
        -- global interface
            ck		     => ck,      
            reset_n	   => reset_n,    
            vdd		     => vdd,	    
            vss		     => vss);

        --Test des prédicats

        EQ <= '1' when (reg_zero                & if_ir(31 downto 28)) = "10000"  else '0';
        NE <= '1' when (reg_zero                & if_ir(31 downto 28)) = "00001"  else '0';
        CS <= '1' when (reg_cry                 & if_ir(31 downto 28)) = "10010"  else '0';
        CC <= '1' when (reg_cry                 & if_ir(31 downto 28)) = "00011"  else '0';
        MI <= '1' when (reg_neg                 & if_ir(31 downto 28)) = "10100"  else '0';
        PL <= '1' when (reg_neg                 & if_ir(31 downto 28)) = "00101"  else '0';
        VS <= '1' when (reg_ovr                 & if_ir(31 downto 28)) = "10110"  else '0';
        VC <= '1' when (reg_ovr                 & if_ir(31 downto 28)) = "00111"  else '0';
        HI <= '1' when (reg_cry  & reg_zero     & if_ir(31 downto 28)) = "101000" else '0';
        LS <= '1' when (reg_cry  & reg_zero     & if_ir(31 downto 28)) = "011001" else '0';
        GE <= '1' when ((reg_cry xnor reg_zero) & if_ir(31 downto 28)) = "11010"  else '0';
        LT <= '1' when ((reg_cry xor  reg_zero) & if_ir(31 downto 28)) = "11010"  else '0';
        GT <= '1' when ((reg_zero)&(reg_neg xnor reg_ovr) & if_ir(31 downto 28)) = "011100"  else '0';
        LE <= '1' when ((reg_zero)&(reg_neg xor  reg_ovr) & if_ir(31 downto 28)) = "111100"  else '0';
        AL <= '1' when (if_ir(31 downto 28) = "1110") else '0';
        NV <= '1' when (if_ir(31 downto 28) = "1111") else '0';
       
        cond <= '1'  when ((EQ or NE or CS or CC or MI or PL or VS or VC or HI or LS or GE or LT or GT or LE or AL or not(AL)) = '1') else '0'; 
        --Validité des Test sur les prédicats
        condv <= '1' when ((reg_cznv and reg_vv) = '1') else '0';

        trdd <= '1' when (if_ir(27 downto 26) =  "00") else '0';
        br   <= '1' when (if_ir(27 downto 25) = "101") else '0';
        ams  <= '1' when (if_ir(27 downto 26) =  "01") else '0';
        amm  <= '1' when (if_ir(27 downto 25) = "100") else '0';

        op2i <=    if_ir(25)  when (trdd = '1') else 
               not(if_ir(25)) when (ams  = '1') else
               '-'; -- don't care

        and_i <= '1' when (trdd & if_ir(25 downto 21) = "10000") else '0'; 
        eor_i <= '1' when (trdd & if_ir(25 downto 21) = "10001") else '0';
        sub_i <= '1' when (trdd & if_ir(25 downto 21) = "10010") else '0';
        rsb_i <= '1' when (trdd & if_ir(25 downto 21) = "10011") else '0';
        add_i <= '1' when (trdd & if_ir(25 downto 21) = "10100") else '0';
        adc_i <= '1' when (trdd & if_ir(25 downto 21) = "10101") else '0';
        sbc_i <= '1' when (trdd & if_ir(25 downto 21) = "10110") else '0';
        rsc_i <= '1' when (trdd & if_ir(25 downto 21) = "10111") else '0';
        tst_i <= '1' when (trdd & if_ir(25 downto 21) = "11000") else '0';
        teq_i <= '1' when (trdd & if_ir(25 downto 21) = "11001") else '0';
        cmp_i <= '1' when (trdd & if_ir(25 downto 21) = "11010") else '0';
        cmn_i <= '1' when (trdd & if_ir(25 downto 21) = "11011") else '0';
        orr_i <= '1' when (trdd & if_ir(25 downto 21) = "11100") else '0';
        mov_i <= '1' when (trdd & if_ir(25 downto 21) = "11101") else '0';
        bic_i <= '1' when (trdd & if_ir(25 downto 21) = "11110") else '0';
        mvn_i <= '1' when (trdd & if_ir(25 downto 21) = "11111") else '0';

        flag_wb <= if_ir(20) when (trdd = '1') else '-';

        inval_czn <= '1' when ((flag_wb or   tst_i or teq_i or cmp_i or cmn_i)                    = '1') else '0';
        inval_ovr <= '1' when ((flag_wb and (add_i or adc_i or sub_i or rsb_i or sbc_i or rsc_i)) = '1') else '0';

        radr1 <= if_ir(19 downto 16) when ((trdd or ams or amm) = '1') else "XXXX";
        
        alu_dest   <= if_ir(15 downto 12); 
        alu_dest_v <= '1' when ((trdd or ams) ='1') else '0';





end behavior;
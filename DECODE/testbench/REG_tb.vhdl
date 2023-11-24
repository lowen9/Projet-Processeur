library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG_tb is
end REG_tb;

architecture struct of REG_tb is
    constant clk_period : time := 1 ns;
    -- Write Port 1 prioritaire
	signal wdata1		    : Std_Logic_Vector(31 downto 0);
	signal wadr1			: Std_Logic_Vector(3 downto 0);
	signal wen1			    : Std_Logic;

	-- Write Port 2 non prioritaire
	signal wdata2		    : Std_Logic_Vector(31 downto 0);
	signal wadr2			: Std_Logic_Vector(3 downto 0);
	signal wen2			    : Std_Logic;

	-- Write CSPR Port
	signal wcry			    : Std_Logic;
	signal wzero			: Std_Logic;
	signal wneg			    : Std_Logic;
	signal wovr			    : Std_Logic;
	signal cspr_wb		    : Std_Logic;
		
	-- Read Port 1 32 bits
	signal reg_rd1		    : Std_Logic_Vector(31 downto 0);
	signal radr1			: Std_Logic_Vector(3 downto 0);
	signal reg_v1		    : Std_Logic;

	-- Read Port 2 32 bits
	signal reg_rd2		    : Std_Logic_Vector(31 downto 0);
	signal radr2			: Std_Logic_Vector(3 downto 0);
	signal reg_v2		    : Std_Logic;

	-- Read Port 3 32 bits
	signal reg_rd3		    : Std_Logic_Vector(31 downto 0);
	signal radr3			: Std_Logic_Vector(3 downto 0);
	signal reg_v3		    : Std_Logic;

	-- read CSPR Port
	signal reg_cry		    : Std_Logic;
	signal reg_zero		    : Std_Logic;
	signal reg_neg		    : Std_Logic;
	signal reg_cznv		    : Std_Logic;
	signal reg_ovr		    : Std_Logic;
	signal reg_vv		    : Std_Logic;
		
	-- Invalidate Port 
	signal inval_adr1	    : Std_Logic_Vector(3 downto 0);
	signal inval1		    : Std_Logic;

	signal inval_adr2	    : Std_Logic_Vector(3 downto 0);
	signal inval2		    : Std_Logic;

	signal inval_czn	    : Std_Logic;
	signal inval_ovr	    : Std_Logic;

	-- PC
	signal reg_pc		    : Std_Logic_Vector(31 downto 0);
	signal reg_pcv		    : Std_Logic;
	signal inc_pc		    : Std_Logic;

    --global interface
    signal ck, reset_n : std_logic;
    signal vdd, vss : bit;
begin

    REG : entity work.REG(Behavior) PORT MAP(-- Write Port 1 prioritaire
                                                wdata1	=> wdata1,	    
                                                wadr1	=>  wadr1,		
                                                wen1	=>   wen1,		
                                            -- Write Port 2 non prioritaire
                                                wdata2	=> wdata2,	   
                                                wadr2	=>  wadr2,		
                                                wen2	=>   wen2,		

                                            -- Write CSPR Port
                                                wcry	=> wcry	  ,
                                                wzero	=> wzero  ,
                                                wneg	=> wneg	  ,
                                                wovr	=> wovr	  ,
                                                cspr_wb	=> cspr_wb,
                                                
                                            -- Read Port 1 32 bits
                                                reg_rd1	=>reg_rd1,  
                                                radr1	=>  radr1,		
                                                reg_v1	=> reg_v1,	    

                                            -- Read Port 2 32 bits
                                                reg_rd2	=> reg_rd2,	    	    
                                                radr2	=> radr2  ,				
                                                reg_v2	=> reg_v2 ,   	    

                                            -- Read Port 3 32 bits
                                                reg_rd3 => reg_rd3,		    
                                                radr3   => radr3  ,			
                                                reg_v3  => reg_v3 ,		    

                                            -- read CSPR Port
                                                reg_cry	      => reg_cry   ,	    
                                                reg_zero      => reg_zero  ,		
                                                reg_neg	      => reg_neg   ,	    
                                                reg_cznv      => reg_cznv  ,		
                                                reg_ovr	      => reg_ovr   ,	    
                                                reg_vv 	      => reg_vv    ,	    
                                                
                                            -- Invalidate Port 
                                                inval_adr1	  => inval_adr1, 
                                                inval1		  => inval1	   , 
                                                inval_adr2	  => inval_adr2, 
                                                inval2		  => inval2	   , 
                                                inval_czn	  => inval_czn , 
                                                inval_ovr	  => inval_ovr , 

                                            -- PC
                                                reg_pc		  =>reg_pc,
                                                reg_pcv		  =>reg_pcv,
                                                inc_pc		  =>inc_pc,

                                            -- global interface
                                                ck			  => ck     ,
                                                reset_n		  => reset_n,
                                                vdd			  => vdd    ,
                                                vss			  => vss);
                                        
    inval1 <= '1', '0' after 2 ns, '1' after 3 ns, '0' after 10 ns, '1' after 11 ns;
    inval_adr1 <= x"3" , x"A" after 10 ns; 
    inval2 <= '1', '0' after 3 ns, '1' after 4 ns, '0' after 6 ns, '1' after 7 ns;
    inval_adr2 <= x"3", x"A" after 6 ns;

    wen1   <= '0','1' after 5 ns, '0' after 6 ns, '1' after 15 ns, '0' after 16 ns;
    wdata1 <= x"1234ABCD" after 5 ns, x"11111111" after 15 ns;
    wadr1  <= x"3" after 5 ns, x"A" after 15 ns;
    wen2   <= '0','1' after 5 ns, '0' after 6 ns, '1' after 8 ns, '0' after 9 ns;
    wdata2 <= x"0AB12647" after 5 ns, x"10101010" after 8 ns;
    wadr2  <= x"3" after 5 ns, x"A" after 8 ns;

    radr1 <= x"3", x"A" after 7 ns;
    radr2 <= x"A";
    radr3 <= x"3";

    inc_pc <= '0', '1' after 5 ns, '0' after 7 ns, '1' after 11 ns, '0' after 13 ns;
    
    reset_n <= '1', '0' after 1 ns, '1' after 2 ns;

    clk_gen:process
    begin
        ck <= '0';
        wait for clk_period/2;
        ck <= '1';
        wait for clk_period/2;
    end process;

    ASSERT FALSE Report "Fini" Severity Error;

end struct;
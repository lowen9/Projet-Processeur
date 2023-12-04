library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
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
end Reg;

architecture Behavior OF Reg is
type Tableau is array(15 downto 0) of std_logic_vector(31 downto 0);
signal R : Tableau;
signal CSPR : std_logic_vector(3 downto 0);
signal CSPR_v : std_logic_vector(1 downto 0);
signal R_v : std_logic_vector(15 downto 0);
begin

    process(ck, reset_n)
    begin
        if reset_n = '0' then
            for i in 0 to 15 loop
                R(i)   <= (others => '0');
                R_v(i) <= '1';
            end loop;
            reg_rd1  <= (others => '0');
            reg_rd2  <= (others => '0');
            reg_rd3  <= (others => '0');
            reg_cry	 <= '0';	  
		    reg_zero <= '0';
		    reg_neg	 <= '0';	  
		    reg_ovr	 <= '0';
            --Registre tous valide au début
            reg_v1   <= '1';
            reg_v2   <= '1';
            reg_v3   <= '1';
            reg_cznv <= '1';
            reg_vv   <= '1';
            CSPR_v   <= "11";
        elsif rising_edge(ck) then
            if(inval1 = '0') then
                -- for i in 0 to 15 loop
                --     if to_integer(unsigned(inval_adr1)) = i then
                --         R_v(i) <= '0';
                --     end if;
                -- end loop;
            --version opti--
                R_v(to_integer(unsigned(inval_adr1))) <= '0';
            end if;
            if(inval2 = '0') then
                -- for i in 0 to 15 loop
                --     if to_integer(unsigned(inval_adr2)) = i then
                --         R_v(i) <= '0';
                --     end if;
                -- end loop;
            --version opti--
                R_v(to_integer(unsigned(inval_adr2))) <= '0';
            end if;
            if(inval_czn = '0') then
                CSPR_v(1) <= '0';
            end if;
            if(inval_ovr = '0') then
                CSPR_v(0) <= '0';
            end if;
            --écriture dans le banc de registre
            if(wen1 = '1') then       --On regarde si port 1 d'écriture est enable
                -- for j in 0 to 15 loop
                --     if(to_integer(unsigned(wadr1)) = j) then
                --         if(R_v(j) = '0') then
                --             R(j)   <= wdata1;
                --             R_v(j) <= '1';
                --         end if;
                --     end if;
                -- end loop;
            --Version opti--
                if(R_v(to_integer(unsigned(wadr1))) = '0') then
                    R(to_integer(unsigned(wadr1)))   <= wdata1;
                    R_v(to_integer(unsigned(wadr1))) <= '1';
                end if;
            end if;

            if(wen2 = '1') then --On regarde si port 2 d'écriture est enable
                -- for j in 0 to 15 loop
                --     if(to_integer(unsigned(wadr2)) = j) then 
                --         --On regarde si le port2 écrit sur un registre que port1 est en train d'écrire 
                --         if(wen1 = '1' and to_integer(unsigned(wadr1)) /= j) then
                --             if(R_v(j) = '0') then
                --                 R(j)   <= wdata2;
                --                 R_v(j) <= '1';
                --             end if;
                --         end if;
                --     end if;
                -- end loop;
            --version opti--
                if(wen1 = '1' and to_integer(unsigned(wadr1)) /= to_interger(unsigned(wadr2))) then
                    if(R_v(to_interger(unsigned(wadr2))) = '0') then
                        R(to_interger(unsigned(wadr2)))   <= wdata2;
                        R_v(to_interger(unsigned(wadr2))) <= '1';
                    end if;
                end if;

            end if;
            --écriture des flags
            if(cspr_wb = '1') then
                if(CSPR_v(1) = '0') then
                    CSPR(3) <= wneg;
                    CSPR(2) <= wzero;
                    CSPR(1) <= wcry;
                    CSPR_v(1) <= '1';
                end if;
                if(CSPR_v(0) = '0') then
                    CSPR(0) <= wovr;
                    CSPR_v(0) <= '1';
                end if;
            end if;

            --Lecture dans le banc de registre
            for i in 0 to 15 loop
                if (to_integer(unsigned(radr1)) = i) then
                    reg_rd1 <= R(i);
                    reg_v1  <= R_v(i);
                end if;
                if (to_integer(unsigned(radr2)) = i) then
                    reg_rd2 <= R(i);
                    reg_v2  <= R_v(i);
                end if;
                if (to_integer(unsigned(radr3)) = i) then
                    reg_rd3 <= R(i);
                    reg_v3  <= R_v(i);
                end if;
            end loop;
            --Lecture des flags

            reg_ovr <= CSPR(0);
            reg_cry <= CSPR(1);
		    reg_zero<= CSPR(2);		
		    reg_neg	<= CSPR(3);	 
            reg_vv  <= CSPR_v(0);    
		    reg_cznv<= CSPR_v(1);
            if (inc_pc ='1')then
                R(15)<= std_logic_vector(unsigned(R(15)) + 4);
            end if;
            reg_pcv<= R_v(15);
            reg_pc <= R(15);
        end if;
    end process;
end Behavior;


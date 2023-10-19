LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity testbench is
end testbench;

architecture struct of testbench is
SIGNAL op1, op2, res : Std_Logic_Vector(31 downto 0);
SIGNAL cin, cout, z, n, v : Std_Logic;
SIGNAL cmd : Std_Logic_Vector(1 downto 0);
SIGNAL vdd, vss : bit;

BEGIN

    ALU : entity work.ALU(equ) PORT MAP(op1, op2, cin, cmd, res, cout, z, n, v, vdd, vss);

    PROCESS
        variable seed1, seed2: positive;
        variable rand1: real;
        variable int_rand1: integer;
        variable alop1: Std_Logic_Vector(31 downto 0);
        variable seed3, seed4: positive;
        variable rand2: real;
        variable int_rand2: integer;
        variable alop2 : Std_Logic_Vector(31 downto 0);
    BEGIN

        cin <= '0';
        cmd <= "00";


        FOR i in 0 to 10 LOOP
            uniform(seed1, seed2, rand1);
            int_rand1 := integer(trunc(rand1*2147483649.0));
            alop1 := std_logic_vector(to_unsigned(int_rand1,alop1'LENGTH));
            op1 <= alop1;
            FOR j in 0 to 10 LOOP
                uniform(seed3, seed4, rand2);
                int_rand2 := integer(trunc(rand2*2147483649.0));
                alop2 := std_logic_vector(to_unsigned(int_rand2,alop2'LENGTH));
                op2 <= alop2;
                wait for 10 ns;
                --Verification des calculs et opération logique
                if cmd = "00" then
                    if cin = '0' then
                        signed(alop1
                        ASSERT cout&res = STD_LOGIC_VECTOR(to_unsigned(int_rand1+int_rand2,32)) REPORT "ERREUR d'addition cin ='0'!" Severity ERROR;
                        --ASSERT alop2'LENGTH = 32 REPORT "WHATTTTT ?????" Severity ERROR; 
                    else 
                        --ASSERT cout&res = STD_LOGIC_VECTOR(to_unsigned(int_rand1+int_rand2+1,33)) REPORT "ERREUR d'addition cin ='1'!" Severity ERROR;
                    end if;
                elsif cmd = "01" then 
                    ASSERT res = (STD_LOGIC_VECTOR(to_signed(int_rand1,32)) and STD_LOGIC_VECTOR(to_signed(int_rand2,32))) REPORT "ERREUR de AND !" Severity ERROR;
                elsif cmd = "10" then
                    ASSERT res = (STD_LOGIC_VECTOR(to_signed(int_rand1,32)) or STD_LOGIC_VECTOR(to_signed(int_rand2,32))) REPORT "ERREUR de OR !" Severity ERROR; 
                else
                    ASSERT res = (STD_LOGIC_VECTOR(to_signed(int_rand1,32)) xor STD_LOGIC_VECTOR(to_signed(int_rand2,32))) REPORT "ERREUR de XOR !" Severity ERROR; 
                end if;
                --Verification des Drapeaux
                if signed(res) < 0 then
                    ASSERT n = '1' REPORT "ERREUR sur négatif res négatif" Severity ERROR;
                else
                    ASSERT n = '0' REPORT "ERREUR sur négatif res positif" Severity ERROR;
                end if;
            end loop;
        end loop;
        ASSERT false REPORT "PNTNTNTETUIOETIHO ça marche bordel !" Severity NOTE;
        WAIT;
    END PROCESS;

end struct;

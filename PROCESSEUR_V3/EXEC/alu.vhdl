LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Alu is
    port (  op1 : in  Std_Logic_Vector(31 downto 0);
            op2 : in  Std_Logic_Vector(31 downto 0);
            cin : in  Std_Logic;
            cmd : in  Std_Logic_Vector(1 downto 0);
            res : out Std_Logic_Vector(31 downto 0);
            cout: out Std_Logic;
            z   : out Std_Logic;
            n   : out Std_Logic;
            v   : out Std_Logic;
            vdd : in  bit;
            vss : in  bit);
end Alu;

architecture equ of Alu is
SIGNAL temp : Std_Logic_Vector(32 downto 0);
    BEGIN
    
    temp <= std_logic_vector('0'&unsigned(op1) + unsigned(op2) + unsigned'("" & cin));

    res <= temp(31 downto 0) when cmd="00" else 
           op1 and op2       when cmd="01" else
           op1 or  op2       when cmd="10" else 
           op1 xor op2       when cmd="11";

    --cout <= '1' when temp(32) = '1' else '0';
    --cond_v <= ( ((not(op1(31))) and (not(op2(31))) and (temp(31))) or (op1(31) and op2(31) and (not(temp(31)))));
    --cond_v <= ((not(op1(31)) and not(op2(31)) and temp(31)) or (op1(31) and op2(31) and not(temp(31))));
    cout <= temp(32);
    z <= '1' when temp(31 downto 0) = x"00000000" else '0';
    n <= temp(31);
    v <= ((not(op1(31)) and not(op2(31)) and temp(31)) or (op1(31) and op2(31) and not(temp(31))));
    
end equ;

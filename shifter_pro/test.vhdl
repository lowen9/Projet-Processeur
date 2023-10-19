LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity test is
end test;

architecture struct of test is
SIGNAL shift_lsl, shift_lsr, shift_asr, shift_ror, shift_rrx, cin, cout : std_logic;
SIGNAL shift_val : Std_Logic_vector(4 downto 0);
SIGNAL din, dout: Std_Logic_vector(31 downto 0);
SIGNAL vdd, vss : bit;

BEGIN

    SHIFT : entity work.Shifter(behavior) PORT MAP(shift_lsl, shift_lsr, shift_asr, shift_ror, shift_rrx, shift_val, din, cin , dout, cout, vdd, vss);

    process
    begin
        cin <= '0';
        shift_lsl <= '1', '0' after 10 ns;
        shift_lsr <= '0', '1' after 10 ns, '0' after 20 ns;
        shift_asr <= '0', '1' after 20 ns, '0' after 30 ns;
        shift_ror <= '0', '1' after 30 ns, '0' after 40 ns;
        shift_rrx <= '0', '1' after 40 ns, '0' after 50 ns;
        shift_val <= "00100";
        din <= "10110100111101001011000011010011"; 
    wait;
    end process;
end struct;

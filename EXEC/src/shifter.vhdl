LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Shifter is
port( shift_lsl : in Std_Logic;
      shift_lsr : in Std_Logic;
      shift_asr : in Std_Logic;
      shift_ror : in Std_Logic;
      shift_rrx : in Std_Logic;
      shift_val : in Std_Logic_Vector(4 downto 0);
      din : in Std_Logic_Vector(31 downto 0);
      cin : in Std_Logic;
      dout : out Std_Logic_Vector(31 downto 0);
      cout : out Std_Logic;
      -- global interface
      vdd : in bit;
      vss : in bit);
end Shifter;

architecture behavior of Shifter is
signal cout_lsl, cout_alrsr : std_logic;
signal shift_i : integer;
begin

  shift_i <= to_integer(unsigned(shift_val));
  
  dout <= std_logic_vector(shift_left  (unsigned(din), shift_i)) when shift_lsl = '1' else 
          std_logic_vector(shift_right (unsigned(din), shift_i)) when shift_lsr = '1' else
          std_logic_vector(shift_right (  signed(din), shift_i)) when shift_asr = '1' else
          std_logic_vector(rotate_right(unsigned(din), shift_i)) when shift_ror = '1' else
          cin & din(31 downto 1)                                 when shift_rrx = '1' else
          din;

  cout_lsl <= din(32-shift_i) when shift_i > 0 else '0';
  cout_alrsr <= din(shift_i -1) when shift_i > 0 else '0';

  cout <= (cout_lsl)   when shift_lsl = '1' else 
          (cout_alrsr) when shift_lsr = '1' else
          (cout_alrsr) when shift_asr = '1' else
          (cout_alrsr) when shift_ror = '1' else
          din(0)       when shift_rrx = '1' else
          cin;

end behavior;

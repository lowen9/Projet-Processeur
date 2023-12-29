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
--signal flag : std_logic_vector(4 downto 0) := shift_lsl & shift_lsr & shift_asr & shift_ror & shift_rrx;
--signal zero, msb_asr : std_logic_vector(31 downto 0) := (others => '0');
--signal cond_lsl, cond_lsr, cond_asr, cond_ror, cond_rrx : boolean;
--signal one : std_logic_vector(31 downto 0) := X"FFFFFFFF";
signal cout_lsl, cout_alrsr : std_logic;
signal shift_i : integer;
begin

--   zero <= (others =>  '0');
--   one  <= (others =>  '1');

  shift_i <= to_integer(unsigned(shift_val));
  
--   cond_lsl <= (shift_lsl and not(shift_lsr) and not(shift_asr) and not(shift_ror) and not(shift_rrx)) = '1';
--   cond_lsr <= (shift_lsr and not(shift_lsl) and not(shift_asr) and not(shift_ror) and not(shift_rrx)) = '1';
--   cond_asr <= (shift_asr and not(shift_lsl) and not(shift_lsr) and not(shift_ror) and not(shift_rrx)) = '1';
--   cond_ror <= (shift_ror and not(shift_lsl) and not(shift_lsr) and not(shift_asr) and not(shift_rrx)) = '1';
--   cond_rrx <= ((shift_rrx and not(shift_lsl) and not(shift_lsr) and not(shift_asr) and not(shift_ror)) = '1' and shift_val = "00000");

--   msb_asr <= zero when din(31) = '0' else one;

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
    



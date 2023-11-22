library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAE is 
    port(
        clk: in std_logic;
        reset: in std_logic; 
        TF1: in std_logic;--La fifo vers ifetch est pleine
        TF2: in std_logic;--Une première valeur de pc a peu être écrite dans dec2if
        TR1: in std_logic;--if2dec vide, dec2exe pleine ou prédicat invalide, une nouvelle valeur de pc est envoyée vers ifetch si la fifo dec2if n’est pas pleine
        TR2: in std_logic;--Le prédicat est faux, l’instruction doit être jetée
        TR3: in std_logic;--Le prédicat est vrai, l’instruction est exécutée
        TR4: in std_logic;--L’instruction est un appel de fonction
        TR5: in std_logic;--L’instruction est un branchement
        TR6: in std_logic;--L’instruction est un transfert multiple
        TL1: in std_logic;--commande d’exec pour calculer une nouvelle valeur de pc.
        TB1: in std_logic;--if2dec est vide.
        TB2: in std_logic;--if2dec n’est pas vide
    )
end MAE ;

architecture Behavioral of MAE is 
type StateType is (fetch, run, mtrans, link, branch);
signal cur_state, next_state : StateType ; --:= fetch;
--Process d'etats futurs 
process ( ck )
begin
    if( rising_edge(ck)) then
        if(resetn='0') then
            cur_state <= fetch;
        else
            cur_state <= next_state; 
        end if;
    end if; 
end process
--process d'entrees
process( T1, T2 ,T3 ,T4 ,T5 ,T6 ,cur_state)
begin
    case cur_state is 
        when fetch =>
            if (TF2 = '1' )then 
                next_state <= run ;
            else if (TF1='1' and TF2='0' )then 
                next_state <= fetch ;
            end if; 
        when run =>
            if (TR1='1' and TR2='1' and TR3='1' and TR4= '0' and TR5='0' and TR6= '0') then
                next_state <= run; 
            else if (TR4= '1') then 
                next_state <= link; 
            else if (TR5='1') then 
                next_state <= branch; 
            else --if (TR6= '1') then 
                next_state <= mtrans; 
            end if; 
        when link =>
            if (TL1='1') then 
                next_state <= branch;
            else 
                next_state <= link; 
            end if; 
        when branch =>
            if     (TB2='1') then
                next_state <= run; 
            else if(TB1='1') then 
                next_state <= branch; 
            end if; 
        when mtrans =>--- a revoir 
            if     ( T2='1' )  then 
                next_state <= run; 
            else if( T1 ='1' ) then 
                next_state <= mtrans;
            else if( TR5 = '1') then
                next_state <= branch; 
            end if; 
    end case;
end process;

        



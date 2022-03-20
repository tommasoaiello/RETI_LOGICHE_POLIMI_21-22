----------------------------------------------------------------------------------
--  
-- Student : Tommaso Aiello 
-- Codice Persona: 10687571
-- Create Date: 28.01.2022 
-- Design Name: 
-- Module Name: project_reti_logiche - Behavioral
-- Project Name: PROVA FINALE PROGETTO RETI LOGICHE ANNO 2021-2022
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Sintetizzare componente HW che implementa specifica: Codificatore convoluzionale con tasso di trasmissione 1/2
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

--Libraries that have been used
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;




entity project_reti_logiche is
     port (
          i_clk     : in std_logic;
          i_rst     : in std_logic;
          i_start   : in std_logic;
          i_data    : in std_logic_vector(7 downto 0);
          o_address : out std_logic_vector(15 downto 0);
          o_done    : out std_logic;
          o_en      : out std_logic;
          o_we      : out std_logic;
          o_data    : out std_logic_vector (7 downto 0)
     );
     end project_reti_logiche;


architecture Behavioral of project_reti_logiche is
    type STATE is (S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13); --declaration of states of the fsm
    
    signal current_state : STATE ;
    
    signal dimension : std_logic_vector(7 downto 0); 
    signal count_words : unsigned(15 downto 0);
    signal var_words : unsigned(15 downto 0);
    signal write_address : unsigned(15 downto 0);
    signal u: std_logic_vector(7 downto 0);
    signal uk: std_logic;
    signal uk1: std_logic;
    signal uk2: std_logic;
    signal z: std_logic_vector(15 downto 0);
    signal i,vari: unsigned(2 downto 0);
    signal j,varj: unsigned(3 downto 0);
        
    
    begin
        process(i_clk, i_start, i_rst)
            begin
                if rising_edge(i_clk) then
                    o_done <= '0';
                    o_we <='0';
                    o_en <='0';
                    o_data <= (others =>'0');
                    o_address <= (others => '0');
                    if(i_rst ='1') then
                        current_state <=S1;
                    else
                        case current_state is
                        
                             when S1 =>
                                o_en <= '0';
                                o_done <= '0';
                                o_we <='0';
                                o_data <= (others => '0');
                                o_address <= (others => '0');
                                dimension <= "00000000";
                                count_words <= (others => '0');
                                var_words <= (others => '0');
                                i <= "111";
                                j <= "1111";
                                vari <= "111";
                                varj <= "1111";
                                u <= (others => '0');
                                uk <= '0';
                                uk1 <= '0';
                                uk2 <= '0';
                                z <= (others => '0');
                                write_address <= "0000001111101000";
                                if i_start = '1' then 
                                    current_state <= S2;
                                else 
                                    current_state <= S1;
                                end if;
                                
                             when S2 =>
                                o_en <= '1';
                                o_done <= '0';
                                o_we <='0';
                                o_address <= (others => '0');
                                current_state <= S3;
                             
                             when S3 =>
                                o_en <='1';
                                o_we <='0';
                                current_state <= S4;
                             
                             when S4 =>
                                o_en <= '1';
                                o_we <='0';
                                o_address <= std_logic_vector(count_words + 1);
                                dimension <= i_data;
                                current_state <= S5;
                             
                             when S5 =>
                                o_en <= '1';
                                o_we <= '0';
                                if count_words = unsigned(dimension) then
                                    current_state <=S12;
                                else 
                                    current_state <= S6;
                                end if;
                                
                             when S6 =>
                                o_we <='0';
                                u <= i_data;
                                current_state <= S7;
                             
                             when S7 =>
                                o_we <='0';
                                uk <= u(to_integer(i));
                                current_state <= S8;
                             
                             when S8 =>
                                o_en <='0';
                                o_we <= '0';
                                if not(i = "000") then
                                    uk <= u(to_integer(i)-1);
                                    uk1 <= uk;
                                    uk2 <= uk1;
                                  
                                    if( (uk ='0' and uk1 ='0' and uk2 ='0') or ( uk='1' and uk1='0' and uk2 ='1')) then
                                        z(to_integer(j)) <= '0';
                                        z(to_integer(j)-1) <= '0';
                                        
                                    elsif ( (uk ='0' and uk1 ='1' and uk2 ='0') or ( uk='1' and uk1='1' and uk2 ='1')) then
                                        z(to_integer(j)) <= '0';
                                        z(to_integer(j)-1) <= '1';
    
                                    elsif( (uk ='0' and uk1 ='1' and uk2 ='1') or ( uk='1' and uk1='1' and uk2 ='0')) then
                                        z(to_integer(j)) <= '1';
                                        z(to_integer(j)-1) <= '0';
                                        
                                    elsif( (uk ='0' and uk1 ='0' and uk2 ='1') or ( uk='1' and uk1='0' and uk2 ='0')) then    
                                        z(to_integer(j)) <= '1';
                                        z(to_integer(j)-1) <= '1';
                                    end if;
                                    
                                    i <= vari - 1 ;
                                    vari <= i - 1 ;
                                    j <= varj - 2;
                                    varj <= j - 2;
                                    current_state <= S8;
                                    
                               else 
                                    uk1 <= uk;
                                    uk2 <= uk1;
                                  
                                    if( (uk ='0' and uk1 ='0' and uk2 ='0') or ( uk='1' and uk1='0' and uk2 ='1')) then
                                        z(to_integer(j)) <= '0';
                                        z(to_integer(j)-1) <= '0';
                                        
                                    elsif ( (uk ='0' and uk1 ='1' and uk2 ='0') or ( uk='1' and uk1='1' and uk2 ='1')) then
                                        z(to_integer(j)) <= '0';
                                        z(to_integer(j)-1) <= '1';
                                        
                                    elsif( (uk ='0' and uk1 ='1' and uk2 ='1') or ( uk='1' and uk1='1' and uk2 ='0')) then
                                        z(to_integer(j)) <= '1';
                                        z(to_integer(j)-1) <= '0';
                                        
                                    elsif( (uk ='0' and uk1 ='0' and uk2 ='1') or ( uk='1' and uk1='0' and uk2 ='0')) then    
                                        z(to_integer(j)) <= '1';
                                        z(to_integer(j)-1) <= '1';
                                        
                                    end if;
                                    
                                    i <= "111";
                                    vari <= "111" ;
                                    j <= "1111";
                                    varj <= "1111";
                                    
                                    current_state <= S9;
                               end if;
                             
                             when S9 =>
                                o_en <= '1';
                                o_we <='1';
                                o_address <= std_logic_vector(write_address);
                                o_data <= z(15 downto 8);
                                var_words <= count_words;
                                current_state <= S10;
                                
                             when S10=>
                                count_words <= var_words + 1;  
                                o_en <= '1';
                                o_we <= '1';
                                o_address <= std_logic_vector(write_address + 1);
                                o_data <= z(7 downto 0);
                                current_state <= S11;
                                var_words <= write_address;
                                
                             when S11 =>
                                write_address <= var_words + 2;
                                o_en <='1';
                                o_we <= '0';
                                o_address <= std_logic_vector (count_words + 1);
                                current_state <= S5;
                                
                             when S12 =>
                                o_done <= '1';
                                o_en <= '0';
                                if(i_start = '1') then
                                    current_state <= S12;
                                else
                                    current_state <= S13;
                                end if;
                             
                             when S13 =>
                                o_done <= '0';
                                current_state <= S1;
                            
                        end case;
                   end if;
                end if;  
        end process;            
                
    
    
end Behavioral;


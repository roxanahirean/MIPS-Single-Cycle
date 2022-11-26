----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2022 12:36:37 PM
-- Design Name: 
-- Module Name: IDecode - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IDecode is
--  Port ( );
    Port( clk: in std_logic;
    instr: in std_logic_vector(15 downto 0);
    wd: in std_logic_vector(15 downto 0);
    en: in std_logic;
    reg_write: in std_logic;
    reg_dst: in std_logic;
    ext_op: in std_logic;
    rd1: out std_logic_vector(15 downto 0);
    rd2: out std_logic_vector(15 downto 0);
    ext_imm: out std_logic_vector(15 downto 0);
    func: out std_logic_vector(2 downto 0);
    sa: out std_logic);
end IDecode;

architecture Behavioral of IDecode is

component reg_file is
port (
    clk : in std_logic;
    ra1 : in std_logic_vector (2 downto 0);
    ra2 : in std_logic_vector (2 downto 0);
    wa : in std_logic_vector (2 downto 0);
    wd : in std_logic_vector (15 downto 0);
    regwr : in std_logic;
    en: in std_logic;
    rd1 : out std_logic_vector (15 downto 0);
    rd2 : out std_logic_vector (15 downto 0)
    
);
end component reg_file;

signal wa : std_logic_vector(2 downto 0) := (others => '0');

begin
registers: reg_file port map(clk, instr(12 downto 10), instr(9 downto 7), wa, wd, reg_write, en, rd1, rd2);


    wa <= instr(6 downto 4) when reg_dst = '1' else instr(9 downto 7);
    sa <= instr(3);
    func <= instr(2 downto 0);
    ext_imm <= "000000000" & instr(6 downto 0) when ext_op = '0' else instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6 downto 0);
    

end Behavioral;

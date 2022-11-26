----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2022 10:42:57
-- Design Name: 
-- Module Name: test_env - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
  Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0)
           );
end test_env;


architecture Behavioral of test_env is                

component MPG is
Port(clock: in STD_LOGIC;
        btn:in STD_LOGIC;
        en:out STD_LOGIC);
end component;

component SSD is
    Port ( clk: in STD_LOGIC;
           digits: in STD_LOGIC_VECTOR(15 downto 0);
           anod: out STD_LOGIC_VECTOR(3 downto 0);
           catod: out STD_LOGIC_VECTOR(6 downto 0));
end component;

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
end component;

component IF1 is
 Port( clk: in std_logic;
 en: in std_logic;
 rst: in std_logic;
 brAddr: in std_logic_vector(15 downto 0);
 jmpAddr: in std_logic_vector(15 downto 0);
 pcSrc: in std_logic;
 jump: in std_logic;
 instr: out std_logic_vector(15 downto 0);
 pcout:out std_logic_vector(15 downto 0)
 );
 end component;


--component rams_no_change is
-- port ( clk : in std_logic;
--       we : in std_logic;
--       en : in std_logic;
--       addr : in std_logic_vector(3 downto 0);
--       di : in std_logic_vector(15 downto 0);
--       do : out std_logic_vector(15 downto 0));
-- end component;

component MainControl is
Port ( 
    Instr : in std_logic_vector(15 downto 13);
    RegDst : out std_logic;    
    ExtOp : out std_logic;    
    ALUSrc : out std_logic;    
    Branch : out std_logic;    
    Jump : out std_logic;    
    ALUOp : out std_logic_vector(2 downto 0);    
    MemWrite : out std_logic;    
    MemToReg : out std_logic;    
    RegWrite : out std_logic;    
    BranchNE : out std_logic  
    );
end component MainControl;

component IDecode is
    Port (
        clk : in std_logic;
        instr : in std_logic_vector (15 downto 0);
        wd : in std_logic_vector (15 downto 0);
        en : in std_logic;
        reg_write : in std_logic;
        reg_dst : in std_logic;
        ext_op : in std_logic;
        rd1 : out std_logic_vector (15 downto 0);
        rd2 : out std_logic_vector (15 downto 0);
        ext_imm : out std_logic_vector (15 downto 0);
        func : out std_logic_vector (2 downto 0);
        sa : out std_logic);
end component IDecode;


component MEM is
    Port (
        clk : in std_logic;
        en : in std_logic;
        MemWrite : in std_logic;
        ALUResIn : in std_logic_vector(15 downto 0);
        RD2 : in std_logic_vector(15 downto 0);
        MemData : out std_logic_vector(15 downto 0);
        ALUResOut: out std_logic_vector(15 downto 0));
end component MEM;

component EX is
    Port (
        RD1 : in std_logic_vector (15 downto 0);
        ALUSrc : in std_logic;
        RD2 : in std_logic_vector (15 downto 0);
        ext_imm : in std_logic_vector (15 downto 0);
        sa : in std_logic;
        func : in std_logic_vector(2 downto 0);
        ALUOp: in std_logic_vector(2 downto 0);
        PCp1: in std_logic_vector(15 downto 0);
        Zero: out std_logic;
        ALURes: out std_logic_vector(15 downto 0);
        BranchAddress: out std_logic_vector(15 downto 0));
end component EX;

--signal cnt: std_logic_vector (3 downto 0):= "0000";
signal en: std_logic := '0';
signal rst: std_logic := '0';
signal digits : std_logic_vector(15 downto 0) := (others => '0');
--signal digitSSD: std_logic_vector (15 downto 0):= (others=> '0');
--signal zero: std_logic :='0';

signal rd1 : std_logic_vector(15 downto 0) := (others => '0');
signal rd2 : std_logic_vector(15 downto 0) := (others => '0');

--signal enable_reg: std_logic := '0';  --pt al doilea mpg
--signal do: std_logic_vector(15 downto 0) := (others => '0');
signal rez: std_logic_vector(15 downto 0) := (others => '0');
signal BrAdd: std_logic_vector(15 downto 0):= (others => '0');
signal JAdd: std_logic_vector(15 downto 0):= (others => '0' );
--signal pcSrc: std_logic := '0' ;
--signal jump: std_logic := '0';

signal instr: std_logic_vector(15 downto 0) := (others => '0' );
signal pcout: std_logic_vector(15 downto 0):= (others => '0');

signal ralu : std_logic_vector(15 downto 0) := (others => '0');
signal ext_imm : std_logic_vector(15 downto 0) := (others => '0');
--signal ext_func : std_logic_vector(15 downto 0) := (others => '0');
--signal ext_sa : std_logic_vector(15 downto 0) := (others => '0');
signal func : std_logic_vector(2 downto 0) := (others => '0');
signal sa : std_logic := '0';
signal BranchAddress : std_logic_vector(15 downto 0) := (others => '0');
signal ALUResOut : std_logic_vector(15 downto 0) := (others => '0');
signal MemData : std_logic_vector(15 downto 0) := (others => '0');
signal WD : std_logic_vector(15 downto 0) := (others => '0');
signal jaddr : std_logic_vector(15 downto 0) := (others => '0');


signal RegDst : std_logic := '0';
--signal reg_dst : std_logic := '0';
signal ExtOp : std_logic := '0';
signal ALUSrc : std_logic := '0';
signal Branch : std_logic := '0';
signal Jump : std_logic := '0';
signal ALUOp : std_logic_vector(2 downto 0) := "000";
signal MemWrite : std_logic := '0';
signal MemToReg : std_logic := '0';
signal RegWrite : std_logic := '0';
signal BranchNE : std_logic := '0';

signal Zero : std_logic := '0';
signal PCSrc : std_logic := '0';


--type MEM is array ( 0 to 255) of std_logic_vector (15 downto 0);

--signal rom: MEM := (x"0000",
 --                   x"0001",
 --                   x"0010",
 --                   x"0011",
 --                   x"0100",
 --                   others => "0000000000000000");
--signal data : std_logic_vector(15 downto 0);    


begin

MPG1: MPG port map (clk, btn(0), rst);
MPG2: mpg port map(clk, btn(1), en);
--data<= rom(conv_integer(cnt));
ss: SSD port map(clk, digits, an, cat);
--reg: reg_file port map(clk, cnt(3 downto 0), cnt (3 downto 0), cnt(3 downto 0),rez,enable_reg, rd1, rd2);
iff: IF1 port map(clk, en, rst, x"0010", x"0000", sw(1), sw(0), instr, pcout);
--ramm: rams_no_change port map(clk,enable_reg, en, cnt, digits, do);
--monopulse_regwr: mpg port map(clk,btn(1),enable_reg);

I_Decode: IDecode port map(clk, instr, ralu, en, RegWrite, RegDst, ExtOp, rd1, rd2, ext_imm, func, sa);

main_control: MainControl port map( instr(15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemToReg, RegWrite, BranchNE);

memory: MEM port map(clk, en, MemWrite, ralu, rd2, MemData, AluResOut);
instr_exec: EX port map(rd1, ALUSrc, rd2, ext_imm, sa, func, ALUOp, pcout, Zero, ralu, BranchAddress);


    jaddr <= (pcout(15 downto 13) & instr(12 downto 0));
    WD <= MemData when MemToReg = '1' else ALUResOut;
    PCSrc <= (Branch and Zero) or (BranchNE and not Zero);
    

       
--digits <= pcout when sw(7) ='1' else instr;

--    ralu <= rd1 + rd2;
        
process(sw(7 downto 5), instr, pcout, rd1, rd2, ext_imm, ralu, MemData, WD)
    begin
        case sw(7 downto 5) is
            when "000" => digits <= instr;
            when "001" => digits <= pcout;
            when "010" => digits <= rd1;
            when "011" => digits <= rd2;
            when "100" => digits <= ext_imm;
            when "101" => digits <= ralu;
            when "110" => digits <= MemData;
            when "111" => digits <= WD;
        end case;
    end process;      
    

      led(11 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemToReg & RegWrite & BranchNE;

--    ext_func <= "0000000000000" & func;
--    ext_sa <= "000000000000000" & sa;
    


--alu

--process(cnt)
  --  begin
   --     case cnt is
   --         when "00" => digitSSD <= ("000000000000" & sw(3 downto 0)) + ("000000000000" & sw(7 downto 4)); 
    --        when "01" => digitSSD <= ("000000000000" & sw(3 downto 0)) - ("000000000000" & sw(7 downto 4));              
    --        when "10" => digitSSD <= "000000" & sw(7 downto 0) & "00";
    --        when "11" => digitSSD <= "0000000000000" & sw(7 downto 5);
    --    end case;
    --    if digitSSD = x"0000" then
      --              zero <= '1';
    --            else
    --                zero <= '0';
    --            end if;
 --   end process;
    --led(7) <= zero;

--
--process (clk,en)
--begin
--if rising_edge(clk) then
--   if en ='1' then
--     if sw(0)='1' then
--      cnt<= cnt+1;
--     else
--      cnt<= cnt-1;
--     end if;
--    end if;
-- end if;
--end process;

--rez<= rd1+rd2;

--led <= cnt;
   
end Behavioral;
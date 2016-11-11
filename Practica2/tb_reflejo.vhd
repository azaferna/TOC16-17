--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:17:19 10/25/2016
-- Design Name:   
-- Module Name:   C:/hlocal/Practica2/tb_reflejo.vhd
-- Project Name:  Practica2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reflejo
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_reflejo IS
END tb_reflejo;
 
ARCHITECTURE behavior OF tb_reflejo IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT reflejo
    PORT(
         clk 		: in   std_logic;
         rst 		: in   std_logic;
         boton 	: in   std_logic;
         switch 	: in   std_logic;
         leds 		: out  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    
 
   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal boton : std_logic := '0';
   signal switch : std_logic := '0';
 
 	--Outputs
   signal leds : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: reflejo PORT MAP (
          clk => clk,
          rst => rst,
          boton => boton,
          switch => switch,
          leds => leds
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process 
   stim_proc: process
   begin		
      rst <= '1';
		switch <= '1';
		boton <= '1';
		wait for 40 ns;
		
		rst <= '0';
		switch <= '0';
		boton <= '1';
		wait for 40 ns;
		
		boton <= '0';
      wait;
   end process;

END;

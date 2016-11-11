----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:14:56 10/25/2016 
-- Design Name: 
-- Module Name:    reflejo - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reflejo is
	port(
		clk   :	in std_logic;
		rst   :	in std_logic;	
		boton :	in std_logic;
		switch:	in std_logic; --Para ir al estado de espera desde los leds
		leds :	out std_logic_vector(4 downto 0);
		numero : out std_logic_vector(6 downto 0)
		);
end reflejo;

architecture Behavioral of reflejo is

-- 	Estructura de estados
	type		ESTADOS	is	(ESPERA, COORDINACION, RAPIDO, MEDIO, LENTO, ERROR, LED_RAPIDO, LED_MEDIO, LED_LENTO, LED_ERROR, 
							s0,s1,s2,s3,s4,s5,s6,s7); 
--				S0 = ESPERA
--				S1 = COORDINACION	--Led 4
--				S2 = RAPIDO
--				S3 = MEDIO
--				S4 = LENTO
--				S5 = ERROR
--				S6 = LED_RAPIDO 	--Led 3
--				S7 = LED_MEDIO  	--Led 2
--				S8 = LED_LENTO 		--Led 1
--				S9 = LED_ERROR		--Led 0
--	Señal para los cambios de estado	
	signal	ESTADO,	SIG_ESTADO:	ESTADOS;

--	Divisor de frecuencia del reloj para poder ver los cambios en la FPGA
	component divisor
			port(
				rst 		:	in  std_logic;	
				clk_in 	:	in  std_logic;	
				clk_out 	:	out std_logic
			);		
	end component;	

--  Señal de reloj para conectar el divisor con la maquina de estados
	signal clk_intermediate: std_logic;

begin
--	Descomentar según convenga
--	USANDO DIVISOR PARA LA FPGA
	divider_1: divisor 
	port map (
					rst		=>	'0',	
					clk_in	=>	clk,	
					clk_out	=>	clk_intermediate
				);	
					
					
	--divider_1: divisor port map(rst,clk,clk_intermediate);
	--PARA LA SIMULACION	
--clk_intermediate	<=	clk;	
	
-- Proceso de cambio de estados
	process (rst, clk_intermediate)
	begin
	
	if rst = '1' then
		SIG_ESTADO <= ESPERA;
	
	elsif rising_edge(clk_intermediate) then
		case ESTADO is
		   when ESPERA =>
				SIG_ESTADO <= COORDINACION;
				
			when COORDINACION =>
				SIG_ESTADO <= RAPIDO;
				
			when RAPIDO =>
				if boton = '0' then
					SIG_ESTADO <= LED_RAPIDO;
				else
					SIG_ESTADO <= MEDIO;
				end if;
				
			when MEDIO =>
				if boton = '0' then
					SIG_ESTADO <= LED_MEDIO;
				else
					SIG_ESTADO <= LENTO;
				end if;
				
			when LENTO =>
				if boton = '0' then
					SIG_ESTADO <= LED_LENTO;
				else
					SIG_ESTADO <= ERROR;
				end if;
				
			when ERROR =>
				SIG_ESTADO <= LED_ERROR;
			
			when LED_RAPIDO =>
			if switch = '1' then
				SIG_ESTADO <= ESPERA;
				else 
				SIG_ESTADO <= LED_RAPIDO;
			end if;
			when LED_MEDIO =>
				if switch = '1' then
					SIG_ESTADO <= ESPERA;
				else 
					SIG_ESTADO <= LED_MEDIO;
				end if;
			when LED_LENTO =>
				if switch = '1' then
					SIG_ESTADO <= ESPERA;
				else 
					SIG_ESTADO <= LED_LENTO;
				end if;
			when LED_ERROR =>
				SIG_ESTADO <= s0;
					when s0 => --y
						SIG_ESTADO <= s1;
					when s1 =>--o
						SIG_ESTADO <= s2;
					when s2 =>--u
						SIG_ESTADO <= s3;
					when s3 => -- 
						SIG_ESTADO <= s4;
					when s4 => --l
						SIG_ESTADO <= s5;
					when s5 =>--o
						SIG_ESTADO <= s6;
					when s6 =>--s
						SIG_ESTADO <= s7;
					when s7 =>--e
						SIG_ESTADO <= espera;
			end case;
		end if;
	end process;
	
	--Process que hace que el reloj cambie los estados
	process (clk_intermediate)
	begin
		if rising_edge(clk_intermediate) then
			ESTADO <= SIG_ESTADO;
		end if;
	end process;
	
	--Process que pone las salidas en los estados

	process (rst, clk_intermediate)
	begin
		if rst = '1' then
			leds <= "00000";
			
		elsif rising_edge(clk_intermediate) then --especificar en hojas
			case ESTADO is
				when COORDINACION =>
					leds <= "00001";
					numero <="0000110";
				when LED_RAPIDO =>
					leds  <= "00010";
					numero <="1011011";
				when LED_MEDIO =>
					leds  <= "00100";
					numero <="0011111";
				when LED_LENTO =>
					leds  <= "01000";
					numero <="1100110";
				when LED_ERROR =>
					leds  <= "10000";
					numero <="1101101";
					
					when s0 =>
						numero <="1101110"; --y
					when s1 =>
						numero <="0111111";--o
					when s2 =>
						numero <="0111110";--u
					when s3 =>
						numero <="0000000";--
					when s4 =>
						numero <="0111000";--l
					when s5 =>
						numero <="0111111";--o
					when s6 =>
						numero <="1111001";--s
					when s7 =>
						numero <="1101101";--e
		
				when others => leds <= "00000" ;
				--when others =>numero <= "0000000";
			end case;
		end if;
	end process;
end Behavioral;

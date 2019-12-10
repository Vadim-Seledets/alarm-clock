library IEEE;
use IEEE.STD_LOGIC_1164.all;

package AudioDriverTypes is

	-- Types and subtypes
	
	subtype TPureTone is integer range 0 to 20000;
	subtype TTone is integer range 0 to 255;
	subtype TToneIndex is integer range 0 to 7; 
	subtype TDuration is integer range 0 to 1000;
	
	type TSound is
	record
		Tone: TTone;
		Duration: TDuration;
	end record;

	type TPureTones is array (0 to 7) of TPureTone;
	type TTones is array (0 to 7) of TTone;
	type TToneName is (Do, Re, Mi, Fa, So, La, Si, TDo);
	
	-- Constants
	
	constant pwm_frequency: integer := 10000000;
	constant N: integer := 128;
	constant pwm_freq_div_N: integer := pwm_frequency / N;
	constant PureTones: TPureTones := (523, 587, 659, 698, 784, 880, 988, 1047);
	constant Tones: TTones := (
		pwm_freq_div_N / PureTones(0), -- Do
		pwm_freq_div_N / PureTones(1), -- Re
		pwm_freq_div_N / PureTones(2), -- Mi
		pwm_freq_div_N / PureTones(3), -- Fa
		pwm_freq_div_N / PureTones(4), -- So
		pwm_freq_div_N / PureTones(5), -- La
		pwm_freq_div_N / PureTones(6), -- Si
		pwm_freq_div_N / PureTones(7)  -- TDo
	);
	
	-- Function declarations

	function ToneNameToToneIndex(signal tone_name: IN TToneName) return TToneIndex;

end AudioDriverTypes;
	
package body AudioDriverTypes is

	-- Function implementations
	
	function ToneNameToToneIndex(signal tone_name: IN TToneName) return TToneIndex is
		variable result: TToneIndex := 0;
	begin
		if tone_name = Do then
			result := 0;
		elsif tone_name = Re then
			result := 1;
		elsif tone_name = Mi then
			result := 2;
		elsif tone_name = Fa then
			result := 3;
		elsif tone_name = So then
			result := 4;
		elsif tone_name = La then
			result := 5;
		elsif tone_name = Si then
			result := 6;
		elsif tone_name = TDo then
			result := 7;
		end if;
		return result;
	end function;
	
end AudioDriverTypes;

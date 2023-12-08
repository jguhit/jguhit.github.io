-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Tue Apr 27 15:45:02 2021
-- Host        : PHYS-XUEYEHU10 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ vio_0_stub.vhdl
-- Design      : vio_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in1 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe_in2 : in STD_LOGIC_VECTOR ( 17 downto 0 );
    probe_in3 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe_in4 : in STD_LOGIC_VECTOR ( 17 downto 0 );
    probe_in5 : in STD_LOGIC_VECTOR ( 5 downto 0 );
    probe_in6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out0 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out2 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out3 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out4 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out5 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out6 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out7 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out8 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out9 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out10 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out11 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out12 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out13 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out14 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out15 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out16 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out17 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out18 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out19 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out20 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out21 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out22 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out23 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out24 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out25 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out26 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out27 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out28 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out29 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out30 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out31 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out32 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out33 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out34 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out35 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out36 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out37 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out38 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out39 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out40 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out41 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out42 : out STD_LOGIC_VECTOR ( 23 downto 0 )
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[0:0],probe_in1[6:0],probe_in2[17:0],probe_in3[10:0],probe_in4[17:0],probe_in5[5:0],probe_in6[0:0],probe_out0[23:0],probe_out1[23:0],probe_out2[23:0],probe_out3[23:0],probe_out4[23:0],probe_out5[23:0],probe_out6[23:0],probe_out7[23:0],probe_out8[23:0],probe_out9[23:0],probe_out10[23:0],probe_out11[23:0],probe_out12[23:0],probe_out13[23:0],probe_out14[23:0],probe_out15[23:0],probe_out16[23:0],probe_out17[23:0],probe_out18[23:0],probe_out19[23:0],probe_out20[23:0],probe_out21[23:0],probe_out22[23:0],probe_out23[23:0],probe_out24[23:0],probe_out25[23:0],probe_out26[23:0],probe_out27[23:0],probe_out28[23:0],probe_out29[23:0],probe_out30[23:0],probe_out31[23:0],probe_out32[23:0],probe_out33[23:0],probe_out34[23:0],probe_out35[23:0],probe_out36[23:0],probe_out37[23:0],probe_out38[23:0],probe_out39[23:0],probe_out40[23:0],probe_out41[23:0],probe_out42[23:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2019.2";
begin
end;

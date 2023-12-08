-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Thu Jul  8 17:59:47 2021
-- Host        : PHYS-XUEYEHU10 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top vio_0 -prefix
--               vio_0_ vio_0_stub.vhdl
-- Design      : vio_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vio_0 is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in1 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in2 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in3 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in4 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in5 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in6 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in7 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in8 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in9 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in10 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in11 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in12 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in13 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in14 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in15 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in16 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in17 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in18 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in19 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in20 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in21 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in22 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in23 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in24 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in25 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in26 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in27 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in28 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in29 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in30 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in31 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in32 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in33 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in34 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in35 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in36 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in37 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in38 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in39 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in40 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in41 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in42 : in STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_in43 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in44 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_in45 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in46 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 5 downto 0 );
    probe_out2 : out STD_LOGIC_VECTOR ( 17 downto 0 );
    probe_out3 : out STD_LOGIC_VECTOR ( 10 downto 0 );
    probe_out4 : out STD_LOGIC_VECTOR ( 17 downto 0 );
    probe_out5 : out STD_LOGIC_VECTOR ( 5 downto 0 );
    probe_out6 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out7 : out STD_LOGIC_VECTOR ( 17 downto 0 );
    probe_out8 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out9 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out10 : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end vio_0;

architecture stub of vio_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[23:0],probe_in1[23:0],probe_in2[23:0],probe_in3[23:0],probe_in4[23:0],probe_in5[23:0],probe_in6[23:0],probe_in7[23:0],probe_in8[23:0],probe_in9[23:0],probe_in10[23:0],probe_in11[23:0],probe_in12[23:0],probe_in13[23:0],probe_in14[23:0],probe_in15[23:0],probe_in16[23:0],probe_in17[23:0],probe_in18[23:0],probe_in19[23:0],probe_in20[23:0],probe_in21[23:0],probe_in22[23:0],probe_in23[23:0],probe_in24[23:0],probe_in25[23:0],probe_in26[23:0],probe_in27[23:0],probe_in28[23:0],probe_in29[23:0],probe_in30[23:0],probe_in31[23:0],probe_in32[23:0],probe_in33[23:0],probe_in34[23:0],probe_in35[23:0],probe_in36[23:0],probe_in37[23:0],probe_in38[23:0],probe_in39[23:0],probe_in40[23:0],probe_in41[23:0],probe_in42[23:0],probe_in43[0:0],probe_in44[2:0],probe_in45[0:0],probe_in46[0:0],probe_out0[0:0],probe_out1[5:0],probe_out2[17:0],probe_out3[10:0],probe_out4[17:0],probe_out5[5:0],probe_out6[0:0],probe_out7[17:0],probe_out8[0:0],probe_out9[0:0],probe_out10[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2019.2";
begin
end;

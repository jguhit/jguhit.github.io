-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Mon Jul 12 09:52:53 2021
-- Host        : t3pers21.physics.lsa.umich.edu running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub
--               /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_ETH_TX_PACKING/ila_ETH_TX_PACKING_stub.vhdl
-- Design      : ila_ETH_TX_PACKING
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ila_ETH_TX_PACKING is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe4 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe7 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe8 : in STD_LOGIC_VECTOR ( 8 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 9 downto 0 )
  );

end ila_ETH_TX_PACKING;

architecture stub of ila_ETH_TX_PACKING is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[0:0],probe1[0:0],probe2[0:0],probe3[0:0],probe4[2:0],probe5[7:0],probe6[0:0],probe7[0:0],probe8[8:0],probe9[9:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "ila,Vivado 2019.2";
begin
end;

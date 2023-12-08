-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Mon Jul 12 09:50:37 2021
-- Host        : t3pers21.physics.lsa.umich.edu running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub
--               /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/vio_ETH_TX_PRELOAD/vio_ETH_TX_PRELOAD_stub.vhdl
-- Design      : vio_ETH_TX_PRELOAD
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vio_ETH_TX_PRELOAD is
  Port ( 
    clk : in STD_LOGIC;
    probe_out0 : out STD_LOGIC_VECTOR ( 47 downto 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 47 downto 0 )
  );

end vio_ETH_TX_PRELOAD;

architecture stub of vio_ETH_TX_PRELOAD is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_out0[47:0],probe_out1[47:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2019.2";
begin
end;

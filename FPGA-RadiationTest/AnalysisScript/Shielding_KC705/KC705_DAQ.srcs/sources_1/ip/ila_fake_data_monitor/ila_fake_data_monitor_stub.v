// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Jul 12 09:52:52 2021
// Host        : t3pers21.physics.lsa.umich.edu running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_fake_data_monitor/ila_fake_data_monitor_stub.v
// Design      : ila_fake_data_monitor
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "ila,Vivado 2019.2" *)
module ila_fake_data_monitor(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[0:0],probe2[0:0],probe3[0:0],probe4[2:0],probe5[7:0],probe6[0:0]" */;
  input clk;
  input [0:0]probe0;
  input [0:0]probe1;
  input [0:0]probe2;
  input [0:0]probe3;
  input [2:0]probe4;
  input [7:0]probe5;
  input [0:0]probe6;
endmodule

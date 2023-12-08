// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Jul 12 09:50:37 2021
// Host        : t3pers21.physics.lsa.umich.edu running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/vio_fake_data/vio_fake_data_stub.v
// Design      : vio_fake_data
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.2" *)
module vio_fake_data(clk, probe_out0, probe_out1, probe_out2)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_out0[0:0],probe_out1[0:0],probe_out2[15:0]" */;
  input clk;
  output [0:0]probe_out0;
  output [0:0]probe_out1;
  output [15:0]probe_out2;
endmodule

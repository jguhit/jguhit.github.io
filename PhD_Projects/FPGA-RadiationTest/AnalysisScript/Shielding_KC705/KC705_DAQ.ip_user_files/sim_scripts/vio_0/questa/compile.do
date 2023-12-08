vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm -64 -sv "+incdir+../../../../KC705_DAQ.srcs/sources_1/ip/vio_0/hdl/verilog" "+incdir+../../../../KC705_DAQ.srcs/sources_1/ip/vio_0/hdl" \
"C:/Xilinx2020/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93 \
"C:/Xilinx2020/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../KC705_DAQ.srcs/sources_1/ip/vio_0/sim/vio_0.vhd" \


vlog -work xil_defaultlib \
"glbl.v"


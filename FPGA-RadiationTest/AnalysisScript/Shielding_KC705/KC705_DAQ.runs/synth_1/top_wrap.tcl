# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param chipscope.maxJobs 1
set_param tcl.collectionResultDisplayLimit 0
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7k325tffg900-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/xx/work/KC705_DAQ/KC705_DAQ.cache/wt [current_project]
set_property parent.project_path /home/xx/work/KC705_DAQ/KC705_DAQ.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part xilinx.com:kc705:part0:1.6 [current_project]
set_property ip_output_repo /home/xx/work/KC705_DAQ/KC705_DAQ.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib -sv {
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/Test_env/sys_defs.sv
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/Test_env/Control_Center.sv
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/Test_env/ETH_RX_Filter.sv
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/Test_env/ETH_TX_Packing.sv
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/Test_env/ETH_TX_Submodule_Sending_FSM.sv
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/Test_env/Sendback_Center.sv
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/Test_env/fake_data_sent.sv
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/Test_env/top_wrap.sv
}
set_property is_global_include true [get_files /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/Test_env/sys_defs.sv]
read_verilog -library xil_defaultlib {
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/Test_env/Risingedge_Pulse.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/ethernet_mac_interface.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/axi_lite_sm/tri_mode_ethernet_mac_0_axi_lite_sm.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/fifo/tri_mode_ethernet_mac_0_bram_tdp.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/tri_mode_ethernet_mac_0_clk_wiz.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/tri_mode_ethernet_mac_0_example_design_clocks.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/tri_mode_ethernet_mac_0_example_design_resets.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/tri_mode_ethernet_mac_0_fifo_block.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/common/tri_mode_ethernet_mac_0_reset_sync.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/fifo/tri_mode_ethernet_mac_0_rx_client_fifo.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/support/tri_mode_ethernet_mac_0_support.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/support/tri_mode_ethernet_mac_0_support_resets.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/common/tri_mode_ethernet_mac_0_sync_block.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/fifo/tri_mode_ethernet_mac_0_ten_100_1g_eth_fifo.v
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/fifo/tri_mode_ethernet_mac_0_tx_client_fifo.v
}
read_vhdl -library xil_defaultlib {
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/mezz_jtag_emul.vhd
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/imports/prbs/prbs_any.vhd
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/imports/prbs/prbs_chk.vhd
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/imports/prbs/prbs_chk_4ch.vhd
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/imports/prbs/prbs_gen.vhd
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/imports/prbs/prbs_gen_4ch.vhd
  /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/top.vhd
}
read_ip -quiet /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/vio_0/vio_0.xci
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/vio_0/vio_0.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/vio_0/vio_0_ooc.xdc]

read_ip -quiet /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

read_ip -quiet /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_fake_data_monitor/ila_fake_data_monitor.xci
set_property used_in_synthesis false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_fake_data_monitor/ila_v6_2/constraints/ila_impl.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_fake_data_monitor/ila_v6_2/constraints/ila_impl.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_fake_data_monitor/ila_v6_2/constraints/ila.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_fake_data_monitor/ila_fake_data_monitor_ooc.xdc]

read_ip -quiet /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/vio_ETH_TX_PRELOAD/vio_ETH_TX_PRELOAD.xci
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/vio_ETH_TX_PRELOAD/vio_ETH_TX_PRELOAD.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/vio_ETH_TX_PRELOAD/vio_ETH_TX_PRELOAD_ooc.xdc]

read_ip -quiet /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/vio_fake_data/vio_fake_data.xci
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/vio_fake_data/vio_fake_data.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/vio_fake_data/vio_fake_data_ooc.xdc]

read_ip -quiet /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_ETH_TX_PACKING/ila_ETH_TX_PACKING.xci
set_property used_in_synthesis false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_ETH_TX_PACKING/ila_v6_2/constraints/ila_impl.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_ETH_TX_PACKING/ila_v6_2/constraints/ila_impl.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_ETH_TX_PACKING/ila_v6_2/constraints/ila.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_ETH_TX_PACKING/ila_ETH_TX_PACKING_ooc.xdc]

read_ip -quiet /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/fifo_ETH_TX/fifo_ETH_TX.xci
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/fifo_ETH_TX/fifo_ETH_TX.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/fifo_ETH_TX/fifo_ETH_TX_clocks.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/fifo_ETH_TX/fifo_ETH_TX_ooc.xdc]

read_ip -quiet /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/tri_mode_ethernet_mac_0/tri_mode_ethernet_mac_0.xci
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0_clocks.xdc]

read_ip -quiet /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_eth_rx/ila_eth_rx.xci
set_property used_in_synthesis false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_eth_rx/ila_v6_2/constraints/ila_impl.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_eth_rx/ila_v6_2/constraints/ila_impl.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_eth_rx/ila_v6_2/constraints/ila.xdc]
set_property used_in_implementation false [get_files -all /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/ip/ila_eth_rx/ila_eth_rx_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/constrs_1/new/top.xdc
set_property used_in_implementation false [get_files /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/constrs_1/new/top.xdc]

read_xdc /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/constrain/constrain_test_env_position.xdc
set_property used_in_implementation false [get_files /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/constrain/constrain_test_env_position.xdc]

read_xdc /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/constrain/constrain_test_env_timing.xdc
set_property used_in_implementation false [get_files /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/constrain/constrain_test_env_timing.xdc]

read_xdc /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/constrain/tri_mode_ethernet_mac_0_example_design.xdc
set_property used_in_implementation false [get_files /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/constrain/tri_mode_ethernet_mac_0_example_design.xdc]

read_xdc /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/constrain/tri_mode_ethernet_mac_0_user_phytiming.xdc
set_property used_in_implementation false [get_files /home/xx/work/KC705_DAQ/KC705_DAQ.srcs/sources_1/new/ETH_firmware/source/ethernet_mac_interface/constrain/tri_mode_ethernet_mac_0_user_phytiming.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top top_wrap -part xc7k325tffg900-2


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top_wrap.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_wrap_utilization_synth.rpt -pb top_wrap_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
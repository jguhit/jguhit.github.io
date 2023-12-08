#set_false_path -through [get_nets *VIO*]
set_false_path -through [get_nets */*VIO*]




set_false_path -to [get_pins -hier -filter {NAME =~ *_sync*/D}]
set_false_path -to [get_pins -hier -filter {NAME =~ *_sync*/D}]
set_false_path -to [get_pins -hier -filter {NAME =~ */*_sync*/D}]
set_false_path -to [get_pins -hier -filter {NAME =~ */*_sync*/D}]

#set_false_path -through [get_nets -hierarchical -filter {NAME =~ *CC*}]

set_false_path -from [get_pins -hier -filter {NAME =~ *_config_reg*/C}]
set_false_path -from [get_pins -hier -filter {NAME =~ */*_config_reg*/C}]


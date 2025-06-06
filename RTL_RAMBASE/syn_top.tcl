
set TOP "top"
set CLK "clk"
set library_path "~/sotb65nm/160108_REL_VDEC/LIB/LE8U_V02.02.00/liberty/LSTP"
lappend search_path  $library_path
lappend search_path "./include"
lappend search_path "."
lappend search_path "./"
lappend link_path  $library_path
lappend link_path "./include"
lappend link_path "."
lappend link_path "./"

set ULLIBRARY LE8UL_LSTP_Ptt_V0p75_T25
set target_library LE8UL_LSTP_Ptt_V0p75_T25.db
set synthetic_library "dw_foundation.sldb"
set link_library [list  LE8UL_LSTP_Ptt_V0p75_T25.db $synthetic_library]
set symbol_library [list "EXD.sdb"]

set designer {{Designers Name}}
set company {{TEST}}
set verilogout_no_tri "true"
set verilogout_single_bit "false"

set rtl_dir "."
set rtl_src [list ${{rtl_dir}}/top.v ${{rtl_dir}}/CommandBuffer.v ${{rtl_dir}}/CalculationCore.v ${{rtl_dir}}/AddSubMod.v ${{rtl_dir}}/MontMul.v ${{rtl_dir}}/inversion/MontgomeryInverter.v ${{rtl_dir}}/inversion/Div2.v ${{rtl_dir}}/inversion/Div4.v ${{rtl_dir}}/inversion/Div4PathUnit.v]

# Do not use TIE CELLs at SYN stage. Connect logic 0 and 1 to TIE NETS at P&R stage.
set_dont_use [list ${{ULLIBRARY}}/LE8ULTIEHXD ${{ULLIBRARY}}/LE8ULTIELXD]

# The number of CPUs
set_host_options -max_cores 16

read_file -rtl -format verilog ${{rtl_src}}
current_design ${{TOP}}
create_clock -period  {clk} ${{CLK}}
set_max_area 0.0 
set_dont_touch_network ${{CLK}}
set_load 0.2 [all_outputs]
set_input_delay -max 2 -clock ${{CLK}} [all_inputs]
set_output_delay -max 2 -clock ${{CLK}} [all_outputs]
#compile
compile_ultra
#compile -map effort high
define_name_rules verilog -case_insensitive -type net
change_names -rules verilog -hierarchy
current_design ${{TOP}}
redirect {res_dir}/port.txt {{ report_port }}
redirect {res_dir}/timing.txt {{report_timing -path full_clock -nworst 2 -nets -transition_time -capacitance -attributes -sort_by slack}}
redirect {res_dir}/area.txt {{report_area}}
redirect {res_dir}/power.txt {{report_power}}
current_design ${{TOP}}
write -format verilog -hierarchy -output "{res_dir}/${{TOP}}out.v" [list ${{TOP}}]
quit

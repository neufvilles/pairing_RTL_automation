
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

read_file -autoread -top ${TOP} -format verilog dc_result_add4/5_0/topout.v
set_design_top ${TOP}
redirect ./area_hierarchy.txt {report_area -hierarchy}
quit

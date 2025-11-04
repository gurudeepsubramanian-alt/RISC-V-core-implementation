#########################################
# TCL Script for Synthesis (processor.tcl)
#########################################

# -------------------------------------------------------------
# Library setup
# -------------------------------------------------------------
set_db init_lib_search_path {/home/install/FOUNDRY/digital/90nm/dig/lib}
set_db library {slow.lib}

# -------------------------------------------------------------
# Read HDL Files
# -------------------------------------------------------------
read_hdl alu.v
read_hdl insmemory.v
read_hdl processor2stage.v

# Elaborate design
elaborate

# -------------------------------------------------------------
# Read SDC Constraints
# -------------------------------------------------------------
read_sdc constraints.sdc

# -------------------------------------------------------------
# Synthesis Steps
# -------------------------------------------------------------
set_db syn_generic_effort medium
syn_generic

set_db syn_map_effort medium
syn_map

set_db syn_opt_effort medium
syn_opt

# -------------------------------------------------------------
# Write Netlist and Final SDC
# -------------------------------------------------------------
write_hdl > processor_netlist.v
write_sdc > processor_out.sdc

# -------------------------------------------------------------
# Reports
# -------------------------------------------------------------
report_timing  >
report_area    >
report_power   >

# Optional: open GUI (if supported)
add gui_show

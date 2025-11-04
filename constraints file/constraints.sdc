###############################################################
#  constraint_processor.sdc  —  Single Corner / No OCV
###############################################################

# -------------------------------------------------------------
# Clock definition (single BCWC clock)
# -------------------------------------------------------------
create_clock -name clk -period 10 [get_ports clk]

# -------------------------------------------------------------
# Input delays
# -------------------------------------------------------------
set_input_delay 2 -clock clk [get_ports {clk reset}]
set_input_delay 2 -clock clk [get_ports {grp[*] opcode[*] operand1[*] operand2[*] operand3[*] flags[*]}]

# -------------------------------------------------------------
# Output delays
# -------------------------------------------------------------
set_output_delay 2 -clock clk [get_ports {result_out[*] pc_out[*]}]

# -------------------------------------------------------------
# Drive & Load
# -------------------------------------------------------------
set_drive 1 [all_inputs]
set_load 0.1 [all_outputs]

# -------------------------------------------------------------
# Operating condition (single corner — NO OCV)
# -------------------------------------------------------------
# Simple corner selection WITHOUT on-chip variation
set_operating_conditions slow -library slow.lib

# -------------------------------------------------------------
# False paths
# -------------------------------------------------------------
set_false_path -from [get_ports reset] -to [all_outputs]

###############################################################
# End of SDC
###############################################################

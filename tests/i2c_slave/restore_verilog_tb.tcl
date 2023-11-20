
# XM-Sim Command File
# TOOL:	xmsim(64)	21.03-s001
#
#
# You can restore this configuration with:
#
#      xrun -access +rwc -sv i2c_slave.v i2c_slave_tb.v -s -input /asic/projects/E/ETROC2_RO/gdg/ETROC2/cocotbext-i2c/tests/i2c_slave/restore_verilog_tb.tcl
#

set tcl_prompt1 {puts -nonewline "xcelium> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1
set assert_reporting_mode 0
set vcd_compact_mode 0
alias . run
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves tb_i2c.clk tb_i2c.RST tb_i2c.SCL tb_i2c.SDA tb_i2c.u_i2c_master.RST tb_i2c.u_i2c_master.SCL tb_i2c.u_i2c_master.SDA tb_i2c.u_i2c_slave.LEDG tb_i2c.u_i2c_slave.LEDR tb_i2c.u_i2c_slave.RST tb_i2c.u_i2c_slave.SCL tb_i2c.u_i2c_slave.SDA tb_i2c.u_i2c_slave.SW_1 tb_i2c.u_i2c_slave.clk
probe -create -database waves tb_i2c.clk tb_i2c.RST tb_i2c.SCL tb_i2c.SDA tb_i2c.u_i2c_master.RST tb_i2c.u_i2c_master.SCL tb_i2c.u_i2c_master.SDA tb_i2c.u_i2c_slave.LEDG tb_i2c.u_i2c_slave.LEDR tb_i2c.u_i2c_slave.RST tb_i2c.u_i2c_slave.SCL tb_i2c.u_i2c_slave.SDA tb_i2c.u_i2c_slave.SW_1 tb_i2c.u_i2c_slave.clk
probe -create -database waves tb_i2c.u_i2c_slave.ack_bit tb_i2c.u_i2c_slave.address_detect tb_i2c.u_i2c_slave.bit_counter tb_i2c.u_i2c_slave.start_detect tb_i2c.u_i2c_slave.start_resetter tb_i2c.u_i2c_slave.start_rst tb_i2c.u_i2c_slave.stop_detect tb_i2c.u_i2c_slave.stop_resetter tb_i2c.u_i2c_slave.stop_rst

simvision -input restore_verilog_tb.tcl.svcf

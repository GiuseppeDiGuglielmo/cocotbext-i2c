
# XM-Sim Command File
# TOOL:	xmsim(64)	21.03-s001
#
#
# You can restore this configuration with:
#
#      xrun -timescale 1ns/1ns -licqueue -64 -xmlibdirpath sim_build -plinowarn -top i2c_slave_harness -loadvpi /fasic_home/gdg/venvs/cocotb-env/lib64/python3.8/site-packages/cocotb/libs/libcocotbvpi_ius.so:vlog_startup_routines_bootstrap -access +rwc -createdebugdb i2c_slave.v -input /asic/projects/E/ETROC2_RO/gdg/ETROC2/cocotbext-i2c/tests/i2c_slave/restore_cocotb_tb.tcl
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
probe -create -database waves i2c_slave_harness.RST i2c_slave_harness.SDA i2c_slave_harness.SCL i2c_slave_harness.u_i2c_slave.RST i2c_slave_harness.u_i2c_slave.SDA i2c_slave_harness.u_i2c_slave.SCL i2c_slave_harness.SW_1 i2c_slave_harness.LEDR i2c_slave_harness.LEDG i2c_slave_harness.clk i2c_slave_harness.u_i2c_slave.SW_1 i2c_slave_harness.u_i2c_slave.LEDR i2c_slave_harness.u_i2c_slave.LEDG i2c_slave_harness.u_i2c_slave.clk i2c_slave_harness.u_i2c_slave.write_strobe i2c_slave_harness.u_i2c_slave.stop_rst i2c_slave_harness.u_i2c_slave.stop_resetter i2c_slave_harness.u_i2c_slave.stop_detect i2c_slave_harness.u_i2c_slave.state i2c_slave_harness.u_i2c_slave.start_rst i2c_slave_harness.u_i2c_slave.start_resetter i2c_slave_harness.u_i2c_slave.start_detect i2c_slave_harness.u_i2c_slave.reg_03 i2c_slave_harness.u_i2c_slave.reg_02 i2c_slave_harness.u_i2c_slave.reg_01 i2c_slave_harness.u_i2c_slave.reg_00 i2c_slave_harness.u_i2c_slave.read_write_bit i2c_slave_harness.u_i2c_slave.output_shift i2c_slave_harness.u_i2c_slave.output_control i2c_slave_harness.u_i2c_slave.master_ack i2c_slave_harness.u_i2c_slave.lsb_bit i2c_slave_harness.u_i2c_slave.input_shift i2c_slave_harness.u_i2c_slave.index_pointer i2c_slave_harness.u_i2c_slave.bit_counter i2c_slave_harness.u_i2c_slave.address_detect i2c_slave_harness.u_i2c_slave.ack_bit

simvision -input restore_cocotb_tb.tcl.svcf

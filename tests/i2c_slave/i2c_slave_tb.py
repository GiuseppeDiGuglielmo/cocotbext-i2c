#!/usr/bin/env python

import os
import logging

import cocotb
from cocotb.triggers import Timer
from cocotb.regression import TestFactory

import cocotb_test.simulator

from cocotbext.i2c import I2cMaster

class I2C_TB:
    def __init__(self, dut):
        self.dut = dut

        self.log = logging.getLogger("cocotb.tb")
        self.log.setLevel(logging.DEBUG)

        self.i2c_master = I2cMaster(sda=dut.SDA, scl=dut.SCL, speed=8000000)
                 
#        self.i2c_memory = I2cMemory(sda=dut.sda_2_o, sda_o=dut.sda_2_i,
#            scl=dut.scl_2_o, scl_o=dut.scl_2_i, addr=0x50, size=256)


async def run_test(dut, payload_lengths=None, payload_data=None):

    tb = I2C_TB(dut)
    tb.log.setLevel(logging.INFO)

    dut.clk.value = 0
    dut.SW_1.value = 0
    
    dut.RST.value = 1

    await Timer(5, 'us')

    dut.RST.value = 0

    await Timer(5, 'us')
  
    dev_addr = dut.device_address.value
    reg_data = b'\xff\xff'

    await tb.i2c_master.write(dev_addr, reg_data)
    await tb.i2c_master.send_stop()

    await Timer(10, 'us')
#
#    await tb.i2c_master.write(0x50, b'\x00')
#    data = await tb.i2c_master.read(0x50, 4)
#    await tb.i2c_master.send_stop()
#
#    tb.log.info("Read data: %s", data)
#
#    assert test_data == data


if cocotb.SIM_NAME:

    factory = TestFactory(run_test)
    factory.generate_tests()


# cocotb-test

tests_dir = os.path.dirname(__file__)


def test_i2c(request):
    dut = "test_i2c"
    module = os.path.splitext(os.path.basename(__file__))[0]
    toplevel = dut

    verilog_sources = [
        os.path.join(tests_dir, f"{dut}.v"),
    ]

    parameters = {}

    extra_env = {f'PARAM_{k}': str(v) for k, v in parameters.items()}

    sim_build = os.path.join(tests_dir, "sim_build",
        request.node.name.replace('[', '-').replace(']', ''))

    cocotb_test.simulator.run(
        python_search=[tests_dir],
        verilog_sources=verilog_sources,
        toplevel=toplevel,
        module=module,
        parameters=parameters,
        sim_build=sim_build,
        extra_env=extra_env,
    )

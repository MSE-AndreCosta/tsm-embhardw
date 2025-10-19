#
# basic script to build design under test and testbench
# start modelsim hdl simulator and run do start.do to run script
#

#############################################################
# define alias
#############################################################
alias tb_env {
  echo "\nSET ENVIRONMENT\n"
  quietly set VHDL_SOURCE_DIR "../../src"
  quietly set VHDL_TB_DIR "../vhdl"
  vlib work
  echo "SET ENVIRONMENT DONE!\n"
}


alias design {
  echo "\nCOMPILE DESIGN\n"
  eval vcom -work work $VHDL_SOURCE_DIR/lcd_dma_controller.vhd
  echo "COMPILE DESIGN DONE!\n"
}


alias testbench {
  echo "\nCOMPILE TESTBENCH\n"
  eval vcom -work work $VHDL_TB_DIR/avalon_pkg/avalon_pkg.vhd
  eval vcom -work work $VHDL_TB_DIR/lcd_controller_tb.vhd
  echo "\nCOMPILE TESTBENCH DONE!\n"
}


alias run_simulation {
  echo "\nRUN SIMULATION\n"
  vsim -t 1ns -l simulation_logfile.txt work.lcd_controller_tb
  # do wave.do
  add wave -r *
  run 2us
  echo "\nRUN TESTBENCH DONE!\n"

}


#############################################################
# run alias
#############################################################
tb_env
design
testbench
run_simulation


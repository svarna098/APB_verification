vlog -sv +acc +cover +fcover -l simulation.log apb_dut.sv apb_interface.sv apb_package.sv apb_top.sv 
vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"

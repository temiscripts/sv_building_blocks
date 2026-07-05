# CAM Makefile

VLOG_FLAGS = -sv
TOP        = CAM_tb
SRC        = cam.sv cam_tb.sv

sim:
	vlib work
	vlog $(VLOG_FLAGS) $(SRC)
	vsim -c -do "run -all; quit" $(TOP)

wave:
	vlib work
	vlog $(VLOG_FLAGS) $(SRC)
	vsim -onfinish stop $(TOP) -do "add wave *; run -all"

clean:
	rm -rf work transcript* *.wlf *.log

golden:
	python3 cam_golden.py	

.PHONY: sim wave clean
#------------------------------------------------------
# Command line options :
#
# t = Test Name
# i = Number of Iterations
# d = Delay between Transactions
# p = Stall Probability
#------------------------------------------------------

t = DIRECTED_TEST
i = 1
d = 0
p = 0

allc: clean init compile runc cover

all: clean init compile run cover

clean:
	rm -rf transcript vsim.wlf work compilelog.txt runlog.txt test.ucdb coverage_log.txt wave.do

init:
	vlib work;

compile: clean init
	vlog \
	-l compilelog.txt \
	-work work \
	+incdir+/cadtools/questa/questa_sim/verilog_src/uvm-1.1b/src \
	+incdir+../lib \
	+incdir+../rtl \
	+incdir+../sv \
	../rtl/*.sv \
	../sv/tb_top.sv ; 

runc: clean init compile
	vsim -c -l runlog.txt -do "coverage save -onexit test.ucdb;run -all;exit" \
	-voptargs="+acc" tb_top +TESTNAME=$t +NO_OF_TRANS=$i +OSTALL_PROB=$p +DELAY=$d;

run: clean init compile 
	vsim -l runlog.txt \
	-voptargs="+acc" tb_top +TESTNAME=$t +NO_OF_TRANS=$i +OSTALL_PROB=$p +DELAY=$d;

cover: 
	vcover report -details test.ucdb >coverage_log.txt

# SystemVerilog

32- bit calulator RTL design in Verilog and Verification in SV
======================================================
================== INSTRUCTIONS ======================
======================================================

This Example has 3 directories :
 /rtl  : contains the Calculator RTL design
 /sim  : contains Makefile and Regression script
 /sv   : contains the Testbench files

To run the Example, go to the /sim directory and 
enter the follwoing Run Command from the terminal : 
		
  make runc (Batch mode)
  make run  (GUI mode)

To run a specific test, enter the following Run Command 
from the terminal :
  
  make runc t=<test_name> (Batch mode)
  make run t=<test_name>  (GUI mode)

Other command line options available are listed in 
the Makefile.

To run Regression, go to the /sim directory and 
enter the following Run Command from the terminal :

  ./RunSim -f runlist

======================================================
======================================================

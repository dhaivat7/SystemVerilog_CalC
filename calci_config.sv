class calci_config;
    
    calci_vif dr_vif;
    calci_vif ip_mon_vif;
    calci_vif op_mon_vif;
    mailbox #(calci_trans) gen2dr_mbx;
    mailbox #(calci_trans) imon2sb_mbx;
    mailbox #(calci_trans) omon2sb_mbx;
    
    static int trans_count = 10;
    static int rand_stall = 0;
    static int driver_delay = 0;
  	
		string test_name;
    event RST_DONE;
//------------------------------------------------    
    function new();
    endfunction : new
//------------------------------------------------    
  function void get_args_from_command_line();
    int no_of_trans;
    int ostall_prob;
    int delay;
    void'($value$plusargs("TESTNAME=%0s",test_name));
    void'($value$plusargs("NO_OF_TRANS=%0d",no_of_trans));
    void'($value$plusargs("OSTALL_PROB=%0d",ostall_prob));
    void'($value$plusargs("DELAY=%0d",delay));
    $display("-------------------------------------");
    $display("Test Name :: %0s\nIterations :: %0d\nOstall probability :: %0d\nDelay :: %0d ",test_name,no_of_trans,ostall_prob,delay);
    $display("-------------------------------------");
		trans_count = no_of_trans;
    driver_delay = delay;
		rand_stall = ostall_prob;
  endfunction : get_args_from_command_line
//------------------------------------------------    
endclass : calci_config

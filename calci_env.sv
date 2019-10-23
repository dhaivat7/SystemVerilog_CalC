class calci_env;
	calci_gen gen;
	calci_driver driver;
	calci_monitor ip_mon;
	calci_monitor op_mon;
	calci_sb sb;
	calci_config cfg;
//------------------------------------------------  
  function new(calci_config cfg);
		this.cfg = cfg;
  endfunction
//------------------------------------------------  
  function void build();
  	gen = new(cfg);
  	driver = new(cfg);
  	ip_mon = new(cfg);
  	op_mon = new(cfg);
  	sb = new(cfg);
  endfunction : build
//------------------------------------------------  
  function void connect();
    gen.connect();	
    ip_mon.connect();
    driver.connect();
    op_mon.connect();
    sb.connect();
  endfunction : connect
//------------------------------------------------
  function void config_monitor();
    ip_mon.vif = cfg.ip_mon_vif;
    ip_mon.mon_type = "INPUT MONITOR";
    op_mon.vif = cfg.op_mon_vif;
    op_mon.mon_type = "OUTPUT MONITOR";
  endfunction : config_monitor
//------------------------------------------------
  task start_env_components();
    $display("Starting all component start tasks in the Environment...");
    fork
      driver.run_driver();    
      ip_mon.run_monitor();    
      op_mon.run_monitor();       
      sb.run_scoreboard();    
    join_none
  endtask : start_env_components
//------------------------------------------------
endclass : calci_env

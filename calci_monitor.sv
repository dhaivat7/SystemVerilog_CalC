class calci_monitor;
	calci_vif vif;
	mailbox #(calci_trans) mon2sb_mbx;
	calci_sig_cov h_sig_cov;	

	calci_trans pkt;
	calci_config cfg;
	int count;
	
	string mon_type;
  rand bit stall;
  constraint STALL {stall dist {`HIGH := cfg.rand_stall, `LOW := (100-cfg.rand_stall)};}
//------------------------------------------------  
	function new(calci_config cfg);
		this.cfg = cfg;
		this.mon2sb_mbx = new();
		count = 1;
	endfunction : new
//------------------------------------------------  
  function void connect();
  	if(mon_type == "INPUT MONITOR") 
			cfg.imon2sb_mbx = mon2sb_mbx;
  	else if(mon_type == "OUTPUT MONITOR") 
			cfg.omon2sb_mbx = mon2sb_mbx;
  endfunction : connect
//------------------------------------------------  
  virtual task run_monitor();
		wait_for_reset_done();
		randomize_and_drive_stall(); 
  	fork
			collect_transfer();				
  	join_none
  endtask : run_monitor
//------------------------------------------------  
  task wait_for_reset_done();
		wait(cfg.RST_DONE.triggered);
  endtask : wait_for_reset_done
//------------------------------------------------  
	virtual task randomize_and_drive_stall();
		fork
			if(mon_type == "OUTPUT MONITOR") drive_stall();
  	join_none
	endtask : randomize_and_drive_stall
//------------------------------------------------  
  virtual task collect_transfer();
		build_coverage_model();
    forever begin
			wait_for_a_valid_transaction_cycle();
			create_and_populate_pkt();
      put_pkt_into_mailbox();
			perform_coverage();
      @(vif.mr_cb);
			count++;
    end 
  endtask : collect_transfer
//------------------------------------------------  
	virtual function void build_coverage_model();
		h_sig_cov = new(mon_type);
		h_sig_cov.h_vif = vif;
	endfunction : build_coverage_model
//------------------------------------------------  
  virtual task drive_stall();
	  if(cfg.rand_stall == 0)
			vif.mr_cb.Stall <= 1'b0;
    else begin
    	forever begin
	    	randomize_stall_dist();    
	   		vif.mr_cb.Stall <= stall;
        @(vif.mr_cb);
      end
    end 
  endtask : drive_stall
//------------------------------------------------  
  function void randomize_stall_dist();
  	void'(randomize(stall));
  endfunction : randomize_stall_dist
//------------------------------------------------  
	virtual task wait_for_a_valid_transaction_cycle();
  	wait(vif.mr_cb.Valid && ~vif.mr_cb.Stall);
	endtask: wait_for_a_valid_transaction_cycle
//------------------------------------------------  
	virtual function void create_and_populate_pkt();
      pkt = new();
		  pkt.A = vif.mr_cb.A;
      pkt.B = vif.mr_cb.B;
      pkt.ctrl = vif.mr_cb.ctrl;
      pkt.C = vif.mr_cb.C;
			//$display("%s %d transaction collected %t",mon_type,count,$time);
			//pkt.print();
	endfunction: create_and_populate_pkt
//------------------------------------------------  
  task put_pkt_into_mailbox();
		mon2sb_mbx.put(pkt);
  endtask : put_pkt_into_mailbox
//------------------------------------------------  
  function void perform_coverage();
		-> h_sig_cov.calci_sig_cov_event;
  endfunction : perform_coverage
//------------------------------------------------  
endclass : calci_monitor

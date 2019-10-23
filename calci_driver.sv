class calci_driver;
  calci_trans pkt;
  calci_vif vif;
  mailbox #(calci_trans) gen2dr_mbx;
  calci_config cfg;
	int count;
//------------------------------------------------  
  function new(calci_config cfg);
		this.cfg = cfg;
		count = 1;
  endfunction
//------------------------------------------------  
  function void connect();
    vif = cfg.dr_vif;
    gen2dr_mbx = cfg.gen2dr_mbx;
  endfunction : connect
//------------------------------------------------  
  virtual task run_driver();  
    wait_for_reset_done();
    fork
      forever begin
				get_pkt_from_mailbox();
        drive_transfer(pkt);
      end
    join_none
  endtask : run_driver
//------------------------------------------------  
  task wait_for_reset_done();
		wait(cfg.RST_DONE.triggered);
    @(vif.dr_cb);
  endtask : wait_for_reset_done
//------------------------------------------------  
  task get_pkt_from_mailbox();
    gen2dr_mbx.get(pkt); 
  endtask : get_pkt_from_mailbox
//------------------------------------------------  
	virtual task introduce_random_delay_between_transactions();
		int trans_delay ;
		trans_delay = $urandom_range(cfg.driver_delay,0);
    repeat(trans_delay) @(vif.dr_cb);
	endtask: introduce_random_delay_between_transactions
//------------------------------------------------  
	virtual function void set_dut_inputs();
		//pkt.print();
    vif.dr_cb.Valid <= 1'b1;
    vif.dr_cb.A <= pkt.A;
    vif.dr_cb.B <= pkt.B;
    vif.dr_cb.ctrl <= pkt.ctrl;
	endfunction: set_dut_inputs
//------------------------------------------------  
	virtual task wait_for_dut_to_take_input();
		//$display("Driving %d transaction before stall %t",count,$time);
    @(vif.dr_cb);
    wait(vif.dr_cb.Stall===1'b0);
	endtask: wait_for_dut_to_take_input
//------------------------------------------------  
	virtual function void reset_dut_inputs();
    vif.dr_cb.Valid <= 1'b0;
	endfunction: reset_dut_inputs
//------------------------------------------------  
  virtual task drive_transfer(calci_trans pkt);
		introduce_random_delay_between_transactions();
		set_dut_inputs();
		wait_for_dut_to_take_input();
		reset_dut_inputs();
		count++;
  endtask : drive_transfer
//------------------------------------------------  
endclass : calci_driver

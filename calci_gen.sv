class calci_gen;
	calci_trans pkt;
	mailbox #(calci_trans) gen2dr_mbx;
	calci_config cfg;
//------------------------------------------------  
  function new(calci_config cfg);
		this.cfg = cfg;
		this.gen2dr_mbx = new();
  endfunction
//------------------------------------------------  
	function void connect();
		cfg.gen2dr_mbx = gen2dr_mbx;
	endfunction : connect
//------------------------------------------------  
	virtual function void generate_directed_pkt();
    pkt = new();
    pkt.A = 10;
    pkt.B = 10;
    pkt.ctrl = `ADD;
	endfunction : generate_directed_pkt
//------------------------------------------------  
	virtual function void generate_pkt_with_control(bit[1:0] control = `ADD);
    pkt = new();
		void'(pkt.randomize());
    pkt.ctrl = control;
	endfunction : generate_pkt_with_control
//------------------------------------------------  
	virtual function void generate_random_pkt();
		pkt = new();
		void'(pkt.randomize());
	endfunction : generate_random_pkt
//------------------------------------------------  
	virtual task deliver_pkt_to_driver();
		gen2dr_mbx.put(pkt);
	endtask : deliver_pkt_to_driver
//------------------------------------------------  
endclass  : calci_gen

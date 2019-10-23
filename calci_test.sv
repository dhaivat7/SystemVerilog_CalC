// Calci Base Test
//------------------------------------------------    
import calci_pkg::*;
class calci_base_test;
  
	calci_config cfg;
  calci_env env;
//------------------------------------------------    
  function new(calci_config cfg);
		this.cfg = cfg;
  endfunction
//------------------------------------------------    
  function void build_env_and_config();
    env = new(cfg); 
    env.build();
    env.config_monitor();
    env.connect();
  endfunction : build_env_and_config
//------------------------------------------------
  virtual task start_test();
     env.start_env_components();
     run_test();
  endtask : start_test
//------------------------------------------------
  virtual task run_test();
		set_transaction_count();
    repeat(cfg.trans_count) begin
    	generate_pkt();
			deliver_pkt_to_driver();
		end
  endtask : run_test
//------------------------------------------------
	virtual function void set_transaction_count();
	endfunction: set_transaction_count
//------------------------------------------------
	virtual function void generate_pkt();
		env.gen.generate_directed_pkt(); 
	endfunction: generate_pkt
//------------------------------------------------
  virtual function void generate_directed_pkt();
		env.gen.generate_directed_pkt(); 
	endfunction : generate_directed_pkt
//------------------------------------------------
  virtual function void generate_pkt_with_control(bit[1:0] control = `ADD);
		env.gen.generate_pkt_with_control(control); 
	endfunction : generate_pkt_with_control
//------------------------------------------------
  virtual function void generate_random_pkt();
		env.gen.generate_random_pkt(); 
	endfunction : generate_random_pkt
//------------------------------------------------
	virtual task deliver_pkt_to_driver();
    env.gen.deliver_pkt_to_driver();
	endtask : deliver_pkt_to_driver
//------------------------------------------------
endclass
//------------------------------------------------
// Calci Directed Test
//------------------------------------------------
class calci_directed_test extends calci_base_test;
//------------------------------------------------    
  function new(calci_config cfg);
		super.new(cfg);
  endfunction
//------------------------------------------------
	virtual function void set_transaction_count();
		cfg.trans_count = 1;
	endfunction: set_transaction_count
//------------------------------------------------
endclass : calci_directed_test
//------------------------------------------------
// Calci Add Test
//------------------------------------------------
class calci_directed_add_test extends calci_base_test;
//------------------------------------------------    
  function new(calci_config cfg);
		super.new(cfg);
  endfunction
//------------------------------------------------    
	virtual function void generate_pkt();
    generate_pkt_with_control(`ADD);
	endfunction: generate_pkt
//------------------------------------------------
endclass : calci_directed_add_test
//------------------------------------------------
// Calci Sub Test
//------------------------------------------------
class calci_directed_sub_test extends calci_base_test;
//------------------------------------------------    
  function new(calci_config cfg);
		super.new(cfg);
  endfunction
//------------------------------------------------    
	virtual function void generate_pkt();
    generate_pkt_with_control(`SUB);
	endfunction: generate_pkt
//------------------------------------------------
endclass : calci_directed_sub_test
//------------------------------------------------    
// Calci Mul Test
//------------------------------------------------    
class calci_directed_mul_test extends calci_base_test;
//------------------------------------------------    
  function new(calci_config cfg);
		super.new(cfg);
  endfunction
//------------------------------------------------    
	virtual function void generate_pkt();
    generate_pkt_with_control(`MUL);
	endfunction: generate_pkt
//------------------------------------------------
endclass : calci_directed_mul_test
//------------------------------------------------
// Calci Div Test
//------------------------------------------------
class calci_directed_div_test extends calci_base_test;
//------------------------------------------------    
  function new(calci_config cfg);
		super.new(cfg);
  endfunction
//------------------------------------------------    
	virtual function void generate_pkt();
    generate_pkt_with_control(`DIV);
	endfunction: generate_pkt
//------------------------------------------------
endclass : calci_directed_div_test
//------------------------------------------------
// Calci Random Test
//------------------------------------------------
class calci_random_test extends calci_base_test;
//------------------------------------------------    
  function new(calci_config cfg);
		super.new(cfg);
  endfunction
//------------------------------------------------    
	virtual function void generate_pkt();
			generate_random_pkt();
	endfunction: generate_pkt
//------------------------------------------------
endclass : calci_random_test
//------------------------------------------------
// Calci Random Test With Delay
//------------------------------------------------
class calci_random_test_with_delay extends calci_base_test;
//------------------------------------------------    
  function new(calci_config cfg);
		super.new(cfg);
  endfunction
//------------------------------------------------    
	virtual function void generate_pkt();
		set_delay_between_transactions();
		generate_random_pkt();
	endfunction: generate_pkt
//------------------------------------------------
	virtual function void set_delay_between_transactions();
		if(cfg.driver_delay==0) cfg.driver_delay = `DEFAULT_DELAY_BTWN_TXNS;
	endfunction : set_delay_between_transactions
//------------------------------------------------
endclass : calci_random_test_with_delay
//------------------------------------------------
// Calci Random Stall Test
//------------------------------------------------
class calci_random_stall_test extends calci_base_test;
//------------------------------------------------    
  function new(calci_config cfg);
		super.new(cfg);
  endfunction
//------------------------------------------------    
	virtual function void generate_pkt();
			set_stall_probability();
			generate_random_pkt();
	endfunction: generate_pkt
//------------------------------------------------
	virtual function void set_stall_probability();
		if(cfg.rand_stall==0) cfg.rand_stall = `DEFAULT_STALL_PROBABILITY;
	endfunction : set_stall_probability
//------------------------------------------------
endclass : calci_random_stall_test
//------------------------------------------------

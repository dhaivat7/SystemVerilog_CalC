//------------------------------------------------ 
`include "calci_if.sv"
`include "calci_pkg.sv"
module tb_top;
	import calci_pkg::*;

	parameter CLOCK_PERIOD = 10;
	parameter RESET_PERIOD = 2;

 	reg clock;
  logic rstn;
  calci_if DUV_IN(clock);
  calci_if DUV_OUT(clock);
	
  calci_config cfg;
	calci_base_test test;
//------------------------------------------------ 
  calc DUT(
        .inpA       (DUV_IN.A),
        .inpB       (DUV_IN.B),
        .inpOpType  (DUV_IN.ctrl),
        .outC       (DUV_OUT.C),
        .iValid     (DUV_IN.Valid),
        .iStall     (DUV_IN.Stall),
        .oStall     (DUV_OUT.Stall),
        .oValid     (DUV_OUT.Valid),
        .clk        (clock),
        .rstn       (rstn));
//------------------------------------------------ 
  initial begin	
		build_config_and_do_assignments();
		build_test();
		generate_clock();
    initialize_dut_input_signals();
		give_reset_to_dut();
    run_test();
		generate_final_report();
		finish_test();
  end
//------------------------------------------------ 
  task generate_clock();
		fork
    	forever begin
      	clock = `LOW; 
      	#(CLOCK_PERIOD/2);
      	clock = `HIGH; 
      	#(CLOCK_PERIOD/2);
    	end
		join_none
  endtask : generate_clock
//-----------------------------------------------
	function void build_config_and_do_assignments();
    cfg = new();
    cfg.dr_vif = DUV_IN;
    cfg.ip_mon_vif = DUV_IN;
    cfg.op_mon_vif = DUV_OUT;
		cfg.get_args_from_command_line;
	endfunction: build_config_and_do_assignments
//------------------------------------------------ 
  function void initialize_dut_input_signals();
    DUV_IN.Valid = `LOW;
    DUV_OUT.Stall = `LOW;
  endfunction : initialize_dut_input_signals
//------------------------------------------------
  task give_reset_to_dut();
		rstn = `HIGH;
  	repeat(RESET_PERIOD) @(posedge clock); 
		do_reset();
  	-> cfg.RST_DONE;
	endtask : give_reset_to_dut
//------------------------------------------------   
	task do_reset();
  	rstn = `LOW;
  	repeat(RESET_PERIOD) @(posedge clock); 
  	rstn = `HIGH;
	endtask : do_reset
//------------------------------------------------ 
  function void build_test();
		build_test_given_in_command_line();
    test.build_env_and_config();
	endfunction : build_test
//------------------------------------------------
  task run_test();
    test.start_test();
		wait_for_test_to_complete_or_timeout();
  endtask:run_test
//------------------------------------------------
	function void build_test_given_in_command_line();
		case(cfg.test_name)
			"DIRECTED_TEST"     		: build_directed_test();    
      "DIRECTED_ADD_TEST"			: build_directed_add_test();    
			"DIRECTED_SUB_TEST"		  : build_directed_sub_test();    
			"DIRECTED_MUL_TEST"		  : build_directed_mul_test();    
			"DIRECTED_DIV_TEST" 		: build_directed_div_test();    
			"RANDOM_TEST"      		  : build_random_test();
			"RANDOM_TEST_WITH_DELAY": build_random_test_with_delay();
			"RANDOM_STALL_TEST" 		: build_random_stall_test();
    	default: $display("Invalid Test name provided");
		endcase
	endfunction : build_test_given_in_command_line
//------------------------------------------------ 
	function void build_directed_test();
  	calci_directed_test dir_test;
		dir_test = new(cfg);
		test = dir_test;
	endfunction : build_directed_test
//------------------------------------------------ 
	function void build_directed_add_test();
    calci_directed_add_test dir_add_test;
		dir_add_test = new(cfg);
		test = dir_add_test;
	endfunction : build_directed_add_test
//------------------------------------------------ 
	function void build_directed_sub_test();
    calci_directed_sub_test dir_sub_test;
		dir_sub_test = new(cfg);
		test = dir_sub_test;
	endfunction : build_directed_sub_test
//------------------------------------------------ 
	function void build_directed_mul_test();
    calci_directed_mul_test dir_mul_test;
		dir_mul_test = new(cfg);
		test = dir_mul_test;
	endfunction : build_directed_mul_test
//------------------------------------------------ 
	function void build_directed_div_test();
    calci_directed_div_test dir_div_test;
		dir_div_test = new(cfg);
		test = dir_div_test;
	endfunction : build_directed_div_test
//------------------------------------------------ 
	function void build_random_test();
    calci_random_test rand_test;
		rand_test = new(cfg);
		test = rand_test;
	endfunction : build_random_test
//------------------------------------------------ 
	function void build_random_test_with_delay();
    calci_random_test_with_delay rand_test_with_delay;
		rand_test_with_delay = new(cfg);
		test = rand_test_with_delay;
	endfunction : build_random_test_with_delay
//------------------------------------------------ 
	function void build_random_stall_test();
    calci_random_stall_test rand_stall_test;
		rand_stall_test = new(cfg);
		test = rand_stall_test;
	endfunction : build_random_stall_test
//------------------------------------------------ 
	task wait_for_test_to_complete_or_timeout();
		fork
    wait(test.env.sb.CHECK_DONE.triggered);
		begin
			#(`MAX_TIME_TAKEN_BY_ONE_TRANS * cfg.trans_count);
			$display("Test Timed out ERROR");
		end
		join_any
	endtask : wait_for_test_to_complete_or_timeout
//------------------------------------------------ 
	function void generate_final_report();
    test.env.sb.report();
	endfunction : generate_final_report
//------------------------------------------------   
  task finish_test();
    $finish();
  endtask : finish_test
//------------------------------------------------   
endmodule : tb_top

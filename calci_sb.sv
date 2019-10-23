class calci_sb;
  mailbox #(calci_trans) imon2sb_mbx;
  mailbox #(calci_trans) omon2sb_mbx;
  calci_config cfg;
  
  calci_trans_cov h_trans_cov;
	event CHECK_DONE;
	int data_verified = 1;
  int pass = 0;
  int fail = 0;

	calci_trans ip_pkt_q [$];
	calci_trans op_pkt_q [$];
//------------------------------------------------  
  function new(calci_config cfg);
		this.cfg = cfg;
    h_trans_cov = new();
  endfunction
//------------------------------------------------  
  function void connect();
    imon2sb_mbx = cfg.imon2sb_mbx;
    omon2sb_mbx = cfg.omon2sb_mbx;
  endfunction : connect
//------------------------------------------------  
  virtual task run_scoreboard();
		fork
			get_pkt_from_input_mon_and_populate_q();
			get_pkt_from_output_mon_and_populate_q();
			wait_for_op_pkt_and_process();
		join_none
  endtask : run_scoreboard
//------------------------------------------------  
	virtual task get_pkt_from_input_mon_and_populate_q();
		calci_trans pkt,temp_pkt;
		forever begin
      imon2sb_mbx.get(temp_pkt);
			pkt = temp_pkt.copy();
			//$display("Received packet from input monitor\n");
			//pkt.print();
			ip_pkt_q.push_back(pkt);
		end
	endtask : get_pkt_from_input_mon_and_populate_q
//------------------------------------------------  
	virtual task get_pkt_from_output_mon_and_populate_q();
		calci_trans pkt,temp_pkt;
		forever begin
      omon2sb_mbx.get(temp_pkt);
			pkt = temp_pkt.copy();
			//$display("Received packet from output monitor\n");
			//pkt.print();
			op_pkt_q.push_back(pkt);
		end
	endtask : get_pkt_from_output_mon_and_populate_q
//------------------------------------------------  
	virtual task wait_for_op_pkt_and_process();
		calci_trans ip_pkt,op_pkt;
		forever begin
			wait(op_pkt_q.size()!=0);
			op_pkt = op_pkt_q.pop_front();
			if(ip_pkt_q.size()==0) begin
				$error("ERROR : Unexpected output packet received in Scoreboard!!");
				continue;
			end
			ip_pkt = ip_pkt_q.pop_front();
			perform_checking(ip_pkt,op_pkt);
	    perform_coverage(ip_pkt);
      if(data_verified == cfg.trans_count) 
				-> CHECK_DONE;
    	data_verified++;
		end
	endtask : wait_for_op_pkt_and_process
//------------------------------------------------  
	virtual function void perform_checking(calci_trans ip_pkt, calci_trans op_pkt);
  	get_expected_output(ip_pkt);
    compare_output_data(ip_pkt,op_pkt);
	endfunction : perform_checking
//------------------------------------------------  
	virtual function void get_expected_output(ref calci_trans ip_pkt);
		calci_ref_model::calci_oper(ip_pkt);
	endfunction
//------------------------------------------------  
  virtual function void compare_output_data(calci_trans ip_pkt,calci_trans op_pkt);
		//ip_pkt.print();
    if(ip_pkt.expected_output == op_pkt.C) begin
      pass++;
      $display("PASS : Transaction %0d\t Data Match ",data_verified);
    end
    else begin
      $display("FAIL : Output Data Mismatches");
      $display("ERROR : Expected data == %0d  Actual data == %0d",ip_pkt.expected_output,op_pkt.C);
      fail++;
    end
  endfunction : compare_output_data
//------------------------------------------------  
  function void perform_coverage(calci_trans cov_pkt);
    h_trans_cov.pkt_in_sample(cov_pkt);
  endfunction : perform_coverage
//------------------------------------------------  
  virtual function void report();
    $display("-------------------------------------------");
    if(fail != 0) begin
      $display("SB Report : Transactions PASS = %0d FAIL = %0d",pass,fail);
    end
    else begin
      $display("SB Report : Total Transactions Pass = %0d",pass);
    end
    $display("-------------------------------------------");
  endfunction : report
//------------------------------------------------  
endclass : calci_sb

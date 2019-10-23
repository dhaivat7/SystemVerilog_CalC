//------------------------------------------------  
class calci_trans_cov;
	
	bit calci_tlm_cov_coverage_on = 1;

	calci_trans m_pkt;

	bit cp_CTRL_cp_en = 1;
	bit cp_CTRL_BIN_0_bin_en = 1;

	bit cp_A_cp_en = 1;
	bit cp_A_zero_bin_en = 1;
	bit cp_A_low_bin_en = 1;
	bit cp_A_mid_bin_en = 1;
	bit cp_A_high_bin_en = 1;
	bit cp_A_max_bin_en = 1;

	bit cp_B_cp_en = 1;
	bit cp_B_zero_bin_en = 1;
	bit cp_B_low_bin_en = 1;
	bit cp_B_mid_bin_en = 1;
	bit cp_B_high_bin_en = 1;
	bit cp_B_max_bin_en = 1;

	static int iName = 0;
//------------------------------------------------  
	covergroup calci_trans_cov_tlm_cg(string cg_name, bit cg_per_instance);

		option.name = cg_name;
		option.per_instance = cg_per_instance;
		option.weight = 1;
		option.goal = 100;
		option.at_least = 1;
		option.auto_bin_max = 64;

		cp_CTRL_cp : coverpoint m_pkt.ctrl iff(cp_CTRL_cp_en == 1){
				bins cp_CTRL_BIN_0 []  = {[0:3]} iff(cp_CTRL_BIN_0_bin_en == 1);
		}

		cp_A_cp : coverpoint m_pkt.A iff(cp_A_cp_en == 1){
				bins zero = {0} iff(cp_A_zero_bin_en == 1);
				bins low = {[1:80]} iff(cp_A_low_bin_en == 1);
				bins mid = {[81:170]} iff(cp_A_mid_bin_en == 1);
				bins high = {[171:254]} iff(cp_A_high_bin_en == 1);
				bins max = {255} iff(cp_A_max_bin_en == 1);
		}

		cp_B_cp : coverpoint m_pkt.B iff(cp_B_cp_en == 1){
				bins zero = {0} iff(cp_B_zero_bin_en == 1);
				bins low = {[1:80]} iff(cp_B_low_bin_en == 1);
				bins mid = {[81:170]} iff(cp_B_mid_bin_en == 1);
				bins high = {[171:254]} iff(cp_B_high_bin_en == 1);
				bins max = {255} iff(cp_B_max_bin_en == 1);
		}

	endgroup:	calci_trans_cov_tlm_cg
//------------------------------------------------  
	function new();
		string sName;
		string sCov;
		sName.itoa(iName++);
		sCov={"calci_trans_cov_tlm_cg" ,sName};
		if(calci_trans_cov_tlm_cg) begin
			calci_trans_cov_tlm_cg.set_inst_name(sCov);
		end else begin
			calci_trans_cov_tlm_cg = new("calci_trans_cov_tlm_cg",1);
			calci_trans_cov_tlm_cg.set_inst_name(sCov);
		end
	endfunction: new
//------------------------------------------------  
	virtual function void pkt_in_sample(calci_trans pkt);
		m_pkt = pkt;
		calci_trans_cov_tlm_cg.sample();
	endfunction: pkt_in_sample
//------------------------------------------------  
endclass : calci_trans_cov
//------------------------------------------------  

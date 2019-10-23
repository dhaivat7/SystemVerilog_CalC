class calci_sig_cov;
	
	bit calci_sig_cov_coverage_on = 1;

	event calci_sig_cov_event;

	calci_vif h_vif;
	//virtual calci_sig_cov_sig_if h_vif;

	bit cp_VALID_cp_en = 1;
	bit cp_VALID_low_bin_en = 1;
	bit cp_VALID_high_bin_en = 1;

	bit cp_STALL_cp_en = 1;
	bit cp_STALL_low_bin_en = 1;
	bit cp_STALL_high_bin_en = 1;

	bit cr_VLD_STL_cr_en = 1;

	static int iName = 0;
//------------------------------------------------  
	covergroup calci_sig_cov_sig_cg(string cg_name, bit cg_per_instance)@(calci_sig_cov_event);

		option.name = cg_name;
		option.per_instance = cg_per_instance;
		option.weight = 1;
		option.goal = 100;
		option.at_least = 1;
		option.auto_bin_max = 64;

		cp_VALID_cp : coverpoint h_vif.Valid iff(cp_VALID_cp_en == 1){
				bins low = {1'b0} iff(cp_VALID_low_bin_en == 1);
				bins high = {1'b1} iff(cp_VALID_high_bin_en == 1);
		}

		cp_STALL_cp : coverpoint h_vif.Stall iff(cp_STALL_cp_en == 1){
				bins low = {1'b0} iff(cp_STALL_low_bin_en == 1);
				bins high = {1'b1} iff(cp_STALL_high_bin_en == 1);
		}

		cr_VLD_STL_cr : cross cp_VALID_cp,cp_STALL_cp iff(cr_VLD_STL_cr_en == 1){
				ignore_bins cr_VLD_STL_BIN_0 = binsof(cp_VALID_cp) intersect {0};
		}

	endgroup:	calci_sig_cov_sig_cg
//------------------------------------------------  
	function new(string sName);
		string sCov;
	//	sName.itoa(iName++);
		sCov={"calci_sig_cov_cg","_",sName};
		if(calci_sig_cov_sig_cg) begin
			calci_sig_cov_sig_cg.set_inst_name(sCov);
		end else begin
			calci_sig_cov_sig_cg = new("calci_sig_cov_sig_cg",1);
			calci_sig_cov_sig_cg.set_inst_name(sCov);
		end
	endfunction: new
//------------------------------------------------  
endclass : calci_sig_cov
//------------------------------------------------  

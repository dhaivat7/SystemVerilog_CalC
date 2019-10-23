class calci_trans;
	rand logic[7:0] A;
  rand logic[7:0] B;
  rand logic[1:0] ctrl;
  logic[15:0] C;

  logic[15:0] expected_output;
//------------------------------------------------  
  function new();
  endfunction
//------------------------------------------------  
  virtual function void print();
      $display("------------------------------------------");
      $display("\tA = %0h",A);
      $display("\tB = %0h",B);
      $display("\tctrl = %0h",ctrl);
      $display("------------------------------------------");
  endfunction: print
//------------------------------------------------  
	virtual function calci_trans copy();
		copy = new();
		copy.A = this.A ;
		copy.B = this.B ;
		copy.C = this.C ;
		copy.ctrl = this.ctrl ;
		copy.expected_output = this.expected_output;
	endfunction: copy
//------------------------------------------------  
endclass : calci_trans

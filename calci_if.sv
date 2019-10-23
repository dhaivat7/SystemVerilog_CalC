interface calci_if(input bit clk);

    parameter input_skew = 0ns;
    parameter output_skew = 0ns;

    logic Valid,Stall;
    logic[7:0] A;
    logic[7:0] B;
    logic[1:0] ctrl;
    logic[15:0] C;
//---------------------------------------------------------------------
    clocking dr_cb @(posedge clk);
      default input #input_skew output #output_skew;
      input Stall;
      output A,B,ctrl,Valid;
    endclocking
//---------------------------------------------------------------------
    clocking mr_cb @(posedge clk);
      default input #input_skew output #output_skew;
      input A,B,ctrl;
      input C,Valid;
			inout Stall;
    endclocking
//---------------------------------------------------------------------
endinterface

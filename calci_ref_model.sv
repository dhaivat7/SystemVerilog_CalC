class calci_ref_model;
//------------------------------------------------  
  function new();
  endfunction
//------------------------------------------------  
  static function void calci_oper(ref calci_trans trans);
    case(trans.ctrl)
      `ADD : trans.expected_output = trans.A + trans.B;
      `SUB : trans.expected_output = trans.A - trans.B;
      `MUL : trans.expected_output = trans.A * trans.B;
      `DIV : if(trans.B == 'd0) trans.expected_output = 'd0;
         		 else trans.expected_output = trans.A / trans.B;
    endcase
  endfunction : calci_oper  
//------------------------------------------------  
endclass : calci_ref_model

module calc (
                  input [7:0]  inpA ,
                  input [7:0]  inpB ,
                  input [01:0] inpOpType ,
                  output[15:0] outC  ,

                  input        iValid ,
                  output       iStall ,

                  input        oStall ,
                  output       oValid ,

                  input        clk ,
                  input        rstn 
                  ) ;
//----------------------------------------------------------------------

   parameter   ST_IDL   = 2'b00 ;
   parameter   ST_VALID = 2'b01 ;
   parameter   ST_STALL = 2'b11 ;
  
   reg         inp_dstall_r, oup_dval_r ;
   reg         inp_dstall_s, oup_dval_s;
	 reg         lat_inp_ls, lat_inp_hs, mv_lat_l_hs;

   reg [1:0]   st_cur, st_nxt ;


   reg  [15:0] store_ha, store_hb, oup_h ;
   reg  [15:0] store_la, store_lb;
   reg  [01:0] store_lctrl, store_hctrl ;
   

//----------------------------------------------------------------------
always @* begin
  inp_dstall_s = 1'b0 ;
  oup_dval_s   = 1'b0 ;
  lat_inp_ls   = 1'b0 ;
  lat_inp_hs   = 1'b0 ;
	mv_lat_l_hs  = 1'b0;
  st_nxt       = st_cur ;
  case(st_cur) 
    ST_IDL : begin
       if(iValid) begin
         lat_inp_hs   = 1'b1 ;
         st_nxt       = ST_VALID ;
      		oup_dval_s = 1'b1 ;
       end
     end
    ST_VALID : begin
      oup_dval_s = 1'b1 ;
			if(oStall) begin
				if(iValid) begin
      		inp_dstall_s = 1'b1 ;
        	st_nxt       = ST_STALL ;
         	lat_inp_ls   = 1'b1 ;
				end
			end
			else if(!iValid)begin
      	oup_dval_s = 1'b0 ;
        st_nxt     = ST_IDL ;
			end
			else begin
         lat_inp_hs   = 1'b1 ;
			end
		end	
    ST_STALL : begin
      oup_dval_s 	= 1'b1 ;
      inp_dstall_s = 1'b1 ;
      if(!oStall) begin
      	inp_dstall_s = 1'b0 ;
        st_nxt       = ST_VALID ;
				mv_lat_l_hs = 1'b1;
      end
     end
  endcase
end
//----------------------------------------------------------------------
always @(posedge clk or negedge rstn) begin
  if(!rstn) begin
    inp_dstall_r <= 1'b0 ;
    st_cur       <= ST_IDL ;
    oup_dval_r   <= 1'b0 ;
  end
  else begin
    inp_dstall_r <= inp_dstall_s ;
    st_cur       <= st_nxt ;
    oup_dval_r   <= oup_dval_s ;
  end
end
//----------------------------------------------------------------------
always @(posedge clk) begin
  if(lat_inp_hs) begin
    store_ha    <= inpA ;
    store_hb    <= inpB ;
    store_hctrl <= inpOpType ;
  end
	else if(mv_lat_l_hs)begin
    store_ha    <= store_la ;
    store_hb    <= store_lb ;
    store_hctrl <= store_lctrl ;
  end
end
//----------------------------------------------------------------------
always @(posedge clk) begin
  if(lat_inp_ls) begin
    store_la    <= inpA ;
    store_lb    <= inpB ;
    store_lctrl <= inpOpType ;
  end
end
//----------------------------------------------------------------------
always @* begin
  if(store_hctrl == 2'b00) oup_h = store_ha + store_hb ;
  else if(store_hctrl == 2'b01) oup_h = store_ha - store_hb ;
  else if(store_hctrl == 2'b10) oup_h = store_ha * store_hb ;
  else if(store_hb == 0) oup_h = 0 ;
  else oup_h = store_ha / store_hb ;
end
//----------------------------------------------------------------------
assign iStall   = inp_dstall_r ;
assign oValid   = oup_dval_r ;
assign outC     = oup_h ;
//----------------------------------------------------------------------

endmodule 

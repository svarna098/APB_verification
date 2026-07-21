class apb_transaction ;
  rand bit [31:0] wdata_in ;
  rand bit [7:0] addr_in;
  rand bit write_read ;
  rand bit transfer;
  rand bit [3:0] strb_in  ;
  
  rand bit  [31:0] PRDATA;
  rand bit PREADY;
  rand bit PSLVERR;
  
  bit [7:0] PADDR;
  bit PSEL;
  bit PENABLE;
  bit [31:0] pwdata;
  bit pwrite;
  bit [3:0] PSTRB;
  bit [31:0] rdata_out;
  bit transferdone;
  bit error;

  static int count=0;
  
  constraint data { 
		  wdata_in  inside { [0:255]};
		  }

 constraint rdata { 
		  PRDATA  inside { [0:255]};
		  }
constraint rd_wr { 
		soft  write_read  inside { 1};
		  }
constraint tr { 
		  soft transfer  inside { 0};
		  }
//constraint data_1 { if (PREADY ==1) wdata_in inside {[0:255]}; }
 // constraint trans { 
		//  soft transfer dist { 0:= 20 , 1:= 80} ;
		//  }
 // constraint ready { 
  //  soft PREADY dist { 0:= 40 , 1:= 60} ;
   //   }

  function void pre_randomize ();

   //if(count ==0)
  // transfer =0;
if (write_read ==1) begin
 if(PREADY ==0) begin
    if  (transfer==1) begin
                      wdata_in.rand_mode(0); addr_in.rand_mode (0); end 
               end
		else  begin
                if ( transfer==1)
			begin wdata_in.rand_mode(1); addr_in.rand_mode (1); end
	  end

end
else begin
    if(PREADY ==0) begin
    if  (transfer==1) begin
                      PRDATA.rand_mode(0); addr_in.rand_mode (0); end 
               end
		else  begin
                if ( transfer==1)
			begin PRDATA.rand_mode(1); addr_in.rand_mode (1); end
	  end
end 
  endfunction


  function void post_randomize ();
       


	  if (count==3)begin
		  PREADY=0;transfer =1; end                    //2
   	if(count ==4 || count==5)begin
		transfer =1  ;PREADY =0;end                    //3,4
	  if(count==6)begin
		PREADY =1; transfer=1; end                    //5                  
	  if(count==7 ||count==8) begin
		  PREADY =1;transfer=1; end                   //7
	//  if(count==6)   begin 
		//  PREADY =1;
		//  transfer =1;
	//  end
	  if(count ==9)  begin
		  PREADY =1;
		  transfer=0;    end                          //9
	
	 if(count ==10)  begin
		  PREADY =0;
		  transfer=0;end
	 if(count ==11)  begin
		  PREADY =0;
		  transfer=1; end
	if(count ==12)  begin
		  PREADY =1;
		  transfer=1;
 end
  endfunction

  virtual function apb_transaction copy ();
    copy=new();
    copy.wdata_in = this.wdata_in;
    copy.transfer = this.transfer;
    copy.addr_in =this.addr_in;
    copy.write_read = this.write_read;
    copy.PSLVERR =this.PSLVERR;
    copy.PREADY=this.PREADY;
    copy.PRDATA =this.PRDATA;
    copy.strb_in =this.strb_in;
    
    return copy ;
  endfunction
endclass

class apb_tr_1 extends apb_transaction;

 
   constraint rd_wr {
      write_read == 0;
   }
constraint tr { 
		   transfer  dist { 1:=80 ,0:=20};
		  }
   virtual function apb_transaction copy();

      apb_tr_1 copy1;

      copy1 = new();

      copy1.wdata_in   = this.wdata_in;
      copy1.addr_in    = this.addr_in;
      copy1.write_read = this.write_read;
      copy1.transfer   = this.transfer;
      copy1.strb_in    = this.strb_in;
      copy1.PRDATA     = this.PRDATA;
      copy1.PREADY     = this.PREADY;
      copy1.PSLVERR    = this.PSLVERR;

      return copy1;

   endfunction

endclass




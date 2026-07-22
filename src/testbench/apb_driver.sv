class apb_driver;
  apb_transaction tx_drv;
  mailbox gen2drv;
  mailbox drv2 ;
  virtual apb_if.drv vif;

  covergroup mon_cg ;

      //data: coverpoint tx_drv.wdata_in;
    //  address : coverpoint tx_drv.addr_in ;
      writeread : coverpoint tx_drv.write_read { bins wr_rd []= {0,1};}
      trans: coverpoint tx_drv.transfer ;
     // strb : coverpoint tx_drv.strb_in ;
      slave_error : coverpoint tx_drv.PSLVERR;
      ready : coverpoint tx_drv.PREADY;
     // rdata:coverpoint tx_drv.PRDATA;
   /*    
      wdata: cross data , writeread {  
             bins wd_wrrd = binsof (data) || binsof (writeread) ;}
      addr : cross  address , writeread {
	           bins wr_addr = binsof (address) || binsof (writeread) ;}
      data_addr : cross address ,data {
	           bins da_ad = binsof (address) && binsof (data); }
*/
  endgroup
                         

  function new ( mailbox gen2drv , mailbox drv2 , virtual apb_if.drv vif );

	  this.gen2drv = gen2drv;
	  this.drv2 = drv2;
	  this.vif = vif;
	  
	  mon_cg = new();

  endfunction

  task run ();

   repeat (4) @ (vif.drv_cb);


  for(int i=0 ;i<100;i=i+1)
   begin
	  tx_drv=new();
	  gen2drv.get (tx_drv);

	  if(vif.drv_cb.reset==0)
	   //repeat (1) @(vif.drv_cb)
             begin
		  vif.drv_cb.wdata_in <=0;
		  vif.drv_cb.addr_in <=0;
		  vif.drv_cb.transfer <= 0;
		  vif.drv_cb.PRDATA <=0;
		  vif .drv_cb.PREADY <=0;
		  vif. drv_cb.PSLVERR <=0;
		  vif.drv_cb.write_read <=0;
		  vif.drv_cb.strb_in <=0;
		  
		  drv2.put (tx_drv);
		 
		  $display ("driver: :  transfer=%d | wdata =%d | addr =%d | write_read =%d  | strb =%d | pready =%d | pslverr=%d | prdata =%d  | time=%0t ", vif.drv_cb.transfer , vif.drv_cb.wdata_in , vif.drv_cb.addr_in , vif.drv_cb .write_read , vif.drv_cb.strb_in , vif.drv_cb.PREADY , vif.drv_cb.PSLVERR , vif.drv_cb.PRDATA , $time);
 
 repeat (1) @ (vif.drv_cb);

	  end

	  else 
	 // repeat (1) @(vif.drv_cb)
	    begin
		if(i==0 )
   		 tx_drv.wdata_in= 32'hffffffff;
		if (i==1)
    		tx_drv.wdata_in =32'd0;
		  vif.drv_cb.wdata_in <= tx_drv.wdata_in;
		  vif.drv_cb.PREADY <= tx_drv.PREADY;
		  vif.drv_cb.addr_in <= tx_drv.addr_in;
		  vif.drv_cb.transfer <= tx_drv.transfer;
		  vif.drv_cb.PRDATA <= tx_drv.PRDATA;
		  
		  vif.drv_cb.PSLVERR <= tx_drv.PSLVERR;
		  vif.drv_cb.write_read <=tx_drv.write_read;
		  vif.drv_cb.strb_in <= tx_drv.strb_in;
		  
		  drv2.put(tx_drv);
		  

		  $display ("driver: :  transfer=%d | wdata =%d | addr =%d | write_read =%d  | strb =%d | pready =%d | pslverr=%d | prdata =%d  | time=%0t ", vif.drv_cb.transfer , vif.drv_cb.wdata_in , vif.drv_cb.addr_in , vif.drv_cb .write_read , vif.drv_cb.strb_in , vif.drv_cb.PREADY , vif.drv_cb.PSLVERR , vif.drv_cb.PRDATA , $time );
  
		  mon_cg.sample();
repeat (1) @ (vif.drv_cb);
	  end
  end
endtask
endclass


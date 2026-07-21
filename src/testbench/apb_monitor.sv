class apb_monitor;
apb_transaction tx_mon;
mailbox mon2sc ;
virtual apb_if.mon_cb vif ;

/*covergroup mon_cg;
address :coverpoint tx_mon.PADDR ;
data : coverpoint tx_mon.pwdata ;
read_write : coverpoint tx_mon.pwrite { bins wr_rd []= {0,1};}
read : coverpoint tx_mon.rdata_out;
psel : coverpoint tx_mon.PSEL;
enable : coverpoint tx_mon.PENABLE ;
//strb
Transfer : coverpoint tx_mon.transferdone;
Err: coverpoint tx_mon.error;
endgroup*/

function new( mailbox mon2sc , virtual apb_if.mon_cb vif);
this.mon2sc =mon2sc ;

this.vif =vif;

//mon_cg=new();
endfunction

task start ();
repeat (4) @(vif.mon_cb);

for (int i=0 ;i<20;i=i+1)
begin
	tx_mon =new();
        
	//repeat ( 1) @(vif.mon_cb);
	  
		tx_mon.PSEL = vif.mon_cb.PSEL;
		tx_mon.PADDR =vif.mon_cb.PADDR ;
		tx_mon.pwrite = vif.mon_cb.pwrite;
		tx_mon.rdata_out =vif.mon_cb.rdata_out;
		tx_mon.PENABLE =vif.mon_cb.PENABLE;
		tx_mon.transferdone = vif.mon_cb.transferdone;
		tx_mon.error=vif.mon_cb.error;
		tx_mon.pwdata =vif.mon_cb.pwdata;
		tx_mon.PSTRB = vif.mon_cb.PSTRB;
		
		mon2sc .put (tx_mon);
               
		$display( " monitor : psel =%d  | paddr=%d | pwrite=%d | penable =%d | transfer_done=%d  | pstrb =%d  | pwdata =%d  | rdata =%d  | error =%d | time=%0t",  tx_mon.PSEL , tx_mon.PADDR ,tx_mon.pwrite, tx_mon.PENABLE , tx_mon.transferdone , tx_mon.PSTRB , tx_mon.pwdata , tx_mon.rdata_out , tx_mon.error , $time );
  
	 repeat ( 1)@(vif.mon_cb);

		
	

		
		//mon_cg.sample ();
		//repeat (1) @(vif.mon_cb);
	end
	endtask
endclass


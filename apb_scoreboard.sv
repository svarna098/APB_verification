class apb_scoreboard;

mailbox mon2sc;
mailbox ref2sc;

apb_transaction  tx_mon, tx_ref ;

int pass =0;
int fail =0;

function new (mailbox mon2sc , mailbox ref2sc );
	this.mon2sc=mon2sc;
	this.ref2sc=ref2sc;
endfunction

task run();

for (int i=0;i<100 ;i=i+1)
	begin
		//tx_ref=new();
		//tx_mon=new();
	//begin
//fork
		
//$display ("  ref after get:fail : psel =%d  | paddr=%d | pwrite=%d | penable =%d | transfer_done=%d  | pstrb =%d  | pwdata =%d  | rdata =%d  | error =%d  | time =%0t ",  tx_ref.PSEL , tx_ref.PADDR ,tx_ref.pwrite, tx_ref.PENABLE , tx_ref.transferdone , tx_ref.PSTRB , tx_ref.pwdata , tx_ref.rdata_out , tx_ref.error, $time );
		mon2sc.get (tx_mon);
		ref2sc.get(tx_ref);
//join
	//end
	//if(tx_ref == tx_mon )
	if (tx_ref.pwrite==tx_mon.pwrite && tx_ref.PADDR==tx_mon.PADDR && tx_ref.pwdata==tx_mon.pwdata && tx_ref.rdata_out==tx_mon.rdata_out &&tx_ref.error==tx_mon.error && tx_ref.PSTRB ==tx_mon.PSTRB && tx_mon.PSEL ==tx_ref.PSEL && tx_mon.PENABLE ==tx_ref.PENABLE && tx_mon.transferdone ==tx_ref.transferdone ) begin
		$display ( "scoreboard : pass");
$display ("====================================================================================================================================================\n");end
	else
		begin
		$display ("scoreboard mon:fail : psel =%d  | paddr=%d | pwrite=%d | penable =%d | transfer_done=%d  | pstrb =%d  | pwdata =%d  | rdata =%d  | error =%d | tine =%0t ",  tx_mon.PSEL , tx_mon.PADDR ,tx_mon.pwrite, tx_mon.PENABLE , tx_mon.transferdone , tx_mon.PSTRB , tx_mon.pwdata , tx_mon.rdata_out , tx_mon.error , $time);
		$display ("scoreboard ref:fail : psel =%d  | paddr=%d | pwrite=%d | penable =%d | transfer_done=%d  | pstrb =%d  | pwdata =%d  | rdata =%d  | error =%d | time =%0t",  tx_ref.PSEL , tx_ref.PADDR ,tx_ref.pwrite, tx_ref.PENABLE , tx_ref.transferdone , tx_ref.PSTRB , tx_ref.pwdata , tx_ref.rdata_out , tx_ref.error ,$time);

$display ("====================================================================================================================================================\n");
		
		end
	end
endtask
endclass
	

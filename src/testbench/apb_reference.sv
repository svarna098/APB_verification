/*class apb_reference ;

apb_transaction tx_ref;

mailbox drv2 ;
mailbox ref2sc;

virtual apb_if.reference vif ;

reg [7:0] mem_data ;
reg [4:0] mem_addr ;
reg  [7:0] mem_rdata;

typedef enum  { idle , setup , access } state_t;

state_t state;

function new (mailbox drv2 , mailbox ref2sc , virtual apb_if.reference vif );
	this.drv2 =drv2;
	this.ref2sc =ref2sc;
	this.vif =vif;
	
endfunction


task run ();

for (int i=0 ; i<50 ;i=i+1)
	begin

		tx_ref=new();
		drv2.get (tx_ref);


		if (tx_ref.transfer ==0 )
			state=0;
		else if (tx_ref.transfer ==1)
                       state=1;
		else if (state==1)
			state=2;
		else if (state==2)
    			begin
			if(tx_ref.PREADY==0)
				state=2;

			else  begin
			   if(tx_ref.transfer==0)
				state=0;
			   else
			       state=1;
			      end
			end
		

		repeat (1) @ (vif.ref_cb)
		 begin
			if(state==0)  begin
			if ( tx_ref.transfer ==0)
			//idle state
				tx_ref.PSEL =0;      end
			else
			   begin
				//setup state
				if(state==1)  begin
				repeat (1) @ (vif.ref_cb)
				tx_ref.PSEL =1;
				tx_ref.PENABLE =0;
				tx_ref.pwrite = tx_ref.write_read;
				tx_ref.PSTRB =tx_ref.strb_in ;
				tx_ref.PADDR =tx_ref.addr_in;
				if(tx_ref.write_read ==1)
					begin
						//mem_addr = tx_ref.addr_in;
						//mem_data = tx_ref.wdata_in;
						
						tx_ref.wdata_in =tx_ref.pwdata;
						
						  
					end
				if ( tx_ref.write_read ==0)
					 begin
						//mem_addr = tx_ref.addr_in;
						 //mem_rdata= tx_ref.PRDATA;
			
						tx_ref.PRDATA =tx_ref.rdata_out;
						
					end		
		  		end
				//access state
				if(state==2)  begin
				repeat (1) @ (vif.ref_cb)
					tx_ref.PSEL =1;
					tx_ref.PENABLE =1;
					//tx_ref.pwrite = tx_ref.write_read;
				
			
			      if(tx_ref.PREADY==1)
					tx_ref.error =tx_ref.PSLVERR;
				begin	
				   
				  if( tx_ref.transfer==1)
				   begin
					// repeat (1) @ (vif.ref_cb)

					tx_ref.transfer_done =1;
			
				       if(tx_ref.write_read ==1)
					begin
						tx_ref.PADDR= mem_addr;
						tx_ref.pwdata= mem_data ;
					end
				        if ( tx_ref.write_read ==0)
					 begin
						tx_ref.PADDR= mem_addr;
						tx_ref.rdata_out= mem_data ;
					end	
				   end


				  else if( tx_ref.transfer==0)
				    begin

					//repeat (1) @ (vif.ref_cb)
					tx_ref.transfer_done =1;
			
					if(tx_ref.write_read ==1)
					begin
						tx_ref.PADDR= mem_addr;
						tx_ref.pwdata= mem_data ;
					end


					if ( tx_ref.write_read ==0)
					 begin
						tx_ref.PADDR= mem_addr;
						tx_ref.rdata_out= mem_data ;
					 end	
				    end
				end
			       end 	
					 repeat (1) @ (vif.ref_cb)
					tx_ref.transfer_done =0;
					//tx_ref.PSEL =0;

			    end
			end
			 ref2sc.put (tx_ref);
		end
        
   endtask

endclass
*/


class apb_reference ;

apb_transaction tx_ref;

mailbox drv2 ;
mailbox ref2sc;

virtual apb_if.reference vif ;

reg [31:0] mem_data ;
reg [7:0] mem_addr ;
reg [31:0] mem_rdata;

typedef enum { idle , setup , access } state_t;

state_t state;

function new (mailbox drv2 , mailbox ref2sc , virtual apb_if.reference vif );
	this.drv2 = drv2;
	this.ref2sc = ref2sc;
	this.vif = vif;
endfunction


task run ();
repeat (1) @(vif.ref_cb);

for (int i=0 ; i<20 ; i=i+1)
	begin

		tx_ref = new();
		drv2.get(tx_ref);
		//repeat (1) @(vif.ref_cb)
                  

	  if(vif.ref_cb.reset==0)
	   //repeat (1) @(vif.drv_cb)
             begin
		  tx_ref.PSEL = 0;
		tx_ref.PADDR =0;
		tx_ref.pwrite = 0;
		tx_ref.rdata_out =0;
		tx_ref.PENABLE =0;
		tx_ref.transferdone = 0;
		tx_ref.error=0;
		tx_ref.pwdata =0;
		tx_ref.PSTRB = 0;
	     end

         else
             begin

		if (tx_ref.transfer == 0)
			state = idle;
		else if (tx_ref.transfer == 1) 
			state = setup;
                        
		else if (tx_ref.transfer == 1 && state==setup)
			state = access;
		if (state == access)
		begin
			if(tx_ref.PREADY == 0)
				state = access;
			else
			begin
				if(tx_ref.transfer == 0)
					state = idle;
				else
					state = setup;
			end
		end


		//repeat (1) @(vif.ref_cb);
		//begin

			if(state == idle)
			begin
					
				//if(tx_ref.transfer == 0)
					tx_ref.PSEL = 0;
                                        tx_ref.PENABLE = 0;
			end
			else
			

				if(state == setup)
				begin

					

					tx_ref.PSEL = 1;
					tx_ref.PENABLE = 0;
					tx_ref.pwrite = tx_ref.write_read;
					tx_ref.PSTRB = tx_ref.strb_in;
					tx_ref.PADDR = tx_ref.addr_in;
					mem_addr = tx_ref.addr_in;

					if(tx_ref.write_read == 1)
					begin
						 tx_ref.pwdata = tx_ref.wdata_in;
				
						mem_data = tx_ref.wdata_in;
					end

					if(tx_ref.write_read == 0)
					begin
						//tx_ref.rdata_out  = tx_ref.PRDATA ;

						mem_rdata= tx_ref.PRDATA;
						
					end

				end


				if(state == access)
				begin

					//repeat (1) @(vif.ref_cb);

					tx_ref.PSEL = 1;
					tx_ref.PENABLE = 1;

					if(tx_ref.PREADY == 1)
					begin

						tx_ref.error = tx_ref.PSLVERR;

						if(tx_ref.transfer == 1)
						begin

							tx_ref.transferdone = 1;

							if(tx_ref.write_read == 1)
							begin
								tx_ref.PADDR = mem_addr;
								tx_ref.pwdata = mem_data;
							end

							if(tx_ref.write_read == 0)
							begin
								tx_ref.PADDR = mem_addr;
								tx_ref.rdata_out = mem_rdata;
							end

						end

						else if(tx_ref.transfer == 0)
						begin

							tx_ref.transferdone = 1;

							if(tx_ref.write_read == 1)
							begin
								tx_ref.PADDR = mem_addr;
								tx_ref.pwdata = mem_data;
							end

							if(tx_ref.write_read == 0)
							begin
								tx_ref.PADDR = mem_addr;
								tx_ref.rdata_out = mem_data;
							end

						end

					end

					//repeat (1) @(vif.ref_cb);

					tx_ref.transferdone = 0;

				//end

			
			
			//repeat (1) @(vif.ref_cb);
			
		end
		end
	ref2sc.put(tx_ref);
$display ("%m  ref:fail : psel =%d  | paddr=%d | pwrite=%d | penable =%d | transfer_done=%d  | pstrb =%d  | pwdata =%d  | rdata =%d  | error =%d  | time =%0t ",  tx_ref.PSEL , tx_ref.PADDR ,tx_ref.pwrite, tx_ref.PENABLE , tx_ref.transferdone , tx_ref.PSTRB , tx_ref.pwdata , tx_ref.rdata_out , tx_ref.error, $time );
                  
//$display ("====================================================================================================================================================\n");
//repeat (1) @(vif.ref_cb);
	end


endtask

endclass
		  			

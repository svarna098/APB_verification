class apb_generator ;
  apb_transaction tx_gen;
  mailbox gen2drv ;

  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
    tx_gen=new();
  endfunction

//  static int count =0;


  task apb();

    for (int i=0 ; i<20;i=i+1)
	
     begin

        if(tx_gen.randomize ()==1)  begin
           tx_gen.count=tx_gen.count+1;
        end


      gen2drv.put (tx_gen.copy());
      $display ("generator: :  transfer=%d | pready =%d  | write_read =%d | wdata_in =%d | addr_in =%d |  strb =%d |  pslverr=%d | prdata =%d   ", tx_gen.transfer , tx_gen.PREADY ,tx_gen.write_read ,tx_gen.wdata_in , tx_gen.addr_in ,         tx_gen.strb_in ,  tx_gen.PSLVERR , tx_gen.PRDATA );
   
    end
   $display ("====================================================================================================================================================\n");
  endtask
endclass



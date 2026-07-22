module top( );
  
    import apb_pkg ::*; 
  
    bit clk;
    bit reset;

 
  initial
    begin
    forever #10 clk=~clk;
    end

  initial
    begin
      @(posedge clk);
	reset =0;
	repeat(2)@(posedge clk);
	reset =1;
      //reset=0;
     // repeat(2)@(posedge clk);
     // reset=1;
      
	


    end
 
  
    apb_if intrf(clk,reset);
 
    apb_master duv (.PADDR(intrf.PADDR),
            . PSEL(intrf.PSEL),
            .PENABLE(intrf.PENABLE),
            .PWRITE(intrf.pwrite),
            .PWDATA(intrf.pwdata),
            .PSTRB (intrf. PSTRB),
            . PRDATA (intrf .PRDATA),
            . PREADY (intrf. PREADY),
            .PSLVERR (intrf.PSLVERR),
            .transfer (intrf.transfer),
            .write_read (intrf.write_read),
            .addr_in (intrf.addr_in),
            . wdata_in (intrf. wdata_in),
            . strb_in (intrf. strb_in),
            .rdata_out (intrf.rdata_out),
            .transfer_done (intrf.transferdone),
            .error (intrf.error ),
            .PCLK(clk),
            .PRESETn (reset)
           ); 
                  
  
   apb_test_regression tb;

initial begin
    tb = new(intrf.drv, intrf.mon, intrf.reference);
    tb.run();
    #100 $finish;
end
endmodule

interface apb_if (input bit clk , reset);
logic [31:0] PRDATA;
logic PREADY;
logic PSLVERR;
logic transfer;
logic write_read;
logic [7:0] addr_in;
logic  [31:0] wdata_in;
logic [3:0] strb_in;
logic [7:0] PADDR ;
logic [31:0] pwdata;
logic PSEL ,PENABLE , pwrite , transferdone ,error;
logic [3:0]PSTRB;
logic [31:0] rdata_out;

clocking drv_cb @ (posedge clk);
  default input #0  output #0;
output PRDATA , PREADY , PSLVERR , transfer , write_read , addr_in , wdata_in , strb_in ;
input reset;
endclocking

clocking mon_cb @( posedge clk);
  default input #0  output #0;
input PADDR ,PSEL ,PENABLE , pwrite ,pwdata, transferdone ,error,  rdata_out,PSTRB;
//input pstrb;
endclocking

 clocking ref_cb @( posedge clk);
  default input #0  output #0;
input reset;
//output PADDR ,PSEL ,PENABLE , pwrite ,pwdata,PSTRB, transferdone ,error,  rdata_out;
//input reset, PRDATA , PREADY , PSLVERR , transfer , write_read , addr_in , wdata_in , strb_in ;
endclocking

modport drv ( clocking drv_cb);
modport mon ( clocking mon_cb );
modport reference (clocking ref_cb );


property p1;
@(posedge clk) disable iff (!reset)
!transfer |-> (!PSEL);
endproperty

assert property (p1);

property p2;
@(posedge clk) disable iff (!reset)
transfer |=> (PSEL&&(!PENABLE)) ##1 (PSEL && PENABLE);
endproperty

assert property (p2);




 endinterface


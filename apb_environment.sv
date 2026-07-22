class apb_environment;
virtual apb_if drv_vif;
virtual apb_if mon_vif;
virtual apb_if ref_vif;

mailbox gen2drv;
mailbox drv2;
mailbox ref2sc;
mailbox mon2sc;

apb_generator gen;
apb_driver driver;
apb_monitor monitor;
apb_scoreboard scb;
apb_reference reference;

function new (virtual apb_if drv_vif,
virtual apb_if mon_vif,
virtual apb_if ref_vif);

this.drv_vif =drv_vif;
this.mon_vif = mon_vif;
this.ref_vif = ref_vif;

endfunction

task build ();
 begin
	gen2drv =new();
	drv2=new();
	ref2sc =new();
	mon2sc =new();


gen=new (gen2drv);
driver = new (gen2drv ,drv2 , drv_vif );
monitor = new ( mon2sc,mon_vif  );
reference = new (drv2 , ref2sc , ref_vif);
scb = new (  mon2sc,ref2sc );

end
endtask

task run();

fork
	gen.apb ();
	driver.run();
	monitor.start();
	
	scb.run();
	reference.run();
	
	
	
 
join

endtask

endclass



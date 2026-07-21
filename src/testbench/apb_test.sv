class apb_test;

  virtual apb_if drv_vif;
  virtual apb_if mon_vif;
  virtual apb_if ref_vif;

  apb_environment env;

  function new (virtual apb_if drv_vif,
    virtual apb_if mon_vif,
    virtual apb_if ref_vif);

    this.drv_vif =drv_vif;
    this.mon_vif = mon_vif;
    this.ref_vif = ref_vif;

  endfunction

 virtual task run ();
    env =new (drv_vif , mon_vif , ref_vif );
    env.build;
    env.run;
  endtask
endclass

class apb_test_1 extends apb_test;

   apb_tr_1 trans;

   function new(
      virtual apb_if drv_vif,
      virtual apb_if mon_vif,
      virtual apb_if ref_vif
   );

      super.new(drv_vif,mon_vif,ref_vif);

   endfunction


   virtual task run();

      env = new(drv_vif,mon_vif,ref_vif);

      env.build();

      trans = new();

     env.gen.tx_gen = trans;

      env.run();

   endtask

endclass

class apb_test_regression extends apb_test;

   apb_transaction trans0;
   apb_tr_1  trans1;

   function new(
    virtual apb_if drv_vif,
    virtual apb_if mon_vif,
    virtual apb_if ref_vif);

   super.new(drv_vif, mon_vif, ref_vif);

   endfunction

   virtual task run();

      env = new(drv_vif, mon_vif, ref_vif);

      env.build();

   
      trans0 = new();
      env.gen.tx_gen = trans0;
      env.run();

     
      trans1 = new();
      env.gen.tx_gen = trans1;
      env.run();

   endtask

endclass

CREATE OR REPLACE PACKAGE CPI.gipi_wbond_basic_pkg
AS
   TYPE gipi_wbond_basic_type IS RECORD (
      par_id            gipi_wbond_basic.par_id%TYPE,
      obligee_no        gipi_wbond_basic.obligee_no%TYPE,
      prin_id           gipi_wbond_basic.prin_id%TYPE,
      val_period_unit   gipi_wbond_basic.val_period_unit%TYPE,
      val_period        gipi_wbond_basic.val_period%TYPE,
      coll_flag         gipi_wbond_basic.coll_flag%TYPE,
      clause_type       gipi_wbond_basic.clause_type%TYPE,
      np_no             gipi_wbond_basic.np_no%TYPE,
      contract_dtl      gipi_wbond_basic.contract_dtl%TYPE,
      contract_date     gipi_wbond_basic.contract_date%TYPE,
      co_prin_sw        gipi_wbond_basic.co_prin_sw%TYPE,
      waiver_limit      gipi_wbond_basic.waiver_limit%TYPE,
      indemnity_text    gipi_wbond_basic.indemnity_text%TYPE,
      bond_dtl          gipi_wbond_basic.bond_dtl%TYPE,
      endt_eff_date     gipi_wbond_basic.endt_eff_date%TYPE,
      remarks           gipi_wbond_basic.remarks%TYPE,
      obligee_name      giis_obligee.obligee_name%TYPE,
      prin_signor       giis_prin_signtry.prin_signor%TYPE,
      designation       giis_prin_signtry.designation%TYPE,
      np_name           giis_notary_public.np_name%TYPE,
      plaintiff_dtl     gipi_wbond_basic.plaintiff_dtl%TYPE,
      defendant_dtl     gipi_wbond_basic.defendant_dtl%TYPE,
      civil_case_no     gipi_wbond_basic.civil_case_no%TYPE
   );

   TYPE gipi_wbond_basic_tab IS TABLE OF gipi_wbond_basic_type;

   FUNCTION get_gipi_wbond_basic (p_par_id gipi_wbond_basic.par_id%TYPE)
      RETURN gipi_wbond_basic_tab PIPELINED;

   PROCEDURE set_gipi_wbond_basic (
      p_par_id           IN   gipi_wbond_basic.par_id%TYPE,
      p_obligee_no       IN   gipi_wbond_basic.obligee_no%TYPE,
      p_bond_dtl         IN   gipi_wbond_basic.bond_dtl%TYPE,
      p_indemnity_text   IN   gipi_wbond_basic.indemnity_text%TYPE,
      p_clause_type      IN   gipi_wbond_basic.clause_type%TYPE,
      p_waiver_limit     IN   gipi_wbond_basic.waiver_limit%TYPE,
      p_contract_date    IN   gipi_wbond_basic.contract_date%TYPE,
      p_contract_dtl     IN   gipi_wbond_basic.contract_dtl%TYPE,
      p_prin_id          IN   gipi_wbond_basic.prin_id%TYPE,
      p_co_prin_sw       IN   gipi_wbond_basic.co_prin_sw%TYPE,
      p_np_no            IN   gipi_wbond_basic.np_no%TYPE,
      p_coll_flag        IN   gipi_wbond_basic.coll_flag%TYPE,
      p_plaintiff_dtl    IN   gipi_wbond_basic.plaintiff_dtl%TYPE,
      p_defendant_dtl    IN   gipi_wbond_basic.defendant_dtl%TYPE,
      p_civil_case_no    IN   gipi_wbond_basic.civil_case_no%TYPE,
      p_val_period       IN   gipi_wbond_basic.VAL_PERIOD%TYPE,
      p_val_period_unit  IN   gipi_wbond_basic.VAL_PERIOD_UNIT%TYPE
   );

   PROCEDURE del_gipi_wbond_basic (p_par_id IN gipi_wbond_basic.par_id%TYPE);

   FUNCTION get_bond_basic_new_record (p_par_id gipi_wbond_basic.par_id%TYPE)
      RETURN gipi_wbond_basic_tab PIPELINED;
      
    -- shan 10.13.2014
    TYPE gipi_wc20_dtl_type IS RECORD(
        par_id          gipi_wc20_dtl.PAR_ID%type,
        item_no         gipi_wc20_dtl.ITEM_NO%type,
        plate_no        gipi_wc20_dtl.PLATE_NO%type,
        motor_no        gipi_wc20_dtl.MOTOR_NO%type,
        make            gipi_wc20_dtl.MAKE%type,
        psc_case_no     gipi_wc20_dtl.PSC_CASE_NO%type
    );
   
    TYPE gipi_wc20_dtl_tab IS TABLE OF gipi_wc20_dtl_type;
   
   
    FUNCTION get_land_carrier_dtl(
        p_par_id        gipi_wc20_dtl.PAR_ID%type
    ) RETURN gipi_wc20_dtl_tab PIPELINED;
    
    
    PROCEDURE set_land_carrier_dtl (p_rec gipi_wc20_dtl%ROWTYPE);


    PROCEDURE del_land_carrier_dtl (
        p_par_id        gipi_wc20_dtl.PAR_ID%type,
        p_item_no       gipi_wc20_dtl.ITEM_NO%type
    );
   
    PROCEDURE val_add_land_carrier_dtl(
        p_par_id        gipi_wc20_dtl.PAR_ID%type,
        p_item_no       gipi_wc20_dtl.ITEM_NO%type
    );
   
END gipi_wbond_basic_pkg;
/



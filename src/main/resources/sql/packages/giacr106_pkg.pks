CREATE OR REPLACE PACKAGE CPI.giacr106_pkg
AS
   TYPE giacr106_records_type IS RECORD (
      cf_company           VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_basis             VARCHAR2 (150),
      cf_from_date         VARCHAR2 (50),
      cf_to_date           VARCHAR2 (50),
      ri_name              giis_reinsurer.ri_name%TYPE,
      line_name            giis_line.line_name%TYPE,
      eff_date             giri_binder.eff_date%TYPE,
      binder               VARCHAR2 (50),
      policy_no            VARCHAR2 (50),
      policy_id            gipi_polbasic.policy_id%TYPE,
      assured              giis_assured.assd_name%TYPE,
      amt_insured          NUMBER (20, 2),
      prem                 NUMBER (20, 2),
      comm                 NUMBER (20, 2),
      net_prem             NUMBER (20, 2),
      binder_id            giri_binder.fnl_binder_id%TYPE,
      replaced_flag        giri_binder.replaced_flag%TYPE,
      ri_prem_vat          NUMBER (20, 2),
      ri_comm_vat          NUMBER (20, 2),
      ri_wholding_vat      NUMBER (20, 2),
      dummy2               VARCHAR2 (3),
      frps_yy              giri_frps_ri.frps_yy%TYPE,
      frps_seq_no          giri_frps_ri.frps_seq_no%TYPE,
      ppw                  DATE,
      intrmdry_intm_no     gipi_comm_invoice.intrmdry_intm_no%TYPE,
      cf_net_prem          NUMBER (20, 2),
      -- jhing 02.01.2016 added new fields GENQA 5270
      ref_date       DATE,
      ref_no         VARCHAR2 (100),    
      g_tran_id      giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      disb_amt       giac_outfacul_prem_payts.disbursement_amt%TYPE,
      balance_amt     NUMBER (20, 2),
      tran_class     giac_acctrans.tran_class%TYPE,
      for_tot_amt_insured          NUMBER (20, 2),
      for_tot_prem                 NUMBER (20, 2),
      for_tot_comm                 NUMBER (20, 2),
      for_tot_net_prem             NUMBER (20, 2),
      for_tot_ri_prem_vat          NUMBER (20, 2),
      for_tot_ri_comm_vat          NUMBER (20, 2),
      for_tot_ri_wholding_vat      NUMBER (20, 2),
      for_tot_cf_net_prem          NUMBER (20, 2),
      for_tot_balance_amt          NUMBER (20, 2),
      ri_cd                giis_reinsurer.ri_cd%TYPE , 
      line_cd              giis_line.line_cd%TYPE     
   );

   TYPE giacr106_records_tab IS TABLE OF giacr106_records_type;

   TYPE binder_dtl_type IS RECORD (
      ref_date       DATE,
      ref_no         VARCHAR2 (30),
      g_tran_id      giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      disb_amt       giac_outfacul_prem_payts.disbursement_amt%TYPE,
      tran_class     giac_acctrans.tran_class%TYPE,
      cf_disb_pyt    giac_outfacul_prem_payts.disbursement_amt%TYPE,
      cf_disb_amt2   NUMBER (20, 2),
      cf_ref_bal     NUMBER (20, 2),
      cs_disb_amt    NUMBER (20, 2),
      dummy          VARCHAR2 (3)
   );

   TYPE binder_dtl_tab IS TABLE OF binder_dtl_type;

   FUNCTION get_giacr106_records_old ( --mikel 11.23.2015; UCPBGEN 20878; backup old function
      p_ri_cd       giri_binder.ri_cd%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_date_type   VARCHAR2,
      p_date_from   DATE,
      p_date_to     DATE,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr106_records_tab PIPELINED;
      
   FUNCTION get_giacr106_records_old_v2 (   -- jhing GENQA 5270 - backup of old function 
      p_ri_cd       giri_binder.ri_cd%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_date_type   VARCHAR2,
      p_date_from   DATE,
      p_date_to     DATE,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr106_records_tab PIPELINED;   
      
   
   -- jhing GENQA 5270 - new function for the report    
   FUNCTION get_giacr106_records (
      p_ri_cd       giri_binder.ri_cd%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_date_type   VARCHAR2,
      p_date_from   DATE,
      p_date_to     DATE,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr106_records_tab PIPELINED;       


   FUNCTION get_binder_dtl (
      p_ri_cd           giri_binder.ri_cd%TYPE,
      p_line_cd         giri_binder.line_cd%TYPE,
      p_date_type       VARCHAR2,
      p_date_from       DATE,
      p_date_to         DATE,
      p_binder_id       giri_binder.fnl_binder_id%TYPE,
      p_dummy2          VARCHAR2,
      p_replaced_flag   VARCHAR2,
      p_cf_net_prem     NUMBER
   )
      RETURN binder_dtl_tab PIPELINED;
END; 
/
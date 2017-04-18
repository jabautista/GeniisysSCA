CREATE OR REPLACE PACKAGE CPI.giacr105_pkg
AS
   TYPE giacr105_records_type IS RECORD (
      cf_company           VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_basis             VARCHAR2 (150),
      cf_from_date         VARCHAR2 (50),
      cf_to_date           VARCHAR2 (50),
      ri_cd                giis_reinsurer.ri_cd%TYPE ,   -- added by jhing 01.31.2016 GENQA 5269
      ri_name              giis_reinsurer.ri_name%TYPE,
      line_cd              giis_line.line_cd%TYPE,       -- added by jhing 01.31.2016 GENQA 5269
      line_name            giis_line.line_name%TYPE,
      eff_date             giri_binder.eff_date%TYPE,
      binder               VARCHAR2 (50),
      policy_no            VARCHAR2 (100),
      issue_date           gipi_polbasic.issue_date%TYPE,
      incept_date          gipi_polbasic.eff_date%TYPE,
      invoice_no           VARCHAR2 (50),
      policy_id            VARCHAR2 (50),
      assured              giis_assured.assd_name%TYPE,     
      amt_insured          NUMBER (20, 2),      
      prem                 NUMBER (20, 2),      
      comm                 NUMBER (20, 2),      
      net_prem             NUMBER (20, 2),      
      binder_id            VARCHAR2 (50),
      ri_prem_vat          NUMBER (20, 2),      
      ri_comm_vat          NUMBER (20, 2),      
      tran_id              giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      prem_seq_no          giac_aging_ri_soa_details.prem_seq_no%TYPE,
      pol_id               gipi_polbasic.policy_id%TYPE,
      balance              NUMBER,
      -- jhing 01.31.2016 added new fields 
      ref_date             DATE,
      ref_no               VARCHAR2(100) , 
      for_tot_prem         NUMBER (20, 2),
      for_tot_amt_insured  NUMBER (20, 2),
      for_tot_net_prem     NUMBER (20, 2),
      for_tot_comm         NUMBER (20, 2),
      for_tot_ri_comm_vat  NUMBER (20, 2),
      for_tot_ri_prem_vat  NUMBER (20, 2),
      for_tot_balance      NUMBER (20, 2),
      coll_amt       giac_inwfacul_prem_collns.collection_amt%TYPE,
      tran_class     giac_acctrans.tran_class%TYPE,
      pol_flag       gipi_polbasic.pol_flag%TYPE,
      reCurPayt      VARCHAR2(1)
   );   
   
   TYPE giacr105_records_tab IS TABLE OF giacr105_records_type;
   
   TYPE binder_dtl_type IS RECORD (
      ref_date       VARCHAR2 (30),
      ref_no         VARCHAR2 (30),
      coll_amt       giac_inwfacul_prem_collns.collection_amt%TYPE,
      tran_class     giac_acctrans.tran_class%TYPE,
      pol_flag       gipi_polbasic.pol_flag%TYPE
   );
   
   TYPE binder_dtl_tab IS TABLE OF binder_dtl_type;
   
   FUNCTION get_giacr105_records (
      p_ri_cd       giri_binder.ri_cd%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_date_type   VARCHAR2,
      p_date_from   DATE,
      p_date_to     DATE
   )
      RETURN giacr105_records_tab PIPELINED;
      
   -- jhing 01.31.2016 new function for the retrieval of records - GENQA 5269
   FUNCTION get_giacr105_records_v2 (
      p_ri_cd       giri_binder.ri_cd%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_date_type   VARCHAR2,
      p_date_from   DATE,
      p_date_to     DATE,
      p_user_id     VARCHAR2,
      p_module_id   VARCHAR2
   )
      RETURN giacr105_records_tab PIPELINED;   
   
      
   FUNCTION get_binder_dtl (
      p_ri_cd           giri_binder.ri_cd%TYPE,
      p_line_cd         giri_binder.line_cd%TYPE,
      p_date_type       VARCHAR2,
      p_date_from       DATE,
      p_date_to         DATE,
      p_tran_id         giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      p_pol_id          gipi_polbasic.policy_id%TYPE,
      p_prem_seq_no     giac_aging_ri_soa_details.prem_seq_no%TYPE
   )
      RETURN binder_dtl_tab PIPELINED;
END;
/



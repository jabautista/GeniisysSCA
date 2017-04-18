CREATE OR REPLACE PACKAGE CPI.giacs251_pkg
AS

   TYPE fund_lov_type IS RECORD(
      fund_cd                 giis_funds.fund_cd%TYPE,
      fund_desc               giis_funds.fund_desc%TYPE
   );
   TYPE fund_lov_tab IS TABLE OF fund_lov_type;

   TYPE batch_type IS RECORD(
      iss_cd                  giac_comm_voucher_ext.iss_cd%TYPE, 
      intm_no                 giac_comm_voucher_ext.intm_no%TYPE,
      cv_pref                 giac_comm_voucher_ext.cv_pref%TYPE,
      cv_no                   giac_comm_voucher_ext.cv_no%TYPE,
      print_tag               giac_comm_voucher_ext.print_tag%TYPE,
      actual_comm             NUMBER,
      comm_payable            NUMBER,
      comm_paid               NUMBER,
      net_due                 NUMBER,
      intm_name               giis_intermediary.intm_name%TYPE,
      parent_intm_name        giis_intermediary.intm_name%TYPE
   );
   TYPE batch_tab IS TABLE OF batch_type;
   
   TYPE batch_dtl_type IS RECORD(
      intm_no                 giac_comm_voucher_ext.intm_no%TYPE,
      iss_cd                  giac_comm_voucher_ext.iss_cd%TYPE,
      prem_seq_no             giac_comm_voucher_ext.prem_seq_no%TYPE,
      wtax_amt                NUMBER,
      comm_paid               NUMBER,
      prem_amt                NUMBER,
      comm_amt                NUMBER,
      input_vat               NUMBER,
      cv_no                   giac_comm_voucher_ext.cv_no%TYPE,
      cv_pref                 giac_comm_voucher_ext.cv_pref%TYPE,
      actual_comm             NUMBER,
      comm_payable            NUMBER,
      policy_id               NUMBER(12),
      policy_no               VARCHAR2(100),
      intm_name               giis_intermediary.intm_name%TYPE,
      total_prem_amt          NUMBER,
      total_actual_comm       NUMBER,
      total_comm_payable      NUMBER,
      total_comm_amt          NUMBER,
      total_wtax_amt          NUMBER,
      total_input_vat_amt     NUMBER,
      pol_flag                gipi_polbasic.pol_flag%TYPE,
      pol_status              VARCHAR2(100)
   );
   TYPE batch_dtl_tab IS TABLE OF batch_dtl_type;
   
   TYPE batch_listing_type IS RECORD(
      iss_cd                  giac_comm_voucher_ext.iss_cd%TYPE,
      intm_no                 giac_comm_voucher_ext.intm_no%TYPE,
      cv_pref                 giac_comm_voucher_ext.cv_pref%TYPE,
      cv_no                   giac_comm_voucher_ext.cv_no%TYPE,
      print_tag               giac_comm_voucher_ext.print_tag%TYPE,
      actual_comm             NUMBER,
      comm_payable            NUMBER,
      comm_paid               NUMBER,
      net_due                 NUMBER,
      intm_name               giis_intermediary.intm_name%TYPE,
      parent_intm_name        giis_intermediary.intm_name%TYPE,
      generate_flag           VARCHAR2(1),
      printed_flag            VARCHAR2(1),
      tagged_actual_comm      NUMBER,
      tagged_comm_payable     NUMBER,
      tagged_comm_paid        NUMBER,
      tagged_net_due          NUMBER,
      grand_actual_comm       NUMBER,
      grand_comm_payable      NUMBER,
      grand_comm_paid         NUMBER,
      grand_net_due           NUMBER
   );
   TYPE batch_listing_tab IS TABLE OF batch_listing_type;
   
   TYPE reports_type IS RECORD(
      intm_no                 giac_comm_voucher_ext.intm_no%TYPE,
      cv_no                   giac_comm_voucher_ext.cv_no%TYPE,
      cv_pref                 giac_comm_voucher_ext.cv_pref%TYPE,
      iss_cd                  giac_comm_voucher_ext.iss_cd%TYPE
   );
   TYPE reports_tab IS TABLE OF reports_type;
   
   FUNCTION get_fund_lov(
      p_find_text             VARCHAR2
   )
     RETURN fund_lov_tab PIPELINED;
   
   FUNCTION get_batch_comm_voucher(
      p_fund_cd               giac_comm_voucher_ext.fund_cd%TYPE,
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE
   )
     RETURN batch_tab PIPELINED;
     
   FUNCTION get_batch_comm_voucher_dtl(
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE,
      p_prem_seq_no           giac_comm_voucher_ext.prem_seq_no%TYPE,
      p_prem_amt              NUMBER,
      p_actual_comm           NUMBER,
      p_comm_payable          NUMBER,
      p_comm_amt              NUMBER,
      p_wtax_amt              NUMBER,
      p_input_vat             NUMBER
   )
     RETURN batch_dtl_tab PIPELINED;
     
   PROCEDURE get_detail_totals(
      p_intm_no               IN       giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               IN       giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 IN       giac_comm_voucher_ext.cv_no%TYPE,
      p_prem_seq_no           IN       giac_comm_voucher_ext.prem_seq_no%TYPE,
      p_prem_amt              IN       NUMBER,
      p_actual_comm           IN       NUMBER,
      p_comm_payable          IN       NUMBER,
      p_comm_amt              IN       NUMBER,
      p_wtax_amt              IN       NUMBER,
      p_input_vat             IN       NUMBER,
      p_total_prem_amt        IN OUT   NUMBER,
      p_total_actual_comm     IN OUT   NUMBER,
      p_total_comm_payable    IN OUT   NUMBER,
      p_total_comm_amt        IN OUT   NUMBER,
      p_total_wtax_amt        IN OUT   NUMBER,
      p_total_input_vat_amt   IN OUT   NUMBER
   );
     
   PROCEDURE populate_batch_comm_voucher(
      p_fund_cd               giac_comm_voucher_ext.fund_cd%TYPE,
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE
   );
   
   FUNCTION get_batch_comm_voucher_listing(
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE,
      p_actual_comm           NUMBER,
      p_comm_payable          NUMBER,
      p_comm_paid             NUMBER,
      p_net_due               NUMBER,
      p_get_totals            VARCHAR2
   )
     RETURN batch_listing_tab PIPELINED;
   
   PROCEDURE get_doc_cv_seq(
      p_fund_cd         IN    giis_funds.fund_cd%TYPE,
      p_user_id         IN    giis_users.user_id%TYPE,
      p_cv_pref         OUT   giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_seq_no       OUT   giac_comm_voucher_ext.cv_no%TYPE
   );
   
   PROCEDURE update_sum_ext(
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE,
      p_bank_file_no          giac_comm_voucher_ext.bank_file_no%TYPE,
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE
   );
   
   PROCEDURE get_totals(
      p_intm_no               IN    giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               IN    giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 IN    giac_comm_voucher_ext.cv_no%TYPE,
      p_actual_comm           IN    NUMBER,
      p_comm_payable          IN    NUMBER,
      p_comm_paid             IN    NUMBER,
      p_net_due               IN    NUMBER,
      p_tagged_actual_comm    OUT   NUMBER,
      p_tagged_comm_payable   OUT   NUMBER,
      p_tagged_comm_paid      OUT   NUMBER,
      p_tagged_net_due        OUT   NUMBER,
      p_total_actual_comm     OUT   NUMBER,
      p_total_comm_payable    OUT   NUMBER,
      p_total_comm_paid       OUT   NUMBER,
      p_total_net_due         OUT   NUMBER
   );
   
   PROCEDURE clear_temp_table;
   
   PROCEDURE save_generate_flag(
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_iss_cd                giac_comm_voucher_ext.iss_cd%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE,
      p_generate_flag         VARCHAR2
   );
   
   PROCEDURE generate_cv_number(
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE
   );
   
   FUNCTION get_batch_reports
     RETURN reports_tab PIPELINED;
     
   PROCEDURE tag_all(
      p_actual_comm           NUMBER,
      p_comm_payable          NUMBER,
      p_comm_paid             NUMBER,
      p_net_due               NUMBER
    );
   
   PROCEDURE untag_all;
   
   PROCEDURE update_tags(
      p_fund_cd               giis_funds.fund_cd%TYPE,
      p_iss_cd                giac_comm_voucher_ext.iss_cd%TYPE,
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_user_id               giac_comm_voucher_ext.user_id%TYPE
   );
   
   FUNCTION check_policy_status(
      p_intm_no               giac_comm_voucher_ext.intm_no%TYPE,
      p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
      p_cv_no                 giac_comm_voucher_ext.cv_no%TYPE
   )
     RETURN VARCHAR2;
     
   -- used when module is called by GIACS158 : shan 03.25.2015 -- start - AFP SR-18481 : shan 05.21.2015
    TYPE comm_due_type IS RECORD(
        bank_file_no            GIAC_BANK_COMM_PAYT_SUM_EXT.BANK_FILE_NO%TYPE,
        cv_pref                 GIAC_BANK_COMM_PAYT_SUM_EXT.cv_pref%TYPE,
        cv_no                   GIAC_BANK_COMM_PAYT_SUM_EXT.cv_no%TYPE, 
        intm_no                 GIAC_BANK_COMM_PAYT_SUM_EXT.INTM_NO%TYPE,
        intm_name               GIIS_INTERMEDIARY.INTM_NAME%TYPE,        
        parent_intm_name        GIIS_INTERMEDIARY.INTM_NAME%TYPE,
        net_comm_due            NUMBER
    );
   
    TYPE comm_due_tab IS TABLE OF comm_due_type;
   
    FUNCTION get_comm_due_listing(
        p_bank_file_no      GIAC_BANK_COMM_PAYT_SUM_EXT.BANK_FILE_NO%TYPE
    ) RETURN comm_due_tab PIPELINED;
    
    PROCEDURE gen_cv_number_comm_due(
        p_bank_file_no          giac_bank_comm_payt_sum_ext.BANK_FILE_NO%TYPE,
        p_intm_no               GIAC_BANK_COMM_PAYT_SUM_EXT.INTM_NO%TYPE,
        p_cv_pref               giac_comm_voucher_ext.cv_pref%TYPE,
        p_cv_no        IN OUT   giac_comm_voucher_ext.cv_no%TYPE
    );
    
    TYPE comm_due_dtl_type IS RECORD(
        bank_file_no            GIAC_BANK_COMM_PAYT_SUM_EXT.BANK_FILE_NO%TYPE,
        cv_pref                 GIAC_BANK_COMM_PAYT_SUM_EXT.cv_pref%TYPE,
        cv_no                   GIAC_BANK_COMM_PAYT_SUM_EXT.cv_no%TYPE, 
        intm_no                 GIAC_BANK_COMM_PAYT_SUM_EXT.INTM_NO%TYPE,
        intm_name               GIIS_INTERMEDIARY.INTM_NAME%TYPE,   
        policy_id               giac_bank_comm_payt_sum_ext.POLICY_ID%TYPE,
        iss_cd                  giac_bank_comm_payt_sum_ext.ISS_CD%TYPE,
        prem_seq_no             giac_bank_comm_payt_sum_ext.PREM_SEQ_NO%TYPE,
        policy_no               VARCHAR2(100),
        premium_paid            NUMBER(17,2),
        commission_due          NUMBER(17,2),
        wholding_tax_due        NUMBER(17,2),
        input_vat_due           NUMBER(17,2),
        net_comm_due            NUMBER(17,2),
        inv_comm_amt            NUMBER(17,2),
        inv_whtax_amt           NUMBER(17,2),
        inv_input_vat           NUMBER(17,2),
        net_comm_paid           NUMBER(17,2)
    );
   
    TYPE comm_due_dtl_tab IS TABLE OF comm_due_dtl_type;
   
    FUNCTION get_comm_due_dtl(
        p_intm_no      GIAC_BANK_COMM_PAYT_SUM_EXT.INTM_NO%TYPE
    ) RETURN comm_due_dtl_tab PIPELINED;
    
    PROCEDURE update_comm_due_tags(
        p_fund_cd               giis_funds.fund_cd%TYPE,
        p_bank_file_no          GIAC_BANK_COMM_PAYT_SUM_EXT.BANK_FILE_NO%TYPE,
        p_intm_no               GIAC_BANK_COMM_PAYT_SUM_EXT.intm_no%TYPE,
        p_cv_no                 GIAC_BANK_COMM_PAYT_SUM_EXT.cv_no%TYPE,
        p_cv_pref               GIAC_BANK_COMM_PAYT_SUM_EXT.cv_pref%TYPE,
        p_user_id               giac_comm_voucher_ext.user_id%TYPE,
        p_to_revert             VARCHAR2
    );
    -- end - AFP SR-18481 : shan 05.21.2015
END;
/

CREATE OR REPLACE PACKAGE CPI.giacr409_pkg
AS
   TYPE giacr409_type IS RECORD (
      company_name      VARCHAR2 (300),
      company_address   VARCHAR2 (500),
      flag              VARCHAR2 (2),
      as_of             VARCHAR2 (100),
      branch            VARCHAR2 (100),
      line_name         VARCHAR2 (30),
      trans_date        DATE,
      bill_no           VARCHAR2 (50),
      booking_month     VARCHAR2 (20),
--      tran_no           giac_prev_comm_inv.tran_no%TYPE,
--        prev_intm           GIAC_PREV_COMM_INV.intm_no%TYPE,
--        prev_share          GIAC_PREV_COMM_INV.share_percentage%TYPE,
--        prev_intm_name      GIIS_INTERMEDIARY.intm_name%TYPE,
      comm_rec_id       giac_prev_comm_inv.comm_rec_id%TYPE,
      status            giac_new_comm_inv.tran_flag%TYPE,
      modified_by       giac_new_comm_inv.user_id%TYPE,
--        new_intm            GIAC_NEW_COMM_INV.intm_no%TYPE,
--        new_share           GIAC_NEW_COMM_INV.share_percentage%TYPE,
--        new_intm_name       GIIS_INTERMEDIARY.intm_name%TYPE,
      line_cd           gipi_polbasic.line_cd%TYPE,
      policy_id         giac_new_comm_inv.policy_id%TYPE,
      iss_cd            giac_new_comm_inv.iss_cd%TYPE,
      prem_seq_no       giac_new_comm_inv.prem_seq_no%TYPE,
      sum_prem_prev     giac_prev_comm_inv_peril.premium_amt%TYPE,
      sum_comm_prev     giac_prev_comm_inv_peril.commission_amt%TYPE,
      sum_wtax_prev     giac_prev_comm_inv_peril.wholding_tax%TYPE,
      sum_prem_new      giac_prev_comm_inv_peril.premium_amt%TYPE,
      sum_comm_new      giac_prev_comm_inv_peril.commission_amt%TYPE,
      sum_wtax_new      giac_prev_comm_inv_peril.wholding_tax%TYPE,
      v_coll_index      NUMBER
   );

   TYPE giacr409_tab IS TABLE OF giacr409_type;

   TYPE main_new_comm_type IS RECORD (
      comm_rec_id     giac_prev_comm_inv.comm_rec_id%TYPE,
      new_intm        giac_new_comm_inv.intm_no%TYPE,
      new_share       giac_new_comm_inv.share_percentage%TYPE,
      new_intm_name   giis_intermediary.intm_name%TYPE,
      line_cd         gipi_polbasic.line_cd%TYPE,
      policy_id       giac_new_comm_inv.policy_id%TYPE
   );

   TYPE main_new_comm_tab IS TABLE OF main_new_comm_type;

   TYPE main_prev_comm_type IS RECORD (
      comm_rec_id      giac_prev_comm_inv.comm_rec_id%TYPE,
      tran_no          giac_prev_comm_inv.tran_no%TYPE,
      prev_intm        giac_prev_comm_inv.intm_no%TYPE,
      prev_share       giac_prev_comm_inv.share_percentage%TYPE,
      prev_intm_name   giis_intermediary.intm_name%TYPE
   );

   TYPE main_prev_comm_tab IS TABLE OF main_prev_comm_type;

   TYPE prev_comm_type IS RECORD (
      prev_intm        giac_prev_comm_inv.intm_no%TYPE,
      comm_rec_id      giac_prev_comm_inv_peril.comm_rec_id%TYPE,
      peril_cd         giac_prev_comm_inv_peril.peril_cd%TYPE,
      prev_intm_name   giis_intermediary.intm_name%TYPE,
      prev_share       giac_prev_comm_inv.share_percentage%TYPE,
      peril_name       VARCHAR2 (20),
      prem_prl         giac_prev_comm_inv_peril.premium_amt%TYPE,
      commission_rt    giac_prev_comm_inv_peril.commission_rt%TYPE,
      comm_prl         giac_prev_comm_inv_peril.commission_amt%TYPE,
      wtax_prl         giac_prev_comm_inv_peril.wholding_tax%TYPE,
      sum_prem_amt     giac_prev_comm_inv_peril.premium_amt%TYPE
   );

   TYPE prev_comm_tab IS TABLE OF prev_comm_type;

   TYPE new_comm_type IS RECORD (
      new_share       giac_new_comm_inv.share_percentage%TYPE,
      peril_name      VARCHAR2 (20),
      prem_prl        giac_new_comm_inv_peril.premium_amt%TYPE,
      commission_rt   giac_new_comm_inv_peril.commission_rt%TYPE,
      comm_prl        giac_new_comm_inv_peril.commission_amt%TYPE,
      wtax_prl        giac_new_comm_inv_peril.wholding_tax%TYPE
   );

   TYPE new_comm_tab IS TABLE OF new_comm_type;

   TYPE taken_comm_type IS RECORD (
      flag              VARCHAR2 (2),
      gl_account_code   VARCHAR2 (50),
      gl_acct_name      giac_chart_of_accts.gl_acct_name%TYPE,
      debit_amt         giac_acct_entries.debit_amt%TYPE,
      credit_amt        giac_acct_entries.credit_amt%TYPE,
      sl_cd             giac_acct_entries.sl_cd%TYPE
   );

   TYPE taken_comm_tab IS TABLE OF taken_comm_type;

   TYPE new_commissions_type IS RECORD (
      flag              VARCHAR2 (2),
      gl_account_code   VARCHAR2 (50),
      gl_acct_name      giac_chart_of_accts.gl_acct_name%TYPE,
      debit_amt         giac_acct_entries.debit_amt%TYPE,
      credit_amt        giac_acct_entries.credit_amt%TYPE,
      sl_cd             giac_acct_entries.sl_cd%TYPE
   );

   TYPE new_commissions_tab IS TABLE OF new_commissions_type;

   FUNCTION populate_giacr409 (
      p_branch_type   VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_flag          VARCHAR2,
      p_fr_date       VARCHAR2,
      p_to_date       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_prem_seq_no   NUMBER,
      p_tran_no       VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN giacr409_tab PIPELINED;

   FUNCTION get_main_new_comm (
      p_branch_type   VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_flag          VARCHAR2,
      p_fr_date       VARCHAR2,
      p_to_date       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_prem_seq_no   NUMBER,
      p_tran_no       VARCHAR2,
      p_user_id       VARCHAR2,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE
   )
      RETURN main_new_comm_tab PIPELINED;

   FUNCTION get_main_prev_comm (
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE
   )
      RETURN main_prev_comm_tab PIPELINED;

   FUNCTION get_prev_comm_invoice (
      p_tran_no       giac_prev_comm_inv.tran_no%TYPE,
      p_prev_intm     giac_prev_comm_inv.intm_no%TYPE,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE,
      p_policy_id     giac_new_comm_inv.policy_id%TYPE,
      p_prev_share    giac_prev_comm_inv.share_percentage%TYPE
   )
      RETURN prev_comm_tab PIPELINED;

   FUNCTION get_new_comm_invoice (
      p_iss_cd        giac_new_comm_inv_peril.iss_cd%TYPE,
      p_prem_seq_no   giac_new_comm_inv_peril.prem_seq_no%TYPE,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE,
      p_new_intm      giac_new_comm_inv.intm_no%TYPE,
      p_new_share     giac_new_comm_inv.share_percentage%TYPE,
      p_policy_id     giac_new_comm_inv.policy_id%TYPE
   )
      RETURN new_comm_tab PIPELINED;

   FUNCTION get_taken_comm (
      p_fr_date   VARCHAR2,
      p_to_date   VARCHAR2,
      p_branch    giac_acctrans.gibr_branch_cd%TYPE,
   --added by steven 12.03.2014
      p_line_cd         VARCHAR2,   -- added by shan 02.11.2015
      p_flag            VARCHAR2
   )
      RETURN taken_comm_tab PIPELINED;

   FUNCTION get_new_comm (
      p_fr_date   VARCHAR2,
      p_to_date   VARCHAR2,
      p_branch    giac_acctrans.gibr_branch_cd%TYPE,
   --added by steven 12.03.2014
      p_line_cd         VARCHAR2,   -- added by shan 02.11.2015
      p_flag            VARCHAR2
   )
      RETURN new_commissions_tab PIPELINED;

   FUNCTION get_sum_prem_prev (
      p_comm_rec_id   giac_prev_comm_inv_peril.comm_rec_id%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_sum_comm_prev (
      p_comm_rec_id   giac_prev_comm_inv_peril.comm_rec_id%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_sum_wtax_prev (
      p_comm_rec_id   giac_prev_comm_inv_peril.comm_rec_id%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_sum_prem_new (
      p_branch_type   VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_flag          VARCHAR2,
      p_fr_date       VARCHAR2,
      p_to_date       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_prem_seq_no   NUMBER,
      p_tran_no       VARCHAR2,
      p_user_id       VARCHAR2,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_sum_comm_new (
      p_branch_type   VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_flag          VARCHAR2,
      p_fr_date       VARCHAR2,
      p_to_date       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_prem_seq_no   NUMBER,
      p_tran_no       VARCHAR2,
      p_user_id       VARCHAR2,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_sum_wtax_new (
      p_branch_type   VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_flag          VARCHAR2,
      p_fr_date       VARCHAR2,
      p_to_date       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_prem_seq_no   NUMBER,
      p_tran_no       VARCHAR2,
      p_user_id       VARCHAR2,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE
   )
      RETURN NUMBER;
   
    v_bill_list      CLOB;
       
    TYPE bill_no_type IS RECORD(
        iss_cd          giac_new_comm_inv.ISS_CD%type,
        prem_seq_no     giac_new_comm_inv.PREM_SEQ_NO%type
    );
    
    TYPE bill_no_tab IS TABLE OF bill_no_type;
    
    FUNCTION extract_bill_from_list
        RETURN bill_no_tab PIPELINED;
        
END giacr409_pkg;
/



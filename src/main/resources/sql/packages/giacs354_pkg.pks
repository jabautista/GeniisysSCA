CREATE OR REPLACE PACKAGE CPI.giacs354_pkg
AS
/* Created by Mikel 07.05.2013
** To automate EOM reconcilation of GL vs UW reports and GL vs Outstanding Loss
*/

   /* Modified by Mikel 01.15.2014
   ** Added functions for UW and OF details (per policy) recon
   */

   /* Modified by Mikel 02.11.2014
   ** Added function for EVAT recon
   */
   TYPE giacr354_rec_type IS RECORD (
      branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
      line_cd          giis_line.line_cd%TYPE,
      gl_acct_no       VARCHAR2 (30),
      gl_acct_name     giac_chart_of_accts.gl_acct_name%TYPE,
      acct_trty_type   giis_dist_share.acct_trty_type%TYPE,
      base_amt         VARCHAR2 (50),
      gl_amount        giac_acct_entries.debit_amt%TYPE,
      uw_amount        giac_acct_entries.debit_amt%TYPE,
      variances        giac_acct_entries.debit_amt%TYPE
   );

   TYPE giacr354_type IS TABLE OF giacr354_rec_type;

   TYPE giacr354_gl_rec_type IS RECORD (
      gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      line_cd          giis_line.line_cd%TYPE,
      gl_acct_no       VARCHAR2 (30),
      gl_acct_name     giac_chart_of_accts.gl_acct_name%TYPE,
      tran_id          giac_acctrans.tran_id%TYPE,
      tran_class       giac_acctrans.tran_class%TYPE,
      balance          giac_acct_entries.debit_amt%TYPE,
      acct_trty_type   giis_dist_share.acct_trty_type%TYPE
   );

   TYPE giacr354_gl_type IS TABLE OF giacr354_gl_rec_type;

   TYPE giacr354_tb_reg_rec_type IS RECORD (
      gl_acct_no     VARCHAR2 (30),
      gl_acct_name   giac_chart_of_accts.gl_acct_name%TYPE,
      cash_reg_dr    giac_acct_entries.debit_amt%TYPE,
      cash_reg_cr    giac_acct_entries.credit_amt%TYPE,
      disb_reg_dr    giac_acct_entries.debit_amt%TYPE,
      disb_reg_cr    giac_acct_entries.credit_amt%TYPE,
      jv_reg_dr      giac_acct_entries.debit_amt%TYPE,
      jv_reg_cr      giac_acct_entries.credit_amt%TYPE,
      tb_debit       giac_acct_entries.debit_amt%TYPE,
      tb_credit      giac_acct_entries.credit_amt%TYPE,
      variances      giac_acct_entries.debit_amt%TYPE
   );

   TYPE giacr354_tb_reg_type IS TABLE OF giacr354_tb_reg_rec_type;

   --added rec type for bordereaux by MAC 07/19/2013
   TYPE giacr354_brdrx_rec_type IS RECORD (
      branch_cd      giac_acctrans.gibr_branch_cd%TYPE,
      line_cd        giis_line.line_cd%TYPE,
      gl_acct_no     VARCHAR2 (30),
      gl_acct_name   giac_chart_of_accts.gl_acct_name%TYPE,
      base_amt       VARCHAR2 (50),
      gl_amount      giac_acct_entries.debit_amt%TYPE,
      brdrx_amount   giac_acct_entries.debit_amt%TYPE,
      variances      giac_acct_entries.debit_amt%TYPE
   );

   TYPE giacr354_brdrx_reg_type IS TABLE OF giacr354_brdrx_rec_type;

   --mikel 03.19.2014
   TYPE giacr354_brdrx_dtl_rec_type IS RECORD (
      line_cd        giis_line.line_cd%TYPE,
      claim_no       VARCHAR2 (100),
      claim_id       gicl_claims.claim_id%TYPE,
      item_no        NUMBER (9),
      peril_cd       NUMBER (5),
      base_amt       VARCHAR2 (50),
      gl_amount      giac_acct_entries.debit_amt%TYPE,
      brdrx_amount   giac_acct_entries.debit_amt%TYPE,
      variances      giac_acct_entries.debit_amt%TYPE
   );

   TYPE giacr354_brdrx_dtl_type IS TABLE OF giacr354_brdrx_dtl_rec_type;

   --added by mikel; 01.15.2014
   TYPE giacr354_dtl_rec_type IS RECORD (
      branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
      line_cd          giis_line.line_cd%TYPE,
      policy_id        gipi_invoice.policy_id%TYPE,
      policy_no        VARCHAR2 (50),
      pol_flag         VARCHAR2 (20),
      binder_no        VARCHAR2 (50),
      dist_no          giuw_pol_dist.dist_no%TYPE,
      acct_trty_type   giis_dist_share.acct_trty_type%TYPE,
      base_amt         VARCHAR2 (50),
      gl_amount        giac_acct_entries.debit_amt%TYPE,
      uw_amount        giac_acct_entries.debit_amt%TYPE,
      variances        giac_acct_entries.debit_amt%TYPE
   );

   TYPE giacr354_dtl_type IS TABLE OF giacr354_dtl_rec_type;

   --added by mikel; 02.11.2014
   TYPE giacr354_tax_rec_type IS RECORD (
      reference_no   VARCHAR2 (60),
      tran_id        giuw_pol_dist.dist_no%TYPE,
      gl_amount      giac_acct_entries.debit_amt%TYPE,
      tax_amount     giac_acct_entries.debit_amt%TYPE,
      variances      giac_acct_entries.debit_amt%TYPE
   );

   TYPE giacr354_tax_type IS TABLE OF giacr354_tax_rec_type;

   FUNCTION select_gl_branch_line (
      p_module        VARCHAR2,
      p_item_no       NUMBER,
      p_tran_class    VARCHAR2,
      p_break_by      VARCHAR2,
      p_date_option   VARCHAR2,
      --T=Transaction Date or P=Posting Date by MAC 07/16/2013
      p_from_date     DATE,          --added for Losses Paid by MAC 07/16/2013
      p_to_date       DATE           --added for Losses Paid by MAC 07/16/2013
   )
      RETURN giacr354_gl_type PIPELINED;

   FUNCTION giacr354_prd (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_type PIPELINED;

   --mikel 03.17.2014
   FUNCTION giacr354_prd_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_dtl_type PIPELINED;

   FUNCTION giacr354_uw (p_from_date DATE, p_to_date DATE, p_post_tran VARCHAR2)
      RETURN giacr354_type PIPELINED;

   FUNCTION giacr354_uw_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_dtl_type PIPELINED;

   FUNCTION giacr354_of (p_from_date DATE, p_to_date DATE, p_post_tran VARCHAR2)
      RETURN giacr354_type PIPELINED;

   FUNCTION giacr354_of_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_dtl_type PIPELINED;

   FUNCTION giacr354_inf (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_type PIPELINED;

   --mikel 03.17.2014
   FUNCTION giacr354_inf_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_dtl_type PIPELINED;

   FUNCTION giacr354_ol (p_from_date DATE, p_to_date DATE, p_post_tran VARCHAR2)
      RETURN giacr354_brdrx_reg_type PIPELINED;

   FUNCTION giacr354_ol_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_brdrx_dtl_type PIPELINED;

   --added function for Losses Paid by MAC 07/19/2013.
   FUNCTION giacr354_clm_payt (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_brdrx_reg_type PIPELINED;

   --mikel 05.13.2014
   FUNCTION giacr354_clm_payt_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN giacr354_brdrx_dtl_type PIPELINED;

   --   FUNCTION giacr354_tb (p_mm NUMBER, p_year NUMBER)
--      RETURN giacr354_tb_reg_type PIPELINED;

   --   FUNCTION giacr354_evat (
--      p_post_tran   VARCHAR2,
--      p_from_date   DATE,
--      p_to_date     DATE
--   )
--      RETURN giacr354_tax_type PIPELINED;

   --   TYPE tran_class_rec_type IS RECORD (
--      rv_low_value   cg_ref_codes.rv_low_value%TYPE,
--      rv_meaning     cg_ref_codes.rv_meaning%TYPE
--   );

   --   TYPE tran_class_type IS TABLE OF tran_class_rec_type;

   --   FUNCTION get_tran_class_lov
--      RETURN tran_class_type PIPELINED;

   --   FUNCTION validate_tran_date (
--      p_mm                 NUMBER,
--      p_yyyy               NUMBER,
--      p_tran_class         cg_ref_codes.rv_low_value%TYPE,
--      p_user_id            giis_users.user_id%TYPE,
--      p_message      OUT   VARCHAR2
--   )
--      RETURN BOOLEAN;

   --created function to check if GL of Treaty and XOL is the same by MAC 07/16/2013.
   FUNCTION is_gl_treaty_xol_same (
      p_module_id     VARCHAR2,
      p_treaty_item   NUMBER,
      p_xol_item      NUMBER
   )
      RETURN NUMBER;

   --mikel 03.06.2014
   PROCEDURE extract_gross_prem (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   );

   --mikel 03.17.2014
   PROCEDURE extract_gross_prem_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   );

   --mikel 03.14.2014
   PROCEDURE extract_treaty_prem (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   );

   --mikel 03.14.2014
   PROCEDURE extract_facul_prem (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   );

   --mikel 03.14.2014
   PROCEDURE extract_facul_prem_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   );

   --mikel 03.17.2014
   PROCEDURE extract_treaty_prem_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   );

   --mikel 03.19.2014
   PROCEDURE extract_os_loss (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   );

   --mikel 03.19.2014
   PROCEDURE extract_os_loss_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   );

   --mikel 05.09.2014
   PROCEDURE extract_losses_paid (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   );

   --mikel 05.13.2014
   PROCEDURE extract_losses_paid_dtl (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   );
END;
/



CREATE OR REPLACE PACKAGE CPI.gicls261_pkg
AS
/* Created by : Aliza Garza
 * Date Created: 06.04.2013
 * Reference By: GICLS261 - Claim Payment Inquiry
 * Description: Package for Claim Payment Queries
 *
*/
   TYPE clm_payment_type IS RECORD (
      claim_id         gicl_claims.claim_id%TYPE,
      advice_id        gicl_clm_loss_exp.advice_id%TYPE,
      clm_loss_id      gicl_clm_loss_exp.clm_loss_id%TYPE,
      item_no          gicl_clm_loss_exp.item_no%TYPE,
      item_title       gicl_clm_item.item_title%TYPE,
      peril_cd         gicl_clm_loss_exp.peril_cd%TYPE,
      peril_sname      giis_peril.peril_sname%TYPE,
      payee_type       gicl_clm_loss_exp.payee_type%TYPE,
      payee_class_cd   gicl_clm_loss_exp.payee_class_cd%TYPE,
      payee_cd         gicl_clm_loss_exp.payee_cd%TYPE,
      payee_name       VARCHAR2 (560),
      tran_date        gicl_clm_loss_exp.tran_date%TYPE,
      net_amt          gicl_clm_loss_exp.net_amt%TYPE,
      paid_amt         gicl_clm_loss_exp.paid_amt%TYPE,
      tran_id          gicl_clm_loss_exp.tran_id%TYPE,
      item             VARCHAR2(100),
      peril            VARCHAR2(200),
      payee            VARCHAR2(500)
      
   );

   TYPE clm_payment_tab IS TABLE OF clm_payment_type;

   TYPE clm_payment_adv_type IS RECORD (
      tran_id              gicl_clm_loss_exp.tran_id%TYPE,                                  
      advice_no            VARCHAR2 (20),
      refcheck_no          VARCHAR2 (50),
      ref_no               VARCHAR2 (50),
      csr_no               VARCHAR2 (50),
      batch_no             VARCHAR (50),
      particulars          VARCHAR (1000),
      date_paid            DATE,
      ref_date             DATE,
      chck_date            DATE,
      check_pref_suf       giac_chk_release_info.check_pref_suf%TYPE,
      check_no             giac_chk_release_info.check_no%TYPE,
      check_release_date   giac_chk_release_info.check_release_date%TYPE,
      check_released_by    giac_chk_release_info.check_released_by%TYPE,
      user_id              giac_chk_release_info.user_id%TYPE,
      check_received_by    giac_chk_release_info.check_received_by%TYPE,
      or_no                giac_chk_release_info.or_no%TYPE,
      or_date              giac_chk_release_info.or_date%TYPE,
      last_update          giac_chk_release_info.last_update%TYPE
   );

   TYPE clm_payment_adv_tab IS TABLE OF clm_payment_adv_type;

   TYPE clmpol_lov_type IS RECORD (
      --added by MarkS SR-5833 11.9.2016 optimization
      count_                NUMBER,
      rownum_               NUMBER,
      --end
      claim_id        gicl_claims.claim_id%TYPE,
      line_cd         gicl_claims.line_cd%TYPE,
      subline_cd      gicl_claims.subline_cd%TYPE,
      iss_cd          gicl_claims.iss_cd%TYPE,
      clm_yy          gicl_claims.clm_yy%TYPE,
      clm_seq_no      gicl_claims.clm_seq_no%TYPE,
      issue_yy        gicl_claims.issue_yy%TYPE,
      pol_iss_cd      gicl_claims.pol_iss_cd%TYPE,
      pol_seq_no      gicl_claims.pol_seq_no%TYPE,
      renew_no        gicl_claims.renew_no%TYPE,
      dsp_loss_date   gicl_claims.loss_date%TYPE,
      assd_name       giis_assured.assd_name%TYPE,
      clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      loss_cat_des    giis_loss_ctgry.loss_cat_des%TYPE,
      item             VARCHAR2(100),
      peril            VARCHAR2(100),
      payee            VARCHAR2(300)
   );

   TYPE clmpol_lov_tab IS TABLE OF clmpol_lov_type;

   TYPE clmline_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE clmline_lov_tab IS TABLE OF clmline_lov_type;

   TYPE clmsubline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE,
      line_cd        giis_subline.line_cd%TYPE --added by John Dolon 7.10.2013
   );

   TYPE clmsubline_lov_tab IS TABLE OF clmsubline_lov_type;

   TYPE clmisscd_lov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE clmisscd_lov_tab IS TABLE OF clmisscd_lov_type;
   
   TYPE policy_lov_type IS RECORD (
      line_cd         gicl_claims.line_cd%TYPE,
      subline_cd      gicl_claims.subline_cd%TYPE,
      pol_iss_cd          gicl_claims.iss_cd%TYPE,
      issue_yy        NUMBER(10),
      pol_seq_no      NUMBER(10),
      renew_no        NUMBER(10),
      policy_no       VARCHAR2(50),
      assured_name    gicl_claims.assured_name%TYPE
   );

   TYPE policy_lov_tab IS TABLE OF policy_lov_type;
   
   TYPE check_release_type IS RECORD (
        tran_id             giac_chk_release_info.gacc_tran_id%TYPE,
        check_pref_suf      giac_chk_release_info.check_pref_suf%TYPE,
        check_no            giac_chk_release_info.check_no%TYPE,
        check_release_date  giac_chk_release_info.check_release_date%TYPE,
        check_released_by   giac_chk_release_info.check_released_by%TYPE,
        check_received_by   giac_chk_release_info.check_received_by%TYPE,
        or_no               giac_chk_release_info.or_no%TYPE,
        or_date             giac_chk_release_info.or_date%TYPE,
        last_update         giac_chk_release_info.last_update%TYPE
   );

   TYPE check_release_tab IS TABLE OF check_release_type;
   
   FUNCTION check_release_info (p_tran_id VARCHAR2)
      RETURN check_release_tab PIPELINED;
   
   FUNCTION get_policy_lov (
      p_module_id    VARCHAR2,
      p_userid       VARCHAR2,
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   gicl_claims.clm_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE
   )
      RETURN policy_lov_tab PIPELINED;

   FUNCTION get_clm_payment (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN clm_payment_tab PIPELINED;

   FUNCTION get_clm_adv (p_advice_id gicl_clm_loss_exp.advice_id%TYPE, p_clm_loss_id gicl_clm_loss_exp.clm_loss_id%TYPE)
      RETURN clm_payment_adv_tab PIPELINED;

   FUNCTION get_clmpol_lov (
      p_module_id    VARCHAR2,
      p_userid       VARCHAR2,
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_pol_iss_cd   gicl_claims.iss_cd%TYPE,
      p_clm_yy       gicl_claims.issue_yy%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_clm_seq_no   gicl_claims.clm_seq_no%TYPE,
      p_pol_seq_no   gicl_claims.clm_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE,
      p_claim_id     gicl_claims.claim_id%TYPE,
      --added by MarkS SR-5833 11.9.2016 optimization
      p_find_text            VARCHAR2,
      p_order_by             VARCHAR2,
      p_asc_desc_flag      VARCHAR2,
      p_from                 NUMBER,
      p_to                   NUMBER,
      p_clm_line_cd        VARCHAR2,
      p_clm_subline_cd     VARCHAR2,
      p_assured_name       VARCHAR2
      --end
   )
      RETURN clmpol_lov_tab PIPELINED;

   FUNCTION get_clmline_lov (p_module_id VARCHAR2, p_userid VARCHAR2, p_line_cd VARCHAR2)
      RETURN clmline_lov_tab PIPELINED;

   FUNCTION get_clmsubline_lov (p_module_id VARCHAR2, p_userid VARCHAR2, p_line_cd giis_line.line_cd%TYPE, p_subline_cd giis_subline.subline_cd%TYPE)
      RETURN clmsubline_lov_tab PIPELINED;

   FUNCTION get_clmisscd_lov (p_module_id VARCHAR2, p_userid VARCHAR2, p_iss_cd giis_issource.iss_cd%TYPE, p_line_cd VARCHAR2)
      RETURN clmisscd_lov_tab PIPELINED;
   
   --added by john dolon 7.19.2013   
   FUNCTION validate_entries(
        p_line_cd       VARCHAR2,
        p_subline_cd    VARCHAR2,
        p_clmline_cd    VARCHAR2,
        p_clmsubline_cd VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_pol_iss_cd    VARCHAR2,
        p_clm_yy        VARCHAR2,
        p_issue_yy      VARCHAR2,
        p_clm_seq_no    VARCHAR2,
        p_pol_seq_no    VARCHAR2,
        p_renew_no      VARCHAR2
    )
    RETURN VARCHAR2;
    
END;
/

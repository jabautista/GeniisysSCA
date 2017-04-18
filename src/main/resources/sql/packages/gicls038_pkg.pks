CREATE OR REPLACE PACKAGE CPI.gicls038_pkg
AS
   TYPE reserve_type IS RECORD (
      claim_no          VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      item_no           gicl_clm_res_hist.item_no%TYPE,
      peril_cd          gicl_clm_res_hist.peril_cd%TYPE,
      dsp_peril_sname   VARCHAR2 (500),
      loss_reserve      gicl_clm_res_hist.loss_reserve%TYPE,
      expense_reserve   gicl_clm_res_hist.expense_reserve%TYPE,
      line_cd           gicl_claims.line_cd%TYPE,
      subline_cd        gicl_claims.subline_cd%TYPE,
      issue_yy          gicl_claims.issue_yy%TYPE,
      pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      renew_no          gicl_claims.renew_no%TYPE,
      pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
      clm_yy            gicl_claims.clm_yy%TYPE,
      clm_seq_no        gicl_claims.clm_seq_no%TYPE,
      iss_cd            gicl_claims.iss_cd%TYPE,
      claim_id          gicl_claims.claim_id%TYPE,
      loss_date         gicl_claims.loss_date%TYPE,
      grouped_item_no   gicl_clm_res_hist.grouped_item_no%TYPE,
      currency_cd       gicl_clm_res_hist.currency_cd%TYPE,
      convert_rate      gicl_clm_res_hist.convert_rate%TYPE,
      catastrophic_cd   gicl_claims.catastrophic_cd%TYPE,
      clm_file_date     gicl_claims.clm_file_date%TYPE
   );

   TYPE reserve_tab IS TABLE OF reserve_type;

   FUNCTION get_reserve_list (
      p_line_cd   gicl_claims.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN reserve_tab PIPELINED;

   TYPE lossexpense_type IS RECORD (
      claim_no          VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      hist_seq_no       gicl_clm_loss_exp.hist_seq_no%TYPE,
      item_stat_cd      gicl_clm_loss_exp.item_stat_cd%TYPE,
      item_no           gicl_clm_loss_exp.item_no%TYPE,
      grouped_item_no   gicl_clm_loss_exp.grouped_item_no%TYPE,
      peril_cd          gicl_clm_loss_exp.peril_cd%TYPE,
      dsp_peril_sname   VARCHAR2 (500),
      currency_cd       gicl_clm_loss_exp.currency_cd%TYPE,
      currency_rate     gicl_clm_loss_exp.currency_rate%TYPE,
      payee_type        gicl_clm_loss_exp.payee_type%TYPE,
      payee_cd          gicl_clm_loss_exp.payee_cd%TYPE,
      dsp_payee_name    VARCHAR2 (500),
      paid_amt          gicl_clm_loss_exp.paid_amt%TYPE,
      net_amt           gicl_clm_loss_exp.net_amt%TYPE,
      advise_amt        gicl_clm_loss_exp.advise_amt%TYPE,
      line_cd           gicl_claims.line_cd%TYPE,
      subline_cd        gicl_claims.subline_cd%TYPE,
      issue_yy          gicl_claims.issue_yy%TYPE,
      pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      renew_no          gicl_claims.renew_no%TYPE,
      pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
      clm_yy            gicl_claims.clm_yy%TYPE,
      clm_seq_no        gicl_claims.clm_seq_no%TYPE,
      iss_cd            gicl_claims.iss_cd%TYPE,
      claim_id          gicl_claims.claim_id%TYPE,
      clm_loss_id       gicl_clm_loss_exp.clm_loss_id%TYPE,
      loss_date         gicl_claims.loss_date%TYPE,
      eff_date          gicl_claims.pol_eff_date%TYPE,
      expiry_date       gicl_claims.expiry_date%TYPE,
      catastrophic_cd   gicl_claims.catastrophic_cd%TYPE,
      dist_rg           VARCHAR2 (1),
      clm_file_date     gicl_claims.clm_file_date%TYPE
   );

   TYPE lossexpense_tab IS TABLE OF lossexpense_type;

   FUNCTION get_lossexpense_list (
      p_line_cd   gicl_claims.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN lossexpense_tab PIPELINED;

   TYPE subline_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_tab IS TABLE OF subline_type;

   FUNCTION get_subline_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN subline_tab PIPELINED;

   TYPE branch_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE branch_tab IS TABLE OF branch_type;

   FUNCTION get_branch_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN branch_tab PIPELINED;
END;
/



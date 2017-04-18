CREATE OR REPLACE PACKAGE CPI.gicl_claims_hist_pkg
AS
   TYPE gicl_clm_item_reserve_type IS RECORD (
      claim_id          gicl_claims.claim_id%TYPE,
      grouped_item_no   gicl_clm_reserve.grouped_item_no%TYPE,
      item_no           gicl_clm_reserve.item_no%TYPE,
      item_title        gipi_item.item_title%TYPE,
      peril_cd          gicl_clm_reserve.peril_cd%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      loss_reserve      gicl_clm_reserve.loss_reserve%TYPE,
      expense_reserve   gicl_clm_reserve.expense_reserve%TYPE
   );

   TYPE gicl_clm_item_reserve_tab IS TABLE OF gicl_clm_item_reserve_type;

   FUNCTION get_claim_item_reserve (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN gicl_clm_item_reserve_tab PIPELINED;

   TYPE gicl_clm_loss_exp_type IS RECORD (
      claim_id         gicl_claims.claim_id%TYPE,
      grouped_item_no   gicl_clm_reserve.grouped_item_no%TYPE,
      item_no           gicl_clm_reserve.item_no%TYPE,
      peril_cd          gicl_clm_reserve.peril_cd%TYPE,
      hist_seq_no      gicl_clm_loss_exp.hist_seq_no%TYPE,
      item_stat_cd     gicl_clm_loss_exp.item_stat_cd%TYPE,
      dist_sw          gicl_clm_loss_exp.dist_sw%TYPE,
      paid_amt         gicl_clm_loss_exp.paid_amt%TYPE,
      net_amt          gicl_clm_loss_exp.net_amt%TYPE,
      advise_amt       gicl_clm_loss_exp.advise_amt%TYPE,
      payee_type       gicl_loss_exp_payees.payee_type%TYPE,
      payee_class_cd   gicl_loss_exp_payees.payee_class_cd%TYPE,
      payee_cd         gicl_loss_exp_payees.payee_cd%TYPE,
      payee_name       VARCHAR(2000)
   );

   TYPE gicl_clm_loss_exp_tab IS TABLE OF gicl_clm_loss_exp_type;

   FUNCTION get_claim_loss_exp_hist (
      p_claim_id          gicl_claims.claim_id%TYPE,
      p_item_no           gicl_clm_reserve.item_no%TYPE,
      p_peril_cd          gicl_clm_reserve.peril_cd%TYPE,
      p_grouped_item_no   gicl_clm_reserve.grouped_item_no%TYPE
   )
      RETURN gicl_clm_loss_exp_tab PIPELINED;
END;
/



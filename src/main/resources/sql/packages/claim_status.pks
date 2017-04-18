CREATE OR REPLACE PACKAGE CPI.claim_status
AS
   v_catastrophic_desc          VARCHAR2 (4000);
   v_claim_number               VARCHAR2 (4000);
   v_with_xol_in_reserve_cat    VARCHAR2 (1);
   v_with_xol_in_payt_cat       VARCHAR2 (1);
   v_with_xol_in_reserve        VARCHAR2 (1);
   v_with_xol_in_payt           VARCHAR2 (1);
   v_with_spoiled_endt          VARCHAR2 (1);
   v_with_reserve_hist          VARCHAR2 (1);
   v_refresh_sw                 VARCHAR2 (1);
   v_with_valid_peril_no_payt   VARCHAR2 (1);
   v_with_unpaid_settlement     VARCHAR2 (1);

   FUNCTION with_xol_in_reserve_cat (
      p_claim_id   gicl_clm_res_hist.claim_id%TYPE
   )
      --return 1 if there's an XOL in reserve distribution under a particular Catastrophy (same Catastrophic Code as selected claim).
   RETURN NUMBER;

   FUNCTION with_xol_in_payment_cat (
      p_claim_id   gicl_clm_res_hist.claim_id%TYPE
   )
      --return 1 if there's an XOL in settlement distribution under a particular Catastrophy (same Catastrophic Code as selected claim).
   RETURN NUMBER;

   FUNCTION with_xol_in_reserve (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
      --return 1 if there's an XOL in reserve distribution.
   RETURN NUMBER;

   FUNCTION with_xol_in_payment (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
      --return 1 if there's an XOL in settlement distribution.
   RETURN NUMBER;

   FUNCTION with_unpaid_settlement (
      p_claim_id   gicl_clm_res_hist.claim_id%TYPE
   )
      --return 1 if there's a valid settlement with no payment yet
   RETURN NUMBER;

   FUNCTION with_advice (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
      --return 1 if there is at least one valid advice.
   RETURN NUMBER;

   FUNCTION with_advice_with_no_payt (
      p_claim_id   gicl_clm_res_hist.claim_id%TYPE
   )
      --return 1 if there is at least one valid advice without claim payment.
   RETURN NUMBER;

   FUNCTION with_reserve_hist (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
      --return 1 if there is at least one peril (loss or expense) with reserve been updated using GICLS040 or GICLS039.
   RETURN NUMBER;

   FUNCTION with_spoiled_endt (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
      --return 1 if at least one endorsement is spoiled
   RETURN NUMBER;

   FUNCTION with_valid_peril_no_payt (
      p_claim_id   gicl_clm_res_hist.claim_id%TYPE
   )
      --return 1 if at least one valid peril has no claim payment
   RETURN NUMBER;

   FUNCTION get_paid_amt (
      p_loss_exp   VARCHAR2,
      p_claim_id   gicl_clm_res_hist.claim_id%TYPE,
      p_item_no    gicl_clm_res_hist.item_no%TYPE,
      p_peril_cd   gicl_clm_res_hist.peril_cd%TYPE
   )
      --return total paid amount (loss or expense) of the selected claim per item peril.
      --return total paid amount (loss or expense) of the selected claim if no item and peril specified.
      --return NULL if no claim payment history
   RETURN NUMBER;

   FUNCTION get_confirmation_message (
      p_claim_id       gicl_clm_res_hist.claim_id%TYPE,
      p_claim_status   VARCHAR2
   )
      --return confirmation message before updating claim status.
   RETURN VARCHAR2;

   FUNCTION get_final_message (
      p_claim_id       gicl_clm_res_hist.claim_id%TYPE,
      p_claim_status   VARCHAR2
   )
      --return final message after claim is updated.
   RETURN VARCHAR2;

   FUNCTION get_catastrophic_desc (
      p_claim_id   gicl_clm_res_hist.claim_id%TYPE
   )
      --return catastrophic code and description per claim
   RETURN VARCHAR2;

   FUNCTION get_pol_flag (p_claim_id gicl_clm_res_hist.claim_id%TYPE)
      --return pol_flag of original policy per claim
   RETURN VARCHAR2;

   FUNCTION get_ann_tsi_amt (
      p_claim_id   gicl_clm_res_hist.claim_id%TYPE,
      p_item_no    gicl_clm_res_hist.item_no%TYPE,
      p_peril_cd   gicl_clm_res_hist.peril_cd%TYPE
   )
      --return annual TSI amount of claim per item peril
   RETURN NUMBER;

   PROCEDURE reset_variables;
    --reset all declared variables upon module entry and after final message.

   FUNCTION validate_claim (
      p_claim_id       gicl_clm_res_hist.claim_id%TYPE,
      p_claim_status   VARCHAR2
   )
      --return NULL if claim is valid to be reopened, denied, withdrawn, cancelled, or closed otherwise return Error message
   RETURN VARCHAR2;

   PROCEDURE update_status (
      p_claim_id       IN   gicl_clm_res_hist.claim_id%TYPE,
      p_claim_status        VARCHAR2
   );                                             --update status of claim(s)

   PROCEDURE update_xol_res;       --update Reserve amount in XOL maintenance

   PROCEDURE update_xol_payt;         --update Paid amount in XOL maintenance
END claim_status;
/



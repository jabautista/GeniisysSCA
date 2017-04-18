CREATE OR REPLACE PACKAGE CPI.gicls259_pkg
AS
   TYPE clm_list_per_payee_type IS RECORD (
      claim_number    VARCHAR (50), 
      policy_number   VARCHAR (50),
      clm_file_date   gicl_claims.clm_file_date%TYPE,
      loss_date       gicl_claims.loss_date%TYPE,
      assured_name    gicl_claims.assured_name%TYPE,
	  claim_id		  gicl_claims.claim_id%TYPE
   );

   TYPE per_payee_dtl_type IS RECORD (
      item_no         gicl_clm_loss_exp.item_no%TYPE,
      dsp_item        VARCHAR2 (200),
      peril_cd        gicl_clm_loss_exp.peril_cd%TYPE,
      dsp_peril       VARCHAR2 (200),
      hist_seq_no     gicl_clm_loss_exp.hist_seq_no%TYPE,
      paid_amt        gicl_clm_loss_exp.paid_amt%TYPE,
      net_amt         gicl_clm_loss_exp.net_amt%TYPE,
      advice_amt      gicl_clm_loss_exp.advise_amt%TYPE,
      dsp_status      giis_clm_stat.clm_stat_desc%TYPE,
      nbt_advice_no   VARCHAR2 (100)
   );

   TYPE per_payee_dtl_tab IS TABLE OF per_payee_dtl_type;

   TYPE clm_list_per_payee_tab IS TABLE OF clm_list_per_payee_type;

   FUNCTION get_clm_list_per_payee (
      p_user_id          giis_users.user_id%TYPE,
      p_payee_cd         giis_payees.payee_no%TYPE,
      p_payee_class_cd   giis_payee_class.payee_class_cd%TYPE
   )
      RETURN clm_list_per_payee_tab PIPELINED;

   FUNCTION get_gicls259_details (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_payee_cd         giis_payees.payee_no%TYPE,
      p_payee_class_cd   giis_payee_class.payee_class_cd%TYPE
   )
      RETURN per_payee_dtl_tab PIPELINED;
END;
/



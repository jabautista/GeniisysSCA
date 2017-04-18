CREATE OR REPLACE PACKAGE CPI.GIAC_ADVANCED_PAYT_PKG
AS
    PROCEDURE set_giac_advanced_payt 
        (p_gacc_tran_id         giac_advanced_payt.gacc_tran_id%TYPE,
         p_policy_id            giac_advanced_payt.policy_id%TYPE,
         p_transaction_type     giac_advanced_payt.transaction_type%TYPE,
         p_iss_cd               giac_advanced_payt.iss_cd%TYPE,
         p_prem_seq_no          giac_advanced_payt.prem_seq_no%TYPE,
         p_premium_amt          giac_advanced_payt.premium_amt%TYPE,
         p_tax_amt              giac_advanced_payt.tax_amt%TYPE,
         p_inst_no              giac_advanced_payt.inst_no%TYPE,
         p_acct_ent_date        giac_advanced_payt.acct_ent_date%TYPE,
         p_user_id              giac_advanced_payt.user_id%TYPE,
         p_last_update          giac_advanced_payt.last_update%TYPE,
         p_booking_mth          giac_advanced_payt.booking_mth%TYPE,
         p_booking_year         giac_advanced_payt.booking_year%TYPE,
         p_cancel_date          giac_advanced_payt.cancel_date%TYPE,
         p_rev_gacc_tran_id     giac_advanced_payt.rev_gacc_tran_id%TYPE,
         p_batch_gacc_tran_id   giac_advanced_payt.batch_gacc_tran_id%TYPE,
         p_assd_no              giac_advanced_payt.assd_no%TYPE);
         
    PROCEDURE delete_giac_advanced_payt
        (p_gacc_tran_id giac_advanced_payt.gacc_tran_id%TYPE,
         p_iss_cd       giac_advanced_payt.iss_cd%TYPE,
         p_prem_seq_no  giac_advanced_payt.prem_seq_no%TYPE,
         p_inst_no      giac_advanced_payt.inst_no%TYPE);
		 
	PROCEDURE insert_giac_advanced_payt 
        (p_gacc_tran_id         GIAC_ADVANCED_PAYT.gacc_tran_id%TYPE,
         p_transaction_type     GIAC_ADVANCED_PAYT.transaction_type%TYPE,
         p_iss_cd               GIAC_ADVANCED_PAYT.iss_cd%TYPE,
         p_prem_seq_no          GIAC_ADVANCED_PAYT.prem_seq_no%TYPE,
         p_inst_no              GIAC_ADVANCED_PAYT.inst_no%TYPE,
         p_policy_id            GIAC_ADVANCED_PAYT.policy_id%TYPE,
         p_premium_amt          GIAC_ADVANCED_PAYT.premium_amt%TYPE,
         p_tax_amt              GIAC_ADVANCED_PAYT.tax_amt%TYPE,
         p_user_id              GIAC_ADVANCED_PAYT.user_id%TYPE,
         p_booking_mth          GIAC_ADVANCED_PAYT.booking_mth%TYPE,
         p_booking_year         GIAC_ADVANCED_PAYT.booking_year%TYPE,
         p_assd_no              GIAC_ADVANCED_PAYT.assd_no%TYPE);
    
END;
/



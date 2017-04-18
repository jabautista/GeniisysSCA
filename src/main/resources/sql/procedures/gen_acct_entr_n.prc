DROP PROCEDURE CPI.GEN_ACCT_ENTR_N;

CREATE OR REPLACE PROCEDURE CPI.gen_acct_entr_n (
   p_module_nm                   giac_modules.module_name%TYPE,
   p_transaction_type            giac_direct_prem_collns.transaction_type%TYPE,
   p_iss_cd                      giac_direct_prem_collns.b140_iss_cd%TYPE,
   p_bill_no                     giac_direct_prem_collns.b140_prem_seq_no%TYPE,
   p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
   p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
   p_giop_gacc_tran_id           giac_acct_entries.gacc_tran_id%TYPE,
   p_item_no               OUT   NUMBER,
   p_msg_alert             OUT   VARCHAR2
)
IS
/* this generates the acct'g entries */
BEGIN
	 
   IF NVL (giacp.v ('PREM_REC_GROSS_TAG'), 'Y') != 'Y'
   THEN
   dbms_output.put_line('here a.1');
      aeg_parameters_n (p_module_nm,
                        p_transaction_type,
                        p_iss_cd,
                        p_bill_no,
                        p_giop_gacc_branch_cd,
                        p_giop_gacc_fund_cd,
                        p_giop_gacc_tran_id,
                        p_item_no,
                        p_msg_alert
                       );
   END IF;
--:nbt.gen_acct_flag := 'N';
END gen_acct_entr_n;
/



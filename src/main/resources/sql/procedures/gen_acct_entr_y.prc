DROP PROCEDURE CPI.GEN_ACCT_ENTR_Y;

CREATE OR REPLACE PROCEDURE CPI.gen_acct_entr_y (
   p_gacc_tran_id                giac_direct_prem_collns.gacc_tran_id%TYPE,
   p_module_name                 giac_modules.module_name%TYPE,
   p_item_no               OUT   INTEGER,
   p_msg_alert             OUT   VARCHAR2,
   p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
   p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
)
IS
BEGIN
   IF NVL (giacp.v ('PREM_REC_GROSS_TAG'), 'Y') = 'Y'
   THEN
      IF NVL (giacp.v ('ENTER_ADVANCED_PAYT'), 'N') = 'Y'
      THEN
         aeg_parameters_y_prem_rec (p_gacc_tran_id,
                                    p_module_name,
                                    p_item_no,
                                    p_msg_alert,
                                    p_giop_gacc_branch_cd,
                                    p_giop_gacc_fund_cd
                                   );
         aeg_parameters_y_prem_dep (p_gacc_tran_id,
                                    p_module_name,
                                    p_item_no,
                                    p_msg_alert,
                                    p_giop_gacc_branch_cd,
                                    p_giop_gacc_fund_cd
                                   );
      ELSE
         aeg_parameters_y (p_gacc_tran_id,
                           p_module_name,
                           p_item_no,
                           p_msg_alert,
                           p_giop_gacc_branch_cd,
                           p_giop_gacc_fund_cd
                          );
      END IF;
   END IF;
END;
/



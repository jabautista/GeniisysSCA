DROP PROCEDURE CPI.CHECK_ADV_PAYT;

CREATE OR REPLACE PROCEDURE CPI.check_adv_payt
 (p_gacc_tran_id       GIAC_ADVANCED_PAYT.gacc_tran_id%TYPE,
  p_transaction_type   GIAC_ADVANCED_PAYT.transaction_type%TYPE,
  p_iss_cd             GIAC_ADVANCED_PAYT.iss_cd%TYPE,
  p_prem_seq_no        GIAC_ADVANCED_PAYT.prem_seq_no%TYPE,
  p_inst_no            GIAC_ADVANCED_PAYT.inst_no%TYPE,
  p_policy_id          GIAC_ADVANCED_PAYT.policy_id%TYPE,
  p_premium_amt        GIAC_ADVANCED_PAYT.premium_amt%TYPE,
  p_tax_amt            GIAC_ADVANCED_PAYT.tax_amt%TYPE,
  p_user_id            GIAC_ADVANCED_PAYT.user_id%TYPE,
  p_assd_no            GIAC_ADVANCED_PAYT.assd_no%TYPE,
  p_inc_tag            VARCHAR2) AS

  v_booking_mth        GIAC_ADVANCED_PAYT.booking_mth%TYPE;
  v_booking_year       GIAC_ADVANCED_PAYT.booking_year%TYPE;
  v_acct_ent_date      DATE;
  
   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  08.13.2012
   **  Reference By : (GIACS007 -  Direct Premium Collections)
   **  Description :  Executes program unit CHECK_ADV_PAYT
   **                 from GIACS007.                  
   */ 
  
  BEGIN
    
    IF p_inc_tag = 'Y' THEN
        
        FOR I IN (SELECT multi_booking_mm, multi_booking_yy, 
                         acct_ent_date
                    FROM GIPI_INVOICE
                   WHERE policy_id = p_policy_id
                     AND iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no)
        LOOP
           v_booking_mth   := i.multi_booking_mm;
           v_booking_year  := i.multi_booking_yy;
           v_acct_ent_date := i.acct_ent_date;
        END LOOP;
        
        IF v_acct_ent_date IS NULL THEN
            GIAC_ADVANCED_PAYT_PKG.insert_giac_advanced_payt
            (p_gacc_tran_id,    p_transaction_type,     p_iss_cd,
             p_prem_seq_no,     p_inst_no,              p_policy_id,
             p_premium_amt,     p_tax_amt,              p_user_id,
             v_booking_mth,     v_booking_year,         p_assd_no);
        
        ELSE
           NULL;
     	  /*MESSAGE('Policy has already been taken up during'|| to_char(v_acct_ent_date,' FMMONTH,YYYY') || ' batch take up');
     	  MESSAGE('Policy has already been taken up during'|| to_char(v_acct_ent_date,' FMMONTH,YYYY') || ' batch take up');
     	  :gdpc.inc_tag := 'N';*/	 
        END IF;
    
    
    ELSIF p_inc_tag = 'N' THEN
    
        GIAC_ADVANCED_PAYT_PKG.delete_giac_advanced_payt(p_gacc_tran_id, p_iss_cd, p_prem_seq_no, p_inst_no);
    
    END IF; 
  
  END check_adv_payt;
/



CREATE OR REPLACE PACKAGE BODY CPI.GIAC_ADVANCED_PAYT_PKG
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
         p_assd_no              giac_advanced_payt.assd_no%TYPE)
    IS
    BEGIN
    
        MERGE INTO giac_advanced_payt
          USING dual ON (gacc_tran_id = p_gacc_tran_id
                         AND iss_cd = p_iss_cd
                         AND prem_seq_no = p_prem_seq_no
                         AND inst_no = p_inst_no)
          WHEN NOT MATCHED THEN
            INSERT (gacc_tran_id,   policy_id,      transaction_type,       iss_cd,
                    prem_seq_no,    premium_amt,    tax_amt,                inst_no,
                    acct_ent_date,  user_id,        last_update,            booking_mth,
                    booking_year,   cancel_date,    rev_gacc_tran_id,       batch_gacc_tran_id,
                    assd_no)
            VALUES (p_gacc_tran_id,     p_policy_id,    p_transaction_type,     p_iss_cd,
                    p_prem_seq_no,      p_premium_amt,  p_tax_amt,              p_inst_no,
                    p_acct_ent_date,    p_user_id,      p_last_update,          p_booking_mth,
                    p_booking_year,     p_cancel_date,  p_rev_gacc_tran_id,     p_batch_gacc_tran_id,
                    p_assd_no)
          WHEN MATCHED THEN
            UPDATE SET 
               premium_amt          = p_premium_amt,
               tax_amt              = p_tax_amt,
               acct_ent_date        = p_acct_ent_date,
               user_id              = p_user_id,
               last_update          = p_last_update,
               booking_mth          = p_booking_mth,
               booking_year         = p_booking_year,
               cancel_date          = p_cancel_date,
               rev_gacc_tran_id     = p_rev_gacc_tran_id,
               batch_gacc_tran_id   = p_batch_gacc_tran_id,
               assd_no              = p_assd_no;
               
    END set_giac_advanced_payt;
    
    PROCEDURE delete_giac_advanced_payt
        (p_gacc_tran_id giac_advanced_payt.gacc_tran_id%TYPE,
         p_iss_cd       giac_advanced_payt.iss_cd%TYPE,
         p_prem_seq_no  giac_advanced_payt.prem_seq_no%TYPE,
         p_inst_no      giac_advanced_payt.inst_no%TYPE)
    IS
    BEGIN
    
       DELETE FROM giac_advanced_payt
         WHERE gacc_tran_id = p_gacc_tran_id
           AND iss_cd       = p_iss_cd
           AND prem_seq_no  = p_prem_seq_no
           AND inst_no      = p_inst_no;
           
    END;
	
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
         p_assd_no              GIAC_ADVANCED_PAYT.assd_no%TYPE) AS
         
   /*
   **  Created by   : Veronica V. Raymundo
   **  Date Created : 08.13.2012
   **  Reference By : (GIACS007 -  Direct Premium Collections)
   **  Description  : Update records in GIAC_ADVANCED_PAYT when records
   **                 already exists. Otherwise, insert records in 
   **                 GIAC_ADVANCED_PAYT.
   */ 
         
    BEGIN
        UPDATE GIAC_ADVANCED_PAYT
           SET gacc_tran_id = p_gacc_tran_id, 
               policy_id    = p_policy_id,
               iss_cd       = p_iss_cd, 
               prem_seq_no  = p_prem_seq_no,     
               inst_no      = p_inst_no, 
               premium_amt  = p_premium_amt,
               tax_amt      = p_tax_amt, 
               booking_mth  = p_booking_mth,
               booking_year = p_booking_year, 
               user_id      = p_user_id,
               last_update  = SYSDATE , 
               transaction_type = p_transaction_type,
               assd_no      = p_assd_no
         WHERE gacc_tran_id = p_gacc_tran_id
           AND transaction_type = p_transaction_type    
           AND iss_cd = p_iss_cd
           AND prem_seq_no = p_prem_seq_no
           AND inst_no = p_inst_no;
                                                               
        IF SQL%NOTFOUND THEN
          
          INSERT INTO GIAC_ADVANCED_PAYT
            ( gacc_tran_id , policy_id  ,     iss_cd    ,     prem_seq_no ,     
              inst_no      , premium_amt,     tax_amt   ,     booking_mth ,
              booking_year , user_id    ,     last_update,    transaction_type,   
              assd_no)
    	  	                                
          VALUES 
            ( p_gacc_tran_id, p_policy_id,    p_iss_cd ,      p_prem_seq_no ,
              p_inst_no     , p_premium_amt,  p_tax_amt,      p_booking_mth ,
              p_booking_year, p_user_id,      SYSDATE  ,      p_transaction_type,
              p_assd_no);
              
        END IF;
    END insert_giac_advanced_payt;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.GIAC_SPOILED_CHECK_PKG
AS

  /*
  **  Created by   :  Marie Kris Felipe
  **  Date Created :  04.24.2013
  **  Reference By : (GIACS002 - Generate Disbursement Voucher)
  **  Description  : executes SPOIL_CHECK program unit
  */
  PROCEDURE insert_spoiled_check(
        p_check IN giac_spoiled_check%ROWTYPE
  )IS
  
  BEGIN 
        INSERT 
          INTO giac_spoiled_check
               (gacc_tran_id,   item_no,
               bank_cd,         bank_acct_cd,
               check_date,      check_pref_suf,
               check_no,        check_stat,
               check_class,     currency_cd,
               fcurrency_amt,   currency_rt,
               amount,          print_dt,
               user_id,         last_update)
       VALUES (p_check.GACC_TRAN_ID,                  p_check.item_no,
               p_check.bank_cd,                       p_check.bank_acct_cd,
               p_check.check_date,                    p_check.check_pref_suf,
               p_check.check_no,                      p_check.check_stat,
               p_check.check_class,                   p_check.currency_cd,
               p_check.fcurrency_amt,                 p_check.currency_rt,
               p_check.amount,                        p_check.print_dt,
               nvl(giis_users_pkg.app_user, USER),    SYSDATE);
       
      IF SQL%NOTFOUND THEN
          --msg_alert('Spoil check: Unable to insert into spoiled_check.','E', TRUE);
          raise_application_error(-20001, 'Geniisys Exception#E#Spoil check: Unable to insert into spoiled_check.');
      END IF;
     
  END insert_spoiled_check; 


END GIAC_SPOILED_CHECK_PKG;
/



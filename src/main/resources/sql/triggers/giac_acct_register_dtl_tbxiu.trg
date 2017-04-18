DROP TRIGGER CPI.GIAC_ACCT_REGISTER_DTL_TBXIU;

CREATE OR REPLACE TRIGGER CPI.giac_acct_register_dtl_tbxiu 
       BEFORE INSERT OR UPDATE 
       ON CPI.GIAC_ACCT_REGISTER_DTL 
       FOR EACH ROW
DECLARE 
      BEGIN 
        :NEW.user_id     := NVL (giis_users_pkg.app_user, USER); 
        :NEW.last_update := SYSDATE; 
      END;
/



DROP TRIGGER CPI.GIAC_ACCT_REGISTER_TBXIU;

CREATE OR REPLACE TRIGGER CPI.giac_acct_register_tbxiu 
       BEFORE INSERT OR UPDATE 
       ON CPI.GIAC_ACCT_REGISTER 
       FOR EACH ROW
DECLARE 
      BEGIN 
        :NEW.user_id     := NVL (giis_users_pkg.app_user, USER); 
        :NEW.last_update := SYSDATE; 
      END;
/



DROP TRIGGER CPI.MI_OTHER_DTLS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.MI_OTHER_DTLS_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_MI_OTHER_DTLS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    BEGIN
      :NEW.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :NEW.last_update :=  SYSDATE;
    END;
END;
/



DROP TRIGGER CPI.INTM_SPECIAL_RATE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.INTM_SPECIAL_RATE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_INTM_SPECIAL_RATE FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
	   -- updated by MJ 04/10/2014
       --:NEW.USER_ID    := USER;
	   :NEW.user_ID     := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/



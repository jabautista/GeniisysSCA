DROP TRIGGER CPI.GIIS_PACK_PLAN_COVER_DTL_TBIUX;

CREATE OR REPLACE TRIGGER CPI.GIIS_PACK_PLAN_COVER_DTL_TBIUX
BEFORE INSERT OR UPDATE
ON CPI.GIIS_PACK_PLAN_COVER_DTL FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
       :NEW.USER_ID    := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/



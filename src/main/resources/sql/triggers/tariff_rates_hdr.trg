DROP TRIGGER CPI.TARIFF_RATES_HDR;

CREATE OR REPLACE TRIGGER CPI.TARIFF_RATES_HDR
BEFORE INSERT OR UPDATE
ON CPI.GIIS_TARIFF_RATES_HDR FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
       :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/



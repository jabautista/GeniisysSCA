DROP TRIGGER CPI.GIPI_INSP_DATA_DTL_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIPI_INSP_DATA_DTL_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIPI_INSP_DATA_DTL FOR EACH ROW
DECLARE 
BEGIN
 :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
 :NEW.LAST_UPDATE := SYSDATE;
END;
/



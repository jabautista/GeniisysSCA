DROP TRIGGER CPI.TRG1_LINE_SUBLIN_COVER;

CREATE OR REPLACE TRIGGER CPI.TRG1_LINE_SUBLIN_COVER
BEFORE INSERT OR UPDATE
ON CPI.GIIS_LINE_SUBLINE_COVERAGES FOR EACH ROW
DECLARE
BEGIN
  DECLARE
     BEGIN
       :NEW.user_ID      :=  NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE  :=  SYSDATE;
     END;
END;
/



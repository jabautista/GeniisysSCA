DROP TRIGGER CPI.GIAC_COLL_ANALYSIS_EXT_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIAC_COLL_ANALYSIS_EXT_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIAC_COLL_ANALYSIS_EXT FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    BEGIN
      :NEW.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :NEW.last_update :=  SYSDATE;
    END;
END;
/



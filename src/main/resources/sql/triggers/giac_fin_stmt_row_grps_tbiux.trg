DROP TRIGGER CPI.GIAC_FIN_STMT_ROW_GRPS_TBIUX;

CREATE OR REPLACE TRIGGER CPI.GIAC_FIN_STMT_ROW_GRPS_TBIUX
before INSERT OR UPDATE
ON CPI.GIAC_FINANCIAL_STMT_ROW_GROUPS FOR each ROW
BEGIN
  IF INSERTING THEN
   :NEW.created_by := NVL (giis_users_pkg.app_user, USER);
   :NEW.create_dt  := SYSDATE;
  END IF;

  :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/



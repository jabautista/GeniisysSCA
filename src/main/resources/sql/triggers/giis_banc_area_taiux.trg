DROP TRIGGER CPI.GIIS_BANC_AREA_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIIS_BANC_AREA_taiux
AFTER INSERT OR UPDATE OF EFF_DATE ON CPI.GIIS_BANC_AREA FOR EACH ROW
DECLARE
BEGIN
IF UPDATING THEN
  IF :NEW.eff_date != :OLD.eff_date THEN
    INSERT INTO giis_banc_area_hist
                  (area_cd, new_eff_date, old_eff_date, user_id, last_update)
        VALUES (:New.area_cd,:NEW.eff_date, :OLD.eff_date, NVL (giis_users_pkg.app_user, USER), SYSDATE);
  END IF;
ELSE
  INSERT INTO giis_banc_area_hist
           (area_cd, new_eff_date, old_eff_date, user_id, last_update)
  VALUES (:NEW.area_cd,:NEW.eff_date, :NEW.eff_date, NVL (giis_users_pkg.app_user, USER), SYSDATE);
END IF;
END;
/



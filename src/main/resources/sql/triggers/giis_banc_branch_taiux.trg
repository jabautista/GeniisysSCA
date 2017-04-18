DROP TRIGGER CPI.GIIS_BANC_BRANCH_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIIS_BANC_BRANCH_taiux
AFTER INSERT OR UPDATE ON CPI.GIIS_BANC_BRANCH FOR EACH ROW
DECLARE
BEGIN
IF UPDATING THEN
  INSERT INTO giis_banc_branch_hist
(branch_cd, area_cd, old_eff_date, new_eff_date, old_area_cd, new_area_cd, old_manager_cd,   new_manager_cd, old_bank_acct_cd, new_bank_acct_cd, old_mgr_eff_date, new_mgr_eff_date, user_id, last_update)
  VALUES (:NEW.branch_cd,:NEW.area_cd, :OLD.eff_date, :NEW.eff_date, :OLD.area_cd,:NEW.area_cd,
        :OLD.manager_cd,:NEW.manager_cd,:OLD.bank_acct_cd,:NEW.bank_acct_cd,
       :OLD.mgr_eff_date,:NEW.mgr_eff_date, NVL (giis_users_pkg.app_user, USER), SYSDATE);
ELSE
  INSERT INTO giis_banc_branch_hist
(branch_cd, area_cd, old_eff_date, new_eff_date, old_area_cd, new_area_cd, old_manager_cd, new_manager_cd, old_bank_acct_cd, new_bank_acct_cd, old_mgr_eff_date, new_mgr_eff_date, user_id, last_update)
  VALUES (:NEW.branch_cd, :NEW.area_cd, :NEW.eff_date, :NEW.eff_date, :NEW.area_cd,:NEW.area_cd,
          :NEW.manager_cd,:NEW.manager_cd,:NEW.bank_acct_cd,:NEW.bank_acct_cd,
       :NEW.mgr_eff_date,:NEW.mgr_eff_date, NVL (giis_users_pkg.app_user, USER), SYSDATE);
END IF;
END;
/



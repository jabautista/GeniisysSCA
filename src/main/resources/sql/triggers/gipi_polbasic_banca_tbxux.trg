DROP TRIGGER CPI.GIPI_POLBASIC_BANCA_TBXUX;

CREATE OR REPLACE TRIGGER CPI.GIPI_POLBASIC_BANCA_TBXUX
   BEFORE INSERT OR UPDATE OF area_cd, branch_cd, manager_cd
   ON CPI.GIPI_POLBASIC    FOR EACH ROW
DECLARE
BEGIN
   INSERT INTO gipi_bancassurance_hist
               (policy_id, hist_no,
               old_area, new_area,
               old_branch, new_branch,
               old_manager, new_manager,
               user_id,last_update
               )
        VALUES (:NEW.policy_id, (SELECT COUNT (policy_id)
                                   FROM gipi_bancassurance_hist
                                  WHERE policy_id = :NEW.policy_id) + 1,
                                  :OLD.area_cd, :NEW.area_cd,
                                  :OLD.branch_cd, :NEW.branch_cd,
                                  :OLD.manager_cd, :NEW.manager_cd,
                                  NVL (giis_users_pkg.app_user, USER), SYSDATE
               );
END;
/



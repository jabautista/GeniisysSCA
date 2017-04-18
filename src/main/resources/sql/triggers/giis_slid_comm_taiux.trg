DROP TRIGGER CPI.GIIS_SLID_COMM_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIIS_SLID_COMM_TAIUX
   AFTER INSERT OR UPDATE
   ON CPI.GIIS_SLID_COMM    FOR EACH ROW
DECLARE
BEGIN
   IF UPDATING
   THEN
      IF :OLD.slid_comm_rt <> :NEW.slid_comm_rt
      THEN
         INSERT INTO giis_slid_comm_hist
                     (line_cd, subline_cd, peril_cd,
                      old_hi_prem_lim, hi_prem_lim, old_lo_prem_lim,
                      lo_prem_lim, old_slid_comm_rt,
                      slid_comm_rt, remarks,
                      user_id, last_update
                     )
              VALUES (:NEW.line_cd, :NEW.subline_cd, :NEW.peril_cd,
                      :OLD.hi_prem_lim, :NEW.hi_prem_lim, :OLD.lo_prem_lim,
                      :NEW.lo_prem_lim, :OLD.slid_comm_rt,
                      :NEW.slid_comm_rt, :NEW.remarks,
                      NVL (giis_users_pkg.app_user, USER), SYSDATE
                     );
      END IF;
   ELSE
      INSERT INTO giis_slid_comm_hist
                  (line_cd, subline_cd, peril_cd,
                   old_hi_prem_lim, hi_prem_lim, old_lo_prem_lim,
                   lo_prem_lim, old_slid_comm_rt, slid_comm_rt,
                   remarks, user_id, last_update
                  )
           VALUES (:NEW.line_cd, :NEW.subline_cd, :NEW.peril_cd,
                   :NEW.hi_prem_lim, :NEW.hi_prem_lim, :NEW.lo_prem_lim,
                   :NEW.lo_prem_lim, :NEW.slid_comm_rt, :NEW.slid_comm_rt,
                   :NEW.remarks, NVL (giis_users_pkg.app_user, USER), SYSDATE
                  );
   END IF;
END;
/



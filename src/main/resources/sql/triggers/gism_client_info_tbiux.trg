DROP TRIGGER CPI.GISM_CLIENT_INFO_TBIUX;

CREATE OR REPLACE TRIGGER CPI.GISM_CLIENT_INFO_TBIUX
BEFORE INSERT OR UPDATE
ON CPI.GISM_CLIENT_INFO FOR EACH ROW
DECLARE
BEGIN
  FOR rec IN (SELECT gism_client_info_client_id_s.NEXTVAL seq
                       FROM dual)
  LOOP
    :NEW.client_id := rec.seq;
    EXIT;
  END LOOP;
  :NEW.user_id := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/



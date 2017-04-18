DROP TRIGGER CPI.GIPI_USER_EVENTS_TBXI;

CREATE OR REPLACE TRIGGER CPI.GIPI_USER_EVENTS_TBXI
   BEFORE INSERT
   ON CPI.GIPI_USER_EVENTS    FOR EACH ROW
BEGIN
   FOR c1 IN (SELECT userid
                FROM giis_event_mod_users
               WHERE event_user_mod = :NEW.event_user_mod)
   LOOP
      :NEW.userid := NVL (c1.userid, :NEW.user_id);
   END LOOP;

   SELECT DISTINCT b.event_cd, b.event_mod_cd
              INTO :NEW.event_cd, :NEW.event_mod_cd
              FROM giis_event_modules b, giis_event_mod_users a
             WHERE b.event_mod_cd = a.event_mod_cd
               AND a.event_user_mod = :NEW.event_user_mod;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      BEGIN
         SELECT DISTINCT event_cd, event_mod_cd
                    INTO :NEW.event_cd, :NEW.event_mod_cd
                    FROM giis_events_column a
                   WHERE a.event_col_cd = :NEW.event_col_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            :NEW.event_cd := NULL;
            :NEW.event_mod_cd := NULL;
      END;
END;
/



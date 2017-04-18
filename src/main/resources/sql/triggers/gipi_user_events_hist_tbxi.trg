DROP TRIGGER CPI.GIPI_USER_EVENTS_HIST_TBXI;

CREATE OR REPLACE TRIGGER CPI.GIPI_USER_EVENTS_HIST_TBXI

BEFORE INSERT ON CPI.GIPI_USER_EVENTS_HIST FOR EACH ROW
BEGIN
  SELECT DISTINCT event_cd
    INTO :NEW.event_cd
    FROM GIIS_EVENT_MODULES b, GIIS_EVENT_MOD_userS a
   WHERE b.event_mod_cd = a.event_mod_cd
     AND a.event_user_mod = :NEW.event_user_mod;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      SELECT DISTINCT event_cd
         INTO :NEW.event_cd
         FROM GIIS_EVENTS_COLUMN a
       WHERE a.event_col_cd = :NEW.event_col_cd;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        :NEW.event_cd := NULL;
    END;
END;
/



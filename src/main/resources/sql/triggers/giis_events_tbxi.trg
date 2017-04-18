DROP TRIGGER CPI.GIIS_EVENTS_TBXI;

CREATE OR REPLACE TRIGGER CPI.GIIS_EVENTS_TBXI
       BEFORE INSERT
       ON CPI.GIIS_EVENTS        FOR EACH ROW
DECLARE
      BEGIN
        SELECT events_seq.NEXTVAL
          INTO :NEW.event_cd
         FROM DUAL;
        :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
        :NEW.last_update := SYSDATE;
      END;
/



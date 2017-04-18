DROP TRIGGER CPI.GIIS_EVENT_MOD_USERS_TBXI;

CREATE OR REPLACE TRIGGER CPI.GIIS_EVENT_MOD_USERS_TBXI
       BEFORE INSERT
       ON CPI.GIIS_EVENT_MOD_USERS        FOR EACH ROW
DECLARE
      BEGIN
    SELECT EVENT_MOD_userS_SEQ.NEXTVAL
   INTO :NEW.EVENT_user_MOD
   FROM DUAL;
      END;
/



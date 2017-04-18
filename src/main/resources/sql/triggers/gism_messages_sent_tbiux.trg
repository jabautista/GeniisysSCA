DROP TRIGGER CPI.GISM_MESSAGES_SENT_TBIUX;

CREATE OR REPLACE TRIGGER CPI.GISM_MESSAGES_SENT_TBIUX
BEFORE INSERT /*added by EMCY da082305te*/ OR UPDATE
ON CPI.GISM_MESSAGES_SENT FOR EACH ROW
DECLARE
BEGIN
--EMCYDA042307TE -- modified: added validation for insert and update, added update in gism_messages_sent_dtl

/*FOR rec IN (SELECT gism_messages_sent_msg_id_s.NEXTVAL seq
FROM dual)
LOOP
:NEW.msg_id := rec.seq;
EXIT;
END LOOP;*/
IF INSERTING THEN
:NEW.set_date := SYSDATE;
:NEW.message_status := 'Q';
:NEW.user_id := NVL (giis_users_pkg.app_user, USER);
:NEW.last_update := SYSDATE;
END IF;

UPDATE GISM_MESSAGES_SENT_DTL
SET status_sw = :NEW.message_status
WHERE msg_id = :NEW.msg_id;

END;
/



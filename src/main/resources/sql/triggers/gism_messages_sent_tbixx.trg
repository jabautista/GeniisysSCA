DROP TRIGGER CPI.GISM_MESSAGES_SENT_TBIXX;

CREATE OR REPLACE TRIGGER CPI.GISM_MESSAGES_SENT_TBIXX
BEFORE INSERT
ON CPI.GISM_MESSAGES_SENT FOR EACH ROW
DECLARE
BEGIN
  /*FOR rec IN (SELECT gism_messages_sent_msg_id_s.NEXTVAL seq
  	  	  	 	FROM dual)
  LOOP
    :NEW.msg_id := rec.seq;
    EXIT;
  END LOOP;*/
  :NEW.set_date := SYSDATE;
  :NEW.message_status := 'Q';
  :NEW.user_id := USER;
  :NEW.last_update := SYSDATE;
END;
/



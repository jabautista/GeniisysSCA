DROP TRIGGER CPI.GISM_MESSAGES_SENT_DTL_TBIXX;

CREATE OR REPLACE TRIGGER CPI.GISM_MESSAGES_SENT_DTL_TBIXX
BEFORE INSERT
ON CPI.GISM_MESSAGES_SENT_DTL FOR EACH ROW
DECLARE
BEGIN
  FOR rec IN (SELECT GISM_DTL_ID_s.NEXTVAL seq
  	  	  	 	FROM dual)
  LOOP
    :NEW.DTL_ID := rec.seq;
    :NEW.STATUS_SW := 'Q';
    :NEW.LAST_UPDATE := SYSDATE;
    EXIT;
  END LOOP;
END;
/



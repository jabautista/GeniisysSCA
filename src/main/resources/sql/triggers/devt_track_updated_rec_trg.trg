DROP TRIGGER CPI.DEVT_TRACK_UPDATED_REC_TRG;

CREATE OR REPLACE TRIGGER CPI.DEVT_TRACK_UPDATED_REC_TRG
BEFORE INSERT OR UPDATE
ON CPI.DEVT_TRACK_UPDATED_REC FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
    :NEW.user_ID      := USER;
    :NEW.last_update := SYSDATE;
  END;
END;
/



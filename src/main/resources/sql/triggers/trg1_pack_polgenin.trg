DROP TRIGGER CPI.TRG1_PACK_POLGENIN;

CREATE OR REPLACE TRIGGER CPI.TRG1_PACK_POLGENIN
            BEFORE INSERT OR UPDATE
            ON CPI.GIPI_PACK_POLGENIN FOR EACH ROW
DECLARE
            BEGIN
              DECLARE
              BEGIN
                   :NEW.USER_ID    := USER;
                   :NEW.LAST_UPDATE := SYSDATE;
              END;
            END;
/



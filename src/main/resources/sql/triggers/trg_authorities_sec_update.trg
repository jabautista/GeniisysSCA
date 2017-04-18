DROP TRIGGER CPI.TRG_AUTHORITIES_SEC_UPDATE;

CREATE OR REPLACE TRIGGER CPI.TRG_AUTHORITIES_SEC_UPDATE
AFTER UPDATE ON CPI.USERS FOR EACH ROW
BEGIN
    UPDATE authorities SET username = :NEW.username where username = :OLD.username; 
END;
/



DROP TRIGGER CPI.TRG_USERS_SEC_DELETE;

CREATE OR REPLACE TRIGGER CPI.TRG_USERS_SEC_DELETE
AFTER DELETE ON CPI.GIIS_USERS FOR EACH ROW
BEGIN
     DELETE FROM authorities WHERE username = :OLD.user_id; 
     DELETE FROM users WHERE username = :OLD.user_id;
END;
/


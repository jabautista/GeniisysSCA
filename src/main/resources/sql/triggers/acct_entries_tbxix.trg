DROP TRIGGER CPI.ACCT_ENTRIES_TBXIX;

CREATE OR REPLACE TRIGGER CPI.ACCT_ENTRIES_TBXIX
BEFORE INSERT
ON CPI.GIAC_ACCT_ENTRIES FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
    DECLARE
      CURSOR c IS SELECT acct_entry_id + 1
                    FROM giac_acct_entries
                   WHERE gacc_tran_id = :new.gacc_tran_id AND
                         acct_entry_id > 0
                ORDER BY acct_entry_id DESC;
    BEGIN
      BEGIN
        OPEN c;
          FETCH c INTO :new.acct_entry_id;
          IF c%NOTFOUND THEN
             :new.acct_entry_id := 1;
          END IF;
        CLOSE c;
      END;
    END;
  END;
END;
/



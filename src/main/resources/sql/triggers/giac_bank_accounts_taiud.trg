DROP TRIGGER CPI.GIAC_BANK_ACCOUNTS_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GIAC_BANK_ACCOUNTS_TAIUD
  AFTER INSERT OR UPDATE
  ON CPI.GIAC_BANK_ACCOUNTS   FOR EACH ROW
DECLARE
  ws_fund_cd      GIAC_SL_LISTS.fund_cd%TYPE;
  ws_sl_cd        GIAC_SL_LISTS.sl_cd%TYPE := NVL (:NEW.bank_acct_cd,:OLD.bank_acct_cd);
  ws_sl_type_cd   GIAC_SL_LISTS.sl_type_cd%TYPE;
  ws_sl_nm        GIAC_SL_LISTS.sl_name%TYPE;
  CURSOR c IS
    SELECT bank_sname
      FROM GIAC_BANKS
     WHERE bank_cd = NVL (:NEW.bank_cd, :OLD.bank_cd);
BEGIN
  ws_fund_cd := Giacp.v('FUND_CD');
  IF ws_fund_cd IS NULL THEN
     RAISE_APPLICATION_ERROR (-20000, 'NO RECORDS IN PARAMETERS TABLE.');
  END IF;

  OPEN c;
  FETCH c INTO ws_sl_nm;

  IF c%NOTFOUND  THEN
     RAISE_APPLICATION_ERROR (-20001, 'NO RECORDS IN BANKS TABLE.');
  ELSE
     IF :NEW.bank_acct_type = 'CA' THEN
        ws_sl_type_cd := Giacp.v ('BANK_ACCT_SL_CA');
     ELSIF :NEW.bank_acct_type = 'SA' THEN
        ws_sl_type_cd := Giacp.v ('BANK_ACCT_SL_SA');
     ELSIF :NEW.bank_acct_type = 'TD' THEN
        ws_sl_type_cd := Giacp.v ('BANK_ACCT_SL_TD');
     END IF;

     ws_sl_nm := ws_sl_nm || ' - ' || :NEW.branch_bank || ' - ' || :NEW.bank_acct_type|| ' # '
                 || :NEW.bank_acct_no;

     IF UPDATING THEN
        UPDATE GIAC_SL_LISTS
           SET sl_name = ws_sl_nm
         WHERE fund_cd    = ws_fund_cd
           AND sl_type_cd = ws_sl_type_cd
           AND sl_cd      = ws_sl_cd;
     ELSIF INSERTING THEN
        INSERT INTO GIAC_SL_LISTS
    (fund_cd,    sl_type_cd,    sl_cd,
     sl_name,    remarks,
     user_id,    last_update)
        VALUES
    (ws_fund_cd, ws_sl_type_cd, ws_sl_cd,
     ws_sl_nm,   'this IS generated BY the SYSTEM AFTER INSERT ON bank accounts TABLE.',
           NVL (giis_users_pkg.app_user, USER),       SYSDATE);
     ELSIF DELETING THEN
        DELETE FROM GIAC_SL_LISTS
              WHERE fund_cd    = ws_fund_cd
                AND sl_type_cd = ws_sl_type_cd
                AND sl_cd      = ws_sl_cd;
     END IF;
  END IF;
END;
/


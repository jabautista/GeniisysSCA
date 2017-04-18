DROP TRIGGER CPI.GIAC_OUCS_TAIUX;

CREATE OR REPLACE TRIGGER CPI."GIAC_OUCS_TAIUX"
AFTER INSERT OR UPDATE OF OUC_NAME
ON CPI.GIAC_OUCS FOR EACH ROW
DECLARE
BEGIN
    DECLARE
      ws_fund_cd       GIAC_SL_LISTS.fund_cd%TYPE    ;
      ws_sl_type_cd    GIAC_SL_LISTS.sl_type_cd%TYPE ;
      ws_sl_cd         GIAC_SL_LISTS.sl_cd%TYPE      := NVL(:NEW.OUC_ID, :OLD.OUC_ID);
      ws_sl_nm         GIAC_SL_LISTS.sl_name%TYPE    := NVL(:NEW.OUC_NAME, :OLD.OUC_NAME);
  BEGIN
  --
  -- Get fund code
  --
      BEGIN
        SELECT param_value_v
          INTO ws_fund_cd
          FROM giac_parameters
         WHERE param_name = 'FUND_CD';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20012, 'NO RECORDS IN PARAMETERS TABLE.');
      END;
  --
  -- Get payee class code
  --
      BEGIN
        SELECT param_value_v GIAC_OUCS
          INTO ws_sl_type_cd
          FROM giac_parameters
         WHERE param_name = 'GOUC_DEPT_CD';
      END;
  --
  --
      IF UPDATING THEN
  --
  -- Update GIAC SL LISTS...
  --
      BEGIN
        UPDATE giac_sl_lists
           SET sl_name = ws_sl_nm
         WHERE fund_cd = ws_fund_cd
           AND sl_type_cd = ws_sl_type_cd
           AND sl_cd      = ws_sl_cd;
        IF SQL%NOTFOUND THEN
          INSERT INTO GIAC_SL_LISTS(fund_cd   , sl_type_cd   , sl_cd   , sl_name ,
                                    remarks   , user_id      , last_update)
                             VALUES(ws_fund_cd, ws_sl_type_cd, ws_sl_cd, ws_sl_nm,
                                    'THIS IS GENERATED BY THE SYSTEM AFTER INSERT ON GIAC_OUCS TABLE.',
                                    NVL (giis_users_pkg.app_user, USER)     , SYSDATE);
        END IF;
      END;
      ELSIF INSERTING THEN
  --
  -- Insert into GIAC SL LISTS...
  --
        INSERT INTO GIAC_SL_LISTS(fund_cd   , sl_type_cd   , sl_cd   , sl_name ,
                                  remarks   , user_id      , last_update)
                           VALUES(ws_fund_cd, ws_sl_type_cd, ws_sl_cd, ws_sl_nm,
                                  'THIS IS GENERATED BY THE SYSTEM AFTER INSERT ON GIAC_OUCS TABLE.',
                                  NVL (giis_users_pkg.app_user, USER)     , SYSDATE);
     END IF;
  END;
END;
/


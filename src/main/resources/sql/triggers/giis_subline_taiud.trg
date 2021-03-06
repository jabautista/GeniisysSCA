DROP TRIGGER CPI.GIIS_SUBLINE_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GIIS_SUBLINE_TAIUD
AFTER INSERT OR DELETE OR UPDATE
ON CPI.GIIS_SUBLINE FOR EACH ROW
DECLARE
BEGIN
  BEGIN
    DECLARE
      ws_fund_cd       GIAC_SL_LISTS.fund_cd%TYPE    ;
      ws_sl_type_cd    GIAC_SL_LISTS.sl_type_cd%TYPE := '5';
      ws_sl_nm         GIAC_SL_LISTS.sl_name%TYPE    ;
      CURSOR c IS SELECT (b.acct_line_cd * 100) +
                         NVL(:NEW.acct_subline_cd, :OLD.acct_subline_cd) sl_cd,
                         b.line_name|| ' - ' ||NVL(:NEW.subline_name, :OLD.subline_name) sl_name
                    FROM GIIS_LINE b
                   WHERE b.line_cd = NVL(:NEW.line_cd, :OLD.line_cd);
      ws_sl_cd         GIAC_SL_LISTS.sl_cd%TYPE;
    BEGIN
      BEGIN
        SELECT param_value_v
          INTO ws_fund_cd
          FROM GIAC_PARAMETERS
         WHERE param_name = 'FUND_CD';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20013, 'No records in PARAMETERS table.');
      END;
      OPEN c;
      FETCH c INTO ws_sl_cd, ws_sl_nm;
      IF c%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20014, 'No records in LINE-SUBLINE table.');
      ELSE
        IF UPDATING THEN
          UPDATE GIAC_SL_LISTS
             SET sl_name    = ws_sl_nm
           WHERE fund_cd    = ws_fund_cd
             AND sl_type_cd = ws_sl_type_cd
             AND sl_cd      = ws_sl_cd;
        ELSIF INSERTING THEN
          INSERT INTO GIAC_SL_LISTS(fund_cd   , sl_type_cd   , sl_cd   , sl_name ,
                                   remarks   , user_id      , last_update)
                            VALUES(ws_fund_cd, ws_sl_type_cd, ws_sl_cd, ws_sl_nm,
                                   'This is generated by the system after insert on SUBLINE table.',
                                  NVL (giis_users_pkg.app_user, USER)     , SYSDATE);
        ELSIF DELETING THEN
          DELETE FROM GIAC_SL_LISTS
           WHERE fund_cd    = ws_fund_cd
             AND sl_type_cd = ws_sl_type_cd
             AND sl_cd      = ws_sl_cd;
        END IF;
      END IF;
      CLOSE c;
    END;
  END;
END;
/



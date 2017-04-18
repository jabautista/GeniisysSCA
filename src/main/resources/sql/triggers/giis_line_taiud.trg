DROP TRIGGER CPI.GIIS_LINE_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GIIS_LINE_TAIUD
AFTER INSERT OR DELETE OR UPDATE
ON CPI.GIIS_LINE FOR EACH ROW
DECLARE
BEGIN
  BEGIN
    DECLARE
      ws_fund_cd       GIAC_SL_LISTS.fund_cd%TYPE    ;
      ws_sl_type_cd    GIAC_SL_LISTS.sl_type_cd%TYPE := '4';
      ws_sl_cd         GIAC_SL_LISTS.sl_cd%TYPE      := NVL(:NEW.acct_line_cd, :OLD.acct_line_cd);
      ws_sl_nm         GIAC_SL_LISTS.sl_name%TYPE    := NVL(:NEW.line_name, :OLD.line_name);
    BEGIN
      BEGIN
        SELECT param_value_v
          INTO ws_fund_cd
          FROM giac_parameters
         WHERE param_name = 'FUND_CD';
      EXCEPTION
        WHEN no_data_found THEN
          RAISE_APPLICATION_ERROR(-20010, 'No records in PARAMETERS table.');
      END;
      IF updating THEN
        UPDATE giac_sl_lists
           SET sl_name = ws_sl_nm
         WHERE fund_cd = ws_fund_cd
           AND sl_type_cd = ws_sl_type_cd
           AND sl_cd      = ws_sl_cd;
     ELSIF inserting THEN
       INSERT INTO GIAC_SL_LISTS(fund_cd   , sl_type_cd   , sl_cd   , sl_name ,
                                 remarks   , user_id      , last_update)
                          VALUES(ws_fund_cd, ws_sl_type_cd, ws_sl_cd, ws_sl_nm,
                                 'This is generated by the system after insert on LINE table.',
                                 NVL (giis_users_pkg.app_user, USER)     , SYSDATE);
     ELSIF deleting THEN
       DELETE FROM giac_sl_lists
        WHERE fund_cd = ws_fund_cd
          AND sl_type_cd = ws_sl_type_cd
          AND sl_cd = ws_sl_cd;
     END IF;
    END;
  END;
END;
/


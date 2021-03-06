DROP TRIGGER CPI.GIIS_REINSURER_TAIUX_042505;

CREATE OR REPLACE TRIGGER CPI.GIIS_REINSURER_TAIUX_042505
AFTER INSERT OR UPDATE OF RI_NAME
ON CPI.GIIS_REINSURER FOR EACH ROW
DECLARE
BEGIN
  BEGIN
    DECLARE
      ws_fund_cd       GIAC_SL_LISTS.fund_cd%TYPE    ;
      ws_sl_type_cd    GIAC_SL_LISTS.sl_type_cd%TYPE := '2';
      ws_sl_cd         GIAC_SL_LISTS.sl_cd%TYPE      := NVL(:NEW.ri_cd, :OLD.ri_cd);
      ws_sl_nm         GIAC_SL_LISTS.sl_name%TYPE    := NVL(:NEW.ri_name, :OLD.ri_name);
      ws_pno           GIIS_PAYEES.payee_no%TYPE     := NVL(:NEW.ri_cd, :OLD.ri_cd);
      ws_pcd           GIIS_PAYEES.payee_class_cd%TYPE;
      ws_plast         GIIS_PAYEES.payee_last_name%TYPE := NVL(:NEW.ri_name, :OLD.ri_name);
      ws_addr1         GIIS_PAYEES.mail_addr1%TYPE := NVL(:NEW.mail_address1, :OLD.mail_address1);
      ws_tin           GIIS_PAYEES.tin%TYPE        := 'TIN NOT AVAILABLE...';
      ws_tag           GIIS_PAYEES.allow_tag%TYPE  := 'Y';
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
        SELECT param_value_v
          INTO ws_pcd
          FROM giac_parameters
         WHERE param_name = 'RI_CLASS_CD';
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
                                    'THIS IS GENERATED BY THE SYSTEM AFTER INSERT ON REINSURER TABLE.',
                                    NVL (giis_users_pkg.app_user, USER)     , SYSDATE);
        END IF;
      END;
  --
  -- Update GIIS PAYEES...
  --
      BEGIN
        UPDATE giis_payees
           SET payee_no = ws_pno,
               payee_last_name = ws_plast,
               mail_addr1 = ws_addr1,
               tin = ws_tin,
               user_id = NVL (giis_users_pkg.app_user, USER),
               last_update = SYSDATE
         WHERE payee_no = ws_pno
           AND payee_class_cd = ws_pcd;
        IF SQL%NOTFOUND THEN
          INSERT INTO GIAC_SL_LISTS(fund_cd   , sl_type_cd   , sl_cd   , sl_name ,
                                    remarks   , user_id      , last_update)
                             VALUES(ws_fund_cd, ws_sl_type_cd, ws_sl_cd, ws_sl_nm,
                                    'THIS IS GENERATED BY THE SYSTEM AFTER INSERT ON REINSURER TABLE.',
                                    NVL (giis_users_pkg.app_user, USER)     , SYSDATE);
        END IF;
      END;
  --
  --
      ELSIF INSERTING THEN
  --
  -- Insert into GIAC SL LISTS...
  --
        INSERT INTO GIAC_SL_LISTS(fund_cd   , sl_type_cd   , sl_cd   , sl_name ,
                                  remarks   , user_id      , last_update)
                           VALUES(ws_fund_cd, ws_sl_type_cd, ws_sl_cd, ws_sl_nm,
                                  'THIS IS GENERATED BY THE SYSTEM AFTER INSERT ON REINSURER TABLE.',
                                  NVL (giis_users_pkg.app_user, USER)     , SYSDATE);
  --
  -- Insert into GIIS PAYEES...
  --
        INSERT INTO GIIS_PAYEES(payee_no,
                                payee_class_cd,
                                payee_last_name,
                                mail_addr1,
                                tin,
                                allow_tag,
                                remarks,
                                user_id,
                                last_update)
                         VALUES(ws_pno,
                                ws_pcd,
                                ws_plast,
                                ws_addr1,
                                ws_tin,
                                ws_tag,
                                'THIS IS GENERATED BY THE SYSTEM AFTER INSERT ON REINSURER TABLE.',
                                NVL (giis_users_pkg.app_user, USER),
                                SYSDATE);
  -- Commented by Loth
  --    ELSIF deleting THEN
  --
  -- Delete from GIAC SL LISTS...
  --
  --      DELETE FROM giac_sl_lists
  --       WHERE fund_cd = ws_fund_cd
  --         AND sl_type_cd = ws_sl_type_cd
  --         AND sl_cd = ws_sl_cd;
  --
  -- Delete from GIIS PAYEES...
  --
  --      DELETE FROM giis_payees
  --       WHERE payee_no = ws_pno
  --         AND payee_class_cd = ws_pcd;
      END IF;
    END;
  END;
END;
/

ALTER TRIGGER CPI.GIIS_REINSURER_TAIUX_042505 DISABLE;



DROP TRIGGER CPI.GIIS_PAYEES_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIIS_PAYEES_TAIUX
AFTER INSERT OR UPDATE ON CPI.GIIS_PAYEES FOR EACH ROW
DECLARE
    ws_fund_cd         GIAC_SL_LISTS.fund_cd%TYPE;
    ws_sl_type_cd      GIIS_PAYEE_CLASS.sl_type_cd%TYPE;
    ws_sl_type_tag     GIIS_PAYEE_CLASS.sl_type_tag%TYPE;
    ws_sl_cd           GIAC_SL_LISTS.sl_cd%TYPE;
    ws_PAYEE_CLASS_TAG GIIS_PAYEE_CLASS.payee_class_tag%TYPE;
BEGIN
  SELECT param_value_v
  INTO   ws_fund_cd
  FROM   GIAC_PARAMETERS
  WHERE  param_name = 'FUND_CD';
  BEGIN
    SELECT NVL(sl_type_cd,'-'),DECODE(sl_type_tag,'Y',sl_type_tag,NULL,'N'),PAYEE_CLASS_TAG
    INTO   ws_sl_type_cd, ws_sl_type_tag,WS_PAYEE_CLASS_TAG
    FROM   GIIS_PAYEE_CLASS
    WHERE  payee_class_cd = :NEW.payee_class_cd;
    IF ws_PAYEE_CLASS_TAG = 'M' THEN
    IF  ws_sl_type_tag = 'Y' THEN
       IF INSERTING THEN
          INSERT INTO GIAC_SL_LISTS(fund_cd, sl_type_cd,
                                      sl_cd  , sl_name,
                                      remarks, user_id,
                                      last_update)
          VALUES(ws_fund_cd, ws_sl_type_cd,:NEW.payee_no,
                :NEW.payee_first_name||DECODE(:NEW.payee_first_name,NULL,NULL,' ')||:NEW.payee_middle_name||DECODE(:NEW.payee_middle_name,NULL,NULL,' ')||:NEW.payee_last_name,
                'This is generated by the system after insert on GIIS_PAYEES table.',
                 NVL (giis_users_pkg.app_user, USER), SYSDATE);
      ELSIF UPDATING THEN
          UPDATE GIAC_SL_LISTS
          SET SL_NAME = :NEW.payee_first_name||DECODE(:NEW.payee_first_name,NULL,NULL,' ')||:NEW.payee_middle_name||DECODE(:NEW.payee_middle_name,NULL,NULL,' ')||:NEW.payee_last_name,
          user_ID = NVL (giis_users_pkg.app_user, USER),
          LAST_UPDATE = SYSDATE
          WHERE SL_TYPE_CD = ws_sl_type_cd
          AND SL_CD = :NEW.payee_no;
      END IF;
      END IF;
      END IF;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20080,'PAYEE CLASS CODE ' || :NEW.payee_class_cd || 'not found.');
  END;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR(-20779,'FUND_CD not found in GIAC_PARAMETERS.');
END;
/



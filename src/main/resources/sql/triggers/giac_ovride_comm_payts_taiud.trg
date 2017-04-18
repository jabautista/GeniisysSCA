DROP TRIGGER CPI.GIAC_OVRIDE_COMM_PAYTS_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GIAC_OVRIDE_COMM_PAYTS_TAIUD
AFTER INSERT OR DELETE OR UPDATE OF comm_amt, wtax_amt ON CPI.GIAC_OVRIDE_COMM_PAYTS REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
  ws_tran_id     GIAC_TAXES_WHELD.gacc_tran_id%TYPE := NVL(:NEW.gacc_tran_id, :OLD.gacc_tran_id);
  ws_gen_type    GIAC_TAXES_WHELD.gen_type%TYPE;
  ws_pclass_cd   GIAC_TAXES_WHELD.payee_class_cd%TYPE;
  ws_item_no     GIAC_TAXES_WHELD.item_no%TYPE;
  ws_payee_cd    GIAC_TAXES_WHELD.payee_cd%TYPE := NVL(:NEW.intm_no, :OLD.intm_no);
  ws_tax_id      GIAC_TAXES_WHELD.gwtx_whtax_id%TYPE ;
  ws_income      GIAC_TAXES_WHELD.income_amt%TYPE := NVL(:NEW.comm_amt, :OLD.comm_amt);
  ws_whtax       GIAC_TAXES_WHELD.wholding_tax_amt%TYPE := NVL(:NEW.wtax_amt, :OLD.wtax_amt);
  ws_tran_type   GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE := NVL(:NEW.transaction_type, :OLD.transaction_type);
  ws_tax_cd      GIAC_WHOLDING_TAXES.whtax_code%TYPE ;
  ws_corp_tag    GIIS_INTERMEDIARY.corp_tag%TYPE;
BEGIN
  BEGIN
    SELECT generation_type
      INTO ws_gen_type
      FROM GIAC_MODULES
     WHERE module_name = 'GIACS040';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20004, 'NO RECORDS IN GIAC MODULES TABLE.');
  END;
  BEGIN
    SELECT param_value_v
      INTO ws_pclass_cd
      FROM GIAC_PARAMETERS
     WHERE param_name = 'INTM_CLASS_CD';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20004, 'NO RECORDS IN GIAC PARAMETERS TABLE.');
  END;
/*
  BEGIN
    SELECT corp_tag
      INTO ws_corp_tag
      FROM GIIS_INTERMEDIARY
     WHERE intm_no = ws_payee_cd;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20004, 'NO RECORDS IN GIIS INTERMEDIARY TABLE.');
  END;
  IF ws_corp_tag = 'Y' THEN
     BEGIN
       SELECT param_value_n
         INTO ws_tax_cd
         FROM GIAC_PARAMETERS
        WHERE param_name = 'CORP_WHTAX_CD';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20005, 'NO RECORDS IN GIAC_PARAMETERS TABLE.');
     END;
  ELSE
     BEGIN
       SELECT param_value_n
         INTO ws_tax_cd
         FROM GIAC_PARAMETERS
        WHERE param_name = 'INTM_WHTAX_CD';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20005, 'NO RECORDS IN GIAC_PARAMETERS TABLE.');
     END;
  END IF;
  BEGIN
    IF ws_tax_cd IS NOT NULL THEN
       BEGIN
         SELECT whtax_id
           INTO ws_tax_id
           FROM GIAC_WHOLDING_TAXES
          WHERE NVL(end_dt, TRUNC(SYSDATE)) >= TRUNC(SYSDATE)
            AND whtax_code = ws_tax_cd;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20006, 'NO RECORDS IN W/HOLDING TAXES TABLE.');
       END;
    END IF;
  END;
*/
/* modified by judyann 07192005;
** get the withholding tax id applicable to the intermediary
** as maintained in the intermediaries table
*/
  BEGIN
    SELECT whtax_id
      INTO ws_tax_id
      FROM GIIS_INTERMEDIARY
     WHERE intm_no = ws_payee_cd;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20004, 'NO RECORDS IN GIIS INTERMEDIARY TABLE.');
  END;
  BEGIN
    SELECT NVL(MAX(item_no), 0) item_no
      INTO ws_item_no
      FROM GIAC_TAXES_WHELD
     WHERE gacc_tran_id = ws_tran_id;
  END;
  BEGIN
    SELECT income_amt, wholding_tax_amt
      INTO ws_income, ws_whtax
      FROM GIAC_TAXES_WHELD
     WHERE gacc_tran_id = ws_tran_id
       AND payee_class_cd = ws_pclass_cd
       AND payee_cd = ws_payee_cd
       AND gen_type = ws_gen_type;
    IF INSERTING THEN
       ws_income := ws_income + NVL(:NEW.comm_amt, :OLD.comm_amt);
       ws_whtax  := ws_whtax + NVL(:NEW.wtax_amt, :OLD.wtax_amt);
       UPDATE GIAC_TAXES_WHELD
          SET income_amt = ws_income,
              wholding_tax_amt = ws_whtax
        WHERE gacc_tran_id = ws_tran_id
          AND payee_class_cd = ws_pclass_cd
          AND payee_cd = ws_payee_cd
          AND gen_type = ws_gen_type;
    ELSIF DELETING THEN
       ws_income := NVL(ws_income, 0) -
                    NVL(:OLD.comm_amt, 0);
       ws_whtax  := NVL(ws_whtax, 0) -
                    NVL(:OLD.wtax_amt, 0);
       IF ws_income = 0 THEN
          DELETE FROM GIAC_TAXES_WHELD
           WHERE gacc_tran_id = ws_tran_id
             AND payee_class_cd = ws_pclass_cd
             AND payee_cd = ws_payee_cd
             AND gen_type = ws_gen_type;
       ELSE
          UPDATE GIAC_TAXES_WHELD
             SET income_amt = ws_income,
                 wholding_tax_amt = ws_whtax
           WHERE gacc_tran_id = ws_tran_id
             AND payee_class_cd = ws_pclass_cd
             AND payee_cd = ws_payee_cd
             AND gen_type = ws_gen_type;
       END IF;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ws_item_no := ws_item_no + 1;
      INSERT INTO GIAC_TAXES_WHELD(gacc_tran_id , gen_type, payee_class_cd, item_no,
                                   gwtx_whtax_id, payee_cd, income_amt    ,
                                   wholding_tax_amt,
                                   remarks      , user_id , last_update)
                            VALUES(ws_tran_id, ws_gen_type, ws_pclass_cd, ws_item_no,
                                   ws_tax_id , ws_payee_cd, ws_income   , ws_whtax    ,
                                   'THIS IS GENERATED BY THE SYSTEM AFTER INSERT ON OVERRIDING COMMISSION TABLE.', NVL (giis_users_pkg.app_user, USER)     , SYSDATE);
    WHEN TOO_MANY_ROWS THEN
      RAISE_APPLICATION_ERROR(-20005, 'TOO MANY RECORDS FOUND IN GIAC TAXES WHELD TABLE.');
  END;
END;
/



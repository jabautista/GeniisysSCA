DROP TRIGGER CPI.GIAC_COMM_PAYTS_TAIXD;

CREATE OR REPLACE TRIGGER CPI.GIAC_COMM_PAYTS_TAIXD
AFTER INSERT OR DELETE
ON CPI.GIAC_COMM_PAYTS FOR EACH ROW
DECLARE
--
-- Populates/deletes corresponding record in giac_taxes_withheld
-- after GIACS007 or GIACS020 modules inserts/deletes from
-- giac_comm_payts (commission payment table).
--
-- TABLES AFFECTED     TRANSACTION TYPE      COLUMNS
--
-- giac_taxes_wheld    update / insert / delete  wholding_tax_amt
--                          income_amt
--
  ws_tran_id     GIAC_TAXES_WHELD.gacc_tran_id%TYPE := NVL(:NEW.gacc_tran_id, :OLD.gacc_tran_id);
  ws_gen_type    GIAC_TAXES_WHELD.gen_type%TYPE;
  ws_pclass_cd   GIAC_TAXES_WHELD.payee_class_cd%TYPE;
  ws_item_no     GIAC_TAXES_WHELD.item_no%TYPE;
  ws_payee_cd    GIAC_TAXES_WHELD.payee_cd%TYPE := NVL(:NEW.intm_no, :OLD.intm_no);
  ws_tax_id      GIAC_TAXES_WHELD.gwtx_whtax_id%TYPE ;
  ws_income      GIAC_TAXES_WHELD.income_amt%TYPE := NVL(:NEW.comm_amt, :OLD.comm_amt);
  ws_whtax       GIAC_TAXES_WHELD.wholding_tax_amt%TYPE := NVL(:NEW.wtax_amt, :OLD.wtax_amt);
  ws_tran_type   GIAC_COMM_PAYTS.tran_type%TYPE := NVL(:NEW.tran_type, :OLD.tran_type);
  ws_tax_cd      GIAC_WHOLDING_TAXES.whtax_code%TYPE ;
  ws_corp_tag    GIIS_INTERMEDIARY.corp_tag%TYPE;
BEGIN
  --
  -- Populate generation type from GIAC MODULES using the transaction type.
  -- Transaction type 5 is for GIACS007 and GIACS020 for others.
  --
  BEGIN
    IF ws_tran_type = '5' THEN
      BEGIN
        SELECT generation_type
          INTO ws_gen_type
          FROM giac_modules
         WHERE module_name = 'GIACS007';
      EXCEPTION
         WHEN no_data_found THEN
           RAISE_APPLICATION_ERROR(-20003, 'No records in GIAC MODULES table.');
      END;
    ELSE
      BEGIN
        SELECT generation_type
          INTO ws_gen_type
          FROM giac_modules
         WHERE module_name = 'GIACS020';
      EXCEPTION
        WHEN no_data_found THEN
          RAISE_APPLICATION_ERROR(-20004, 'No records in GIAC MODULES table.');
      END;
    END IF;
  END;
  --
  -- Get the payee class code
  --
  BEGIN
    SELECT param_value_v
      INTO ws_pclass_cd
      FROM giac_parameters
     WHERE param_name = 'INTM_CLASS_CD';
  EXCEPTION
    WHEN no_data_found THEN
      RAISE_APPLICATION_ERROR(-20004, 'No records in GIAC PARAMETERS table.');
  END;
  --
  -- Populate corporate tag...
  --
  BEGIN
    SELECT corp_tag
      INTO ws_corp_tag
      FROM giis_intermediary
     WHERE intm_no = ws_payee_cd;
  EXCEPTION
    WHEN no_data_found THEN
      RAISE_APPLICATION_ERROR(-20004, 'No records in GIIS INTERMEDIARY table.');
  END;
  --
  -- Populate the WITHHOLDING TAX ID...
  --
  BEGIN
    IF ws_corp_tag = 'Y' THEN
      BEGIN
        SELECT param_value_n
          INTO ws_tax_cd
          FROM giac_parameters
         WHERE param_name = 'CORP_WHTAX_CD';
      EXCEPTION
        WHEN no_data_found THEN
          RAISE_APPLICATION_ERROR(-20005, 'No records in GIAC_PARAMETERS table.');
      END;
    ELSE
      BEGIN
        SELECT param_value_n
          INTO ws_tax_cd
          FROM giac_parameters
         WHERE param_name = 'INTM_WHTAX_CD';
      EXCEPTION
        WHEN no_data_found THEN
          RAISE_APPLICATION_ERROR(-20005, 'No records in GIAC_PARAMETERS table.');
      END;
    END IF;
    BEGIN
      IF ws_tax_cd IS NOT NULL THEN
        BEGIN
          SELECT whtax_id
            INTO ws_tax_id
            FROM giac_wholding_taxes
           WHERE NVL(end_dt, TRUNC(sysdate)) >= TRUNC(sysdate)
             AND whtax_code = ws_tax_cd;
        EXCEPTION
          WHEN no_data_found THEN
            RAISE_APPLICATION_ERROR(-20006, 'No records in W/HOLDING TAXES table.');
        END;
      END IF;
    END;
  END;
  --
  --
  BEGIN
    --
    -- Get the next item no
    --
    BEGIN
      SELECT NVL(MAX(item_no), 0) item_no
        INTO ws_item_no
        FROM giac_taxes_wheld
       WHERE gacc_tran_id = ws_tran_id;
    END;
    BEGIN
      SELECT income_amt, wholding_tax_amt
        INTO ws_income, ws_whtax
        FROM giac_taxes_wheld
       WHERE gacc_tran_id   = ws_tran_id
         AND payee_class_cd = ws_pclass_cd
         AND payee_cd       = ws_payee_cd
         AND gen_type       = ws_gen_type;
       IF inserting THEN
         ws_income := ws_income + NVL(:NEW.comm_amt, :OLD.comm_amt);
         ws_whtax  := ws_whtax + NVL(:NEW.wtax_amt, :OLD.wtax_amt);
         UPDATE giac_taxes_wheld
            SET income_amt       = ws_income,
                wholding_tax_amt = ws_whtax
          WHERE gacc_tran_id   = ws_tran_id
            AND payee_class_cd = ws_pclass_cd
            AND payee_cd       = ws_payee_cd
            AND gen_type       = ws_gen_type;
         IF SQL%NOTFOUND THEN
       RAISE_APPLICATION_ERROR(-20007,'Cannot update to table GIAC_TAXES_WHELD');
     END IF;
       ELSIF deleting THEN
         ws_income := NVL(ws_income, 0) - NVL(:OLD.comm_amt, 0);
         ws_whtax  := NVL(ws_whtax, 0) - NVL(:OLD.wtax_amt, 0);
         IF ws_income = 0 THEN
           DELETE FROM giac_taxes_wheld
            WHERE gacc_tran_id   = ws_tran_id
              AND payee_class_cd = ws_pclass_cd
              AND payee_cd       = ws_payee_cd
              AND gen_type       = ws_gen_type;
           IF SQL%NOTFOUND THEN
         RAISE_APPLICATION_ERROR(-20007,'Cannot delete from table GIAC_TAXES_WHELD');
           END IF;
         ELSE
           UPDATE giac_taxes_wheld
              SET income_amt = ws_income,
                  wholding_tax_amt = ws_whtax
            WHERE gacc_tran_id = ws_tran_id
              AND payee_class_cd = ws_pclass_cd
              AND payee_cd = ws_payee_cd
              AND gen_type = ws_gen_type;
           IF SQL%NOTFOUND THEN
         RAISE_APPLICATION_ERROR(-20007,'Cannot update from table GIAC_TAXES_WHELD');
           END IF;
         END IF;
       END IF;
    EXCEPTION
      WHEN no_data_found THEN
        ws_item_no := ws_item_no + 1;
        INSERT INTO GIAC_TAXES_WHELD(
             gacc_tran_id,  gen_type,    payee_class_cd, item_no,
             gwtx_whtax_id, payee_cd,    income_amt,     wholding_tax_amt,
             remarks,
             user_id,       last_update)
        VALUES(
             ws_tran_id,    ws_gen_type, ws_pclass_cd,   ws_item_no,
             ws_tax_id,     ws_payee_cd, ws_income,      ws_whtax,
             'This is generated by the system after insert on COMMISSION PAYMENT table.',
             NVL (giis_users_pkg.app_user, USER),          SYSDATE);
      WHEN too_many_rows THEN
        RAISE_APPLICATION_ERROR(-20005, 'Too many records found in GIAC TAXES WHELD table.');
    END;
  END;
END;
/

ALTER TRIGGER CPI.GIAC_COMM_PAYTS_TAIXD DISABLE;



CREATE OR REPLACE TRIGGER CPI.GIAC_COMM_PAYTS_TAIUD
   AFTER INSERT OR UPDATE OR DELETE
   ON CPI.GIAC_COMM_PAYTS    REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
BEGIN
   IF NVL(giacp.v('BATCH_GEN_WTAX'), 'N') = 'N' THEN --added by mikel 06.15.2015; Wtax enhancements, BIR demo findings.
       BEGIN
          DECLARE
             ws_tran_id     giac_taxes_wheld.gacc_tran_id%TYPE := NVL (:NEW.gacc_tran_id, :OLD.gacc_tran_id);
             ws_gen_type    giac_taxes_wheld.gen_type%TYPE;
             ws_pclass_cd   giac_taxes_wheld.payee_class_cd%TYPE;
             ws_item_no     giac_taxes_wheld.item_no%TYPE;
             ws_payee_cd    giac_taxes_wheld.payee_cd%TYPE := NVL (:NEW.parent_intm_no, :OLD.parent_intm_no);
             ws_tax_id      giac_taxes_wheld.gwtx_whtax_id%TYPE;
             ws_income      giac_taxes_wheld.income_amt%TYPE := NVL (:NEW.comm_amt, :OLD.comm_amt);
             ws_whtax       giac_taxes_wheld.wholding_tax_amt%TYPE := NVL (:NEW.wtax_amt, :OLD.wtax_amt);
             ws_tran_type   giac_comm_payts.tran_type%TYPE  := NVL (:NEW.tran_type, :OLD.tran_type);
             ws_sl_cd       giac_taxes_wheld.sl_cd%TYPE; --Added by Jerome 09.28.2016 SR 5664
             ws_sl_type_cd  giac_taxes_wheld.sl_type_cd%TYPE; --Added by Jerome 09.28.2016 SR 5664
          BEGIN
    --
    -- Populate generation type from GIAC MODULES using the transaction type.
    -- Transaction type 5 is for GIACS007 and GIACS020 for others.
    --
             BEGIN
                IF ws_tran_type = '5'
                THEN
                   BEGIN
                      SELECT generation_type
                        INTO ws_gen_type
                        FROM giac_modules
                       WHERE module_name = 'GIACS007';
                   EXCEPTION
                      WHEN NO_DATA_FOUND
                      THEN
                         RAISE_APPLICATION_ERROR (-20003, 'No records in GIAC MODULES table.');
                   END;
                ELSE
                   BEGIN
                      SELECT generation_type
                        INTO ws_gen_type
                        FROM giac_modules
                       WHERE module_name = 'GIACS020';
                   EXCEPTION
                      WHEN NO_DATA_FOUND
                      THEN
                         RAISE_APPLICATION_ERROR (-20004, 'No records in GIAC MODULES table.');
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
                WHEN NO_DATA_FOUND
                THEN
                   RAISE_APPLICATION_ERROR (-20004, 'No records in GIAC PARAMETERS table.');
             END;

    --
    -- Populate the WITHHOLDING TAX ID...
    --
             BEGIN
                SELECT whtax_id
                  INTO ws_tax_id
                  FROM giis_intermediary
                 WHERE intm_no = ws_payee_cd;
                
                --Added by reymon 03252013
                --if whtax_id is null
                IF ws_tax_id IS NULL THEN
                    RAISE_APPLICATION_ERROR (-20004, 'No records in GIIS INTERMEDIARY table.');
                END IF;
                 
             EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                   RAISE_APPLICATION_ERROR (-20004, 'No records in GIIS INTERMEDIARY table.');
             END;

    --
    --
    --
             BEGIN
    --
                SELECT sl_cd, sl_type_cd
                  INTO ws_sl_cd, ws_sl_type_cd
                  FROM giac_sl_lists
                 WHERE sl_cd = ws_payee_cd
                   AND sl_type_cd = ws_pclass_cd;
    -- Get the next item no
    --
                BEGIN
                   SELECT NVL (MAX (item_no), 0) item_no
                     INTO ws_item_no
                     FROM giac_taxes_wheld
                    WHERE gacc_tran_id = ws_tran_id;
                END;

                BEGIN
                   SELECT income_amt, wholding_tax_amt
                     INTO ws_income, ws_whtax
                     FROM giac_taxes_wheld
                    WHERE gacc_tran_id = ws_tran_id
                      AND payee_class_cd = ws_pclass_cd
                      AND payee_cd = ws_payee_cd
                      AND gen_type = ws_gen_type;

                   IF INSERTING
                   THEN
                      ws_income := NVL(ws_income,0) + NVL (:NEW.comm_amt, :OLD.comm_amt);
                      ws_whtax := NVL(ws_whtax,0) + NVL (:NEW.wtax_amt, :OLD.wtax_amt);

                      UPDATE giac_taxes_wheld
                         SET income_amt = ws_income,
                             wholding_tax_amt = ws_whtax
                       WHERE gacc_tran_id = ws_tran_id
                         AND payee_class_cd = ws_pclass_cd
                         AND payee_cd = ws_payee_cd
                         AND gen_type = ws_gen_type;
                   ELSIF DELETING
                   THEN
                      ws_income := NVL (ws_income, 0) - NVL (:OLD.comm_amt, 0);
                      ws_whtax := NVL (ws_whtax, 0) - NVL (:OLD.wtax_amt, 0);

                      IF ws_income = 0
                      THEN
                         DELETE FROM giac_taxes_wheld
                               WHERE gacc_tran_id = ws_tran_id
                                 AND payee_class_cd = ws_pclass_cd
                                 AND payee_cd = ws_payee_cd
                                 AND gen_type = ws_gen_type;
                      ELSE
                         UPDATE giac_taxes_wheld
                            SET income_amt = ws_income,
                                wholding_tax_amt = ws_whtax
                          WHERE gacc_tran_id = ws_tran_id
                            AND payee_class_cd = ws_pclass_cd
                            AND payee_cd = ws_payee_cd
                            AND gen_type = ws_gen_type;
                      END IF;
                   END IF;
                EXCEPTION
                   WHEN NO_DATA_FOUND
                   THEN
                      ws_item_no := ws_item_no + 1;

                      INSERT INTO giac_taxes_wheld
                                  (gacc_tran_id, gen_type, payee_class_cd,
                                   item_no, gwtx_whtax_id, payee_cd,
                                   income_amt, wholding_tax_amt,
                                   remarks,
                                   user_id, last_update, sl_cd, sl_type_cd --sl_cd, sl_type_cd Added by Jerome 09.28.2016 SR 5664
                                  )
                           VALUES (ws_tran_id, ws_gen_type, ws_pclass_cd,
                                   ws_item_no, ws_tax_id, ws_payee_cd,
                                   ws_income, ws_whtax,
                                   'This is generated by the system after insert on COMMISSION PAYMENT table.',
                                   NVL (giis_users_pkg.app_user, USER), SYSDATE, ws_sl_cd, ws_sl_type_cd --ws_sl_cd, ws_sl_type_cd Added by Jerome 09.28.2016 SR 5664
                                  );
                   WHEN TOO_MANY_ROWS
                   THEN
                      RAISE_APPLICATION_ERROR (-20005, 'Too many records found in GIAC TAXES WHELD table.');
                END;
             END;
          END;
       END;
   END IF; 
END;
/



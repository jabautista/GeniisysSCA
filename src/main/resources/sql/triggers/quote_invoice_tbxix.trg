DROP TRIGGER CPI.QUOTE_INVOICE_TBXIX;

CREATE OR REPLACE TRIGGER CPI.QUOTE_INVOICE_TBXIX
BEFORE INSERT
ON CPI.GIPI_QUOTE_INVOICE FOR EACH ROW
DECLARE
BEGIN
  DECLARE
      v_quote_inv_no     gipi_quote_invoice.quote_inv_no%TYPE;
  BEGIN
      v_quote_inv_no    :=  NULL;
      FOR A IN (SELECT QUOTE_INV_NO,ROWID
                  FROM GIIS_QUOTE_INV_SEQ
                WHERE ISS_CD = :NEW.ISS_CD
                FOR UPDATE OF QUOTE_INV_NO) LOOP
           v_quote_inv_no  :=  NVL(A.QUOTE_INV_NO,0) + 1;
           BEGIN
           UPDATE giis_quote_inv_seq
             SET quote_inv_no =  v_quote_inv_no
           WHERE ROWID        =  A.ROWID;
           EXCEPTION
              WHEN DUP_VAL_ON_INDEX THEN
                 RAISE_APPLICATION_ERROR(-200001,'Duplicate record in GIIS_QUOTE_INV_SEQ found.');
           END;
           :new.quote_inv_no  :=  v_quote_inv_no;
           EXIT;
      END LOOP;
      IF v_quote_inv_no IS NULL THEN
         BEGIN
         INSERT INTO GIIS_QUOTE_INV_SEQ
             (ISS_CD,QUOTE_INV_NO)
         VALUES (:NEW.ISS_CD,1);
         EXCEPTION
           WHEN DUP_VAL_ON_INDEX THEN
              RAISE_APPLICATION_ERROR(-200001,'Duplicate record in GIIS_QUOTE_INV_SEQ found.');
         END;
      END IF;
  END;
END;
/



/*
** Created by: Paolo J. Santos
** Date: 12.27.2016
** Description: Created table GIAC_PRINTED_BIR2307_HIST based on AC-SPECS-2014-033
*/
SET SERVEROUTPUT ON

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM all_objects
              WHERE owner LIKE 'CPI'
                AND object_name = 'GIAC_PRINTED_BIR2307_HIST')
   LOOP
      v_exists := 'Y';
   END LOOP;

   IF v_exists = 'N'
   THEN
      EXECUTE IMMEDIATE 'CREATE TABLE CPI.GIAC_PRINTED_BIR2307_HIST
(
  BIR_HIST_NO       NUMBER(12),
  GACC_TRAN_ID      NUMBER(12),
  PAYEE_CD          NUMBER(12),
  PAYEE_CLASS_CD    VARCHAR2(2),
  GWTX_WHTAX_ID     NUMBER(5),
  PRINT_SEQ_NO      NUMBER(2),
  BIR_TAX_CD        VARCHAR2(10)                ,
  WHTAX_RT          NUMBER(3)                   ,
  INCOME_AMT        NUMBER(12,2)                ,
  WHOLDING_TAX_AMT  NUMBER(12,2)                ,
  USER_ID           VARCHAR2(8),
  LAST_UPDATE       DATE
)
TABLESPACE ACCTG_DATA';

      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_PRINTED_BIR2307_HIST 
          ADD (CONSTRAINT PRINTED_BIR2307_HIST_PK 
      PRIMARY KEY(BIR_HIST_NO))';

      EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM GIAC_PRINTED_BIR2307_HIST FOR CPI.GIAC_PRINTED_BIR2307_HIST';

      EXECUTE IMMEDIATE 'GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIAC_PRINTED_BIR2307_HIST TO PUBLIC';

      DBMS_OUTPUT.put_line ('GIAC_PRINTED_BIR2307_HIST has been created.');
   ELSE
      DBMS_OUTPUT.put_line ('GIAC_PRINTED_BIR2307_HIST already exists.');
   END IF;
END;
/

COMMENT ON COLUMN cpi.giac_printed_bir2307_hist.gacc_tran_id IS 'Transation ID of commision payment';

COMMENT ON COLUMN cpi.giac_printed_bir2307_hist.payee_cd IS 'Payee';

COMMENT ON COLUMN cpi.giac_printed_bir2307_hist.payee_class_cd IS 'Payee Class';

COMMENT ON COLUMN cpi.giac_printed_bir2307_hist.gwtx_whtax_id IS 'Withholding tax ID';

COMMENT ON COLUMN cpi.giac_printed_bir2307_hist.print_seq_no IS 'Number of times report was printed';

COMMENT ON COLUMN cpi.giac_printed_bir2307_hist.bir_tax_cd IS 'BIR Tax code in GIACS022';

COMMENT ON COLUMN cpi.giac_printed_bir2307_hist.whtax_rt IS 'Rate reflected in the module';

COMMENT ON COLUMN cpi.giac_printed_bir2307_hist.income_amt IS 'Income Amount reflected on the report';

COMMENT ON COLUMN cpi.giac_printed_bir2307_hist.wholding_tax_amt IS 'Withholding Tax amount reflected on the report';

COMMENT ON COLUMN cpi.giac_printed_bir2307_hist.user_id IS 'user ID of the user who last updated the record';

COMMENT ON COLUMN cpi.giac_printed_bir2307_hist.last_update IS 'Date record was updated';
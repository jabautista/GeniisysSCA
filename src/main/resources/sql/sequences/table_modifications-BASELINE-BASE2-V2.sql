SET serveroutput ON

------------------
-- CREATE TABLE --
------------------

-- GIAC_ORDER_OF_PAYTS_TEMP
DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_tables
    WHERE UPPER (table_name) = 'GIAC_ORDER_OF_PAYTS_TEMP';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('GIAC_ORDER_OF_PAYTS_TEMP already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE ('CREATE TABLE CPI.GIAC_ORDER_OF_PAYTS_TEMP
                            (
                              GACC_TRAN_ID       NUMBER(12),
                              GIBR_GFUN_FUND_CD  VARCHAR2(3 BYTE),
                              GIBR_BRANCH_CD     VARCHAR2(2 BYTE),
                              OR_FLAG            VARCHAR2(1 BYTE),
                              OR_PREF_SUF        VARCHAR2(5 BYTE),
                              OR_NO              NUMBER(10),
                              OR_DATE            DATE,
                              DSP_OR_DATE        VARCHAR2(30 BYTE),
                              DSP_OR_PREF        VARCHAR2(20 BYTE),
                              DSP_OR_NO          VARCHAR2(20 BYTE),
                              PAYOR              VARCHAR2(550 BYTE),
                              PARTICULARS        VARCHAR2(500 BYTE),
                              NBT_REPL_OR_TAG    VARCHAR2(1 BYTE),
                              NBT_TRAN_FLAG      VARCHAR2(1 BYTE),
                              GENERATE_FLAG      VARCHAR2(1 BYTE),
                              PRINTED_FLAG       VARCHAR2(1 BYTE),
                              OR_TYPE            VARCHAR2(1 BYTE)
                            )
                            TABLESPACE ACCTG_DATA
                            PCTUSED    0
                            PCTFREE    20
                            INITRANS   1
                            MAXTRANS   255
                            STORAGE    (
                                        INITIAL          9728K
                                        NEXT             128K
                                        MINEXTENTS       1
                                        MAXEXTENTS       UNLIMITED
                                        PCTINCREASE      0
                                        BUFFER_POOL      DEFAULT
                                       )
                            LOGGING 
                            NOCOMPRESS 
                            NOCACHE
                            NOPARALLEL
                            MONITORING');

      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIAC_ORDER_OF_PAYTS_TEMP FOR CPI.GIAC_ORDER_OF_PAYTS_TEMP');

      EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON CPI.GIAC_ORDER_OF_PAYTS_TEMP TO PUBLIC');

      DBMS_OUTPUT.put_line ('GIAC_ORDER_OF_PAYTS_TEMP created.');
END;


-----------------
-- ADD COLUMNS --
-----------------

-- GIAC_BANK_COMM_PAYT_DTL_EXT.COMMISSION_AMT
DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_BANK_COMM_PAYT_DTL_EXT'
       AND UPPER(column_name) = 'COMMISSION_AMT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column COMMISSION_AMT to table GIAC_BANK_COMM_PAYT_DTL_EXT...');
        EXECUTE IMMEDIATE 'ALTER TABLE giac_bank_comm_payt_dtl_ext add commission_amt NUMBER(12,2)';
        dbms_output.put_line('Column added.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('COMMISSION_AMT column already exist at GIAC_BANK_COMM_PAYT_DTL_EXT table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_PREV_COMM_INV.CREATE_DATE
DECLARE
   v_count       NUMBER (1)      := 0;
   v_alter_col   VARCHAR2 (1000)
      := 'ALTER TABLE GIAC_PREV_COMM_INV 
                        ADD CREATE_DATE DATE';
BEGIN
   SELECT COUNT (1)
     INTO v_count
     FROM all_tab_columns
    WHERE table_name = 'GIAC_PREV_COMM_INV'
      AND column_name = 'CREATE_DATE'
      AND owner = 'CPI';

   IF v_count = 0
   THEN
      EXECUTE IMMEDIATE v_alter_col;
      DBMS_OUTPUT.put_line ('CREATE_DATE is successfully added!');
   ELSE
      DBMS_OUTPUT.PUT_LINE('CREATE_DATE column already exists at GIAC_PREV_COMM_INV table.');
   END IF;
END;


-- GIAC_BANK_COMM_PAYT_DTL_EXT.INPUT_VAT
DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_BANK_COMM_PAYT_DTL_EXT'
       AND UPPER(column_name) = 'INPUT_VAT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column INPUT_VAT to table GIAC_BANK_COMM_PAYT_DTL_EXT...');
        EXECUTE IMMEDIATE 'ALTER TABLE giac_bank_comm_payt_dtl_ext add input_vat NUMBER(12,2)';
        dbms_output.put_line('Column added.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('INPUT_VAT column already exist at GIAC_BANK_COMM_PAYT_DTL_EXT table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_BANK_COMM_PAYT_DTL_EXT.NET_COMM_PAID
DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_BANK_COMM_PAYT_DTL_EXT'
       AND UPPER(column_name) = 'NET_COMM_PAID';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column NET_COMM_PAID to table GIAC_BANK_COMM_PAYT_DTL_EXT...');
        EXECUTE IMMEDIATE 'ALTER TABLE giac_bank_comm_payt_dtl_ext add net_comm_paid NUMBER(12,2)';
        dbms_output.put_line('Column added.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NET_COMM_PAID column already exist at GIAC_BANK_COMM_PAYT_DTL_EXT table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_UPLOAD_PREM_REFNO.REC_ID
DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_UPLOAD_PREM_REFNO'
       AND UPPER(column_name) = 'REC_ID';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column REC_ID to table GIAC_UPLOAD_PREM_REFNO...');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_UPLOAD_PREM_REFNO add rec_id NUMBER(5)';
        dbms_output.put_line('Column added.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('REC_ID column already exist at GIAC_UPLOAD_PREM_REFNO table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_BANK_COMM_PAYT_DTL_EXT.WHOLDING_TAX
DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_BANK_COMM_PAYT_DTL_EXT'
       AND UPPER(column_name) = 'WHOLDING_TAX';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column WHOLDING_TAX to table GIAC_BANK_COMM_PAYT_DTL_EXT...');
        EXECUTE IMMEDIATE 'ALTER TABLE giac_bank_comm_payt_dtl_ext add wholding_tax NUMBER(12,2)';
        dbms_output.put_line('Column added.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('WHOLDING_TAX column already exist at GIAC_BANK_COMM_PAYT_DTL_EXT table.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


--------------------
-- MODIFY COLUMNS --
--------------------

-- GIAC_AGING_SOA_DETAILS.BALANCE_AMT_DUE
--DECLARE
--   v_exists   NUMBER (1) := 0;
--BEGIN
--   SELECT 1
--     INTO v_exists
--     FROM all_tab_cols
--    WHERE table_name = 'GIAC_AGING_SOA_DETAILS'
--      AND owner = 'CPI'
--      AND column_name = 'BALANCE_AMT_DUE'
--      AND data_precision <> 16
--      AND data_scale <> 2;

--   IF v_exists = 1
--   THEN
--      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_AGING_SOA_DETAILS MODIFY BALANCE_AMT_DUE NUMBER(16,2)';

--      DBMS_OUTPUT.put_line ('Successfully modified GIAC_AGING_SOA_DETAILS.BALANCE_AMT_DUE length to (16,2).');
--   END IF;
--EXCEPTION
--   WHEN NO_DATA_FOUND
--   THEN
--      DBMS_OUTPUT.put_line ('Data length of GIAC_AGING_SOA_DETAILS.BALANCE_AMT_DUE column is already (16,2).');
--END;


-- GIIS_COVERAGE.COVERAGE_CD
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GIIS_COVERAGE'
      AND owner = 'CPI'
      AND column_name = 'COVERAGE_CD'
      AND data_precision <> 5;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIIS_COVERAGE MODIFY COVERAGE_CD NUMBER(5)';

      DBMS_OUTPUT.put_line ('Successfully modified GIIS_COVERAGE.COVERAGE_CD length to 5.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GIIS_COVERAGE.COVERAGE_CD column is already 5.');
END;


-- GICL_CLAIMS.EXP_RES_AMT
ALTER TABLE gicl_claims
MODIFY exp_res_amt number(16,2);

--DECLARE
--   v_exists   NUMBER (1) := 0;
--BEGIN
--   SELECT 1
--     INTO v_exists
--     FROM all_tab_cols
--    WHERE table_name = 'GICL_CLAIMS'
--      AND owner = 'CPI'
--      AND column_name = 'EXP_RES_AMT'
--      AND data_precision <> 16
--      AND data_scale <> 2;

--   IF v_exists = 1
--   THEN
--      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GICL_CLAIMS MODIFY EXP_RES_AMT NUMBER(16,2)';

--      DBMS_OUTPUT.put_line ('Successfully modified GICL_CLAIMS.EXP_RES_AMT length to (16,2).');
--   END IF;
--EXCEPTION
--   WHEN NO_DATA_FOUND
--   THEN
--      DBMS_OUTPUT.put_line ('Data length of GICL_CLAIMS.EXP_RES_AMT column is already (16,2).');
--END;


-- GIPI_QUOTE_ITEM.MC_MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GIPI_QUOTE_ITEM'
      AND owner = 'CPI'
      AND column_name = 'MC_MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_QUOTE_ITEM MODIFY MC_MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GIPI_QUOTE_ITEM.MC_MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GIPI_QUOTE_ITEM.MC_MOTOR_NO column is already 30.');
END;


-- GIPI_MC_ERROR_LOG.MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GIPI_MC_ERROR_LOG'
      AND owner = 'CPI'
      AND column_name = 'MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_MC_ERROR_LOG MODIFY MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GIPI_MC_ERROR_LOG.MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GIPI_MC_ERROR_LOG.MOTOR_NO column is already 30.');
END;


-- GICL_MC_TP_DTL.MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GICL_MC_TP_DTL'
      AND owner = 'CPI'
      AND column_name = 'MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GICL_MC_TP_DTL MODIFY MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GICL_MC_TP_DTL.MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GICL_MC_TP_DTL.MOTOR_NO column is already 30.');
END;


-- GICL_NO_CLAIM_MULTI.MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GICL_NO_CLAIM_MULTI'
      AND owner = 'CPI'
      AND column_name = 'MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GICL_NO_CLAIM_MULTI MODIFY MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GICL_NO_CLAIM_MULTI.MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GICL_NO_CLAIM_MULTI.MOTOR_NO column is already 30.');
END;


-- GICL_MOTOR_CAR_DTL.MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GICL_MOTOR_CAR_DTL'
      AND owner = 'CPI'
      AND column_name = 'MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GICL_MOTOR_CAR_DTL MODIFY MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GICL_MOTOR_CAR_DTL.MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GICL_MOTOR_CAR_DTL.MOTOR_NO column is already 30.');
END;


-- GIPI_QUOTE_ITEM_MC.MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GIPI_QUOTE_ITEM_MC'
      AND owner = 'CPI'
      AND column_name = 'MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_QUOTE_ITEM_MC MODIFY MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GIPI_QUOTE_ITEM_MC.MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GIPI_QUOTE_ITEM_MC.MOTOR_NO column is already 30.');
END;


-- GIEX_PACK_EXPIRY.MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GIEX_PACK_EXPIRY'
      AND owner = 'CPI'
      AND column_name = 'MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIEX_PACK_EXPIRY MODIFY MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GIEX_PACK_EXPIRY.MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GIEX_PACK_EXPIRY.MOTOR_NO column is already 30.');
END;


-- GIEX_EXPIRY.MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GIEX_EXPIRY'
      AND owner = 'CPI'
      AND column_name = 'MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIEX_EXPIRY MODIFY MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GIEX_EXPIRY.MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GIEX_EXPIRY.MOTOR_NO column is already 30.');
END;


-- GICL_CLAIMS.MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GICL_CLAIMS'
      AND owner = 'CPI'
      AND column_name = 'MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GICL_CLAIMS MODIFY MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GICL_CLAIMS.MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GICL_CLAIMS.MOTOR_NO column is already 30.');
END;


-- GICL_NO_CLAIM.MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GICL_NO_CLAIM'
      AND owner = 'CPI'
      AND column_name = 'MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GICL_NO_CLAIM MODIFY MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GICL_NO_CLAIM.MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GICL_NO_CLAIM.MOTOR_NO column is already 30.');
END;


-- GIIS_VESSEL.MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GIIS_VESSEL'
      AND owner = 'CPI'
      AND column_name = 'MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIIS_VESSEL MODIFY MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GIIS_VESSEL.MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GIIS_VESSEL.MOTOR_NO column is already 30.');
END;


-- GIPI_MC_UPLOAD.MOTOR_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GIPI_MC_UPLOAD'
      AND owner = 'CPI'
      AND column_name = 'MOTOR_NO'
      AND data_length <> 30;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIPI_MC_UPLOAD MODIFY MOTOR_NO VARCHAR2(30)';

      DBMS_OUTPUT.put_line ('Successfully modified GIPI_MC_UPLOAD.MOTOR_NO length to 30.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GIPI_MC_UPLOAD.MOTOR_NO column is already 30.');
END;


-- GIAC_PARENT_COMM_VOUCHER.OCV_PREF_SUF
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GIAC_PARENT_COMM_VOUCHER'
      AND owner = 'CPI'
      AND column_name = 'OCV_PREF_SUF'
      AND data_length <> 5;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_PARENT_COMM_VOUCHER MODIFY OCV_PREF_SUF VARCHAR2(5)';

      DBMS_OUTPUT.put_line ('Successfully modified GIAC_PARENT_COMM_VOUCHER.OCV_PREF_SUF length to 5.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GIAC_PARENT_COMM_VOUCHER.OCV_PREF_SUF column is already 5.');
END;


-- GIAC_AGING_SOA_DETAILS.PREM_BALANCE_DUE
--DECLARE
--   v_exists   NUMBER (1) := 0;
--BEGIN
--   SELECT 1
--     INTO v_exists
--     FROM all_tab_cols
--    WHERE table_name = 'GIAC_AGING_SOA_DETAILS'
--      AND owner = 'CPI'
--      AND column_name = 'PREM_BALANCE_DUE'
--      AND data_precision <> 16
--      AND data_scale <> 2;

--   IF v_exists = 1
--   THEN
--      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_AGING_SOA_DETAILS MODIFY PREM_BALANCE_DUE NUMBER(16,2)';

--      DBMS_OUTPUT.put_line ('Successfully modified GIAC_AGING_SOA_DETAILS.PREM_BALANCE_DUE length to (16,2).');
--   END IF;
--EXCEPTION
--   WHEN NO_DATA_FOUND
--   THEN
--      DBMS_OUTPUT.put_line ('Data length of GIAC_AGING_SOA_DETAILS.PREM_BALANCE_DUE column is already (16,2).');
--END;


-- GICL_NO_CLAIM.SERIAL_NO
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GICL_NO_CLAIM'
      AND owner = 'CPI'
      AND column_name = 'SERIAL_NO'
      AND data_length <> 25;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GICL_NO_CLAIM MODIFY SERIAL_NO VARCHAR2(25)';

      DBMS_OUTPUT.put_line ('Successfully modified GICL_NO_CLAIM.SERIAL_NO length to 25.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GICL_NO_CLAIM.SERIAL_NO column is already 25.');
END;


-- GIAC_AGING_SOA_DETAILS.TAX_BALANCE_DUE
--DECLARE
--   v_exists   NUMBER (1) := 0;
--BEGIN
--   SELECT 1
--     INTO v_exists
--     FROM all_tab_cols
--    WHERE table_name = 'GIAC_AGING_SOA_DETAILS'
--      AND owner = 'CPI'
--      AND column_name = 'TAX_BALANCE_DUE'
--      AND data_precision <> 16
--      AND data_scale <> 2;

--   IF v_exists = 1
--   THEN
--      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_AGING_SOA_DETAILS MODIFY TAX_BALANCE_DUE NUMBER(16,2)';

--      DBMS_OUTPUT.put_line ('Successfully modified GIAC_AGING_SOA_DETAILS.TAX_BALANCE_DUE length to (16,2).');
--   END IF;
--EXCEPTION
--   WHEN NO_DATA_FOUND
--   THEN
--      DBMS_OUTPUT.put_line ('Data length of GIAC_AGING_SOA_DETAILS.TAX_BALANCE_DUE column is already (16,2).');
--END;


-- GIAC_AGING_SOA_DETAILS.TEMP_PAYMENTS
--DECLARE
--   v_exists   NUMBER (1) := 0;
--BEGIN
--   SELECT 1
--     INTO v_exists
--     FROM all_tab_cols
--    WHERE table_name = 'GIAC_AGING_SOA_DETAILS'
--      AND owner = 'CPI'
--      AND column_name = 'TEMP_PAYMENTS'
--      AND data_precision <> 16
--      AND data_scale <> 2;

--   IF v_exists = 1
--   THEN
--      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_AGING_SOA_DETAILS MODIFY TEMP_PAYMENTS NUMBER(16,2)';

--      DBMS_OUTPUT.put_line ('Successfully modified GIAC_AGING_SOA_DETAILS.TEMP_PAYMENTS length to (16,2).');
--   END IF;
--EXCEPTION
--   WHEN NO_DATA_FOUND
--   THEN
--      DBMS_OUTPUT.put_line ('Data length of GIAC_AGING_SOA_DETAILS.TEMP_PAYMENTS column is already (16,2).');
--END;


-- GIAC_AGING_SOA_DETAILS.TOTAL_AMOUNT_DUE
--DECLARE
--   v_exists   NUMBER (1) := 0;
--BEGIN
--   SELECT 1
--     INTO v_exists
--     FROM all_tab_cols
--    WHERE table_name = 'GIAC_AGING_SOA_DETAILS'
--      AND owner = 'CPI'
--      AND column_name = 'TOTAL_AMOUNT_DUE'
--      AND data_precision <> 16
--      AND data_scale <> 2;

--   IF v_exists = 1
--   THEN
--      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_AGING_SOA_DETAILS MODIFY TOTAL_AMOUNT_DUE NUMBER(16,2)';

--      DBMS_OUTPUT.put_line ('Successfully modified GIAC_AGING_SOA_DETAILS.TOTAL_AMOUNT_DUE length to (16,2).');
--   END IF;
--EXCEPTION
--   WHEN NO_DATA_FOUND
--   THEN
--      DBMS_OUTPUT.put_line ('Data length of GIAC_AGING_SOA_DETAILS.TOTAL_AMOUNT_DUE column is already (16,2).');
--END;


-- GIAC_AGING_SOA_DETAILS.TOTAL_PAYMENTS
--DECLARE
--   v_exists   NUMBER (1) := 0;
--BEGIN
--   SELECT 1
--     INTO v_exists
--     FROM all_tab_cols
--    WHERE table_name = 'GIAC_AGING_SOA_DETAILS'
--      AND owner = 'CPI'
--      AND column_name = 'TOTAL_PAYMENTS'
--      AND data_precision <> 16
--      AND data_scale <> 2;

--   IF v_exists = 1
--   THEN
--      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_AGING_SOA_DETAILS MODIFY TOTAL_PAYMENTS NUMBER(16,2)';

--      DBMS_OUTPUT.put_line ('Successfully modified GIAC_AGING_SOA_DETAILS.TOTAL_PAYMENTS length to (16,2).');
--   END IF;
--EXCEPTION
--   WHEN NO_DATA_FOUND
--   THEN
--      DBMS_OUTPUT.put_line ('Data length of GIAC_AGING_SOA_DETAILS.TOTAL_PAYMENTS column is already (16,2).');
--END;

-- GIAC_AGING_SOA_DETAILS columns
ALTER TABLE giac_aging_soa_details
MODIFY balance_amt_due NUMBER(16,2);

ALTER TABLE giac_aging_soa_details
MODIFY total_amount_due NUMBER(16,2);

ALTER TABLE giac_aging_soa_details
MODIFY total_payments NUMBER(16,2);

ALTER TABLE giac_aging_soa_details
MODIFY temp_payments NUMBER(16,2);

ALTER TABLE giac_aging_soa_details
MODIFY prem_balance_due NUMBER(16,2);

ALTER TABLE giac_aging_soa_details
MODIFY tax_balance_due NUMBER(16,2);


------------------
-- DROP COLUMNS --
------------------

DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIAC_BANK_COMM_PAYT_DTL_EXT'
       AND UPPER(column_name) = 'ASSD_NO'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN   
        DBMS_OUTPUT.PUT_LINE('ASSD_NO column does not exist at GIAC_BANK_COMM_PAYT_DTL_EXT table.');
    ELSE
    	dbms_output.put_line('Dropping column ASSD_NO to table GIAC_BANK_COMM_PAYT_DTL_EXT...');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.giac_bank_comm_payt_dtl_ext DROP COLUMN assd_no';
        dbms_output.put_line('Column dropped.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIAC_BANK_COMM_PAYT_DTL_EXT'
       AND UPPER(column_name) = 'ASSD_NAME'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN   
        DBMS_OUTPUT.PUT_LINE('ASSD_NAME column does not exist at GIAC_BANK_COMM_PAYT_DTL_EXT table.');
    ELSE
    	dbms_output.put_line('Dropping column ASSD_NAME to table GIAC_BANK_COMM_PAYT_DTL_EXT...');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.giac_bank_comm_payt_dtl_ext DROP COLUMN assd_name';
        dbms_output.put_line('Column dropped.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIAC_BANK_COMM_PAYT_DTL_EXT'
       AND UPPER(column_name) = 'COMMISSION_RT'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN   
        DBMS_OUTPUT.PUT_LINE('COMMISSION_RT column does not exist at GIAC_BANK_COMM_PAYT_DTL_EXT table.');
    ELSE
    	dbms_output.put_line('Dropping column COMMISSION_RT to table GIAC_BANK_COMM_PAYT_DTL_EXT...');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.giac_bank_comm_payt_dtl_ext DROP COLUMN commission_rt';
        dbms_output.put_line('Column dropped.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIAC_BANK_COMM_PAYT_DTL_EXT'
       AND UPPER(column_name) = 'CRED_BRANCH'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN   
        DBMS_OUTPUT.PUT_LINE('CRED_BRANCH column does not exist at GIAC_BANK_COMM_PAYT_DTL_EXT table.');
    ELSE
    	dbms_output.put_line('Dropping column CRED_BRANCH to table GIAC_BANK_COMM_PAYT_DTL_EXT...');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.giac_bank_comm_payt_dtl_ext DROP COLUMN cred_branch';
        dbms_output.put_line('Column dropped.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIAC_BANK_COMM_PAYT_DTL_EXT'
       AND UPPER(column_name) = 'LINE_CD'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN   
        DBMS_OUTPUT.PUT_LINE('LINE_CD column does not exist at GIAC_BANK_COMM_PAYT_DTL_EXT table.');
    ELSE
    	dbms_output.put_line('Dropping column LINE_CD to table GIAC_BANK_COMM_PAYT_DTL_EXT...');
        EXECUTE IMMEDIATE 'ALTER TABLE cpi.giac_bank_comm_payt_dtl_ext DROP COLUMN line_cd';
        dbms_output.put_line('Column dropped.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIAC_BANK_COMM_PAYT_DTL_EXT'
       AND UPPER(column_name) = 'PERIL_CD'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN   
        DBMS_OUTPUT.PUT_LINE('PERIL_CD column does not exist at GIAC_BANK_COMM_PAYT_DTL_EXT table.');
    ELSE
    	dbms_output.put_line('Dropping column PERIL_CD to table GIAC_BANK_COMM_PAYT_DTL_EXT...');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.giac_bank_comm_payt_dtl_ext DROP COLUMN peril_cd';
        dbms_output.put_line('Column dropped.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


DECLARE 
  v_count NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_count
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIAC_BANK_COMM_PAYT_DTL_EXT'
       AND UPPER(column_name) = 'PERIL_SNAME'
       AND OWNER = 'CPI';
       
    IF v_count = 0 THEN   
        DBMS_OUTPUT.PUT_LINE('PERIL_SNAME column does not exist at GIAC_BANK_COMM_PAYT_DTL_EXT table.');
    ELSE
    	dbms_output.put_line('Dropping column PERIL_SNAME to table GIAC_BANK_COMM_PAYT_DTL_EXT...');
        EXECUTE IMMEDIATE 'ALTER TABLE CPI.giac_bank_comm_payt_dtl_ext DROP COLUMN peril_sname';
        dbms_output.put_line('Column dropped.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-----------------
-- MODIFY VIEW --
-----------------

CREATE OR REPLACE FORCE VIEW cpi.giex_expiries_v (policy_id,
                                                  expiry_date,
                                                  renew_flag,
                                                  line_cd,
                                                  subline_cd,
                                                  same_polno_sw,
                                                  cpi_rec_no,
                                                  cpi_branch_cd,
                                                  iss_cd,
                                                  post_flag,
                                                  balance_flag,
                                                  claim_flag,
                                                  extract_user,
                                                  extract_date,
                                                  user_id,
                                                  last_update,
                                                  date_printed,
                                                  no_of_copies,
                                                  auto_renew_flag,
                                                  update_flag,
                                                  tsi_amt,
                                                  prem_amt,
                                                  ren_tsi_amt,
                                                  ren_prem_amt,
                                                  summary_sw,
                                                  incept_date,
                                                  assd_no,
                                                  assd_name,
                                                  auto_sw,
                                                  tax_amt,
                                                  policy_tax_amt,
                                                  issue_yy,
                                                  pol_seq_no,
                                                  renew_no,
                                                  color,
                                                  motor_no,
                                                  model_year,
                                                  make,
                                                  serialno,
                                                  plate_no,
                                                  ren_notice_cnt,
                                                  ren_notice_date,
                                                  item_title,
                                                  loc_risk1,
                                                  loc_risk2,
                                                  loc_risk3,
                                                  car_company,
                                                  intm_no,
                                                  remarks,
                                                  orig_tsi_amt,
                                                  sms_flag,
                                                  renewal_id,
                                                  reg_policy_sw,
                                                  assd_sms,
                                                  intm_sms,
                                                  email_doc,
                                                  email_sw,
                                                  email_stat,
                                                  assd_email,
                                                  intm_email,
                                                  non_ren_reason,
                                                  coc_serial_no,
                                                  non_ren_reason_cd,
                                                  pack_policy_id,
                                                  is_package,
                                                  ref_pol_no
                                                 )
AS
   SELECT policy_id, expiry_date, renew_flag, line_cd, subline_cd, same_polno_sw, a.cpi_rec_no, a.cpi_branch_cd, iss_cd, post_flag, balance_flag, claim_flag, extract_user, extract_date, a.user_id,
          a.last_update, date_printed, no_of_copies, auto_renew_flag, update_flag, tsi_amt, prem_amt, ren_tsi_amt, ren_prem_amt, summary_sw, incept_date, a.assd_no, b.assd_name, auto_sw, tax_amt, policy_tax_amt,
          issue_yy, pol_seq_no, renew_no, color, motor_no, model_year, make, serialno, plate_no, ren_notice_cnt, ren_notice_date, item_title, loc_risk1, loc_risk2, loc_risk3, car_company, intm_no,
          a.remarks, orig_tsi_amt, sms_flag, renewal_id, reg_policy_sw, assd_sms, intm_sms, email_doc, email_sw, email_stat, assd_email, intm_email, non_ren_reason, coc_serial_no, non_ren_reason_cd,
          0 pack_policy_id, 'N' is_package, ref_pol_no
     FROM giex_expiry a, giis_assured b
    WHERE 1=1
      AND a.assd_no = b.assd_no
      AND NVL (pack_policy_id, 0) = 0
   UNION ALL
   SELECT pack_policy_id, expiry_date, renew_flag, line_cd, subline_cd, same_polno_sw, -23, '-O', iss_cd, post_flag, balance_flag, claim_flag, extract_user, extract_date, a.user_id, a.last_update,
          date_printed, no_of_copies, auto_renew_flag, update_flag, tsi_amt, prem_amt, ren_tsi_amt, ren_prem_amt, summary_sw, incept_date, a.assd_no, b.assd_name, auto_sw, tax_amt, policy_tax_amt, issue_yy,
          pol_seq_no, renew_no, color, motor_no, model_year, make, serialno, plate_no, ren_notice_cnt, ren_notice_date, item_title, loc_risk1, loc_risk2, loc_risk3, car_company, intm_no, a.remarks,
          orig_tsi_amt, sms_flag, renewal_id, reg_policy_sw, assd_sms, intm_sms, email_doc, email_sw, email_stat, assd_email, intm_email, non_ren_reason, coc_serial_no, non_ren_reason_cd,
          pack_policy_id, 'Y' is_package, ref_pol_no
     FROM giex_pack_expiry a, giis_assured b
    WHERE 1=1
      AND a.assd_no = b.assd_no;
      
CREATE OR REPLACE PUBLIC SYNONYM GIEX_EXPIRIES_V FOR CPI.GIEX_EXPIRIES_V;
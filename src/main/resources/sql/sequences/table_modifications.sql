SET serveroutput ON

-- GIIS_ISSOURCE.address2 - from 30 to 50
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_ISSOURCE'
       AND UPPER(column_name) = 'ADDRESS2';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column ADDRESS2 to table GIIS_ISSOURCE.');
        EXECUTE IMMEDIATE 'ALTER TABLE giis_issource add ADDRESS2 VARCHAR2(50)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.giis_issource MODIFY ADDRESS2 VARCHAR2(50)');
        DBMS_OUTPUT.PUT_LINE('ADDRESS2 has been modified to VARCHAR2(50).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIPI_QUOTE_ITMPERIL.ann_tsi_amt from 12,2 to 16,2
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_QUOTE_ITMPERIL'
       AND UPPER(column_name) = 'ANN_TSI_AMT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column ANN_TSI_AMT to table GIPI_QUOTE_ITMPERIL.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_QUOTE_ITMPERIL add ANN_TSI_AMT NUMBER(16,2)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIPI_QUOTE_ITMPERIL MODIFY ANN_TSI_AMT NUMBER(16,2)');
        DBMS_OUTPUT.PUT_LINE('ANN_TSI_AMT has been modified to NUMBER(16,2).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIN_ASSD_PROD_HDR.assd_name from 50 to 500
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIN_ASSD_PROD_HDR'
       AND UPPER(column_name) = 'ASSD_NAME';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column ASSD_NAME to table GIIN_ASSD_PROD_HDR.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIN_ASSD_PROD_HDR add ASSD_NAME VARCHAR2(500)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIN_ASSD_PROD_HDR MODIFY ASSD_NAME VARCHAR2(500)');
        DBMS_OUTPUT.PUT_LINE('ASSD_NAME has been modified to VARCHAR2(500).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_CLAIMS.assd_name2 from 50 to 500
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_CLAIMS'
       AND UPPER(column_name) = 'ASSD_NAME2';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column ASSD_NAME2 to table GICL_CLAIMS.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_CLAIMS add ASSD_NAME2 VARCHAR2(500)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_CLAIMS MODIFY ASSD_NAME2 VARCHAR2(500)');
        DBMS_OUTPUT.PUT_LINE('ASSD_NAME2 has been modified to VARCHAR2(500).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIXX_CLAIMS.assured_name from 50 to 500
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIXX_CLAIMS'
       AND UPPER(column_name) = 'ASSURED_NAME';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column ASSURED_NAME to table GIXX_CLAIMS.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIXX_CLAIMS add ASSURED_NAME VARCHAR2(500)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIXX_CLAIMS MODIFY ASSURED_NAME VARCHAR2(500)');
        DBMS_OUTPUT.PUT_LINE('ASSURED_NAME has been modified to VARCHAR2(500).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_PREMDEPOSIT_EXT.assured_name from 100 to 550
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_PREMDEPOSIT_EXT'
       AND UPPER(column_name) = 'ASSURED_NAME';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column ASSURED_NAME to table GIAC_PREMDEPOSIT_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_PREMDEPOSIT_EXT add ASSURED_NAME VARCHAR2(550)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_PREMDEPOSIT_EXT MODIFY ASSURED_NAME VARCHAR2(550)');
        DBMS_OUTPUT.PUT_LINE('ASSURED_NAME has been modified to VARCHAR2(550).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIS_PERIL.basc_perl_cd from 2 to 5
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_PERIL'
       AND UPPER(column_name) = 'BASC_PERL_CD';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column BASC_PERL_CD to table GIIS_PERIL.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIS_PERIL add BASC_PERL_CD NUMBER(5)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIS_PERIL MODIFY BASC_PERL_CD NUMBER(5)');
        DBMS_OUTPUT.PUT_LINE('BASC_PERL_CD has been modified to NUMBER(5).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_RI_STMT_EXT.bill_address from 152 to 155
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_RI_STMT_EXT'
       AND UPPER(column_name) = 'BILL_ADDRESS';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column BILL_ADDRESS to table GIAC_RI_STMT_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_RI_STMT_EXT add BILL_ADDRESS VARCHAR2(155)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_RI_STMT_EXT MODIFY BILL_ADDRESS VARCHAR2(155)');
        DBMS_OUTPUT.PUT_LINE('BILL_ADDRESS has been modified to VARCHAR2(155).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIS_ISSOURCE.branch_tin_cd - from 15 to 100
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_ISSOURCE'
       AND UPPER(column_name) = 'BRANCH_TIN_CD';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column BRANCH_TIN_CD to table GIIS_ISSOURCE.');
        EXECUTE IMMEDIATE 'ALTER TABLE giis_issource add BRANCH_TIN_CD VARCHAR2(100)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.giis_issource MODIFY BRANCH_TIN_CD VARCHAR2(100)');
        DBMS_OUTPUT.PUT_LINE('BRANCH_TIN_CD has been modified to VARCHAR2(100).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.commission_amt from 16,2 to 16,4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'COMMISSION_AMT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column COMMISSION_AMT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add COMMISSION_AMT NUMBER(16,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY COMMISSION_AMT NUMBER(16,4)');
        DBMS_OUTPUT.PUT_LINE('COMMISSION_AMT has been modified to NUMBER(16,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.comm_vat from 12,2 to 12,4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'COMM_VAT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column COMM_VAT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add COMM_VAT NUMBER(12,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY COMM_VAT NUMBER(12,4)');
        DBMS_OUTPUT.PUT_LINE('COMM_VAT has been modified to NUMBER(12,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIXX_DEDUCTIBLE_LEVELS.deductible_text - from 2000 to 4000
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIXX_DEDUCTIBLE_LEVELS'
       AND UPPER(column_name) = 'DEDUCTIBLE_TEXT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column DEDUCTIBLE_TEXT to table GIXX_DEDUCTIBLE_LEVELS.');
        EXECUTE IMMEDIATE 'ALTER TABLE gixx_deductible_levels add DEDUCTIBLE_TEXT VARCHAR2(4000)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIXX_DEDUCTIBLE_LEVELS MODIFY DEDUCTIBLE_TEXT VARCHAR2(4000)');
        DBMS_OUTPUT.PUT_LINE('DEDUCTIBLE_TEXT has been modified to VARCHAR2(4000).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_EVAL_DEDUCTIBLES.ded_cd - from 5 to 12
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_EVAL_DEDUCTIBLES'
       AND UPPER(column_name) = 'DED_CD';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column DED_CD to table GICL_EVAL_DEDUCTIBLES.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_EVAL_DEDUCTIBLES add DED_CD VARCHAR2(12)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_EVAL_DEDUCTIBLES MODIFY DED_CD VARCHAR2(12)');
        DBMS_OUTPUT.PUT_LINE('DED_CD has been modified to VARCHAR2(12).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIPI_ACCIDENT_ITEM.destination - from 50 to 500
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_ACCIDENT_ITEM'
       AND UPPER(column_name) = 'DESTINATION';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column DESTINATION to table GIPI_ACCIDENT_ITEM.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_ACCIDENT_ITEM add DESTINATION VARCHAR2(500)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIPI_ACCIDENT_ITEM MODIFY DESTINATION VARCHAR2(500)');
        DBMS_OUTPUT.PUT_LINE('DESTINATION has been modified to VARCHAR2(500).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIPI_WACCIDENT_ITEM.destination - from 50 to 500
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_WACCIDENT_ITEM'
       AND UPPER(column_name) = 'DESTINATION';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column DESTINATION to table GIPI_WACCIDENT_ITEM.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_WACCIDENT_ITEM add DESTINATION VARCHAR2(500)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIPI_WACCIDENT_ITEM MODIFY DESTINATION VARCHAR2(500)');
        DBMS_OUTPUT.PUT_LINE('DESTINATION has been modified to VARCHAR2(500).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIXX_ACCIDENT_ITEM.destination - from 50 to 500
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIXX_ACCIDENT_ITEM'
       AND UPPER(column_name) = 'DESTINATION';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column DESTINATION to table GIXX_ACCIDENT_ITEM.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIXX_ACCIDENT_ITEM add DESTINATION VARCHAR2(500)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIXX_ACCIDENT_ITEM MODIFY DESTINATION VARCHAR2(500)');
        DBMS_OUTPUT.PUT_LINE('DESTINATION has been modified to VARCHAR2(500).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_CLM_RES_HIST.dist_no - from VARCHAR(2) to NUMBER(8)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_CLM_RES_HIST'
       AND UPPER(column_name) = 'DIST_NO';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column DIST_NO to table GICL_CLM_RES_HIST.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_CLM_RES_HIST add DIST_NO NUMBER(8)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_CLM_RES_HIST MODIFY DIST_NO NUMBER(8)');
        DBMS_OUTPUT.PUT_LINE('DIST_NO has been modified to NUMBER(8).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.due_to_ri - from (16,2) to (16,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'DUE_TO_RI';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column DUE_TO_RI to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add DUE_TO_RI NUMBER(16,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY DUE_TO_RI NUMBER(16,4)');
        DBMS_OUTPUT.PUT_LINE('DUE_TO_RI has been modified to NUMBER(16,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.fc_comm_amt - from (16,2) to (16,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'FC_COMM_AMT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FC_COMM_AMT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add FC_COMM_AMT NUMBER(16,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY FC_COMM_AMT NUMBER(16,4)');
        DBMS_OUTPUT.PUT_LINE('FC_COMM_AMT has been modified to NUMBER(16,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.fc_comm_vat - from (12,2) to (12,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'FC_COMM_VAT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FC_COMM_VAT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add FC_COMM_VAT NUMBER(12,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY FC_COMM_VAT NUMBER(12,4)');
        DBMS_OUTPUT.PUT_LINE('FC_COMM_VAT has been modified to NUMBER(12,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.fc_prem_amt - from (16,2) to (16,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'FC_PREM_AMT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FC_PREM_AMT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add FC_PREM_AMT NUMBER(16,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY FC_PREM_AMT NUMBER(16,4)');
        DBMS_OUTPUT.PUT_LINE('FC_PREM_AMT has been modified to NUMBER(16,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.fc_prem_vat - from (12,2) to (12,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'FC_PREM_VAT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FC_PREM_VAT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add FC_PREM_VAT NUMBER(12,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY FC_PREM_VAT NUMBER(12,4)');
        DBMS_OUTPUT.PUT_LINE('FC_PREM_VAT has been modified to NUMBER(12,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.fc_ri_wholding_vat - from (12,2) to (12,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'FC_RI_WHOLDING_VAT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FC_RI_WHOLDING_VAT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add FC_RI_WHOLDING_VAT NUMBER(12,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY FC_RI_WHOLDING_VAT NUMBER(12,4)');
        DBMS_OUTPUT.PUT_LINE('FC_RI_WHOLDING_VAT has been modified to NUMBER(12,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.fc_tax_amt - from (12,2) to (12,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'FC_TAX_AMT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FC_TAX_AMT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add FC_TAX_AMT NUMBER(12,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY FC_TAX_AMT NUMBER(12,4)');
        DBMS_OUTPUT.PUT_LINE('FC_TAX_AMT has been modified to NUMBER(12,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIPI_MC_UPLOAD.filename - from 50 to 500
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_MC_UPLOAD'
       AND UPPER(column_name) = 'FILENAME';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FILENAME to table GIPI_MC_UPLOAD.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_MC_UPLOAD add FILENAME VARCHAR2(500)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIPI_MC_UPLOAD MODIFY FILENAME VARCHAR2(500)');
        DBMS_OUTPUT.PUT_LINE('FILENAME has been modified to VARCHAR2(500).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIPI_UPLOAD_TEMP.filename - from 50 to 500
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_UPLOAD_TEMP'
       AND UPPER(column_name) = 'FILENAME';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FILENAME to table GIPI_UPLOAD_TEMP.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_UPLOAD_TEMP add FILENAME VARCHAR2(500)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIPI_UPLOAD_TEMP MODIFY FILENAME VARCHAR2(500)');
        DBMS_OUTPUT.PUT_LINE('FILENAME has been modified to VARCHAR2(500).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_PICTURES.file_name - from 100 to 2000
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_PICTURES'
       AND UPPER(column_name) = 'FILE_NAME';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FILE_NAME to table GICL_PICTURES.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_PICTURES add FILE_NAME VARCHAR2(2000)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_PICTURES MODIFY FILE_NAME VARCHAR2(2000)');
        DBMS_OUTPUT.PUT_LINE('FILE_NAME has been modified to VARCHAR2(2000).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_ADVS_FLA.fla_header - from 150 to 500
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_ADVS_FLA'
       AND UPPER(column_name) = 'FLA_HEADER';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FLA_HEADER to table GICL_ADVS_FLA.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_ADVS_FLA add FLA_HEADER VARCHAR2(500)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_ADVS_FLA MODIFY FLA_HEADER VARCHAR2(500)');
        DBMS_OUTPUT.PUT_LINE('FLA_HEADER has been modified to VARCHAR2(500).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_ADVS_FLA.fla_title - from 100 to 500
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_ADVS_FLA'
       AND UPPER(column_name) = 'FLA_TITLE';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FLA_TITLE to table GICL_ADVS_FLA.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_ADVS_FLA add FLA_TITLE VARCHAR2(500)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_ADVS_FLA MODIFY FLA_TITLE VARCHAR2(500)');
        DBMS_OUTPUT.PUT_LINE('FLA_TITLE has been modified to VARCHAR2(500).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_REQD_DOCS.frwd_by - from 8 to 20
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_REQD_DOCS'
       AND UPPER(column_name) = 'FRWD_BY';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FRWD_BY to table GICL_REQD_DOCS.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_REQD_DOCS add FRWD_BY VARCHAR2(20)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_REQD_DOCS MODIFY FRWD_BY VARCHAR2(20)');
        DBMS_OUTPUT.PUT_LINE('FRWD_BY has been modified to VARCHAR2(20).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.funds_held_amt - from (16,2) to (16,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'FUNDS_HELD_AMT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column FUNDS_HELD_AMT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add FUNDS_HELD_AMT NUMBER(16,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY FUNDS_HELD_AMT NUMBER(16,4)');
        DBMS_OUTPUT.PUT_LINE('FUNDS_HELD_AMT has been modified to NUMBER(16,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIPI_INSTALLMENT_HIST_DTL.inst_no - from 2 to 4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_INSTALLMENT_HIST_DTL'
       AND UPPER(column_name) = 'INST_NO';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column INST_NO to table GIPI_INSTALLMENT_HIST_DTL.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_INSTALLMENT_HIST_DTL add INST_NO NUMBER(4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIPI_INSTALLMENT_HIST_DTL MODIFY INST_NO NUMBER(4)');
        DBMS_OUTPUT.PUT_LINE('INST_NO has been modified to NUMBER(4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_OP_TEXT.item_gen_type - from 1 to 2
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_OP_TEXT'
       AND UPPER(column_name) = 'ITEM_GEN_TYPE';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column ITEM_GEN_TYPE to table GIAC_OP_TEXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_OP_TEXT add ITEM_GEN_TYPE VARCHAR2(2)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_OP_TEXT MODIFY ITEM_GEN_TYPE VARCHAR2(2)');
        DBMS_OUTPUT.PUT_LINE('ITEM_GEN_TYPE has been modified to VARCHAR2(2).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_PDC_REP_HIST.item_no - from 2 to 9
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_PDC_REP_HIST'
       AND UPPER(column_name) = 'ITEM_NO';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column ITEM_NO to table GIAC_PDC_REP_HIST.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_PDC_REP_HIST add ITEM_NO NUMBER(9)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_PDC_REP_HIST MODIFY ITEM_NO NUMBER(9)');
        DBMS_OUTPUT.PUT_LINE('ITEM_NO has been modified to NUMBER(9).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_MC_LPS.loss_exp_cd - from 2 to 5
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GICL_MC_LPS'
      AND owner = 'CPI'
      AND column_name = 'LOSS_EXP_CD'
      AND data_length <> 5;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE cpi.GICL_MC_LPS MODIFY (loss_exp_cd VARCHAR2(5))';

      DBMS_OUTPUT.put_line ('Successfully modify GICL_MC_LPS.loss_exp_cd length to 5.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GICL_MC_LPS.loss_exp_cd column is already 5.');
END;


-- GICL_MC_LPS_HIST.loss_exp_cd - from 2 to 5
DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE table_name = 'GICL_MC_LPS_HIST'
      AND owner = 'CPI'
      AND column_name = 'LOSS_EXP_CD'
      AND data_length <> 5;

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE cpi.GICL_MC_LPS_HIST MODIFY (loss_exp_cd VARCHAR2(5))';

      DBMS_OUTPUT.put_line ('Successfully modify GICL_MC_LPS_HIST.loss_exp_cd length to 5.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('Data length of GICL_MC_LPS_HIST.loss_exp_cd column is already 5.');
END;


-- GICL_LRATIO_LOSS_PAID_EXT.loss_paid - from (12,2) to (16,2)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_LRATIO_LOSS_PAID_EXT'
       AND UPPER(column_name) = 'LOSS_PAID';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column LOSS_PAID to table GICL_LRATIO_LOSS_PAID_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_LRATIO_LOSS_PAID_EXT add LOSS_PAID NUMBER(16,2)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_LRATIO_LOSS_PAID_EXT MODIFY LOSS_PAID NUMBER(16,2)');
        DBMS_OUTPUT.PUT_LINE('LOSS_PAID has been modified to NUMBER(16,2).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIEX_SMS_DTL.message - from 170 to 480
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIEX_SMS_DTL'
       AND UPPER(column_name) = 'MESSAGE';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column MESSAGE to table GIEX_SMS_DTL.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIEX_SMS_DTL add MESSAGE VARCHAR2(480)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIEX_SMS_DTL MODIFY MESSAGE VARCHAR2(480)');
        DBMS_OUTPUT.PUT_LINE('MESSAGE has been modified to VARCHAR2(480).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GISM_MESSAGES_RECEIVED.message - from 160 to 480
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GISM_MESSAGES_RECEIVED'
       AND UPPER(column_name) = 'MESSAGE';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column MESSAGE to table GISM_MESSAGES_RECEIVED.');
        EXECUTE IMMEDIATE 'ALTER TABLE GISM_MESSAGES_RECEIVED add MESSAGE VARCHAR2(480)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GISM_MESSAGES_RECEIVED MODIFY MESSAGE VARCHAR2(480)');
        DBMS_OUTPUT.PUT_LINE('MESSAGE has been modified to VARCHAR2(480).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GISM_MESSAGES_SENT.message - from 170 to 480
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GISM_MESSAGES_SENT'
       AND UPPER(column_name) = 'MESSAGE';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column MESSAGE to table GISM_MESSAGES_SENT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GISM_MESSAGES_SENT add MESSAGE VARCHAR2(480)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GISM_MESSAGES_SENT MODIFY MESSAGE VARCHAR2(480)');
        DBMS_OUTPUT.PUT_LINE('MESSAGE has been modified to VARCHAR2(480).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GISM_MESSAGE_TEMPLATE.message - from 160 to 480
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GISM_MESSAGE_TEMPLATE'
       AND UPPER(column_name) = 'MESSAGE';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column MESSAGE to table GISM_MESSAGE_TEMPLATE.');
        EXECUTE IMMEDIATE 'ALTER TABLE GISM_MESSAGE_TEMPLATE add MESSAGE VARCHAR2(480)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GISM_MESSAGE_TEMPLATE MODIFY MESSAGE VARCHAR2(480)');
        DBMS_OUTPUT.PUT_LINE('MESSAGE has been modified to VARCHAR2(480).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- DEVT_TRACK_UPDATED_REC.new_col1 - from 500 to 2000
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'DEVT_TRACK_UPDATED_REC'
       AND UPPER(column_name) = 'NEW_COL1';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column NEW_COL1 to table DEVT_TRACK_UPDATED_REC.');
        EXECUTE IMMEDIATE 'ALTER TABLE DEVT_TRACK_UPDATED_REC add NEW_COL1 VARCHAR2(2000)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.DEVT_TRACK_UPDATED_REC MODIFY NEW_COL1 VARCHAR2(2000)');
        DBMS_OUTPUT.PUT_LINE('NEW_COL1 has been modified to VARCHAR2(2000).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- DEVT_TRACK_UPDATED_REC.new_col2 - from 500 to 2000
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'DEVT_TRACK_UPDATED_REC'
       AND UPPER(column_name) = 'NEW_COL2';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column NEW_COL2 to table DEVT_TRACK_UPDATED_REC.');
        EXECUTE IMMEDIATE 'ALTER TABLE DEVT_TRACK_UPDATED_REC add NEW_COL2 VARCHAR2(2000)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.DEVT_TRACK_UPDATED_REC MODIFY NEW_COL2 VARCHAR2(2000)');
        DBMS_OUTPUT.PUT_LINE('NEW_COL2 has been modified to VARCHAR2(2000).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- DEVT_TRACK_UPDATED_REC.new_col3 - from 500 to 2000
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'DEVT_TRACK_UPDATED_REC'
       AND UPPER(column_name) = 'NEW_COL3';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column NEW_COL3 to table DEVT_TRACK_UPDATED_REC.');
        EXECUTE IMMEDIATE 'ALTER TABLE DEVT_TRACK_UPDATED_REC add NEW_COL3 VARCHAR2(2000)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.DEVT_TRACK_UPDATED_REC MODIFY NEW_COL3 VARCHAR2(2000)');
        DBMS_OUTPUT.PUT_LINE('NEW_COL3 has been modified to VARCHAR2(2000).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIS_USER_GRP_HIST.new_user_grp - from 2 to 4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_USER_GRP_HIST'
       AND UPPER(column_name) = 'NEW_USER_GRP';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column NEW_USER_GRP to table GIIS_USER_GRP_HIST.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIS_USER_GRP_HIST add NEW_USER_GRP NUMBER(4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIS_USER_GRP_HIST MODIFY NEW_USER_GRP NUMBER(4)');
        DBMS_OUTPUT.PUT_LINE('NEW_USER_GRP has been modified to NUMBER(4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- DEVT_TRACK_UPDATED_REC.old_col1 - from 500 to 2000
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'DEVT_TRACK_UPDATED_REC'
       AND UPPER(column_name) = 'OLD_COL1';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column OLD_COL1 to table DEVT_TRACK_UPDATED_REC.');
        EXECUTE IMMEDIATE 'ALTER TABLE DEVT_TRACK_UPDATED_REC add OLD_COL1 VARCHAR2(2000)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.DEVT_TRACK_UPDATED_REC MODIFY OLD_COL1 VARCHAR2(2000)');
        DBMS_OUTPUT.PUT_LINE('OLD_COL1 has been modified to VARCHAR2(2000).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- DEVT_TRACK_UPDATED_REC.old_col2 - from 500 to 2000
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'DEVT_TRACK_UPDATED_REC'
       AND UPPER(column_name) = 'OLD_COL2';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column OLD_COL2 to table DEVT_TRACK_UPDATED_REC.');
        EXECUTE IMMEDIATE 'ALTER TABLE DEVT_TRACK_UPDATED_REC add OLD_COL2 VARCHAR2(2000)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.DEVT_TRACK_UPDATED_REC MODIFY OLD_COL2 VARCHAR2(2000)');
        DBMS_OUTPUT.PUT_LINE('OLD_COL2 has been modified to VARCHAR2(2000).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- DEVT_TRACK_UPDATED_REC.old_col3 - from 500 to 2000
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'DEVT_TRACK_UPDATED_REC'
       AND UPPER(column_name) = 'OLD_COL3';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column OLD_COL2 to table DEVT_TRACK_UPDATED_REC.');
        EXECUTE IMMEDIATE 'ALTER TABLE DEVT_TRACK_UPDATED_REC add OLD_COL3 VARCHAR2(2000)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.DEVT_TRACK_UPDATED_REC MODIFY OLD_COL3 VARCHAR2(2000)');
        DBMS_OUTPUT.PUT_LINE('OLD_COL3 has been modified to VARCHAR2(2000).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIS_USER_GRP_HIST.old_user_grp - from 2 to 4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_USER_GRP_HIST'
       AND UPPER(column_name) = 'OLD_USER_GRP';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column OLD_USER_GRP to table GIIS_USER_GRP_HIST.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIS_USER_GRP_HIST add OLD_USER_GRP NUMBER(4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIS_USER_GRP_HIST MODIFY OLD_USER_GRP NUMBER(4)');
        DBMS_OUTPUT.PUT_LINE('OLD_USER_GRP has been modified to NUMBER(4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_LRATIO_CURR_OS_EXT.os_amt - from (12,2) to (16,2)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_LRATIO_CURR_OS_EXT'
       AND UPPER(column_name) = 'OS_AMT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column OS_AMT to table GICL_LRATIO_CURR_OS_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_LRATIO_CURR_OS_EXT add OS_AMT NUMBER(16,2)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_LRATIO_CURR_OS_EXT MODIFY OS_AMT NUMBER(16,2)');
        DBMS_OUTPUT.PUT_LINE('OS_AMT has been modified to NUMBER(16,2).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_LRATIO_PREV_OS_EXT.os_amt - from (12,2) to (16,2)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_LRATIO_PREV_OS_EXT'
       AND UPPER(column_name) = 'OS_AMT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column OS_AMT to table GICL_LRATIO_PREV_OS_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_LRATIO_PREV_OS_EXT add OS_AMT NUMBER(16,2)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_LRATIO_PREV_OS_EXT MODIFY OS_AMT NUMBER(16,2)');
        DBMS_OUTPUT.PUT_LINE('OS_AMT has been modified to NUMBER(16,2).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_CHK_DISBURSEMENT.payee - from 300 to 500
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_CHK_DISBURSEMENT'
       AND UPPER(column_name) = 'PAYEE';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column PAYEE to table GIAC_CHK_DISBURSEMENT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_CHK_DISBURSEMENT add PAYEE VARCHAR2(500)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_CHK_DISBURSEMENT MODIFY PAYEE VARCHAR2(500)');
        DBMS_OUTPUT.PUT_LINE('PAYEE has been modified to VARCHAR2(500).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIPI_WLTO_PREM_STATS.peril_cd - from 2 to 5
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_WLTO_PREM_STATS'
       AND UPPER(column_name) = 'PERIL_CD';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column PERIL_CD to table GIPI_WLTO_PREM_STATS.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_WLTO_PREM_STATS add PERIL_CD NUMBER(5)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIPI_WLTO_PREM_STATS MODIFY PERIL_CD NUMBER(5)');
        DBMS_OUTPUT.PUT_LINE('PERIL_CD has been modified to NUMBER(5).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIPI_WNLTO_PREM_STATS.peril_cd - from 2 to 5
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_WNLTO_PREM_STATS'
       AND UPPER(column_name) = 'PERIL_CD';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column PERIL_CD to table GIPI_WNLTO_PREM_STATS.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_WNLTO_PREM_STATS add PERIL_CD NUMBER(5)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIPI_WNLTO_PREM_STATS MODIFY PERIL_CD NUMBER(5)');
        DBMS_OUTPUT.PUT_LINE('PERIL_CD has been modified to NUMBER(5).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_COLL_ANALYSIS_EXT.policy_no - from 40 to 50
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_COLL_ANALYSIS_EXT'
       AND UPPER(column_name) = 'POLICY_NO';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column POLICY_NO to table GIAC_COLL_ANALYSIS_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_COLL_ANALYSIS_EXT add POLICY_NO VARCHAR2(50)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_COLL_ANALYSIS_EXT MODIFY POLICY_NO VARCHAR2(50)');
        DBMS_OUTPUT.PUT_LINE('POLICY_NO has been modified to VARCHAR2(50).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.premium_amt - from (16,2) to (16,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'PREMIUM_AMT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column PREMIUM_AMT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add PREMIUM_AMT NUMBER(16,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY PREMIUM_AMT NUMBER(16,4)');
        DBMS_OUTPUT.PUT_LINE('PREMIUM_AMT has been modified to NUMBER(16,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_DUETO_EXT.prem_tax - from (16,2) to (12,2)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_DUETO_EXT'
       AND UPPER(column_name) = 'PREM_TAX';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column PREM_TAX to table GIAC_DUETO_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_DUETO_EXT add PREM_TAX NUMBER(12,2)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_DUETO_EXT MODIFY PREM_TAX NUMBER(12,2)');
        DBMS_OUTPUT.PUT_LINE('PREM_TAX has been modified to NUMBER(12,2).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.prem_vat - from (12,2) to (12,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'PREM_VAT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column PREM_VAT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add PREM_VAT NUMBER(12,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY PREM_VAT NUMBER(12,4)');
        DBMS_OUTPUT.PUT_LINE('PREM_VAT has been modified to NUMBER(12,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_EVAL_DEP_DTL.remarks - from 2000 to 4000
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_EVAL_DEP_DTL'
       AND UPPER(column_name) = 'REMARKS';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column REMARKS to table GICL_EVAL_DEP_DTL.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_EVAL_DEP_DTL add REMARKS VARCHAR2(4000)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_EVAL_DEP_DTL MODIFY REMARKS VARCHAR2(4000)');
        DBMS_OUTPUT.PUT_LINE('REMARKS has been modified to VARCHAR2(4000).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIRI_PACK_INPOLBAS.remarks - from 500 to 4000
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIRI_PACK_INPOLBAS'
       AND UPPER(column_name) = 'REMARKS';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column REMARKS to table GIRI_PACK_INPOLBAS.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIRI_PACK_INPOLBAS add REMARKS VARCHAR2(4000)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIRI_PACK_INPOLBAS MODIFY REMARKS VARCHAR2(4000)');
        DBMS_OUTPUT.PUT_LINE('REMARKS has been modified to VARCHAR2(4000).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIRI_PACK_WINPOLBAS.remarks - from 500 to 4000
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIRI_PACK_WINPOLBAS'
       AND UPPER(column_name) = 'REMARKS';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column REMARKS to table GIRI_PACK_WINPOLBAS.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIRI_PACK_WINPOLBAS add REMARKS VARCHAR2(4000)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIRI_PACK_WINPOLBAS MODIFY REMARKS VARCHAR2(4000)');
        DBMS_OUTPUT.PUT_LINE('REMARKS has been modified to VARCHAR2(4000).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.ri_wholding_vat - from (12,2) to (12,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'RI_WHOLDING_VAT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column RI_WHOLDING_VAT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add RI_WHOLDING_VAT NUMBER(12,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY RI_WHOLDING_VAT NUMBER(12,4)');
        DBMS_OUTPUT.PUT_LINE('RI_WHOLDING_VAT has been modified to NUMBER(12,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIPI_RISK_PROFILE_DTL.sec_net_retention_prem  - from (12,2) to (16,2)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_RISK_PROFILE_DTL'
       AND UPPER(column_name) = 'SEC_NET_RETENTION_PREM';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column SEC_NET_RETENTION_PREM to table GIPI_RISK_PROFILE_DTL.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_RISK_PROFILE_DTL add SEC_NET_RETENTION_PREM NUMBER(16,2)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIPI_RISK_PROFILE_DTL MODIFY SEC_NET_RETENTION_PREM NUMBER(16,2)');
        DBMS_OUTPUT.PUT_LINE('SEC_NET_RETENTION_PREM has been modified to NUMBER(16,2).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TB_SL_EXT.sl_name - from 500 to 600
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TB_SL_EXT'
       AND UPPER(column_name) = 'SL_NAME';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column SL_NAME to table GIAC_TB_SL_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TB_SL_EXT add SL_NAME VARCHAR2(600)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TB_SL_EXT MODIFY SL_NAME VARCHAR2(600)');
        DBMS_OUTPUT.PUT_LINE('SL_NAME has been modified to VARCHAR2(600).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_SL_LISTS.sl_name - from 775 to 600
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_SL_LISTS'
       AND UPPER(column_name) = 'SL_NAME';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column SL_NAME to table GIAC_SL_LISTS.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_SL_LISTS add SL_NAME VARCHAR2(600)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_SL_LISTS MODIFY SL_NAME VARCHAR2(600)');
        DBMS_OUTPUT.PUT_LINE('SL_NAME has been modified to VARCHAR2(600).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIAC_TREATY_BATCH_EXT.tax_amt - from (16,2) to (16,4)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIAC_TREATY_BATCH_EXT'
       AND UPPER(column_name) = 'TAX_AMT';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column TAX_AMT to table GIAC_TREATY_BATCH_EXT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_TREATY_BATCH_EXT add TAX_AMT NUMBER(16,4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIAC_TREATY_BATCH_EXT MODIFY TAX_AMT NUMBER(16,4)');
        DBMS_OUTPUT.PUT_LINE('TAX_AMT has been modified to NUMBER(16,4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIS_LOSS_TAX_HIST.tax_hist_no - from 3 to 4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_LOSS_TAX_HIST'
       AND UPPER(column_name) = 'TAX_HIST_NO';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column TAX_HIST_NO to table GIIS_LOSS_TAX_HIST.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIS_LOSS_TAX_HIST add TAX_HIST_NO NUMBER(4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIS_LOSS_TAX_HIST MODIFY TAX_HIST_NO NUMBER(4)');
        DBMS_OUTPUT.PUT_LINE('TAX_HIST_NO has been modified to NUMBER(4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GICL_CLM_RECOVERY.tp_driver_name - from 30 to 100
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GICL_CLM_RECOVERY'
       AND UPPER(column_name) = 'TP_DRIVER_NAME';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column TP_DRIVER_NAME to table GICL_CLM_RECOVERY.');
        EXECUTE IMMEDIATE 'ALTER TABLE GICL_CLM_RECOVERY add TP_DRIVER_NAME VARCHAR2(100)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GICL_CLM_RECOVERY MODIFY TP_DRIVER_NAME VARCHAR2(100)');
        DBMS_OUTPUT.PUT_LINE('TP_DRIVER_NAME has been modified to VARCHAR2(100).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIS_USERS.user_grp - from 2 to 4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_USERS'
       AND UPPER(column_name) = 'USER_GRP';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column USER_GRP to table GIIS_USERS.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIS_USERS add USER_GRP NUMBER(4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIS_USERS MODIFY USER_GRP NUMBER(4)');
        DBMS_OUTPUT.PUT_LINE('USER_GRP has been modified to NUMBER(4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIS_USER_GRP_DTL.user_grp - from 2 to 4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_USER_GRP_DTL'
       AND UPPER(column_name) = 'USER_GRP';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column USER_GRP to table GIIS_USER_GRP_DTL.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIS_USER_GRP_DTL add USER_GRP NUMBER(4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIS_USER_GRP_DTL MODIFY USER_GRP NUMBER(4)');
        DBMS_OUTPUT.PUT_LINE('USER_GRP has been modified to NUMBER(4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;



-- GIIS_USER_GRP_HDR.user_grp - from 2 to 4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_USER_GRP_HDR'
       AND UPPER(column_name) = 'USER_GRP';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column USER_GRP to table GIIS_USER_GRP_HDR.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIS_USER_GRP_HDR add USER_GRP NUMBER(4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIS_USER_GRP_HDR MODIFY USER_GRP NUMBER(4)');
        DBMS_OUTPUT.PUT_LINE('USER_GRP has been modified to NUMBER(4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIS_USER_GRP_LINE.user_grp - from 2 to 4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_USER_GRP_LINE'
       AND UPPER(column_name) = 'USER_GRP';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column USER_GRP to table GIIS_USER_GRP_LINE.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIS_USER_GRP_LINE add USER_GRP NUMBER(4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIS_USER_GRP_LINE MODIFY USER_GRP NUMBER(4)');
        DBMS_OUTPUT.PUT_LINE('USER_GRP has been modified to NUMBER(4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIS_USER_GRP_MODULES.user_grp - from 2 to 4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_USER_GRP_MODULES'
       AND UPPER(column_name) = 'USER_GRP';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column USER_GRP to table GIIS_USER_GRP_MODULES.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIS_USER_GRP_MODULES add USER_GRP NUMBER(4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIS_USER_GRP_MODULES MODIFY USER_GRP NUMBER(4)');
        DBMS_OUTPUT.PUT_LINE('USER_GRP has been modified to NUMBER(4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIS_USER_GRP_TRAN.user_grp - from 2 to 4
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_USER_GRP_TRAN'
       AND UPPER(column_name) = 'USER_GRP';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column USER_GRP to table GIIS_USER_GRP_TRAN.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIS_USER_GRP_TRAN add USER_GRP NUMBER(4)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIS_USER_GRP_TRAN MODIFY USER_GRP NUMBER(4)');
        DBMS_OUTPUT.PUT_LINE('USER_GRP has been modified to NUMBER(4).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIIS_PACKAGE_BENEFIT.user_id - from 7 to 8
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIIS_PACKAGE_BENEFIT'
       AND UPPER(column_name) = 'USER_ID';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column USER_ID to table GIIS_PACKAGE_BENEFIT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIIS_PACKAGE_BENEFIT add USER_ID VARCHAR2(8)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIIS_PACKAGE_BENEFIT MODIFY USER_ID VARCHAR2(8)');
        DBMS_OUTPUT.PUT_LINE('USER_ID has been modified to VARCHAR2(8).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIPI_FIRESTAT_EXTRACT.zone_no - from NUMBER(2) to VARCHAR2(2)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_FIRESTAT_EXTRACT'
       AND UPPER(column_name) = 'ZONE_NO';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column ZONE_NO to table GIPI_FIRESTAT_EXTRACT.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_FIRESTAT_EXTRACT add ZONE_NO VARCHAR2(2)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIPI_FIRESTAT_EXTRACT MODIFY ZONE_NO VARCHAR2(2)');
        DBMS_OUTPUT.PUT_LINE('ZONE_NO has been modified to VARCHAR2(2).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- GIPI_FIRESTAT_EXTRACT_DTL.zone_no - from NUMBER(2) to VARCHAR2(2)
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tab_columns
     WHERE UPPER(table_name) = 'GIPI_FIRESTAT_EXTRACT_DTL'
       AND UPPER(column_name) = 'ZONE_NO';
       
    IF v_count = 0 THEN   
        dbms_output.put_line('Adding column ZONE_NO to table GIPI_FIRESTAT_EXTRACT_DTL.');
        EXECUTE IMMEDIATE 'ALTER TABLE GIPI_FIRESTAT_EXTRACT_DTL add ZONE_NO VARCHAR2(2)';
        dbms_output.put_line('Column added.');
    ELSE
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.GIPI_FIRESTAT_EXTRACT_DTL MODIFY ZONE_NO VARCHAR2(2)');
        DBMS_OUTPUT.PUT_LINE('ZONE_NO has been modified to VARCHAR2(2).');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;


-- QUEST_SL_TEMP_EXPLAIN1 - drop table
DECLARE 
    v_count     NUMBER;
BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM user_tables
     WHERE UPPER(table_name) = 'QUEST_SL_TEMP_EXPLAIN1';
       
    IF v_count = 0 THEN
        dbms_output.put_line('Table does not exist.');
    ELSE
        EXECUTE IMMEDIATE ('DROP TABLE QUEST_SL_TEMP_EXPLAIN1');
        DBMS_OUTPUT.PUT_LINE('QUEST_SL_TEMP_EXPLAIN1 has been dropped.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '||sqlerrm);
END;
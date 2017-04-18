SET SERVEROUTPUT ON

DECLARE
    v_tab_exists        NUMBER := 0;
    v_col_exists        NUMBER := 0;
BEGIN
    -- check if table is already existing
    SELECT 1
      INTO v_tab_exists
      FROM all_tables
     WHERE table_name = 'GIPI_GROUPED_ITEMS'
       AND owner = 'CPI';
       
    IF v_tab_exists = 1 THEN
        -- include all columns of the table
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'POLICY_ID';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY policy_id NUMBER(12)');
                dbms_output.put_line('Column POLICY_ID has been modified to NUMBER(12)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD policy_id NUMBER(12)');
                dbms_output.put_line('Column POLICY_ID has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'ITEM_NO';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY item_no NUMBER(9)');
                dbms_output.put_line('Column ITEM_NO has been modified to NUMBER(9)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD item_no NUMBER(9)');
                dbms_output.put_line('Column ITEM_NO has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'GROUPED_ITEM_NO';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY grouped_item_no NUMBER(9)');
                dbms_output.put_line('Column GROUPED_ITEM_NO has been modified to NUMBER(9)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD grouped_item_no NUMBER(9)');
                dbms_output.put_line('Column GROUPED_ITEM_NO has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'GROUPED_ITEM_TITLE';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY grouped_item_title VARCHAR2(50)');
                dbms_output.put_line('Column GROUPED_ITEM_TITLE has been modified to VARCHAR2(50)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD grouped_item_title VARCHAR2(50)');
                dbms_output.put_line('Column GROUPED_ITEM_TITLE has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'INCLUDE_TAG';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY include_tag VARCHAR2(1)');
                dbms_output.put_line('Column INCLUDE_TAG has been modified to VARCHAR2(1)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD include_tag VARCHAR2(1)');
                dbms_output.put_line('Column INCLUDE_TAG has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'SEX';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY sex VARCHAR2(1)');
                dbms_output.put_line('Column SEX has been modified to VARCHAR2(1)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD sex VARCHAR2(1)');
                dbms_output.put_line('Column SEX has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'POSITION_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY position_cd NUMBER(4)');
                dbms_output.put_line('Column POSITION_CD has been modified to NUMBER(4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD position_cd NUMBER(4)');
                dbms_output.put_line('Column POSITION_CD has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'CIVIL_STATUS';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY civil_status VARCHAR2(1)');
                dbms_output.put_line('Column CIVIL_STATUS has been modified to VARCHAR2(1)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD civil_status VARCHAR2(1)');
                dbms_output.put_line('Column CIVIL_STATUS has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'DATE_OF_BIRTH';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY date_of_birth DATE');
                dbms_output.put_line('Column DATE_OF_BIRTH has been modified to DATE');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD date_of_birth DATE');
                dbms_output.put_line('Column DATE_OF_BIRTH has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'AGE';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY age NUMBER(3)');
                dbms_output.put_line('Column AGE has been modified to NUMBER(3)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD age NUMBER(3)');
                dbms_output.put_line('Column AGE has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'SALARY';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY salary NUMBER(12,2)');
                dbms_output.put_line('Column SALARY has been modified to NUMBER(12,2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD salary NUMBER(12,2)');
                dbms_output.put_line('Column SALARY has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'SALARY_GRADE';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY salary_grade VARCHAR2(3)');
                dbms_output.put_line('Column SALARY_GRADE has been modified to VARCHAR2(3)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD salary_grade VARCHAR2(3)');
                dbms_output.put_line('Column SALARY_GRADE has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'AMOUNT_COVERAGE';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY amount_coverage NUMBER(16,2)');
                dbms_output.put_line('Column AMOUNT_COVERAGE has been modified to NUMBER(16,2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD amount_coverage NUMBER(16,2)');
                dbms_output.put_line('Column AMOUNT_COVERAGE has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'REMARKS';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY remarks VARCHAR2(4000)');
                dbms_output.put_line('Column REMARKS has been modified to VARCHAR2(4000)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD remarks VARCHAR2(4000)');
                dbms_output.put_line('Column REMARKS has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'LINE_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY line_cd VARCHAR2(2)');
                dbms_output.put_line('Column LINE_CD has been modified to VARCHAR2(2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD line_cd VARCHAR2(2)');
                dbms_output.put_line('Column LINE_CD has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'SUBLINE_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY subline_cd VARCHAR2(7)');
                dbms_output.put_line('Column SUBLINE_CD has been modified to VARCHAR2(7)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD subline_cd VARCHAR2(7)');
                dbms_output.put_line('Column SUBLINE_CD has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'CPI_REC_NO';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY cpi_rec_no NUMBER(12)');
                dbms_output.put_line('Column CPI_REC_NO has been modified to NUMBER(12)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD cpi_rec_no NUMBER(12)');
                dbms_output.put_line('Column CPI_REC_NO has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'CPI_BRANCH_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY cpi_branch_cd VARCHAR2(2)');
                dbms_output.put_line('Column CPI_BRANCH_CD has been modified to VARCHAR2(2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD cpi_branch_cd VARCHAR2(2)');
                dbms_output.put_line('Column CPI_BRANCH_CD has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'DELETE_SW';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY delete_sw VARCHAR2(1)');
                dbms_output.put_line('Column DELETE_SW has been modified to VARCHAR2(1)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD delete_sw VARCHAR2(1)');
                dbms_output.put_line('Column DELETE_SW has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'GROUP_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY group_cd NUMBER(4)');
                dbms_output.put_line('Column GROUP_CD has been modified to NUMBER(4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD group_cd NUMBER(4)');
                dbms_output.put_line('Column GROUP_CD has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'USER_ID';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY user_id VARCHAR2(8)');
                dbms_output.put_line('Column USER_ID has been modified to VARCHAR2(8)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD user_id VARCHAR2(8)');
                dbms_output.put_line('Column USER_ID has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'LAST_UPDATE';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY last_update DATE');
                dbms_output.put_line('Column LAST_UPDATE has been modified to DATE');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD last_update DATE');
                dbms_output.put_line('Column LAST_UPDATE has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'FROM_DATE';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY from_date DATE');
                dbms_output.put_line('Column FROM_DATE has been modified to DATE');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD from_date DATE');
                dbms_output.put_line('Column FROM_DATE has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'TO_DATE';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY to_date DATE');
                dbms_output.put_line('Column TO_DATE has been modified to DATE');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD to_date DATE');
                dbms_output.put_line('Column TO_DATE has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'PAYT_TERMS';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY payt_terms VARCHAR2(3)');
                dbms_output.put_line('Column PAYT_TERMS has been modified to VARCHAR2(3)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD payt_terms VARCHAR2(3)');
                dbms_output.put_line('Column PAYT_TERMS has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'PACK_BEN_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY pack_ben_cd NUMBER(4)');
                dbms_output.put_line('Column PACK_BEN_CD has been modified to NUMBER(4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD pack_ben_cd NUMBER(4)');
                dbms_output.put_line('Column PACK_BEN_CD has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'ANN_TSI_AMT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY ann_tsi_amt NUMBER(16,2)');
                dbms_output.put_line('Column ANN_TSI_AMT has been modified to NUMBER(16,2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD ann_tsi_amt NUMBER(16,2)');
                dbms_output.put_line('Column ANN_TSI_AMT has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'ANN_PREM_AMT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY ann_prem_amt NUMBER(12,2)');
                dbms_output.put_line('Column ANN_PREM_AMT has been modified to NUMBER(12,2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD ann_prem_amt NUMBER(12,2)');
                dbms_output.put_line('Column ANN_PREM_AMT has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'CONTROL_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY control_cd VARCHAR2(250)');
                dbms_output.put_line('Column CONTROL_CD has been modified to VARCHAR2(250)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD control_cd VARCHAR2(250)');
                dbms_output.put_line('Column CONTROL_CD has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'CONTROL_TYPE_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY control_type_cd NUMBER(5)');
                dbms_output.put_line('Column CONTROL_TYPE_CD has been modified to NUMBER(5)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD control_type_cd NUMBER(5)');
                dbms_output.put_line('Column CONTROL_TYPE_CD has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'TSI_AMT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY tsi_amt NUMBER(16,2)');
                dbms_output.put_line('Column TSI_AMT has been modified to NUMBER(16,2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD tsi_amt NUMBER(16,2)');
                dbms_output.put_line('Column TSI_AMT has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'PREM_AMT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY prem_amt NUMBER(12,2)');
                dbms_output.put_line('Column PREM_AMT has been modified to NUMBER(12,2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD prem_amt NUMBER(12,2)');
                dbms_output.put_line('Column PREM_AMT has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'PRINCIPAL_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY principal_cd NUMBER(9)');
                dbms_output.put_line('Column PRINCIPAL_CD has been modified to NUMBER(9)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD principal_cd NUMBER(9)');
                dbms_output.put_line('Column PRINCIPAL_CD has been added to GIPI_GROUPED_ITEMS');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_GROUPED_ITEMS'
               AND owner = 'CPI'
               AND column_name = 'ARC_EXT_DATA';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items MODIFY arc_ext_data VARCHAR2(1)');
                dbms_output.put_line('Column ARC_EXT_DATA has been modified to VARCHAR2(1)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_grouped_items ADD arc_ext_data VARCHAR2(1)');
                dbms_output.put_line('Column ARC_EXT_DATA has been added to GIPI_GROUPED_ITEMS');
        END;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- DDL to create table if it is not yet existing
        EXECUTE IMMEDIATE('CREATE TABLE CPI.GIPI_GROUPED_ITEMS
                            (
                              POLICY_ID           NUMBER(12)                NOT NULL,
                              ITEM_NO             NUMBER(9)                 NOT NULL,
                              GROUPED_ITEM_NO     NUMBER(9)                 NOT NULL,
                              GROUPED_ITEM_TITLE  VARCHAR2(50 BYTE)         NOT NULL,
                              INCLUDE_TAG         VARCHAR2(1 BYTE)          NOT NULL,
                              SEX                 VARCHAR2(1 BYTE),
                              POSITION_CD         NUMBER(4),
                              CIVIL_STATUS        VARCHAR2(1 BYTE),
                              DATE_OF_BIRTH       DATE,
                              AGE                 NUMBER(3),
                              SALARY              NUMBER(12,2),
                              SALARY_GRADE        VARCHAR2(3 BYTE),
                              AMOUNT_COVERAGE     NUMBER(16,2),
                              REMARKS             VARCHAR2(4000 BYTE),
                              LINE_CD             VARCHAR2(2 BYTE),
                              SUBLINE_CD          VARCHAR2(7 BYTE),
                              CPI_REC_NO          NUMBER(12),
                              CPI_BRANCH_CD       VARCHAR2(2 BYTE),
                              DELETE_SW           VARCHAR2(1 BYTE),
                              GROUP_CD            NUMBER(4),
                              USER_ID             VARCHAR2(8 BYTE),
                              LAST_UPDATE         DATE,
                              FROM_DATE           DATE,
                              TO_DATE             DATE,
                              PAYT_TERMS          VARCHAR2(3 BYTE),
                              PACK_BEN_CD         NUMBER(4),
                              ANN_TSI_AMT         NUMBER(16,2),
                              ANN_PREM_AMT        NUMBER(12,2),
                              CONTROL_CD          VARCHAR2(250 BYTE),
                              CONTROL_TYPE_CD     NUMBER(5),
                              TSI_AMT             NUMBER(16,2),
                              PREM_AMT            NUMBER(12,2),
                              PRINCIPAL_CD        NUMBER(9),
                              ARC_EXT_DATA        VARCHAR2(1 BYTE)
                            )
                            TABLESPACE MAIN_DATA
                            PCTUSED    0
                            PCTFREE    10
                            INITRANS   1
                            MAXTRANS   255
                            STORAGE    (
                                        INITIAL          5376K
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
                            
        EXECUTE IMMEDIATE('COMMENT ON TABLE CPI.GIPI_GROUPED_ITEMS IS ''This is the main transaction table for items/insurable objects grouped under one item in Personal Accident and Casualty policy.''');
                            
        EXECUTE IMMEDIATE('CREATE UNIQUE INDEX CPI.GIPI_GROUPED_ITEMS_PK ON CPI.GIPI_GROUPED_ITEMS
                            (POLICY_ID, ITEM_NO, GROUPED_ITEM_NO)
                            LOGGING
                            TABLESPACE INDEXES
                            PCTFREE    10
                            INITRANS   2
                            MAXTRANS   255
                            STORAGE    (
                                        INITIAL          1536K
                                        NEXT             128K
                                        MINEXTENTS       1
                                        MAXEXTENTS       UNLIMITED
                                        PCTINCREASE      0
                                        BUFFER_POOL      DEFAULT
                                       )
                            NOPARALLEL');


        EXECUTE IMMEDIATE('CREATE INDEX CPI.GIPI_GROUPED_ITEMS_XX ON CPI.GIPI_GROUPED_ITEMS
                            (GROUP_CD)
                            LOGGING
                            TABLESPACE INDEXES
                            PCTFREE    10
                            INITRANS   2
                            MAXTRANS   255
                            STORAGE    (
                                        INITIAL          128K
                                        NEXT             128K
                                        MINEXTENTS       1
                                        MAXEXTENTS       UNLIMITED
                                        PCTINCREASE      0
                                        BUFFER_POOL      DEFAULT
                                       )
                            NOPARALLEL');
        
        EXECUTE IMMEDIATE('CREATE OR REPLACE TRIGGER CPI.GIPI_GROUPED_ITEMS_TBXIU
                              BEFORE INSERT OR UPDATE ON CPI.GIPI_GROUPED_ITEMS FOR EACH ROW
                            DECLARE
                            BEGIN
                              :NEW.user_id    := NVL (giis_users_pkg.app_user, USER);
                              :NEW.last_update := SYSDATE;
                            END');
                            
        EXECUTE IMMEDIATE('CREATE PUBLIC SYNONYM GIPI_GROUPED_ITEMS FOR CPI.GIPI_GROUPED_ITEMS');
        
        EXECUTE IMMEDIATE('ALTER TABLE CPI.GIPI_GROUPED_ITEMS ADD (
                              CONSTRAINT GIPI_GROUPED_ITEMS_PK
                             PRIMARY KEY
                             (POLICY_ID, ITEM_NO, GROUPED_ITEM_NO)
                                USING INDEX 
                                TABLESPACE INDEXES
                                PCTFREE    10
                                INITRANS   2
                                MAXTRANS   255
                                STORAGE    (
                                            INITIAL          1536K
                                            NEXT             128K
                                            MINEXTENTS       1
                                            MAXEXTENTS       UNLIMITED
                                            PCTINCREASE      0
                                           ))');

        EXECUTE IMMEDIATE('ALTER TABLE CPI.GIPI_GROUPED_ITEMS ADD (
                              CONSTRAINT GIPI_GROUPED_ITEMS_FK 
                             FOREIGN KEY (POLICY_ID, ITEM_NO) 
                             REFERENCES CPI.GIPI_ITEM (POLICY_ID,ITEM_NO),
                              CONSTRAINT GROUP_GROUPED_ITEMS_FK 
                             FOREIGN KEY (GROUP_CD) 
                             REFERENCES CPI.GIIS_GROUP (GROUP_CD))');
                     
        EXECUTE IMMEDIATE('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIPI_GROUPED_ITEMS TO PUBLIC');
        
        dbms_output.put_line('GIPI_GROUPED_ITEMS table created');
END;
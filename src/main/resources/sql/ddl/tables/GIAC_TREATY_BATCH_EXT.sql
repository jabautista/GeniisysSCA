SET SERVEROUTPUT ON

DECLARE
    v_tab_exists        NUMBER := 0;
    v_col_exists        NUMBER := 0;
BEGIN
    -- check if table is already existing
    SELECT 1
      INTO v_tab_exists
      FROM all_tables
     WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
       AND owner = 'CPI';
       
    IF v_tab_exists = 1 THEN
        -- include all columns of the table
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'CESSION_ID';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY cession_id NUMBER(12)');
                dbms_output.put_line('Column CESSION_ID has been modified to NUMBER(12)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD cession_id NUMBER(12)');
                dbms_output.put_line('Column CESSION_ID has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'ISS_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY iss_cd VARCHAR2(2)');
                dbms_output.put_line('Column ISS_CD has been modified to VARCHAR2(2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD iss_cd VARCHAR2(2)');
                dbms_output.put_line('Column ISS_CD has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'POLICY_ID';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY policy_id NUMBER(12)');
                dbms_output.put_line('Column POLICY_ID has been modified to NUMBER(12)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD policy_id NUMBER(12)');
                dbms_output.put_line('Column POLICY_ID has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'ITEM_NO';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY item_no NUMBER(9)');
                dbms_output.put_line('Column ITEM_NO has been modified to NUMBER(9)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD item_no NUMBER(9)');
                dbms_output.put_line('Column ITEM_NO has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'LINE_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY line_cd VARCHAR2(2)');
                dbms_output.put_line('Column LINE_CD has been modified to VARCHAR2(2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD line_cd VARCHAR2(2)');
                dbms_output.put_line('Column LINE_CD has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'ACCT_LINE_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY acct_line_cd NUMBER(2)');
                dbms_output.put_line('Column ACCT_LINE_CD has been modified to NUMBER(2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD acct_line_cd NUMBER(2)');
                dbms_output.put_line('Column ACCT_LINE_CD has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'ACCT_SUBLINE_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY acct_subline_cd NUMBER(2)');
                dbms_output.put_line('Column ACCT_SUBLINE_CD has been modified to NUMBER(2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD acct_subline_cd NUMBER(2)');
                dbms_output.put_line('Column ACCT_SUBLINE_CD has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'SHARE_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY share_cd NUMBER(3)');
                dbms_output.put_line('Column SHARE_CD has been modified to NUMBER(3)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD share_cd NUMBER(3)');
                dbms_output.put_line('Column SHARE_CD has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'TRTY_YY';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY trty_yy NUMBER(2)');
                dbms_output.put_line('Column TRTY_YY has been modified to NUMBER(2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD trty_yy NUMBER(2)');
                dbms_output.put_line('Column TRTY_YY has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'RI_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY ri_cd NUMBER(5)');
                dbms_output.put_line('Column RI_CD has been modified to NUMBER(5)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD ri_cd NUMBER(5)');
                dbms_output.put_line('Column RI_CD has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'PERIL_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY peril_cd NUMBER(5)');
                dbms_output.put_line('Column PERIL_CD has been modified to NUMBER(5)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD peril_cd NUMBER(5)');
                dbms_output.put_line('Column PERIL_CD has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'CURRENCY_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY currency_cd NUMBER(2)');
                dbms_output.put_line('Column CURRENCY_CD has been modified to NUMBER(2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD currency_cd NUMBER(2)');
                dbms_output.put_line('Column CURRENCY_CD has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'CURRENCY_RT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY currency_rt NUMBER(12,9)');
                dbms_output.put_line('Column CURRENCY_RT has been modified to NUMBER(12,9)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD currency_rt NUMBER(12,9)');
                dbms_output.put_line('Column CURRENCY_RT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'TK_UP_TYPE';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY tk_up_type VARCHAR2(1)');
                dbms_output.put_line('Column TK_UP_TYPE has been modified to VARCHAR2(1)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD tk_up_type VARCHAR2(1)');
                dbms_output.put_line('Column TK_UP_TYPE has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'FUNDS_HELD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY funds_held NUMBER(12,9)');
                dbms_output.put_line('Column FUNDS_HELD has been modified to NUMBER(12,9)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD funds_held NUMBER(12,9)');
                dbms_output.put_line('Column FUNDS_HELD has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
                BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'PREMIUM_AMT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY premium_amt NUMBER(16,4)');
                dbms_output.put_line('Column PREMIUM_AMT has been modified to NUMBER(16,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD premium_amt NUMBER(16,4)');
                dbms_output.put_line('Column PREMIUM_AMT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'FC_PREM_AMT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY fc_prem_amt NUMBER(16,4)');
                dbms_output.put_line('Column FC_PREM_AMT has been modified to NUMBER(16,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD fc_prem_amt NUMBER(16,4)');
                dbms_output.put_line('Column FC_PREM_AMT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'COMMISSION_AMT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY commission_amt NUMBER(16,4)');
                dbms_output.put_line('Column COMMISSION_AMT has been modified to NUMBER(16,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD commission_amt NUMBER(16,4)');
                dbms_output.put_line('Column COMMISSION_AMT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'FC_COMM_AMT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY fc_comm_amt NUMBER(16,4)');
                dbms_output.put_line('Column FC_COMM_AMT has been modified to NUMBER(16,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD fc_comm_amt NUMBER(16,4)');
                dbms_output.put_line('Column FC_COMM_AMT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'TAX_AMT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY tax_amt NUMBER(16,4)');
                dbms_output.put_line('Column TAX_AMT has been modified to NUMBER(16,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD tax_amt NUMBER(16,4)');
                dbms_output.put_line('Column TAX_AMT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
                BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'FC_TAX_AMT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY fc_tax_amt NUMBER(16,4)');
                dbms_output.put_line('Column FC_TAX_AMT has been modified to NUMBER(16,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD fc_tax_amt NUMBER(16,4)');
                dbms_output.put_line('Column FC_TAX_AMT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'ACCT_INTM_CD';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY acct_intm_cd NUMBER(2)');
                dbms_output.put_line('Column ACCT_INTM_CD has been modified to NUMBER(2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD acct_intm_cd NUMBER(2)');
                dbms_output.put_line('Column ACCT_INTM_CD has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'ACCT_TRTY_TYPE';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY acct_trty_type NUMBER(2)');
                dbms_output.put_line('Column ACCT_TRTY_TYPE has been modified to NUMBER(2)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD acct_trty_type NUMBER(2)');
                dbms_output.put_line('Column ACCT_TRTY_TYPE has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'DIST_NO';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY dist_no NUMBER(8)');
                dbms_output.put_line('Column DIST_NO has been modified to NUMBER(8)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD dist_no NUMBER(8)');
                dbms_output.put_line('Column DIST_NO has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'DUE_TO_RI';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY due_to_ri NUMBER(16,4)');
                dbms_output.put_line('Column DUE_TO_RI has been modified to NUMBER(16,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD due_to_ri NUMBER(16,4)');
                dbms_output.put_line('Column DUE_TO_RI has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'FUNDS_HELD_AMT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY funds_held_amt NUMBER(16,4)');
                dbms_output.put_line('Column FUNDS_HELD_AMT has been modified to NUMBER(16,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD funds_held_amt NUMBER(16,4)');
                dbms_output.put_line('Column FUNDS_HELD_AMT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'PREM_VAT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY prem_vat NUMBER(12,4)');
                dbms_output.put_line('Column PREM_VAT has been modified to NUMBER(12,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD prem_vat NUMBER(12,4)');
                dbms_output.put_line('Column PREM_VAT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'COMM_VAT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY comm_vat NUMBER(12,4)');
                dbms_output.put_line('Column COMM_VAT has been modified to NUMBER(12,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD comm_vat NUMBER(12,4)');
                dbms_output.put_line('Column COMM_VAT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'FC_PREM_VAT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY fc_prem_vat NUMBER(12,4)');
                dbms_output.put_line('Column FC_PREM_VAT has been modified to NUMBER(12,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD fc_prem_vat NUMBER(12,4)');
                dbms_output.put_line('Column FC_PREM_VAT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'FC_COMM_VAT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY fc_comm_vat NUMBER(12,4)');
                dbms_output.put_line('Column FC_COMM_VAT has been modified to NUMBER(12,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD fc_comm_vat NUMBER(12,4)');
                dbms_output.put_line('Column FC_COMM_VAT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
                BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'RI_WHOLDING_VAT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY ri_wholding_vat NUMBER(12,4)');
                dbms_output.put_line('Column RI_WHOLDING_VAT has been modified to NUMBER(12,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD ri_wholding_vat NUMBER(12,4)');
                dbms_output.put_line('Column RI_WHOLDING_VAT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'LOCAL_FOREIGN_SW';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY local_foreign_sw VARCHAR2(1)');
                dbms_output.put_line('Column LOCAL_FOREIGN_SW has been modified to VARCHAR2(1)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD local_foreign_sw VARCHAR2(1)');
                dbms_output.put_line('Column LOCAL_FOREIGN_SW has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'FC_RI_WHOLDING_VAT';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY fc_ri_wholding_vat NUMBER(12,4)');
                dbms_output.put_line('Column FC_RI_WHOLDING_VAT has been modified to NUMBER(12,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD fc_ri_wholding_vat NUMBER(12,4)');
                dbms_output.put_line('Column FC_RI_WHOLDING_VAT has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'FC_PREM_TAX';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY fc_prem_tax NUMBER(12,4)');
                dbms_output.put_line('Column FC_PREM_TAX has been modified to NUMBER(12,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD fc_prem_tax NUMBER(12,4)');
                dbms_output.put_line('Column FC_PREM_TAX has been added to GIAC_TREATY_BATCH_EXT');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'PREM_TAX';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY prem_tax NUMBER(12,4)');
                dbms_output.put_line('Column PREM_TAX has been modified to NUMBER(12,4)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD prem_tax NUMBER(12,4)');
                dbms_output.put_line('Column PREM_TAX has been added to GIAC_TREATY_BATCH_EXT');
        END; 
        
        
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIAC_TREATY_BATCH_EXT'
               AND owner = 'CPI'
               AND column_name = 'LAST_UPDATE';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext MODIFY last_update DATE');
                dbms_output.put_line('Column LAST_UPDATE has been modified to DATE');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE giac_treaty_batch_ext ADD last_update DATE');
                dbms_output.put_line('Column LAST_UPDATE has been added to GIAC_TREATY_BATCH_EXT');
        END;        
        
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- DDL to create table if it is not yet existing
        EXECUTE IMMEDIATE('CREATE TABLE CPI.GIAC_TREATY_BATCH_EXT
                            (
                              CESSION_ID          NUMBER(12)                NOT NULL,
                              ISS_CD              VARCHAR2(2 BYTE)          NOT NULL,
                              POLICY_ID           NUMBER(12)                NOT NULL,
                              ITEM_NO             NUMBER(9)                 NOT NULL,
                              LINE_CD             VARCHAR2(2 BYTE)          NOT NULL,
                              ACCT_LINE_CD        NUMBER(2)                 NOT NULL,
                              ACCT_SUBLINE_CD     NUMBER(2)                 NOT NULL,
                              SHARE_CD            NUMBER(3)                 NOT NULL,
                              TRTY_YY             NUMBER(2)                 NOT NULL,
                              RI_CD               NUMBER(5)                 NOT NULL,
                              PERIL_CD            NUMBER(5)                 NOT NULL,
                              CURRENCY_CD         NUMBER(2),
                              CURRENCY_RT         NUMBER(12,9),
                              TK_UP_TYPE          VARCHAR2(1 BYTE),
                              FUNDS_HELD          NUMBER(12,9),
                              PREMIUM_AMT         NUMBER(16,4),
                              FC_PREM_AMT         NUMBER(16,4),
                              COMMISSION_AMT      NUMBER(16,4),
                              FC_COMM_AMT         NUMBER(16,4),
                              TAX_AMT             NUMBER(16,4),
                              FC_TAX_AMT          NUMBER(16,4),
                              ACCT_INTM_CD        NUMBER(2),
                              ACCT_TRTY_TYPE      NUMBER(2),
                              DIST_NO             NUMBER(8),
                              DUE_TO_RI           NUMBER(16,4),
                              FUNDS_HELD_AMT      NUMBER(16,4),
                              PREM_VAT            NUMBER(12,4),
                              COMM_VAT            NUMBER(12,4),
                              FC_PREM_VAT         NUMBER(12,4),
                              FC_COMM_VAT         NUMBER(12,4),
                              RI_WHOLDING_VAT     NUMBER(12,4),
                              LOCAL_FOREIGN_SW    VARCHAR2(1 BYTE),
                              FC_RI_WHOLDING_VAT  NUMBER(12,4),
                              FC_PREM_TAX         NUMBER(12,4),
                              PREM_TAX            NUMBER(12,4),
                              LAST_UPDATE         DATE
                            )
                            TABLESPACE ACCTG_DATA
                            PCTUSED    0
                            PCTFREE    10
                            INITRANS   1
                            MAXTRANS   255
                            STORAGE    (
                                        INITIAL          640K
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
        
        EXECUTE IMMEDIATE('CREATE PUBLIC SYNONYM GIAC_TREATY_BATCH_EXT FOR CPI.GIAC_TREATY_BATCH_EXT');
                                 
        EXECUTE IMMEDIATE('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIAC_TREATY_BATCH_EXT TO PUBLIC');
        
        dbms_output.put_line('GIAC_TREATY_BATCH_EXT table created');
END;
SET SERVEROUTPUT ON

DECLARE
    v_tab_exists        NUMBER := 0;
    v_col_exists        NUMBER := 0;
BEGIN
    -- check if table is already existing
    SELECT 1
      INTO v_tab_exists
      FROM all_tables
     WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
       AND owner = 'CPI';
       
    IF v_tab_exists = 1 THEN
        -- include all columns of the table
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
               AND owner = 'CPI'
               AND column_name = 'PAR_ID';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary MODIFY par_id NUMBER(12)');
                dbms_output.put_line('Column PAR_ID has been modified to NUMBER(12)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary ADD par_id NUMBER(12)');
                dbms_output.put_line('Column PAR_ID has been added to GIPI_WGRP_ITEMS_BENEFICIARY');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
               AND owner = 'CPI'
               AND column_name = 'ITEM_NO';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary MODIFY item_no NUMBER(9)');
                dbms_output.put_line('Column ITEM_NO has been modified to NUMBER(9)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary ADD item_no NUMBER(9)');
                dbms_output.put_line('Column ITEM_NO has been added to GIPI_WGRP_ITEMS_BENEFICIARY');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
               AND owner = 'CPI'
               AND column_name = 'GROUPED_ITEM_NO';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary MODIFY grouped_item_no NUMBER(9)');
                dbms_output.put_line('Column GROUPED_ITEM_NO has been modified to NUMBER(9)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary ADD grouped_item_no NUMBER(9)');
                dbms_output.put_line('Column GROUPED_ITEM_NO has been added to GIPI_WGRP_ITEMS_BENEFICIARY');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
               AND owner = 'CPI'
               AND column_name = 'BENEFICIARY_NO';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary MODIFY beneficiary_no NUMBER(5)');
                dbms_output.put_line('Column BENEFICIARY_NO has been modified to NUMBER(5)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary ADD beneficiary_no NUMBER(5)');
                dbms_output.put_line('Column BENEFICIARY_NO has been added to GIPI_WGRP_ITEMS_BENEFICIARY');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
               AND owner = 'CPI'
               AND column_name = 'BENEFICIARY_NAME';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary MODIFY beneficiary_name VARCHAR2(30)');
                dbms_output.put_line('Column BENEFICIARY_NAME has been modified to VARCHAR2(30)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary ADD beneficiary_name VARCHAR2(30)');
                dbms_output.put_line('Column BENEFICIARY_NAME has been added to GIPI_WGRP_ITEMS_BENEFICIARY');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
               AND owner = 'CPI'
               AND column_name = 'BENEFICIARY_ADDR';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary MODIFY beneficiary_addr VARCHAR2(50)');
                dbms_output.put_line('Column BENEFICIARY_ADDR has been modified to VARCHAR2(50)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary ADD beneficiary_addr VARCHAR2(50)');
                dbms_output.put_line('Column BENEFICIARY_ADDR has been added to GIPI_WGRP_ITEMS_BENEFICIARY');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
               AND owner = 'CPI'
               AND column_name = 'RELATION';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary MODIFY relation VARCHAR2(15)');
                dbms_output.put_line('Column RELATION has been modified to VARCHAR2(15)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary ADD relation VARCHAR2(15)');
                dbms_output.put_line('Column RELATION has been added to GIPI_WGRP_ITEMS_BENEFICIARY');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
               AND owner = 'CPI'
               AND column_name = 'DATE_OF_BIRTH';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary MODIFY date_of_birth DATE');
                dbms_output.put_line('Column DATE_OF_BIRTH has been modified to DATE');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary ADD date_of_birth DATE');
                dbms_output.put_line('Column DATE_OF_BIRTH has been added to GIPI_WGRP_ITEMS_BENEFICIARY');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
               AND owner = 'CPI'
               AND column_name = 'AGE';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary MODIFY age NUMBER(3)');
                dbms_output.put_line('Column AGE has been modified to NUMBER(3)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary ADD age NUMBER(3)');
                dbms_output.put_line('Column AGE has been added to GIPI_WGRP_ITEMS_BENEFICIARY');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
               AND owner = 'CPI'
               AND column_name = 'CIVIL_STATUS';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary MODIFY civil_status VARCHAR2(1)');
                dbms_output.put_line('Column CIVIL_STATUS has been modified to VARCHAR2(1)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary ADD civil_status VARCHAR2(1)');
                dbms_output.put_line('Column CIVIL_STATUS has been added to GIPI_WGRP_ITEMS_BENEFICIARY');
        END;
        
        BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE table_name = 'GIPI_WGRP_ITEMS_BENEFICIARY'
               AND owner = 'CPI'
               AND column_name = 'SEX';
               
            IF v_col_exists = 1 THEN
                -- modify column if table and column are already existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary MODIFY sex VARCHAR2(1)');
                dbms_output.put_line('Column SEX has been modified to VARCHAR2(1)');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- add column if column is not yet existing
                EXECUTE IMMEDIATE('ALTER TABLE gipi_wgrp_items_beneficiary ADD sex VARCHAR2(1)');
                dbms_output.put_line('Column SEX has been added to GIPI_WGRP_ITEMS_BENEFICIARY');
        END;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- DDL to create table if it is not yet existing        
        
        EXECUTE IMMEDIATE('CREATE TABLE CPI.GIPI_WGRP_ITEMS_BENEFICIARY
                            (
                              PAR_ID            NUMBER(12)                  NOT NULL,
                              ITEM_NO           NUMBER(9)                   NOT NULL,
                              GROUPED_ITEM_NO   NUMBER(9)                   NOT NULL,
                              BENEFICIARY_NO    NUMBER(5)                   NOT NULL,
                              BENEFICIARY_NAME  VARCHAR2(30 BYTE)           NOT NULL,
                              BENEFICIARY_ADDR  VARCHAR2(50 BYTE),
                              RELATION          VARCHAR2(15 BYTE),
                              DATE_OF_BIRTH     DATE,
                              AGE               NUMBER(3),
                              CIVIL_STATUS      VARCHAR2(1 BYTE),
                              SEX               VARCHAR2(1 BYTE)
                            )
                            TABLESPACE WORKING_DATA
                            PCTUSED    0
                            PCTFREE    10
                            INITRANS   1
                            MAXTRANS   255
                            STORAGE    (
                                        INITIAL          128K
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
                         
        EXECUTE IMMEDIATE('COMMENT ON TABLE CPI.GIPI_WGRP_ITEMS_BENEFICIARY IS ''This is the working transaction table for the beneficiaries of the grouped item(s) stored in table GIPI_GROUPED_ITEMS per person insured in Personal Accident and Casualty policy.''');
        
        EXECUTE IMMEDIATE('CREATE UNIQUE INDEX CPI.WGRP_ITEMS_BENEFICIARY_PK ON CPI.GIPI_WGRP_ITEMS_BENEFICIARY
                            (PAR_ID, ITEM_NO, GROUPED_ITEM_NO, BENEFICIARY_NO)
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
                         
        EXECUTE IMMEDIATE('CREATE PUBLIC SYNONYM GIPI_WGRP_ITEMS_BENEFICIARY FOR CPI.GIPI_WGRP_ITEMS_BENEFICIARY');
        
        EXECUTE IMMEDIATE('ALTER TABLE CPI.GIPI_WGRP_ITEMS_BENEFICIARY ADD (
                              CONSTRAINT WGRP_ITEMS_BENEFICIARY_PK
                             PRIMARY KEY
                             (PAR_ID, ITEM_NO, GROUPED_ITEM_NO, BENEFICIARY_NO)
                                USING INDEX 
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
                                           ))');
                         
        EXECUTE IMMEDIATE('ALTER TABLE CPI.GIPI_WGRP_ITEMS_BENEFICIARY ADD (
                              CONSTRAINT WGROUPED_ITEMS_WGRP_ITM_BEN_FK 
                             FOREIGN KEY (PAR_ID, ITEM_NO, GROUPED_ITEM_NO) 
                             REFERENCES CPI.GIPI_WGROUPED_ITEMS (PAR_ID,ITEM_NO,GROUPED_ITEM_NO))');
        
        EXECUTE IMMEDIATE('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIPI_WGRP_ITEMS_BENEFICIARY TO PUBLIC');
        
        dbms_output.put_line('GIPI_WGRP_ITEMS_BENEFICIARY table created');
END;
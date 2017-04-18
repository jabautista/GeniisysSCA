SET serveroutput ON
DECLARE
    v_exists    NUMBER := 0;
BEGIN
    SELECT DISTINCT 1
      INTO v_exists
      FROM all_indexes
     WHERE owner = 'CPI'
       AND index_name = 'GFPP_PK';
    
    IF v_exists = 1 THEN        
        EXECUTE IMMEDIATE ('ALTER TABLE giac_outfacul_prem_payts DROP CONSTRAINT gfpp_pk');
        EXECUTE IMMEDIATE ('DROP INDEX GFPP_PK');
        
        EXECUTE IMMEDIATE ('CREATE UNIQUE INDEX CPI.gfpp_pk ON CPI.giac_outfacul_prem_payts
                                (D010_FNL_BINDER_ID, GACC_TRAN_ID, A180_RI_CD, RECORD_NO)
                                LOGGING
                                TABLESPACE INDEXES
                                PCTFREE    10
                                INITRANS   2
                                MAXTRANS   255
                                STORAGE    (
                                            INITIAL          512K
                                            NEXT             128K
                                            MINEXTENTS       1
                                            MAXEXTENTS       UNLIMITED
                                            PCTINCREASE      0
                                            BUFFER_POOL      DEFAULT
                                           )
                                NOPARALLEL');
         
        EXECUTE IMMEDIATE('ALTER TABLE CPI.GIAC_OUTFACUL_PREM_PAYTS ADD (
                              CONSTRAINT GFPP_PK
                              PRIMARY KEY
                              (D010_FNL_BINDER_ID, GACC_TRAN_ID, A180_RI_CD, RECORD_NO)
                              USING INDEX CPI.GFPP_PK
                              ENABLE VALIDATE)');
        DBMS_OUTPUT.PUT_LINE('Successfully modified constraint GFPP_PK of giac_outfacul_prem_payts.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        EXECUTE IMMEDIATE ('CREATE UNIQUE INDEX CPI.GFPP_PK ON CPI.GIAC_OUTFACUL_PREM_PAYTS
                                (D010_FNL_BINDER_ID, GACC_TRAN_ID, A180_RI_CD, RECORD_NO)
                                LOGGING
                                TABLESPACE INDEXES
                                PCTFREE    10
                                INITRANS   2
                                MAXTRANS   255
                                STORAGE    (
                                            INITIAL          512K
                                            NEXT             128K
                                            MINEXTENTS       1
                                            MAXEXTENTS       UNLIMITED
                                            PCTINCREASE      0
                                            BUFFER_POOL      DEFAULT
                                           )
                                NOPARALLEL');
         
        EXECUTE IMMEDIATE('ALTER TABLE CPI.GIAC_OUTFACUL_PREM_PAYTS ADD (
                              CONSTRAINT GFPP_PK
                              PRIMARY KEY
                              (D010_FNL_BINDER_ID, GACC_TRAN_ID, A180_RI_CD, RECORD_NO)
                              USING INDEX CPI.GFPP_PK
                              ENABLE VALIDATE)');
                              
        DBMS_OUTPUT.PUT_LINE('Successfully added constraint GFPP_PK of giac_outfacul_prem_payts.');
        
    WHEN TOO_MANY_ROWS THEN
        EXECUTE IMMEDIATE ('DROP INDEX GFPP_PK');
        
        EXECUTE IMMEDIATE ('CREATE UNIQUE INDEX CPI.GFPP_PK ON CPI.GIAC_OUTFACUL_PREM_PAYTS
                                (D010_FNL_BINDER_ID, GACC_TRAN_ID, A180_RI_CD, RECORD_NO)
                                LOGGING
                                TABLESPACE INDEXES
                                PCTFREE    10
                                INITRANS   2
                                MAXTRANS   255
                                STORAGE    (
                                            INITIAL          512K
                                            NEXT             128K
                                            MINEXTENTS       1
                                            MAXEXTENTS       UNLIMITED
                                            PCTINCREASE      0
                                            BUFFER_POOL      DEFAULT
                                           )
                                NOPARALLEL');
         
        EXECUTE IMMEDIATE('ALTER TABLE CPI.GIAC_OUTFACUL_PREM_PAYTS ADD (
                              CONSTRAINT GFPP_PK
                              PRIMARY KEY
                              (D010_FNL_BINDER_ID, GACC_TRAN_ID, A180_RI_CD, RECORD_NO)
                              USING INDEX CPI.GFPP_PK
                              ENABLE VALIDATE)');
                              
        DBMS_OUTPUT.PUT_LINE('Successfully modified constraint GFPP_PK of giac_outfacul_prem_payts.');
END;
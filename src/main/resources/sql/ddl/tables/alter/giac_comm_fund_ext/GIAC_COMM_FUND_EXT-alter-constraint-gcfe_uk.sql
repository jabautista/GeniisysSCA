SET serveroutput ON
DECLARE
    v_exists    NUMBER := 0;
BEGIN
    SELECT DISTINCT 1
      INTO v_exists
      FROM all_constraints
     WHERE owner = 'CPI'
       AND constraint_name = 'GCFE_UK';
       
    IF v_exists = 1 THEN
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.giac_comm_fund_ext DROP CONSTRAINT gcfe_uk');
        
        EXECUTE IMMEDIATE ('DROP INDEX CPI.gcfe_uk');
        
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.giac_comm_fund_ext ADD (
                                                                    CONSTRAINT gcfe_uk '||
                                                                    'UNIQUE (gacc_tran_id, iss_cd, prem_seq_no, intm_no, record_no, cs_rec_no, record_seq_no) '||
                                                                    'USING INDEX
                                                                            TABLESPACE users
                                                                            PCTFREE    10
                                                                            INITRANS   2
                                                                            MAXTRANS   255
                                                                            STORAGE    (
                                                                                        INITIAL          192 k
                                                                                        MINEXTENTS       1
                                                                                        MAXEXTENTS       UNLIMITED
                                                                                        PCTINCREASE      0
                                                                                       )
                                                                     )');
        DBMS_OUTPUT.PUT_LINE('Successfully modified constraint GCFE_UK of GIAC_COMM_FUND_EXT.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.giac_comm_fund_ext ADD (
                                                                    CONSTRAINT gcfe_uk '||
                                                                    'UNIQUE (gacc_tran_id, iss_cd, prem_seq_no, intm_no, record_no, cs_rec_no, record_seq_no) '||
                                                                    'USING INDEX
                                                                            TABLESPACE users
                                                                            PCTFREE    10
                                                                            INITRANS   2
                                                                            MAXTRANS   255
                                                                            STORAGE    (
                                                                                        INITIAL          192 k
                                                                                        MINEXTENTS       1
                                                                                        MAXEXTENTS       UNLIMITED
                                                                                        PCTINCREASE      0
                                                                                       )
                                                                    )');
        DBMS_OUTPUT.PUT_LINE('Successfully added constraint GCFE_UK of GIAC_COMM_FUND_EXT.');
        
    WHEN TOO_MANY_ROWS THEN
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.giac_comm_fund_ext DROP CONSTRAINT gcfe_uk');
        EXECUTE IMMEDIATE ('DROP INDEX CPI.gcfe_uk');
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.giac_comm_fund_ext ADD (
                                                                    CONSTRAINT gcfe_uk '||
                                                                    'UNIQUE (gacc_tran_id, iss_cd, prem_seq_no, intm_no, record_no, cs_rec_no, record_seq_no) '||
                                                                    'USING INDEX
                                                                            TABLESPACE users
                                                                            PCTFREE    10
                                                                            INITRANS   2
                                                                            MAXTRANS   255
                                                                            STORAGE    (
                                                                                        INITIAL          192 k
                                                                                        MINEXTENTS       1
                                                                                        MAXEXTENTS       UNLIMITED
                                                                                        PCTINCREASE      0
                                                                                       )
                                                                     )');
        DBMS_OUTPUT.PUT_LINE('Successfully modified constraint GCFE_UK of GIAC_COMM_FUND_EXT.');
END;
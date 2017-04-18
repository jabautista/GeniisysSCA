SET SERVEROUTPUT ON

DECLARE
    v_exists        NUMBER(1) := 0;
BEGIN
    -- check if table is already existing
    FOR i IN (
            SELECT DISTINCT 1 rec
              FROM all_tables
             WHERE owner = 'CPI'
               AND table_name = 'GIAC_BATCH_NULL_BOOKINGMTH')
    LOOP
        v_exists := i.rec;
    END LOOP;
       
    IF v_exists = 1 THEN
        dbms_output.put_line('Table GIAC_BATCH_NULL_BOOKINGMTH alreay exists.');
    ELSE
        -- DDL to create table if it is not yet existing
        EXECUTE IMMEDIATE('CREATE TABLE CPI.GIAC_BATCH_NULL_BOOKINGMTH
                            (
                              POLICY_ID           NUMBER(12)                NOT NULL,
                              POLICY_NO           VARCHAR2(30 BYTE)         NOT NULL
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
        
        EXECUTE IMMEDIATE('CREATE PUBLIC SYNONYM GIAC_BATCH_NULL_BOOKINGMTH FOR CPI.GIAC_BATCH_NULL_BOOKINGMTH');
        
        dbms_output.put_line('GIAC_BATCH_NULL_BOOKINGMTH table created');
    END IF;
END;
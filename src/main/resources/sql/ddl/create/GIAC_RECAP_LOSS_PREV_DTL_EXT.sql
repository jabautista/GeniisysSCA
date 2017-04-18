SET SERVEROUTPUT ON 

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_objects
    WHERE owner = 'CPI' AND object_name = 'GIAC_RECAP_LOSS_PREV_DTL_EXT';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('GIAC_RECAP_LOSS_PREV_DTL_EXT already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE (   'CREATE TABLE CPI.GIAC_RECAP_LOSS_PREV_DTL_EXT ( '
                         || 'CLAIM_ID         NUMBER(12) NOT NULL,'
                         || 'ITEM_NO          NUMBER(9)  NOT NULL,'
                         || 'PERIL_CD         NUMBER(5)  NOT NULL,'
                         || 'GROUPED_ITEM_NO  NUMBER(9)  NOT NULL,'
                         || 'LINE_CD          VARCHAR2(2 BYTE),'
                         || 'ISS_CD           VARCHAR2(2 BYTE),'
                         || 'GRP_SEQ_NO       NUMBER(4),'
                         || 'POSTING_DATE     DATE,'
                         || 'ACCT_TRAN_ID     NUMBER(12),'
                         || 'OS_LOSS          NUMBER(16,2),'
                         || 'OS_EXPENSE       NUMBER(16,2),'
                         || 'USER_ID          VARCHAR2(8 BYTE),'
                         || 'LAST_UPDATE      DATE) ' 
                         || 'TABLESPACE USERS '
                         || 'PCTUSED    0 '
                         || 'PCTFREE    10 '
                         || 'INITRANS   1 '
                         || 'MAXTRANS   255 '
                         || 'STORAGE    ( '
                         || 'INITIAL          131712K '
                         || 'NEXT             128K '
                         || 'MINEXTENTS       1 '
                         || 'MAXEXTENTS       UNLIMITED '
                         || 'PCTINCREASE      0 '
                         || 'BUFFER_POOL      DEFAULT) '
                         || 'LOGGING '
                         || 'NOCOMPRESS '
                         || 'NOCACHE '
                         || 'NOPARALLEL '
                         || 'MONITORING'
                        );
      
    
      
      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIAC_RECAP_LOSS_PREV_DTL_EXT FOR CPI.GIAC_RECAP_LOSS_PREV_DTL_EXT');

      EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIAC_RECAP_LOSS_PREV_DTL_EXT TO PUBLIC');

      DBMS_OUTPUT.put_line ('GIAC_RECAP_LOSS_PREV_DTL_EXT created.');
END;
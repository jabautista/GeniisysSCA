SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_objects
    WHERE owner = 'CPI' AND object_name = 'GIPI_UWREPORTS_DIST_NETRET';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('GIPI_UWREPORTS_DIST_NETRET already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE (   'CREATE TABLE CPI.GIPI_UWREPORTS_DIST_NETRET ( '
                         || 'POLICY_ID      NUMBER(12), '
                         || 'ITEM_GRP       NUMBER(5), '
                         || 'TAKEUP_SEQ_NO  NUMBER(3), '
                         || 'DIST_NO        NUMBER(8), '
                         || 'DIST_SEQ_NO    NUMBER(5), '
                         || 'ACCT_ENT_DATE  DATE, '
                         || 'ACCT_NEG_DATE  DATE, '
                         || 'LINE_CD        VARCHAR2(2 BYTE), '
                         || 'SHARE_CD       NUMBER(3), '
                         || 'PERIL_CD       NUMBER(5), '
                         || 'PREM_AMT       NUMBER(12,2), '
                         || 'REC_TYPE       VARCHAR2(1 BYTE), '
                         || 'USER_ID        VARCHAR2(8 BYTE), '
                         || 'TAB_NUMBER     NUMBER(1), '
                         || 'SCOPE          NUMBER(1)) '
                         || 'TABLESPACE MAIN_DATA '
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
                         || 'MONITORING '
                        );

   
      
      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIPI_UWREPORTS_DIST_NETRET FOR CPI.GIPI_UWREPORTS_DIST_NETRET');

      EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIPI_UWREPORTS_DIST_NETRET TO PUBLIC');

      DBMS_OUTPUT.put_line ('GIPI_UWREPORTS_DIST_NETRET created.');
END;
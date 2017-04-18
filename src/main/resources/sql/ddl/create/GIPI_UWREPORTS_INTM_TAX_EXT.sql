SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_objects
    WHERE owner = 'CPI' AND object_name = 'GIPI_UWREPORTS_INTM_TAX_EXT';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('GIPI_UWREPORTS_INTM_TAX_EXT already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE (   'CREATE TABLE CPI.GIPI_UWREPORTS_INTM_TAX_EXT ( '
                         || 'POLICY_ID      NUMBER(12), '
                         || 'ISS_CD       VARCHAR2(2 BYTE), '
                         || 'PREM_SEQ_NO        NUMBER(12), '
                         || 'INTM_NO        NUMBER(12), '
                         || 'TAX_CD         NUMBER(2), '
                         || 'TAX_AMT        NUMBER(12,2), '
                         || 'REC_TYPE       VARCHAR2(1 BYTE), '
                         || 'USER_ID        VARCHAR2(8 BYTE), '
                         || 'LAST_UPDATE    DATE) '
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
                         || 'MONITORING'
                        );

      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIPI_UWREPORTS_INTM_TAX_EXT FOR CPI.GIPI_UWREPORTS_INTM_TAX_EXT');

      EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIPI_UWREPORTS_INTM_TAX_EXT TO PUBLIC');

      DBMS_OUTPUT.put_line ('GIPI_UWREPORTS_INTM_TAX_EXT created.');
END;
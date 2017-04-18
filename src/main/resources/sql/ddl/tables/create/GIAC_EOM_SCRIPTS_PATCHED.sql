SET serveroutput on;

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   BEGIN
      SELECT 'Y'
        INTO v_exists
        FROM all_objects
       WHERE owner = 'CPI' AND object_name = 'GIAC_EOM_SCRIPTS_PATCHED';

      DBMS_OUTPUT.put_line ('Table already exists.');
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         EXECUTE IMMEDIATE 'CREATE TABLE CPI.GIAC_EOM_SCRIPTS_PATCHED
                            (
                              MONTH          VARCHAR2(10),
                              YEAR           NUMBER(4),
                              EOM_SCRIPT_NO  NUMBER(3),
                              POLICY_NO      VARCHAR2(50),
                              POLICY_ID      NUMBER(12),
                              DIST_NO        NUMBER(12),
                              FNL_BINDER_ID  NUMBER(12),
                              CLAIM_ID       NUMBER(12),
                              MODULE_ID      VARCHAR2(10),
                              USER_ID        VARCHAR2(8),
                              LAST_UPDATE    DATE       
                            )
                            TABLESPACE ACCTG_DATA
                            PCTUSED    0
                            PCTFREE    10
                            INITRANS   1
                            MAXTRANS   255
                            STORAGE    (
                                        INITIAL          64K
                                        MINEXTENTS       1
                                        MAXEXTENTS       UNLIMITED
                                        PCTINCREASE      0
                                        BUFFER_POOL      DEFAULT
                                       )
                            LOGGING 
                            NOCOMPRESS 
                            NOCACHE
                            NOPARALLEL
                            MONITORING';

         EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM GIAC_EOM_SCRIPTS_PATCHED FOR CPI.GIAC_EOM_SCRIPTS_PATCHED';

         DBMS_OUTPUT.put_line ('Table created.');
         DBMS_OUTPUT.put_line ('Synonym created.');
   END;
END;
DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   BEGIN
      SELECT 'Y'
        INTO v_exists
        FROM all_tables
       WHERE owner = 'CPI' AND table_name = 'GIIS_USERS_PW_HIST';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_exists := 'N';
   END;

   IF v_exists = 'N'
   THEN
      EXECUTE IMMEDIATE ('CREATE TABLE CPI.GIIS_USERS_PW_HIST
                            (
                              HIST_ID       NUMBER,
                              USER_ID       VARCHAR2(8 BYTE),
                              PASSWORD      VARCHAR2(1000 BYTE),
                              SALT          VARCHAR2(1000 BYTE),
                              DATE_PW_USED  DATE
                            )
                            TABLESPACE USERS
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
                            MONITORING');

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_USERS_PW_HIST ADD (
                              PRIMARY KEY
                              (HIST_ID)
                              USING INDEX
                                TABLESPACE USERS
                                PCTFREE    10
                                INITRANS   2
                                MAXTRANS   255
                                STORAGE    (
                                            INITIAL          64K
                                            MINEXTENTS       1
                                            MAXEXTENTS       UNLIMITED
                                            PCTINCREASE      0
                                            BUFFER_POOL      DEFAULT
                                           )
                              ENABLE VALIDATE)');

      EXECUTE IMMEDIATE
         ('CREATE OR REPLACE PUBLIC SYNONYM giis_users_pw_hist FOR CPI.giis_users_pw_hist');

      DBMS_OUTPUT.PUT_LINE ('GIIS_USERS_PW_HIST created.');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('GIIS_USERS_PW_HIST already exists.');
   END IF;
END;
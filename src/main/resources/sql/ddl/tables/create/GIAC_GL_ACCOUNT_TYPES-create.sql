/* Created by   : Gzelle
 * Date Created : 10-26-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */
SET serveroutput on;

DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   FOR i IN (SELECT DISTINCT 1 rec
                        FROM all_tables
                       WHERE owner = 'CPI'
                         AND table_name = 'GIAC_GL_ACCOUNT_TYPES')
   LOOP
      v_exists := i.rec;
   END LOOP;

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line ('Table GIAC_GL_ACCOUNT_TYPES alreay exists.');
   ELSE
      EXECUTE IMMEDIATE ('CREATE TABLE CPI.GIAC_GL_ACCOUNT_TYPES
                                (
                                     ledger_cd      VARCHAR2 (10) NOT NULL,
                                     ledger_desc    VARCHAR2 (50) NOT NULL,
                                     active_tag     VARCHAR2 (1)  NOT NULL,
                                     remarks        VARCHAR2 (4000),
                                     user_id        VARCHAR2 (8)  NOT NULL,
                                     last_update    DATE          NOT NULL
                                )
                            TABLESPACE ACCTG_DATA
                            PCTUSED    0
                            PCTFREE    10
                            INITRANS   1
                            MAXTRANS   255
                            STORAGE    (
                                        INITIAL          128 k
                                        NEXT             128 k
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

	  EXECUTE IMMEDIATE ('COMMENT ON TABLE CPI.GIAC_GL_ACCOUNT_TYPES IS ''Maintenance table for General Ledger Control Account Types''');
                            
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_GL_ACCOUNT_TYPES.ledger_cd IS ''Unique reference code for General Ledger Control Account Type''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_GL_ACCOUNT_TYPES.ledger_desc IS ''Description of General Ledger Control Account Type''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_GL_ACCOUNT_TYPES.active_tag IS ''Status of GL Type; Valid values: Y, N''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_GL_ACCOUNT_TYPES.remarks IS ''Remarks or Additional Info''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_GL_ACCOUNT_TYPES.user_id IS ''User ID of last person who updated the record''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_GL_ACCOUNT_TYPES.last_update IS ''Date when the record was last updated''');

      EXECUTE IMMEDIATE ('CREATE UNIQUE INDEX CPI.GGLAT_PK ON CPI.GIAC_GL_ACCOUNT_TYPES 
                          (ledger_cd)
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

      EXECUTE IMMEDIATE ('CREATE OR REPLACE TRIGGER CPI.GIAC_GL_ACCOUNT_TYPES_TBIUX
                             BEFORE INSERT OR UPDATE
                             ON CPI.GIAC_GL_ACCOUNT_TYPES
                             FOR EACH ROW
                          DECLARE
                          BEGIN
                             :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
                             :NEW.last_update := SYSDATE;
                          END;');

      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIAC_GL_ACCOUNT_TYPES FOR CPI.GIAC_GL_ACCOUNT_TYPES');

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_GL_ACCOUNT_TYPES ADD (
                              CONSTRAINT GGLAT_PK
                             PRIMARY KEY
                             (ledger_cd)
                                USING INDEX 
                                TABLESPACE INDEXES
                                PCTFREE    10
                                INITRANS   2
                                MAXTRANS   255
                                STORAGE    (
                                            INITIAL          256K
                                            NEXT             128K
                                            MINEXTENTS       1
                                            MAXEXTENTS       UNLIMITED
                                            PCTINCREASE      0
                                           )
                          )');
      
      EXECUTE IMMEDIATE('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIAC_GL_ACCOUNT_TYPES TO PUBLIC'); 

      DBMS_OUTPUT.put_line ('Created GIAC_GL_ACCOUNT_TYPES.');
   END IF;
END;
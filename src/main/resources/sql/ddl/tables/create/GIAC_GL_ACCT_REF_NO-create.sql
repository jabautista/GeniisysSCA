/* Created by   : Gzelle
 * Date Created : 10-30-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */
SET serveroutput on;

DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   FOR i IN (SELECT DISTINCT 1 rec
                        FROM all_tables
                       WHERE owner = 'CPI'
                         AND table_name = 'GIAC_GL_ACCT_REF_NO')
   LOOP
      v_exists := i.rec;
   END LOOP;

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line ('Table GIAC_GL_ACCT_REF_NO alreay exists.');
   ELSE
      EXECUTE IMMEDIATE ('CREATE TABLE CPI.GIAC_GL_ACCT_REF_NO
                                (
                                     gacc_tran_id   NUMBER   (12) NOT NULL,
									 gl_acct_id		NUMBER   (6)  NOT NULL,
									 ledger_cd      VARCHAR2 (10) NOT NULL,
                                     subledger_cd   VARCHAR2 (10) NOT NULL,
                                     transaction_cd VARCHAR2 (10) NOT NULL,
                                     sl_cd   		NUMBER   (12) NOT NULL,
                                     acct_seq_no    NUMBER   (5)  NOT NULL,
									 acct_tran_type VARCHAR2 (1)  NOT NULL
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

	  EXECUTE IMMEDIATE ('COMMENT ON TABLE CPI.GIAC_GL_ACCT_REF_NO IS ''Transaction table for GL with ACCT_REF_NO.''');

      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIAC_GL_ACCT_REF_NO FOR CPI.GIAC_GL_ACCT_REF_NO');

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_GL_ACCT_REF_NO ADD (
                              CONSTRAINT GGLARN_UK
                             UNIQUE (gacc_tran_id, gl_acct_id, ledger_cd, subledger_cd, transaction_cd, sl_cd, acct_seq_no, acct_tran_type)
                                USING INDEX
                                TABLESPACE INDEXES
                                PCTFREE    10
                                INITRANS   2
                                MAXTRANS   255
                                STORAGE    (
                                            INITIAL          128 k
                                            NEXT             128 k
                                            MINEXTENTS       1
                                            MAXEXTENTS       UNLIMITED
                                            PCTINCREASE      0
                                           ))');
      
      EXECUTE IMMEDIATE('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIAC_GL_ACCT_REF_NO TO PUBLIC'); 

      DBMS_OUTPUT.put_line ('Created GIAC_GL_ACCT_REF_NO.');
   END IF;
END;
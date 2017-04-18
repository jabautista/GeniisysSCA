SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 08.03.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/
DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   SELECT CASE
             WHEN EXISTS (
                     SELECT NULL
                       FROM all_tables
                      WHERE owner = 'CPI'
                            AND table_name = 'GIRI_INCHARGES_TAX')
                THEN 'Y'
             ELSE 'N'
          END AS rec_exists
     INTO v_exists
     FROM DUAL;

   IF v_exists = 'Y'
   THEN
      DBMS_OUTPUT.put_line ('Table GIRI_INCHARGES_TAX alreay exists.');
   ELSE
      EXECUTE IMMEDIATE ('CREATE TABLE CPI.GIRI_INCHARGES_TAX
                         ( intreaty_id   NUMBER(4)   NOT NULL
                         , tax_type      VARCHAR2(1) NOT NULL
                         , tax_cd        NUMBER(5)   NOT NULL
                         , charge_cd     NUMBER(2)
                         , charge_amt    NUMBER(12,2)
                         , sl_type_cd    VARCHAR2(2)
                         , sl_cd         NUMBER(12)
                         , tax_pct       NUMBER(12,9)
                         , tax_amt       NUMBER(12,2)
                         , user_id       VARCHAR2(8) NOT NULL
                         , last_update   DATE        NOT NULL
                         , CONSTRAINT giri_incharges_tax_pk PRIMARY KEY (intreaty_id, tax_type, tax_cd, charge_cd) USING INDEX TABLESPACE INDEXES)
                         TABLESPACE RI_DATA');

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIRI_INCHARGES_TAX ADD (
                         CONSTRAINT GIIC_GIIT_FK 
                           FOREIGN KEY (INTREATY_ID, CHARGE_CD) 
                           REFERENCES CPI.GIRI_INTREATY_CHARGES (INTREATY_ID, CHARGE_CD))');

      EXECUTE IMMEDIATE (   'CREATE OR REPLACE TRIGGER CPI.GIIS_INCHG_TAX_TBIUX'
                         || CHR (10)
                         || '  BEFORE INSERT OR UPDATE ON CPI.GIRI_INCHARGES_TAX'
                         || CHR (10)
                         || '  FOR EACH ROW'
                         || CHR (10)
                         || 'DECLARE'
                         || CHR (10)
                         || 'BEGIN'
                         || CHR (10)
                         || '  :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);'
                         || CHR (10)
                         || '  :NEW.last_update := SYSDATE;'
                         || CHR (10)
                         || 'END;'
                        );

      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIRI_INCHARGES_TAX FOR CPI.GIRI_INCHARGES_TAX');

      EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIRI_INCHARGES_TAX TO PUBLIC');

      DBMS_OUTPUT.put_line ('Created table GIRI_INCHARGES_TAX.');
   END IF;
END;
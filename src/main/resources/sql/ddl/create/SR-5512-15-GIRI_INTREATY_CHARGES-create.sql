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
                       AND table_name = 'GIRI_INTREATY_CHARGES')
                THEN 'Y'
             ELSE 'N'
          END AS rec_exists
     INTO v_exists
     FROM DUAL;

   IF v_exists = 'Y'
   THEN
      DBMS_OUTPUT.put_line ('Table GIRI_INTREATY_CHARGES alreay exists.');
   ELSE
      EXECUTE IMMEDIATE ('CREATE TABLE CPI.GIRI_INTREATY_CHARGES
                         ( intreaty_id   NUMBER(4)   NOT NULL
                         , charge_cd     NUMBER(2)
                         , amount        NUMBER(12,2)
                         , w_tax         VARCHAR2(1)   
                         , user_id       VARCHAR2(8) NOT NULL
                         , last_update   DATE        NOT NULL
                         , CONSTRAINT giri_intreaty_charges_pk PRIMARY KEY (intreaty_id, charge_cd)  USING INDEX TABLESPACE INDEXES
                         , CONSTRAINT intreaty_charges_w_tax_chk CHECK (w_tax IN (''Y'' , ''N''))
                         )
                         TABLESPACE RI_DATA');

      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIRI_INTREATY_CHARGES FOR CPI.GIRI_INTREATY_CHARGES');

      EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIRI_INTREATY_CHARGES TO PUBLIC');

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIRI_INTREATY_CHARGES ADD (
                         CONSTRAINT GIIN_GIIC_FK 
                           FOREIGN KEY (INTREATY_ID) 
                           REFERENCES CPI.GIRI_INTREATY (INTREATY_ID))');

      EXECUTE IMMEDIATE (   'CREATE OR REPLACE TRIGGER CPI.GIRI_INTREATY_CHG_TBIUX'
                         || CHR (10)
                         || '  BEFORE INSERT OR UPDATE ON CPI.GIRI_INTREATY_CHARGES'
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

      DBMS_OUTPUT.put_line ('Created table GIRI_INTREATY_CHARGES.');
   END IF;
END;
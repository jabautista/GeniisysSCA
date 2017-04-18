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
                                 AND table_name = 'GIRI_INTREATY')
                THEN 'Y'
             ELSE 'N'
          END AS rec_exists
     INTO v_exists
     FROM DUAL;

   IF v_exists = 'Y'
   THEN
      DBMS_OUTPUT.put_line ('Table GIRI_INTREATY alreay exists.');
   ELSE
      EXECUTE IMMEDIATE ('CREATE TABLE CPI.GIRI_INTREATY
                         ( intreaty_id         NUMBER(4)    NOT NULL
                         , line_cd             VARCHAR2(2)  NOT NULL
                         , trty_yy             NUMBER(2)    NOT NULL
                         , intrty_seq_no       NUMBER(5)    NOT NULL
                         , ri_cd               NUMBER(5)    NOT NULL
                         , accept_date         DATE         NOT NULL
                         , approve_by          VARCHAR2(8)
                         , approve_date        DATE
                         , cancel_user         VARCHAR2(8)
                         , cancel_date         DATE
                         , acct_ent_date       DATE
                         , acct_neg_date       DATE
                         , booking_mth         VARCHAR2(10) NOT NULL
                         , booking_yy          NUMBER(4)    NOT NULL
                         , tran_type           VARCHAR2(3)  NOT NULL
                         , tran_no             NUMBER(2)    NOT NULL
                         , currency_cd         NUMBER(2)    NOT NULL
                         , currency_rt         NUMBER(12,9) NOT NULL
                         , ri_prem_amt         NUMBER(12,2)
                         , ri_comm_rt          NUMBER(12,9)
                         , ri_comm_amt         NUMBER(12,2)
                         , ri_vat_rt           NUMBER(12,9)
                         , ri_comm_vat         NUMBER(12,2)
                         , clm_loss_pd_amt     NUMBER(12,2)
                         , clm_loss_exp_amt    NUMBER(12,2)
                         , clm_recoverable_amt NUMBER(12,2)
                         , charge_amount       NUMBER(12,2)
                         , intrty_flag         NUMBER(1)    NOT NULL
                         , share_cd            NUMBER(3)    NOT NULL
                         , user_id             VARCHAR2(8)  NOT NULL
                         , last_update         DATE         NOT NULL
                         , CONSTRAINT giri_intreaty_pk PRIMARY KEY (intreaty_id) USING INDEX TABLESPACE INDEXES
                         )
                         TABLESPACE RI_DATA');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.intreaty_id IS ''Unique ID of Inward Treaty Record''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.line_cd IS ''Line code''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.trty_yy IS ''Treaty Year''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.intrty_seq_no IS ''Inward Treaty Record Sequence Number''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.ri_cd IS ''Reinsurer Code''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.accept_date IS ''Date accepted''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.approve_by IS ''User who approved the record''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.approve_date IS ''Date approved''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.cancel_user IS ''User who cancelled the record''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.cancel_date IS ''Date cancelled''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.acct_ent_date IS ''Accounting entry date''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.acct_neg_date IS ''Accounting negate date''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.booking_mth IS ''Booking Month''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.booking_yy IS ''Booking Year''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.tran_type IS ''Transaction Type''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.tran_no IS ''Transaction Number''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.currency_cd IS ''Currency Code''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.currency_rt IS ''Currency Rate''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.ri_prem_amt IS ''RI Premium Amount''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.ri_comm_rt IS ''RI Commission Rate''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.ri_comm_amt IS ''RI Commission Amount''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.ri_vat_rt IS ''RI VAT Rate''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.ri_comm_vat IS ''RI Commission VAT Amount''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.clm_loss_pd_amt IS ''Loss Paid Amount''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.clm_loss_exp_amt IS ''Loss Expense Amount''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.clm_recoverable_amt IS ''Recoverable Amount''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.charge_amount IS ''Charges Amount''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.intrty_flag IS ''Inward Treaty Record Status Flag''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.share_cd IS ''Share Code''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.user_id IS ''User ID who created or last updated the record''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIRI_INTREATY.last_update IS ''Date when the record was created or updated''');

      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIRI_INTREATY FOR CPI.GIRI_INTREATY');

      EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIRI_INTREATY TO PUBLIC');

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIRI_INTREATY ADD (
                         CONSTRAINT GILI_GIIN_FK 
                           FOREIGN KEY (LINE_CD) 
                           REFERENCES CPI.GIIS_LINE (LINE_CD),
                         CONSTRAINT GIRE_GIIN_FK 
                           FOREIGN KEY (RI_CD) 
                           REFERENCES CPI.GIIS_REINSURER (RI_CD),
                         CONSTRAINT GIDS_GIIN_FK 
                           FOREIGN KEY (LINE_CD, SHARE_CD) 
                           REFERENCES CPI.GIIS_DIST_SHARE (LINE_CD, SHARE_CD))');

      EXECUTE IMMEDIATE (   'CREATE OR REPLACE TRIGGER CPI.GIRI_INTREATY_TBIUX'
                         || CHR (10)
                         || '  BEFORE INSERT OR UPDATE ON CPI.GIRI_INTREATY'
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

      DBMS_OUTPUT.put_line ('Created table GIRI_INTREATY.');
   END IF;
END;
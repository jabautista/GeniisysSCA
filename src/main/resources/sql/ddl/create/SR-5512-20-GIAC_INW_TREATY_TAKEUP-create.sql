SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 10.13.2016
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
                                 AND table_name = 'GIAC_INW_TREATY_TAKEUP')
                THEN 'Y'
             ELSE 'N'
          END AS rec_exists
     INTO v_exists
     FROM DUAL;
     
   IF v_exists = 'Y'
   THEN
      DBMS_OUTPUT.put_line ('Table GIAC_INW_TREATY_TAKEUP alreay exists.');
   ELSE
      EXECUTE IMMEDIATE ('CREATE TABLE CPI.GIAC_INW_TREATY_TAKEUP
                         ( takeup_id       NUMBER(12)    NOT NULL
                         , takeup_year     NUMBER(4)     NOT NULL
                         , takeup_mm       NUMBER(2)     NOT NULL
                         , intreaty_id     NUMBER(4)     NOT NULL
                         , line_cd         VARCHAR2(2)   NOT NULL
                         , trty_yy         NUMBER(2)     NOT NULL
                         , intrty_seq_no   NUMBER(5)     NOT NULL
                         , share_cd        NUMBER(3)     NOT NULL
                         , ri_cd           NUMBER(5)     NOT NULL
                         , ri_prem_amt     NUMBER(12,2)  NOT NULL
                         , ri_comm_amt     NUMBER(12,2)  NOT NULL
                         , ri_comm_vat     NUMBER(12,2)  NOT NULL
                         , charge_amt      NUMBER(12,2)
                         , charge_vat      NUMBER(12,2)
                         , charge_wtax     NUMBER(12,2)
                         , currency_cd     NUMBER(2)     NOT NULL
                         , currency_rt     NUMBER(12,9)  NOT NULL
                         , fc_prem_amt     NUMBER(12,2)  NOT NULL
                         , fc_comm_amt     NUMBER(12,2)  NOT NULL
                         , fc_comm_vat     NUMBER(12,2)  NOT NULL
                         , fc_charge_amt   NUMBER(12,2)
                         , fc_charge_vat   NUMBER(12,2)
                         , fc_charge_wtax  NUMBER(12,2)
                         , CONSTRAINT giac_inw_treaty_takeup_pk PRIMARY KEY (takeup_id) USING INDEX TABLESPACE INDEXES
                         )
                         TABLESPACE ACCTG_DATA');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.takeup_id IS ''Unique identifier of take up record''');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.takeup_year IS ''Takeup year''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.takeup_mm IS ''Takeup month''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.intreaty_id IS ''Unique identifier of inward treaty record''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.line_cd IS ''Line code''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.trty_yy IS ''Treaty year''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.intrty_seq_no IS ''Inward Treaty record sequence number''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.share_cd IS ''Share code''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.ri_cd IS ''Reinsurer code''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.ri_prem_amt IS ''RI Premium Amount in local currency''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.ri_comm_amt IS ''RI Commission Amount in local currency''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.ri_comm_vat IS ''VAT on RI Commission in local currency''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.charge_amt IS ''Total amount of charges in local currency''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.charge_vat IS ''VAT on charges in local currency''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.charge_wtax IS ''Wtax on charges in local currency''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.currency_cd IS ''Currency Code''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.currency_rt IS ''Currency Rate''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.fc_prem_amt IS ''RI Premium Amount in foreign currency''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.fc_comm_amt IS ''RI Commission Amount in foreign currency''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.fc_comm_vat IS ''VAT on RI Commission in foreign currency''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.fc_charge_amt IS ''Total amount of charges in foreign currency''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.fc_charge_vat IS ''VAT on charges in foreign currency''');
      
      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_INW_TREATY_TAKEUP.fc_charge_wtax IS ''Wtax on charges in foreign currency''');

      EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIAC_INW_TREATY_TAKEUP TO PUBLIC');

      DBMS_OUTPUT.put_line ('Created table GIAC_INW_TREATY_TAKEUP.');
   END IF;
END;
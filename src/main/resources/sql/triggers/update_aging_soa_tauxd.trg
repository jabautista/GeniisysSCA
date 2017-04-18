DROP TRIGGER CPI.UPDATE_AGING_SOA_TAUXD;

CREATE OR REPLACE TRIGGER CPI.UPDATE_AGING_SOA_TAUXD
AFTER INSERT OR DELETE ON CPI.GIAC_DIRECT_PREM_COLLNS FOR EACH ROW
BEGIN
  /* created by  : BoYeT
  ** date        :  12/16/2002
  ** description : This trigger will update the record in giac_aging_soa_details.
  */
  IF INSERTING THEN
     UPDATE giac_aging_soa_details
        SET total_payments   = total_payments + :NEW.collection_amt,
      temp_payments    = temp_payments  +  :NEW.collection_amt,
   balance_amt_due  = balance_amt_due - :NEW.collection_amt,
   prem_balance_due = prem_balance_due - :NEW.premium_amt,
   tax_balance_due  = tax_balance_due - :NEW.tax_amt
      WHERE iss_cd      = :NEW.b140_iss_cd
        AND prem_seq_no = :NEW.b140_prem_seq_no
        AND inst_no     = :NEW.inst_no;
  ELSIF DELETING THEN
     UPDATE giac_aging_soa_details
        SET total_payments   = total_payments - :OLD.collection_amt,
      temp_payments    = temp_payments  -  :OLD.collection_amt,
   balance_amt_due  = balance_amt_due + :OLD.collection_amt,
   prem_balance_due = prem_balance_due + :OLD.premium_amt,
   tax_balance_due  = tax_balance_due + :OLD.tax_amt
      WHERE iss_cd      = :OLD.b140_iss_cd
        AND prem_seq_no = :OLD.b140_prem_seq_no
        AND inst_no     = :OLD.inst_no;
  END IF;
END;
/



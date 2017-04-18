DROP TRIGGER CPI.BANK_REF_NO_TBXIX;

CREATE OR REPLACE TRIGGER CPI.BANK_REF_NO_TBXIX
  BEFORE INSERT OR UPDATE
  ON CPI.GIPI_REF_NO_HIST   REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
DECLARE
BEGIN
  :NEW.bank_ref_no :=
       LPAD (:NEW.acct_iss_cd, 2, 0)
    || '-'
    || LPAD (:NEW.branch_cd, 4, 0)
    || '-'
    || LPAD (:NEW.ref_no, 7, 0)
    || '-'
    || LPAD (:NEW.mod_no, 2, 0);
END;
/



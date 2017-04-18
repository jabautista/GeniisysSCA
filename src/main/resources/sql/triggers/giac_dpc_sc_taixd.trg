DROP TRIGGER CPI.GIAC_DPC_SC_TAIXD;

CREATE OR REPLACE TRIGGER CPI.GIAC_DPC_SC_TAIXD
AFTER INSERT OR DELETE  ON CPI.GIAC_DIRECT_PREM_COLLNS FOR EACH ROW
DECLARE
  v_policy_id      GIPI_POLBASIC.policy_id%TYPE;
  v_line_cd        GIPI_POLBASIC.line_cd%TYPE;
  v_subline_cd     GIPI_POLBASIC.subline_cd%TYPE;
  v_sc_tag         GIIS_LINE.sc_tag%TYPE;
  v_pol_prem_amt   GIPI_POLBASIC.prem_amt%TYPE;
  v_tran_date      GIAC_ACCTRANS.tran_date%TYPE;
  v_currency_rt    GIPI_INVOICE.currency_rt%TYPE;
  v_other_charges  GIPI_INVOICE.other_charges%TYPE;
BEGIN
    SELECT a.policy_id, a.line_cd, a.subline_cd, a.prem_amt,
           NVL(b.currency_rt,1),NVL(other_charges,0)
      INTO v_policy_id, v_line_cd, v_subline_cd, v_pol_prem_amt ,v_currency_rt,
           v_other_charges
      FROM GIPI_POLBASIC     a,
           GIPI_INVOICE b
      WHERE a.policy_id   =   b.policy_id
        AND b.iss_Cd      =   NVL(:NEW.b140_iss_Cd, :OLD.b140_iss_cd)
        AND b.prem_seq_no =   NVL(:NEW.b140_prem_seq_no, :OLD.b140_prem_seq_no)
        AND (TRUNC(a.acct_ent_date) > TO_DATE('31-MAY-99')
             OR a.acct_ent_date IS NULL)     ;

    SELECT sc_tag
      INTO v_sc_tag
      FROM GIIS_LINE
      WHERE line_cd = v_line_cd;

    IF v_sc_tag IS NOT NULL THEN
      IF INSERTING THEN
        v_other_charges  := v_other_charges * v_currency_rt * (:NEW.premium_amt / v_pol_prem_amt);
        INSERT INTO GIAC_SC_COLLNS
           (gacc_tran_id,         policy_id,      line_cd,              subline_cd,
            pol_prem_amt,         iss_cd,         prem_seq_no,          inst_no,
            premium_amt,          tax_amt,        tran_date,            acct_ent_date,
            reverse_tag,          currency_rt,    other_charges)
        VALUES
           (:NEW.gacc_tran_id,    v_policy_id,      v_line_cd,             v_subline_cd,
            v_pol_prem_amt,       :NEW.b140_iss_cd, :NEW.b140_prem_seq_no, :NEW.inst_no,
            :NEW.premium_amt,     :NEW.tax_amt,     SYSDATE,               NULL,
            NULL,                 v_currency_rt,    v_other_charges);
      ELSIF DELETING THEN
        IF :OLD.acct_ent_date IS NULL THEN
          DELETE
          FROM GIAC_SC_COLLNS
          WHERE gacc_tran_id = :OLD.gacc_tran_id
            AND iss_cd       = :OLD.b140_iss_cd
            AND prem_seq_no  = :OLD.b140_prem_seq_no
            AND inst_no      = :OLD.inst_no;
--            and trunc(tran_date)    =  v_tran_date;
       ELSE
         RAISE_APPLICATION_ERROR(-20099,'Cannot delete. This record has already been taken up.');

       END IF;
    END IF;
  END IF;
END;
/

ALTER TRIGGER CPI.GIAC_DPC_SC_TAIXD DISABLE;
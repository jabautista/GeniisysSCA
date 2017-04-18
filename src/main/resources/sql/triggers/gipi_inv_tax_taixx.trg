DROP TRIGGER CPI.GIPI_INV_TAX_TAIXX;

CREATE OR REPLACE TRIGGER CPI.GIPI_INV_TAX_TAIXX
BEFORE INSERT
ON CPI.GIPI_INV_TAX FOR EACH ROW
DECLARE
 v_taxable      gipi_inv_tax.taxable_prem_amt%type;
 v_taxexempt    gipi_inv_tax.taxexempt_prem_amt%type;
 v_zerorated    gipi_inv_tax.zerorated_prem_amt%type;
 v_eff_date     gipi_polbasic.eff_date%type;
 v_prem_amt     gipi_invoice.prem_amt%type;
 v_line_cd      gipi_polbasic.line_cd%type;
 v_policy_id    gipi_polbasic.policy_id%type;
BEGIN

    FOR i IN (SELECT a.eff_date,b.prem_amt,a.line_cd,a.policy_id
                FROM GIPI_POLBASIC a , GIPI_INVOICE b
               WHERE 1=1
                 AND a.policy_id    = b.policy_id
                 AND b.iss_cd       = :new.iss_cd
                 AND b.prem_Seq_no  = :new.prem_seq_no)
    LOOP
        v_eff_date  := i.eff_date;
        v_prem_amt  := i.prem_amt;
        v_line_cd   := i.line_cd;
        v_policy_id := i.policy_id;
    END LOOP;

    FOR a IN (SELECT z.peril_sw,z.tax_id
                FROM giis_tax_charges z
               WHERE 1=1
                 AND z.eff_start_date <= v_eff_date
                 AND z.eff_end_date   >= v_eff_date
                 AND z.line_cd      = v_line_cd
                 AND z.iss_cd       = :new.iss_cd
                 AND z.tax_cd       = :new.tax_cd)
    LOOP
         v_taxable   :=0;
         v_taxexempt :=0;
         v_zerorated :=0;
        IF :new.tax_amt = 0 THEN
          v_zerorated := v_prem_amt;
        ELSE
          IF nvl(a.peril_sw,'N') = 'Y' THEN
            FOR c IN (SELECT sum(j.prem_amt) prem_amt
                        FROM giis_tax_peril v, gipi_itmperil j
                       WHERE 1=1
                         AND v.peril_cd     = j.peril_cd
                         AND v.line_cd      = v_line_cd
                         AND v.iss_cd       = :new.iss_cd
                         AND v.tax_cd       = :new.tax_cd
                         AND v.tax_id       = a.tax_id
                         AND j.policy_id    = v_policy_id)
            LOOP
                v_taxable := c.prem_amt;
                v_taxexempt := v_prem_amt - v_taxable;
            END LOOP;--c
          ELSE
            v_taxable := v_prem_amt;
            v_taxexempt := v_prem_amt - v_taxable;
          END IF;
        END IF;

           :new.taxable_prem_amt := v_taxable;
           :new.taxexempt_prem_amt := v_taxexempt;
           :new.zerorated_prem_amt := v_zerorated;

    END LOOP;

END;
/



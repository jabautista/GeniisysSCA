DROP TRIGGER CPI.AGING_SOA_DETAILS_TAXIX;

CREATE OR REPLACE TRIGGER CPI.AGING_SOA_DETAILS_TAXIX
AFTER INSERT
ON CPI.GIAC_AGING_SOA_DETAILS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
      DECLARE
        v_gibr_gfun_fund_cd  giac_aging_parameters.gibr_gfun_fund_cd%TYPE;
        v_gibr_branch_cd   giac_aging_parameters.gibr_branch_cd%TYPE;
        v_a020_assd_no    giac_aging_soa_details.a020_assd_no%TYPE;
        v_gagp_aging_id    giac_aging_soa_details.gagp_aging_id%TYPE;
      BEGIN
         SELECT gibr_gfun_fund_cd,gibr_branch_cd
           INTO v_gibr_gfun_fund_cd,v_gibr_branch_cd
           FROM giac_aging_parameters
          WHERE aging_id = :NEW.gagp_aging_id;
    -- 1
        BEGIN
          SELECT gagp_aging_id
            INTO v_gagp_aging_id
            FROM giac_aging_totals
           WHERE gagp_aging_id = :NEW.gagp_aging_id;
          UPDATE giac_aging_totals
             SET balance_amt_due  = balance_amt_due  + :NEW.balance_amt_due,
                 prem_balance_due = prem_balance_due + :NEW.prem_balance_due,
                 tax_balance_due  = tax_balance_due  + :NEW.tax_balance_due
           WHERE gagp_aging_id    = :NEW.gagp_aging_id;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             INSERT INTO giac_aging_totals
                    (gibr_gfun_fund_cd,gibr_branch_cd,
                     gagp_aging_id,balance_amt_due,
                     prem_balance_due,tax_balance_due)
             VALUES (v_gibr_gfun_fund_cd,v_gibr_branch_cd,
                     :NEW.gagp_aging_id,:NEW.balance_amt_due,
                     :NEW.prem_balance_due,:NEW.tax_balance_due);
        END;
    -- 2
        BEGIN
          SELECT a020_assd_no
            INTO v_a020_assd_no
            FROM giac_aging_summaries
           WHERE gagp_aging_id = :NEW.gagp_aging_id AND
                 a020_assd_no  = :NEW.a020_assd_no;
          UPDATE giac_aging_summaries
             SET balance_amt_due  = balance_amt_due  + :NEW.balance_amt_due,
                 prem_balance_due = prem_balance_due + :NEW.prem_balance_due,
                 tax_balance_due  = tax_balance_due  + :NEW.tax_balance_due
           WHERE gagp_aging_id    = :NEW.gagp_aging_id AND
                 a020_assd_no     = :NEW.a020_assd_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            INSERT INTO giac_aging_summaries
                  (gagp_aging_id,a020_assd_no,balance_amt_due,
                   prem_balance_due,tax_balance_due)
            VALUES(:NEW.gagp_aging_id,:NEW.a020_assd_no,:NEW.balance_amt_due,
                   :NEW.prem_balance_due,:NEW.tax_balance_due);
        END;
    -- 3
        BEGIN
          SELECT a020_assd_no
            INTO v_a020_assd_no
            FROM giac_soa_summaries
           WHERE a020_assd_no = :NEW.a020_assd_no;
          UPDATE giac_soa_summaries
             SET balance_amt_due  = balance_amt_due  + :NEW.balance_amt_due,
                 prem_balance_due = prem_balance_due + :NEW.prem_balance_due,
                 tax_balance_due  = tax_balance_due + :NEW.tax_balance_due
           WHERE a020_assd_no     = :NEW.a020_assd_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             INSERT INTO giac_soa_summaries
                   (a020_assd_no,balance_amt_due,
                    prem_balance_due,tax_balance_due)
             VALUES (:NEW.a020_assd_no,:NEW.balance_amt_due,
                     :NEW.prem_balance_due,:NEW.tax_balance_due);
        END;
    -- 4
        BEGIN
          SELECT a020_assd_no
            INTO v_a020_assd_no
            FROM giac_aging_assd_line
           WHERE a020_assd_no    = :NEW.a020_assd_no AND
                 a150_line_cd    = :NEW.a150_line_cd AND
                 gagp_aging_id   = :NEW.gagp_aging_id;
          UPDATE giac_aging_assd_line
             SET balance_amt_due  = balance_amt_due  + :NEW.balance_amt_due,
                 prem_balance_due = prem_balance_due + :NEW.prem_balance_due,
                 tax_balance_due  = tax_balance_due  + :NEW.tax_balance_due
           WHERE a020_assd_no     = :NEW.a020_assd_no AND
                 a150_line_cd     = :NEW.a150_line_cd AND
                 gagp_aging_id    = :NEW.gagp_aging_id;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             INSERT INTO giac_aging_assd_line
                     (gagp_aging_id,a020_assd_no,
                      a150_line_cd,balance_amt_due,
                      prem_balance_due,tax_balance_due)
               VALUES(:NEW.gagp_aging_id,:NEW.a020_assd_no,
                      :NEW.a150_line_cd,:NEW.balance_amt_due,
                      :NEW.prem_balance_due,:NEW.tax_balance_due);
        END;
    -- 5
        BEGIN
          SELECT gagp_aging_id
            INTO v_gagp_aging_id
            FROM giac_aging_line_totals
           WHERE a150_line_cd    = :NEW.a150_line_cd AND
                 gagp_aging_id   = :NEW.gagp_aging_id;
          UPDATE giac_aging_line_totals
             SET balance_amt_due  = balance_amt_due  + :NEW.balance_amt_due,
                 prem_balance_due = prem_balance_due + :NEW.prem_balance_due,
                 tax_balance_due  = tax_balance_due  + :NEW.tax_balance_due
           WHERE a150_line_cd     = :NEW.a150_line_cd AND
                 gagp_aging_id    = :NEW.gagp_aging_id;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             INSERT INTO giac_aging_line_totals
                    (gagp_aging_id,
                     a150_line_cd,balance_amt_due,
                     prem_balance_due,tax_balance_due)
              VALUES(:NEW.gagp_aging_id,
                     :NEW.a150_line_cd,:NEW.balance_amt_due,
                     :NEW.prem_balance_due,:NEW.tax_balance_due);
        END;
      END;
  END;
END;
/



DROP TRIGGER CPI.AGING_SOA_DETAILS_TADIX;

CREATE OR REPLACE TRIGGER CPI.AGING_SOA_DETAILS_TADIX
BEFORE INSERT OR DELETE OR UPDATE OF balance_amt_due,
prem_balance_due, tax_balance_due
ON CPI.GIAC_AGING_SOA_DETAILS FOR EACH ROW
DECLARE
--
-- TABLES AFFECTED 	     TRANSACTION TYPE	COLUMNS
--
-- giac_aging_totals 	     update / insert /	balance_amt_due
--			     delete		prem_balance_due
--						tax_balance_due
--
-- giac_aging_summaries      update / insert /	balance_amt_due
--			     delete		prem_balance_due
--						tax_balance_due
--
-- giac_soa_summaries	     update / insert /	balance_amt_due
--			     delete		prem_balance_due
--						tax_balance_due
--
-- giac_aging_assd_line      update / insert /	balance_amt_due
--	 		     delete		prem_balance_due
--						tax_balance_due
--
-- giac_aging_line_totals    update / insert /	balance_amt_due
--			     delete		prem_balance_due
--						tax_balance_due
--
  v_exists1		VARCHAR2(1) := 'N';
  v_exists2		VARCHAR2(1) := 'N';
  v_exists3		VARCHAR2(1) := 'N';
  v_exists4		VARCHAR2(1) := 'N';
  v_exists5		VARCHAR2(1) := 'N';
  v_gibr_gfun_fund_cd  	GIAC_AGING_PARAMETERS.gibr_gfun_fund_cd%TYPE;
  v_gibr_branch_cd     	GIAC_AGING_PARAMETERS.gibr_branch_cd%TYPE;

  v_balance_amt_due1    GIAC_AGING_TOTALS.balance_amt_due%TYPE;
  v_prem_balance_due1   GIAC_AGING_TOTALS.prem_balance_due%TYPE;
  v_tax_balance_due1    GIAC_AGING_TOTALS.tax_balance_due%TYPE;

  v_balance_amt_due2    GIAC_AGING_SUMMARIES.balance_amt_due%TYPE;
  v_prem_balance_due2   GIAC_AGING_SUMMARIES.prem_balance_due%TYPE;
  v_tax_balance_due2    GIAC_AGING_SUMMARIES.tax_balance_due%TYPE;

  v_balance_amt_due3    GIAC_SOA_SUMMARIES.balance_amt_due%TYPE;
  v_prem_balance_due3   GIAC_SOA_SUMMARIES.prem_balance_due%TYPE;
  v_tax_balance_due3    GIAC_SOA_SUMMARIES.tax_balance_due%TYPE;

  v_balance_amt_due4    GIAC_AGING_ASSD_LINE.balance_amt_due%TYPE;
  v_prem_balance_due4   GIAC_AGING_ASSD_LINE.prem_balance_due%TYPE;
  v_tax_balance_due4    GIAC_AGING_ASSD_LINE.tax_balance_due%TYPE;

  v_balance_amt_due5    GIAC_AGING_LINE_TOTALS.balance_amt_due%TYPE;
  v_prem_balance_due5   GIAC_AGING_LINE_TOTALS.prem_balance_due%TYPE;
  v_tax_balance_due5    GIAC_AGING_LINE_TOTALS.tax_balance_due%TYPE;
BEGIN
  IF INSERTING THEN
    SELECT gibr_gfun_fund_cd,
	   gibr_branch_cd
      INTO v_gibr_gfun_fund_cd,
	   v_gibr_branch_cd
      FROM GIAC_AGING_PARAMETERS
     WHERE aging_id = :NEW.gagp_aging_id;

-- 1
    FOR ag_tot IN (
      SELECT 'a'
        FROM GIAC_AGING_TOTALS
       WHERE gagp_aging_id = :NEW.gagp_aging_id)
    LOOP
      v_exists1 := 'Y';
      UPDATE GIAC_AGING_TOTALS
         SET balance_amt_due  = balance_amt_due  + :NEW.balance_amt_due,
             prem_balance_due = prem_balance_due + :NEW.prem_balance_due,
             tax_balance_due  = tax_balance_due  + :NEW.tax_balance_due
       WHERE gagp_aging_id    = :NEW.gagp_aging_id;
    END LOOP;
    IF v_exists1 = 'N' THEN
      INSERT INTO GIAC_AGING_TOTALS(
           gibr_gfun_fund_cd,     gibr_branch_cd,
           gagp_aging_id,         balance_amt_due,
           prem_balance_due,      tax_balance_due)
      VALUES (
           v_gibr_gfun_fund_cd,   v_gibr_branch_cd,
           :NEW.gagp_aging_id,    :NEW.balance_amt_due,
           :NEW.prem_balance_due, :NEW.tax_balance_due);
    ELSE
      v_exists1 := 'N';
    END IF;
-- 2
    FOR ag_sum IN (
      SELECT 'a'
        FROM GIAC_AGING_SUMMARIES
       WHERE gagp_aging_id = :NEW.gagp_aging_id
         AND a020_assd_no  = :NEW.a020_assd_no)
    LOOP
      v_exists2 := 'Y';
      UPDATE GIAC_AGING_SUMMARIES
        SET balance_amt_due  = balance_amt_due  + :NEW.balance_amt_due,
            prem_balance_due = prem_balance_due + :NEW.prem_balance_due,
            tax_balance_due  = tax_balance_due  + :NEW.tax_balance_due
      WHERE gagp_aging_id    = :NEW.gagp_aging_id
        AND a020_assd_no     = :NEW.a020_assd_no;
    END LOOP;
    IF v_exists2 = 'N' THEN
      INSERT INTO GIAC_AGING_SUMMARIES (
           gagp_aging_id,         a020_assd_no,       balance_amt_due,
           prem_balance_due,      tax_balance_due)
      VALUES (
           :NEW.gagp_aging_id,    :NEW.a020_assd_no, :NEW.balance_amt_due,
           :NEW.prem_balance_due, :NEW.tax_balance_due);
    ELSE
      v_exists2 := 'N';
    END IF;
-- 3
    FOR soa_sum IN (
      SELECT 'a'
        FROM GIAC_SOA_SUMMARIES
       WHERE a020_assd_no = :NEW.a020_assd_no)
    LOOP
      v_exists3 := 'Y';
      UPDATE GIAC_SOA_SUMMARIES
         SET balance_amt_due  = balance_amt_due  + :NEW.balance_amt_due,
             prem_balance_due = prem_balance_due + :NEW.prem_balance_due,
             tax_balance_due  = tax_balance_due + :NEW.tax_balance_due
       WHERE a020_assd_no     = :NEW.a020_assd_no;
    END LOOP;
    IF v_exists3 = 'N' THEN
      INSERT INTO GIAC_SOA_SUMMARIES (
           a020_assd_no,           balance_amt_due,
           prem_balance_due,       tax_balance_due)
      VALUES (
           :NEW.a020_assd_no,      :NEW.balance_amt_due,
           :NEW.prem_balance_due,  :NEW.tax_balance_due);
    ELSE
      v_exists3 := 'N';
    END IF;
-- 4
    FOR ag_assd_line IN (
      SELECT a020_assd_no
        FROM GIAC_AGING_ASSD_LINE
       WHERE a020_assd_no    = :NEW.a020_assd_no AND
             a150_line_cd    = :NEW.a150_line_cd AND
             gagp_aging_id   = :NEW.gagp_aging_id)
    LOOP
      v_exists4 := 'Y';
      UPDATE GIAC_AGING_ASSD_LINE
         SET balance_amt_due  = balance_amt_due  + :NEW.balance_amt_due,
             prem_balance_due = prem_balance_due + :NEW.prem_balance_due,
             tax_balance_due  = tax_balance_due  + :NEW.tax_balance_due
       WHERE a020_assd_no     = :NEW.a020_assd_no AND
             a150_line_cd     = :NEW.a150_line_cd AND
             gagp_aging_id    = :NEW.gagp_aging_id;
    END LOOP;
    IF v_exists4 = 'N' THEN
      INSERT INTO GIAC_AGING_ASSD_LINE (
           gagp_aging_id,         a020_assd_no,
           a150_line_cd,          balance_amt_due,
           prem_balance_due,      tax_balance_due)
      VALUES(
           :NEW.gagp_aging_id,    :NEW.a020_assd_no,
           :NEW.a150_line_cd,     :NEW.balance_amt_due,
           :NEW.prem_balance_due, :NEW.tax_balance_due);
    ELSE
      v_exists4 := 'N';
    END IF;
-- 5
    FOR ag_line_tot IN (
      SELECT gagp_aging_id
        FROM GIAC_AGING_LINE_TOTALS
       WHERE a150_line_cd    = :NEW.a150_line_cd AND
             gagp_aging_id   = :NEW.gagp_aging_id)
    LOOP
      v_exists5 := 'Y';
      UPDATE GIAC_AGING_LINE_TOTALS
         SET balance_amt_due  = balance_amt_due  + :NEW.balance_amt_due,
             prem_balance_due = prem_balance_due + :NEW.prem_balance_due,
             tax_balance_due  = tax_balance_due  + :NEW.tax_balance_due
       WHERE a150_line_cd     = :NEW.a150_line_cd AND
             gagp_aging_id    = :NEW.gagp_aging_id;
    END LOOP;
    IF v_exists5 = 'N' THEN
      INSERT INTO GIAC_AGING_LINE_TOTALS (
           gagp_aging_id,        a150_line_cd,
	   balance_amt_due,      prem_balance_due,
	   tax_balance_due)
      VALUES (
           :NEW.gagp_aging_id,   :NEW.a150_line_cd,
	   :NEW.balance_amt_due, :NEW.prem_balance_due,
	   :NEW.tax_balance_due);
    ELSE
      v_exists5 := 'N';
    END IF;
  ELSIF DELETING THEN
-- 1
    UPDATE GIAC_AGING_TOTALS
       SET balance_amt_due  = balance_amt_due  - :OLD.balance_amt_due,
           prem_balance_due = prem_balance_due - :OLD.prem_balance_due,
           tax_balance_due  = tax_balance_due  - :OLD.tax_balance_due
     WHERE gagp_aging_id  = :OLD.gagp_aging_id;

    FOR a IN (
      SELECT balance_amt_due, prem_balance_due, tax_balance_due
        FROM GIAC_AGING_TOTALS
       WHERE gagp_aging_id  = :OLD.gagp_aging_id)
    LOOP
      v_balance_amt_due1  := a.balance_amt_due;
      v_prem_balance_due1 := a.prem_balance_due;
      v_tax_balance_due1  := a.tax_balance_due;
    END LOOP;

    IF NVL(v_balance_amt_due1,0) = 0 AND
       NVL(v_prem_balance_due1,0) = 0 AND
       NVL(v_tax_balance_due1,0) = 0 THEN
      DELETE GIAC_AGING_TOTALS
       WHERE gagp_aging_id  = :OLD.gagp_aging_id;
    END IF;
-- 2
    UPDATE GIAC_AGING_SUMMARIES
       SET balance_amt_due  = balance_amt_due  - :OLD.balance_amt_due,
           prem_balance_due = prem_balance_due - :OLD.prem_balance_due,
           tax_balance_due  = tax_balance_due  - :OLD.tax_balance_due
     WHERE gagp_aging_id  = :OLD.gagp_aging_id
       AND a020_assd_no   = :OLD.a020_assd_no;

    FOR b IN (
      SELECT balance_amt_due, prem_balance_due, tax_balance_due
        FROM GIAC_AGING_SUMMARIES
       WHERE gagp_aging_id  = :OLD.gagp_aging_id
         AND a020_assd_no   = :OLD.a020_assd_no)
    LOOP
      v_balance_amt_due2  := b.balance_amt_due;
      v_prem_balance_due2 := b.prem_balance_due;
      v_tax_balance_due2  := b.tax_balance_due;
    END LOOP;

    IF NVL(v_balance_amt_due2,0) = 0 AND
       NVL(v_prem_balance_due2,0) = 0 AND
       NVL(v_tax_balance_due2,0) = 0 THEN
      DELETE GIAC_AGING_SUMMARIES
       WHERE gagp_aging_id  = :OLD.gagp_aging_id
         AND a020_assd_no   = :OLD.a020_assd_no;
    END IF;
-- 3
    UPDATE GIAC_SOA_SUMMARIES
       SET balance_amt_due  = balance_amt_due  - :OLD.balance_amt_due,
           prem_balance_due = prem_balance_due - :OLD.prem_balance_due,
           tax_balance_due  = tax_balance_due  - :OLD.tax_balance_due
     WHERE a020_assd_no   = :OLD.a020_assd_no;

    FOR c IN (
      SELECT balance_amt_due, prem_balance_due, tax_balance_due
        FROM GIAC_SOA_SUMMARIES
       WHERE a020_assd_no   = :OLD.a020_assd_no)
    LOOP
      v_balance_amt_due3  := c.balance_amt_due;
      v_prem_balance_due3 := c.prem_balance_due;
      v_tax_balance_due3  := c.tax_balance_due;
    END LOOP;

    IF NVL(v_balance_amt_due3,0) = 0 AND
       NVL(v_prem_balance_due3,0) = 0 AND
       NVL(v_tax_balance_due3,0) = 0 THEN
      DELETE GIAC_SOA_SUMMARIES
       WHERE a020_assd_no   = :OLD.a020_assd_no;
    END IF;
-- 4
    UPDATE GIAC_AGING_ASSD_LINE
       SET balance_amt_due  = balance_amt_due  - :OLD.balance_amt_due,
           prem_balance_due = prem_balance_due - :OLD.prem_balance_due,
           tax_balance_due  = tax_balance_due  - :OLD.tax_balance_due
     WHERE gagp_aging_id  = :OLD.gagp_aging_id
       AND a150_line_cd   = :OLD.a150_line_cd
       AND a020_assd_no   = :OLD.a020_assd_no;

    FOR d IN (
      SELECT balance_amt_due, prem_balance_due, tax_balance_due
        FROM GIAC_AGING_ASSD_LINE
       WHERE gagp_aging_id  = :OLD.gagp_aging_id
         AND a150_line_cd   = :OLD.a150_line_cd
         AND a020_assd_no   = :OLD.a020_assd_no)
    LOOP
      v_balance_amt_due4  := d.balance_amt_due;
      v_prem_balance_due4 := d.prem_balance_due;
      v_tax_balance_due4  := d.tax_balance_due;
    END LOOP;

    IF NVL(v_balance_amt_due4,0) = 0 AND
       NVL(v_prem_balance_due4,0) = 0 AND
       NVL(v_tax_balance_due4,0) = 0 THEN
      DELETE GIAC_AGING_ASSD_LINE
       WHERE gagp_aging_id  = :OLD.gagp_aging_id
         AND a150_line_cd   = :OLD.a150_line_cd
         AND a020_assd_no   = :OLD.a020_assd_no;
    END IF;
-- 5
    UPDATE GIAC_AGING_LINE_TOTALS
       SET balance_amt_due  = balance_amt_due  - :OLD.balance_amt_due,
           prem_balance_due = prem_balance_due - :OLD.prem_balance_due,
           tax_balance_due  = tax_balance_due  - :OLD.tax_balance_due
     WHERE gagp_aging_id  = :OLD.gagp_aging_id
       AND a150_line_cd   = :OLD.a150_line_cd;

    FOR e IN (
      SELECT balance_amt_due, prem_balance_due, tax_balance_due
        FROM GIAC_AGING_LINE_TOTALS
       WHERE gagp_aging_id  = :OLD.gagp_aging_id
         AND a150_line_cd   = :OLD.a150_line_cd)
    LOOP
      v_balance_amt_due5  := e.balance_amt_due;
      v_prem_balance_due5 := e.prem_balance_due;
      v_tax_balance_due5  := e.tax_balance_due;
    END LOOP;

    IF NVL(v_balance_amt_due5,0) = 0 AND
       NVL(v_prem_balance_due5,0) = 0 AND
       NVL(v_tax_balance_due5,0) = 0 THEN
      DELETE GIAC_AGING_LINE_TOTALS
       WHERE gagp_aging_id  = :OLD.gagp_aging_id
         AND a150_line_cd   = :OLD.a150_line_cd;
    END IF;
  ELSIF UPDATING THEN
-- 1
    UPDATE GIAC_AGING_TOTALS
       SET balance_amt_due  = balance_amt_due  - :OLD.balance_amt_due + NVL(:NEW.balance_amt_due,0),
           prem_balance_due = prem_balance_due - :OLD.prem_balance_due + NVL(:NEW.prem_balance_due,0),
           tax_balance_due  = tax_balance_due  - :OLD.tax_balance_due + NVL(:OLD.tax_balance_due,0)
     WHERE gagp_aging_id  = :NEW.gagp_aging_id;
-- 2
    UPDATE GIAC_AGING_SUMMARIES
       SET balance_amt_due  = balance_amt_due  - :OLD.balance_amt_due + NVL(:NEW.balance_amt_due,0),
           prem_balance_due = prem_balance_due - :OLD.prem_balance_due + NVL(:NEW.prem_balance_due,0),
           tax_balance_due  = tax_balance_due  - :OLD.tax_balance_due + NVL(:OLD.tax_balance_due,0)
     WHERE gagp_aging_id  = :NEW.gagp_aging_id
       AND a020_assd_no   = :NEW.a020_assd_no;
-- 3
    UPDATE GIAC_SOA_SUMMARIES
       SET balance_amt_due  = balance_amt_due  - :OLD.balance_amt_due + NVL(:NEW.balance_amt_due,0),
           prem_balance_due = prem_balance_due - :OLD.prem_balance_due + NVL(:NEW.prem_balance_due,0),
           tax_balance_due  = tax_balance_due  - :OLD.tax_balance_due + NVL(:OLD.tax_balance_due,0)
     WHERE a020_assd_no   = :NEW.a020_assd_no;
-- 4
    UPDATE GIAC_AGING_ASSD_LINE
       SET balance_amt_due  = balance_amt_due  - :OLD.balance_amt_due + NVL(:NEW.balance_amt_due,0),
           prem_balance_due = prem_balance_due - :OLD.prem_balance_due + NVL(:NEW.prem_balance_due,0),
           tax_balance_due  = tax_balance_due  - :OLD.tax_balance_due + NVL(:OLD.tax_balance_due,0)
     WHERE gagp_aging_id  = :NEW.gagp_aging_id
       AND a150_line_cd   = :NEW.a150_line_cd
       AND a020_assd_no   = :NEW.a020_assd_no;
-- 5
    UPDATE GIAC_AGING_LINE_TOTALS
       SET balance_amt_due  = balance_amt_due  - :OLD.balance_amt_due + NVL(:NEW.balance_amt_due,0),
           prem_balance_due = prem_balance_due - :OLD.prem_balance_due + NVL(:NEW.prem_balance_due,0),
           tax_balance_due  = tax_balance_due  - :OLD.tax_balance_due + NVL(:OLD.tax_balance_due,0)
     WHERE gagp_aging_id  = :NEW.gagp_aging_id
       AND a150_line_cd   = :NEW.a150_line_cd;
  END IF;
END;
/

ALTER TRIGGER CPI.AGING_SOA_DETAILS_TADIX DISABLE;



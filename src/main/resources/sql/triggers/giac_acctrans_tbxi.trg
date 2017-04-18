CREATE OR REPLACE TRIGGER GIAC_ACCTRANS_TBXI
   BEFORE INSERT
   ON CPI.GIAC_ACCTRANS
   FOR EACH ROW
   WHEN (NEW.tran_class != 'COL' AND NEW.tran_class != 'DV')    -- OR NEW.tran_class = 'DV')    SR-5550 JET JUL-08-2016
DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   :new.jv_pref := 'JV';

   SELECT NVL (MAX (jv_seq_no), 0) + 1
     INTO :new.jv_seq_no
     FROM giac_acctrans
    WHERE     tran_class NOT IN ('COL', 'DV')
          AND gfun_fund_cd = :new.gfun_fund_cd
          AND gibr_branch_cd = :new.gibr_branch_cd
          AND tran_year = :new.tran_year
          AND tran_month = :new.tran_month;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      :new.jv_seq_no := 1;
END;
/
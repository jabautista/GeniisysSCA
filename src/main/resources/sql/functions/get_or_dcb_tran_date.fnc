DROP FUNCTION CPI.GET_OR_DCB_TRAN_DATE;

CREATE OR REPLACE FUNCTION CPI.get_or_dcb_tran_date (
   p_or_date           VARCHAR2,
   p_fund_cd           giac_acctrans.gfun_fund_cd%TYPE,
   p_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
   p_dcb_no            giac_colln_batch.dcb_no%TYPE
)
   RETURN DATE
IS
   v_dcb_tran_date   giac_colln_batch.tran_date%TYPE;
BEGIN
   FOR a IN (SELECT tran_date
               FROM giac_colln_batch
              WHERE dcb_no = p_dcb_no
                AND dcb_year = TO_NUMBER(TO_CHAR( to_date(p_or_date,'MM-DD-YYYY'), 'YYYY'))
                AND branch_cd = p_branch_cd
                AND fund_cd = p_fund_cd)
   LOOP
      v_dcb_tran_date := a.tran_date;
      EXIT;
   END LOOP;

   RETURN v_dcb_tran_date;
END;
/



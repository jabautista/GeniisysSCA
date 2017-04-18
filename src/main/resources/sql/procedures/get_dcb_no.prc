CREATE OR REPLACE PROCEDURE CPI.get_dcb_no (
   p_fund_cd           giac_acctrans.gfun_fund_cd%TYPE,
   p_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
   p_dcb_no      OUT   giac_colln_batch.dcb_no%TYPE,
   p_tran_date  IN OUT   giac_colln_batch.tran_date%TYPE, -- apollo cruz 09.09.2015 sr#20107 - changed p_tran_date from OUT to IN OUT param
   p_message	 OUT   varchar2
)
IS
BEGIN
   FOR dcb IN (SELECT   MIN (dcb_no) min_dcb, TRUNC (tran_date) tran_date
                   FROM giac_colln_batch
                  WHERE fund_cd = p_fund_cd
                    AND branch_cd = p_branch_cd
                    AND dcb_year = TO_NUMBER (TO_CHAR (NVL(p_tran_date, SYSDATE), 'YYYY'))
                    AND TRUNC (tran_date) = TRUNC (NVL(p_tran_date, SYSDATE))
                    AND dcb_flag = 'O'
               GROUP BY TRUNC (tran_date))
   LOOP
      p_dcb_no := dcb.min_dcb;
      p_tran_date := dcb.tran_date;
      EXIT;
   END LOOP;

   IF p_dcb_no IS NULL
   THEN
      p_message := 'There is no open DCB No. for '|| TO_CHAR (NVL(p_tran_date, SYSDATE), 'fmMonth DD, YYYY') || '.';                 
   END IF;
END;
/



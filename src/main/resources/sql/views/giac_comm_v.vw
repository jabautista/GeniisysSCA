DROP VIEW CPI.GIAC_COMM_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_comm_v (intm_no,
                                              fund_cd,
                                              branch_cd,
                                              branch_name
                                             )
AS
   SELECT intm_no, gfun_fund_cd fund_cd, branch_cd, branch_name
     FROM giis_intermediary b, giac_branches a
    WHERE EXISTS (
               SELECT 'X'
                 FROM gipi_comm_invoice d
                WHERE d.intrmdry_intm_no = b.intm_no
                      AND d.iss_cd = a.branch_cd);



CREATE OR REPLACE PACKAGE BODY CPI.giacs206_pkg
AS
   /*
   ** Created by : J. Diago
   ** Date Created : 08.02.2013
   ** Reference by : Aging by Age Level (For a Given Assured)
   */
   FUNCTION get_giacs206_dtls (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_aging_id    giac_aging_parameters.aging_id%TYPE,
      p_assd_no     giac_aging_soa_details.a020_assd_no%TYPE
   )
      RETURN giacs206_dtls_tab PIPELINED
   IS
      v_list   giacs206_dtls_type;
   BEGIN
      FOR i IN (SELECT   b.aging_id, a.assd_no, a.assd_name,
                         b.gibr_gfun_fund_cd, b.gibr_branch_cd,
                         b.column_heading, c.balance_amt_due
                    FROM giis_assured a,
                         giac_aging_parameters b,
                         giac_aging_summaries_v c
                   WHERE a.assd_no = c.a020_assd_no
                     AND b.aging_id = c.gagp_aging_id
                     AND c.a020_assd_no = p_assd_no
                     AND b.gibr_gfun_fund_cd = p_fund_cd
                ORDER BY b.column_heading)
      LOOP
         v_list.aging_id := i.aging_id;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.dsp_gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_list.dsp_gibr_branch_cd := i.gibr_branch_cd;
         v_list.dsp_column_heading := i.column_heading;
         v_list.balance_amt_due := i.balance_amt_due;

         BEGIN
            SELECT SUM (balance_amt_due)
              INTO v_list.sum_balance_amt_due
              FROM giac_aging_summaries_v
             WHERE a020_assd_no = p_assd_no;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacs206_dtls;
END;
/



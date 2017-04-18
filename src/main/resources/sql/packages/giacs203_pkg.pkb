CREATE OR REPLACE PACKAGE BODY CPI.giacs203_pkg
AS
   /*
   ** Created by : J. Diago
   ** Date Created " 08.02.2013
   ** Reference by : GIACS203 List of Bills Under an Age Level
   */
   FUNCTION get_giacs203_dtls (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_aging_id    giac_aging_parameters.aging_id%TYPE,
      p_assd_no     giac_aging_soa_details.a020_assd_no%TYPE
   )
      RETURN giacs203_dtls_tab PIPELINED
   IS
      v_list   giacs203_dtls_type;
   BEGIN
      FOR i IN (SELECT   a.aging_id, a.gibr_gfun_fund_cd, a.gibr_branch_cd,
                         a.column_heading, b.a020_assd_no, c.assd_name,
                         b.iss_cd || '-'
                         || LPAD (b.prem_seq_no, 8, 0) bill_no,
                         b.inst_no, b.total_amount_due, b.total_payments,
                         b.temp_payments, b.balance_amt_due,
                         b.prem_balance_due, b.tax_balance_due
                    FROM giac_aging_parameters a,
                         giac_aging_soa_details b,
                         giis_assured c
                   WHERE a.aging_id = b.gagp_aging_id
                     AND b.a020_assd_no = c.assd_no
                     AND a.gibr_gfun_fund_cd = p_fund_cd
                     AND a.gibr_branch_cd = p_branch_cd
                     AND a.aging_id = p_aging_id
                     AND b.a020_assd_no = p_assd_no
                ORDER BY a.aging_id,
                         b.a020_assd_no,
                         b.iss_cd,
                         b.prem_seq_no,
                         b.balance_amt_due)
      LOOP
         v_list.aging_id := i.aging_id;
         v_list.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_list.gibr_branch_cd := i.gibr_branch_cd;
         v_list.column_heading := i.column_heading;
         v_list.a020_assd_no := i.a020_assd_no;
         v_list.assd_name := i.assd_name;
         v_list.bill_no := i.bill_no;
         v_list.inst_no := i.inst_no;
         v_list.total_amount_due := i.total_amount_due;
         v_list.total_payments := i.total_payments;
         v_list.temp_payments := i.temp_payments;
         v_list.temp_payments := i.temp_payments;
         v_list.balance_amt_due := i.balance_amt_due;
         v_list.prem_balance_due := i.prem_balance_due;
         v_list.tax_balance_due := i.tax_balance_due;

         BEGIN
            SELECT SUM (balance_amt_due)
              INTO v_list.sum_balance_amt_due
              FROM giac_aging_soa_details
             WHERE gagp_aging_id = p_aging_id 
               AND a020_assd_no = p_assd_no
               AND iss_cd = p_branch_cd;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacs203_dtls;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giacs204_pkg
AS
   FUNCTION get_giacs204_dtls (
      p_aging_id           giac_aging_parameters.aging_id%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_branch_cd          giac_aging_parameters.gibr_branch_cd%TYPE,
      p_bill_no            VARCHAR2,
      p_total_amount_due   giac_aging_soa_details.total_amount_due%TYPE,
      p_total_payments     giac_aging_soa_details.total_payments%TYPE,
      p_balance_amt_due    giac_aging_soa_details.balance_amt_due%TYPE
   )
      RETURN giacs204_dtls_tab PIPELINED
   IS
      v_list   giacs204_dtls_type;
   BEGIN
      FOR i IN
         (SELECT a.column_heading, b.assd_name, c.iss_cd, c.prem_seq_no,
                 c.iss_cd || '-' || LPAD (c.prem_seq_no, 8, 0) bill_no,
                 c.total_amount_due, c.total_payments, c.balance_amt_due
            FROM giac_aging_parameters a,
                 giis_assured b,
                 giac_aging_soa_details c
           WHERE a.aging_id = c.gagp_aging_id
             AND c.a020_assd_no = b.assd_no
             AND c.a020_assd_no = p_assd_no
             AND a.aging_id = p_aging_id
             AND a.gibr_branch_cd = p_branch_cd
             AND UPPER (c.iss_cd || '-' || LPAD (c.prem_seq_no, 8, 0)) LIKE UPPER (NVL (p_bill_no, '%'))
             AND c.total_amount_due = NVL(p_total_amount_due, c.total_amount_due)
             AND c.total_payments = NVL(p_total_payments, c.total_payments)
             AND c.balance_amt_due = NVL(p_balance_amt_due, c.balance_amt_due))
      LOOP
         v_list.column_heading := i.column_heading;
         v_list.assd_name := i.assd_name;
         v_list.iss_cd := i.iss_cd;
         v_list.prem_seq_no := i.prem_seq_no;
         v_list.bill_no := i.bill_no;
         v_list.total_amount_due := i.total_amount_due;
         v_list.total_payments := i.total_payments;
         v_list.balance_amt_due := i.balance_amt_due;

         BEGIN
            SELECT SUM (balance_amt_due)
              INTO v_list.sum_balance_amt_due
              FROM giac_aging_soa_details
             WHERE gagp_aging_id = p_aging_id AND a020_assd_no = p_assd_no;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacs204_dtls;
END;
/



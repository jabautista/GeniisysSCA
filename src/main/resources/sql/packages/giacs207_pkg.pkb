CREATE OR REPLACE PACKAGE BODY CPI.giacs207_pkg
AS
   FUNCTION get_giacs207_dtls (
      p_assd_no           giis_assured.assd_no%TYPE,
      p_aging_id          giac_aging_parameters.aging_id%TYPE,
      p_branch_cd         giis_issource.iss_cd%TYPE,
      p_column_heading    giac_aging_parameters.column_heading%TYPE,
      p_iss_cd            giis_issource.iss_cd%TYPE,
      p_bill_no           VARCHAR2,
      p_balance_amt_due   giac_aging_soa_details.balance_amt_due%TYPE,
      p_total_payments    giac_aging_soa_details.total_payments%TYPE,
      p_total_amt_due     giac_aging_soa_details.total_amount_due%TYPE
   )
      RETURN giacs207_dtls_tab PIPELINED
   AS
      v_list   giacs207_dtls_type;
   BEGIN
      FOR i IN
         (SELECT a.assd_no, a.assd_name, c.aging_id, c.column_heading,
                 b.iss_cd, b.prem_seq_no,
                 b.iss_cd || '-' || LPAD (b.prem_seq_no, 8, 0) bill_no,
                 b.balance_amt_due, b.total_payments, b.total_amount_due
            FROM giis_assured a,
                 giac_aging_soa_details b,
                 giac_aging_parameters c
           WHERE a.assd_no = b.a020_assd_no
             AND b.gagp_aging_id = c.aging_id
             AND a.assd_no = p_assd_no
             AND b.gagp_aging_id = p_aging_id
             AND b.iss_cd = p_branch_cd
             AND UPPER (c.column_heading) LIKE
                                           UPPER (NVL (p_column_heading, '%'))
             AND UPPER (b.iss_cd) LIKE UPPER (NVL (p_iss_cd, '%'))
             AND UPPER (b.iss_cd || '-' || LPAD (b.prem_seq_no, 8, 0)) LIKE
                                                  UPPER (NVL (p_bill_no, '%'))
             AND b.balance_amt_due =
                                    NVL (p_balance_amt_due, b.balance_amt_due)
             AND b.total_payments = NVL (p_total_payments, b.total_payments)
             AND b.total_amount_due =
                                     NVL (p_total_amt_due, b.total_amount_due))
      LOOP
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.aging_id := i.aging_id;
         v_list.column_heading := i.column_heading;
         v_list.iss_cd := i.iss_cd;
         v_list.prem_seq_no := i.prem_seq_no;
         v_list.bill_no := i.bill_no;
         v_list.balance_amt_due := i.balance_amt_due;
         v_list.total_payments := i.total_payments;
         v_list.total_amount_due := i.total_amount_due;

         BEGIN
            SELECT SUM (balance_amt_due), SUM (total_payments),
                   SUM (total_amount_due)
              INTO v_list.sum_balance_amt_due, v_list.sum_total_payments,
                   v_list.sum_total_amount_due
              FROM giis_assured a,
                   giac_aging_soa_details b,
                   giac_aging_parameters c
             WHERE a.assd_no = b.a020_assd_no
               AND b.gagp_aging_id = c.aging_id
               AND a.assd_no = p_assd_no
               AND b.gagp_aging_id = p_aging_id
               AND b.iss_cd = p_branch_cd
               AND UPPER (c.column_heading) LIKE
                                           UPPER (NVL (p_column_heading, '%'))
               AND UPPER (b.iss_cd) LIKE UPPER (NVL (p_iss_cd, '%'))
               AND UPPER (b.iss_cd || '-' || LPAD (b.prem_seq_no, 8, 0)) LIKE
                                                  UPPER (NVL (p_bill_no, '%'))
               AND b.balance_amt_due =
                                    NVL (p_balance_amt_due, b.balance_amt_due)
               AND b.total_payments = NVL (p_total_payments, b.total_payments)
               AND b.total_amount_due =
                                     NVL (p_total_amt_due, b.total_amount_due);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.sum_balance_amt_due := 0;
               v_list.sum_total_payments := 0;
               v_list.total_amount_due := 0;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacs207_dtls;

   FUNCTION get_assured_list_dtls (
      p_assd_no           giis_assured.assd_no%TYPE,
      p_assd_name         giis_assured.assd_name%TYPE,
      p_balance_amt_due   giac_soa_summaries_v.balance_amt_due%TYPE
   )
      RETURN giacs207_assd_list_tab PIPELINED
   IS
      v_list   giacs207_assd_list_type;
   BEGIN
      FOR i IN (SELECT   b.assd_no, b.assd_name, a.balance_amt_due
                    FROM giac_soa_summaries_v a, giis_assured b
                   WHERE a.a020_assd_no = b.assd_no
                     AND b.assd_no = NVL (p_assd_no, b.assd_no)
                     AND UPPER (b.assd_name) LIKE
                                                UPPER (NVL (p_assd_name, '%'))
                     AND a.balance_amt_due =
                                    NVL (p_balance_amt_due, a.balance_amt_due)
                ORDER BY b.assd_no)
      LOOP
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.balance_amt_due := i.balance_amt_due;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_assured_list_dtls;
END;
/



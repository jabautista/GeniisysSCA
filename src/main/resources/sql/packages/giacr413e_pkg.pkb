CREATE OR REPLACE PACKAGE BODY CPI.giacr413e_pkg
AS
   FUNCTION get_giacr_413e_report (
      p_from_dt     VARCHAR2,
      p_to_dt       VARCHAR2,
      p_intm_type   VARCHAR2,
      p_module_id   VARCHAR2,
      p_tran_post   NUMBER,
      p_user_id     VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
      v_is_empty VARCHAR2(1) := 'Y';
   BEGIN
   
     BEGIN
        SELECT param_value_v
          INTO v_list.company_name
          FROM giac_parameters
         WHERE param_name = 'COMPANY_NAME';
     END;

     BEGIN
        SELECT param_value_v
          INTO v_list.company_address
          FROM giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
     END;

     BEGIN
        SELECT    'From '
               || TO_CHAR (TO_DATE (p_from_dt, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          )
               || ' to '
               || TO_CHAR (TO_DATE (p_to_dt, 'mm/dd/yyyy'),
                           'fmMonth DD, RRRR'
                          )
          INTO v_list.period
          FROM DUAL;
     END;

     BEGIN
        IF p_tran_post = 1
        THEN
           v_list.tran_post := 'Based on Transaction Date';
        ELSE
           v_list.tran_post := 'Based on Posting Date';
        END IF;
     END;
         
      FOR i IN
         (SELECT   d.intm_type, a.intm_no, e.line_cd, d.intm_name,
                   get_policy_no (e.policy_id) policy_no, e.subline_cd, e.iss_cd,
                   e.issue_yy, e.pol_seq_no, e.renew_no, e.endt_seq_no,
                   SUM (a.comm_amt) comm, SUM (a.wtax_amt) wtax,
                   SUM (input_vat_amt) input_vat,
                     SUM (a.comm_amt)
                   - SUM (a.wtax_amt)
                   + SUM (input_vat_amt) net
              FROM gipi_polbasic e,
                   giac_comm_payts a,
                   gipi_comm_invoice f,
                   giac_acctrans b,
                   giis_intermediary d
             WHERE 1 = 1
               AND (   (    p_tran_post = 1
                        AND TRUNC (b.tran_date) BETWEEN TO_DATE (p_from_dt,
                                                                 'MM-dd-YYYY'
                                                                )
                                                    AND TO_DATE (p_to_dt,
                                                                 'MM-dd-YYYY'
                                                                )
                       )
                    OR (    p_tran_post = 2
                        AND TRUNC (b.posting_date) BETWEEN TO_DATE
                                                                 (p_from_dt,
                                                                  'MM-dd-YYYY'
                                                                 )
                                                       AND TO_DATE
                                                                 (p_to_dt,
                                                                  'MM-dd-YYYY'
                                                                 )
                       )
                   )
               AND b.tran_flag <> 'D'
               --AND b.tran_flag <> 'CP' --mikel 12.12.2016;
               AND b.tran_class NOT IN ('CP', 'CPR') --mikel 12.12.2016; SR 5874 - excluded transactions that are processed from cancelled policies module (GIACS412)
               AND b.tran_id > 0
               AND a.gacc_tran_id = b.tran_id
               AND d.intm_type = NVL (p_intm_type, d.intm_type)
               AND f.intrmdry_intm_no > 0
               AND f.iss_cd = a.iss_cd
               --AND check_user_per_iss_cd_acctg2 (NULL, a.iss_cd, p_module_id, p_user_id) = 1 --mikel 12.12.2016;
               AND EXISTS (SELECT 'X'
                                   FROM table (security_access.get_branch_line('AC', p_module_id, p_user_id))
                                  WHERE branch_cd = a.iss_cd) --mikel 12.12.2016; SR 5874 - optimization                                                                             
               AND f.prem_seq_no = a.prem_seq_no
               AND a.intm_no = d.intm_no
               AND a.intm_no = f.intrmdry_intm_no
               AND e.policy_id = f.policy_id
               AND NOT EXISTS (
                      SELECT c.gacc_tran_id
                        FROM giac_reversals c, giac_acctrans d
                       WHERE c.reversing_tran_id = d.tran_id
                         AND d.tran_flag <> 'D'
                         AND c.gacc_tran_id = a.gacc_tran_id)
          GROUP BY d.intm_type,
                   a.intm_no,
                   e.line_cd,
                   d.intm_name,
                   get_policy_no (e.policy_id),
                   e.subline_cd,
                   e.iss_cd,
                   e.issue_yy,
                   e.pol_seq_no,
                   e.renew_no,
                   e.endt_seq_no
          ORDER BY d.intm_type,
                   a.intm_no,  --added by Kris 07.25.2013
                   d.intm_name,
                   e.line_cd,
                   e.subline_cd,
                   e.iss_cd,
                   e.issue_yy,
                   e.pol_seq_no,
                   e.renew_no,
                   e.endt_seq_no)
      LOOP
         v_is_empty := 'N';
         BEGIN
            SELECT intm_desc
              INTO v_list.cf_intm_type
              FROM giis_intm_type
             WHERE intm_type = i.intm_type;
         END;
         
         v_list.intm_no := i.intm_no;
         v_list.intm_name := i.intm_name;
         v_list.policy_no := i.policy_no;
         v_list.comm := i.comm;
         v_list.wtax := i.wtax;
         v_list.input_vat := i.input_vat;
         v_list.net := i.net;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;

         PIPE ROW (v_list);
      END LOOP;
      
      IF v_is_empty = 'Y' THEN
        PIPE ROW(v_list);
      END IF;
      
      RETURN;
   END get_giacr_413e_report;
END;
/
CREATE OR REPLACE PACKAGE BODY CPI.giacr162_pkg
AS
   FUNCTION get_giacr_162_report (
      p_from_dt   VARCHAR2,
      p_to_dt     VARCHAR2,
      p_choice    VARCHAR2,
      p_intm_no   NUMBER,
      p_user_id   VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
      v_print   BOOLEAN := false;
   BEGIN
        BEGIN
            SELECT param_value_v
              INTO v_list.company_name
              FROM giis_parameters
             WHERE param_name = 'COMPANY_NAME';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_name := '';
        END;

        BEGIN
            SELECT param_value_v
              INTO v_list.company_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_address := '';
        END;

         IF p_from_dt = p_to_dt
         THEN
            v_list.title_date := TO_CHAR (TO_DATE (p_from_dt, 'mm-dd-yyyy'), 'fmMonth dd, yyyy');
         ELSE
            v_list.title_date := 'from ' || TO_CHAR (TO_DATE (p_from_dt, 'mm-dd-yyyy'), 'fmMonth dd, yyyy' )
                                || ' to ' || TO_CHAR (TO_DATE (p_to_dt, 'mm-dd-yyyy'), 'fmMonth dd, yyyy');
         END IF;
         
      FOR i IN
         (SELECT   DECODE (a.print_date, NULL, 'UNPRINTED', 'PRINTED' ) cv_choice,
                   DECODE (a.print_date, NULL, '1', TO_CHAR (/*TO_DATE (*/TRUNC (a.print_date), /*'mm/dd/yyyy' ),*/ 'dd-MON-yy')  ) cv_date,
                   a.intm_no intm_no, TRUNC (a.tran_date) tran_date,
                   DECODE (a.ref_no, NULL, 'N', a.ref_no) ref_no,
                   tran_class tran_class, policy_no policy_no,
                   a.inst_no inst_no, NVL (a.premium_amt, 0) prem_amt,
                   NVL (a.commission_due, 0) comm_amt,
                   NVL (a.withholding_tax, 0) tax, NVL (a.advances, 0) adv,
                   NVL (a.input_vat, 0) vat, a.assd_no assd,
                   a.ocv_pref_suf || '-' || a.ocv_no cv_no,
                   a.iss_cd || '-' || a.prem_seq_no bill_no
              FROM giac_parent_comm_voucher a
             WHERE tran_date BETWEEN NVL (TO_DATE (p_from_dt, 'mm-dd-yyyy'),
                                          tran_date
                                         )
                                 AND NVL (TO_DATE (p_to_dt, 'mm-dd-yyyy'),
                                          tran_date
                                         )
               AND a.intm_no = p_intm_no
               AND (   (a.print_date IS NOT NULL AND p_choice = 'P')
                    OR (a.print_date IS NULL AND p_choice = 'U')
                    OR p_choice = 'A'
                   )
               AND check_user_per_iss_cd_acctg2(null, gibr_branch_cd, 'GIACS149', p_user_id) = 1
          ORDER BY tran_date, policy_no)
      LOOP
         /*BEGIN
            SELECT param_value_v
              INTO v_list.company_name
              FROM giis_parameters
             WHERE param_name = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_name := '';
         END;

         BEGIN
            SELECT param_value_v
              INTO v_list.company_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_address := '';
         END;

         IF p_from_dt = p_to_dt
         THEN
            v_list.title_date :=
               TO_CHAR (TO_DATE (p_from_dt, 'mm-dd-yyyy'),
                        'fmMonth dd, yyyy');
         ELSE
            v_list.title_date :=
                  'from '
               || TO_CHAR (TO_DATE (p_from_dt, 'mm-dd-yyyy'),
                           'fmMonth dd, yyyy'
                          )
               || ' to '
               || TO_CHAR (TO_DATE (p_to_dt, 'mm-dd-yyyy'), 'fmMonth dd,yyyy');
         END IF;*/

         BEGIN
            SELECT 'Intermediary :  ' || TO_CHAR (intm_no) || ' - '
                   || intm_name
              INTO v_list.intrmdry
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;
         END;
         v_print            := TRUE;
         v_list.print_details := 'Y';
         v_list.cv_choice := i.cv_choice;
         v_list.cv_date := i.cv_date;
         v_list.cv_no := i.cv_no;
         v_list.tran_date := i.tran_date;
         v_list.policy_no := i.policy_no;
         v_list.bill_no := i.bill_no;
         v_list.inst_no := i.inst_no;
         v_list.tran_class := i.tran_class;
         v_list.ref_no := i.ref_no;
         v_list.prem_amt := i.prem_amt;
         v_list.comm_amt := i.comm_amt;
         v_list.tax := i.tax;
         v_list.adv := i.adv;
         v_list.vat := i.vat;
         v_list.cf_net_amt :=
              NVL (i.comm_amt, 0)
            - NVL (i.tax, 0)
            - NVL (i.adv, 0)
            + NVL (i.vat, 0);
         v_list.intm_no := i.intm_no;

         BEGIN
            SELECT assd_name
              INTO v_list.cf_assd
              FROM giis_assured
             WHERE assd_no = i.assd;
         END;

         PIPE ROW (v_list);
      END LOOP;
      
      IF v_print = FALSE THEN
        v_list.print_details := 'N';
        PIPE ROW(v_list);
      END IF;
   END get_giacr_162_report;

   FUNCTION get_giacr_162_details (
      p_from_dt     VARCHAR2,
      p_to_dt       VARCHAR2,
      p_choice      VARCHAR2,
      p_intm_no     NUMBER,
      p_cv_choice   VARCHAR2,
      p_cv_date     VARCHAR2,
      p_cv_no       VARCHAR2,
      p_tran_date   DATE,
      p_user_id   VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN
         (SELECT   DECODE (a.print_date, NULL, 'UNPRINTED', 'PRINTED') cv_choice,
                   DECODE (a.print_date, NULL, '1', TO_CHAR (/*TO_DATE (*/TRUNC (a.print_date), /*'mm/dd/yyyy' ),*/ 'dd-MON-yy' ) ) cv_date,
                   a.intm_no intm_no, TRUNC (a.tran_date) tran_date,
                   DECODE (a.ref_no, NULL, 'N', a.ref_no) ref_no,
                   tran_class tran_class, policy_no policy_no,
                   a.inst_no inst_no, NVL (a.premium_amt, 0) prem_amt,
                   NVL (a.commission_due, 0) comm_amt,
                   NVL (a.withholding_tax, 0) tax, NVL (a.advances, 0) adv,
                   NVL (a.input_vat, 0) vat, a.assd_no assd,
                   a.ocv_pref_suf || '-' || a.ocv_no cv_no,
                   a.iss_cd || '-' || a.prem_seq_no bill_no
              FROM giac_parent_comm_voucher a
             WHERE tran_date BETWEEN NVL (TO_DATE (p_from_dt, 'mm-dd-yyyy'),
                                          tran_date
                                         )
                                 AND NVL (TO_DATE (p_to_dt, 'mm-dd-yyyy'),
                                          tran_date
                                         )
               AND a.intm_no = p_intm_no
               AND (   (a.print_date IS NOT NULL AND p_choice = 'P')
                    OR (a.print_date IS NULL AND p_choice = 'U')
                    OR p_choice = 'A'
                   )
               AND DECODE (a.print_date, NULL, 'UNPRINTED', 'PRINTED') = p_cv_choice
               AND DECODE (a.print_date, NULL, '1', TO_CHAR (/*TO_DATE (*/TRUNC (a.print_date), /*'mm/dd/yyyy' ),*/ 'dd-MON-yy' ) ) = p_cv_date
               AND a.ocv_pref_suf || '-' || a.ocv_no = p_cv_no
               AND TRUNC (a.tran_date) = p_tran_date
               AND check_user_per_iss_cd_acctg2(null, gibr_branch_cd, 'GIACS149', p_user_id) = 1
          ORDER BY tran_date, policy_no)
      LOOP
         BEGIN
            SELECT 'Intermediary :  ' || TO_CHAR (intm_no) || ' - '
                   || intm_name
              INTO v_list.intrmdry
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;
         END;

         v_list.cv_choice := i.cv_choice;
         v_list.cv_date := i.cv_date;
         v_list.cv_no := i.cv_no;
         v_list.tran_date := i.tran_date;
         v_list.policy_no := i.policy_no;
         v_list.bill_no := i.bill_no;
         v_list.inst_no := i.inst_no;
         v_list.tran_class := i.tran_class;
         v_list.ref_no := i.ref_no;
         v_list.prem_amt := i.prem_amt;
         v_list.comm_amt := i.comm_amt;
         v_list.tax := i.tax;
         v_list.adv := i.adv;
         v_list.vat := i.vat;
         v_list.cf_net_amt :=
              NVL (i.comm_amt, 0)
            - NVL (i.tax, 0)
            - NVL (i.adv, 0)
            + NVL (i.vat, 0);
         v_list.intm_no := i.intm_no;

         BEGIN
            SELECT assd_name
              INTO v_list.cf_assd
              FROM giis_assured
             WHERE assd_no = i.assd;
         END;

         PIPE ROW (v_list);
      END LOOP;
   END get_giacr_162_details;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giacr182_pkg
AS
   FUNCTION get_giacr182_details (
      p_ri_cd     giac_dueto_asof_ext.ri_cd%TYPE,
      p_line_cd   giac_dueto_asof_ext.line_cd%TYPE,
      p_user_id   giac_dueto_asof_ext.user_id%TYPE
   )
      RETURN giacr182_tab PIPELINED
   IS
      v_giacr182   giacr182_type;
   BEGIN
      FOR i IN (SELECT   fund_cd, branch_cd, ri_cd, ri_name, policy_id,
                         policy_no, fnl_binder_id, line_cd, binder_yy,
                         binder_seq_no, binder_date, booking_date,
                         amt_insured,
                         (  (ri_prem_amt + NVL (prem_vat, 0))
                          - (  ri_comm_amt
                             + NVL (comm_vat, 0)
                             + NVL (wholding_vat, 0)
                            )
                         ) "NET_PREMIUM",
                         assd_no, assd_name, cut_off_date, from_date,
                         TO_DATE
                    FROM giac_dueto_asof_ext
                   WHERE ri_cd = NVL (p_ri_cd, ri_cd)
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND user_id = p_user_id
                ORDER BY 4, 9, 7)
      LOOP
         v_giacr182.report_title :=
               'Binders Booked from '
            || TO_CHAR (i.from_date, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (i.TO_DATE, 'fmMonth DD, YYYY');
         v_giacr182.report_title2 :=
              'Balance as of ' || TO_CHAR (i.cut_off_date, 'fmMonth DD, YYYY');
         v_giacr182.fund_cd := i.fund_cd;
         v_giacr182.branch_cd := i.branch_cd;
         v_giacr182.ri_cd := i.ri_cd;
         v_giacr182.ri_name := i.ri_name;
         v_giacr182.policy_id := i.policy_id;
         v_giacr182.policy_no := i.policy_no;
         v_giacr182.fnl_binder_id := i.fnl_binder_id;
         v_giacr182.line_cd := i.line_cd;
         v_giacr182.binder_yy := i.binder_yy;
         v_giacr182.binder_seq_no := i.binder_seq_no;
         v_giacr182.binder_date := TO_CHAR (i.binder_date, 'MM-DD-RRRR');
         v_giacr182.booking_date := TO_CHAR (i.booking_date, 'MM-DD-RRRR');
         v_giacr182.amt_insured := i.amt_insured;
         v_giacr182.net_premium := i.net_premium;
         v_giacr182.assd_no := i.assd_no;
         v_giacr182.assd_name := i.assd_name;
         v_giacr182.cut_off_date := TO_CHAR (i.cut_off_date, 'MM-DD-RRRR');
         v_giacr182.from_date := TO_CHAR (i.from_date, 'MM-DD-RRRR');
         v_giacr182.TO_DATE := TO_CHAR (i.TO_DATE, 'MM-DD-RRRR');

         SELECT giacr182_pkg.get_cf_company_nameformula
           INTO v_giacr182.company_name
           FROM DUAL;

         SELECT giacr182_pkg.get_cf_company_addformula
           INTO v_giacr182.company_address
           FROM DUAL;

         PIPE ROW (v_giacr182);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giacr182_sum_per_ri (
      p_ri_cd     giac_dueto_asof_ext.ri_cd%TYPE,
      p_user_id   giac_dueto_asof_ext.user_id%TYPE
   )
      RETURN giacr182_sum_per_ri_tab PIPELINED
   IS
      v_giacr182   giacr182_sum_per_ri_type;
   BEGIN
      FOR i IN (SELECT   ri_cd, ri_name,
                         SUM ((  (ri_prem_amt + NVL (prem_vat, 0))
                               - (  ri_comm_amt
                                  + NVL (comm_vat, 0)
                                  + NVL (wholding_vat, 0)
                                 )
                              )
                             ) "NET_PREMIUM"
                    FROM giac_dueto_asof_ext
                   WHERE ri_cd = NVL (p_ri_cd, ri_cd) AND user_id = p_user_id
                GROUP BY ri_cd, ri_name
                ORDER BY ri_cd, ri_name)
      LOOP
         v_giacr182.ri_cd := i.ri_cd;
         v_giacr182.ri_name := i.ri_name;
         v_giacr182.net_premium := i.net_premium;
         PIPE ROW (v_giacr182);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giacr182_sum_per_line (
      p_ri_cd     giac_dueto_asof_ext.ri_cd%TYPE,
      p_line_cd   giac_dueto_asof_ext.line_cd%TYPE,
      p_user_id   giac_dueto_asof_ext.user_id%TYPE
   )
      RETURN giacr182_sum_per_line_tab PIPELINED
   IS
      v_giacr182   giacr182_sum_per_line_type;
   BEGIN
      FOR i IN (SELECT   ri_cd, line_cd,
                         SUM ((  (ri_prem_amt + NVL (prem_vat, 0))
                               - (  ri_comm_amt
                                  + NVL (comm_vat, 0)
                                  + NVL (wholding_vat, 0)
                                 )
                              )
                             ) "NET_PREMIUM"
                    FROM giac_dueto_asof_ext
                   WHERE ri_cd = NVL (p_ri_cd, ri_cd)
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND user_id = p_user_id
                GROUP BY ri_cd, line_cd
                ORDER BY ri_cd, line_cd)
      LOOP
         v_giacr182.ri_cd := i.ri_cd;
         v_giacr182.line_cd := i.line_cd;
         v_giacr182.net_premium := i.net_premium;

         SELECT giacr182_pkg.get_cf_line_nameformula (v_giacr182.line_cd)
           INTO v_giacr182.line_name
           FROM DUAL;

         PIPE ROW (v_giacr182);
      END LOOP;

      RETURN;
   END;
   
    FUNCTION get_giacr182_sum_recap (
      p_ri_cd     giac_dueto_asof_ext.ri_cd%TYPE,
      p_line_cd   giac_dueto_asof_ext.line_cd%TYPE,
      p_user_id   giac_dueto_asof_ext.user_id%TYPE
   )
      RETURN giacr182_sum_per_line_tab PIPELINED
   IS
      v_giacr182   giacr182_sum_per_line_type;
   BEGIN
      FOR i IN (SELECT   line_cd,
                         SUM ((  (ri_prem_amt + NVL (prem_vat, 0))
                               - (  ri_comm_amt
                                  + NVL (comm_vat, 0)
                                  + NVL (wholding_vat, 0)
                                 )
                              )
                             ) "NET_PREMIUM"
                    FROM giac_dueto_asof_ext
                   WHERE ri_cd = NVL (p_ri_cd, ri_cd)
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND user_id = p_user_id
                GROUP BY line_cd
                ORDER BY line_cd)
      LOOP
         v_giacr182.line_cd := i.line_cd;
         v_giacr182.net_premium := i.net_premium;

         SELECT giacr182_pkg.get_cf_line_nameformula (v_giacr182.line_cd)
           INTO v_giacr182.line_name
           FROM DUAL;

         PIPE ROW (v_giacr182);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2
   IS
      v_company_name   giis_parameters.param_value_v%TYPE;
   BEGIN
      v_company_name := '(No company name available)';

      FOR rec IN (SELECT giacp.v ('COMPANY_NAME') v_company_name
                    FROM DUAL)
      LOOP
         v_company_name := rec.v_company_name;
      END LOOP;

      RETURN (v_company_name);
   END;

   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2
   IS
      v_company_address   giis_parameters.param_value_v%TYPE;
   BEGIN
      FOR rec IN (SELECT UPPER (giacp.v ('COMPANY_ADDRESS'))
                                                           v_company_address
                    FROM DUAL)
      LOOP
         v_company_address := rec.v_company_address;
      END LOOP;

      RETURN (v_company_address);
   END;

   FUNCTION get_cf_line_nameformula (
      p_line_cd   giac_dueto_asof_ext.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_line_name   VARCHAR2 (50);
   BEGIN
      SELECT line_name
        INTO v_line_name
        FROM giis_line
       WHERE line_cd = p_line_cd;

      RETURN (v_line_name);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_line_name := 'Unlisted Line';
         RETURN (v_line_name);
   END;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giacr188_pkg
AS
   FUNCTION get_giacr188_details (
      p_ri_cd     giac_dueto_asof_ext.ri_cd%TYPE,
      p_line_cd   giac_dueto_asof_ext.line_cd%TYPE,
      p_user_id   giac_dueto_asof_ext.user_id%TYPE
   )
      RETURN giacr188_tab PIPELINED
   IS
      v_giacr188   giacr188_type;
   BEGIN
      FOR i IN (SELECT   a.ri_name "REINSURER", b.line_name, a.booking_date,
                         a.line_cd, a.binder_yy, a.binder_seq_no,
                         a.policy_no, a.incept_date, a.binder_date,
                         a.ref_pol_no, a.assd_name, a.amt_insured,
                         a.ri_prem_amt, a.ri_comm_amt,
                         (  (a.ri_prem_amt + NVL (a.prem_vat, 0))
                          - (  a.ri_comm_amt
                             + NVL (a.comm_vat, 0)
                             + NVL (wholding_vat, 0)
                            )
                         ) "NET_PREMIUM",
                         a.prem_vat, a.comm_vat, a.wholding_vat, a.from_date,
                         a.TO_DATE, a.cut_off_date
                    FROM giac_dueto_asof_ext a, giis_line b
                   WHERE a.line_cd = b.line_cd
                     AND a.user_id = p_user_id
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                ORDER BY a.ri_name,
                         b.line_name,
                         a.booking_date,
                         a.line_cd,
                         a.binder_yy,
                         a.binder_seq_no)
      LOOP
         v_giacr188.ri_name := i.reinsurer;
         v_giacr188.line_name := i.line_name;
         v_giacr188.booking_date := i.booking_date;
         v_giacr188.binder_no :=
                    i.line_cd || '-' || i.binder_yy || '-' || i.binder_seq_no;
         v_giacr188.policy_no := i.policy_no;
         v_giacr188.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_giacr188.binder_date := TO_CHAR (i.binder_date, 'MM-DD-RRRR');
         v_giacr188.ref_pol_no := i.ref_pol_no;
         v_giacr188.assd_name := i.assd_name;
         v_giacr188.amt_insured := i.amt_insured;
         v_giacr188.ri_prem_amt := i.ri_prem_amt;
         v_giacr188.ri_comm_amt := i.ri_comm_amt;
         v_giacr188.net_premium := i.net_premium;
         v_giacr188.prem_vat := i.prem_vat;
         v_giacr188.comm_vat := i.comm_vat;
         v_giacr188.wholding_vat := i.wholding_vat;
         v_giacr188.from_date := i.from_date;
         v_giacr188.TO_DATE := i.TO_DATE;
         v_giacr188.cut_off_date := i.cut_off_date;
         v_giacr188.report_title :=
               'Binders Booked from '
            || TO_CHAR (i.from_date, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (i.TO_DATE, 'fmMonth DD, YYYY');
         v_giacr188.report_title2 :=
                      'As of ' || TO_CHAR (i.cut_off_date, 'fmMonth DD, YYYY');

         SELECT giacr188_pkg.get_cf_company_nameformula
           INTO v_giacr188.company_name
           FROM DUAL;

         SELECT giacr188_pkg.get_cf_company_addformula
           INTO v_giacr188.company_address
           FROM DUAL;

         PIPE ROW (v_giacr188);
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
END;
/



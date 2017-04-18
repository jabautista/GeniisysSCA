CREATE OR REPLACE PACKAGE BODY CPI.giacr093a_pkg
AS
   FUNCTION cf_conameformula
      RETURN CHAR
   IS
      v_company   giac_parameters.param_value_v%type; -- VARCHAR2 (200); -- shan 08.05.2014
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_company
           FROM giac_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN ('CPI INSURANCE CORP.');
      END;

      RETURN (v_company);
   END;

   FUNCTION cf_company_addressformula
      RETURN CHAR
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN (v_address);
   END;

   FUNCTION populate_giacr093a_header (
      p_pdc       VARCHAR2,
      p_as_of     DATE,
      p_cut_off   DATE
   )
      RETURN giacr093a_header_tab PIPELINED
   IS
      v_rec   giacr093a_header_type;
   BEGIN
      v_rec.company_name := cf_conameformula;
      v_rec.company_address := cf_company_addressformula;

      IF p_pdc = 'R'
      THEN
         v_rec.title := 'POST-DATED CHECKS REGISTER';
      ELSIF p_pdc = 'O'
      THEN
         v_rec.title := 'OUTSTANDING POST-DATED CHECKS';
      END IF;

      v_rec.as_of :=
                  'Check Date as of ' || TO_CHAR (p_as_of, 'fmMonth DD, RRRR');
      v_rec.cut_off :=
                 'O.R. Date as of ' || TO_CHAR (p_cut_off, 'fmMonth DD, RRRR');
      PIPE ROW (v_rec);
      RETURN;
   END populate_giacr093a_header;

   FUNCTION populate_giacr093a_details (
      p_as_of           DATE,
      p_cut_off         DATE,
      p_begin_extract   VARCHAR2,
      p_end_extract     VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN giacr093a_details_tab PIPELINED
   AS
      v_rec       giacr093a_details_type;
      v_pol_id    gipi_invoice.policy_id%TYPE;
      v_par_id    gipi_polbasic.par_id%TYPE;
      v_assd_no   gipi_parlist.assd_no%TYPE;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.branch_cd branch,
                          DECODE (a.apdc_no,
                                  NULL, 'UNDISTRIBUTED',
                                     a.apdc_pref
                                  || '-'
                                  || LPAD (a.apdc_no, 10, '0')
                                 ) apdc_no,
                          a.apdc_date, b.bank_sname bank,
                          a.bank_branch bank_branch, a.check_no check_no,
                          a.check_date check_date, a.check_amt check_amount,
                             c.iss_cd
                          || '-'
                          || LPAD (c.prem_seq_no, 12, '0')
                          || '-'
                          || LPAD (c.inst_no, 2, '0') bill_no,
                          c.iss_cd, c.prem_seq_no,
                          c.collection_amt collection_amount,
                          a.or_date or_date,
                          DECODE (a.or_pref_suf,
                                  NULL, NULL,
                                     a.or_pref_suf
                                  || '-'
                                  || LPAD (a.or_no, 10, '0')
                                 ) or_no,
                          d.ref_apdc_no, d.payor
                     FROM giac_pdc_ext a,
                          giac_banks b,
                          giac_pdc_dtl_ext c,
                          giac_apdc_payt d
                    WHERE a.bank_cd = b.bank_cd
                      AND a.pdc_id = c.pdc_id
                      AND a.as_of_date = p_as_of
                      AND a.cut_off_date = p_cut_off
                      AND a.user_id = UPPER (p_user)
                      AND a.extract_date
                             BETWEEN TO_DATE (p_begin_extract,
                                              'MM/DD/RRRR HH:MI:SS AM'
                                             )
                                 AND TO_DATE (p_end_extract,
                                              'MM/DD/RRRR HH:MI:SS AM'
                                             )
                      AND a.apdc_id = d.apdc_id)
      LOOP
         FOR j IN (SELECT branch_name
                     FROM giac_branches
                    WHERE branch_cd = i.branch)
         LOOP
            v_rec.branch := j.branch_name;
            EXIT;
         END LOOP;

         FOR r IN (SELECT policy_id
                     FROM gipi_invoice
                    WHERE iss_cd = i.iss_cd AND prem_seq_no = i.prem_seq_no)
         LOOP
            v_pol_id := r.policy_id;

            FOR h IN (SELECT get_policy_no (v_pol_id) policy_number
                        FROM DUAL)
            LOOP
               v_rec.pol_no := h.policy_number;
               EXIT;
            END LOOP;

            FOR w IN (SELECT par_id
                        FROM gipi_polbasic
                       WHERE policy_id = v_pol_id)
            LOOP
               v_par_id := w.par_id;

               FOR q IN (SELECT assd_no
                           FROM gipi_parlist
                          WHERE par_id = v_par_id)
               LOOP
                  v_assd_no := q.assd_no;

                  FOR y IN (SELECT get_assd_name (v_assd_no) assured
                              FROM DUAL)
                  LOOP
                     v_rec.assured := y.assured;
                     EXIT;
                  END LOOP;
               END LOOP;
            END LOOP;
         END LOOP;
		 
		 v_rec.branch_cd := i.branch; --CarloR SR-5519 06.28.2016
         v_rec.assd_no := v_assd_no; --CarloR SR-5519 06.28.2016
         v_rec.apdc_no := i.apdc_no;
         v_rec.apdc_date := i.apdc_date;
         v_rec.bank := i.bank;
         v_rec.bank_branch := i.bank_branch;
         v_rec.check_no := i.check_no;
         v_rec.check_date := i.check_date;
         v_rec.check_amt := i.check_amount;
         v_rec.bill_no := i.bill_no;
         v_rec.iss_cd := i.iss_cd;
         v_rec.collection_amt := i.collection_amount;
         v_rec.or_date := i.or_date;
         v_rec.or_no := i.or_no;
         v_rec.ref_apdc_no := i.ref_apdc_no;
         v_rec.payor := i.payor;
         PIPE ROW (v_rec);
      END LOOP;
   END populate_giacr093a_details;
END giacr093a_pkg;
/



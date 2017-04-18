CREATE OR REPLACE PACKAGE BODY CPI.giacr170_pkg
AS
   FUNCTION cf_comp_nameformula
      RETURN VARCHAR2
   IS
      comp_name   VARCHAR2 (100);
   BEGIN
      SELECT param_value_v
        INTO comp_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (comp_name);
   END;

   FUNCTION cf_comp_addformula
      RETURN VARCHAR2
   IS
      v_add   VARCHAR2 (350);
   BEGIN
      SELECT param_value_v
        INTO v_add
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_add);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_add := '(NO PARAMETER COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         RETURN (v_add);
      WHEN TOO_MANY_ROWS
      THEN
         v_add := '(TOO MANY VALUES OF COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         RETURN (v_add);
   END;

   FUNCTION cf_date_typeformula (p_date_type VARCHAR2)
      RETURN CHAR
   IS
      v_date_type   VARCHAR2 (200);
   BEGIN
      IF UPPER (p_date_type) = 'T'
      THEN
         v_date_type := 'Based on  Transaction Date';
      ELSIF UPPER (p_date_type) = 'P'
      THEN
         v_date_type := 'Based on  Posting Date';
      END IF;

      RETURN (v_date_type);
   END;

   FUNCTION cf_dateformula (p_to_date DATE, p_from_date DATE)
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      IF p_from_date IS NULL
      THEN
         BEGIN
            SELECT 'As of  ' || TO_CHAR (p_to_date, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;
      ELSIF p_from_date IS NOT NULL
      THEN
         BEGIN
            SELECT    'From '
                   || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
                   || ' To '
                   || TO_CHAR (p_to_date, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;
      END IF;

      RETURN (v_date);
   END;

   FUNCTION populate_giacr170 (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_date_type   VARCHAR2
   )
      RETURN giacr170_tab PIPELINED
   IS
      v_rec   giacr170_type;
   BEGIN
      v_rec.company_name := cf_comp_nameformula;
      v_rec.company_address := cf_comp_addformula;
      v_rec.f_date :=
         cf_dateformula (TO_DATE (p_to_date, 'MM/DD/YYYY'),
                         TO_DATE (p_from_date, 'MM/DD/YYYY')
                        );
      v_rec.date_type_title := cf_date_typeformula (p_date_type);
      PIPE ROW (v_rec);
      RETURN;
   END populate_giacr170;

   FUNCTION populate_giacr170_details (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_date_type   VARCHAR2,
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_module_id   VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr170_details_tab PIPELINED
   IS
      v_rec         giacr170_details_type;
      v_to_date     DATE                 := TO_DATE (p_to_date, 'MM/DD/YYYY');
      v_from_date   DATE               := TO_DATE (p_from_date, 'MM/DD/YYYY');
      v_or_no       VARCHAR2 (30);
   BEGIN
      FOR i IN
         (SELECT   g.tran_id, g.tran_date,
                   DECODE (d.endt_seq_no,
                           0,  d.line_cd
                            || '-'
                            || d.subline_cd
                            || '-'
                            || d.iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (d.issue_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (d.pol_seq_no, '0000009'))
                            || '-'
                            || LTRIM (TO_CHAR (d.renew_no, '09')),
                              d.line_cd
                           || '-'
                           || d.subline_cd
                           || '-'
                           || d.iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (d.issue_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (d.pol_seq_no, '0000009'))
                           || '-'
                           || LTRIM (TO_CHAR (d.renew_no, '09'))
                           || '/'
                           || d.endt_iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (d.endt_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (d.endt_seq_no, '000009'))
                          ) policy_no,
                   RTRIM (LTRIM (d.ref_pol_no)) reference_pol_no,
                   f.assd_name assured, d.incept_date inception_date,
                   d.expiry_date expiry_date,
                   a.iss_cd || '-' || a.prem_seq_no bill_no,
                   c.collection_amt collection_amt,
                   c.premium_amt premium_amt, c.tax_amt tax_amt,
                   a.booking_mth bk_month, a.booking_year bk_year,
                   DECODE (p_branch,
                           'OR', g.gibr_branch_cd,
                           'BI', c.b140_iss_cd,
                           'CB', d.cred_branch
                          ) branch,
                   h.dv_no, i.or_no, g.jv_no, h.dv_pref, i.or_pref_suf, g.jv_pref_suff -- Dren 04.27.2016 SR-5353        
              FROM giac_advanced_payt a,
                   giac_direct_prem_collns c,
                   gipi_polbasic d,
                   gipi_invoice e,
                   giis_assured f,
                   giac_acctrans g,
                   giac_disb_vouchers h, -- Dren 04.27.2016 SR-5353
                   giac_order_of_payts i -- Dren 04.27.2016 SR-5353
             WHERE a.gacc_tran_id = c.gacc_tran_id
               AND g.tran_id = h.gacc_tran_id(+) -- Dren 04.27.2016 SR-5353
               AND g.tran_id = i.gacc_tran_id(+) -- Dren 04.27.2016 SR-5353
               AND a.gacc_tran_id = g.tran_id
               AND a.iss_cd = c.b140_iss_cd
               AND a.prem_seq_no = c.b140_prem_seq_no
               AND d.policy_id = e.policy_id
               AND c.b140_iss_cd = e.iss_cd
               AND c.b140_prem_seq_no = e.prem_seq_no
               AND d.assd_no = f.assd_no
               AND g.tran_flag != 'D'
               AND c.inst_no = a.inst_no           --added by april 05.19.2009
               AND (   g.gibr_branch_cd IN (
                          SELECT DECODE (p_branch, 'OR', gibr_branch_cd)
                            FROM giac_acctrans
                           WHERE gibr_branch_cd =
                                             NVL (p_branch_cd, gibr_branch_cd)
                             AND check_user_per_iss_cd_acctg2 (NULL,
                                                               gibr_branch_cd,
                                                               p_module_id,
                                                               p_user
                                                              ) = 1)
                                                    --added by reymon 05162012
                    OR c.b140_iss_cd IN (
                          SELECT DECODE (p_branch, 'BI', b140_iss_cd)
                            FROM giac_direct_prem_collns
                           WHERE b140_iss_cd = NVL (p_branch_cd, b140_iss_cd)
                             AND check_user_per_iss_cd_acctg2 (NULL,
                                                               b140_iss_cd,
                                                               p_module_id,
                                                               p_user
                                                              ) = 1)
                                                    --added by reymon 05162012
                    OR d.cred_branch IN (
                          SELECT DECODE (p_branch, 'CB', cred_branch)
                            FROM gipi_polbasic
                           WHERE cred_branch = NVL (p_branch_cd, cred_branch)
                             AND check_user_per_iss_cd_acctg2 (NULL,
                                                               cred_branch,
                                                               p_module_id,
                                                               p_user
                                                              ) = 1)
                   )                                --added by reymon 05162012
               AND TRUNC (DECODE (UPPER (p_date_type),
                                  'T', g.tran_date,
                                  'P', g.posting_date
                                 )
                         )
                      BETWEEN NVL
                                (UPPER (v_from_date),
                                 (SELECT MIN
                                            (TRUNC
                                                  (DECODE (UPPER (p_date_type),
                                                           'T', tran_date,
                                                           'P', posting_date
                                                          )
                                                  )
                                            )
                                    FROM giac_acctrans)
                                )
                          AND v_to_date
                            --added by: jen 072605 -- aaron 100509 added trunc
               AND NOT EXISTS (
                      SELECT x.gacc_tran_id
                        FROM giac_reversals x, giac_acctrans y
                       WHERE x.reversing_tran_id = y.tran_id
                         AND y.tran_flag != 'D'
                         AND x.gacc_tran_id = a.gacc_tran_id)
          ORDER BY branch, h.dv_pref, h.dv_no, i.or_pref_suf,i.or_no, g.jv_pref_suff,  g.jv_no, g.tran_id, g.tran_date) -- Dren 04.27.2016 SR-5353
      LOOP
         v_rec.tran_id := i.tran_id;
         v_rec.tran_date := i.tran_date;
         v_rec.policy_number := i.policy_no;
         v_rec.reference_pol_no := i.reference_pol_no;
         v_rec.assured := i.assured;
         v_rec.inception_date := i.inception_date;
         v_rec.expiry_date := i.expiry_date;
         v_rec.bill_no := i.bill_no;
         v_rec.collection_amt := i.collection_amt;
         v_rec.premium_amt := i.premium_amt;
         v_rec.tax_amt := i.tax_amt;
         v_rec.bk_month := i.bk_month;
         v_rec.bk_year := i.bk_year;
         v_rec.branch := i.branch;
         
         BEGIN
            SELECT TRAN_ID 
              INTO v_or_no
              FROM TABLE(GIACR170_PKG.CF_1Formula(i.tran_id));           
            v_rec.or_no := v_or_no;
         END; -- Dren 04.27.2016 SR-5353
                  
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END populate_giacr170_details;

   FUNCTION cf_1formula (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN tran_id_tab PIPELINED
   IS
      v_rec   tran_id_type;
   BEGIN
      FOR i IN (SELECT dv_pref || '-' || dv_no ref_no
                  FROM giac_disb_vouchers
                 WHERE gacc_tran_id = p_tran_id)
      LOOP
         v_rec.tran_id := i.ref_no;
         PIPE ROW (v_rec);
      END LOOP;

      FOR i IN (SELECT or_pref_suf || '-' || or_no ref_no
                  FROM giac_order_of_payts
                 WHERE gacc_tran_id = p_tran_id)
      LOOP
         v_rec.tran_id := i.ref_no;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_rec.tran_id IS NULL
      THEN
         FOR i IN (SELECT jv_pref_suff || '-' || jv_no ref_no
                     FROM giac_acctrans
                    WHERE tran_id = p_tran_id)
         LOOP
            v_rec.tran_id := i.ref_no;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;
   END cf_1formula;

   FUNCTION cf_branch_nameformula (p_branch VARCHAR2)
      RETURN branch_tab PIPELINED
   IS
      v_rec   branch_type;
   BEGIN
      FOR i IN (SELECT branch_name
                  FROM giac_branches
                 WHERE branch_cd = p_branch)
      LOOP
         v_rec.branch := i.branch_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
END giacr170_pkg;
/



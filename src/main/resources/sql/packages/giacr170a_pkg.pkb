CREATE OR REPLACE PACKAGE BODY CPI.giacr170a_pkg
AS
   FUNCTION cf_comp_nameformula
      RETURN VARCHAR2
   IS
      comp_name   VARCHAR2 (100);
   BEGIN
      SELECT param_value_v
        INTO comp_name
        FROM giac_parameters
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
        FROM giac_parameters
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

   FUNCTION cf_titleformula (
      p_date_type   VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE
   )
      RETURN CHAR
   IS
      v_title   VARCHAR2 (200);
      v_date    VARCHAR2 (100);
   BEGIN
      IF UPPER (p_date_type) = 'T'
      THEN
         v_title := 'Transaction Date';
      ELSIF UPPER (p_date_type) = 'P'
      THEN
         v_title := 'Posting Date';
      END IF;

      BEGIN
         SELECT    ' from '
                || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
                || ' to '
                || TO_CHAR (p_to_date, 'fmMonth DD, YYYY')
           INTO v_date
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_date := NULL;
      END;

      RETURN (v_title || v_date);
   END;

   FUNCTION populate_giacr170a (
      p_date_type   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2
   )
      RETURN giacr170a_tab PIPELINED
   IS
      v_rec   giacr170a_type;
   BEGIN
      v_rec.company_name := cf_comp_nameformula;
      v_rec.company_address := cf_comp_addformula;
      v_rec.title :=
         cf_titleformula (p_date_type,
                          TO_DATE (p_from_date, 'MM/DD/YYYY'),
                          TO_DATE (p_to_date, 'MM/DD/YYYY')
                         );
      PIPE ROW (v_rec);
      RETURN;
   END populate_giacr170a;

   FUNCTION cf_evatformula (
      p_branch_cd   VARCHAR2,
      p_policy_no   VARCHAR2,
      p_date_type   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_ref_no      VARCHAR2
   )
      RETURN NUMBER
   IS
      v_evat        NUMBER;
      v_from_date   DATE   := TO_DATE (p_from_date, 'MM/DD/YYYY');
      v_to_date     DATE   := TO_DATE (p_to_date, 'MM/DD/YYYY');

      CURSOR cur1
      IS
         SELECT DISTINCT get_policy_no (d.policy_id) policy_no,
                         g.tax_amt evat, get_ref_no (b.tran_id) ref_no
                    FROM giac_advanced_payt a,
                         giac_acctrans b,
                         giac_direct_prem_collns c,
                         gipi_polbasic d,
                         gipi_invoice e,
                         giac_tax_collns g,
                         giis_assured f
                   WHERE a.gacc_tran_id = b.tran_id
                     AND a.gacc_tran_id = c.gacc_tran_id
                     AND a.iss_cd = c.b140_iss_cd
                     AND a.prem_seq_no = c.b140_prem_seq_no
                     AND d.policy_id = e.policy_id
                     AND c.b140_iss_cd = e.iss_cd
                     AND c.b140_prem_seq_no = e.prem_seq_no
                     AND d.assd_no = f.assd_no
                     AND c.gacc_tran_id = g.gacc_tran_id
                     AND c.b140_iss_cd = g.b160_iss_cd
                     AND c.b140_prem_seq_no = g.b160_prem_seq_no
                     AND c.inst_no = g.inst_no
                     AND d.cred_branch = NVL (p_branch_cd, d.cred_branch)
                     AND g.b160_tax_cd = giacp.n ('EVAT')
                     AND get_policy_no (d.policy_id) = p_policy_no
                     AND a.batch_gacc_tran_id IN (
                            SELECT tran_id
                              FROM giac_acctrans
                             WHERE tran_class = 'PPR'
                               AND tran_flag <> 'D'
                               AND TRUNC (DECODE (p_date_type,
                                                  'T', tran_date,
                                                  'P', posting_date
                                                 )
                                         ) BETWEEN v_from_date AND v_to_date);

      evat          NUMBER := 0;
   BEGIN
      FOR a IN cur1
      LOOP
         IF a.policy_no = p_policy_no AND a.ref_no = p_ref_no
         THEN
            v_evat := a.evat;
         END IF;
      END LOOP;

      RETURN (v_evat);
   END;

   FUNCTION populate_giacr170a_details (
      p_date_type   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2
   )
      RETURN giacr170a_details_tab PIPELINED
   IS
      v_rec         giacr170a_details_type;
      v_from_date   DATE               := TO_DATE (p_from_date, 'MM/DD/YYYY');
      v_to_date     DATE                 := TO_DATE (p_to_date, 'MM/DD/YYYY');
      branch        VARCHAR2 (50);
   BEGIN
      FOR i IN
         (SELECT DISTINCT get_ref_no (b.tran_id) ref_no,
                          DECODE (p_date_type,
                                  'P', b.posting_date,
                                  'T', b.tran_date
                                 ) date_decode,
                          get_policy_no (d.policy_id) policy_no, f.assd_name,
                          d.incept_date, d.expiry_date,
                          a.iss_cd || '-' || a.prem_seq_no bill_no,
                          c.premium_amt, c.tax_amt,
                          (a.booking_mth || ' ' || a.booking_year
                          ) booking_date,
                          d.cred_branch
                     FROM giac_advanced_payt a,
                          giac_acctrans b,
                          giac_direct_prem_collns c,
                          gipi_polbasic d,
                          gipi_invoice e,
                          giis_assured f
                    WHERE a.gacc_tran_id = b.tran_id
                      AND a.gacc_tran_id = c.gacc_tran_id
                      AND a.iss_cd = c.b140_iss_cd
                      AND a.prem_seq_no = c.b140_prem_seq_no
                      AND d.policy_id = e.policy_id
                      AND c.b140_iss_cd = e.iss_cd
                      AND c.b140_prem_seq_no = e.prem_seq_no
                      AND d.assd_no = f.assd_no
                      AND d.cred_branch = NVL (p_branch_cd, d.cred_branch)
                      AND a.batch_gacc_tran_id IN (
                             SELECT tran_id
                               FROM giac_acctrans
                              WHERE tran_class = 'PPR'
                                AND tran_flag <> 'D'
                                AND TRUNC (DECODE (p_date_type,
                                                   'P', posting_date,
                                                   'T', tran_date
                                                  )
                                          ) BETWEEN v_from_date AND v_to_date)
                 ORDER BY policy_no)
      LOOP
         v_rec.ref_no := i.ref_no;
         v_rec.date_decode := i.date_decode;
         v_rec.policy_no := i.policy_no;
         v_rec.assd_name := i.assd_name;
         v_rec.incept_date := i.incept_date;
         v_rec.expiry_date := i.expiry_date;
         v_rec.bill_no := i.bill_no;
         v_rec.premium_amt := i.premium_amt;
         v_rec.tax_amt := i.tax_amt;
         v_rec.booking_date := i.booking_date;
         v_rec.cred_branch := i.cred_branch;
         v_rec.evat :=
            cf_evatformula (p_branch_cd,
                            i.policy_no,
                            p_date_type,
                            p_from_date,
                            p_to_date,
                            i.ref_no
                           );

         FOR j IN (SELECT branch_name
                     FROM giac_branches
                    WHERE branch_cd = i.cred_branch)
         LOOP
            v_rec.branch_name := j.branch_name;
            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END populate_giacr170a_details;
END giacr170a_pkg;
/



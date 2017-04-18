CREATE OR REPLACE PACKAGE BODY CPI.extract_soa_rep2_pkg
IS
/*
**  Created by :    Steven Ramirez
**  Date Created:   08.28.2014
**  The most boring thing in the world... Silence.
*/
   FUNCTION validates (
      p_date_as_of       DATE DEFAULT NULL,
      p_book_tag         VARCHAR2 DEFAULT NULL,
      p_incep_tag        VARCHAR2 DEFAULT NULL,
      p_issue_tag        VARCHAR2 DEFAULT NULL,
      p_rep_date         VARCHAR2 DEFAULT NULL,
      p_acct_ent_date    DATE DEFAULT NULL,
      p_book_date_fr     DATE DEFAULT NULL,
      p_book_date_to     DATE DEFAULT NULL,
      p_incept_date      DATE DEFAULT NULL,
      p_incept_date_fr   DATE DEFAULT NULL,
      p_incept_date_to   DATE DEFAULT NULL,
      p_issue_date_fr    DATE DEFAULT NULL,
      p_issue_date_to    DATE DEFAULT NULL,
      p_special_pol      VARCHAR2 DEFAULT NULL,
      p_branch_param     VARCHAR2 DEFAULT NULL,
      p_issue_date       DATE DEFAULT NULL
   )
      RETURN NUMBER
   IS
   BEGIN
      IF     TRUNC (p_acct_ent_date) <= p_date_as_of
         AND p_book_tag = 'Y'
         AND p_incep_tag = 'N'
         AND p_issue_tag = 'N'
         AND p_rep_date = 'A'
      THEN
         RETURN v_true;
      ELSIF     TRUNC (p_acct_ent_date) BETWEEN p_book_date_fr AND p_book_date_to
            AND p_book_tag = 'Y'
            AND p_incep_tag = 'N'
            AND p_issue_tag = 'N'
            AND p_rep_date = 'F'
      THEN
         RETURN v_true;
      ELSIF     TRUNC (p_incept_date) <= p_date_as_of
            AND p_book_tag = 'N'
            AND p_incep_tag = 'Y'
            AND p_issue_tag = 'N'
            AND p_rep_date = 'A'
      THEN
         RETURN v_true;
      ELSIF     TRUNC (p_incept_date) BETWEEN p_incept_date_fr
                                          AND p_incept_date_to
            AND p_book_tag = 'N'
            AND p_incep_tag = 'Y'
            AND p_issue_tag = 'N'
            AND p_rep_date = 'F'
      THEN
         RETURN v_true;
      ELSIF     TRUNC (p_issue_date) <= p_date_as_of
            AND p_book_tag = 'N'
            AND p_incep_tag = 'N'
            AND p_issue_tag = 'Y'
            AND p_rep_date = 'A'
      THEN
         RETURN v_true;
      ELSIF     TRUNC (p_issue_date) BETWEEN p_issue_date_fr AND p_issue_date_to
            AND p_book_tag = 'N'
            AND p_incep_tag = 'N'
            AND p_issue_tag = 'Y'
            AND p_rep_date = 'F'
      THEN
         RETURN v_true;
      ELSIF     TRUNC (p_acct_ent_date) <= p_date_as_of
            AND TRUNC (p_incept_date) <= p_date_as_of
            AND p_book_tag = 'Y'
            AND p_incep_tag = 'Y'
            AND p_issue_tag = 'N'
            AND p_rep_date = 'A'
      THEN
         RETURN v_true;
      ELSIF     TRUNC (p_acct_ent_date) BETWEEN p_book_date_fr AND p_book_date_to
            AND TRUNC (p_incept_date) BETWEEN p_incept_date_fr
                                          AND p_incept_date_to
            AND p_book_tag = 'Y'
            AND p_incep_tag = 'Y'
            AND p_issue_tag = 'N'
            AND p_rep_date = 'F'
      THEN
         RETURN v_true;
      ELSIF     TRUNC (p_acct_ent_date) <= p_date_as_of
            AND TRUNC (p_issue_date) <= p_date_as_of
            AND p_book_tag = 'Y'
            AND p_incep_tag = 'N'
            AND p_issue_tag = 'Y'
            AND p_rep_date = 'A'
      THEN
         RETURN v_true;
      ELSIF     TRUNC (p_acct_ent_date) BETWEEN p_book_date_fr AND p_book_date_to
            AND TRUNC (p_issue_date) BETWEEN p_issue_date_fr AND p_issue_date_to
            AND p_book_tag = 'Y'
            AND p_incep_tag = 'N'
            AND p_issue_tag = 'Y'
            AND p_rep_date = 'F'
      THEN
         RETURN v_true;
      ELSE
         RETURN v_false;
      END IF;
   END;

   FUNCTION get_list (
      p_date_as_of       DATE DEFAULT NULL,
      p_book_tag         VARCHAR2 DEFAULT NULL,
      p_incep_tag        VARCHAR2 DEFAULT NULL,
      p_issue_tag        VARCHAR2 DEFAULT NULL,
      p_rep_date         VARCHAR2 DEFAULT NULL,
      p_book_date_fr     DATE DEFAULT NULL,
      p_book_date_to     DATE DEFAULT NULL,
      p_incept_date_fr   DATE DEFAULT NULL,
      p_incept_date_to   DATE DEFAULT NULL,
      p_issue_date_fr    DATE DEFAULT NULL,
      p_issue_date_to    DATE DEFAULT NULL,
      p_special_pol      VARCHAR2 DEFAULT NULL,
      p_branch_param     VARCHAR2 DEFAULT NULL
   )
      RETURN tab PIPELINED
   IS
      CURSOR c1
      IS
         SELECT a.policy_id, get_policy_no (a.policy_id) policy_no,
                a.assd_no, a.cred_branch, a.line_cd, a.subline_cd, a.iss_cd,
                a.issue_yy, a.renew_no, a.pol_seq_no, b.line_name,
                a.acct_ent_date, a.ref_pol_no, a.incept_date, a.issue_date,
                a.spld_date, a.pol_flag, a.eff_date, a.expiry_date,
                DECODE ((SELECT 'X' endt_tax_count
                           FROM gipi_endttext
                          WHERE policy_id = a.policy_id AND endt_tax = 'Y'),
                        'X', (SELECT policy_id
                                FROM gipi_polbasic
                               WHERE line_cd = a.line_cd
                                 AND subline_cd = a.subline_cd
                                 AND iss_cd = a.iss_cd
                                 AND issue_yy = a.issue_yy
                                 AND renew_no = a.renew_no
                                 AND pol_seq_no = a.pol_seq_no
                                 AND endt_seq_no = 0),
                        a.policy_id
                       ) policy_id2,
                NULL assd_no2, NULL assd_name2, a.reg_policy_sw, a.endt_type, a.SPLD_ACCT_ENT_DATE
           FROM gipi_polbasic a, giis_line b, gipi_parlist c, giis_subline d
          WHERE a.line_cd = b.line_cd
            AND b.line_cd = d.line_cd
            AND a.line_cd = d.line_cd
            AND a.subline_cd = d.subline_cd
            AND a.par_id = c.par_id
            AND a.policy_id >= 0
            AND c.par_id >= 0
            AND a.iss_cd != 'RI'
            AND d.op_flag != 'Y'
            AND extract_soa_rep2_pkg.validates (p_date_as_of,
                                                p_book_tag,
                                                p_incep_tag,
                                                p_issue_tag,
                                                p_rep_date,
                                                a.acct_ent_date,
                                                p_book_date_fr,
                                                p_book_date_to,
                                                a.incept_date,
                                                p_incept_date_fr,
                                                p_incept_date_to,
                                                p_issue_date_fr,
                                                p_issue_date_to,
                                                p_special_pol,
                                                p_branch_param,
                                                a.issue_date
                                               ) = 1;

      v_rec   rec;

      PROCEDURE get_assd_info
      IS
      BEGIN
         SELECT z.assd_name, y.assd_no
           INTO v_rec.assd_name, v_rec.assd_no2
           FROM gipi_polbasic x, gipi_parlist y, giis_assured z
          WHERE x.par_id = y.par_id
            AND y.assd_no = z.assd_no
            AND x.line_cd = v_rec.line_cd
            AND x.subline_cd = v_rec.subline_cd
            AND x.iss_cd = v_rec.iss_cd
            AND x.issue_yy = v_rec.issue_yy
            AND x.renew_no = v_rec.renew_no
            AND x.pol_seq_no = v_rec.pol_seq_no
            AND x.endt_seq_no =
                   (SELECT MAX (endt_seq_no)
                      FROM gipi_polbasic
                     WHERE line_cd = v_rec.line_cd
                       AND subline_cd = v_rec.subline_cd
                       AND iss_cd = v_rec.iss_cd
                       AND issue_yy = v_rec.issue_yy
                       AND renew_no = v_rec.renew_no
                       AND pol_seq_no = v_rec.pol_seq_no);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;
   BEGIN
      OPEN c1;

      LOOP
         FETCH c1
          INTO v_rec;

         get_assd_info;
         EXIT WHEN c1%NOTFOUND;
         PIPE ROW (v_rec);
         NULL;
      END LOOP;

      CLOSE c1;
   END;
END;
/



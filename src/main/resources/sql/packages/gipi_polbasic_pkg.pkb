CREATE OR REPLACE PACKAGE BODY CPI.gipi_polbasic_pkg
AS
   FUNCTION get_gipi_polbasic (
      p_line_cd       gipi_polbasic.line_cd%TYPE, 
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,                            
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy       gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      p_eff_date      gipi_polbasic.eff_date%TYPE,
      p_expiry_date   gipi_polbasic.expiry_date%TYPE
   )
      RETURN gipi_polbasic_tab PIPELINED
   IS
      v_polbasic   gipi_polbasic_type;
   BEGIN
      FOR i IN (SELECT   a.par_id, a.line_cd, a.subline_cd, a.iss_cd,
                         a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd,
                         a.endt_yy, a.endt_seq_no, a.eff_date, a.expiry_date,
                         a.assd_no, b.assd_name, c.dist_no, a.dist_flag,
                         a.policy_id
                    FROM gipi_polbasic a,
                         giis_assured b,
                         gipi_polbasic_pol_dist_v c
                   WHERE EXISTS (SELECT 'A'
                                   FROM gipi_polbasic_pol_dist_v v
                                  WHERE v.policy_id = a.policy_id)
                     AND a.assd_no = b.assd_no
                     AND a.policy_id = c.policy_id
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
                     AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
                     AND a.renew_no = NVL (p_renew_no, a.renew_no)
                     AND a.endt_iss_cd = NVL (p_endt_iss_cd, a.endt_iss_cd)
                     AND a.endt_yy = NVL (p_endt_yy, a.endt_yy)
                     AND a.endt_seq_no = NVL (p_endt_seq_no, a.endt_seq_no)
                     AND TO_CHAR (a.eff_date, 'MM-DD-RRRR') =
                            NVL (TO_CHAR (p_eff_date, 'MM-DD-RRRR'),
                                 TO_CHAR (a.eff_date, 'MM-DD-RRRR')
                                )
                     AND a.expiry_date = NVL (p_expiry_date, a.expiry_date)
                ORDER BY line_cd,
                         subline_cd,
                         iss_cd,
                         issue_yy,
                         pol_seq_no,
                         renew_no)
      LOOP
         v_polbasic.par_id := i.par_id;
         v_polbasic.line_cd := i.line_cd;
         v_polbasic.subline_cd := i.subline_cd;
         v_polbasic.iss_cd := i.iss_cd;
         v_polbasic.issue_yy := i.issue_yy;
         v_polbasic.pol_seq_no := i.pol_seq_no;
         v_polbasic.renew_no := i.renew_no;
         v_polbasic.endt_iss_cd := i.endt_iss_cd;
         v_polbasic.endt_yy := i.endt_yy;
         v_polbasic.endt_seq_no := i.endt_seq_no;
         v_polbasic.eff_date := i.eff_date;
         v_polbasic.expiry_date := i.expiry_date;
         v_polbasic.assd_no := i.assd_no;
         v_polbasic.assd_name := i.assd_name;
         v_polbasic.dist_no := i.dist_no;
         v_polbasic.dist_flag := i.dist_flag;
         v_polbasic.policy_id := i.policy_id;
         PIPE ROW (v_polbasic);
      END LOOP;

      RETURN;
   END get_gipi_polbasic;

   FUNCTION get_gipi_polbasic (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_keyword IN VARCHAR2
   )
      RETURN gipi_polbasic_tab2 PIPELINED
   IS
      v_polbasic   gipi_polbasic_type2;
   BEGIN
      FOR i IN (SELECT   a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                         a.issue_yy, a.pol_seq_no, a.renew_no, a.par_id,
                         a.endt_iss_cd, a.pol_flag, a.pack_pol_flag,
                         a.co_insurance_sw, a.acct_ent_date, a.assd_no,
                         a.prorate_flag, a.short_rt_percent, a.prov_prem_pct,
                         a.endt_yy, a.endt_seq_no, a.eff_date, a.expiry_date,
                         b.assd_name, a.incept_date, a.issue_date,
                         a.booking_mth, a.booking_year, d.ri_name, d.ri_cd
                    FROM gipi_polbasic a,
                         giis_assured b,
                         giri_inpolbas c,
                         giis_reinsurer d
                   WHERE a.iss_cd IN (SELECT e.param_value_v
                                        FROM giis_parameters e
                                       WHERE e.param_name = 'ISS_CD_RI')
                     AND b.assd_no IN (SELECT f.assd_no
                                         FROM gipi_parlist f
                                        WHERE f.par_id = a.par_id)
                     AND a.pol_flag IN ('1', '2', '3')
                     AND a.assd_no = b.assd_no
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
                     AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
                     AND a.renew_no = NVL (p_renew_no, a.renew_no)
                     AND a.policy_id = c.policy_id
                     AND c.ri_cd = d.ri_cd
                     AND (subline_cd LIKE UPPER ('%' || p_keyword || '%')
                         OR iss_cd LIKE UPPER ('%' || p_keyword || '%')
                         OR issue_yy LIKE UPPER ('%' || p_keyword || '%')
                         OR pol_seq_no LIKE UPPER ('%' || p_keyword || '%')
                         OR renew_no LIKE UPPER ('%' || p_keyword || '%'))
                ORDER BY line_cd,
                         subline_cd,
                         iss_cd,
                         issue_yy,
                         pol_seq_no,
                         renew_no)
      LOOP
         IF NVL (i.endt_seq_no, 0) = 0
         THEN
            v_polbasic.endt_iss_cd := NULL;
            v_polbasic.endt_yy := NULL;
            v_polbasic.endt_seq_no := NULL;
         ELSE
            v_polbasic.endt_iss_cd := i.endt_iss_cd;
            v_polbasic.endt_yy := i.endt_yy;
            v_polbasic.endt_seq_no := i.endt_seq_no;
         END IF;

         v_polbasic.par_id := i.par_id;
         v_polbasic.line_cd := i.line_cd;
         v_polbasic.subline_cd := i.subline_cd;
         v_polbasic.iss_cd := i.iss_cd;
         v_polbasic.issue_yy := i.issue_yy;
         v_polbasic.pol_seq_no := i.pol_seq_no;
         v_polbasic.renew_no := i.renew_no;
         v_polbasic.eff_date := i.eff_date;
         v_polbasic.expiry_date := i.expiry_date;
         v_polbasic.assd_no := i.assd_no;
         v_polbasic.assd_name := i.assd_name;
         v_polbasic.policy_id := i.policy_id;
         v_polbasic.incept_date := i.incept_date;
         v_polbasic.acct_ent_date := i.acct_ent_date;
         v_polbasic.issue_date := i.issue_date;
         v_polbasic.booking_mth := i.booking_mth;
         v_polbasic.booking_year := i.booking_year;
         v_polbasic.ri_name := i.ri_name;
         v_polbasic.pol_flag := i.pol_flag;
         v_polbasic.pack_pol_flag := i.pack_pol_flag;
         v_polbasic.co_insurance_sw := i.co_insurance_sw;
         v_polbasic.prorate_flag := i.prorate_flag;
         v_polbasic.short_rt_percent := i.short_rt_percent;
         v_polbasic.prov_prem_pct := i.prov_prem_pct;
         v_polbasic.ri_cd := i.ri_cd;
         PIPE ROW (v_polbasic);
      END LOOP;

      RETURN;
   END get_gipi_polbasic;

   --for GIUTS024
   FUNCTION get_gipi_polbasic2 (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN gipi_polbasic_tab2 PIPELINED
   IS
      v_polbasic   gipi_polbasic_type2;
   BEGIN
      FOR i IN (SELECT   a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                         a.issue_yy, a.pol_seq_no, a.renew_no, a.par_id,
                         a.endt_iss_cd, a.pol_flag, a.assd_no, a.endt_yy,
                         a.endt_seq_no, a.eff_date, a.expiry_date,
                         b.assd_name
                    FROM gipi_polbasic a, giis_assured b, gipi_parlist c
                   WHERE c.par_id = a.par_id
                     AND b.assd_no = c.assd_no
                     AND a.pol_flag IN ('1', '2', '3')
                     AND NVL (endt_seq_no, 0) > 0
                     AND NVL (endt_type, 'N') = 'N'
                     AND EXISTS (
                            SELECT '1'
                              FROM gipi_polbasic l,
                                   giuw_pol_dist m,
                                   giri_distfrps n
                             WHERE l.line_cd = a.line_cd
                               AND l.subline_cd = a.subline_cd
                               AND l.iss_cd = a.iss_cd
                               AND l.issue_yy = a.issue_yy
                               AND l.pol_seq_no = a.pol_seq_no
                               AND l.renew_no = a.renew_no
                               AND l.pol_flag IN ('1', '2', '3')
                               AND l.policy_id = m.policy_id
                               AND n.dist_no = n.dist_no
                               AND n.ri_flag <> '4')
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
                     AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
                     AND a.renew_no = NVL (p_renew_no, a.renew_no)
                ORDER BY line_cd,
                         subline_cd,
                         iss_cd,
                         issue_yy,
                         pol_seq_no,
                         endt_iss_cd,
                         endt_yy,
                         endt_seq_no)
      LOOP
         IF i.endt_seq_no = 0
         THEN
            v_polbasic.endt_iss_cd := NULL;
            v_polbasic.endt_yy := NULL;
            v_polbasic.endt_seq_no := NULL;
         ELSE
            v_polbasic.endt_iss_cd := i.endt_iss_cd;
            v_polbasic.endt_yy := i.endt_yy;
            v_polbasic.endt_seq_no := i.endt_seq_no;
         END IF;

         v_polbasic.par_id := i.par_id;
         v_polbasic.line_cd := i.line_cd;
         v_polbasic.subline_cd := i.subline_cd;
         v_polbasic.iss_cd := i.iss_cd;
         v_polbasic.issue_yy := i.issue_yy;
         v_polbasic.pol_seq_no := i.pol_seq_no;
         v_polbasic.renew_no := i.renew_no;
         v_polbasic.eff_date := i.eff_date;
         v_polbasic.expiry_date := i.expiry_date;
         v_polbasic.assd_no := i.assd_no;
         v_polbasic.assd_name := i.assd_name;
         v_polbasic.policy_id := i.policy_id;
         v_polbasic.pol_flag := i.pol_flag;
         PIPE ROW (v_polbasic);
      END LOOP;

      RETURN;
   END get_gipi_polbasic2;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (CHECK_POLICY_FOR_RENEWAL)
**  Description : This is used to get the policy_id.
*/
   FUNCTION get_polid (
      p_line_cd      gipi_polbasic.line_cd%TYPE,   --used to get the policy_id
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      --used to get the policy_id
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,    --used to get the policy_id
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,  --used to get the policy_id
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      --used to get the policy_id
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )                                               --used to get the policy_id
      RETURN NUMBER
   IS
      v_pol_id   gipi_polbasic.policy_id%TYPE;
   BEGIN
      FOR i IN (SELECT policy_id
                  FROM gipi_polbasic
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
--                   AND p_renew_no = p_renew_no) modified by robert 12.06.12
                   AND renew_no = p_renew_no
                   ORDER BY endt_seq_no) --robert 12.06.12 added ORDER BY endt_seq_no
      LOOP
         v_pol_id := i.policy_id;
         EXIT;
      END LOOP;

      RETURN v_pol_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END get_polid;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (CHECK_POLICY_FOR_RENEWAL)
**  Description : This is used to get the pol_flag of the policy.
*/
   FUNCTION get_pol_flag (p_policy_id gipi_polbasic.policy_id%TYPE)
      --used to get the pol_flag
   RETURN gipi_polbasic.pol_flag%TYPE
   IS
      v_pol_flag   gipi_polbasic.pol_flag%TYPE;
   BEGIN
      FOR i IN (SELECT pol_flag
                  FROM gipi_polbasic
                 WHERE policy_id = p_policy_id)
      LOOP
         v_pol_flag := i.pol_flag;
      END LOOP;

      RETURN v_pol_flag;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END get_pol_flag;

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  February 24, 2010
**  Reference By : (OPEN POLICY)
**  Description : This is used to get ref_open_pol_no
*/
   FUNCTION get_ref_open_pol_no (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN gipi_polbasic.ref_open_pol_no%TYPE
   IS
      v_ref_open_pol_no   gipi_polbasic.ref_open_pol_no%TYPE;
   BEGIN
      FOR i IN (SELECT ref_open_pol_no
                  FROM gipi_polbasic
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no)
      LOOP
         v_ref_open_pol_no := i.ref_open_pol_no;
      END LOOP;

      RETURN v_ref_open_pol_no;
   END get_ref_open_pol_no;

   FUNCTION get_gipi_polbasic3 (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_assd_no       gipi_polbasic.assd_no%TYPE,
      p_incept_date   gipi_polbasic.incept_date%TYPE,
      p_expiry_date   gipi_polbasic.expiry_date%TYPE
   )
      RETURN gipi_polbasic_tab PIPELINED
   IS
      v_pol   gipi_polbasic_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.line_cd, a.subline_cd, a.iss_cd,
                                a.issue_yy, a.pol_seq_no, a.renew_no,
                                a.ref_pol_no, a.incept_date, a.expiry_date
                           FROM gipi_polbasic a
                          WHERE p_incept_date BETWEEN TRUNC (a.incept_date)
                                                  AND TRUNC (a.expiry_date)
                            AND p_expiry_date BETWEEN TRUNC (a.incept_date)
                                                  AND TRUNC (a.expiry_date)
                            AND a.assd_no = p_assd_no
                            AND a.line_cd = p_line_cd
                            AND a.pol_flag <> '5'
                            AND a.subline_cd IN (
                                   SELECT subline_cd
                                     FROM giis_subline
                                    WHERE line_cd = p_line_cd
                                          AND op_flag = 'Y')
                       ORDER BY a.line_cd,
                                a.subline_cd,
                                a.iss_cd,
                                a.issue_yy,
                                a.pol_seq_no,
                                a.renew_no ASC)
      LOOP
         v_pol.line_cd := i.line_cd;
         v_pol.subline_cd := i.subline_cd;
         v_pol.iss_cd := i.iss_cd;
         v_pol.issue_yy := i.issue_yy;
         v_pol.pol_seq_no := i.pol_seq_no;
         v_pol.renew_no := i.renew_no;
         v_pol.ref_pol_no := i.ref_pol_no;
         v_pol.incept_date := i.incept_date;
         v_pol.expiry_date := i.expiry_date;
         PIPE ROW (v_pol);
      END LOOP;

      RETURN;
   END get_gipi_polbasic3;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 05.27.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This procedure returns the eff_date and policy_id of the given policy_no
   */
   PROCEDURE get_eff_date_policy_id (
      p_line_cd      IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN       gipi_polbasic.renew_no%TYPE,
      p_eff_date     OUT      gipi_polbasic.eff_date%TYPE,
      p_policy_id    OUT      gipi_polbasic.policy_id%TYPE
   )
   IS
   BEGIN
      FOR x IN (SELECT b2501.eff_date eff_date, b2501.policy_id
                  FROM gipi_polbasic b2501
                 WHERE b2501.line_cd = p_line_cd
                   AND b2501.subline_cd = p_subline_cd
                   AND b2501.iss_cd = p_iss_cd
                   AND b2501.issue_yy = p_issue_yy
                   AND b2501.pol_seq_no = p_pol_seq_no
                   AND b2501.renew_no = p_renew_no
                   AND b2501.pol_flag IN ('1', '2', '3', 'X')
                   AND b2501.endt_seq_no = 0)
      LOOP
         p_eff_date := x.eff_date;
         p_policy_id := x.policy_id;
         EXIT;
      END LOOP;
   END get_eff_date_policy_id;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 05.27.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This function returns the maximum endt_seq_no of the given policy_no
   */
   FUNCTION get_max_endt_seq_no (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE,
      p_eff_date     IN   gipi_polbasic.eff_date%TYPE,
      p_field_name   IN   VARCHAR2
   )
      RETURN NUMBER
   IS
      TYPE cur_typ IS REF CURSOR;

      v_cur               cur_typ;
      v_query_str         VARCHAR2 (1000);
      v_max_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE;
   BEGIN
      v_query_str :=
         'SELECT MAX(endt_seq_no) endt_seq_no
                  FROM GIPI_POLBASIC b2501
                 WHERE b2501.line_cd    = :line_cd
                   AND b2501.subline_cd = :subline_cd
                   AND b2501.iss_cd     = :iss_cd
                   AND b2501.issue_yy   = :issue_yy
                   AND b2501.pol_seq_no = :pol_seq_no
                   AND b2501.renew_no   = :renew_no
                   AND b2501.pol_flag   IN (''1'',''2'',''3'',''X'') ';

      IF p_field_name = 'ADDRESS'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                   AND (b2501.address1 IS NOT NULL OR b2501.address2 IS NOT NULL OR    b2501.address3 IS NOT NULL)';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ADDRESS2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND TRUNC(b2501.eff_date) <= NVL(:eff_date,SYSDATE)
                   AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(:eff_date)
                   AND (b2501.address1 IS NOT NULL OR b2501.address2 IS NOT NULL OR b2501.address3 IS NOT NULL)';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ASSURED'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                   AND b2501.assd_no IS NOT NULL';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ASSURED2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND b2501.eff_date <= NVL(:eff_date, SYSDATE)
                   AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(:eff_date)
                   AND b2501.assd_no IS NOT NULL';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'SEARCH_FOR_POLICY2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND TRUNC(b2501.eff_date) <= TRUNC(NVL(:eff_date,SYSDATE))
                   AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(:eff_date)';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name IN
               ('COI_CANCELLATION', 'ENDT_CANCELLATION', 'FLAT_CANCELLATION')
      THEN
         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'PRORATE_CANCELLATION'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= :eff_date';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSE
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      END IF;

      RETURN v_max_endt_seq_no;
   END get_max_endt_seq_no;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 05.27.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This function returns the maximum endt_seq_no for backward endt. with updates
   */
   FUNCTION get_max_endt_seq_no_back_stat (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE,
      p_eff_date     IN   gipi_polbasic.eff_date%TYPE,
      p_field_name   IN   VARCHAR2
   )
      RETURN NUMBER
   IS
      TYPE cur_typ IS REF CURSOR;

      v_cur                cur_typ;
      v_query_str          VARCHAR2 (1000);
      v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE;
   BEGIN
      v_query_str :=
         'SELECT MAX(b2501.endt_seq_no) endt_seq_no
                  FROM GIPI_POLBASIC b2501
                 WHERE b2501.line_cd    = :line_cd
                   AND b2501.subline_cd = :subline_cd
                   AND b2501.iss_cd     = :iss_cd
                   AND b2501.issue_yy   = :issue_yy
                   AND b2501.pol_seq_no = :pol_seq_no
                   AND b2501.renew_no   = :renew_no
                   AND b2501.pol_flag   IN (''1'',''2'',''3'',''X'')';

      IF p_field_name = 'ADDRESS'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                   AND (b2501.address1 IS NOT NULL OR b2501.address2 IS NOT NULL OR b2501.address3 IS NOT NULL)
                   AND NVL(b2501.back_stat,5) = 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ADDRESS2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND b2501.eff_date <= :eff_date
                   AND TRUNC(NVL(b2501.endt_expiry_date, b2501.expiry_date)) >= TRUNC(:eff_date)
                   AND (b2501.address1 IS NOT NULL OR b2501.address2 IS NOT NULL OR b2501.address3 IS NOT NULL)
                   AND NVL(b2501.back_stat,5) = 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ASSURED'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                   AND b2501.assd_no IS NOT NULL
                   AND NVL(b2501.back_stat,5) = 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ASSURED2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND b2501.eff_date <= :eff_date
                   AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(:eff_date)
                   AND b2501.assd_no IS NOT NULL
                   AND NVL(b2501.back_stat,5) = 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'SEARCH_FOR_POLICY2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND TRUNC(b2501.eff_date) <= TRUNC(:eff_date)
                   AND TRUNC(NVL(b2501.endt_expiry_date, b2501.expiry_date)) >= TRUNC(:eff_date)
                   AND NVL(b2501.back_stat,5) = 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name IN
               ('COI_CANCELLATION', 'ENDT_CANCELLATION', 'FLAT_CANCELLATION')
      THEN
         v_query_str := v_query_str || '  AND NVL(b2501.back_stat,5) = 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'PRORATE_CANCELLATION'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= :eff_date
                   AND NVL(b2501.back_stat,5) = 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSE
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                   AND NVL(b2501.back_stat,5) = 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_endt_seq_no1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      END IF;

      RETURN v_max_endt_seq_no1;
   END get_max_endt_seq_no_back_stat;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 05.27.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This function returns the maximum endt_seq_no for backward endt. with updates
   */
   FUNCTION get_max_eff_date_back_stat (
      p_line_cd            IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd         IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd             IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no         IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no           IN   gipi_polbasic.renew_no%TYPE,
      p_eff_date           IN   gipi_polbasic.eff_date%TYPE,
      p_max_endt_seq_no1   IN   gipi_polbasic.endt_seq_no%TYPE,
      p_field_name         IN   VARCHAR2
   )
      RETURN DATE
   IS
      TYPE cur_typ IS REF CURSOR;

      v_cur             cur_typ;
      v_query_str       VARCHAR2 (1000);
      v_max_eff_date1   gipi_wpolbas.eff_date%TYPE;
   BEGIN
      v_query_str :=
         'SELECT MAX(b2501.eff_date) eff_date
                  FROM GIPI_POLBASIC b2501
                 WHERE b2501.line_cd    = :line_cd
                   AND b2501.subline_cd = :subline_cd
                   AND b2501.iss_cd     = :iss_cd
                   AND b2501.issue_yy   = :issue_yy
                   AND b2501.pol_seq_no = :pol_seq_no
                   AND b2501.renew_no   = :renew_no
                   AND b2501.pol_flag   IN (''1'',''2'',''3'',''X'')';

      IF p_field_name = 'ADDRESS'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                   AND NVL(b2501.back_stat,5) = 2
                   AND (b2501.address1 IS NOT NULL OR b2501.address2 IS NOT NULL OR b2501.address3 IS NOT NULL)
                   AND b2501.endt_seq_no = :max_endt_seq_no1';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_max_endt_seq_no1;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ADDRESS2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND b2501.eff_date   <= :eff_date
                   AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(:eff_date)
                   AND NVL(b2501.back_stat,5) = 2
                   AND (b2501.address1 IS NOT NULL OR b2501.address2 IS NOT NULL OR b2501.address3 IS NOT NULL)
                   AND b2501.endt_seq_no = :max_endt_seq_no1';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date,
               p_max_endt_seq_no1;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ASSURED'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                   AND NVL(b2501.back_stat,5) = 2
                   AND b2501.assd_no IS NOT NULL
                   AND b2501.endt_seq_no = :max_endt_seq_no1';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_max_endt_seq_no1;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ASSURED2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND b2501.eff_date   <= :eff_date
                   AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(:eff_date)
                   AND NVL(b2501.back_stat,5) = 2
                   AND b2501.assd_no IS NOT NULL
                   AND b2501.endt_seq_no = :max_endt_seq_no1';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date,
               p_max_endt_seq_no1;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'SEARCH_FOR_POLICY2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND TRUNC(b2501.eff_date) <= TRUNC(:eff_date)
                   AND TRUNC(NVL(b2501.endt_expiry_date, b2501.expiry_date)) >= TRUNC(:eff_date)
                   AND NVL(b2501.back_stat,5) = 2
                   AND b2501.endt_seq_no = :max_endt_seq_no1';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date,
               p_max_endt_seq_no1;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name IN
               ('COI_CANCELLATION', 'ENDT_CANCELLATION', 'FLAT_CANCELLATION')
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.back_stat,5) = 2
                   AND b2501.endt_seq_no = :max_endt_seq_no1';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_max_endt_seq_no1;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name IN
              ('COI_CANCELLATION2', 'ENDT_CANCELLATION2',
               'FLAT_CANCELLATION2')
      THEN
         v_query_str :=
               v_query_str
            || '  AND b2501.endt_seq_no != 0
                   AND NVL(b2501.back_stat,5) = 2
                   AND b2501.endt_seq_no = :max_endt_seq_no1';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_max_endt_seq_no1;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'PRORATE_CANCELLATION'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= :eff_date
                   AND NVL(b2501.back_stat,5) = 2
                   AND b2501.endt_seq_no = :max_endt_seq_no1';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_max_endt_seq_no1;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSE
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                   AND NVL(b2501.back_stat,5) = 2
                   AND b2501.endt_seq_no = :max_endt_seq_no1';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_max_endt_seq_no1;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date1;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      END IF;

      RETURN v_max_eff_date1;
   END get_max_eff_date_back_stat;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 05.27.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This function returns the maximum eff_date with the given policy_no
   */
   FUNCTION get_endt_max_eff_date (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE,
      p_eff_date     IN   gipi_polbasic.eff_date%TYPE,
      p_field_name   IN   VARCHAR2
   )
      RETURN DATE
   IS
      TYPE cur_typ IS REF CURSOR;

      v_cur             cur_typ;
      v_query_str       VARCHAR2 (1000);
      v_max_eff_date2   gipi_wpolbas.eff_date%TYPE;
   BEGIN
      v_query_str :=
         'SELECT MAX(b2501.eff_date) eff_date
                  FROM GIPI_POLBASIC b2501
                 WHERE b2501.line_cd    = :line_cd
                   AND b2501.subline_cd = :subline_cd
                   AND b2501.iss_cd     = :iss_cd
                   AND b2501.issue_yy   = :issue_yy
                   AND b2501.pol_seq_no = :pol_seq_no
                   AND b2501.renew_no   = :renew_no
                   AND b2501.pol_flag   IN (''1'',''2'',''3'',''X'')
                   AND b2501.endt_seq_no != 0';

      IF p_field_name = 'ADDRESS'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                   AND NVL(b2501.back_stat,5)!= 2
                   AND (b2501.address1 IS NOT NULL OR b2501.address2 IS NOT NULL OR b2501.address3 IS NOT NULL)';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date2;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ADDRESS2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND b2501.eff_date <= :eff_date
                   AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(:eff_date)
                   AND NVL(b2501.back_stat,5)!= 2
                   AND (b2501.address1 IS NOT NULL OR b2501.address2 IS NOT NULL OR b2501.address3 IS NOT NULL)';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date2;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ASSURED'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                   AND NVL(b2501.back_stat,5)!= 2
                   AND b2501.assd_no IS NOT NULL';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date2;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'ASSURED2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND b2501.eff_date <= :eff_date
                   AND TRUNC(NVL(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(:eff_date)
                   AND NVL(b2501.back_stat,5)!= 2
                   AND b2501.assd_no IS NOT NULL';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date2;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'SEARCH_FOR_POLICY2'
      THEN
         v_query_str :=
               v_query_str
            || '  AND TRUNC(b2501.eff_date) <= TRUNC(:eff_date)
                   AND TRUNC(NVL(b2501.endt_expiry_date, b2501.expiry_date)) >= TRUNC(:eff_date)
                   AND NVL(b2501.back_stat, 5)!= 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date2;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name IN
               ('COI_CANCELLATION', 'ENDT_CANCELLATION', 'FLAT_CANCELLATION')
      THEN
         v_query_str := v_query_str || '  AND NVL(b2501.back_stat,5)!= 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date2;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF p_field_name = 'PRORATE_CANCELLATION'
      THEN
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= :eff_date
                   AND NVL(b2501.back_stat,5)!= 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_eff_date;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date2;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSE
         v_query_str :=
               v_query_str
            || '  AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                   AND NVL(b2501.back_stat,5)!= 2';

         OPEN v_cur FOR v_query_str
         USING p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no;

         LOOP
            FETCH v_cur
             INTO v_max_eff_date2;

            EXIT;
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      END IF;

      RETURN v_max_eff_date2;
   END get_endt_max_eff_date;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 05.27.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This procedure returns the address of the given policy_no
   */
   PROCEDURE get_address_for_endt (
      p_line_cd      IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN       gipi_polbasic.renew_no%TYPE,
      p_eff_date     IN       gipi_polbasic.eff_date%TYPE,
      p_address1     OUT      gipi_polbasic.address1%TYPE,
      p_address2     OUT      gipi_polbasic.address2%TYPE,
      p_address3     OUT      gipi_polbasic.address3%TYPE
   )
   IS
   BEGIN
      FOR a1 IN (SELECT   b2501.address1, b2501.address2, b2501.address3
                     FROM gipi_polbasic b2501
                    WHERE b2501.line_cd = p_line_cd
                      AND b2501.subline_cd = p_subline_cd
                      AND b2501.iss_cd = p_iss_cd
                      AND b2501.issue_yy = p_issue_yy
                      AND b2501.pol_seq_no = p_pol_seq_no
                      AND b2501.renew_no = p_renew_no
                      AND b2501.pol_flag IN ('1', '2', '3', 'X')
                      AND b2501.eff_date = p_eff_date
                      AND (   b2501.address1 IS NOT NULL
                           OR b2501.address2 IS NOT NULL
                           OR b2501.address3 IS NOT NULL
                          )
                 ORDER BY b2501.endt_seq_no DESC)
      LOOP
         p_address1 := a1.address1;
         p_address2 := a1.address2;
         p_address3 := a1.address3;
         EXIT;
      END LOOP;
   END get_address_for_endt;

   /*
   **  Created by        : Emman
   **  Date Created     : 07.13.2010
   **  Reference By     : ( Endt Item Information)
   **  Description     : This procedure returns the address of the given policy_no, for new endt par item
   */
   PROCEDURE get_address_for_new_endt_item (
      p_line_cd       IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      IN       gipi_polbasic.renew_no%TYPE,
      p_eff_date      IN       gipi_polbasic.eff_date%TYPE,
      p_expiry_date   IN       gipi_polbasic.expiry_date%TYPE,
      p_address1      OUT      gipi_polbasic.address1%TYPE,
      p_address2      OUT      gipi_polbasic.address2%TYPE,
      p_address3      OUT      gipi_polbasic.address3%TYPE
   )
   IS
   BEGIN
      FOR c IN (SELECT   address1, address2, address3
                    FROM gipi_polbasic a
                   WHERE line_cd = p_line_cd
                     AND iss_cd = p_iss_cd
                     AND subline_cd = p_subline_cd
                     AND issue_yy = p_issue_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no
                     AND pol_flag IN ('1', '2', '3', 'X')
                     AND TRUNC (eff_date) <=
                            DECODE (NVL (a.endt_seq_no, 0),
                                    0, TRUNC (a.eff_date),
                                    TRUNC (p_eff_date)
                                   )
                     AND TRUNC (DECODE (NVL (a.endt_expiry_date,
                                             a.expiry_date),
                                        a.expiry_date, p_expiry_date,
                                        a.endt_expiry_date
                                       )
                               ) >= TRUNC (p_eff_date)
                     AND (   address1 IS NOT NULL
                          OR address2 IS NOT NULL
                          OR address3 IS NOT NULL
                         )
                ORDER BY eff_date DESC)
      LOOP
         p_address1 := c.address1;
         p_address2 := c.address2;
         p_address3 := c.address3;
      END LOOP;
   END get_address_for_new_endt_item;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 05.27.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This function returns the assd_no of the given policy_no
   */
   FUNCTION get_assd_no_for_endt (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE,
      p_eff_date     IN   gipi_polbasic.eff_date%TYPE
   )
      RETURN NUMBER
   IS
      v_assd_no   gipi_polbasic.assd_no%TYPE;
   BEGIN
      FOR a1 IN (SELECT   b2501.assd_no
                     FROM gipi_polbasic b2501
                    WHERE b2501.line_cd = p_line_cd
                      AND b2501.subline_cd = p_subline_cd
                      AND b2501.iss_cd = p_iss_cd
                      AND b2501.issue_yy = p_issue_yy
                      AND b2501.pol_seq_no = p_pol_seq_no
                      AND b2501.renew_no = p_renew_no
                      AND b2501.pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (b2501.eff_date) = TRUNC (p_eff_date)
                      AND b2501.assd_no IS NOT NULL
                 ORDER BY b2501.endt_seq_no DESC)
      LOOP
         v_assd_no := a1.assd_no;
         EXIT;
      END LOOP;

      RETURN v_assd_no;
   END get_assd_no_for_endt;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 05.27.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This procedure returns the ann_tsi_amt, ann_prem_amt, and p_amt_sw of the given policy_no
   */
   PROCEDURE get_amt_from_latest_endt (
      p_line_cd        IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN       gipi_polbasic.renew_no%TYPE,
      p_eff_date       IN       gipi_polbasic.eff_date%TYPE,
      p_field_name     IN       VARCHAR2,
      p_ann_tsi_amt    OUT      gipi_polbasic.ann_tsi_amt%TYPE,
      p_ann_prem_amt   OUT      gipi_polbasic.ann_prem_amt%TYPE,
      p_amt_sw         OUT      VARCHAR2
   )
   IS
   BEGIN
      p_amt_sw := 'N';

      IF p_field_name = 'SEARCH_FOR_POLICY2'
      THEN
         FOR amt IN (SELECT   b250.ann_tsi_amt, b250.ann_prem_amt
                         FROM gipi_polbasic b250
                        WHERE b250.line_cd = p_line_cd
                          AND b250.subline_cd = p_subline_cd
                          AND b250.iss_cd = p_iss_cd
                          AND b250.issue_yy = p_issue_yy
                          AND b250.pol_seq_no = p_pol_seq_no
                          AND b250.renew_no = p_renew_no
                          AND b250.pol_flag IN ('1', '2', '3', 'X')
                          AND NVL (b250.endt_seq_no, 0) > 0
                          AND b250.eff_date <= NVL (p_eff_date, SYSDATE)
                     ORDER BY b250.eff_date DESC, b250.endt_seq_no DESC)
         LOOP
            p_ann_tsi_amt := amt.ann_tsi_amt;
            p_ann_prem_amt := amt.ann_prem_amt;
            p_amt_sw := 'Y';
            EXIT;
         END LOOP;
      ELSIF p_field_name = 'SEARCH_FOR_POLICY'
      THEN
         FOR amt IN (SELECT   b250.ann_tsi_amt, b250.ann_prem_amt
                         FROM gipi_polbasic b250
                        WHERE b250.line_cd = p_line_cd
                          AND b250.subline_cd = p_subline_cd
                          AND b250.iss_cd = p_iss_cd
                          AND b250.issue_yy = p_issue_yy
                          AND b250.pol_seq_no = p_pol_seq_no
                          AND b250.renew_no = p_renew_no
                          AND b250.pol_flag IN ('1', '2', '3', 'X')
                          AND NVL (b250.endt_seq_no, 0) > 0
                          AND b250.eff_date =
                                 (SELECT MAX (b2501.eff_date)
                                    FROM gipi_polbasic b2501
                                   WHERE b2501.line_cd = p_line_cd
                                     AND b2501.subline_cd = p_subline_cd
                                     AND b2501.iss_cd = p_iss_cd
                                     AND b2501.issue_yy = p_issue_yy
                                     AND b2501.pol_seq_no = p_pol_seq_no
                                     AND b2501.renew_no = p_renew_no
                                     AND NVL (b2501.endt_seq_no, 0) > 0
                                     --AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                                     AND b2501.pol_flag IN
                                                         ('1', '2', '3', 'X'))
                     ORDER BY b250.endt_seq_no DESC)
         LOOP
            p_ann_tsi_amt := amt.ann_tsi_amt;
            p_ann_prem_amt := amt.ann_prem_amt;
            p_amt_sw := 'Y';
            EXIT;
         END LOOP;
      END IF;
   END get_amt_from_latest_endt;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 05.27.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This procedure returns the ann_tsi_amt, ann_prem_amt of the given policy_no who has no endt
   */
   PROCEDURE get_amt_from_pol_wout_endt (
      p_line_cd        IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN       gipi_polbasic.renew_no%TYPE,
      p_ann_tsi_amt    OUT      gipi_polbasic.ann_tsi_amt%TYPE,
      p_ann_prem_amt   OUT      gipi_polbasic.ann_prem_amt%TYPE
   )
   IS
   BEGIN
      FOR amt IN (SELECT b250.ann_tsi_amt, b250.ann_prem_amt
                    FROM gipi_polbasic b250
                   WHERE b250.line_cd = p_line_cd
                     AND b250.subline_cd = p_subline_cd
                     AND b250.iss_cd = p_iss_cd
                     AND b250.issue_yy = p_issue_yy
                     AND b250.pol_seq_no = p_pol_seq_no
                     AND b250.renew_no = p_renew_no
                     AND b250.pol_flag IN ('1', '2', '3', 'X')
                     AND NVL (b250.endt_seq_no, 0) = 0)
      LOOP
         p_ann_tsi_amt := amt.ann_tsi_amt;
         p_ann_prem_amt := amt.ann_prem_amt;
         EXIT;
      END LOOP;
   END get_amt_from_pol_wout_endt;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  June 1, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril Information)
**  Description  : Function that will return the computed number of days.
*/
   FUNCTION get_comp_no_of_days (p_par_id gipi_polbasic.line_cd%TYPE)
      RETURN NUMBER
   IS
      v_comp_no_of_days   NUMBER (3);
   BEGIN
      FOR i IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                       renew_no, expiry_date, incept_date
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
      LOOP
         FOR j IN (SELECT DISTINCT a.policy_id policy_id,
                                   TRUNC (a.incept_date) incept_date,
                                   TRUNC (a.expiry_date) expiry_date,
                                   a.endt_seq_no
                              FROM gipi_polbasic a
                             WHERE a.line_cd = i.line_cd
                               AND a.subline_cd = i.subline_cd
                               AND a.iss_cd = i.iss_cd
                               AND a.issue_yy = i.issue_yy
                               AND a.pol_seq_no = i.pol_seq_no
                               AND a.renew_no = i.renew_no
                               AND a.pol_flag NOT IN ('4', '5')
                          ORDER BY a.endt_seq_no DESC)
         LOOP
            v_comp_no_of_days :=
                 TRUNC (i.expiry_date - i.incept_date)
               - TRUNC (j.expiry_date - j.incept_date);
            EXIT;
         END LOOP;

         EXIT;
      END LOOP;

      RETURN v_comp_no_of_days;
   END get_comp_no_of_days;

/*
**  Created by   :  Emman
**  Date Created :  06.15.2010
**  Reference By : (GIPIS060 - Item Information)
**  Description  : Function that will return the effectivity date (in string format) if particular item has been endorsed.
*/
   FUNCTION get_back_endt_eff_date (
      p_par_id    gipi_wpolbas.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (100) := '';
   BEGIN
      FOR b540 IN (SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no,
                          renew_no, eff_date, expiry_date, endt_expiry_date
                     FROM gipi_wpolbas
                    WHERE par_id = p_par_id)
      LOOP
         FOR pol IN
            (SELECT   b250.policy_id
                 FROM gipi_polbasic b250
                WHERE b250.line_cd = b540.line_cd
                  AND b250.subline_cd = b540.subline_cd
                  AND b250.iss_cd = b540.iss_cd
                  AND b250.issue_yy = b540.issue_yy
                  AND b250.pol_seq_no = b540.pol_seq_no
                  AND b250.renew_no = b540.renew_no
                  AND TRUNC (b250.eff_date) > TRUNC (b540.eff_date)
                  AND b250.endt_seq_no > 0
                  AND b250.pol_flag IN ('1', '2', '3', 'X')
                  AND TRUNC (DECODE (NVL (b250.endt_expiry_date,
                                          b250.expiry_date
                                         ),
                                     b250.expiry_date, b540.expiry_date,
                                     b250.endt_expiry_date
                                    )
                            ) >= TRUNC (b540.eff_date)
                  AND EXISTS (
                         SELECT '1'
                           FROM gipi_item b340
                          WHERE b340.item_no = p_item_no
                            AND b340.policy_id = b250.policy_id)
             ORDER BY b250.eff_date DESC)
         LOOP
            v_date := TO_CHAR (b540.eff_date, 'fmMonth DD, YYYY');
            EXIT;
         END LOOP;
      END LOOP;

      RETURN v_date;
   END get_back_endt_eff_date;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 06.24.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This function checks if the policy_no entered is spoiled and return values based on the indicated condition
   */
   FUNCTION get_spoiled_flag (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_spld   VARCHAR2 (1) := 'N';
   BEGIN
      FOR tag IN (SELECT   spld_flag
                      FROM gipi_polbasic
                     WHERE line_cd = p_line_cd
                       AND subline_cd = p_subline_cd
                       AND iss_cd = p_iss_cd
                       AND issue_yy = p_issue_yy
                       AND pol_seq_no = p_pol_seq_no
                       AND renew_no = p_renew_no
                  ORDER BY eff_date DESC)
      LOOP
         IF tag.spld_flag = 2
         THEN
            v_spld := 'Y';
            EXIT;
         END IF;
      END LOOP;

      RETURN v_spld;
   END get_spoiled_flag;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 06.24.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This function checks if the policy_no entered is spoiled and return values based on the indicated condition
   */
   FUNCTION get_spoiled_flag1 (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_spld1   VARCHAR2 (1) := 'N';
   BEGIN
      FOR spld IN (SELECT spld_flag
                     FROM gipi_polbasic
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no
                      AND endt_seq_no = 0)
      LOOP
         IF spld.spld_flag = 3
         THEN
            v_spld1 := 'Y';
            EXIT;
         END IF;
      END LOOP;

      RETURN v_spld1;
   END get_spoiled_flag1;
   /*
   **  Created by        : Mark JM
   **  Date Created     : 06.25.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This function returns the ref_pol_no of the policy_no entered
   */
   FUNCTION get_ref_pol_no (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_ref_pol_no   gipi_polbasic.ref_pol_no%TYPE;
   BEGIN
      FOR ref_pol_no IN (SELECT   ref_pol_no
                             FROM gipi_polbasic
                            WHERE 1 = 1
                              AND line_cd = p_line_cd
                              AND subline_cd = p_subline_cd
                              AND iss_cd = p_iss_cd
                              AND issue_yy = p_issue_yy
                              AND pol_seq_no = p_pol_seq_no
                              AND renew_no = p_renew_no
                              AND ref_pol_no IS NOT NULL
                              AND pol_flag IN ('1', '2', '3', 'X')
                         ORDER BY eff_date DESC)
      LOOP
         v_ref_pol_no := ref_pol_no.ref_pol_no;
         EXIT;
      END LOOP;

      RETURN v_ref_pol_no;
   END get_ref_pol_no;

   FUNCTION get_polbasic_listing (p_par_id gipi_polbasic.par_id%TYPE)
      RETURN gipi_polbasic_tab1 PIPELINED
   IS
      v_pol                gipi_polbasic_type1;
      v_assd_no            giis_assured.assd_no%TYPE;
      v_assd_name          giis_assured.assd_name%TYPE;
      v_line_cd            gipi_parlist.line_cd%TYPE;
      v_iss_cd             gipi_parlist.iss_cd%TYPE;
      v_par_yy             gipi_parlist.par_yy%TYPE;
      v_par_seq_no         gipi_parlist.par_seq_no%TYPE;
      v_quote_seq_no       gipi_parlist.quote_seq_no%TYPE;
      v_line               giis_line.line_cd%TYPE;
      v_prem_amt           gipi_invoice.prem_amt%TYPE;
      v_chk_bill           VARCHAR2 (1);
      v_bill               gipi_invoice.prem_amt%TYPE;
      v_pack_bill          gipi_pack_invoice.prem_amt%TYPE;
      v_pack               giis_line.pack_pol_flag%TYPE;
      v_bill_not_printed   VARCHAR2 (1)                         := 'N';
      v_value              giis_parameters.param_value_v%TYPE;
      v_drv_endt_iss_cd    VARCHAR2 (50);
      v_exist              VARCHAR2 (1)                         := 'N';
      v_exist2             VARCHAR2 (1)                         := 'N';  --SR5761 10.18.2016 added by MarkS Optimization of print sample policy

      CURSOR a
      IS
         SELECT line_cd, iss_cd, par_yy, par_seq_no, quote_seq_no
           FROM gipi_parlist
          WHERE par_id = p_par_id;

      CURSOR b
      IS
         SELECT line_cd, iss_cd, par_yy, par_seq_no, quote_seq_no
           FROM gipi_pack_parlist
          WHERE pack_par_id = p_par_id;
   --ADDED BY VJ 091609
   BEGIN
      /*  --SR5761 10.18.2016 added by MarkS Optimization of print sample policy
      BEGIN
      SELECT 'Y' 
        INTO v_exist2
      FROM GIPI_POLBASIC
      WHERE par_id=p_par_id;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
      END;
      IF v_exist2 = 'Y' THEN*/ --Deo [01.30.2017]: comment out (SR-23765)
      FOR i IN (SELECT pack_policy_id, line_cd, subline_cd, iss_cd, issue_yy,
                       pol_seq_no, renew_no, endt_iss_cd, endt_yy,
                       endt_seq_no, policy_id, assd_no, endt_type, par_id,
                       no_of_items, pol_flag, co_insurance_sw,
                       fleet_print_tag, 0 pack_pol
                  FROM gipi_polbasic
                 WHERE pack_policy_id IS NULL
                   AND par_id = p_par_id 		--Deo [01.30.2017]: add condition (SR-23765)
                UNION ALL
                SELECT pack_policy_id, line_cd, subline_cd, iss_cd, issue_yy,
                       pol_seq_no, renew_no, endt_iss_cd, endt_yy,
                       endt_seq_no, pack_policy_id policy_id, assd_no,
                       endt_type, pack_par_id par_id, no_of_items, pol_flag,
                       co_insurance_sw, fleet_print_tag, 1 pack_pol
                  FROM gipi_pack_polbasic
                 WHERE pack_par_id = p_par_id)  --Deo [01.30.2017]: add condition (SR-23765)
      LOOP
         /*IF p_par_id = i.par_id
         THEN
            /*GETTING ASSURED VALUES*/
            /*FOR a IN (SELECT par_id
                        FROM gipi_polbasic
                       WHERE policy_id = i.policy_id)
            LOOP
               FOR b IN (SELECT assd_no
                           FROM gipi_parlist
                          WHERE par_id = a.par_id)
               LOOP
                  v_assd_no := b.assd_no;
                  EXIT;
               END LOOP;
            END LOOP;*/ --Deo [01.30.2017]: comment out (SR-23765)

            IF i.assd_no IS NULL
            THEN
               IF i.pack_pol = 1 		--Deo [01.30.2017]: SR-23765
	           THEN
	              FOR b1 IN (SELECT assd_no
	                           FROM gipi_pack_parlist
	                          WHERE pack_par_id = i.par_id)
	              LOOP
	                 v_assd_no := b1.assd_no;
	              END LOOP;
	           ELSE
	              FOR b2 IN (SELECT assd_no
	                           FROM gipi_parlist
	                          WHERE par_id = i.par_id)
	              LOOP
	                 v_assd_no := b2.assd_no;
	              END LOOP;
	           END IF;

               v_pol.assd_no := v_assd_no;
            ELSE
               v_pol.assd_no := i.assd_no;
            END IF;

            BEGIN
               SELECT assd_name
                 INTO v_pol.assd_name
                 FROM giis_assured
                WHERE assd_no = v_pol.assd_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            /*OBTAINING PAR_NO VALUES*/
            BEGIN
               SELECT NVL (menu_line_cd, line_cd) line_cd
                 INTO v_line
                 FROM giis_line
                WHERE line_cd = i.line_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            --IF v_line = 'PK' OR v_line = giis_line_pkg.get_menu_line_cd(v_line)   --edited by d.alcantara, 08-04-2011
            IF    v_line = 'PK'
               OR UPPER (giis_line_pkg.get_pack_pol_flag (v_line)) = 'Y'
            THEN
               OPEN b;

               FETCH b
                INTO v_line_cd, v_iss_cd, v_par_yy, v_par_seq_no,
                     v_quote_seq_no;

               IF b%NOTFOUND
               THEN
                  NULL;
               ELSE
                  v_pol.par_no :=
                        v_line_cd
                     || ' - '
                     || v_iss_cd
                     || ' - '
                     || TO_CHAR (v_par_yy, '09')
                     || ' - '
                     || TO_CHAR (v_par_seq_no, '099999')
                     || ' - '
                     || TO_CHAR (v_quote_seq_no, '09');
               END IF;

               CLOSE b;
            ELSE
               OPEN a;

               FETCH a
                INTO v_line_cd, v_iss_cd, v_par_yy, v_par_seq_no,
                     v_quote_seq_no;

               IF a%NOTFOUND
               THEN
                  NULL;
               ELSE
                  v_pol.par_no :=
                        v_line_cd
                     || ' - '
                     || v_iss_cd
                     || ' - '
                     || TO_CHAR (v_par_yy, '09')
                     || ' - '
                     || TO_CHAR (v_par_seq_no, '099999')
                     || ' - '
                     || TO_CHAR (v_quote_seq_no, '09');
               END IF;

               CLOSE a;
            END IF;

            /*CHK BILL?*/
            IF i.pol_flag IN ('1', '2', '3')
            THEN
               IF i.pack_pol = 1 --Deo [01.30.2017]: add start (SR-23765)
	           THEN
	              FOR prem IN (SELECT prem_amt
	                             FROM gipi_pack_invoice
	                            WHERE policy_id = i.policy_id)
	              LOOP
	                 v_prem_amt := prem.prem_amt;
	              END LOOP;
	           ELSE				--Deo [01.30.2017]: add ends (SR-23765)
               FOR prem IN (SELECT prem_amt
                              FROM gipi_invoice
                             WHERE policy_id = i.policy_id)
               LOOP
                  v_prem_amt := prem.prem_amt;
               END LOOP;
               END IF;			--Deo [01.30.2017]: close if (SR-23765)

               IF v_prem_amt < 0
               THEN
                  v_chk_bill := 'N';
               ELSE
                  v_chk_bill := 'Y';
               --:cg$ctrl.bill_radiogroup := 'N'; -- added by aaron 080409
               END IF;
            ELSE
               v_chk_bill := 'N';
            END IF;

            IF v_chk_bill = 'Y'
            THEN
               FOR a IN (SELECT pack_pol_flag
                           FROM giis_line
                          WHERE line_cd = i.line_cd)
               LOOP
                  v_pack := a.pack_pol_flag;
               END LOOP;

               FOR b IN (SELECT NVL (prem_amt, 0) + NVL (tax_amt, 0) amt
                           FROM gipi_invoice
                          WHERE policy_id = i.policy_id)
               LOOP
                  v_bill := NVL (b.amt, 0);
               END LOOP;

               FOR c IN (SELECT NVL (prem_amt, 0) + NVL (tax_amt, 0) amt
                           FROM gipi_pack_invoice
                          WHERE policy_id = i.policy_id)
               LOOP
                  v_pack_bill := NVL (c.amt, 0);
               END LOOP;

               BEGIN
                  SELECT param_value_v
                    INTO v_value
                    FROM giis_parameters
                   WHERE param_name = 'PRINT_BILL';
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NULL;
               END;

               IF v_pack = 'Y'
               THEN
                  IF v_pack_bill = 0
                  THEN
                     IF NVL (v_value, 'N') = 'N'
                     THEN                               --issa@cic 01.18.2007
                        --msg_alert('Total Amount Due is 0, bill will not be printed.', 'I', FALSE);
                        v_bill_not_printed := 'Y';
                        v_chk_bill := 'N';
                     END IF;                             --issa@cic 01.18.2007
                  END IF;
               ELSE
                  IF v_bill = 0
                  THEN
                     IF NVL (v_value, 'N') = 'N'
                     THEN                               --issa@cic 01.18.2007
                        --msg_alert('Total Amount Due is 0, bill will not be printed.', 'I', FALSE);
                        v_bill_not_printed := 'Y';
                        v_chk_bill := 'N';
                     END IF;                             --issa@cic 01.18.2007
                  END IF;
               END IF;
            END IF;

            /*POLICY_NO*/
            v_pol.policy_no :=
                  i.line_cd
               || ' - '
               || i.subline_cd
               || ' - '
               || i.iss_cd
               || ' - '
               || RTRIM (LTRIM (TO_CHAR (i.issue_yy, '09')))
               || ' - '
               || RTRIM (LTRIM (TO_CHAR (i.pol_seq_no, '0999999')))
               || ' - '
               || RTRIM (LTRIM (TO_CHAR (i.renew_no, '09')));

            /*ENDORSEMENT NO*/
            IF NVL (i.endt_seq_no, 0) <> 0
            THEN
               v_drv_endt_iss_cd :=
                     i.endt_iss_cd
                  || ' - '
                  || LTRIM (TO_CHAR (i.endt_yy, '09'))
                  || ' - '
                  || LTRIM (TO_CHAR (i.endt_seq_no, '099999'));
                  
               IF  i.endt_type IS NOT NULL  --SR 2577 lmbeltran 091115
               THEN 
                  v_drv_endt_iss_cd := 
                      v_drv_endt_iss_cd 
                   || ' - '
                   || i.endt_type;     
               END IF;
                 
            ELSE
               v_drv_endt_iss_cd := '0';
            END IF;

            IF v_drv_endt_iss_cd <> '0'
            THEN                     -- added condition by andrew - 04.15.2011
               v_pol.endt_no := v_pol.policy_no || ' - ' || v_drv_endt_iss_cd;
            END IF;

			IF i.pack_pol = 1			--Deo [01.30.2017]: add start (SR-23765)
	        THEN
	           FOR a IN (SELECT a.dist_no
	                       FROM giuw_pol_dist a, gipi_polbasic b
	                      WHERE b.pack_policy_id = i.policy_id
	                        AND a.policy_id = b.policy_id
	                        AND a.dist_flag = '3')
	           LOOP
	              FOR b IN (SELECT '1'
	                          FROM giuw_policyds_dtl
	                         WHERE dist_no = a.dist_no AND share_cd = '999')
	              LOOP
	                 v_exist := 'Y';
	                 EXIT;
	              END LOOP;
	              EXIT;
	           END LOOP;
	
	           BEGIN
	              SELECT DISTINCT NVL (endt_tax, 'N')
	                         INTO v_pol.endt_tax
	                         FROM gipi_endttext a, gipi_polbasic b
	                        WHERE b.pack_policy_id = i.policy_id
	                          AND a.policy_id = b.policy_id;
	           EXCEPTION
	              WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
	              THEN
	                 NULL;
	           END;
	
	           BEGIN
	              SELECT COUNT (1) num
	                INTO v_pol.itmperil_count
	                FROM gipi_itmperil a, gipi_polbasic b
	               WHERE b.pack_policy_id = i.policy_id
	                 AND a.policy_id = b.policy_id;
	           EXCEPTION
	              WHEN NO_DATA_FOUND
	              THEN
	                 NULL;
	           END;
	
	           FOR cd IN (SELECT '1'
	                        FROM giis_parameters a,
	                             giis_peril c,
	                             gipi_itmperil b,
	                             gipi_polbasic d
	                       WHERE a.param_name = 'COMPULSORY DEATH/BI'
	                         AND a.param_type = 'V'
	                         AND c.peril_sname = a.param_value_v
	                         AND b.tsi_amt > 0
	                         AND b.peril_cd = c.peril_cd
	                         AND b.policy_id = d.policy_id
	                         AND d.pack_policy_id = i.policy_id)
	           LOOP
	              v_pol.compulsory_death := 'Y';
	              EXIT;
	           END LOOP;
	        ELSE						--Deo [01.30.2017]: add ends (SR-23765)
            /*policy_ds_dtl_exist*/
            FOR a IN (SELECT dist_no
                        FROM giuw_pol_dist
                       WHERE policy_id = i.policy_id AND dist_flag = '3')
            LOOP
               FOR b IN (SELECT '1'
                           FROM giuw_policyds_dtl
                          WHERE dist_no = a.dist_no AND share_cd = '999')
               LOOP
                  v_exist := 'Y';
                  EXIT;
               END LOOP;

               EXIT;
            END LOOP;

            /*endt_tax*/
            BEGIN
               SELECT NVL (endt_tax, 'N')
                 INTO v_pol.endt_tax
                 FROM gipi_endttext
                WHERE policy_id = i.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            /*itmperil_count*/
            BEGIN
               SELECT COUNT (1) num
                 INTO v_pol.itmperil_count
                 FROM gipi_itmperil
                WHERE policy_id = i.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            /*compulsory_death*/
            v_pol.compulsory_death := 'N';

            FOR cd IN (SELECT '1'
                         FROM giis_parameters a, giis_peril c,
                              gipi_itmperil b
                        WHERE a.param_name = 'COMPULSORY DEATH/BI'
                          AND a.param_type = 'V'
                          AND c.peril_sname = a.param_value_v
                          AND b.tsi_amt > 0
                          AND b.peril_cd = c.peril_cd
                          AND b.policy_id = i.policy_id)
            LOOP
               v_pol.compulsory_death := 'Y';
            END LOOP;
            END IF;						--Deo [01.30.2017]: close if (SR-23765)

            /*coc_type*/
                        -- comment out by andrew - 05.16.2011

            -- returned by d.alcantara, 10-07-2011
            IF v_line = 'MC'
            THEN
               FOR v IN (SELECT coc_type
                           FROM gipi_vehicle
                          WHERE policy_id = i.policy_id)
               LOOP
                  v_pol.coc_type := v.coc_type;
               END LOOP;
            END IF;

            --pack_pol_flag
            BEGIN
               SELECT NVL (pack_pol_flag, 'N')
                 INTO v_pol.pack_pol_flag
                 FROM giis_line
                WHERE line_cd = i.line_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            v_pol.pack_policy_id := i.pack_policy_id;
            v_pol.line_cd := v_line; --i.line_cd; changed to v_line to get menu line cd Gzelle 11132014
            v_pol.subline_cd := i.subline_cd;
            v_pol.iss_cd := i.iss_cd;
            v_pol.issue_yy := i.issue_yy;
            v_pol.pol_seq_no := i.pol_seq_no;
            v_pol.renew_no := i.renew_no;
            v_pol.endt_iss_cd := i.endt_iss_cd;
            v_pol.endt_yy := i.endt_yy;
            v_pol.endt_seq_no := i.endt_seq_no;
            v_pol.policy_id := i.policy_id;
            v_pol.endt_type := i.endt_type;
            v_pol.par_id := i.par_id;
            v_pol.no_of_items := i.no_of_items;
            v_pol.pol_flag := i.pol_flag;
            v_pol.co_insurance_sw := i.co_insurance_sw;
            v_pol.fleet_print_tag := i.fleet_print_tag;
            v_pol.pack_pol := i.pack_pol;
            v_pol.bill_not_printed := v_bill_not_printed;
            v_pol.policy_ds_dtl_exist := v_exist;
            PIPE ROW (v_pol);
         /*ELSE
            NULL;
         END IF;*/ --Deo [01.30.2017]: comment out (SR-23765)
      END LOOP;
      --END IF; --SR5761 10.18.2016 added by MarkS Optimization of print sample policy --Deo [01.30.2017]: comment out (SR-23765)
      RETURN;
   END get_polbasic_listing;

/*
**  Created by   : Menandro G.C. Robes
**  Date Created : July 5, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril Information)
**  Description  : Function to retrieve endorsement policies' dates.
*/
   FUNCTION get_endt_policy (p_par_id gipi_wpolbas.par_id%TYPE)
      RETURN endt_policy_tab PIPELINED
   IS
      v_policy   endt_policy_type;
      
        CURSOR a1_cur IS
            SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                   renew_no, eff_date, expiry_date
              FROM gipi_wpolbas
             WHERE par_id = p_par_id;
             
        CURSOR b2_cur (p_line_cd varchar, p_subline_cd varchar, p_iss_cd varchar, p_issue_yy varchar, p_pol_seq_no number,
                        p_renew_no number, p_eff_date date, p_expiry_date date) IS
            SELECT line_cd, subline_cd, iss_cd, issue_yy,
                        pol_seq_no, renew_no, policy_id, incept_date,
                        eff_date, expiry_date, endt_expiry_date,
                        endt_iss_cd, endt_yy, endt_seq_no, pol_flag,
                           endt_iss_cd
                        || '-'
                        || TO_CHAR (endt_yy, '09')
                        || TO_CHAR (endt_seq_no, '099999') endt_no
                   FROM gipi_polbasic
                  WHERE line_cd = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND iss_cd = p_iss_cd
                    AND issue_yy = p_issue_yy
                    AND pol_seq_no = p_pol_seq_no
                    AND renew_no = p_renew_no
                    AND pol_flag IN ('1', '2', '3', 'X')
                    AND TRUNC (eff_date) <=
                           DECODE (NVL (endt_seq_no, 0),
                                   0, TRUNC (eff_date),
                                   TRUNC (p_eff_date)
                                  )
                    AND TRUNC (DECODE (NVL (endt_expiry_date, expiry_date),
                                       expiry_date, p_expiry_date,
                                       endt_expiry_date
                                      )
                              ) >= TRUNC (p_eff_date)
               ORDER BY eff_date DESC;
      
      TYPE wpolbas_row IS RECORD(
            line_cd         gipi_wpolbas.line_cd%TYPE,
            subline_cd      gipi_wpolbas.subline_cd%TYPE,
            iss_cd          gipi_wpolbas.iss_cd%TYPE,
            issue_yy        gipi_wpolbas.issue_yy%TYPE,
            pol_seq_no      gipi_wpolbas.pol_seq_no%TYPE,
            renew_no        gipi_wpolbas.renew_no%TYPE,
            eff_date        gipi_wpolbas.eff_date%TYPE,
            expiry_date     gipi_wpolbas.expiry_date%TYPE
        );
        TYPE wpolbas_tab IS TABLE OF wpolbas_row INDEX BY PLS_INTEGER;
        vv_wpolbas              wpolbas_tab;
        
        TYPE polbasic_row IS RECORD(
            line_cd             gipi_polbasic.line_cd%TYPE,
            subline_cd          gipi_polbasic.subline_cd%TYPE,
            iss_cd              gipi_polbasic.iss_cd%TYPE,
            issue_yy            gipi_polbasic.issue_yy%TYPE,
            pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
            renew_no            gipi_polbasic.renew_no%TYPE,
            policy_id           gipi_polbasic.policy_id%TYPE,
            incept_date         gipi_polbasic.incept_date%TYPE,
            eff_date            gipi_polbasic.eff_date%TYPE,
            expiry_date         gipi_polbasic.expiry_date%TYPE,
            endt_expiry_date    gipi_polbasic.endt_expiry_date%TYPE,
            endt_iss_cd         gipi_polbasic.endt_iss_cd%TYPE,
            endt_yy             gipi_polbasic.endt_yy%TYPE,
            endt_seq_no         gipi_polbasic.endt_seq_no%TYPE,
            pol_flag            gipi_polbasic.pol_flag%TYPE,
            endt_no             VARCHAR2(100)
        );
        TYPE polbasic_tab IS TABLE OF polbasic_row INDEX BY PLS_INTEGER;
        vv_polbasic             polbasic_tab;
      
   BEGIN
        OPEN a1_cur;
        LOOP
            FETCH a1_cur
            BULK COLLECT INTO vv_wpolbas;
            
            EXIT WHEN a1_cur%NOTFOUND;
        END LOOP;
        CLOSE a1_cur;
        
--      FOR a1 IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
--                        renew_no, eff_date, expiry_date
--                   FROM gipi_wpolbas
--                  WHERE par_id = p_par_id)
--      LOOP
--         FOR i IN (SELECT   line_cd, subline_cd, iss_cd, issue_yy,
--                            pol_seq_no, renew_no, policy_id, incept_date,
--                            eff_date, expiry_date, endt_expiry_date,
--                            endt_iss_cd, endt_yy, endt_seq_no, pol_flag,
--                               endt_iss_cd
--                            || '-'
--                            || TO_CHAR (endt_yy, '09')
--                            || TO_CHAR (endt_seq_no, '099999') endt_no
--                       FROM gipi_polbasic
--                      WHERE line_cd = a1.line_cd
--                        AND subline_cd = a1.subline_cd
--                        AND iss_cd = a1.iss_cd
--                        AND issue_yy = a1.issue_yy
--                        AND pol_seq_no = a1.pol_seq_no
--                        AND renew_no = a1.renew_no
--                        AND pol_flag IN ('1', '2', '3', 'X')
--                        AND TRUNC (eff_date) <=
--                               DECODE (NVL (endt_seq_no, 0),
--                                       0, TRUNC (eff_date),
--                                       TRUNC (a1.eff_date)
--                                      )
--                        AND TRUNC (DECODE (NVL (endt_expiry_date, expiry_date),
--                                           expiry_date, a1.expiry_date,
--                                           endt_expiry_date
--                                          )
--                                  ) >= TRUNC (a1.eff_date)
--                   ORDER BY eff_date DESC)
--         LOOP

        FOR a IN 1 .. vv_wpolbas.COUNT
        LOOP
            OPEN b2_cur (vv_wpolbas(a).line_cd, vv_wpolbas(a).subline_cd, vv_wpolbas(a).iss_cd, vv_wpolbas(a).issue_yy, vv_wpolbas(a).pol_seq_no,
                            vv_wpolbas(a).renew_no, vv_wpolbas(a).eff_date, vv_wpolbas(a).expiry_date);
            LOOP
            FETCH b2_cur
                BULK COLLECT INTO vv_polbasic;
                
                EXIT WHEN b2_cur%NOTFOUND;
            END LOOP;
            CLOSE b2_cur;
        
            FOR b IN 1 .. vv_polbasic.COUNT
            LOOP
                v_policy.policy_id := vv_polbasic(b).policy_id;
                v_policy.line_cd := vv_polbasic(b).line_cd;
                v_policy.subline_cd := vv_polbasic(b).subline_cd;
                v_policy.iss_cd := vv_polbasic(b).iss_cd;
                v_policy.issue_yy := vv_polbasic(b).issue_yy;
                v_policy.pol_seq_no := vv_polbasic(b).pol_seq_no;
                v_policy.renew_no := vv_polbasic(b).renew_no;
                v_policy.incept_date := vv_polbasic(b).incept_date;
                v_policy.eff_date := vv_polbasic(b).eff_date;
                v_policy.expiry_date := vv_polbasic(b).expiry_date;
                v_policy.endt_expiry_date := vv_polbasic(b).endt_expiry_date;
                v_policy.endt_no := vv_polbasic(b).endt_no;
                v_policy.endt_iss_cd := vv_polbasic(b).endt_iss_cd;
                v_policy.endt_yy := vv_polbasic(b).endt_yy;
                v_policy.endt_seq_no := vv_polbasic(b).endt_seq_no;
                v_policy.pol_flag := vv_polbasic(b).pol_flag;
                PIPE ROW (v_policy);
            END LOOP;
        END LOOP;
   END get_endt_policy;

   /*
   **  Created by   : mark jm
   **  Date Created : October 29, 2010
   **  Reference By : (GIPIS061 - Endorsement Item Information - Casualty)
   **  Description  : Function to retrieve endorsement policies' dates.
   */
   FUNCTION get_endt_policy2 (p_par_id IN gipi_wpolbas.par_id%TYPE)
      RETURN endt_policy_tab PIPELINED
   IS
      v_policy   endt_policy_type;
   BEGIN
      FOR a1 IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                        renew_no, eff_date, expiry_date
                   FROM gipi_wpolbas
                  WHERE par_id = p_par_id)
      LOOP
         FOR i IN (SELECT   line_cd, subline_cd, iss_cd, issue_yy,
                            pol_seq_no, renew_no, policy_id, incept_date,
                            eff_date, expiry_date, endt_expiry_date,
                            endt_iss_cd, endt_yy, endt_seq_no, pol_flag,
                               endt_iss_cd
                            || '-'
                            || TO_CHAR (endt_yy, '09')
                            || TO_CHAR (endt_seq_no, '099999') endt_no
                       FROM gipi_polbasic
                      WHERE line_cd = a1.line_cd
                        AND subline_cd = a1.subline_cd
                        AND iss_cd = a1.iss_cd
                        AND issue_yy = a1.issue_yy
                        AND pol_seq_no = a1.pol_seq_no
                        AND renew_no = a1.renew_no
                   ORDER BY eff_date DESC)
         LOOP
            v_policy.policy_id := i.policy_id;
            v_policy.line_cd := i.line_cd;
            v_policy.subline_cd := i.subline_cd;
            v_policy.iss_cd := i.iss_cd;
            v_policy.issue_yy := i.issue_yy;
            v_policy.pol_seq_no := i.pol_seq_no;
            v_policy.renew_no := i.renew_no;
            v_policy.incept_date := i.incept_date;
            v_policy.eff_date := i.eff_date;
            v_policy.expiry_date := i.expiry_date;
            v_policy.endt_expiry_date := i.endt_expiry_date;
            v_policy.endt_no := i.endt_no;
            v_policy.endt_iss_cd := i.endt_iss_cd;
            v_policy.endt_yy := i.endt_yy;
            v_policy.endt_seq_no := i.endt_seq_no;
            v_policy.pol_flag := i.pol_flag;
            PIPE ROW (v_policy);
         END LOOP;

         RETURN;
      END LOOP;
   END get_endt_policy2;
   -- added by MarkS 5.25.2016 SR-22344
   FUNCTION get_old_user_id(p_policy_id gipi_polbasic.policy_id%TYPE)
   RETURN gipi_polbasic.user_id%TYPE
   IS
   v_old_user_id gipi_polbasic.user_id%TYPE;
   BEGIN
      SELECT user_id 
      INTO v_old_user_id
      FROM gipi_polbasic
      WHERE policy_id = p_policy_id;
   END;
   -- end SR-22344
   PROCEDURE update_printed_count (p_policy_id gipi_polbasic.policy_id%TYPE)
   IS
       
   BEGIN
      UPDATE gipi_polbasic
         SET polendt_printed_cnt = NVL (polendt_printed_cnt, 0) + 1,
             polendt_printed_date = SYSDATE,
             user_id = get_old_user_id(p_policy_id) -- added by MarkS 5.25.2016 SR-22344
       WHERE policy_id = p_policy_id;

      COMMIT;
   END update_printed_count;

   FUNCTION get_max_endt_item_no (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN NUMBER
   IS
      v_item_no   gipi_item.item_no%TYPE;
   BEGIN
      FOR i IN (SELECT MAX (b.item_no) NO
                  FROM gipi_polbasic a, gipi_item b
                 WHERE a.line_cd = p_line_cd
                   AND a.iss_cd = p_iss_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.issue_yy = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no = p_renew_no
                   AND a.pol_flag IN ('1', '2', '3', 'X')
                   AND a.policy_id = b.policy_id)
      LOOP
         v_item_no := i.NO;
      END LOOP;

      RETURN v_item_no;
   END;
    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    xx.xx.xxxx    xxxxxx            created this function
    **    01.10.2012    mark jm            modified sql statements based on QA test results
    */
    FUNCTION get_policy_for_endt (
        p_line_cd IN gipi_wpolbas.line_cd%TYPE,
        p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
        p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
        p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
        p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
        p_renew_no IN gipi_wpolbas.renew_no%TYPE,      
        p_keyword IN VARCHAR2)
    RETURN gipi_polbasic_tab PIPELINED
    IS
        v_polbas   gipi_polbasic_type;
    BEGIN
        FOR i IN (
            SELECT a.policy_id, a.subline_cd, a.iss_cd, TO_CHAR(a.issue_yy,'09') issue_yy, TO_CHAR(a.pol_seq_no,'0000009') pol_seq_no, TO_CHAR(a.renew_no,'09') renew_no 
              FROM gipi_polbasic a
             WHERE line_cd = p_line_cd
               AND endt_seq_no = 0 
               AND pol_flag NOT IN ('5','4') 
               AND subline_cd = NVL(p_subline_cd, a.subline_cd)
               AND iss_cd = NVL(p_iss_cd, a.iss_cd)
               AND issue_yy = NVL(p_issue_yy, a.issue_yy)
               AND pol_seq_no = NVL(p_pol_seq_no, a.pol_seq_no)
               AND renew_no = NVL(p_renew_no, a.renew_no)
               AND dist_flag NOT IN ('5','X')
               AND pack_policy_id IS NULL  --added by d.alcantara, 10.09.2012, para hindi masama yung mga subpolicy ng package
               AND NOT EXISTS 
                    (SELECT '1'
                      FROM gipi_wpolbas
                     WHERE line_cd = p_line_cd
                       AND pol_flag NOT IN ('5','4') 
                       AND subline_cd = NVL(p_subline_cd, a.subline_cd)
                       AND iss_cd = NVL(p_iss_cd, a.iss_cd)
                       AND issue_yy = NVL(p_issue_yy, a.issue_yy) 
                       AND pol_seq_no = NVL(p_pol_seq_no, a.pol_seq_no)
                       AND renew_no = NVL(p_renew_no, a.renew_no))
                       
               AND (subline_cd LIKE UPPER ('%' || p_keyword || '%')
                    OR iss_cd LIKE UPPER ('%' || p_keyword || '%')
                    OR issue_yy LIKE UPPER ('%' || p_keyword || '%')
                    OR pol_seq_no LIKE UPPER ('%' || p_keyword || '%')
                    OR renew_no LIKE UPPER ('%' || p_keyword || '%'))
      /*SELECT policy_id, subline_cd, iss_cd,
                       TO_CHAR (issue_yy, '09') issue_yy,
                       TO_CHAR (pol_seq_no, '0000009') pol_seq_no,
                       TO_CHAR (renew_no, '09') renew_no
                  FROM gipi_polbasic
                 WHERE line_cd = p_line_cd
                   AND endt_seq_no = 0
                   AND pol_flag NOT IN ('5', '4')
                   AND subline_cd = NVL (p_subline, subline_cd)
                   AND iss_cd = NVL (p_iss_cd, iss_cd)
                   AND (   subline_cd LIKE UPPER ('%' || p_keyword || '%')
                        OR iss_cd LIKE UPPER ('%' || p_keyword || '%')
                        OR issue_yy LIKE UPPER ('%' || p_keyword || '%')
                        OR pol_seq_no LIKE UPPER ('%' || p_keyword || '%')
                        OR renew_no LIKE UPPER ('%' || p_keyword || '%')
                       )*/)
        LOOP
            v_polbas.policy_id := i.policy_id;
            v_polbas.subline_cd := i.subline_cd;
            v_polbas.iss_cd := i.iss_cd;
            v_polbas.issue_yy := i.issue_yy;
            v_polbas.pol_seq_no := i.pol_seq_no;
            v_polbas.renew_no := i.renew_no;
            PIPE ROW (v_polbas);
        END LOOP;

        RETURN;
    END get_policy_for_endt;

   /*bry*/
   FUNCTION is_pol_exist (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR ref_pol_no IN (SELECT '1'
                           FROM gipi_polbasic
                          WHERE line_cd = p_line_cd
                            AND subline_cd = p_subline_cd
                            AND iss_cd = p_iss_cd
                            AND issue_yy = p_issue_yy
                            AND pol_seq_no = p_pol_seq_no
                            AND renew_no = p_renew_no)
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exist;
   END is_pol_exist;

   /*
     **  Created by   : BRYAN JOSEPH G. ABULUYAN
     **  Date Created : 12/03/2010
     **  Reference By : (GIPIS091 - Regenerate Policy Documents)
     **  Description  : Retrieves list of existing polices matching input query parameters
     */
   FUNCTION get_gipi_polbasic_listing (
      p_user_id       giis_users.user_id%TYPE,
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_line_cd2      gipi_polbasic.line_cd%TYPE,
      p_subline_cd2   gipi_polbasic.subline_cd%TYPE,
      p_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy       gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      p_assd_name     giis_assured.assd_name%TYPE
   )
      RETURN gipi_polbasic_tab3 PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_cur         cur_typ;
      v_query_str   VARCHAR2 (30000);
      pol           gipi_polbasic_type3;
   BEGIN
      v_query_str :=
         'SELECT DISTINCT * FROM (SELECT x.pack_policy_id, x.line_cd, x.subline_cd, x.iss_cd,
                                                   x.issue_yy, x.pol_seq_no, x.renew_no, x.endt_iss_cd,
                                            x.endt_yy, x.endt_seq_no, x.policy_id, x.assd_no,
                                            x.endt_type, x.par_id, x.no_of_items, x.pol_flag,
                                            x.co_insurance_sw, x.fleet_print_tag, ESCAPE_VALUE(y.assd_name) assd_name, GIPI_PARLIST_PKG.get_par_no(x.par_id) par_no,
                                          z.prem_seq_no, NVL(a.endt_tax, ''N'') endt_tax, b.coc_type
                                      FROM GIPI_POLBASIC x, GIIS_ASSURED y, GIPI_INVOICE z, GIPI_ENDTTEXT a, GIPI_VEHICLE b
                                    WHERE pack_policy_id IS NULL
                                      AND x.assd_no = y.assd_no(+)
                                      AND x.policy_id = z.policy_id(+)
                                      AND x.policy_id = a.policy_id(+)
                                      AND x.policy_id = b.policy_id(+)
                                    UNION ALL
                                      SELECT x.pack_policy_id, x.line_cd, x.subline_cd, x.iss_cd,
                                                x.issue_yy, x.pol_seq_no, x.renew_no, x.endt_iss_cd,
                                            x.endt_yy, x.endt_seq_no, x.pack_policy_id policy_id, x.assd_no,
                                            x.endt_type, x.pack_par_id par_id, x.no_of_items, x.pol_flag,
                                            x.co_insurance_sw, x.fleet_print_tag, y.assd_name, GIPI_PACK_PARLIST_PKG.get_pack_par_no(x.pack_par_id) par_no,
                                          z.prem_seq_no, NVL(a.endt_tax, ''N'') endt_tax, b.coc_type
                                      FROM GIPI_PACK_POLBASIC x, GIIS_ASSURED y, GIPI_PACK_INVOICE z, GIPI_ENDTTEXT a, GIPI_VEHICLE b
                                    WHERE x.assd_no = y.assd_no
                                      AND x.pack_policy_id = z.policy_id(+)
                                      AND x.pack_policy_id = a.policy_id(+)
                                      AND x.pack_policy_id = b.policy_id(+)
                                      )
                            WHERE line_cd IN (SELECT DISTINCT a.line_cd
                                                FROM giis_user_grp_line a,giis_users b
                                               WHERE b.user_grp = a.user_grp
                                                 AND b.user_id = :user_id)
                              AND line_cd = NVL(:line_cd, line_cd)
                              AND subline_cd = NVL(:subline_cd, subline_cd)
                              AND iss_cd = NVL(:iss_cd, iss_cd)
                              AND UPPER(issue_yy) LIKE NVL(''%'' || UPPER(:issue_yy) || ''%'', UPPER(issue_yy))
                              AND TO_CHAR(pol_seq_no, ''000099'') LIKE NVL(''%'' || TO_CHAR(:pol_seq_no, ''000099'') || ''%'', TO_CHAR(pol_seq_no, ''000099''))
                              AND UPPER(renew_no) LIKE NVL(''%'' || UPPER(:renew_no) || ''%'', UPPER(renew_no))
                              AND UPPER(assd_name) LIKE NVL(''%'' || UPPER(:assd_name) || ''%'', UPPER(assd_name))';

      IF p_iss_cd IS NULL AND p_line_cd IS NOT NULL
      THEN
         v_query_str :=
               v_query_str
            || ' AND iss_cd = DECODE(check_user_per_iss_cd1('''
            || p_line_cd
            || ''', iss_cd, '''
            || p_user_id
            || ''', ''GIPIS091''), 1, iss_cd, NULL) ';
      ELSIF p_iss_cd IS NOT NULL AND p_line_cd IS NULL
      THEN
         IF check_user_per_iss_cd1 (p_line_cd,
                                    p_iss_cd,
                                    p_user_id,
                                    'GIPIS091'
                                   ) <> 1
         THEN
            v_query_str := v_query_str || ' AND 1 = 2 ';
         END IF;
      ELSIF p_iss_cd IS NOT NULL AND p_line_cd IS NOT NULL
      THEN
         IF check_user_per_iss_cd1 (p_line_cd,
                                    p_iss_cd,
                                    p_user_id,
                                    'GIPIS091'
                                   ) <> 1
         THEN
            v_query_str := v_query_str || ' AND 1 = 2 ';
         END IF;
      ELSIF p_iss_cd IS NULL AND p_line_cd IS NULL
      THEN
         v_query_str :=
               v_query_str
            || ' AND line_cd = DECODE( check_user_per_line1(line_cd, iss_cd, '''
            || p_user_id
            || ''', ''GIPIS091''), 1, line_cd, NULL) '
            || '  AND iss_cd = DECODE( check_user_per_iss_cd1(line_cd, iss_cd, '''
            || p_user_id
            || ''',''GIPIS091''), 1, iss_cd, NULL) ';
      END IF;

      IF (   p_line_cd2 IS NOT NULL
          OR p_subline_cd2 IS NOT NULL
          OR p_endt_iss_cd IS NOT NULL
          OR p_endt_yy IS NOT NULL
          OR p_endt_seq_no IS NOT NULL
         )
      THEN
         v_query_str :=
               v_query_str
            || ' AND line_cd = NVL( :line_cd2, line_cd)
                        AND subline_cd = NVL( :subline_cd2, subline_cd)
                        AND endt_iss_cd = NVL(:endt_iss_cd, endt_iss_cd)
                        AND endt_yy = NVL(:endt_yy, endt_yy)
                        AND endt_seq_no = NVL(:endt_seq_no, endt_seq_no)
                        AND endt_seq_no > 0
                        ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no';

         OPEN v_cur FOR v_query_str
         USING p_user_id,
               p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_assd_name,
               p_line_cd2,
               p_subline_cd2,
               p_endt_iss_cd,
               p_endt_yy,
               p_endt_seq_no;

         LOOP
            FETCH v_cur
             INTO pol;

            PIPE ROW (pol);
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSIF (   p_line_cd2 IS NULL
             OR p_subline_cd2 IS NULL
             OR p_endt_iss_cd IS NULL
             OR p_endt_yy IS NULL
             OR p_endt_seq_no IS NULL
            )
      THEN
         v_query_str :=
               v_query_str
            || ' AND line_cd = NVL( :line_cd2, line_cd)
                        AND subline_cd = NVL( :subline_cd2, subline_cd)
                        AND endt_iss_cd = NVL(:endt_iss_cd, endt_iss_cd)
                        AND endt_yy = NVL(:endt_yy, endt_yy)
                        AND endt_seq_no = NVL(:endt_seq_no, endt_seq_no)
                        AND endt_seq_no >= 0
                        ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no';

         OPEN v_cur FOR v_query_str
         USING p_user_id,
               p_line_cd,
               p_subline_cd,
               p_iss_cd,
               p_issue_yy,
               p_pol_seq_no,
               p_renew_no,
               p_assd_name,
               p_line_cd,
               p_subline_cd,
               p_endt_iss_cd,
               p_endt_yy,
               p_endt_seq_no;

         LOOP
            FETCH v_cur
             INTO pol;

            EXIT WHEN v_cur%NOTFOUND;
            PIPE ROW (pol);
         END LOOP;

         CLOSE v_cur;
      END IF;

      RETURN;
   END get_gipi_polbasic_listing;

   FUNCTION check_if_bill_not_printed (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_pol_flag    gipi_polbasic.pol_flag%TYPE,
      p_line_cd     gipi_polbasic.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_bill_not_printed   VARCHAR2 (1)                         := 'N';
      v_chk_bill           VARCHAR2 (1)                         := 'N';
      v_pack               giis_line.pack_pol_flag%TYPE;
      v_pol_flag           gipi_polbasic.pol_flag%TYPE;
      v_line_cd            gipi_polbasic.line_cd%TYPE;
      v_prem_amt           gipi_invoice.prem_amt%TYPE;
      v_bill               gipi_invoice.prem_amt%TYPE;
      v_pack_bill          gipi_invoice.prem_amt%TYPE;
      v_value              giis_parameters.param_value_v%TYPE;
   BEGIN
      /*BEGIN
         SELECT pol_flag, line_cd
           INTO v_pol_flag, v_line_cd
           FROM (SELECT pol_flag, line_cd
                   FROM gipi_polbasic
                  WHERE policy_id = p_policy_id AND pack_policy_id IS NULL
                 UNION ALL
                 SELECT pol_flag, line_cd
                   FROM gipi_pack_polbasic
                  WHERE pack_policy_id = p_policy_id);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;*/ -- commented by: nica 04.20.2011
      IF p_pol_flag IN ('1', '2', '3')
      THEN
         FOR prem IN (SELECT prem_amt
                        FROM gipi_invoice
                       WHERE policy_id = p_policy_id)
         LOOP
            v_prem_amt := prem.prem_amt;
         END LOOP;

         IF v_prem_amt < 0
         THEN
            v_chk_bill := 'N';
         ELSE
            v_chk_bill := 'Y';
         --:cg$ctrl.bill_radiogroup := 'N'; -- added by aaron 080409
         END IF;
      ELSE
         v_chk_bill := 'N';
      END IF;

      IF v_chk_bill = 'Y'
      THEN
         FOR a IN (SELECT pack_pol_flag
                     FROM giis_line
                    WHERE line_cd = p_line_cd)
         LOOP
            v_pack := a.pack_pol_flag;
         END LOOP;

         FOR b IN (SELECT NVL (prem_amt, 0) + NVL (tax_amt, 0) amt
                     FROM gipi_invoice
                    WHERE policy_id = p_policy_id)
         LOOP
            v_bill := NVL (b.amt, 0);
         END LOOP;

         FOR c IN (SELECT NVL (prem_amt, 0) + NVL (tax_amt, 0) amt
                     FROM gipi_pack_invoice
                    WHERE policy_id = p_policy_id)
         LOOP
            v_pack_bill := NVL (c.amt, 0);
         END LOOP;

         BEGIN
            SELECT param_value_v
              INTO v_value
              FROM giis_parameters
             WHERE param_name = 'PRINT_BILL';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         IF v_pack = 'Y'
         THEN
            IF v_pack_bill = 0
            THEN
               IF NVL (v_value, 'N') = 'N'
               THEN                                     --issa@cic 01.18.2007
                  --msg_alert('Total Amount Due is 0, bill will not be printed.', 'I', FALSE);
                  v_bill_not_printed := 'Y';
                  v_chk_bill := 'N';
               END IF;                                   --issa@cic 01.18.2007
            END IF;
         ELSE
            IF v_bill = 0
            THEN
               IF NVL (v_value, 'N') = 'N'
               THEN                                     --issa@cic 01.18.2007
                  --msg_alert('Total Amount Due is 0, bill will not be printed.', 'I', FALSE);
                  v_bill_not_printed := 'Y';
                  v_chk_bill := 'N';
               END IF;                                   --issa@cic 01.18.2007
            END IF;
         END IF;
      END IF;

      RETURN v_bill_not_printed;
   END check_if_bill_not_printed;

   FUNCTION get_gipd_line_cd_lov (p_keyword VARCHAR2)
      RETURN gipd_line_cd_lov_tab PIPELINED
   IS
      v_gipd_line_cd   gipd_line_cd_lov_type;
   BEGIN
      FOR i IN (SELECT   b250.line_cd line_cd                     /* CG$FK */
                                             ,
                         b250.subline_cd subline_cd, b250.iss_cd iss_cd,
                         b250.issue_yy issue_yy, b250.pol_seq_no pol_seq_no,
                         b250.renew_no renew_no, b250.assd_no assd_no,
                         a020.assd_name assd_name,
                         b250.endt_seq_no endt_seq_no
                    FROM gipi_polbasic b250, giis_assured a020
                   WHERE b250.endt_seq_no = 0
                     AND a020.assd_no(+) = b250.assd_no
                     AND (   b250.line_cd LIKE '%' || p_keyword || '%'
                          OR b250.subline_cd LIKE '%' || p_keyword || '%'
                          OR b250.iss_cd LIKE '%' || p_keyword || '%'
                          OR b250.issue_yy LIKE '%' || p_keyword || '%'
                          OR b250.pol_seq_no LIKE '%' || p_keyword || '%'
                          OR b250.renew_no LIKE '%' || p_keyword || '%'
                          OR b250.assd_no LIKE '%' || p_keyword || '%'
                          OR a020.assd_name LIKE '%' || p_keyword || '%'
                          OR b250.endt_seq_no LIKE '%' || p_keyword || '%'
                         )
                ORDER BY b250.assd_no ASC,
                         b250.line_cd ASC,
                         b250.subline_cd ASC,
                         b250.iss_cd ASC,
                         b250.issue_yy ASC,
                         b250.pol_seq_no ASC,
                         b250.renew_no ASC)
      LOOP
         v_gipd_line_cd.line_cd := i.line_cd;
         v_gipd_line_cd.subline_cd := i.subline_cd;
         v_gipd_line_cd.iss_cd := i.iss_cd;
         v_gipd_line_cd.issue_yy := i.issue_yy;
         v_gipd_line_cd.pol_seq_no := i.pol_seq_no;
         v_gipd_line_cd.renew_no := i.renew_no;
         v_gipd_line_cd.assd_no := i.assd_no;
         v_gipd_line_cd.assd_name := i.assd_name;
         v_gipd_line_cd.endt_seq_no := i.endt_seq_no;
         PIPE ROW (v_gipd_line_cd);
      END LOOP;

      RETURN;
   END get_gipd_line_cd_lov;

   --modified by reymon added to_char to dates reymon 11132013
   FUNCTION get_gipi_polinfo_endtseq0 (
      p_line_cd            gipi_polbasic.line_cd%TYPE,
      p_subline_cd         gipi_polbasic.subline_cd%TYPE,
      p_iss_cd             gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no           gipi_polbasic.renew_no%TYPE,
      p_ref_pol_no         gipi_polbasic.ref_pol_no%TYPE,
      p_nbt_line_cd        gipi_parlist.line_cd%TYPE,
      p_nbt_iss_cd         gipi_parlist.iss_cd%TYPE,
      p_nbt_par_yy         gipi_parlist.par_yy%TYPE,
      p_nbt_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_nbt_quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_module_id          VARCHAR2
   )
      RETURN gipi_polinfo_endtseq0_tab PIPELINED
   IS
      v_polbasic   gipi_polinfo_endtseq0_type;
   BEGIN
      FOR i IN (SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                       a.issue_yy, a.pol_seq_no, a.renew_no, a.ref_pol_no,
                       a.endt_seq_no, TO_CHAR(a.expiry_date, 'MM-DD-RRRR') expiry_date, a.assd_no,
                       a.cred_branch, TO_CHAR(a.issue_date, 'MM-DD-RRRR') issue_date, TO_CHAR(a.incept_date, 'MM-DD-RRRR') incept_date,
                       a.pol_flag,
                       DECODE (a.pol_flag,
                               '1', 'New',
                               '2', 'Renewal',
                               '3', 'Replacement',
                               '4', 'Cancelled Endorsement',
                               '5', 'Spoiled',
                               'X', 'Expired'
                              ) mean_pol_flag,
                       b.line_cd nbt_line_cd, b.iss_cd nbt_iss_cd, b.par_yy,
                       b.par_seq_no, b.quote_seq_no, c.line_cd line_cd_rn,
                       c.iss_cd iss_cd_rn, c.rn_yy, c.rn_seq_no, UPPER(d.designation || d.assd_name) assd_name, --concatenated designation: gzelle06.14.2013
                       /* changed get_pack_policy_no reymon 11142013
                          e.line_cd
                       || ' - '
                       || e.subline_cd
                       || ' - '
                       || e.iss_cd
                       || ' - '
                       || TO_CHAR (e.issue_yy, '09')
                       || ' - '
                       || TO_CHAR (e.pol_seq_no, '099999')
                       || ' - '
                       || TO_CHAR (e.renew_no, '09')*/
--                       GET_PACK_POLICY_NO(e.pack_policy_id) pack_pol_no, -- bonok :: 03.21.2014 :: for optimization
                       e.pack_policy_id, f.iss_name
                  FROM gipi_polbasic a,
                       gipi_parlist b,
                       giex_rn_no c,
                       giis_assured d,
                       gipi_pack_polbasic e,
                       giis_issource f
                 WHERE a.endt_seq_no = 0
                   AND check_user_per_line2(a.line_cd, a.iss_cd, p_module_id, p_user_id) = 1 -- check user access per line
                   AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, p_module_id, p_user_id) = 1 -- and iss_cd - Nica 05.09.2013
                   AND a.par_id = b.par_id(+)
                   AND a.policy_id = c.policy_id(+)
                   AND a.assd_no = d.assd_no(+)
                   AND a.pack_policy_id = e.pack_policy_id(+)
                   AND a.cred_branch = f.iss_cd(+)
                   /*AND a.line_cd = NVL (p_line_cd, a.line_cd)*/  AND UPPER(a.line_cd) LIKE UPPER(NVL(p_line_cd, '%'))
                   /*AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)*/  AND UPPER(a.subline_cd) LIKE UPPER(NVL(p_subline_cd, '%'))
                   /*AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)*/  AND UPPER(a.iss_cd) LIKE UPPER(NVL(p_iss_cd, '%'))
                   AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
                   AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
                   AND a.renew_no = NVL (p_renew_no, a.renew_no)
                   AND NVL (a.ref_pol_no, 'N') =
                                   NVL (p_ref_pol_no, NVL (a.ref_pol_no, 'N'))
                   /*AND b.line_cd = NVL (p_nbt_line_cd, b.line_cd)*/  AND UPPER(b.line_cd) LIKE UPPER(NVL(p_nbt_line_cd, '%'))
                   /*AND b.iss_cd = NVL (p_nbt_iss_cd, b.iss_cd)*/  AND UPPER(b.iss_cd) LIKE UPPER(NVL(p_nbt_iss_cd, '%'))
                   AND b.par_yy = NVL (p_nbt_par_yy, b.par_yy)
                   AND b.par_seq_no = NVL (p_nbt_par_seq_no, b.par_seq_no)
                   AND b.quote_seq_no =
                                      NVL (p_nbt_quote_seq_no, b.quote_seq_no))
      LOOP
         v_polbasic.policy_id := i.policy_id;
         v_polbasic.line_cd := i.line_cd;
         v_polbasic.subline_cd := i.subline_cd;
         v_polbasic.iss_cd := i.iss_cd;
         v_polbasic.issue_yy := i.issue_yy;
         v_polbasic.pol_seq_no := i.pol_seq_no;
         v_polbasic.renew_no := i.renew_no;
         v_polbasic.ref_pol_no := i.ref_pol_no;
         v_polbasic.endt_seq_no := i.endt_seq_no;
         v_polbasic.expiry_date := i.expiry_date;
         v_polbasic.assd_no := i.assd_no;
         v_polbasic.cred_branch := i.cred_branch;
         v_polbasic.issue_date := i.issue_date;
         v_polbasic.incept_date := i.incept_date;
         v_polbasic.pol_flag := i.pol_flag;
         v_polbasic.mean_pol_flag := i.mean_pol_flag;
         v_polbasic.nbt_line_cd := i.nbt_line_cd;
         v_polbasic.nbt_iss_cd := i.nbt_iss_cd;
         v_polbasic.par_yy := i.par_yy;
         v_polbasic.par_seq_no := i.par_seq_no;
         v_polbasic.quote_seq_no := i.quote_seq_no;
         v_polbasic.line_cd_rn := i.line_cd_rn;
         v_polbasic.iss_cd_rn := i.iss_cd_rn;
         v_polbasic.rn_yy := i.rn_yy;
         v_polbasic.rn_seq_no := i.rn_seq_no;
         v_polbasic.assd_name := i.assd_name;
--         v_polbasic.pack_pol_no := i.pack_pol_no; -- bonok :: 03.21.2014 :: for optimization
         v_polbasic.pack_policy_id := i.pack_policy_id;
         v_polbasic.iss_name := i.iss_name;
         
         IF i.pack_policy_id IS NOT NULL THEN -- bonok :: 03.21.2014 :: for optimization
            v_polbasic.pack_pol_no := GET_PACK_POLICY_NO(i.pack_policy_id); 
         ELSE
            v_polbasic.pack_pol_no := NULL;
         END IF;
         
         PIPE ROW (v_polbasic);
      END LOOP;                                                 --MOSES 030411

      RETURN;
   END get_gipi_polinfo_endtseq0;

   FUNCTION get_gipi_related_polinfo (
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_subline_cd       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_issue_yy         gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no         gipi_polbasic.renew_no%TYPE,
      p_ref_pol_no       gipi_polbasic.ref_pol_no%TYPE,
      p_endorsement_no   VARCHAR,
      p_par_no           VARCHAR,
      p_eff_date         gipi_polbasic.eff_date%TYPE,
      p_issue_date       gipi_polbasic.issue_date%TYPE,
      p_acct_ent_date    gipi_polbasic.acct_ent_date%TYPE,
      p_ref_pol_no2      gipi_polbasic.ref_pol_no%TYPE,
      p_status           VARCHAR
   )
      RETURN gipi_polinfo_tab PIPELINED
   IS
      v_polinfo     gipi_polinfo_type;
      v_status      VARCHAR (50);
      v_status2     VARCHAR (50);
      v_spld_flag   NUMBER (5);
   BEGIN
      v_status := p_status;

      IF    ('SPOILED' LIKE '%' || NVL (p_status, 'MBC') || '%')
         OR ('TAGGED FOR SPOILAGE' LIKE '%' || p_status || '%')
      THEN
         v_status := NULL;

         IF ('SPOILED' LIKE '%' || NVL (p_status, 'MBC') || '%')
         THEN
            v_status2 := 'SPOILED';
            v_spld_flag := 3;
         ELSIF ('TAGGED FOR SPOILAGE' LIKE '%' || NVL (p_status, 'MBC') || '%'
               )
         THEN
            v_status2 := 'TAGGED FOR SPOILAGE';
            v_spld_flag := 2;
         END IF;
      END IF;

      FOR i IN
         (SELECT *
            FROM (SELECT a.policy_id,
                         DECODE (a.endt_seq_no,
                                 0, a.endt_type,
                                    a.endt_iss_cd
                                 || '-'
                                 || LPAD (a.endt_yy, 2, 0)
                                 || '-'
                                 || LPAD (a.endt_seq_no, 6, 0)
                                 || '-'
                                 || a.endt_type
                                ) endorsement_no,
                         a.endt_type, TRUNC (a.eff_date) eff_date,
                         TRUNC (a.issue_date) issue_date,
                         TRUNC (a.acct_ent_date) acct_ent_date,
                            b.line_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LPAD (b.par_yy, 2, 0)
                         || '-'
                         || LPAD (b.par_seq_no, 6, 0)
                         || '-'
                         || LPAD (b.quote_seq_no, 2, 0) par_no,
                         a.ref_pol_no, a.prem_amt, a.pol_flag, a.spld_flag,
                         DECODE (a.pol_flag,
                                 '1', 'New',
                                 '2', 'Renewal',
                                 '3', 'Replacement',
                                 '4', 'Cancelled Endorsement',
                                 '5', 'Spoiled',
                                 'X', 'Expired'
                                ) mean_pol_flag,
                         a.reinstate_tag
                    FROM gipi_polbasic a, gipi_parlist b
                   WHERE a.par_id = b.par_id(+)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
                     AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
                     AND a.renew_no = NVL (p_renew_no, a.renew_no)
                     /*AND NVL (a.ref_pol_no, 'N') =
                                   NVL (p_ref_pol_no, NVL (a.ref_pol_no, 'N'))*/)
           WHERE NVL (endorsement_no, 'M') LIKE
                       '%'
                    || NVL (p_endorsement_no, NVL (endorsement_no, 'M'))
                    || '%'
             AND par_no LIKE '%' || NVL (p_par_no, par_no) || '%'
             AND TO_DATE (TO_CHAR (eff_date, 'MM-DD-YYYY'), 'MM-DD-YYYY') =
                    TO_DATE (NVL (TO_CHAR (p_eff_date, 'MM-DD-YYYY'),
                                  TO_CHAR (eff_date, 'MM-DD-YYYY')
                                 ),
                             'MM-DD-YYYY'
                            )
             AND TO_DATE (TO_CHAR (issue_date, 'MM-DD-YYYY'), 'MM-DD-YYYY') =
                    TO_DATE (NVL (TO_CHAR (p_issue_date, 'MM-DD-YYYY'),
                                  TO_CHAR (issue_date, 'MM-DD-YYYY')
                                 ),
                             'MM-DD-YYYY'
                            )
             AND TO_DATE (TO_CHAR (NVL (acct_ent_date, SYSDATE), 'MM-DD-YYYY'),
                          'MM-DD-YYYY'
                         ) =
                    TO_DATE (NVL (TO_CHAR (p_acct_ent_date, 'MM-DD-YYYY'),
                                  TO_CHAR (NVL (acct_ent_date, SYSDATE),
                                           'MM-DD-YYYY'
                                          )
                                 ),
                             'MM-DD-YYYY'
                            )
             AND NVL (ref_pol_no, 'N') LIKE
                       '%' || NVL (p_ref_pol_no2, NVL (ref_pol_no, 'N'))
                       || '%'
             AND UPPER (mean_pol_flag) LIKE
                            '%' || NVL (v_status, UPPER (mean_pol_flag))
                            || '%'
             AND (   (spld_flag = NVL (v_spld_flag, spld_flag))
                  OR (mean_pol_flag = NVL (v_status2, mean_pol_flag))
                 )
             ORDER BY policy_id) -- added by Nica 06.14.2012 to sort by policy_id
      LOOP
         v_polinfo.policy_id := i.policy_id;
         v_polinfo.endorsement_no := i.endorsement_no;
         v_polinfo.endt_type := i.endt_type;
         v_polinfo.eff_date := i.eff_date;
         v_polinfo.issue_date := i.issue_date;
         v_polinfo.acct_ent_date := i.acct_ent_date;
         v_polinfo.par_no := i.par_no;
         v_polinfo.ref_pol_no := i.ref_pol_no;
         v_polinfo.prem_amt := i.prem_amt;
         v_polinfo.pol_flag := i.pol_flag;
         v_polinfo.spld_flag := i.spld_flag;
         v_polinfo.mean_pol_flag := i.mean_pol_flag;
         v_polinfo.reinstate_tag := i.reinstate_tag;

         FOR i IN (SELECT rv_meaning
                     FROM cg_ref_codes
                    WHERE rv_domain = 'GIPI_POLBASIC.SPLD_FLAG'
                      AND rv_low_value = v_polinfo.spld_flag
                      AND rv_low_value IN ('3', '2'))
         LOOP
            v_polinfo.mean_pol_flag :=
                                  NVL (i.rv_meaning, v_polinfo.mean_pol_flag);
         END LOOP;

         PIPE ROW (v_polinfo);
      END LOOP;                                                 --MOSES 031011
   END get_gipi_related_polinfo;

   FUNCTION get_gipi_polbasic_rep (p_policy_id gipi_polbasic.policy_id%TYPE)
      --Created by: Alfred  03/10/2011
   RETURN gipi_polbasic_rep_tab PIPELINED
   IS
      v_gipi_polbasic_rep   gipi_polbasic_rep_type;
   BEGIN
      FOR i IN (SELECT b250.policy_id policy_id,/* a020.assd_name assd_name,*/
                       decode(a020.designation, null, a020.assd_name ||' '|| a020.assd_name2
                             ,a020.designation||' '||a020.assd_name ||' '|| a020.assd_name2) assd_name, --edited by d.alcantara, 02-02-2012
                       b250.address1 address1, b250.address2 address2,
                       b250.address3 address3,
                          b250.line_cd
                       || '-'
                       || b250.subline_cd
                       || '-'
                       || b250.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (b250.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (b250.pol_seq_no, '0999999'))
                                                                 pol_seq_no1,
                       b250.issue_date issue_date,
                       b250.incept_date incept_date,
                       b250.expiry_date expiry_date
                  FROM gipi_polbasic b250,
                       giis_assured a020,
                       gipi_parlist b240
                 WHERE b250.policy_id = p_policy_id
                   AND a020.assd_no = b240.assd_no
                   AND b250.par_id = b240.par_id)
      LOOP
         v_gipi_polbasic_rep.policy_id := i.policy_id;
         v_gipi_polbasic_rep.assd_name := i.assd_name;
         v_gipi_polbasic_rep.address1 := i.address1;
         v_gipi_polbasic_rep.address2 := i.address2;
         v_gipi_polbasic_rep.address3 := i.address3;
         v_gipi_polbasic_rep.pol_seq_no1 := i.pol_seq_no1;
         v_gipi_polbasic_rep.issue_date := i.issue_date;
         v_gipi_polbasic_rep.incept_date := i.incept_date;
         v_gipi_polbasic_rep.expiry_date := i.expiry_date;
         v_gipi_polbasic_rep.cf_coc_signatory :=
                                                cf_coc_signatory ('GIPIR914');
         v_gipi_polbasic_rep.cf_print_signatory := cf_print_signatory ();
         PIPE ROW (v_gipi_polbasic_rep);
      END LOOP;

      RETURN;
   END get_gipi_polbasic_rep;

   FUNCTION get_gipi_fleet_policy (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_fleet_policy_tab PIPELINED
   IS
      v_gipi_fleet_policy   gipi_fleet_policy_type;
   BEGIN
      FOR c IN (SELECT   b250.policy_id policy_id,
                            b250.line_cd
                         || '-'
                         || b250.subline_cd
                         || '-'
                         || b250.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b250.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b250.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (b250.renew_no, '09')) policy_no,
                            b250.endt_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b250.endt_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b250.endt_seq_no, '099999'))
                                                                     endt_no,
                         b250.endt_seq_no endt_seq_no,
                         DECODE (a020.designation,
                                 NULL, a020.assd_name || a020.assd_name2,
                                    a020.designation
                                 || ' '
                                 || a020.assd_name
                                 || a020.assd_name2
                                ) assd_name,
                         b250.subline_cd, b170.item_no item_no,
                         b170.item_title item_title, b290.plate_no plate_no,
                         b290.make make, b290.coc_serial_no coc_serial_no,
                         b290.repair_lim repair_lim, b180.tsi_amt tsi_amt,
                         a170.peril_sname peril_sname,
                         b180.prem_amt prem_amt, b290.assignee assignee,
                         TO_CHAR (b290.mot_type) motor_type,
                         b290.motor_no motor_no, b290.serial_no serial_no,
                         SUM (b300.deductible_amt) deductible,
                         b290.towing towing
                    FROM gipi_polbasic b250,
                         giis_assured a020,
                         gipi_item b170,
                         gipi_vehicle b290,
                         giis_peril a170,
                         gipi_itmperil b180,
                         gipi_parlist b240,
                         gipi_deductibles b300
                   WHERE a020.assd_no = b240.assd_no
                     AND a170.peril_cd = b180.peril_cd
                     AND a170.line_cd = b180.line_cd
                     AND b180.item_no = b170.item_no
                     AND b180.policy_id = b170.policy_id
                     AND b290.item_no = b170.item_no
                     AND b290.policy_id = b170.policy_id
                     AND b170.policy_id = b250.policy_id
                     AND b250.par_id = b240.par_id
                     AND b250.policy_id = p_policy_id
                     AND b290.item_no = b300.item_no(+)
                     AND b290.policy_id = b300.policy_id(+)
                GROUP BY b250.policy_id,
                            b250.line_cd
                         || '-'
                         || b250.subline_cd
                         || '-'
                         || b250.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b250.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b250.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (b250.renew_no, '09')),
                            b250.endt_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b250.endt_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b250.endt_seq_no, '099999')),
                         b250.endt_seq_no,
                         DECODE (a020.designation,
                                 NULL, a020.assd_name || a020.assd_name2,
                                    a020.designation
                                 || ' '
                                 || a020.assd_name
                                 || a020.assd_name2
                                ),
                         b250.subline_cd,
                         b170.item_no,
                         b170.item_title,
                         b290.plate_no,
                         b290.make,
                         b290.coc_serial_no,
                         b290.repair_lim,
                         b180.tsi_amt,
                         a170.peril_sname,
                         b180.prem_amt,
                         b290.assignee,
                         TO_CHAR (b290.mot_type),
                         b290.motor_no,
                         b290.serial_no,
                         b290.towing
                ORDER BY policy_no)
      LOOP
         v_gipi_fleet_policy.policy_id := c.policy_id;
         v_gipi_fleet_policy.policy_no := c.policy_no;
         v_gipi_fleet_policy.endt_no := c.endt_no;
         v_gipi_fleet_policy.assd_name := c.assd_name;
         v_gipi_fleet_policy.subline_cd := c.subline_cd;
         v_gipi_fleet_policy.item_no := c.item_no;
         v_gipi_fleet_policy.item_title := c.item_title;
         v_gipi_fleet_policy.plate_no := c.plate_no;
         v_gipi_fleet_policy.make := c.make;
         v_gipi_fleet_policy.coc_serial_no := c.coc_serial_no;
         v_gipi_fleet_policy.repair_lim := c.repair_lim;
         v_gipi_fleet_policy.tsi_amt := c.tsi_amt;
         v_gipi_fleet_policy.peril_sname := c.peril_sname;
         v_gipi_fleet_policy.prem_amt := c.prem_amt;
         v_gipi_fleet_policy.assignee := c.assignee;
         v_gipi_fleet_policy.motor_type := c.motor_type;
         v_gipi_fleet_policy.motor_no := c.motor_no;
         v_gipi_fleet_policy.serial_no := c.serial_no;
         v_gipi_fleet_policy.deductible := c.deductible;
         v_gipi_fleet_policy.towing := c.towing;
         PIPE ROW (v_gipi_fleet_policy);
      END LOOP;

      RETURN;
   END get_gipi_fleet_policy;

   FUNCTION get_gipi_fleet_pol_par (p_par_id gipi_polbasic.par_id%TYPE)
      RETURN gipi_fleet_pol_par_tab PIPELINED
   IS
      v_gipi_fleet_pol_par   gipi_fleet_pol_par_type;
   BEGIN
      FOR c IN (SELECT   b250.par_id par_id,
                            b240.line_cd
                         || '-'
                         || b240.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b240.par_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b240.par_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (b240.quote_seq_no, '09')) par_no,
                            b250.endt_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b250.endt_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b250.endt_seq_no, '099999'))
                                                                     endt_no,
                         b250.endt_seq_no endt_seq_no,
                         a020.assd_name assd_name, b250.subline_cd,
                         b170.item_no item_no, b170.item_title item_title,
                         b290.plate_no plate_no, b290.make make,
                         b290.coc_serial_no coc_serial_no,
                         b290.repair_lim repair_limit, b180.tsi_amt tsi_amt,
                         a170.peril_sname peril_sname,
                         b180.prem_amt prem_amt, b290.assignee assignee,
                         TO_CHAR (b290.mot_type) motor_type,
                         b290.motor_no motor_no, b290.serial_no serial_no
                    FROM gipi_wpolbas b250,
                         gipi_parlist b240,
                         giis_assured a020,
                         gipi_witem b170,
                         gipi_wvehicle b290,
                         giis_peril a170,
                         gipi_witmperl b180
                   WHERE a020.assd_no = b250.assd_no
                     AND a170.peril_cd = b180.peril_cd
                     AND a170.line_cd = b180.line_cd
                     AND b180.item_no = b170.item_no
                     AND b180.par_id = b170.par_id
                     AND b290.item_no = b170.item_no
                     AND b290.par_id = b170.par_id
                     AND b170.par_id = b250.par_id
                     AND b240.par_id = b250.par_id
                     AND b250.par_id = p_par_id
                ORDER BY par_no)
      LOOP
         v_gipi_fleet_pol_par.par_id := c.par_id;
         v_gipi_fleet_pol_par.par_no := c.par_no;
         v_gipi_fleet_pol_par.endt_no := c.endt_no;
         v_gipi_fleet_pol_par.endt_seq_no := c.endt_seq_no;
         v_gipi_fleet_pol_par.assd_name := c.assd_name;
         v_gipi_fleet_pol_par.subline_cd := c.subline_cd;
         v_gipi_fleet_pol_par.item_no := c.item_no;
         v_gipi_fleet_pol_par.item_title := c.item_title;
         v_gipi_fleet_pol_par.plate_no := c.plate_no;
         v_gipi_fleet_pol_par.make := c.make;
         v_gipi_fleet_pol_par.coc_serial_no := c.coc_serial_no;
         v_gipi_fleet_pol_par.repair_limit := c.repair_limit;
         v_gipi_fleet_pol_par.tsi_amt := c.tsi_amt;
         v_gipi_fleet_pol_par.peril_sname := c.peril_sname;
         v_gipi_fleet_pol_par.prem_amt := c.prem_amt;
         v_gipi_fleet_pol_par.assignee := c.assignee;
         v_gipi_fleet_pol_par.motor_type := c.motor_type;
         v_gipi_fleet_pol_par.motor_no := c.motor_no;
         v_gipi_fleet_pol_par.serial_no := c.serial_no;
         PIPE ROW (v_gipi_fleet_pol_par);
      END LOOP;
   END get_gipi_fleet_pol_par;

   FUNCTION get_polmain_info (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_polmain_info_tab PIPELINED
   IS
      v_main_info   gipi_polmain_info_type;
   BEGIN
      FOR i IN (SELECT a.policy_id, b.assd_no, a.line_cd, a.iss_cd, a.subline_cd,
                          a.line_cd
                       || ' - '
                       || a.subline_cd
                       || ' - '
                       || a.iss_cd
                       || ' - '
                       || TO_CHAR (a.issue_yy, '09')
                       || ' - '
                       || TO_CHAR (a.pol_seq_no, '0999999')
                       || ' - '
                       || TO_CHAR (a.renew_no, '09') pol_no,
                       DECODE (a.endt_seq_no,
                               0, NULL,
                                  a.endt_iss_cd
                               || ' - '
                               || TO_CHAR (a.endt_yy, '99')
                               || ' - '
                               || TO_CHAR (a.endt_seq_no, '099999')
                               || ' - '
                               || a.endt_type
                              ) endorsement_no,
                       a.expiry_date, a.endt_expiry_date, a.acct_of_cd,
                       a.label_tag, c.assd_name, d.with_invoice_tag,
                       a.pack_pol_flag
                  FROM gipi_polbasic a,
                       gipi_parlist b,
                       giis_assured c,
                       gipi_open_liab d
                 WHERE a.par_id = b.par_id(+)
                   AND b.assd_no = c.assd_no(+)
                   AND a.policy_id = d.policy_id(+)
                   AND a.policy_id = p_policy_id)
      LOOP
         FOR j IN (SELECT assd_name
                     FROM giis_assured
                    WHERE assd_no = i.acct_of_cd)
         LOOP
            v_main_info.acct_of := j.assd_name;
         END LOOP;

         v_main_info.policy_id := i.policy_id;
         v_main_info.pol_no := i.pol_no;
         v_main_info.endorsement_no := i.endorsement_no;
         v_main_info.assd_name := i.assd_name;
         v_main_info.label_tag := i.label_tag;
         v_main_info.line_cd := i.line_cd;
         v_main_info.iss_cd := i.iss_cd;
         v_main_info.pack_pol_flag := i.pack_pol_flag;
         
         BEGIN
            SELECT 'Y'
              INTO v_main_info.subline_mop_sw
              FROM giis_subline
             WHERE line_cd = i.line_cd
               AND subline_cd = i.subline_cd
               AND op_flag = 'Y';
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_main_info.subline_mop_sw := 'N';          
         END;
         
         --Added by Apollo 12.10.2014
         BEGIN
            SELECT menu_line_cd
              INTO v_main_info.menu_line_cd
              FROM giis_line
             WHERE line_cd = i.line_cd; 
         END;
         
         PIPE ROW (v_main_info);
      END LOOP;
   END get_polmain_info;

    --modified by reymon added to_char to dates reymon 11132013
   FUNCTION get_polbasic_info (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_polbasic_info_tab PIPELINED
   IS
      v_basic_info            gipi_polbasic_info_type;
      v_line_cd               gipi_polbasic.line_cd%TYPE;
      v_policy_endtseq0       gipi_polbasic.policy_id%TYPE;
      v_line_cd_endtseq0      gipi_polbasic.line_cd%TYPE;
      v_subline_cd_endtseq0   gipi_polbasic.subline_cd%TYPE;
      v_menu_line_cd          giis_line.menu_line_cd%TYPE;
      v_line_mn               giis_parameters.param_value_v%TYPE;
      v_line_ca               giis_parameters.param_value_v%TYPE;
      v_line_fi               giis_parameters.param_value_v%TYPE;
      v_survey_payee_no       giis_payees.payee_no%TYPE;
      v_settling_payee_no     giis_payees.payee_no%TYPE;
      v_exist_or_not          VARCHAR2 (50);
      v_subline_op            giis_parameters.param_value_v%TYPE;
      v_subline_car           giis_parameters.param_value_v%TYPE;
      v_subline_ear           giis_parameters.param_value_v%TYPE;
      v_subline_mbi           giis_parameters.param_value_v%TYPE;
      v_subline_dos           giis_parameters.param_value_v%TYPE;
      v_subline_bpv           giis_parameters.param_value_v%TYPE;
      v_subline_eei           giis_parameters.param_value_v%TYPE;
      v_subline_pcp           giis_parameters.param_value_v%TYPE;
      v_subline_bbi           giis_parameters.param_value_v%TYPE;
      v_subline_mop           giis_parameters.param_value_v%TYPE;
      v_subline_oth           giis_parameters.param_value_v%TYPE;
      v_subline_mlop          giis_parameters.param_value_v%TYPE;
      v_open_policy_sw        giis_subline.open_policy_sw%TYPE;
      v_op_flag               giis_subline.op_flag%TYPE;
   BEGIN
      BEGIN
         SELECT ca.param_value_v, mn.param_value_v, fi.param_value_v
           INTO v_line_ca, v_line_mn, v_line_fi
           FROM giis_parameters ca, giis_parameters mn, giis_parameters fi
          WHERE ca.param_name = 'LINE_CODE_CA'
            AND mn.param_name = 'LINE_CODE_MN'
            AND fi.param_name = 'LINE_CODE_FI';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_line_ca := 'CA';
            v_line_mn := 'MN';
            v_line_fi := 'FI';
      END;

      BEGIN
         SELECT a.param_value_v a, b.param_value_v b, c.param_value_v c,
                d.param_value_v d, e.param_value_v e, f.param_value_v f,
                g.param_value_v g, h.param_value_v h, i.param_value_v i,
                j.param_value_v j, k.param_value_v k
           INTO v_subline_car, v_subline_ear, v_subline_mbi,
                v_subline_mlop, v_subline_dos, v_subline_bpv,
                v_subline_eei, v_subline_pcp, v_subline_op,
                v_subline_bbi, v_subline_mop
           FROM giis_parameters a,
                giis_parameters b,
                giis_parameters c,
                giis_parameters d,
                giis_parameters e,
                giis_parameters f,
                giis_parameters g,
                giis_parameters h,
                giis_parameters i,
                giis_parameters j,
                giis_parameters k
          WHERE a.param_name = 'CONTRACTOR_ALL_RISK'
            AND b.param_name = 'ERECTION_ALL_RISK'
            AND c.param_name = 'MACHINERY_BREAKDOWN_INSURANCE'
            AND d.param_name = 'MACHINERY_LOSS_OF_PROFIT'
            AND e.param_name = 'DETERIORATION_OF_STOCKS'
            AND f.param_name = 'BOILER_AND_PRESSURE_VESSEL'
            AND g.param_name = 'ELECTRONIC_EQUIPMENT'
            AND h.param_name = 'PRINCIPAL_CONTROL_POLICY'
            AND i.param_name = 'OPEN_POLICY'
            AND j.param_name = 'BANKERS BLANKET INSURANCE'
            AND k.param_name = 'SUBLINE_MN_MOP';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_subline_car := 'CAR';
            v_subline_ear := 'EAR';
            v_subline_mbi := 'MBI';
            v_subline_mlop := 'MLOP';
            v_subline_dos := 'DOS';
            v_subline_bpv := 'BPV';
            v_subline_eei := 'EEI';
            v_subline_pcp := 'PCP';
            v_subline_op := 'OP';
            v_subline_oth := 'OTH';
      END;

      FOR i IN (SELECT *
                  FROM (SELECT TO_CHAR(a.incept_date, 'MM-DD-RRRR') incept_date,
                               TO_CHAR(a.expiry_date, 'MM-DD-RRRR') expiry_date,
                               TO_CHAR(a.issue_date, 'MM-DD-RRRR') issue_date,
                               TO_CHAR(a.eff_date, 'MM-DD-RRRR') eff_date,
                               TO_CHAR(a.endt_expiry_date, 'MM-DD-RRRR') endt_expiry_date,
                               a.ref_pol_no,
                               a.manual_renew_no, a.actual_renew_no,
                               a.issue_yy, a.prem_amt, a.tsi_amt, a.risk_tag,
                               a.incept_tag, a.expiry_tag, a.plan_sw,
                               a.endt_expiry_tag, a.bancassurance_sw,
                               a.surcharge_sw, a.discount_sw, a.pack_pol_flag,
                               a.auto_renew_flag, a.foreign_acc_sw,
                               a.reg_policy_sw, a.prem_warr_tag,
                               a.prem_warr_days, a.fleet_print_tag,
                               a.with_tariff_sw, a.co_insurance_sw,
                               a.prorate_flag, a.short_rt_percent,
                               a.prov_prem_tag, a.prov_prem_pct, a.comp_sw,
                               a.ann_tsi_amt, a.ann_prem_amt, a.line_cd,
                               a.subline_cd, a.iss_cd, a.pol_seq_no,
                               a.renew_no,
                                  a.line_cd
                               || '-'
                               || a.subline_cd
                               || '-'
                               || a.iss_cd
                               || '-'
                               || a.issue_yy
                               || '-'
                               || a.pol_seq_no
                               || '-'
                               || a.renew_no pol_no,
                               a.policy_id, a.address1, a.address2,
                               a.address3, a.endt_seq_no, a.booking_year,
                               a.booking_mth, a.survey_agent_cd,
                               a.settling_agent_cd, b.gen_info01,
                               b.gen_info02, b.gen_info03, b.gen_info04,
                               b.gen_info05, b.gen_info06, b.gen_info07,
                               b.gen_info08, b.gen_info09, b.gen_info10,
                               b.gen_info11, b.gen_info12, b.gen_info13,
                               b.gen_info14, b.gen_info15, b.gen_info16,
                               b.gen_info17, b.initial_info01,
                               b.initial_info02, b.initial_info03,
                               b.initial_info04, b.initial_info05,
                               b.initial_info06, b.initial_info07,
                               b.initial_info08, b.initial_info09,
                               b.initial_info10, b.initial_info11,
                               b.initial_info12, b.initial_info13,
                               b.initial_info14, b.initial_info15,
                               b.initial_info16, b.initial_info17,
                               c.endt_text01, c.endt_text02, c.endt_text03,
                               c.endt_text04, c.endt_text05, c.endt_text06,
                               c.endt_text07, c.endt_text08, c.endt_text09,
                               c.endt_text10, c.endt_text11, c.endt_text12,
                               c.endt_text13, c.endt_text14, c.endt_text15,
                               c.endt_text16, c.endt_text17, d.type_desc,
                               e.industry_nm, f.region_desc, g.iss_name,
                               h.remarks, i.takeup_term_desc, j.line_name
                          FROM gipi_polbasic a,
                               gipi_polgenin b,
                               gipi_endttext c,
                               giis_policy_type d,
                               giis_industry e,
                               giis_region f,
                               giis_issource g,
                               gipi_parlist h,
                               giis_takeup_term i,
                               giis_line j
                         WHERE a.policy_id = b.policy_id(+)
                           AND a.policy_id = c.policy_id(+)
                           AND a.line_cd = d.line_cd(+)
                           AND a.type_cd = d.type_cd(+)
                           AND a.industry_cd = e.industry_cd(+)
                           AND a.region_cd = f.region_cd(+)
                           AND a.cred_branch = g.iss_cd(+)
                           AND a.par_id = h.par_id(+)
                           AND a.takeup_term = i.takeup_term(+)
                           AND a.line_cd = j.line_cd(+))
                 WHERE policy_id = NVL (p_policy_id, policy_id))
      LOOP
         v_basic_info.policy_id := i.policy_id;
         v_basic_info.pol_no := i.pol_no;
         v_basic_info.address1 := i.address1;
         v_basic_info.address2 := i.address2;
         v_basic_info.address3 := i.address3;
         v_basic_info.endt_seq_no := i.endt_seq_no;
         v_basic_info.booking_year := i.booking_year;
         v_basic_info.booking_mth := i.booking_mth;
         v_basic_info.type_desc := i.type_desc;
         v_basic_info.industry_nm := i.industry_nm;
         v_basic_info.region_desc := i.region_desc;
         v_basic_info.iss_name := i.iss_name;
         v_basic_info.remarks := i.remarks;
         v_basic_info.takeup_term_desc := i.takeup_term_desc;
         v_basic_info.line_name := i.line_name;
         v_basic_info.incept_date := i.incept_date;
         v_basic_info.expiry_date := i.expiry_date;
         v_basic_info.issue_date := i.issue_date;
         v_basic_info.eff_date := i.eff_date;
         v_basic_info.endt_expiry_date := i.endt_expiry_date;
         v_basic_info.ref_pol_no := i.ref_pol_no;
         v_basic_info.manual_renew_no := i.manual_renew_no;
         v_basic_info.actual_renew_no := i.actual_renew_no;
         v_basic_info.issue_yy := i.issue_yy;
         v_basic_info.prem_amt := i.prem_amt;
         v_basic_info.tsi_amt := i.tsi_amt;
         v_basic_info.risk_tag := i.risk_tag;
         v_basic_info.incept_tag := i.incept_tag;
         v_basic_info.expiry_tag := i.expiry_tag;
         v_basic_info.plan_sw := i.plan_sw;
         v_basic_info.endt_expiry_tag := i.endt_expiry_tag;
         v_basic_info.bancassurance_sw := i.bancassurance_sw;
         v_basic_info.surcharge_sw := i.surcharge_sw;
         v_basic_info.discount_sw := i.discount_sw;
         v_basic_info.pack_pol_flag := i.pack_pol_flag;
         v_basic_info.auto_renew_flag := i.auto_renew_flag;
         v_basic_info.foreign_acc_sw := i.foreign_acc_sw;
         v_basic_info.reg_policy_sw := i.reg_policy_sw;
         v_basic_info.prem_warr_tag := i.prem_warr_tag;
         v_basic_info.prem_warr_days := i.prem_warr_days;
         v_basic_info.fleet_print_tag := i.fleet_print_tag;
         v_basic_info.with_tariff_sw := i.with_tariff_sw;
         v_basic_info.co_insurance_sw := i.co_insurance_sw;
         v_basic_info.prorate_flag := i.prorate_flag;
         v_basic_info.short_rt_percent := i.short_rt_percent;
         v_basic_info.prov_prem_tag := i.prov_prem_tag;
         v_basic_info.prov_prem_pct := i.prov_prem_pct;
         v_basic_info.comp_sw := i.comp_sw;
         v_basic_info.ann_tsi_amt := i.ann_tsi_amt;
         v_basic_info.ann_prem_amt := i.ann_prem_amt;
         v_basic_info.survey_agent_cd := i.survey_agent_cd;
         v_basic_info.settling_agent_cd := i.settling_agent_cd;
         v_basic_info.gen_info01 := i.gen_info01;
         v_basic_info.gen_info02 := i.gen_info02;
         v_basic_info.gen_info03 := i.gen_info03;
         v_basic_info.gen_info04 := i.gen_info04;
         v_basic_info.gen_info05 := i.gen_info05;
         v_basic_info.gen_info06 := i.gen_info06;
         v_basic_info.gen_info07 := i.gen_info07;
         v_basic_info.gen_info08 := i.gen_info08;
         v_basic_info.gen_info09 := i.gen_info09;
         v_basic_info.gen_info10 := i.gen_info10;
         v_basic_info.gen_info11 := i.gen_info11;
         v_basic_info.gen_info12 := i.gen_info12;
         v_basic_info.gen_info13 := i.gen_info13;
         v_basic_info.gen_info14 := i.gen_info14;
         v_basic_info.gen_info15 := i.gen_info15;
         v_basic_info.gen_info16 := i.gen_info16;
         v_basic_info.gen_info17 := i.gen_info17;
         v_basic_info.subline_cd_param := GIIS_PARAMETERS_PKG.GET_ENGG_SUBLINE_NAME(i.subline_cd); --added by robert SR 20307 10.27.15
         IF (i.endt_seq_no = 0)
         THEN
            v_basic_info.info01 := i.initial_info01;
            v_basic_info.info02 := i.initial_info02;
            v_basic_info.info03 := i.initial_info03;
            v_basic_info.info04 := i.initial_info04;
            v_basic_info.info05 := i.initial_info05;
            v_basic_info.info06 := i.initial_info06;
            v_basic_info.info07 := i.initial_info07;
            v_basic_info.info08 := i.initial_info08;
            v_basic_info.info09 := i.initial_info09;
            v_basic_info.info10 := i.initial_info10;
            v_basic_info.info11 := i.initial_info11;
            v_basic_info.info12 := i.initial_info12;
            v_basic_info.info13 := i.initial_info13;
            v_basic_info.info14 := i.initial_info14;
            v_basic_info.info15 := i.initial_info15;
            v_basic_info.info16 := i.initial_info16;
            v_basic_info.info17 := i.initial_info17;
            v_basic_info.dsp_text := NULL;
            v_basic_info.prompt_text := 'Initial Information';
         ELSE
            v_basic_info.info01 := i.endt_text01;
            v_basic_info.info02 := i.endt_text02;
            v_basic_info.info03 := i.endt_text03;
            v_basic_info.info04 := i.endt_text04;
            v_basic_info.info05 := i.endt_text05;
            v_basic_info.info06 := i.endt_text06;
            v_basic_info.info07 := i.endt_text07;
            v_basic_info.info08 := i.endt_text08;
            v_basic_info.info09 := i.endt_text09;
            v_basic_info.info10 := i.endt_text10;
            v_basic_info.info11 := i.endt_text11;
            v_basic_info.info12 := i.endt_text12;
            v_basic_info.info13 := i.endt_text13;
            v_basic_info.info14 := i.endt_text14;
            v_basic_info.info15 := i.endt_text15;
            v_basic_info.info16 := i.endt_text16;
            v_basic_info.info17 := i.endt_text17;
            v_basic_info.dsp_text := 'Endt Expiry Date';
            v_basic_info.prompt_text := 'Endorsement Information';
         END IF;

         FOR j IN (SELECT rv_meaning
                     FROM cg_ref_codes
                    WHERE rv_domain = 'GIPI_POLBASIC.RISK_TAG'
                      AND rv_low_value = i.risk_tag)
         LOOP
            v_basic_info.risk_desc := j.rv_meaning;
         END LOOP;

         IF i.survey_agent_cd IS NOT NULL
         THEN
            SELECT payee_no,
                      DECODE (payee_first_name,
                              NULL, NULL,
                              payee_first_name || ' '
                             )
                   || DECODE (payee_middle_name,
                              NULL, NULL,
                              payee_middle_name || ' '
                             )
                   || payee_last_name
              INTO v_survey_payee_no,
                   v_basic_info.survey_agent
              FROM giis_payees
             WHERE payee_no = i.survey_agent_cd
               AND payee_class_cd IN (SELECT param_value_v
                                        FROM giis_parameters
                                       WHERE param_name = 'SURVEY_PAYEE_CLASS');
         ELSE
            v_basic_info.survey_agent := NULL;
         END IF;

         IF i.settling_agent_cd IS NOT NULL
         THEN
            SELECT payee_no,
                      DECODE (payee_first_name,
                              NULL, NULL,
                              payee_first_name || ' '
                             )
                   || DECODE (payee_middle_name,
                              NULL, NULL,
                              payee_middle_name || ' '
                             )
                   || payee_last_name NAME
              INTO v_settling_payee_no,
                   v_basic_info.settling_agent
              FROM giis_payees
             WHERE payee_no = i.settling_agent_cd
               AND payee_class_cd IN (
                                     SELECT param_value_v
                                       FROM giis_parameters
                                      WHERE param_name =
                                                        'SETTLING_PAYEE_CLASS');
         ELSE
            v_basic_info.settling_agent := NULL;
         END IF;

         IF i.pack_pol_flag = 'Y'
         THEN
            FOR x IN (SELECT pack_line_cd
                        FROM gipi_item
                       WHERE policy_id = i.policy_id)
            LOOP
               v_line_cd := x.pack_line_cd;
            END LOOP;
         ELSE
            v_line_cd := i.line_cd;
         END IF;

         SELECT menu_line_cd
           INTO v_menu_line_cd
           FROM giis_line
          WHERE line_cd = NVL(v_line_cd, i.line_cd);  --added by d.alcantara,03-13-2012

         IF v_line_cd = v_line_mn OR v_menu_line_cd = 'MN'
         THEN
            v_basic_info.line_type := 'marine';
         ELSE
            v_basic_info.line_type := NULL;
         END IF;

         SELECT policy_id, line_cd, subline_cd
           INTO v_policy_endtseq0, v_line_cd_endtseq0, v_subline_cd_endtseq0
           FROM gipi_polbasic
          WHERE endt_seq_no = 0
            AND line_cd = i.line_cd
            AND subline_cd = i.subline_cd
            AND iss_cd = i.iss_cd
            AND issue_yy = i.issue_yy
            AND pol_seq_no = i.pol_seq_no
            AND renew_no = i.renew_no;

         v_basic_info.policy_endtseq0 := v_policy_endtseq0;

         BEGIN
            SELECT 'exists in gipi_polnrep'
              INTO v_exist_or_not
              FROM (SELECT DISTINCT policy_id
                               FROM gipi_polbasic
                              WHERE policy_id IN (
                                                 SELECT DISTINCT old_policy_id
                                                            FROM gipi_polnrep)
                                 OR policy_id IN (
                                                 SELECT DISTINCT new_policy_id
                                                            FROM gipi_polnrep))
             WHERE policy_id = v_policy_endtseq0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist_or_not := NULL;
         END;

         IF v_exist_or_not = 'exists in gipi_polnrep'
         THEN
            FOR a IN (SELECT 1
                        FROM gipi_polnrep
                       WHERE old_policy_id = v_policy_endtseq0)
            LOOP
               v_basic_info.policy_id_type := 'old';
               EXIT;
            END LOOP;

            FOR b IN (SELECT 1
                        FROM gipi_polnrep
                       WHERE new_policy_id = v_policy_endtseq0)
            LOOP
               v_basic_info.policy_id_type := 'new';
               EXIT;
            END LOOP;
         ELSE
            v_basic_info.policy_id_type := NULL;
         END IF;

         SELECT giacp.v ('DEFAULT_CURRENCY')
           INTO v_basic_info.default_currency
           FROM DUAL;

         BEGIN
            SELECT contract_proj_buss_title,
                   site_location,
                   construct_start_date,
                   construct_end_date,
                   maintain_start_date,
                   maintain_end_date,
                   mbi_policy_no, weeks_test,
                   time_excess
              INTO v_basic_info.contract_proj_buss_title,
                   v_basic_info.site_location,
                   v_basic_info.construct_start_date,
                   v_basic_info.construct_end_date,
                   v_basic_info.maintain_start_date,
                   v_basic_info.maintain_end_date,
                   v_basic_info.mbi_policy_no, v_basic_info.weeks_test,
                   v_basic_info.time_excess
              FROM gipi_engg_basic
             WHERE policy_id = i.policy_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_basic_info.contract_proj_buss_title := NULL;
               v_basic_info.site_location := NULL;
               v_basic_info.construct_start_date := NULL;
               v_basic_info.construct_end_date := NULL;
               v_basic_info.maintain_start_date := NULL;
               v_basic_info.maintain_end_date := NULL;
               v_basic_info.mbi_policy_no := NULL;
               v_basic_info.weeks_test := NULL;
               v_basic_info.time_excess := NULL;
         END;

         IF i.subline_cd = v_subline_car
         THEN
            v_basic_info.prompt_title := 'Title of Contract';
            v_basic_info.prompt_location := 'Contract Site Location';
         ELSIF i.subline_cd = v_subline_ear
         THEN
            v_basic_info.prompt_title := 'Project';
            v_basic_info.prompt_location := 'Site of Erection';
         ELSIF i.subline_cd = v_subline_eei
         THEN
            v_basic_info.prompt_title := 'Description';
            v_basic_info.prompt_location := 'The Premises';
         ELSIF i.subline_cd = v_subline_mbi
         THEN
            v_basic_info.prompt_title := 'Nature of Business';
            v_basic_info.prompt_location := 'Work Site';
         ELSIF i.subline_cd = v_subline_mlop
         THEN
            v_basic_info.prompt_title := 'Nature of Business';
            v_basic_info.prompt_location := 'The Premises';
         ELSIF i.subline_cd = v_subline_dos
         THEN
            v_basic_info.prompt_title := 'Description';
            v_basic_info.prompt_location := 'Location of Refrigeration Plant';
         ELSIF i.subline_cd = v_subline_bpv
         THEN
            v_basic_info.prompt_title := 'Description';
            v_basic_info.prompt_location := 'The Premises';
         ELSIF i.subline_cd = v_subline_pcp
         THEN
            v_basic_info.prompt_title := 'Description';
            v_basic_info.prompt_location := 'Territorial Limits';
         ELSE
            v_basic_info.prompt_title := 'Title';
            v_basic_info.prompt_location := 'Location';
         END IF;

         IF     v_line_cd_endtseq0 = v_line_ca
            AND v_subline_cd_endtseq0 = v_subline_bbi
         THEN
            v_basic_info.bank_btn_label := 'Bank Collection';
         ELSIF v_line_cd_endtseq0 = v_line_mn
         THEN
            v_basic_info.bank_btn_label := 'Cargo Information';
         ELSE
            v_basic_info.bank_btn_label := NULL;
         END IF;

         BEGIN
            SELECT open_policy_sw, op_flag
              INTO v_open_policy_sw, v_op_flag
              FROM giis_subline
             WHERE line_cd = v_line_cd_endtseq0
               AND subline_cd = v_subline_cd_endtseq0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_open_policy_sw := '';
               v_op_flag := '';
         END;

         IF v_open_policy_sw = 'Y'
         THEN
            v_basic_info.open_policy_view := 'openPolicy';
         ELSIF v_op_flag = 'Y'
         THEN
            IF    v_line_cd_endtseq0 = v_line_fi
               OR v_line_cd_endtseq0 = v_line_mn
            THEN
               v_basic_info.open_policy_view := 'openLiabFiMn';
            ELSE
               v_basic_info.open_policy_view := 'openLiab';
            END IF;
         ELSE
            v_basic_info.open_policy_view := '';
         END IF;
         --added by robert SR 21862 03.08.16
         FOR c1 IN (SELECT 1
                      FROM gipi_item
                     WHERE policy_id = v_basic_info.policy_id
                       AND currency_cd <> GIACP.N('CURRENCY_CD'))
         LOOP
            v_basic_info.is_foreign_currency := 'Y';
            EXIT;
         END LOOP; 

         PIPE ROW (v_basic_info);
      END LOOP;
   END get_polbasic_info;                                     --MOSES 03182011

   FUNCTION get_polbasic_gipir311_info (
      p_policy_id   gipi_polbasic.policy_id%TYPE
   )
      RETURN gipi_polbasic_gipir311_tab PIPELINED
   IS
      v_gipir311   gipi_polbasic_gipir311_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT (get_policy_no (p_policy_id)) policy_no,
                          a.policy_id,
                          UPPER (TO_CHAR (a.expiry_date, 'MM/DD RRRR')
                                ) expiry_date,
                          TO_CHAR (NVL (NVL (c.from_date, b.from_date),
                                        a.eff_date
                                       ),
                                   'MM/DD/RR'
                                  ) eff_date,
                          c.grouped_item_no,
                             TO_CHAR (b.item_no)
                          || '-'
                          || TO_CHAR (c.grouped_item_no) cert_no,
                          UPPER (c.grouped_item_title) title, a.line_cd,
                          b.item_no, c.grouped_item_no grp_perilfilter,
                          TO_CHAR (issue_date, 'DD') || 'th' issue_day,
                          INITCAP (TO_CHAR (issue_date, 'FMmonth, YYYY')
                                  ) issue_month_year,
                          a.iss_cd
                     FROM gipi_polbasic a, gipi_item b, gipi_grouped_items c
                    WHERE b.policy_id = a.policy_id
                      AND c.policy_id = b.policy_id
                      AND b.item_no = c.item_no
                      AND a.policy_id = p_policy_id
                 ORDER BY c.grouped_item_no ASC)
      LOOP
         v_gipir311.policy_no := i.policy_no;
         v_gipir311.policy_id := i.policy_id;
         v_gipir311.expiry_date := i.expiry_date;
         v_gipir311.eff_date := i.eff_date;
         v_gipir311.grouped_item_no := i.grouped_item_no;
         v_gipir311.cert_no := i.cert_no;
         v_gipir311.title := i.title;
         v_gipir311.issue_day := i.issue_day;
         v_gipir311.issue_month_year := i.issue_month_year;
         v_gipir311.iss_cd := i.iss_cd;
         v_gipir311.grp_perilfilter := i.grp_perilfilter;
         PIPE ROW (v_gipir311);
      END LOOP;
   END;

   -- modified by d.alcantara, 09/26/2011
   FUNCTION get_gipir915_polbasic_info (p_policy_id gipi_item.policy_id%TYPE)
      RETURN gipi_gipir915_polbasic_tab PIPELINED
   IS
      v_gipir915   gipi_gipir915_polbasic_type;
      v_item_no    gipi_item.item_no%TYPE;
   BEGIN
      FOR a IN (SELECT b170.item_no item_no
                  FROM gipi_polbasic b250, gipi_item b170
                 WHERE b250.policy_id = b170.policy_id
                   AND b250.policy_id = p_policy_id)
      LOOP
         v_item_no := a.item_no;
      END LOOP;

      FOR i IN (SELECT b250.policy_id policy_id,/* a020.assd_name assd_name,*/
                       decode(a020.designation, null, a020.assd_name ||' '|| a020.assd_name2
                             ,a020.designation||' '||a020.assd_name ||' '|| a020.assd_name2) assd_name, --edited by d.alcantara, 02-02-2012
                       b250.subline_cd subline_code,
                       UPPER (b250.address1) address1,
                       UPPER (b250.address2) address2,
                       UPPER (b250.address3) address3,
                          b250.line_cd
                       || '-'
                       || b250.subline_cd
                       || '-'
                       || b250.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (b250.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (b250.pol_seq_no, '0999999'))
                       || '-'
                       || LTRIM (TO_CHAR (b250.renew_no, '09')) policy_no1,
                       TO_CHAR (b250.issue_date, 'FMmm/dd/yyyy') issue_date,
                       TO_CHAR (b250.incept_date, 'FMmm/dd/yyyy') incept_date,
                       TO_CHAR (b250.expiry_date, 'FMmm/dd/yyyy') expiry_date,
                       b170.item_no item_no, b170.from_date, b170.TO_DATE,
                       b170.currency_rt, b290.make make,
                       b290.model_year model_year,
                          LTRIM (LTRIM (TO_CHAR (b290.coc_yy, '09')))
                       || '-'
                       || LTRIM (TO_CHAR (b290.coc_serial_no, '0999999'))
                                                                       coc_no,
                       b290.color color, b290.plate_no plate_no,
                       b290.serial_no serial_no, b290.motor_no motor_no,
                       b290.no_of_pass capacity, b290.unladen_wt unladen_wt,
                       b290.mot_type mot_type, b290.type_of_body_cd,
                       b290.mv_file_no file_no,
                       b290.coc_serial_no coc_serial_no,
                       co.car_company
                  FROM gipi_polbasic b250,
                       gipi_item b170,
                       gipi_vehicle b290,
                       giis_assured a020,
                       giis_mc_car_company co
                 WHERE b250.policy_id = p_policy_id
                   AND b250.policy_id = b170.policy_id
                   AND b170.policy_id = b290.policy_id
                   AND b170.item_no = b290.item_no
                   AND a020.assd_no = b250.assd_no
                   AND b290.car_company_cd = co.car_company_cd (+) --added 03-19-2012, based on FLT SR8770, to handle null car_company_cd in gipi_wvehicle
                   AND b290.coc_serial_no IS NOT NULL)
      LOOP
         v_gipir915.policy_id := i.policy_id;
         v_gipir915.assd_name := i.assd_name;
         v_gipir915.subline_cd := i.subline_code;
         v_gipir915.address1 := i.address1;
         v_gipir915.address2 := i.address2;
         v_gipir915.address3 := i.address3;
         v_gipir915.policy_no1 := i.policy_no1;
         v_gipir915.issue_date := i.incept_date;
         v_gipir915.incept_date := i.incept_date;
         v_gipir915.expiry_date := i.expiry_date;
         v_gipir915.item_no := i.item_no;
         v_gipir915.from_date := i.from_date;
         v_gipir915.TO_DATE := i.TO_DATE;
         v_gipir915.currency_rt := i.currency_rt;
         v_gipir915.make := get_car_company_gipir915 (p_policy_id, i.item_no);
         v_gipir915.model_year := i.model_year;
         v_gipir915.coc_no := i.coc_no;
         v_gipir915.color := i.color;
         v_gipir915.plate_no := i.plate_no;
         v_gipir915.serial_no := i.serial_no;
         v_gipir915.motor_no := i.motor_no;
         v_gipir915.no_of_pass := i.capacity;
         v_gipir915.unladen_wt := i.unladen_wt;
         v_gipir915.mot_type := i.mot_type;
         v_gipir915.type_of_body_cd := i.type_of_body_cd;
         v_gipir915.mv_file_no := i.file_no;
         v_gipir915.coc_serial_no := i.coc_serial_no;
         v_gipir915.cf_coc_signatory := cf_coc_signatory ('GIPIR915');
         v_gipir915.cf_print_signatory := cf_print_signatory ();
         v_gipir915.car_company := i.car_company;
         PIPE ROW (v_gipir915);
      END LOOP;
   END get_gipir915_polbasic_info;

    --modified by reymon added to_char to dates reymon 11132013
   FUNCTION get_polbasic_info_su (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_polbasic_info_su_tab PIPELINED
   IS
      v_basic_info   gipi_polbasic_info_su_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT a.pol_flag, TO_CHAR(a.issue_date, 'MM-DD-RRRR') issue_date,
                               TO_CHAR(a.incept_date, 'MM-DD-RRRR') incept_date, a.incept_tag,
                               TO_CHAR(a.eff_date, 'MM-DD-RRRR') eff_date, a.expiry_tag,
                               a.endt_seq_no, a.auto_renew_flag,
                               a.reg_policy_sw, a.bancassurance_sw,
                               a.address1, a.address2, a.address3,
                               a.mortg_name, a.booking_year, a.booking_mth,
                               a.subline_cd, a.ref_pol_no, TO_CHAR(a.expiry_date, 'MM-DD-RRRR') expiry_date,
                               TO_CHAR(a.endt_expiry_date, 'MM-DD-RRRR') endt_expiry_date,
                               b.gen_info01, b.gen_info02,
                               b.gen_info03, b.gen_info04, b.gen_info05,
                               b.gen_info06, b.gen_info07, b.gen_info08,
                               b.gen_info09, b.gen_info10, b.gen_info11,
                               b.gen_info12, b.gen_info13, b.gen_info14,
                               b.gen_info15, b.gen_info16, b.gen_info17,
                               c.endt_text01, c.endt_text02, c.endt_text03,
                               c.endt_text04, c.endt_text05, c.endt_text06,
                               c.endt_text07, c.endt_text08, c.endt_text09,
                               c.endt_text10, c.endt_text11, c.endt_text12,
                               c.endt_text13, c.endt_text14, c.endt_text15,
                               c.endt_text16, c.endt_text17,
                               d.takeup_term_desc, e.industry_nm,
                               f.region_desc, g.val_period, g.val_period_unit,
                               a.policy_id
                          FROM gipi_polbasic a,
                               gipi_polgenin b,
                               gipi_endttext c,
                               giis_takeup_term d,
                               giis_industry e,
                               giis_region f,
                               gipi_bond_basic g,
                               giis_line h --added by robert 11.27.14
                         WHERE (a.line_cd = 'SU' OR h.menu_line_cd = 'SU' OR a.line_cd = giisp.v('LINE_CODE_SU')) --added by robert 11.27.14
                           AND a.policy_id = b.policy_id(+)
                           AND a.policy_id = c.policy_id(+)
                           AND a.takeup_term = d.takeup_term(+)
                           AND a.industry_cd = e.industry_cd(+)
                           AND a.region_cd = f.region_cd(+)
                           AND a.policy_id = g.policy_id(+)
                           AND a.line_cd = h.line_cd) --added by robert 11.27.14
                 WHERE policy_id = NVL (p_policy_id, policy_id))
      LOOP
         v_basic_info.policy_id := i.policy_id;
         v_basic_info.address1 := i.address1;
         v_basic_info.address2 := i.address2;
         v_basic_info.address3 := i.address3;
         v_basic_info.booking_year := i.booking_year;
         v_basic_info.booking_mth := i.booking_mth;
         v_basic_info.industry_nm := i.industry_nm;
         v_basic_info.region_desc := i.region_desc;
         v_basic_info.takeup_term_desc := i.takeup_term_desc;
         v_basic_info.incept_date := i.incept_date;
         v_basic_info.expiry_date := i.expiry_date;
         v_basic_info.issue_date := i.issue_date;
         v_basic_info.eff_date := i.eff_date;
         v_basic_info.endt_expiry_date := i.endt_expiry_date;
         v_basic_info.ref_pol_no := i.ref_pol_no;
         v_basic_info.incept_tag := i.incept_tag;
         v_basic_info.expiry_tag := i.expiry_tag;
         v_basic_info.bancassurance_sw := i.bancassurance_sw;
         v_basic_info.reg_policy_sw := i.reg_policy_sw;
         v_basic_info.auto_renew_flag := i.auto_renew_flag;
         v_basic_info.pol_flag := i.pol_flag;
         v_basic_info.subline_cd := i.subline_cd;
         v_basic_info.endt_seq_no := i.endt_seq_no;
         v_basic_info.mortg_name := i.mortg_name;
         v_basic_info.val_period := i.val_period;
         v_basic_info.val_period_unit := NVL (i.val_period_unit, 'D');
         v_basic_info.gen_info01 := i.gen_info01;
         v_basic_info.gen_info02 := i.gen_info02;
         v_basic_info.gen_info03 := i.gen_info03;
         v_basic_info.gen_info04 := i.gen_info04;
         v_basic_info.gen_info05 := i.gen_info05;
         v_basic_info.gen_info06 := i.gen_info06;
         v_basic_info.gen_info07 := i.gen_info07;
         v_basic_info.gen_info08 := i.gen_info08;
         v_basic_info.gen_info09 := i.gen_info09;
         v_basic_info.gen_info10 := i.gen_info10;
         v_basic_info.gen_info11 := i.gen_info11;
         v_basic_info.gen_info12 := i.gen_info12;
         v_basic_info.gen_info13 := i.gen_info13;
         v_basic_info.gen_info14 := i.gen_info14;
         v_basic_info.gen_info15 := i.gen_info15;
         v_basic_info.gen_info16 := i.gen_info16;
         v_basic_info.gen_info17 := i.gen_info17;
         v_basic_info.endt_text01 := i.endt_text01;
         v_basic_info.endt_text02 := i.endt_text02;
         v_basic_info.endt_text03 := i.endt_text03;
         v_basic_info.endt_text04 := i.endt_text04;
         v_basic_info.endt_text05 := i.endt_text05;
         v_basic_info.endt_text06 := i.endt_text06;
         v_basic_info.endt_text07 := i.endt_text07;
         v_basic_info.endt_text08 := i.endt_text08;
         v_basic_info.endt_text09 := i.endt_text09;
         v_basic_info.endt_text10 := i.endt_text10;
         v_basic_info.endt_text11 := i.endt_text11;
         v_basic_info.endt_text12 := i.endt_text12;
         v_basic_info.endt_text13 := i.endt_text13;
         v_basic_info.endt_text14 := i.endt_text14;
         v_basic_info.endt_text15 := i.endt_text15;
         v_basic_info.endt_text16 := i.endt_text16;
         v_basic_info.endt_text17 := i.endt_text17;

         IF (i.endt_seq_no = 0)
         THEN
            v_basic_info.dsp_endt_expiry_date := NULL;
            v_basic_info.prompt_text := NULL;
         ELSE
            v_basic_info.dsp_endt_expiry_date := 'Endt Expiry Date';
            v_basic_info.prompt_text := 'Endorsement Information';
         END IF;
         
         BEGIN
            SELECT rv_meaning
              INTO v_basic_info.pol_flag_desc
              FROM cg_ref_codes
             WHERE rv_low_value = i.pol_flag
               AND rv_domain LIKE '%GIPI_POLBASIC.POL_FLAG%';
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_basic_info.pol_flag_desc := NULL;         
         END;

         PIPE ROW (v_basic_info);
      END LOOP;
   END get_polbasic_info_su;                                   --moses04062011

   FUNCTION get_bank_payment_dtl (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN bank_payment_dtl_tab PIPELINED
   IS
      v_bank_payment_dtl   bank_payment_dtl_type;
   BEGIN
      FOR i IN (SELECT policy_id
                  FROM gipi_polbasic
                 WHERE policy_id = NVL (p_policy_id, policy_id))
      LOOP
      
         FOR a IN (SELECT company_cd,
                   b.payee_last_name
                || ', '
                || b.payee_first_name
                || ' '
                || b.payee_middle_name company_name
           --INTO v_bank_payment_dtl.company_cd,
           --     v_bank_payment_dtl.company_name
           FROM gipi_polbasic a, giis_payees b
          WHERE b.payee_class_cd = giacp.v ('COMPANY_CLASS_CD')
            AND a.company_cd = b.payee_no
            AND policy_id = i.policy_id)
         LOOP
            v_bank_payment_dtl.company_cd       := a.company_cd;
            v_bank_payment_dtl.company_name     := a.company_name;
         END LOOP;
        
         FOR b IN (SELECT a.employee_cd,
                   b.payee_last_name
                || ', '
                || b.payee_first_name
                || ' '
                || b.payee_middle_name employee_name
           --INTO v_bank_payment_dtl.employee_cd,
           --     v_bank_payment_dtl.employee_name
           FROM gipi_polbasic a, giis_payees b
          WHERE b.payee_class_cd = giacp.v ('EMP_CLASS_CD')
            AND a.employee_cd = b.ref_payee_cd
            AND policy_id = i.policy_id)
         LOOP
            v_bank_payment_dtl.employee_cd      := b.employee_cd;
            v_bank_payment_dtl.employee_name    := b.employee_name;
         END LOOP;

         SELECT bank_ref_no
           INTO v_bank_payment_dtl.bank_ref_no
           FROM gipi_polbasic
          WHERE policy_id = i.policy_id;

         PIPE ROW (v_bank_payment_dtl);
      END LOOP;
   END get_bank_payment_dtl;                                   --moses04082011

   FUNCTION get_bancassurance_dtl (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN bancassurance_dtl_tab PIPELINED
   IS
      v_bancassurance_dtl   bancassurance_dtl_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT a.policy_id, a.banc_type_cd, a.branch_cd,
                               a.area_cd, a.manager_cd, b.banc_type_desc,
                               c.area_desc, d.branch_desc,
                                  e.payee_last_name
                               || ', '
                               || e.payee_first_name
                               || ' '
                               || e.payee_middle_name payee_full_name
                          FROM gipi_polbasic a,
                               giis_banc_type b,
                               giis_banc_area c,
                               giis_banc_branch d,
                               giis_payees e
                         WHERE a.banc_type_cd = b.banc_type_cd
                           AND a.area_cd = c.area_cd
                           AND a.branch_cd = d.branch_cd
                           AND a.manager_cd = e.payee_no
                           AND e.payee_class_cd =
                                          giisp.v ('BANK_MANAGER_PAYEE_CLASS'))
                 WHERE policy_id = NVL (p_policy_id, policy_id))
      LOOP
         v_bancassurance_dtl.banc_type_cd := i.banc_type_cd;
         v_bancassurance_dtl.area_cd := i.area_cd;
         v_bancassurance_dtl.branch_cd := i.branch_cd;
         v_bancassurance_dtl.manager_cd := i.manager_cd;
         v_bancassurance_dtl.banc_type_desc := i.banc_type_desc;
         v_bancassurance_dtl.area_desc := i.area_desc;
         v_bancassurance_dtl.branch_desc := i.branch_desc;
         v_bancassurance_dtl.full_name := i.payee_full_name;
         PIPE ROW (v_bancassurance_dtl);
      END LOOP;
   END get_bancassurance_dtl;                                 --MOSES 04112011

   FUNCTION get_plan_dtl (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN plan_dtl_tab PIPELINED
   IS
      v_plan_dtl   plan_dtl_type;
   BEGIN
      FOR i IN (SELECT policy_id, plan_cd, plan_ch_tag, pack_policy_id
                  FROM gipi_polbasic
                 WHERE policy_id = NVL (p_policy_id, policy_id))
      LOOP
         v_plan_dtl.plan_cd := i.plan_cd;
         v_plan_dtl.plan_ch_tag := i.plan_ch_tag;

         IF i.pack_policy_id IS NOT NULL
         THEN
            SELECT plan_desc
              INTO v_plan_dtl.plan_desc
              FROM giis_pack_plan a
             WHERE a.plan_cd = i.plan_cd;
         ELSE
            SELECT plan_desc
              INTO v_plan_dtl.plan_desc
              FROM giis_plan a
             WHERE a.plan_cd = i.plan_cd;
         END IF;

         PIPE ROW (v_plan_dtl);
      END LOOP;
   END get_plan_dtl;                                          --MOSES 04112011

   FUNCTION get_policy_endtseq0 (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN policy_endtseq0_tab PIPELINED
   IS
      v_polbasic     policy_endtseq0_type;
      v_line_cd      gipi_polbasic.line_cd%TYPE;
      v_subline_cd   gipi_polbasic.subline_cd%TYPE;
      v_iss_cd       gipi_polbasic.iss_cd%TYPE;
      v_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no     gipi_polbasic.renew_no%TYPE;
   BEGIN
      SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
             renew_no
        INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no,
             v_renew_no
        FROM gipi_polbasic
       WHERE policy_id = p_policy_id;

      FOR i IN (SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                       a.issue_yy, a.pol_seq_no, a.renew_no, a.ref_pol_no,
                       a.endt_seq_no, a.expiry_date, a.assd_no, a.cred_branch,
                       a.issue_date, a.incept_date, a.pol_flag,
                       DECODE (a.pol_flag,
                               '1', 'New',
                               '2', 'Renewal',
                               '3', 'Replacement',
                               '4', 'Cancelled Endorsement',
                               '5', 'Spoiled',
                               'X', 'Expired'
                              ) mean_pol_flag,
                       b.line_cd nbt_line_cd, b.iss_cd nbt_iss_cd, b.par_yy,
                       b.par_seq_no, b.quote_seq_no, c.line_cd line_cd_rn,
                       c.iss_cd iss_cd_rn, c.rn_yy, c.rn_seq_no, d.assd_name,
                          e.line_cd
                       || ' - '
                       || e.subline_cd
                       || ' - '
                       || e.iss_cd
                       || ' - '
                       || TO_CHAR (e.issue_yy, '09')
                       || ' - '
                       || TO_CHAR (e.pol_seq_no, '099999')
                       || ' - '
                       || TO_CHAR (e.renew_no, '09') pack_pol_no,
                       e.pack_policy_id, f.iss_name
                  FROM gipi_polbasic a,
                       gipi_parlist b,
                       giex_rn_no c,
                       giis_assured d,
                       gipi_pack_polbasic e,
                       giis_issource f
                 WHERE a.endt_seq_no = 0
                   AND a.par_id = b.par_id(+)
                   AND a.policy_id = c.policy_id(+)
                   AND a.assd_no = d.assd_no(+)
                   AND a.pack_policy_id = e.pack_policy_id(+)
                   AND a.cred_branch = f.iss_cd(+)
                   AND a.line_cd = NVL (v_line_cd, a.line_cd)
                   AND a.subline_cd = NVL (v_subline_cd, a.subline_cd)
                   AND a.iss_cd = NVL (v_iss_cd, a.iss_cd)
                   AND a.issue_yy = NVL (v_issue_yy, a.issue_yy)
                   AND a.pol_seq_no = NVL (v_pol_seq_no, a.pol_seq_no)
                   AND a.renew_no = NVL (v_renew_no, a.renew_no))
      LOOP
         v_polbasic.policy_id := i.policy_id;
         v_polbasic.line_cd := i.line_cd;
         v_polbasic.subline_cd := i.subline_cd;
         v_polbasic.iss_cd := i.iss_cd;
         v_polbasic.issue_yy := i.issue_yy;
         v_polbasic.pol_seq_no := i.pol_seq_no;
         v_polbasic.renew_no := i.renew_no;
         v_polbasic.ref_pol_no := i.ref_pol_no;
         v_polbasic.endt_seq_no := i.endt_seq_no;
         v_polbasic.expiry_date := i.expiry_date;
         v_polbasic.assd_no := i.assd_no;
         v_polbasic.cred_branch := i.cred_branch;
         v_polbasic.issue_date := i.issue_date;
         v_polbasic.incept_date := i.incept_date;
         v_polbasic.pol_flag := i.pol_flag;
         v_polbasic.mean_pol_flag := i.mean_pol_flag;
         v_polbasic.nbt_line_cd := i.nbt_line_cd;
         v_polbasic.nbt_iss_cd := i.nbt_iss_cd;
         v_polbasic.par_yy := i.par_yy;
         v_polbasic.par_seq_no := i.par_seq_no;
         v_polbasic.quote_seq_no := i.quote_seq_no;
         v_polbasic.line_cd_rn := i.line_cd_rn;
         v_polbasic.iss_cd_rn := i.iss_cd_rn;
         v_polbasic.rn_yy := i.rn_yy;
         v_polbasic.rn_seq_no := i.rn_seq_no;
         v_polbasic.assd_name := i.assd_name;
         --v_polbasic.pack_pol_no := i.pack_pol_no; comment out by carloR 08-04-2016
         
         IF i.pack_pol_no = ' -  -  -  -  - '  --added by CarloR 08-04-2016 SR-5461 start
         THEN
             v_polbasic.pack_pol_no := '';
         ELSE
            v_polbasic.pack_pol_no := i.pack_pol_no;
         END IF; --end
         
         v_polbasic.pack_policy_id := i.pack_policy_id;
         v_polbasic.iss_name := i.iss_name;
         PIPE ROW (v_polbasic);
      END LOOP;                                                --MOSES 0413011

      RETURN;
   END get_policy_endtseq0;

   FUNCTION get_policy_per_assured (
   p_assd_no       gipi_parlist.assd_no%TYPE,
   p_user_id       gipi_polbasic.user_id%TYPE,
   p_module_id     giis_modules.module_id%TYPE)
      RETURN policy_per_assured_tab PIPELINED
   IS
      v_policy_per_assured   policy_per_assured_type;
   BEGIN
      FOR i IN (
      --SELECT *    commented out by Gzelle 07292014
      --            FROM (
                  SELECT   a.policy_id, a.line_cd, a.subline_cd,
                                 a.iss_cd, a.issue_yy, a.pol_seq_no,
                                 a.renew_no, a.endt_iss_cd, a.endt_yy,
                                 a.endt_seq_no, a.endt_type, a.incept_date,
                                 a.expiry_date, a.pol_flag, a.tsi_amt,
                                 a.prem_amt, a.par_id, a.acct_of_cd,
                                 a.endt_expiry_date, a.label_tag,
                                 a.cred_branch, b.assd_no,
                                    a.line_cd
                                 || ' - '
                                 || a.subline_cd
                                 || ' - '
                                 || a.iss_cd
                                 || ' - '
                                 || TO_CHAR (a.issue_yy, '09')
                                 || ' - '
                                 || TO_CHAR (a.pol_seq_no, '0000009')
                                 || ' - '
                                 || TO_CHAR (a.renew_no, '09') policy_no,
                                    a.endt_iss_cd
                                 || TO_CHAR (a.endt_yy, '09')
                                 || ' - '
                                 || TO_CHAR (a.endt_seq_no, '0000009')
                                 || ' - '
                                 || a.endt_type endt_no
                            FROM gipi_polbasic a, gipi_parlist b
                           WHERE a.par_id = b.par_id
                             AND b.assd_no = p_assd_no
                             AND a.line_cd = DECODE (check_user_per_line2 (a.line_cd, a.iss_cd, p_module_id, p_user_id), 1, a.line_cd, NULL)
                             AND a.iss_cd = DECODE (check_user_per_iss_cd2 (a.line_cd,a.iss_cd, p_module_id,p_user_id), 1, a.iss_cd, NULL ) -- added by gab 07.22.2015
                        ORDER BY a.line_cd,
                                 a.subline_cd,
                                 a.iss_cd,
                                 a.issue_yy,
                                 a.pol_seq_no,
                                 a.renew_no)
                 --WHERE assd_no = NVL (p_assd_no, assd_no))    commented out by Gzelle 07292014
      LOOP
         v_policy_per_assured.policy_id := i.policy_id;
         v_policy_per_assured.line_cd := i.line_cd;
         v_policy_per_assured.subline_cd := i.subline_cd;
         v_policy_per_assured.iss_cd := i.iss_cd;
         v_policy_per_assured.issue_yy := i.issue_yy;
         v_policy_per_assured.pol_seq_no := i.pol_seq_no;
         v_policy_per_assured.renew_no := i.renew_no;
         v_policy_per_assured.endt_iss_cd := i.endt_iss_cd;
         v_policy_per_assured.endt_yy := i.endt_yy;
         v_policy_per_assured.endt_seq_no := i.endt_seq_no;
         v_policy_per_assured.endt_type := i.endt_type;
         v_policy_per_assured.incept_date := TRUNC(i.incept_date); -- added by gab 07.22.2015
         v_policy_per_assured.expiry_date := TRUNC(i.expiry_date);
         v_policy_per_assured.pol_flag := i.pol_flag;
         v_policy_per_assured.tsi_amt := i.tsi_amt;
         v_policy_per_assured.prem_amt := i.prem_amt;
         v_policy_per_assured.par_id := i.par_id;
         v_policy_per_assured.acct_of_cd := i.acct_of_cd;
         v_policy_per_assured.endt_expiry_date := i.endt_expiry_date;
         v_policy_per_assured.label_tag := i.label_tag;
         v_policy_per_assured.cred_branch := i.cred_branch;
         v_policy_per_assured.assd_no := i.assd_no;
         v_policy_per_assured.policy_no := i.policy_no;

         IF v_policy_per_assured.endt_seq_no > 0
         THEN
            v_policy_per_assured.endt_no := i.endt_no;
         ELSE
            v_policy_per_assured.endt_no := NULL;
         END IF;

         SELECT DECODE (pol_flag,
                        '1', 'New',
                        '2', 'Renewal',
                        '3', 'Replacement',
                        '4', 'Cancelled Endorsement',
                        '5', 'Spoiled',
                        'X', 'Expired'
                       )
           INTO v_policy_per_assured.mean_pol_flag
           FROM gipi_polbasic
          WHERE line_cd = i.line_cd
            AND subline_cd = i.subline_cd
            AND iss_cd = i.iss_cd
            AND issue_yy = i.issue_yy
            AND pol_seq_no = i.pol_seq_no
            AND renew_no = i.renew_no
            AND endt_iss_cd = i.endt_iss_cd
            AND endt_yy = i.endt_yy
            AND endt_seq_no = i.endt_seq_no;

         PIPE ROW (v_policy_per_assured);

         BEGIN
            SELECT designation || ' ' || assd_name
              INTO v_policy_per_assured.acct_of
              FROM giis_assured
             WHERE assd_no = i.acct_of_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      END LOOP;
   END get_policy_per_assured;                                --MOSES 04152011

   FUNCTION get_policy_per_obligee (
      p_obligee_no   gipi_bond_basic.obligee_no%TYPE
   )
      RETURN policy_per_obligee_tab PIPELINED
   IS
      v_policy_per_obligee   policy_per_obligee_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                               a.issue_yy, a.pol_seq_no, a.renew_no,
                               a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                               a.endt_type, a.tsi_amt, a.prem_amt, a.par_id,
                               a.acct_of_cd, a.endt_expiry_date, a.label_tag,
                               a.cred_branch, b.obligee_no,
                                  a.line_cd
                               || a.subline_cd
                               || ' - '
                               || a.iss_cd
                               || ' - '
                               || TO_CHAR (a.issue_yy, '09')
                               || ' - '
                               || TO_CHAR (a.pol_seq_no, '0000009')
                               || ' - '
                               || TO_CHAR (a.renew_no, '09') policy_no,
                                  a.endt_iss_cd
                               || TO_CHAR (a.endt_yy, '09')
                               || ' - '
                               || TO_CHAR (a.endt_seq_no, '0000009')
                               || ' - '
                               || a.endt_type endt_no
                          FROM gipi_polbasic a, gipi_bond_basic b
                         WHERE a.policy_id = b.policy_id)
                 WHERE obligee_no = NVL (p_obligee_no, obligee_no))
      LOOP
         v_policy_per_obligee.policy_id := i.policy_id;
         v_policy_per_obligee.subline_cd := i.subline_cd;
         v_policy_per_obligee.issue_yy := i.issue_yy;
         v_policy_per_obligee.renew_no := i.renew_no;
         v_policy_per_obligee.line_cd := i.line_cd;
         v_policy_per_obligee.endt_yy := i.endt_yy;
         v_policy_per_obligee.tsi_amt := i.tsi_amt;
         v_policy_per_obligee.iss_cd := i.iss_cd;
         v_policy_per_obligee.par_id := i.par_id;
         v_policy_per_obligee.prem_amt := i.prem_amt;
         v_policy_per_obligee.endt_type := i.endt_type;
         v_policy_per_obligee.label_tag := i.label_tag;
         v_policy_per_obligee.acct_of_cd := i.acct_of_cd;
         v_policy_per_obligee.pol_seq_no := i.pol_seq_no;
         v_policy_per_obligee.endt_seq_no := i.endt_seq_no;
         v_policy_per_obligee.endt_iss_cd := i.endt_iss_cd;
         v_policy_per_obligee.cred_branch := i.cred_branch;
         v_policy_per_obligee.policy_no := i.policy_no;
         v_policy_per_obligee.endt_no := i.endt_no;
         PIPE ROW (v_policy_per_obligee);
      END LOOP;
   END get_policy_per_obligee;                                --MOSES 04292011

   FUNCTION get_policy_renewals (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN policy_renewals_tab PIPELINED
   IS
      v_policy_renewals   policy_renewals_type;
   BEGIN
      FOR i IN (SELECT old_policy_id, new_policy_id
                  FROM gipi_polnrep
                 WHERE old_policy_id = p_policy_id
                    OR new_policy_id = p_policy_id)
      LOOP
         SELECT policy_id, line_cd,
                subline_cd, iss_cd,
                issue_yy, pol_seq_no,
                renew_no,
                   line_cd
                || ' - '
                || subline_cd
                || ' - '
                || iss_cd
                || ' - '
                || TO_CHAR (issue_yy, '09')
                || ' - '
                || TO_CHAR (pol_seq_no, '0000009')
                || ' - '
                || TO_CHAR (renew_no, '09') policy_no
           INTO v_policy_renewals.policy_id, v_policy_renewals.line_cd,
                v_policy_renewals.subline_cd, v_policy_renewals.iss_cd,
                v_policy_renewals.issue_yy, v_policy_renewals.pol_seq_no,
                v_policy_renewals.renew_no,
                v_policy_renewals.policy_no
           FROM gipi_polbasic
          WHERE (policy_id = i.new_policy_id AND policy_id <> p_policy_id)
             OR (policy_id = i.old_policy_id AND policy_id <> p_policy_id);

         PIPE ROW (v_policy_renewals);
      END LOOP;
   END get_policy_renewals;                                    --MOSES05062011

   -- functions below were created by angelo for lovs in cancellation in gipis165
   FUNCTION get_endt_cancellation_lov (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN endt_cancellation_lov_tab PIPELINED
   IS
      v_lov   endt_cancellation_lov_type;
   BEGIN
      FOR i IN (SELECT      a.endt_iss_cd
                         || '-'
                         || LTRIM (RTRIM (TO_CHAR (a.endt_yy, '09')))
                         || '-'
                         || LTRIM (RTRIM (TO_CHAR (a.endt_seq_no, '099999')))
                                                                 endorsement,
                         a.policy_id
                    FROM gipi_polbasic a
                   WHERE EXISTS (
                            SELECT '1'
                              FROM gipi_itmperil b
                             WHERE b.policy_id = a.policy_id
                               AND (   NVL (a.tsi_amt, 0) <> 0
                                    OR NVL (a.prem_amt, 0) <> 0
                                   ))
                     AND a.pol_flag IN ('1', '2', '3')
                     /*and nvl(a.endt_seq_no,0) > 0 commented */
                     AND NVL (a.endt_type, 'A') = 'A'
                     AND a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.iss_cd = p_iss_cd
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                     AND a.cancelled_endt_id IS NULL
                     AND NOT EXISTS (
                            SELECT '1'
                              FROM gipi_polbasic
                             WHERE a.policy_id = cancelled_endt_id
                               AND pol_flag IN ('1', '2', '3'))
                ORDER BY endorsement)
      LOOP
         v_lov.endorsement := i.endorsement;
         v_lov.policy_id := i.policy_id;
         PIPE ROW (v_lov);
      END LOOP;

      RETURN;
   END get_endt_cancellation_lov;

   FUNCTION get_endt_cancellation_lov2 (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN endt_cancellation_lov_tab PIPELINED
   IS
      v_lov   endt_cancellation_lov_type;
   BEGIN
      FOR i IN (SELECT      a.endt_iss_cd
                         || '-'
                         || LTRIM (RTRIM (TO_CHAR (a.endt_yy, '09')))
                         || '-'
                         || LTRIM (RTRIM (TO_CHAR (a.endt_seq_no, '099999')))
                                                                 endorsement,
                         a.policy_id
                    FROM gipi_polbasic a
                   WHERE EXISTS (
                            SELECT '1'
                              FROM gipi_itmperil b
                             WHERE b.policy_id = a.policy_id
                               AND (   NVL (a.tsi_amt, 0) <> 0
                                    OR NVL (a.prem_amt, 0) <> 0
                                   ))
                     AND NOT EXISTS (
                            SELECT '1'
                              FROM giac_direct_prem_collns y, gipi_invoice z
                             WHERE y.b140_iss_cd = z.iss_cd
                               AND y.b140_prem_seq_no = z.prem_seq_no
                               AND z.policy_id = a.policy_id)
                     AND a.pol_flag IN ('1', '2', '3')
                     AND NVL (a.endt_seq_no, 0) > 0
                     AND a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.iss_cd = p_iss_cd
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                     AND a.cancelled_endt_id IS NULL
                     AND NOT EXISTS (
                            SELECT '1'
                              FROM gipi_polbasic
                             WHERE a.policy_id = cancelled_endt_id
                               AND pol_flag IN ('1', '2', '3'))
                ORDER BY endorsement)
      LOOP
         v_lov.endorsement := i.endorsement;
         v_lov.policy_id := i.policy_id;
         PIPE ROW (v_lov);
      END LOOP;

      RETURN;
   END get_endt_cancellation_lov2;

    /*
   **  Created by      : Jerome Orio
   **  Date Created    : 05.02.2011
   **  Reference By    : (GIPIS031 - Endt Basic Information)
   **  Description     : This function returns the risk_tag of the given policy_no
   */
   PROCEDURE get_endt_risk_tag (
      p_line_cd              gipi_polbasic.line_cd%TYPE,
      p_subline_cd           gipi_polbasic.subline_cd%TYPE,
      p_iss_cd               gipi_polbasic.iss_cd%TYPE,
      p_issue_yy             gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no           gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no             gipi_polbasic.renew_no%TYPE,
      p_risk_tag       OUT   gipi_polbasic.risk_tag%TYPE,
      p_nbt_risk_tag   OUT   cg_ref_codes.rv_meaning%TYPE
   )
   IS
      FUNCTION rv_meaning (p_rv_domain VARCHAR2, p_rv_low_value VARCHAR2)
         RETURN VARCHAR2
      IS
         v_rv_meaning   VARCHAR2 (100);
      BEGIN
         FOR cg IN (SELECT rv_meaning
                      FROM cg_ref_codes
                     WHERE rv_domain = p_rv_domain
                       AND rv_low_value = p_rv_low_value)
         LOOP
            v_rv_meaning := cg.rv_meaning;
            EXIT;
         END LOOP;

         RETURN (v_rv_meaning);
      END;
   BEGIN
      FOR risk IN (SELECT   risk_tag
                       FROM gipi_polbasic
                      WHERE 1 = 1
                        AND line_cd = p_line_cd
                        AND subline_cd = p_subline_cd
                        AND iss_cd = p_iss_cd
                        AND issue_yy = p_issue_yy
                        AND pol_seq_no = p_pol_seq_no
                        AND renew_no = p_renew_no
                   --AND risk_tag   IS NOT NULL
                   ORDER BY eff_date DESC, endt_seq_no DESC)
      LOOP
         p_risk_tag := risk.risk_tag;

         IF risk.risk_tag IS NOT NULL
         THEN
            p_nbt_risk_tag :=
                         rv_meaning ('GIPI_POLBASIC.RISK_TAG', risk.risk_tag);
         ELSE
            p_nbt_risk_tag := NULL;
         END IF;

         EXIT;
      END LOOP;
   END;

   /*
   **  Created by      : Veronica V. Raymundo
   **  Date Created    : 05.16.2011
   **  Reference By    : (GIPIS159 - Policy Certificates Printing)
   **  Description     : This function return list of valid policies for policy certificates printing
   */
   FUNCTION get_gipi_polbasic_list_cert (
      p_user_id       giis_users.user_id%TYPE,
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_line_cd2      gipi_polbasic.line_cd%TYPE,
      p_subline_cd2   gipi_polbasic.subline_cd%TYPE,
      p_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy       gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      p_assd_name     giis_assured.assd_name%TYPE,
      --optimization 10.13.2016 SR5680 MarkS 
      p_find_text       VARCHAR2,
      p_order_by      	VARCHAR2,
      p_asc_desc_flag 	VARCHAR2,
      p_from          	NUMBER,
      p_to            	NUMBER
      --optimization 10.13.2016 SR5680 MarkS  
   )
      RETURN gipi_polbasic_tab6 PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_cur         cur_typ;
      v_query_str   VARCHAR2 (32000);
      pol           gipi_polbasic_type6;
   BEGIN
   --commented out MarkS SR680 10.14.2016 
--v_query_str :=
--         'SELECT DISTINCT * FROM (SELECT x.pack_policy_id, x.line_cd, x.subline_cd, x.iss_cd,
--                                         x.issue_yy, x.pol_seq_no, x.renew_no, x.endt_iss_cd,
--                                         x.endt_yy, x.endt_seq_no, x.policy_id, x.assd_no,
--                                         x.endt_type, x.par_id, x.no_of_items, x.pol_flag,
--                                         x.co_insurance_sw, x.fleet_print_tag, y.assd_name, 
--                                         GIPI_POLBASIC_PKG.get_policy_no (x.policy_id) policy_no,
--                                         DECODE(x.endt_seq_no, 0, NULL, GIPI_POLBASIC_PKG.get_endt_no (x.policy_id)) endt_no,
--                                         GIPI_PARLIST_PKG.get_par_no(x.par_id) par_no
--                                      FROM GIPI_POLBASIC x, GIIS_ASSURED y
--                                      WHERE x.assd_no = y.assd_no(+)
--                                  )
--                            WHERE line_cd IN (SELECT DISTINCT a.line_cd
--                                                FROM giis_user_grp_line a,giis_users b
--                                               WHERE b.user_grp = a.user_grp
--                                                 AND b.user_id = :user_id)
--                              AND line_cd = NVL(:line_cd, line_cd)
--                              AND subline_cd = NVL(:subline_cd, subline_cd)
--                              AND iss_cd = NVL(:iss_cd, iss_cd)
--                              AND UPPER(issue_yy) LIKE NVL(''%'' || UPPER(:issue_yy) || ''%'', UPPER(issue_yy))
--                              AND TO_CHAR(pol_seq_no, ''000099'') LIKE NVL(''%'' || TO_CHAR(:pol_seq_no, ''000099'') || ''%'', TO_CHAR(pol_seq_no, ''000099''))
--                              AND UPPER(renew_no) LIKE NVL(''%'' || UPPER(:renew_no) || ''%'', UPPER(renew_no))
--                              AND UPPER(assd_name) LIKE NVL(''%'' || UPPER(:assd_name) || ''%'', UPPER(assd_name))';

--      IF p_iss_cd IS NULL AND p_line_cd IS NOT NULL
--      THEN
--         v_query_str :=
--               v_query_str
--            || ' AND iss_cd = DECODE(check_user_per_iss_cd1('''
--            || p_line_cd
--            || ''', iss_cd, '''
--            || p_user_id
--            || ''', ''GIPIS159''), 1, iss_cd, NULL) ';
--      ELSIF p_iss_cd IS NOT NULL AND p_line_cd IS NULL
--      THEN
--         IF check_user_per_iss_cd1 (p_line_cd,
--                                    p_iss_cd,
--                                    p_user_id,
--                                    'GIPIS159'
--                                   ) <> 1
--         THEN
--            v_query_str := v_query_str || ' AND 1 = 2 ';
--         END IF;
--      ELSIF p_iss_cd IS NOT NULL AND p_line_cd IS NOT NULL
--      THEN
--         IF check_user_per_iss_cd1 (p_line_cd,
--                                    p_iss_cd,
--                                    p_user_id,
--                                    'GIPIS159'
--                                   ) <> 1
--         THEN
--            v_query_str := v_query_str || ' AND 1 = 2 ';
--         END IF;
--      ELSIF p_iss_cd IS NULL AND p_line_cd IS NULL
--      THEN
--         v_query_str :=
--               v_query_str
--            || ' AND line_cd = DECODE( check_user_per_line1(line_cd, iss_cd, '''
--            || p_user_id
--            || ''', ''GIPIS159''), 1, line_cd, NULL) '
--            || ' AND iss_cd = DECODE( check_user_per_iss_cd1(line_cd, iss_cd, '''
--            || p_user_id
--            || ''',''GIPIS159''), 1, iss_cd, NULL) ';
--      END IF;

--      IF (   p_line_cd2 IS NOT NULL
--          OR p_subline_cd2 IS NOT NULL
--          OR p_endt_iss_cd IS NOT NULL
--          OR p_endt_yy IS NOT NULL
--          OR p_endt_seq_no IS NOT NULL
--         )
--      THEN
--         v_query_str :=
--               v_query_str
--            || ' AND line_cd = NVL( :line_cd2, line_cd)
--                        AND subline_cd = NVL( :subline_cd2, subline_cd)
--                        AND endt_iss_cd = NVL(:endt_iss_cd, endt_iss_cd)
--                        AND endt_yy = NVL(:endt_yy, endt_yy)
--                        AND endt_seq_no = NVL(:endt_seq_no, endt_seq_no)
--                        AND endt_seq_no > 0
--                        ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no';

--         OPEN v_cur FOR v_query_str
--         USING p_user_id,
--               p_line_cd,
--               p_subline_cd,
--               p_iss_cd,
--               p_issue_yy,
--               p_pol_seq_no,
--               p_renew_no,
--               p_assd_name,
--               p_line_cd2,
--               p_subline_cd2,
--               p_endt_iss_cd,
--               p_endt_yy,
--               p_endt_seq_no;

--         LOOP
--            FETCH v_cur
--             INTO pol;

--            PIPE ROW (pol);
--            EXIT WHEN v_cur%NOTFOUND;
--         END LOOP;

--         CLOSE v_cur;
--      ELSIF (   p_line_cd2 IS NULL
--             OR p_subline_cd2 IS NULL
--             OR p_endt_iss_cd IS NULL
--             OR p_endt_yy IS NULL
--             OR p_endt_seq_no IS NULL
--            )
--      THEN
--         v_query_str :=
--               v_query_str
--            || ' AND line_cd = NVL( :line_cd2, line_cd)
--                        AND subline_cd = NVL( :subline_cd2, subline_cd)
--                        AND endt_iss_cd = NVL(:endt_iss_cd, endt_iss_cd)
--                        AND endt_yy = NVL(:endt_yy, endt_yy)
--                        AND endt_seq_no = NVL(:endt_seq_no, endt_seq_no)
--                        AND endt_seq_no >= 0
--                        ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no';

--         OPEN v_cur FOR v_query_str
--         USING p_user_id,
--               p_line_cd,
--               p_subline_cd,
--               p_iss_cd,
--               p_issue_yy,
--               p_pol_seq_no,
--               p_renew_no,
--               p_assd_name,
--               p_line_cd,
--               p_subline_cd,
--               p_endt_iss_cd,
--               p_endt_yy,
--               p_endt_seq_no;

--         LOOP
--            FETCH v_cur
--             INTO pol;

--            EXIT WHEN v_cur%NOTFOUND;
--            PIPE ROW (pol);
--         END LOOP;

--         CLOSE v_cur;
--      END IF;
--commented out MarkS SR680 10.14.2016 
   --optimization 10.13.2016 SR5680 MarkS  
      v_query_str :=
         'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT * FROM (SELECT x.pack_policy_id, x.line_cd, x.subline_cd, x.iss_cd,
                                         x.issue_yy, x.pol_seq_no, x.renew_no, x.endt_iss_cd,
                                         x.endt_yy, x.endt_seq_no, x.policy_id, x.assd_no,
                                         x.endt_type, x.par_id, x.no_of_items, x.pol_flag,
                                         x.co_insurance_sw, x.fleet_print_tag, y.assd_name, 
                                            x.line_cd
                                            || ''-''
                                            || x.subline_cd
                                            || ''-''
                                            || x.iss_cd
                                            || ''-''
                                            || LTRIM (TO_CHAR (x.issue_yy, ''09''))
                                            || ''-''
                                            || LTRIM (TO_CHAR (x.pol_seq_no, ''0999999''))
                                            || ''-''
                                            || LTRIM (TO_CHAR (x.renew_no, ''09'')) policy_no,
                                         DECODE(x.endt_seq_no, 0, NULL,   x.line_cd
                                                                                || ''-''
                                                                                || x.subline_cd
                                                                                || ''-''
                                                                                || x.endt_iss_cd
                                                                                || ''-''
                                                                                || LTRIM (TO_CHAR (x.endt_yy, ''09''))
                                                                                || ''-''
                                                                                || LTRIM (TO_CHAR (x.endt_seq_no, ''099999''))) endt_no,
                                         (SELECT    line_cd
                                                   || '' - ''
                                                   || iss_cd
                                                   || '' - ''
                                                   || LTRIM (TO_CHAR (par_yy, ''09''))
                                                   || '' - ''
                                                   || LTRIM (TO_CHAR (par_seq_no, ''099999''))
                                                   || '' - ''
                                                   || LTRIM (TO_CHAR (quote_seq_no, ''09''))
                                              FROM gipi_parlist
                                             WHERE par_id = x.par_id) par_no
                                      FROM GIPI_POLBASIC x, GIIS_ASSURED y
                                      WHERE x.assd_no = y.assd_no(+)
                                  ) a
                            WHERE 1=1
                            AND line_cd LIKE NVL(:line_cd, ''%'')
                              AND subline_cd LIKE NVL(:subline_cd, ''%'')
                              AND iss_cd LIKE NVL(:iss_cd, ''%'')
                              AND UPPER(issue_yy) LIKE NVL(''%'' || UPPER(:issue_yy) || ''%'', UPPER(issue_yy))
                              AND TO_CHAR(pol_seq_no, ''000099'') LIKE NVL(''%'' || TO_CHAR(:pol_seq_no, ''000099'') || ''%'', TO_CHAR(pol_seq_no, ''000099''))
                              AND UPPER(renew_no) LIKE NVL(''%'' || UPPER(:renew_no) || ''%'', UPPER(renew_no))
                              AND UPPER(assd_name) LIKE NVL(''%'' || UPPER(:assd_name) || ''%'', UPPER(assd_name))
                              AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''UW'', ''GIPIS159'', :p_user_id))
                                WHERE branch_cd = a.iss_cd AND line_cd = a.line_cd) ';
      
      IF (   p_line_cd2 IS NOT NULL
          OR p_subline_cd2 IS NOT NULL
          OR p_endt_iss_cd IS NOT NULL
          OR p_endt_yy IS NOT NULL
          OR p_endt_seq_no IS NOT NULL
         )
      THEN
        v_query_str :=
            v_query_str
            || ' AND line_cd = NVL( :line_cd2, line_cd)
                        AND subline_cd = NVL( :subline_cd2, subline_cd)
                        AND endt_iss_cd = NVL(:endt_iss_cd, endt_iss_cd)
                        AND endt_yy = NVL(:endt_yy, endt_yy)
                        AND endt_seq_no = NVL(:endt_seq_no, endt_seq_no)
                        AND endt_seq_no > 0';
        v_query_str := v_query_str || 'ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) innersql';                        
        IF (p_find_text IS NOT NULL   
            )        
        THEN
            v_query_str := v_query_str || ' WHERE (   innersql.policy_no LIKE UPPER('''||p_find_text||''')
                                                     OR innersql.endt_no LIKE UPPER('''||p_find_text||''')
                                                      OR innersql.par_no LIKE UPPER('''||p_find_text||''')
                                                      OR innersql.assd_name LIKE UPPER('''||p_find_text||'''))';
        END IF;
        IF p_order_by IS NOT NULL
        THEN
            IF p_order_by = 'policyNo'
                THEN        
                  v_query_str := v_query_str || ' ORDER BY policy_no ';
                ELSIF p_order_by = 'endtNo'
                THEN
                  v_query_str := v_query_str || ' ORDER BY endt_no ';
                ELSIF p_order_by = 'parNo'
                THEN
                  v_query_str := v_query_str || ' ORDER BY par_no ';
                ELSIF p_order_by = 'assdName'
                THEN
                  v_query_str := v_query_str || ' ORDER BY assd_name ';          
            END IF;        
                
            IF p_asc_desc_flag IS NOT NULL
                THEN
                   v_query_str := v_query_str || p_asc_desc_flag;
                ELSE
                   v_query_str := v_query_str || ' ASC';
            END IF; 
        END IF;
                                       
      v_query_str := v_query_str || '
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;                         
              
         OPEN v_cur FOR v_query_str
         USING  p_line_cd,
                p_subline_cd,
                p_iss_cd,
                p_issue_yy,
                p_pol_seq_no,
                p_renew_no,
                p_assd_name,
                p_user_id,
                p_line_cd2,
                p_subline_cd2,
                p_endt_iss_cd,
                p_endt_yy,
                p_endt_seq_no;

         LOOP
            FETCH v_cur
             INTO pol;

            PIPE ROW (pol);
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      ELSE
      v_query_str := v_query_str || ') innersql ';                        
        IF (p_find_text IS NOT NULL   
            )        
        THEN
            v_query_str := v_query_str || ' WHERE (   innersql.policy_no LIKE UPPER('''||p_find_text||''')
                                                     OR innersql.endt_no LIKE UPPER('''||p_find_text||''')
                                                      OR innersql.par_no LIKE UPPER('''||p_find_text||''')
                                                      OR innersql.assd_name LIKE UPPER('''||p_find_text||'''))';
        END IF;
        IF p_order_by IS NOT NULL
        THEN
            IF p_order_by = 'policyNo'
                THEN        
                  v_query_str := v_query_str || ' ORDER BY policy_no ';
                ELSIF p_order_by = 'endtNo'
                THEN
                  v_query_str := v_query_str || ' ORDER BY endt_no ';
                ELSIF p_order_by = 'parNo'
                THEN
                  v_query_str := v_query_str || ' ORDER BY par_no ';
                ELSIF p_order_by = 'assdName'
                THEN
                  v_query_str := v_query_str || ' ORDER BY assd_name ';          
            END IF;        
                
            IF p_asc_desc_flag IS NOT NULL
                THEN
                   v_query_str := v_query_str || p_asc_desc_flag;
                ELSE
                   v_query_str := v_query_str || ' ASC';
            END IF; 
        END IF;
                                       
      v_query_str := v_query_str || '
                            ) outersql
                         ) mainsql WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
      OPEN v_cur FOR v_query_str
         USING  p_line_cd,
                p_subline_cd,
                p_iss_cd,
                p_issue_yy,
                p_pol_seq_no,
                p_renew_no,
                p_assd_name,
                p_user_id;

         LOOP
            FETCH v_cur
             INTO pol;

            PIPE ROW (pol);
            EXIT WHEN v_cur%NOTFOUND;
         END LOOP;

         CLOSE v_cur;
      END IF;
--optimization 10.13.2016 SR5680 MarkS  
      RETURN;
   END get_gipi_polbasic_list_cert;

   /*
   **  Created by      : D.Alcantara
   **  Date Created    : 06.21.2011
   **  Reference By    : (GIPIR915)
   */
   FUNCTION get_gipir915_polbasic_info2 (
      p_policy_id   gipi_item.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN gipi_gipir915_polbasic_tab PIPELINED
   IS
      v_gipir915   gipi_gipir915_polbasic_type;
   BEGIN
      FOR i IN (SELECT b250.policy_id policy_id, a020.assd_name assd_name,
                       b250.subline_cd subline_code,
                       UPPER (b250.address1) address1,
                       UPPER (b250.address2) address2,
                       UPPER (b250.address3) address3,
                          b250.line_cd
                       || '-'
                       || b250.subline_cd
                       || '-'
                       || b250.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (b250.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (b250.pol_seq_no, '0999999'))
                       || '-'
                       || LTRIM (TO_CHAR (b250.renew_no, '09')) policy_no1,
                       TO_CHAR (b250.issue_date, 'FMmm/dd/yyyy') issue_date,
                       TO_CHAR (b250.incept_date, 'FMmm/dd/yyyy')
                                                                 incept_date,
                       TO_CHAR (b250.expiry_date, 'FMmm/dd/yyyy')
                                                                 expiry_date,
                       b170.item_no item_no, b170.from_date, b170.TO_DATE,
                       b170.currency_rt, b290.make make,
                       b290.model_year model_year,
                          LTRIM (LTRIM (TO_CHAR (b290.coc_yy, '09')))
                       || '-'
                       || LTRIM (TO_CHAR (b290.coc_serial_no, '0999999'))
                                                                      coc_no,
                       b290.color color, b290.plate_no plate_no,
                       b290.serial_no serial_no, b290.motor_no motor_no,
                       b290.no_of_pass capacity, b290.unladen_wt unladen_wt,
                       b290.mot_type mot_type, b290.type_of_body_cd,
                       b290.mv_file_no file_no,
                       b290.coc_serial_no coc_serial_no
                  FROM gipi_polbasic b250,
                       gipi_item b170,
                       gipi_vehicle b290,
                       giis_assured a020
                 WHERE b250.policy_id = p_policy_id
                   AND b170.item_no = p_item_no
                   AND b250.policy_id = b170.policy_id
                   AND b170.policy_id = b290.policy_id
                   AND b170.item_no = b290.item_no
                   AND a020.assd_no = b250.assd_no
                   AND b290.coc_serial_no IS NOT NULL)
      LOOP
         v_gipir915.policy_id := i.policy_id;
         v_gipir915.assd_name := i.assd_name;
         v_gipir915.subline_cd := i.subline_code;
         v_gipir915.address1 := i.address1;
         v_gipir915.address2 := i.address2;
         v_gipir915.address3 := i.address3;
         v_gipir915.policy_no1 := i.policy_no1;
         v_gipir915.issue_date := i.incept_date;
         v_gipir915.incept_date := i.incept_date;
         v_gipir915.expiry_date := i.expiry_date;
         v_gipir915.item_no := i.item_no;
         v_gipir915.from_date := i.from_date;
         v_gipir915.TO_DATE := i.TO_DATE;
         v_gipir915.currency_rt := i.currency_rt;
         v_gipir915.make := get_car_company_gipir915 (p_policy_id, p_item_no);
         v_gipir915.model_year := i.model_year;
         v_gipir915.coc_no := i.coc_no;
         v_gipir915.color := i.color;
         v_gipir915.plate_no := i.plate_no;
         v_gipir915.serial_no := i.serial_no;
         v_gipir915.motor_no := i.motor_no;
         v_gipir915.no_of_pass := i.capacity;
         v_gipir915.unladen_wt := i.unladen_wt;
         v_gipir915.mot_type := i.mot_type;
         v_gipir915.type_of_body_cd := i.type_of_body_cd;
         v_gipir915.mv_file_no := i.file_no;
         v_gipir915.coc_serial_no := i.coc_serial_no;
         v_gipir915.cf_coc_signatory := cf_coc_signatory ('GIPIR915');
         v_gipir915.cf_print_signatory := cf_print_signatory ();
         PIPE ROW (v_gipir915);
      END LOOP;
   END get_gipir915_polbasic_info2;

    /*
   **  Created by      : Rey
   **  Date Created    : 07.19.2011
   **  Reference By    : (GIPIS100)
   */
   FUNCTION get_policy_per_endorsement (
      p_endt_type   giis_endttext.endt_cd%TYPE
   )
      RETURN policy_per_endorsement_tab PIPELINED
   IS
      v_policy_per_endorsement   policy_per_endrsment_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                               a.issue_yy, a.pol_seq_no, a.renew_no,
                               a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                               a.endt_type, a.incept_date, a.expiry_date,
                               a.pol_flag, a.tsi_amt, a.prem_amt, a.par_id,
                               a.acct_of_cd, a.endt_expiry_date, a.label_tag,
                               a.cred_branch, b.assd_no, c.endt_cd,
                               c.endt_title,
                                  a.line_cd
                               || '-'
                               || a.subline_cd
                               || '-'
                               || a.iss_cd
                               || '-'
                               || TO_CHAR (a.issue_yy, '09')
                               || '-'
                               || TO_CHAR (a.pol_seq_no, '0000009')
                               || '-'
                               || TO_CHAR (a.renew_no, '09') policy_no,
                                  a.endt_iss_cd
                               || TO_CHAR (a.endt_yy, '09')
                               || '-'
                               || TO_CHAR (a.endt_seq_no, '0000009')
                               || '-'
                               || a.endt_type endt_no
                          FROM gipi_polbasic a,
                               gipi_parlist b,
                               giis_endttext c,
                               gipi_endttext d
                         WHERE a.par_id = b.par_id
                           AND d.endt_cd = c.endt_cd
                           AND d.policy_id = a.policy_id)
                 WHERE NVL (endt_cd, '%%') LIKE
                                               UPPER (NVL (p_endt_type, '%%')))
      LOOP
         v_policy_per_endorsement.policy_id := i.policy_id;
         v_policy_per_endorsement.line_cd := i.line_cd;
         v_policy_per_endorsement.subline_cd := i.subline_cd;
         v_policy_per_endorsement.iss_cd := i.iss_cd;
         v_policy_per_endorsement.issue_yy := i.issue_yy;
         v_policy_per_endorsement.pol_seq_no := i.pol_seq_no;
         v_policy_per_endorsement.renew_no := i.renew_no;
         v_policy_per_endorsement.endt_iss_cd := i.endt_iss_cd;
         v_policy_per_endorsement.endt_yy := i.endt_yy;
         v_policy_per_endorsement.endt_seq_no := i.endt_seq_no;
         v_policy_per_endorsement.endt_type := i.endt_type;
         v_policy_per_endorsement.incept_date := i.incept_date;
         v_policy_per_endorsement.expiry_date := i.expiry_date;
         v_policy_per_endorsement.pol_flag := i.pol_flag;
         v_policy_per_endorsement.tsi_amt := i.tsi_amt;
         v_policy_per_endorsement.prem_amt := i.prem_amt;
         v_policy_per_endorsement.par_id := i.par_id;
         v_policy_per_endorsement.acct_of_cd := i.acct_of_cd;
         v_policy_per_endorsement.endt_expiry_date := i.endt_expiry_date;
         v_policy_per_endorsement.label_tag := i.label_tag;
         v_policy_per_endorsement.cred_branch := i.cred_branch;
         v_policy_per_endorsement.assd_no := i.assd_no;
         v_policy_per_endorsement.policy_no := i.policy_no;
         v_policy_per_endorsement.endt_no := i.endt_no;

         SELECT DECODE (pol_flag,
                        '1', 'New',
                        '2', 'Renewal',
                        '3', 'Replacement',
                        '4', 'Cancelled Endorsement',
                        '5', 'Spoiled',
                        'X', 'Expired'
                       )
           INTO v_policy_per_endorsement.mean_pol_flag
           FROM gipi_polbasic
          WHERE line_cd = i.line_cd
            AND subline_cd = i.subline_cd
            AND iss_cd = i.iss_cd
            AND issue_yy = i.issue_yy
            AND pol_seq_no = i.pol_seq_no
            AND renew_no = i.renew_no
            AND endt_iss_cd = i.endt_iss_cd
            AND endt_yy = i.endt_yy
            AND endt_seq_no = i.endt_seq_no;

         PIPE ROW (v_policy_per_endorsement);

         BEGIN
            SELECT designation || ' ' || assd_name
              INTO v_policy_per_endorsement.acct_of
              FROM giis_assured
             WHERE assd_no = i.acct_of_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      END LOOP;
   END get_policy_per_endorsement;

   PROCEDURE get_ref_pol_no (
      p_line_cd       IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      IN       gipi_polbasic.renew_no%TYPE,
      p_assd_no       IN       gipi_parlist.assd_no%TYPE,
      p_ref_pol_no    OUT      gipi_polbasic.ref_pol_no%TYPE,
      p_exist         OUT      VARCHAR2,
      p_incept_date   OUT      VARCHAR2,
      p_expiry_date   OUT      VARCHAR2,
      p_mesg          OUT      VARCHAR2
   )
   IS
   /*
   ** Create By: D.Alcantara, 07-26-2011
   ** Date Created :  july 26, 2010
   **  Reference By : gipis002 - basic information
   **  Description : validation for open policy detail
   */
       v_issue_yy            gipi_polbasic.issue_yy%TYPE;
       v_eff_date            gipi_polbasic.eff_date%TYPE;
       v_expiry_date    gipi_polbasic.expiry_date%TYPE;
       v_incept_date    gipi_polbasic.incept_date%TYPE;
       v_opflag         VARCHAR2(1);
       v_policy_id      gipi_polbasic.policy_id%TYPE;
   BEGIN
      p_exist := 'N';
      p_ref_pol_no := '';
      p_incept_date := '';
      p_expiry_date := '';

      FOR i IN (SELECT ref_pol_no, incept_date, expiry_date
                  FROM gipi_polbasic
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no)
      LOOP
         p_ref_pol_no := i.ref_pol_no;
      /*   p_incept_date := TO_CHAR (i.incept_date, 'mm-dd-yyyy');
         p_expiry_date := TO_CHAR (i.expiry_date, 'mm-dd-yyyy');*/
         p_exist := 'Y';
         EXIT;
      END LOOP;
      
      FOR A1 IN (  SELECT incept_date,expiry_date,assd_no,eff_date, policy_id, ref_pol_no --, assd_no -- aaron 082709
                      FROM gipi_polbasic
                     WHERE line_cd    = p_line_cd
                       AND subline_cd = p_subline_cd
                       AND iss_cd     = p_iss_cd
                       AND issue_yy   = p_issue_yy
                       AND pol_seq_no = p_pol_seq_no
                       AND renew_no   = p_renew_no
                     ORDER BY TRUNC(eff_date) DESC)
       LOOP
            v_expiry_date              := a1.expiry_date;
            v_incept_date              := a1.incept_date;
            v_eff_date                 := a1.eff_date;
            v_policy_id             := a1.policy_id;
            p_exist := 'Y';
            FOR z1 IN (SELECT endt_seq_no, expiry_date, incept_date, policy_id
                         FROM GIPI_POLBASIC b2501
                        WHERE b2501.line_cd    = p_line_cd
                            AND b2501.subline_cd = p_subline_cd
                            AND b2501.iss_cd     = p_iss_cd
                            AND b2501.issue_yy   = p_issue_yy
                            AND b2501.pol_seq_no = p_pol_seq_no
                            AND b2501.renew_no   = p_renew_no
                            AND b2501.pol_flag   IN ('1','2','3')
                            AND NVL(b2501.back_stat,5) = 2
                            AND b2501.pack_policy_id IS NULL
                            AND (
                                    b2501.endt_seq_no = 0 OR
                                    (b2501.endt_seq_no > 0 AND
                                    TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date))
                                    )
                        ORDER BY endt_seq_no DESC )
            LOOP
                    FOR z1a IN (SELECT endt_seq_no, eff_date, expiry_date, incept_date, policy_id
                                                FROM GIPI_POLBASIC b2501
                                             WHERE b2501.line_cd    = p_line_cd
                                                 AND b2501.subline_cd = p_subline_cd
                                                 AND b2501.iss_cd     = p_iss_cd
                                                 AND b2501.issue_yy   = p_issue_yy
                                                 AND b2501.pol_seq_no = p_pol_seq_no
                                                 AND b2501.renew_no   = p_renew_no
                                                 AND b2501.pol_flag   IN ('1','2','3')
                                                 AND b2501.pack_policy_id IS NULL
                                                 AND (
                                                            b2501.endt_seq_no = 0 OR
                                                            (b2501.endt_seq_no > 0 AND
                                                            TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date))
                                                            )
                                                ORDER BY endt_seq_no DESC )
                    LOOP
                        IF z1.endt_seq_no = z1a.endt_seq_no THEN
                            v_expiry_date       := z1.expiry_date;
                            v_incept_date       := z1.incept_date;
                            v_policy_id := z1.policy_id;
                        ELSE
                            IF z1a.eff_date > v_eff_date THEN
                                v_eff_date                 := z1a.eff_date;
                                v_expiry_date              := z1a.expiry_date;
                                v_incept_date              := z1a.incept_date;
                                v_policy_id := z1a.policy_id;
                            ELSE
                                v_expiry_date  := z1.expiry_date;
                                v_incept_date  := z1.incept_date;
                            END IF;
                        END IF;                       
                                        
                        EXIT;
                END LOOP;  
                EXIT;
            END LOOP;
                
                p_expiry_date := TO_CHAR(v_expiry_date, 'MM-DD-YYYY');
                p_incept_date := TO_CHAR(v_incept_date, 'MM-DD-YYYY');
                
                FOR x IN (SELECT op_flag
                            FROM giis_subline
                           WHERE subline_cd = p_subline_cd 
                             AND line_cd =  p_line_cd)
                LOOP
                    v_opflag := x.op_flag;
                    IF v_opflag != 'Y' THEN             
                        p_mesg := 'This is not a valid open policy.';
                    END IF;
                END LOOP;
                
                IF A1.assd_no != p_assd_no THEN
                    FOR x IN (SELECT assd_name
                                FROM giis_assured
                               WHERE assd_no = p_assd_no)
                    LOOP           
                     p_mesg := 'The open policy''s assured should be ' || x.assd_name || '.';
                    END LOOP;
                END IF;    
       EXIT;
       END LOOP;     
   END get_ref_pol_no;

   /*
   **  Created by        : Emman
   **  Date Created     : 08.11.2011
   **  Reference By     : (GIUTS021 - Redistribution)
   **  Description     : get GIPI_POLBASIC records for redistribution
   */
   FUNCTION get_redistribution_policies (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy       gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      p_assd_name     giis_assured.assd_name%TYPE,
      p_eff_date      gipi_polbasic.eff_date%TYPE,
      p_expiry_date   gipi_polbasic.expiry_date%TYPE,
      p_user_id          giis_users.user_id%TYPE 
   )
      RETURN gipi_polbasic_tab5 PIPELINED
   IS
      v_polbasic   gipi_polbasic_type5;
   BEGIN
      IF     p_line_cd IS NULL
         AND p_subline_cd IS NULL
         AND p_iss_cd IS NULL
         AND p_issue_yy IS NULL
         AND p_pol_seq_no IS NULL
         AND p_renew_no IS NULL
         AND p_endt_iss_cd IS NULL
         AND p_endt_yy IS NULL
         AND p_endt_seq_no IS NULL
         AND p_eff_date IS NULL
         AND p_expiry_date IS NULL
      THEN
         FOR i IN (SELECT   a.par_id, a.line_cd, a.subline_cd, a.iss_cd,
                            a.issue_yy, a.pol_seq_no, a.renew_no,
                            a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                            TRUNC(a.eff_date) eff_date,
                            TRUNC(a.expiry_date) expiry_date,
                            a.assd_no,
                            b.assd_name, a.dist_flag, a.policy_id,
                            a.renew_flag,
                               a.line_cd
                            || '-'
                            || a.subline_cd
                            || '-'
                            || a.iss_cd
                            || '-'
                            || LTRIM(TO_CHAR (a.issue_yy, '09'))
                            || '-'
                            || LTRIM(TO_CHAR (a.pol_seq_no, '0999999'))
                            || '-'
                            || LTRIM(TO_CHAR (renew_no, '09')) 
                            policy_no,
                               a.line_cd
                            || '-'
                            || a.subline_cd
                            || '-'
                            || a.endt_iss_cd
                            || '-'
                            || TO_CHAR (a.endt_yy, '09')
                            || '-'
                            || TO_CHAR (a.endt_seq_no, '0999999') endt_no
                       FROM gipi_polbasic a, giis_assured b
                      WHERE EXISTS (SELECT 'A'
                                      FROM gipi_polbasic_pol_dist_v v
                                     WHERE v.policy_id = a.policy_id)
                        AND a.assd_no = b.assd_no
                        AND UPPER (b.assd_name) LIKE
                                                NVL (UPPER(p_assd_name), b.assd_name)
                        AND a.pol_flag NOT IN ('4', '5') --added edgar 10/15/2014 to exclude cancelled and spoiled policies
                        AND a.policy_id IN (SELECT policy_id --added edgar 11/21/2014 to query only distributed records
                                              FROM giuw_pol_dist
                                             WHERE policy_id = a.policy_id
                                               AND dist_flag = '3')
                   ORDER BY line_cd,
                            subline_cd,
                            iss_cd,
                            issue_yy,
                            pol_seq_no,
                            renew_no)
         LOOP
            v_polbasic.par_id := i.par_id;
            v_polbasic.line_cd := i.line_cd;
            v_polbasic.subline_cd := i.subline_cd;
            v_polbasic.iss_cd := i.iss_cd;
            v_polbasic.issue_yy := i.issue_yy;
            v_polbasic.pol_seq_no := i.pol_seq_no;
            v_polbasic.renew_no := i.renew_no;
            v_polbasic.endt_iss_cd := i.endt_iss_cd;
            v_polbasic.endt_yy := i.endt_yy;
            v_polbasic.endt_seq_no := i.endt_seq_no;
            v_polbasic.eff_date := i.eff_date;
            v_polbasic.expiry_date := i.expiry_date;
            v_polbasic.assd_no := i.assd_no;
            v_polbasic.assd_name := i.assd_name;
            v_polbasic.dist_flag := i.dist_flag;
            v_polbasic.policy_id := i.policy_id;
            v_polbasic.policy_no := i.policy_no;
            v_polbasic.renew_flag := i.renew_flag;

            IF i.endt_seq_no IS NULL OR i.endt_seq_no < 1
            THEN
               v_polbasic.endt_no := '';
            ELSE
               v_polbasic.endt_no := i.endt_no;
            END IF;

            PIPE ROW (v_polbasic);
         END LOOP;
      ELSE
         FOR i IN (SELECT   a.par_id, a.line_cd, a.subline_cd, a.iss_cd,
                            a.issue_yy, a.pol_seq_no, a.renew_no,
                            a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                            TRUNC(a.eff_date) eff_date,
                            TRUNC(a.expiry_date) expiry_date,
                            a.assd_no,
                            b.assd_name, a.dist_flag, a.policy_id,
                            a.renew_flag,
                               a.line_cd
                            || '-'
                            || a.subline_cd
                            || '-'
                            || a.iss_cd
                            || '-'
                            || LTRIM(TO_CHAR (a.issue_yy, '09'))
                            || '-'
                            || LTRIM(TO_CHAR (a.pol_seq_no, '0999999'))
                            || '-'
                            || LTRIM(TO_CHAR (renew_no, '09')) 
                            policy_no,
                               a.line_cd
                            || '-'
                            || a.subline_cd
                            || '-'
                            || a.endt_iss_cd
                            || '-'
                            || TO_CHAR (a.endt_yy, '09')
                            || '-'
                            || TO_CHAR (a.endt_seq_no, '0999999') endt_no
                       FROM gipi_polbasic a, giis_assured b
                      WHERE  check_user_per_iss_cd2(a.line_cd, a.iss_cd,'GIUTS021',p_user_id) = 1 --added by steven 1/15/2013 remove the cade below
                      /*check_user_per_line (line_cd,
                                                 p_iss_cd,
                                                 'GIUTS021'
                                                ) = 1
                        AND check_user_per_iss_cd (p_line_cd,
                                                   iss_cd,
                                                   'GIUTS021'
                                                  ) = 1*/
                        AND a.assd_no = b.assd_no
                        AND a.line_cd LIKE NVL (p_line_cd, a.line_cd)
                        AND UPPER (a.subline_cd) LIKE NVL (UPPER (p_subline_cd), a.subline_cd)
                        AND UPPER(a.iss_cd) LIKE NVL (UPPER(p_iss_cd), a.iss_cd)
                        AND a.issue_yy LIKE NVL (p_issue_yy, a.issue_yy)
                        AND a.pol_seq_no LIKE NVL (p_pol_seq_no, a.pol_seq_no)
                        AND a.renew_no LIKE NVL (p_renew_no, a.renew_no)
                        --AND UPPER(a.endt_iss_cd) LIKE NVL (UPPER(p_endt_iss_cd), a.endt_iss_cd)
                        AND a.endt_yy LIKE NVL (p_endt_yy, a.endt_yy)
                        AND a.endt_seq_no LIKE NVL (p_endt_seq_no, a.endt_seq_no)
                        AND to_char(a.eff_date,'mm-dd-yyyy') LIKE NVL (to_char(p_eff_date,'mm-dd-yyyy'), to_char(a.eff_date,'mm-dd-yyyy'))  --added by steven 11.12.2012
                        AND to_char(a.expiry_date,'mm-dd-yyyy') LIKE NVL (to_char(p_expiry_date,'mm-dd-yyyy'), to_char(a.expiry_date,'mm-dd-yyyy'))  --added by steven 11.12.2012
                        AND UPPER (b.assd_name) LIKE
                                                NVL (UPPER(p_assd_name), b.assd_name)
                        AND a.pol_flag NOT IN ('4', '5') --added edgar 10/15/2014 to exclude cancelled and spoiled policies
                        AND a.policy_id IN (SELECT policy_id --added edgar 11/21/2014 to query only distributed records
                                              FROM giuw_pol_dist
                                             WHERE policy_id = a.policy_id
                                               AND dist_flag = '3')
                   ORDER BY line_cd,
                            subline_cd,
                            iss_cd,
                            issue_yy,
                            pol_seq_no,
                            renew_no)
         LOOP
            v_polbasic.par_id := i.par_id;
            v_polbasic.line_cd := i.line_cd;
            v_polbasic.subline_cd := i.subline_cd;
            v_polbasic.iss_cd := i.iss_cd;
            v_polbasic.issue_yy := i.issue_yy;
            v_polbasic.pol_seq_no := i.pol_seq_no;
            v_polbasic.renew_no := i.renew_no;
            v_polbasic.endt_iss_cd := i.endt_iss_cd;
            v_polbasic.endt_yy := i.endt_yy;
            v_polbasic.endt_seq_no := i.endt_seq_no;
            v_polbasic.eff_date := i.eff_date;
            v_polbasic.expiry_date := i.expiry_date;
            v_polbasic.assd_no := i.assd_no;
            v_polbasic.assd_name := i.assd_name;
            v_polbasic.dist_flag := i.dist_flag;
            v_polbasic.policy_id := i.policy_id;
            v_polbasic.policy_no := i.policy_no;
            v_polbasic.renew_flag := i.renew_flag;

            IF i.endt_seq_no IS NULL OR i.endt_seq_no < 1
            THEN
               v_polbasic.endt_no := '';
            ELSE
               v_polbasic.endt_no := i.endt_no;
            END IF;

            PIPE ROW (v_polbasic);
         END LOOP;
      END IF;

      RETURN;
   END get_redistribution_policies;

   /**
   * Rey Jadlocon
   * 08.11.2011
   * policyby Assured in Account of
   **/
   /*Modified by pjsantos 11/14/2016 for optimization GENQA 5771*/
   FUNCTION get_polassured_in_acct_of(  p_assd_name         VARCHAR2,
                                        p_assd_name2         VARCHAR2,
                                        p_policy_no          VARCHAR2,
                                        p_endt_no            VARCHAR2,
                                        p_order_by           VARCHAR2,      
                                        p_asc_desc_flag      VARCHAR2,      
                                        p_first_row          NUMBER,        
                                        p_last_row           NUMBER)
      RETURN polassured_in_acct_of_tab PIPELINED
   IS
      v_assured_in_acct_of   polassured_in_acct_of_type;
      TYPE cur_type IS REF CURSOR;      
      c        cur_type;                
      v_sql    VARCHAR2(32767);         
   BEGIN
     /* FOR i IN
         (*/
       v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM(SELECT *
                                    FROM  (SELECT   a.assd_no, b.assd_name, a.policy_id, a.line_cd,
                           a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no,
                           a.renew_no, a.endt_iss_cd, a.endt_seq_no,
                           a.endt_yy, a.endt_type,
                              a.line_cd
                           || ''-''
                           || a.subline_cd
                           || ''-''
                           || a.iss_cd
                           || ''-''
                           || LTRIM(TO_CHAR (a.issue_yy, ''09''))
                           || ''-''
                           || LTRIM(TO_CHAR (a.pol_seq_no, ''0000009''))
                           || ''-''
                           || LTRIM(TO_CHAR (a.renew_no, ''09'')) policy_no,
                           DECODE(NVL(a.endt_seq_no,0), 0, NULL, a.endt_iss_cd
                           || ''-''
                           || LTRIM(TO_CHAR (a.endt_yy, ''09''))
                           || ''-''
                           || LTRIM(TO_CHAR (a.endt_seq_no, ''00000009''))
                           || ''-''
                           || LTRIM(a.endt_type)) endt_no,
                           a.acct_of_cd,
                           (SELECT z.designation || '' '' || z.assd_name
                              FROM giis_assured z
                             WHERE z.assd_no = a.acct_of_cd) in_acct_of
                      FROM gipi_polbasic a, giis_assured b
                     WHERE 1=1
                       AND a.line_cd != ''BB''
                       AND a.assd_no = b.assd_no ) ';                
          
                      
            IF p_order_by IS NOT NULL
              THEN
                IF p_order_by = 'assdName'
                 THEN        
                  v_sql := v_sql || ' ORDER BY assd_name ';
                ELSIF  p_order_by = 'assdName2'
                 THEN
                  v_sql := v_sql || ' ORDER BY in_acct_of ';
                ELSIF  p_order_by = 'acctOfCd'
                 THEN
                  v_sql := v_sql || ' ORDER BY acct_of_cd ';
                ELSIF  p_order_by = 'policyNo'
                 THEN
                  v_sql := v_sql || ' ORDER BY policy_no '; 
                ELSIF  p_order_by = 'endtNo'
                 THEN
                  v_sql := v_sql || ' ORDER BY endt_no '; 
                END IF;
                
                IF p_asc_desc_flag IS NOT NULL
                THEN
                   v_sql := v_sql || p_asc_desc_flag;
                ELSE
                   v_sql := v_sql || ' ASC '; 
                END IF; 
                IF p_order_by = 'assdName' OR  p_order_by = 'policyNo' OR  p_order_by = 'endtNo' OR p_order_by = 'assdName2'
                  THEN
                    v_sql := v_sql || ' NULLS LAST '; 
                END IF;
             END IF;
            
            v_sql := v_sql || ' ) innersql WHERE 1=1 ';  
            
              IF p_assd_name IS NOT NULL
                THEN
                 v_sql := v_sql || ' AND UPPER(assd_name) LIKE '''||REPLACE(UPPER(p_assd_name),'''','''''')||''' ';
            END IF;
            IF p_assd_name2 IS NOT NULL
                THEN
                 v_sql := v_sql || ' AND UPPER(in_acct_of) LIKE '''||REPLACE(UPPER(p_assd_name2),'''','''''')||''' ';
            END IF;
            IF p_policy_no IS NOT NULL
                THEN
                 v_sql := v_sql || ' AND UPPER(policy_no) LIKE '''||UPPER(p_policy_no)||''' ';
            END IF;
            IF p_endt_no IS NOT NULL
                THEN
                 v_sql := v_sql || ' AND UPPER(endt_no) LIKE '''||UPPER(p_endt_no)||''' ';
            END IF;
            
            v_sql := v_sql || ' ) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row; 
     OPEN c FOR v_sql;
     LOOP
      FETCH c INTO
            v_assured_in_acct_of.count_        ,
            v_assured_in_acct_of.rownum_       ,
            v_assured_in_acct_of.assd_no       ,
            v_assured_in_acct_of.assd_name     ,
            v_assured_in_acct_of.policy_id     ,
            v_assured_in_acct_of.line_cd       ,
            v_assured_in_acct_of.subline_cd    ,
            v_assured_in_acct_of.iss_cd        ,
            v_assured_in_acct_of.issue_yy      ,
            v_assured_in_acct_of.pol_seq_no    ,
            v_assured_in_acct_of.renew_no      ,
            v_assured_in_acct_of.endt_iss_cd   ,
            v_assured_in_acct_of.endt_seq_no   ,
            v_assured_in_acct_of.endt_yy       ,
            v_assured_in_acct_of.endt_type     ,     
            v_assured_in_acct_of.policy_no     ,
            v_assured_in_acct_of.endt_no       ,
            v_assured_in_acct_of.acct_of_cd    ,
            v_assured_in_acct_of.assd_name2    ;     
                  
              
         /*v_assured_in_acct_of.assd_no := i.assd_no;
         v_assured_in_acct_of.assd_name := i.assd_name;
         v_assured_in_acct_of.policy_id := i.policy_id;
         v_assured_in_acct_of.line_cd := i.line_cd;
         v_assured_in_acct_of.subline_cd := i.subline_cd;
         v_assured_in_acct_of.iss_cd := i.iss_cd;
         v_assured_in_acct_of.issue_yy := i.issue_yy;
         v_assured_in_acct_of.pol_seq_no := i.pol_seq_no;
         v_assured_in_acct_of.renew_no := i.renew_no;
         v_assured_in_acct_of.endt_iss_cd := i.endt_iss_cd;
         v_assured_in_acct_of.endt_seq_no := i.endt_seq_no;
         v_assured_in_acct_of.endt_type := i.endt_type;
         v_assured_in_acct_of.endt_yy := i.endt_yy;
         v_assured_in_acct_of.policy_no := i.policy_no;
         v_assured_in_acct_of.assd_name2 := i.in_acct_of;

        IF (i.endt_seq_no = 0)
         THEN
            v_assured_in_acct_of.endt_no := NULL;
         ELSE
            v_assured_in_acct_of.endt_no := i.endt_no;
         END IF;*/

        EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_assured_in_acct_of);
      END LOOP;      
     CLOSE c;            
    RETURN; 
   END get_polassured_in_acct_of;

   /*
   **  Created by        : Emman
   **  Date Created     : 08.12.2011
   **  Reference By     : (GIUTS021 - Redistribution)
   **  Description     : execute POST-QUERY of block V370
   */
   PROCEDURE exec_giuws012_v370_post_query (
      p_policy_id              IN       gipi_polbasic.policy_id%TYPE,
      p_sve_facultative_code   OUT      VARCHAR2,
      p_neg_dist_no            OUT      gipi_polbasic_pol_dist_v.dist_no%TYPE,
      p_dist_status            OUT      VARCHAR2
   )
   IS
      v_type      giis_parameters.param_type%TYPE;
      v_value_n   giis_parameters.param_value_n%TYPE;
      v_value_v   giis_parameters.param_value_v%TYPE;
      v_value_d   giis_parameters.param_value_d%TYPE;
   BEGIN
      p_dist_status := 'OK';

      /* Populate SVE_FACULTATIVE_CODE for reference use */
      BEGIN
         SELECT param_type, param_value_n, param_value_v, param_value_d
           INTO v_type, v_value_n, v_value_v, v_value_d
           FROM giis_parameters
          WHERE param_name = 'FACULTATIVE';

         IF v_type = 'N'
         THEN
            p_sve_facultative_code := v_value_n;
         ELSIF v_type = 'V'
         THEN
            p_sve_facultative_code := v_value_v;
         ELSE
            p_sve_facultative_code := v_value_d;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_sve_facultative_code := NULL;
         WHEN OTHERS
         THEN
            NULL;
      END;
      /*added edgar 10/21/2014*/
      FOR i IN (SELECT '1' 
                  FROM giuw_pol_dist
                 WHERE policy_id = p_policy_id
                   AND dist_flag = '5')
      LOOP
            p_dist_status := 'REDIST';
      END LOOP;
      /*ended edgar 10/21/2014*/
      IF p_dist_status = 'OK' THEN --added if condition : edgar 11/21/2014
          /* query current distribution no. */
          BEGIN
             SELECT dist_no
               INTO p_neg_dist_no
               FROM gipi_polbasic_pol_dist_v
              WHERE policy_id = p_policy_id;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                --p_msg_alert := 'This policy has no distribution No.';
                p_dist_status := 'NO_DIST';
             WHEN TOO_MANY_ROWS
             THEN
                p_dist_status := 'TOO_MANY_DIST';
          END;
      END IF; --ended if condition : edgar 11/21/2014
   END exec_giuws012_v370_post_query;

/**
* Rey Jadlocon
* 08.15.2011
* policy by obligee list
**/
   FUNCTION get_policy_obligee_list (
      p_obligee_no   gipi_bond_basic.obligee_no%TYPE
   )
      RETURN policy_obligee_tab PIPELINED
   IS
      v_policy_obligee   policy_obligee_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT   b.policy_id, b.endt_seq_no, b.endt_yy,
                                 b.endt_iss_cd, c.obligee_name, b.pol_seq_no,
                                    b.line_cd
                                 || ' - '
                                 || b.subline_cd
                                 || ' - '
                                 || b.iss_cd
                                 || ' - '
                                 || b.issue_yy
                                 || ' - '
                                 || TO_CHAR (b.pol_seq_no, '0000009')
                                 || ' - '
                                 || TO_CHAR (b.renew_no, '09') policy_no,
                                    b.endt_iss_cd
                                 || ' - '
                                 || b.endt_yy
                                 || ' - '
                                 || TO_CHAR (b.endt_seq_no, '0000009')
                                 || ' - '
                                 || b.endt_type endt_no,
                                 b.tsi_amt, b.prem_amt
                            FROM gipi_polbasic b,
                                 gipi_bond_basic a,
                                 giis_obligee c
                           WHERE b.policy_id = a.policy_id
                             AND a.obligee_no = c.obligee_no
                             AND a.obligee_no =
                                              NVL (p_obligee_no, a.obligee_no)
                        ORDER BY b.pol_seq_no, b.iss_cd))
      LOOP
         v_policy_obligee.policy_id := i.policy_id;
         v_policy_obligee.endt_seq_no := i.endt_seq_no;
         v_policy_obligee.endt_yy := i.endt_yy;
         v_policy_obligee.endt_iss_cd := i.endt_iss_cd;
         v_policy_obligee.obligee_name := i.obligee_name;
         v_policy_obligee.pol_seq_no := i.pol_seq_no;
         v_policy_obligee.policy_no := i.policy_no;

         IF v_policy_obligee.endt_yy > 0
         THEN
            v_policy_obligee.endt_no := i.endt_no;
         ELSE
            v_policy_obligee.endt_no := NULL;
         END IF;

         v_policy_obligee.tsi_amt := i.tsi_amt;
         v_policy_obligee.prem_amt := i.prem_amt;
         PIPE ROW (v_policy_obligee);
      END LOOP;
   END get_policy_obligee_list;

   /**
   * Rey Jadlocon
   * 08.16.2011
   * bond policy data
   **/
   FUNCTION get_bond_policy_data (p_policy_id gipi_bond_basic.policy_id%TYPE)
      RETURN bond_policy_data_tab PIPELINED
   IS
      v_bond_policy_data   bond_policy_data_type;
   BEGIN
      FOR i IN (SELECT a.obligee_no, a.prin_id, a.np_no, a.clause_type,
                       a.policy_id, a.bond_dtl, a.indemnity_text,
                       a.coll_flag, a.waiver_limit,
                       TO_CHAR (a.contract_date, 'MM-dd-rrrr') str_cntr_date,
                       a.contract_dtl, b.obligee_name, c.prin_signor,
                       c.designation, d.np_name, f.clause_desc, g.gen_info
                  FROM gipi_bond_basic a,
                       giis_obligee b,
                       giis_prin_signtry c,
                       giis_notary_public d,
                       giis_bond_class_clause f,
                       gipi_polgenin g
                 WHERE a.obligee_no = b.obligee_no(+)
                   AND a.prin_id = c.prin_id(+)
                   AND a.np_no = d.np_no(+)
                   AND a.policy_id = g.policy_id(+)
                   AND a.clause_type = f.clause_type(+)
                   AND a.policy_id = p_policy_id)
      LOOP
         v_bond_policy_data.obligee_name := i.obligee_name;
         v_bond_policy_data.prin_signor := i.prin_signor;
         v_bond_policy_data.designation := i.designation;
         v_bond_policy_data.np_name := i.np_name;
         v_bond_policy_data.clause_desc := i.clause_desc;
         v_bond_policy_data.gen_info := i.gen_info;
         v_bond_policy_data.bond_dtl := i.bond_dtl;
         v_bond_policy_data.indemnity_text := i.indemnity_text;
         v_bond_policy_data.coll_flag := i.coll_flag;
         v_bond_policy_data.waiver_limit := i.waiver_limit;
         v_bond_policy_data.str_cntr_date := i.str_cntr_date;
         v_bond_policy_data.contract_dtl := i.contract_dtl;
         v_bond_policy_data.policy_id := i.policy_id;
         PIPE ROW (v_bond_policy_data);
      END LOOP;

      RETURN;
   END get_bond_policy_data;

/**
* Rey Jadlocon
* 08.16.2011
* consignor(s)
**/
   FUNCTION get_cosignor (p_policy_id gipi_cosigntry.policy_id%TYPE)
      RETURN cosignor_tab PIPELINED
   IS
      v_cosignor   cosignor_type;
   BEGIN
      FOR x IN (SELECT a.cosign_name, b.bonds_flag, b.indem_flag
                  FROM giis_cosignor_res a, gipi_cosigntry b
                 WHERE a.cosign_id = b.cosign_id
                       AND b.policy_id = p_policy_id)
      LOOP
         v_cosignor.cosign_name := x.cosign_name;
         v_cosignor.bonds_flag := x.bonds_flag;
         v_cosignor.indem_flag := x.indem_flag;
         PIPE ROW (v_cosignor);
      END LOOP;

      RETURN;
   END get_cosignor;

   /*
   **  Created by        : Emman
   **  Date Created     : 08.18.2011
   **  Reference By     : (GIUTS021 - Redistribution)
   **  Description     : get GIPI_POLBASIC record for redistribution of specified policy_id
   */
   FUNCTION get_redistribution_policy (
      p_policy_id   gipi_polbasic.policy_id%TYPE
   )
      RETURN gipi_polbasic_tab5 PIPELINED
   IS
      v_polbasic   gipi_polbasic_type5;
   BEGIN
      FOR i IN (SELECT a.par_id, a.line_cd, a.subline_cd, a.iss_cd,
                       a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd,
                       a.endt_yy, a.endt_seq_no, a.eff_date, a.expiry_date,
                       a.assd_no, b.assd_name, a.dist_flag, a.policy_id,
                       a.renew_flag,
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || TO_CHAR (a.issue_yy, '09')
                       || '-'
                       || TO_CHAR (a.pol_seq_no, '0999999') policy_no,
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.endt_iss_cd
                       || '-'
                       || TO_CHAR (a.endt_yy, '09')
                       || '-'
                       || TO_CHAR (a.endt_seq_no, '0999999') endt_no
                  FROM gipi_polbasic a, giis_assured b
                 WHERE a.policy_id = p_policy_id AND a.assd_no = b.assd_no)
      LOOP
         v_polbasic.par_id := i.par_id;
         v_polbasic.line_cd := i.line_cd;
         v_polbasic.subline_cd := i.subline_cd;
         v_polbasic.iss_cd := i.iss_cd;
         v_polbasic.issue_yy := i.issue_yy;
         v_polbasic.pol_seq_no := i.pol_seq_no;
         v_polbasic.renew_no := i.renew_no;
         v_polbasic.endt_iss_cd := i.endt_iss_cd;
         v_polbasic.endt_yy := i.endt_yy;
         v_polbasic.endt_seq_no := i.endt_seq_no;
         v_polbasic.eff_date := i.eff_date;
         v_polbasic.expiry_date := i.expiry_date;
         v_polbasic.assd_no := i.assd_no;
         v_polbasic.assd_name := i.assd_name;
         v_polbasic.dist_flag := i.dist_flag;
         v_polbasic.policy_id := i.policy_id;
         v_polbasic.policy_no := i.policy_no;
         v_polbasic.renew_flag := i.renew_flag;

         IF i.endt_seq_no IS NULL OR i.endt_seq_no < 1
         THEN
            v_polbasic.endt_no := '';
         ELSE
            v_polbasic.endt_no := i.endt_no;
         END IF;

         PIPE ROW (v_polbasic);
      END LOOP;

      RETURN;
   END get_redistribution_policy;

   /*
   **  Created by        : Niknok Orio
   **  Date Created     : 09.26.2011
   **  Reference By     : (GICLS010 - Claims basic information)
   **  Description     : getting LOV for issue year
   */
   FUNCTION get_issue_yy_list (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd   gipi_polbasic.iss_cd%TYPE
   )
      RETURN gipi_polbasic_tab PIPELINED
   IS
      v_list   gipi_polbasic_type;
      v_pack_pol  giis_line.pack_pol_flag%TYPE := 'N';
   BEGIN
      FOR i IN (SELECT DISTINCT a.issue_yy
                           FROM gipi_polbasic a, giuw_pol_dist b
                          WHERE a.line_cd = p_line_cd
                            AND a.subline_cd = p_subline_cd
                            AND a.iss_cd = p_pol_iss_cd
                            AND a.policy_id = b.policy_id
                            AND b.dist_flag IN (
                                            SELECT c.param_value_v
                                              FROM giis_parameters c
                                             WHERE c.param_name =
                                                                 'DISTRIBUTED')
                            AND b.negate_date IS NULL)
      LOOP
         v_list.issue_yy := i.issue_yy;
         PIPE ROW (v_list);
      END LOOP;
      
      --added by kenneth 11.28.2014
      BEGIN
         SELECT pack_pol_flag
           INTO v_pack_pol
           FROM giis_line
          WHERE line_cd = p_line_cd AND pack_pol_flag = 'Y';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_pack_pol := 'N';
      END;
       
      IF v_pack_pol = 'Y' THEN
        BEGIN
            FOR j IN (SELECT DISTINCT issue_yy
                    FROM gipi_pack_polbasic  
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_pol_iss_cd
                      AND pol_seq_no > 0)
            LOOP
            v_list.issue_yy := j.issue_yy;
            PIPE ROW (v_list);
            END LOOP;
        END;
       END IF;
      --end
      RETURN;
   END;

   /*
   **  Created by        : Niknok Orio
   **  Date Created     : 09.26.2011
   **  Reference By     : (GICLS010 - Claims basic information)
   **  Description     : getting LOV for policy sequence no.
   */
   FUNCTION get_pol_seq_no_list (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE
   )
      RETURN gipi_polbasic_tab PIPELINED
   IS
      v_list   gipi_polbasic_type;
      v_pack_pol  giis_line.pack_pol_flag%TYPE := 'N';
   BEGIN
      FOR i IN (SELECT DISTINCT a.pol_seq_no
                           FROM gipi_polbasic a, giuw_pol_dist b
                          WHERE a.pol_flag NOT IN ('4', '5')
                            AND a.line_cd = p_line_cd
                            AND a.subline_cd = p_subline_cd
                            AND a.iss_cd = p_pol_iss_cd
                            AND a.issue_yy = p_issue_yy
                            AND a.endt_seq_no = 0
                            AND a.policy_id = b.policy_id
                            AND b.dist_flag IN (
                                            SELECT c.param_value_v
                                              FROM giis_parameters c
                                             WHERE c.param_name =
                                                                 'DISTRIBUTED')
                            AND b.negate_date IS NULL
                       ORDER BY a.pol_seq_no)
      LOOP
         v_list.pol_seq_no := i.pol_seq_no;
         PIPE ROW (v_list);
      END LOOP;

      --added by kenneth 11.28.2014
      BEGIN
         SELECT pack_pol_flag
           INTO v_pack_pol
           FROM giis_line
          WHERE line_cd = p_line_cd AND pack_pol_flag = 'Y';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_pack_pol := 'N';
      END;
      
      IF v_pack_pol = 'Y' THEN
        BEGIN
            FOR j IN (SELECT DISTINCT nvl(pol_seq_no, null) pol_seq_no
                    FROM gipi_pack_polbasic  
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_pol_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no > 0)
            LOOP
            v_list.pol_seq_no := j.pol_seq_no;
            PIPE ROW (v_list);
            END LOOP;
        END;
       END IF;
     --end
       
      RETURN;
   END;

   /*
   **  Created by        : Niknok Orio
   **  Date Created     : 09.26.2011
   **  Reference By     : (GICLS010 - Claims basic information)
   **  Description     : getting LOV for renew no.
   */
   FUNCTION get_renew_no_list (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE
   )
      RETURN gipi_polbasic_tab PIPELINED
   IS
      v_list   gipi_polbasic_type;
      v_pack_pol  giis_line.pack_pol_flag%TYPE := 'N';
   BEGIN
      FOR i IN (SELECT DISTINCT a.renew_no
                           FROM gipi_polbasic a, giuw_pol_dist b
                          WHERE a.line_cd = p_line_cd
                            AND a.subline_cd = p_subline_cd
                            AND a.iss_cd = p_pol_iss_cd
                            AND a.issue_yy = p_issue_yy
                            AND a.pol_seq_no = p_pol_seq_no
                            AND a.policy_id = b.policy_id
                            AND b.dist_flag IN (
                                            SELECT c.param_value_v
                                              FROM giis_parameters c
                                             WHERE c.param_name =
                                                                 'DISTRIBUTED')
                            AND b.negate_date IS NULL
                       ORDER BY a.renew_no)
      LOOP
         v_list.renew_no := i.renew_no;
         PIPE ROW (v_list);
      END LOOP;

      --added by kenneth 11.28.2014
      BEGIN
         SELECT pack_pol_flag
           INTO v_pack_pol
           FROM giis_line
          WHERE line_cd = p_line_cd AND pack_pol_flag = 'Y';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_pack_pol := 'N';
      END;
      
      IF v_pack_pol = 'Y' THEN
        BEGIN
            FOR j IN (SELECT DISTINCT renew_no
                    FROM gipi_pack_polbasic
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_pol_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no)
            LOOP
            v_list.renew_no := j.renew_no;
            PIPE ROW (v_list);
            END LOOP;
        END;
       END IF;
     --end

      RETURN;
   END;

   /*
   **  Created by        : Robert Virrey
   **  Date Created     : 09.29.2011
   **  Reference By     : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
   **  Description     : PACK_DETAILS_HEADER PROGRAM UNIT
   */
   PROCEDURE get_pack_details_header (
      p_pack_policy_id     IN       gipi_polbasic.pack_policy_id%TYPE,
      p_policy_id          IN       gipi_polbasic.policy_id%TYPE,
      p_dsp_policy_id      OUT      gipi_polbasic.policy_id%TYPE,
      p_dsp_line_cd        OUT      giex_expiries_v.line_cd%TYPE,
      p_dsp_subline_cd     OUT      giex_expiries_v.subline_cd%TYPE,
      p_dsp_iss_cd         OUT      giex_expiries_v.iss_cd%TYPE,
      p_dsp_issue_yy       OUT      giex_expiries_v.issue_yy%TYPE,
      p_dsp_pol_seq_no     OUT      giex_expiries_v.pol_seq_no%TYPE,
      p_dsp_renew_no       OUT      giex_expiries_v.renew_no%TYPE,
      p_basic_policy_id    OUT      gipi_polbasic.policy_id%TYPE,
      p_basic_line_cd      OUT      gipi_polbasic.line_cd%TYPE,
      p_basic_subline_cd   OUT      gipi_polbasic.subline_cd%TYPE,
      p_basic_iss_cd       OUT      gipi_polbasic.iss_cd%TYPE,
      p_basic_issue_yy     OUT      gipi_polbasic.issue_yy%TYPE,
      p_basic_pol_seq_no   OUT      gipi_polbasic.pol_seq_no%TYPE,
      p_basic_renew_no     OUT      gipi_polbasic.renew_no%TYPE
   )
   IS
   BEGIN
      IF p_pack_policy_id > 0
      THEN
         FOR cur IN (SELECT policy_id, line_cd, subline_cd,
                            iss_cd, issue_yy, pol_seq_no,
                            renew_no
                       FROM gipi_polbasic
                      WHERE pack_policy_id = p_pack_policy_id)
         LOOP
            p_basic_policy_id   := cur.policy_id;
            p_basic_line_cd     := cur.line_cd;
            p_basic_subline_cd  := cur.subline_cd;
            p_basic_iss_cd      := cur.iss_cd;
            p_basic_issue_yy    := cur.issue_yy;
            p_basic_pol_seq_no  := cur.pol_seq_no;
            p_basic_renew_no    := cur.renew_no;
            EXIT;
         END LOOP;

         SELECT policy_id, line_cd, subline_cd,
                iss_cd, issue_yy, pol_seq_no, renew_no
           INTO p_dsp_policy_id, p_dsp_line_cd, p_dsp_subline_cd,
                p_dsp_iss_cd, p_dsp_issue_yy, p_dsp_pol_seq_no, p_dsp_renew_no
           FROM giex_expiries_v
          WHERE pack_policy_id = p_pack_policy_id;
      ELSE
         FOR cur IN (SELECT policy_id, line_cd, subline_cd,
                            iss_cd, issue_yy, pol_seq_no,
                            renew_no
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id)
         LOOP
            p_basic_policy_id   := cur.policy_id;
            p_basic_line_cd     := cur.line_cd;
            p_basic_subline_cd  := cur.subline_cd;
            p_basic_iss_cd      := cur.iss_cd;
            p_basic_issue_yy    := cur.issue_yy;
            p_basic_pol_seq_no  := cur.pol_seq_no;
            p_basic_renew_no    := cur.renew_no;
            EXIT;
         END LOOP;
      END IF;
   END get_pack_details_header;

   /*
   **  Created by   : Robert Virrey
   **  Date Created : 10-12-2011
   **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
   **  Description  : UPDATE_POLBAS2 program unit
   */
   PROCEDURE update_polbas2 (p_new_policy_id gipi_polbasic.policy_id%TYPE)
   IS
      v_no_itm          gipi_polbasic.no_of_items%TYPE;
      v_tsi_amt         gipi_polbasic.tsi_amt%TYPE;
      v_prem_amt        gipi_polbasic.prem_amt%TYPE;
      v_ann_prem_amt    gipi_polbasic.prem_amt%TYPE;
      v_ann_prem_amt1   gipi_polbasic.prem_amt%TYPE;
      v_ann_tsi_amt     gipi_polbasic.ann_tsi_amt%TYPE;
      v_tsi_amt1        gipi_polbasic.tsi_amt%TYPE;
      v_prem_amt1       gipi_polbasic.prem_amt%TYPE;
      v_ann_tsi_amt1    gipi_polbasic.ann_tsi_amt%TYPE;
      /*FOR GPA*/
      v_ann_prem_amt2   gipi_polbasic.prem_amt%TYPE;
      v_tsi_amt2        gipi_polbasic.tsi_amt%TYPE;
      v_prem_amt2       gipi_polbasic.prem_amt%TYPE;
      v_ann_tsi_amt2    gipi_polbasic.ann_tsi_amt%TYPE;
      /*END GPA*/
      v_dep_pct         NUMBER (3, 2)          := giisp.n ('MC_DEP_PCT')
                                                  / 100;
   BEGIN
      FOR item IN (SELECT   item_no, currency_rt
                       FROM gipi_item
                      WHERE policy_id = p_new_policy_id
                   ORDER BY item_no)
      LOOP
         v_prem_amt1 := 0;
         v_tsi_amt1 := 0;
         v_ann_tsi_amt1 := 0;

         /*FOR GPA*/
         FOR grp_item IN (SELECT   grouped_item_no
                              FROM gipi_grouped_items
                             WHERE policy_id = p_new_policy_id
                               AND item_no = item.item_no
                          ORDER BY item_no)
         LOOP
            v_prem_amt2 := 0;
            v_tsi_amt2 := 0;
            v_ann_tsi_amt2 := 0;
            v_ann_prem_amt2 := 0;

            FOR grp_peril IN (SELECT a.item_no, a.tsi_amt, a.prem_amt,
                                     b.line_cd line_cd, b.peril_cd peril_cd,
                                     NVL (a.ann_prem_amt,
                                          a.prem_amt
                                         ) ann_prem_amt,
                                     b.peril_type, a.prem_rt
                                FROM gipi_itmperil_grouped a, giis_peril b
                               WHERE a.line_cd = b.line_cd
                                 AND a.peril_cd = b.peril_cd
                                 AND a.grouped_item_no =
                                                      grp_item.grouped_item_no
                                 AND a.item_no = item.item_no
                                 AND policy_id = p_new_policy_id)
            LOOP
               v_prem_amt2 := NVL (v_prem_amt2, 0) + grp_peril.prem_amt;
               v_ann_prem_amt2 :=
                             NVL (v_ann_prem_amt2, 0)
                             + grp_peril.ann_prem_amt;

               IF grp_peril.peril_type = 'B'
               THEN
                  v_tsi_amt2 := NVL (v_tsi_amt2, 0) + grp_peril.tsi_amt;
                  v_ann_tsi_amt2 :=
                                   NVL (v_ann_tsi_amt2, 0)
                                   + grp_peril.tsi_amt;
               END IF;
            END LOOP;

            IF NVL (v_ann_tsi_amt2, 0) = 0
            THEN
               DELETE FROM gipi_grouped_items
                     WHERE item_no = item.item_no
                       AND grouped_item_no = grp_item.grouped_item_no
                       AND policy_id = p_new_policy_id;
            ELSE
               UPDATE gipi_grouped_items
                  SET prem_amt = v_prem_amt2,
                      ann_prem_amt = v_ann_prem_amt2,
                      tsi_amt = v_tsi_amt2,
                      ann_tsi_amt = v_ann_tsi_amt2
                WHERE item_no = item.item_no
                  AND grouped_item_no = grp_item.grouped_item_no
                  AND policy_id = p_new_policy_id;
            END IF;
         --forms_ddl('COMMIT');
         END LOOP;

         /*END GPA*/
         FOR peril IN (SELECT a.item_no, a.tsi_amt, a.prem_amt,
                              b.line_cd line_cd, b.peril_cd peril_cd,
                              NVL (a.ann_prem_amt, a.prem_amt) ann_prem_amt,
                              b.peril_type, a.prem_rt
                         FROM gipi_itmperil a, giis_peril b
                        WHERE a.line_cd = b.line_cd
                          AND a.peril_cd = b.peril_cd
                          AND a.item_no = item.item_no
                          AND policy_id = p_new_policy_id)
         LOOP
            v_prem_amt1 := NVL (v_prem_amt1, 0) + peril.prem_amt;
            v_ann_prem_amt1 := NVL (v_ann_prem_amt1, 0) + peril.ann_prem_amt;

            IF peril.peril_type = 'B'
            THEN
               v_tsi_amt1 := NVL (v_tsi_amt1, 0) + peril.tsi_amt;
               v_ann_tsi_amt1 := NVL (v_ann_tsi_amt1, 0) + peril.tsi_amt;
            END IF;
         /*FOR a IN (
           SELECT '1'
                     FROM giex_dep_perl b
                  WHERE b.line_cd  = peril.line_cd
                    AND b.peril_cd = peril.peril_cd
                    AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
             LOOP
                 v_tsi_amt1      := v_tsi_amt1 - (v_tsi_amt1*v_dep_pct);
                   v_ann_tsi_amt1  := v_tsi_amt1 - (v_tsi_amt1*v_dep_pct);
                   v_prem_amt1     := v_tsi_amt1 * (peril.prem_rt/100);
                   v_ann_prem_amt1 := v_tsi_amt1 * (peril.prem_rt/100);
               END LOOP;*/
         END LOOP;

         IF NVL (v_ann_tsi_amt1, 0) = 0
         THEN
            DELETE FROM gipi_item
                  WHERE item_no = item.item_no
                        AND policy_id = p_new_policy_id;
         ELSE
            UPDATE gipi_item
               SET prem_amt = v_prem_amt1,
                   ann_prem_amt = v_ann_prem_amt1,
                   tsi_amt = v_tsi_amt1,
                   ann_tsi_amt = v_ann_tsi_amt1
             WHERE item_no = item.item_no AND policy_id = p_new_policy_id;
         END IF;

         v_no_itm := NVL (v_no_itm, 0) + 1;
         v_prem_amt := NVL (v_prem_amt, 0) + (v_prem_amt1 * item.currency_rt);
         v_ann_prem_amt :=
                   NVL (v_ann_prem_amt, 0)
                 + (v_ann_prem_amt1 * item.currency_rt);
         v_tsi_amt := NVL (v_tsi_amt, 0) + (v_tsi_amt1 * item.currency_rt);
         v_ann_tsi_amt :=
                     NVL (v_ann_tsi_amt, 0)
                   + (v_ann_tsi_amt1 * item.currency_rt);
      --message(v_tsi_amt||'-'||variables.new_par_id);pause;
      END LOOP;

      --forms_ddl('COMMIT');
      UPDATE gipi_polbasic
         SET prem_amt = v_prem_amt,
             tsi_amt = v_tsi_amt,
             no_of_items = v_no_itm,
             ann_tsi_amt = v_ann_tsi_amt,
             ann_prem_amt = v_ann_prem_amt
       WHERE policy_id = p_new_policy_id;
   --forms_ddl('COMMIT');
   --message(v_tsi_amt);pause;
   END update_polbas2;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : December 14, 2011
   **  Reference By  : (GICLS026- No Claim)
   **  Description   : chck_policy program unit
   */
   PROCEDURE check_policy_gicls026 (
      p_line_cd      IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN       gipi_polbasic.renew_no%TYPE,
      p_msg          OUT      VARCHAR2
   )
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      SELECT DISTINCT 'x'
                 INTO v_exist
                 FROM gipi_polbasic
                WHERE line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND iss_cd = p_iss_cd
                  AND issue_yy = p_issue_yy
                  AND pol_seq_no = p_pol_seq_no
                  AND renew_no = p_renew_no;

      IF v_exist IS NOT NULL
      THEN
         gicl_claims_pkg.check_claims_gicls026 (p_line_cd,
                                                p_subline_cd,
                                                p_iss_cd,
                                                p_issue_yy,
                                                p_pol_seq_no,
                                                p_renew_no,
                                                p_msg
                                               );
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         /* :c038.line_cd := null;
          :c038.subline_cd := null;
          :c038.iss_cd := null;
          :c038.issue_yy := null;
          :c038.pol_seq_no := null;
          :c038.renew_no := null;
          set_item_property('c038.item_no',REQUIRED,PROPERTY_FALSE);
          msg_alert('Policy does not exist.','I',FALSE);*/
         p_msg := 'Policy does not exist.';
   END;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : December 14, 2011
   **  Reference By  : (GICLS026- No Claim)
   **  Description   : ISSUE_YY_LOV
   */
   FUNCTION get_polbasic_issue_yy (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE
   )
      RETURN gipi_polbasic_tab PIPELINED
   IS
      v_polbasic   gipi_polbasic_type;
   BEGIN
      FOR i IN (SELECT DISTINCT TO_CHAR (issue_yy, '09') issue_yy
                           FROM gipi_polbasic
                          WHERE iss_cd = p_iss_cd
                            AND subline_cd = p_subline_cd
                            AND line_cd = p_line_cd)
      LOOP
         v_polbasic.issue_yy := i.issue_yy;
         PIPE ROW (v_polbasic);
      END LOOP;

      RETURN;
   END get_polbasic_issue_yy;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : December 14, 2011
   **  Reference By  : (GICLS026- No Claim)
   **  Description   : POL_SEQ_NO_LOV
   */
   FUNCTION get_polbasic_pol_seq_no (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE
   )
      RETURN gipi_polbasic_tab PIPELINED
   IS
      v_polbasic   gipi_polbasic_type;
   BEGIN
      FOR i IN (SELECT DISTINCT TO_CHAR (pol_seq_no, '0999999') pol_seq_no
                           FROM gipi_polbasic
                          WHERE issue_yy = p_issue_yy
                            AND iss_cd = p_iss_cd
                            AND subline_cd = p_subline_cd
                            AND line_cd = p_line_cd
                      ORDER BY pol_seq_no)
      LOOP
         v_polbasic.pol_seq_no := i.pol_seq_no;
         PIPE ROW (v_polbasic);
      END LOOP;

      RETURN;
   END get_polbasic_pol_seq_no;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : December 14, 2011
   **  Reference By  : (GICLS026- No Claim)
   **  Description   : RENEW_NO_LOV
   */
   FUNCTION get_polbasic_renew_no (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE
   )
      RETURN gipi_polbasic_tab PIPELINED
   IS
      v_polbasic   gipi_polbasic_type;
   BEGIN
      FOR i IN (SELECT DISTINCT TO_CHAR (renew_no, '09') renew_no
                           FROM gipi_polbasic
                          WHERE pol_seq_no = p_pol_seq_no
                            AND issue_yy = p_issue_yy
                            AND iss_cd = p_iss_cd
                            AND subline_cd = p_subline_cd
                            AND line_cd = p_line_cd
                        ORDER BY renew_no)
      LOOP
         v_polbasic.renew_no := i.renew_no;
         PIPE ROW (v_polbasic);
      END LOOP;

      RETURN;
   END get_polbasic_renew_no;

   /*
   **  Created by      : Robert Virrey
   **  Date Created    : 01.05.2012
   **  Reference By    : (GIUTS024 Generate Binder (Non-Affecting Endorsement))
   **  Description     : gets GIUTS024 list of records
   */
   FUNCTION get_giuts024_listing (
     p_user_id      giis_users.user_id%TYPE,
     p_line_cd      gipi_polbasic.line_cd%TYPE,
     p_subline_cd   gipi_polbasic.subline_cd%TYPE,
     p_iss_cd       gipi_polbasic.iss_cd%TYPE,
     p_issue_yy     gipi_polbasic.issue_yy%TYPE,
     p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
     p_renew_no     gipi_polbasic.renew_no%TYPE,
     p_endt_seq_no  gipi_polbasic.endt_seq_no%TYPE
   )
   RETURN gipi_polbasic_tab5 PIPELINED
   IS
      v_polbasic   gipi_polbasic_type5;
   BEGIN
      FOR i IN (SELECT *
                  FROM gipi_polbasic
                 WHERE POL_FLAG IN ( '1','2','3','X') --added 'X' by j.diago 09.17.2014
                   --AND line_cd = DECODE(check_user_per_line2(line_cd, iss_cd,'GIUTS024', p_user_id),1, line_cd,NULL) removed by j.diago 09.17.2014 : moved to xml 
                   --AND iss_cd = DECODE(check_user_per_iss_cd2(line_cd, iss_cd,'GIUTS024', p_user_id),1, iss_cd,NULL) removed by j.diago 09.17.2014 : moved to xml
                   AND NVL(ENDT_SEQ_NO, 0) > 0
                   AND NVL(ENDT_TYPE, 'N') = 'N'
                   AND EXISTS (SELECT '1'
                                 FROM GIPI_POLBASIC B, GIUW_POL_DIST C, GIRI_DISTFRPS D
                                WHERE B.LINE_CD = GIPI_POLBASIC.LINE_CD
                                  AND B.SUBLINE_CD = GIPI_POLBASIC.SUBLINE_CD
                                  AND B.ISS_CD = GIPI_POLBASIC.ISS_CD
                                  AND B.ISSUE_YY = GIPI_POLBASIC.ISSUE_YY
                                  AND B.POL_SEQ_NO = GIPI_POLBASIC.POL_SEQ_NO
                                  AND B.RENEW_NO = GIPI_POLBASIC.RENEW_NO
                                  AND B.POL_FLAG IN ('1','2','3','X')
                                  AND B.POLICY_ID = C.POLICY_ID
                                  AND C.DIST_NO = D.DIST_NO
                                  AND D.RI_FLAG  <> '4')
                   AND line_cd LIKE UPPER (NVL (p_line_cd, '%')) -- removed UPPER(line_cd) by j.diago 09.17.2014 : to use index
                   AND subline_cd LIKE UPPER (NVL (p_subline_cd, '%')) -- removed UPPER(subline_cd) by j.diago 09.17.2014 : to use index
                   AND iss_cd LIKE UPPER (NVL (p_iss_cd, '%')) -- removed UPPER(iss_cd) by j.diago 09.17.2014 : to use index
                   AND issue_yy = NVL (p_issue_yy, issue_yy)
                   AND pol_seq_no = NVL (p_pol_seq_no, pol_seq_no)
                   AND renew_no = NVL (p_renew_no, renew_no)
                   AND endt_seq_no = NVL(p_endt_seq_no, endt_seq_no)
                 ORDER BY line_cd, subline_cd, iss_cd, issue_yy,  pol_seq_no, endt_iss_cd, endt_yy, endt_seq_no)
      LOOP
         v_polbasic.policy_id   := i.policy_id;
         v_polbasic.policy_no   := gipi_polbasic_pkg.get_policy_no (i.policy_id);
         v_polbasic.assd_no     := i.assd_no;
         v_polbasic.eff_date    := i.eff_date;
         v_polbasic.expiry_date := i.expiry_date;
         v_polbasic.par_id      := i.par_id;
         v_polbasic.line_cd     := i.line_cd;
         v_polbasic.subline_cd  := i.subline_cd;
         v_polbasic.iss_cd      := i.iss_cd;
         v_polbasic.issue_yy    := i.issue_yy;
         v_polbasic.pol_seq_no  := i.pol_seq_no;
         v_polbasic.renew_no    := i.renew_no;

         IF i.endt_seq_no = 0
         THEN
            v_polbasic.endt_no      := NULL;
            v_polbasic.endt_iss_cd  := NULL;
            v_polbasic.endt_yy      := NULL;
            v_polbasic.endt_seq_no  := NULL;
         ELSE
            v_polbasic.endt_no      := i.endt_iss_cd|| ' - '|| TO_CHAR (i.endt_yy, '09')|| ' - '|| TO_CHAR (i.endt_seq_no, '099999');
            v_polbasic.endt_iss_cd  := i.endt_iss_cd;
            v_polbasic.endt_yy      := TO_CHAR (i.endt_yy, '09');
            v_polbasic.endt_seq_no  := TO_CHAR (i.endt_seq_no, '099999');
         END IF;

         BEGIN
            FOR assd IN (SELECT assd_name
                           FROM giis_assured a, gipi_parlist b
                          WHERE a.assd_no = b.assd_no AND b.par_id = i.par_id)
            LOOP
               v_polbasic.assd_name := assd.assd_name;
               EXIT;
            END LOOP;
         END;

         PIPE ROW (v_polbasic);
      END LOOP;

      RETURN;
   END get_giuts024_listing;

   /*
   **  Created by      : Andrew Robes
   **  Date Created    : 01.06.2012
   **  Reference By    : (GIPIS091 - Regenerate Policy Documents)
   **  Description     : Function to retrieve policy records
   */
   FUNCTION get_reprint_policy_listing (
      p_user_id           giis_users.user_id%TYPE,
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_iss_cd            gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          gipi_polbasic.renew_no%TYPE,
      p_endt_line_cd      gipi_polbasic.line_cd%TYPE,
      p_endt_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_endt_iss_cd       gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy           gipi_polbasic.endt_yy%TYPE, 
      p_endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
      p_assd_name         giis_assured.assd_name%TYPE,
      p_policy_no         VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_endt_no           VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_par_no            VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_dsp_prem_seq_no   VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_order_by          VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_asc_desc_flag     VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_first_row         NUMBER,        --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_last_row          NUMBER         --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
   )
      RETURN reprint_policy_tab PIPELINED
   IS
      v_pol   reprint_policy_type;
      v_count_prem_seq_no   NUMBER;
      TYPE cur_type IS REF CURSOR;      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      c        cur_type;                --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      v_sql    VARCHAR2(32767);         --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
   BEGIN
      
      --edited by d.alcantara, 04-19-2012, edited query
      /*FOR i IN ( SELECT mainsql.*
              FROM (SELECT yeah.*, ROW_NUMBER () OVER (ORDER BY 1) ROW_NUMBER,
                           COUNT (1) OVER () row_count
                      FROM (SELECT jm.*
                       FROM (SELECT ROWNUM rownum_, a.*
                              FROM (SELECT a.*, *//*b.assd_name,NVL (c.endt_tax, 'N') endt_tax, d.menu_line_cd
                  FROM (SELECT pol.pack_policy_id, pol.line_cd, pol.subline_cd, pol.iss_cd,
                               pol.issue_yy, pol.pol_seq_no, pol.renew_no, pol.endt_iss_cd,
                               pol.endt_yy, pol.endt_seq_no, pol.policy_id, pol.assd_no,
                               pol.endt_type, pol.par_id, pol.no_of_items, pol.pol_flag,
                               pol.co_insurance_sw, pol.fleet_print_tag, ga.assd_name
                          FROM gipi_polbasic pol, gipi_parlist par,
                               giis_assured ga
                         WHERE pack_policy_id IS NULL
                           AND par.par_id = pol.par_id 
                           AND par.assd_no = ga.assd_no
                           AND par.par_id IN ( SELECT par_id
                                       FROM gipi_parlist
                                      WHERE assd_no IN ( 
                                             SELECT assd_no
                                               FROM giis_assured
                                              WHERE UPPER(assd_name) like UPPER('%'||p_assd_name||'%'))) --added upper by robert 03.16.15
                        UNION ALL
                        SELECT pack.pack_policy_id, pack.line_cd, pack.subline_cd, pack.iss_cd,
                               pack.issue_yy, pack.pol_seq_no, pack.renew_no, pack.endt_iss_cd,
                               pack.endt_yy, pack.endt_seq_no, pack.pack_policy_id policy_id,
                               pack.assd_no, pack.endt_type, pack.pack_par_id par_id,
                               pack.no_of_items, pack.pol_flag, pack.co_insurance_sw,
                               pack.fleet_print_tag, ga.assd_name
                          FROM gipi_pack_polbasic pack, gipi_pack_parlist par,
                               giis_assured ga
                         WHERE pack.pack_par_id = par.pack_par_id
                           AND ga.assd_no = par.assd_no
                           AND par.pack_par_id IN (SELECT pack_par_id
                                       FROM gipi_pack_parlist
                                      WHERE assd_no IN ( 
                                             SELECT assd_no
                                               FROM giis_assured
                                              WHERE UPPER(assd_name) like UPPER('%'||p_assd_name||'%'))) --added upper by robert 03.16.15
                       ) a,
                      -- giis_assured b,
                       gipi_endttext c,
                       giis_line d
                 WHERE a.line_cd =
                          DECODE (check_user_per_line2 (a.line_cd,
                                                        a.iss_cd,
                                                        'GIPIS091',
                                                        p_user_id
                                                       ),
                                  1, a.line_cd,
                                  NULL
                                 )
                   AND a.iss_cd =
                          DECODE (check_user_per_iss_cd2 (a.line_cd,
                                                          a.iss_cd,
                                                          'GIPIS091',
                                                          p_user_id
                                                         ),
                                  1, a.iss_cd,
                                  NULL
                                 )
                   AND c.policy_id(+) = a.policy_id
                   AND d.line_cd = a.line_cd
                   AND UPPER (a.line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
                   AND UPPER (a.subline_cd) LIKE UPPER (NVL (p_subline_cd, '%'))
                   AND UPPER (a.iss_cd) LIKE UPPER (NVL (p_iss_cd, '%'))
                   AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
                   AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
                   AND a.renew_no = NVL (p_renew_no, a.renew_no)
                   AND UPPER (a.line_cd) LIKE UPPER (NVL (p_endt_line_cd, '%'))
                   AND UPPER (a.subline_cd) LIKE UPPER (NVL (p_endt_subline_cd, '%'))
                   AND UPPER (a.iss_cd) LIKE UPPER (NVL (p_endt_iss_cd, '%'))                   
                   AND a.endt_yy = NVL (p_endt_yy, a.endt_yy)
                   AND a.endt_seq_no = NVL (p_endt_seq_no, a.endt_seq_no)
              ORDER BY a.endt_seq_no)
               a) jm) yeah) mainsql
               WHERE rownum_ BETWEEN p_first_row AND p_last_row)
      LOOP
         v_pol.pack_policy_id := i.pack_policy_id;
         v_pol.line_cd := i.line_cd;
         v_pol.menu_line_cd := i.menu_line_cd;
         v_pol.subline_cd := i.subline_cd;
         v_pol.iss_cd := i.iss_cd;
         v_pol.issue_yy := i.issue_yy;
         v_pol.pol_seq_no := i.pol_seq_no;
         v_pol.renew_no := i.renew_no;
         v_pol.endt_iss_cd := i.endt_iss_cd;
         v_pol.endt_yy := i.endt_yy;
         v_pol.endt_seq_no := i.endt_seq_no;
         v_pol.policy_id := i.policy_id;
         v_pol.assd_no := i.assd_no;
         v_pol.endt_type := i.endt_type;
         v_pol.par_id := i.par_id;
         v_pol.no_of_items := i.no_of_items;
         v_pol.pol_flag := i.pol_flag;
         v_pol.co_insurance_sw := i.co_insurance_sw;
         v_pol.fleet_print_tag := i.fleet_print_tag;
         v_pol.assd_name := i.assd_name;
         v_pol.endt_tax := i.endt_tax;  

         IF i.pack_policy_id IS NULL
         THEN
            v_pol.policy_no := gipi_polbasic_pkg.get_policy_no (i.policy_id);
         ELSE
            v_pol.policy_no :=
                           gipi_polbasic_pkg.get_pack_policy_no (i.policy_id);
         END IF;

         IF NVL (i.endt_seq_no, 0) <> 0
         THEN
            IF i.pack_policy_id IS NULL
            THEN
               v_pol.endt_no := gipi_polbasic_pkg.get_endt_no (i.policy_id);
            ELSE
               v_pol.endt_no :=
                             gipi_polbasic_pkg.get_pack_endt_no (i.policy_id);
            END IF;
         END IF;

         IF i.pack_policy_id IS NULL
         THEN
            FOR z IN (SELECT line_cd, iss_cd, par_yy, par_seq_no,
                             quote_seq_no
                        FROM gipi_parlist
                       WHERE par_id = i.par_id)
            LOOP
               v_pol.par_no :=
                     z.line_cd
                  || ' - '
                  || z.iss_cd
                  || ' - '
                  || TO_CHAR (z.par_yy, '09')
                  || ' - '
                  || TO_CHAR (z.par_seq_no, '099999')
                  || ' - '
                  || TO_CHAR (z.quote_seq_no, '09');
            END LOOP;
         ELSE
            FOR z IN (SELECT line_cd, iss_cd, par_yy, par_seq_no,
                             quote_seq_no
                        FROM gipi_pack_parlist
                       WHERE pack_par_id = i.par_id)
            LOOP
               v_pol.par_no :=
                     z.line_cd
                  || ' - '
                  || z.iss_cd
                  || ' - '
                  || TO_CHAR (z.par_yy, '09')
                  || ' - '
                  || TO_CHAR (z.par_seq_no, '099999')
                  || ' - '
                  || TO_CHAR (z.quote_seq_no, '09');
            END LOOP;
         END IF;


         IF 'MC' = i.line_cd OR 'MC' = i.menu_line_cd THEN
           FOR y IN (
               SELECT coc_type
                 FROM gipi_vehicle
                WHERE policy_id = i.policy_id)
           LOOP           
             v_pol.coc_type := y.coc_type;
             EXIT;
           END LOOP;
         END IF;
         
         --added by robert to consider packages 05.29.2013
         v_pol.endt_tax := NULL;
         IF i.pack_policy_id IS NULL
         THEN
           v_pol.endt_tax := i.endt_tax;
         ELSE
           FOR b IN (SELECT endt_tax
                       FROM gipi_endttext gend, gipi_polbasic gpol
                      WHERE i.pack_policy_id = gpol.pack_policy_id
                        AND gend.policy_id = gpol.policy_id)
           LOOP
              v_pol.endt_tax := NVL (b.endt_tax, 'N');
              EXIT;
           END LOOP;
 
           IF v_pol.endt_tax IS NULL
           THEN
              v_pol.endt_tax := 'N';
           END IF;
         END IF;

         /* Modified by christian 04/03/2013
         ** Added condition to handle non-affecting endorsement without prem_seq_no
         ** Added condition to display policy with multiple prem_seq_no
         */
         /*IF i.pack_policy_id IS NULL
         THEN
           SELECT COUNT(iss_cd || ' - ' || prem_seq_no)
             INTO v_count_prem_seq_no
             FROM gipi_invoice
            WHERE policy_id = i.policy_id;
           
           IF v_count_prem_seq_no <> 0 THEN             
             FOR z IN (SELECT iss_cd, prem_seq_no
                         FROM gipi_invoice
                        WHERE policy_id = i.policy_id)
             LOOP
                v_pol.prem_seq_no := z.prem_seq_no;
                v_pol.dsp_prem_seq_no :=
                   z.iss_cd || ' - '
                   || TO_CHAR (z.prem_seq_no, '099999999999');
                PIPE ROW (v_pol);
             END LOOP;
           
           ELSE
             v_pol.prem_seq_no := '';
             v_pol.dsp_prem_seq_no := '';
             PIPE ROW (v_pol);
           END IF;
           
         ELSE
           SELECT COUNT(iss_cd || ' - ' || prem_seq_no)
             INTO v_count_prem_seq_no
             FROM gipi_invoice
            WHERE policy_id = i.policy_id;
           
           IF v_count_prem_seq_no <> 0 THEN  
             FOR z IN (SELECT iss_cd, prem_seq_no
                         FROM gipi_pack_invoice
                        WHERE policy_id = i.policy_id)
             LOOP
                v_pol.prem_seq_no := z.prem_seq_no;
                v_pol.dsp_prem_seq_no :=
                   z.iss_cd || ' - '
                   || TO_CHAR (z.prem_seq_no, '099999999999');
                PIPE ROW (v_pol);
             END LOOP;
           ELSE
             v_pol.prem_seq_no := '';
             v_pol.dsp_prem_seq_no := '';
             PIPE ROW (v_pol);
           END IF;
         END IF;*/ -- replaced by Nica 07.09.2015 UCPB SR 19755 with codes below
         /*
         v_pol.prem_seq_no := '';
         v_pol.dsp_prem_seq_no := '';
         v_count_prem_seq_no := 0;
         
         IF i.pack_policy_id IS NULL THEN 
             FOR z IN (SELECT iss_cd, prem_seq_no
                         FROM gipi_invoice
                        WHERE policy_id = i.policy_id)
             LOOP
                v_pol.prem_seq_no := z.prem_seq_no;
                v_pol.dsp_prem_seq_no :=
                   z.iss_cd || ' - '
                   || TO_CHAR (z.prem_seq_no, '099999999999');
                v_count_prem_seq_no := v_count_prem_seq_no +1;
                
                PIPE ROW (v_pol);
             END LOOP;
             
             IF v_count_prem_seq_no = 0 THEN
                PIPE ROW (v_pol);
             END IF;            
         ELSE      
             FOR z IN (SELECT iss_cd, prem_seq_no
                         FROM gipi_pack_invoice
                        WHERE policy_id = i.pack_policy_id)
             LOOP
                v_pol.prem_seq_no := z.prem_seq_no;
                v_pol.dsp_prem_seq_no :=
                   z.iss_cd || ' - '
                   || TO_CHAR (z.prem_seq_no, '099999999999');
                v_count_prem_seq_no := v_count_prem_seq_no +1;
                
                PIPE ROW (v_pol);
             END LOOP;
             
             IF v_count_prem_seq_no = 0 THEN
                PIPE ROW (v_pol);
             END IF;    
         END IF;
     
      END LOOP;*/
      /*Comment out by pjsantos 09/14/2016, replaced by code below for optimization*/
        /*Modified by pjsantos 10/14/2016, added ROWNUM to subquery for bill number and premium sequence number GENQA 5756*/
      
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT a.*, NVL (c.endt_tax, ''N'') endt_tax, d.menu_line_cd
                   FROM (SELECT pol.pack_policy_id, pol.line_cd, pol.subline_cd, pol.iss_cd,
                               pol.issue_yy, pol.pol_seq_no, pol.renew_no, pol.endt_iss_cd,
                               pol.endt_yy, pol.endt_seq_no, pol.policy_id, pol.assd_no,
                               pol.endt_type, pol.par_id, pol.no_of_items, pol.pol_flag,
                               pol.co_insurance_sw, pol.fleet_print_tag, ga.assd_name,
                               par.line_cd ||''-''|| par.iss_cd || ''-'' || LTRIM(RTRIM(TO_CHAR (par.par_yy, ''09'')))|| ''-'' || LTRIM(RTRIM(TO_CHAR (par.par_seq_no, ''099999'')))
                               || ''-'' || LTRIM(RTRIM(TO_CHAR (par.quote_seq_no, ''09''))) par_no,
                               pol.line_cd || ''-'' || pol.subline_cd || ''-''  || pol.iss_cd || ''-'' || LTRIM (TO_CHAR (pol.issue_yy, ''09'')) || ''-'' || LTRIM (TO_CHAR (pol.pol_seq_no, ''0999999''))
                               || ''-'' || LTRIM (TO_CHAR (pol.renew_no, ''09'')) policy_no,
                               DECODE (pol.endt_seq_no , 0, NULL,NULL,NULL,
                               pol.line_cd || ''-''|| subline_cd|| ''-''|| endt_iss_cd|| ''-''|| LTRIM (TO_CHAR (endt_yy, ''09''))|| ''-''
                               || LTRIM (TO_CHAR (endt_seq_no, ''099999''))) endt_no
                          FROM gipi_polbasic pol, gipi_parlist par,
                               giis_assured ga
                         WHERE pack_policy_id IS NULL
                           AND par.par_id = pol.par_id 
                           AND par.assd_no = ga.assd_no
                           AND UPPER(ga.assd_name) like NVL(UPPER(''%''||:p_assd_name||''%''), ''%'')
                        UNION ALL
                        SELECT pack.pack_policy_id, pack.line_cd, pack.subline_cd, pack.iss_cd,
                               pack.issue_yy, pack.pol_seq_no, pack.renew_no, pack.endt_iss_cd,
                               pack.endt_yy, pack.endt_seq_no, pack.pack_policy_id policy_id,
                               pack.assd_no, pack.endt_type, pack.pack_par_id par_id,
                               pack.no_of_items, pack.pol_flag, pack.co_insurance_sw,
                               pack.fleet_print_tag, ga.assd_name,
                               par.line_cd ||''-''|| par.iss_cd || ''-'' || LTRIM(RTRIM(TO_CHAR (par.par_yy, ''09'')))|| ''-'' || LTRIM(RTRIM(TO_CHAR (par.par_seq_no, ''099999'')))
                               || ''-'' || LTRIM(RTRIM(TO_CHAR (par.quote_seq_no, ''09''))) par_no,
                               pack.line_cd || ''-'' || pack.subline_cd || ''-''  || pack.iss_cd || ''-'' || LTRIM (TO_CHAR (pack.issue_yy, ''09'')) || ''-'' || LTRIM (TO_CHAR (pack.pol_seq_no, ''0999999''))
                               || ''-'' || LTRIM (TO_CHAR (pack.renew_no, ''09'')) policy_no,
                               DECODE (pack.endt_seq_no , 0, NULL,NULL,NULL,
                               pack.line_cd || ''-''|| subline_cd|| ''-''|| endt_iss_cd|| ''-''|| LTRIM (TO_CHAR (endt_yy, ''09''))|| ''-''
                               || LTRIM (TO_CHAR (endt_seq_no, ''099999''))) endt_no
                          FROM gipi_pack_polbasic pack, gipi_pack_parlist par,
                               giis_assured ga
                         WHERE pack.pack_par_id = par.pack_par_id
                           AND ga.assd_no = par.assd_no
                           AND UPPER(ga.assd_name) like NVL(UPPER(''%''||:p_assd_name||''%''), ''%'')
                       ) a,
                      -- giis_assured b, 
                       gipi_endttext c,
                       giis_line d
                 WHERE 1=1
                   AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''UW'', ''GIPIS091'', :p_user_id))
                                WHERE branch_cd = a.iss_cd)
                   AND  c.policy_id(+) = a.policy_id
                   AND  UPPER(d.line_cd) =   UPPER(a.line_cd)
                   AND  UPPER(a.line_cd) LIKE NVL (:p_line_cd, ''%'')
                   AND  UPPER(a.subline_cd) LIKE NVL (:p_subline_cd, ''%'')
                   AND  UPPER(a.iss_cd) LIKE  NVL (:p_iss_cd, ''%'')
                   AND  a.issue_yy = NVL (:p_issue_yy, a.issue_yy)
                   AND  a.pol_seq_no = NVL (:p_pol_seq_no, a.pol_seq_no)
                   AND  a.renew_no = NVL (:p_renew_no, a.renew_no)
                   AND  UPPER (a.line_cd) LIKE UPPER (NVL (:p_endt_line_cd, ''%''))
                   AND  UPPER (a.subline_cd) LIKE UPPER (NVL (:p_endt_subline_cd, ''%''))
                   AND  UPPER (a.iss_cd) LIKE UPPER (NVL (:p_endt_iss_cd, ''%''))                   
                   AND  a.endt_yy = NVL (:p_endt_yy, a.endt_yy)
                   AND  a.endt_seq_no = NVL (:p_endt_seq_no, a.endt_seq_no)';
               
   IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'policyNo'
         THEN        
          v_sql := v_sql || ' ORDER BY policy_no ';
        ELSIF  p_order_by = 'endtNo'
         THEN
          v_sql := v_sql || ' ORDER BY endt_no ';
        ELSIF  p_order_by = 'parNo'
         THEN
          v_sql := v_sql || ' ORDER BY par_no ';
        ELSIF  p_order_by = 'assdName'
         THEN
          v_sql := v_sql || ' ORDER BY a.assd_name '; 
        /*ELSIF  p_order_by = 'dspPremSeqNo'
         THEN
          v_sql := v_sql || ' ORDER BY dsp_prem_seq_no ';*/ --removed by June Mark SR-23336 [11-08-16]         
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
    END IF;
    
    v_sql := v_sql || ') innersql';
    v_sql := v_sql ||' WHERE UPPER(policy_no) LIKE UPPER(NVL(:p_policy_no, ''%''))
                         AND UPPER(NVL(endt_no, ''%'')) LIKE UPPER(NVL(:p_endt_no, ''%''))
                         AND UPPER(par_no) LIKE UPPER(NVL(:p_par_no, ''%''))';
                         --AND UPPER(NVL(dsp_prem_seq_no, ''%'')) LIKE UPPER(NVL(:p_dsp_prem_seq_no, ''%'')) removed by June Mark SR-23336 [11-08-16]
    v_sql := v_sql || ') outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row;
    
   
 
 
    OPEN c FOR v_sql USING  p_assd_name, p_assd_name, p_user_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, 
    p_endt_line_cd,    p_endt_subline_cd, p_endt_iss_cd, p_endt_yy,p_endt_seq_no, p_policy_no, p_endt_no, p_par_no/*, p_dsp_prem_seq_no*/; --removed by June Mark SR-23336 [11-08-16]   
      LOOP
      FETCH c INTO 
      v_pol.count_, 
      v_pol.rownum_, 
      v_pol.pack_policy_id  ,  
      v_pol.line_cd,       
      v_pol.subline_cd,       
      v_pol.iss_cd,            
      v_pol.issue_yy,          
      v_pol.pol_seq_no,        
      v_pol.renew_no,          
      v_pol.endt_iss_cd,       
      v_pol.endt_yy,           
      v_pol.endt_seq_no,       
      v_pol.policy_id,         
      v_pol.assd_no,           
      v_pol.endt_type,         
      v_pol.par_id,            
      v_pol.no_of_items,       
      v_pol.pol_flag,          
      v_pol.co_insurance_sw,   
      v_pol.fleet_print_tag,   
      v_pol.assd_name,     
      v_pol.par_no,      
      v_pol.policy_no,
      v_pol.endt_no,
      --v_pol.prem_seq_no,       
      --v_pol.dsp_prem_seq_no,   removed by June Mark SR-23336 [11-02-16]
      v_pol.endt_tax, 
      v_pol.menu_line_cd; 
     
      --added by June Mark SR-23336 [11-02-16]
         IF v_pol.pack_policy_id IS NULL THEN 
             FOR z IN (SELECT iss_cd, prem_seq_no
                         FROM gipi_invoice
                        WHERE policy_id = v_pol.policy_id)
             LOOP
                v_pol.prem_seq_no := z.prem_seq_no;
                v_pol.dsp_prem_seq_no :=
                   z.iss_cd || ' - '
                   || TO_CHAR (z.prem_seq_no, '099999999999');
                
             END LOOP;            
         ELSE      
             FOR z IN (SELECT iss_cd, prem_seq_no
                         FROM gipi_pack_invoice
                        WHERE policy_id = v_pol.pack_policy_id)
             LOOP
                v_pol.prem_seq_no := z.prem_seq_no;
                v_pol.dsp_prem_seq_no :=
                   z.iss_cd || ' - '
                   || TO_CHAR (z.prem_seq_no, '099999999999');
                
             END LOOP;
         END IF; --end SR-23336  
         
         IF 'MC' = v_pol.line_cd OR 'MC' = v_pol.menu_line_cd THEN
           FOR y IN (
               SELECT coc_type
                 FROM gipi_vehicle
                WHERE policy_id = v_pol.policy_id)
           LOOP           
             v_pol.coc_type := y.coc_type;
             EXIT;
           END LOOP;
         END IF;
         
         --added by robert to consider packages 05.29.2013
         v_pol.endt_tax := NULL;
         IF v_pol.pack_policy_id IS NULL
         THEN
           v_pol.endt_tax := v_pol.endt_tax;
         ELSE
           FOR b IN (SELECT endt_tax
                       FROM gipi_endttext gend, gipi_polbasic gpol
                      WHERE v_pol.pack_policy_id = gpol.pack_policy_id
                        AND gend.policy_id = gpol.policy_id)
           LOOP
              v_pol.endt_tax := NVL (b.endt_tax, 'N');
              EXIT;
           END LOOP;
  
           IF v_pol.endt_tax IS NULL
           THEN
              v_pol.endt_tax := 'N';
           END IF;
         END IF;  
      EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_pol);
      END LOOP;      
      CLOSE c;            
      RETURN; 
   END get_reprint_policy_listing;

   FUNCTION get_policy_no (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN VARCHAR2
   IS
      v_policy_no   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT    line_cd
                || '-'
                || subline_cd
                || '-'
                || iss_cd
                || '-'
                || LTRIM (TO_CHAR (issue_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                || '-'
                || LTRIM (TO_CHAR (renew_no, '09')) policy_no
           INTO v_policy_no
           FROM gipi_polbasic
          WHERE policy_id = p_policy_id;

         RETURN v_policy_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN NULL;
      END;
   END get_policy_no;

   FUNCTION get_pack_policy_no (
      p_pack_policy_id   gipi_pack_polbasic.pack_policy_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_pack_policy_no   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT    line_cd
                || '-'
                || subline_cd
                || '-'
                || iss_cd
                || '-'
                || LTRIM (TO_CHAR (issue_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                || '-'
                || LTRIM (TO_CHAR (renew_no, '09')) policy_no
           INTO v_pack_policy_no
           FROM gipi_pack_polbasic
          WHERE pack_policy_id = p_pack_policy_id;

         RETURN v_pack_policy_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN NULL;
      END;
   END get_pack_policy_no;

   FUNCTION get_endt_no (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN VARCHAR2
   IS
      v_endt_no   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT    line_cd
                || '-'
                || subline_cd
                || '-'
                || endt_iss_cd
                || '-'
                || LTRIM (TO_CHAR (endt_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (endt_seq_no, '099999')) endt_no
           INTO v_endt_no
           FROM gipi_polbasic
          WHERE policy_id = p_policy_id;

         RETURN v_endt_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN NULL;
      END;
   END get_endt_no;

   FUNCTION get_pack_endt_no (
      p_pack_policy_id   gipi_pack_polbasic.pack_policy_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_pack_endt_no   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT    line_cd
                || '-'
                || subline_cd
                || '-'
                || endt_iss_cd
                || '-'
                || LTRIM (TO_CHAR (endt_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (endt_seq_no, '09999999')) endt_no
           INTO v_pack_endt_no
           FROM gipi_pack_polbasic
          WHERE pack_policy_id = p_pack_policy_id;

         RETURN v_pack_endt_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN NULL;
      END;
   END get_pack_endt_no;
   /*
   **  Created by      : Emsy Bola?os
   **  Date Created    : 01.09.2012
   **  Reference By    : (GIRIS053 - Group Binders)
   **  Description     : function to show Policy Number LOV
   */
   --edited by steven 09.02.2014
   FUNCTION get_gipi_polno_lov (
      p_user_id   giis_users.user_id%TYPE, 
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE
   )
      RETURN gipi_polno_lov_tab PIPELINED
   IS
      v_pol_no   gipi_polno_lov_type;
   BEGIN
      FOR i IN (/*SELECT get_policy_no(a.policy_id) policy_no,
                       a.policy_id,
                       b.assd_name,
                       a.endt_type endt_no,
                       a.line_cd,
                       a.subline_cd,
                       a.iss_cd,
                       a.issue_yy,
                       a.pol_seq_no
                  FROM gipi_polbasic a, giis_assured b
                 WHERE a.assd_no = b.assd_no
                 ORDER BY policy_no*/
                 SELECT a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no, 
                         DECODE (NVL (a.endt_seq_no, 0),0, '',
                                          a.endt_iss_cd
                                       || '-'
                                       || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                       || '-'
                                       || LTRIM (TO_CHAR (a.endt_seq_no, '0999999'))) endt_no,
                       a.policy_id, b.assd_name,
                       a.endt_type, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
                       a.pol_seq_no
                  FROM gipi_polbasic a, giis_assured b
                 WHERE a.assd_no = b.assd_no
                   AND EXISTS (
                          SELECT 1
                            FROM giuw_pol_dist c, giri_distfrps d
                           WHERE c.policy_id = a.policy_id
                             AND c.dist_flag NOT IN (4, 5)
                             AND c.dist_no = d.dist_no)
                   AND (   EXISTS (
                              SELECT c1.access_tag
                                FROM giis_users a1,
                                     giis_user_grp_dtl b1,
                                     giis_user_grp_modules c1
                               WHERE a1.user_grp = b1.user_grp
                                 AND a1.user_grp = c1.user_grp
                                 AND a1.user_id = p_user_id
                                 AND b1.iss_cd = NVL (p_iss_cd, a.iss_cd)
                                 AND b1.tran_cd = c1.tran_cd
                                 AND c1.module_id = 'GIRIS053'
                                 AND c1.access_tag = 1
                                 AND EXISTS (
                                        SELECT 1
                                          FROM giis_user_grp_line
                                         WHERE user_grp = b1.user_grp
                                           AND iss_cd = b1.iss_cd
                                           AND tran_cd = c1.tran_cd
                                           AND line_cd = NVL (p_line_cd, a.line_cd)))
                        OR EXISTS (
                              SELECT c1.access_tag
                                FROM giis_users a1, giis_user_iss_cd b1, giis_user_modules c1
                               WHERE a1.user_id = b1.userid
                                 AND a1.user_id = c1.userid
                                 AND a1.user_id = p_user_id
                                 AND b1.iss_cd = NVL (p_iss_cd, a.iss_cd)
                                 AND b1.tran_cd = c1.tran_cd
                                 AND c1.module_id = 'GIRIS053'
                                 AND c1.access_tag = 1
                                 AND EXISTS (
                                        SELECT 1
                                          FROM giis_user_line
                                         WHERE userid = b1.userid
                                           AND iss_cd = b1.iss_cd
                                           AND tran_cd = c1.tran_cd
                                           AND line_cd = NVL (p_line_cd, a.line_cd)))))
      LOOP
           v_pol_no.policy_no := i.policy_no;
           v_pol_no.assd_name := i.assd_name;
           v_pol_no.endt_no := i.endt_no;
           v_pol_no.endt_type := i.endt_type;
           v_pol_no.policy_id := i.policy_id;
           v_pol_no.line_cd := i.line_cd;
           v_pol_no.subline_cd := i.subline_cd;
           v_pol_no.iss_cd := i.iss_cd;
           v_pol_no.issue_yy := i.issue_yy;
           v_pol_no.pol_seq_no := i.pol_seq_no;
       
          pipe row(v_pol_no);
      END LOOP;
   END;
   
   FUNCTION check_policy_giexs006 (
       p_line_cd       gipi_polbasic.line_cd%TYPE,
       p_subline_cd    gipi_polbasic.subline_cd%TYPE,
       p_iss_cd        gipi_polbasic.iss_cd%TYPE,
       p_issue_yy      gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no       gipi_polbasic.renew_no%TYPE
   )
       RETURN check_policy_giexs006_tab PIPELINED
   IS
       v_result        check_policy_giexs006_type;
   BEGIN
       FOR i IN(SELECT pol_flag, policy_id
                  FROM gipi_polbasic
                 WHERE line_cd     = p_line_cd
                   AND subline_cd  = p_subline_cd
                   AND iss_cd      = p_iss_cd
                   AND issue_yy    = p_issue_yy
                   AND pol_seq_no  = p_pol_seq_no
                   AND renew_no    = p_renew_no
                   AND NVL(endt_seq_no, 0) = 0)
       LOOP
           v_result.policy_id := i.policy_id;
           v_result.pol_flag  := i.pol_flag;
           PIPE ROW(v_result);
       END LOOP;
   END check_policy_giexs006;
   
   
  /*
   **  Created by      : Andrew Robes
   **  Date Created    : 04.23.2012
   **  Reference By    : (GIRIS0100 - View Policy Information)
   **  Description     : Function to retrieve the policy information based on policy_id
   */
   --modified by reymon added to_char to dates reymon 11132013
   FUNCTION get_policy_information (
      p_policy_id            gipi_polbasic.policy_id%TYPE
   )
      RETURN gipi_polinfo_endtseq0_tab PIPELINED
   IS
      v_polbasic   gipi_polinfo_endtseq0_type;
   BEGIN
      FOR i IN (SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd,
                       a.issue_yy, a.pol_seq_no, a.renew_no, a.ref_pol_no,
                       a.endt_seq_no, TO_CHAR(a.expiry_date, 'MM-DD-RRRR') expiry_date, a.assd_no,
                       a.cred_branch, TO_CHAR(a.issue_date, 'MM-DD-RRRR') issue_date, TO_CHAR(a.incept_date, 'MM-DD-RRRR') incept_date,
                       a.pol_flag,
                       DECODE (a.pol_flag,
                               '1', 'New',
                               '2', 'Renewal',
                               '3', 'Replacement',
                               '4', 'Cancelled Endorsement',
                               '5', 'Spoiled',
                               'X', 'Expired'
                              ) mean_pol_flag,
                       b.line_cd nbt_line_cd, b.iss_cd nbt_iss_cd, b.par_yy,
                       b.par_seq_no, b.quote_seq_no, c.line_cd line_cd_rn,
                       c.iss_cd iss_cd_rn, c.rn_yy, c.rn_seq_no, d.assd_name,
                          e.line_cd
                       || ' - '
                       || e.subline_cd
                       || ' - '
                       || e.iss_cd
                       || ' - '
                       || TO_CHAR (e.issue_yy, '09')
                       || ' - '
                       || TO_CHAR (e.pol_seq_no, '099999')
                       || ' - '
                       || TO_CHAR (e.renew_no, '09') pack_pol_no,
                       e.pack_policy_id, f.iss_name
                  FROM gipi_polbasic a,
                       gipi_parlist b,
                       giex_rn_no c,
                       giis_assured d,
                       gipi_pack_polbasic e,
                       giis_issource f
                 WHERE --a.endt_seq_no = 0 remove by steven 04.06.2013 para may ma-fetch na record 
                   --AND 
                   a.par_id = b.par_id(+)
                   AND a.policy_id = c.policy_id(+)
                   AND a.assd_no = d.assd_no(+)
                   AND a.pack_policy_id = e.pack_policy_id(+)
                   AND a.cred_branch = f.iss_cd(+)
                   AND a.policy_id = p_policy_id)
      LOOP
         v_polbasic.policy_id := i.policy_id;
         v_polbasic.line_cd := i.line_cd;
         v_polbasic.subline_cd := i.subline_cd;
         v_polbasic.iss_cd := i.iss_cd;
         v_polbasic.issue_yy := i.issue_yy;
         v_polbasic.pol_seq_no := i.pol_seq_no;
         v_polbasic.renew_no := i.renew_no;
         v_polbasic.ref_pol_no := i.ref_pol_no;
         v_polbasic.endt_seq_no := i.endt_seq_no;
         v_polbasic.expiry_date := i.expiry_date;
         v_polbasic.assd_no := i.assd_no;
         v_polbasic.cred_branch := i.cred_branch;
         v_polbasic.issue_date := i.issue_date;
         v_polbasic.incept_date := i.incept_date;
         v_polbasic.pol_flag := i.pol_flag;
         v_polbasic.mean_pol_flag := i.mean_pol_flag;
         v_polbasic.nbt_line_cd := i.nbt_line_cd;
         v_polbasic.nbt_iss_cd := i.nbt_iss_cd;
         v_polbasic.par_yy := i.par_yy;
         v_polbasic.par_seq_no := i.par_seq_no;
         v_polbasic.quote_seq_no := i.quote_seq_no;
         v_polbasic.line_cd_rn := i.line_cd_rn;
         v_polbasic.iss_cd_rn := i.iss_cd_rn;
         v_polbasic.rn_yy := i.rn_yy;
         v_polbasic.rn_seq_no := i.rn_seq_no;
         v_polbasic.assd_name := i.assd_name;
         --v_polbasic.pack_pol_no := i.pack_pol_no; comment out by CarloR 09.01.2016
         
         IF i.pack_pol_no = ' -  -  -  -  - '  --added by CarloR 09.01.2016 SR-5461 start
         THEN
             v_polbasic.pack_pol_no := '';
         ELSE
            v_polbasic.pack_pol_no := i.pack_pol_no;
         END IF; --end
         
         v_polbasic.pack_policy_id := i.pack_policy_id;
         v_polbasic.iss_name := i.iss_name;
         PIPE ROW (v_polbasic);
      END LOOP;                                            

      RETURN;
   END get_policy_information;
   
   FUNCTION get_policy_bond_seq_no (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE
   ) RETURN NUMBER IS
      v_bond_seq_no gipi_polbasic.bond_seq_no%TYPE;
   BEGIN
      SELECT bond_seq_no
        INTO v_bond_seq_no
        FROM gipi_polbasic
       WHERE line_cd     = p_line_cd
         AND subline_cd  = p_subline_cd
         AND iss_cd      = p_iss_cd
         AND issue_yy    = p_issue_yy
         AND pol_seq_no  = p_pol_seq_no
         AND renew_no    = p_renew_no
         AND endt_seq_no = 0;
      
      RETURN v_bond_seq_no;
   EXCEPTION
      WHEN no_data_found THEN
        RETURN null;
   END get_policy_bond_seq_no;
   
   FUNCTION check_endt_giuts008a (
        p_line_cd        gipi_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_polbasic.subline_cd%TYPE,
        p_iss_cd        gipi_polbasic.iss_cd%TYPE,
        p_issue_yy        gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no        gipi_polbasic.renew_no%TYPE,
        p_endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
        p_endt_yy        gipi_polbasic.endt_yy%TYPE,
        p_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE
   )
        RETURN check_giuts008a_tab PIPELINED
   IS
        v_res    check_giuts008a_type;
   BEGIN
           FOR i IN(SELECT spld_flag
                     FROM gipi_polbasic
                     WHERE line_cd     =  p_line_cd
                    AND subline_cd  =  p_subline_cd
                    AND iss_cd      =  p_iss_cd
                    AND issue_yy    =  p_issue_yy
                    AND pol_seq_no  =  p_pol_seq_no
                    AND renew_no    =  p_renew_no
                    AND endt_iss_cd =  p_endt_iss_cd
                    AND endt_yy     =  p_endt_yy
                    AND endt_seq_no =  p_endt_seq_no)
        LOOP
            v_res.spld := i.spld_flag;
            
            FOR j IN(SELECT spld_flag
                         FROM gipi_polbasic
                        WHERE line_cd     =  p_line_cd
                        AND subline_cd  =  p_subline_cd
                        AND iss_cd      =  p_iss_cd
                        AND issue_yy    =  p_issue_yy
                        AND pol_seq_no  =  p_pol_seq_no
                        AND renew_no    =  p_renew_no
                        AND endt_seq_no = 0)
            LOOP
                v_res.spld1 := j.spld_flag;
            END LOOP;
            
            FOR k IN(SELECT user_id
                       FROM gipi_wpolbas
                      WHERE line_cd     =  p_line_cd
                        AND subline_cd  =  p_subline_cd
                        AND iss_cd      =  p_iss_cd
                        AND issue_yy    =  p_issue_yy
                        AND NVL(pol_seq_no, 999999)  = NVL (p_pol_seq_no, 999999)
                        AND renew_no    =  p_renew_no)
            LOOP
                v_res.user_id := k.user_id;
                v_res.exist := 'Y';
            END LOOP;
        END LOOP;
        
        FOR l IN(SELECT pack_policy_id
                       FROM gipi_pack_polbasic
                      WHERE line_cd     = p_line_cd
                          AND subline_cd  = p_subline_cd
                        AND iss_cd      = p_iss_cd
                        AND issue_yy    = p_issue_yy
                        AND pol_seq_no  = p_pol_seq_no
                        AND renew_no    = p_renew_no
                        AND endt_iss_cd = p_endt_iss_cd
                        AND endt_yy     = p_endt_yy
                        AND endt_seq_no = p_endt_seq_no)
        LOOP
            v_res.pack_policy_id := l.pack_policy_id;
        END LOOP;
        
        PIPE ROW(v_res);                    
   END check_endt_giuts008a;
   
   FUNCTION check_policy_giuts008a(
        p_line_cd        gipi_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_polbasic.subline_cd%TYPE,
        p_iss_cd        gipi_polbasic.iss_cd%TYPE,
        p_issue_yy        gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no        gipi_polbasic.renew_no%TYPE
   )
        RETURN check_giuts008a_tab PIPELINED
   IS
           v_res    check_giuts008a_type;
   BEGIN
           FOR i IN(SELECT spld_flag
                   FROM gipi_polbasic
                  WHERE line_cd     =  p_line_cd
                    AND subline_cd  =  p_subline_cd
                    AND iss_cd      =  p_iss_cd
                    AND issue_yy    =  p_issue_yy
                    AND pol_seq_no  =  p_pol_seq_no
                    AND renew_no    =  p_renew_no)
        LOOP
            v_res.spld := i.spld_flag;
        END LOOP;
        
        FOR j IN(SELECT pack_policy_id
                   FROM gipi_pack_polbasic
                  WHERE line_cd     = p_line_cd
                    AND subline_cd  = p_subline_cd
                    AND iss_cd      = p_iss_cd
                    AND issue_yy    = p_issue_yy
                    AND pol_seq_no  = p_pol_seq_no
                    AND renew_no    = p_renew_no
                    AND endt_seq_no = 0)
        LOOP
            v_res.pack_policy_id := j.pack_policy_id;    
        END LOOP;
        
        PIPE ROW(v_res);
        
    END check_policy_giuts008a;
    
    -- bonok :: 01.07.2013
    FUNCTION get_ref_pol_no2(
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
    )
      RETURN VARCHAR2
    IS
      v_ref_pol_no   gipi_polbasic.ref_pol_no%TYPE;
    BEGIN
      FOR ref_pol_no IN (SELECT ref_pol_no
                           FROM gipi_polbasic
                          WHERE line_cd = p_line_cd
                            AND subline_cd = p_subline_cd
                            AND iss_cd = p_iss_cd
                            AND issue_yy = p_issue_yy
                            AND pol_seq_no = p_pol_seq_no
                            AND renew_no = p_renew_no)
      LOOP
         v_ref_pol_no := ref_pol_no.ref_pol_no;
         EXIT;
      END LOOP;

      RETURN v_ref_pol_no;
    END get_ref_pol_no2;
    
    /*
   **  Created by      : Kris Felipe
   **  Date Created    : 08.22.2013
   **  Reference By    : (GIUTS027- Update Policy Coverage)
   **  Description     : Function to retrieve the policy information based on parameters given
   */
    FUNCTION get_giuts027_policy_list(
        p_line_cd       gipi_polbasic.line_cd%TYPE,
        p_subline_cd    gipi_polbasic.subline_cd%TYPE,
        p_iss_cd        gipi_polbasic.iss_cd%TYPE,
        p_issue_yy      gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no      gipi_polbasic.renew_no%TYPE,
        p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
        p_endt_yy       gipi_polbasic.endt_yy%TYPE,
        p_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
        p_assd_name     giis_assured.assd_name%TYPE,
        p_user_id       gipi_polbasic.user_id%TYPE,
        p_module_id     giis_modules.module_id%TYPE
    ) RETURN gipi_polbasic_tab4 PIPELINED
    IS
        v_policy        gipi_polbasic_type4;
        v_policy_tab    gipi_polbasic_tab4;
        v_query         VARCHAR2(32767) := '';
        
        TYPE cur_typ IS REF CURSOR;
        c          cur_typ;
    BEGIN

        v_query := 'SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no, assd_no, par_id, policy_id                           
                      FROM gipi_polbasic
                     WHERE endt_seq_no  = NVL('''|| p_endt_seq_no|| ''', endt_seq_no)
                       AND endt_yy      = NVL('''|| p_endt_yy|| ''' , endt_yy)
                       AND line_cd      = DECODE(check_user_per_line2(line_cd,iss_cd,'''|| p_module_id || ''', '''|| p_user_id || '''),1,line_cd,null)
                       AND iss_cd       = DECODE(check_user_per_iss_cd2(line_cd,iss_cd,'''|| p_module_id || ''', '''|| p_user_id || ''' ),1,iss_cd,NULL)
                       AND line_cd      = NVL('''|| p_line_cd || ''', line_cd)
                       AND subline_cd   = NVL('''|| p_subline_cd || ''', subline_cd)
                       AND iss_cd       = NVL('''|| p_iss_cd || ''', iss_cd)
                       AND issue_yy     = NVL('''|| p_issue_yy || ''', issue_yy)
                       AND pol_seq_no   = NVL('''|| p_pol_seq_no || ''', pol_seq_no)
                       AND renew_no     = NVL('''|| p_renew_no || ''', renew_no)
                       AND par_id IN (SELECT par_id 
                                        FROM gipi_parlist
                                       WHERE assd_no IN (SELECT assd_no FROM giis_assured WHERE (UPPER(assd_name) LIKE UPPER(NVL('''|| p_assd_name|| ''', assd_name)) )))' ;
                                                                
                                                                
        IF p_endt_iss_cd IS NOT NULL THEN
            v_query := v_query || ' AND endt_seq_no > 0 AND iss_cd = ''' || p_endt_iss_cd || '''';
        END IF;
        
        IF p_endt_yy IS NOT NULL THEN
            v_query := v_query || ' AND endt_seq_no > 0 AND issue_yy = ''' || p_endt_yy || '''';            
        END IF;
        
        IF p_assd_name IS NOT NULL THEN
            v_query := v_query || ' AND endt_seq_no >= 0';
        END IF;
        
        v_query := v_query || ' ORDER BY 1, 2, 3, 4, 5, 6';
                
        OPEN c FOR v_query;

        LOOP
            FETCH c
             INTO v_policy.line_cd,
                  v_policy.subline_cd,
                  v_policy.iss_cd,
                  v_policy.issue_yy,
                  v_policy.pol_seq_no,
                  v_policy.renew_no,
                  v_policy.endt_iss_cd,
                  v_policy.endt_yy,
                  v_policy.endt_seq_no,
                  v_policy.assd_no,
                  v_policy.par_id,
                  v_policy.policy_id;
                  
             SELECT assd_name
               INTO v_policy.assd_name
               FROM giis_assured
              WHERE assd_no = v_policy.assd_no;
              
             SELECT v_policy.line_cd || '-' || v_policy.subline_cd || '-' || v_policy.iss_cd || '-' || LTRIM(TO_CHAR(v_policy.issue_yy, '09')) || '-' || LTRIM(TO_CHAR(v_policy.pol_seq_no, '0000009')) || '-' || LTRIM(TO_CHAR(v_policy.renew_no, '09'))
               INTO v_policy.policy_no
               FROM dual;
               
             SELECT v_policy.endt_iss_cd || '-' || LTRIM(TO_CHAR(v_policy.endt_yy, '09')) || '-' || LTRIM(TO_CHAR(v_policy.endt_seq_no, '000009'))
               INTO v_policy.endt_no
               FROM dual;
              
             IF v_policy.endt_seq_no = 0 THEN
                v_policy.endt_iss_cd    := NULL;
                v_policy.endt_yy        := NULL;
                v_policy.endt_seq_no    := NULL;
                v_policy.endt_no        := NULL;
             END IF;

            EXIT WHEN c%NOTFOUND;
            PIPE ROW (v_policy);
        END LOOP;

        CLOSE c;

        RETURN;
        
    EXCEPTION
        WHEN OTHERS THEN NULL;        
    END get_giuts027_policy_list;
    
    FUNCTION get_gipis156_pol_no_lov (
       p_line_cd        VARCHAR2,
       p_subline_cd     VARCHAR2,
       p_iss_cd         VARCHAR2,
       p_issue_yy       VARCHAR2,
       p_pol_seq_no     VARCHAR2,
       p_renew_no       VARCHAR2,
       p_user_id        VARCHAR2,
       p_module_id      VARCHAR2
    )
       RETURN gipis156_pol_no_tab PIPELINED
    IS
       v_list gipis156_pol_no_type;
       v_assd_no    giis_assured.assd_no%TYPE;
    BEGIN
       FOR i IN (SELECT policy_id, line_cd, subline_cd,
                        iss_cd, issue_yy, pol_seq_no, renew_no,
                        endt_iss_cd, endt_yy, endt_seq_no,
                        cred_branch, incept_date, issue_date, endt_type,
                        bancassurance_sw
                   FROM gipi_polbasic
                  WHERE line_cd = NVL(p_line_cd, line_cd)
                    AND subline_cd = NVL(p_subline_cd, subline_cd)
                    AND iss_cd = NVL(p_iss_cd, iss_cd)
                    AND issue_yy = NVL(p_issue_yy, issue_yy)
                    AND pol_seq_no = NVL(p_pol_seq_no, pol_seq_no)
                    AND renew_no = NVL(p_renew_no, renew_no)
                    AND check_user_per_iss_cd2(line_cd, iss_cd, p_module_id, p_user_id) =1
                    AND pol_flag IN ('1','2','3','4','X'))
       LOOP
          v_list.policy_id := i.policy_id;
          v_list.line_cd := i.line_cd;
          v_list.subline_cd := i.subline_cd;
          v_list.iss_cd := i.iss_cd;
          v_list.issue_yy := i.issue_yy;
          v_list.pol_seq_no := i.pol_seq_no;
          v_list.renew_no := i.renew_no;
          v_list.endt_iss_cd := i.endt_iss_cd;
          v_list.endt_yy := i.endt_yy;
          v_list.endt_seq_no := i.endt_seq_no;
          v_list.cred_branch := i.cred_branch;
          v_list.incept_date := i.incept_date;
          v_list.issue_date := i.issue_date;
          v_list.endt_type := i.endt_type;
          v_list.bancassurance_sw := i.bancassurance_sw;
          
          v_list.policy_endt_no := get_policy_no(i.policy_id);
          
          IF v_list.ora2010_sw IS NULL THEN
             v_list.ora2010_sw := giisp.v ('ORA2010_SW');
          END IF;
          
          BEGIN
             SELECT param_value_v
                INTO v_list.allow_booking_in_adv_tag
                FROM giis_parameters
               WHERE param_name = 'ALLOW_BOOKING_IN_ADVANCE';
          END;
          
          BEGIN
             SELECT endt_iss_cd, endt_yy, endt_seq_no
               INTO v_list.dsp_endt_iss_cd, v_list.dsp_endt_yy, v_list.dsp_endt_seq_no
               FROM gipi_polbasic
              WHERE policy_id = i.policy_id
                AND endt_seq_no != 0;
          EXCEPTION WHEN NO_DATA_FOUND THEN
             v_list.dsp_endt_iss_cd := NULL;
             v_list.dsp_endt_yy := NULL;
             v_list.dsp_endt_seq_no := NULL;
          END;
          
          BEGIN
             SELECT assd_no
               INTO v_assd_no
               FROM gipi_parlist
              WHERE par_id IN (SELECT par_id
                                 FROM gipi_polbasic
                                WHERE policy_id = i.policy_id);
          EXCEPTION WHEN NO_DATA_FOUND THEN
             v_assd_no := NULL;                            
          END;
          
          IF v_assd_no IS NOT NULL THEN
             BEGIN
             
                FOR pol IN (SELECT policy_id,endt_seq_no,assd_no
                              FROM gipi_polbasic
                             WHERE line_cd      = i.line_cd
                               AND subline_cd   = i.subline_cd
                               AND iss_cd       = i.iss_cd
                               AND issue_yy     = i.issue_yy
                               AND pol_seq_no   = i.pol_seq_no
                               AND endt_seq_no != 0
                               AND expiry_date >= SYSDATE
                               AND line_cd     != 'BB'
                               AND pol_flag    != '5'
                          ORDER BY incept_date)
                LOOP
                   IF pol.endt_seq_no <= v_list.endt_seq_no THEN
                      v_assd_no := NVL(pol.assd_no,v_assd_no);         
                   END IF;
                END LOOP;
             END;
             
             BEGIN
                SELECT assd_name
                  INTO v_list.assd_name
                  FROM giis_assured
                 WHERE assd_no = v_assd_no; 
             END;
          END IF;
          
          FOR i IN (SELECT assd_no
                      FROM giis_assured
                     WHERE assd_name = v_list.assd_name)
          LOOP
             v_list.assd_name2 := get_assd_name(i.assd_no);
             EXIT;
          END LOOP;
          
          PIPE ROW(v_list);
       END LOOP;
    END get_gipis156_pol_no_lov;
    
    FUNCTION get_gipis156_basic_info(
       p_line_cd        VARCHAR2,
       p_subline_cd     VARCHAR2,
       p_iss_cd         VARCHAR2,
       p_issue_yy       VARCHAR2,
       p_pol_seq_no     VARCHAR2,
       p_renew_no       VARCHAR2,
       p_endt_yy        VARCHAR2,    
       p_endt_seq_no    VARCHAR2,
       p_cred_branch    VARCHAR2
    )
       RETURN gipis156_basic_info_tab PIPELINED
    IS
       v_list gipis156_basic_info_type;
       v_num NUMBER:= 0;
    BEGIN
       FOR i IN (SELECT reg_policy_sw, eff_date, issue_date, expiry_date, --benjo 10.07.2015 GENQA-SR-4890 added expiry_date
                        booking_year, booking_mth, acct_ent_date,
                        area_cd, branch_cd, manager_cd, bancassurance_sw,
                        policy_id, bank_ref_no, pack_policy_id, takeup_term
                   FROM gipi_polbasic
                  WHERE line_cd = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND iss_cd = p_iss_cd
                    AND issue_yy = p_issue_yy
                    AND pol_seq_no = p_pol_seq_no
                    AND renew_no = p_renew_no
                    AND endt_yy = p_endt_yy
                    AND endt_seq_no = p_endt_seq_no)
       LOOP
          v_list.reg_policy_sw := i.reg_policy_sw;
          v_list.eff_date := i.eff_date;
          v_list.issue_date := i.issue_date;
          v_list.expiry_date := i.expiry_date; --benjo 10.07.2015 GENQA-SR-4890
          v_list.booking_year := i.booking_year;
          v_list.booking_mth := i.booking_mth;
          v_list.acct_ent_date := i.acct_ent_date;
          v_list.booking_mth_yr := i.booking_year || ' - ' || i.booking_mth;
          v_list.area_cd := i.area_cd;
          v_list.branch_cd := i.branch_cd;
          v_list.manager_cd := i.manager_cd;
          v_list.bank_ref_no := i.bank_ref_no;
          v_list.takeup_term := i.takeup_term;          
          
          IF i.bancassurance_sw = 'Y' THEN
             BEGIN
                FOR dsps IN (SELECT gb.manager_cd manager_cd, gs.area_desc area_desc, gb.branch_desc branch_desc
                               FROM giis_banc_area gs, gipi_polbasic gp, giis_banc_branch gb
                              WHERE gs.area_cd = gp.area_cd
                                AND gb.branch_cd = gp.branch_cd                     
                                AND gp.policy_id = i.policy_id)
                LOOP
                   v_list.dsp_area_desc := dsps.area_desc;
                   v_list.dsp_branch_desc := dsps.branch_desc; 
                END LOOP;
             END;
             
             BEGIN
                FOR mgr IN (SELECT nvl(a.payee_last_name,'') || ',' || NVL(a.payee_first_name,'') || ',' || NVL(a.payee_middle_name,'')manager_name
                              FROM giis_payees a, giis_banc_branch b
                             WHERE b.branch_cd = v_list.branch_cd
                               AND a.payee_no = b.manager_cd
                               AND a.payee_class_cd = giisp.v ('BANK_MANAGER_PAYEE_CLASS') )
                LOOP
                   v_list.dsp_manager_name := mgr.manager_name;
                END LOOP;
             END;             
          END IF;
          
          
          BEGIN
             FOR cred IN (SELECT iss_name, iss_cd
                            FROM giis_issource
                           WHERE iss_cd = NVL(p_cred_branch, p_iss_cd))
             LOOP
                IF p_cred_branch IS NOT NULL THEN
                   v_list.cred_branch := cred.iss_name;
                 v_list.cred_branch_cd := cred.iss_cd;
                ELSE 
                   v_list.cred_branch := NULL;
                 v_list.cred_branch_cd := NULL;
                END IF;        
             END LOOP;
          END;
          
          FOR x IN (SELECT pack_policy_id
                      FROM gipi_polbasic
                     WHERE policy_id = i.policy_id)
          LOOP
            IF x.pack_policy_id IS NULL THEN
            
               BEGIN
                  SELECT 99
                    INTO v_num
                    FROM gipi_polbasic a, gipi_invoice b, giac_direct_prem_collns c
                   WHERE a.policy_id = b.policy_id
                     AND a.policy_id = i.policy_id
                     AND c.b140_iss_cd = b.iss_cd
                     AND c.b140_prem_seq_no = b.prem_seq_no;

                 --will do the ff: if invoice is already paid
                  v_list.nbt_acct_iss_cd := SUBSTR (i.bank_ref_no, 1, 2);
                  v_list.nbt_branch_cd := SUBSTR (i.bank_ref_no, 4, 4);
                  v_list.dsp_ref_no := SUBSTR (i.bank_ref_no, 9, 7);
                  v_list.dsp_mod_no := SUBSTR (i.bank_ref_no, -2, 2);
                  v_list.bank_ref_no_enabled := 'N';
               EXCEPTION
                  WHEN TOO_MANY_ROWS THEN
                     --will do the ff: if invoice is already paid
                     v_list.nbt_acct_iss_cd := SUBSTR (i.bank_ref_no, 1, 2);
                     v_list.nbt_branch_cd := SUBSTR (i.bank_ref_no, 4, 4);
                     v_list.dsp_ref_no := SUBSTR (i.bank_ref_no, 9, 7);
                     v_list.dsp_mod_no := SUBSTR (i.bank_ref_no, -2, 2);
                     v_list.bank_ref_no_enabled := 'N';
                  
                  WHEN NO_DATA_FOUND THEN
                     --when no_data_found,it means that invoice is not yet paid.
                     v_list.nbt_acct_iss_cd := SUBSTR (i.bank_ref_no, 1, 2);
                     v_list.nbt_branch_cd := SUBSTR (i.bank_ref_no, 4, 4);
                     v_list.dsp_ref_no := SUBSTR (i.bank_ref_no, 9, 7);
                     v_list.dsp_mod_no := SUBSTR (i.bank_ref_no, -2, 2);
                     v_list.bank_ref_no_enabled := 'Y';   
                         
               END;
            
            ELSE
            
               BEGIN
                  SELECT 99
                    INTO v_num
                    FROM gipi_polbasic a, gipi_invoice b, giac_direct_prem_collns c
                   WHERE a.policy_id = b.policy_id
                     AND a.pack_policy_id = i.pack_policy_id
                     AND c.b140_iss_cd = b.iss_cd
                     AND c.b140_prem_seq_no = b.prem_seq_no;
                     
                  v_list.nbt_acct_iss_cd := SUBSTR (i.bank_ref_no, 1, 2);
                  v_list.nbt_branch_cd := SUBSTR (i.bank_ref_no, 4, 4);
                  v_list.dsp_ref_no := SUBSTR (i.bank_ref_no, 9, 7);
                  v_list.dsp_mod_no := SUBSTR (i.bank_ref_no, -2, 2);
                  v_list.bank_ref_no_enabled := 'N';
--                  message('Payment for the sub-policy detected. Bank reference number disabled.');
               EXCEPTION
                  WHEN TOO_MANY_ROWS THEN
                     v_list.nbt_acct_iss_cd := SUBSTR (i.bank_ref_no, 1, 2);
                     v_list.nbt_branch_cd := SUBSTR (i.bank_ref_no, 4, 4);
                     v_list.dsp_ref_no := SUBSTR (i.bank_ref_no, 9, 7);
                     v_list.dsp_mod_no := SUBSTR (i.bank_ref_no, -2, 2);
                     v_list.bank_ref_no_enabled := 'N';
--                     message('Payment for the sub-policy detected. Bank reference number disabled.');
                  WHEN NO_DATA_FOUND THEN
                     v_list.nbt_acct_iss_cd := SUBSTR (i.bank_ref_no, 1, 2);
                     v_list.nbt_branch_cd := SUBSTR (i.bank_ref_no, 4, 4);
                     v_list.dsp_ref_no := SUBSTR (i.bank_ref_no, 9, 7);
                     v_list.dsp_mod_no := SUBSTR (i.bank_ref_no, -2, 2);
                     v_list.bank_ref_no_enabled := 'Y';
                     
               END;   
                  
            END IF;
          END LOOP;           
       
          PIPE ROW(v_list);
       END LOOP;
    END get_gipis156_basic_info;   
    
    FUNCTION get_exposure_list(
        p_search_by         VARCHAR2,
        p_search_date       VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        -- added by MarkS 12.1.2016 SR5863
        p_order_by          VARCHAR2,
        p_asc_desc_flag     VARCHAR2,
        p_from              NUMBER,
        p_to                NUMBER,
        p_filt_pol_no       VARCHAR2,
        p_filt_endt_no      VARCHAR2,
        p_filt_item         NUMBER,
        p_filt_tsiamtorg    NUMBER,
        p_filt_premantorg   NUMBER
        --SR5863
    ) RETURN gipis209_exposure_tab PIPELINED
    IS
        v_dtl        gipis209_exposure_type;
        v_dtl_tab    gipis209_exposure_tab;
        v_query         VARCHAR2(32767) := '';
        
        TYPE cur_typ IS REF CURSOR;
        c          cur_typ;
    BEGIN
        -- added by MarkS 12.1.2016 SR5863 optmization
        v_query := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (';
        v_query := v_query ||      'SELECT assd_no,
                                            TO_CHAR(incept_date, ''mm-dd-yyyy'') incept_date, 
                                            TO_CHAR(eff_date,    ''mm-dd-yyyy'') eff_date, 
                                            TO_CHAR(issue_date,  ''mm-dd-yyyy'') issue_date, 
                                            TO_CHAR(expiry_date, ''mm-dd-yyyy'') expiry_date, 
                                            policy_id, item, 
                                            tsi_amt, tsi_amt_orig, prem_amt, prem_amt_orig, 
                                            currency_rt_chk, 
                                            line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                                            endt_iss_cd, endt_yy, endt_seq_no,
                                            line_cd || '' - '' || subline_cd || '' - '' || iss_cd || '' - '' || LPAD(issue_yy, 2, 0) || '' - '' || LPAD(pol_seq_no, 7, 0)|| '' - '' || LPAD (renew_no, 2, 0) policy_no,
                                            endt_iss_cd || '' - '' || LPAD(endt_yy, 2, 0) || '' - '' || LPAD(endt_seq_no, 7, 0) endt_no
                                      FROM ( SELECT a.assd_no, a.incept_date, a.eff_date, a.issue_date, a.expiry_date,
                                                    a.policy_id, 
                                                    ''Item - '' || b.item_title item, 
                                                    (NVL(b.tsi_amt, 0) * b.currency_rt) tsi_amt, 
                                                    NVL(b.tsi_amt, 0) tsi_amt_orig, 
                                                    (NVL(b.prem_amt, 0) * b.currency_rt) prem_amt, 
                                                    NVL(b.prem_amt, 0) prem_amt_orig,
                                                    DECODE(b.currency_rt, 1, ''N'', ''Y'') currency_rt_chk, 
                                                    a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no
                                               FROM gipi_polbasic a, gipi_item b, gipi_accident_item c
                                              WHERE a.policy_id = c.policy_id 
                                                AND a.policy_id = b.policy_id 
                                                AND b.item_no = c.item_no
                                             UNION
                                             SELECT a.assd_no, a.incept_date, a.eff_date, a.issue_date, a.expiry_date,
                                                    a.policy_id, 
                                                    ''Grouped Item - '' || b.grouped_item_title item,
                                                    NVL(b.tsi_amt, 0) tsi_amt, 
                                                    NVL(b.tsi_amt, 0) tsi_amt_orig, 
                                                    NVL(b.prem_amt, 0) prem_amt, 
                                                    NVL(b.prem_amt, 0) prem_amt_orig,
                                                    ''N'' currency_rt_chk, 
                                                    a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no
                                               FROM gipi_polbasic a, gipi_grouped_items b, gipi_accident_item c
                                              WHERE a.policy_id = c.policy_id 
                                                AND a.policy_id = b.policy_id 
                                                AND b.item_no = c.item_no )';
        
        IF p_search_by = 'inceptDate' THEN
        
            IF p_search_date = 'asOf' THEN
                v_query := v_query || ' WHERE incept_date < TO_DATE('''|| p_as_of_date || ''', ''mm-dd-yyyy'')';
            ELSE
                v_query := v_query || ' WHERE incept_date BETWEEN TO_DATE(''' || p_from_date || ''', ''mm-dd-yyyy'')  AND  TO_DATE(''' || p_to_date || ''', ''mm-dd-yyyy'')';
            END IF;
            
        ELSIF p_search_by = 'effectivityDate' THEN
        
            IF p_search_date = 'asOf' THEN
                v_query := v_query || ' WHERE eff_date < TO_DATE(''' || p_as_of_date || ''', ''mm-dd-yyyy'')'; 
            ELSE
                v_query := v_query || ' WHERE eff_date BETWEEN TO_DATE(''' || p_from_date || ''', ''mm-dd-yyyy'')  AND  TO_DATE(''' || p_to_date || ''', ''mm-dd-yyyy'')'; 
            END IF;
        
        ELSIF p_search_by = 'issueDate' THEN
        
            IF p_search_date = 'asOf' THEN
                v_query := v_query || ' WHERE issue_date < TO_DATE(''' || p_as_of_date || ''', ''mm-dd-yyyy'')'; 
            ELSE
                v_query := v_query || ' WHERE issue_date BETWEEN TO_DATE(''' || p_from_date || ''', ''mm-dd-yyyy'')  AND  TO_DATE(''' || p_to_date || ''', ''mm-dd-yyyy'')'; 
            END IF;
        
        ELSIF p_search_by = 'expiryDate' THEN
        
            IF p_search_date = 'asOf' THEN
                v_query := v_query || ' WHERE expiry_date < TO_DATE(''' || p_as_of_date || ''', ''mm-dd-yyyy'')'; 
            ELSE
                v_query := v_query || ' WHERE expiry_date BETWEEN TO_DATE(''' || p_from_date || ''', ''mm-dd-yyyy'')  AND  TO_DATE(''' || p_to_date || ''', ''mm-dd-yyyy'')'; 
            END IF;
            
        ELSE
            v_query := v_query || ' WHERE rownum = 0';
        
        END IF;
        -- added by MarkS 12.1.2016 SR5863
        IF p_filt_pol_no IS NOT NULL THEN
            v_query := v_query || 'UPPER(line_cd || ''-'' || subline_cd || ''-'' || iss_cd || ''-'' || LPAD(issue_yy, 2, 0) || ''-'' || LPAD(pol_seq_no, 7, 0) || ''-'' || LPAD (renew_no, 2, 0))
                                           LIKE 
                                       REPLACE(UPPER('''|| p_filt_pol_no ||'''), '' '', '''')    ';
        END IF; 
        
        IF p_filt_endt_no IS NOT NULL THEN
            v_query := v_query || 'UPPER(endt_iss_cd || ''-'' || LPAD(endt_yy, 2, 0) || ''-'' || LPAD(endt_seq_no, 7, 0))
                                           LIKE
                                       REPLACE(UPPER('''|| p_filt_endt_no ||'''), '' '', '''')  ';
        END IF; 
        
        IF p_filt_item IS NOT NULL THEN
            v_query := v_query || 'UPPER(item) LIKE UPPER('|| p_filt_item ||')';
        END IF; 
        
        IF p_filt_tsiamtorg IS NOT NULL THEN
            v_query := v_query || 'tsi_amt_orig = '|| p_filt_tsiamtorg ||'';
        END IF; 
        
        IF p_filt_premantorg IS NOT NULL THEN
            v_query := v_query || 'prem_amt_orig = '|| p_filt_premantorg ||'';
        END IF;
        
        IF p_order_by IS NOT NULL
        THEN
            IF p_order_by = 'currencyRtChk'
            THEN        
              v_query := v_query || ' ORDER BY currency_rt_chk ';
            ELSIF p_order_by = 'lineCd sublineCd issCd issueYy polSeqNo renewNo'
            THEN
              v_query := v_query || ' ORDER BY policy_no ';
            ELSIF p_order_by = 'endtIssCd endtYy endtSeqNo'
            THEN
              v_query := v_query || ' ORDER BY endt_iss_cd, endt_yy, endt_seq_no ';
            ELSIF p_order_by = 'item'
            THEN
              v_query := v_query || ' ORDER BY item ';           
            ELSIF p_order_by = 'tsiAmtOrig'
            THEN
              v_query := v_query || ' ORDER BY tsi_amt_orig ';
            ELSIF p_order_by = 'premAmtOrig'
            THEN
              v_query := v_query || ' ORDER BY prem_amt_orig ';                               
            END IF;        
            
            IF p_asc_desc_flag IS NOT NULL
            THEN
               v_query := v_query || p_asc_desc_flag;
            ELSE
               v_query := v_query || ' ASC';
            END IF; 
        END IF;
        v_query := v_query || ') innersql';
        v_query := v_query || '
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
        -- added by MarkS 12.1.2016 SR5863                    
        OPEN c FOR v_query;        

        LOOP
            FETCH c
             INTO 
                  -- added by MarkS 12.1.2016 SR5863
                  v_dtl.count_,
                  v_dtl.rownum_,    
                  v_dtl.assd_no, 
                  v_dtl.incept_date,
                  v_dtl.eff_date,
                  v_dtl.issue_date,
                  v_dtl.expiry_date,
                  v_dtl.policy_id,
                  v_dtl.item,
                  v_dtl.tsi_amt,
                  v_dtl.tsi_amt_orig,
                  v_dtl.prem_amt,
                  v_dtl.prem_amt_orig,
                  v_dtl.currency_rt_chk,
                  v_dtl.line_cd, v_dtl.subline_cd, v_dtl.iss_cd, v_dtl.issue_yy, v_dtl.pol_seq_no, v_dtl.renew_no,
                  v_dtl.endt_iss_cd , v_dtl.endt_yy, v_dtl.endt_seq_no,
                  v_dtl.policy_no,
                  v_dtl.endt_no;            
            
            SELECT assd_name
              INTO v_dtl.assd_name
              FROM giis_assured
             WHERE assd_no = v_dtl.assd_no;
              
            SELECT v_dtl.line_cd || '-' || v_dtl.subline_cd || '-' || v_dtl.iss_cd || '-' || LTRIM(TO_CHAR(v_dtl.issue_yy, '09')) || '-' || LTRIM(TO_CHAR(v_dtl.pol_seq_no, '0000009')) || '-' || LTRIM(TO_CHAR(v_dtl.renew_no, '09'))
              INTO v_dtl.policy_no
              FROM dual;
               
            SELECT v_dtl.endt_iss_cd || '-' || LTRIM(TO_CHAR(v_dtl.endt_yy, '09')) || '-' || LTRIM(TO_CHAR(v_dtl.endt_seq_no, '000009'))
              INTO v_dtl.endt_no
              FROM dual;

            EXIT WHEN c%NOTFOUND;
            PIPE ROW (v_dtl);
        END LOOP;

        CLOSE c;

        RETURN;        
    END get_exposure_list;
    
    
    FUNCTION get_polbasic_list_gipis155(
        p_line_cd           gipi_polbasic.LINE_CD%type,
        p_subline_cd        gipi_polbasic.SUBLINE_CD%type,
        p_iss_cd            gipi_polbasic.ISS_CD%type,
        p_issue_yy          gipi_polbasic.ISSUE_YY%type,
        p_pol_seq_no        gipi_polbasic.POL_SEQ_NO%type,
        p_renew_no          gipi_polbasic.RENEW_NO%type,
        p_dsp_endt_iss_cd   VARCHAR2,
        p_dsp_endt_yy       VARCHAR2,
        p_dsp_endt_seq_no   VARCHAR2,
        p_assd_name         VARCHAR2,
        p_module_id         VARCHAR2,
        p_user_id           VARCHAR2
    ) RETURN gipi_polbasic_gipis155_tab PIPELINED
    AS
        TYPE cur_type IS REF CURSOR;
        
        rec         gipi_polbasic_gipis155_type;
        custom      cur_type;
        v_query     VARCHAR2(32767);
        v_where     varchar2(32767);
    BEGIN
        /** prog unit: SECURITY  **/
        --FOR line in (                                               --commented out by. June Mark SR-23228 [10.17.16]
                      /* SELECT d.line_cd, B.iss_cd
                        FROM GIIS_USERS         a
                            , GIIS_USER_ISS_CD  b
                            , GIIS_MODULES_TRAN c
                            , GIIS_USER_LINE    d
                       WHERE 1=1
                         AND a.user_id  = b.userid
                         AND a.user_id   = USER
                         AND b.tran_cd   = c.tran_cd
                         AND c.module_id = p_module_id
                           AND d.userid    = b.userid
                           AND d.iss_cd    = b.iss_cd
                           AND d.tran_cd   = b.tran_cd
                      UNION
                      SELECT d.line_cd, b.iss_cd
                        FROM GIIS_USERS          a
                            , GIIS_USER_GRP_DTL  b
                            , GIIS_MODULES_TRAN  c
                                , GIIS_USER_GRP_LINE d
                       WHERE 1=1
                         AND a.user_id   = USER
                         AND a.user_grp  = b.user_grp
                         AND b.tran_cd   = c.tran_cd
                         AND c.module_id = p_module_id
                         AND d.user_grp = b.user_grp
                         AND d.iss_cd   = b.iss_cd
                         AND d.tran_cd  = b.tran_cd -- jhing 04.11.2013 commented out and replaced with: */ 
                  /*SELECT a.line_cd , b.iss_cd                                                                             --commented out by. June Mark SR-23228 [10.17.16]
                    FROM giis_line A, giis_issource B
                   WHERE 1 = 1 
                     AND check_user_per_iss_cd2 ( a.line_cd, b.iss_cd, p_module_id, p_user_id) =1 jhing 04.11.2013 )
        LOOP
            IF v_where IS NULL THEN
                 v_where := 'AND ((line_cd = '''||line.line_cd||''' AND iss_cd = '''||line.iss_cd||''')';
            ELSE
                 v_where := v_where||' OR (line_cd = '''||line.line_cd||''' AND iss_cd = '''||line.iss_cd||''')';
            END IF;
        END LOOP;
        
        IF v_where IS NULL THEN
            v_where := 'AND line_cd = NULL AND iss_cd = NULL';
        ELSE
            v_where := v_where||' )';
        END IF;*/                                                                                                           --END comment SR-23228
        
        /** end SECURITY **/
        
        v_query := 'SELECT policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                           endt_iss_cd, endt_yy, endt_seq_no, assd_no, par_id
                      FROM GIPI_POLBASIC a
                     WHERE UPPER(line_cd) = NVL(''' || UPPER(p_line_cd) || ''', line_cd)
                       AND UPPER(subline_cd) = NVL(''' || UPPER(p_subline_cd) || ''', subline_cd) 
                       AND UPPER(iss_cd) = NVL(''' || UPPER(p_iss_cd) || ''', iss_cd) 
                       AND issue_yy = NVL(''' || p_issue_yy || ''', issue_yy) 
                       AND pol_seq_no = NVL(''' || p_pol_seq_no || ''', pol_seq_no) 
                       AND renew_no = NVL(''' || p_renew_no || ''', renew_no)
                       AND endt_seq_no = nvl( ''' || p_dsp_endt_seq_no || ''',endt_seq_no)
                       AND endt_yy  = nvl(''' || p_dsp_endt_yy || ''',endt_yy)                       
                       AND line_cd = ''FI'' 
                       AND EXISTS (SELECT policy_id
                                     FROM gipi_fireitem b
                                    WHERE b.policy_id = a.policy_id) ' /* || v_where */; -- moved concatenation to opening cursor to prevent exceeding max length : shan 08.13.2014  
        
        v_query := v_query || 'AND (iss_cd, line_cd) IN                                                     
                                   (SELECT branch_cd, line_cd
                                    FROM TABLE (security_access.get_branch_line (''UW'',
                                                                                 '''||p_module_id||''',
                                                                                 '''||p_user_id||''')))'; --added by. June Mark SR-23228 [10.17.16]
                                                                            
        IF p_assd_name IS NOT NULL THEN
              /*v_query := v_query*/ v_where := v_where ||' AND par_id IN (SELECT par_id 
                                                   FROM gipi_parlist
                                                  WHERE assd_no IN (SELECT assd_no 
                                                                      FROM giis_assured 
                                                                     WHERE (assd_name LIKE LTRIM(RTRIM(''' || p_assd_name || ''')))))';
        END IF; 
               
        IF P_DSP_ENDT_ISS_CD IS NOT NULL THEN
            /*v_query := v_query*/ v_where := v_where ||' AND ENDT_SEQ_NO > 0 AND ISS_CD = ''' || P_DSP_ENDT_ISS_CD || '''';
        END IF; 
         
        IF P_DSP_ENDT_YY IS NOT NULL THEN
            /*v_query := v_query*/ v_where := v_where ||' AND ENDT_SEQ_NO > 0 AND ISSUE_YY = ''' || P_DSP_ENDT_YY || '''';
        END IF;  
   

        --v_query := v_query || ' ORDER BY 1, 2, 3, 4, 5, 6';
        
        OPEN custom FOR v_query || v_where;
        
        LOOP
            FETCH custom
             INTO rec.policy_id, rec.line_cd, rec.subline_cd, rec.iss_cd, rec.issue_yy, rec.pol_seq_no, rec.renew_no,
                  rec.endt_iss_cd, rec.endt_yy, rec.endt_seq_no, rec.assd_no, rec.par_id;
             
            for c in (select  assd_name 
                        from  giis_assured
                       where  assd_no = rec.assd_no ) loop

               rec.assd_name := c.assd_name;
                exit;
            end loop;

            IF rec.assd_name is null then
               for d in ( select  assd_name 
                            from  giis_assured A020, gipi_parlist B240
                           where  A020.assd_no = rec.assd_no 
                             and  B240.par_id = rec.par_id) 
                loop

                   rec.assd_name := d.assd_name; 
                    exit;
                end loop;  
            END IF;
             
            FOR endt IN (SELECT endt_iss_cd, endt_yy, endt_seq_no
                           FROM gipi_polbasic
                          WHERE policy_id = rec.policy_id)
            LOOP
                rec.dsp_endt_iss_cd := endt.endt_iss_cd;
                rec.dsp_endt_yy     := endt.endt_yy;
                rec.dsp_endt_seq_no := endt.endt_seq_no;
            END LOOP;         
  
            /*IF rec.endt_seq_no <> 0 then 
                rec.dsp_line_cd    := :b240.line_cd;
                rec.dsp_subline_cd := :b240.subline_cd;
            ELSE*/
            IF rec.endt_seq_no = 0 THEN 
                rec.dsp_endt_iss_cd := NULL;
                rec.dsp_endt_yy     := NULL;
                rec.dsp_endt_seq_no := NULL;
            END IF;
             
            EXIT WHEN custom%NOTFOUND;
            
            PIPE ROW(rec);
        END LOOP;
    END get_polbasic_list_gipis155;

   FUNCTION get_gipis100_endt_code_list
   RETURN gipis100_endt_code_tab PIPELINED AS
      v_list               gipis100_endt_code_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.endt_cd, a.endt_title
                  FROM giis_endttext a, gipi_endttext b 
                 WHERE a.endt_cd = b.endt_cd
                 ORDER BY LTRIM(a.endt_title))
      LOOP
         v_list.endt_cd := i.endt_cd;
         v_list.endt_title := LTRIM(i.endt_title);
      
         PIPE ROW(v_list);
      END LOOP;
   END;      
   
   FUNCTION get_gipis100_endt_type_list(
      p_endt_cd            gipi_endttext.endt_cd%TYPE
   ) RETURN gipis100_endt_list_type_tab PIPELINED AS
      v_list               gipis100_endt_list_type_type;
   BEGIN
      FOR i IN (SELECT a.policy_id, a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                       a.endt_iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.endt_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.endt_seq_no, '0999999')) endt_no,
                       a.tsi_amt, a.prem_amt
                  FROM gipi_polbasic a, gipi_endttext b 
                 WHERE a.policy_id = b.policy_id
                   AND b.endt_cd = p_endt_cd
                 ORDER BY a.line_cd)
      LOOP
         v_list.policy_id := i.policy_id;
         v_list.policy_no := i.policy_no;
         v_list.endt_no := i.endt_no;
         v_list.tsi_amt := i.tsi_amt;
         v_list.prem_amt := i.prem_amt;
         
         PIPE ROW(v_list);
      END LOOP;
   END;

   --added by hdrtagudin 07302015 SR 18751   
FUNCTION get_initial_acceptance (p_policy_id gipi_polbasic.policy_id%TYPE)
   RETURN initial_acceptance_type_tab PIPELINED
AS
   v_rec   initial_acceptance_type;
BEGIN
   FOR i IN (SELECT policy_no,
                       a.line_cd
                    || ' - '
                    || RTRIM (a.iss_cd)
                    || ' - '
                    || TO_CHAR (a.par_yy, '09')
                    || ' - '
                    || TO_CHAR (a.par_seq_no, '0999999')
                    || ' - '
                    || TO_CHAR (a.quote_seq_no, '09') par_no,
                    endt_no, b.writer_cd, c.assd_name, b.accept_no, b.accept_by,
                    d.ri_name, b.ri_policy_no, b.ri_endt_no, b.orig_tsi_amt,
                    b.ref_accept_no, b.accept_date, b.ri_binder_no,
                    b.offer_date, b.orig_prem_amt, b.remarks
               FROM gipi_parlist a,
                    (SELECT    line_cd
                            || ' - '
                            || LTRIM (subline_cd)
                            || ' - '
                            || iss_cd
                            || ' - '
                            || TO_CHAR (issue_yy, '09')
                            || ' - '
                            || TO_CHAR (pol_seq_no, '0000009')
                            || ' - '
                            || TO_CHAR (renew_no, '09') policy_no,
                            DECODE (endt_seq_no,
                                    0, '',
                                       endt_iss_cd
                                    || '-'
                                    || TO_CHAR (endt_yy, '09')
                                    || ' - '
                                    || TO_CHAR (endt_seq_no, '0000009')
                                   ) endt_no,
                            b.policy_id, b.par_id, accept_date, accept_no, b.assd_no,
                            accept_by, writer_cd, ri_cd, ref_accept_no, ri_policy_no,
                            ri_binder_no, ri_endt_no, offer_date, orig_tsi_amt,
                            orig_prem_amt, a.remarks
                       FROM giri_inpolbas a, gipi_polbasic b
                      WHERE a.policy_id = b.policy_id) b,
                    giis_assured c,
                    giis_reinsurer d
              WHERE a.par_id = b.par_id
                AND b.assd_no = c.assd_no
                AND b.ri_cd = d.ri_cd(+)
                AND b.policy_id = p_policy_id)
   LOOP
      v_rec.policy_no := i.policy_no;
      v_rec.par_no := i.par_no;
      v_rec.endt_no := i.endt_no;
      v_rec.assd_name := i.assd_name;
      v_rec.accept_no := i.accept_no;
      v_rec.accept_by := i.accept_by;
      v_rec.ri_name := i.ri_name;
      v_rec.ri_policy_no := i.ri_policy_no;
      v_rec.ri_endt_no := i.ri_endt_no;
      v_rec.orig_tsi_amt := i.orig_tsi_amt;
      v_rec.ref_accept_no := i.ref_accept_no;
      v_rec.accept_date := i.accept_date;
      v_rec.ri_binder_no := i.ri_binder_no;
      v_rec.offer_date := i.offer_date;
      v_rec.orig_prem_amt := i.orig_prem_amt;
      v_rec.remarks := i.remarks;
 
      IF NVL(i.writer_cd,0) <> 0 THEN
          SELECT ri_name
          INTO v_rec.reassured
            FROM giis_reinsurer d
          WHERE ri_cd = i.writer_cd;
      END IF;
      

      PIPE ROW (v_rec);
   END LOOP;
 END;    
 
 FUNCTION get_par_id(p_policy_id gipi_polbasic.policy_id%TYPE)
   RETURN gipi_polbasic.par_id%TYPE
 AS
    v_par_id gipi_polbasic.par_id%TYPE;
 BEGIN
    SELECT par_id
      INTO v_par_id
      FROM gipi_polbasic
     WHERE policy_id = p_policy_id;
    RETURN v_par_id;
 END get_par_id;
 
END gipi_polbasic_pkg;
/

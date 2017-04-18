CREATE OR REPLACE PACKAGE BODY CPI.gipir072_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 09.05.2013
     **  Reference By : GIPIR072
     **  Description  : Summarized Monthly Statistical Report Per Cargo Class
     */
   FUNCTION cf_title (p_starting_date DATE, p_ending_date DATE)
      RETURN CHAR
   IS
      v_title   VARCHAR2 (2000);
      v_days    NUMBER
                      := ABS (TRUNC (p_ending_date) - TRUNC (p_starting_date));
   BEGIN
      IF v_days <= 6
      THEN
         v_title := 'SUMMARIZED DAILY STATISTICAL REPORT PER CARGO CLASS';
      ELSIF ((6 < v_days) AND (v_days <= 29))
      THEN
         v_title := 'SUMMARIZED WEEKLY STATISTICAL REPORT PER CARGO CLASS';
      ELSE
         v_title := 'SUMMARIZED MONTHLY STATISTICAL REPORT PER CARGO CLASS';
      END IF;

      RETURN v_title;
   END;

   FUNCTION cf_tax_amt (p_policy_id NUMBER, p_policy_no VARCHAR2)
      RETURN NUMBER
   IS
      v_tax   NUMBER (16, 2);
   BEGIN
      SELECT SUM (tax_amt)
        INTO v_tax
        FROM gipi_invoice
       WHERE policy_id = p_policy_id
         AND iss_cd =
                SUBSTR (p_policy_no,
                        (INSTR (p_policy_no, '-', 1, 2) + 1),
                          (INSTR (p_policy_no, '-', 1, 3)
                          )
                        - (INSTR (p_policy_no, '-', 1, 2) + 1)
                       );

      RETURN (v_tax);
   END;

   FUNCTION get_gipir072_record (
      p_extract_id      NUMBER,
      p_subline_cd      VARCHAR2,
      p_cargo_cd        VARCHAR2,
      p_starting_date   DATE,
      p_ending_date     DATE,
      p_user_id         VARCHAR2
   )
      RETURN gipir072_record_tab PIPELINED
   IS
      v_rec   gipir072_record_type;
      mjm     BOOLEAN              := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');
      v_rec.title := cf_title (p_starting_date, p_ending_date);
      v_rec.period :=
         (   TO_CHAR (p_starting_date, 'MM-DD-YYYY')
          || ' TO '
          || TO_CHAR (p_ending_date, 'MM-DD-YYYY')
         );

      FOR i IN (SELECT policy_no, a.policy_id, share_cd,
                       a.subline_cd || ' - ' || subline_name subline_name,
                       cargo_class_cd, cargo_class_desc,
                       a.assd_no || ' - ' || assd_name assd, assd_name,
                       trty_name, dist_tsi, dist_prem
                  FROM gixx_mrn_cargo_stat a, gipi_polbasic b
                 WHERE extract_id = TO_NUMBER (p_extract_id)
                   AND a.policy_id = b.policy_id
                   AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                   AND cargo_class_cd = NVL (p_cargo_cd, cargo_class_cd)
                   AND a.user_id = p_user_id
                   AND check_user_per_iss_cd2 (NULL,
                                               b.iss_cd,
                                               'GIPIS901',
                                               p_user_id
                                              ) = 1
                 ORDER BY a.subline_cd || ' - ' || subline_name, cargo_class_cd, assd_name,
                          policy_no, trty_name)
      LOOP
         mjm := FALSE;
         v_rec.policy_no := i.policy_no;
         v_rec.policy_id := i.policy_id;
         v_rec.share_cd := i.share_cd;
         v_rec.subline_name := i.subline_name;
         v_rec.cargo_class_cd := i.cargo_class_cd;
         v_rec.cargo_class_desc := i.cargo_class_desc;
         v_rec.assd := i.assd;
         v_rec.assd_name := i.assd_name;
         v_rec.trty_name := i.trty_name;
         v_rec.dist_tsi := i.dist_tsi;
         v_rec.dist_prem := i.dist_prem;
         v_rec.tax_amt := cf_tax_amt (i.policy_id, i.policy_no);
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_gipir072_record;
END;
/



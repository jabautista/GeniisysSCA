DROP PROCEDURE CPI.UPDATE_EXPIRY;

CREATE OR REPLACE PROCEDURE CPI.update_expiry (
   p_expiry_date    IN OUT   gicl_claims.expiry_date%TYPE,
   p_incept_date    IN OUT   gicl_claims.expiry_date%TYPE,
   p_loss_date               gicl_claims.loss_date%TYPE,
   p_pol_eff_date            gicl_claims.pol_eff_date%TYPE,
                                                  --variables.tmp_pol_eff_date
   p_line_cd                 gicl_claims.line_cd%TYPE,
   p_subline_cd              gicl_claims.subline_cd%TYPE,
   p_pol_iss_cd              gicl_claims.iss_cd%TYPE,
   p_issue_yy                gicl_claims.issue_yy%TYPE,
   p_pol_seq_no              gicl_claims.pol_seq_no%TYPE,
   p_renew_no                gicl_claims.renew_no%TYPE,
   p_claim_id                gicl_claims.claim_id%TYPE
)
IS
   /*
   **  Created by      : Christian Santos
   **  Date Created    : 10.25.2012
   **  Reference By    : (GICLS039 - Batch Claim Closing)
   */
   v_expiry_date   gicl_claims.expiry_date%TYPE;
   v_incept_date   gicl_claims.expiry_date%TYPE;
BEGIN
   -- check and retrieve for any change of expiry in case there is
   -- endorsement of expiry date
   FOR rec IN (SELECT   TRUNC(expiry_date) expiry_date, endt_seq_no
                   FROM gipi_polbasic a
                  WHERE a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_pol_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no
                    AND a.pol_flag IN ('1', '2', '3', 'X')
                    AND TRUNC(a.eff_date) <= NVL (p_loss_date, SYSDATE)
                    AND expiry_date IS NOT NULL
                    AND expiry_date = NVL (endt_expiry_date, expiry_date)
               ORDER BY a.eff_date DESC, a.endt_seq_no DESC)
   LOOP
      v_expiry_date := rec.expiry_date;
      p_expiry_date := rec.expiry_date;

      --check for change in expiry using backward endt.
      FOR b IN (SELECT   TRUNC(expiry_date) expiry_date
                    FROM gipi_polbasic a
                   WHERE a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.iss_cd = p_pol_iss_cd
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                     AND a.pol_flag IN ('1', '2', '3', 'X')
                     AND TRUNC(a.eff_date) <= NVL (p_loss_date, SYSDATE)
                     AND NVL (a.endt_seq_no, 0) > 0
                     AND TRUNC(expiry_date) <> v_expiry_date
                     AND expiry_date = endt_expiry_date
                     AND NVL (a.back_stat, 5) = 2
                     AND NVL (a.endt_seq_no, 0) > rec.endt_seq_no
                ORDER BY a.endt_seq_no DESC)
      LOOP
         v_expiry_date := b.expiry_date;
         p_expiry_date := b.expiry_date;
         EXIT;
      END LOOP;

      EXIT;
   END LOOP;

   -- then check and retrieve for any change of incept in case there is
   -- endorsement of incept date
   FOR rec IN (SELECT   TRUNC(incept_date) incept_date, endt_seq_no
                   FROM gipi_polbasic a
                  WHERE a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_pol_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no
                    AND a.pol_flag IN ('1', '2', '3', 'X')
                    AND TRUNC(a.eff_date) <= NVL (p_loss_date, SYSDATE)
                    AND incept_date IS NOT NULL
                    AND expiry_date = NVL (endt_expiry_date, expiry_date)
               ORDER BY a.eff_date DESC, a.endt_seq_no DESC)
   LOOP
      v_incept_date := rec.incept_date;
      p_incept_date := rec.incept_date;
      --check for change in expiry using backward endt.
      FOR b IN (SELECT   TRUNC(incept_date) incept_date
                    FROM gipi_polbasic a
                   WHERE a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.iss_cd = p_pol_iss_cd
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                     AND a.pol_flag IN ('1', '2', '3', 'X')
                     AND TRUNC(a.eff_date) <= NVL (p_loss_date, SYSDATE)
                     AND NVL (a.endt_seq_no, 0) > 0
                     AND TRUNC(incept_date) <> v_incept_date
                     AND expiry_date = endt_expiry_date
                     AND NVL (a.back_stat, 5) = 2
                     AND NVL (a.endt_seq_no, 0) > rec.endt_seq_no
                ORDER BY a.endt_seq_no DESC)
      LOOP
         v_incept_date := b.incept_date;
         p_incept_date := b.incept_date;
         EXIT;
      END LOOP;

      EXIT;
   END LOOP;

   UPDATE gicl_claims
      SET expiry_date = NVL (v_expiry_date, p_expiry_date),
          pol_eff_date = NVL (v_incept_date, p_pol_eff_date)
    WHERE claim_id = p_claim_id;
END;
/



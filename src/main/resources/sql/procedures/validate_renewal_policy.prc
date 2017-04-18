DROP PROCEDURE CPI.VALIDATE_RENEWAL_POLICY;

CREATE OR REPLACE PROCEDURE CPI.validate_renewal_policy (
   p_line_cd      IN       giex_expiry.line_cd%TYPE,
   p_subline_cd   IN       giex_expiry.subline_cd%TYPE,
   p_iss_cd       IN       giex_expiry.iss_cd%TYPE,
   p_issue_yy     IN       giex_expiry.issue_yy%TYPE,
   p_pol_seq_no   IN       giex_expiry.pol_seq_no%TYPE,
   p_renew_no     IN       giex_expiry.renew_no%TYPE,
   p_alert        OUT      VARCHAR2
)
IS
BEGIN
   FOR c IN
      (SELECT NVL (post_flag, 'N') post_flag,
              policy_id -- select to check if policy was processed for expiry
         FROM giex_expiry
        WHERE line_cd = p_line_cd
          AND subline_cd = p_subline_cd
          AND iss_cd = p_iss_cd
          AND issue_yy = p_issue_yy
          AND pol_seq_no = p_pol_seq_no
          AND renew_no = p_renew_no)
   LOOP
      IF c.post_flag = 'Y'
      THEN                       
         --if procesed and has par, check par status
         --roset, 2/3/2011
         FOR n IN (SELECT b.par_status
                     FROM gipi_wpolnrep a, gipi_parlist b
                    WHERE 1 = 1
                      AND a.par_id = b.par_id
                      AND a.old_policy_id = c.policy_id)
         LOOP
            IF n.par_status NOT IN (99, 98)
            THEN
               p_alert := 'N';
            ELSE
               p_alert := 'Y';     --reinstate if par is cancelled or deleted
            END IF;

            EXIT;
         END LOOP;                                                     --roset
         --check if policy renewal was already posted
         FOR x IN (SELECT b.pol_flag
                     FROM gipi_polnrep a, gipi_polbasic b
                    WHERE 1 = 1
                      AND a.new_policy_id = b.policy_id
                      AND a.old_policy_id = c.policy_id)
         LOOP
            IF x.pol_flag NOT IN ('4', '5', 'X')
            THEN
               p_alert := 'N';
            ELSE
               p_alert := 'Y';
            END IF;

            EXIT;
         END LOOP;
      ELSE                                            -- continue to reinstate
         p_alert := 'Y';
      END IF;

      EXIT;

      IF p_alert = 'Y'
      THEN
         DELETE FROM giex_old_group_tax
               WHERE policy_id = c.policy_id;

         DELETE FROM giex_old_group_peril
               WHERE policy_id = c.policy_id;

         DELETE FROM giex_new_group_tax
               WHERE policy_id = c.policy_id;

         DELETE FROM giex_new_group_peril
               WHERE policy_id = c.policy_id;

         DELETE FROM giex_itmperil
               WHERE policy_id = c.policy_id;

         DELETE FROM giex_expiry
               WHERE policy_id = c.policy_id;
      END IF;
   END LOOP;

   DBMS_OUTPUT.put_line (p_alert);
END;
/



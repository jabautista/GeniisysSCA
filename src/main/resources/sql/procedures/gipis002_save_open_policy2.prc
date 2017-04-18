DROP PROCEDURE CPI.GIPIS002_SAVE_OPEN_POLICY2;

CREATE OR REPLACE PROCEDURE CPI.gipis002_save_open_policy2 (
   p_par_id          IN   gipi_wopen_policy.par_id%TYPE,
   p_line_cd         IN   gipi_wopen_policy.line_cd%TYPE,
   p_op_subline_cd   IN   gipi_wopen_policy.op_subline_cd%TYPE,
   p_op_iss_cd       IN   gipi_wopen_policy.op_iss_cd%TYPE,
   p_op_issue_yy     IN   gipi_wopen_policy.op_issue_yy%TYPE,
   p_op_pol_seqno    IN   gipi_wopen_policy.op_pol_seqno%TYPE,
   p_op_renew_no     IN   gipi_wopen_policy.op_renew_no%TYPE,
   p_decltn_no       IN   gipi_wopen_policy.decltn_no%TYPE
)
IS
   prev_assd     VARCHAR2 (55);
   curr_assd     VARCHAR2 (55);
   v_exist       VARCHAR2 (1)                   := 'N';
   v_policy_id   gipi_polbasic.policy_id%TYPE;
   v_par_id      gipi_parhist.par_id%TYPE;
   v_count       NUMBER;
   v_count2      NUMBER;
   m_policy_id   gipi_polbasic.policy_id%TYPE;
BEGIN
   DECLARE
      v_issue_yy      gipi_polbasic.issue_yy%TYPE;
      v_eff_date      gipi_polbasic.eff_date%TYPE;
      v_expiry_date   gipi_polbasic.expiry_date%TYPE;
      v_incept_date   gipi_polbasic.incept_date%TYPE;
   BEGIN
      FOR a1 IN (SELECT   incept_date, expiry_date, assd_no, eff_date,
                          policy_id
                     FROM gipi_polbasic
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_op_subline_cd
                      AND iss_cd = p_op_iss_cd
                      AND issue_yy = p_op_issue_yy
                      AND pol_seq_no = p_op_pol_seqno
                      AND renew_no = p_op_renew_no
                 ORDER BY eff_date DESC)
      LOOP
         v_expiry_date := a1.expiry_date;
         v_incept_date := a1.incept_date;
         v_eff_date := a1.eff_date;
		 m_policy_id := a1.policy_id;
         FOR z1 IN (SELECT   endt_seq_no, expiry_date, incept_date,
                             policy_id
                        FROM gipi_polbasic b2501
                       WHERE b2501.line_cd = p_line_cd
                         AND b2501.subline_cd = p_op_subline_cd
                         AND b2501.iss_cd = p_op_iss_cd
                         AND b2501.issue_yy = p_op_issue_yy
                         AND b2501.pol_seq_no = p_op_pol_seqno
                         AND b2501.renew_no = p_op_renew_no
                         AND b2501.pol_flag IN ('1', '2', '3')
                         AND NVL (b2501.back_stat, 5) = 2
                         AND b2501.pack_policy_id IS NULL
                         AND (   b2501.endt_seq_no = 0
                              OR (    b2501.endt_seq_no > 0
                                  AND TRUNC (b2501.endt_expiry_date) >=
                                                     TRUNC (b2501.expiry_date)
                                 )
                             )
                    ORDER BY endt_seq_no DESC)
         LOOP
            -- get the last endorsement sequence of the policy
            FOR z1a IN (SELECT   endt_seq_no, eff_date, expiry_date,
                                 incept_date, policy_id
                            FROM gipi_polbasic b2501
                           WHERE b2501.line_cd = p_line_cd
                             AND b2501.subline_cd = p_op_subline_cd
                             AND b2501.iss_cd = p_op_iss_cd
                             AND b2501.issue_yy = p_op_issue_yy
                             AND b2501.pol_seq_no = p_op_pol_seqno
                             AND b2501.renew_no = p_op_renew_no
                             AND b2501.pol_flag IN ('1', '2', '3')
                             AND b2501.pack_policy_id IS NULL
                             AND (   b2501.endt_seq_no = 0
                                  OR (    b2501.endt_seq_no > 0
                                      AND TRUNC (b2501.endt_expiry_date) >=
                                                     TRUNC (b2501.expiry_date)
                                     )
                                 )
                        ORDER BY endt_seq_no DESC)
            LOOP
               IF z1.endt_seq_no = z1a.endt_seq_no
               THEN
                  v_expiry_date := z1.expiry_date;
                  v_incept_date := z1.incept_date;
				  m_policy_id := z1.policy_id;
               ELSE
                  IF z1a.eff_date > v_eff_date
                  THEN
                     v_eff_date := z1a.eff_date;
                     v_expiry_date := z1a.expiry_date;
                     v_incept_date := z1a.incept_date;
                  ELSE
                     v_expiry_date := z1.expiry_date;
                     v_incept_date := z1.incept_date;
                  END IF;
               END IF;

               EXIT;
            END LOOP;

            EXIT;
         END LOOP;

         v_issue_yy := 1;

         --:b530.eff_date := v_eff_date;
         UPDATE gipi_wopen_policy
            SET eff_date = v_eff_date
          WHERE par_id = p_par_id;

         EXIT;
      END LOOP;
   END;

   UPDATE gipi_wopen_policy
      SET decltn_no = p_decltn_no
    WHERE par_id = p_par_id;

   --populate_tables;
   
   gipis002_populate_tables (
	   p_par_id,
	   p_line_cd,
	   p_op_subline_cd,
	   p_op_iss_cd,
	   p_op_issue_yy,
	   p_op_pol_seqno,
	   p_op_renew_no,
	   m_policy_id
   );
   
   --update_witem;
   GIPIS002_UPDATE_WITEM(p_par_id);

END gipis002_save_open_policy2;
/



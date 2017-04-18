DROP PROCEDURE CPI.VALIDATE_POLICY_DATES;

CREATE OR REPLACE PROCEDURE CPI.validate_policy_dates (
   p_line_cd         IN       gipi_wopen_policy.line_cd%TYPE,
   p_op_subline_cd   IN       gipi_wopen_policy.op_subline_cd%TYPE,
   p_op_iss_cd       IN       gipi_wopen_policy.op_iss_cd%TYPE,
   p_op_issue_yy     IN       gipi_wopen_policy.op_issue_yy%TYPE,
   p_op_pol_seqno    IN       gipi_wopen_policy.op_pol_seqno%TYPE,
   p_op_renew_no     IN       gipi_wopen_policy.op_renew_no%TYPE,
   p_eff_date        IN       gipi_wpolbas.eff_date%TYPE,
   p_expiry_date     IN       gipi_wpolbas.expiry_date%TYPE,
   m_eff_date        OUT      gipi_wpolbas.eff_date%TYPE,
   v_message1        OUT      VARCHAR2,
   v_message2        OUT      VARCHAR2,
   v_message_code	 OUT 	  VARCHAR2
)
IS
   v_issue_yy      gipi_polbasic.issue_yy%TYPE;
   v_eff_date      gipi_polbasic.eff_date%TYPE;
   v_expiry_date   gipi_polbasic.expiry_date%TYPE;
   v_incept_date   gipi_polbasic.incept_date%TYPE;
   p_message       VARCHAR2 (400)                   := '';
   

BEGIN
   v_message1 := '';
   v_message2 := '';
   v_message_code := '0';
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
      --variables.policy_id := a1.policy_id;

      FOR z1 IN (SELECT   endt_seq_no, expiry_date, incept_date, policy_id
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
               --variables.policy_id := z1.policy_id;
            ELSE
               IF z1a.eff_date > v_eff_date
               THEN
                  v_eff_date := z1a.eff_date;
                  v_expiry_date := z1a.expiry_date;
                  v_incept_date := z1a.incept_date;
                  --variables.policy_id := z1a.policy_id;
               ELSE
                  v_expiry_date := z1.expiry_date;
                  v_incept_date := z1.incept_date;
               END IF;
            END IF;

            EXIT;
         END LOOP;

         EXIT;
      END LOOP;

-----------------
      v_issue_yy := 1;
      m_eff_date := v_eff_date;

      IF m_eff_date/*p_eff_date --replace by nok 10.27.2011*/ NOT BETWEEN v_incept_date AND v_expiry_date
      THEN
         v_message1 :=
               'Effectivity date '
            || TO_CHAR (p_eff_date)
            || ' must be within '
            || TO_CHAR (v_incept_date)
            || ' and '
            || TO_CHAR (v_expiry_date)
            || '.';
		v_message_code := '1';
      ELSIF p_expiry_date NOT BETWEEN v_incept_date AND v_expiry_date
      THEN                                                    --issa07.09.2007
         v_message1 :=
               'Expiry date '
            || TO_CHAR (p_expiry_date)
            || ' must be within '
            || TO_CHAR (v_incept_date)
            || ' and '
            || TO_CHAR (v_expiry_date)
            || '.';
		 v_message_code := '2';
         RETURN;
      END IF;

      EXIT;
   END LOOP;

   IF v_issue_yy IS NULL
   THEN
      v_message2 := 'No such policy exists in the master table.';
	  v_message_code := '3';
      RETURN;
   END IF;
END validate_policy_dates;
/



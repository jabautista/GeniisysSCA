DROP PROCEDURE CPI.GIPIS002_SAVE_OPEN_POLICY1;

CREATE OR REPLACE PROCEDURE CPI.gipis002_save_open_policy1 (
   p_par_id          IN   gipi_wopen_policy.par_id%TYPE,
   p_line_cd         IN   gipi_wopen_policy.line_cd%TYPE,
   p_op_subline_cd   IN   gipi_wopen_policy.op_subline_cd%TYPE,
   p_op_iss_cd       IN   gipi_wopen_policy.op_iss_cd%TYPE,
   p_op_issue_yy     IN   gipi_wopen_policy.op_issue_yy%TYPE,
   p_op_pol_seqno    IN   gipi_wopen_policy.op_pol_seqno%TYPE,
   p_op_renew_no     IN   gipi_wopen_policy.op_renew_no%TYPE,
   p_decltn_no		 IN   gipi_wopen_policy.decltn_no%TYPE
)
IS
/* BRYAN 09/21/2010
** for pre-insert and pre-update of GIPI_WOPEN_POLICY in Basic Info page
 */
   prev_assd     VARCHAR2 (100);
   curr_assd     VARCHAR2 (100);
   v_exist       VARCHAR2 (1)                   := 'N';
   v_policy_id   gipi_polbasic.policy_id%TYPE;
   v_par_id      gipi_parlist.par_id%TYPE;
   v_count       NUMBER;
   v_count2      NUMBER;
BEGIN
   FOR a IN (SELECT policy_id
               FROM gipi_polbasic
              WHERE p_line_cd = line_cd
                AND p_op_subline_cd = subline_cd
                AND p_op_iss_cd = iss_cd
                AND p_op_issue_yy = issue_yy
                AND p_op_pol_seqno = pol_seq_no
                AND p_op_renew_no = renew_no)
   LOOP
      v_policy_id := a.policy_id;
   END LOOP;

   FOR b IN (SELECT par_id
               FROM gipi_parhist
              WHERE par_id = p_par_id)
   LOOP
      v_par_id := b.par_id;
   END LOOP;

   FOR c IN (SELECT policy_id, line_cd, wc_cd, swc_seq_no, print_seq_no,
                    wc_title, print_sw, change_tag
               FROM gipi_polwc
              WHERE policy_id = v_policy_id)
   LOOP
      SELECT COUNT (*)
        INTO v_count
        FROM gipi_polwc
       WHERE policy_id = v_policy_id;

      --issa07.06.2007 to check if WC is already inserted in gipi_polwc
      SELECT COUNT (*)
        INTO v_count2
        FROM gipi_wpolwc
       WHERE par_id = v_par_id
         AND line_cd = c.line_cd
         AND wc_cd = c.wc_cd
         AND swc_seq_no = c.swc_seq_no;

      --i end--
      IF v_count <> 0 AND v_count2 = 0
      THEN
         INSERT INTO gipi_wpolwc
                     (par_id, line_cd, wc_cd, swc_seq_no,
                      print_seq_no, wc_title, print_sw, change_tag
                     )
              VALUES (v_par_id, c.line_cd, c.wc_cd, c.swc_seq_no,
                      c.print_seq_no, c.wc_title, c.print_sw, c.change_tag
                     );
      END IF;
   END LOOP;

   --IF p_record_status = 'CHANGED'
   --THEN
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

-----------------
/* added by gmi
** to get the correct expiry date and inception date if policy has backward endt
*/
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
   --END IF;

   UPDATE gipi_wopen_policy
      SET decltn_no = p_decltn_no
    WHERE par_id = p_par_id;


   --IF p_record_status <> 'QUERY'
   --THEN
      --populate_tables;
      --update_witem;
   --END IF;
END gipis002_save_open_policy1;
/



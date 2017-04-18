DROP PROCEDURE CPI.GIPIS002_SAVE_OPEN_POLICY;

CREATE OR REPLACE PROCEDURE CPI.gipis002_save_open_policy(
   p_par_id		     IN		  gipi_wopen_policy.par_id%TYPE,
   p_line_cd         IN       gipi_wopen_policy.line_cd%TYPE,
   p_op_subline_cd   IN       gipi_wopen_policy.op_subline_cd%TYPE,
   p_op_iss_cd       IN       gipi_wopen_policy.op_iss_cd%TYPE,
   p_op_issue_yy     IN       gipi_wopen_policy.op_issue_yy%TYPE,
   p_op_pol_seqno    IN       gipi_wopen_policy.op_pol_seqno%TYPE,
   p_op_renew_no     IN       gipi_wopen_policy.op_renew_no%TYPE,
   p_record_status	 IN 	  VARCHAR2)
IS
/* BRYAN 09/21/2010
** for pre-insert and pre-update of GIPI_WOPEN_POLICY in Basic Info page
 */
   prev_assd     VARCHAR2 (55);
   curr_assd     VARCHAR2 (55);
   v_exist       VARCHAR2 (1)                   := 'N';
   v_policy_id   gipi_polbasic.policy_id%TYPE;
   v_par_id      gipi_parhist.par_id%TYPE;
   v_count       NUMBER                         := ' ';
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
   
   
END gipis002_save_open_policy;
/



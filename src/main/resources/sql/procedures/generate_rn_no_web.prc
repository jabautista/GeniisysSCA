DROP PROCEDURE CPI.GENERATE_RN_NO_WEB;

CREATE OR REPLACE PROCEDURE CPI.GENERATE_RN_NO_WEB
(p_line_cd       gipi_polbasic.line_cd%TYPE,
   p_subline_cd    gipi_polbasic.subline_cd%TYPE,
   p_iss_cd        gipi_polbasic.iss_cd%TYPE,
   p_intm_no       giex_expiry.intm_no%TYPE,
   p_line_cd2      gipi_polbasic.line_cd%TYPE,
   p_subline_cd2   gipi_polbasic.subline_cd%TYPE,
   p_iss_cd2       gipi_polbasic.iss_cd%TYPE,
   p_issue_yy      gipi_polbasic.issue_yy%TYPE,
   p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
   p_renew_no      gipi_polbasic.renew_no%TYPE,
   p_fr_date       DATE,
   p_to_date       DATE
)
IS
   v_count       NUMBER                       := 0;
   p_exist       VARCHAR2 (1)                 := 'N';
   v_rn_seq_no   giex_rn_no.rn_seq_no%TYPE;
   p_rn_seq_no   NUMBER                       := 9999999;
   --v_last_rn_seq_no   giex_rn_no.rn_seq_no%TYPE;
   v_line_cd     gipi_polbasic.line_cd%TYPE;
   v_iss_cd      gipi_polbasic.iss_cd%TYPE;
   v_rn_yy       giex_rn_no.rn_yy%TYPE;

   CURSOR exp_pol
   IS
      SELECT   a.policy_id, a.line_cd, a.iss_cd,
               TO_NUMBER (TO_CHAR (a.extract_date, 'YY')) rn_yy
          FROM giex_expiry a
         WHERE NOT EXISTS (SELECT '1'
                             FROM giex_rn_no b
                            WHERE b.policy_id = a.policy_id)
           AND a.line_cd = NVL (p_line_cd, NVL (p_line_cd2, a.line_cd))
           AND a.subline_cd =
                         NVL (p_subline_cd, NVL (p_subline_cd2, a.subline_cd))
           AND a.iss_cd = NVL (p_iss_cd, NVL (p_iss_cd2, a.iss_cd))
           AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
           AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
           AND a.renew_no = NVL (p_renew_no, a.renew_no)
           AND NVL (a.intm_no, 0) = NVL (p_intm_no, NVL (a.intm_no, 0))
           AND TRUNC (a.expiry_date) >= NVL (p_fr_date, TRUNC (a.expiry_date))
           AND TRUNC (a.expiry_date) <= NVL (p_to_date, TRUNC (a.expiry_date))
           AND a.renew_flag = '2'
           AND NVL (a.pack_policy_id, 0) = 0                    --added by gmi
      ORDER BY a.line_cd,
               a.subline_cd,
               a.iss_cd,
               a.issue_yy,
               a.pol_seq_no,
               a.renew_no;
BEGIN
   FOR e IN exp_pol
   LOOP
      v_count := v_count + 1;
      p_exist := 'N';

      FOR a1 IN (SELECT        rn_seq_no, line_cd, iss_cd, rn_yy
                          FROM giis_rn_seq
                         WHERE line_cd = e.line_cd
                           AND iss_cd = e.iss_cd
                           AND rn_yy = e.rn_yy)
      LOOP    
         p_exist := 'Y';
         v_rn_seq_no := NVL (a1.rn_seq_no, 0) + 1;
         if v_rn_seq_no > 999999 then
              v_rn_seq_no := 0;
          end if;
         v_line_cd := a1.line_cd;
         v_iss_cd := a1.iss_cd;
         v_rn_yy := a1.rn_yy;
      END LOOP;

      IF p_exist = 'Y'
      THEN
         UPDATE giis_rn_seq
            SET rn_seq_no = (v_rn_seq_no)
          WHERE line_cd = v_line_cd AND iss_cd = v_iss_cd AND rn_yy = v_rn_yy;
      END IF;

      IF p_exist = 'N'
      THEN
         v_rn_seq_no := 0;

         INSERT INTO giis_rn_seq
                     (line_cd, iss_cd, rn_yy, rn_seq_no
                     )
              VALUES (e.line_cd, e.iss_cd, e.rn_yy, v_rn_seq_no
                     );
      END IF;

      INSERT INTO giex_rn_no
                  (policy_id, line_cd, iss_cd, rn_yy, rn_seq_no
                  )
           VALUES (e.policy_id, e.line_cd, e.iss_cd, e.rn_yy, v_rn_seq_no
                  );
   END LOOP;
end;
/



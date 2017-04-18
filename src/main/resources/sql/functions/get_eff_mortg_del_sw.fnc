DROP FUNCTION CPI.GET_EFF_MORTG_DEL_SW;

CREATE OR REPLACE FUNCTION CPI.get_eff_mortg_del_sw (
   p_policy_id   gipi_polbasic.policy_id%TYPE,
   p_mortg_cd    gipi_mortgagee.mortg_cd%TYPE ,
   p_item_no       gipi_mortgagee.item_no%TYPE 
)
   RETURN VARCHAR2
IS
/*   Note : this function is created for MAC policy certificates. 
**          p_policy_id refers to the policy currently being printed 
**          p_mortg_cd refers to the mortg_cd being checked 
**
*/ 
   v_policy_no           VARCHAR2 (50)                         := NULL;
   v_del_sw              VARCHAR2 (1)                          := 'N';
   v_line_cd             gipi_polbasic.line_cd%TYPE;
   v_subline_cd          gipi_polbasic.subline_cd%TYPE;
   v_iss_cd              gipi_polbasic.iss_cd%TYPE;
   v_issue_yy            gipi_polbasic.issue_yy%TYPE;
   v_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
   v_renew_no            gipi_polbasic.renew_no%TYPE;
   v_endt_seq_no         gipi_polbasic.endt_seq_no%TYPE;
   v_eff_date            gipi_polbasic.eff_date%TYPE;
   v_expiry_date         gipi_polbasic.expiry_date%TYPE;
   v_endt_expiry_date    gipi_polbasic.endt_expiry_date%TYPE;
   v_max_endt_seq_no     gipi_polbasic.endt_seq_no%TYPE;
   v_latesteff_endt_no   gipi_polbasic.endt_seq_no%TYPE;
   v_backward_endt_no    gipi_polbasic.endt_seq_no%TYPE;
   v_target_endt_no      gipi_polbasic.endt_seq_no%TYPE;
BEGIN
   FOR x IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                    renew_no, endt_seq_no, eff_date, expiry_date,
                    endt_expiry_date
               FROM gipi_polbasic
              WHERE policy_id = p_policy_id)
   LOOP
      v_line_cd := x.line_cd;
      v_subline_cd := x.subline_cd;
      v_iss_cd := x.iss_cd;
      v_issue_yy := x.issue_yy;
      v_pol_seq_no := x.pol_seq_no;
      v_renew_no := x.renew_no;
      v_endt_seq_no := x.endt_seq_no;
      v_eff_date := x.eff_date;
      v_expiry_date := x.expiry_date;
      v_endt_expiry_date := x.endt_expiry_date;
   END LOOP;

   -- get the maximum endorsement no. created
   FOR endt IN (SELECT MAX (endt_seq_no) endt_seq_no
                  FROM gipi_polbasic a, gipi_mortgagee b
                 WHERE a.policy_id = b.policy_id
                   AND a.line_cd = v_line_cd
                   AND a.iss_cd = v_iss_cd
                   AND a.subline_cd = v_subline_cd
                   AND a.issue_yy = v_issue_yy
                   AND a.pol_seq_no = v_pol_seq_no
                   AND a.renew_no = v_renew_no
                   AND a.pol_flag IN ('1', '2', '3', 'X')
                   AND (a.endt_seq_no = 0 or (a.endt_seq_no <> 0 ) AND TRUNC (a.eff_date) <= TRUNC (v_eff_date)
                   AND TRUNC (NVL (a.endt_expiry_date, a.expiry_date)) >=
                                                            TRUNC (v_eff_date) )                    
                   AND a.endt_seq_no <= v_endt_seq_no
                   AND b.mortg_cd = p_mortg_cd
                   AND b.item_no = p_item_no)
   LOOP
      v_max_endt_seq_no := endt.endt_seq_no;
      EXIT;
   END LOOP;

   -- get the latest backward endt_seq_no
   FOR endt IN (SELECT MAX (endt_seq_no) endt_seq_no
                  FROM gipi_polbasic a, gipi_mortgagee b
                 WHERE a.policy_id = b.policy_id
                   AND a.line_cd = v_line_cd
                   AND a.iss_cd = v_iss_cd
                   AND a.subline_cd = v_subline_cd
                   AND a.issue_yy = v_issue_yy
                   AND a.pol_seq_no = v_pol_seq_no
                   AND a.renew_no = v_renew_no
                   AND a.pol_flag IN ('1', '2', '3', 'X')
                   AND (a.endt_seq_no = 0 or (a.endt_seq_no <> 0 ) AND TRUNC (a.eff_date) <= TRUNC (v_eff_date)
                   AND TRUNC (NVL (a.endt_expiry_date, a.expiry_date)) >=
                                                            TRUNC (v_eff_date) )  
                   AND NVL (a.back_stat, 5) = 2
                   AND a.endt_seq_no <= v_endt_seq_no
                   AND b.mortg_cd = p_mortg_cd
                   AND b.item_no = p_item_no )
   LOOP
      v_backward_endt_no := endt.endt_seq_no;
      EXIT;
   END LOOP;

   -- get the latest effective endorsement created for the mortgagee
   FOR endt IN (SELECT   endt_seq_no
                    FROM gipi_polbasic a, gipi_mortgagee b
                   WHERE a.policy_id = b.policy_id
                     AND a.line_cd = v_line_cd
                     AND a.iss_cd = v_iss_cd
                     AND a.subline_cd = v_subline_cd
                     AND a.issue_yy = v_issue_yy
                     AND a.pol_seq_no = v_pol_seq_no
                     AND a.renew_no = v_renew_no
                     AND a.pol_flag IN ('1', '2', '3', 'X')
                     AND TRUNC (a.eff_date) <= TRUNC (v_eff_date)
                     AND (a.endt_seq_no = 0 or (a.endt_seq_no <> 0 ) AND TRUNC (a.eff_date) <= TRUNC (v_eff_date)
                     AND TRUNC (NVL (a.endt_expiry_date, a.expiry_date)) >=
                                                            TRUNC (v_eff_date) )  
                     AND a.endt_seq_no <= v_endt_seq_no
                     AND b.mortg_cd = p_mortg_cd
                     AND b.item_no = p_item_no
                ORDER BY a.eff_date DESC)
   LOOP
      v_latesteff_endt_no := endt.endt_seq_no;
      EXIT;
   END LOOP;

   -- IF THE BACKWARD ENDORSEMENT IS EQUAL TO THE LAST ENDORSEMENT CREATED, THEN USE THE BACKWARD ENDT , OTHERWISE RETRIEVE INFO FROM THE LATEST EFFECTIVE ENDT
   IF v_backward_endt_no IS NOT NULL
      AND v_backward_endt_no = v_max_endt_seq_no
   THEN
      v_target_endt_no := v_backward_endt_no;
   ELSE
      v_target_endt_no := v_latesteff_endt_no;
   END IF;

   FOR mort IN (SELECT NVL (b.delete_sw, 'N') delete_sw
                  FROM gipi_polbasic a, gipi_mortgagee b
                 WHERE a.policy_id = b.policy_id
                   AND b.mortg_cd = p_mortg_cd
                   AND a.line_cd = v_line_cd
                   AND a.subline_cd = v_subline_cd
                   AND a.iss_cd = v_iss_cd
                   AND a.issue_yy = v_issue_yy
                   AND a.pol_seq_no = v_pol_seq_no
                   AND a.renew_no = v_renew_no
                   AND a.endt_seq_no = v_target_endt_no
                   AND b.item_no = p_item_no)
   LOOP
      v_del_sw := mort.delete_sw;
      EXIT;
   END LOOP;

   RETURN v_del_sw;
END get_eff_mortg_del_sw;
/



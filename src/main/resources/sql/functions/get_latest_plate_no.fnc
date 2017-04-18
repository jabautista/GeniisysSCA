DROP FUNCTION CPI.GET_LATEST_PLATE_NO;

CREATE OR REPLACE FUNCTION CPI.get_latest_plate_no (
                             p_line_cd       gipi_polbasic.line_cd%TYPE,
                             p_subline_cd    gipi_polbasic.subline_cd%TYPE,
                             p_iss_cd        gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy      gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no      gipi_polbasic.renew_no%TYPE,
                             p_item_no       gipi_vehicle.item_no%TYPE) RETURN VARCHAR2 IS
  v_plate_no   gipi_vehicle.plate_no%TYPE;
BEGIN
/* created by jayr 11252003
** this will return the latest plate number for the specified policy
*/
     FOR rec IN (SELECT y.item_no, y.plate_no, x.endt_seq_no
                  FROM gipi_polbasic x,
                       gipi_vehicle  y
                 WHERE 1=1
                   AND x.policy_id  = y.policy_id
                   AND x.line_cd    = p_line_cd
                   AND x.subline_cd = p_subline_cd
                   AND x.iss_cd     = p_iss_cd
                   AND x.issue_yy   = p_issue_yy
                   AND x.pol_seq_no = p_pol_seq_no
                   AND x.renew_no   = p_renew_no
                   AND y.item_no    = p_item_no
                   AND x.pol_flag  IN  ('1','2','3','4')
                 ORDER BY x.eff_date DESC,x.endt_seq_no DESC)
     LOOP
       v_plate_no  := rec.plate_no;
      --check for change in plate_no using backward endt.
        FOR rec2 IN (SELECT b.item_no, b.plate_no, a.endt_seq_no
                       FROM gipi_polbasic a,
                            gipi_vehicle  b
                      WHERE 1=1
                        AND a.policy_id  = a.policy_id
                        AND a.line_cd    = p_line_cd
                        AND a.subline_cd = p_subline_cd
                        AND a.iss_cd     = p_iss_cd
                        AND a.issue_yy   = p_issue_yy
                        AND a.pol_seq_no = p_pol_seq_no
                        AND a.renew_no   = p_renew_no
                        AND b.item_no    = p_item_no
                        AND a.pol_flag  IN  ('1','2','3','4')
                        AND NVL(a.endt_seq_no,0) > 0
                        AND NVL(a.back_stat,5) = 2
                        AND NVL(a.endt_seq_no,0) > rec.endt_seq_no
                      ORDER BY a.endt_seq_no DESC)
        LOOP
          v_plate_no  := rec2.plate_no;
        EXIT;
        END LOOP;
     EXIT;
     END LOOP;
RETURN v_plate_no;
END;
/



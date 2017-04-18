DROP FUNCTION CPI.GET_LATEST_MOTOR_NO;

CREATE OR REPLACE FUNCTION CPI.get_latest_motor_no (
                             p_policy_id      gipi_polbasic.policy_id%TYPE,
                             p_item_no        gipi_vehicle.item_no%TYPE) RETURN VARCHAR2 IS
  v_motor_no     gipi_vehicle.motor_no%TYPE;
BEGIN
/* created by marlo 02142011
** based from get_latest_plate_no3
*/
     FOR rec IN (SELECT y.item_no, y.motor_no, x.endt_seq_no,
                        x.line_cd,x.subline_cd,x.iss_cd,
                        x.issue_yy, x.pol_seq_no, x.renew_no
                  FROM gipi_polbasic x,
                       gipi_vehicle  y
                 WHERE 1=1
                   AND x.policy_id  = y.policy_id
                   AND x.policy_id  = p_policy_id
                   AND y.item_no    = p_item_no
                   AND x.pol_flag  IN  ('1','2','3','4')
                 ORDER BY x.eff_date DESC,x.endt_seq_no DESC)
     LOOP
       v_motor_no  := rec.motor_no;
   --check for endt in motor_no
     FOR rec3 IN (SELECT a.policy_id, a.endt_seq_no,b.motor_no
                       FROM gipi_polbasic a,
                            gipi_vehicle  b
                      WHERE 1=1
                        AND a.policy_id    = b.policy_id
                        AND b.item_no      = p_item_no
                        AND a.line_cd      = rec.line_cd
                        AND a.subline_cd   = rec.subline_cd
                        AND a.iss_cd       = rec.iss_cd
                        AND a.issue_yy     = rec.issue_yy
                        AND a.pol_seq_no   = rec.pol_seq_no
                        AND a.renew_no     = rec.renew_no
                        AND a.pol_flag  IN  ('1','2','3','4')
                        AND NVL(a.endt_seq_no,0) > 0
                        AND NVL(a.endt_seq_no,0) > rec.endt_seq_no
                      ORDER BY a.endt_seq_no DESC)
        LOOP
          v_motor_no  := rec3.motor_no;
        EXIT;
        END LOOP;
     --check for change in motor_no using backward endt.
        FOR rec2 IN (SELECT b.item_no, b.motor_no, a.endt_seq_no
                       FROM gipi_polbasic a,
                            gipi_vehicle  b
                      WHERE 1=1
                        AND a.policy_id  = b.policy_id
                        AND a.policy_id  = p_policy_id
                        AND b.item_no    = p_item_no
                        AND a.pol_flag  IN  ('1','2','3','4')
                        AND NVL(a.endt_seq_no,0) > 0
                        AND NVL(a.back_stat,5) = 2
                        AND NVL(a.endt_seq_no,0) > rec.endt_seq_no
                      ORDER BY a.endt_seq_no DESC)
        LOOP
          v_motor_no  := rec2.motor_no;
        EXIT;
        END LOOP;
     EXIT;
     END LOOP;
RETURN v_motor_no;
END;
/



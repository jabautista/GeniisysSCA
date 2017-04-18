DROP FUNCTION CPI.GET_LATEST_PLATE_NO3;

CREATE OR REPLACE FUNCTION CPI.get_latest_plate_no3 (
                             p_policy_id      gipi_polbasic.policy_id%TYPE,
                             p_item_no        gipi_vehicle.item_no%TYPE) RETURN VARCHAR2
IS
  v_plate_no     gipi_vehicle.plate_no%TYPE;
  v_total_tag    gicl_claims.total_tag%TYPE;
BEGIN
/* created by jayr 11252003
** this will return the latest plate number for the specified policy
*/
/*Modified by jen.061706
** check if item was tagged as total loss.
*/
  FOR i IN (SELECT 'Y' total_tag
  	  	      FROM gicl_claims a,
                   gicl_clm_item b,
				   gipi_polbasic c
             WHERE 1=1
			   AND c.policy_id  = p_policy_id
			   AND a.line_cd    = c.line_cd
               AND a.subline_cd = c.subline_cd
			   AND a.POL_ISS_CD = c.iss_cd
			   AND a.issue_yy   = c.issue_yy
    		   AND a.pol_seq_no = c.pol_seq_no
   			   AND a.renew_no   = c.renew_no
   			   AND a.claim_id   = b.claim_id
   			   AND b.item_no    = p_item_no
			   AND a.total_tag  = 'Y'
			   AND a.clm_stat_cd NOT IN ('CC','WD','DN'))
  LOOP
    v_total_tag := i.total_tag;
  END LOOP;
  IF NVL(v_total_tag,'N') = 'N' THEN
     FOR rec IN (SELECT y.item_no, y.plate_no, x.endt_seq_no,
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
       v_plate_no  := rec.plate_no;
   --check for endt in plate_no
     FOR rec3 IN (SELECT a.policy_id, a.endt_seq_no,b.plate_no
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
          v_plate_no  := rec3.plate_no;
        EXIT;
        END LOOP;
     --check for change in plate_no using backward endt.
        FOR rec2 IN (SELECT b.item_no, b.plate_no, a.endt_seq_no
                       FROM gipi_polbasic a,
                            gipi_vehicle  b
                      WHERE 1=1
                        AND a.policy_id  = a.policy_id
                        AND a.policy_id  = p_policy_id
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
  END IF;
RETURN v_plate_no;
END;
/



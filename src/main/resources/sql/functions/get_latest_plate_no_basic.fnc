DROP FUNCTION CPI.GET_LATEST_PLATE_NO_BASIC;

CREATE OR REPLACE FUNCTION CPI.get_latest_plate_no_basic
(
  p_line_cd       gipi_polbasic.line_cd%TYPE,
  p_subline_cd    gipi_polbasic.subline_cd%TYPE,
  p_iss_cd        gipi_polbasic.iss_cd%TYPE,
  p_issue_yy      gipi_polbasic.issue_yy%TYPE,
  p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
  p_renew_no      gipi_polbasic.renew_no%TYPE,
  p_item_no       gipi_vehicle.item_no%TYPE
) RETURN VARCHAR2
IS
  v_plate_no   gipi_vehicle.plate_no%TYPE;
  v_total_tag  gicl_claims.total_tag%TYPE;
BEGIN
  /*Modified by: jen.071106
  **check first if there's a claim tagged as total loss
  **  for the item. If yes, do not get the latest plate no.
  */
  
  /* MJ Fabroa 03/08/2013
  ** Removed 4 in pol_flag.
  ** Confirmed by Ms Jen.
  */
  
  FOR i IN (SELECT 'Y' total_tag
  	  	      FROM gicl_claims a,
                   gicl_clm_item b
             WHERE 1=1
			   AND a.line_cd    = p_line_cd
               AND a.subline_cd = p_subline_cd
			   AND a.POL_ISS_CD = p_iss_cd
			   AND a.issue_yy   = p_issue_yy
    		   AND a.pol_seq_no = p_pol_seq_no
   			   AND a.renew_no   = p_renew_no
   			   AND a.claim_id   = b.claim_id
   			   AND b.item_no    = p_item_no
			   AND a.total_tag  = 'Y'
			   AND a.clm_stat_cd NOT IN ('CC','WD','DN'))
  LOOP
    v_total_tag := i.total_tag;
  END LOOP;
  IF NVL(v_total_tag,'N') = 'N' THEN
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
                   --AND x.pol_flag  IN  ('1','2','3','4','X')
				   AND x.pol_flag  IN  ('1','2','3','X')	--Modified by MJ Fabroa 03/08/2013. Confirmed by Ms Jen.
                 ORDER BY x.eff_date DESC,x.endt_seq_no DESC)
    LOOP
      v_plate_no  := rec.plate_no;
      --check for change in plate_no using backward endt.
      FOR rec2 IN (SELECT b.item_no, b.plate_no, a.endt_seq_no
                     FROM gipi_polbasic a,
                          gipi_vehicle  b
                    WHERE 1=1
                      AND a.policy_id  = b.policy_id
                      AND a.line_cd    = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd     = p_iss_cd
                      AND a.issue_yy   = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no   = p_renew_no
                      AND b.item_no    = p_item_no
                      --AND a.pol_flag  IN  ('1','2','3','4','X')
					  AND a.pol_flag  IN  ('1','2','3','X')	--Modified by MJ Fabroa 03/08/2013. Confirmed by Ms Jen.
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



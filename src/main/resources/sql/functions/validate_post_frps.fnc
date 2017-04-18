DROP FUNCTION CPI.VALIDATE_POST_FRPS;

CREATE OR REPLACE FUNCTION CPI.validate_post_frps (
			 p_line_cd GIRI_DISTFRPS_WDISTFRPS_V.line_cd%TYPE,
			 p_frps_yy GIRI_DISTFRPS_WDISTFRPS_V.frps_yy%TYPE,
			 p_frps_seq_no GIRI_DISTFRPS_WDISTFRPS_V.frps_seq_no%TYPE,
			 p_dist_no	 GIRI_DISTFRPS_WDISTFRPS_V.dist_no%TYPE,
			 p_dist_seq_no GIRI_DISTFRPS_WDISTFRPS_V.dist_seq_no%TYPE
	) RETURN VARCHAR2 IS
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 06.19.2012
    **  Reference By  : GIRIS002 - Enter RI Acceptance
    **  Description   : Check if allowed to post FRPS based on the ff. condtions
    **                  a. FRPS has perils already
    **                  b. The sum of the ri_shr_pct per peril is equal to 
    **                     giuw_perilds dist_spct per peril.
    **                  c. All ri_shr_pct of perils are equal to dist_spct
    */
    
	  v_dist_spct			GIUW_PERILDS_DTL.dist_spct%type;
	  v_dist_prem			GIUW_PERILDS_DTL.dist_prem%type;
	  ctr				    NUMBER :=0;
	  ctr1				    NUMBER :=0;
	  v_count		    	NUMBER;
	  v_pol_flag      		VARCHAR2(1);
	  v_diff				NUMBER; 
	  v_diff1				NUMBER; 
	  v_message				VARCHAR2(5000);
	  CURSOR tmp_area IS
	    SELECT peril_cd, SUM(ri_shr_pct) sum_ri_shr_pct, SUM(ri_prem_amt) sum_ri_prem_amt
	      FROM GIRI_WFRPERIL
	     WHERE line_cd     = p_line_cd
	       AND frps_yy     = p_frps_yy
	       AND frps_seq_no = p_frps_seq_no
	  GROUP BY peril_cd;
	
	BEGIN

	  FOR A1 IN (SELECT post_flag
	              FROM GIUW_POL_DIST
	             WHERE dist_no = p_dist_no) 
      LOOP
        v_pol_flag := A1.post_flag;
        EXIT; 
	  END LOOP;
      
	  BEGIN
	    SELECT COUNT(peril_cd)
	      INTO v_count
	      FROM GIRI_WFRPERIL
	     WHERE line_cd     = p_line_cd
	       AND frps_yy     = p_frps_yy
	       AND frps_seq_no = p_frps_seq_no; 
	  EXCEPTION
	  	  WHEN NO_DATA_FOUND THEN 
	  	  NULL; 
	  END;
	  
      IF v_count IS NULL OR v_count = 0 THEN
	    v_message := 'There are no perils for this FRPS yet.';
		RETURN v_message;
	  ELSE    
	    FOR c1_rec IN tmp_area LOOP
            BEGIN
                SELECT round(dist_spct,2), round(dist_prem,2)
                  INTO v_dist_spct, v_dist_prem
                  FROM GIUW_PERILDS_DTL T1, GIIS_DIST_SHARE T2
                 WHERE T1.line_cd    = T2.line_cd
                   AND T1.share_cd   = T2.share_cd
                   AND T2.share_type = '3'
                   AND dist_no       = p_dist_no
                   AND dist_seq_no   = p_dist_seq_no
                   AND T1.line_cd    = p_line_cd
                   AND peril_cd      = c1_rec.peril_cd;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN NULL; 
            END;
        
            IF round(c1_rec.sum_ri_shr_pct,2) != v_dist_spct THEN
                v_diff := round(c1_rec.sum_ri_shr_pct,2) - v_dist_spct;
                ctr := ctr+1;
            ELSE
                NULL;
            END IF;      
	      
            IF round(c1_rec.sum_ri_prem_amt,2) != v_dist_prem THEN
                v_diff1 := round(c1_rec.sum_ri_prem_amt,2) - v_dist_prem;
                ctr1 := ctr1+1;
            ELSE
                NULL;
            END IF;      
	    END LOOP;
        
	    IF ctr != 0 AND v_pol_flag != 'P' AND ABS(v_diff) > 0.02 THEN
	      v_message := 'The total facultative placement '||
	                   'is not equal to the distribution.';
		  RETURN v_message;
	    ELSIF ctr1 != 0 AND ABS(v_diff1) > 0.02 THEN 
	      v_message := 'The total facultative premium placement ' ||
	                   'is not equal to the distribution.';
		  RETURN v_message;	 		  
	    ELSE
		RETURN v_message;
	    	--pause;
	    	--create_binders;
	      --CALL_GIRIS026 (p_line_cd, p_frps_yy, p_frps_seq_no);
	    END IF;
	  END IF;
END;
/



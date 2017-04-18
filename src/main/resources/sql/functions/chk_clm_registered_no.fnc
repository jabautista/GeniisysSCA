DROP FUNCTION CPI.CHK_CLM_REGISTERED_NO;

CREATE OR REPLACE FUNCTION CPI.Chk_Clm_Registered_No (p_claim_id     gicl_claims.claim_id%TYPE,
                                                  p_assd_no      gicl_claims.assd_no%TYPE,
											      p_cell_no      VARCHAR2) RETURN VARCHAR2 IS
  v_reg_sw     VARCHAR2(1) := 'N';
  v_cell_no    VARCHAR2(10) := SUBSTR(p_cell_no, -10,10);
BEGIN 
  FOR chk_assd1 IN (
    SELECT '1'
	  FROM GIIS_ASSURED
	 WHERE assd_no = p_assd_no
       AND (cp_no IS NOT NULL OR
            sun_no IS NOT NULL OR
            smart_no IS NOT NULL OR
			globe_no IS NOT NULL  ))
  LOOP
    v_reg_sw := 'E';
  END LOOP;
  IF v_reg_sw = 'E' THEN 
     FOR chk_assd1 IN (
       SELECT '1'
	     FROM GIIS_ASSURED
  	    WHERE assd_no = p_assd_no
          AND (SUBSTR(cp_no, -10,10) = v_cell_no OR
               SUBSTR(sun_no, -10,10) = v_cell_no OR
               SUBSTR(smart_no, -10,10) = v_cell_no OR
			   SUBSTR(globe_no, -10,10) = v_cell_no ))
     LOOP
       v_reg_sw := 'Y';
     END LOOP;
  END IF;
  IF v_reg_sw <> 'Y' THEN
  	 FOR chk_intm IN (
       SELECT intm_no, 
	          SUBSTR(cp_no, -10,10) cp_no, 
              SUBSTR(sun_no, -10,10) sun_no,
              SUBSTR(smart_no, -10,10) smart_no,
    		  SUBSTR(globe_no, -10,10) globe_no
	     FROM GIIS_INTERMEDIARY
   	    WHERE intm_no IN (SELECT DISTINCT intm_no
		                   FROM gicl_intm_itmperil
						  WHERE claim_id  = p_claim_id)                     
          AND (cp_no IS NOT NULL OR
               sun_no IS NOT NULL OR
               smart_no IS NOT NULL OR
		  	   globe_no IS NOT NULL  ))
     LOOP
	   IF v_cell_no = chk_intm.cp_no OR
	      v_cell_no = chk_intm.sun_no OR
		  v_cell_no = chk_intm.smart_no OR
		  v_cell_no = chk_intm.globe_no THEN
		  v_reg_sw := 'Y';
          EXIT;	   
	   ELSIF v_reg_sw = 'A' THEN
          v_reg_sw := 'E';
	   ELSIF v_reg_sw = 'N' THEN
	      v_reg_sw := 'I';
       END IF;	   
     END LOOP;
  END IF;	  			 	   										 
  RETURN v_reg_sw;
END Chk_Clm_Registered_No;
/



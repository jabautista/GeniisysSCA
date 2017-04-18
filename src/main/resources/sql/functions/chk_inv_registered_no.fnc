DROP FUNCTION CPI.CHK_INV_REGISTERED_NO;

CREATE OR REPLACE FUNCTION CPI.CHK_INV_REGISTERED_NO (p_line_cd      gipi_polbasic.line_cd%TYPE,
                                                  p_subline_cd   gipi_polbasic.line_cd%TYPE,
                                                  p_iss_cd       gipi_polbasic.iss_cd%TYPE,
                                                  p_issue_yy     gipi_polbasic.issue_yy%TYPE,
                                                  p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
                                                  p_renew_no     gipi_polbasic.renew_no%TYPE,												
                                                  p_prem_iss_cd       gipi_polbasic.iss_cd%TYPE,												  												  
                                                  p_prem_seq_no  gipi_invoice.prem_seq_no%TYPE,
											      p_cell_no      VARCHAR2) RETURN VARCHAR2 IS
  v_reg_sw     VARCHAR2(1) := 'N';
  v_assd_no    GIIS_ASSURED.assd_no %TYPE := Get_Latest_Assured_No2 (p_line_cd,     p_subline_cd,  p_iss_cd,  p_issue_yy,p_pol_seq_no,  p_renew_no); 
  v_cell_no    VARCHAR2(10) := SUBSTR(p_cell_no, -10,10);                         	                                         											  
BEGIN
  FOR chk_assd1 IN (
    SELECT '1'
	  FROM GIIS_ASSURED
	 WHERE assd_no = v_assd_no
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
  	    WHERE assd_no = v_assd_no
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
   	    WHERE intm_no IN (SELECT DISTINCT intrmdry_intm_no
		                   FROM gipi_comm_invoice
						  WHERE iss_cd     = p_prem_iss_cd
							AND prem_seq_no   = p_prem_seq_no)                     
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
END Chk_Inv_Registered_No;
/



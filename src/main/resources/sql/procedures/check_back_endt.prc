DROP PROCEDURE CPI.CHECK_BACK_ENDT;

CREATE OR REPLACE PROCEDURE CPI.check_back_endt(
	   	  		  p_par_id	   IN  GIPI_PARLIST.par_id%TYPE,
				  p_back_endt  OUT VARCHAR2
	   	  		  )
  	   IS
  v_par_type  GIPI_PARLIST.par_type%type;	
  v_back_endt VARCHAR2(200);   
BEGIN
     SELECT par_type
       INTO v_par_type
       FROM gipi_parlist
      WHERE par_id = p_par_id;

  IF v_par_type = 'E' THEN
     	  --BETH 02062001 for endt. record always check if it is backward endt. 
    --IF :GLOBAL.cg$back_endt = 'N' THEN
      FOR pol IN (SELECT '1'
                    FROM gipi_polbasic b250, gipi_wpolbas b540
                   WHERE b250.line_cd = b540.line_cd
                     AND b250.subline_cd = b540.subline_cd
                   	 AND b250.iss_cd = b540.iss_cd
                   	 AND b250.issue_yy = b540.issue_yy
                   	 AND b250.pol_seq_no = b540.pol_seq_no
                   	 AND b250.renew_no = b540.renew_no
                   	 AND TRUNC(b250.eff_date) > TRUNC(b540.eff_date)
                   	 AND b250.pol_flag     in('1','2','3')
                   	 AND NVL(b250.endt_expiry_date,b250.expiry_date) >=  b540.eff_date
                   	 AND B540.par_id = p_par_id                
                   	 AND b540.pol_flag IN ('1','2','3')
                   ORDER BY B250.eff_date desc)
      LOOP
        v_back_endt := 'Y';
        EXIT;
      END LOOP; 
    --END IF; 
  END IF;
  p_back_endt := NVL(v_back_endt,'N');	  
END;
/



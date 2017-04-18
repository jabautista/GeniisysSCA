DROP FUNCTION CPI.GET_BACK_ENDT_STATUS;

CREATE OR REPLACE FUNCTION CPI.GET_BACK_ENDT_STATUS (p_par_id  GIPI_WPOLBAS.par_id%TYPE) 
  RETURN VARCHAR2 IS
  
  v_back_endt VARCHAR2(1) := 'N';
  
BEGIN  
  FOR b IN (
    SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, pol_flag, prorate_flag, eff_date
      FROM gipi_wpolbas
     WHERE par_id = p_par_id)
  LOOP  
    FOR c IN 
        (SELECT  eff_date
           FROM  gipi_polbasic
          WHERE  line_cd     = b.line_cd
            AND  subline_cd  = b.subline_cd
            AND  iss_cd      = b.iss_cd
            AND  issue_yy    = b.issue_yy
            AND  pol_seq_no  = b.pol_seq_no
            AND  renew_no    = b.renew_no
            AND  endt_seq_no != 0
            AND  pol_flag   IN ('1','2','3')
          ORDER BY eff_date DESC)
    LOOP
      IF TRUNC(c.eff_date) > TRUNC(b.eff_date) THEN
        v_back_endt := 'Y';
      END IF;
    END LOOP;
    
    IF b.pol_flag = '4' OR b.prorate_flag = '1' THEN
      v_back_endt := 'N';
    END IF;
  END LOOP;
  
  RETURN v_back_endt;
END GET_BACK_ENDT_STATUS;
/



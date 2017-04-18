DROP FUNCTION CPI.GET_REC_FLAG_FOR_GIPI_WVES_AIR;

CREATE OR REPLACE FUNCTION CPI.get_rec_flag_for_gipi_wves_air(p_carrier IN GIPI_WVES_AIR%ROWTYPE)

RETURN GIPI_PARLIST.par_type%TYPE 

IS

v_var_type      GIPI_PARLIST.par_type%TYPE;

BEGIN
   DECLARE 
   CURSOR gaiv_cur IS SELECT line_cd, subline_cd, iss_cd, issue_yy, 
                            pol_seq_no, eff_date, vessel_cd
                     FROM GIPI_VES_AIR_V;
   BEGIN
       SELECT NVL(par_type, 'P') INTO v_var_type 
       FROM GIPI_PARLIST
       WHERE par_id = p_carrier.par_id;
       
       IF v_var_type = 'P'
       THEN
          v_var_type := 'A';
       ELSIF v_var_type = 'E' THEN
          FOR i IN (SELECT line_cd, subline_cd,iss_cd, 
                        issue_yy,pol_seq_no, eff_date
                 FROM GIPI_WPOLBAS
                 WHERE par_id = p_carrier.par_id)
           LOOP
               FOR gaiv_cur_rec IN gaiv_cur LOOP
                  BEGIN
                    IF   i.line_cd    != gaiv_cur_rec.line_cd     OR
                         i.subline_cd != gaiv_cur_rec.subline_cd  OR
                         i.iss_cd     != gaiv_cur_rec.iss_cd      OR
                         i.issue_yy   != gaiv_cur_rec.issue_yy    OR
                         i.pol_seq_no != gaiv_cur_rec.pol_seq_no  OR
                         i.eff_date   != gaiv_cur_rec.eff_date    OR
                         p_carrier.vessel_cd  != gaiv_cur_rec.vessel_cd   OR
                         gaiv_cur_rec.vessel_cd = 'D'
                    THEN
                         v_var_type := 'A';
                                  
                    ELSE
                         IF p_carrier.voy_limit IS NOT NULL OR p_carrier.vescon IS NOT NULL THEN
                           v_var_type := 'C';
                         ELSE 
                           v_var_type := 'D';
                         END IF;
                    END IF;
                              
                  END;
                END LOOP;  
           END LOOP;
       END IF;      
       RETURN v_var_type;
   END;
END get_rec_flag_for_gipi_wves_air;
/



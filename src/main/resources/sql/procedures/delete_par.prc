DROP PROCEDURE CPI.DELETE_PAR;

CREATE OR REPLACE PROCEDURE CPI.delete_par(
	   	  		  p_par_id			IN  gipi_parlist.par_id%TYPE,
				  p_line_cd			IN  gipi_parlist.line_cd%TYPE,							
				  p_iss_cd			IN  GIPI_WPOLBAS.iss_cd%TYPE
				  )
	   IS
  v_issue_ri      GIIS_PARAMETERS.param_value_v%TYPE :=  giisp.v('ISS_CD_RI');	
  v_pol_stat 	  GIPI_WPOLBAS.pol_flag%TYPE;
  v_par_seq_no    gipi_parlist.par_seq_no%TYPE;
  v_par_yy        gipi_parlist.par_yy%TYPE;
  v_quote_seq_no  gipi_parlist.quote_seq_no%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio  
  **  Date Created : April 05, 2010  
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : delete_par program unit 
  */
  SELECT par_seq_no,par_yy,quote_seq_no
    INTO v_par_seq_no, v_par_yy, v_quote_seq_no
    FROM gipi_parlist
   WHERE par_id = p_par_id;
   	
  SELECT pol_flag
     INTO v_pol_stat
     FROM GIPI_WPOLBAS
    WHERE par_id = p_par_id;
	
  /*IF :gauge.process = 'Y' THEN
    :gauge.file  := 'Deleting PAR...';
  ELSE
    :gauge.file := 'passing delete policy DELETE_PARs';
  END IF;
  vbx_counter;*/ 
   DELETE FROM gipi_wmortgagee
        WHERE par_id = p_par_id;
   DELETE FROM gipi_wopen_policy
        WHERE par_id = p_par_id;    
  delete_wpictures(p_par_id);
  delete_item_package(p_line_cd,p_par_id);
  IF v_quote_seq_no = 1 THEN
     IF v_pol_stat IN ('2','3') THEN
        --delete_wpolnrep;
		Gipi_Wpolnrep_Pkg.del_gipi_wpolnreps(p_par_id);
     END IF;
     delete_oth_workfile(p_par_id);
     IF p_iss_cd = v_issue_ri THEN
        delete_winpolbas(p_par_id);
     END IF;
     delete_wpolbas(p_par_id);
  ELSE 
     BEGIN
       DECLARE
         CURSOR c IS SELECT a.par_id,a.line_cd,b.pol_flag
                       FROM gipi_parlist a, gipi_wpolbas b
                      WHERE a.line_cd    = p_line_cd    AND
                            a.iss_cd     = p_iss_cd     AND
                            a.par_yy     = v_par_yy     AND
                            a.par_seq_no = v_par_seq_no AND
                            a.par_id     = b.par_id(+)
                   ORDER BY a.par_id;
         p_par_id        gipi_parlist.par_id%TYPE;
       BEGIN
         p_par_id   :=  p_par_id;
         FOR c1 IN c LOOP
             p_par_id := c1.par_id;
             delete_item_package(c1.line_cd,p_par_id);
             IF c1.pol_flag IN ('2','3') THEN
                --delete_wpolnrep;
				Gipi_Wpolnrep_Pkg.del_gipi_wpolnreps(p_par_id);
             END IF;
             delete_oth_workfile(p_par_id);
             delete_wpolbas(p_par_id);
         END LOOP;
         p_par_id := p_par_id;
       END;
     END;
  END IF;
EXCEPTION	 
  WHEN NO_DATA_FOUND THEN
       NULL;
  WHEN TOO_MANY_ROWS THEN
       NULL;  
END;
/



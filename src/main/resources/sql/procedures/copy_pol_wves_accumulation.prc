DROP PROCEDURE CPI.COPY_POL_WVES_ACCUMULATION;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wves_accumulation(
	   	  		  p_par_id		    IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id		IN  GIPI_POLBASIC.policy_id%TYPE,
				  p_line_cd			IN  GIPI_PARLIST.line_cd%TYPE,
				  p_subline_cd		IN  GIPI_WPOLBAS.subline_cd%TYPE,
				  p_iss_cd			IN  GIPI_WPOLBAS.iss_cd%TYPE
	   	  		  )
	    IS
  v_issue_yy	GIPI_POLBASIC.issue_yy%TYPE;
  v_pol_seq_no	GIPI_POLBASIC.pol_seq_no%TYPE;
  CURSOR c IS SELECT vessel_cd,item_no,eta,etd,tsi_amt,rec_flag,eff_date
                FROM GIPI_WVES_ACCUMULATION
               WHERE par_id = p_par_id;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wves_accumulation program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Vessel Accumulation info..';
  ELSE
    :gauge.FILE := 'passing copy policy WVES_ACCUMULATION';
  END IF;
  vbx_counter;  */
  FOR A IN (
  SELECT issue_yy,pol_seq_no
    FROM GIPI_POLBASIC
   WHERE policy_id = p_policy_id) LOOP
    FOR c_rec IN c LOOP
     BEGIN
      INSERT INTO GIPI_VES_ACCUMULATION
                 (line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,
                  item_no,vessel_cd,eta,etd,tsi_amt,rec_flag,eff_date)
          VALUES (p_line_cd,p_subline_cd,
                  p_iss_cd,A.issue_yy,A.pol_seq_no,
                  c_rec.item_no,c_rec.vessel_cd,c_rec.eta,
                  c_rec.etd,c_rec.tsi_amt,c_rec.rec_flag,c_rec.eff_date);
     EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         UPDATE  GIPI_VES_ACCUMULATION
            SET  vessel_cd = c_rec.vessel_cd,
                 eta       = NVL(c_rec.eta,eta),
                 etd       = NVL(c_rec.etd,etd),
                 tsi_amt   = NVL(c_rec.tsi_amt,tsi_amt),
                 rec_flag  = NVL(c_rec.rec_flag,rec_flag),
                 eff_date  = NVL(c_rec.eff_date,eff_date)
          WHERE  line_cd   = p_line_cd
            AND  subline_cd= p_subline_cd
            AND  iss_cd    = p_iss_cd
            AND  issue_yy  = A.issue_yy
            AND  pol_seq_no= A.pol_seq_no
            AND  item_no   = c_rec.item_no;
     END;
    END LOOP;
    EXIT;
  END LOOP;
END;
/



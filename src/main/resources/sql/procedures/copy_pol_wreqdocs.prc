DROP PROCEDURE CPI.COPY_POL_WREQDOCS;

CREATE OR REPLACE PROCEDURE CPI.copy_POL_WREQDOCS(
	   	  		  p_par_id		    IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id		IN  GIPI_POLBASIC.policy_id%TYPE,
				  p_user_id			IN  VARCHAR2,
				  p_msg_alert		OUT VARCHAR2
				  )
		 IS
  CURSOR reqdocs_cur IS 
     SELECT doc_cd,par_id,doc_sw,line_cd,
            date_submitted,user_id,last_update,remarks
			 FROM GIPI_WREQDOCS
      WHERE par_id  = p_par_id;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
  v_line_su              GIIS_LINE.line_cd%TYPE := 'SU';
  v_global_all_line_cd   VARCHAR2(2000); ---HINDI KO ALAM KUNG SAN MANGGAGALING UNG VALUE NITO KAYA GINAWA KO MUNA VARIABLE -- jerome orio
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_POL_WREQDOCS program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Required Document info..';
  ELSE
    :gauge.FILE := 'passing copy policy WREQDOCS';
  END IF;
  vbx_counter;  */
  IF v_global_all_line_cd = v_line_su THEN
      FOR cur_rec IN REQDOCS_CUR LOOP
             IF cur_rec.doc_sw = 'Y' AND cur_rec.date_submitted IS NULL THEN
              p_msg_alert := 'Dates should not be null for required document. PAR should have submitted date for documents.';
              --:gauge.FILE := 'PAR should have submitted date for documents.';
              --error_rtn;
             END IF;
      END LOOP;        
   END IF;
  FOR REQDOCS_cur_rec IN REQDOCS_cur LOOP
  INSERT INTO GIPI_REQDOCS(doc_cd,policy_id,doc_sw,line_cd,date_submitted,user_id,
                           last_update,remarks)
       VALUES(reqdocs_cur_rec.doc_cd,p_policy_id,reqdocs_cur_rec.doc_sw,
	      reqdocs_cur_rec.line_cd,reqdocs_cur_rec.date_submitted,p_user_id,
              SYSDATE,reqdocs_cur_rec.remarks);
  END LOOP;
END;
/



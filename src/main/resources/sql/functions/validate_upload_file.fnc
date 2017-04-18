DROP FUNCTION CPI.VALIDATE_UPLOAD_FILE;

CREATE OR REPLACE FUNCTION CPI.Validate_Upload_File (
	p_file          GIPI_MC_UPLOAD.filename%TYPE)
  RETURN VARCHAR2 IS
	/*
	**  Created by		: Grace
	**  Date Created 	: 03.02.2010
	**  Reference By 	: (GIPIS198 - Upload Fleet Policy Data)
	**  Description 	: Checks if filename has already been uploaded
	*/
	v_exist 	BOOLEAN := FALSE;
	v_msg    	VARCHAR2(4000);
BEGIN
  IF p_file IS NULL THEN
     v_msg := 'There is no excel file to be uploaded.';
  END IF;   
     
  FOR a IN (SELECT 1 
   	          FROM gipi_mc_upload
		     WHERE filename LIKE p_file)
  LOOP
    v_exist := TRUE;
  END LOOP;
	
  IF v_exist = TRUE THEN
     v_msg := 'This file has already been uploaded';
  END IF;
	
  RETURN v_msg;
END;
/



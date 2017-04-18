DROP PROCEDURE CPI.COPY_POL_WPICTURES;

CREATE OR REPLACE PROCEDURE CPI.COPY_POL_WPICTURES(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE,
				   p_user_id	IN  VARCHAR2
				   ) 
		 IS
/* This procedure was added by rolandmm 01/15/2004
/* This was created for the purpose of extracting information from gipi_wpictures
** and inserting this information to gipi_pictures.

** Modified by Lhen 031904
*/

  v_item			GIPI_PICTURES.item_no%TYPE;
  v_file			GIPI_PICTURES.file_name%TYPE;
  v_file_type	GIPI_PICTURES.file_type%TYPE;
  v_file_ext	GIPI_PICTURES.file_ext%TYPE;
  v_remarks		GIPI_PICTURES.remarks%TYPE;
  v_exist 		VARCHAR2(1) := 'N';

BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : COPY_POL_WPICTURES program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
     :gauge.FILE := 'Finalising Pictures Info....';
  ELSE
     :gauge.FILE := 'passing copy policy for PICTURES';
  END IF;

  vbx_counter;*/

/**  INSERT INTO gipi_pictures
              (policy_id,item_no,file_name,file_type,
               file_ext,remarks,user_id,last_update)
       SELECT :postpar.policy_id,item_no,file_name,file_type,
               file_ext,remarks,user_id,last_update
         FROM gipi_wpictures
        WHERE par_id = :postpar.par_id;**/--commented out by Lhen 031904
        
  FOR pol IN (
    SELECT 'a'
      FROM GIPI_WPICTURES
     WHERE par_id = p_par_id ) 
  LOOP
  	v_exist := 'Y';
  	EXIT;
  END LOOP;	 
  
  IF v_exist = 'Y' THEN
     FOR pic IN (
       SELECT item_no,     
       				file_name, 
       				file_type, 
       				file_ext, 
       				remarks
         FROM GIPI_WPICTURES
        WHERE par_id = p_par_id) 
     LOOP
       v_item				:= pic.item_no;
       v_file				:= pic.file_name;
       v_file_type			:= pic.file_type;
       v_file_ext			:= pic.file_ext;
       v_remarks			:= pic.remarks;
       
       INSERT INTO GIPI_PICTURES(
         policy_id,       		 		item_no, 
         file_name, 					file_type, 
         file_ext, 						remarks, 
         user_id, 						last_update, 
         pol_file_name,                 create_user,    --added by Gzelle 04.02.2014 [create_user ]
         create_date)                                   --as per Batch Posting testcase
       VALUES ( 
         P_policy_id,					v_item,
         v_file,          				v_file_type,
         v_file_ext,					v_remarks,
         p_user_id,						TRUNC(SYSDATE),
         NULL,                          p_user_id,
         SYSDATE);

         v_item				:= NULL;
         v_file				:= NULL;
         v_file_type	:= NULL;
         v_file_ext		:= NULL;
         v_remarks		:= NULL;
       END LOOP;
    END IF;
END;
/



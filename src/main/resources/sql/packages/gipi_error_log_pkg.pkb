CREATE OR REPLACE PACKAGE BODY CPI.GIPI_ERROR_LOG_PKG
AS

    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 06.16.2010
	**  Reference By 	: (GIPIS195- Grouped Accident Uploading Module)
	**  Description 	: get the records in GIPI_ERROR_LOG per filename
	*/
  FUNCTION get_gipi_error_log (p_filename		 GIPI_ERROR_LOG.filename%TYPE)
    RETURN gipi_error_log_tab PIPELINED IS
	v_err    gipi_error_log_type;
  BEGIN
    FOR i IN (SELECT  upload_no, 		  		 filename,			  grouped_item_title,
		  	 		  sex,						 civil_status,		  date_of_birth,
					  age,   					 salary,	 		  salary_grade,
					  amount_coverage, 			 remarks,		 	  user_id,
					  last_update, 				 control_cd,	  	  control_type_cd,
					  grouped_item_no
           		FROM gipi_error_log a
			   WHERE a.filename = p_filename
               ORDER BY upload_no,grouped_item_no,grouped_item_title)
	LOOP
	  v_err.upload_no 						:= i.upload_no;
	  v_err.filename 						:= i.filename;
	  v_err.grouped_item_title 				:= i.grouped_item_title;
	  v_err.sex 							:= i.sex;
	  v_err.civil_status 					:= i.civil_status;
	  v_err.date_of_birth 					:= i.date_of_birth;
	  v_err.age 							:= i.age;
	  v_err.salary 							:= i.salary;
	  v_err.salary_grade 					:= i.salary_grade;
	  v_err.amount_coverage 				:= i.amount_coverage;
	  v_err.remarks 						:= i.remarks;
	  v_err.user_id 						:= i.user_id;
	  v_err.last_update 					:= i.last_update;
	  v_err.control_cd    			 		:= i.control_cd;
	  v_err.control_type_cd 		 		:= i.control_type_cd;
	  v_err.grouped_item_no					:= i.grouped_item_no;
	  PIPE ROW(v_err);
	END LOOP;
	RETURN;
  END;

    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 06.16.2010
	**  Reference By 	: (GIPIS195- Grouped Accident Uploading Module)
	**  Description 	: delete records in GIPI_ERROR_LOG
	*/
  PROCEDURE del_gipi_error_log IS
  BEGIN
  	   DELETE FROM gipi_error_log;
  END;

END;
/



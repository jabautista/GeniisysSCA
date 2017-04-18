CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wreqdocs_Pkg AS

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  March 3, 2010
**  Reference By : (GIPIS029 - Required Documents Submitted
**  Description  : This returns all documents submitted for a given par_id
*/
  FUNCTION get_wreqdocs_list(p_par_id 			GIPI_WREQDOCS.par_id%TYPE)
    RETURN gipi_wreqdocs_tab PIPELINED IS
	v_doc  					 gipi_wreqdocs_type;
  BEGIN
    FOR i IN (SELECT a.doc_cd, 		   a.par_id, 	a.doc_sw,      a.line_cd,
	 	  	 		 a.date_submitted, a.user_id, 	a.last_update, a.remarks,
	 				 b.doc_name
			    FROM GIPI_WREQDOCS a
				    ,GIIS_REQUIRED_DOCS b
			   WHERE a.par_id 			= p_par_id
			     AND b.doc_cd 			= a.doc_cd
				 AND b.line_cd			= a.line_cd
			   ORDER BY b.doc_name)
	LOOP
	  v_doc.doc_cd	 					:= i.doc_cd;
	  v_doc.par_id						:= i.par_id;
	  v_doc.doc_sw						:= i.doc_sw;
	  v_doc.line_cd						:= i.line_cd;
	  v_doc.date_submitted				:= i.date_submitted;
	  v_doc.user_id						:= i.user_id;
	  v_doc.last_update					:= i.last_update;
	  v_doc.remarks						:= i.remarks;
	  v_doc.doc_name					:= i.doc_name;
	  PIPE ROW(v_doc);
	END LOOP;
    RETURN;
  END;

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  March 5, 2010
**  Reference By : (GIPIS029 - Required Documents Submitted
**  Description  : This deletes a certain record with a certain par_id and doc_cd
*/
  Procedure delete_gipi_wreqdoc(p_par_id 			GIPI_WREQDOCS.par_id%TYPE
  							   ,p_doc_cd			GIPI_WREQDOCS.doc_cd%TYPE)
	IS
  BEGIN
    DELETE FROM GIPI_WREQDOCS
	 WHERE par_id   		 = p_par_id
  	   AND doc_cd  			 = p_doc_cd;
  END delete_gipi_wreqdoc;

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  March 5, 2010
**  Reference By : (GIPIS029 - Required Documents Submitted
**  Description  : This inserts or updates records
*/
  Procedure set_gipi_wreqdoc(p_wreqdoc	IN GIPI_WREQDOCS%ROWTYPE)
    IS
  BEGIN
  	   MERGE INTO GIPI_WREQDOCS
	   USING DUAL ON (par_id   = p_wreqdoc.par_id
	 	   		 AND doc_cd    = p_wreqdoc.doc_cd)
	   WHEN NOT MATCHED THEN
	   		INSERT ( doc_cd,         par_id,     doc_sw,      line_cd,
				     date_submitted, user_id, 	 remarks)
			VALUES ( p_wreqdoc.doc_cd,         p_wreqdoc.par_id,    p_wreqdoc.doc_sw, 		p_wreqdoc.line_cd,
				     p_wreqdoc.date_submitted, p_wreqdoc.user_id, 	p_wreqdoc.remarks)
		WHEN MATCHED THEN
	   	  UPDATE SET doc_sw  		=	  p_wreqdoc.doc_sw,
				     line_cd  		=	  p_wreqdoc.line_cd,
					 date_submitted	=	  p_wreqdoc.date_submitted,
					 user_id  		=	  p_wreqdoc.user_id,
					 remarks  		=	  p_wreqdoc.remarks;
  END set_gipi_wreqdoc;

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  March 08, 2010
**  Reference By : (GIPIS029 - Required Documents Submitted
**  Description  : This inserts or updates records
*/
  Procedure set_gipi_wreqdoc1(p_doc_cd	   	  IN GIPI_WREQDOCS.doc_cd%TYPE
  							,p_par_id	   	  IN GIPI_WREQDOCS.par_id%TYPE
							,p_doc_sw	   	  IN GIPI_WREQDOCS.doc_sw%TYPE
							,p_line_cd	   	  IN GIPI_WREQDOCS.line_cd%TYPE
							,p_date_submitted IN GIPI_WREQDOCS.date_submitted%TYPE
							,p_user_id		  IN GIPI_WREQDOCS.user_id%TYPE
							,p_remarks		  IN GIPI_WREQDOCS.remarks%TYPE)
    IS
  BEGIN
  	   MERGE INTO GIPI_WREQDOCS
	   USING DUAL ON (par_id   = p_par_id
	 	   		 AND doc_cd    = p_doc_cd)
	   WHEN NOT MATCHED THEN
	   		INSERT ( doc_cd,         par_id,     doc_sw,      line_cd,
				     date_submitted, user_id, 	 remarks)
			VALUES ( p_doc_cd,         p_par_id,    p_doc_sw, 		p_line_cd,
				     p_date_submitted, p_user_id, 	p_remarks)
		WHEN MATCHED THEN
	   	  UPDATE SET doc_sw  		=	  p_doc_sw,
				     line_cd  		=	  p_line_cd,
					 date_submitted	=	  p_date_submitted,
					 user_id  		=	  p_user_id,
					 remarks  		=	  p_remarks;
  END set_gipi_wreqdoc1;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.01.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure deletes record based on the given par_id
	*/
	Procedure DEL_GIPI_WREQDOCS (p_par_id IN GIPI_WREQDOCS.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_WREQDOCS
		 WHERE par_id = p_par_id;
	END DEL_GIPI_WREQDOCS;
END Gipi_Wreqdocs_Pkg;
/



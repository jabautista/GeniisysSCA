CREATE OR REPLACE PACKAGE BODY CPI.Giis_Assured_Intm_Pkg AS

  FUNCTION get_giis_assured_intm (p_assd_no				  GIIS_ASSURED_INTM.assd_no%TYPE)
    RETURN giis_assured_intm_tab PIPELINED IS
	
	v_intm 			giis_assured_intm_type;
	
  BEGIN
  	FOR i IN (
		SELECT a.assd_no, a.line_cd, a.intm_no, b.intm_name, a.user_id, a.last_update 
		  FROM GIIS_ASSURED_INTM a
		      ,GIIS_INTERMEDIARY b 
		 WHERE a.assd_no = p_assd_no
		   AND a.intm_no = b.intm_no)
	LOOP
		v_intm.assd_no		  := i.assd_no;
		v_intm.line_cd		  := i.line_cd;
		v_intm.intm_no		  := i.intm_no;
		v_intm.intm_name	  := i.intm_name;
		v_intm.user_id		  := i.user_id;
		v_intm.last_update	  := i.last_update;	
	  PIPE ROW (v_intm);
	END LOOP;
	RETURN;
  END get_giis_assured_intm;	


  PROCEDURE set_giis_assured_intm (
  	 p_assd_no				  IN  GIIS_ASSURED_INTM.assd_no%TYPE,
	 p_line_cd				  IN  GIIS_ASSURED_INTM.line_cd%TYPE,
	 p_intm_no				  IN  GIIS_ASSURED_INTM.intm_no%TYPE) IS
  BEGIN
   	 INSERT INTO GIIS_ASSURED_INTM 
	 		( assd_no,   line_cd,   intm_no )
	 VALUES ( p_assd_no, p_line_cd, p_intm_no );
	  
	 COMMIT;
  END set_giis_assured_intm;	   
  
  
  PROCEDURE del_giis_assured_intm (
     p_assd_no				  GIIS_ASSURED_INTM.assd_no%TYPE,
	 p_line_cd				  GIIS_ASSURED_INTM.line_cd%TYPE,
	 p_intm_no				  GIIS_ASSURED_INTM.intm_no%TYPE) IS
  BEGIN
     DELETE FROM GIIS_ASSURED_INTM
	  WHERE assd_no = p_assd_no 
	    AND line_cd = p_line_cd
		AND intm_no = p_intm_no;
	
	 COMMIT;	 
  END del_giis_assured_intm;

  
  PROCEDURE del_giis_assured_intm_all (
     p_assd_no				  GIIS_ASSURED_INTM.assd_no%TYPE) IS
  BEGIN
     DELETE FROM GIIS_ASSURED_INTM
	  WHERE assd_no = p_assd_no; 
	 COMMIT;	 
  END del_giis_assured_intm_all;
  
END Giis_Assured_Intm_Pkg;
/



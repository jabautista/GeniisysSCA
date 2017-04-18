CREATE OR REPLACE PACKAGE BODY CPI.Giis_Assured_Group_Pkg AS

  FUNCTION get_giis_assured_group (p_assd_no				  GIIS_ASSURED_GROUP.assd_no%TYPE)
    RETURN giis_assured_group_tab PIPELINED IS
	
	v_group			giis_assured_group_type;
	
  BEGIN
    FOR i IN (
		SELECT a.assd_no, a.group_cd, b.group_desc, a.remarks, a.user_id, a.last_update
		  FROM GIIS_ASSURED_GROUP a
		      ,GIIS_GROUP		  b
		 WHERE a.assd_no  = p_assd_no
		   AND a.group_cd = b.group_cd)
    LOOP
		v_group.assd_no			:= i.assd_no;
		v_group.group_cd		:= i.group_cd;
		v_group.group_desc		:= i.group_desc;
		v_group.remarks			:= i.remarks;
		v_group.user_id			:= i.user_id;
		v_group.last_update		:= i.last_update;	    
	  PIPE ROW(v_group);
	END LOOP;
	RETURN;
  END get_giis_assured_group;	

  
  PROCEDURE set_giis_assured_group (
  	 p_assd_no				  IN  GIIS_ASSURED_GROUP.assd_no%TYPE,
	 p_group_cd				  IN  GIIS_ASSURED_GROUP.group_cd%TYPE,
	 p_remarks				  IN  GIIS_ASSURED_GROUP.remarks%TYPE) IS
  BEGIN
    MERGE INTO GIIS_ASSURED_GROUP
	USING DUAL ON (assd_no  = p_assd_no
		  	   AND group_cd = p_group_cd)
	  WHEN NOT MATCHED THEN
	  	   INSERT ( assd_no,   group_cd,   remarks )
		   VALUES ( p_assd_no, p_group_cd, p_remarks )
	  WHEN MATCHED THEN
	  	   UPDATE SET remarks	= p_remarks;
		   
	COMMIT;
  END set_giis_assured_group;
	 
  PROCEDURE del_giis_assured_group (
     p_assd_no				  GIIS_ASSURED_GROUP.assd_no%TYPE,
	 p_group_cd				  GIIS_ASSURED_GROUP.group_cd%TYPE) IS 
  BEGIN
    DELETE FROM GIIS_ASSURED_GROUP
	 WHERE assd_no  = p_assd_no
 	   AND group_cd = p_group_cd;
	
	COMMIT;
  END del_giis_assured_group;


  PROCEDURE del_giis_assured_group_all (
     p_assd_no				  GIIS_ASSURED_GROUP.assd_no%TYPE) IS 
  BEGIN
    DELETE FROM GIIS_ASSURED_GROUP
	 WHERE assd_no  = p_assd_no;
	
	COMMIT;
  END del_giis_assured_group_all;
    
END Giis_Assured_Group_Pkg;
/



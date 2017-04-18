CREATE OR REPLACE PACKAGE BODY CPI.giis_principal_res_pkg
AS
   PROCEDURE save_giis_principal_res (
      p_principal_res_no      giis_principal_res.principal_res_no%TYPE,
      p_principal_res_date    giis_principal_res.principal_res_date%TYPE,
      p_principal_res_place   giis_principal_res.principal_res_place%TYPE,
	  p_control_type_cd   	  giis_principal_res.control_type_cd%TYPE,
      p_assd_no               giis_principal_res.assd_no%TYPE,
      p_user_id               giis_principal_res.user_id%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_principal_res
         USING DUAL
         ON (assd_no = p_assd_no)
         WHEN NOT MATCHED THEN
            INSERT (principal_res_no, principal_res_date,
                    principal_res_place, assd_no, user_id, last_update,
					control_type_cd) --added by steven 11/27/2012
            VALUES (p_principal_res_no, p_principal_res_date,
                    p_principal_res_place, p_assd_no, p_user_id, SYSDATE,
					p_control_type_cd) --added by steven 11/27/2012
         WHEN MATCHED THEN
            UPDATE
               SET principal_res_no = p_principal_res_no,
                   principal_res_date = p_principal_res_date,
                   principal_res_place = p_principal_res_place,
                   user_id = p_user_id, last_update = SYSDATE,
				   control_type_cd = p_control_type_cd --added by steven 11/27/2012
            ;
   END;
END giis_principal_res_pkg;
/



CREATE OR REPLACE PACKAGE CPI.giis_principal_res_pkg
AS
   PROCEDURE save_giis_principal_res (
      p_principal_res_no      giis_principal_res.principal_res_no%TYPE,
      p_principal_res_date    giis_principal_res.principal_res_date%TYPE,
      p_principal_res_place   giis_principal_res.principal_res_place%TYPE,
	  p_control_type_cd   	  giis_principal_res.control_type_cd%TYPE, --added by steven 11/27/2012
      p_assd_no   giis_principal_res.assd_no%TYPE,
      p_user_id               giis_principal_res.user_id%TYPE
   );
END giis_principal_res_pkg;
/



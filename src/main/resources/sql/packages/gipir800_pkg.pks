CREATE OR REPLACE PACKAGE CPI.GIPIR800_PKG AS 

  TYPE gipir800_type IS RECORD (
    company_name GIIS_PARAMETERS.param_value_v%TYPE,
    company_address GIIS_PARAMETERS.param_value_v%TYPE
  );

  TYPE gipir800_tab IS TABLE OF gipir800_type;
  
  FUNCTION populate_gipir800
    RETURN gipir800_tab PIPELINED;

  TYPE gipir800_details_type IS RECORD (
    B_ASSD_NO      giis_assured.assd_no%TYPE,
    B_ASSD_NAME    giis_assured.assd_name%TYPE,
    B_MAIL_ADDR1   VARCHAR2(155),
    B_RV_MEANING   cg_ref_codes.rv_meaning%TYPE
  );

  TYPE gipir800_details_tab IS TABLE OF gipir800_details_type;
  
  FUNCTION populate_gipir800_details
    RETURN gipir800_details_tab PIPELINED;  

END GIPIR800_PKG;
/



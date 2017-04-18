CREATE OR REPLACE PACKAGE CPI.GIPIR801_PKG AS 

  TYPE gipir801_type IS RECORD (
    company_name GIIS_PARAMETERS.param_value_v%TYPE,
    company_address GIIS_PARAMETERS.param_value_v%TYPE,
    line    VARCHAR(20)
  );

  TYPE gipir801_tab IS TABLE OF gipir801_type;
  
FUNCTION populate_gipir801
    RETURN gipir801_tab PIPELINED;

  TYPE gipir801_details_type IS RECORD (
    
    line_name          giis_line.line_name%TYPE,            
    company_name       GIIS_PARAMETERS.param_value_v%TYPE,
    company_address    GIIS_PARAMETERS.param_value_v%TYPE,
    peril_type         VARCHAR2(10),
    peril_cd           GIIS_PERIL.PERIL_CD%TYPE,
    peril_sname        GIIS_PERIL.PERIL_SNAME%TYPE,
    peril_name         GIIS_PERIL.PERIL_NAME%TYPE,
    ri_comm_rt         GIIS_PERIL.RI_COMM_RT%TYPE
  );

  TYPE gipir801_details_tab IS TABLE OF gipir801_details_type;
  
  FUNCTION populate_gipir801_details
    RETURN gipir801_details_tab PIPELINED;  

END GIPIR801_PKG;
/



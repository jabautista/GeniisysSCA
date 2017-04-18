CREATE OR REPLACE PACKAGE CPI.GIPIR924C_PKG 
AS

   TYPE report_type IS RECORD (
   	  dist_flag                 GIUW_POL_DIST.dist_flag%TYPE,
      rv_meaning                CG_REF_CODES.rv_meaning%TYPE,
      line_name                 GIIS_LINE.line_name%TYPE,
      subline_name              GIIS_SUBLINE.subline_name%TYPE,
      Pol_Endrsmnt              VARCHAR(60),
      issue_date                GIPI_POLBASIC.issue_date%TYPE,
      incept_date               GIPI_POLBASIC.incept_date%TYPE,
      assd_name                 GIIS_ASSURED.assd_name%TYPE,
      tsi_amt                   GIPI_POLBASIC.tsi_amt%TYPE,
      prem_amt                  GIPI_POLBASIC.prem_amt%TYPE,
      policy_id				    GIPI_POLBASIC.policy_id%TYPE,
      existing                  VARCHAR2(1)
                         
   );

   TYPE report_tab IS TABLE OF report_type;

   TYPE header_type IS RECORD (
      cf_company                VARCHAR2 (150),
      cf_company_addrs          VARCHAR2 (500),
      cf_run_date               VARCHAR2 (30)
   );

   TYPE header_tab IS TABLE OF header_type;	
 
    FUNCTION get_header_GIPIR924C (
          p_user_id   gipi_polbasic.user_id%TYPE
    )
    RETURN header_tab PIPELINED;
      
      
    FUNCTION populate_GIPIR924C (
          p_direct               NUMBER,
          p_ri                   NUMBER,
          p_iss_param            GIPI_POLBASIC.iss_cd%TYPE,
          p_iss_cd               GIPI_POLBASIC.iss_cd%TYPE,
          p_line_cd              GIPI_POLBASIC.line_cd%TYPE,
          p_user_id              GIIS_USERS.user_id%TYPE
    )
    RETURN report_tab PIPELINED;

 
    FUNCTION cf_co_nameFormula
        RETURN CHAR;


    FUNCTION cf_co_addFormula
        RETURN CHAR;

          
    FUNCTION cf_run_dateFormula
        RETURN CHAR; 
        
     FUNCTION exist(p_policy_id  GIPI_POLBASIC.policy_id%TYPE)
        RETURN VARCHAR2;


END GIPIR924C_PKG;
/



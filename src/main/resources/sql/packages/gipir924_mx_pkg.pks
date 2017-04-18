CREATE OR REPLACE PACKAGE CPI.GIPIR924_MX_PKG
AS
 
  TYPE report_type IS RECORD (
    assd_name                GIPI_UWREPORTS_INTM_EXT.assd_name%TYPE,
    line_cd                  GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
    line_name                GIPI_UWREPORTS_INTM_EXT.line_name%TYPE,
    subline_cd               GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
    subline_name             GIPI_UWREPORTS_INTM_EXT.subline_name%TYPE,
    iss_cd                   GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
    total_tsi                GIPI_UWREPORTS_INTM_EXT.total_tsi%TYPE,
    total_prem               GIPI_UWREPORTS_INTM_EXT.total_prem%TYPE,
    
    total                    NUMBER,
    total_taxes              NUMBER,
    commission               NUMBER,
    other_charges            GIPI_UWREPORTS_INTM_EXT.other_taxes%TYPE,

    polcount                 NUMBER,
    
    cf_iss_header            VARCHAR2(20),
    cf_iss_name              VARCHAR2(60),
    
    cf_heading3              VARCHAR2 (150),
    cf_company                  VARCHAR2 (150),
    cf_based_on              VARCHAR2 (200),
    cf_company_address       VARCHAR2 (500),
    
    show_total_taxes         VARCHAR2 (1)
   );

  TYPE report_tab IS TABLE OF report_type;
       
  FUNCTION populate_gipir924_mx(
    p_iss_param    GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
    p_iss_cd       GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
    p_scope        GIPI_UWREPORTS_INTM_EXT.SCOPE%TYPE,
    p_line_cd      GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
    p_subline_cd   GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
    p_assd_no      GIPI_UWREPORTS_INTM_EXT.assd_no%TYPE,
    p_intm_no       GIPI_UWREPORTS_INTM_EXT.intm_no%TYPE,
    p_user_id      GIPI_UWREPORTS_EXT.user_id%TYPE)
  RETURN report_tab PIPELINED;
  
  TYPE taxes_type IS RECORD (
--    assd_name                GIPI_UWREPORTS_INTM_EXT.assd_name%TYPE,
   line_cd                  GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
--    line_name                GIPI_UWREPORTS_INTM_EXT.line_name%TYPE,
   subline_cd               GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
--    subline_name             GIPI_UWREPORTS_INTM_EXT.subline_name%TYPE,
    iss_cd                   GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
--    total_tsi                GIPI_UWREPORTS_INTM_EXT.total_tsi%TYPE,
--    total_prem               GIPI_UWREPORTS_INTM_EXT.total_prem%TYPE,
     tax_name   VARCHAR2(3000),
     tax_amt    NUMBER,
     tax_cd     NUMBER
   );

  TYPE taxes_tab IS TABLE OF taxes_type;
       
  FUNCTION get_gipir924_mx_taxes(
    p_iss_param    GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
    p_iss_cd       GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
    p_scope        GIPI_UWREPORTS_INTM_EXT.SCOPE%TYPE,
    p_line_cd      GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
    p_subline_cd   GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
    p_assd_no      GIPI_UWREPORTS_INTM_EXT.assd_no%TYPE,
    p_intm_no       GIPI_UWREPORTS_INTM_EXT.intm_no%TYPE)
  RETURN taxes_tab PIPELINED;
END;
/



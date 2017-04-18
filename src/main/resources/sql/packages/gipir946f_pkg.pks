CREATE OR REPLACE PACKAGE CPI.gipir946f_pkg
AS
   /*
   **  Created by   :  Alvin Azarraga
   **  Date Created : 06.04.2012
   **  Reference By : GICLR037_RSIC
   **  Description  :
   */
   TYPE get_gipir946f_type IS RECORD (
      iss_cd         gipi_uwreports_ext.iss_cd%TYPE,
      line_cd        gipi_uwreports_ext.line_cd%TYPE,
      line_name      giis_line.line_name%TYPE,
      subline_cd     gipi_uwreports_ext.subline_cd%TYPE,
      intm_name      giis_intermediary.intm_name%TYPE,
      tsi_basic      gipi_uwreports_peril_ext.tsi_amt%TYPE,
      tsi_amt        gipi_uwreports_peril_ext.tsi_amt%TYPE,
      prem_amt       gipi_uwreports_peril_ext.prem_amt%TYPE,
      ref_intm_cd    giis_intermediary.ref_intm_cd%TYPE,
      subline_name   VARCHAR2 (100),
      iss_name       VARCHAR2 (100),
      iss_title      VARCHAR2 (100),
      ref_intm       VARCHAR2 (100),
      intm           VARCHAR2 (100)
   );

   TYPE get_gipir946f_tab IS TABLE OF get_gipir946f_type;

   TYPE populate_gipir946f_type IS RECORD (
      param_date        NUMBER (1),
      from_date         DATE,
      TO_DATE           DATE,
      heading3          VARCHAR2 (150),
      company_name      VARCHAR2 (150),
      company_address   VARCHAR2 (150),
      based_on          VARCHAR2 (100),
      SCOPE             NUMBER (1),
      policy_label      VARCHAR2 (200)
   );

   TYPE populate_gipir946f_tab IS TABLE OF populate_gipir946f_type;

   FUNCTION cf_iss_nameformula (p_iss_cd giis_issource.iss_cd%TYPE)
      RETURN CHAR;

   FUNCTION cf_iss_titleformula (p_iss_param VARCHAR2)
      RETURN CHAR;

   FUNCTION cf_subline_nameformula (
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_line_cd      giis_subline.line_cd%TYPE
   )
      RETURN CHAR;

   FUNCTION cf_ref_intmformula (p_intm_no giis_intermediary.intm_no%TYPE)
      RETURN CHAR;

   FUNCTION cf_intmformula (
      p_ref_intm_cd   giis_intermediary.ref_intm_cd%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_intm_name     giis_intermediary.intm_name%TYPE
   )
      RETURN CHAR;

   FUNCTION get_gipir946f (
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_iss_param    NUMBER,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN get_gipir946f_tab PIPELINED;

   FUNCTION populate_gipir946f (
        p_scope         gipi_uwreports_ext.SCOPE%TYPE,
        p_user_id       gipi_uwreports_ext.user_id%TYPE
   )
      RETURN populate_gipir946f_tab PIPELINED;
END gipir946f_pkg;
/



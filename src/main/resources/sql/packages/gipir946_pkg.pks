CREATE OR REPLACE PACKAGE CPI.gipir946_pkg   
AS
   TYPE get_data_type IS RECORD (
      iss_cd              gipi_uwreports_peril_ext.iss_cd%TYPE,
      line_cd             gipi_uwreports_peril_ext.line_cd%TYPE,
      line_name           gipi_uwreports_peril_ext.line_name%TYPE,
      subline_cd          gipi_uwreports_peril_ext.subline_cd%TYPE,
      subline_name        giis_subline.subline_name%TYPE,
      peril_cd            gipi_uwreports_peril_ext.peril_cd%TYPE,
      peril_name          gipi_uwreports_peril_ext.peril_name%TYPE,
      peril_type          gipi_uwreports_peril_ext.peril_type%TYPE,
      intm_no             gipi_uwreports_peril_ext.intm_no%TYPE,
      intm_name           gipi_uwreports_peril_ext.intm_name%TYPE,
      sumdecode           NUMBER (20, 2),
      sumtsi              NUMBER (20, 2),
      sumprem             NUMBER (20, 2),
      cf_new_commission   NUMBER (20, 2),
      cf_iss_name         VARCHAR2 (100),
      cf_iss_header       VARCHAR2 (100),
      cf_heading          VARCHAR2 (100),
      cf_company          VARCHAR2 (100),
      cf_com_address      giis_parameters.param_value_v%TYPE, -- VARCHAR2(100), changed by robert 01.02.14 
      cf_based_on         VARCHAR2 (100)
   );

   TYPE gipir946_dt_tab IS TABLE OF get_data_type;

   FUNCTION get_dt (
      p_scope        NUMBER,
      p_subline_cd   gipi_uwreports_peril_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_peril_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_peril_ext.iss_cd%TYPE,
      p_iss_param    NUMBER,
      p_user_id      gipi_uwreports_peril_ext.user_id%TYPE
   )
      RETURN gipir946_dt_tab PIPELINED;

   FUNCTION get_cf_commission (
      p_subline_cd   gipi_uwreports_peril_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_peril_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_peril_ext.iss_cd%TYPE,
      p_intm_no      gipi_uwreports_peril_ext.intm_no%TYPE,
      p_peril_cd     gipi_uwreports_peril_ext.peril_cd%TYPE,
      p_user_id      gipi_uwreports_peril_ext.user_id%TYPE
   )
      RETURN NUMBER;
END;
/



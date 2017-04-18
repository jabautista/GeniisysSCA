CREATE OR REPLACE PACKAGE CPI.gipir928e_pkg
AS
   TYPE report_type IS RECORD (
      iss_cd              gipi_uwreports_ext.iss_cd%TYPE,
      iss_cd_header       gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
      iss_name            giis_issource.iss_name%TYPE,
      line_cd             gipi_uwreports_dist_peril_ext.line_cd%TYPE,
      line_name           giis_line.line_name%TYPE,
      subline_cd          gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
      subline_name        giis_subline.subline_name%TYPE,
      fa_peril_prem       NUMBER,
      total_prem          NUMBER,
      total_tsi           NUMBER,
      fa_peril_tsi        NUMBER,
      company_name        VARCHAR2(200),
      company_addr        VARCHAR2(200),
      date_to             DATE,
      date_from           DATE,
      iss_header          VARCHAR2(50)
   );
   TYPE report_tab IS TABLE OF report_type;
   
   FUNCTION populate_gipir928e (
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN report_tab PIPELINED;
      
      
    TYPE rep_detail_type IS RECORD (
      iss_cd              gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
      line_cd             gipi_uwreports_dist_peril_ext.line_cd%TYPE,
      subline_cd          gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
      nr_peril_ts         gipi_uwreports_dist_peril_ext.nr_dist_tsi%TYPE,
      nr_peril_prem       gipi_uwreports_dist_peril_ext.nr_dist_prem%TYPE,
      share_cd            gipi_uwreports_dist_peril_ext.share_cd%TYPE,
      subline_name        giis_subline.subline_name%TYPE,
      trty_name           gipi_uwreports_dist_peril_ext.trty_name%TYPE
    );
    TYPE rep_detail_tab IS TABLE OF rep_detail_type;
   
    FUNCTION get_gipir928e_detail (
        p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_cd       gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
        p_line_cd      gipi_uwreports_dist_peril_ext.line_cd%TYPE,
        p_scope        gipi_uwreports_ext.SCOPE%TYPE,
        p_subline_cd   gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
        p_user_id      gipi_uwreports_dist_peril_ext.user_id%TYPE
    )
      RETURN rep_detail_tab PIPELINED;
   
END gipir928e_pkg;
/



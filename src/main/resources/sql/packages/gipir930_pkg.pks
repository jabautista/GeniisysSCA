CREATE OR REPLACE PACKAGE CPI.gipir930_pkg
AS
   /*
   **  Created by   :  Alvin Azarraga
   **  Date Created : 06.04.2012
   **  Reference By : GICLR037_RSIC
   **  Description  :
   */
   TYPE get_gipir930_type IS RECORD (
      assd_name         gipi_uwreports_ri_ext.assd_name%TYPE,
      line_cd           gipi_uwreports_ri_ext.line_cd%TYPE,
      subline_cd        gipi_uwreports_ri_ext.subline_cd%TYPE,
      iss_cd            gipi_uwreports_ri_ext.iss_cd%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      incept_date       gipi_uwreports_ri_ext.incept_date%TYPE,
      expiry_date       gipi_uwreports_ri_ext.expiry_date%TYPE,
      line_name         gipi_uwreports_ri_ext.line_name%TYPE,
      subline_name      gipi_uwreports_ri_ext.subline_name%TYPE,
      policy_no         gipi_uwreports_ri_ext.policy_no%TYPE,
      binder_no         gipi_uwreports_ri_ext.binder_no%TYPE,
      total_si          gipi_uwreports_ri_ext.total_si%TYPE,
      total_prem        gipi_uwreports_ri_ext.total_prem%TYPE,
      sum_reinsured     gipi_uwreports_ri_ext.sum_reinsured%TYPE,
      share_premium     gipi_uwreports_ri_ext.share_premium%TYPE,
      ri_comm_amt       gipi_uwreports_ri_ext.ri_comm_amt%TYPE,
      net_due           gipi_uwreports_ri_ext.net_due%TYPE,
      ri_short_name     gipi_uwreports_ri_ext.ri_short_name%TYPE,
      ri_cd             gipi_uwreports_ri_ext.ri_cd%TYPE,
      iss_cd_header     gipi_uwreports_ri_ext.iss_cd%TYPE,
      ri_prem_vat       gipi_uwreports_ri_ext.ri_prem_vat%TYPE,
      ri_comm_vat       gipi_uwreports_ri_ext.ri_comm_vat%TYPE,
      ri_wholding_vat   gipi_uwreports_ri_ext.ri_wholding_vat%TYPE,
      frps_line_cd      gipi_uwreports_ri_ext.frps_line_cd%TYPE,
      frps_yy           gipi_uwreports_ri_ext.frps_yy%TYPE,
      frps_seq_no       gipi_uwreports_ri_ext.frps_seq_no%TYPE,
      ri_premium_tax    gipi_uwreports_ri_ext.ri_premium_tax%TYPE,
      binder_count      NUMBER, -- apollo cruz 05.26.2015 AFPGEN-IMPLEM-SR 0004410 
      distinct_rec      VARCHAR2(1) -- to be used in jasper for proper display of records
   );

   TYPE get_gipir930_tab IS TABLE OF get_gipir930_type;

   TYPE populate_gipir930_type IS RECORD (
      company_name      VARCHAR2 (100),
      company_address   VARCHAR2(500),  --Halley 01.28.14
      heading3          VARCHAR2 (100),
      policy_label      VARCHAR2 (100)
   );

   TYPE populate_gipir930_tab IS TABLE OF populate_gipir930_type;

   FUNCTION get_gipir930 (
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    NUMBER,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN get_gipir930_tab PIPELINED;

   FUNCTION cf_sum_reinsuredformula (
      p_frps_line_cd   gipi_uwreports_ri_ext.frps_line_cd%TYPE,
      p_frps_yy        gipi_uwreports_ri_ext.frps_yy%TYPE,
      p_frps_seq_no    gipi_uwreports_ri_ext.frps_seq_no%TYPE,
      p_ri_cd          gipi_uwreports_ri_ext.ri_cd%TYPE
   )
      RETURN NUMBER;

   FUNCTION populate_gipir930 (
      p_scope          gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id        gipi_uwreports_ext.user_id%TYPE
   )
      RETURN populate_gipir930_tab PIPELINED;

   FUNCTION cf_iss_nameformula (p_iss_cd_header VARCHAR2)
      RETURN CHAR;
END gipir930_pkg;
/



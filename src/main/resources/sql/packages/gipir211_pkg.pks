CREATE OR REPLACE PACKAGE CPI.gipir211_pkg
AS
   TYPE gipir211_pkg_type IS RECORD (
      /*Q1*/
      policy_number        VARCHAR2 (100),
      policy_id            gipi_polbasic.policy_id%TYPE,
      assd_no              giis_assured.assd_no%TYPE,
      assd_name            giis_assured.assd_name%TYPE,
      acct_of_cd           gipi_polbasic.acct_of_cd%TYPE,
      acct_of_cd_sw        gipi_polbasic.acct_of_cd_sw%TYPE,
      eff_date             VARCHAR2 (50),
      acct_ent_date        VARCHAR2 (50),
      issue_date           VARCHAR2 (50),
      package_cd           giis_package_benefit.package_cd%TYPE,
      cf_policy_number     VARCHAR2 (200),
      cf_assured_name      VARCHAR2 (2000),
      cf_company_name      VARCHAR2 (60),
      cf_address           VARCHAR2 (250),
      cf_date_title        VARCHAR2 (100),
      cf_from_to_title     VARCHAR2 (100),
      cf_total             VARCHAR2 (100),
      cf_plan              VARCHAR2 (100),
      /*Q2*/
      control_cd           gipi_grouped_items.control_cd%TYPE,
      grouped_item_no      gipi_grouped_items.GROUPED_ITEM_NO%TYPE, -- added by marks sr5306 12.5.2016
      grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      endt_iss_cd          gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy              gipi_polbasic.endt_yy%TYPE,
      endt_seq_no          gipi_polbasic.endt_seq_no%TYPE,
      endt_no              VARCHAR2 (50),
      item_no              gipi_itmperil_grouped.item_no%TYPE,
      expiry_date          VARCHAR2 (50),
      eff_date2            VARCHAR2 (50),
      peril_sname          giis_peril.peril_sname%TYPE,
      tsi_amt              gipi_itmperil_grouped.tsi_amt%TYPE,
      prem_amt             gipi_itmperil_grouped.prem_amt%TYPE,
      delete_sw            gipi_grouped_items.delete_sw%TYPE,
      cf_endt              VARCHAR2 (20),
      cf_status            VARCHAR2 (20),
      peril_type           giis_peril.peril_type%TYPE,        -- -jhing 03.30.2016 GENQA 5036
      peril_comp_tsi       gipi_itmperil_grouped.tsi_amt%TYPE  -- -jhing 03.30.2016 GENQA 5036
   );

   TYPE gipir211_pkg_tab IS TABLE OF gipir211_pkg_type;

   FUNCTION get_gipir211_dtls_old (   -- -jhing 03.30.2016 GENQA 5036
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no     VARCHAR2,
      p_a_from       DATE,
      p_a_to         DATE,
      p_e_from       DATE,
      p_e_to         DATE,
      p_i_from       DATE,
      p_i_to         DATE,
      p_f            DATE,
      p_t            DATE,
      p_user_id      VARCHAR2
   )
      RETURN gipir211_pkg_tab PIPELINED;
      
   FUNCTION get_gipir211_dtls (  -- -jhing 03.30.2016 GENQA 5036
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no     VARCHAR2,
      p_a_from       DATE,
      p_a_to         DATE,
      p_e_from       DATE,
      p_e_to         DATE,
      p_i_from       DATE,
      p_i_to         DATE,
      p_f            DATE,
      p_t            DATE,
      p_user_id      VARCHAR2
   )
      RETURN gipir211_pkg_tab PIPELINED;      

   FUNCTION get_gipir211_endt_dtls (
      p_policy_id            VARCHAR2,
      p_control_cd           VARCHAR2,
      p_grouped_item_title   VARCHAR2
   )
      RETURN gipir211_pkg_tab PIPELINED;

   FUNCTION get_gipir211_peril_dtls (
      p_policy_id            VARCHAR2,
      p_control_cd           VARCHAR2,
      p_item_no              VARCHAR2,
      p_grouped_item_title   VARCHAR2
   )
      RETURN gipir211_pkg_tab PIPELINED;
END;
/



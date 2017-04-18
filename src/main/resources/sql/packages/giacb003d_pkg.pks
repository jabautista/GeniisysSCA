CREATE OR REPLACE PACKAGE CPI.GIACB003D_PKG
AS
   TYPE giacb003d_record_type IS RECORD (
      line_cd              VARCHAR2 (2),
      line_name            VARCHAR2 (20),
      subline_cd           giis_subline.subline_cd%TYPE,
      subline_name         giis_subline.subline_name%TYPE,
      policy_number        VARCHAR2 (50),
      assd_no              giis_assured.assd_no%TYPE,
      assured              VARCHAR2 (500),
      policy_id            gipi_polbasic.policy_id%TYPE,
      ri_cd                giis_reinsurer.ri_cd%TYPE,
      ri_name              giis_reinsurer.ri_name%TYPE,
      group_no             VARCHAR2 (200),
      frps_no              VARCHAR2 (200),
      dist_seq_no          NUMBER (5),
      dist_no              NUMBER (8),
      ri_prem_vat          giri_frperil.ri_prem_amt%TYPE,
      ri_comm_vat          giri_frperil.ri_comm_vat%TYPE,
      ri_wholding_vat      giri_frperil.ri_wholding_vat%TYPE,
      peril_cd             giis_peril.peril_cd%TYPE,
      peril_name           VARCHAR2 (100),
      tsi_amt              giri_frperil.ri_tsi_amt%TYPE,
      prem_amt             giri_frperil.ri_prem_amt%TYPE,
      comm_amt             giri_frperil.ri_comm_vat%TYPE,
      net_amt              giri_frperil.ri_prem_amt%TYPE,
      peril_type           giis_peril.peril_type%TYPE,
      basictsi_amt         giri_frperil.ri_tsi_amt%TYPE,
      cf_company_name      VARCHAR2 (500),
      cf_company_address   VARCHAR2 (500),
      top_date             VARCHAR2 (70),
      v_flag               VARCHAR2 (1)
   );

   TYPE giacb003d_record_tab IS TABLE OF giacb003d_record_type;

   FUNCTION get_giacb003d_record (p_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacb003d_record_tab PIPELINED;
      
   FUNCTION get_giacb003d_peril (p_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacb003d_record_tab PIPELINED;
END GIACB003D_PKG;
/



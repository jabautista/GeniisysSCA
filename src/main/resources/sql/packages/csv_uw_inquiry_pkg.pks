CREATE OR REPLACE PACKAGE CPI.csv_uw_inquiry_pkg
AS
   TYPE giuwr130_csv_type IS RECORD (
      policy_no                  VARCHAR2 (100),
      endt_no                    VARCHAR2 (50),
      line_cd                    VARCHAR2 (50),
      subline_cd                 VARCHAR2 (50),
      iss_cd                     VARCHAR2 (50),
      policy_eff_date            VARCHAR2 (50),
      distribution_eff_date      VARCHAR2 (50),
      policy_expiry_date         VARCHAR2 (50),
      distribution_expiry_date   VARCHAR2 (50),
      status                     VARCHAR2 (100),
      dist_no                    VARCHAR2 (50),
      dist_seq_no                VARCHAR2 (50),
      sum_insured                giuw_policyds.tsi_amt%TYPE,
      prem_amt                   giuw_policyds.prem_amt%TYPE,
      currency                   giis_currency.currency_desc%TYPE,
      currency_rate              gipi_invoice.currency_rt%TYPE,
      distribution_share         VARCHAR2 (100),
      tsi_share_pct              giuw_policyds_dtl.dist_spct%TYPE,
      dist_tsi_amt               giuw_policyds_dtl.dist_tsi%TYPE,
      prem_share_pct             giuw_policyds_dtl.dist_spct1%TYPE,
      dist_prem_amt              giuw_policyds_dtl.dist_prem%TYPE
   );

   TYPE giuwr130_csv_tab IS TABLE OF giuwr130_csv_type;

   FUNCTION get_giuwr130 (
      p_dist_flag   giuw_pol_dist.dist_no%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giuwr130_csv_tab PIPELINED;
END; 
/


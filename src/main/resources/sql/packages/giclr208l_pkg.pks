CREATE OR REPLACE PACKAGE CPI.giclr208l_pkg
AS
   TYPE report_type IS RECORD (
      company_name       VARCHAR2 (200),
      company_address    VARCHAR2 (200),
      intm_no            VARCHAR2 (10),
      intm_name          VARCHAR2 (200),
      branch             VARCHAR2 (100),
      line_cd            VARCHAR2 (10),
      line               VARCHAR2 (100),
      claim_number       VARCHAR2 (100),
      policy_number      VARCHAR2 (100),
      assd_name          VARCHAR2 (500),
      intm_ri            VARCHAR2 (1000),
      eff_date           DATE,
      expiry_date        DATE,
      loss_date          DATE,
      clm_file_date      DATE,
      loss_cat_desc      VARCHAR2 (100),
      loss_location      VARCHAR2 (200),
      item               VARCHAR2 (200),
      peril              VARCHAR2 (200),
      tsi_amt            NUMBER (16, 2),
      clm_stat_desc      VARCHAR2 (100),
      outstanding_loss   NUMBER (16, 2),
      share_type2        NUMBER (16, 2),
      share_type3        NUMBER (16, 2),
      share_type1        NUMBER (16, 2),
      share_type4        NUMBER (16, 2),
      pol_iss_cd         VARCHAR2 (1000),
      date_as_of        VARCHAR2(100),
      date_from         VARCHAR2(100),
      date_to           VARCHAR2(100),
      exist             VARCHAR2(1)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr208l_report (
      p_session_id   NUMBER,
      p_claim_id     NUMBER,
      p_intm_break   NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to     VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/



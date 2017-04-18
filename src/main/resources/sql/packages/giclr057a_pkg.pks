CREATE OR REPLACE PACKAGE CPI.GICLR057A_PKG
AS
   TYPE giclr057a_type IS RECORD (
      claim_id          NUMBER(12),
      catastrophic_cd   NUMBER(5),
      catastrophic_desc VARCHAR2(100),
      claim_no          VARCHAR2(40),
      line_cd           VARCHAR2(2),
      loss_cat_cd       VARCHAR2(2),
      loss_cat          VARCHAR2(30),
      policy_no         VARCHAR2(40),
      assured_name      VARCHAR2(500),
      ldate             VARCHAR2(20),
      in_hou_adj        VARCHAR2(8),    
      clm_stat_cd       VARCHAR2(2),
      clm_stat          VARCHAR2(50),
      location          VARCHAR2(500),
      res_amt           NUMBER(16,2),
      pd_amt            NUMBER(16,2),
      net_res_amt       NUMBER(16,2),
      net_pd_amt        NUMBER(16,2),
      facul_res_amt     NUMBER(16,2),
      facul_pd_amt      NUMBER(16,2),
      pts_res_amt       NUMBER(16,2),
      pts_pd_amt        NUMBER(16,2),
      npts_res_amt      NUMBER(16,2),
      npts_pd_amt       NUMBER(16,2),
      param_cat         VARCHAR2(50),
      param_loss_cat    VARCHAR2(50),
      param_iss         VARCHAR2(50),
      param_block       VARCHAR2(50),
      param_district    VARCHAR2(100),
      param_city        VARCHAR2(100),
      param_province    VARCHAR2(100)
   );
   
   TYPE giclr057a_tab IS TABLE OF giclr057a_type;
   
   FUNCTION get_giclr057a(
        p_catastrophic_cd   VARCHAR2,
        p_loss_cat_cd       VARCHAR2,
        p_iss_cd            VARCHAR2,
        p_location          VARCHAR2,
        p_block_no          VARCHAR2,
        p_district_no       VARCHAR2,
        p_city_cd           VARCHAR2,
        p_province_cd       VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2
   )
   RETURN giclr057a_tab PIPELINED;
   
   TYPE giclr057_header_type IS RECORD(
       company_name        VARCHAR2(100),
       company_address     VARCHAR2(250)
   );
    
   TYPE giclr057_header_tab IS TABLE OF giclr057_header_type;
    
   FUNCTION get_giclr057_header
    RETURN giclr057_header_tab PIPELINED;
    
    
END;
/



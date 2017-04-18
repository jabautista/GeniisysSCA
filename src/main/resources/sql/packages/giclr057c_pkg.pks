CREATE OR REPLACE PACKAGE CPI.GICLR057C_PKG
AS
   TYPE giclr057c_type IS RECORD (
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
      province_cd       VARCHAR2(6),
      province          VARCHAR2(400),
      city_cd           VARCHAR2(6),
      city              VARCHAR2(40),
      district_no       VARCHAR2(6),
      district_desc     VARCHAR2(40),
      block_no          VARCHAR2(6),
      block_desc        VARCHAR2(40),
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
      param_iss         VARCHAR2(50)
   );
   
   TYPE giclr057c_tab IS TABLE OF giclr057c_type;
   
   FUNCTION get_giclr057c(
        p_line_cd           VARCHAR2,
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
   RETURN giclr057c_tab PIPELINED;
   
END;
/



CREATE OR REPLACE PACKAGE CPI.GICLR208LR_PKG
AS 
   TYPE get_giclr208lr_report_type IS RECORD (
      company_name          giac_parameters.param_value_v%TYPE,
      company_address       giac_parameters.param_value_v%TYPE,
      report_title          VARCHAR(100),
      cf_param_date         VARCHAR(100),
      cf_date               VARCHAR(100),
      intm_name             VARCHAR(250),
      intm_no               gicl_res_brdrx_extr.intm_no%TYPE,
      iss_name              giis_issource.iss_name%TYPE,
      iss_cd                gicl_res_brdrx_extr.iss_cd%TYPE,
      line_cd               gicl_res_brdrx_extr.line_cd%TYPE,
      line_name             giis_line.line_name%TYPE,
      claim_no              gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no             gicl_res_brdrx_extr.policy_no%TYPE,      
      assd_name             giis_assured.assd_name%TYPE,
      intm_ri               VARCHAR2(1000),
      eff_date              gicl_claims.pol_eff_date%TYPE,
      expiry_date           gicl_claims.expiry_date%TYPE,
      loss_date             gicl_res_brdrx_extr.loss_date%TYPE,
      clm_file_date         gicl_res_brdrx_extr.clm_file_date%TYPE,
      cf_loss_ctgry         giis_loss_ctgry.loss_cat_des%TYPE,
      location              VARCHAR2(250),
      item_name             VARCHAR2(200),
      peril_name            giis_peril.peril_name%TYPE,
      tsi_amt               gicl_res_brdrx_extr.tsi_amt%TYPE,
      claim_status          giis_clm_stat.clm_stat_desc%TYPE,
      outstanding_loss      NUMBER(16,2),
      cf_share_type1        NUMBER(16,2),
      cf_share_type2        NUMBER(16,2),
      cf_share_type3        NUMBER(16,2),
      cf_share_type4        NUMBER(16,2),
      recoverable           NUMBER(16,2),
      exist                 VARCHAR2(1) 
   );
   TYPE get_giclr208lr_report_tab IS TABLE OF get_giclr208lr_report_type; 
    
    FUNCTION get_giclr208lr_report(
        p_intm_break    NUMBER,
        p_os_date       NUMBER,
        p_date_option   NUMBER,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_session_id    VARCHAR2, 
        p_claim_id      VARCHAR2
    ) 
    RETURN get_giclr208lr_report_tab PIPELINED;    
END;
/



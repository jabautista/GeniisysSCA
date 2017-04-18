CREATE OR REPLACE PACKAGE CPI.giclr274a_pkg
IS
   TYPE giclr274a_detail_type IS RECORD (
      package_policy_no     VARCHAR2(50),
      policy_no             VARCHAR2(50),
      claim_no              VARCHAR2(50),
      assd_no               gicl_claims.assd_no%TYPE,
      assured_name          gicl_claims.assured_name%TYPE,
      dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
      clm_file_date         gicl_claims.clm_file_date%TYPE,
      clm_stat_desc         giis_clm_stat.clm_stat_desc%TYPE,
      loss_res_amt          gicl_claims.loss_res_amt%TYPE,
      exp_res_amt           gicl_claims.exp_res_amt%TYPE,
      loss_pd_amt           gicl_claims.loss_pd_amt%TYPE,
      exp_pd_amt            gicl_claims.exp_pd_amt%TYPE,
      date_type             VARCHAR2(100),
      company_name          giis_parameters.param_value_v%TYPE,
      company_address       giis_parameters.param_value_v%TYPE
   );

   TYPE giclr274a_detail_tab IS TABLE OF giclr274a_detail_type;
   
   FUNCTION get_giclr274a_detail(
      p_line_cd             gipi_pack_polbasic.line_cd%TYPE,
      p_subline_cd          gipi_pack_polbasic.subline_cd%TYPE,
      p_pol_iss_cd          gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy            gipi_pack_polbasic.issue_yy%TYPE,
      p_pol_seq_no          gipi_pack_polbasic.pol_seq_no%TYPE,
      p_renew_no            gipi_pack_polbasic.renew_no%TYPE,      
      p_from_date           VARCHAR2,
      p_to_date             VARCHAR2,
      p_as_of_date          VARCHAR2,
      p_from_ldate          VARCHAR2,
      p_to_ldate            VARCHAR2,
      p_as_of_ldate         VARCHAR2
   ) RETURN giclr274a_detail_tab PIPELINED;
END giclr274a_pkg;
/



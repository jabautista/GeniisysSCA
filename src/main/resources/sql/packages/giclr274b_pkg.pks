CREATE OR REPLACE PACKAGE CPI.giclr274b_pkg
IS
   TYPE giclr274b_detail_type IS RECORD (
      package_policy_no     VARCHAR2(50),
      claim_no              VARCHAR2(50),
      policy_no             VARCHAR2(50),
      dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
      assured_name          gicl_claims.assured_name%TYPE,
      rec_no                VARCHAR2(50),
      cancel_tag            gicl_clm_recovery.cancel_tag%TYPE,
      rec_stat              VARCHAR2(20),
      rec_type_cd           gicl_clm_recovery.rec_type_cd%TYPE,
      rec_type_desc         giis_recovery_type.rec_type_desc%TYPE,
      recoverable_amt       gicl_clm_recovery.recoverable_amt%TYPE,
      recovered_amt         gicl_clm_recovery.recovered_amt%TYPE,
      lawyer_cd             gicl_clm_recovery.lawyer_cd%TYPE,
      payor_cd              gicl_recovery_payor.payor_cd%TYPE,
      payor_class_cd        gicl_recovery_payor.payor_class_cd%TYPE,
      payor                 VARCHAR2(600),
      payr_rec_amt          gicl_recovery_payor.recovered_amt%TYPE,
      date_type             VARCHAR2(100),
      company_name          giis_parameters.param_value_v%TYPE,
      company_address       giis_parameters.param_value_v%TYPE
   );

   TYPE giclr274b_detail_tab IS TABLE OF giclr274b_detail_type;
   
   FUNCTION get_giclr274b_detail(
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
   ) RETURN giclr274b_detail_tab PIPELINED;
   
END giclr274b_pkg;
/



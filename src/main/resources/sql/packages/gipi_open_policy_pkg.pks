CREATE OR REPLACE PACKAGE CPI.gipi_open_policy_pkg
AS
   TYPE endtseq0_open_policy_type IS RECORD (
      policy_id         gipi_open_policy.policy_id%TYPE,
      line_cd           gipi_open_policy.line_cd%TYPE,
      op_iss_cd         gipi_open_policy.op_iss_cd%TYPE,
      op_issue_yy       gipi_open_policy.op_issue_yy%TYPE,
      op_pol_seqno      gipi_open_policy.op_pol_seqno%TYPE,
      op_subline_cd     gipi_open_policy.op_subline_cd%TYPE,
      op_renew_no       gipi_open_policy.op_renew_no%TYPE,
      decltn_no         gipi_open_policy.decltn_no%TYPE,
      eff_date          gipi_open_policy.eff_date%TYPE,
      ref_open_pol_no   gipi_polbasic.ref_open_pol_no%TYPE
   );

   TYPE endtseq0_open_policy_tab IS TABLE OF endtseq0_open_policy_type;
   
   TYPE open_policy_type IS RECORD(
      policy_id         gipi_polbasic.policy_id%TYPE,
      line_cd           gipi_open_policy.line_cd%TYPE,
      op_iss_cd         gipi_open_policy.op_iss_cd%TYPE,
      op_issue_yy       gipi_open_policy.op_issue_yy%TYPE,
      op_pol_seq_no     gipi_open_policy.op_pol_seqno%TYPE,
      op_subline_cd     gipi_open_policy.op_subline_cd%TYPE,
      op_renew_no       gipi_open_policy.op_renew_no%TYPE,
      policy_no         VARCHAR2(100),
      incept_date       VARCHAR2(20), --gipi_polbasic.incept_date%TYPE
      expiry_date       VARCHAR2(20),
      assd_no           gipi_polbasic.assd_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      cred_branch       gipi_polbasic.cred_branch%TYPE,
      limit_liability   gipi_open_liab.limit_liability%TYPE,
      tsi_amt           GIPI_POLBASIC.TSI_AMT%TYPE,
      prem_amt          GIPI_POLBASIC.PREM_AMT%TYPE
   );
   
   TYPE open_policy_tab IS TABLE OF open_policy_type;

   FUNCTION get_endtseq0_open_policy (
      p_policy_endtseq0   gipi_polbasic.policy_id%TYPE
   )
      RETURN endtseq0_open_policy_tab PIPELINED;      
      
   -- for gipis199
   FUNCTION get_open_policy_lov(
        p_line_cd           gipi_open_policy.line_cd%TYPE,
        p_op_subline_cd     gipi_open_policy.op_subline_cd%TYPE,
        p_op_iss_cd         gipi_open_policy.op_iss_cd%TYPE,
        p_op_issue_yy       gipi_open_policy.op_issue_yy%TYPE,
        p_op_pol_seq_no     gipi_open_policy.op_pol_seqno%TYPE,
        p_op_renew_no       gipi_open_policy.op_renew_no%TYPE, 
        p_cred_branch       gipi_polbasic.cred_branch%TYPE,
        p_user_id           gipi_polbasic.user_id%TYPE,
        p_incept_date       VARCHAR2,
        p_expiry_date       VARCHAR2
   ) RETURN open_policy_tab PIPELINED;
   
   FUNCTION get_open_policy_list(
        p_line_cd           gipi_open_policy.line_cd%TYPE,
        p_op_subline_cd     gipi_open_policy.op_subline_cd%TYPE,
        p_op_iss_cd         gipi_open_policy.op_iss_cd%TYPE,
        p_op_issue_yy       gipi_open_policy.op_issue_yy%TYPE,
        p_op_pol_seq_no     gipi_open_policy.op_pol_seqno%TYPE,
        p_op_renew_no       gipi_open_policy.op_renew_no%TYPE, 
        p_cred_branch       gipi_polbasic.cred_branch%TYPE,
        p_user_id           gipi_polbasic.user_id%TYPE
   ) RETURN open_policy_tab PIPELINED;
   
   TYPE open_liab_fi_mn_type IS RECORD (
      policy_id         gipi_polbasic.policy_id%TYPE,
      geog_cd           gipi_open_liab.geog_cd%TYPE,
      geog_desc         giis_geog_class.geog_desc%TYPE,
      currency_cd       gipi_open_liab.currency_cd%TYPE,
      currency_desc     giis_currency.currency_desc%TYPE,
      limit_liability   gipi_open_liab.limit_liability%TYPE,
      currency_rt       gipi_open_liab.currency_rt%TYPE,
      voy_limit         gipi_open_liab.voy_limit%TYPE,
      with_invoice_tag  gipi_open_liab.with_invoice_tag%TYPE
   );
   
   TYPE open_liab_fi_mn_tab IS TABLE OF open_liab_fi_mn_type;
   
   FUNCTION get_open_liab_fi_mn (
      p_policy_id VARCHAR2
   )
      RETURN open_liab_fi_mn_tab PIPELINED;
      
   TYPE open_cargo_type IS RECORD (
      cargo_class_cd    gipi_open_cargo.cargo_class_cd%TYPE,
      cargo_class_desc  giis_cargo_class.cargo_class_desc%TYPE
   );
   
   TYPE open_cargo_tab IS TABLE OF open_cargo_type;
   
   FUNCTION get_open_cargos (
      p_policy_id VARCHAR2,
      p_geog_cd   VARCHAR2
   )
      RETURN open_cargo_tab PIPELINED;
      
   TYPE open_peril_type IS RECORD (
      peril_name        giis_peril.peril_name%TYPE,
      prem_rate         gipi_open_peril.prem_rate%TYPE,
      remarks           gipi_open_peril.remarks%TYPE,
      with_invoice_tag  gipi_open_peril.with_invoice_tag%TYPE
   );
   
   TYPE open_peril_tab IS TABLE OF open_peril_type;
   
   FUNCTION get_open_perils (
      p_policy_id VARCHAR2,
      p_geog_cd   VARCHAR2
   )
      RETURN open_peril_tab PIPELINED;
      
END gipi_open_policy_pkg;
/



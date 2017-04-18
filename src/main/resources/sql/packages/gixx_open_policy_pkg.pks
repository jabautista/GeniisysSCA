CREATE OR REPLACE PACKAGE CPI.GIXX_OPEN_POLICY_PKG AS

  FUNCTION get_open_policy_no(p_extract_id    GIXX_OPEN_POLICY.extract_id%TYPE)
    RETURN VARCHAR2;
    
    
  -- added by Kris 03.11.2013 for GIPIS101
  TYPE open_policy_type IS RECORD (
    extract_id          gixx_open_policy.extract_id%TYPE,
    line_cd             gixx_open_policy.line_cd%TYPE,
    op_subline_cd       gixx_open_policy.op_subline_cd%TYPE,
    op_iss_cd           gixx_open_policy.op_iss_cd%TYPE,
    op_issue_yy         gixx_open_policy.op_issue_yy%TYPE,
    op_pol_seqno        gixx_open_policy.op_pol_seqno%TYPE,
    op_renew_no         gixx_open_policy.op_renew_no%TYPE,
    decltn_no           gixx_open_policy.decltn_no%TYPE,
    eff_date            gixx_open_policy.eff_date%TYPE,
    ref_open_pol_no     gipi_polbasic.ref_open_pol_no%TYPE,
    policy_id           gixx_open_policy.policy_id%TYPE
  );
  
  TYPE open_policy_tab IS TABLE OF open_policy_type;
  
  FUNCTION get_open_policy(
    p_extract_id    gixx_open_policy.extract_id%TYPE
  ) RETURN open_policy_tab PIPELINED;
  -- end 03.11.2013: for GIPIS101
    

END GIXX_OPEN_POLICY_PKG;
/



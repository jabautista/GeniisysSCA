DROP FUNCTION CPI.GET_MAX_INST_NO;

CREATE OR REPLACE FUNCTION CPI.GET_MAX_INST_NO (
   p_iss_cd    giac_dcb_users.gibr_fund_cd%TYPE
  ,p_prem_seq_no  giac_dcb_users.gibr_branch_cd%TYPE
  ) RETURN NUMBER AS
  v_inst_no number;
  BEGIN
    SELECT MAX (INST_NO)
   INTO v_inst_no
   FROM giac_direct_prem_collns
  WHERE b140_iss_cd = p_iss_cd
    AND b140_prem_seq_no = p_prem_seq_no;
  return (v_inst_no);
  END;
/



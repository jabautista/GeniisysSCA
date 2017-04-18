DROP PROCEDURE CPI.COMPUTE_PROPOSAL1;

CREATE OR REPLACE PROCEDURE CPI.compute_proposal1 (v_line_cd varchar2,v_subline_cd varchar2, v_iss_cd varchar2,v_quotation_yy number,v_quotation_no number,v_proposal_no1 OUT NUMBER) IS
BEGIN
  SELECT max(proposal_no)
    INTO v_proposal_no1
    FROM gipi_quote
   WHERE line_cd      = v_line_cd
    AND subline_cd   = v_subline_cd
     AND iss_cd       = v_iss_cd
     AND quotation_yy = v_quotation_yy
     AND quotation_no = v_quotation_no;
  v_proposal_no1 := v_proposal_no1 + 1;
 
END;
/



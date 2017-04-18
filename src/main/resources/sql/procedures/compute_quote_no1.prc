DROP PROCEDURE CPI.COMPUTE_QUOTE_NO1;

CREATE OR REPLACE PROCEDURE CPI.compute_quote_no1 (v_line_cd varchar2,v_subline_cd varchar2, v_iss_cd varchar2,v_quotation_yy number,v_proposal_no number,v_quotation_no OUT NUMBER) IS
BEGIN
  SELECT max(quotation_no)
    INTO v_quotation_no
    FROM gipi_quote
      WHERE line_cd      = v_line_cd
     AND subline_cd   = v_subline_cd
     AND iss_cd       = v_iss_cd
     AND quotation_yy = v_quotation_yy
     AND proposal_no = v_proposal_no;
  v_quotation_no := v_quotation_no + 1;  
END;
/



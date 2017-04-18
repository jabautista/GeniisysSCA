DROP PROCEDURE CPI.PRE_COMMIT_A_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Pre_Commit_A_Gipis002
   (b240_par_id IN NUMBER,
    v_exist IN OUT VARCHAR2,
    v_line_cd OUT VARCHAR2,
    v_op_subline_cd OUT VARCHAR2,
    v_op_iss_cd OUT VARCHAR2,
    v_op_issue_yy OUT NUMBER,
    v_op_pol_seqno OUT NUMBER,
    v_op_renew_no OUT NUMBER) IS
	v_exist2   VARCHAR2(1) := 'N';   
BEGIN
  FOR c1 IN (SELECT line_cd , op_subline_cd , op_iss_cd ,
                    op_issue_yy , op_pol_seqno, op_renew_no --issa07.09.2007
               FROM GIPI_WOPEN_POLICY
              WHERE par_id = b240_par_id)
  LOOP
    v_exist2 := 'Y';
    v_line_cd       := c1.line_cd;
    v_op_subline_cd := c1.op_subline_cd;
    v_op_iss_cd     := c1.op_iss_cd; 
    v_op_issue_yy   := c1.op_issue_yy;
    v_op_pol_seqno  := c1.op_pol_seqno;
    v_op_renew_no   := c1.op_renew_no; --issa07.09.2007
  EXIT;
  END LOOP;
  v_exist := v_exist2;
END;
/



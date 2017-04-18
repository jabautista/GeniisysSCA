DROP FUNCTION CPI.GET_DCB_FLAG;

CREATE OR REPLACE FUNCTION CPI.get_dcb_flag (
		 	 p_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
   			 p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
   			 p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
			 p_or_date                      varchar2
			 
		 )		 
 RETURN VARCHAR2 IS
  v_dcb_flag   giac_colln_batch.dcb_flag%TYPE;
BEGIN
  BEGIN
    SELECT dcb_flag
      INTO v_dcb_flag
      FROM giac_colln_batch
     WHERE fund_cd   = p_gibr_gfun_fund_cd
       AND branch_cd = p_gibr_branch_cd
       AND dcb_year  = TO_NUMBER(TO_CHAR( to_date(p_or_date,'MM-DD-YYYY'), 'YYYY'))
       AND dcb_no    = p_dcb_no;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_dcb_flag := 'O';
  END;

  RETURN v_dcb_flag;
END;
/



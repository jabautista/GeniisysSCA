DROP PROCEDURE CPI.VALIDATE_GIACS035_DCB_NO_1;

CREATE OR REPLACE PROCEDURE CPI.validate_giacs035_dcb_no_1 (p_gfun_fund_cd		   IN     GIAC_COLLN_BATCH.fund_cd%TYPE,
		   						    p_gibr_branch_cd	   					   IN	  GIAC_COLLN_BATCH.branch_cd%TYPE,
									p_dcb_date			   					   IN	  VARCHAR2,
									p_dcb_year			   					   IN	  GIAC_COLLN_BATCH.dcb_year%TYPE,
									p_dcb_no			   					   IN	  GIAC_COLLN_BATCH.dcb_no%TYPE,
									p_var_all_ors_r_cancelled	   			   IN OUT VARCHAR2,
									p_message			      				      OUT VARCHAR2)
IS
  /*
  **  Created by   :  Emman
  **  Date Created :  03.31.2011
  **  Reference By : (GIACS035 - Close DCB)
  **  Description  : Validates the DCB_NO field
  */
BEGIN
  /* VALIDATE_DCB_NO **/
  DECLARE
  	  v_exists   VARCHAR2(1) := 'N';
  BEGIN
	  FOR b IN (SELECT A.dcb_no
	              FROM giac_colln_batch A 
	              WHERE A.dcb_no = p_dcb_no
	              AND A.dcb_year = p_dcb_year 
	              AND A.branch_cd = p_gibr_branch_cd
	              AND A.fund_cd = p_gfun_fund_cd 
	              AND A.dcb_flag IN ('O', 'X')
	              AND A.dcb_no NOT IN 
	                (SELECT GACC.tran_class_no
	                   FROM giac_acctrans GACC
	                   WHERE GACC.tran_class = 'CDC'
	                   AND GACC.gfun_fund_cd = p_gfun_fund_cd
	                   AND GACC.gibr_branch_cd = p_gibr_branch_cd
	                   --AND TO_CHAR(GACC.tran_date,'MM-DD-RRRR') = TO_CHAR(p_dcb_date,'MM-DD-RRRR')
					   AND TO_CHAR(GACC.tran_date,'MM-DD-RRRR') = p_dcb_date
	                   AND GACC.tran_year = p_dcb_year
	                   AND GACC.tran_flag <> 'D'))
	  LOOP
	    v_exists := 'Y';
	    EXIT;
	  END LOOP;
	     
	  IF v_exists = 'N' THEN
	    --p_dcb_no := :CONTROL.prev_dcb_no;
	    --msg_alert('Invalid DCB No.', 'I', TRUE);
		p_message := 'INVALID_DCB_NO';
		RETURN;
	  END IF;
  END;
  /* end of VALIDATE_DCB_NO procedure **/
  
  /* CHECK_IF_ALL_ORs_R_CANCELLED **/
  DECLARE
  	v_or_flag VARCHAR2(1); --to store the selected or_flag
  BEGIN
  	FOR A IN (SELECT or_flag
	            FROM giac_order_of_payts GIOP, giac_collection_dtl GCDL
	           WHERE 1=1
	             AND GIOP.gacc_tran_id = GCDL.gacc_tran_id
	             AND (GIOP.dcb_no = p_dcb_no OR  
	                  (GCDL.due_dcb_no = p_dcb_no AND
	                   TRUNC(GCDL.due_dcb_date) =  p_dcb_date))  
	             AND GIOP.gibr_gfun_fund_cd = p_gfun_fund_cd 
	             AND GIOP.gibr_branch_cd = p_gibr_branch_cd 
	             AND GIOP.or_flag IS NOT NULL            
	             AND (TO_CHAR(GIOP.or_date,'MM-DD-RRRR') = TO_CHAR(p_dcb_date,'MM-DD-RRRR')
	             OR TRUNC(GCDL.due_dcb_date) =  p_dcb_date)
	           MINUS
	    	  SELECT or_flag
	            FROM giac_order_of_payts GIOP, giac_collection_dtl GCDL
	           WHERE 1=1
	             AND GIOP.gacc_tran_id = GCDL.gacc_tran_id
	             AND GIOP.or_flag = 'C' 
	             AND (GIOP.dcb_no = p_dcb_no OR                                   
	                  (GCDL.due_dcb_no = p_dcb_no AND
	                   TRUNC(GCDL.due_dcb_date) =  p_dcb_date))
	             AND GIOP.gibr_gfun_fund_cd = p_gfun_fund_cd 
	             AND GIOP.gibr_branch_cd = p_gibr_branch_cd 
	             AND (TO_CHAR(GIOP.or_date,'MM-DD-RRRR') = TO_CHAR(p_dcb_date,'MM-DD-RRRR') 
	              OR TRUNC(GCDL.due_dcb_date) =  p_dcb_date))
	  LOOP
	      v_or_flag := A.or_flag;
	  END LOOP;
	  
	  IF v_or_flag IS NULL THEN
		   p_var_all_ors_r_cancelled := 'Y';
	  ELSE
	  	  p_var_all_ors_r_cancelled := 'N';	  
	  END IF;
  END validate_giacs035_dcb_no;
  /* end of CHECK_IF_ALL_ORs_R_CANCELLED **/
  
END validate_giacs035_dcb_no_1;
/



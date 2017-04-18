CREATE OR REPLACE PACKAGE CPI.Gipi_Wopen_Policy_Pkg AS

  TYPE gipi_wopen_policy_type IS RECORD
    (par_id			    GIPI_WOPEN_POLICY.par_id%TYPE, 
	 line_cd			GIPI_WOPEN_POLICY.line_cd%TYPE,
	 op_subline_cd		GIPI_WOPEN_POLICY.op_subline_cd%TYPE,
	 op_iss_cd			GIPI_WOPEN_POLICY.op_iss_cd%TYPE,
	 op_issue_yy		GIPI_WOPEN_POLICY.op_issue_yy%TYPE,
	 op_pol_seqno		GIPI_WOPEN_POLICY.op_pol_seqno%TYPE,	 	 
	 op_renew_no		GIPI_WOPEN_POLICY.op_renew_no%TYPE,	 
	 decltn_no			GIPI_WOPEN_POLICY.decltn_no%TYPE,	 
	 eff_date			GIPI_WOPEN_POLICY.eff_date%TYPE,	 
	 ref_open_pol_no	GIPI_POLBASIC.ref_open_pol_no%TYPE,
	 gipi_witem_exist	VARCHAR2(1));
	 
  TYPE gipis031A_wopen_policy_type IS RECORD
    (par_id			    GIPI_WOPEN_POLICY.par_id%TYPE, 
	 line_cd			GIPI_WOPEN_POLICY.line_cd%TYPE,
	 op_subline_cd		GIPI_WOPEN_POLICY.op_subline_cd%TYPE,
	 op_iss_cd			GIPI_WOPEN_POLICY.op_iss_cd%TYPE,
	 op_issue_yy		GIPI_WOPEN_POLICY.op_issue_yy%TYPE,
	 op_pol_seqno		GIPI_WOPEN_POLICY.op_pol_seqno%TYPE,	 	 
	 op_renew_no		GIPI_WOPEN_POLICY.op_renew_no%TYPE,	 
	 decltn_no			GIPI_WOPEN_POLICY.decltn_no%TYPE,	 
	 eff_date			GIPI_WOPEN_POLICY.eff_date%TYPE	 
	 );
	 
  TYPE gipi_wopen_policy_tab IS TABLE OF gipi_wopen_policy_type;
  
  TYPE rc_gipi_wopen_policy_cur IS REF CURSOR RETURN gipis031A_wopen_policy_type;
  
  TYPE gipi_wopen_policy_type2 IS RECORD
    (eff_date			GIPI_WOPEN_POLICY.eff_date%TYPE,
	 message1			VARCHAR2(200),
	 message2			VARCHAR2(200)
	);
	
  TYPE gipi_wopen_policy_tab2 IS TABLE OF gipi_wopen_policy_type2;
	
  FUNCTION get_gipi_wopen_policy (p_par_id     GIPI_WOPEN_POLICY.par_id%TYPE)
    RETURN gipi_wopen_policy_tab PIPELINED;
	
    
  PROCEDURE set_gipi_wopen_policy ( 
  	 v_par_id			IN  GIPI_WOPEN_POLICY.par_id%TYPE, 
	 v_line_cd			IN  GIPI_WOPEN_POLICY.line_cd%TYPE,
	 v_op_subline_cd	IN  GIPI_WOPEN_POLICY.op_subline_cd%TYPE,
	 v_op_iss_cd		IN  GIPI_WOPEN_POLICY.op_iss_cd%TYPE,
	 v_op_issue_yy		IN  GIPI_WOPEN_POLICY.op_issue_yy%TYPE,
	 v_op_pol_seqno		IN  GIPI_WOPEN_POLICY.op_pol_seqno%TYPE,	 	 
	 v_op_renew_no		IN  GIPI_WOPEN_POLICY.op_renew_no%TYPE,	 
	 v_decltn_no		IN  GIPI_WOPEN_POLICY.decltn_no%TYPE,	 
	 v_eff_date			IN  GIPI_WOPEN_POLICY.eff_date%TYPE);
	 
  PROCEDURE save_wopenpolicy(p_gipi_wopen_policy	GIPI_WOPEN_POLICY%ROWTYPE);	
  
  PROCEDURE get_gipi_wopen_policy_exist (p_par_id  IN GIPI_WOPEN_POLICY.par_id%TYPE,
  										 p_exist   OUT NUMBER);
										 
  /*FUNCTION validate_policy_dates(p_line_cd			GIPI_WOPEN_POLICY.line_cd%TYPE,
	 	   						 p_op_subline_cd	GIPI_WOPEN_POLICY.op_subline_cd%TYPE,
	 							 p_op_iss_cd		GIPI_WOPEN_POLICY.op_iss_cd%TYPE,
	 							 p_op_issue_yy		GIPI_WOPEN_POLICY.op_issue_yy%TYPE,
	 							 p_op_pol_seqno		GIPI_WOPEN_POLICY.op_pol_seqno%TYPE,	 	 
	 							 p_op_renew_no		GIPI_WOPEN_POLICY.op_renew_no%TYPE,
								 p_eff_date			GIPI_WPOLBAS.eff_date%TYPE,
								 p_expiry_date		GIPI_WPOLBAS.expiry_date%TYPE)
    RETURN gipi_wopen_policy_tab2 PIPELINED;*/

END Gipi_Wopen_Policy_Pkg;
/



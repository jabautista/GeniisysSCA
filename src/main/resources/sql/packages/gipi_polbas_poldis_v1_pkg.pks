CREATE OR REPLACE PACKAGE CPI.Gipi_Polbas_Poldis_V1_Pkg AS
 
  TYPE gipi_polbas_poldis_type IS RECORD (
    policy_id		   GIPI_POLBASIC.policy_id%TYPE,
	line_cd			   GIPI_POLBASIC.line_cd%TYPE,
	subline_cd		   GIPI_POLBASIC.subline_cd%TYPE,
	iss_cd			   GIPI_POLBASIC.iss_cd%TYPE,
	issue_yy		   GIPI_POLBASIC.issue_yy%TYPE,
	pol_seq_no		   GIPI_POLBASIC.pol_seq_no%TYPE,
	endt_iss_cd		   GIPI_POLBASIC.endt_iss_cd%TYPE,
	endt_yy			   GIPI_POLBASIC.endt_yy%TYPE,
	endt_seq_no		   GIPI_POLBASIC.endt_seq_no%TYPE,
	renew_no		   GIPI_POLBASIC.renew_no%TYPE,
	par_id			   GIPI_POLBASIC.par_id%TYPE,
	pol_flag		   GIPI_POLBASIC.pol_flag%TYPE,
	acct_ent_date	   GIPI_POLBASIC.acct_ent_date%TYPE,
	spld_flag		   GIPI_POLBASIC.spld_flag%TYPE,
	dist_no			   GIUW_POL_DIST.dist_no%TYPE,
	dist_flag		   GIUW_POL_DIST.dist_flag%TYPE,
	eff_date		   GIUW_POL_DIST.eff_date%TYPE,
	expiry_date		   GIUW_POL_DIST.expiry_date%TYPE,
	negate_date		   GIUW_POL_DIST.negate_date%TYPE,
	dist_type		   GIUW_POL_DIST.dist_type%TYPE,
	acct_neg_date	   GIUW_POL_DIST.acct_neg_date%TYPE,
	assd_no			   GIPI_PARLIST.assd_no%TYPE,
	par_type		   GIPI_PARLIST.par_type%TYPE);
	
  TYPE gipi_polbas_poldis_tab IS TABLE OF gipi_polbas_poldis_type;
  
  FUNCTION get_gipi_polbas_poldis ( p_line_cd		   GIPI_POLBASIC.line_cd%TYPE,
									p_subline_cd	   GIPI_POLBASIC.subline_cd%TYPE,
									p_iss_cd		   GIPI_POLBASIC.iss_cd%TYPE,
									p_issue_yy		   GIPI_POLBASIC.issue_yy%TYPE,
									p_pol_seq_no	   GIPI_POLBASIC.pol_seq_no%TYPE,
									p_endt_iss_cd	   GIPI_POLBASIC.endt_iss_cd%TYPE,
									p_endt_yy		   GIPI_POLBASIC.endt_yy%TYPE,
									p_endt_seq_no	   GIPI_POLBASIC.endt_seq_no%TYPE,
									p_renew_no		   GIPI_POLBASIC.renew_no%TYPE,
									p_dist_no		   GIUW_POL_DIST.dist_no%TYPE )
    RETURN gipi_polbas_poldis_tab PIPELINED;	 
 
 
END Gipi_Polbas_Poldis_V1_Pkg;
/



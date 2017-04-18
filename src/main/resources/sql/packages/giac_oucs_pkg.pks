CREATE OR REPLACE PACKAGE CPI.GIAC_OUCS_PKG
AS
	TYPE giac_oucs_type IS RECORD(
		ouc_id              giac_oucs.ouc_id%TYPE,
		gibr_gfun_fund_cd   giac_oucs.gibr_gfun_fund_cd%TYPE,
		gibr_branch_cd      giac_oucs.gibr_branch_cd%TYPE,
		ouc_cd              giac_oucs.ouc_cd%TYPE,
		ouc_name            giac_oucs.ouc_name%TYPE,
		user_id             giac_oucs.user_id%TYPE,
		last_update         giac_oucs.last_update%TYPE,
		cpi_rec_no          giac_oucs.cpi_rec_no%TYPE,
		cpi_branch_cd       giac_oucs.cpi_branch_cd%TYPE,
		claim_tag           giac_oucs.claim_tag%TYPE,
		remarks             giac_oucs.remarks%TYPE		
		);
		
	TYPE giac_oucs_tab IS TABLE OF giac_oucs_type;
	
	FUNCTION get_giac_oucs_list(
		p_fund_cd			giac_oucs.gibr_gfun_fund_cd%TYPE,
		p_branch_cd			giac_oucs.gibr_branch_cd%TYPE)
	RETURN giac_oucs_tab PIPELINED;	
		
END;
/



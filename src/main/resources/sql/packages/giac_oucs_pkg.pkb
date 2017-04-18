CREATE OR REPLACE PACKAGE BODY CPI.GIAC_OUCS_PKG
AS
  /*
  **  Created by   : Jerome Orio
  **  Date Created : 06.06.2012
  **  Reference By : (GIACS016 - Disbursement)
  **  Description  :  
  */	
	FUNCTION get_giac_oucs_list(
		p_fund_cd			giac_oucs.gibr_gfun_fund_cd%TYPE,
		p_branch_cd			giac_oucs.gibr_branch_cd%TYPE)
	RETURN giac_oucs_tab PIPELINED IS
	  v_list 			giac_oucs_type;
	BEGIN
		FOR i IN (SELECT gouc.ouc_cd gouc_ouc_cd, gouc.ouc_id gouc_ouc_id,
					     gouc.ouc_name dsp_ouc_name
				    FROM giac_oucs gouc
				   WHERE gouc.gibr_gfun_fund_cd = p_fund_cd
				     AND gouc.gibr_branch_cd = p_branch_cd)
		LOOP
			v_list.ouc_cd 		:= i.gouc_ouc_cd; 
			v_list.ouc_id 		:= i.gouc_ouc_id;
			v_list.ouc_name 	:= i.dsp_ouc_name;
			PIPE ROW(v_list);
		END LOOP;
	  RETURN;		
	END;			
	
END;
/



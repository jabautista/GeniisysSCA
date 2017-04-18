DROP PROCEDURE CPI.SEARCH_FOR_ASSURED2;

CREATE OR REPLACE PROCEDURE CPI.Search_For_Assured2 (p_assd_no IN OUT GIPI_WPOLBAS.assd_no%TYPE,
	p_eff_date		IN GIPI_WPOLBAS.eff_date%TYPE,
	p_line_cd		IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd	IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd		IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy		IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_WPOLBAS.renew_no%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 05.26.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure returns the assd_no	
	*/
	v_max_eff_date1           GIPI_WPOLBAS.eff_date%TYPE;
	v_max_eff_date2           GIPI_WPOLBAS.eff_date%TYPE;
	v_max_eff_date            GIPI_WPOLBAS.eff_date%TYPE;
	v_eff_date                GIPI_WPOLBAS.eff_date%TYPE;
	v_policy_id               GIPI_POLBASIC.policy_id%TYPE;
	v_max_endt_seq_no         GIPI_WPOLBAS.endt_seq_no%TYPE;
	v_max_endt_seq_no1        GIPI_WPOLBAS.endt_seq_no%TYPE;
BEGIN
	--get policy id and effectivity of policy
	
	Gipi_Polbasic_Pkg.get_eff_date_policy_id(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_eff_date, v_policy_id);
	
	--get the maximum endt_seq_no from all endt. of the policy	
	v_max_endt_seq_no := Gipi_Polbasic_Pkg.get_max_endt_seq_no(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 'ASSURED');
	
	--if maximum endt_seq_no is greater than 0 then check if latest
	--assured should be from latest backward endt with update or  
	-- from the latest endt that is not backward 
	IF v_max_endt_seq_no > 0 THEN
		--get maximum endt_seq_no for backward endt. with updates		
		v_max_endt_seq_no1 := Gipi_Polbasic_Pkg.get_max_endt_seq_no_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 'ASSURED');
	 
		--if maximum endt_seq_no of all endt is not equal to  maximum endt_seq_no of 
		--backward endt. with update then get max. eff_date for both condition
		IF v_max_endt_seq_no != NVL(v_max_endt_seq_no1,-1) THEN             
			--get max. eff_date for backward endt with updates			
			v_max_eff_date1 := Gipi_Polbasic_Pkg.get_max_eff_date_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, v_max_endt_seq_no1, 'ASSURED');
			
			--get max eff_date for endt			
			v_max_eff_date2 := Gipi_Polbasic_Pkg.get_endt_max_eff_date(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 'ASSURED');
			v_max_eff_date := NVL(v_max_eff_date2,v_max_eff_date1);                         
		ELSE
			--assd_no should be from the latest backward endt. with updates			
			v_max_eff_date := Gipi_Polbasic_Pkg.get_max_eff_date_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, v_max_endt_seq_no1, 'ASSURED');
		END IF;
	ELSE
		--eff_date should be from policy for records with no endt or 
		--no valid endt. that meets the conditions set
		v_max_eff_date := v_eff_date;            	
	END IF;
	
	--get assured from records with eff_date equal to the derived eff_date
	p_assd_no := Gipi_Polbasic_Pkg.get_assd_no_for_endt(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_max_eff_date);
END Search_For_Assured2;
/



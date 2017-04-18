DROP PROCEDURE CPI.REVERT_FLAT_CANCELLATION;

CREATE OR REPLACE PROCEDURE CPI.Revert_Flat_Cancellation (
	p_par_id 			IN GIPI_PARLIST.par_id%TYPE,
	p_line_cd			IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd		IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd			IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy			IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no		IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no			IN GIPI_WPOLBAS.renew_no%TYPE,
	p_eff_date			IN GIPI_WPOLBAS.eff_date%TYPE,
	p_co_insurance_sw	IN GIPI_WPOLBAS.co_insurance_sw%TYPE,
	p_ann_tsi_amt		OUT GIPI_WPOLBAS.ann_tsi_amt%TYPE,
	p_ann_prem_amt		OUT GIPI_WPOLBAS.ann_prem_amt%TYPE,
	p_msg_alert			OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.20.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: To revert the processes done when Cancelled(Flat) checkbox was tagged
	*/
BEGIN
	Delete_Other_Info(p_par_id);
	Gipis031_Delete_Records(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy,
		p_pol_seq_no, p_renew_no, p_eff_date, p_co_insurance_sw, p_ann_tsi_amt,
		p_ann_prem_amt, p_msg_alert);
	
END Revert_Flat_Cancellation;
/



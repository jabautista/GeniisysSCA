DROP PROCEDURE CPI.ENDT_DELETE_BILL;

CREATE OR REPLACE PROCEDURE CPI.ENDT_DELETE_BILL (
	p_par_id		IN GIPI_WPOLBAS.par_id%TYPE,
	p_line_cd		IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd	IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd		IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy		IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_WPOLBAS.renew_no%TYPE,
	p_eff_date		IN GIPI_WPOLBAS.eff_date%TYPE,
	p_co_ins_sw		IN GIPI_WPOLBAS.co_insurance_sw%TYPE,
	p_ann_tsi_amt	OUT GIPI_WPOLBAS.ann_tsi_amt%TYPE,
	p_ann_prem_amt	OUT GIPI_WPOLBAS.ann_prem_amt%TYPE,
	p_msg_alert		OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.28.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure deletes records on certain tables,
	**					: updates record on gipi_wpolbas, and gipi_witem.
	**					: It also returns new value for ann_tsi_amt and ann_prem_amt
	**					: for current record on gipi_wpolbas
	*/
	v_items VARCHAR2(1) := 'N';
BEGIN
	FOR A IN (
		SELECT '1'
		  FROM GIPI_WITEM
		 WHERE par_id = p_par_id
		   AND rec_flag = 'A')
	LOOP
		v_items := 'Y';
	END LOOP;
	
	Gipi_Winstallment_Pkg.del_gipi_winstallment_1(p_par_id);
	--Gipi_Wcomm_Inv_Perils_Pkg.del_gipi_wcomm_inv_perils_1(p_par_id);
    Gipi_Wcomm_Inv_Perils_Pkg.del_gipi_wcomm_inv_perils1(p_par_id);
	Gipi_Wcomm_Invoices_Pkg.del_gipi_wcomm_invoices_1(p_par_id);
	Gipi_Winvperl_Pkg.del_gipi_winvperl_1(p_par_id);
	Gipi_Winv_Tax_Pkg.del_gipi_winv_tax_1(p_par_id);
	Gipi_Wpackage_Inv_Tax_Pkg.del_gipi_wpackage_inv_tax(p_par_id);
	Gipi_Winvoice_Pkg.del_gipi_winvoice1(p_par_id);
	Gipi_Orig_Invperl_Pkg.del_gipi_orig_invperl(p_par_id);
	Gipi_Orig_Inv_Tax_Pkg.del_gipi_orig_inv_tax(p_par_id);
	Gipi_Orig_Invoice_Pkg.del_gipi_orig_invoice(p_par_id);
	Gipi_Orig_Itmperil_Pkg.del_gipi_orig_itmperil(p_par_id);
	Gipi_Co_Insurer_Pkg.del_gipi_co_insurer(p_par_id);
	Gipi_Main_Co_Ins_Pkg.del_gipi_main_co_ins(p_par_id);
	Gipi_Wpolbas_Discount_Pkg.del_gipi_wpolbas_discount(p_par_id);
	Gipi_Witem_Discount_Pkg.del_gipi_witem_discount(p_par_id);
	Gipi_Wperil_Discount_Pkg.del_gipi_wperil_discount(p_par_id);
	Gipi_Witmperl_Pkg.del_gipi_witmperl2(p_par_id);
	Gipi_Wopen_Peril_Pkg.del_gipi_wopen_peril(p_par_id);
	Gipi_Wdeductibles_Pkg.del_gipi_wdeductibles(p_par_id);
	
	Delete_Co_Ins(p_par_id, p_co_ins_sw);
	
	UPDATE GIPI_WPOLBAS
	   SET discount_sw = 'N'
	 WHERE par_id = p_par_id;
	 
	UPDATE GIPI_WITEM
	   SET discount_sw = 'N'
	 WHERE par_id = p_par_id;
	
	Delete_Co_Ins(p_par_id, p_co_ins_sw);
	
	Get_Amounts(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, 
		p_eff_date, p_ann_tsi_amt, p_ann_prem_amt, p_msg_alert);
	
	IF p_msg_alert IS NOT NULL THEN
		GOTO RAISE_FORM_TRIGGER_FAILURE;
	END IF;	
	
	<<RAISE_FORM_TRIGGER_FAILURE>>
	NULL;
END ENDT_DELETE_BILL;
/



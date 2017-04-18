DROP PROCEDURE CPI.DELETE_RECORDS01;

CREATE OR REPLACE PROCEDURE CPI.DELETE_RECORDS01 (
	p_par_id IN gipi_wpolbas.par_id%TYPE,
	p_line_cd IN gipi_wpolbas.line_cd%TYPE,
	p_eff_date IN gipi_wpolbas.eff_date%TYPE,
	p_co_insurance_sw IN gipi_wpolbas.co_insurance_sw%TYPE,
	p_msg_alert OUT VARCHAR2)
AS
	/*	Date        Author			Description
    **	==========	===============	============================
    **	01.27.2012	mark jm			This procedure deletes record on the following tables based on the given par_id	
    */	
	v_line_cd gipi_wpolbas.line_cd%TYPE;
	v_subline_cd gipi_wpolbas.subline_cd%TYPE;
    v_iss_cd gipi_wpolbas.iss_cd%TYPE;
    v_issue_yy gipi_wpolbas.issue_yy%TYPE;
    v_pol_seq_no gipi_wpolbas.pol_seq_no%TYPE;
    v_renew_no gipi_wpolbas.renew_no%TYPE;
BEGIN

    --Gipi_Wpolbas_Pkg.get_gipi_wpolbas_par_no(p_par_id, v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no);
    
    gipi_winstallment_pkg.del_gipi_winstallment_1(p_par_id);
    gipi_wcomm_inv_perils_pkg.del_gipi_wcomm_inv_perils1(p_par_id);
    gipi_wcomm_invoices_pkg.del_gipi_wcomm_invoices_1(p_par_id);
    gipi_winvperl_pkg.del_gipi_winvperl_1(p_par_id);
    gipi_winv_tax_pkg.del_gipi_winv_tax_1(p_par_id);
    gipi_wpackage_inv_tax_pkg.del_gipi_wpackage_inv_tax(p_par_id);
    gipi_winvoice_pkg.del_gipi_winvoice1(p_par_id);
    gipi_orig_invperl_pkg.del_gipi_orig_invperl(p_par_id);
    gipi_orig_inv_tax_pkg.del_gipi_orig_inv_tax(p_par_id);
    gipi_orig_invoice_pkg.del_gipi_orig_invoice(p_par_id);
    gipi_orig_itmperil_pkg.del_gipi_orig_itmperil(p_par_id);
    gipi_co_insurer_pkg.del_gipi_co_insurer(p_par_id);
    gipi_main_co_ins_pkg.del_gipi_main_co_ins(p_par_id);
    gipi_wpolbas_discount_pkg.del_gipi_wpolbas_discount(p_par_id);
    gipi_witem_discount_pkg.del_gipi_witem_discount(p_par_id);
    gipi_wperil_discount_pkg.del_gipi_wperil_discount(p_par_id);
    gipi_witmperl_pkg.del_gipi_witmperl2(p_par_id);    
    delete_co_ins(p_par_id, p_co_insurance_sw);
    gipi_witem_pkg.del_all_gipi_witem(p_par_id);    
    get_amounts01(p_par_id, p_line_cd, p_eff_date, p_msg_alert);
    
END DELETE_RECORDS01;
/



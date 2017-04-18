DROP PROCEDURE CPI.PACK_ENDT_DELETE_RECORDS;

CREATE OR REPLACE PROCEDURE CPI.PACK_ENDT_DELETE_RECORDS (
    p_par_id             IN     GIPI_WPOLBAS.par_id%TYPE,
    p_pack_line_cd       IN     GIPI_WPOLBAS.line_cd%TYPE,
    p_line_cd            IN     GIPI_PACK_WPOLBAS.line_cd%TYPE,
    p_subline_cd         IN     GIPI_PACK_WPOLBAS.subline_cd%TYPE,
    p_iss_cd             IN     GIPI_PACK_WPOLBAS.iss_cd%TYPE,
    p_issue_yy           IN     GIPI_PACK_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no         IN     GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no           IN     GIPI_PACK_WPOLBAS.renew_no%TYPE,
    p_eff_date           IN     GIPI_PACK_WPOLBAS.eff_date%TYPE,
    p_co_insurance_sw    IN     GIPI_PACK_WPOLBAS.co_insurance_sw%TYPE,
    p_ann_tsi_amt        OUT    GIPI_PACK_WPOLBAS.ann_tsi_amt%TYPE,
    p_ann_prem_amt       OUT    GIPI_PACK_WPOLBAS.ann_prem_amt%TYPE,
    p_msg_alert          OUT    VARCHAR2)
AS
    /*
    **  Created by        : Veronica V. Raymundo
    **  Date Created     : 11.16.2011
    **  Reference By     : (GIPIS031A - Package Endt Basic Information)
    **  Description     : This procedure deletes record on the following tables based on the given par_id    
    */
    
BEGIN
  
    Gipi_Winstallment_Pkg.del_gipi_winstallment_1(p_par_id);
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
    DELETE_CO_INS(p_par_id, p_co_insurance_sw);
    Gipi_Witem_Pkg.del_all_gipi_witem(p_par_id);    
    PACK_ENDT_GET_AMOUNTS(p_par_id, p_pack_line_cd, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, 
                          p_eff_date, p_ann_tsi_amt, p_ann_prem_amt, p_msg_alert);
    
END PACK_ENDT_DELETE_RECORDS;
/



DROP PROCEDURE CPI.PACK_ENDT_DELETE_OTHER_INFO;

CREATE OR REPLACE PROCEDURE CPI.PACK_ENDT_DELETE_OTHER_INFO (p_par_id IN GIPI_WPOLBAS.par_id%TYPE)
AS
	/*
	**  Created by		: Emman
	**  Date Created 	: 03.10.2011
	**  Reference By 	: (GIPIS031A - Package Endt Basic Information)
	**  Description 	: This procedure deletes record on the following tables based on the given par_id	
	*/
	v_dist_no		GIUW_POL_DIST.dist_no%TYPE;
	v_frps_yy		GIRI_WDISTFRPS.frps_yy%TYPE;
	v_frps_seq_no	GIRI_WDISTFRPS.frps_seq_no%TYPE;
BEGIN
	GIPI_WENGG_BASIC_PKG.del_gipi_wengg_basic(p_par_id);
	GIPI_WPRINCIPAL_PKG.del_gipi_wprincipal(p_par_id);
	GIPI_WLOCATION_PKG.del_gipi_wlocation(p_par_id);
	Gipi_Waccident_Item_Pkg.del_gipi_waccident_item(p_par_id);
	Gipi_Waviation_Item_Pkg.del_gipi_waviation_item(p_par_id);
	Gipi_Wves_Air_Pkg.del_gipi_wves_air(p_par_id);
	Gipi_Wvehicle_Pkg.del_gipi_wvehicle(p_par_id);
	Gipi_Wmcacc_Pkg.del_gipi_wmcacc(p_par_id);
	Gipi_Wcasualty_Item_Pkg.del_gipi_wcasualty_item(p_par_id);
	Gipi_Wbeneficiary_Pkg.del_gipi_wbeneficiary(p_par_id);
	GIPI_WGRP_ITMS_BENEFICIARY_PKG.del_gipi_wgrp_itms_beneficiary(p_par_id);
	Gipi_Wgrouped_Items_Pkg.del_gipi_wgrouped_items(p_par_id);
	Gipi_Wbond_Basic_Pkg.del_gipi_wbond_basic(p_par_id);
	Gipi_Witem_Ves_Pkg.del_gipi_witem_ves(p_par_id);
	Gipi_Wcargo_Pkg.del_gipi_wcargo(p_par_id);
	GIPI_WLIM_LIAB_PKG.del_gipi_wlim_liab(p_par_id);
	Gipi_Wfireitm_Pkg.del_gipi_wfireitm(p_par_id);
	Gipi_Wcosigntry_Pkg.del_gipi_wcosigntry(p_par_id);
	Gipi_Wdeductibles_Pkg.del_gipi_wdeductibles(p_par_id);
	Gipi_Wcomm_Inv_Perils_Pkg.del_gipi_wcomm_inv_perils1(p_par_id);
	Gipi_Wcomm_Invoices_Pkg.del_gipi_wcomm_invoices_1(p_par_id);
	Gipi_Wpackage_Inv_Tax_Pkg.del_gipi_wpackage_inv_tax(p_par_id);
	Gipi_Winstallment_Pkg.del_gipi_winstallment_1(p_par_id);
	Gipi_Winvoice_Pkg.del_gipi_winvoice1(p_par_id);
	Gipi_Winvperl_Pkg.del_gipi_winvperl_1(p_par_id);
	Gipi_Winv_Tax_Pkg.del_gipi_winv_tax_1(p_par_id);
	Gipi_Witmperl_Pkg.del_gipi_witmperl2(p_par_id);
	Gipi_Wperil_Discount_Pkg.del_gipi_wperil_discount(p_par_id);
	Gipi_Wpolnrep_Pkg.del_gipi_wpolnreps(p_par_id);
	Gipi_Wpolwc_Pkg.DEL_GIPI_WPOLWC(p_par_id);
	Gipi_Wreqdocs_Pkg.DEL_GIPI_WREQDOCS(p_par_id);	
	Gipi_Wves_Accumulation_Pkg.DEL_GIPI_WVES_ACCUMULATION(p_par_id);

	BEGIN
		FOR X IN (
			SELECT dist_no
			  FROM GIUW_POL_DIST
			 WHERE par_id = p_par_id)
		LOOP
			v_dist_no := X.dist_no;
			Giuw_Witemperilds_Dtl_Pkg.del_giuw_witemperilds_dtl(v_dist_no);
			Giuw_Witemperilds_Pkg.del_giuw_witemperilds(v_dist_no);
			Giuw_Wperilds_Dtl_Pkg.del_giuw_wperilds_dtl(v_dist_no);
            Giuw_Wperilds_Pkg.del_giuw_wperilds(v_dist_no);
            Giuw_Witemds_Dtl_Pkg.del_giuw_witemds_dtl(v_dist_no);
            Giuw_Witemds_Pkg.del_giuw_witemds(v_dist_no); --belle 09142012
            
            BEGIN
                SELECT frps_yy, frps_seq_no
                  INTO v_frps_yy, v_frps_seq_no
                  FROM GIRI_WDISTFRPS
                 WHERE dist_no = v_dist_no
              GROUP BY frps_yy, frps_seq_no;
            
                Giri_Wfrperil_Pkg.del_giri_wfrperil_1(v_frps_yy, v_frps_seq_no);
                Giri_Wfrps_Ri_Pkg.del_giri_wfrps_ri_1(v_frps_yy, v_frps_seq_no);
                Giri_Wdistfrps_Pkg.del_giri_wdistfrps1(v_frps_yy, v_frps_seq_no);
            EXCEPTION
                WHEN TOO_MANY_ROWS THEN
                    NULL;
                WHEN NO_DATA_FOUND THEN 
                    NULL;
            END;
            Giuw_Wpolicyds_Dtl_Pkg.del_giuw_wpolicyds_dtl(v_dist_no);
            Giuw_Wpolicyds_Pkg.del_giuw_wpolicyds(v_dist_no);
        END LOOP;
    END;
END PACK_ENDT_DELETE_OTHER_INFO;
/



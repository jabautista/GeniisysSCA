DROP PROCEDURE CPI.DELETE_ALL_TABLES;

CREATE OR REPLACE PROCEDURE CPI.DELETE_ALL_TABLES (
	p_par_id 		IN GIPI_WPOLBAS.par_id%TYPE,
	p_line_cd		IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd	IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd		IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy		IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_WPOLBAS.renew_no%TYPE,
	p_eff_date		IN GIPI_WPOLBAS.eff_date%TYPE,
	p_msg_alert		OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.09.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure is used for deleting records using the given par_id
	*/
	v_dist_no      	GIUW_POL_DIST.dist_no%TYPE;
	v_frps_yy      	GIRI_WDISTFRPS.frps_yy%TYPE;
	v_frps_seq_no  	GIRI_WDISTFRPS.frps_seq_no%TYPE;
	v_ann_tsi_amt	GIPI_WPOLBAS.ann_tsi_amt%TYPE;
	v_ann_prem_amt	GIPI_WPOLBAS.ann_prem_amt%TYPE;
BEGIN
	--Deleting related Engineering information..
	Gipi_Wengg_Basic_Pkg.del_gipi_wengg_basic(p_par_id);
	Gipi_Wprincipal_Pkg.del_gipi_wprincipal(p_par_id);
	Gipi_Wlocation_Pkg.del_gipi_wlocation(p_par_id);
	
	--Deleting related Accident information..
	Gipi_Waccident_Item_Pkg.del_gipi_waccident_item(p_par_id);
	
	--Deleting related Aviation information..
	Gipi_Waviation_Item_Pkg.del_gipi_waviation_item(p_par_id);	
	Gipi_Wves_Air_Pkg.del_gipi_wves_air(p_par_id);	
	
	--Deleting related Motor Car information..
	Gipi_Wvehicle_Pkg.del_gipi_wvehicle(p_par_id);
	Gipi_Wmcacc_Pkg.del_gipi_wmcacc(p_par_id);
	
	--Deleting related Casualty information..
	Gipi_Wcasualty_Item_Pkg.del_gipi_wcasualty_item(p_par_id);
	Gipi_Wbeneficiary_Pkg.del_gipi_wbeneficiary(p_par_id);
	
	--Deleting related Surety information..
	Gipi_Wbond_Basic_Pkg.del_gipi_wbond_basic(p_par_id);
	
	--Deleting related Marine Cargo information..
	Gipi_Witem_Ves_Pkg.del_gipi_witem_ves(p_par_id);
	Gipi_Wcargo_Pkg.del_gipi_wcargo(p_par_id);
	Gipi_Wopen_Cargo_Pkg.del_gipi_wopen_cargo(p_par_id);
	Gipi_Wopen_Peril_Pkg.del_gipi_wopen_peril(p_par_id);
	Gipi_Wopen_Liab_Pkg.del_gipi_wopen_liab(p_par_id);
	Gipi_Wlim_Liab_Pkg.del_gipi_wlim_liab(p_par_id);
	Gipi_Wgrp_Itms_Beneficiary_Pkg.del_gipi_wgrp_itms_beneficiary(p_par_id);
	Gipi_Wgrouped_Items_Pkg.del_gipi_wgrouped_items(p_par_id);
	
	--Deleting related Fire information..
	Gipi_Wfireitm_Pkg.del_gipi_wfireitm(p_par_id);
	
	--Deleting other related information..
	Gipi_Wcosigntry_Pkg.del_gipi_wcosigntry(p_par_id);
	Gipi_Wdeductibles_Pkg.del_gipi_wdeductibles(p_par_id);
	
	--Deleting invoice related information..
	Gipi_Wcomm_Inv_Perils_Pkg.del_gipi_wcomm_inv_perils1(p_par_id);
	Gipi_Wcomm_Invoices_Pkg.del_gipi_wcomm_invoices_1(p_par_id);
	Gipi_Wpackage_Inv_Tax_Pkg.del_gipi_wpackage_inv_tax(p_par_id);
	Gipi_Winstallment_Pkg.del_gipi_winstallment_1(p_par_id);
	Gipi_Winvoice_Pkg.del_gipi_winvoice1(p_par_id);
	Gipi_Winvperl_Pkg.del_gipi_winvperl_1(p_par_id);
	Gipi_Winv_Tax_Pkg.del_gipi_winv_tax_1(p_par_id);
	Gipi_Witmperl_Pkg.del_gipi_witmperl2(p_par_id);
	Gipi_Witem_Pkg.del_all_gipi_witem(p_par_id);
	
	Gipi_Wperil_Discount_Pkg.del_gipi_wperil_discount(p_par_id);
    FOR i IN (
        SELECT a.old_policy_id
          FROM GIPI_WPOLNREP a
              ,GIPI_WPOLBAS  b
         WHERE a.par_id        = p_par_id
           AND a.par_id        = b.par_id)
    LOOP
      Gipi_Wpolnrep_Pkg.del_gipi_wpolnrep(p_par_id, i.old_policy_id);
    END LOOP;
	Gipi_Wpolwc_Pkg.del_gipi_wpolwc(p_par_id);
	Gipi_Wreqdocs_Pkg.del_gipi_wreqdocs(p_par_id);
	Gipi_Wves_Accumulation_Pkg.del_gipi_wves_accumulation(p_par_id);
	
	BEGIN
		FOR i IN (
			SELECT dist_no 
			  FROM GIUW_POL_DIST
			 WHERE par_id = p_par_id)
		LOOP
			Giuw_Witemperilds_Dtl_Pkg.del_giuw_witemperilds_dtl(i.dist_no);
			Giuw_Witemperilds_Pkg.del_giuw_witemperilds(i.dist_no);
			Giuw_Wperilds_Dtl_Pkg.del_giuw_wperilds_dtl(i.dist_no);
			Giuw_Wperilds_Pkg.del_giuw_wperilds(i.dist_no);
			Giuw_Witemds_Dtl_Pkg.del_giuw_witemds_dtl(i.dist_no);
			Giuw_Witemds_Pkg.del_giuw_witemds(i.dist_no);
			
			BEGIN
				SELECT frps_yy, frps_seq_no
				  INTO v_frps_yy, v_frps_seq_no
				  FROM GIRI_WDISTFRPS
				 WHERE dist_no = i.dist_no
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
			
			Giuw_Wpolicyds_Dtl_Pkg.del_giuw_wpolicyds_dtl(i.dist_no);
			Giuw_Wpolicyds_Pkg.del_giuw_wpolicyds(i.dist_no);
		END LOOP;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			NULL;
	END;
	
	Get_Amounts(p_par_id, p_line_cd, p_subline_cd, p_iss_cd,
		p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 
		v_ann_tsi_amt, v_ann_prem_amt,	p_msg_alert);
	
END DELETE_ALL_TABLES;
/



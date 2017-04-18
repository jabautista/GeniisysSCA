DROP PROCEDURE CPI.DELETE_OTHER_INFO;

CREATE OR REPLACE PROCEDURE CPI.DELETE_OTHER_INFO (p_par_id IN GIPI_WPOLBAS.par_id%TYPE)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.01.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure deletes record on the following tables based on the given par_id    
    */
    v_dist_no        giuw_pol_dist.dist_no%TYPE;
    v_frps_yy        giri_wdistfrps.frps_yy%TYPE;
    v_frps_seq_no    giri_wdistfrps.frps_seq_no%TYPE;
    v_withPostedBndr VARCHAR2(1); 
BEGIN
    gipi_wengg_basic_pkg.del_gipi_wengg_basic(p_par_id);
    gipi_wprincipal_pkg.del_gipi_wprincipal(p_par_id);
    gipi_wlocation_pkg.del_gipi_wlocation(p_par_id);
    gipi_waccident_item_pkg.del_gipi_waccident_item(p_par_id);
    gipi_waviation_item_pkg.del_gipi_waviation_item(p_par_id);
    gipi_wves_air_pkg.del_gipi_wves_air(p_par_id);
    gipi_wvehicle_pkg.del_gipi_wvehicle(p_par_id);
    gipi_wmcacc_pkg.del_gipi_wmcacc(p_par_id);
    gipi_wcasualty_item_pkg.del_gipi_wcasualty_item(p_par_id);
    gipi_wbeneficiary_pkg.del_gipi_wbeneficiary(p_par_id);
    gipi_wgrp_itms_beneficiary_pkg.del_gipi_wgrp_itms_beneficiary(p_par_id);
    gipi_wgrouped_items_pkg.del_gipi_wgrouped_items(p_par_id);
    gipi_wbond_basic_pkg.del_gipi_wbond_basic(p_par_id);
    gipi_witem_ves_pkg.del_gipi_witem_ves(p_par_id);
    gipi_wcargo_pkg.del_gipi_wcargo(p_par_id);
    gipi_wlim_liab_pkg.del_gipi_wlim_liab(p_par_id);
    gipi_wfireitm_pkg.del_gipi_wfireitm(p_par_id);
    gipi_wcosigntry_pkg.del_gipi_wcosigntry(p_par_id);
    gipi_wdeductibles_pkg.del_gipi_wdeductibles(p_par_id);
    gipi_wcomm_inv_perils_pkg.del_gipi_wcomm_inv_perils1(p_par_id);
    gipi_wcomm_invoices_pkg.del_gipi_wcomm_invoices_1(p_par_id);
    gipi_wpackage_inv_tax_pkg.del_gipi_wpackage_inv_tax(p_par_id);
    gipi_winstallment_pkg.del_gipi_winstallment_1(p_par_id);
    gipi_winvoice_pkg.del_gipi_winvoice1(p_par_id);
    gipi_winvperl_pkg.del_gipi_winvperl_1(p_par_id);
    gipi_winv_tax_pkg.del_gipi_winv_tax_1(p_par_id);
    gipi_witmperl_pkg.del_gipi_witmperl2(p_par_id);
    gipi_wperil_discount_pkg.del_gipi_wperil_discount(p_par_id);
    gipi_wpolnrep_pkg.del_gipi_wpolnreps(p_par_id);
    gipi_wpolwc_pkg.del_gipi_wpolwc(p_par_id);
    gipi_wreqdocs_pkg.del_gipi_wreqdocs(p_par_id);    
    gipi_wves_accumulation_pkg.del_gipi_wves_accumulation(p_par_id);

    BEGIN
        FOR X IN (
            SELECT dist_no
              FROM GIUW_POL_DIST
             WHERE par_id = p_par_id)
        LOOP
            v_dist_no := X.dist_no;
            giuw_witemperilds_dtl_pkg.del_giuw_witemperilds_dtl(v_dist_no);
            giuw_witemperilds_pkg.del_giuw_witemperilds(v_dist_no);
            giuw_wperilds_dtl_pkg.del_giuw_wperilds_dtl(v_dist_no);
            giuw_wperilds_pkg.del_giuw_wperilds(v_dist_no);
            giuw_witemds_dtl_pkg.del_giuw_witemds_dtl(v_dist_no);
            giuw_witemds_pkg.del_giuw_witemds(v_dist_no);
            /*BEGIN
                SELECT frps_yy, frps_seq_no
                  INTO v_frps_yy, v_frps_seq_no
                  FROM GIRI_WDISTFRPS
                 WHERE dist_no = v_dist_no
              GROUP BY frps_yy, frps_seq_no;
            
                giri_wfrperil_pkg.del_giri_wfrperil_1(v_frps_yy, v_frps_seq_no);
                giri_wfrps_ri_pkg.del_giri_wfrps_ri_1(v_frps_yy, v_frps_seq_no);
                giri_wdistfrps_pkg.del_giri_wdistfrps1(v_frps_yy, v_frps_seq_no);
            EXCEPTION
                WHEN TOO_MANY_ROWS THEN
                    NULL;
                WHEN NO_DATA_FOUND THEN 
                    NULL;
            END;*/ -- jhing REPUBLICFULLWEB 21984, replaced code with for loop to handle multiple dist groups and 
                    -- to resolve SQL Error reported in the SR due to missing condition of Line_Cd in the query of records in GIRI_WDISTFRPS which causes too many rows
             
            -- jhing 03.22.2016 REPUBLICFULLWEB 21984 new query
            FOR curFRPS in (SELECT frps_yy, frps_seq_no , line_cd                 
                                  FROM GIRI_WDISTFRPS
                                 WHERE dist_no = v_dist_no)
            LOOP
                giri_wfrperil_pkg.del_giri_wfrperil(curFRPS.line_cd, curFRPS.frps_yy , curFRPS.frps_seq_no );
                giri_wfrps_ri_pkg.del_giri_wfrps_ri(curFRPS.line_cd, curFRPS.frps_yy , curFRPS.frps_seq_no);
                giri_wfrps_peril_grp_pkg.del_giri_wfrps_peril_grp (curFRPS.line_cd, curFRPS.frps_yy , curFRPS.frps_seq_no);
            
            END LOOP; 
            
            
            giri_wdistfrps_pkg.del_giri_wdistfrps(v_dist_no); -- jhing 03.22.2016            
            
            
            v_withPostedBndr := 'N'; 
            
            FOR cur1 in (SELECT 1
                              FROM giri_distfrps a, giri_frps_ri b, giri_binder c
                             WHERE     a.dist_no = v_dist_no
                                   AND a.line_cd = b.line_cd
                                   AND a.frps_yy = b.frps_yy
                                   AND a.frps_seq_no = b.frps_seq_no
                                   AND b.fnl_binder_id = c.fnl_binder_id)
            LOOP
                v_withPostedBndr := 'Y'; 
                EXIT;
            END LOOP;
            
            IF v_withPostedBndr = 'Y' THEN 
                raise_application_error  (-20015,    'Geniisys Exception#E#Cannot delete distribution records with posted binder.'   );
            END IF;                
            
            giuw_wpolicyds_dtl_pkg.del_giuw_wpolicyds_dtl(v_dist_no);
            giuw_wpolicyds_pkg.del_giuw_wpolicyds(v_dist_no);
            giuw_perilds_dtl_pkg.del_giuw_perilds_dtl(v_dist_no);
            giuw_itemds_dtl_pkg.del_giuw_itemds_dtl(v_dist_no);
            giuw_itemperilds_dtl_pkg.del_giuw_itemperilds_dtl(v_dist_no);
            giuw_policyds_dtl_pkg.del_giuw_policyds_dtl(v_dist_no);
            giuw_itemperilds_pkg.del_giuw_itemperilds(v_dist_no);
            giuw_perilds_pkg.del_giuw_perilds(v_dist_no);
            giuw_itemds_pkg.del_giuw_itemds(v_dist_no);
            giuw_policyds_pkg.del_giuw_policyds(v_dist_no);
        END LOOP;
    END;
END DELETE_OTHER_INFO;
/



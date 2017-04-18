DROP PROCEDURE CPI.POST_POL_PAR_2;

CREATE OR REPLACE PROCEDURE CPI.post_pol_par_2(
    p_proc_line_cd           IN  giis_line.line_cd%TYPE,
    p_menu_line_cd          OUT  giis_line.menu_line_cd%TYPE,
    p_is_package             IN  VARCHAR2,
    p_new_policy_id         OUT  NUMBER,
    p_new_pack_policy_id    OUT  NUMBER,
    p_msg                   OUT  VARCHAR2,
    p_message_box        IN OUT  VARCHAR2,
    p_old_pol_id             IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_policy_id             OUT  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_expiry_date       IN  gipi_wpolbas.eff_date%TYPE,
    p_proc_incept_date       IN  gipi_wpolbas.incept_date%TYPE,
    p_proc_assd_no           IN  gipi_wpolbas.assd_no%TYPE,
    p_proc_same_polno_sw     IN  VARCHAR2,
    p_new_par_id            OUT  NUMBER,
    p_new_pack_par_id       OUT  NUMBER,   
    p_proc_renew_flag        IN  VARCHAR2,
    p_user                   IN  gipi_pack_parlist.underwriter%TYPE,
    p_pack_sw               OUT  VARCHAR2,
    p_long                  OUT  gipi_polgenin.gen_info%TYPE,
    p_proc_iss_cd            IN  VARCHAR2,
    p_iss_ri                 IN  VARCHAR2,
    p_line_mn                IN  VARCHAR2,
    p_open_flag              IN  VARCHAR2,
    p_line_ac                IN  VARCHAR2,
    p_line_su                IN  VARCHAR2,
    p_line_ca                IN  VARCHAR2,
    p_line_en                IN  VARCHAR2,
    p_bpv                    IN  VARCHAR2,
    p_subline_bpv           OUT  giis_parameters.param_value_v%TYPE,
    p_proc_subline_cd        IN  VARCHAR2,
    p_line_fi                IN  VARCHAR2,
    p_line_mc                IN  VARCHAR2,
    p_line_mh                IN  VARCHAR2,
    p_line_av                IN  VARCHAR2,
    p_subline_mop            IN  VARCHAR2,
    p_subline_mrn            IN  VARCHAR2,
    p_is_subpolicy           IN  VARCHAR2,
    p_dist_no_old           OUT  giuw_policyds.dist_no%TYPE,
    p_dist_no_new           OUT  giuw_policyds.dist_no%TYPE
) 
IS
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : post_pol_par program unit 
  */
    FOR menu_line IN ( SELECT menu_line_cd code
                       FROM giis_line
                      WHERE line_cd = p_proc_line_cd)
  LOOP
      p_menu_line_cd := menu_line.code;
      EXIT;
  END LOOP;
  IF p_is_package = 'Y' THEN
      /* added by gmi 060507*/
      copy_pol_pack_wpolbas(p_new_policy_id, p_new_pack_policy_id,p_msg,p_message_box,p_old_pol_id,p_policy_id,
                            p_proc_expiry_date,p_proc_incept_date,p_proc_assd_no,p_pack_sw,p_proc_same_polno_sw,
                            p_new_par_id,p_new_pack_par_id,p_proc_renew_flag,p_user);
      copy_pol_pack_wpolgenin(p_old_pol_id,p_msg,p_new_policy_id,p_user);
      populate_pack_polnrep2(p_new_par_id, p_old_pol_id, p_new_policy_id, p_user);      
  ELSE 
      copy_pol_wpolbas_2(p_new_policy_id, p_msg, p_message_box, p_old_pol_id, p_policy_id, p_proc_expiry_date, 
                         p_proc_incept_date, p_proc_assd_no, p_pack_sw, p_proc_same_polno_sw, p_new_par_id, 
                         p_new_pack_par_id, p_new_pack_policy_id, p_proc_renew_flag, p_user, p_is_subpolicy);
      copy_pol_wpolgenin_2(p_old_pol_id, p_new_policy_id, p_long, p_msg);
      populate_polnrep2(p_new_par_id, p_old_pol_id, p_new_policy_id, p_user);
  END IF;    
  IF p_is_package = 'N' THEN
      IF p_proc_iss_cd = p_iss_ri THEN
         copy_pol_winpolbas_2(p_old_pol_id, p_new_policy_id);
      END IF;
      IF p_pack_sw = 'Y' THEN
         copy_pol_wpack_line_subline_2(p_old_pol_id, p_new_policy_id);
      END IF;
      IF p_pack_sw = 'Y' THEN
        FOR A IN (SELECT   pack_line_cd line_cd, pack_subline_cd subline_cd
                    FROM   gipi_pack_line_subline
                   WHERE   policy_id  =  p_new_policy_id) 
       LOOP
          IF (A.line_cd = p_line_mn OR p_menu_line_cd = 'MN' )
               AND p_open_flag = 'Y' THEN
             NULL;
          ELSE
             IF A.line_cd != p_line_ac OR p_menu_line_cd != 'AC' THEN
               --copy_pol_winspection;
               copy_pol_wlim_liab_2(p_old_pol_id, p_new_policy_id);
             END IF;        
             copy_pol_witem2_2(A.line_cd,A.subline_cd, p_old_pol_id, p_new_policy_id);
             copy_pol_wreqdocs_2(p_old_pol_id, p_proc_line_cd, p_line_su, p_new_policy_id, p_user, p_msg);
             copy_pol_winvoice_2(p_old_pol_id, p_iss_ri, p_proc_iss_cd, p_new_policy_id, p_proc_line_cd, p_user, p_pack_sw, p_msg);        
          END IF;
          copy_pol_wpolwc_2(p_old_pol_id, p_new_policy_id, p_long);
          IF A.line_cd = p_line_ac OR p_menu_line_cd = 'AC' THEN --ivy*
             copy_pol_wbeneficiary_2(p_new_policy_id, p_old_pol_id);
             copy_pol_waccident_item_2(p_new_policy_id, p_old_pol_id);  -- ramil 09/03/96
             copy_pol_wgroup_item_2(p_new_policy_id, p_old_pol_id);     -- beth 11/05/98
             copy_pol_wgrp_itmperil_2(p_new_policy_id, p_old_pol_id, p_proc_line_cd);   -- gmi 05/31/07
             copy_pol_witmperil_ben_2(p_new_policy_id, p_old_pol_id);   -- gmi 05/31/07
             copy_pol_wgrp_items_ben_2(p_new_policy_id, p_old_pol_id);  -- grace 05/15/00
          ELSIF A.line_cd = p_line_ca OR p_menu_line_cd = 'CA' THEN
             copy_pol_wbeneficiary_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wbank_sched_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wcasualty_item_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wcasualty_personnel_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wdeductibles_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wgroup_item_2(p_new_policy_id, p_old_pol_id);     -- beth 11/05/98
             copy_pol_wgrp_items_ben_2(p_new_policy_id, p_old_pol_id);  -- grace 05/15/00
          ELSIF A.line_cd = p_line_en OR p_menu_line_cd = 'EN' THEN
             copy_pol_wengg_basic_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wprincipal_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wdeductibles_2(p_new_policy_id, p_old_pol_id);
             BEGIN
               SELECT param_value_v
                 INTO p_subline_bpv
                 FROM giis_parameters
                WHERE param_name = p_bpv;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  p_msg := 'No record in giis_parameters for engrng. subline '|| p_proc_subline_cd;
             END;
             IF A.subline_cd = p_subline_bpv THEN
                copy_pol_wlocation_2(p_new_policy_id, p_old_pol_id);
             END IF;
          ELSIF A.line_cd = p_line_fi OR p_menu_line_cd = 'FI' THEN
             copy_pol_wfire_2(p_new_policy_id, p_old_pol_id);
          ELSIF A.line_cd = p_line_mc OR p_menu_line_cd = 'MC' THEN
             copy_pol_wvehicle_2(p_old_pol_id, p_new_policy_id);
             copy_pol_wmcacc_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wdeductibles_2(p_new_policy_id, p_old_pol_id);     -- beth 11/05/98
          ELSIF A.line_cd = p_line_su THEN
             copy_pol_wbond_basic_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wcosigntry_2(p_new_policy_id, p_old_pol_id);
             update_collateral_par_2(p_new_par_id, p_new_policy_id, p_old_pol_id);
          ELSIF (A.line_cd IN
               (p_line_mh,p_line_mn,p_line_av) OR 
               p_menu_line_cd IN ('MH','MN','AV')) THEN
             copy_pol_wcargo_hull_2(A.line_cd,A.subline_cd, p_new_policy_id, p_old_pol_id, 
                                    p_line_mn, p_subline_mop, p_subline_mrn, p_line_mh, p_line_av);
         END IF;
       END LOOP;
             update_co_ins_2(p_new_par_id, p_new_policy_id, p_old_pol_id); --BETH 020699
      ELSE
          IF (p_proc_line_cd = p_line_mn OR p_menu_line_cd = 'MN')
               AND p_open_flag = 'Y' THEN
             copy_pol_witem_2(p_new_policy_id, p_old_pol_id);   --BETH   transfer data from gipi_witem and gipi_witmperl to
             copy_pol_witmperl_2(p_proc_line_cd, p_old_pol_id, p_new_policy_id);--011399 its final table
             copy_pol_winvoice_2(p_old_pol_id, p_iss_ri, p_proc_iss_cd, p_new_policy_id, p_proc_line_cd, p_user, p_pack_sw, p_msg);--032999 loth
          ELSE
             IF p_proc_line_cd != p_line_ac OR p_menu_line_cd != 'AC'THEN
               --copy_pol_winspection;
               copy_pol_wlim_liab_2(p_old_pol_id, p_new_policy_id);
             END IF;        
             copy_pol_wreqdocs_2(p_old_pol_id, p_proc_line_cd, p_line_su, p_new_policy_id, p_user, p_msg);
             copy_pol_witem_2(p_new_policy_id, p_old_pol_id);
             copy_pol_witmperl_2(p_proc_line_cd, p_old_pol_id, p_new_policy_id);
             copy_pol_winvoice_2(p_old_pol_id, p_iss_ri, p_proc_iss_cd, p_new_policy_id, p_proc_line_cd, p_user, p_pack_sw, p_msg);
             update_co_ins_2(p_new_par_id, p_new_policy_id, p_old_pol_id); --BETH 020699
          END IF;
          copy_pol_wpolwc_2(p_old_pol_id, p_new_policy_id, p_long);
          IF p_proc_line_cd = p_line_ac OR p_menu_line_cd = 'AC' THEN
             copy_pol_wbeneficiary_2(p_new_policy_id, p_old_pol_id);
             copy_pol_waccident_item_2(p_new_policy_id, p_old_pol_id);  -- ramil 09/03/96
             copy_pol_wgroup_item_2(p_new_policy_id, p_old_pol_id);     -- beth 11/05/98         
             copy_pol_wgrp_itmperil_2(p_new_policy_id, p_old_pol_id, p_proc_line_cd);   -- gmi 05/31/07
             copy_pol_witmperil_ben_2(p_new_policy_id, p_old_pol_id);   -- gmi 05/31/07
             copy_pol_wgrp_items_ben_2(p_new_policy_id, p_old_pol_id);  -- grace 05/15/00         
          ELSIF p_proc_line_cd = p_line_ca OR p_menu_line_cd = 'CA' THEN
             copy_pol_wbank_sched_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wcasualty_item_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wcasualty_personnel_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wdeductibles_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wgroup_item_2(p_new_policy_id, p_old_pol_id);     -- beth 11/05/98
             copy_pol_wgrp_items_ben_2(p_new_policy_id, p_old_pol_id);  -- grace 05/15/00
          ELSIF p_proc_line_cd = p_line_en OR p_menu_line_cd = 'EN' THEN
             copy_pol_wengg_basic_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wprincipal_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wdeductibles_2(p_new_policy_id, p_old_pol_id);
             BEGIN
               SELECT param_value_v
                 INTO p_subline_bpv
                 FROM giis_parameters
                WHERE param_name = p_bpv;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  p_msg := 'No record in giis_parameters for engrng. subline '|| p_proc_subline_cd;
             END;
             IF p_proc_subline_cd = p_subline_bpv THEN
                copy_pol_wlocation_2(p_new_policy_id, p_old_pol_id);
             END IF;
          ELSIF p_proc_line_cd = p_line_fi OR p_menu_line_cd = 'FI' THEN
             copy_pol_wfire_2(p_new_policy_id, p_old_pol_id);
          ELSIF p_proc_line_cd = p_line_mc OR p_menu_line_cd = 'MC' THEN
             copy_pol_wvehicle_2(p_old_pol_id, p_new_policy_id);
             copy_pol_wmcacc_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wdeductibles_2(p_new_policy_id, p_old_pol_id);     -- beth 11/05/98
          ELSIF p_proc_line_cd = p_line_su THEN
             copy_pol_wbond_basic_2(p_new_policy_id, p_old_pol_id);
             copy_pol_wcosigntry_2(p_new_policy_id, p_old_pol_id);
             update_collateral_par_2(p_new_par_id, p_new_policy_id, p_old_pol_id);
          ELSIF (p_proc_line_cd IN
               (p_line_mh,p_line_mn,p_line_av) OR 
               p_menu_line_cd IN ('MH','MN','AV')) THEN
             copy_pol_wcargo_hull_2(p_proc_line_cd,p_proc_subline_cd, p_new_policy_id, p_old_pol_id, p_line_mn, p_subline_mop, p_subline_mrn, p_line_mh, p_line_av);
            
         ELSE 
             copy_pol_wbeneficiary_2(p_new_policy_id, p_old_pol_id);
         END IF;
      END IF;
    END IF;  
    
    -- vin 9.27.2010 added for copying distribution details and mini reminder notes
   /* copy_pol_dist_tab_2(p_old_pol_id, p_new_par_id, p_new_policy_id, p_dist_no_new, p_dist_no_old);
    copy_pol_other_dist_tab_2(p_dist_no_old, p_dist_no_new);
    copy_pol_wreminder_2(p_old_pol_id, p_new_par_id, p_user);*/ -- not existing in 5.9.2012 module version of GIEXS004 
    --
    update_polbas2(p_new_policy_id);
END;
/



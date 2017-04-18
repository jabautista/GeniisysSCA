DROP PROCEDURE CPI.COPY_POLICY;

CREATE OR REPLACE PROCEDURE CPI.copy_policy (
   p_proc_line_cd         IN     giis_line.line_cd%TYPE,
   p_menu_line_cd            OUT giis_line.menu_line_cd%TYPE,
   p_is_package           IN     VARCHAR2,
   p_new_policy_id           OUT NUMBER,
   p_new_pack_policy_id      OUT NUMBER,
   p_msg                     OUT VARCHAR2,
   p_message_box          IN OUT VARCHAR2,
   p_old_pol_id           IN     gipi_pack_polbasic.pack_policy_id%TYPE,
   p_policy_id               OUT gipi_pack_polbasic.pack_policy_id%TYPE,
   p_proc_expiry_date     IN     gipi_wpolbas.eff_date%TYPE,
   p_proc_incept_date     IN     gipi_wpolbas.incept_date%TYPE,
   p_proc_assd_no         IN     gipi_wpolbas.assd_no%TYPE,
   p_proc_same_polno_sw   IN     VARCHAR2,
   p_new_par_id              OUT NUMBER,
   p_new_pack_par_id         OUT NUMBER,
   p_proc_renew_flag      IN     VARCHAR2,
   p_user                 IN     gipi_pack_parlist.underwriter%TYPE,
   p_pack_sw                 OUT VARCHAR2,
   p_long                    OUT gipi_polgenin.gen_info%TYPE,
   p_proc_iss_cd          IN     VARCHAR2,
   p_iss_ri               IN     VARCHAR2,
   p_line_mn              IN     VARCHAR2,
   p_open_flag            IN     VARCHAR2,
   p_line_ac              IN     VARCHAR2,
   p_line_su              IN     VARCHAR2,
   p_line_ca              IN     VARCHAR2,
   p_line_en              IN     VARCHAR2,
   p_bpv                  IN     VARCHAR2,
   p_subline_bpv             OUT giis_parameters.param_value_v%TYPE,
   p_proc_subline_cd      IN     VARCHAR2,
   p_line_fi              IN     VARCHAR2,
   p_line_mc              IN     VARCHAR2,
   p_line_mh              IN     VARCHAR2,
   p_line_av              IN     VARCHAR2,
   p_subline_mop          IN     VARCHAR2,
   p_subline_mrn          IN     VARCHAR2,
   p_is_subpolicy         IN     VARCHAR2,
   p_dist_no_old             OUT giuw_policyds.dist_no%TYPE,
   p_dist_no_new             OUT giuw_policyds.dist_no%TYPE,
   p_allow_ar_wdist       IN     VARCHAR2)
IS
   v_dist_no   giuw_pol_dist.dist_no%TYPE;
BEGIN
   /*
   **  Created by   : Robert Virrey
   **  Date Created : 10-14-2011
   **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
   **  Description  : copy_policy program unit
       edited: added p_allow_ar_wdist and AUTO_DIST_NET_RET_2 - irwin - 8.23.2012
   */
   post_pol_par_2 (p_proc_line_cd,
                   p_menu_line_cd,
                   p_is_package,
                   p_new_policy_id,
                   p_new_pack_policy_id,
                   p_msg,
                   p_message_box,
                   p_old_pol_id,
                   p_policy_id,
                   p_proc_expiry_date,
                   p_proc_incept_date,
                   p_proc_assd_no,
                   p_proc_same_polno_sw,
                   p_new_par_id,
                   p_new_pack_par_id,
                   p_proc_renew_flag,
                   p_user,
                   p_pack_sw,
                   p_long,
                   p_proc_iss_cd,
                   p_iss_ri,
                   p_line_mn,
                   p_open_flag,
                   p_line_ac,
                   p_line_su,
                   p_line_ca,
                   p_line_en,
                   p_bpv,
                   p_subline_bpv,
                   p_proc_subline_cd,
                   p_line_fi,
                   p_line_mc,
                   p_line_mh,
                   p_line_av,
                   p_subline_mop,
                   p_subline_mrn,
                   p_is_subpolicy,
                   p_dist_no_old,
                   p_dist_no_new);

   IF NVL (p_is_package, 'N') = 'N'
   THEN            --added by gmi 060507 (sub policy lng ang dpat dumaan d2..)
      IF NVL (p_allow_ar_wdist, 'N') = 'Y'
      THEN
         dist_giuw_pol_dist_2 (v_dist_no,
                               p_msg,
                               p_new_policy_id,
                               p_new_par_id);
         AUTO_DIST_NET_RET_2 (v_dist_no, p_new_policy_id); -- ADDED BASED ON 5.9.2012 GIEXS004 MODULE VERSION - IRWIN
      ELSE
         process_distribution_2 (p_new_par_id,
                                 p_new_policy_id,
                                 p_proc_line_cd,
                                 p_proc_subline_cd,
                                 p_proc_iss_cd,
                                 p_pack_sw,
                                 p_msg);
      END IF;
   END IF;
END;
/



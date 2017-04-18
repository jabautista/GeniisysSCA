CREATE OR REPLACE PACKAGE CPI.giri_distfrps_pkg
AS
   TYPE giri_distfrps_type IS RECORD (
      line_cd             giri_distfrps.line_cd%TYPE,
      frps_yy             giri_distfrps.frps_yy%TYPE,
      frps_seq_no         giri_distfrps.frps_seq_no%TYPE,
      dist_no             giri_distfrps.dist_no%TYPE,
      dist_seq_no         giri_distfrps.dist_seq_no%TYPE,
      tsi_amt             giri_distfrps.tsi_amt%TYPE,
      tot_fac_spct        giri_distfrps.tot_fac_spct%TYPE,
      tot_fac_tsi         giri_distfrps.tot_fac_tsi%TYPE,
      prem_amt            giri_distfrps.prem_amt%TYPE,
      tot_fac_prem        giri_distfrps.tot_fac_prem%TYPE,
      ri_flag             giri_distfrps.ri_flag%TYPE,
      currency_cd         giri_distfrps.currency_cd%TYPE,
      currency_rt         giri_distfrps.currency_rt%TYPE,
      create_date         giri_distfrps.create_date%TYPE,
      user_id             giri_distfrps.user_id%TYPE,
      prem_warr_sw        giri_distfrps.prem_warr_sw%TYPE,
      claims_coop_sw      giri_distfrps.claims_coop_sw%TYPE,
      claims_control_sw   giri_distfrps.claims_control_sw%TYPE,
      loc_voy_unit        giri_distfrps.loc_voy_unit%TYPE,
      op_sw               giri_distfrps.op_sw%TYPE,
      op_group_no         giri_distfrps.op_group_no%TYPE,
      op_frps_yy          giri_distfrps.op_frps_yy%TYPE,
      op_frps_seq_no      giri_distfrps.op_frps_seq_no%TYPE,
      cpi_rec_no          giri_distfrps.cpi_rec_no%TYPE,
      cpi_branch_cd       giri_distfrps.cpi_branch_cd%TYPE,
      tot_fac_spct2       giri_distfrps.tot_fac_spct2%TYPE,
      arc_ext_data        giri_distfrps.arc_ext_data%TYPE,
      par_id              gipi_parlist.par_id%TYPE,
      frps_no             VARCHAR2 (50),
      iss_cd              gipi_parlist.iss_cd%TYPE,
      par_yy              gipi_parlist.par_yy%TYPE,
      par_seq_no          gipi_parlist.par_seq_no%TYPE,
      quote_seq_no        gipi_parlist.quote_seq_no%TYPE,
      par_no              VARCHAR2 (50),
      par_type            gipi_parlist.par_type%TYPE,
      policy_no           VARCHAR2 (50),
      endt_iss_cd         gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy             gipi_polbasic.endt_yy%TYPE,
      endt_seq_no         gipi_polbasic.endt_seq_no%TYPE,
      endt_no             VARCHAR2 (50),
      assd_name           giis_assured.assd_name%TYPE,
      pack_pol_no         VARCHAR2 (50),
      eff_date            gipi_polbasic.eff_date%TYPE,
      expiry_date         gipi_polbasic.expiry_date%TYPE,
      ref_pol_no          gipi_polbasic.ref_pol_no%TYPE,
      curr_desc           giis_currency.currency_desc%TYPE,
      dist_flag           giuw_pol_dist.dist_flag%TYPE,
      dist_desc           VARCHAR2 (50),
      reg_policy_sw       gipi_polbasic.reg_policy_sw%TYPE,
      spcl_pol_tag        NUMBER,
      dist_spct1          giuw_wpolicyds_dtl.dist_spct%TYPE,
      dist_by_tsi_prem    NUMBER,
      subline_cd          gipi_polbasic.subline_cd%TYPE,
      issue_yy            gipi_polbasic.issue_yy%TYPE,
      pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
      renew_no            giri_distfrps_wdistfrps_v.renew_no%TYPE
   );

   TYPE giri_distfrps_tab IS TABLE OF giri_distfrps_type;

   PROCEDURE del_giri_distfrps (
      p_frps_seq_no   IN   giri_distfrps.frps_seq_no%TYPE,
      p_frps_yy       IN   giri_distfrps.frps_yy%TYPE
   );

   FUNCTION check_dist_flag (
      p_dist_no       giri_distfrps.dist_no%TYPE,
      p_dist_seq_no   giri_distfrps.dist_seq_no%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_giri_distfrps (p_dist_no IN giri_distfrps.dist_no%TYPE)
      RETURN giri_distfrps_tab PIPELINED;

   FUNCTION get_giri_frpslist (
      p_user_id       giis_users.user_id%TYPE,
      p_module_id     giis_user_grp_modules.module_id%TYPE,
      p_line_cd       gipi_parlist.line_cd%TYPE,
      p_frps_yy       giri_distfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps.frps_seq_no%TYPE,
      p_iss_cd        gipi_parlist.iss_cd%TYPE,
      p_par_yy        gipi_parlist.par_yy%TYPE,
      p_par_seq_no    gipi_parlist.par_seq_no%TYPE,
      p_endt_yy       gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
	  p_assd_name     giis_assured.assd_name%TYPE,
	  p_dist_no       giri_distfrps.dist_no%TYPE      
   )
      RETURN giri_distfrps_tab PIPELINED;

   PROCEDURE create_giri_distfrps_giris026 (
      p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
   );

   PROCEDURE update_flag_giris026 (
      p_line_cd             giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy             giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no         giri_distfrps_wdistfrps_v.frps_seq_no%TYPE,
      p_dist_no             giri_distfrps_wdistfrps_v.dist_no%TYPE,
      p_dist_seq_no         giri_distfrps_wdistfrps_v.dist_seq_no%TYPE,
      p_param         OUT   VARCHAR2
   );

   FUNCTION get_giri_frpslist2 (
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )
      RETURN giri_distfrps_tab PIPELINED;

   FUNCTION get_pack_pol_no_giris006 (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_ref_pol_no_giris006 (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_par_yy         gipi_parlist.par_yy%TYPE,
      p_par_seq_no     gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no   gipi_parlist.quote_seq_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_policy_no_giris006 (p_dist_no giuw_pol_dist.dist_no%TYPE)
      RETURN VARCHAR2;

   PROCEDURE complete_ri_posting (
      p_line_cd               giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_subline_cd            giri_distfrps_wdistfrps_v.subline_cd%TYPE,
      p_iss_cd                giri_distfrps_wdistfrps_v.iss_cd%TYPE,
      p_issue_yy              giri_distfrps_wdistfrps_v.issue_yy%TYPE,
      p_pol_seq_no            giri_distfrps_wdistfrps_v.pol_seq_no%TYPE,
      p_renew_no              giri_distfrps_wdistfrps_v.renew_no%TYPE,
      p_frps_yy               giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no           giri_distfrps_wdistfrps_v.frps_seq_no%TYPE,
      p_dist_no               giri_distfrps_wdistfrps_v.dist_no%TYPE,
      p_dist_seq_no           giri_distfrps_wdistfrps_v.dist_seq_no%TYPE,
      p_param           OUT   VARCHAR2
   );
   
      FUNCTION get_giri_frpslist3 (
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )      
      RETURN giri_distfrps_tab PIPELINED;
      
      
     FUNCTION get_giri_frpslist4 (
      p_user_id       GIIS_USERS.user_id%TYPE,
      p_module_id     GIIS_USER_GRP_MODULES.module_id%TYPE,
      p_line_cd       GIPI_PARLIST.line_cd%TYPE,
      p_frps_yy       GIRI_DISTFRPS.frps_yy%TYPE,
      p_frps_seq_no   GIRI_DISTFRPS.frps_seq_no%TYPE
   )      
      RETURN giri_distfrps_tab PIPELINED;
      
    PROCEDURE update_distfrps (
        p_line_cd       IN giri_frps_ri.line_cd%TYPE,
        p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
        p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE,
        p_dist_no       IN giuw_pol_dist.dist_no%TYPE
    );
   
    PROCEDURE CHECK_FOR_RI_RECORDS(
        p_dist_no       giri_distfrps.dist_no%TYPE,
        p_ri_sw     OUT VARCHAR2
        );
        
    PROCEDURE CREATE_GIRI_DISTFRPS_GIUTS021 (p_line_cd     IN giri_distfrps.line_cd%TYPE,
                                    p_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                                    p_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE);
           
END giri_distfrps_pkg;
/



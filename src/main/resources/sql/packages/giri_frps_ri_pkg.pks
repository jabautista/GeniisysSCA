CREATE OR REPLACE PACKAGE CPI.giri_frps_ri_pkg
AS
   TYPE giri_frps_ri_type IS RECORD (
      line_cd                  giri_frps_ri.line_cd%TYPE,
      frps_yy                  giri_frps_ri.frps_yy%TYPE,
      frps_seq_no              giri_frps_ri.frps_seq_no%TYPE,
      ri_seq_no                giri_frps_ri.ri_seq_no%TYPE,
      ri_cd                    giri_frps_ri.ri_cd%TYPE,
      fnl_binder_id            giri_frps_ri.fnl_binder_id%TYPE,
      ri_shr_pct               giri_frps_ri.ri_shr_pct%TYPE,
      ri_tsi_amt               giri_frps_ri.ri_tsi_amt%TYPE,
      ri_prem_amt              giri_frps_ri.ri_prem_amt%TYPE,
      reverse_sw               giri_frps_ri.reverse_sw%TYPE,
      ann_ri_s_amt             giri_frps_ri.ann_ri_s_amt%TYPE,
      ann_ri_pct               giri_frps_ri.ann_ri_pct%TYPE,
      ri_comm_rt               giri_frps_ri.ri_comm_rt%TYPE,
      ri_comm_amt              giri_frps_ri.ri_comm_amt%TYPE,
      prem_tax                 giri_frps_ri.prem_tax%TYPE,
      other_charges            giri_frps_ri.other_charges%TYPE,
      renew_sw                 giri_frps_ri.renew_sw%TYPE,
      facoblig_sw              giri_frps_ri.facoblig_sw%TYPE,
      bndr_remarks1            giri_frps_ri.bndr_remarks1%TYPE,
      bndr_remarks2            giri_frps_ri.bndr_remarks2%TYPE,
      bndr_remarks3            giri_frps_ri.bndr_remarks3%TYPE,
      remarks                  giri_frps_ri.remarks%TYPE,
      delete_sw                giri_frps_ri.delete_sw%TYPE,
      revrs_bndr_print_date    giri_frps_ri.revrs_bndr_print_date%TYPE,
      last_update              giri_frps_ri.last_update%TYPE,
      master_bndr_id           giri_frps_ri.master_bndr_id%TYPE,
      cpi_rec_no               giri_frps_ri.cpi_rec_no%TYPE,
      cpi_branch_cd            giri_frps_ri.cpi_branch_cd%TYPE,
      bndr_printed_cnt         giri_frps_ri.bndr_printed_cnt%TYPE,
      revrs_bndr_printed_cnt   giri_frps_ri.revrs_bndr_printed_cnt%TYPE,
      ri_as_no                 giri_frps_ri.ri_as_no%TYPE,
      ri_accept_by             giri_frps_ri.ri_accept_by%TYPE,
      ri_accept_date           giri_frps_ri.ri_accept_date%TYPE,
      ri_shr_pct2              giri_frps_ri.ri_shr_pct2%TYPE,
      ri_prem_vat              giri_frps_ri.ri_prem_vat%TYPE,
      ri_comm_vat              giri_frps_ri.ri_comm_vat%TYPE,
      ri_wholding_vat          giri_frps_ri.ri_wholding_vat%TYPE,
      address1                 giri_frps_ri.address1%TYPE,
      address2                 giri_frps_ri.address2%TYPE,
      address3                 giri_frps_ri.address3%TYPE,
      prem_warr_days           giri_frps_ri.prem_warr_days%TYPE,
      prem_warr_tag            giri_frps_ri.prem_warr_tag%TYPE,
      pack_binder_id           giri_frps_ri.pack_binder_id%TYPE,
      arc_ext_data             giri_frps_ri.arc_ext_data%TYPE,
      dsp_ri_sname             giis_reinsurer.ri_name%TYPE,
      attention                giri_binder.attention%TYPE,
      dsp_frps_no              VARCHAR2 (32000),
      binder_no                VARCHAR2 (32000),
      dsp_grp_bdr              VARCHAR2 (32000),
      currency_rt              VARCHAR2 (32000),
      currency_cd              VARCHAR2 (32000),
      dsp_policy_no            VARCHAR2 (32000),
      gen_sw                   VARCHAR2(1)
   );

   TYPE giri_frps_ri_tab IS TABLE OF giri_frps_ri_type;

   TYPE giri_binder_tg_type IS RECORD (
      dsp_frps_no         VARCHAR2 (50),
      dsp_binder_no       VARCHAR2 (50),
      dsp_reinsurer       VARCHAR2 (50),
      dsp_grp_binder_no   VARCHAR2 (50),
      ri_cd               giri_frps_ri.ri_cd%TYPE,
      line_cd             giri_frps_ri.line_cd%TYPE,
      frps_yy             giri_frps_ri.frps_yy%TYPE,
      frps_seq_no         giri_frps_ri.frps_seq_no%TYPE,
      binder_yy           giri_binder.binder_yy%TYPE,
      binder_seq_no       giri_binder.binder_seq_no%TYPE,
      grp_binder_yy       giri_group_binder.binder_yy%TYPE,
      grp_binder_seq_no   giri_group_binder.binder_seq_no%TYPE,
      ri_shr_pct          giri_frps_ri.ri_shr_pct%TYPE,
      ri_tsi_amt          VARCHAR (100),
      ri_prem_amt         VARCHAR (100),
      ri_seq_no           giri_frps_ri.ri_seq_no%TYPE,
      fnl_binder_id       giri_frps_ri.fnl_binder_id%TYPE,
      ann_ri_pct          giri_frps_ri.ann_ri_pct%TYPE,
      ann_ri_s_amt        giri_frps_ri.ann_ri_s_amt%TYPE,
      ri_comm_rt          giri_frps_ri.ri_comm_rt%TYPE,
      ri_comm_amt         giri_frps_ri.ri_comm_amt%TYPE,
      prem_tax            giri_frps_ri.prem_tax%TYPE,
      renew_sw            giri_frps_ri.renew_sw%TYPE,
      master_bndr_id      giri_frps_ri.master_bndr_id%TYPE,
      currency_rt         giri_distfrps.currency_rt%TYPE,
      currency_cd         giri_distfrps.currency_cd%TYPE
   );

   TYPE giri_binder_tg_tab IS TABLE OF giri_binder_tg_type;

   TYPE get_binder_id_type IS RECORD (
      binder_id   VARCHAR2 (3200)
   );

   TYPE get_binder_id_tab IS TABLE OF get_binder_id_type;

   PROCEDURE delete_mrecords_giris026 (
      p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
   );

   PROCEDURE create_giri_frps_ri_binder (
      p_line_cd         giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy         giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no     giri_distfrps_wdistfrps_v.frps_seq_no%TYPE,
      p_dist_no         giri_distfrps_wdistfrps_v.dist_no%TYPE,
      p_iss_cd          giri_distfrps_wdistfrps_v.iss_cd%TYPE,
      p_par_policy_id   giri_distfrps_wdistfrps_v.par_policy_id%TYPE
   );

   PROCEDURE update_bindrel (
      p_line_cd       giri_frps_ri.line_cd%TYPE,
      p_frps_yy       giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_frps_ri.frps_seq_no%TYPE,
      p_ri_cd         giri_frps_ri.ri_cd%TYPE,
      p_binder_id     giri_frps_ri.fnl_binder_id%TYPE
   );

   FUNCTION get_giri_frps_ri (p_dist_no giuw_pol_dist.dist_no%TYPE)
      RETURN giri_frps_ri_tab PIPELINED;

   FUNCTION get_giri_frps_ri2 (
      p_line_cd       giri_frps_ri.line_cd%TYPE,
      p_frps_yy       giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_frps_ri.frps_seq_no%TYPE
   )
      RETURN giri_frps_ri_tab PIPELINED;

   PROCEDURE reverse_binder (
      p_fnl_binder_id   IN   giri_frps_ri.fnl_binder_id%TYPE,
      p_line_cd         IN   giri_frps_ri.line_cd%TYPE,
      p_frps_yy         IN   giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no     IN   giri_frps_ri.frps_seq_no%TYPE,
      p_dist_no         IN   giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE delete_mrecords_giuts021 (
      p_line_cd       IN   giri_distfrps.line_cd%TYPE,
      p_frps_yy       IN   giri_distfrps.frps_yy%TYPE,
      p_frps_seq_no   IN   giri_distfrps.frps_seq_no%TYPE
   );

   PROCEDURE create_giri_frps_ri_binder2 (
      p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
      v_line_cd1      IN   giri_distfrps.line_cd%TYPE,
      v_frps_yy       IN   giri_distfrps.frps_yy%TYPE,
      v_frps_seq_no   IN   giri_distfrps.frps_seq_no%TYPE
   );

   FUNCTION get_giri_frps_ri3 (
      p_pack_policy_id   gipi_polbasic.pack_policy_id%TYPE
   )
      RETURN giri_frps_ri_tab PIPELINED;

   FUNCTION get_binder_tg (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN giri_binder_tg_tab PIPELINED;
   
   FUNCTION get_binder_id
      RETURN NUMBER;
   PROCEDURE create_binder_peril_giris053(
      p_binder_id           NUMBER
    );

   PROCEDURE update_master_bndr_id (
      p_line_cd             giri_frps_ri.line_cd%TYPE,
      p_frps_yy             giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no         giri_frps_ri.frps_seq_no%TYPE,
      p_ri_cd               giri_frps_ri.ri_cd%TYPE,
      p_binder_id           NUMBER
   );

   PROCEDURE create_binder (
      p_line_cd             giri_frps_ri.line_cd%TYPE,
      p_ri_cd               giri_frps_ri.ri_cd%TYPE,
      p_binder_id           NUMBER ,
      P_USER_ID             VARCHAR2
   );

   PROCEDURE reverse_package_binder (
      p_pack_binder_id   giri_frps_ri.pack_binder_id%TYPE
   );

   PROCEDURE create_pack_binder (
      p_pack_line_cd     giis_fbndr_seq.line_cd%TYPE,
      p_pack_binder_id   giri_frps_ri.pack_binder_id%TYPE,
      p_pack_policy_id   giri_pack_binder_hdr.pack_policy_id%TYPE,
      p_ri_cd            giri_frps_ri.ri_cd%TYPE,
      p_currency_cd      giri_distfrps.currency_cd%TYPE,
      p_currency_rt      giri_distfrps.currency_rt%TYPE
   );

   TYPE gen_package_binder_type IS RECORD (
      ri_cd            giri_frps_ri.ri_cd%TYPE,
      currency_cd      giri_distfrps.currency_cd%TYPE,
      currency_rt      giri_distfrps.currency_rt%TYPE,
      pack_binder_id   giri_frps_ri.pack_binder_id%TYPE
   );

   TYPE gen_package_binder_tab IS TABLE OF gen_package_binder_type;

   PROCEDURE gen_package_binder (
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_line_cd   gipi_pack_parlist.line_cd%TYPE
   );

   PROCEDURE update_pack_binder_id (
      p_ri_cd            giri_frps_ri.ri_cd%TYPE,
      p_currency_cd      giri_distfrps.currency_cd%TYPE,
      p_currency_rt      giri_distfrps.currency_rt%TYPE,
      p_line_cd          giri_frps_ri.line_cd%TYPE,
      p_frps_yy          giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no      giri_frps_ri.frps_seq_no%TYPE,
      p_fnl_binder_id    giri_frps_ri.fnl_binder_id%TYPE,
      v_ri_cd            giri_frps_ri.ri_cd%TYPE,
      v_currency_cd      giri_distfrps.currency_cd%TYPE,
      v_currency_rt      giri_distfrps.currency_rt%TYPE,
      v_pack_binder_id   giri_frps_ri.pack_binder_id%TYPE
   );
    
    PROCEDURE ungroup_binders(
       p_master_bndr_id   NUMBER
    );

END giri_frps_ri_pkg;
/



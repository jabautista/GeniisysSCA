CREATE OR REPLACE PACKAGE CPI.gipis109_pkg
AS
   TYPE giis_vessel_type IS RECORD (
      vessel_cd         giis_vessel.vessel_cd%TYPE,
      vessel_name       giis_vessel.vessel_name%TYPE,
      vessel_flag       giis_vessel.vessel_flag%TYPE,
      nbt_vestype       VARCHAR2 (50),
      exclude_expired   VARCHAR2 (1),
      exclude_not_eff   VARCHAR2 (1),
      bus_type          NUMBER (1),
      line_mn           giis_parameters.param_value_v%TYPE,
      line_mh           giis_parameters.param_value_v%TYPE,
      line_av           giis_parameters.param_value_v%TYPE,
      line_mn_msg       VARCHAR2 (100),
      line_mh_msg       VARCHAR2 (100),
      line_av_msg       VARCHAR2 (100)
   );

   TYPE giis_vessel_tab IS TABLE OF giis_vessel_type;

   TYPE vessel_accum_dtl_type IS RECORD (
      actual         NUMBER (16, 2),
      TEMPORARY      NUMBER (16, 2),
      expo_sum       NUMBER (16, 2),
      rv_low_value   cg_ref_codes.rv_low_value%TYPE,
      line_cd        giis_line.line_cd%TYPE
   );

   TYPE vessel_accum_dtl_tab IS TABLE OF vessel_accum_dtl_type;

   TYPE share_exposure_type IS RECORD (
      actual      NUMBER (16, 2),
      TEMPORARY   NUMBER (16, 2),
      expo_sum    NUMBER (16, 2),
      share_cd    giis_dist_share.share_cd%TYPE,
      line_cd     giis_line.line_cd%TYPE,
      trty_name   giis_dist_share.trty_name%TYPE
   );

   TYPE share_exposure_tab IS TABLE OF share_exposure_type;

   TYPE actual_exposure_type IS RECORD (
      policy_id          gixx_vessel_acc_dist.policy_id%TYPE,
      line_cd            gixx_vessel_acc_dist.line_cd%TYPE,
      subline_cd         gixx_vessel_acc_dist.subline_cd%TYPE,
      iss_cd             gixx_vessel_acc_dist.iss_cd%TYPE,
      issue_yy           gixx_vessel_acc_dist.issue_yy%TYPE,
      pol_seq_no         gixx_vessel_acc_dist.pol_seq_no%TYPE,
      renew_no           gixx_vessel_acc_dist.renew_no%TYPE,
      item_no            gixx_vessel_acc_dist.item_no%TYPE,
      dist_flag          gixx_vessel_acc_dist.dist_flag%TYPE,
      dist_tsi           gixx_vessel_acc_dist.dist_tsi%TYPE,
      ann_tsi_amt        gixx_vessel_acc_dist.ann_tsi_amt%TYPE,
      assd_no            gixx_vessel_acc_dist.assd_no%TYPE,
      assd_name          gixx_vessel_acc_dist.assd_name%TYPE,
      eff_date           gixx_vessel_acc_dist.eff_date%TYPE,
      incept_date        gixx_vessel_acc_dist.incept_date%TYPE,
      expiry_date        gixx_vessel_acc_dist.expiry_date%TYPE,
      endt_expiry_date   gixx_vessel_acc_dist.endt_expiry_date%TYPE,
      peril_cd           gixx_vessel_acc_dist.peril_cd%TYPE,
      prem_rt            gixx_vessel_acc_dist.prem_rt%TYPE,
      peril_sname        gixx_vessel_acc_dist.peril_sname%TYPE,
      peril_name         gixx_vessel_acc_dist.peril_name%TYPE,
      vessel_cd          gixx_vessel_acc_dist.vessel_cd%TYPE,
      eta                gixx_vessel_acc_dist.eta%TYPE,
      etd                gixx_vessel_acc_dist.etd%TYPE,
      bl_awb             gixx_vessel_acc_dist.bl_awb%TYPE,
      cargo_type         gixx_vessel_acc_dist.cargo_type%TYPE,
      cargo_class_cd     gixx_vessel_acc_dist.cargo_class_cd%TYPE,
      cargo_type_desc    gixx_vessel_acc_dist.cargo_type_desc%TYPE,
      cargo_class_desc   gixx_vessel_acc_dist.cargo_class_desc%TYPE,
      endt_seq_no        gixx_vessel_acc_dist.endt_seq_no%TYPE,
      policy_no          VARCHAR2 (50),
      expired            VARCHAR2 (1),
      not_yet_eff        VARCHAR2 (1),
      item_title         gipi_item.item_title%TYPE,
      nbt_dist_status    VARCHAR2 (100),
      dsp_expiry_date    VARCHAR2 (50),
      dsp_eta            VARCHAR2 (50),
      dsp_etd            VARCHAR2 (50)
   );

   TYPE actual_exposure_tab IS TABLE OF actual_exposure_type;

   TYPE temporary_exposure_type IS RECORD (
      line_cd            gipi_vessel_acc_dist_v2.line_cd%TYPE,
      subline_cd         gipi_vessel_acc_dist_v2.subline_cd%TYPE,
      iss_cd             gipi_vessel_acc_dist_v2.iss_cd%TYPE,
      issue_yy           gipi_vessel_acc_dist_v2.issue_yy%TYPE,
      renew_no           gipi_vessel_acc_dist_v2.renew_no%TYPE,
      pol_flag           gipi_vessel_acc_dist_v2.pol_flag%TYPE,
      incept_date        gipi_vessel_acc_dist_v2.incept_date%TYPE,
      expiry_date        gipi_vessel_acc_dist_v2.expiry_date%TYPE,
      endt_expiry_date   gipi_vessel_acc_dist_v2.endt_expiry_date%TYPE,
      eff_date           gipi_vessel_acc_dist_v2.eff_date%TYPE,
      endt_seq_no        gipi_vessel_acc_dist_v2.endt_seq_no%TYPE,
      endt_yy            gipi_vessel_acc_dist_v2.endt_yy%TYPE,
      endt_iss_cd        gipi_vessel_acc_dist_v2.endt_iss_cd%TYPE,
      item_no            gipi_vessel_acc_dist_v2.item_no%TYPE,
      vessel_cd          gipi_vessel_acc_dist_v2.vessel_cd%TYPE,
      ann_tsi_amt        gipi_vessel_acc_dist_v2.ann_tsi_amt%TYPE,
      tsi_amt            gipi_vessel_acc_dist_v2.tsi_amt%TYPE,
      rec_flag           gipi_vessel_acc_dist_v2.rec_flag%TYPE,
      dist_flag          gipi_vessel_acc_dist_v2.dist_flag%TYPE,
      par_id             gipi_vessel_acc_dist_v2.par_id%TYPE,
      par_yy             gipi_vessel_acc_dist_v2.par_yy%TYPE,
      quote_seq_no       gipi_vessel_acc_dist_v2.quote_seq_no%TYPE,
      par_seq_no         gipi_vessel_acc_dist_v2.par_seq_no%TYPE,
      assd_no            gipi_vessel_acc_dist_v2.assd_no%TYPE,
      dist_tsi           gipi_vessel_acc_dist_v2.dist_tsi%TYPE,
      assd_name          gipi_vessel_acc_dist_v2.assd_name%TYPE,
      peril_cd           gipi_vessel_acc_dist_v4.peril_cd%TYPE,
      peril_sname        gipi_vessel_acc_dist_v4.peril_sname%TYPE,
      peril_name         gipi_vessel_acc_dist_v4.peril_name%TYPE,
      prem_rt            gipi_vessel_acc_dist_v4.prem_rt%TYPE,
      par_no             VARCHAR2 (50),
      item_title         gipi_witem.item_title%TYPE,
      expired            VARCHAR2 (1),
      not_yet_eff        VARCHAR2 (1),
      eta                gipi_wcargo.eta%TYPE,
      etd                gipi_wcargo.etd%TYPE,
      bl_awb             gipi_wcargo.bl_awb%TYPE,
      cargo_class        giis_cargo_class.cargo_class_desc%TYPE,
      cargo_type         giis_cargo_type.cargo_type_desc%TYPE,
      nbt_dist_status    VARCHAR2 (100),
      dsp_expiry_date    VARCHAR2 (50),
      dsp_eta            VARCHAR2 (50),
      dsp_etd            VARCHAR2 (50)
   );

   TYPE temporary_exposure_tab IS TABLE OF temporary_exposure_type;

   FUNCTION get_giis_vessel (p_refresh VARCHAR2, p_enter_query VARCHAR2)
      RETURN giis_vessel_tab PIPELINED;

   FUNCTION get_exposures (
      p_vessel_cd         giis_vessel.vessel_cd%TYPE,
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2
   )
      RETURN vessel_accum_dtl_tab PIPELINED;

   PROCEDURE get_itemds_dtl_act (
      p_exclude_expired            VARCHAR2,
      p_exclude_not_eff            VARCHAR2,
      p_line_cd                    VARCHAR2,
      p_vessel_cd                  giis_vessel.vessel_cd%TYPE,
      p_rv_low_value               cg_ref_codes.rv_low_value%TYPE,
      p_actual            IN OUT   NUMBER
   );

   PROCEDURE get_itemds_dtl_temp (
      p_exclude_expired            VARCHAR2,
      p_exclude_not_eff            VARCHAR2,
      p_line_cd                    VARCHAR2,
      p_vessel_cd                  giis_vessel.vessel_cd%TYPE,
      p_rv_low_value               cg_ref_codes.rv_low_value%TYPE,
      p_temporary         IN OUT   NUMBER
   );

   FUNCTION get_share_exposure (
      p_rv_low_value      cg_ref_codes.rv_low_value%TYPE,
      p_vessel_cd         giis_vessel.vessel_cd%TYPE,
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2
   )
      RETURN share_exposure_tab PIPELINED;

   PROCEDURE get_itemds_act_x (
      p_exclude_expired            VARCHAR2,
      p_exclude_not_eff            VARCHAR2,
      p_line_cd                    VARCHAR2,
      p_line_cd2                   VARCHAR2,
      p_vessel_cd                  giis_vessel.vessel_cd%TYPE,
      p_share_cd                   giis_dist_share.share_cd%TYPE,
      p_actual            IN OUT   NUMBER
   );

   PROCEDURE get_itemds_temp_x (
      p_exclude_expired            VARCHAR2,
      p_exclude_not_eff            VARCHAR2,
      p_line_cd                    VARCHAR2,
      p_line_cd2                   VARCHAR2,
      p_vessel_cd                  giis_vessel.vessel_cd%TYPE,
      p_share_cd                   giis_dist_share.share_cd%TYPE,
      p_temporary         IN OUT   NUMBER
   );

   FUNCTION get_actual_exposure (
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_share_cd          gixx_vessel_acc_dist.share_cd%TYPE,
      p_vessel_cd         VARCHAR2,
      p_all               VARCHAR2
   )
      RETURN actual_exposure_tab PIPELINED;

   FUNCTION get_temporary_exposure (
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_share_cd          gixx_vessel_acc_dist.share_cd%TYPE,
      p_vessel_cd         giis_vessel.vessel_cd%TYPE,
      p_mode              VARCHAR2,
      p_all               VARCHAR2
   )
      RETURN temporary_exposure_tab PIPELINED;
END;
/



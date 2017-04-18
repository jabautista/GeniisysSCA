CREATE OR REPLACE PACKAGE CPI.gipis111_pkg
AS
   TYPE giis_ca_location_type IS RECORD (
      location_cd      giis_ca_location.location_cd%TYPE,
      location_desc    giis_ca_location.location_desc%TYPE,
      from_date        giis_ca_location.from_date%TYPE,
      TO_DATE          giis_ca_location.TO_DATE%TYPE,
      dsp_from_date    VARCHAR2 (50),
      dsp_to_date      VARCHAR2 (50),
      dsp_from_date2   VARCHAR2 (50),
      dsp_to_date2     VARCHAR2 (50),
      ret_limit        giis_ca_location.ret_limit%TYPE,
      treaty_limit     giis_ca_location.treaty_limit%TYPE,
      remarks          giis_ca_location.remarks%TYPE
   );

   TYPE giis_ca_location_tab IS TABLE OF giis_ca_location_type;

   TYPE giis_ca_location_dtl_type IS RECORD (
      dsp_beg_bal   NUMBER (20, 2),
      dsp_actual    NUMBER (20, 2),
      dsp_temp      NUMBER (20, 2),
      dsp_sum       NUMBER (20, 2)
   );

   TYPE giis_ca_location_dtl_tab IS TABLE OF giis_ca_location_dtl_type;

   TYPE actual_exposure_type IS RECORD (
      line_cd            gixx_ca_accum_dist.line_cd%TYPE,
      subline_cd         gixx_ca_accum_dist.subline_cd%TYPE,
      iss_cd             gixx_ca_accum_dist.iss_cd%TYPE,
      issue_yy           gixx_ca_accum_dist.issue_yy%TYPE,
      pol_seq_no         gixx_ca_accum_dist.pol_seq_no%TYPE,
      renew_no           gixx_ca_accum_dist.renew_no%TYPE,
      policy_id          gixx_ca_accum_dist.policy_id%TYPE,
      item_no            gixx_ca_accum_dist.item_no%TYPE,
      item_title         gipi_item.item_title%TYPE,
      eff_date           gixx_ca_accum_dist.eff_date%TYPE,
      expiry_date        gixx_ca_accum_dist.expiry_date%TYPE,
      endt_expiry_date   gixx_ca_accum_dist.endt_expiry_date%TYPE,
      peril_cd           gixx_ca_accum_dist.peril_cd%TYPE,
      peril_name         gixx_ca_accum_dist.peril_name%TYPE,
      location_cd        gixx_ca_accum_dist.location_cd%TYPE,
      dist_tsi           gixx_ca_accum_dist.dist_tsi%TYPE,
      assd_name          gixx_ca_accum_dist.assd_name%TYPE,
      dist_flag          gixx_ca_accum_dist.dist_flag%TYPE,
      incept_date        gixx_ca_accum_dist.incept_date%TYPE,
      prem_rt            gixx_ca_accum_dist.prem_rt%TYPE,
      policy_no          VARCHAR2 (50),
      ann_tsi_amt        gixx_ca_accum_dist.ann_tsi_amt%TYPE,
      max_expiry         DATE,
      dsp_max_expiry     VARCHAR2 (50),
      expired            VARCHAR2 (1),
      not_yet_eff        VARCHAR2 (1),
      dist_stat          VARCHAR2 (50),
      claim_exists       VARCHAR2 (1),
      claim_id           gicl_claims.claim_id%TYPE
   );

   TYPE actual_exposure_tab IS TABLE OF actual_exposure_type;

   TYPE temporary_exposure_type IS RECORD (
      par_no           VARCHAR2 (50),
      par_id           gipi_ca_item_basic_dist_v.par_id%TYPE,
      line_cd          gipi_ca_item_basic_dist_v.line_cd%TYPE,
      subline_cd       gipi_ca_item_basic_dist_v.subline_cd%TYPE,
      iss_cd           gipi_ca_item_basic_dist_v.iss_cd%TYPE,
      issue_yy         gipi_ca_item_basic_dist_v.issue_yy%TYPE,
      pol_seq_no       gipi_ca_item_basic_dist_v.pol_seq_no%TYPE,
      renew_no         gipi_ca_item_basic_dist_v.renew_no%TYPE,
      par_yy           gipi_ca_item_basic_dist_v.par_yy%TYPE,
      par_seq_no       gipi_ca_item_basic_dist_v.par_seq_no%TYPE,
      quote_seq_no     gipi_ca_item_basic_dist_v.quote_seq_no%TYPE,
      item_no          gipi_ca_item_basic_dist_v.item_no%TYPE,
      item_title       gipi_item.item_title%TYPE,
      location_cd      gipi_ca_item_basic_dist_v.location_cd%TYPE,
      peril_cd         gipi_ca_item_basic_dist_v.peril_cd%TYPE,
      peril_name       gipi_ca_item_basic_dist_v.peril_name%TYPE,
      eff_date         gipi_ca_item_basic_dist_v.eff_date%TYPE,
      expiry_date      gipi_ca_item_basic_dist_v.expiry_date%TYPE,
      dist_tsi         gipi_ca_item_basic_dist_v.dist_tsi%TYPE,
      assd_name        gipi_ca_item_basic_dist_v.assd_name%TYPE,
      ann_tsi_amt      gipi_ca_item_basic_dist_v.ann_tsi_amt%TYPE,
      dist_flag        gipi_ca_item_basic_dist_v.dist_flag%TYPE,
      incept_date      gipi_ca_item_basic_dist_v.incept_date%TYPE,
      prem_rt          gipi_ca_item_basic_dist_v.prem_rt%TYPE,
      max_expiry       DATE,
      dsp_max_expiry   VARCHAR2 (50),
      expired          VARCHAR2 (1),
      not_yet_eff      VARCHAR2 (1),
      dist_stat        VARCHAR2 (50),
      claim_exists     VARCHAR2 (1),
      claim_id         gicl_claims.claim_id%TYPE
   );

   TYPE temporary_exposure_tab IS TABLE OF temporary_exposure_type;

   FUNCTION get_giis_ca_location (p_enter_query VARCHAR2)
      RETURN giis_ca_location_tab PIPELINED;

   FUNCTION get_giis_ca_location_dtl (
      p_location_cd       giis_ca_location.location_cd%TYPE,
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2
   )
      RETURN giis_ca_location_dtl_tab PIPELINED;

   PROCEDURE get_ca_actual_exposure2 (
      p_exclude_expiry    IN       VARCHAR2,
      p_exclude_not_eff   IN       VARCHAR2,
      p_location_cd       IN       gipi_casualty_item.location_cd%TYPE,
      p_share_type        IN       giis_dist_share.share_type%TYPE,
      p_dist_tsi          IN OUT   gixx_ca_accum_dist.dist_tsi%TYPE
   );

   PROCEDURE get_ca_temp_exposure2 (
      p_exclude_expiry    IN       VARCHAR2,
      p_exclude_not_eff   IN       VARCHAR2,
      p_location_cd       IN       gipi_casualty_item.location_cd%TYPE,
      p_share_type        IN       giis_dist_share.share_type%TYPE,
      p_dist_tsi          IN OUT   gixx_ca_accum_dist.dist_tsi%TYPE
   );

   FUNCTION get_actual_exposure (
      p_location_cd       giis_ca_location.location_cd%TYPE,
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_mode              VARCHAR2
   )
      RETURN actual_exposure_tab PIPELINED;

   FUNCTION get_temporary_exposure (
      p_location_cd       giis_ca_location.location_cd%TYPE,
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_mode              VARCHAR2
   )
      RETURN temporary_exposure_tab PIPELINED;
END;
/



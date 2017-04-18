CREATE OR REPLACE PACKAGE CPI.gipis110_pkg
AS
   TYPE province_type IS RECORD (
      province_desc   giis_province.province_desc%TYPE,
      province_cd     giis_province.province_cd%TYPE
   );

   TYPE province_tab IS TABLE OF province_type;

   TYPE city_type IS RECORD (
      city      giis_city.city%TYPE,
      city_cd   giis_city.city_cd%TYPE,
      province_desc   giis_province.province_desc%TYPE,
      province_cd     giis_province.province_cd%TYPE
   );

   TYPE city_tab IS TABLE OF city_type;

   TYPE giis_block_type IS RECORD (
      province_cd     giis_block.province_cd%TYPE,
      city            giis_block.city%TYPE,
      city_cd         giis_block.city_cd%TYPE,
      district_no     giis_block.district_no%TYPE,
      block_no        giis_block.block_no%TYPE,
      block_desc      giis_block.block_desc%TYPE,
      block_id        giis_block.block_id%TYPE,
      retn_lim_amt    giis_block.retn_lim_amt%TYPE,
      trty_lim_amt    giis_block.trty_lim_amt%TYPE,
      district_desc   giis_block.district_desc%TYPE,
      remarks         giis_block.remarks%TYPE
   );

   TYPE giis_block_tab IS TABLE OF giis_block_type;

   TYPE giis_block_dtl_type IS RECORD (
      risk_cd        giis_risks.risk_cd%TYPE,
      risk_desc      giis_risks.risk_desc%TYPE,
      rv_low_value   cg_ref_codes.rv_low_value%TYPE,
      rv_meaning     cg_ref_codes.rv_meaning%TYPE,
      MANUAL         NUMBER (20, 2),
      actual         NUMBER (20, 2),
      TEMPORARY      NUMBER (20, 2),
      expo_sum       NUMBER (20, 2)
   );

   TYPE giis_block_dtl_tab IS TABLE OF giis_block_dtl_type;

   TYPE share_exposure_type IS RECORD (
      actual      NUMBER (20, 2),
      TEMPORARY   NUMBER (20, 2),
      expo_sum    NUMBER (20, 2),
      share_cd    giis_dist_share.share_cd%TYPE,
      line_cd     giis_line.line_cd%TYPE,
      trty_name   giis_dist_share.trty_name%TYPE
   );

   TYPE share_exposure_tab IS TABLE OF share_exposure_type;

   TYPE actual_exposure_type IS RECORD (
      fr_item_type       gixx_block_accumulation_dist.fr_item_type%TYPE,
      block_id           gixx_block_accumulation_dist.block_id%TYPE,
      risk_cd            gixx_block_accumulation_dist.risk_cd%TYPE,
      line_cd            gixx_block_accumulation_dist.line_cd%TYPE,
      assd_no            gixx_block_accumulation_dist.assd_no%TYPE,
      assd_name          gixx_block_accumulation_dist.assd_name%TYPE,
      item_no            gixx_block_accumulation_dist.item_no%TYPE,
      construction_cd    gixx_block_accumulation_dist.construction_cd%TYPE,
      tarf_cd            gixx_block_accumulation_dist.tarf_cd%TYPE,
      subline_cd         gixx_block_accumulation_dist.subline_cd%TYPE,
      iss_cd             gixx_block_accumulation_dist.iss_cd%TYPE,
      issue_yy           gixx_block_accumulation_dist.issue_yy%TYPE,
      pol_seq_no         gixx_block_accumulation_dist.pol_seq_no%TYPE,
      renew_no           gixx_block_accumulation_dist.renew_no%TYPE,
      eff_date           gixx_block_accumulation_dist.eff_date%TYPE,
      expiry_date        gixx_block_accumulation_dist.expiry_date%TYPE,
      loc_risk           gixx_block_accumulation_dist.loc_risk%TYPE,
      district_no        gixx_block_accumulation_dist.district_no%TYPE,
      block_no           gixx_block_accumulation_dist.block_no%TYPE,
      dist_flag          gixx_block_accumulation_dist.dist_flag%TYPE,
      share_type         gixx_block_accumulation_dist.share_type%TYPE,
      province_cd        gixx_block_accumulation_dist.province_cd%TYPE,
      city               gixx_block_accumulation_dist.city%TYPE,
      peril_cd           gixx_block_accumulation_dist.peril_cd%TYPE,
      peril_name         gixx_block_accumulation_dist.peril_name%TYPE,
      peril_sname        gixx_block_accumulation_dist.peril_sname%TYPE,
      prem_rt            gixx_block_accumulation_dist.prem_rt%TYPE,
      incept_date        gixx_block_accumulation.incept_date%TYPE,
      endt_expiry_date   gixx_block_accumulation.endt_expiry_date%TYPE,
      endt_seq_no        gixx_block_accumulation.endt_seq_no%TYPE,
      ann_tsi_amt        gixx_block_accumulation.ann_tsi_amt%TYPE,
      dsp_expiry_date    VARCHAR2 (50),
      dsp_eff_date       VARCHAR2 (50),
      dsp_incept_date    VARCHAR2 (50),
      policy_no          VARCHAR2 (50),
      fire               giis_parameters.param_value_v%TYPE,
      max_expiry         DATE,
      dsp_max_expiry     VARCHAR2 (50),
      expired            VARCHAR2 (1),
      not_yet_eff        VARCHAR2 (1),
      dsp_fr_item_type   giis_fi_item_type.fr_itm_tp_ds%TYPE,
      dist_tsi           NUMBER (20, 2),
      dsp_dist_status    VARCHAR2 (100),
      nbt_cons_desc      giis_fire_construction.construction_desc%TYPE,
      with_claims        NUMBER (12)
   );

   TYPE actual_exposure_tab IS TABLE OF actual_exposure_type;

   TYPE temporary_exposure_type IS RECORD (
      par_id             gipi_fire_basic_item_dist_v2.par_id%TYPE,
      line_cd            gipi_fire_basic_item_dist_v2.line_cd%TYPE,
      subline_cd         gipi_fire_basic_item_dist_v2.subline_cd%TYPE,
      iss_cd             gipi_fire_basic_item_dist_v2.iss_cd%TYPE,
      issue_yy           gipi_fire_basic_item_dist_v2.issue_yy%TYPE,
      par_yy             gipi_fire_basic_item_dist_v2.par_yy%TYPE,
      par_seq_no         gipi_fire_basic_item_dist_v2.par_seq_no%TYPE,
      quote_seq_no       gipi_fire_basic_item_dist_v2.quote_seq_no%TYPE,
      renew_no           gipi_fire_basic_item_dist_v2.renew_no%TYPE,
      item_no            gipi_fire_basic_item_dist_v2.item_no%TYPE,
      district_no        gipi_fire_basic_item_dist_v2.district_no%TYPE,
      block_no           gipi_fire_basic_item_dist_v2.block_no%TYPE,
      pol_flag           gipi_fire_basic_item_dist_v2.pol_flag%TYPE,
      ann_tsi_amt        gipi_fire_basic_item_dist_v2.ann_tsi_amt%TYPE,
      assd_no            gipi_fire_basic_item_dist_v2.assd_no%TYPE,
      assd_name          gipi_fire_basic_item_dist_v2.assd_name%TYPE,
      eff_date           gipi_fire_basic_item_dist_v2.eff_date%TYPE,
      incept_date        gipi_fire_basic_item_dist_v2.incept_date%TYPE,
      expiry_date        gipi_fire_basic_item_dist_v2.expiry_date%TYPE,
      endt_expiry_date   gipi_fire_basic_item_dist_v2.endt_expiry_date%TYPE,
      dist_flag          gipi_fire_basic_item_dist_v2.dist_flag%TYPE,
      tarf_cd            gipi_fire_basic_item_dist_v2.tarf_cd%TYPE,
      construction_cd    gipi_fire_basic_item_dist_v2.construction_cd%TYPE,
      loc_risk           gipi_fire_basic_item_dist_v2.loc_risk%TYPE,
      province_cd        gipi_fire_basic_item_dist_v2.province_cd%TYPE,
      city               gipi_fire_basic_item_dist_v2.city%TYPE,
      block_id           gipi_fire_basic_item_dist_v2.block_id%TYPE,
      dist_tsi           gipi_fire_basic_item_dist_v2.dist_tsi%TYPE,
      share_cd           gipi_fire_basic_item_dist_v2.share_cd%TYPE,
      par_no             gipi_fire_basic_item_dist_v2.par_no%TYPE,
      fr_item_type       gipi_fire_basic_item_dist_v2.fr_item_type%TYPE,
      dsp_fr_item_type   giis_fi_item_type.fr_itm_tp_ds%TYPE,
      risk_cd            gipi_fire_basic_item_dist_v2.risk_cd%TYPE,
      peril_type         gipi_fire_basic_item_dist_v2.peril_type%TYPE,
      peril_cd           gipi_fire_basic_item_dist_v2.peril_cd%TYPE,
      prem_rt            gipi_fire_basic_item_dist_v2.prem_rt%TYPE,
      peril_sname        gipi_fire_basic_item_dist_v2.peril_sname%TYPE,
      peril_name         gipi_fire_basic_item_dist_v2.peril_name%TYPE,
      dsp_expiry_date    VARCHAR2 (50),
      dsp_eff_date       VARCHAR2 (50),
      dsp_incept_date    VARCHAR2 (50),
      dsp_par_no         VARCHAR2 (50),
      fire               giis_parameters.param_value_v%TYPE,
      max_expiry         DATE,
      dsp_max_expiry     VARCHAR2 (50),
      expired            VARCHAR2 (1),
      not_yet_eff        VARCHAR2 (1),
      dsp_dist_status    VARCHAR2 (100),
      nbt_cons_desc      giis_fire_construction.construction_desc%TYPE,
      with_claims        NUMBER (12)
   );

   TYPE temporary_exposure_tab IS TABLE OF temporary_exposure_type;

   FUNCTION get_province
      RETURN province_tab PIPELINED;

   FUNCTION get_city (p_province_cd giis_province.province_cd%TYPE)
      RETURN city_tab PIPELINED;

   FUNCTION get_giis_block (
      p_city_cd       giis_block.city_cd%TYPE,
      p_province_cd   giis_block.province_cd%TYPE
   )
      RETURN giis_block_tab PIPELINED;

   FUNCTION check_fi_access (p_user_id giis_users.user_id%TYPE)
      RETURN NUMBER;

   PROCEDURE get_itemds_dtl_manual (
      p_counter             NUMBER,
      p_block_id            giis_block.block_id%TYPE,
      p_manual     IN OUT   NUMBER
   );

   PROCEDURE get_itemds_dtl_act (
      p_line_cd                 VARCHAR2,
      p_exclude                 VARCHAR2,
      p_exclude_not_eff         VARCHAR2,
      p_user_id                 giis_users.user_id%TYPE,
      p_district_no             giis_block.district_no%TYPE,
      p_block_no                giis_block.block_no%TYPE,
      p_province_cd             giis_block.province_cd%TYPE,
      p_city                    giis_block.city%TYPE,
      p_rv_low_value            cg_ref_codes.rv_low_value%TYPE,
      p_risk_cd                 giis_risks.risk_cd%TYPE,
      p_actual            OUT   NUMBER
   );

   PROCEDURE get_itemds_dtl_temp (
      p_line_cd                 VARCHAR2,
      p_exclude                 VARCHAR2,
      p_exclude_not_eff         VARCHAR2,
      p_user_id                 giis_users.user_id%TYPE,
      p_district_no             giis_block.district_no%TYPE,
      p_block_no                giis_block.block_no%TYPE,
      p_province_cd             giis_block.province_cd%TYPE,
      p_city                    giis_block.city%TYPE,
      p_rv_low_value            cg_ref_codes.rv_low_value%TYPE,
      p_risk_cd                 giis_risks.risk_cd%TYPE,
      p_temporary         OUT   NUMBER,
      p_bus_type                NUMBER
   );

   FUNCTION get_giis_block_dtl (
      p_block_id          giis_block.block_id%TYPE,
      p_exclude_not_eff   VARCHAR2,
      p_exclude           VARCHAR2,
      p_user_id           giis_users.user_id%TYPE,
      p_district_no       giis_block.district_no%TYPE,
      p_block_no          giis_block.block_no%TYPE,
      p_province_cd       giis_block.province_cd%TYPE,
      p_city              giis_block.city%TYPE,
      p_bus_type          NUMBER
   )
      RETURN giis_block_dtl_tab PIPELINED;

   PROCEDURE get_block_act_exposures (
      p_exclude                     VARCHAR2,
      p_exclude_not_eff             VARCHAR2,
      p_user_id                     giis_users.user_id%TYPE,
      p_district_no                 giis_block.district_no%TYPE,
      p_block_no                    giis_block.block_no%TYPE,
      p_province_cd                 giis_block.province_cd%TYPE,
      p_city                        giis_block.city%TYPE,
      p_actual             IN OUT   NUMBER,
      p_block_actual_sum   IN OUT   NUMBER,
      p_risk_cd                     giis_risks.risk_cd%TYPE -- nieko 07132016 KB 894
   );

   PROCEDURE get_block_temp_exposures (
      p_exclude                    VARCHAR2,
      p_exclude_not_eff            VARCHAR2,
      p_user_id                    giis_users.user_id%TYPE,
      p_district_no                giis_block.district_no%TYPE,
      p_block_no                   giis_block.block_no%TYPE,
      p_province_cd                giis_block.province_cd%TYPE,
      p_city                       giis_block.city%TYPE,
      p_block_temp_sum    IN OUT   NUMBER,
      p_risk_cd                    giis_risks.risk_cd%TYPE, -- nieko 07132016 KB 894,
      p_bus_type                   NUMBER
   );

   FUNCTION get_share_exposure (
      p_exclude           VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_rv_low_value      cg_ref_codes.rv_low_value%TYPE,
      p_block_id          giis_block.block_id%TYPE,
      p_district_no       giis_block.district_no%TYPE,
      p_block_no          giis_block.block_no%TYPE,
      p_province_cd       giis_block.province_cd%TYPE,
      p_city              giis_block.city%TYPE,
      p_risk_cd           giis_risks.risk_cd%TYPE
   )
      RETURN share_exposure_tab PIPELINED;

   PROCEDURE get_itemds_act_x (
      p_line_cd                 VARCHAR2,
      p_exclude                 VARCHAR2,
      p_exclude_not_eff         VARCHAR2,
      p_district_no             giis_block.district_no%TYPE,
      p_block_no                giis_block.block_no%TYPE,
      p_province_cd             giis_block.province_cd%TYPE,
      p_city                    giis_block.city%TYPE,
      p_share_line_cd           giis_dist_share.line_cd%TYPE,
      p_share_cd                giis_dist_share.share_cd%TYPE,
      p_risk_cd                 giis_risks.risk_cd%TYPE,
      p_actual            OUT   NUMBER
   );

   PROCEDURE get_itemds_temp_x (
      p_line_cd                 VARCHAR2,
      p_exclude                 VARCHAR2,
      p_exclude_not_eff         VARCHAR2,
      p_district_no             giis_block.district_no%TYPE,
      p_block_no                giis_block.block_no%TYPE,
      p_province_cd             giis_block.province_cd%TYPE,
      p_city                    giis_block.city%TYPE,
      p_share_line_cd           giis_dist_share.line_cd%TYPE,
      p_share_cd                giis_dist_share.share_cd%TYPE,
      p_risk_cd                 giis_risks.risk_cd%TYPE,
      p_temporary         OUT   NUMBER
   );

   FUNCTION get_actual_exposure (
      p_exclude           VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_share_type        gixx_block_accumulation_dist.share_type%TYPE,
      p_block_id          giis_block.block_id%TYPE,
      p_user_id           giis_users.user_id%TYPE,
      p_mode              VARCHAR2,
      p_all               VARCHAR2,
      p_risk_cd           giis_risks.risk_cd%TYPE -- nieko 07132016 KB 894
   )
      RETURN actual_exposure_tab PIPELINED;

   FUNCTION record_claim_exists (
      p_block        VARCHAR2,
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   gicl_claims.pol_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_temporary_exposure (
      p_exclude           VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_share_type        gixx_block_accumulation_dist.share_type%TYPE,
      p_block_id          giis_block.block_id%TYPE,
      p_user_id           giis_users.user_id%TYPE,
      p_mode              VARCHAR2,
      p_all               VARCHAR2,
      p_risk_cd           giis_risks.risk_cd%TYPE -- nieko 07132016 KB 894
   )
      RETURN temporary_exposure_tab PIPELINED;
      
   --nieko 07132016 KB 894
   TYPE giis_block_risk_type IS RECORD (
      block_id        giis_block.block_id%TYPE,
      district_no     giis_block.district_no%TYPE,
      block_no        giis_block.block_no%TYPE,
      block_desc      giis_block.block_desc%TYPE,
      risk_cd         giis_risks.risk_cd%TYPE,
      risk_desc       giis_risks.risk_desc%TYPE,
      retn_lim_amt    giis_block.retn_lim_amt%TYPE,
      trty_lim_amt    giis_block.trty_lim_amt%TYPE
   );

   TYPE giis_block_risk_tab IS TABLE OF giis_block_risk_type;
   
   
   FUNCTION gipis110_block_risk (
      p_block_id        giis_block.block_id%TYPE
   )
      RETURN giis_block_risk_tab PIPELINED;
      
   FUNCTION get_giis_block_risk_dtl (
      p_block_id          giis_block.block_id%TYPE,
      p_exclude_not_eff   VARCHAR2,
      p_exclude           VARCHAR2,
      p_user_id           giis_users.user_id%TYPE,
      p_district_no       giis_block.district_no%TYPE,
      p_block_no          giis_block.block_no%TYPE,
      p_province_cd       giis_block.province_cd%TYPE,
      p_city              giis_block.city%TYPE,
      p_risk_cd           giis_risks.risk_cd%TYPE,
      p_bus_type          NUMBER
   )
      RETURN giis_block_dtl_tab PIPELINED;     
   --nieko 07132016  end
END;
/



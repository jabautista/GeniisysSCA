CREATE OR REPLACE PACKAGE CPI.gipi_witem_pkg
AS
   TYPE item_tsi_prem_type IS RECORD (
      tsi_amt    gipi_witem.tsi_amt%TYPE,
      prem_amt   gipi_witem.prem_amt%TYPE
   );

   TYPE item_tsi_prem_tab IS TABLE OF item_tsi_prem_type;

   TYPE gipi_witem_type IS RECORD (
      par_id                   gipi_witem.par_id%TYPE,
      item_no                  gipi_witem.item_no%TYPE,
      item_title               gipi_witem.item_title%TYPE,
      item_desc                VARCHAR2 (4000),
--GIPI_WITEM.item_desc%TYPE, increased size to have an extra space for replaced special characters by MAC 02/27/2013
      item_desc2               VARCHAR2 (4000),
--GIPI_WITEM.item_desc2%TYPE, increased size to have an extra space for replaced special characters by MAC 02/27/2013
      currency_cd              gipi_witem.currency_cd%TYPE,
      currency_desc            giis_currency.currency_desc%TYPE,
      currency_rt              gipi_witem.currency_rt%TYPE,
      coverage_cd              gipi_witem.coverage_cd%TYPE,
      coverage_desc            giis_coverage.coverage_desc%TYPE,
      group_cd                 gipi_witem.group_cd%TYPE,
      group_desc               giis_group.group_desc%TYPE,
      region_cd                gipi_witem.region_cd%TYPE,
      region_desc              giis_region.region_desc%TYPE,
      pack_line_cd             gipi_witem.pack_line_cd%TYPE,
      pack_subline_cd          gipi_witem.pack_subline_cd%TYPE,
      discount_sw              gipi_witem.discount_sw%TYPE,
      from_date                gipi_witem.from_date%TYPE,
      TO_DATE                  gipi_witem.TO_DATE%TYPE,
      rec_flag                 gipi_witem.rec_flag%TYPE,
      item_grp                 gipi_witem.item_grp%TYPE,
      prem_amt                 gipi_witem.prem_amt%TYPE,
      ann_prem_amt             gipi_witem.ann_prem_amt%TYPE,
      tsi_amt                  gipi_witem.tsi_amt%TYPE,
      ann_tsi_amt              gipi_witem.ann_tsi_amt%TYPE,
      other_info               VARCHAR2 (4000),
--GIPI_WITEM.other_info%TYPE, increased size to have an extra space for replaced special characters by MAC 02/27/2013
      changed_tag              gipi_witem.changed_tag%TYPE,
      prorate_flag             gipi_witem.prorate_flag%TYPE,
      comp_sw                  gipi_witem.comp_sw%TYPE,
      short_rt_percent         gipi_witem.short_rt_percent%TYPE,
      risk_no                  gipi_witem.risk_no%TYPE,
      risk_item_no             gipi_witem.risk_item_no%TYPE,
      payt_terms               gipi_witem.payt_terms%TYPE,
      surcharge_sw             gipi_witem.surcharge_sw%TYPE,
      pack_ben_cd              gipi_witem.pack_ben_cd%TYPE,
      dsp_package_cd           giis_package_benefit.package_cd%TYPE,
      itmperl_grouped_exists   VARCHAR2 (1)
   );

   TYPE gipi_witem_par_type IS RECORD (
      par_id             gipi_witem.par_id%TYPE,
      item_no            gipi_witem.item_no%TYPE,
      item_title         gipi_witem.item_title%TYPE,
      item_grp           gipi_witem.item_grp%TYPE,
      item_desc          VARCHAR2 (4000),
--gipi_witem.item_desc%TYPE, increased size to have an extra space for replaced special characters by MAC 02/27/2013
      item_desc2         VARCHAR2 (4000),
--gipi_witem.item_desc2%TYPE, increased size to have an extra space for replaced special characters by MAC 02/27/2013
      tsi_amt            gipi_witem.tsi_amt%TYPE,
      prem_amt           gipi_witem.prem_amt%TYPE,
      ann_prem_amt       gipi_witem.ann_prem_amt%TYPE,
      ann_tsi_amt        gipi_witem.ann_tsi_amt%TYPE,
      rec_flag           gipi_witem.rec_flag%TYPE,
      currency_cd        gipi_witem.currency_cd%TYPE,
      currency_rt        gipi_witem.currency_rt%TYPE,
      currency_desc      giis_currency.currency_desc%TYPE,
      group_cd           gipi_witem.group_cd%TYPE,
      from_date          gipi_witem.from_date%TYPE,
      TO_DATE            gipi_witem.TO_DATE%TYPE,
      pack_line_cd       gipi_witem.pack_line_cd%TYPE,
      pack_subline_cd    gipi_witem.pack_subline_cd%TYPE,
      discount_sw        gipi_witem.discount_sw%TYPE,
      coverage_cd        gipi_witem.coverage_cd%TYPE,
      other_info         VARCHAR2 (4000),
--gipi_witem.other_info%TYPE, increased size to have an extra space for replaced special characters by MAC 02/27/2013
      surcharge_sw       gipi_witem.surcharge_sw%TYPE,
      region_cd          gipi_witem.region_cd%TYPE,
      risk_no            gipi_witem.risk_no%TYPE,
      risk_item_no       gipi_witem.risk_item_no%TYPE,
      prorate_flag       gipi_witem.prorate_flag%TYPE,
      comp_sw            gipi_witem.comp_sw%TYPE,
      payt_terms         gipi_witem.payt_terms%TYPE,
      changed_tag        gipi_witem.changed_tag%TYPE,
      short_rt_percent   gipi_witem.short_rt_percent%TYPE,
      pack_ben_cd        gipi_witem.pack_ben_cd%TYPE
   );

   TYPE gipi_witem_tab IS TABLE OF gipi_witem_type;

   TYPE item_no_type IS RECORD (
      item_no   gipi_witem.item_no%TYPE
   );

   TYPE item_no_tab IS TABLE OF item_no_type;

   TYPE gipi_witem_par_tab IS TABLE OF gipi_witem_par_type;

   FUNCTION get_gipi_witem (p_par_id gipi_witem.par_id%TYPE)
      RETURN gipi_witem_tab PIPELINED;

   FUNCTION get_gipi_witem (
      p_par_id    gipi_witem.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN gipi_witem_tab PIPELINED;

   PROCEDURE set_gipi_witem (
      v_par_id            IN   gipi_witem.par_id%TYPE,
      v_item_no           IN   gipi_witem.item_no%TYPE,
      v_item_title        IN   gipi_witem.item_title%TYPE,
      v_item_desc         IN   gipi_witem.item_desc%TYPE,
      v_item_desc2        IN   gipi_witem.item_desc2%TYPE,
      v_currency_cd       IN   gipi_witem.currency_cd%TYPE,
      v_currency_rt       IN   gipi_witem.currency_rt%TYPE,
      v_coverage_cd       IN   gipi_witem.coverage_cd%TYPE,
      v_group_cd          IN   gipi_witem.group_cd%TYPE,
      v_region_cd         IN   gipi_witem.region_cd%TYPE,
      v_pack_line_cd      IN   gipi_witem.pack_line_cd%TYPE,
      v_pack_subline_cd   IN   gipi_witem.pack_subline_cd%TYPE,
      v_discount_sw       IN   gipi_witem.discount_sw%TYPE,
      v_from_date         IN   gipi_witem.from_date%TYPE,
      v_to_date           IN   gipi_witem.TO_DATE%TYPE,
      v_rec_flag          IN   gipi_witem.rec_flag%TYPE,
      v_item_grp          IN   gipi_witem.item_grp%TYPE,
      v_prem_amt          IN   gipi_witem.prem_amt%TYPE,
      v_ann_prem_amt      IN   gipi_witem.ann_prem_amt%TYPE,
      v_tsi_amt           IN   gipi_witem.tsi_amt%TYPE,
      v_ann_tsi_amt       IN   gipi_witem.ann_tsi_amt%TYPE,
      v_other_info        IN   gipi_witem.other_info%TYPE
   );

   PROCEDURE set_gipi_witem_1 (p_item gipi_witem%ROWTYPE);

   PROCEDURE set_gipi_witem_2 (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_item_no            IN   gipi_witem.item_no%TYPE,
      p_item_title         IN   gipi_witem.item_title%TYPE,
      p_item_grp           IN   gipi_witem.item_grp%TYPE,
      p_item_desc          IN   gipi_witem.item_desc%TYPE,
      p_item_desc2         IN   gipi_witem.item_desc2%TYPE,
      p_tsi_amt            IN   gipi_witem.tsi_amt%TYPE,
      p_prem_amt           IN   gipi_witem.prem_amt%TYPE,
      p_ann_prem_amt       IN   gipi_witem.ann_prem_amt%TYPE,
      p_ann_tsi_amt        IN   gipi_witem.ann_tsi_amt%TYPE,
      p_rec_flag           IN   gipi_witem.rec_flag%TYPE,
      p_currency_cd        IN   gipi_witem.currency_cd%TYPE,
      p_currency_rt        IN   gipi_witem.currency_rt%TYPE,
      p_group_cd           IN   gipi_witem.group_cd%TYPE,
      p_from_date          IN   gipi_witem.from_date%TYPE,
      p_to_date            IN   gipi_witem.TO_DATE%TYPE,
      p_pack_line_cd       IN   gipi_witem.pack_line_cd%TYPE,
      p_pack_subline_cd    IN   gipi_witem.pack_subline_cd%TYPE,
      p_discount_sw        IN   gipi_witem.discount_sw%TYPE,
      p_coverage_cd        IN   gipi_witem.coverage_cd%TYPE,
      p_other_info         IN   gipi_witem.other_info%TYPE,
      p_surcharge_sw       IN   gipi_witem.surcharge_sw%TYPE,
      p_region_cd          IN   gipi_witem.region_cd%TYPE,
      p_changed_tag        IN   gipi_witem.changed_tag%TYPE,
      p_prorate_flag       IN   gipi_witem.prorate_flag%TYPE,
      p_comp_sw            IN   gipi_witem.comp_sw%TYPE,
      p_short_rt_percent   IN   gipi_witem.short_rt_percent%TYPE,
      p_pack_ben_cd        IN   gipi_witem.pack_ben_cd%TYPE,
      p_payt_terms         IN   gipi_witem.payt_terms%TYPE,
      p_risk_no            IN   gipi_witem.risk_no%TYPE,
      p_risk_item_no       IN   gipi_witem.risk_item_no%TYPE
   );

   PROCEDURE set_gipi_witem_wgroup (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_item_no            IN   gipi_witem.item_no%TYPE,
      p_item_title         IN   gipi_witem.item_title%TYPE,
      p_item_grp           IN   gipi_witem.item_grp%TYPE,
      p_item_desc          IN   gipi_witem.item_desc%TYPE,
      p_item_desc2         IN   gipi_witem.item_desc2%TYPE,
      p_tsi_amt            IN   gipi_witem.tsi_amt%TYPE,
      p_prem_amt           IN   gipi_witem.prem_amt%TYPE,
      p_ann_prem_amt       IN   gipi_witem.ann_prem_amt%TYPE,
      p_ann_tsi_amt        IN   gipi_witem.ann_tsi_amt%TYPE,
      p_rec_flag           IN   gipi_witem.rec_flag%TYPE,
      p_currency_cd        IN   gipi_witem.currency_cd%TYPE,
      p_currency_rt        IN   gipi_witem.currency_rt%TYPE,
      p_group_cd           IN   gipi_witem.group_cd%TYPE,
      p_from_date          IN   gipi_witem.from_date%TYPE,
      p_to_date            IN   gipi_witem.TO_DATE%TYPE,
      p_pack_line_cd       IN   gipi_witem.pack_line_cd%TYPE,
      p_pack_subline_cd    IN   gipi_witem.pack_subline_cd%TYPE,
      p_discount_sw        IN   gipi_witem.discount_sw%TYPE,
      p_coverage_cd        IN   gipi_witem.coverage_cd%TYPE,
      p_other_info         IN   gipi_witem.other_info%TYPE,
      p_surcharge_sw       IN   gipi_witem.surcharge_sw%TYPE,
      p_region_cd          IN   gipi_witem.region_cd%TYPE,
      p_changed_tag        IN   gipi_witem.changed_tag%TYPE,
      p_prorate_flag       IN   gipi_witem.prorate_flag%TYPE,
      p_comp_sw            IN   gipi_witem.comp_sw%TYPE,
      p_short_rt_percent   IN   gipi_witem.short_rt_percent%TYPE,
      p_pack_ben_cd        IN   gipi_witem.pack_ben_cd%TYPE,
      p_payt_terms         IN   gipi_witem.payt_terms%TYPE,
      p_risk_no            IN   gipi_witem.risk_no%TYPE,
      p_risk_item_no       IN   gipi_witem.risk_item_no%TYPE
   );

   PROCEDURE pre_set_gipi_witem (p_par_id gipi_witem.par_id%TYPE);

   PROCEDURE del_gipi_witem (
      p_par_id    gipi_witem.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   );

   PROCEDURE del_endt_gipi_witem (
      p_par_id    gipi_witem.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   );

   PROCEDURE del_all_gipi_witem (p_par_id gipi_witem.par_id%TYPE);

   PROCEDURE pre_del_gipi_witem (
      p_par_id         gipi_witem.par_id%TYPE,
      p_item_no        gipi_witem.item_no%TYPE,
      p_line_cd        gipi_wpolbas.line_cd%TYPE
   );

   PROCEDURE pre_del_endt_gipi_witem (
      p_par_id    gipi_witem.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE,
      p_line_cd   gipi_wpolbas.line_cd%TYPE
   );

   PROCEDURE post_del_gipi_witem (
      p_par_id    gipi_witem.par_id%TYPE,
      p_line_cd   gipi_parlist.line_cd%TYPE,
      p_iss_cd    gipi_parlist.iss_cd%TYPE
   );

   FUNCTION par_has_item (p_par_id gipi_wpolbas.par_id%TYPE)
      RETURN BOOLEAN;

   FUNCTION get_par_items_wo_peril (p_par_id gipi_wpolbas.par_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_par_items_currency_count (p_par_id gipi_witem.par_id%TYPE)
      RETURN NUMBER;

   FUNCTION get_par_items_curr_rt_count (p_par_id gipi_witem.par_id%TYPE)
      RETURN NUMBER;

   TYPE item_list_type IS RECORD (
      item_no      gipi_witem.item_no%TYPE,
      item_title   gipi_witem.item_title%TYPE
   );

   TYPE item_list_tab IS TABLE OF item_list_type;

   FUNCTION get_item_list1 (p_par_id gipi_witem.par_id%TYPE)
      RETURN item_list_tab PIPELINED;

   FUNCTION get_item_list2 (p_par_id gipi_witem.par_id%TYPE)
      RETURN item_list_tab PIPELINED;

   PROCEDURE set_amts (
      p_par_id         gipi_witem.par_id%TYPE,
      p_item_no        gipi_witem.item_no%TYPE,
      p_prem_amt       gipi_witem.prem_amt%TYPE,
      p_ann_prem_amt   gipi_witem.ann_prem_amt%TYPE
   );

   FUNCTION get_max_risk_item_no (
      p_par_id    gipi_witem.par_id%TYPE,
      p_risk_no   gipi_witem.risk_no%TYPE
   )
      RETURN NUMBER;

   PROCEDURE update_item_value (
      p_tsi_amt        gipi_witem.tsi_amt%TYPE,
      p_prem_amt       gipi_witem.prem_amt%TYPE,
      p_ann_tsi_amt    gipi_witem.ann_tsi_amt%TYPE,
      p_ann_prem_amt   gipi_witem.ann_prem_amt%TYPE,
      p_par_id         gipi_witem.par_id%TYPE,
      p_item_no        gipi_witem.item_no%TYPE
   );

   PROCEDURE set_tsi (
      p_par_id        gipi_witem.par_id%TYPE,
      p_item_no       gipi_witem.item_no%TYPE,
      p_tsi_amt       gipi_witem.tsi_amt%TYPE,
      p_ann_tsi_amt   gipi_witem.ann_tsi_amt%TYPE
   );

   PROCEDURE update_wpolbas (p_par_id IN gipi_witem.par_id%TYPE);

   PROCEDURE insert_limit (p_wopen_liab IN gipi_wopen_liab%ROWTYPE);

   PROCEDURE update_tsi_and_currency (
      p_wopen_liab   IN   gipi_wopen_liab%ROWTYPE,
      p_item_no      IN   gipi_witem.item_no%TYPE
   );

   FUNCTION get_tsi_prem_amt (
      p_par_id    gipi_witem.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN item_tsi_prem_tab PIPELINED;

   PROCEDURE get_tsi_prem_amt (
      p_par_id     IN       gipi_witem.par_id%TYPE,
      p_tsi_amt    OUT      gipi_witem.tsi_amt%TYPE,
      p_prem_amt   OUT      gipi_witem.prem_amt%TYPE
   );

/***************************************************************************/
/*
** Transfered by: whofeih
** Date: 06.10.2010
** for GIPIS050A
*/
   PROCEDURE create_gipi_witem (
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_par_id     gipi_witem.par_id%TYPE
   );

-- end of whofeih
/***************************************************************************/
   FUNCTION get_distinct_gipi_item (p_par_id gipi_witem.par_id%TYPE)
      RETURN item_no_tab PIPELINED;

   PROCEDURE update_gipi_witem_discount (
      p_par_id                   gipi_witem.par_id%TYPE,
      p_item_no                  gipi_witem.item_no%TYPE,
      p_disc_amt                 gipi_wperil_discount.disc_amt%TYPE,
      p_orig_item_ann_prem_amt   gipi_wperil_discount.orig_item_ann_prem_amt%TYPE
   );

   FUNCTION get_item_grp (
      p_par_id          IN   gipi_parlist.par_id%TYPE,
      p_pack_pol_flag   IN   gipi_wpolbas.pack_pol_flag%TYPE,
      p_currency_cd     IN   gipi_witem.currency_cd%TYPE
   )
      RETURN gipi_witem.item_grp%TYPE;

   FUNCTION get_endt_add_item_list (
      p_par_id       gipi_witem.par_id%TYPE,
      p_item_no      gipi_witem.item_no%TYPE,
      p_line_cd      gipi_wpolbas.line_cd%TYPE,
      p_subline_cd   gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd       gipi_wpolbas.iss_cd%TYPE,
      p_issue_yy     gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no   gipi_wpolbas.pol_seq_no%TYPE,
      p_renew_no     gipi_wpolbas.renew_no%TYPE,
      p_eff_date     gipi_wpolbas.eff_date%TYPE
   )
      RETURN gipi_witem_tab PIPELINED;

   PROCEDURE update_amt_details (p_par_id gipi_witem.par_id%TYPE,
                                 p_item_no gipi_witem.item_no%TYPE);

   PROCEDURE update_item_groups (
      p_par_id     gipi_witem.par_id%TYPE,
      p_item_grp   gipi_witem.item_grp%TYPE,
      p_item_no    gipi_witem.item_no%TYPE
   );

   FUNCTION get_gipi_witem_exist (p_par_id gipi_wpolbas.par_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_gipi_witem_for_par (p_par_id IN gipi_witem.par_id%TYPE)
      RETURN gipi_witem_par_tab PIPELINED;

   FUNCTION get_gipi_witem_for_pack_policy (
      p_pack_par_id   IN   gipi_parlist.pack_par_id%TYPE
   )
      RETURN gipi_witem_par_tab PIPELINED;

   FUNCTION get_gipi_witem_for_pack_pol (
      p_pack_par_id   IN   gipi_parlist.pack_par_id%TYPE
   )
      RETURN gipi_witem_par_tab PIPELINED;

   FUNCTION check_gipi_witem_for_pack (
      p_pack_par_id   gipi_pack_parlist.pack_par_id%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_package_records (
      p_pack_par_id   IN   gipi_parlist.pack_par_id%TYPE
   )
      RETURN gipi_witem_par_tab PIPELINED;

   FUNCTION check_item_exist (p_par_id gipi_witem.par_id%TYPE)
      RETURN NUMBER;

   FUNCTION get_gipi_witem_for_par_tg (
      p_par_id       IN   gipi_witem.par_id%TYPE,
      p_item_no      IN   gipi_witem.item_no%TYPE,
      p_item_title   IN   gipi_witem.item_title%TYPE,
      p_item_desc    IN   gipi_witem.item_desc%TYPE,
      p_item_desc2   IN   gipi_witem.item_desc2%TYPE
   )
      RETURN gipi_witem_par_tab PIPELINED;

   PROCEDURE set_item_on_mcupload (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_item_no            IN   gipi_witem.item_no%TYPE,
      p_item_title         IN   gipi_witem.item_title%TYPE,
      p_item_grp           IN   gipi_witem.item_grp%TYPE,
      p_item_desc          IN   gipi_witem.item_desc%TYPE,
      p_item_desc2         IN   gipi_witem.item_desc2%TYPE,
      p_tsi_amt            IN   gipi_witem.tsi_amt%TYPE,
      p_prem_amt           IN   gipi_witem.prem_amt%TYPE,
      p_ann_prem_amt       IN   gipi_witem.ann_prem_amt%TYPE,
      p_ann_tsi_amt        IN   gipi_witem.ann_tsi_amt%TYPE,
      p_rec_flag           IN   gipi_witem.rec_flag%TYPE,
      p_currency_cd        IN   gipi_witem.currency_cd%TYPE,
      p_currency_rt        IN   gipi_witem.currency_rt%TYPE,
      p_group_cd           IN   gipi_witem.group_cd%TYPE,
      p_from_date          IN   gipi_witem.from_date%TYPE,
      p_to_date            IN   gipi_witem.TO_DATE%TYPE,
      p_pack_line_cd       IN   gipi_witem.pack_line_cd%TYPE,
      p_pack_subline_cd    IN   gipi_witem.pack_subline_cd%TYPE,
      p_discount_sw        IN   gipi_witem.discount_sw%TYPE,
      p_coverage_cd        IN   gipi_witem.coverage_cd%TYPE,
      p_other_info         IN   gipi_witem.other_info%TYPE,
      p_surcharge_sw       IN   gipi_witem.surcharge_sw%TYPE,
      p_region_cd          IN   gipi_witem.region_cd%TYPE,
      p_changed_tag        IN   gipi_witem.changed_tag%TYPE,
      p_prorate_flag       IN   gipi_witem.prorate_flag%TYPE,
      p_comp_sw            IN   gipi_witem.comp_sw%TYPE,
      p_short_rt_percent   IN   gipi_witem.short_rt_percent%TYPE,
      p_pack_ben_cd        IN   gipi_witem.pack_ben_cd%TYPE,
      p_payt_terms         IN   gipi_witem.payt_terms%TYPE,
      p_risk_no            IN   gipi_witem.risk_no%TYPE,
      p_risk_item_no       IN   gipi_witem.risk_item_no%TYPE
   );

   FUNCTION get_gipi_witem_exist_2 (
      p_par_id    IN   gipi_witem.par_id%TYPE,
      p_item_no   IN   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2;

   TYPE item_title_lov_type IS RECORD (
      item_no      gipi_witem.item_no%TYPE,
      item_title   gipi_witem.item_title%TYPE,
      prem_amt     gipi_witem.prem_amt%TYPE
   );

   TYPE item_title_lov_tab IS TABLE OF item_title_lov_type;

   FUNCTION get_item_lov (p_par_id gipi_witem.par_id%TYPE)
      RETURN item_title_lov_tab PIPELINED;

   PROCEDURE insert_into_gipi_witem (
      p_par_id            gipi_witem.par_id%TYPE,
      p_limit_liability   gipi_witem.tsi_amt%TYPE,
      p_currency_cd       gipi_witem.currency_cd%TYPE,
      p_currency_rt       gipi_witem.currency_rt%TYPE
   );

   FUNCTION check_get_def_curr_rt
      RETURN NUMBER;
END gipi_witem_pkg;
/



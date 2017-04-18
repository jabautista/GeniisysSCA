CREATE OR REPLACE PACKAGE CPI.gipi_witem_ves_pkg
AS
   TYPE gipi_witem_ves_type IS RECORD (
      par_id                   gipi_witem.par_id%TYPE,
      item_no                  gipi_witem.item_no%TYPE,
      item_title               gipi_witem.item_title%TYPE,
      item_grp                 gipi_witem.item_grp%TYPE,
      item_desc                gipi_witem.item_desc%TYPE,
      item_desc2               gipi_witem.item_desc2%TYPE,
      tsi_amt                  gipi_witem.tsi_amt%TYPE,
      prem_amt                 gipi_witem.prem_amt%TYPE,
      ann_prem_amt             gipi_witem.ann_prem_amt%TYPE,
      ann_tsi_amt              gipi_witem.ann_tsi_amt%TYPE,
      currency_cd              gipi_witem.currency_cd%TYPE,
      currency_rt              gipi_witem.currency_rt%TYPE,
      group_cd                 gipi_witem.group_cd%TYPE,
      from_date                gipi_witem.from_date%TYPE,
      TO_DATE                  gipi_witem.TO_DATE%TYPE,
      pack_line_cd             gipi_witem.pack_line_cd%TYPE,
      pack_subline_cd          gipi_witem.pack_subline_cd%TYPE,
      discount_sw              gipi_witem.discount_sw%TYPE,
      coverage_cd              gipi_witem.coverage_cd%TYPE,
      other_info               gipi_witem.other_info%TYPE,
      surcharge_sw             gipi_witem.surcharge_sw%TYPE,
      region_cd                gipi_witem.region_cd%TYPE,
      changed_tag              gipi_witem.changed_tag%TYPE,
      prorate_flag             gipi_witem.prorate_flag%TYPE,
      comp_sw                  gipi_witem.comp_sw%TYPE,
      short_rt_percent         gipi_witem.short_rt_percent%TYPE,
      pack_ben_cd              gipi_witem.pack_ben_cd%TYPE,
      payt_terms               gipi_witem.payt_terms%TYPE,
      risk_no                  gipi_witem.risk_no%TYPE,
      risk_item_no             gipi_witem.risk_item_no%TYPE,
      currency_desc            giis_currency.currency_desc%TYPE,
      coverage_desc            giis_coverage.coverage_desc%TYPE,
      vessel_cd                gipi_witem_ves.vessel_cd%TYPE,
      vessel_flag              giis_vessel.vessel_flag%TYPE,
      vessel_name              giis_vessel.vessel_name%TYPE,
      vessel_old_name          giis_vessel.vessel_old_name%TYPE,
      vestype_desc             giis_vestype.vestype_desc%TYPE,
      propel_sw                giis_vessel.propel_sw%TYPE,
      vess_class_desc          giis_vess_class.vess_class_desc%TYPE,
      hull_desc                giis_hull_type.hull_desc%TYPE,
      reg_owner                giis_vessel.reg_owner%TYPE,
      reg_place                giis_vessel.reg_place%TYPE,
      gross_ton                giis_vessel.gross_ton%TYPE,
      year_built               giis_vessel.year_built%TYPE,
      net_ton                  giis_vessel.net_ton%TYPE,
      no_crew                  giis_vessel.no_crew%TYPE,
      deadweight               giis_vessel.deadweight%TYPE,
      crew_nat                 giis_vessel.crew_nat%TYPE,
      vessel_length            giis_vessel.vessel_length%TYPE,
      vessel_breadth           giis_vessel.vessel_breadth%TYPE,
      vessel_depth             giis_vessel.vessel_depth%TYPE,
      dry_place                giis_vessel.dry_place%TYPE,
      dry_date                 VARCHAR2(10),    --GIIS_VESSEL.dry_date%TYPE,
      rec_flag                 gipi_witem_ves.rec_flag%TYPE,
      deduct_text              gipi_witem_ves.deduct_text%TYPE,
   no_of_itemperils     NUMBER(2),
      geog_limit               gipi_witem_ves.geog_limit%TYPE,
      itmperl_grouped_exists   VARCHAR2(1),
   restricted_condition    VARCHAR2(100)
   );

      TYPE gipi_witem_ves_tab IS TABLE OF gipi_witem_ves_type;

   TYPE gipi_witem_ves_par_type IS RECORD (
      par_id                   gipi_witem.par_id%TYPE,
      item_no                  gipi_witem.item_no%TYPE,
      vessel_cd                gipi_witem_ves.vessel_cd%TYPE,
      vessel_flag              giis_vessel.vessel_flag%TYPE,
      vessel_name              giis_vessel.vessel_name%TYPE,
      vessel_old_name          giis_vessel.vessel_old_name%TYPE,
      vestype_desc             giis_vestype.vestype_desc%TYPE,
      propel_sw                VARCHAR2(100),--giis_vessel.propel_sw%TYPE,
      vess_class_desc          giis_vess_class.vess_class_desc%TYPE,
      hull_desc                giis_hull_type.hull_desc%TYPE,
      reg_owner                giis_vessel.reg_owner%TYPE,
      reg_place                giis_vessel.reg_place%TYPE,
      gross_ton                giis_vessel.gross_ton%TYPE,
      year_built               giis_vessel.year_built%TYPE,
      net_ton                  giis_vessel.net_ton%TYPE,
      no_crew                  giis_vessel.no_crew%TYPE,
      deadweight               giis_vessel.deadweight%TYPE,
      crew_nat                 giis_vessel.crew_nat%TYPE,
      vessel_length            giis_vessel.vessel_length%TYPE,
      vessel_breadth           giis_vessel.vessel_breadth%TYPE,
      vessel_depth             giis_vessel.vessel_depth%TYPE,
      dry_place                giis_vessel.dry_place%TYPE,
      dry_date                 VARCHAR2(10),    --GIIS_VESSEL.dry_date%TYPE,
      rec_flag                 gipi_witem_ves.rec_flag%TYPE,
      deduct_text              gipi_witem_ves.deduct_text%TYPE,
   --no_of_itemperils     NUMBER(2),
      geog_limit               gipi_witem_ves.geog_limit%TYPE
   );

   TYPE gipi_witem_ves_par_tab IS TABLE OF gipi_witem_ves_par_type;

   FUNCTION get_gipi_witem_ves (p_par_id gipi_witem_ves.par_id%TYPE)       --,
      -- p_item_no         GIPI_WITEM_VES.item_no%TYPE)
   RETURN gipi_witem_ves_tab PIPELINED;

   /*PROCEDURE set_gipi_witem_ves (
      p_par_id        IN   gipi_witem_ves.par_id%TYPE,
      p_item_no       IN   gipi_witem_ves.item_no%TYPE,
      p_vessel_cd     IN   gipi_witem_ves.vessel_cd%TYPE,
      p_rec_flag      IN   gipi_witem_ves.rec_flag%TYPE,
      p_deduct_text   IN   gipi_witem_ves.deduct_text%TYPE,
      p_geog_limit    IN   gipi_witem_ves.geog_limit%TYPE,
      p_dry_date           VARCHAR2,       --IN  GIPI_WITEM_VES.dry_date%TYPE,
      p_dry_place     IN   gipi_witem_ves.dry_place%TYPE
   );*/

   PROCEDURE del_gipi_witem_ves (
      p_par_id    gipi_witem_ves.par_id%TYPE,
      p_item_no   gipi_witem_ves.item_no%TYPE
   );

   PROCEDURE del_gipi_witem_ves (p_par_id IN gipi_witem_ves.par_id%TYPE);

   PROCEDURE set_gipi_witem_ves (
      p_par_id        IN   gipi_witem_ves.par_id%TYPE,
      p_item_no       IN   gipi_witem_ves.item_no%TYPE,
      p_vessel_cd     IN   gipi_witem_ves.vessel_cd%TYPE,
      p_rec_flag      IN   gipi_witem_ves.rec_flag%TYPE,
      p_deduct_text   IN   gipi_witem_ves.deduct_text%TYPE,
      p_geog_limit    IN   gipi_witem_ves.geog_limit%TYPE,
      p_dry_date      IN   gipi_witem_ves.dry_date%TYPE,
      p_dry_place     IN   gipi_witem_ves.dry_place%TYPE
   );

   PROCEDURE set_gipi_witem_ves (p_ves   GIPI_WITEM_VES%ROWTYPE);

   FUNCTION get_witem_ves_endt_details (
      p_line_cd      gipi_wpolbas.line_cd%TYPE,
      p_subline_cd   gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd       gipi_wpolbas.iss_cd%TYPE,
      p_issue_yy     gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no   gipi_wpolbas.pol_seq_no%TYPE,
      p_renew_no     gipi_wpolbas.renew_no%TYPE,
      p_item_no      gipi_witem.item_no%TYPE,
   p_ann_tsi_amt  gipi_witem.ann_tsi_amt%TYPE,
   p_ann_prem_amt gipi_witem.ann_prem_amt%TYPE
   )
      RETURN gipi_witem_ves_tab PIPELINED;

   FUNCTION pre_insert_witem_ves(p_line_cd    GIPI_WPOLBAS.line_cd%TYPE,
                p_iss_cd    GIPI_WPOLBAS.iss_cd%TYPE,
            p_subline_cd   GIPI_WPOLBAS.subline_cd%TYPE,
            p_issue_yy    GIPI_WPOLBAS.issue_yy%TYPE,
            p_pol_seq_no   GIPI_WPOLBAS.pol_seq_no%TYPE,
         p_item_no    GIPI_WITEM.item_no%TYPE,
         p_currency_cd   GIPI_WITEM.currency_cd%TYPE)
     RETURN NUMBER;

   FUNCTION check_addtl_info(p_par_id     GIPI_WITEM_VES.par_id%TYPE)
     RETURN VARCHAR2;

   FUNCTION check_update_wpolbas_validity (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_negate_item        IN   VARCHAR2,
      p_prorate_flag       IN   gipi_wpolbas.prorate_flag%TYPE,
      p_comp_sw            IN   VARCHAR2,
      p_endt_expiry_date   IN   VARCHAR2,
      p_eff_date           IN   VARCHAR2,
      p_short_rt_percent   IN   gipi_wpolbas.short_rt_percent%TYPE,
      p_expiry_date        IN   VARCHAR2
   ) RETURN VARCHAR2;

   PROCEDURE update_wpolbas (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_negate_item        IN   VARCHAR2,
      p_prorate_flag       IN   gipi_wpolbas.prorate_flag%TYPE,
      p_comp_sw            IN   VARCHAR2,
      p_endt_expiry_date   IN   VARCHAR2,
      p_eff_date           IN   VARCHAR2,
      p_short_rt_percent   IN   gipi_wpolbas.short_rt_percent%TYPE,
      p_expiry_date        IN   VARCHAR2
   );

   FUNCTION get_gipi_witem_ves1(p_par_id    GIPI_WITEM.par_id%TYPE,
                                p_item_no   GIPI_WITEM.item_no %TYPE)
   RETURN gipi_witem_ves_par_tab PIPELINED;
   
    FUNCTION get_gipi_witem_ves_pack_pol (
        p_par_id IN gipi_witem_ves.par_id%TYPE,
        p_item_no IN gipi_witem_ves.item_no%TYPE)
    RETURN gipi_witem_ves_par_tab PIPELINED;

END gipi_witem_ves_pkg;
/



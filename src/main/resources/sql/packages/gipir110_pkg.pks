CREATE OR REPLACE PACKAGE CPI.gipir110_pkg
AS
   gipir110_policy_no   VARCHAR2 (100);

   TYPE gipir110_type IS RECORD (
      company_name       VARCHAR2 (100),
      company_add        giac_parameters.param_value_v%TYPE,
      exist              VARCHAR2 (1),
      policy_no          VARCHAR2 (100),
      line_cd            gixx_block_accumulation_dist.line_cd%TYPE,
      subline_cd         gixx_block_accumulation_dist.subline_cd%TYPE,
      iss_cd             gixx_block_accumulation_dist.iss_cd%TYPE,
      issue_yy           gixx_block_accumulation_dist.issue_yy%TYPE,
      pol_seq_no         gixx_block_accumulation_dist.pol_seq_no%TYPE,
      renew_no           gixx_block_accumulation_dist.renew_no%TYPE,
      dist_flag          gixx_block_accumulation_dist.dist_flag%TYPE,
      ann_tsi_amt        gixx_block_accumulation_dist.ann_tsi_amt%TYPE,
      assd_no            gixx_block_accumulation_dist.assd_no%TYPE,
      assd_name          gixx_block_accumulation_dist.assd_name%TYPE,
      eff_date           gixx_block_accumulation_dist.eff_date%TYPE,
      incept_date        gixx_block_accumulation_dist.incept_date%TYPE,
      expiry_date        gixx_block_accumulation_dist.expiry_date%TYPE,
      endt_expiry_date   gixx_block_accumulation_dist.endt_expiry_date%TYPE,
      tarf_cd            gixx_block_accumulation_dist.tarf_cd%TYPE,
      construction_cd    gixx_block_accumulation_dist.construction_cd%TYPE,
      loc_risk           gixx_block_accumulation_dist.loc_risk%TYPE,
      peril_cd           gixx_block_accumulation_dist.peril_cd%TYPE,
      prem_rt            gixx_block_accumulation_dist.prem_rt%TYPE,
      peril_sname        gixx_block_accumulation_dist.peril_sname%TYPE,
      peril_name         gixx_block_accumulation_dist.peril_name%TYPE,
      province_cd        gixx_block_accumulation_dist.province_cd%TYPE,
      city               gixx_block_accumulation_dist.city%TYPE,
      block_id           gixx_block_accumulation_dist.block_id%TYPE,
      item_no            gixx_block_accumulation_dist.item_no%TYPE,
      district_no        gixx_block_accumulation_dist.district_no%TYPE,
      block_no           gixx_block_accumulation_dist.block_no%TYPE,
      fr_item_type       gixx_block_accumulation_dist.fr_item_type%TYPE,
      endt_seq_no        gixx_block_accumulation_dist.endt_seq_no%TYPE,
      province           VARCHAR2 (500),
      district_desc      VARCHAR2 (500),
      block_desc         VARCHAR2 (500)
   );

   TYPE gipir110_tab IS TABLE OF gipir110_type;

   TYPE treaty_type IS RECORD (
      dist_tsi     gixx_block_accumulation_dist.dist_tsi%TYPE,
      share_cd     gixx_block_accumulation_dist.share_cd%TYPE,
      share_type   gixx_block_accumulation_dist.share_type%TYPE,
      trty_name    giis_dist_share.trty_name%TYPE
   );

   TYPE treaty_tab IS TABLE OF treaty_type;

   FUNCTION populate_gipir110 (p_eff_tag VARCHAR2, p_expiry_tag VARCHAR2)
      RETURN gipir110_tab PIPELINED;

   FUNCTION get_trty_name (p_eff_tag VARCHAR2, p_expiry_tag VARCHAR2)
      RETURN treaty_tab PIPELINED;

   FUNCTION get_trty_dtl (
      p_line_cd      gixx_block_accumulation_dist.line_cd%TYPE,
      p_subline_cd   gixx_block_accumulation_dist.subline_cd%TYPE,
      p_iss_cd       gixx_block_accumulation_dist.iss_cd%TYPE,
      p_issue_yy     gixx_block_accumulation_dist.issue_yy%TYPE,
      p_pol_seq_no   gixx_block_accumulation_dist.pol_seq_no%TYPE,
      p_renew_no     gixx_block_accumulation_dist.renew_no%TYPE,
      p_item_no      gixx_block_accumulation_dist.item_no%TYPE,
      p_total        VARCHAR2,
      p_eff_tag      VARCHAR2,
      p_expiry_tag   VARCHAR2
   )
      RETURN treaty_tab PIPELINED;
END gipir110_pkg;
/



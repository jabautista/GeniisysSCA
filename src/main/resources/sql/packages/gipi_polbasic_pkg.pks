CREATE OR REPLACE PACKAGE CPI.gipi_polbasic_pkg
AS
  /* Modified by pjsantos09/15/2061,added functions get_parno, get_policy_no2, get_endt_no and get_prem_seq_no for optimization.*/
   TYPE gipi_polbasic_type IS RECORD
   (
      par_id        gipi_polbasic.par_id%TYPE, 
      line_cd       gipi_polbasic.line_cd%TYPE,
      subline_cd    gipi_polbasic.subline_cd%TYPE,
      iss_cd        gipi_polbasic.iss_cd%TYPE,
      issue_yy      gipi_polbasic.issue_yy%TYPE,
      pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      renew_no      gipi_polbasic.renew_no%TYPE,
      endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy       gipi_polbasic.endt_yy%TYPE,
      endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      eff_date      gipi_polbasic.eff_date%TYPE,
      expiry_date   gipi_polbasic.expiry_date%TYPE,
      assd_no       gipi_polbasic.assd_no%TYPE,
      assd_name     giis_assured.assd_name%TYPE,
      dist_no       giuw_pol_dist.dist_no%TYPE,
      dist_flag     gipi_polbasic.dist_flag%TYPE,
      policy_id     gipi_polbasic.policy_id%TYPE,
      ref_pol_no    gipi_polbasic.ref_pol_no%TYPE,
      incept_date   gipi_polbasic.incept_date%TYPE
   );  

   TYPE gipi_polbasic_tab IS TABLE OF gipi_polbasic_type;

   FUNCTION get_gipi_polbasic (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy        gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE,
      p_eff_date       gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE)
      RETURN gipi_polbasic_tab
      PIPELINED;

   TYPE gipi_polbasic_type2 IS RECORD
   (
      par_id             gipi_polbasic.par_id%TYPE,
      line_cd            gipi_polbasic.line_cd%TYPE,
      subline_cd         gipi_polbasic.subline_cd%TYPE,
      iss_cd             gipi_polbasic.iss_cd%TYPE,
      issue_yy           gipi_polbasic.issue_yy%TYPE,
      pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      renew_no           gipi_polbasic.renew_no%TYPE,
      endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy            gipi_polbasic.endt_yy%TYPE,
      endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      eff_date           gipi_polbasic.eff_date%TYPE,
      expiry_date        gipi_polbasic.expiry_date%TYPE,
      assd_no            gipi_polbasic.assd_no%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      dist_flag          gipi_polbasic.dist_flag%TYPE,
      policy_id          gipi_polbasic.policy_id%TYPE,
      pol_flag           gipi_polbasic.pol_flag%TYPE,
      pack_pol_flag      gipi_polbasic.pack_pol_flag%TYPE,
      co_insurance_sw    gipi_polbasic.co_insurance_sw%TYPE,
      acct_ent_date      gipi_polbasic.acct_ent_date%TYPE,
      prorate_flag       gipi_polbasic.prorate_flag%TYPE,
      short_rt_percent   gipi_polbasic.short_rt_percent%TYPE,
      prov_prem_pct      gipi_polbasic.prov_prem_pct%TYPE,
      incept_date        gipi_polbasic.incept_date%TYPE,
      issue_date         gipi_polbasic.issue_date%TYPE,
      booking_mth        gipi_polbasic.booking_mth%TYPE,
      booking_year       gipi_polbasic.booking_year%TYPE,
      ri_name            giis_reinsurer.ri_name%TYPE,
      ri_cd              giis_reinsurer.ri_cd%TYPE
   );

   TYPE gipi_polbasic_tab2 IS TABLE OF gipi_polbasic_type2;

   TYPE gipi_polbasic_type3 IS RECORD
   (
      pack_policy_id    gipi_polbasic.pack_policy_id%TYPE,
      line_cd           gipi_polbasic.line_cd%TYPE,
      subline_cd        gipi_polbasic.subline_cd%TYPE,
      iss_cd            gipi_polbasic.iss_cd%TYPE,
      issue_yy          gipi_polbasic.issue_yy%TYPE,
      pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      renew_no          gipi_polbasic.renew_no%TYPE,
      endt_iss_cd       gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy           gipi_polbasic.endt_yy%TYPE,
      endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
      policy_id         gipi_polbasic.policy_id%TYPE,
      assd_no           gipi_polbasic.assd_no%TYPE,
      endt_type         gipi_polbasic.endt_type%TYPE,
      par_id            gipi_polbasic.par_id%TYPE,
      no_of_items       gipi_polbasic.no_of_items%TYPE,
      pol_flag          gipi_polbasic.pol_flag%TYPE,
      co_insurance_sw   gipi_polbasic.co_insurance_sw%TYPE,
      fleet_print_tag   gipi_polbasic.fleet_print_tag%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      par_no            VARCHAR2 (100),
      prem_seq_no       gipi_invoice.prem_seq_no%TYPE,
      endt_tax          gipi_endttext.endt_tax%TYPE,
      coc_type          gipi_vehicle.coc_type%TYPE
   );

   TYPE gipi_polbasic_tab3 IS TABLE OF gipi_polbasic_type3;

   TYPE gipi_polbasic_type4 IS RECORD
   (
      pack_policy_id    gipi_polbasic.pack_policy_id%TYPE,
      line_cd           gipi_polbasic.line_cd%TYPE,
      subline_cd        gipi_polbasic.subline_cd%TYPE,
      iss_cd            gipi_polbasic.iss_cd%TYPE,
      issue_yy          gipi_polbasic.issue_yy%TYPE,
      pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      renew_no          gipi_polbasic.renew_no%TYPE,
      endt_iss_cd       gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy           gipi_polbasic.endt_yy%TYPE,
      endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
      policy_id         gipi_polbasic.policy_id%TYPE,
      assd_no           gipi_polbasic.assd_no%TYPE,
      endt_type         gipi_polbasic.endt_type%TYPE,
      par_id            gipi_polbasic.par_id%TYPE,
      no_of_items       gipi_polbasic.no_of_items%TYPE,
      pol_flag          gipi_polbasic.pol_flag%TYPE,
      co_insurance_sw   gipi_polbasic.co_insurance_sw%TYPE,
      fleet_print_tag   gipi_polbasic.fleet_print_tag%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      policy_no         VARCHAR2 (1000),
      endt_no           VARCHAR2 (1000),
      par_no            VARCHAR2 (1000)
      
   );

   TYPE gipi_polbasic_tab4 IS TABLE OF gipi_polbasic_type4;
   --Added by MarkS SR5808 10.26.2016
   TYPE gipi_polbasic_type6 IS RECORD
   (
      count_            NUMBER, --optimization 10.13.2016 SR5680 MarkS 
      rownum_           NUMBER,  --optimization 10.13.2016 SR5680 MarkS 
      pack_policy_id    gipi_polbasic.pack_policy_id%TYPE,
      line_cd           gipi_polbasic.line_cd%TYPE,
      subline_cd        gipi_polbasic.subline_cd%TYPE,
      iss_cd            gipi_polbasic.iss_cd%TYPE,
      issue_yy          gipi_polbasic.issue_yy%TYPE,
      pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      renew_no          gipi_polbasic.renew_no%TYPE,
      endt_iss_cd       gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy           gipi_polbasic.endt_yy%TYPE,
      endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
      policy_id         gipi_polbasic.policy_id%TYPE,
      assd_no           gipi_polbasic.assd_no%TYPE,
      endt_type         gipi_polbasic.endt_type%TYPE,
      par_id            gipi_polbasic.par_id%TYPE,
      no_of_items       gipi_polbasic.no_of_items%TYPE,
      pol_flag          gipi_polbasic.pol_flag%TYPE,
      co_insurance_sw   gipi_polbasic.co_insurance_sw%TYPE,
      fleet_print_tag   gipi_polbasic.fleet_print_tag%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      policy_no         VARCHAR2 (1000),
      endt_no           VARCHAR2 (1000),
      par_no            VARCHAR2 (1000)
      
   );

   TYPE gipi_polbasic_tab6 IS TABLE OF gipi_polbasic_type6;
   --END SR5808
   TYPE gipd_line_cd_lov_type IS RECORD
   (
      line_cd       gipi_polbasic.line_cd%TYPE,
      subline_cd    gipi_polbasic.subline_cd%TYPE,
      iss_cd        gipi_polbasic.iss_cd%TYPE,
      issue_yy      gipi_polbasic.issue_yy%TYPE,
      pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      renew_no      gipi_polbasic.renew_no%TYPE,
      assd_no       gipi_polbasic.assd_no%TYPE,
      assd_name     giis_assured.assd_name%TYPE,
      endt_seq_no   gipi_polbasic.endt_seq_no%TYPE
   );

   TYPE gipd_line_cd_lov_tab IS TABLE OF gipd_line_cd_lov_type;

   /** with policy_no and endt_no **/
   TYPE gipi_polbasic_type5 IS RECORD
   (
      par_id        gipi_polbasic.par_id%TYPE,
      line_cd       gipi_polbasic.line_cd%TYPE,
      subline_cd    gipi_polbasic.subline_cd%TYPE,
      iss_cd        gipi_polbasic.iss_cd%TYPE,
      issue_yy      gipi_polbasic.issue_yy%TYPE,
      pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      renew_no      gipi_polbasic.renew_no%TYPE,
      endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy       gipi_polbasic.endt_yy%TYPE,
      endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      eff_date      gipi_polbasic.eff_date%TYPE,
      expiry_date   gipi_polbasic.expiry_date%TYPE,
      assd_no       gipi_polbasic.assd_no%TYPE,
      assd_name     giis_assured.assd_name%TYPE,
      dist_no       giuw_pol_dist.dist_no%TYPE,
      dist_flag     gipi_polbasic.dist_flag%TYPE,
      policy_id     gipi_polbasic.policy_id%TYPE,
      ref_pol_no    gipi_polbasic.ref_pol_no%TYPE,
      incept_date   gipi_polbasic.incept_date%TYPE,
      renew_flag    gipi_polbasic.renew_flag%TYPE,
      policy_no     VARCHAR2 (50),
      endt_no       VARCHAR2 (100)
   );

   TYPE gipi_polbasic_tab5 IS TABLE OF gipi_polbasic_type5;


   FUNCTION get_gipi_polbasic (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_keyword IN VARCHAR2
   )
      RETURN gipi_polbasic_tab2 PIPELINED;


   FUNCTION get_gipi_polbasic2 (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE)
      RETURN gipi_polbasic_tab2
      PIPELINED;

   FUNCTION get_polid (p_line_cd       gipi_polbasic.line_cd%TYPE,
                       p_subline_cd    gipi_polbasic.subline_cd%TYPE,
                       p_iss_cd        gipi_polbasic.iss_cd%TYPE,
                       p_issue_yy      gipi_polbasic.issue_yy%TYPE,
                       p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
                       p_renew_no      gipi_polbasic.renew_no%TYPE)
      RETURN NUMBER;

   FUNCTION get_pol_flag (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_polbasic.pol_flag%TYPE;

   FUNCTION get_ref_open_pol_no (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE)
      RETURN gipi_polbasic.ref_open_pol_no%TYPE;

   FUNCTION get_gipi_polbasic3 (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_assd_no        gipi_polbasic.assd_no%TYPE,
      p_incept_date    gipi_polbasic.incept_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE)
      RETURN gipi_polbasic_tab
      PIPELINED;

   PROCEDURE get_eff_date_policy_id (
      p_line_cd      IN     gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN     gipi_polbasic.renew_no%TYPE,
      p_eff_date        OUT gipi_polbasic.eff_date%TYPE,
      p_policy_id       OUT gipi_polbasic.policy_id%TYPE);

   FUNCTION get_max_endt_seq_no (
      p_line_cd      IN gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN gipi_polbasic.renew_no%TYPE,
      p_eff_date     IN gipi_polbasic.eff_date%TYPE,
      p_field_name   IN VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_max_endt_seq_no_back_stat (
      p_line_cd      IN gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN gipi_polbasic.renew_no%TYPE,
      p_eff_date     IN gipi_polbasic.eff_date%TYPE,
      p_field_name   IN VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_max_eff_date_back_stat (
      p_line_cd            IN gipi_polbasic.line_cd%TYPE,
      p_subline_cd         IN gipi_polbasic.subline_cd%TYPE,
      p_iss_cd             IN gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           IN gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no         IN gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no           IN gipi_polbasic.renew_no%TYPE,
      p_eff_date           IN gipi_polbasic.eff_date%TYPE,
      p_max_endt_seq_no1   IN gipi_polbasic.endt_seq_no%TYPE,
      p_field_name         IN VARCHAR2)
      RETURN DATE;

   FUNCTION get_endt_max_eff_date (
      p_line_cd      IN gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN gipi_polbasic.renew_no%TYPE,
      p_eff_date     IN gipi_polbasic.eff_date%TYPE,
      p_field_name   IN VARCHAR2)
      RETURN DATE;

   PROCEDURE get_address_for_endt (
      p_line_cd      IN     gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN     gipi_polbasic.renew_no%TYPE,
      p_eff_date     IN     gipi_polbasic.eff_date%TYPE,
      p_address1        OUT gipi_polbasic.address1%TYPE,
      p_address2        OUT gipi_polbasic.address2%TYPE,
      p_address3        OUT gipi_polbasic.address3%TYPE);

   PROCEDURE get_address_for_new_endt_item (
      p_line_cd       IN     gipi_polbasic.line_cd%TYPE,
      p_subline_cd    IN     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        IN     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      IN     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    IN     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      IN     gipi_polbasic.renew_no%TYPE,
      p_eff_date      IN     gipi_polbasic.eff_date%TYPE,
      p_expiry_date   IN     gipi_polbasic.expiry_date%TYPE,
      p_address1         OUT gipi_polbasic.address1%TYPE,
      p_address2         OUT gipi_polbasic.address2%TYPE,
      p_address3         OUT gipi_polbasic.address3%TYPE);

   FUNCTION get_assd_no_for_endt (
      p_line_cd      IN gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN gipi_polbasic.renew_no%TYPE,
      p_eff_date     IN gipi_polbasic.eff_date%TYPE)
      RETURN NUMBER;

   PROCEDURE get_amt_from_latest_endt (
      p_line_cd        IN     gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         IN     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN     gipi_polbasic.renew_no%TYPE,
      p_eff_date       IN     gipi_polbasic.eff_date%TYPE,
      p_field_name     IN     VARCHAR2,
      p_ann_tsi_amt       OUT gipi_polbasic.ann_tsi_amt%TYPE,
      p_ann_prem_amt      OUT gipi_polbasic.ann_prem_amt%TYPE,
      p_amt_sw            OUT VARCHAR2);

   PROCEDURE get_amt_from_pol_wout_endt (
      p_line_cd        IN     gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         IN     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN     gipi_polbasic.renew_no%TYPE,
      p_ann_tsi_amt       OUT gipi_polbasic.ann_tsi_amt%TYPE,
      p_ann_prem_amt      OUT gipi_polbasic.ann_prem_amt%TYPE);

   FUNCTION get_comp_no_of_days (p_par_id gipi_polbasic.line_cd%TYPE)
      RETURN NUMBER;

   FUNCTION get_back_endt_eff_date (p_par_id     gipi_wpolbas.par_id%TYPE,
                                    p_item_no    gipi_witem.item_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_spoiled_flag (
      p_line_cd      IN gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN gipi_polbasic.renew_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_spoiled_flag1 (
      p_line_cd      IN gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN gipi_polbasic.renew_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_ref_pol_no (p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                            p_subline_cd   IN gipi_polbasic.subline_cd%TYPE,
                            p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                            p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                            p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                            p_renew_no     IN gipi_polbasic.renew_no%TYPE)
      RETURN VARCHAR2;

   TYPE gipi_polbasic_type1 IS RECORD
   (
      pack_policy_id        gipi_polbasic.pack_policy_id%TYPE,
      line_cd               gipi_polbasic.line_cd%TYPE,
      subline_cd            gipi_polbasic.subline_cd%TYPE,
      iss_cd                gipi_polbasic.iss_cd%TYPE,
      issue_yy              gipi_polbasic.issue_yy%TYPE,
      pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
      renew_no              gipi_polbasic.renew_no%TYPE,
      endt_iss_cd           gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy               gipi_polbasic.endt_yy%TYPE,
      endt_seq_no           gipi_polbasic.endt_seq_no%TYPE,
      policy_id             gipi_polbasic.policy_id%TYPE,
      assd_no               gipi_polbasic.assd_no%TYPE,
      endt_type             gipi_polbasic.endt_type%TYPE,
      par_id                gipi_polbasic.par_id%TYPE,
      no_of_items           gipi_polbasic.no_of_items%TYPE,
      pol_flag              gipi_polbasic.pol_flag%TYPE,
      co_insurance_sw       gipi_polbasic.co_insurance_sw%TYPE,
      fleet_print_tag       gipi_polbasic.fleet_print_tag%TYPE,
      pack_pol              VARCHAR2 (1),
      policy_no             VARCHAR2 (50),
      par_no                VARCHAR2 (50),
      endt_no               VARCHAR2 (100),
      assd_name             giis_assured.assd_name%TYPE,
      bill_not_printed      VARCHAR2 (1),
      policy_ds_dtl_exist   VARCHAR2 (1),
      endt_tax              gipi_endttext.endt_tax%TYPE,
      itmperil_count        NUMBER (4),
      compulsory_death      VARCHAR2 (1),
      coc_type              gipi_vehicle.coc_type%TYPE,
      pack_pol_flag         giis_line.pack_pol_flag%TYPE
   );

   TYPE gipi_polbasic_tab1 IS TABLE OF gipi_polbasic_type1;

   FUNCTION get_polbasic_listing (p_par_id gipi_polbasic.par_id%TYPE)
      RETURN gipi_polbasic_tab1
      PIPELINED;

   TYPE endt_policy_type IS RECORD
   (
      policy_id          gipi_polbasic.policy_id%TYPE,
      line_cd            gipi_polbasic.line_cd%TYPE,
      subline_cd         gipi_polbasic.subline_cd%TYPE,
      iss_cd             gipi_polbasic.iss_cd%TYPE,
      issue_yy           gipi_polbasic.issue_yy%TYPE,
      pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      renew_no           gipi_polbasic.renew_no%TYPE,
      endt_no            VARCHAR2 (50),
      incept_date        gipi_polbasic.incept_date%TYPE,
      eff_date           gipi_polbasic.eff_date%TYPE,
      expiry_date        gipi_polbasic.expiry_date%TYPE,
      endt_expiry_date   gipi_polbasic.endt_expiry_date%TYPE,
      endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy            gipi_polbasic.endt_yy%TYPE,
      endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      pol_flag           gipi_polbasic.pol_flag%TYPE
   );

   TYPE endt_policy_tab IS TABLE OF endt_policy_type;

   FUNCTION get_endt_policy (p_par_id gipi_wpolbas.par_id%TYPE)
      RETURN endt_policy_tab
      PIPELINED;

   FUNCTION get_endt_policy2 (p_par_id IN gipi_wpolbas.par_id%TYPE)
      RETURN endt_policy_tab
      PIPELINED;

   PROCEDURE update_printed_count (p_policy_id gipi_polbasic.policy_id%TYPE);

   FUNCTION get_max_endt_item_no (
      p_line_cd      IN gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN gipi_polbasic.renew_no%TYPE)
      RETURN NUMBER;

   FUNCTION get_policy_for_endt (
      p_line_cd      IN gipi_wpolbas.line_cd%TYPE,
      p_subline_cd   IN gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd       IN gipi_wpolbas.iss_cd%TYPE,
      p_issue_yy     IN gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no   IN gipi_wpolbas.pol_seq_no%TYPE,
      p_renew_no     IN gipi_wpolbas.renew_no%TYPE,
      p_keyword      IN VARCHAR2)
      RETURN gipi_polbasic_tab
      PIPELINED;

   FUNCTION is_pol_exist (p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                          p_subline_cd   IN gipi_polbasic.subline_cd%TYPE,
                          p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                          p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                          p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                          p_renew_no     IN gipi_polbasic.renew_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_gipi_polbasic_listing (
      p_user_id        giis_users.user_id%TYPE,
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_line_cd2       gipi_polbasic.line_cd%TYPE,
      p_subline_cd2    gipi_polbasic.subline_cd%TYPE,
      p_endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy        gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE,
      p_assd_name      giis_assured.assd_name%TYPE)
      RETURN gipi_polbasic_tab3
      PIPELINED;

   FUNCTION check_if_bill_not_printed (
      p_policy_id    gipi_polbasic.policy_id%TYPE,
      p_pol_flag     gipi_polbasic.pol_flag%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE)
      RETURN VARCHAR2;

   TYPE gipi_polinfo_endtseq0_type IS RECORD
   (
      policy_id        gipi_polbasic.policy_id%TYPE,
      line_cd          gipi_polbasic.line_cd%TYPE,
      subline_cd       gipi_polbasic.subline_cd%TYPE,
      iss_cd           gipi_polbasic.iss_cd%TYPE,
      issue_yy         gipi_polbasic.issue_yy%TYPE,
      pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      renew_no         gipi_polbasic.renew_no%TYPE,
      ref_pol_no       gipi_polbasic.ref_pol_no%TYPE,
      endt_seq_no      gipi_polbasic.endt_seq_no%TYPE,
      expiry_date      VARCHAR2 (10), --gipi_polbasic.expiry_date%TYPE, changed by reymon 11132013
      assd_no          gipi_polbasic.assd_no%TYPE,
      cred_branch      gipi_polbasic.cred_branch%TYPE,
      issue_date       VARCHAR2 (10), --gipi_polbasic.issue_date%TYPE, changed by reymon 11132013
      incept_date      VARCHAR2 (10), --gipi_polbasic.incept_date%TYPE, changed by reymon 11132013
      pol_flag         gipi_polbasic.pol_flag%TYPE,
      mean_pol_flag    VARCHAR (50),
      nbt_line_cd      gipi_parlist.line_cd%TYPE,
      nbt_iss_cd       gipi_parlist.iss_cd%TYPE,
      par_yy           gipi_parlist.par_yy%TYPE,
      par_seq_no       gipi_parlist.par_seq_no%TYPE,
      quote_seq_no     gipi_parlist.quote_seq_no%TYPE,
      line_cd_rn       giex_rn_no.line_cd%TYPE,
      iss_cd_rn        giex_rn_no.iss_cd%TYPE,
      rn_yy            giex_rn_no.rn_yy%TYPE,
      rn_seq_no        giex_rn_no.rn_seq_no%TYPE,
      assd_name        VARCHAR (505), --giis_assured.assd_name%TYPE, gzelle 06.14.2013
      pack_pol_no      VARCHAR (50),
      pack_policy_id   gipi_pack_polbasic.pack_policy_id%TYPE,
      iss_name         giis_issource.iss_name%TYPE
   );

   TYPE gipi_polinfo_endtseq0_tab IS TABLE OF gipi_polinfo_endtseq0_type;

   FUNCTION get_gipi_polinfo_endtseq0 (
      p_line_cd             gipi_polbasic.line_cd%TYPE,
      p_subline_cd          gipi_polbasic.subline_cd%TYPE,
      p_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_issue_yy            gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no            gipi_polbasic.renew_no%TYPE,
      p_ref_pol_no          gipi_polbasic.ref_pol_no%TYPE,
      p_nbt_line_cd         gipi_parlist.line_cd%TYPE,
      p_nbt_iss_cd          gipi_parlist.iss_cd%TYPE,
      p_nbt_par_yy          gipi_parlist.par_yy%TYPE,
      p_nbt_par_seq_no      gipi_parlist.par_seq_no%TYPE,
      p_nbt_quote_seq_no    gipi_parlist.quote_seq_no%TYPE,
      p_user_id             giis_users.user_id%TYPE,
      p_module_id           VARCHAR2)
      RETURN gipi_polinfo_endtseq0_tab
      PIPELINED;

   TYPE gipi_polinfo_type IS RECORD
   (
      policy_id        gipi_polbasic.policy_id%TYPE,
      endorsement_no   VARCHAR (50),
      endt_type        gipi_polbasic.endt_type%TYPE,
      eff_date         gipi_polbasic.eff_date%TYPE,
      issue_date       gipi_polbasic.issue_date%TYPE,
      acct_ent_date    gipi_polbasic.acct_ent_date%TYPE,
      par_no           VARCHAR (50),
      quote_seq_no     gipi_parlist.quote_seq_no%TYPE,
      ref_pol_no       gipi_polbasic.ref_pol_no%TYPE,
      prem_amt         gipi_polbasic.prem_amt%TYPE,
      pol_flag         gipi_polbasic.pol_flag%TYPE,
      spld_flag        gipi_polbasic.spld_flag%TYPE,
      mean_pol_flag    VARCHAR (50),
      reinstate_tag    gipi_polbasic.reinstate_tag%TYPE
   );

   TYPE gipi_polinfo_tab IS TABLE OF gipi_polinfo_type;

   FUNCTION get_gipi_related_polinfo (
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_iss_cd            gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          gipi_polbasic.renew_no%TYPE,
      p_ref_pol_no        gipi_polbasic.ref_pol_no%TYPE,
      p_endorsement_no    VARCHAR,
      p_par_no            VARCHAR,
      p_eff_date          gipi_polbasic.eff_date%TYPE,
      p_issue_date        gipi_polbasic.issue_date%TYPE,
      p_acct_ent_date     gipi_polbasic.acct_ent_date%TYPE,
      p_ref_pol_no2       gipi_polbasic.ref_pol_no%TYPE,
      p_status            VARCHAR)
      RETURN gipi_polinfo_tab
      PIPELINED;

   TYPE gipi_polbasic_rep_type IS RECORD
   (                                          --Created by: Alfred  03/10/2011
      policy_id            gipi_polbasic.policy_id%TYPE,
      assd_name            VARCHAR2 (600),
      address1             gipi_polbasic.address1%TYPE,
      address2             gipi_polbasic.address2%TYPE,
      address3             gipi_polbasic.address3%TYPE,
      pol_seq_no1          VARCHAR2 (100),
      issue_date           gipi_polbasic.issue_date%TYPE,
      incept_date          gipi_polbasic.incept_date%TYPE,
      expiry_date          gipi_polbasic.expiry_date%TYPE,
      cf_coc_signatory     VARCHAR2 (200),
      cf_print_signatory   VARCHAR2 (200)
   );

   TYPE gipi_polbasic_rep_tab IS TABLE OF gipi_polbasic_rep_type;

   FUNCTION get_gipi_polbasic_rep (p_policy_id gipi_polbasic.policy_id%TYPE)
      --Created by: Alfred  03/10/2011
      RETURN gipi_polbasic_rep_tab
      PIPELINED;

   TYPE gipi_fleet_policy_type IS RECORD
   (
      policy_id       gipi_polbasic.policy_id%TYPE,
      policy_no       VARCHAR2 (200),
      endt_no         VARCHAR2 (50),
      endt_seq_no     gipi_polbasic.endt_seq_no%TYPE,
      assd_name       VARCHAR2 (600), --VARCHAR2 (200), changed from 200 to 600 by robert 09182013
      subline_cd      gipi_polbasic.subline_cd%TYPE,
      item_no         gipi_item.item_no%TYPE,
      item_title      gipi_item.item_title%TYPE,
      plate_no        gipi_vehicle.plate_no%TYPE,
      make            gipi_vehicle.make%TYPE,
      coc_serial_no   gipi_vehicle.coc_serial_no%TYPE,
      repair_lim      gipi_vehicle.repair_lim%TYPE,
      tsi_amt         gipi_itmperil.tsi_amt%TYPE,
      peril_sname     giis_peril.peril_sname%TYPE,
      prem_amt        gipi_itmperil.prem_amt%TYPE,
      assignee        gipi_vehicle.assignee%TYPE,
      motor_type      VARCHAR2 (50),
      motor_no        gipi_vehicle.motor_no%TYPE,
      serial_no       gipi_vehicle.serial_no%TYPE,
      deductible      gipi_deductibles.deductible_amt%TYPE,
      towing          gipi_vehicle.towing%TYPE
   );

   TYPE gipi_fleet_policy_tab IS TABLE OF gipi_fleet_policy_type;

   FUNCTION get_gipi_fleet_policy (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_fleet_policy_tab
      PIPELINED;

   TYPE gipi_fleet_pol_par_type IS RECORD
   (
      par_id          gipi_polbasic.par_id%TYPE,
      par_no          VARCHAR2 (200),
      endt_no         VARCHAR2 (50),
      endt_seq_no     gipi_polbasic.endt_seq_no%TYPE,
      assd_name       VARCHAR2 (200),
      subline_cd      gipi_polbasic.subline_cd%TYPE,
      item_no         gipi_item.item_no%TYPE,
      item_title      gipi_item.item_title%TYPE,
      plate_no        gipi_vehicle.plate_no%TYPE,
      make            gipi_vehicle.make%TYPE,
      coc_serial_no   gipi_vehicle.coc_serial_no%TYPE,
      repair_limit    gipi_vehicle.repair_lim%TYPE,
      tsi_amt         gipi_itmperil.tsi_amt%TYPE,
      peril_sname     giis_peril.peril_sname%TYPE,
      prem_amt        gipi_itmperil.prem_amt%TYPE,
      assignee        gipi_vehicle.assignee%TYPE,
      motor_type      VARCHAR2 (50),
      motor_no        gipi_vehicle.motor_no%TYPE,
      serial_no       gipi_vehicle.serial_no%TYPE
   );

   TYPE gipi_fleet_pol_par_tab IS TABLE OF gipi_fleet_pol_par_type;

   FUNCTION get_gipi_fleet_pol_par (p_par_id gipi_polbasic.par_id%TYPE)
      RETURN gipi_fleet_pol_par_tab
      PIPELINED;

   TYPE gipi_polmain_info_type IS RECORD
   (
      policy_id        gipi_polbasic.policy_id%TYPE,
      label_tag        gipi_polbasic.label_tag%TYPE,
      line_cd          gipi_polbasic.line_cd%TYPE,
      iss_cd           gipi_polbasic.iss_cd%TYPE,
      pack_pol_flag    gipi_polbasic.pack_pol_flag%TYPE,
      assd_name        giis_assured.assd_name%TYPE,
      acct_of          giis_assured.assd_name%TYPE,
      pol_no           VARCHAR (50),
      endorsement_no   VARCHAR (50),
      subline_mop_sw   VARCHAR2 (1),
      menu_line_cd     giis_line.menu_line_cd%TYPE
   );

   TYPE gipi_polmain_info_tab IS TABLE OF gipi_polmain_info_type;

   FUNCTION get_polmain_info (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_polmain_info_tab
      PIPELINED;

   TYPE gipi_polbasic_info_type IS RECORD
   (
      policy_id                  gipi_polbasic.policy_id%TYPE,
      pol_no                     VARCHAR2 (50),
      address1                   gipi_polbasic.address1%TYPE,
      address2                   gipi_polbasic.address2%TYPE,
      address3                   gipi_polbasic.address3%TYPE,
      endt_seq_no                gipi_polbasic.endt_seq_no%TYPE,
      booking_year               gipi_polbasic.booking_year%TYPE,
      booking_mth                gipi_polbasic.booking_mth%TYPE,
      type_desc                  giis_policy_type.type_desc%TYPE,
      industry_nm                giis_industry.industry_nm%TYPE,
      region_desc                giis_region.region_desc%TYPE,
      iss_name                   giis_issource.iss_name%TYPE,
      remarks                    gipi_parlist.remarks%TYPE,
      takeup_term_desc           giis_takeup_term.takeup_term_desc%TYPE,
      line_name                  giis_line.line_name%TYPE,
      incept_date                VARCHAR2 (10), --gipi_polbasic.incept_date%TYPE, changed by reymon 11132013
      expiry_date                VARCHAR2 (10), --gipi_polbasic.expiry_date%TYPE, changed by reymon 11132013
      issue_date                 VARCHAR2 (10), --gipi_polbasic.issue_date%TYPE, changed by reymon 11132013
      eff_date                   VARCHAR2 (10), --gipi_polbasic.eff_date%TYPE, changed by reymon 11132013
      endt_expiry_date           VARCHAR2 (10), --gipi_polbasic.endt_expiry_date%TYPE, changed by reymon 11132013
      ref_pol_no                 gipi_polbasic.ref_pol_no%TYPE,
      manual_renew_no            gipi_polbasic.manual_renew_no%TYPE,
      actual_renew_no            gipi_polbasic.actual_renew_no%TYPE,
      issue_yy                   gipi_polbasic.issue_yy%TYPE,
      prem_amt                   gipi_polbasic.prem_amt%TYPE,
      tsi_amt                    gipi_polbasic.tsi_amt%TYPE,
      risk_tag                   gipi_polbasic.risk_tag%TYPE,
      risk_desc                  cg_ref_codes.rv_meaning%TYPE,
      incept_tag                 gipi_polbasic.incept_tag%TYPE,
      expiry_tag                 gipi_polbasic.expiry_tag%TYPE,
      plan_sw                    gipi_polbasic.plan_sw%TYPE,
      endt_expiry_tag            gipi_polbasic.endt_expiry_tag%TYPE,
      bancassurance_sw           gipi_polbasic.bancassurance_sw%TYPE,
      surcharge_sw               gipi_polbasic.surcharge_sw%TYPE,
      discount_sw                gipi_polbasic.discount_sw%TYPE,
      pack_pol_flag              gipi_polbasic.pack_pol_flag%TYPE,
      auto_renew_flag            gipi_polbasic.auto_renew_flag%TYPE,
      foreign_acc_sw             gipi_polbasic.foreign_acc_sw%TYPE,
      reg_policy_sw              gipi_polbasic.reg_policy_sw%TYPE,
      prem_warr_tag              gipi_polbasic.prem_warr_tag%TYPE,
      prem_warr_days             gipi_polbasic.prem_warr_days%TYPE,
      fleet_print_tag            gipi_polbasic.fleet_print_tag%TYPE,
      with_tariff_sw             gipi_polbasic.with_tariff_sw%TYPE,
      co_insurance_sw            gipi_polbasic.co_insurance_sw%TYPE,
      prorate_flag               gipi_polbasic.prorate_flag%TYPE,
      short_rt_percent           gipi_polbasic.short_rt_percent%TYPE,
      prov_prem_tag              gipi_polbasic.prov_prem_tag%TYPE,
      prov_prem_pct              gipi_polbasic.prov_prem_pct%TYPE,
      comp_sw                    gipi_polbasic.comp_sw%TYPE,
      ann_tsi_amt                gipi_polbasic.ann_tsi_amt%TYPE,
      ann_prem_amt               gipi_polbasic.ann_prem_amt%TYPE,
      survey_agent_cd            gipi_polbasic.survey_agent_cd%TYPE,
      survey_agent               VARCHAR2 (100),
      settling_agent_cd          gipi_polbasic.settling_agent_cd%TYPE,
      settling_agent             VARCHAR2 (100),
      contract_proj_buss_title   gipi_engg_basic.contract_proj_buss_title%TYPE,
      construct_start_date       gipi_engg_basic.construct_start_date%TYPE,
      maintain_start_date        gipi_engg_basic.maintain_start_date%TYPE,
      construct_end_date         gipi_engg_basic.construct_end_date%TYPE,
      maintain_end_date          gipi_engg_basic.maintain_end_date%TYPE,
      mbi_policy_no              gipi_engg_basic.mbi_policy_no%TYPE,
      site_location              gipi_engg_basic.site_location%TYPE,
      time_excess                gipi_engg_basic.time_excess%TYPE,
      weeks_test                 gipi_engg_basic.weeks_test%TYPE,
      prompt_title               VARCHAR2 (100),
      prompt_location            VARCHAR2 (100),
      bank_btn_label             VARCHAR2 (20),
      info01                     gipi_polgenin.initial_info01%TYPE,
      info02                     gipi_polgenin.initial_info02%TYPE,
      info03                     gipi_polgenin.initial_info03%TYPE,
      info04                     gipi_polgenin.initial_info04%TYPE,
      info05                     gipi_polgenin.initial_info05%TYPE,
      info06                     gipi_polgenin.initial_info06%TYPE,
      info07                     gipi_polgenin.initial_info07%TYPE,
      info08                     gipi_polgenin.initial_info08%TYPE,
      info09                     gipi_polgenin.initial_info09%TYPE,
      info10                     gipi_polgenin.initial_info10%TYPE,
      info11                     gipi_polgenin.initial_info11%TYPE,
      info12                     gipi_polgenin.initial_info12%TYPE,
      info13                     gipi_polgenin.initial_info13%TYPE,
      info14                     gipi_polgenin.initial_info14%TYPE,
      info15                     gipi_polgenin.initial_info15%TYPE,
      info16                     gipi_polgenin.initial_info16%TYPE,
      info17                     gipi_polgenin.initial_info17%TYPE,
      gen_info01                 gipi_polgenin.gen_info01%TYPE,
      gen_info02                 gipi_polgenin.gen_info02%TYPE,
      gen_info03                 gipi_polgenin.gen_info03%TYPE,
      gen_info04                 gipi_polgenin.gen_info04%TYPE,
      gen_info05                 gipi_polgenin.gen_info05%TYPE,
      gen_info06                 gipi_polgenin.gen_info06%TYPE,
      gen_info07                 gipi_polgenin.gen_info07%TYPE,
      gen_info08                 gipi_polgenin.gen_info08%TYPE,
      gen_info09                 gipi_polgenin.gen_info09%TYPE,
      gen_info10                 gipi_polgenin.gen_info10%TYPE,
      gen_info11                 gipi_polgenin.gen_info11%TYPE,
      gen_info12                 gipi_polgenin.gen_info12%TYPE,
      gen_info13                 gipi_polgenin.gen_info13%TYPE,
      gen_info14                 gipi_polgenin.gen_info14%TYPE,
      gen_info15                 gipi_polgenin.gen_info15%TYPE,
      gen_info16                 gipi_polgenin.gen_info16%TYPE,
      gen_info17                 gipi_polgenin.gen_info17%TYPE,
      subline_cd_param           giis_parameters.param_name%TYPE, --added by robert SR 20307 10.27.15
      policy_endtseq0            gipi_polbasic.policy_id%TYPE,
      dsp_text                   VARCHAR2 (30),
      prompt_text                VARCHAR2 (30),
      line_type                  VARCHAR2 (10),
      open_policy_view           VARCHAR2 (15),
      policy_id_type             VARCHAR2 (5),
      default_currency           VARCHAR2 (5),
      is_foreign_currency        VARCHAR2 (1) --added by robert SR 21862 03.08.16
   );

   TYPE gipi_polbasic_info_tab IS TABLE OF gipi_polbasic_info_type;

   FUNCTION get_polbasic_info (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_polbasic_info_tab
      PIPELINED;

   TYPE gipi_polbasic_gipir311_type IS RECORD
   (
      policy_no          VARCHAR2 (100),
      policy_id          gipi_polbasic.policy_id%TYPE,
      expiry_date        VARCHAR2 (100),
      eff_date           VARCHAR2 (100),
      grouped_item_no    gipi_grouped_items.grouped_item_no%TYPE,
      cert_no            VARCHAR2 (100),
      title              VARCHAR2 (10000),
      issue_day          VARCHAR2 (5),
      issue_month_year   VARCHAR2 (50),
      iss_cd             gipi_polbasic.iss_cd%TYPE,
      grp_perilfilter    gipi_grouped_items.grouped_item_no%TYPE
   );

   TYPE gipi_polbasic_gipir311_tab IS TABLE OF gipi_polbasic_gipir311_type;

   FUNCTION get_polbasic_gipir311_info (
      p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_polbasic_gipir311_tab
      PIPELINED;

   TYPE gipi_gipir915_polbasic_type IS RECORD
   (
      policy_id            gipi_polbasic.policy_id%TYPE,
      assd_name            VARCHAR2 (600),
      subline_cd           gipi_polbasic.subline_cd%TYPE,
      address1             gipi_polbasic.address1%TYPE,
      address2             gipi_polbasic.address2%TYPE,
      address3             gipi_polbasic.address3%TYPE,
      policy_no1           VARCHAR2 (100),
      issue_date           VARCHAR2 (100),
      incept_date          VARCHAR2 (100),
      expiry_date          VARCHAR2 (100),
      item_no              gipi_item.item_no%TYPE,
      from_date            gipi_item.from_date%TYPE,
      TO_DATE              gipi_item.TO_DATE%TYPE,
      currency_rt          gipi_item.currency_rt%TYPE,
      make                 gipi_vehicle.make%TYPE,
      model_year           gipi_vehicle.model_year%TYPE,
      coc_no               VARCHAR2 (100),
      color                gipi_vehicle.color%TYPE,
      plate_no             gipi_vehicle.plate_no%TYPE,
      serial_no            gipi_vehicle.serial_no%TYPE,
      motor_no             gipi_vehicle.motor_no%TYPE,
      no_of_pass           gipi_vehicle.no_of_pass%TYPE,
      unladen_wt           gipi_vehicle.unladen_wt%TYPE,
      mot_type             gipi_vehicle.mot_type%TYPE,
      type_of_body_cd      gipi_vehicle.type_of_body_cd%TYPE,
      mv_file_no           gipi_vehicle.mv_file_no%TYPE,
      coc_serial_no        gipi_vehicle.coc_serial_no%TYPE,
      cf_coc_signatory     VARCHAR2 (200),
      cf_print_signatory   VARCHAR2 (200),
      car_company          GIIS_MC_CAR_COMPANY.car_company%TYPE --added based on SR8770
   );

   TYPE gipi_gipir915_polbasic_tab IS TABLE OF gipi_gipir915_polbasic_type;

   FUNCTION get_gipir915_polbasic_info (p_policy_id gipi_item.policy_id%TYPE)
      RETURN gipi_gipir915_polbasic_tab
      PIPELINED;

   TYPE gipi_polbasic_info_su_type IS RECORD
   (
      policy_id              gipi_polbasic.policy_id%TYPE,
      address1               gipi_polbasic.address1%TYPE,
      address2               gipi_polbasic.address2%TYPE,
      address3               gipi_polbasic.address3%TYPE,
      booking_year           gipi_polbasic.booking_year%TYPE,
      booking_mth            gipi_polbasic.booking_mth%TYPE,
      industry_nm            giis_industry.industry_nm%TYPE,
      region_desc            giis_region.region_desc%TYPE,
      takeup_term_desc       giis_takeup_term.takeup_term_desc%TYPE,
      incept_date            VARCHAR2 (10), --gipi_polbasic.incept_date%TYPE, changed by reymon 11132013
      expiry_date            VARCHAR2 (10), --gipi_polbasic.expiry_date%TYPE, changed by reymon 11132013
      issue_date             VARCHAR2 (10), --gipi_polbasic.issue_date%TYPE, changed by reymon 11132013
      eff_date               VARCHAR2 (10), --gipi_polbasic.eff_date%TYPE, changed by reymon 11132013
      endt_expiry_date       VARCHAR2 (10), --gipi_polbasic.endt_expiry_date%TYPE, changed by reymon 11132013
      ref_pol_no             gipi_polbasic.ref_pol_no%TYPE,
      incept_tag             gipi_polbasic.incept_tag%TYPE,
      expiry_tag             gipi_polbasic.expiry_tag%TYPE,
      bancassurance_sw       gipi_polbasic.bancassurance_sw%TYPE,
      reg_policy_sw          gipi_polbasic.reg_policy_sw%TYPE,
      auto_renew_flag        gipi_polbasic.auto_renew_flag%TYPE,
      prompt_text            VARCHAR2 (50),
      dsp_endt_expiry_date   VARCHAR2 (50),
      pol_flag               gipi_polbasic.pol_flag%TYPE,
      subline_cd             gipi_polbasic.subline_cd%TYPE,
      endt_seq_no            gipi_polbasic.endt_seq_no%TYPE,
      mortg_name             gipi_polbasic.mortg_name%TYPE,
      val_period             gipi_bond_basic.val_period%TYPE,
      val_period_unit        gipi_bond_basic.val_period_unit%TYPE,
      gen_info01             gipi_polgenin.gen_info01%TYPE,
      gen_info02             gipi_polgenin.gen_info02%TYPE,
      gen_info03             gipi_polgenin.gen_info03%TYPE,
      gen_info04             gipi_polgenin.gen_info04%TYPE,
      gen_info05             gipi_polgenin.gen_info05%TYPE,
      gen_info06             gipi_polgenin.gen_info06%TYPE,
      gen_info07             gipi_polgenin.gen_info07%TYPE,
      gen_info08             gipi_polgenin.gen_info08%TYPE,
      gen_info09             gipi_polgenin.gen_info09%TYPE,
      gen_info10             gipi_polgenin.gen_info10%TYPE,
      gen_info11             gipi_polgenin.gen_info11%TYPE,
      gen_info12             gipi_polgenin.gen_info12%TYPE,
      gen_info13             gipi_polgenin.gen_info13%TYPE,
      gen_info14             gipi_polgenin.gen_info14%TYPE,
      gen_info15             gipi_polgenin.gen_info15%TYPE,
      gen_info16             gipi_polgenin.gen_info16%TYPE,
      gen_info17             gipi_polgenin.gen_info17%TYPE,
      endt_text01            gipi_endttext.endt_text01%TYPE,
      endt_text02            gipi_endttext.endt_text02%TYPE,
      endt_text03            gipi_endttext.endt_text03%TYPE,
      endt_text04            gipi_endttext.endt_text04%TYPE,
      endt_text05            gipi_endttext.endt_text05%TYPE,
      endt_text06            gipi_endttext.endt_text06%TYPE,
      endt_text07            gipi_endttext.endt_text07%TYPE,
      endt_text08            gipi_endttext.endt_text08%TYPE,
      endt_text09            gipi_endttext.endt_text09%TYPE,
      endt_text10            gipi_endttext.endt_text10%TYPE,
      endt_text11            gipi_endttext.endt_text11%TYPE,
      endt_text12            gipi_endttext.endt_text12%TYPE,
      endt_text13            gipi_endttext.endt_text13%TYPE,
      endt_text14            gipi_endttext.endt_text14%TYPE,
      endt_text15            gipi_endttext.endt_text15%TYPE,
      endt_text16            gipi_endttext.endt_text16%TYPE,
      endt_text17            gipi_endttext.endt_text17%TYPE,
      pol_flag_desc          cg_ref_codes.rv_meaning%TYPE
   );

   TYPE gipi_polbasic_info_su_tab IS TABLE OF gipi_polbasic_info_su_type;

   FUNCTION get_polbasic_info_su (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_polbasic_info_su_tab
      PIPELINED;

   TYPE bank_payment_dtl_type IS RECORD
   (
      company_cd      gipi_polbasic.company_cd%TYPE,
      employee_cd     gipi_polbasic.employee_cd%TYPE,
      bank_ref_no     gipi_polbasic.bank_ref_no%TYPE,
      company_name    VARCHAR2 (50),
      employee_name   VARCHAR2 (50)
   );

   TYPE bank_payment_dtl_tab IS TABLE OF bank_payment_dtl_type;

   FUNCTION get_bank_payment_dtl (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN bank_payment_dtl_tab
      PIPELINED;

   TYPE bancassurance_dtl_type IS RECORD
   (
      banc_type_cd     gipi_polbasic.banc_type_cd%TYPE,
      area_cd          gipi_polbasic.area_cd%TYPE,
      branch_cd        gipi_polbasic.branch_cd%TYPE,
      manager_cd       gipi_polbasic.manager_cd%TYPE,
      banc_type_desc   giis_banc_type.banc_type_desc%TYPE,
      area_desc        giis_banc_area.area_desc%TYPE,
      branch_desc      giis_banc_branch.branch_desc%TYPE,
      full_name        VARCHAR2 (50)
   );

   TYPE bancassurance_dtl_tab IS TABLE OF bancassurance_dtl_type;

   FUNCTION get_bancassurance_dtl (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN bancassurance_dtl_tab
      PIPELINED;

   TYPE plan_dtl_type IS RECORD
   (
      plan_cd       gipi_polbasic.plan_cd%TYPE,
      plan_ch_tag   gipi_polbasic.plan_ch_tag%TYPE,
      plan_desc     VARCHAR2 (50)
   );

   TYPE plan_dtl_tab IS TABLE OF plan_dtl_type;

   FUNCTION get_plan_dtl (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN plan_dtl_tab
      PIPELINED;

   TYPE policy_endtseq0_type IS RECORD
   (
      pack_pol_no      VARCHAR (50),
      mean_pol_flag    VARCHAR (50),
      rn_yy            giex_rn_no.rn_yy%TYPE,
      iss_cd_rn        giex_rn_no.iss_cd%TYPE,
      line_cd_rn       giex_rn_no.line_cd%TYPE,
      nbt_iss_cd       gipi_parlist.iss_cd%TYPE,
      par_yy           gipi_parlist.par_yy%TYPE,
      rn_seq_no        giex_rn_no.rn_seq_no%TYPE,
      nbt_line_cd      gipi_parlist.line_cd%TYPE,
      iss_cd           gipi_polbasic.iss_cd%TYPE,
      line_cd          gipi_polbasic.line_cd%TYPE,
      assd_no          gipi_polbasic.assd_no%TYPE,
      assd_name        giis_assured.assd_name%TYPE,
      renew_no         gipi_polbasic.renew_no%TYPE,
      issue_yy         gipi_polbasic.issue_yy%TYPE,
      pol_flag         gipi_polbasic.pol_flag%TYPE,
      iss_name         giis_issource.iss_name%TYPE,
      par_seq_no       gipi_parlist.par_seq_no%TYPE,
      policy_id        gipi_polbasic.policy_id%TYPE,
      subline_cd       gipi_polbasic.subline_cd%TYPE,
      pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      ref_pol_no       gipi_polbasic.ref_pol_no%TYPE,
      issue_date       gipi_polbasic.issue_date%TYPE,
      incept_date      gipi_polbasic.incept_date%TYPE,
      quote_seq_no     gipi_parlist.quote_seq_no%TYPE,
      endt_seq_no      gipi_polbasic.endt_seq_no%TYPE,
      expiry_date      gipi_polbasic.expiry_date%TYPE,
      cred_branch      gipi_polbasic.cred_branch%TYPE,
      pack_policy_id   gipi_pack_polbasic.pack_policy_id%TYPE
   );

   TYPE policy_endtseq0_tab IS TABLE OF policy_endtseq0_type;

   FUNCTION get_policy_endtseq0 (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN policy_endtseq0_tab
      PIPELINED;

   TYPE policy_per_assured_type IS RECORD
   (
      policy_id          gipi_polbasic.policy_id%TYPE,
      line_cd            gipi_polbasic.line_cd%TYPE,
      subline_cd         gipi_polbasic.subline_cd%TYPE,
      iss_cd             gipi_polbasic.iss_cd%TYPE,
      issue_yy           gipi_polbasic.issue_yy%TYPE,
      pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      renew_no           gipi_polbasic.renew_no%TYPE,
      endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy            gipi_polbasic.endt_yy%TYPE,
      endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      endt_type          gipi_polbasic.endt_type%TYPE,
      incept_date        gipi_polbasic.incept_date%TYPE,
      expiry_date        gipi_polbasic.expiry_date%TYPE,
      pol_flag           gipi_polbasic.pol_flag%TYPE,
      tsi_amt            gipi_polbasic.tsi_amt%TYPE,
      prem_amt           gipi_polbasic.prem_amt%TYPE,
      par_id             gipi_polbasic.par_id%TYPE,
      acct_of_cd         gipi_polbasic.acct_of_cd%TYPE,
      endt_expiry_date   gipi_polbasic.endt_expiry_date%TYPE,
      label_tag          gipi_polbasic.label_tag%TYPE,
      cred_branch        gipi_polbasic.cred_branch%TYPE,
      assd_no            gipi_parlist.assd_no%TYPE,
      acct_of            VARCHAR2 (1000),       --giis_assured.assd_name%TYPE,
      mean_pol_flag      VARCHAR2 (50),
      policy_no          VARCHAR2 (50),
      endt_no            VARCHAR2 (50)
   );

   TYPE policy_per_assured_tab IS TABLE OF policy_per_assured_type;

   FUNCTION get_policy_per_assured (
      p_assd_no      gipi_parlist.assd_no%TYPE,
      p_user_id      gipi_polbasic.user_id%TYPE,
      p_module_id    giis_modules.module_id%TYPE)   -- added by gab 07.22.2015
      RETURN policy_per_assured_tab
      PIPELINED;


   TYPE policy_per_endrsment_type IS RECORD
   (
      policy_id          gipi_polbasic.policy_id%TYPE,
      line_cd            gipi_polbasic.line_cd%TYPE,
      subline_cd         gipi_polbasic.subline_cd%TYPE,
      iss_cd             gipi_polbasic.iss_cd%TYPE,
      issue_yy           gipi_polbasic.issue_yy%TYPE,
      pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      renew_no           gipi_polbasic.renew_no%TYPE,
      endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy            gipi_polbasic.endt_yy%TYPE,
      endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      endt_type          gipi_polbasic.endt_type%TYPE,
      incept_date        gipi_polbasic.incept_date%TYPE,
      expiry_date        gipi_polbasic.expiry_date%TYPE,
      pol_flag           gipi_polbasic.pol_flag%TYPE,
      tsi_amt            gipi_polbasic.tsi_amt%TYPE,
      prem_amt           gipi_polbasic.prem_amt%TYPE,
      par_id             gipi_polbasic.par_id%TYPE,
      acct_of_cd         gipi_polbasic.acct_of_cd%TYPE,
      endt_expiry_date   gipi_polbasic.endt_expiry_date%TYPE,
      label_tag          gipi_polbasic.label_tag%TYPE,
      cred_branch        gipi_polbasic.cred_branch%TYPE,
      assd_no            gipi_parlist.assd_no%TYPE,
      acct_of            giis_assured.assd_name%TYPE,
      ENDT_CD            GIIS_ENDTTEXT.ENDT_CD%TYPE,
      ENDT_TITLE         GIIS_ENDTTEXT.ENDT_TITLE%TYPE,
      mean_pol_flag      VARCHAR2 (50),
      policy_no          VARCHAR2 (50),
      endt_no            VARCHAR2 (50)
   );

   TYPE policy_per_endorsement_tab IS TABLE OF policy_per_endrsment_type;

   FUNCTION get_policy_per_endorsement (
      p_endt_type GIIS_ENDTTEXT.endt_cd%TYPE)
      RETURN policy_per_endorsement_tab
      PIPELINED;


   TYPE policy_per_obligee_type IS RECORD
   (
      subline_cd         gipi_polbasic.subline_cd%TYPE,
      policy_id          gipi_polbasic.policy_id%TYPE,
      issue_yy           gipi_polbasic.issue_yy%TYPE,
      renew_no           gipi_polbasic.renew_no%TYPE,
      line_cd            gipi_polbasic.line_cd%TYPE,
      endt_yy            gipi_polbasic.endt_yy%TYPE,
      tsi_amt            gipi_polbasic.tsi_amt%TYPE,
      iss_cd             gipi_polbasic.iss_cd%TYPE,
      par_id             gipi_polbasic.par_id%TYPE,
      prem_amt           gipi_polbasic.prem_amt%TYPE,
      endt_type          gipi_polbasic.endt_type%TYPE,
      label_tag          gipi_polbasic.label_tag%TYPE,
      acct_of_cd         gipi_polbasic.acct_of_cd%TYPE,
      pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      cred_branch        gipi_polbasic.cred_branch%TYPE,
      obligee_no         gipi_bond_basic.obligee_no%TYPE,
      endt_expiry_date   gipi_polbasic.endt_expiry_date%TYPE,
      policy_no          VARCHAR2 (50),
      endt_no            VARCHAR2 (50)
   );

   TYPE policy_per_obligee_tab IS TABLE OF policy_per_obligee_type;

   FUNCTION get_policy_per_obligee (
      p_obligee_no gipi_bond_basic.obligee_no%TYPE)
      RETURN policy_per_obligee_tab
      PIPELINED;

   TYPE policy_renewals_type IS RECORD
   (
      policy_id    gipi_polbasic.policy_id%TYPE,
      line_cd      gipi_polbasic.line_cd%TYPE,
      subline_cd   gipi_polbasic.subline_cd%TYPE,
      iss_cd       gipi_polbasic.iss_cd%TYPE,
      issue_yy     gipi_polbasic.issue_yy%TYPE,
      pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      renew_no     gipi_polbasic.renew_no%TYPE,
      policy_no    VARCHAR2 (50)
   );

   TYPE policy_renewals_tab IS TABLE OF policy_renewals_type;

   FUNCTION get_policy_renewals (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN policy_renewals_tab
      PIPELINED;

   TYPE endt_cancellation_lov_type IS RECORD
   (
      endorsement   VARCHAR2 (50),
      policy_id     gipi_polbasic.policy_id%TYPE
   );

   TYPE endt_cancellation_lov_tab IS TABLE OF endt_cancellation_lov_type;

   FUNCTION get_endt_cancellation_lov (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE)
      RETURN endt_cancellation_lov_tab
      PIPELINED;

   FUNCTION get_endt_cancellation_lov2 (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE)
      RETURN endt_cancellation_lov_tab
      PIPELINED;

   PROCEDURE get_endt_risk_tag (
      p_line_cd            gipi_polbasic.line_cd%TYPE,
      p_subline_cd         gipi_polbasic.subline_cd%TYPE,
      p_iss_cd             gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no           gipi_polbasic.renew_no%TYPE,
      p_risk_tag       OUT gipi_polbasic.risk_tag%TYPE,
      p_nbt_risk_tag   OUT cg_ref_codes.rv_meaning%TYPE);

   FUNCTION get_gipi_polbasic_list_cert (
      p_user_id         giis_users.user_id%TYPE,
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        gipi_polbasic.renew_no%TYPE,
      p_line_cd2        gipi_polbasic.line_cd%TYPE,
      p_subline_cd2     gipi_polbasic.subline_cd%TYPE,
      p_endt_iss_cd     gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy         gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no     gipi_polbasic.endt_seq_no%TYPE,
      p_assd_name       giis_assured.assd_name%TYPE,
      --optimization 10.13.2016 SR5680 MarkS 
      p_find_text       VARCHAR2,
      p_order_by      	VARCHAR2,
      p_asc_desc_flag 	VARCHAR2,
      p_from          	NUMBER,
      p_to            	NUMBER
      --optimization 10.13.2016 SR5680 MarkS 
     )
      RETURN gipi_polbasic_tab6
      PIPELINED;

   FUNCTION get_gipir915_polbasic_info2 (
      p_policy_id    gipi_item.policy_id%TYPE,
      p_item_no      gipi_item.item_no%TYPE)
      RETURN gipi_gipir915_polbasic_tab
      PIPELINED;

   TYPE gipi_polbasic_gipir913_type IS RECORD
   (
      policy_id              gipi_polbasic.policy_id%TYPE,
      acct_of_cd             gipi_polbasic.acct_of_cd%TYPE,
      label_tag              gipi_polbasic.label_tag%TYPE,
      assd_name              VARCHAR2 (600),
      address1               gipi_polbasic.address1%TYPE,
      address2               gipi_polbasic.address2%TYPE,
      address3               gipi_polbasic.address3%TYPE,
      assd_tin               giis_assured.assd_tin%TYPE,
      invoice_no             VARCHAR2 (50),
      date_issued            VARCHAR2 (50),
      line_name              giis_line.line_name%TYPE,
      policy_no              VARCHAR2 (50),
      endt_no                VARCHAR2 (50),
      date_from              VARCHAR2 (30),
      date_to                VARCHAR2 (30),
      subline_subline_time   VARCHAR2 (30),
      tsi_amt                gipi_polbasic.tsi_amt%TYPE,
      short_name             giis_currency.short_name%TYPE,
      prem_amt               gipi_invoice.prem_amt%TYPE,
      currency_cd            gipi_invoice.currency_cd%TYPE,
      policy_currency        gipi_invoice.policy_currency%TYPE,
      bank_ref_no            gipi_polbasic.bank_ref_no%TYPE,
      subline_name           giis_subline.subline_name%TYPE,
      intrmdry_intm_no       gipi_comm_invoice.intrmdry_intm_no%TYPE,
      currency_rt            giis_currency.currency_rt%TYPE,
      currency_desc          giis_currency.currency_desc%TYPE,
      intm_name              giis_intermediary.intm_name%TYPE,
      class_name             giis_subline.subline_name%TYPE,
      sum_insured_fc         gipi_polbasic.tsi_amt%TYPE,
      assd_name2             VARCHAR2 (500),
      f_assd_name            VARCHAR2 (600)
   );

   TYPE gipi_polbasic_gipir913_tab IS TABLE OF gipi_polbasic_gipir913_type;

   PROCEDURE get_ref_pol_no (
      p_line_cd       IN     gipi_polbasic.line_cd%TYPE,
      p_subline_cd    IN     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        IN     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      IN     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    IN     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      IN     gipi_polbasic.renew_no%TYPE,
      p_assd_no       IN     gipi_parlist.assd_no%TYPE,
      p_ref_pol_no       OUT gipi_polbasic.ref_pol_no%TYPE,
      p_exist            OUT VARCHAR2,
      p_incept_date      OUT VARCHAR2,
      p_expiry_date      OUT VARCHAR2,
      p_mesg             OUT VARCHAR2);

   FUNCTION get_redistribution_policies (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy        gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE,
      p_assd_name      giis_assured.assd_name%TYPE,
      p_eff_date       gipi_polbasic.eff_date%TYPE, --added by steven 11.12.2012
      p_expiry_date    gipi_polbasic.expiry_date%TYPE, --added by steven 11.12.2012
      p_user_id        giis_users.user_id%TYPE     --added by steven 1/15/2013
                                              )
      RETURN gipi_polbasic_tab5
      PIPELINED;

   /**
     * Rey Jadlocon
     * 08.11.2011
     * policybyAssured in Account of
     **/
/*Modified by pjsantos 11/14/2016 for optimization GENQA 5771*/
   TYPE polassured_in_acct_of_type IS RECORD
   (
      count_        NUMBER, 
      rownum_       NUMBER,
      assd_no       GIPI_POLBASIC.ASSD_NO%TYPE,
      assd_name     GIIS_ASSURED.ASSD_NAME%TYPE,
      policy_id     GIPI_POLBASIC.POLICY_ID%TYPE,  
      line_cd       GIPI_POLBASIC.LINE_CD%TYPE,
      subline_cd    GIPI_POLBASIC.SUBLINE_CD%TYPE,
      iss_cd        GIPI_POLBASIC.ISS_CD%TYPE,
      issue_yy      GIPI_POLBASIC.ISSUE_YY%TYPE,
      pol_seq_no    GIPI_POLBASIC.POL_SEQ_NO%TYPE,
      renew_no      GIPI_POLBASIC.RENEW_NO%TYPE,
      endt_iss_cd   GIPI_POLBASIC.ENDT_ISS_CD%TYPE,
      endt_seq_no   GIPI_POLBASIC.ENDT_SEQ_NO%TYPE,
      endt_yy       GIPI_POLBASIC.ENDT_YY%TYPE,
      endt_type     GIPI_POLBASIC.ENDT_TYPE%TYPE,     
      policy_no     VARCHAR2 (100),
      endt_no       VARCHAR2 (100),           
      acct_of_cd    GIPI_POLBASIC.ACCT_OF_CD%TYPE,
      assd_name2    VARCHAR (1000)  
   ); 

   TYPE polassured_in_acct_of_tab IS TABLE OF polassured_in_acct_of_type;

   FUNCTION get_polassured_in_acct_of(  p_assd_name          VARCHAR2,
                                        p_assd_name2         VARCHAR2,
                                        p_policy_no          VARCHAR2, 
                                        p_endt_no            VARCHAR2, 
                                        p_order_by           VARCHAR2,      
                                        p_asc_desc_flag      VARCHAR2,      
                                        p_first_row          NUMBER,        
                                        p_last_row           NUMBER) 
      RETURN polassured_in_acct_of_tab PIPELINED;
--pjsantos end
   PROCEDURE exec_giuws012_v370_post_query (
      p_policy_id              IN     GIPI_POLBASIC.policy_id%TYPE,
      p_sve_facultative_code      OUT VARCHAR2,
      p_neg_dist_no               OUT gipi_polbasic_pol_dist_v.dist_no%TYPE,
      p_dist_status               OUT VARCHAR2);

   /**
   * Rey Jadlocon
   * 08.16.2011
   * bond policy data
   **/
   TYPE bond_policy_data_type IS RECORD
   (
      obligee_name     GIIS_OBLIGEE.OBLIGEE_NAME%TYPE,
      prin_signor      GIIS_PRIN_SIGNTRY.PRIN_SIGNOR%TYPE,
      designation      GIIS_PRIN_SIGNTRY.DESIGNATION%TYPE,
      np_name          GIIS_NOTARY_PUBLIC.NP_NAME%TYPE,
      clause_desc      GIIS_BOND_CLASS_CLAUSE.CLAUSE_DESC%TYPE,
      gen_info         VARCHAR2 (2000),
      bond_dtl         GIPI_BOND_BASIC.BOND_DTL%TYPE,
      indemnity_text   GIPI_BOND_BASIC.INDEMNITY_TEXT%TYPE,
      coll_flag        GIPI_BOND_BASIC.COLL_FLAG%TYPE,
      waiver_limit     GIPI_BOND_BASIC.WAIVER_LIMIT%TYPE,
      str_cntr_date    VARCHAR2 (100),
      contract_dtl     GIPI_BOND_BASIC.CONTRACT_DTL%TYPE,
      policy_id        GIPI_BOND_BASIC.POLICY_ID%TYPE
   );

   TYPE bond_policy_data_tab IS TABLE OF bond_policy_data_type;

   FUNCTION get_bond_policy_data (p_policy_id GIPI_BOND_BASIC.POLICY_ID%TYPE)
      RETURN bond_policy_data_tab
      PIPELINED;


   /**
   * Rey Jadlocon
   * 08.15.2011
   * policy by obligee list
   **/
   TYPE policy_obligee_type IS RECORD
   (
      policy_id      GIPI_POLBASIC.POLICY_ID%TYPE,
      endt_seq_no    GIPI_POLBASIC.ENDT_SEQ_NO%TYPE,
      endt_yy        GIPI_POLBASIC.ENDT_YY%TYPE,
      endt_iss_cd    GIPI_POLBASIC.ENDT_ISS_CD%TYPE,
      obligee_name   GIIS_OBLIGEE.OBLIGEE_NAME%TYPE,
      pol_seq_no     GIPI_POLBASIC.POL_SEQ_NO%TYPE,
      policy_no      VARCHAR2 (100),
      endt_no        VARCHAR2 (100),
      tsi_amt        GIPI_POLBASIC.TSI_AMT%TYPE,
      prem_amt       GIPI_POLBASIC.PREM_AMT%TYPE
   );

   TYPE policy_obligee_tab IS TABLE OF policy_obligee_type;

   FUNCTION get_policy_obligee_list (
      p_obligee_no GIPI_BOND_BASIC.OBLIGEE_NO%TYPE)
      RETURN policy_obligee_tab
      PIPELINED;

   /**
   * Rey Jadlocon
   * 08.16.2011
   * consignor(s)
   **/
   TYPE cosignor_type IS RECORD
   (
      cosign_name   GIIS_COSIGNOR_RES.COSIGN_NAME%TYPE,
      bonds_flag    GIPI_COSIGNTRY.BONDS_FLAG%TYPE,
      indem_flag    GIPI_COSIGNTRY.INDEM_FLAG%TYPE
   );

   TYPE cosignor_tab IS TABLE OF cosignor_type;

   FUNCTION get_cosignor (p_policy_id gipi_cosigntry.policy_id%TYPE)
      RETURN cosignor_tab
      PIPELINED;

   FUNCTION get_redistribution_policy (
      p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_polbasic_tab5
      PIPELINED;

   FUNCTION get_issue_yy_list (p_line_cd       gipi_polbasic.line_cd%TYPE,
                               p_subline_cd    gipi_polbasic.subline_cd%TYPE,
                               p_pol_iss_cd    gipi_polbasic.iss_cd%TYPE)
      RETURN gipi_polbasic_tab
      PIPELINED;

   FUNCTION get_pol_seq_no_list (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd    gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE)
      RETURN gipi_polbasic_tab
      PIPELINED;

   FUNCTION get_renew_no_list (p_line_cd       gipi_polbasic.line_cd%TYPE,
                               p_subline_cd    gipi_polbasic.subline_cd%TYPE,
                               p_pol_iss_cd    gipi_polbasic.iss_cd%TYPE,
                               p_issue_yy      gipi_polbasic.issue_yy%TYPE,
                               p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE)
      RETURN gipi_polbasic_tab
      PIPELINED;

   PROCEDURE get_pack_details_header (
      p_pack_policy_id     IN     gipi_polbasic.pack_policy_id%TYPE,
      p_policy_id          IN     gipi_polbasic.policy_id%TYPE,
      p_dsp_policy_id         OUT gipi_polbasic.policy_id%TYPE,
      p_dsp_line_cd           OUT giex_expiries_v.line_cd%TYPE,
      p_dsp_subline_cd        OUT giex_expiries_v.subline_cd%TYPE,
      p_dsp_iss_cd            OUT giex_expiries_v.iss_cd%TYPE,
      p_dsp_issue_yy          OUT giex_expiries_v.issue_yy%TYPE,
      p_dsp_pol_seq_no        OUT giex_expiries_v.pol_seq_no%TYPE,
      p_dsp_renew_no          OUT giex_expiries_v.renew_no%TYPE,
      p_basic_policy_id       OUT gipi_polbasic.policy_id%TYPE,
      p_basic_line_cd         OUT gipi_polbasic.line_cd%TYPE,
      p_basic_subline_cd      OUT gipi_polbasic.subline_cd%TYPE,
      p_basic_iss_cd          OUT gipi_polbasic.iss_cd%TYPE,
      p_basic_issue_yy        OUT gipi_polbasic.issue_yy%TYPE,
      p_basic_pol_seq_no      OUT gipi_polbasic.pol_seq_no%TYPE,
      p_basic_renew_no        OUT gipi_polbasic.renew_no%TYPE);

   PROCEDURE UPDATE_POLBAS2 (p_new_policy_id gipi_polbasic.policy_id%TYPE);

   PROCEDURE check_policy_gicls026 (
      p_line_cd      IN     gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN     gipi_polbasic.pol_seq_no%TYPE, 
      p_renew_no     IN     gipi_polbasic.renew_no%TYPE,
      p_msg             OUT VARCHAR2);

   FUNCTION get_polbasic_issue_yy (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE)
      RETURN gipi_polbasic_tab
      PIPELINED;

   FUNCTION get_polbasic_pol_seq_no (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE)
      RETURN gipi_polbasic_tab
      PIPELINED;

   FUNCTION get_polbasic_renew_no (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE)
      RETURN gipi_polbasic_tab
      PIPELINED;

   FUNCTION get_giuts024_listing (
      p_user_id        giis_users.user_id%TYPE,
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE)
      RETURN gipi_polbasic_tab5
      PIPELINED;

   FUNCTION get_policy_no (p_policy_id GIPI_POLBASIC.policy_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_endt_no (p_policy_id GIPI_POLBASIC.policy_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_pack_policy_no (
      p_pack_policy_id GIPI_PACK_POLBASIC.pack_policy_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_pack_endt_no (
      p_pack_policy_id GIPI_PACK_POLBASIC.pack_policy_id%TYPE)
      RETURN VARCHAR2;

   TYPE reprint_policy_type IS RECORD
   (
      pack_policy_id    gipi_polbasic.pack_policy_id%TYPE,
      line_cd           gipi_polbasic.line_cd%TYPE,
      menu_line_cd      giis_line.menu_line_cd%TYPE,
      subline_cd        gipi_polbasic.subline_cd%TYPE,
      iss_cd            gipi_polbasic.iss_cd%TYPE,
      issue_yy          gipi_polbasic.issue_yy%TYPE,
      pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      renew_no          gipi_polbasic.renew_no%TYPE,
      endt_iss_cd       gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy           gipi_polbasic.endt_yy%TYPE,
      endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
      policy_id         gipi_polbasic.policy_id%TYPE,
      assd_no           gipi_polbasic.assd_no%TYPE,
      endt_type         gipi_polbasic.endt_type%TYPE,
      par_id            gipi_polbasic.par_id%TYPE,
      no_of_items       gipi_polbasic.no_of_items%TYPE,
      pol_flag          gipi_polbasic.pol_flag%TYPE,
      co_insurance_sw   gipi_polbasic.co_insurance_sw%TYPE,
      fleet_print_tag   gipi_polbasic.fleet_print_tag%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      par_no            VARCHAR2 (50),
      policy_no         VARCHAR2 (100),
      endt_no           VARCHAR2 (100),
      dsp_prem_seq_no   VARCHAR2 (50),
      prem_seq_no       gipi_invoice.prem_seq_no%TYPE,
      endt_tax          gipi_endttext.endt_tax%TYPE,
      coc_type          gipi_vehicle.coc_type%TYPE,
      count_            NUMBER, --added by pjsantos @pcic 09/14/2016, for optimization
      rownum_           NUMBER --added by pjsantos @pcic 09/14/2016, for optimization
   );

   TYPE reprint_policy_tab IS TABLE OF reprint_policy_type;

   FUNCTION get_reprint_policy_listing (
      p_user_id            giis_users.user_id%TYPE,
      p_line_cd            gipi_polbasic.line_cd%TYPE,
      p_subline_cd         gipi_polbasic.subline_cd%TYPE,
      p_iss_cd             gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no           gipi_polbasic.renew_no%TYPE,
      p_endt_line_cd       gipi_polbasic.line_cd%TYPE,
      p_endt_subline_cd    gipi_polbasic.subline_cd%TYPE, 
      p_endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy            gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      p_assd_name          giis_assured.assd_name%TYPE,
      p_policy_no          VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_endt_no            VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_par_no             VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_dsp_prem_seq_no    VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_order_by           VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_asc_desc_flag      VARCHAR2,      --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_first_row          NUMBER,        --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
      p_last_row           NUMBER         --added by pjsantos @pcic 09/14/2016, for optimization GENQA 5666
                                 )
      RETURN reprint_policy_tab
      PIPELINED;


   TYPE gipi_polno_lov_type IS RECORD
   (
      line_cd      gipi_polbasic.line_cd%TYPE,
      subline_cd   gipi_polbasic.subline_cd%TYPE,
      iss_cd       gipi_polbasic.iss_cd%TYPE,
      issue_yy     gipi_polbasic.issue_yy%TYPE,
      pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      assd_name    VARCHAR2 (15000),
      policy_no    VARCHAR2 (50),
      policy_id    gipi_polbasic.policy_id%TYPE,
      endt_no      VARCHAR2 (100),
      endt_type    gipi_polbasic.endt_type%TYPE
   );

   TYPE gipi_polno_lov_tab IS TABLE OF gipi_polno_lov_type;

   FUNCTION get_gipd_line_cd_lov (p_keyword VARCHAR2)
      RETURN gipd_line_cd_lov_tab
      PIPELINED;

   FUNCTION get_gipi_polno_lov (p_user_id    giis_users.user_id%TYPE, --edited by steven 09.02.2014
                                p_iss_cd     giis_issource.iss_cd%TYPE,
                                p_line_cd    giis_line.line_cd%TYPE)
      RETURN gipi_polno_lov_tab 
      PIPELINED;

   TYPE check_policy_giexs006_type IS RECORD 
   (
      policy_id   gipi_polbasic.policy_id%TYPE,  
      pol_flag    gipi_polbasic.pol_flag%TYPE
   );

   TYPE check_policy_giexs006_tab IS TABLE OF check_policy_giexs006_type;

   FUNCTION check_policy_giexs006 (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE)
      RETURN check_policy_giexs006_tab
      PIPELINED;

   FUNCTION get_policy_information (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_polinfo_endtseq0_tab
      PIPELINED;

   FUNCTION get_policy_bond_seq_no (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE)
      RETURN NUMBER;

   --GIUTS008A
   TYPE check_giuts008a_type IS RECORD
   (
      user_id          gipi_wpolbas.user_id%TYPE,
      exist            VARCHAR2 (1),
      spld             VARCHAR2 (1),
      spld1            VARCHAR2 (1),
      spld2            VARCHAR2 (1),
      pack_policy_id   gipi_pack_polbasic.pack_policy_id%TYPE
   );

   TYPE check_giuts008a_tab IS TABLE OF check_giuts008a_type;

   FUNCTION check_endt_giuts008a (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy        gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE)
      RETURN check_giuts008a_tab
      PIPELINED;

   FUNCTION check_policy_giuts008a (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE)
      RETURN check_giuts008a_tab
      PIPELINED;

   -- bonok :: 01.07.2013
   FUNCTION get_ref_pol_no2 (p_line_cd       gipi_polbasic.line_cd%TYPE,
                             p_subline_cd    gipi_polbasic.subline_cd%TYPE,
                             p_iss_cd        gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy      gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no      gipi_polbasic.renew_no%TYPE)
      RETURN VARCHAR2;

   -- added by Kris 08.22.2013 [for GIUTS027- Update Policy Coverage]
   FUNCTION get_giuts027_policy_list (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE,
      p_endt_yy        gipi_polbasic.endt_yy%TYPE,
      p_endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
      p_assd_name      giis_assured.assd_name%TYPE,
      p_user_id        gipi_polbasic.user_id%TYPE,
      p_module_id      giis_modules.module_id%TYPE)
      RETURN gipi_polbasic_tab4
      PIPELINED;

   TYPE gipis156_pol_no_type IS RECORD
   (
      policy_id                  gipi_polbasic.policy_id%TYPE,
      line_cd                    gipi_polbasic.line_cd%TYPE,
      subline_cd                 gipi_polbasic.subline_cd%TYPE,
      iss_cd                     gipi_polbasic.iss_cd%TYPE,
      issue_yy                   gipi_polbasic.issue_yy%TYPE,
      pol_seq_no                 gipi_polbasic.pol_seq_no%TYPE,
      renew_no                   gipi_polbasic.renew_no%TYPE,
      endt_iss_cd                gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy                    gipi_polbasic.endt_yy%TYPE,
      endt_seq_no                gipi_polbasic.endt_seq_no%TYPE,
      dsp_endt_iss_cd            gipi_polbasic.endt_iss_cd%TYPE,
      dsp_endt_yy                gipi_polbasic.endt_yy%TYPE,
      dsp_endt_seq_no            gipi_polbasic.endt_seq_no%TYPE,
      assd_name                  giis_assured.assd_name%TYPE,
      cred_branch                gipi_polbasic.cred_branch%TYPE,
      incept_date                gipi_polbasic.incept_date%TYPE,
      issue_date                 gipi_polbasic.issue_date%TYPE,
      allow_booking_in_adv_tag   VARCHAR2 (200),
      policy_endt_no             VARCHAR2 (200),
      assd_name2                 giis_assured.assd_name%TYPE,
      endt_type                  gipi_polbasic.endt_type%TYPE,
      bancassurance_sw           gipi_polbasic.bancassurance_sw%TYPE,
      ora2010_sw                 giis_parameters.param_value_v%TYPE
   );

   TYPE gipis156_pol_no_tab IS TABLE OF gipis156_pol_no_type;

   FUNCTION get_gipis156_pol_no_lov (p_line_cd       VARCHAR2,
                                     p_subline_cd    VARCHAR2,
                                     p_iss_cd        VARCHAR2,
                                     p_issue_yy      VARCHAR2,
                                     p_pol_seq_no    VARCHAR2,
                                     p_renew_no      VARCHAR2,
                                     p_user_id       VARCHAR2,
                                     p_module_id     VARCHAR2)
      RETURN gipis156_pol_no_tab
      PIPELINED;

   TYPE gipis156_basic_info_type IS RECORD
   (
      reg_policy_sw         gipi_polbasic.reg_policy_sw%TYPE,
      eff_date              gipi_polbasic.eff_date%TYPE,
      issue_date            gipi_polbasic.issue_date%TYPE,
      expiry_date           gipi_polbasic.expiry_date%TYPE, --benjo 10.07.2015 GENQA-SR-4890
      cred_branch           giis_issource.iss_name%TYPE,
      cred_branch_cd        giis_issource.iss_cd%TYPE,
      booking_year          gipi_polbasic.booking_year%TYPE,
      booking_mth           gipi_polbasic.booking_mth%TYPE,
      booking_mth_yr        VARCHAR2 (50),
      acct_ent_date         gipi_polbasic.acct_ent_date%TYPE,
      area_cd               gipi_polbasic.area_cd%TYPE,
      branch_cd             gipi_polbasic.branch_cd%TYPE,
      dsp_area_desc         giis_banc_area.area_desc%TYPE,
      dsp_branch_desc       giis_banc_branch.branch_desc%TYPE,
      manager_cd            gipi_polbasic.manager_cd%TYPE,
      bank_ref_no           gipi_polbasic.bank_ref_no%TYPE,
      dsp_manager_name      VARCHAR2 (1000),
      nbt_acct_iss_cd       VARCHAR2 (100),
      nbt_branch_cd         VARCHAR2 (100),
      dsp_ref_no            VARCHAR2 (100),
      dsp_mod_no            VARCHAR2 (100),
      bank_ref_no_enabled   VARCHAR2 (1),
      takeup_term           gipi_polbasic.takeup_term%TYPE,
      update_booking_sw     giis_parameters.param_value_v%TYPE
            := NVL (giisp.v ('UPDATE_BOOKING'), 'Y'),
      var_vdate             giac_parameters.param_value_n%TYPE
            := giacp.n ('PROD_TAKE_UP')
   );

   TYPE gipis156_basic_info_tab IS TABLE OF gipis156_basic_info_type;

   FUNCTION get_gipis156_basic_info (p_line_cd        VARCHAR2,
                                     p_subline_cd     VARCHAR2,
                                     p_iss_cd         VARCHAR2,
                                     p_issue_yy       VARCHAR2,
                                     p_pol_seq_no     VARCHAR2,
                                     p_renew_no       VARCHAR2,
                                     p_endt_yy        VARCHAR2,
                                     p_endt_seq_no    VARCHAR2,
                                     p_cred_branch    VARCHAR2)
      RETURN gipis156_basic_info_tab
      PIPELINED;

   TYPE gipis209_exposure_type IS RECORD
   (
      -- added by MarkS 12.1.2016 SR5863
      count_                NUMBER,
      rownum_               NUMBER,
      --SR5863
      currency_rt_chk   VARCHAR2 (1),
      policy_id         gipi_polbasic.policy_id%TYPE,
      line_cd           gipi_polbasic.line_cd%TYPE,
      subline_cd        gipi_polbasic.subline_cd%TYPE,
      iss_cd            gipi_polbasic.iss_cd%TYPE,
      issue_yy          gipi_polbasic.issue_yy%TYPE,
      pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      renew_no          gipi_polbasic.renew_no%TYPE,
      endt_iss_cd       gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy           gipi_polbasic.endt_yy%TYPE,
      endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
      item              VARCHAR2 (700),
      tsi_amt_orig      gipi_polbasic.tsi_amt%TYPE,
      tsi_amt           gipi_polbasic.tsi_amt%TYPE,
      prem_amt_orig     gipi_polbasic.prem_amt%TYPE,
      prem_amt          gipi_polbasic.prem_amt%TYPE,
      assd_no           gipi_polbasic.assd_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      incept_date       VARCHAR2 (100),
      issue_date        VARCHAR2 (100),
      eff_date          VARCHAR2 (100),
      expiry_date       VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      endt_no           VARCHAR2 (100)
   );

   TYPE gipis209_exposure_tab IS TABLE OF gipis209_exposure_type;

   FUNCTION get_exposure_list (p_search_by         VARCHAR2,
                               p_search_date       VARCHAR2,
                               p_as_of_date        VARCHAR2,
                               p_from_date         VARCHAR2,
                               p_to_date           VARCHAR2,
                               -- added by MarkS 12.1.2016 SR5863
                               p_order_by          VARCHAR2,
                               p_asc_desc_flag     VARCHAR2,
                               p_from              NUMBER,
                               p_to                NUMBER,
                               p_filt_pol_no       VARCHAR2,
                               p_filt_endt_no      VARCHAR2,
                               p_filt_item         NUMBER,
                               p_filt_tsiamtorg    NUMBER,
                               p_filt_premantorg   NUMBER)
                               --SR5863
      RETURN gipis209_exposure_tab
      PIPELINED;


   TYPE gipi_polbasic_gipis155_type IS RECORD
   (
      par_id            gipi_polbasic.par_id%TYPE,
      policy_id         gipi_polbasic.policy_id%TYPE,
      line_cd           gipi_polbasic.line_cd%TYPE,
      subline_cd        gipi_polbasic.subline_cd%TYPE,
      iss_cd            gipi_polbasic.iss_cd%TYPE,
      issue_yy          gipi_polbasic.issue_yy%TYPE,
      pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      renew_no          gipi_polbasic.renew_no%TYPE,
      endt_iss_cd       gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy           gipi_polbasic.endt_yy%TYPE,
      endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
      assd_no           gipi_polbasic.assd_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      dsp_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      dsp_endt_yy       gipi_polbasic.endt_yy%TYPE,
      dsp_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE
   );

   TYPE gipi_polbasic_gipis155_tab IS TABLE OF gipi_polbasic_gipis155_type;

   FUNCTION get_polbasic_list_gipis155 (
      p_line_cd            gipi_polbasic.LINE_CD%TYPE,
      p_subline_cd         gipi_polbasic.SUBLINE_CD%TYPE,
      p_iss_cd             gipi_polbasic.ISS_CD%TYPE,
      p_issue_yy           gipi_polbasic.ISSUE_YY%TYPE,
      p_pol_seq_no         gipi_polbasic.POL_SEQ_NO%TYPE,
      p_renew_no           gipi_polbasic.RENEW_NO%TYPE,
      p_dsp_endt_iss_cd    VARCHAR2,
      p_dsp_endt_yy        VARCHAR2,
      p_dsp_endt_seq_no    VARCHAR2,
      p_assd_name          VARCHAR2,
      p_module_id          VARCHAR2,
      p_user_id            VARCHAR2)
      RETURN gipi_polbasic_gipis155_tab
      PIPELINED;

   TYPE gipis100_endt_code_type IS RECORD
   (
      endt_cd      giis_endttext.endt_cd%TYPE,
      endt_title   giis_endttext.endt_title%TYPE
   );

   TYPE gipis100_endt_code_tab IS TABLE OF gipis100_endt_code_type;

   FUNCTION get_gipis100_endt_code_list
      RETURN gipis100_endt_code_tab
      PIPELINED;

   TYPE gipis100_endt_list_type_type IS RECORD
   (
      policy_id   gipi_polbasic.policy_id%TYPE,
      policy_no   VARCHAR2 (50),
      endt_no     VARCHAR2 (25),
      tsi_amt     gipi_polbasic.tsi_amt%TYPE,
      prem_amt    gipi_polbasic.prem_amt%TYPE
   );

   TYPE gipis100_endt_list_type_tab IS TABLE OF gipis100_endt_list_type_type;

   FUNCTION get_gipis100_endt_type_list (
      p_endt_cd gipi_endttext.endt_cd%TYPE)
      RETURN gipis100_endt_list_type_tab
      PIPELINED;

   --added by hdrtagudin 07302015 SR 18751
   TYPE initial_acceptance_type IS RECORD
   (
      policy_no       VARCHAR2 (50),
      par_no          VARCHAR2 (50),
      endt_no         VARCHAR2 (50),
      assd_name       VARCHAR (3000),
      accept_no       giri_inpolbas.accept_no%TYPE,
      accept_by       giri_inpolbas.accept_by%TYPE,
      ri_name         giis_reinsurer.ri_name%TYPE,
      reassured       giis_reinsurer.ri_name%TYPE,
      ref_accept_no   giri_inpolbas.ref_accept_no%TYPE,
      accept_date     giri_inpolbas.accept_date%TYPE,
      ri_endt_no      giri_inpolbas.ri_endt_no%TYPE,
      orig_tsi_amt    giri_inpolbas.orig_tsi_amt%TYPE,
      ri_policy_no    giri_inpolbas.ri_policy_no%TYPE,
      ri_binder_no    giri_inpolbas.ri_binder_no%TYPE,
      offer_date      giri_inpolbas.offer_date%TYPE,
      orig_prem_amt   giri_inpolbas.orig_prem_amt%TYPE,
      remarks         giri_inpolbas.remarks%TYPE
   );

   TYPE initial_acceptance_type_tab IS TABLE OF initial_acceptance_type;

   FUNCTION get_initial_acceptance (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN initial_acceptance_type_tab
      PIPELINED;

   -- added by MarkS 5.25.2016 SR-22344
   FUNCTION get_old_user_id (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_polbasic.user_id%TYPE;

   -- end SR-22344   
   
   FUNCTION get_par_id(p_policy_id gipi_polbasic.policy_id%TYPE)
     RETURN gipi_polbasic.par_id%TYPE;
   
END gipi_polbasic_pkg;
/


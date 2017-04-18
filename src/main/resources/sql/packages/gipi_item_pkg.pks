CREATE OR REPLACE PACKAGE CPI.GIPI_ITEM_PKG AS
  TYPE gipi_item_type IS RECORD (
    policy_id       GIPI_ITEM.policy_id%TYPE,
    item_no         GIPI_ITEM.item_no%TYPE,
    item_title      GIPI_ITEM.item_title%TYPE,
    item_grp        GIPI_ITEM.item_grp%TYPE,
    item_desc       GIPI_ITEM.item_desc%TYPE,
    item_desc2      GIPI_ITEM.item_desc2%TYPE,
    tsi_amt         GIPI_ITEM.tsi_amt%TYPE,
    prem_amt        GIPI_ITEM.prem_amt%TYPE,
    ann_tsi_amt     GIPI_ITEM.ann_tsi_amt%TYPE,
    ann_prem_amt    GIPI_ITEM.ann_prem_amt%TYPE,
    rec_flag        GIPI_ITEM.rec_flag%TYPE,    
    currency_cd     GIPI_ITEM.currency_cd%TYPE,
    currency_rt     GIPI_ITEM.currency_rt%TYPE,
    group_cd        GIPI_ITEM.group_cd%TYPE,
    from_date       GIPI_ITEM.from_date%TYPE,
    to_date         GIPI_ITEM.to_date%TYPE,
    pack_line_cd    GIPI_ITEM.pack_line_cd%TYPE,
    pack_subline_cd GIPI_ITEM.pack_subline_cd%TYPE,
    discount_sw     GIPI_ITEM.discount_sw%TYPE,
    coverage_cd     GIPI_ITEM.coverage_cd%TYPE,
    other_info      GIPI_ITEM.other_info%TYPE,
    surcharge_sw    GIPI_ITEM.surcharge_sw%TYPE,
    region_cd       GIPI_ITEM.region_cd%TYPE,
    changed_tag     GIPI_ITEM.changed_tag%TYPE,
    comp_sw         GIPI_ITEM.comp_sw%TYPE,
    short_rt_percent GIPI_ITEM.short_rt_percent%TYPE,
    pack_ben_cd     GIPI_ITEM.pack_ben_cd%TYPE,
    payt_terms      GIPI_ITEM.payt_terms%TYPE,
    risk_no         GIPI_ITEM.risk_no%TYPE,
    risk_item_no    GIPI_ITEM.risk_item_no%TYPE,
    prorate_flag    GIPI_ITEM.prorate_flag%TYPE,
    currency_desc   GIIS_CURRENCY.currency_desc%TYPE,
    grouped_item_no         GICL_ACCIDENT_DTL.grouped_item_no%TYPE,
    grouped_item_title      GICL_ACCIDENT_DTL.grouped_item_title%TYPE);
    
  TYPE gipi_item_tab IS TABLE OF gipi_item_type;
  FUNCTION get_gipi_item(p_policy_id    GIPI_POLBASIC.policy_id%TYPE,
                         p_line_cd      GIPI_POLBASIC.line_cd%TYPE,
                         p_subline_cd   GIPI_POLBASIC.subline_cd%TYPE,
                         p_iss_cd       GIPI_POLBASIC.iss_cd%TYPE,
                         p_issue_yy     GIPI_POLBASIC.issue_yy%TYPE,
                         p_pol_seq_no   GIPI_POLBASIC.pol_seq_no%TYPE,
                         p_renew_no     GIPI_POLBASIC.renew_no%TYPE) 
    RETURN gipi_item_tab PIPELINED;
  TYPE gipi_item_rep_type IS RECORD(   --Created By:  Alfred  03/10/2011
        policy_id                        GIPI_ITEM.POLICY_ID%TYPE,
        item_no                         GIPI_ITEM.ITEM_NO%TYPE,
        currency_rt                    GIPI_ITEM.CURRENCY_RT%TYPE,
        from_date                      GIPI_ITEM.FROM_DATE%TYPE,
        to_date                          GIPI_ITEM.TO_DATE%TYPE,
        tsi_amt                          GIPI_ITMPERIL.TSI_AMT%TYPE, 
        prem_amt                      GIPI_ITMPERIL.PREM_AMT%TYPE,
        peril_cd                         GIPI_ITMPERIL.PERIL_CD%TYPE,
        peril_sname                   GIIS_PERIL.PERIL_SNAME%TYPE,
        param_value_v               GIIS_PARAMETERS.PARAM_VALUE_V%TYPE,
        CF_PRINT_TSI                VARCHAR2(1)
   );
 TYPE gipi_item_rep_tab IS TABLE OF gipi_item_rep_type;
 FUNCTION get_gipi_item_rep(     --Created By:  Alfred  03/10/2011
        p_policy_id               GIPI_ITEM.POLICY_ID%TYPE,
        p_item_no                GIPI_ITEM.ITEM_NO%TYPE
        )
      RETURN gipi_item_rep_tab PIPELINED;
  FUNCTION get_gipi_item_rep2(     --Created By:  Alfred  03/10/2011
        p_policy_id               GIPI_ITEM.POLICY_ID%TYPE,
        p_item_no                GIPI_ITEM.ITEM_NO%TYPE
        )
      RETURN gipi_item_rep_tab PIPELINED;
  TYPE gipi_related_item_info_type IS RECORD (
    policy_id              GIPI_ITEM.policy_id%TYPE,     
    item_no                GIPI_ITEM.item_no%TYPE,
    item_grp               GIPI_ITEM.item_grp%TYPE,
    item_title             GIPI_ITEM.item_title%TYPE,
    item_desc              GIPI_ITEM.item_desc%TYPE,
    item_desc2             GIPI_ITEM.item_desc2%TYPE,
    currency_rt            GIPI_ITEM.currency_rt%TYPE,
    pack_line_cd           GIPI_ITEM.pack_line_cd%TYPE,
    pack_subline_cd        GIPI_ITEM.pack_subline_cd%TYPE,
    surcharge_sw           GIPI_ITEM.surcharge_sw%TYPE,
    discount_sw            GIPI_ITEM.discount_sw%TYPE,
    tsi_amt                GIPI_ITEM.tsi_amt%TYPE,
    prem_amt               GIPI_ITEM.prem_amt%TYPE,
    ann_tsi_amt            GIPI_ITEM.ann_tsi_amt%TYPE,
    ann_prem_amt           GIPI_ITEM.ann_prem_amt%TYPE,
    other_info             GIPI_ITEM.other_info%TYPE,
    pack_pol_flag          GIPI_POLBASIC.pack_pol_flag%TYPE,
    currency_desc          GIIS_CURRENCY.currency_desc%TYPE,
    coverage_desc          GIIS_COVERAGE.coverage_desc%TYPE,
    peril_view_type        VARCHAR2(15),
    item_type              VARCHAR2(10)
  );
  TYPE gipi_related_item_info_tab IS TABLE OF gipi_related_item_info_type;
  FUNCTION get_related_item_info(p_policy_id  GIPI_POLBASIC.policy_id%TYPE)
    RETURN gipi_related_item_info_tab PIPELINED;
    
  TYPE pack_policy_items_type IS RECORD(
    policy_id              GIPI_ITEM.policy_id%TYPE,
    item_no                GIPI_ITEM.item_no%TYPE,
    item_title             GIPI_ITEM.item_title%TYPE,
    item_desc              GIPI_ITEM.item_desc%TYPE,
    item_desc2             GIPI_ITEM.item_desc2%TYPE,
    currency_cd            GIPI_ITEM.currency_cd%TYPE,
    currency_rt            GIPI_ITEM.currency_rt%TYPE,
    pack_line_cd           GIPI_ITEM.pack_line_cd%TYPE,
    pack_subline_cd        GIPI_ITEM.pack_subline_cd%TYPE
  );
  
  TYPE pack_policy_items_tab IS TABLE OF pack_policy_items_type;
  
  FUNCTION get_pack_policy_items(p_line_cd     IN   GIPI_PACK_WPOLBAS.line_cd%TYPE,
                                 p_iss_cd      IN   GIPI_PACK_WPOLBAS.iss_cd%TYPE,
                                 p_subline_cd  IN   GIPI_PACK_WPOLBAS.subline_cd%TYPE,
                                 p_issue_yy    IN   GIPI_PACK_WPOLBAS.issue_yy%TYPE,
                                 p_pol_seq_no  IN   GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
                                 p_renew_no    IN   GIPI_PACK_WPOLBAS.renew_no%TYPE,
                                 p_eff_date    IN   GIPI_PACK_WPOLBAS.eff_date%TYPE,
                                 p_expiry_date IN   GIPI_PACK_WPOLBAS.expiry_date%TYPE) 
 RETURN pack_policy_items_tab PIPELINED; 
 
 /**
 * Rey Jadlocon
 * 08.02.2011
 * item group list Bipp Group
 **/
 
 TYPE item_group_list_type IS RECORD(
      policy_id         gipi_item.policy_id%TYPE,
      item_grp          GIPI_ITEM.ITEM_GRP%TYPE,
      tsi_amt           GIPI_ITEM.TSI_AMT%TYPE,
      ann_prem_amt      GIPI_ITEM.ANN_PREM_AMT%TYPE,
      ann_tsi_amt       GIPI_ITEM.ANN_TSI_AMT%TYPE,
      currency_rt       GIPI_ITEM.CURRENCY_RT%TYPE,
      currency_desc     GIIS_CURRENCY.CURRENCY_DESC%TYPE
      );
      
      TYPE item_group_list_tab IS TABLE OF item_group_list_type;
      
FUNCTION get_item_group_list(p_policy_id  GIPI_POLBASIC.policy_id%TYPE)
  RETURN item_group_list_tab PIPELINED;
         
    FUNCTION check_existing_item(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE) 
    RETURN NUMBER;  
  
    FUNCTION get_item_no_list(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE
        )
    RETURN gipi_item_tab PIPELINED;
    
     FUNCTION get_item_no_list_MC(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_claim_id              gicl_claims.claim_id%type,
      p_find_text      varchar2
        )
    RETURN gipi_item_tab PIPELINED;
    
    FUNCTION get_item_no_list_en (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_claim_id       gicl_claims.claim_id%TYPE,
      p_find_text      varchar2
      )
   RETURN gipi_item_tab PIPELINED;
   
   FUNCTION get_item_no_list_MN(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_claim_id              gicl_claims.claim_id%type,
      p_find_text      varchar2
        )
    RETURN gipi_item_tab PIPELINED;
      
    FUNCTION get_item_no_list_AV(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_claim_id              gicl_claims.claim_id%type,
        p_iss_cd            gipi_polbasic.iss_cd%type,
		p_find_text varchar2 
        )
    RETURN gipi_item_tab PIPELINED;
    
    FUNCTION get_item_from_policy(
                         p_policy_id    GIPI_POLBASIC.policy_id%TYPE,
                         p_line_cd      GIPI_POLBASIC.line_cd%TYPE,
                         p_subline_cd   GIPI_POLBASIC.subline_cd%TYPE,
                         p_iss_cd       GIPI_POLBASIC.iss_cd%TYPE,
                         p_issue_yy     GIPI_POLBASIC.issue_yy%TYPE,
                         p_pol_seq_no   GIPI_POLBASIC.pol_seq_no%TYPE,
                         p_renew_no     GIPI_POLBASIC.renew_no%TYPE,
                         p_eff_date     GIPI_POLBASIC.eff_date%TYPE) 
    RETURN gipi_item_tab PIPELINED;
    
    
    FUNCTION get_item_no_list_PA ( 
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_claim_id       gicl_claims.claim_id%TYPE)
      
      RETURN gipi_item_tab PIPELINED;
      
    FUNCTION get_grpitem_no_list_PA ( 
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_claim_id       gicl_claims.claim_id%TYPE,
      p_item_no        gipi_item.item_no%TYPE)
      
      RETURN gipi_item_tab PIPELINED;  
      
   TYPE item_type IS RECORD (
        item_no         gipi_item.item_no%TYPE,
        item_title      gipi_item.item_title%TYPE
   );   
   
   TYPE item_tab IS TABLE OF item_type;
   
   FUNCTION get_nonmotcar_item_gicls026( 
        p_line_cd          GIPI_POLBASIC.line_cd%TYPE,  
        p_subline_cd       GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd           GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy         GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no       GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no         GIPI_POLBASIC.renew_no%TYPE
   )
   RETURN item_tab PIPELINED;
   
   FUNCTION get_item_no_giexs007(p_policy_id          gipi_item.policy_id%TYPE)
    RETURN item_tab PIPELINED;
	
	FUNCTION get_item_title (
       p_item_no        gipi_item.item_no%TYPE,
       p_line_cd        gipi_polbasic.line_cd%TYPE,
       p_subline_cd     gipi_polbasic.subline_cd%TYPE,
       p_iss_cd         gipi_polbasic.iss_cd%TYPE,
       p_issue_yy       gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no       gipi_polbasic.renew_no%TYPE
    )
    RETURN VARCHAR2;
    
    TYPE giuts027_item_type IS RECORD (
        policy_id              GIPI_ITEM.policy_id%TYPE,     
        item_no                GIPI_ITEM.item_no%TYPE,
        item_title             GIPI_ITEM.item_title%TYPE,
        coverage_cd            GIPI_ITEM.coverage_cd%TYPE,
        coverage_desc          GIIS_COVERAGE.coverage_desc%TYPE
    );
    
    TYPE giuts027_item_tab IS TABLE OF giuts027_item_type;
    
    FUNCTION get_item_giuts027(
        p_policy_id     gipi_item.policy_id%TYPE
    ) RETURN giuts027_item_tab PIPELINED;
    
    PROCEDURE update_item_coverage(
        p_policy_id     gipi_item.policy_id%TYPE,
        p_item_no       gipi_item.item_no%TYPE,
        p_coverage_cd   gipi_item.coverage_cd%TYPE
    );
    
   FUNCTION get_endt_item_list(
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_eff_date       gipi_polbasic.eff_date%TYPE
   )
     RETURN item_tab PIPELINED;
    
   TYPE gipi_item_ann_tsi_prem_rec IS RECORD (
      item_no       gipi_item.item_no%TYPE,
      ann_tsi_amt   gipi_item.ann_tsi_amt%TYPE,
      ann_prem_amt  gipi_item.ann_prem_amt%TYPE
   );

   TYPE gipi_item_ann_tsi_prem_tab IS TABLE OF gipi_item_ann_tsi_prem_rec;
   
   FUNCTION get_item_ann_tsi_prem(p_par_id          gipi_witem.par_id%TYPE)
    RETURN gipi_item_ann_tsi_prem_tab PIPELINED;
   
    
END GIPI_ITEM_PKG;
/



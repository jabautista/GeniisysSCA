CREATE OR REPLACE PACKAGE CPI.gicl_accident_dtl_pkg
AS
    TYPE gicl_accident_dtl_type IS RECORD(
        claim_id                GICL_CLAIMS.claim_id%TYPE,
        item_no                 GICL_ACCIDENT_DTL.ITEM_NO%TYPE,
        item_title              GICL_ACCIDENT_DTL.ITEM_TITLE%TYPE,
        grouped_item_no         GICL_ACCIDENT_DTL.GROUPED_ITEM_NO%TYPE,
        grouped_item_title      GICL_ACCIDENT_DTL.GROUPED_ITEM_TITLE%TYPE,
        currency_cd             GICL_ACCIDENT_DTL.CURRENCY_CD%TYPE,
        dsp_currency            VARCHAR2(100),
        currency_rate           GICL_ACCIDENT_DTL.CURRENCY_RATE%TYPE,
        position_cd             GICL_ACCIDENT_DTL.POSITION_CD%TYPE,
        dsp_position            VARCHAR2(200),
        monthly_salary          GICL_ACCIDENT_DTL.MONTHLY_SALARY%TYPE,
        dsp_control_type        VARCHAR2(100),
        control_cd              GICL_ACCIDENT_DTL.CONTROL_CD%TYPE,
        control_type_cd         GICL_ACCIDENT_DTL.CONTROL_TYPE_CD%TYPE,
        item_desc               GICL_CLM_ITEM.ITEM_DESC%TYPE,
        item_desc2              GICL_CLM_ITEM.ITEM_DESC2%TYPE,
        level_cd                GICL_ACCIDENT_DTL.LEVEL_CD%TYPE,
        salary_grade            GICL_ACCIDENT_DTL.SALARY_GRADE%TYPE,
        date_of_birth           VARCHAR2(20),
        civil_status            GICL_ACCIDENT_DTL.CIVIL_STATUS%TYPE,
        dsp_civil_stat          CG_REF_CODES.rv_meaning%TYPE, -- marco - 01.24.2013 - changed from VARCHAR(10)
        sex                     GICL_ACCIDENT_DTL.SEX%TYPE,
        dsp_sex                 VARCHAR2(10),
        age                     GICL_ACCIDENT_DTL.AGE%TYPE,
        amount_coverage         GICL_ACCIDENT_DTL.AMOUNT_COVERAGE%TYPE,
        gicl_item_peril_exist   VARCHAR2 (1),
        gicl_mortgagee_exist    VARCHAR2 (1),
        gicl_item_peril_msg     VARCHAR2 (1)
        );
    TYPE gicl_accident_dtl_tab IS TABLE OF gicl_accident_dtl_type;
    
    TYPE gicl_accident_dtl_cur IS REF CURSOR
      RETURN gicl_accident_dtl_type;
      
    TYPE beneficiary_dtl_type IS RECORD(
        claim_id            GICL_ACCIDENT_DTL.claim_id%TYPE,
        item_no             GICL_ACCIDENT_DTL.item_no%TYPE,
        grouped_item_no     GICL_ACCIDENT_DTL.grouped_item_no%TYPE,
        beneficiary_no      gipi_beneficiary.beneficiary_no%TYPE,
        beneficiary_name    gipi_beneficiary.beneficiary_name%TYPE,
        beneficiary_addr    gipi_beneficiary.beneficiary_addr%TYPE,
        position_cd         gipi_beneficiary.position_cd%TYPE,
        position            giis_position.position%TYPE,
        date_of_birth       VARCHAR2(20),
        age                 gipi_beneficiary.age%TYPE,
        civil_status        gipi_beneficiary.civil_status%TYPE,
        sex                 gipi_beneficiary.sex%TYPE,
        relation            gipi_beneficiary.relation%TYPE,
        dsp_civil_stat        VARCHAR2(50),
        dsp_ben_position      VARCHAR2(50), 
        dsp_sex               VARCHAR2(50)
    );
    
    TYPE beneficiary_dtl_tab IS TABLE OF beneficiary_dtl_type;
    
    TYPE beneficiary_dtl_cur IS REF CURSOR
        RETURN beneficiary_dtl_type;   
    
    TYPE availments_dtl_type IS RECORD(
        claim_id            gicl_claims.claim_id%TYPE,
        item_no             gipi_grouped_items.item_no%TYPE,
        grouped_item_no     gipi_grouped_items.grouped_item_no%TYPE,
        peril_cd            gipi_itmperil_grouped.peril_cd%TYPE,
        aggregate_sw        gipi_itmperil_grouped.aggregate_sw%TYPE,     
        base_amt            gipi_itmperil_grouped.base_amt%TYPE,
        no_of_days          gipi_itmperil_grouped.no_of_days%TYPE,
        ann_tsi_amt         gipi_itmperil_grouped.ann_tsi_amt%TYPE,
        dsp_allow           VARCHAR2(100),
        dsp_peril_name      VARCHAR2(100),
        
        dsp_claim_no        VARCHAR2(50),
        dsp_loss_date       VARCHAR2(50),
        dsp_claim_stat      VARCHAR2(50),
        loss_reserve        gicl_clm_reserve.loss_reserve%TYPE,
        paid_amt            gicl_clm_loss_exp.paid_amt%TYPE,
        dsp_no_of_days      gicl_loss_exp_dtl.no_of_units%TYPE
    );
    
    TYPE availments_dtl_tab IS TABLE OF availments_dtl_type;
    
FUNCTION get_accident_dtl_item(p_claim_id       GICL_CLAIMS.CLAIM_ID%TYPE)
    RETURN gicl_accident_dtl_tab PIPELINED;

FUNCTION check_accident_item_no (
    p_claim_id    gicl_accident_dtl.claim_id%TYPE,
    p_item_no     gicl_accident_dtl.item_no%TYPE,
    p_start_row   VARCHAR2,
    p_end_row     VARCHAR2)
      
    RETURN VARCHAR2;    
        
FUNCTION extract_beneficiary_info_ngrp(
    p_beneficiary_no          gipi_beneficiary.beneficiary_no%TYPE,
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE
  ) 
    RETURN beneficiary_dtl_tab PIPELINED;
    
FUNCTION extract_beneficiary_info_grp(
    p_beneficiary_no          gipi_beneficiary.beneficiary_no%TYPE,
    p_grouped_item_no         gicl_beneficiary_dtl.grouped_item_no%TYPE, 
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE
  ) 
    RETURN beneficiary_dtl_tab PIPELINED;
PROCEDURE get_latest_beneficiary_ngrp (
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    v_beneficiary_no    OUT   gipi_beneficiary.beneficiary_no%TYPE,
    v_ben_cnt           OUT   NUMBER
   );

PROCEDURE get_latest_beneficiary_grp( 
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_grouped_item_no         gicl_beneficiary_dtl.grouped_item_no%TYPE,
    v_beneficiary_no    OUT   gipi_beneficiary.beneficiary_no%TYPE,
    v_ben_cnt           OUT   NUMBER
    );   
        
FUNCTION EXTRACT_LATEST_AHDATA_1GRP(
    p_grp_cnt        gipi_grouped_items.grouped_item_no%TYPE,
    p_line_cd        gipi_polbasic.line_cd%TYPE,
    p_subline_cd     gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
    p_issue_yy       gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no       gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
    p_expiry_date    gipi_polbasic.expiry_date%TYPE,
    p_loss_date      gipi_polbasic.expiry_date%TYPE,
    p_item_no        gipi_item.item_no%TYPE,
    p_iss_cd         gipi_polbasic.iss_cd%TYPE
    ) 
    RETURN gicl_accident_dtl_tab PIPELINED;

FUNCTION cnt_beneficiary (
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_grouped_item_no         GICL_ACCIDENT_DTL.GROUPED_ITEM_NO%TYPE
    )
    RETURN VARCHAR2;
    
PROCEDURE check_del_sw(
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_grouped_item_no         gicl_accident_dtl.GROUPED_ITEM_NO%TYPE,
    p_iss_cd                  gipi_polbasic.iss_cd%TYPE,  
    c017                OUT   gicl_accident_dtl_cur,
    c017b               OUT   beneficiary_dtl_cur
    );  
    
PROCEDURE check_grp_item_no (
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_grouped_item_no         gicl_accident_dtl.grouped_item_no%TYPE,
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_exist             OUT   VARCHAR2,
    p_valid             OUT   VARCHAR2
    );    
    
PROCEDURE validate_gicl_accident_item_no (
      p_line_cd                 gipi_polbasic.line_cd%TYPE,
      p_subline_cd              gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_issue_yy                gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no                gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
      p_expiry_date             gipi_polbasic.expiry_date%TYPE,
      p_loss_date               gipi_polbasic.expiry_date%TYPE,
      p_item_no                 gipi_item.item_no%TYPE,
      p_grouped_item_no         gicl_accident_dtl.grouped_item_no%TYPE,
      p_claim_id                gicl_accident_dtl.claim_id%TYPE,
      p_iss_cd                  gipi_polbasic.iss_cd%TYPE,
      p_from                    VARCHAR2,
      p_to                      VARCHAR2,
      c017             OUT      gicl_accident_dtl_cur,
      c017b            OUT      beneficiary_dtl_cur,
      p_item_exist     OUT      NUMBER,
      p_override_fl    OUT      VARCHAR2,
      p_tloss_fl       OUT      VARCHAR2,
      p_item_exist2    OUT      VARCHAR2,
      p_exist          OUT      VARCHAR2,  
      p_valid          OUT      VARCHAR2,
      v_ben_cnt        OUT      NUMBER
);
 
PROCEDURE set_gicl_accident_dtl (
    p_claim_id         gicl_aviation_dtl.claim_id%TYPE,
    p_item_no          gicl_accident_dtl.item_no%TYPE,
    p_item_title       gicl_accident_dtl.item_title%TYPE,
    p_currency_cd      gicl_accident_dtl.currency_cd%TYPE,
    p_currency_rate    gicl_accident_dtl.currency_rate%TYPE,
    p_loss_date        gicl_accident_dtl.loss_date%TYPE, 
    p_date_of_birth    gicl_accident_dtl.date_of_birth%TYPE, 
    p_age              gicl_accident_dtl.age%TYPE, 
    p_civil_status     gicl_accident_dtl.civil_status%TYPE, 
    p_position_cd      gicl_accident_dtl.position_cd%TYPE, 
    p_monthly_salary   gicl_accident_dtl.monthly_salary%TYPE, 
    p_salary_grade     gicl_accident_dtl.salary_grade%TYPE, 
    p_sex              gicl_accident_dtl.sex%TYPE, 
    p_grouped_item_no  gicl_accident_dtl.grouped_item_no%TYPE, 
    p_grouped_item_title  gicl_accident_dtl.grouped_item_title%TYPE, 
    p_amount_coverage  gicl_accident_dtl.amount_coverage%TYPE, 
    p_line_cd          gicl_accident_dtl.line_cd%TYPE, 
    p_subline_cd       gicl_accident_dtl.subline_cd%TYPE,
    p_control_cd       gicl_accident_dtl.control_cd%TYPE,
    p_control_type_cd  gicl_accident_dtl.control_type_cd%TYPE 
   );
   
PROCEDURE del_gicl_accident_dtl (
    p_claim_id          gicl_accident_dtl.claim_id%TYPE,
    p_item_no           gicl_accident_dtl.item_no%TYPE,
    p_grouped_item_no   gicl_accident_dtl.grouped_item_no%TYPE
   );       
   
FUNCTION get_claim_ben_no(
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_grouped_item_no         gicl_accident_dtl.grouped_item_no%TYPE,
    p_find_text               VARCHAR2   
  ) 
    RETURN beneficiary_dtl_tab PIPELINED;
    
FUNCTION get_beneficiary_info(
    p_claim_id              gicl_beneficiary_dtl.claim_id%TYPE,
    p_item_no               gicl_beneficiary_dtl.item_no%TYPE,
    p_grouped_item_no       gicl_beneficiary_dtl.grouped_item_no%TYPE
  )
    RETURN beneficiary_dtl_tab PIPELINED;    
PROCEDURE set_gicl_beneficiary_dtl (
    p_claim_id              gicl_beneficiary_dtl.claim_id%TYPE,
    p_item_no                 gicl_beneficiary_dtl.item_no%TYPE,
    p_grouped_item_no         gicl_beneficiary_dtl.grouped_item_no%TYPE,
    p_beneficiary_no          gicl_beneficiary_dtl.beneficiary_no%TYPE,
    p_beneficiary_name        gicl_beneficiary_dtl.beneficiary_name%TYPE,
    p_beneficiary_addr        gicl_beneficiary_dtl.beneficiary_addr%TYPE,     
    p_relation                gicl_beneficiary_dtl.relation%TYPE,
    p_date_of_birth           VARCHAR2, --gicl_beneficiary_dtl.date_of_birth%TYPE,
    p_age                     gicl_beneficiary_dtl.age%TYPE,
    p_civil_status            gicl_beneficiary_dtl.civil_status%TYPE,
    p_position_cd             gicl_beneficiary_dtl.position_cd%TYPE,
    p_sex                     gicl_beneficiary_dtl.sex%TYPE   
   );
   
PROCEDURE del_gicl_beneficiary_dtl (
    p_claim_id          gicl_accident_dtl.claim_id%TYPE,
    p_item_no           gicl_accident_dtl.item_no%TYPE,
    p_grouped_item_no   gicl_accident_dtl.grouped_item_no%TYPE,
    p_beneficiary_no    gicl_beneficiary_dtl.beneficiary_no%TYPE
   );    

PROCEDURE del_gicl_item_beneficiary (
    p_claim_id          gicl_accident_dtl.claim_id%TYPE,
    p_item_no           gicl_accident_dtl.item_no%TYPE,
    p_grouped_item_no   gicl_accident_dtl.grouped_item_no%TYPE
    );  

   
FUNCTION get_avail_perils(
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_grouped_item_no         gicl_accident_dtl.grouped_item_no%TYPE
  )         
     RETURN availments_dtl_tab PIPELINED; 
     
FUNCTION get_avail_claim_list(
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_grouped_item_no         gicl_accident_dtl.grouped_item_no%TYPE,
    p_no_of_days              gipi_itmperil_grouped.no_of_days%TYPE 
  )   
    RETURN availments_dtl_tab PIPELINED;
    
   TYPE gicl_accident_gicls260_type IS RECORD( -- bonok :: 05.16.2013 :: for GICLS260
      claim_id                gicl_claims.claim_id%TYPE,
      item_no                 gicl_accident_dtl.item_no%TYPE,
      item_title              gicl_accident_dtl.item_title%TYPE,
      grouped_item_no         gicl_accident_dtl.grouped_item_no%TYPE,
      grouped_item_title      gicl_accident_dtl.grouped_item_title%TYPE,
      currency_cd             gicl_accident_dtl.currency_cd%TYPE,
      dsp_currency            VARCHAR2(100),
      currency_rate           gicl_accident_dtl.currency_rate%TYPE,
      position_cd             gicl_accident_dtl.position_cd%TYPE,
      dsp_position            VARCHAR2(200),
      monthly_salary          gicl_accident_dtl.monthly_salary%TYPE,
      dsp_control_type        VARCHAR2(100),
      control_cd              gicl_accident_dtl.control_cd%TYPE,
      control_type_cd         gicl_accident_dtl.control_type_cd%TYPE,
      item_desc               gicl_clm_item.item_desc%TYPE,
      item_desc2              gicl_clm_item.item_desc2%TYPE,
      level_cd                gicl_accident_dtl.level_cd%TYPE,
      salary_grade            gicl_accident_dtl.salary_grade%TYPE,
      date_of_birth           VARCHAR2(20),
      civil_status            gicl_accident_dtl.civil_status%TYPE,
      dsp_civil_stat          cg_ref_codes.rv_meaning%TYPE,
      sex                     gicl_accident_dtl.sex%TYPE,
      dsp_sex                 VARCHAR2(10),
      age                     gicl_accident_dtl.age%TYPE,
      amount_coverage         gicl_accident_dtl.amount_coverage%TYPE,
      loss_date               VARCHAR2(30), --gicl_accident_dtl.loss_date%TYPE, : shan 04.15.2014
      gicl_item_peril_exist   VARCHAR2 (1),
      gicl_mortgagee_exist    VARCHAR2 (1),
      gicl_item_peril_msg     VARCHAR2 (1),
      beneficiary_no          gicl_beneficiary_dtl.beneficiary_no%TYPE,
      beneficiary_name        gicl_beneficiary_dtl.beneficiary_name%TYPE,
      beneficiary_addr        gicl_beneficiary_dtl.beneficiary_addr%TYPE,
      ben_position_cd         gicl_beneficiary_dtl.position_cd%TYPE,
      ben_sex                 gicl_beneficiary_dtl.sex%TYPE,
      ben_relation            gicl_beneficiary_dtl.relation%TYPE,
      ben_date_of_birth       gicl_beneficiary_dtl.date_of_birth%TYPE,
      ben_age                 gicl_beneficiary_dtl.age%TYPE,
      ben_position            giis_position.position%TYPE,
      ben_civil_status        cg_ref_codes.rv_meaning%TYPE
   );
   
   TYPE gicl_accident_gicls260_tab IS TABLE OF gicl_accident_gicls260_type;
    
   FUNCTION get_accident_dtl_gicls260( -- bonok :: 05.16.2013 :: for GICLS260
      p_claim_id            gicl_claims.claim_id%TYPE
   ) RETURN gicl_accident_gicls260_tab PIPELINED; 
   
    --kenneth SR4855 100715
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
  
    --kenneth SR4855 100715  
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
    
    --kenneth SR4855 100715
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
END;
/



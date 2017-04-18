CREATE OR REPLACE PACKAGE CPI.GIPI_WPOLBAS_PKG AS

  TYPE gipi_wpolbas_type IS RECORD
    (par_id                       GIPI_WPOLBAS.par_id%TYPE,      
     label_tag                  GIPI_WPOLBAS.label_tag%TYPE,
     assd_no                   GIPI_WPOLBAS.assd_no%TYPE, 
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     in_account_of              GIIS_ASSURED.assd_name%TYPE, 
     subline_cd                   GIPI_WPOLBAS.subline_cd%TYPE,
     surcharge_sw               GIPI_WPOLBAS.surcharge_sw%TYPE,
     manual_renew_no           VARCHAR(25),--GIPI_WPOLBAS.manual_renew_no%TYPE,
     discount_sw               GIPI_WPOLBAS.discount_sw%TYPE,
     pol_flag                   GIPI_WPOLBAS.pol_flag%TYPE, 
     pol_flag_desc              CG_REF_CODES.rv_meaning%TYPE,
     type_cd                  GIPI_WPOLBAS.type_cd%TYPE,
     type_desc                  GIIS_POLICY_TYPE.type_desc%TYPE,
     address1                   GIPI_WPOLBAS.address1%TYPE, 
     address2                   GIPI_WPOLBAS.address2%TYPE,
     address3                   GIPI_WPOLBAS.address3%TYPE,
     booking_year               GIPI_WPOLBAS.booking_year%TYPE,
     booking_mth               GIPI_WPOLBAS.booking_mth%TYPE,
     takeup_term               GIPI_WPOLBAS.takeup_term%TYPE, 
     takeup_term_desc          GIIS_TAKEUP_TERM.takeup_term_desc%TYPE,
     incept_date                  GIPI_WPOLBAS.incept_date%TYPE,
     expiry_date                  GIPI_WPOLBAS.expiry_date%TYPE,
     issue_date                      GIPI_WPOLBAS.issue_date%TYPE, 
      place_cd                   GIPI_WPOLBAS.place_cd%TYPE,     
     incept_tag                   GIPI_WPOLBAS.incept_tag%TYPE,
     expiry_tag                   GIPI_WPOLBAS.expiry_tag%TYPE,
     risk_tag                      GIPI_WPOLBAS.risk_tag%TYPE,
     risk                      CG_REF_CODES.rv_meaning%TYPE,
     ref_pol_no                      GIPI_WPOLBAS.ref_pol_no%TYPE,
     industry_cd               GIPI_WPOLBAS.industry_cd%TYPE, 
     industry_nm               GIIS_INDUSTRY.industry_nm%TYPE,     
     region_cd                    GIPI_WPOLBAS.region_cd%TYPE, 
     region_desc                GIIS_REGION.region_cd%TYPE,
     cred_branch               GIPI_WPOLBAS.cred_branch%TYPE, 
     iss_name                     GIIS_ISSOURCE.iss_name%TYPE,
     iss_cd                      GIPI_WPOLBAS.iss_cd%TYPE,  
     quotation_printed_sw      GIPI_WPOLBAS.quotation_printed_sw%TYPE,
     covernote_printed_sw      GIPI_WPOLBAS.covernote_printed_sw%TYPE,
     pack_pol_flag                 GIPI_WPOLBAS.pack_pol_flag%TYPE,
     auto_renew_flag          GIPI_WPOLBAS.auto_renew_flag%TYPE,
     foreign_acc_sw               GIPI_WPOLBAS.foreign_acc_sw%TYPE,
     reg_policy_sw               GIPI_WPOLBAS.reg_policy_sw%TYPE,                                  
     prem_warr_tag                GIPI_WPOLBAS.prem_warr_tag%TYPE,
     prem_warr_days                GIPI_WPOLBAS.prem_warr_days%TYPE,
     fleet_print_tag            GIPI_WPOLBAS.fleet_print_tag%TYPE,
     with_tariff_sw                GIPI_WPOLBAS.with_tariff_sw%TYPE,
     co_insurance_sw          GIPI_WPOLBAS.co_insurance_sw%TYPE,
     prorate_flag               GIPI_WPOLBAS.prorate_flag%TYPE,
     comp_sw                   GIPI_WPOLBAS.comp_sw%TYPE,
     short_rt_percent            GIPI_WPOLBAS.short_rt_percent%TYPE,     
     prov_prem_tag                 GIPI_WPOLBAS.prov_prem_tag%TYPE,                                        
     prov_prem_pct                GIPI_WPOLBAS.prov_prem_pct%TYPE,
     survey_agent_cd             GIPI_WPOLBAS.survey_agent_cd%TYPE,    
     survey_agent_name             VARCHAR2(100),                                         
     settling_agent_cd        GIPI_WPOLBAS.settling_agent_cd%TYPE,
     settling_agent_name       VARCHAR2(100),
     designation              GIPI_WPOLBAS.designation%TYPE, 
     acct_of_cd                  GIPI_WPOLBAS.acct_of_cd%TYPE,
     invoice_sw                   GIPI_WPOLBAS.invoice_sw%TYPE,
     line_cd                  GIPI_WPOLBAS.line_cd%TYPE,
     same_polno_sw              GIPI_WPOLBAS.same_polno_sw%TYPE,
     endt_expiry_date          GIPI_WPOLBAS.endt_expiry_date%TYPE,
     eff_date                  GIPI_WPOLBAS.eff_date%TYPE,
     issue_yy                  GIPI_WPOLBAS.issue_yy%TYPE,
     mortg_name                  GIPI_WPOLBAS.mortg_name%TYPE,
     validate_tag              GIPI_WPOLBAS.validate_tag%TYPE,
     pol_seq_no                  GIPI_WPOLBAS.pol_seq_no%TYPE,
     cancel_type              GIPI_WPOLBAS.cancel_type%TYPE,
     endt_expiry_tag          GIPI_WPOLBAS.endt_expiry_tag%TYPE,
     endt_iss_cd              GIPI_WPOLBAS.endt_iss_cd%TYPE,
     acct_of_cd_sw              GIPI_WPOLBAS.acct_of_cd_sw%TYPE,
     old_assd_no              GIPI_WPOLBAS.old_assd_no%TYPE,
     old_address1              GIPI_WPOLBAS.old_address1%TYPE,
     old_address2              GIPI_WPOLBAS.old_address2%TYPE,
     old_address3              GIPI_WPOLBAS.old_address3%TYPE,
     ann_tsi_amt              GIPI_WPOLBAS.ann_tsi_amt%TYPE,
     prem_amt                  GIPI_WPOLBAS.prem_amt%TYPE,
     tsi_amt                  GIPI_WPOLBAS.tsi_amt%TYPE,
     ann_prem_amt              GIPI_WPOLBAS.ann_prem_amt%TYPE,
     msg_alert                  VARCHAR2(32767),
     renew_no                  GIPI_WPOLBAS.renew_no%TYPE,
     ref_open_pol_no          GIPI_WPOLBAS.ref_open_pol_no%TYPE,
     endt_yy                  GIPI_WPOLBAS.endt_yy%TYPE,
     endt_seq_no              GIPI_WPOLBAS.endt_seq_no%TYPE,
     back_stat                  GIPI_WPOLBAS.back_stat%TYPE,
     plan_sw                  GIPI_WPOLBAS.plan_sw%TYPE,
     plan_cd                  GIPI_WPOLBAS.Plan_cd%TYPE,
     plan_ch_tag              GIPI_WPOLBAS.plan_ch_tag%TYPE,
     company_cd               GIPI_WPOLBAS.company_cd%TYPE,
     employee_cd              GIPI_WPOLBAS.employee_cd%TYPE,
     bank_ref_no              GIPI_WPOLBAS.bank_ref_no%TYPE,
     banc_type_cd             GIPI_WPOLBAS.banc_type_cd%TYPE,
     bancassurance_sw         GIPI_WPOLBAS.bancassurance_sw%TYPE,
     area_cd                  GIPI_WPOLBAS.area_cd%TYPE,
     branch_cd                GIPI_WPOLBAS.branch_cd%TYPE,
     manager_cd               GIPI_WPOLBAS.manager_cd%TYPE,
     bond_seq_no              GIPI_WPOLBAS.bond_seq_no%TYPE
     );
     
  TYPE gipi_wpolbas_common_type IS RECORD
    (par_id             GIPI_WPOLBAS.par_id%TYPE,
     subline_cd         GIPI_WPOLBAS.subline_cd%TYPE,
     line_cd             GIPI_WPOLBAS.line_cd%TYPE,
     line_name            GIIS_LINE.line_name%TYPE,
     iss_cd             GIPI_WPOLBAS.iss_cd%TYPE,
     assd_no            GIPI_WPOLBAS.assd_no%TYPE,
     assd_name            GIIS_ASSURED.assd_name%TYPE,
     pack_par_id        GIPI_WPOLBAS.pack_par_id%TYPE,
     pol_flag            GIPI_WPOLBAS.pol_flag%TYPE,
     issue_yy            GIPI_WPOLBAS.issue_yy%TYPE,
     pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
     renew_no            GIPI_WPOLBAS.renew_no%TYPE);
     
  TYPE gipi_wpolbas_tab IS TABLE OF gipi_wpolbas_type;
  
  TYPE gipi_wpolbas_common_tab IS TABLE OF gipi_wpolbas_common_type;
  
  FUNCTION get_gipi_wpolbas_common (p_par_id    GIPI_WPOLBAS.PAR_ID%TYPE)
    RETURN gipi_wpolbas_common_tab PIPELINED;
  
  FUNCTION get_gipi_wpolbas (p_par_id     GIPI_WPOLBAS.par_id%TYPE)
    RETURN gipi_wpolbas_tab PIPELINED;
    
  FUNCTION get_gipi_wpolbas_default_value (p_par_id     GIPI_WPOLBAS.par_id%TYPE)
    RETURN gipi_wpolbas_tab PIPELINED;
    
  FUNCTION get_gipi_wpolbas1 (p_par_id     GIPI_WPOLBAS.par_id%TYPE)
    RETURN gipi_wpolbas_tab PIPELINED;
    
  Procedure get_gipi_wpolbas_exist (p_par_id  IN GIPI_WPOLBAS.par_id%TYPE,
                                      p_exist   OUT NUMBER);
  
  Procedure set_gipi_wpolbas ( 
       v_par_id                  IN  GIPI_WPOLBAS.par_id%TYPE,    
     v_label_tag              IN  GIPI_WPOLBAS.label_tag%TYPE,
     v_assd_no                   IN  GIPI_WPOLBAS.assd_no%TYPE,
     v_subline_cd              IN  GIPI_WPOLBAS.subline_cd%TYPE,
     v_surcharge_sw               IN  GIPI_WPOLBAS.surcharge_sw%TYPE,
     v_manual_renew_no           IN  GIPI_WPOLBAS.manual_renew_no%TYPE,
     v_discount_sw               IN  GIPI_WPOLBAS.discount_sw%TYPE,
     v_pol_flag                   IN  GIPI_WPOLBAS.pol_flag%TYPE,
     v_type_cd                  IN  GIPI_WPOLBAS.type_cd%TYPE,
     v_address1                   IN  GIPI_WPOLBAS.address1%TYPE,
     v_address2                   IN  GIPI_WPOLBAS.address2%TYPE,
     v_address3                   IN  GIPI_WPOLBAS.address3%TYPE,
     v_booking_year               IN  GIPI_WPOLBAS.booking_year%TYPE,
     v_booking_mth               IN  GIPI_WPOLBAS.booking_mth%TYPE,
     v_takeup_term               IN  GIPI_WPOLBAS.takeup_term%TYPE,
     v_incept_date            IN  GIPI_WPOLBAS.incept_date%TYPE,
     v_expiry_date            IN  GIPI_WPOLBAS.expiry_date%TYPE,
     v_issue_date                IN  GIPI_WPOLBAS.issue_date%TYPE,
      v_place_cd                   IN  GIPI_WPOLBAS.place_cd%TYPE,     
     v_incept_tag              IN  GIPI_WPOLBAS.incept_tag%TYPE,
     v_expiry_tag              IN  GIPI_WPOLBAS.expiry_tag%TYPE,
     v_risk_tag                      IN  GIPI_WPOLBAS.risk_tag%TYPE,
     v_ref_pol_no                IN  GIPI_WPOLBAS.ref_pol_no%TYPE,
     v_industry_cd               IN  GIPI_WPOLBAS.industry_cd%TYPE,
     v_region_cd               IN  GIPI_WPOLBAS.region_cd%TYPE,
     v_cred_branch               IN  GIPI_WPOLBAS.cred_branch%TYPE,
     v_quotation_printed_sw      IN  GIPI_WPOLBAS.quotation_printed_sw%TYPE,
     v_covernote_printed_sw      IN  GIPI_WPOLBAS.covernote_printed_sw%TYPE,
     v_pack_pol_flag           IN  GIPI_WPOLBAS.pack_pol_flag%TYPE,
     v_auto_renew_flag          IN  GIPI_WPOLBAS.auto_renew_flag%TYPE,
     v_foreign_acc_sw          IN  GIPI_WPOLBAS.foreign_acc_sw%TYPE,
     v_reg_policy_sw          IN  GIPI_WPOLBAS.reg_policy_sw%TYPE,                                  
     v_prem_warr_tag            IN  GIPI_WPOLBAS.prem_warr_tag%TYPE,
     v_prem_warr_days            IN  GIPI_WPOLBAS.prem_warr_days%TYPE,
     v_fleet_print_tag        IN  GIPI_WPOLBAS.fleet_print_tag%TYPE,
     v_with_tariff_sw            IN  GIPI_WPOLBAS.with_tariff_sw%TYPE,
     v_co_insurance_sw          IN  GIPI_WPOLBAS.co_insurance_sw%TYPE,
     v_prorate_flag               IN  GIPI_WPOLBAS.prorate_flag%TYPE,
     v_comp_sw                   IN  GIPI_WPOLBAS.comp_sw%TYPE,
     v_short_rt_percent        IN  GIPI_WPOLBAS.short_rt_percent%TYPE,     
     v_prov_prem_tag             IN  GIPI_WPOLBAS.prov_prem_tag%TYPE,                                        
     v_prov_prem_pct            IN  GIPI_WPOLBAS.prov_prem_pct%TYPE,
     v_survey_agent_cd             IN  GIPI_WPOLBAS.survey_agent_cd%TYPE,                                         
     v_settling_agent_cd        IN  GIPI_WPOLBAS.settling_agent_cd%TYPE,
     v_user_id                  IN  GIPI_WPOLBAS.user_id%TYPE,
     v_line_cd                  IN  GIPI_WPOLBAS.line_cd%TYPE,
     v_designation              IN  GIPI_WPOLBAS.designation%TYPE,
     v_acct_of_cd              IN  GIPI_WPOLBAS.acct_of_cd%TYPE,
     v_iss_cd                  IN  GIPI_WPOLBAS.iss_cd%TYPE,
     v_invoice_sw              IN  GIPI_WPOLBAS.invoice_sw%TYPE,
     v_renew_no                  IN  GIPI_WPOLBAS.renew_no%TYPE,
     v_issue_yy                  IN  GIPI_WPOLBAS.issue_yy%TYPE,
     v_ref_open_pol_no          IN  GIPI_WPOLBAS.ref_open_pol_no%TYPE,
     v_same_polno_sw          IN  GIPI_WPOLBAS.same_polno_sw%TYPE,
     v_endt_yy                  IN  GIPI_WPOLBAS.endt_yy%TYPE,
     v_endt_seq_no              IN  GIPI_WPOLBAS.endt_seq_no%TYPE,
     v_update_issue_date      IN  VARCHAR2,
     v_mortg_name              IN  GIPI_WPOLBAS.mortg_name%TYPE,
     v_validate_tag              IN  GIPI_WPOLBAS.validate_tag%TYPE,
     v_endt_expiry_date          IN  GIPI_WPOLBAS.endt_expiry_date%TYPE,
     v_company_cd             IN  GIPI_WPOLBAS.company_cd%TYPE,
     v_employee_cd            IN  GIPI_WPOLBAS.employee_cd%TYPE,
     v_bank_ref_no            IN  GIPI_WPOLBAS.bank_ref_no%TYPE,
     v_banc_type_cd           IN  GIPI_WPOLBAS.banc_type_cd%TYPE,
     v_bancassurance_sw       IN  GIPI_WPOLBAS.bancassurance_sw%TYPE,
     v_area_cd                IN  GIPI_WPOLBAS.area_cd%TYPE,
     v_branch_cd              IN  GIPI_WPOLBAS.branch_cd%TYPE,
     v_manager_cd             IN  GIPI_WPOLBAS.manager_cd%TYPE,
     v_plan_cd                IN  GIPI_WPOLBAS.plan_cd%TYPE,
     v_plan_sw                IN  GIPI_WPOLBAS.plan_sw%TYPE
     ); 
     
    Procedure set_gipi_wpolbas2( 
       v_par_id                  IN  GIPI_WPOLBAS.par_id%TYPE,    
     v_label_tag              IN  GIPI_WPOLBAS.label_tag%TYPE,
     v_assd_no                   IN  GIPI_WPOLBAS.assd_no%TYPE,
     v_subline_cd              IN  GIPI_WPOLBAS.subline_cd%TYPE,
     v_surcharge_sw               IN  GIPI_WPOLBAS.surcharge_sw%TYPE,
     v_manual_renew_no           IN  GIPI_WPOLBAS.manual_renew_no%TYPE,
     v_discount_sw               IN  GIPI_WPOLBAS.discount_sw%TYPE,
     v_pol_flag                   IN  GIPI_WPOLBAS.pol_flag%TYPE,
     v_type_cd                  IN  GIPI_WPOLBAS.type_cd%TYPE,
     v_address1                   IN  GIPI_WPOLBAS.address1%TYPE,
     v_address2                   IN  GIPI_WPOLBAS.address2%TYPE,
     v_address3                   IN  GIPI_WPOLBAS.address3%TYPE,
     v_booking_year               IN  GIPI_WPOLBAS.booking_year%TYPE,
     v_booking_mth               IN  GIPI_WPOLBAS.booking_mth%TYPE,
     v_takeup_term               IN  GIPI_WPOLBAS.takeup_term%TYPE,
     v_incept_date            IN  GIPI_WPOLBAS.incept_date%TYPE,
     v_expiry_date            IN  GIPI_WPOLBAS.expiry_date%TYPE,
     v_issue_date                IN  GIPI_WPOLBAS.issue_date%TYPE,
      v_place_cd                   IN  GIPI_WPOLBAS.place_cd%TYPE,     
     v_incept_tag              IN  GIPI_WPOLBAS.incept_tag%TYPE,
     v_expiry_tag              IN  GIPI_WPOLBAS.expiry_tag%TYPE,
     v_risk_tag                      IN  GIPI_WPOLBAS.risk_tag%TYPE,
     v_ref_pol_no                IN  GIPI_WPOLBAS.ref_pol_no%TYPE,
     v_industry_cd               IN  GIPI_WPOLBAS.industry_cd%TYPE,
     v_region_cd               IN  GIPI_WPOLBAS.region_cd%TYPE,
     v_cred_branch               IN  GIPI_WPOLBAS.cred_branch%TYPE,
     v_quotation_printed_sw      IN  GIPI_WPOLBAS.quotation_printed_sw%TYPE,
     v_covernote_printed_sw      IN  GIPI_WPOLBAS.covernote_printed_sw%TYPE,
     v_pack_pol_flag           IN  GIPI_WPOLBAS.pack_pol_flag%TYPE,
     v_auto_renew_flag          IN  GIPI_WPOLBAS.auto_renew_flag%TYPE,
     v_foreign_acc_sw          IN  GIPI_WPOLBAS.foreign_acc_sw%TYPE,
     v_reg_policy_sw          IN  GIPI_WPOLBAS.reg_policy_sw%TYPE,                                  
     v_prem_warr_tag            IN  GIPI_WPOLBAS.prem_warr_tag%TYPE,
     v_prem_warr_days            IN  GIPI_WPOLBAS.prem_warr_days%TYPE,
     v_fleet_print_tag        IN  GIPI_WPOLBAS.fleet_print_tag%TYPE,
     v_with_tariff_sw            IN  GIPI_WPOLBAS.with_tariff_sw%TYPE,
     v_co_insurance_sw          IN  GIPI_WPOLBAS.co_insurance_sw%TYPE,
     v_prorate_flag               IN  GIPI_WPOLBAS.prorate_flag%TYPE,
     v_comp_sw                   IN  GIPI_WPOLBAS.comp_sw%TYPE,
     v_short_rt_percent        IN  GIPI_WPOLBAS.short_rt_percent%TYPE,     
     v_prov_prem_tag             IN  GIPI_WPOLBAS.prov_prem_tag%TYPE,                                        
     v_prov_prem_pct            IN  GIPI_WPOLBAS.prov_prem_pct%TYPE,
     v_survey_agent_cd             IN  GIPI_WPOLBAS.survey_agent_cd%TYPE,                                         
     v_settling_agent_cd        IN  GIPI_WPOLBAS.settling_agent_cd%TYPE,
     v_user_id                  IN  GIPI_WPOLBAS.user_id%TYPE,
     v_line_cd                  IN  GIPI_WPOLBAS.line_cd%TYPE,
     v_designation              IN  GIPI_WPOLBAS.designation%TYPE,
     v_acct_of_cd              IN  GIPI_WPOLBAS.acct_of_cd%TYPE,
     v_iss_cd                  IN  GIPI_WPOLBAS.iss_cd%TYPE,
     v_invoice_sw              IN  GIPI_WPOLBAS.invoice_sw%TYPE,
     v_renew_no                  IN  GIPI_WPOLBAS.renew_no%TYPE,
     v_issue_yy                  IN  GIPI_WPOLBAS.issue_yy%TYPE,
     v_ref_open_pol_no          IN  GIPI_WPOLBAS.ref_open_pol_no%TYPE,
     v_same_polno_sw          IN  GIPI_WPOLBAS.same_polno_sw%TYPE,
     v_endt_yy                  IN  GIPI_WPOLBAS.endt_yy%TYPE,
     v_endt_seq_no              IN  GIPI_WPOLBAS.endt_seq_no%TYPE,
     v_update_issue_date      IN  VARCHAR2,
     v_mortg_name              IN  GIPI_WPOLBAS.mortg_name%TYPE,
     v_validate_tag              IN  GIPI_WPOLBAS.validate_tag%TYPE,
     v_endt_expiry_date          IN  GIPI_WPOLBAS.endt_expiry_date%TYPE,
     v_company_cd             IN  GIPI_WPOLBAS.company_cd%TYPE,
     v_employee_cd            IN  GIPI_WPOLBAS.employee_cd%TYPE,
     v_bank_ref_no            IN  GIPI_WPOLBAS.bank_ref_no%TYPE,
     v_banc_type_cd           IN  GIPI_WPOLBAS.banc_type_cd%TYPE,
     v_bancassurance_sw       IN  GIPI_WPOLBAS.bancassurance_sw%TYPE,
     v_area_cd                IN  GIPI_WPOLBAS.area_cd%TYPE,
     v_branch_cd              IN  GIPI_WPOLBAS.branch_cd%TYPE,
     v_manager_cd             IN  GIPI_WPOLBAS.manager_cd%TYPE,
     v_plan_cd                IN  GIPI_WPOLBAS.plan_cd%TYPE,
     v_plan_sw                IN  GIPI_WPOLBAS.plan_sw%TYPE,
     v_bond_seq_no              IN  GIPI_WPOLBAS.bond_seq_no%TYPE,
	 v_bond_auto_prem			IN  GIPI_WPOLBAS.bond_auto_prem%TYPE --additional parameter by robert GENQA SR 4828 08.25.15
     );      
    
    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.23.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Update GIPI_WPOLBAS no_of_items.    
    **                       This is called during the POST-FORMS-COMMIT of GIPIS010
    */
    
    Procedure set_gipi_wpolbas_no_of_items(p_par_id    GIPI_WPOLBAS.par_id%TYPE);    
    
    FUNCTION get_expiry_date(p_par_id     GIPI_WPOLBAS.par_id%TYPE)
      RETURN GIPI_WPOLBAS.expiry_date%TYPE;
    
    Procedure update_wpolbasic(p_par_id            GIPI_WPOLBAS.par_id%TYPE,
                                    p_tsi_amt            GIPI_WPOLBAS.tsi_amt%TYPE,
                                  p_prem_amt        GIPI_WPOLBAS.prem_amt%TYPE,
                                  p_ann_tsi_amt        GIPI_WPOLBAS.ann_tsi_amt%TYPE,
                                  p_ann_prem_amt    GIPI_WPOLBAS.ann_prem_amt%TYPE);
                                  
  Procedure update_pack_wpolbas(p_pack_par_id  IN  gipi_wpolbas.pack_par_id%TYPE);
  
    Procedure get_gipi_wpolbas_par_no (
        p_par_id        IN GIPI_WPOLBAS.par_id%TYPE,
        p_line_cd        OUT GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd    OUT GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd        OUT GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy        OUT GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no    OUT GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no        OUT GIPI_WPOLBAS.renew_no%TYPE);
        
  FUNCTION check_old_bond_no_exist(p_par_id            GIPI_WPOLBAS.par_id%TYPE,
                                        p_assd_no        GIPI_WPOLBAS.assd_no%TYPE,
                                      p_line_cd        GIPI_POLBASIC.line_cd%TYPE,
                                      p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
                                      p_iss_cd         GIPI_POLBASIC.iss_cd%TYPE,
                                      p_issue_yy        GIPI_POLBASIC.issue_yy%TYPE,
                                      p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
                                      p_renew_no        GIPI_POLBASIC.renew_no%TYPE,
                                   p_pol_flag       GIPI_WPOLBAS.pol_flag%TYPE)
    RETURN VARCHAR2;    
    
  FUNCTION validate_renewal_duration(p_line_cd        GIPI_POLBASIC.line_cd%TYPE,
                                        p_subline_cd   GIPI_POLBASIC.subline_cd%TYPE,
                                        p_iss_cd       GIPI_POLBASIC.iss_cd%TYPE,
                                        p_issue_yy        GIPI_POLBASIC.issue_yy%TYPE,
                                        p_pol_seq_no   GIPI_POLBASIC.pol_seq_no%TYPE,
                                        p_renew_no        GIPI_POLBASIC.renew_no%TYPE,
                                     p_incept_date    GIPI_WPOLBAS.incept_date%TYPE)
    RETURN VARCHAR2;

  FUNCTION Check_Pack_Pol_Flag (p_par_id     GIPI_WPOLBAS.par_id%TYPE)
    RETURN VARCHAR2;        

  Procedure update_gipi_wpolbas_discount (p_par_id                  GIPI_WPOLBAS.par_id%TYPE,
                                          p_disc_amt                GIPI_WPERIL_DISCOUNT.disc_amt%TYPE,
                                          p_orig_pol_ann_prem_amt   GIPI_WPERIL_DISCOUNT.orig_pol_ann_prem_amt%TYPE);

  Procedure update_gipi_wpolbas_amounts (p_par_id       GIPI_WPOLBAS.par_id%TYPE,
                                         p_tsi_amt      GIPI_WPOLBAS.tsi_amt%TYPE,
                                         p_ann_tsi_amt  GIPI_WPOLBAS.ann_tsi_amt%TYPE,
                                         p_prem_amt     GIPI_WPOLBAS.prem_amt%TYPE,
                                         p_ann_prem_amt GIPI_WPOLBAS.ann_prem_amt%TYPE);  
                                         
  Procedure create_gipi_wpolbas(p_quote_id  IN NUMBER,                 
                                  p_par_id    IN NUMBER,
                                p_line_cd   IN GIIS_LINE.line_cd%TYPE, 
                                p_iss_cd    IN VARCHAR2,
                                 p_assd_no   IN NUMBER,                 
                                p_user         IN GIPI_PACK_WPOLBAS.user_id%TYPE,
                                p_out        OUT VARCHAR2);

    PROCEDURE SET_GIPI_WPOLBAS_FROM_ENDT (
        p_par_id IN gipi_wpolbas.par_id%TYPE,
        p_line_cd IN gipi_wpolbas.line_cd%TYPE,
        p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
        p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
        p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
        p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
        p_renew_no IN gipi_wpolbas.renew_no%TYPE,
        p_endt_iss_cd IN gipi_wpolbas.endt_iss_cd%TYPE,
        p_endt_yy IN gipi_wpolbas.endt_yy%TYPE,
        p_endt_seq_no IN gipi_wpolbas.endt_seq_no%TYPE,
        p_incept_date IN gipi_wpolbas.incept_date%TYPE,
        p_incept_tag IN gipi_wpolbas.incept_tag%TYPE,
        p_expiry_date IN gipi_wpolbas.expiry_date%TYPE,
        p_expiry_tag IN gipi_wpolbas.expiry_tag%TYPE,
        p_eff_date IN gipi_wpolbas.eff_date%TYPE,
        p_endt_expiry_date IN gipi_wpolbas.endt_expiry_date%TYPE,
        p_endt_expiry_tag IN gipi_wpolbas.endt_expiry_tag%TYPE,
        p_issue_date IN gipi_wpolbas.issue_date%TYPE,
        p_invoice_sw IN gipi_wpolbas.invoice_sw%TYPE,
        p_pol_flag IN gipi_wpolbas.pol_flag%TYPE,
        p_manual_renew_no IN gipi_wpolbas.manual_renew_no%TYPE,
        p_type_cd IN gipi_wpolbas.type_cd%TYPE,
        p_address1 IN gipi_wpolbas.address1%TYPE,
        p_address2 IN gipi_wpolbas.address2%TYPE,
        p_address3 IN gipi_wpolbas.address3%TYPE,
        p_designation IN gipi_wpolbas.designation%TYPE,
        p_cred_branch IN gipi_wpolbas.cred_branch%TYPE,
        p_assd_no IN gipi_wpolbas.assd_no%TYPE,
        p_acct_of_cd IN gipi_wpolbas.acct_of_cd%TYPE,
        p_place_cd IN gipi_wpolbas.place_cd%TYPE,
        p_risk_tag IN gipi_wpolbas.risk_tag%TYPE,
        p_ref_pol_no IN gipi_wpolbas.ref_pol_no%TYPE,
        p_industy_cd IN gipi_wpolbas.industry_cd%TYPE,
        p_region_cd IN gipi_wpolbas.region_cd%TYPE,
        p_quotation_printed_sw IN gipi_wpolbas.quotation_printed_sw%TYPE,
        p_covernote_printed_sw IN gipi_wpolbas.covernote_printed_sw%TYPE,
        p_pack_pol_flag IN gipi_wpolbas.pack_pol_flag%TYPE,
        p_auto_renew_flag IN gipi_wpolbas.auto_renew_flag%TYPE,
        p_foreign_acc_sw IN gipi_wpolbas.foreign_acc_sw%TYPE,
        p_reg_policy_sw IN gipi_wpolbas.reg_policy_sw%TYPE,
        p_prem_warr_tag IN gipi_wpolbas.prem_warr_tag%TYPE,
        p_prem_warr_days IN gipi_wpolbas.prem_warr_days%TYPE,
        p_fleet_print_tag IN gipi_wpolbas.fleet_print_tag%TYPE,
        p_with_tariff_sw IN gipi_wpolbas.with_tariff_sw%TYPE,
        p_prov_prem_tag IN gipi_wpolbas.prov_prem_tag%TYPE,
        p_prov_prem_pct IN gipi_wpolbas.prov_prem_pct%TYPE,
        p_prorate_flag IN gipi_wpolbas.prorate_flag%TYPE,
        p_comp_sw IN gipi_wpolbas.comp_sw%TYPE,
        p_short_rt_percent IN gipi_wpolbas.short_rt_percent%TYPE,
        p_booking_year IN gipi_wpolbas.booking_year%TYPE,
        p_booking_mth IN gipi_wpolbas.booking_mth%TYPE,
        p_co_insurance_sw IN gipi_wpolbas.co_insurance_sw%TYPE,
        p_takeup_term IN gipi_wpolbas.takeup_term%TYPE,
        p_same_polno_sw IN gipi_wpolbas.same_polno_sw%TYPE,
        p_cancel_type IN gipi_wpolbas.cancel_type%TYPE,
        p_tsi_amt IN gipi_wpolbas.tsi_amt%TYPE,
        p_prem_amt IN gipi_wpolbas.prem_amt%TYPE,
        p_ann_tsi_amt IN gipi_wpolbas.ann_tsi_amt%TYPE,
        p_ann_prem_amt IN gipi_wpolbas.ann_prem_amt%TYPE,
        p_old_assd_no IN gipi_wpolbas.old_assd_no%TYPE,
        p_old_address1 IN gipi_wpolbas.old_address1%TYPE,
        p_old_address2 IN gipi_wpolbas.old_address2%TYPE,
        p_old_address3 IN gipi_wpolbas.old_address3%TYPE,
        p_acct_of_cd_sw IN gipi_wpolbas.acct_of_cd_sw%TYPE,
        p_user_id IN gipi_wpolbas.user_id%TYPE,
        p_back_stat IN gipi_wpolbas.back_stat%TYPE,
        p_bancassurance_sw IN gipi_wpolbas.bancassurance_sw%TYPE,
        p_survey_agent_cd IN gipi_wpolbas.survey_agent_cd%TYPE,
        p_settling_agent_cd IN gipi_wpolbas.settling_agent_cd%TYPE,
        p_cancelled_endt_id IN gipi_wpolbas.cancelled_endt_id%TYPE,
        p_label_tag IN gipi_wpolbas.label_tag%TYPE,
        p_banc_type_cd IN gipi_wpolbas.banc_type_cd%TYPE,
        p_branch_cd IN gipi_wpolbas.branch_cd%TYPE,
        p_manager_cd IN gipi_wpolbas.manager_cd%TYPE,
        p_area_cd IN gipi_wpolbas.area_cd%TYPE); --apollo cruz 11.06.2014 - added banca fields

    FUNCTION get_policy_no_for_endtpar (p_par_id    GIPI_WPOLBAS.par_id%TYPE)
        RETURN VARCHAR2;
        
    PROCEDURE generate_bank_ref_no(
        p_acct_iss_cd        IN   giis_ref_seq.acct_iss_cd%TYPE,
        p_branch_cd          IN   giis_ref_seq.branch_cd%TYPE,
        p_bank_ref_no       OUT   gipi_wpolbas.bank_ref_no%TYPE,
        p_msg_alert         OUT   VARCHAR2,
        p_par_id             IN   gipi_wpolbas.par_id%TYPE
        );
            
    FUNCTION validate_acct_iss_cd(p_acct_iss_cd VARCHAR2)
    RETURN VARCHAR2;
    
    FUNCTION validate_branch_cd(
        p_acct_iss_cd   VARCHAR2,
        p_branch_cd     VARCHAR2
        ) RETURN VARCHAR2;
        
    FUNCTION validate_bank_ref_no(
        p_acct_iss_cd   VARCHAR2,
        p_branch_cd     VARCHAR2,
        p_ref_no        VARCHAR2,
        p_mod_no        VARCHAR2,
        p_bank_ref_no   VARCHAR2
        ) RETURN VARCHAR2;
        
    TYPE endt_bancassurance_dtl_type IS RECORD(
        bancassurance_sw    gipi_wpolbas.bancassurance_sw%TYPE,
        banc_type_cd        gipi_wpolbas.banc_type_cd%TYPE,
        area_cd             gipi_wpolbas.area_cd%TYPE,
        branch_cd           gipi_wpolbas.branch_cd%TYPE,
        manager_cd          gipi_wpolbas.manager_cd%TYPE,
        banc_type_desc      giis_banc_type.banc_type_desc%TYPE,
        area_desc           giis_banc_area.area_desc%TYPE,
        branch_desc         giis_banc_branch.branch_desc%TYPE,
        full_name           VARCHAR2(50)
    );
    
    TYPE endt_bancassurance_dtl_tab IS TABLE OF endt_bancassurance_dtl_type;
    
    FUNCTION get_endt_bancassurance_dtl(p_par_id    gipi_wpolbas.par_id%TYPE )
      
      RETURN endt_bancassurance_dtl_tab PIPELINED;
      
    PROCEDURE set_gipi_wpolbas_endt_bond (
        p_par_id                 gipi_wpolbas.par_id%TYPE,
        p_assd_no                gipi_wpolbas.assd_no%TYPE,
        p_line_cd                gipi_wpolbas.line_cd%TYPE,
        p_subline_cd             gipi_wpolbas.subline_cd%TYPE,
        p_iss_cd                 gipi_wpolbas.iss_cd%TYPE,
        p_issue_yy               gipi_wpolbas.issue_yy%TYPE,
        p_pol_seq_no             gipi_wpolbas.pol_seq_no%TYPE,
        p_renew_no               gipi_wpolbas.renew_no%TYPE,
        p_endt_iss_cd            gipi_wpolbas.endt_iss_cd%TYPE,
        p_endt_yy                gipi_wpolbas.endt_yy%TYPE,
        p_incept_date            gipi_wpolbas.incept_date%TYPE,
        p_expiry_date            gipi_wpolbas.expiry_date%TYPE,
        p_eff_date               gipi_wpolbas.eff_date%TYPE,
        p_endt_expiry_date       gipi_wpolbas.endt_expiry_date%TYPE,
        p_issue_date             gipi_wpolbas.issue_date%TYPE,
        p_ref_pol_no             gipi_wpolbas.ref_pol_no%TYPE,
        p_type_cd                gipi_wpolbas.type_cd%TYPE,
        p_region_cd              gipi_wpolbas.region_cd%TYPE,
        p_address1               gipi_wpolbas.address1%TYPE,
        p_address2               gipi_wpolbas.address2%TYPE,
        p_address3               gipi_wpolbas.address3%TYPE,
        p_mortg_name             gipi_wpolbas.mortg_name%TYPE,
        p_industry_cd            gipi_wpolbas.industry_cd%TYPE,
        p_cred_branch            gipi_wpolbas.cred_branch%TYPE,
        p_booking_mth            gipi_wpolbas.booking_mth%TYPE,
        p_booking_year           gipi_wpolbas.booking_year%TYPE,
        p_takeup_term            gipi_wpolbas.takeup_term%TYPE,
        p_incept_tag             gipi_wpolbas.incept_tag%TYPE,
        p_expiry_tag             gipi_wpolbas.expiry_tag%TYPE,
        p_endt_expiry_tag        gipi_wpolbas.endt_expiry_tag%TYPE,
        p_reg_policy_sw          gipi_wpolbas.reg_policy_sw%TYPE,
        p_foreign_acc_sw         gipi_wpolbas.foreign_acc_sw%TYPE, 
        p_invoice_sw             gipi_wpolbas.invoice_sw%TYPE, 
        p_auto_renew_flag        gipi_wpolbas.auto_renew_flag%TYPE, 
        p_prov_prem_tag          gipi_wpolbas.prov_prem_tag%TYPE, 
        p_pack_pol_flag          gipi_wpolbas.pack_pol_flag%TYPE, 
        p_co_insurance_sw        gipi_wpolbas.co_insurance_sw%TYPE,
        p_user_id                gipi_wpolbas.user_id%TYPE,
        p_pol_flag               gipi_wpolbas.pol_flag%TYPE,
        p_quotation_printed_sw   gipi_wpolbas.quotation_printed_sw%TYPE,
        p_covernote              gipi_wpolbas.covernote_printed_sw%TYPE,
        p_endt_seq_no            gipi_wpolbas.endt_seq_no%TYPE,
        p_same_polno_sw          gipi_wpolbas.same_polno_sw%TYPE,
        p_ann_prem_amt           gipi_wpolbas.ann_prem_amt%TYPE,
        p_ann_tsi_amt            gipi_wpolbas.ann_tsi_amt%TYPE,
        p_bond_seq_no            gipi_wpolbas.bond_seq_no%TYPE,
		p_cancel_type			 gipi_wpolbas.cancel_type%TYPE,
		p_old_assd_no            gipi_wpolbas.old_assd_no%TYPE,
		p_old_address1           gipi_wpolbas.old_address1%TYPE,
        p_old_address2           gipi_wpolbas.old_address2%TYPE,
        p_old_address3           gipi_wpolbas.old_address3%TYPE, --additional parameters by robert GENQA SR 4825 08.03.15
		p_prorate_flag           gipi_wpolbas.prorate_flag%TYPE,
        p_comp_sw	             gipi_wpolbas.comp_sw%TYPE,
        p_short_rt_percent       gipi_wpolbas.short_rt_percent%TYPE, -- end GENQA SR 4825 08.03.15
		p_bond_auto_prem         gipi_wpolbas.bond_auto_prem%TYPE --additional parameter by robert GENQA SR 4828 08.25.15
    );
    
    FUNCTION get_par_id_by_pol_flag(p_pol_flag              GIPI_WPOLBAS.pol_flag%TYPE,
                                     p_par_id              GIPI_WPOLBAS.par_id%TYPE)
      RETURN GIPI_WPOLBAS.par_id%TYPE;
      
    PROCEDURE get_covernote_details(p_par_id            IN   GIPI_WPOLBAS.par_id%TYPE,
                                    p_covernote_expiry  OUT  GIPI_WPOLBAS.covernote_expiry%TYPE,
                                    p_cn_date_printed   OUT  GIPI_WPOLBAS.cn_date_printed%TYPE,
                                    p_cn_no_of_days     OUT  GIPI_WPOLBAS.cn_no_of_days%TYPE );
    
    PROCEDURE update_covernote_details(p_par_id   IN   GIPI_WPOLBAS.par_id%TYPE,
                                       p_days     IN   NUMBER);
                                     
    PROCEDURE update_covernote_printed_sw(p_par_id   IN   GIPI_WPOLBAS.par_id%TYPE);
    
/**
* Rey Jadlocon 
* 11-08-2011
* change par status to 2 when assured is changed 
**/
Procedure change_par_status(p_par_id            gipi_parlist.par_id%TYPE,
                            p_assd_no           gipi_parlist.assd_no%TYPE);
 
/**
* Rey Jadlocon
* 11-09-2011
* check booking date
* Added takeup_seq_no parameter to handle multiple takeup terms. added by Irwin, 5.28.2012
* Change to procedure  belle 07.23.2012
**/
   /**FUNCTION validate_booking_date2(p_booking_date_polbas          VARCHAR2,
                                    p_incept_date                  VARCHAR2,
                                    p_multi_booking_mm             VARCHAR2,
                                    p_multi_booking_yy             NUMBER,
                                    p_par_id                       NUMBER,     
                                    p_due_date                     VARCHAR2,
                                    p_takeup_seq_no                varchar2)
                                    
   RETURN VARCHAR2; **/
   PROCEDURE validate_booking_date2(p_booking_mm_polbas           VARCHAR2, 
                                 p_booking_yy_polbas           VARCHAR2, 
                                 p_incept_date                 VARCHAR2,
                                 p_booking_mm                  VARCHAR2, 
                                 p_booking_yy                  VARCHAR2, 
                                 p_par_id                      NUMBER,     
                                 p_due_date                    VARCHAR2,
                                 p_takeup_seq_no                varchar2); 
/**
* Rey Jadlocon
* 11-14-2011
* incept date
**/
TYPE incept_date_type IS RECORD(
    incept_date     gipi_wpolbas.incept_date%TYPE
);
TYPE incept_date_tab IS TABLE OF incept_date_type;

FUNCTION set_incept_date(p_par_id       gipi_wpolbas.par_id%TYPE)
        RETURN incept_date_tab PIPELINED;

    /* Created by: Joanne
    ** Date: 10.09.13
    **Description: Check for replacements and/or renewals and compare it with the current policy.
    */
   FUNCTION check_policy_renewal (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
   
   RETURN gipi_polbasic.policy_id%TYPE;    
   
    /* Created by: Joanne
    ** Date: 10.09.13
    **Description: Check for replacements and/or renewals and compare it with the current package policy.
    */
   FUNCTION check_pack_policy_renewal (
      p_line_cd      IN   gipi_pack_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_pack_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_pack_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_pack_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_pack_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_pack_polbasic.renew_no%TYPE
   )
   
   RETURN gipi_pack_polbasic.pack_policy_id%TYPE;     
        
    PROCEDURE update_discount_sw (
        p_par_id IN gipi_wpolbas.par_id%TYPE,
        p_discount_sw IN gipi_wpolbas.discount_sw%TYPE);
                      
    PROCEDURE update_surcharge_sw (
        p_par_id IN gipi_wpolbas.par_id%TYPE,
        p_surcharge_sw IN gipi_wpolbas.surcharge_sw%TYPE);        
        
	PROCEDURE update_gipis165 (
		p_par_id 		  IN gipi_wpolbas.par_id%TYPE,
		p_dsp_bond_seq_no IN gipi_wpolbas.bond_seq_no%TYPE
	);
   
   --Apollo Cruz 10.02.2014
   PROCEDURE set_default_cred_branch (p_par_id gipi_wpolbas.par_id%TYPE);
   
   FUNCTION validate_pol_no (
      p_par_id       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no     VARCHAR2
   )
      RETURN VARCHAR2;
   
END Gipi_Wpolbas_Pkg;
/



CREATE OR REPLACE PACKAGE CPI.GIXX_POLBASIC_PKG AS

  TYPE gixx_polbasic_type IS RECORD(
    par_seq_no1            VARCHAR2(50),
    extract_id1           GIXX_POLBASIC.extract_id%TYPE,
    par_id                 GIXX_POLBASIC.policy_id%TYPE,
    policy_number         VARCHAR2(50),
    iss_cd                  GIXX_POLBASIC.iss_cd%TYPE,
    line_cd               GIXX_POLBASIC.line_cd%TYPE,
    par_no                 VARCHAR2(50),
    par_orig                 VARCHAR2(50),
    line_line_name          GIIS_LINE.line_name%TYPE,
    subline_subline_name  GIIS_SUBLINE.subline_name%TYPE,
    subline_subline_cd      GIIS_SUBLINE.subline_cd%TYPE,
    subline_line_cd            GIIS_SUBLINE.line_cd%TYPE,
    basic_incept_date      VARCHAR2(50),
    basic_incept_time      VARCHAR2(50),
    basic_expiry_date      VARCHAR2(50),
    basic_expiry_time      VARCHAR2(50),
    basic_expiry_tag      GIXX_POLBASIC.expiry_tag%TYPE,
    basic_issue_date      VARCHAR2(50),
    basic_tsi_amt          GIXX_POLBASIC.tsi_amt%TYPE,
    subline_subline_time  VARCHAR2(50),
    basic_acct_of_cd      GIXX_POLBASIC.acct_of_cd%TYPE,
    basic_mortg_name      GIXX_POLBASIC.mortg_name%TYPE,
    assd_name              GIIS_ASSURED.assd_name%TYPE,
    address1              GIXX_PARLIST.address1%TYPE,
    address2              GIXX_PARLIST.address2%TYPE,
    address3              GIXX_PARLIST.address3%TYPE,
    basic_addr             VARCHAR2(4000),--GIXX_POLBASIC.old_address1%TYPE,
    basic_pol_flag          GIXX_POLBASIC.pol_flag%TYPE,
    basic_line_cd          GIXX_POLBASIC.line_cd%TYPE,
    basic_ref_pol_no      GIXX_POLBASIC.ref_pol_no%TYPE,
    basic_assd_no          GIXX_POLBASIC.assd_no%TYPE,
    label_tag              VARCHAR2(20),--GIXX_POLBASIC.label_tag%TYPE,
    endt_no                  VARCHAR2(50),
    pol_endt_no              VARCHAR2(50),
    endt_expiry_date      VARCHAR2(50),
    basic_eff_date          VARCHAR2(50),
    eff_date              GIXX_POLBASIC.eff_date%TYPE,
    endt_expiry_tag          GIXX_POLBASIC.endt_expiry_tag%TYPE,
    basic_incept_tag      GIXX_POLBASIC.incept_tag%TYPE,
    basic_subline_cd      GIXX_POLBASIC.subline_cd%TYPE,
    basic_iss_cd          GIXX_POLBASIC.iss_cd%TYPE,
    basic_issue_yy          GIXX_POLBASIC.issue_yy%TYPE,
    basic_pol_seq_no      GIXX_POLBASIC.pol_seq_no%TYPE,
    basic_renew_no          GIXX_POLBASIC.renew_no%TYPE,
    basic_eff_time          VARCHAR2(50),
    basic_endt_expiry_time VARCHAR2(50),
    par_par_type          GIXX_PARLIST.par_type%TYPE,
    par_par_status          GIXX_PARLIST.par_status%TYPE,
    basic_co_insurance_sw GIXX_POLBASIC.co_insurance_sw%TYPE,
    username              VARCHAR2(40),
    intm_no                  VARCHAR2(50),
    intm_name              GIIS_INTERMEDIARY.intm_name%TYPE,
    agent_intm_name          GIIS_INTERMEDIARY.intm_name%TYPE,
    parent_intm_name      GIIS_INTERMEDIARY.intm_name%TYPE,
    agent_intm_no          GIIS_INTERMEDIARY.intm_no%TYPE,
    parent_intm_no            GIIS_INTERMEDIARY.intm_no%TYPE,
    basic_tsi_amt_1          GIXX_POLBASIC.tsi_amt%TYPE,
    subline_open_policy      GIIS_SUBLINE.op_flag%TYPE,
    subline_time          VARCHAR2(50),
    basic_assd_number      GIXX_POLBASIC.assd_no%TYPE,
    cred_br                    GIXX_POLBASIC.cred_branch%TYPE,
    label_tag_1              GIXX_POLBASIC.label_tag%TYPE,
    basic_printed_cnt      GIXX_POLBASIC.polendt_printed_cnt%TYPE,
    basic_printed_dt      GIXX_POLBASIC.polendt_printed_date%TYPE,
    ann_tsi_amt              GIXX_POLBASIC.ann_tsi_amt%TYPE
    );
        
  TYPE gixx_polbasic_tab IS TABLE OF gixx_polbasic_type;
  
  FUNCTION get_gixx_polbasic(p_extract_id         GIXX_POLBASIC.extract_id%TYPE)
    RETURN gixx_polbasic_tab PIPELINED;
    
    
    
  -- added by Kris 02.15.2013 for GIPIS101
  TYPE gixx_polbasic_type2 IS RECORD (
    extract_id      GIXX_POLBASIC.extract_id%TYPE,
    policy_id       GIXX_POLBASIC.policy_id%TYPE,
    policy_no       VARCHAR2(100),
    iss_cd          GIXX_POLBASIC.iss_cd%TYPE,
    line_cd         GIXX_POLBASIC.line_cd%TYPE,
    subline_cd      GIXX_POLBASIC.subline_cd%TYPE,
    issue_yy        GIXX_POLBASIC.issue_yy%TYPE,
    pol_seq_no      GIXX_POLBASIC.pol_seq_no%TYPE,
    renew_no        GIXX_POLBASIc.renew_no%TYPE,
    assd_no         GIXX_POLBASIC.assd_no%TYPE, 
    drv_assd_no     VARCHAR2(1000),--GIIS_ASSURED.assd_name%TYPE,
    acct_of_cd      GIXX_POLBASIC.acct_of_cd%TYPE,
    drv_acct_of     VARCHAR2(1000),
    address1        GIXX_POLBASIC.address1%TYPE,
    address2        GIXX_POLBASIC.address2%TYPE,
    address3        GIXX_POLBASIC.address3%TYPE,
    ref_pol_no      GIXX_POLBASIC.ref_pol_no%TYPE,
    type_cd         GIXX_POLBASIC.type_cd%TYPE,
    dsp_type_desc   GIIS_POLICY_TYPE.type_desc%TYPE,
    manual_renew_no GIXX_POLBASIC.manual_renew_no%TYPE,
    risk_tag        GIXX_POLBASIC.risk_tag%TYPE,
    nbt_risk_tag    VARCHAR2(100),
    incept_date     GIXX_POLBASIC.incept_date%TYPE,
    incept_tag      GIXX_POLBASIC.incept_tag%TYPE,
    expiry_date     GIXX_POLBASIC.expiry_date%TYPE,
    expiry_tag      GIXX_POLBASIC.expiry_tag%TYPE,
    eff_date        GIXX_POLBASIC.eff_date%TYPE,
    issue_date      GIXX_POLBASIC.issue_date%TYPE,
    industry_cd     GIXX_POLBASIC.industry_cd%TYPE,
    industry_nm     GIIS_INDUSTRY.industry_nm%TYPE,
    region_cd       GIXX_POLBASIC.region_cd%TYPE,
    region_desc     GIIS_REGION.region_desc%TYPE,
    cred_branch     GIXX_POLBASIC.cred_branch%TYPE,
    dsp_cred_branch VARCHAR2(50),
    prem_amt        GIXX_POLBASIC.prem_amt%TYPE,
    tsi_amt         GIXX_POLBASIC.tsi_amt%TYPE,
    pack_pol_flag   GIXX_POLBASIC.pack_pol_flag%TYPE,
    auto_renew_flag GIXX_POLBASIC.auto_renew_flag%TYPE,
    foreign_acc_sw  GIXX_POLBASIC.foreign_acc_sw%TYPE,
    reg_policy_sw   GIXX_POLBASIC.reg_policy_sw%TYPE,
    prem_warr_tag   GIXX_POLBASIC.prem_warr_tag%TYPE,
    co_insurance_sw GIXX_POLBASIC.co_insurance_sw%TYPE,
    dsp_label_tag   VARCHAR2(100),
    policy_id_type  VARCHAR2(10),
    line_type       VARCHAR2(100), -- if marine line or not  (to display the marine detail button)
    bank_btn_label  VARCHAR2(100), -- to determine the value of bank button
    default_currency          VARCHAR2(5),  
    is_foreign_currency         VARCHAR2(1),
    dsp_rate                    VARCHAR2(100), --  **LEAD canvas
    variables_subline_open  giis_subline.subline_cd%TYPE,
    variables_subline_mop   giis_subline.subline_cd%TYPE,
    
    contract_proj_buss_title    gixx_engg_basic.contract_proj_buss_title%TYPE,
    site_location               gixx_engg_basic.site_location%TYPE,
    construct_start_date        gixx_engg_basic.construct_start_date%TYPE,
    construct_end_date          gixx_engg_basic.construct_end_date%TYPE,
    maintain_start_date         gixx_engg_basic.maintain_start_date%TYPE,
    maintain_end_date           gixx_engg_basic.maintain_end_date%TYPE,
    mbi_policy_no               gixx_engg_basic.mbi_policy_no%TYPE,
    weeks_test                  gixx_engg_basic.weeks_test%TYPE,
    time_excess                 gixx_engg_basic.time_excess%TYPE,
    prompt_title              VARCHAR2(100),
    prompt_location           VARCHAR2(100),
    subline_cd_param            giis_parameters.param_name%TYPE, --added by robert SR 20307 10.27.15 
    -- for marine details
    survey_agent_cd             GIXX_POLBASIC.SURVEY_AGENT_CD%TYPE,
    survey_agent                VARCHAR2(1000),
    settling_agent_cd           GIXX_POLBASIC.SETTLING_AGENT_CD%TYPE,
    settling_agent              VARCHAR2(1000)    
--    lead_sw         
  );
  
  TYPE gixx_polbasic_tab2 IS TABLE OF gixx_polbasic_type2;
  
 
  FUNCTION get_policy_summary(
    p_iss_cd        GIXX_POLBASIC.iss_cd%TYPE,
    p_line_cd       GIXX_POLBASIC.line_cd%TYPE,
    p_subline_cd    GIXX_POLBASIC.subline_cd%TYPE,
    p_issue_yy      GIXX_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no    GIXX_POLBASIC.pol_seq_no%TYPE,
    p_renew_no      GIXX_POLBASIC.renew_no%TYPE,
    p_ref_pol_no    GIXX_POLBASIC.ref_pol_no%TYPE
  ) RETURN gixx_polbasic_tab2 PIPELINED;
  
  
  TYPE gixx_polbasic_su_type IS RECORD (
      extract_id            gixx_polbasic.extract_id%TYPE,
      policy_id             gixx_polbasic.policy_id%TYPE,
      address1              gixx_polbasic.address1%TYPE,
      address2              gixx_polbasic.address2%TYPE,
      address3              gixx_polbasic.address3%TYPE,
      industry_nm           giis_industry.industry_nm%TYPE,
      region_desc           giis_region.region_desc%TYPE,
      --takeup_term_desc      giis_takeup_term.takeup_term_desc%TYPE,
      incept_date           gixx_polbasic.incept_date%TYPE,
      expiry_date           gixx_polbasic.expiry_date%TYPE,
      issue_date            gixx_polbasic.issue_date%TYPE,
      eff_date              gixx_polbasic.eff_date%TYPE,
      --endt_expiry_date      gixx_polbasic.endt_expiry_date%TYPE,
      ref_pol_no            gixx_polbasic.ref_pol_no%TYPE,
      incept_tag            gixx_polbasic.incept_tag%TYPE,
      expiry_tag            gixx_polbasic.expiry_tag%TYPE,
      --bancassurance_sw      gixx_polbasic.bancassurance_sw%TYPE,
      reg_policy_sw         gixx_polbasic.reg_policy_sw%TYPE,
      auto_renew_flag       gixx_polbasic.auto_renew_flag%TYPE,
      --prompt_text           VARCHAR2 (50),
      --dsp_endt_expiry_date  VARCHAR2 (50),
      pol_flag              gixx_polbasic.pol_flag%TYPE,
      subline_cd            gixx_polbasic.subline_cd%TYPE,
      line_cd               gixx_polbasic.line_cd%TYPE,
      --endt_seq_no           gixx_polbasic.endt_seq_no%TYPE,
      mortg_name            gixx_polbasic.mortg_name%TYPE,
      val_period            gixx_bond_basic.val_period%TYPE,
      val_period_unit       gixx_bond_basic.val_period_unit%TYPE,
      pol_flag_desc         VARCHAR(50)
  );
  
  TYPE gixx_polbasic_su_tab IS TABLE OF gixx_polbasic_su_type;
  
  FUNCTION get_policy_summary_su(
    p_iss_cd        GIXX_POLBASIC.iss_cd%TYPE,
    p_line_cd       GIXX_POLBASIC.line_cd%TYPE,
    p_subline_cd    GIXX_POLBASIC.subline_cd%TYPE,
    p_issue_yy      GIXX_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no    GIXX_POLBASIC.pol_seq_no%TYPE,
    p_renew_no      GIXX_POLBASIC.renew_no%TYPE,
    p_ref_pol_no    GIXX_POLBASIC.ref_pol_no%TYPE
  ) RETURN gixx_polbasic_su_tab PIPELINED;
  -- end: for GIPIS101

END GIXX_POLBASIC_PKG; 
/


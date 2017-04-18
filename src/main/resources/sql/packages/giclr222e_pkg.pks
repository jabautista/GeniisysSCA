CREATE OR REPLACE PACKAGE CPI.GICLR222E_PKG
AS

    TYPE header_type IS RECORD(
        company_name        giac_parameters.PARAM_VALUE_V%type,
        company_address     giis_parameters.PARAM_VALUE_V%type,
        report_title        giis_reports.REPORT_TITLE%type,
        paramdate           VARCHAR2(100),
        date_period         VARCHAR2(100)
    );
    
    TYPE header_tab IS TABLE OF header_type; 
    
    TYPE report_details_type IS RECORD(
        policy_no           GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        cf_policy           VARCHAR2(60),
        assd_no             GICL_RES_BRDRX_EXTR.ASSD_NO%type,
        assd_name           GIIS_ASSURED.ASSD_NAME%type,
        incept_date         GICL_RES_BRDRX_EXTR.INCEPT_DATE%type,
        expiry_date         GICL_RES_BRDRX_EXTR.EXPIRY_DATE%type,
        term                VARCHAR2(30),
        claim_id            GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        line_cd             GICL_RES_BRDRX_EXTR.LINE_CD%type,
        claim_no            GICL_RES_BRDRX_EXTR.CLAIM_NO%type,
        loss_date           GICL_RES_BRDRX_EXTR.LOSS_DATE%type,
        clm_file_date       GICL_RES_BRDRX_EXTR.CLM_FILE_DATE%type,
        clm_loss_id         GICL_RES_BRDRX_EXTR.CLM_LOSS_ID%type,
        item_no             GICL_RES_BRDRX_EXTR.ITEM_NO%type,
        item_title          VARCHAR2(200),
        grouped_item_no     GICL_RES_BRDRX_EXTR.GROUPED_ITEM_NO%type,
        peril_cd            GICL_RES_BRDRX_EXTR.PERIL_CD%type,
        --peril_name          GIIS_PERIL.PERIL_NAME%TYPE,
        loss_cat_cd         GICL_RES_BRDRX_EXTR.LOSS_CAT_CD%type,
        loss_cat_des        GIIS_LOSS_CTGRY.LOSS_CAT_DES%type,
        paid_losses         GICL_RES_BRDRX_EXTR.LOSSES_PAID%type,
        intm_no             GICL_RES_BRDRX_EXTR.INTM_NO%type,
        tsi_amt             GICL_RES_BRDRX_EXTR.TSI_AMT%type,
        cf_intm             VARCHAR2(200),
        cf_intm_ri          VARCHAR2(1000),
        cf_dv_no            VARCHAR2(500),
        brdrx_record_id     GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%type
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    TYPE treaty_header_type IS RECORD( 
        policy_no           GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        treaty_name         GIIS_DIST_SHARE.TRTY_NAME%type,
        line_cd             GICL_RES_BRDRX_DS_EXTR.LINE_CD%type, 
        grp_seq_no          GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%type  
    );
        
    TYPE treaty_header_tab IS TABLE OF treaty_header_type;
    
    
    TYPE treaty_details_type IS RECORD(
        policy_no           GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        claim_id            GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        treaty_name         GIIS_DIST_SHARE.TRTY_NAME%type,
        brdrx_record_id     GICL_RES_BRDRX_DS_EXTR.BRDRX_RECORD_ID%type,
        brdrx_ds_record_id  GICL_RES_BRDRX_DS_EXTR.BRDRX_DS_RECORD_ID%type,
        grp_seq_no          GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%type,
        shr_pct             GICL_RES_BRDRX_DS_EXTR.SHR_PCT%type,
        paid_losses         GICL_RES_BRDRX_DS_EXTR.LOSSES_PAID%type,         
        
        facul_ri_cd         GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type,
        facul_ri_name       GIIS_REINSURER.RI_NAME%TYPE,
        facul_shr_ri_pct    GICL_RES_BRDRX_RIDS_EXTR.SHR_RI_PCT%type,
        paid_losses2        GICL_RES_BRDRX_RIDS_EXTR.LOSSES_PAID%type      
    );
    
    TYPE treaty_details_tab IS TABLE OF treaty_details_type;
    
    
    TYPE treaty_ri_type IS RECORD (
        policy_no               GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        grp_seq_no              GICL_RES_BRDRX_RIDS_EXTR.GRP_SEQ_NO%type,
        brdrx_rids_record_id    GICL_RES_BRDRX_RIDS_EXTR.BRDRX_RIDS_RECORD_ID%type,
        line_cd                 GICL_RES_BRDRX_RIDS_EXTR.LINE_CD%type,
        treaty_name             GIIS_DIST_SHARE.TRTY_NAME%type,
        trty_ri_cd              GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type,
        ri_cd                   GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type,
        ri_name                 GIIS_REINSURER.RI_NAME%TYPE,
        trty_shr_pct            GIIS_TRTY_PANEL.TRTY_SHR_PCT%type
    );
    
    TYPE treaty_ri_tab IS TABLE OF treaty_ri_type;
    
    
    TYPE treaty_ri_amt_type IS RECORD(
        policy_no               GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        grp_seq_no              GICL_RES_BRDRX_RIDS_EXTR.GRP_SEQ_NO%type,
        brdrx_rids_record_id    GICL_RES_BRDRX_RIDS_EXTR.BRDRX_RIDS_RECORD_ID%type,
        line_cd                 GICL_RES_BRDRX_RIDS_EXTR.LINE_CD%type,
        treaty_name             GIIS_DIST_SHARE.TRTY_NAME%type,
        trty_ri_cd              GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type,
        ri_cd                   GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type,
        ri_name                 GIIS_REINSURER.RI_NAME%TYPE,
        trty_shr_pct            GIIS_TRTY_PANEL.TRTY_SHR_PCT%type,
        paid_losses3            GICL_RES_BRDRX_RIDS_EXTR.LOSSES_PAID%TYPE
    );
    
    TYPE treaty_ri_amt_tab IS TABLE OF treaty_ri_amt_type;
    
    
    FUNCTION CF_companyFormula
        RETURN VARCHAR2;
        
    FUNCTION CF_com_addressFormula
        RETURN VARCHAR2;
        
    FUNCTION REPORT_NAMEFormula
        RETURN VARCHAR2;
        
    FUNCTION CF_paramdateFormula(
        p_paid_date     NUMBER
    ) RETURN VARCHAR2;
    
    FUNCTION CF_dateFormula(
        p_from_date     DATE,
        p_to_date       DATE
    ) RETURN VARCHAR2;
    
    FUNCTION get_report_header(
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE
    ) RETURN header_tab PIPELINED;

    FUNCTION CF_POLICYFormula(
        p_policy_no     GICL_RES_BRDRX_EXTR.POLICY_NO%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION ITEM_TITLEFormula(
        p_claim_id             GICL_CLAIMS.claim_id%TYPE,
        p_line_cd              GICL_CLAIMS.line_cd%TYPE,
        p_item_no              gicl_accident_dtl.item_no%TYPE,
        p_grouped_item_no      gicl_accident_dtl.grouped_item_no%TYPE
    ) RETURN VARCHAR2;
        
    
    FUNCTION LOSS_CAT_DESFormula(
        p_loss_cat_cd   GIIS_LOSS_CTGRY.LOSS_CAT_CD%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_INTMFormula(
        p_claim_id      gicl_intm_itmperil.CLAIM_ID%type,
        p_item_no       gicl_intm_itmperil.ITEM_NO%type,
        p_peril_cd      gicl_intm_itmperil.PERIL_CD%type    
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_INTM_RIFormula(
        p_claim_id      gicl_intm_itmperil.CLAIM_ID%type,
        p_item_no       gicl_intm_itmperil.ITEM_NO%type,
        p_peril_cd      gicl_intm_itmperil.PERIL_CD%type
    ) RETURN VARCHAR2;
    
        
    FUNCTION CF_DV_NOFormula(
        p_claim_id      gicl_clm_res_hist.CLAIM_ID%type,
        p_item_no       giac_chk_disbursement.ITEM_NO%type,
        p_clm_loss_id   gicl_clm_res_hist.CLM_LOSS_ID%type,    
        p_paid_losses   GICL_RES_BRDRX_EXTR.LOSSES_PAID%type,
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE
    )RETURN VARCHAR2;
    
    
    FUNCTION PERIL_NAMEFormula(
        p_peril_cd  GIIS_PERIL.PERIL_CD%type,
        p_line_cd   GIIS_PERIL.LINE_CD%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION ASSD_NAMEFormula(
        p_assd_no       GIIS_ASSURED.ASSD_NO%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION get_report_details(
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_policy_no     GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE
    ) RETURN report_details_tab PIPELINED;
    
    
    FUNCTION TREATY_NAMEFormula(
        p_grp_seq_no    GIIS_DIST_SHARE.SHARE_CD%type,    
        p_line_cd       GIIS_DIST_SHARE.LINE_CD%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION FACUL_RI_NAMEFormula(
        p_facul_ri_cd   GIIS_REINSURER.RI_CD%type
    )RETURN VARCHAR2;
    
    
    FUNCTION get_treaty_header(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_claim_id          GICL_RES_BRDRX_DS_EXTR.CLAIM_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type
    )RETURN treaty_header_tab PIPELINED;
    
    
     FUNCTION get_treaty_details(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_claim_id          GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        p_brdrx_record_id   GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%type
    ) RETURN treaty_details_tab PIPELINED;
    
    
    FUNCTION get_treaty_facul(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_claim_id          GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        p_brdrx_record_id   GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%type
    ) RETURN treaty_details_tab PIPELINED;
    
    
    FUNCTION RI_SHRFormula(
        p_line_cd       giis_trty_panel.LINE_CD%type,  
        p_grp_seq_no    giis_trty_panel.TRTY_SEQ_NO%type,  
        p_ri_cd         giis_trty_panel.RI_CD%type         
    ) RETURN NUMBER;
    
    
    FUNCTION get_treaty_ri(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_claim_id          GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type
    ) RETURN treaty_ri_tab PIPELINED;
    
    
    FUNCTION get_treaty_ri_amt(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_claim_id          GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        p_ri_cd             GICL_RES_BRDRX_RIDS_EXTR.RI_CD%TYPE
    ) RETURN treaty_ri_amt_tab PIPELINED;
    
   TYPE giclr222e_header_type IS RECORD(
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      policy_no_dummy      VARCHAR2(50),
      ref_pol_no           GICL_RES_BRDRX_EXTR.ref_pol_no%TYPE,
      assd_no              GICL_RES_BRDRX_EXTR.assd_no%TYPE,
      incept_date          GICL_RES_BRDRX_EXTR.incept_date%TYPE,
      expiry_date          GICL_RES_BRDRX_EXTR.expiry_date%TYPE,
      term                 VARCHAR2(100),
      assd_name            GIIS_ASSURED.assd_name%TYPE,
      grp_seq_no1          GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      grp_seq_no2          GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      grp_seq_no3          GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      grp_seq_no4          GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      treaty1              GIIS_DIST_SHARE.trty_name%TYPE,
      treaty2              GIIS_DIST_SHARE.trty_name%TYPE,
      treaty3              GIIS_DIST_SHARE.trty_name%TYPE,
      treaty4              GIIS_DIST_SHARE.trty_name%TYPE
   );
   TYPE giclr222e_header_tab IS TABLE OF giclr222e_header_type;
   
   TYPE treaty_type IS RECORD(
      grp_seq_no           GIIS_DIST_SHARE.share_cd%TYPE,
      trty_name            GIIS_DIST_SHARE.trty_name%TYPE
   );
   TYPE treaty_tab IS TABLE OF treaty_type;
   
   TYPE giclr222e_detail_type IS RECORD(
      record_id            GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      line_cd              GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      loss_date            GICL_RES_BRDRX_EXTR.loss_date%TYPE,
      clm_file_date        GICL_RES_BRDRX_EXTR.clm_file_date%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      grouped_item_no      GICL_RES_BRDRX_EXTR.grouped_item_no%TYPE,
      peril_cd             GICL_RES_BRDRX_EXTR.peril_cd%TYPE,
      loss_cat_cd          GICL_RES_BRDRX_EXTR.loss_cat_cd%TYPE,
      tsi_amt              GICL_RES_BRDRX_EXTR.tsi_amt%TYPE,
      intm_no              GICL_RES_BRDRX_EXTR.intm_no%TYPE,
      clm_loss_id          GICL_RES_BRDRX_EXTR.clm_loss_id%TYPE,
      paid_losses          GICL_RES_BRDRX_EXTR.expenses_paid%TYPE
   );
   TYPE giclr222e_detail_tab IS TABLE OF giclr222e_detail_type;
   
   TYPE giclr222e_claim_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      loss_date            GICL_RES_BRDRX_EXTR.loss_date%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE
   );
   TYPE giclr222e_claim_tab IS TABLE OF giclr222e_claim_type;
   
   TYPE giclr222e_item_main_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      loss_date            GICL_RES_BRDRX_EXTR.loss_date%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      item_title           VARCHAR2(250)
   );
   TYPE giclr222e_item_main_tab IS TABLE OF giclr222e_item_main_type;
   
   TYPE giclr222e_item_type IS RECORD(
      record_id            GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      loss_date            GICL_RES_BRDRX_EXTR.loss_date%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      clm_loss_id          GICL_RES_BRDRX_EXTR.clm_loss_id%TYPE,
      tsi_amt              GICL_RES_BRDRX_EXTR.tsi_amt%TYPE,
      loss_cat_cd          GICL_RES_BRDRX_EXTR.loss_cat_cd%TYPE,
      loss_cat_desc        GIIS_LOSS_CTGRY.loss_cat_des%TYPE,
      intm_no              GICL_RES_BRDRX_EXTR.intm_no%TYPE,
      intm_name            GIIS_INTERMEDIARY.intm_name%TYPE,
      paid_losses          GICL_RES_BRDRX_EXTR.expenses_paid%TYPE,
      dv_no                VARCHAR2(150),
      peril_cd             GICL_RES_BRDRX_EXTR.peril_cd%TYPE
   );
   TYPE giclr222e_item_tab IS TABLE OF giclr222e_item_type;
   
   TYPE paid_losses_type IS RECORD(
      paid_losses1         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses2         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses3         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses4         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      ds_record_id         GICL_RES_BRDRX_DS_EXTR.brdrx_ds_record_id%TYPE
   );
   TYPE paid_losses_tab IS TABLE OF paid_losses_type;
   
   TYPE paid_losses_type_v IS RECORD(
      paid_losses1         VARCHAR2(1000),
      paid_losses2         VARCHAR2(1000),
      paid_losses3         VARCHAR2(1000),
      paid_losses4         VARCHAR2(1000)
   );
   TYPE paid_losses_tab_v IS TABLE OF paid_losses_type_v;
   
   TYPE facul_type IS RECORD(
      ri_name1             GIIS_REINSURER.ri_sname%TYPE,
      ri_name2             GIIS_REINSURER.ri_sname%TYPE,
      ri_name3             GIIS_REINSURER.ri_sname%TYPE,
      ri_name4             GIIS_REINSURER.ri_sname%TYPE,
      paid_losses1         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses2         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses3         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses4         GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE facul_tab IS TABLE OF facul_type;
   
   TYPE treaty_ri_type2 IS RECORD (
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      grp_seq_no           GICL_RES_BRDRX_RIDS_EXTR.grp_seq_no%TYPE,
      brdrx_rids_record_id GICL_RES_BRDRX_RIDS_EXTR.brdrx_rids_record_id%TYPE,
      line_cd              GICL_RES_BRDRX_RIDS_EXTR.line_cd%TYPE,
      treaty_name          GIIS_DIST_SHARE.trty_name%TYPE,
      trty_ri_cd           GICL_RES_BRDRX_RIDS_EXTR.ri_cd%TYPE,
      ri_cd                GICL_RES_BRDRX_RIDS_EXTR.ri_cd%TYPE,
      ri_name              GIIS_REINSURER.ri_name%TYPE,
      trty_shr_pct         GIIS_TRTY_PANEL.trty_shr_pct%TYPE,
      paid_losses          GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE treaty_ri_tab2 IS TABLE OF treaty_ri_type2;
     
   FUNCTION get_giclr222e_header(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN giclr222e_header_tab PIPELINED;
     
   FUNCTION get_giclr222e_claim(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE
   )
     RETURN giclr222e_claim_tab PIPELINED;
   
   FUNCTION get_giclr222e_item_main(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE
   )
     RETURN giclr222e_item_main_tab PIPELINED;
   
   FUNCTION get_giclr222e_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_paid_date          NUMBER,
      p_from_date          DATE,
      p_to_date            DATE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE
   )
     RETURN giclr222e_item_tab PIPELINED;
   
   FUNCTION get_giclr222e_treaty(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN paid_losses_tab PIPELINED;
     
   FUNCTION get_giclr222e_facul(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_ds_record_id       GICL_RES_BRDRX_DS_EXTR.brdrx_ds_record_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN facul_tab PIPELINED;
     
   FUNCTION get_giclr222e_loss_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN NUMBER;
     
   FUNCTION get_giclr222e_treaty_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN paid_losses_tab_v PIPELINED;
   
   FUNCTION get_treaty_ri2(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no          GICL_RES_BRDRX_EXTR.policy_no%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED;
     
   FUNCTION get_treaty_facul2(
      p_session_id          GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id            GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_policy_no           GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_brdrx_record_id     GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE
   )
     RETURN treaty_details_tab PIPELINED;
    
END GICLR222E_PKG;
/



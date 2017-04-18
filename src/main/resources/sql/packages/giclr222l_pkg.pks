CREATE OR REPLACE PACKAGE CPI.GICLR222L_PKG
AS

    TYPE header_type IS RECORD(
        company_name        giac_parameters.PARAM_VALUE_V%type,
        company_address     giis_parameters.PARAM_VALUE_V%type,
        report_title        giis_reports.REPORT_TITLE%type,
        paramdate           VARCHAR2(100),
        date_period         VARCHAR2(100),
        grand_total         NUMBER
    );
    
    TYPE header_tab IS TABLE OF header_type;    
    
    TYPE treaty_header_type IS RECORD( 
        policy_no           GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        treaty_name         GIIS_DIST_SHARE.TRTY_NAME%type,
        line_cd             GICL_RES_BRDRX_DS_EXTR.LINE_CD%type, 
        grp_seq_no          GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%type  
    );
        
    TYPE treaty_header_tab IS TABLE OF treaty_header_type;          
    
    TYPE treaty_ri_type IS RECORD (
        policy_no               GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        grp_seq_no              GICL_RES_BRDRX_RIDS_EXTR.GRP_SEQ_NO%type,
        brdrx_rids_record_id    GICL_RES_BRDRX_RIDS_EXTR.BRDRX_RIDS_RECORD_ID%type,
        line_cd                 GICL_RES_BRDRX_RIDS_EXTR.LINE_CD%type,
        treaty_name             GIIS_DIST_SHARE.TRTY_NAME%type,
        trty_ri_cd              GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type,
        ri_cd                   GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type,
        ri_name                 GIIS_REINSURER.RI_NAME%TYPE,
        trty_shr_pct            GIIS_TRTY_PANEL.TRTY_SHR_PCT%type,
        paid_losses             gicl_res_brdrx_rids_extr.losses_paid%type
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
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE
    ) RETURN header_tab PIPELINED;
    
    
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
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        p_header_part       NUMBER
    )RETURN treaty_header_tab PIPELINED;
     
    FUNCTION get_treaty_ri(
        p_session_id        GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
        p_policy_no         GICL_RES_BRDRX_EXTR.POLICY_NO%type
    ) RETURN treaty_ri_tab PIPELINED;
        
    TYPE pol_type IS RECORD (
        dummy_pol_no        GICL_RES_BRDRX_EXTR.POLICY_NO%type,
        policy_no           GICL_RES_BRDRX_EXTR.POLICY_NO%type,        
        assd_no             GICL_RES_BRDRX_EXTR.ASSD_NO%type,
        assd_name           GIIS_ASSURED.assd_name%TYPE,
        incept_date         VARCHAR2(10),
        expiry_date         VARCHAR2(10),    
        brdrx_record_id     GICL_RES_BRDRX_EXTR.brdrx_record_id%type,
        claim_id            GICL_RES_BRDRX_EXTR.claim_id%type, 
        line_cd             GICL_RES_BRDRX_EXTR.line_cd%type,
        claim_no            GICL_RES_BRDRX_EXTR.claim_no%type,
        loss_date           GICL_RES_BRDRX_EXTR.loss_date%type,
        clm_file_date       GICL_RES_BRDRX_EXTR.clm_file_date%type,
        item_no             GICL_RES_BRDRX_EXTR.item_no%type,
        grouped_item_no     GICL_RES_BRDRX_EXTR.grouped_item_no%type,
        peril_cd            GICL_RES_BRDRX_EXTR.peril_cd%type,
        loss_cat_cd         GICL_RES_BRDRX_EXTR.loss_cat_cd%type,
        tsi_amt             GICL_RES_BRDRX_EXTR.tsi_amt%type,
        intm_no             GICL_RES_BRDRX_EXTR.intm_no%type,
        clm_loss_id         GICL_RES_BRDRX_EXTR.clm_loss_id%type,
        paid_losses         GICL_RES_BRDRX_EXTR.losses_paid%type,
        cf_intm_ri          VARCHAR2(1000),
        cf_dv_no            VARCHAR2(500),
        item_title          VARCHAR2(200),
        header_part         NUMBER(1),
        loss_cat_des        GIIS_LOSS_CTGRY.LOSS_CAT_DES%type,
        ref_pol_no          GICL_RES_BRDRX_EXTR.ref_pol_no%TYPE
    );
    
    TYPE pol_tab IS TABLE OF pol_type;
    
    FUNCTION get_claims (
       p_session_id   gicl_res_brdrx_ds_extr.session_id%TYPE,
       p_paid_date     NUMBER,
       p_from_date     DATE,
       p_to_date       DATE
    ) RETURN pol_tab PIPELINED;    
    
    FUNCTION get_items (
       p_session_id        gicl_res_brdrx_ds_extr.session_id%TYPE,
       p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
       p_paid_date     NUMBER,
       p_from_date     DATE,
       p_to_date       DATE
    )
       RETURN pol_tab PIPELINED;
    
    FUNCTION get_perils (
       p_session_id        gicl_res_brdrx_ds_extr.session_id%TYPE,
       p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
       p_item_no           gicl_res_brdrx_extr.item_no%TYPE,
       p_paid_date     NUMBER,
       p_from_date     DATE,
       p_to_date       DATE
    )
       RETURN pol_tab PIPELINED;
           
    TYPE treaty_details_type IS RECORD(
      brdrx_ds_record_id1   GICL_RES_BRDRX_DS_EXTR.BRDRX_DS_RECORD_ID%TYPE,
      paid_losses1          GICL_RES_BRDRX_DS_EXTR.LOSSES_PAID%type,
      brdrx_ds_record_id2   GICL_RES_BRDRX_DS_EXTR.BRDRX_DS_RECORD_ID%TYPE,
      paid_losses2          GICL_RES_BRDRX_DS_EXTR.LOSSES_PAID%type,
      brdrx_ds_record_id3   GICL_RES_BRDRX_DS_EXTR.BRDRX_DS_RECORD_ID%TYPE,
      paid_losses3          GICL_RES_BRDRX_DS_EXTR.LOSSES_PAID%type,
      brdrx_ds_record_id4   GICL_RES_BRDRX_DS_EXTR.BRDRX_DS_RECORD_ID%TYPE,
      paid_losses4          GICL_RES_BRDRX_DS_EXTR.LOSSES_PAID%type
    );
    
    TYPE treaty_details_tab IS TABLE OF treaty_details_type;
    
    FUNCTION get_treaty_details(
      p_session_id GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id GICL_RES_BRDRX_DS_EXTR.claim_id%TYPE,
      p_policy_no GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_header_part NUMBER,
      p_brdrx_record_id GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%TYPE,
      p_cf_dv_no VARCHAR2
    ) RETURN treaty_details_tab PIPELINED;

    TYPE facul_type IS RECORD(
      ri_sname1     giis_reinsurer.ri_sname%TYPE,
      paid_losses1  GICL_RES_BRDRX_DS_EXTR.LOSSES_PAID%type,
      ri_sname2     giis_reinsurer.ri_sname%TYPE,
      paid_losses2  GICL_RES_BRDRX_DS_EXTR.LOSSES_PAID%type,
      ri_sname3     giis_reinsurer.ri_sname%TYPE,
      paid_losses3  GICL_RES_BRDRX_DS_EXTR.LOSSES_PAID%type,
      ri_sname4     giis_reinsurer.ri_sname%TYPE,
      paid_losses4  GICL_RES_BRDRX_DS_EXTR.LOSSES_PAID%type
    );
    
    TYPE facul_tab IS TABLE OF facul_type;
    
    FUNCTION get_facul(
      p_session_id GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id GICL_RES_BRDRX_DS_EXTR.claim_id%TYPE,
      p_policy_no GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      p_header_part NUMBER,
      p_brdrx_ds_record_id GICL_RES_BRDRX_DS_EXTR.brdrx_ds_record_id%TYPE
    ) RETURN facul_tab PIPELINED;
    
END GICLR222L_PKG;
/



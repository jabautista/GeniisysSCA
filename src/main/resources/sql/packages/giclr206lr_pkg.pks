CREATE OR REPLACE PACKAGE CPI.GICLR206LR_PKG
AS

    TYPE header_type IS RECORD (
        cf_company          giac_parameters.PARAM_VALUE_V%type,
        cf_com_address      giis_parameters.PARAM_VALUE_V%type,
        cf_report_title     giis_reports.REPORT_TITLE%type,
        cf_paramdate        VARCHAR2(100),
        cf_date             VARCHAR2(100)
    );
    
    TYPE header_tab IS TABLE OF header_type;

    TYPE report_parent_type IS RECORD(
        v_exist                 VARCHAR2(1),
        buss_source_type        VARCHAR2(2),
        iss_type                VARCHAR2(2),
        buss_source             GICL_RES_BRDRX_EXTR.BUSS_SOURCE%TYPE,
        cf_buss_source_name     GIIS_INTM_TYPE.INTM_DESC%TYPE,
        cf_source_name          GIIS_INTERMEDIARY.INTM_NAME%TYPE,
        iss_cd                  GICL_RES_BRDRX_EXTR.ISS_CD%TYPE,        
        cf_iss_name             GIIS_ISSOURCE.ISS_NAME%TYPE,   
        line_cd                 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
        cf_line_name            GIIS_LINE.LINE_NAME%TYPE,   
        subline_cd              GICL_RES_BRDRX_EXTR.SUBLINE_CD%TYPE,
        cf_subline_name         GIIS_SUBLINE.SUBLINE_NAME%TYPE,
        loss_year               GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
        cf_label                VARCHAR2(200)
    );
    
    TYPE report_parent_tab IS TABLE OF report_parent_type;
    
    TYPE report_details_type IS RECORD(
        buss_source_type        VARCHAR2(2),
        iss_type                VARCHAR2(2),
        buss_source             GICL_RES_BRDRX_EXTR.BUSS_SOURCE%TYPE,
        iss_cd                  GICL_RES_BRDRX_EXTR.ISS_CD%TYPE, 
        line_cd                 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
        subline_cd              GICL_RES_BRDRX_EXTR.SUBLINE_CD%TYPE,
        loss_year               GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
        policy_no               GICL_RES_BRDRX_EXTR.POLICY_NO%TYPE,
        claim_no                GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
        cf_policy               VARCHAR2(60),
        cf_assd_name            GIIS_ASSURED.ASSD_NAME%TYPE,
        brdrx_record_id         GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%TYPE,
        claim_id                GICL_RES_BRDRX_EXTR.CLAIM_ID%TYPE,
        assd_no                 GICL_RES_BRDRX_EXTR.ASSD_NO%TYPE,
        incept_date             VARCHAR2(20),
        expiry_date             VARCHAR2(20),
        loss_date               VARCHAR2(20),
        clm_file_date           VARCHAR2(20),
        item_no                 GICL_RES_BRDRX_EXTR.ITEM_NO%TYPE,
        cf_item_title           VARCHAR2(200),
        grouped_item_no         GICL_RES_BRDRX_EXTR.GROUPED_ITEM_NO%TYPE,
        peril_cd                GICL_RES_BRDRX_EXTR.PERIL_CD%TYPE,
        cf_peril_name           GIIS_PERIL.PERIL_NAME%TYPE,
        loss_cat_cd             GICL_RES_BRDRX_EXTR.LOSS_CAT_CD%TYPE,
        cf_loss_cat_des         GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE,
        tsi_amt                 GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
        intm_no                 GICL_RES_BRDRX_EXTR.INTM_NO%TYPE,
        cf_intm                 VARCHAR2(200),
        cf_intm_ri              VARCHAR2(1000),
        clm_loss_id             GICL_RES_BRDRX_EXTR.CLM_LOSS_ID%TYPE,
        paid_losses             GICL_RES_BRDRX_EXTR.LOSSES_PAID%TYPE,
        cf_paid_losses          gicl_res_brdrx_extr.losses_paid%TYPE,
        cf_dv_no                VARCHAR2(500)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    TYPE treaty_header_type IS RECORD( 
        iss_cd              GICL_RES_BRDRX_DS_EXTR.ISS_CD%type,
        buss_source         GICL_RES_BRDRX_DS_EXTR.BUSS_SOURCE%type,
        line_cd             GICL_RES_BRDRX_DS_EXTR.LINE_CD%type, 
        subline_cd          GICL_RES_BRDRX_DS_EXTR.SUBLINE_CD%type,
        loss_year           GICL_RES_BRDRX_DS_EXTR.LOSS_YEAR%type,
        grp_seq_no          GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%type,
        treaty_name         GIIS_DIST_SHARE.TRTY_NAME%type  
    );
        
    TYPE treaty_header_tab IS TABLE OF treaty_header_type;
    
    TYPE treaty_details_type IS RECORD(
        claim_id                GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        buss_source             GICL_RES_BRDRX_EXTR.BUSS_SOURCE%TYPE,
        iss_cd                  GICL_RES_BRDRX_EXTR.ISS_CD%TYPE, 
        line_cd                 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
        subline_cd              GICL_RES_BRDRX_EXTR.SUBLINE_CD%TYPE,
        loss_year               GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
        treaty_name             GIIS_DIST_SHARE.TRTY_NAME%type,
        brdrx_record_id         GICL_RES_BRDRX_DS_EXTR.BRDRX_RECORD_ID%type,
        brdrx_ds_record_id      GICL_RES_BRDRX_DS_EXTR.BRDRX_DS_RECORD_ID%type,
        grp_seq_no              GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%type,
        shr_pct                 GICL_RES_BRDRX_DS_EXTR.SHR_PCT%type,
        paid_losses             GICL_RES_BRDRX_DS_EXTR.LOSSES_PAID%type, 
        cf_paid_losses2         gicl_res_brdrx_extr.losses_paid%TYPE,
        print_flg               VARCHAR2(1),
        
        -- for treaty_facul
        facul_ri_cd             GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type,
        facul_ri_name           GIIS_REINSURER.RI_NAME%TYPE,
        facul_shr_ri_pct        GICL_RES_BRDRX_RIDS_EXTR.SHR_RI_PCT%type,
        facul_paid_losses2      GICL_RES_BRDRX_RIDS_EXTR.LOSSES_PAID%type,
        facul_cf_paid_losses3   gicl_res_brdrx_rids_extr.losses_paid%TYPE
    );
    
    TYPE treaty_details_tab IS TABLE OF treaty_details_type;
    
    TYPE treaty_ri_type IS RECORD(
        buss_source_type        VARCHAR2(2),
        iss_type                VARCHAR2(2),
        buss_source             GICL_RES_BRDRX_EXTR.BUSS_SOURCE%TYPE,
        iss_cd                  GICL_RES_BRDRX_EXTR.ISS_CD%TYPE,   
        line_cd                 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
        subline_cd              GICL_RES_BRDRX_EXTR.SUBLINE_CD%TYPE,
        loss_year               GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE,
        grp_seq_no              GICL_RES_BRDRX_RIDS_EXTR.GRP_SEQ_NO%type,
        cf_treaty_name          GIIS_DIST_SHARE.TRTY_NAME%type,
        trty_ri_cd              GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type,
        cf_trty_ri_name         GIIS_REINSURER.RI_NAME%TYPE,
        ri_cd                   GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type,
        cf_ri_name              GIIS_REINSURER.RI_NAME%TYPE,
        trty_shr_pct            GIIS_TRTY_PANEL.TRTY_SHR_PCT%type,
        cf_ri_shr               giis_trty_panel.trty_shr_pct%type,
        shr_ri_pct              GICL_RES_BRDRX_RIDS_EXTR.SHR_RI_PCT%type,
        brdrx_rids_record_id    GICL_RES_BRDRX_RIDS_EXTR.BRDRX_RIDS_RECORD_ID%type,
        
        --for treaty_ri_amt
        ri_paid_losses3         GICL_RES_BRDRX_RIDS_EXTR.LOSSES_PAID%type,
        cf_paid_losses4         gicl_res_brdrx_rids_extr.losses_paid%TYPE
    );
    
    TYPE treaty_ri_tab IS TABLE OF treaty_ri_type;
    
    
    FUNCTION CF_COMPANYFormula
        RETURN VARCHAR2;
        
        
    FUNCTION CF_COM_ADDRESSFormula
        RETURN VARCHAR2;
        
    
    FUNCTION CF_REPORT_TITLEFormula
        RETURN VARCHAR2;
        
        
    FUNCTION CF_PARAMDATEFormula (
        p_paid_date     NUMBER
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_dateFormula(
        p_from_date     DATE,
        p_to_date       DATE
    ) RETURN VARCHAR2;
    
    
    FUNCTION get_report_header(
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE
    ) RETURN header_tab PIPELINED;    
        
    FUNCTION CF_BUSS_SOURCE_NAMEFormula (
        p_buss_source_type      GIIS_INTM_TYPE.INTM_TYPE%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_SOURCE_NAMEFormula(
        p_iss_type      VARCHAR2,
        p_buss_source   GIIS_REINSURER.RI_CD%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_ISS_NAMEFormula (
        p_iss_cd        GIIS_ISSOURCE.ISS_CD%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_LINE_NAMEFormula (
        p_line_cd       GIIS_LINE.LINE_CD%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_SUBLINE_NAMEFormula(
        p_line_cd       GIIS_SUBLINE.LINE_CD%type,
        p_subline_cd    GIIS_SUBLINE.SUBLINE_CD%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION get_report_parent(
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type    
    ) RETURN report_parent_tab PIPELINED;
    
    
    FUNCTION CF_POLICYFormula (
        p_claim_id      gicl_claims.CLAIM_ID%type,
        p_policy_no     GICL_RES_BRDRX_EXTR.POLICY_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_ASSD_NAMEFormula(
        p_assd_no       GIIS_ASSURED.ASSD_NO%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_ITEM_TITLEFormula(
        p_claim_id             GICL_CLAIMS.claim_id%TYPE,
        p_line_cd              GICL_CLAIMS.line_cd%TYPE,
        p_item_no              gicl_accident_dtl.item_no%TYPE,
        p_grouped_item_no      gicl_accident_dtl.grouped_item_no%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_PERIL_NAMEFormula(
        p_peril_cd      GIIS_PERIL.peril_cd%TYPE,
        p_line_cd       GIIS_PERIL.line_cd%type        
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_LOSS_CAT_DESFormula(
        p_loss_cat_cd       GIIS_LOSS_CTGRY.LOSS_CAT_CD%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_INTMFormula(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_item_no           gicl_res_brdrx_extr.ITEM_NO%type,
        p_peril_cd          gicl_res_brdrx_extr.PERIL_CD%type,
        p_intm_no           gicl_res_brdrx_extr.INTM_NO%type,
        p_intm_break        NUMBER    
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_INTM_RIFormula(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_item_no           gicl_res_brdrx_extr.ITEM_NO%type,
        p_peril_cd          gicl_res_brdrx_extr.PERIL_CD%type,
        p_intm_no           gicl_res_brdrx_extr.INTM_NO%type,
        p_intm_break        NUMBER        
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_DV_NOFormula(
        p_claim_id          gicl_clm_res_hist.CLAIM_ID%type,
        p_clm_loss_id       gicl_clm_res_hist.CLM_LOSS_ID%type,
        p_item_no           giac_chk_disbursement.ITEM_NO%type, 
        p_paid_losses       GICL_RES_BRDRX_EXTR.LOSSES_PAID%type,
        p_paid_date         NUMBER,
        p_from_date         DATE,
        p_to_date           DATE        
    ) RETURN VARCHAR2;
        
    
    FUNCTION CF_paid_lossesFormula(
        p_session_id    gicl_rcvry_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_rcvry_brdrx_extr.CLAIM_ID%type,
        p_buss_source   gicl_rcvry_brdrx_extr.BUSS_SOURCE%type,
        p_iss_cd        gicl_rcvry_brdrx_extr.ISS_CD%type,
        p_line_cd       gicl_rcvry_brdrx_extr.LINE_CD%type,
        p_subline_cd    gicl_rcvry_brdrx_extr.SUBLINE_CD%type,
        p_item_no       gicl_rcvry_brdrx_extr.ITEM_NO%type,
        p_peril_cd      gicl_rcvry_brdrx_extr.PERIL_CD%type,
        p_paid_losses   GICL_RES_BRDRX_EXTR.LOSSES_PAID%type   
    ) RETURN NUMBER;
    
    
    FUNCTION get_report_details(
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE,
        p_intm_break    NUMBER,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type,
        p_line_cd       GICL_RES_BRDRX_EXTR.LINE_CD%type,
        p_subline_cd    GICL_RES_BRDRX_EXTR.SUBLINE_CD%type,
        p_loss_year     GICL_RES_BRDRX_EXTR.LOSS_YEAR%type
    ) RETURN report_details_tab PIPELINED;
    
    
    FUNCTION CF_TREATY_NAMEFormula (
        p_grp_seq_no    GIIS_DIST_SHARE.SHARE_CD%type,
        p_line_cd       GIIS_DIST_SHARE.LINE_CD%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION get_treaty_header(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source       GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd            GICL_RES_BRDRX_DS_EXTR.ISS_CD%type,
        p_line_cd           GICL_RES_BRDRX_DS_EXTR.LINE_CD%type,
        p_subline_cd        GICL_RES_BRDRX_DS_EXTR.SUBLINE_CD%type,
        p_loss_year         GICL_RES_BRDRX_DS_EXTR.LOSS_YEAR%type
    ) RETURN treaty_header_tab PIPELINED;
    
    
    FUNCTION CF_PAID_LOSSES2Formula(
        p_session_id        gicl_rcvry_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_rcvry_brdrx_extr.CLAIM_ID%type,
        p_item_no           gicl_rcvry_brdrx_ds_extr.ITEM_NO%type,
        p_peril_cd          gicl_rcvry_brdrx_ds_extr.PERIL_CD%type,
        p_grp_seq_no        gicl_rcvry_brdrx_ds_extr.GRP_SEQ_NO%type,
        p_paid_losses       GICL_RES_BRDRX_DS_EXTR.LOSSES_PAID%type
    ) RETURN NUMBER; 
    
    
    FUNCTION get_treaty_details(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_brdrx_record_id   GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%type,
        p_buss_source       GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,        
        p_iss_cd            GICL_RES_BRDRX_DS_EXTR.ISS_CD%type,
        p_line_cd           GICL_RES_BRDRX_DS_EXTR.LINE_CD%type,
        p_subline_cd        GICL_RES_BRDRX_DS_EXTR.SUBLINE_CD%type,
        p_loss_year         GICL_RES_BRDRX_DS_EXTR.LOSS_YEAR%type
    ) RETURN treaty_details_tab PIPELINED;
    
    
    FUNCTION CF_RI_NAMEFormula (
        p_ri_cd     GIIS_REINSURER.RI_CD%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_PAID_LOSSES3Formula(
        p_session_id        gicl_rcvry_brdrx_rids_extr.SESSION_ID%type,
        p_claim_id          gicl_rcvry_brdrx_rids_extr.CLAIM_ID%type,
        p_item_no           gicl_rcvry_brdrx_rids_extr.ITEM_NO%type,
        p_peril_cd          gicl_rcvry_brdrx_rids_extr.PERIL_CD%type,
        p_facul_ri_cd       gicl_rcvry_brdrx_rids_extr.RI_CD%type,
        p_paid_losses       GICL_RES_BRDRX_RIDS_EXTR.LOSSES_PAID%type
    ) RETURN NUMBER;
    
    
    FUNCTION get_treaty_facul(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_brdrx_record_id   GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%type,
        p_buss_source       GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,        
        p_iss_cd            GICL_RES_BRDRX_DS_EXTR.ISS_CD%type,
        p_line_cd           GICL_RES_BRDRX_DS_EXTR.LINE_CD%type,
        p_subline_cd        GICL_RES_BRDRX_DS_EXTR.SUBLINE_CD%type,
        p_loss_year         GICL_RES_BRDRX_DS_EXTR.LOSS_YEAR%type        
    ) RETURN treaty_details_tab PIPELINED;
    
    
    FUNCTION CF_RI_SHRFormula(
        p_line_cd           giis_trty_panel.LINE_CD%TYPE,
        p_grp_seq_no        giis_trty_panel.TRTY_SEQ_NO%TYPE,
        p_ri_cd             giis_trty_panel.RI_CD%TYPE
    ) RETURN NUMBER;
    
    
    FUNCTION get_treaty_ri(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type,
        p_line_cd       GICL_RES_BRDRX_EXTR.LINE_CD%type,
        p_subline_cd    GICL_RES_BRDRX_EXTR.SUBLINE_CD%type,
        p_loss_year     GICL_RES_BRDRX_EXTR.LOSS_YEAR%type
    ) RETURN treaty_ri_tab PIPELINED;
    
    
    FUNCTION CF_PAID_LOSSES4Formula(
        p_session_id        gicl_rcvry_brdrx_rids_extr.SESSION_ID%type,
        p_claim_id          gicl_rcvry_brdrx_rids_extr.CLAIM_ID%type,
        p_item_no           gicl_rcvry_brdrx_rids_extr.ITEM_NO%type,
        p_peril_cd          gicl_rcvry_brdrx_rids_extr.PERIL_CD%type,
        p_grp_seq_no        gicl_rcvry_brdrx_rids_extr.GRP_SEQ_NO%type,
        p_ri_cd             gicl_rcvry_brdrx_rids_extr.RI_CD%type,
        p_paid_losses       GICL_RES_BRDRX_RIDS_EXTR.LOSSES_PAID%type
    ) RETURN NUMBER;
    
    
    FUNCTION get_treaty_ri_amt(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type,
        p_line_cd       GICL_RES_BRDRX_EXTR.LINE_CD%type,
        p_subline_cd    GICL_RES_BRDRX_EXTR.SUBLINE_CD%type,
        p_loss_year     GICL_RES_BRDRX_EXTR.LOSS_YEAR%type,
        p_ri_cd         GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type
    ) RETURN treaty_ri_tab PIPELINED;
    
   TYPE treaty_type IS RECORD(
      grp_seq_no           GIIS_DIST_SHARE.share_cd%TYPE,
      trty_name            GIIS_DIST_SHARE.trty_name%TYPE
   );
   TYPE treaty_tab IS TABLE OF treaty_type;
   
   TYPE paid_losses_type IS RECORD(
      paid_losses1         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses2         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses3         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      paid_losses4         GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      ds_record_id         GICL_RES_BRDRX_DS_EXTR.brdrx_ds_record_id%TYPE
   );
   TYPE paid_losses_tab IS TABLE OF paid_losses_type;
   
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
   
   TYPE treaty_ri_type2 IS RECORD(
      treaty_name          GIIS_DIST_SHARE.trty_name%TYPE,
      trty_shr_pct         GIIS_TRTY_PANEL.trty_shr_pct%TYPE,
      paid_losses          GICL_RES_BRDRX_EXTR.losses_paid%TYPE,
      ri_name              GIIS_REINSURER.ri_sname%TYPE,
      grp_seq_no           GICL_RES_BRDRX_RIDS_EXTR.grp_seq_no%TYPE,
      ri_cd                GICL_RES_BRDRX_RIDS_EXTR.ri_cd%TYPE
   );
   TYPE treaty_ri_tab2 IS TABLE OF treaty_ri_type2;

   TYPE giclr206lr_main_type IS RECORD (
      dummy                NUMBER(10),
      iss_type             VARCHAR2(2),
      buss_source_type     VARCHAR2(2),
      iss_cd               giis_issource.iss_cd%TYPE,
      buss_source          gicl_res_brdrx_extr.buss_source%TYPE,
      line_cd              giis_line.line_cd%TYPE,
      subline_cd           giis_subline.subline_cd%TYPE,
      loss_year            gicl_res_brdrx_extr.loss_year%TYPE,
      buss_source_name     giis_intm_type.intm_desc%TYPE,
      source_name          giis_intermediary.intm_name%TYPE,
      iss_name             giis_issource.iss_name%TYPE,
      line_name            giis_line.line_name%TYPE,
      subline_name         giis_subline.subline_name%TYPE,
      grp_seq_no1          gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no2          gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no3          gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no4          gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      treaty1              giis_dist_share.trty_name%TYPE,
      treaty2              giis_dist_share.trty_name%TYPE,
      treaty3              giis_dist_share.trty_name%TYPE,
      treaty4              giis_dist_share.trty_name%TYPE
   );
   TYPE giclr206lr_main_tab IS TABLE OF giclr206lr_main_type;
   
   TYPE giclr206lr_detail_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      ref_pol_no           GICL_RES_BRDRX_EXTR.ref_pol_no%TYPE,
      incept_date          VARCHAR2(20),
      expiry_date          VARCHAR2(20),
      loss_date            VARCHAR2(20),
      assd_no              GICL_RES_BRDRX_EXTR.assd_no%TYPE,
      assd_name            GIIS_ASSURED.assd_name%TYPE
   );
   TYPE giclr206lr_detail_tab IS TABLE OF giclr206lr_detail_type;
   
   TYPE giclr206lr_item_type IS RECORD(
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      item_title           GICL_CLM_ITEM.item_title%TYPE,
      grouped_item_no      GICL_RES_BRDRX_EXTR.grouped_item_no%TYPE
   );
   TYPE giclr206lr_item_tab IS TABLE OF giclr206lr_item_type;
   
   TYPE giclr206lr_peril_type IS RECORD(
      tsi_amt              GICL_RES_BRDRX_EXTR.tsi_amt%TYPE,
      peril_cd             GICL_RES_BRDRX_EXTR.peril_cd%TYPE,
      peril_name           GIIS_PERIL.peril_name%TYPE,
      intm_cedant          VARCHAR2(10000),
      dv_no                VARCHAR2(1000),
      paid_losses          GICL_RES_BRDRX_EXTR.losses_paid%TYPE
   );
   TYPE giclr206lr_peril_tab IS TABLE OF giclr206lr_peril_type;
      
   FUNCTION get_giclr206lr_main(
      p_paid_date          NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_amt                VARCHAR2,
      p_intm_break         NUMBER,
      p_iss_break          NUMBER,
      p_subline_break      NUMBER
   )
     RETURN giclr206lr_main_tab PIPELINED;
   
   FUNCTION get_giclr206lr_detail(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN giclr206lr_detail_tab PIPELINED;
     
   FUNCTION get_giclr206lr_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_claim_no           GICL_RES_BRDRX_EXTR.claim_no%TYPE
   )
     RETURN giclr206lr_item_tab PIPELINED;
     
   FUNCTION get_giclr206lr_peril(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_claim_no           GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_grouped_item_no    GICL_RES_BRDRX_EXTR.grouped_item_no%TYPE,
      p_intm_break         NUMBER,
      p_paid_date          NUMBER,
      p_from_date          DATE,
      p_to_date            DATE
   )
     RETURN giclr206lr_peril_tab PIPELINED;
     
   FUNCTION get_giclr206lr_treaty(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_peril_cd           GICL_RES_BRDRX_EXTR.peril_cd%TYPE
   )
     RETURN paid_losses_tab PIPELINED;
     
   FUNCTION get_giclr206lr_facul(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_ds_record_id       GICL_RES_BRDRX_RIDS_EXTR.brdrx_ds_record_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_peril_cd           GICL_RES_BRDRX_EXTR.peril_cd%TYPE
   )
     RETURN facul_tab PIPELINED;
     
   FUNCTION get_giclr206lr_treaty_total(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE
   )
     RETURN paid_losses_tab PIPELINED;
     
   FUNCTION get_giclr206lr_treaty_ri(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED;
     
   FUNCTION get_giclr206lr_totals(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source_type   VARCHAR2,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN NUMBER;
     
   FUNCTION get_giclr206lr_total_loss(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN NUMBER;
    
END GICLR206LR_PKG;
/



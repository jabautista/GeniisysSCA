CREATE OR REPLACE PACKAGE CPI.GICLR205E_PKG
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
        loss_year               GICL_RES_BRDRX_EXTR.LOSS_YEAR%TYPE
    );
    
    TYPE report_parent_tab IS TABLE OF report_parent_type;
    
    TYPE report_details_type IS RECORD(
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
        outstanding_loss        GICL_RES_BRDRX_EXTR.EXPENSES_PAID%TYPE
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
        brdrx_record_id         GICL_RES_BRDRX_DS_EXTR.BRDRX_RECORD_ID%type,
        brdrx_ds_record_id      GICL_RES_BRDRX_DS_EXTR.BRDRX_DS_RECORD_ID%type,
        grp_seq_no              GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%type,
        treaty_name             GIIS_DIST_SHARE.TRTY_NAME%type,
        shr_pct                 GICL_RES_BRDRX_DS_EXTR.SHR_PCT%type,
        outstanding_loss2       GICL_RES_BRDRX_EXTR.EXPENSES_PAID%TYPE,
        print_flg               VARCHAR2(1),
        
        -- for treaty_facul
        facul_ri_cd             GICL_RES_BRDRX_RIDS_EXTR.RI_CD%type,
        facul_ri_name           GIIS_REINSURER.RI_NAME%TYPE,
        facul_shr_ri_pct        GICL_RES_BRDRX_RIDS_EXTR.SHR_RI_PCT%type,
        facul_outstanding_loss3 GICL_RES_BRDRX_RIDS_EXTR.EXPENSE_RESERVE%type
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
        cf_ri_shr               giis_trty_panel.trty_shr_pct%type,
        shr_ri_pct              GICL_RES_BRDRX_RIDS_EXTR.SHR_RI_PCT%type,
        cf_sum_ri_shr           NUMBER,
        brdrx_rids_record_id    GICL_RES_BRDRX_RIDS_EXTR.BRDRX_RIDS_RECORD_ID%type,
        
        --for treaty_ri_amt
        ri_outstanding_loss4    GICL_RES_BRDRX_RIDS_EXTR.EXPENSE_RESERVE%type
    );
    
    TYPE treaty_ri_tab IS TABLE OF treaty_ri_type;
    
    TYPE trty_type IS RECORD(
        buss_source_type        VARCHAR2(2),
        iss_type                VARCHAR2(2),
        buss_source             GICL_RES_BRDRX_EXTR.BUSS_SOURCE%TYPE,
        iss_cd                  GICL_RES_BRDRX_EXTR.ISS_CD%TYPE, 
        line_cd                 GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
        grp_seq_no              GICL_RES_BRDRX_DS_EXTR.GRP_SEQ_NO%type,
        trty_name               GIIS_DIST_SHARE.TRTY_NAME%type,
        outstanding_loss5       GICL_RES_BRDRX_EXTR.EXPENSES_PAID%TYPE 
    );
    
    TYPE trty_tab IS TABLE OF trty_type;
    
       
    FUNCTION get_report_header(
        p_date_option   NUMBER,
        p_from_date     DATE,
        p_to_date       DATE,
        p_as_of_date    DATE,
        p_os_date       NUMBER        
    ) RETURN header_tab PIPELINED;
    
    
    FUNCTION get_report_parent(
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type    
    ) RETURN report_parent_tab PIPELINED;
    
    
    FUNCTION get_report_details(
        p_session_id    GICL_RES_BRDRX_EXTR.SESSION_ID%type,
        p_claim_id      GICL_RES_BRDRX_EXTR.CLAIM_ID%type,
        p_intm_break    NUMBER,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type,
        p_line_cd       GICL_RES_BRDRX_EXTR.LINE_CD%type,
        p_subline_cd    GICL_RES_BRDRX_EXTR.SUBLINE_CD%type,
        p_loss_year     GICL_RES_BRDRX_EXTR.LOSS_YEAR%type
    ) RETURN report_details_tab PIPELINED;
    

    FUNCTION get_treaty_header(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source       GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd            GICL_RES_BRDRX_DS_EXTR.ISS_CD%type,
        p_line_cd           GICL_RES_BRDRX_DS_EXTR.LINE_CD%type,
        p_subline_cd        GICL_RES_BRDRX_DS_EXTR.SUBLINE_CD%type,
        p_loss_year         GICL_RES_BRDRX_DS_EXTR.LOSS_YEAR%type
    ) RETURN treaty_header_tab PIPELINED;
    
    
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
    
    
    FUNCTION get_treaty_ri(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type,
        p_line_cd       GICL_RES_BRDRX_EXTR.LINE_CD%type,
        p_subline_cd    GICL_RES_BRDRX_EXTR.SUBLINE_CD%type,
        p_loss_year     GICL_RES_BRDRX_EXTR.LOSS_YEAR%type
    ) RETURN treaty_ri_tab PIPELINED;
    
    
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
    
    
    FUNCTION get_trty_per_line(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type,
        p_line_cd       GICL_RES_BRDRX_EXTR.LINE_CD%type
    ) RETURN trty_tab PIPELINED;
    
    
    FUNCTION get_trty_per_iss(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type,
        p_iss_cd        GICL_RES_BRDRX_EXTR.ISS_CD%type
    ) RETURN trty_tab PIPELINED;
    
    
    FUNCTION get_trty_per_buss_source(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source   GICL_RES_BRDRX_EXTR.BUSS_SOURCE%type
    ) RETURN trty_tab PIPELINED;
    
    
    FUNCTION get_trty_per_buss_type(
        p_session_id        gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id          gicl_res_brdrx_extr.CLAIM_ID%type,
        p_buss_source_type  VARCHAR2
    ) RETURN trty_tab PIPELINED;
    
    
    FUNCTION get_trty_per_session_id(
        p_session_id    gicl_res_brdrx_extr.SESSION_ID%type,
        p_claim_id      gicl_res_brdrx_extr.CLAIM_ID%type
    ) RETURN trty_tab PIPELINED;       
    
    /* Handle running multipage column 03.04.2014 - J. Diago */
    TYPE giclr205e_parent_type IS RECORD (
      buss_source_type               giis_intermediary.intm_type%TYPE,
      buss_source_type_name          giis_intm_type.intm_desc%TYPE,
      iss_cd                         gicl_res_brdrx_extr.iss_cd%TYPE,
      buss_source                    gicl_res_brdrx_extr.buss_source%TYPE,
      buss_source_name               giis_reinsurer.ri_name%TYPE,
      iss_name                       giis_issource.iss_name%TYPE,
      line_cd                        gicl_res_brdrx_extr.line_cd%TYPE,
      line_name                      giis_line.line_name%TYPE,
      subline_cd                     gicl_res_brdrx_extr.subline_cd%TYPE,
      subline_name                   giis_subline.subline_name%TYPE,
      loss_year                      gicl_res_brdrx_extr.loss_year%TYPE,
      loss_year_dummy                VARCHAR2(10),
      grp_seq_no1                    gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no2                    gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no3                    gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      grp_seq_no4                    gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      treaty1                        giis_dist_share.trty_name%TYPE,
      treaty2                        giis_dist_share.trty_name%TYPE,
      treaty3                        giis_dist_share.trty_name%TYPE,
      treaty4                        giis_dist_share.trty_name%TYPE
   );
   TYPE giclr205e_parent_tab IS TABLE OF giclr205e_parent_type;
   
   TYPE treaty_type IS RECORD (
      grp_seq_no   giis_dist_share.share_cd%TYPE,
      trty_name    giis_dist_share.trty_name%TYPE
   );
   TYPE treaty_tab IS TABLE OF treaty_type;
   
   FUNCTION get_giclr205e_parent(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE
   )
     RETURN giclr205e_parent_tab PIPELINED;
     
   TYPE giclr205e_claim_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      assd_name            GIIS_ASSURED.assd_name%TYPE,
      incept_date          GICL_RES_BRDRX_EXTR.incept_date%TYPE,
      expiry_date          GICL_RES_BRDRX_EXTR.expiry_date%TYPE,
      loss_date            GICL_RES_BRDRX_EXTR.loss_date%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE
   );
   TYPE giclr205e_claim_tab IS TABLE OF giclr205e_claim_type;
   
   FUNCTION get_giclr205e_claim(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE
   )
     RETURN giclr205e_claim_tab PIPELINED;
     
   TYPE giclr205e_item_main_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      item_title           VARCHAR2(250),
      tsi_amt              GICL_RES_BRDRX_EXTR.tsi_amt%TYPE, --Added by carlo
      peril_name           GIIS_PERIL.peril_name%TYPE --Added by carlo
   );
   TYPE giclr205e_item_main_tab IS TABLE OF giclr205e_item_main_type;
   
   FUNCTION get_giclr205e_item_main(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE
   )
     RETURN giclr205e_item_main_tab PIPELINED;
     
   TYPE giclr205e_item_type IS RECORD(
      claim_id             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      claim_no             GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      policy_no            GICL_RES_BRDRX_EXTR.policy_no%TYPE,
      item_no              GICL_RES_BRDRX_EXTR.item_no%TYPE,
      --tsi_amt              GICL_RES_BRDRX_EXTR.tsi_amt%TYPE, comment out by carlo
      peril_name           GIIS_PERIL.peril_name%TYPE,
      intm_name            GIIS_INTERMEDIARY.intm_name%TYPE,
      outstanding_loss     GICL_RES_BRDRX_EXTR.expenses_paid%TYPE,
      brdrx_record_id      GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      intm_no              GICL_RES_BRDRX_EXTR.intm_no%TYPE --Added by carlo
   );
   TYPE giclr205e_item_tab IS TABLE OF giclr205e_item_type;
   
   FUNCTION get_giclr205e_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE
   )
     RETURN giclr205e_item_tab PIPELINED;
     
   TYPE outstanding_loss_type_v IS RECORD(
      outstanding_loss1       VARCHAR2(1000),
      outstanding_loss2       VARCHAR2(1000),
      outstanding_loss3       VARCHAR2(1000),
      outstanding_loss4       VARCHAR2(1000)
   );
   TYPE outstanding_loss_tab_v IS TABLE OF outstanding_loss_type_v;
   
   FUNCTION get_giclr205e_treaty(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE
   )
     RETURN outstanding_loss_tab_v PIPELINED;
     
   TYPE facul_type IS RECORD(
      ri_name1             GIIS_REINSURER.ri_sname%TYPE,
      ri_name2             GIIS_REINSURER.ri_sname%TYPE,
      ri_name3             GIIS_REINSURER.ri_sname%TYPE,
      ri_name4             GIIS_REINSURER.ri_sname%TYPE,
      outstanding_loss1    GICL_RES_BRDRX_EXTR.expenses_paid%TYPE,
      outstanding_loss2    GICL_RES_BRDRX_EXTR.expenses_paid%TYPE,
      outstanding_loss3    GICL_RES_BRDRX_EXTR.expenses_paid%TYPE,
      outstanding_loss4    GICL_RES_BRDRX_EXTR.expenses_paid%TYPE
   );
   TYPE facul_tab IS TABLE OF facul_type;
   
   FUNCTION get_giclr205e_facul(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE
   )
     RETURN facul_tab PIPELINED;
     
   TYPE total_os_loss_type IS RECORD(
      total_os_loss  GICL_RES_BRDRX_EXTR.expenses_paid%TYPE
   );
   TYPE total_os_loss_tab IS TABLE OF total_os_loss_type;
   
   FUNCTION get_giclr205e_os_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE
   )
     RETURN total_os_loss_tab PIPELINED;
     
   FUNCTION get_giclr205e_treaty_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE
   )
     RETURN outstanding_loss_tab_v PIPELINED;
     
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
      outstanding_loss     GICL_RES_BRDRX_EXTR.expenses_paid%TYPE
   );
   TYPE treaty_ri_tab2 IS TABLE OF treaty_ri_type2;
   
   FUNCTION get_treaty_ri2(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED;
     
   TYPE summary_treaty_type IS RECORD (
      outstanding_loss     GICL_RES_BRDRX_EXTR.expenses_paid%TYPE,
      trty_name            GIIS_DIST_SHARE.trty_name%TYPE
   );
   TYPE summary_treaty_tab IS TABLE OF summary_treaty_type;
   
   FUNCTION get_treaty_summary_line(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN summary_treaty_tab PIPELINED;
     
   FUNCTION get_treaty_summary_iss_source(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN summary_treaty_tab PIPELINED;
     
   FUNCTION get_treaty_summary_buss_source(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN summary_treaty_tab PIPELINED;
     
    FUNCTION get_treaty_summary_buss_type(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source_type   GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN summary_treaty_tab PIPELINED;
     
   FUNCTION get_treaty_summary_grand(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN summary_treaty_tab PIPELINED;
END GICLR205E_PKG;
/



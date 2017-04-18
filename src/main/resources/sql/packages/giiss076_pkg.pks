CREATE OR REPLACE PACKAGE CPI.GIISS076_PKG
AS
    
    TYPE iss_lov_type IS RECORD(
        iss_cd      GIIS_ISSOURCE.ISS_CD%type,
        iss_name    GIIS_ISSOURCE.ISS_NAME%type
    );
    
    TYPE iss_lov_tab IS TABLE OF iss_lov_type;
    
    
    FUNCTION get_iss_lov(
        p_user_id       VARCHAR2
    ) RETURN iss_lov_tab PIPELINED;
    
    
    TYPE parent_intm_lov_type IS RECORD(
        intm_no         giis_intermediary.intm_no%type,
        intm_name       giis_intermediary.intm_name%type,
        designation     giis_intermediary.designation%type,
        tin             giis_intermediary.tin%type
    );
    
    TYPE parent_intm_lov_tab IS TABLE OF parent_intm_lov_type;
    
    FUNCTION get_parent_intm_lov
        RETURN parent_intm_lov_tab PIPELINED;
        
    
    TYPE whtax_lov_type IS RECORD(
        whtax_id            giac_wholding_taxes.WHTAX_ID%type,
        gibr_branch_cd      giac_wholding_taxes.GIBR_BRANCH_CD%type,
        whtax_code          giac_wholding_taxes.WHTAX_CODE%type,
        whtax_desc          giac_wholding_taxes.WHTAX_DESC%type
    );
    
    TYPE whtax_lov_tab IS TABLE OF whtax_lov_type;
    
    FUNCTION get_whtax_lov(
        p_user_id       VARCHAR2
    ) RETURN whtax_lov_tab PIPELINED;
        
        
    TYPE co_intm_type_lov_type IS RECORD(
        co_intm_type        giis_co_intrmdry_types.CO_INTM_TYPE%type,
        type_name           giis_co_intrmdry_types.TYPE_NAME%type
    );
    
    TYPE co_intm_type_lov_tab IS TABLE OF co_intm_type_lov_type;
    
     FUNCTION get_co_intm_type_lov(
        p_iss_cd        giis_co_intrmdry_types.ISS_CD%type
     )  RETURN co_intm_type_lov_tab PIPELINED;
     
     
    TYPE payt_terms_lov_type IS RECORD(
        payt_terms          giis_payterm.PAYT_TERMS%type,
        payt_terms_desc     giis_payterm.PAYT_TERMS_DESC%type
    );
     
    TYPE payt_terms_lov_tab IS TABLE OF payt_terms_lov_type;
    
    FUNCTION get_payt_terms_lov
        RETURN payt_terms_lov_tab PIPELINED;
        

    TYPE rec_type IS RECORD (
        intm_no             GIIS_INTERMEDIARY.INTM_NO%type,
        ref_intm_cd         GIIS_INTERMEDIARY.REF_INTM_CD%type,
        ca_no               GIIS_INTERMEDIARY.CA_NO%type,
        ca_date             VARCHAR2(10),--GIIS_INTERMEDIARY.CA_DATE%type,
        designation         GIIS_INTERMEDIARY.DESIGNATION%type,
        intm_name           GIIS_INTERMEDIARY.INTM_NAME%type,
        parent_intm_no      GIIS_INTERMEDIARY.PARENT_INTM_NO%type,
        parent_designation  GIIS_INTERMEDIARY.DESIGNATION%type,
        parent_intm_name    GIIS_INTERMEDIARY.INTM_NAME%type,
        iss_cd              GIIS_INTERMEDIARY.ISS_CD%type,
        iss_name            GIIS_ISSOURCE.ISS_NAME%type,
        contact_person      GIIS_INTERMEDIARY.CONTACT_PERS%type,
        phone_no            GIIS_INTERMEDIARY.PHONE_NO%type,
        old_intm_no         GIIS_INTERMEDIARY.OLD_INTM_NO%type,
        whtax_id            GIIS_INTERMEDIARY.WHTAX_ID%type,
        whtax_code          GIAC_WHOLDING_TAXES.WHTAX_CODE%type,
        whtax_desc          GIAC_WHOLDING_TAXES.WHTAX_DESC%type,
        tin                 GIIS_INTERMEDIARY.TIN%type,
        wtax_rate           GIIS_INTERMEDIARY.WTAX_RATE%type,
        birthdate           VARCHAR2(10),--GIIS_INTERMEDIARY.BIRTHDATE%type,
        master_intm_no      GIIS_INTERMEDIARY.MASTER_INTM_NO%type,
        intm_type           GIIS_INTERMEDIARY.INTM_TYPE%type,
        intm_type_desc      GIIS_INTM_TYPE.INTM_DESC%type,
        co_intm_type        GIIS_INTERMEDIARY.CO_INTM_TYPE%type,
        co_intm_type_name   GIIS_CO_INTRMDRY_TYPES.TYPE_NAME%type,
        payt_terms          GIIS_INTERMEDIARY.PAYT_TERMS%type,
        payt_terms_desc     GIIS_PAYTERM.PAYT_TERMS_DESC%type,
        mail_addr1          GIIS_INTERMEDIARY.MAIL_ADDR1%type,
        mail_addr2          GIIS_INTERMEDIARY.MAIL_ADDR2%type,
        mail_addr3          GIIS_INTERMEDIARY.MAIL_ADDR3%type,
        bill_addr1          GIIS_INTERMEDIARY.BILL_ADDR1%type,
        bill_addr2          GIIS_INTERMEDIARY.BILL_ADDR2%type,
        bill_addr3          GIIS_INTERMEDIARY.BILL_ADDR3%type,
        prnt_intm_tin_sw    GIIS_INTERMEDIARY.PRNT_INTM_TIN_SW%type,
        special_rate        GIIS_INTERMEDIARY.SPECIAL_RATE%type,
        lf_tag              GIIS_INTERMEDIARY.LF_TAG%type,
        corp_tag            GIIS_INTERMEDIARY.CORP_TAG%type,
        active_tag          GIIS_INTERMEDIARY.ACTIVE_TAG%type,
        lic_tag             GIIS_INTERMEDIARY.LIC_TAG%type,
        input_vat_rate      GIIS_INTERMEDIARY.INPUT_VAT_RATE%type,
        nickname            GIIS_INTERMEDIARY.NICKNAME%type,
        email_add           GIIS_INTERMEDIARY.EMAIL_ADD%type,
        fax_no              GIIS_INTERMEDIARY.FAX_NO%type,
        cp_no               GIIS_INTERMEDIARY.CP_NO%type,
        sun_no              GIIS_INTERMEDIARY.SUN_NO%type,
        globe_no            GIIS_INTERMEDIARY.GLOBE_NO%type,
        smart_no            GIIS_INTERMEDIARY.SMART_NO%type,
        home_add            GIIS_INTERMEDIARY.HOME_ADD%type,
        remarks             GIIS_INTERMEDIARY.REMARKS%type,
        user_id             GIIS_INTERMEDIARY.USER_ID%type,
        last_update         VARCHAR2(30)
    );
    
    TYPE rec_tab IS TABLE OF rec_type;
    
    
    FUNCTION get_intm_record(
        p_intm_no       GIIS_INTERMEDIARY.INTM_NO%type
    )RETURN rec_tab PIPELINED;

    
    PROCEDURE set_rec(
        p_rec           IN  GIIS_INTERMEDIARY%rowtype,
        p_chg_item      IN  VARCHAR2,
        p_intm_type     IN  GIIS_INTERMEDIARY.intm_type%type,
        p_wtax_rate     IN  VARCHAR2, --GIIS_INTERMEDIARY.wtax_rate%type,
        p_record_status IN  VARCHAR2
    );
    
    PROCEDURE val_del_rec (
        p_intm_no   IN  GIIS_INTERMEDIARY.INTM_NO%type
    );
    
    PROCEDURE del_rec (
        p_intm_no   IN  GIIS_INTERMEDIARY.INTM_NO%type
    );

    TYPE master_intm_type IS RECORD(
        master_intm_no      GIIS_MASTER_INTM.MASTER_INTM_NO%type,
        intm_no             GIIS_MASTER_INTM.INTM_NO%type,
        old_intm_no         GIIS_MASTER_INTM.OLD_INTM_NO%type,
        intm_name           GIIS_INTERMEDIARY.INTM_NAME%type,
        user_id             GIIS_MASTER_INTM.USER_ID%type,
        last_update         VARCHAR2(30)
    );
    
    TYPE master_intm_tab IS TABLE OF master_intm_type;
    
    FUNCTION get_master_intm_details(
        p_master_intm_no        GIIS_INTERMEDIARY.MASTER_INTM_NO%type
    ) RETURN master_intm_tab PIPELINED;


    TYPE intm_hist_type IS RECORD(
        intm_no         GIIS_INTERMEDIARY_HIST.INTM_NO%type,
        eff_date        VARCHAR2(30),
        expiry_date     VARCHAR2(30),
        old_intm_type   GIIS_INTERMEDIARY_HIST.OLD_INTM_TYPE%type,
        intm_type       GIIS_INTERMEDIARY_HIST.INTM_TYPE%type,
        old_wtax_rate   GIIS_INTERMEDIARY_HIST.OLD_WTAX_RATE%type,
        wtax_rate       GIIS_INTERMEDIARY_HIST.WTAX_RATE%type,
        corp_tag        GIIS_INTERMEDIARY_HIST.CORP_TAG%type,
        lic_tag         GIIS_INTERMEDIARY_HIST.LIC_TAG%type,
        active_tag      GIIS_INTERMEDIARY_HIST.ACTIVE_TAG%type,
        special_rate    GIIS_INTERMEDIARY_HIST.SPECIAL_RATE%type
    );
    
    TYPE intm_hist_tab IS TABLE OF intm_hist_type;
    
    FUNCTION get_intm_hist(
        p_intm_no       GIIS_INTERMEDIARY_HIST.INTM_NO%type        
    ) RETURN intm_hist_tab PIPELINED;
    
    
    PROCEDURE copy_intm_record(
        p_intm_no       IN  GIIS_INTERMEDIARY.INTM_NO%type,
        v_new_intm_no   OUT GIIS_INTERMEDIARY.INTM_NO%type
    );
    
    FUNCTION check_mobile_prefix(
        p_param     VARCHAR2,
        p_prefix    VARCHAR2
    ) RETURN VARCHAR2;
    
    --nieko 02092017, SR 23817
    TYPE whtax_lov_type2 IS RECORD(
        whtax_id            giac_wholding_taxes.WHTAX_ID%type,
        gibr_branch_cd      giac_wholding_taxes.GIBR_BRANCH_CD%type,
        whtax_code          giac_wholding_taxes.WHTAX_CODE%type,
        whtax_desc          giac_wholding_taxes.WHTAX_DESC%type,
        percent_rate          giac_wholding_taxes.PERCENT_RATE%type
    );
    
    TYPE whtax_lov_tab2 IS TABLE OF whtax_lov_type2;
    
    FUNCTION get_whtax_lov2(
        p_user_id       VARCHAR2
    ) RETURN whtax_lov_tab2 PIPELINED;
    --nieko 02092017
END GIISS076_PKG;
/



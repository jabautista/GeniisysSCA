CREATE OR REPLACE PACKAGE CPI.GIACS607_PKG
AS
    
    PROCEDURE get_parameters(
        p_user_id               IN  VARCHAR2,
        p_fund_cd               OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_fund_desc             OUT giis_funds.fund_desc%TYPE,
        p_branch_cd             OUT giis_user_grp_hdr.grp_iss_cd%type,
        p_branch_name           OUT giac_branches.branch_name%type,
        p_evat_cd               OUT NUMBER,
        p_tax_allocation        OUT giac_parameters.param_value_v%TYPE,
        p_mgmt_comp             OUT VARCHAR2,
        p_comm_exp_gen          OUT giac_parameters.param_value_v%TYPE,
        p_comm_payable_take_up  OUT giac_parameters.param_value_v%TYPE,
        p_prem_payt_for_sp      OUT giac_parameters.param_value_v%TYPE,
        p_stale_check           OUT giac_parameters.param_value_v%TYPE,
        p_stale_days            OUT giac_parameters.param_value_v%TYPE,
        p_stale_mgr_chk         OUT giac_parameters.param_value_v%TYPE,        
        p_sl_type_cd1           OUT giac_parameters.param_name%TYPE,
        p_sl_type_cd2           OUT giac_parameters.param_name%TYPE,
        p_sl_type_cd3           OUT giac_parameters.param_name%TYPE,
        p_dflt_dcb_bank_cd      OUT giac_dcb_users.BANK_CD%TYPE,
        p_dflt_dcb_bank_name    OUT giac_banks.BANK_NAME%TYPE,
        p_dflt_dcb_bank_acct_cd OUT giac_dcb_users.BANK_ACCT_CD%TYPE,
        p_dflt_dcb_bank_acct_no OUT giac_bank_accounts.BANK_ACCT_NO%TYPE,   
        p_jv_tran_type          OUT giac_jv_trans.JV_TRAN_CD%type,
        p_jv_tran_desc          OUT giac_jv_trans.JV_TRAN_DESC%type,  
        p_dflt_currency_cd      OUT giac_parameters.param_value_v%type,
        p_dflt_currency_sname   OUT giis_currency.short_name%type,
        p_dflt_currency_rt      OUT giis_currency.currency_rt%type
    );
    
    FUNCTION get_legend(
        p_rv_domain     cg_ref_codes.RV_DOMAIN%TYPE
    ) RETURN VARCHAR2;
    
    TYPE guf_type IS RECORD (
        source_cd           giac_upload_file.SOURCE_CD%TYPE,
        nbt_source_name     giac_file_source.SOURCE_NAME%TYPE,
        file_no             giac_upload_file.FILE_NO%TYPE,
        file_name           giac_upload_file.FILE_NAME%TYPE,
        nbt_intm_type       giis_intermediary.INTM_TYPE%TYPE,
        intm_no             giac_upload_file.INTM_NO%TYPE,
        nbt_intm_name       giis_intermediary.INTM_NAME%TYPE,
        nbt_ref_intm_cd     giis_intermediary.REF_INTM_CD%TYPE,
        tran_date           giac_upload_file.TRAN_DATE%TYPE,
        tran_id             giac_upload_file.TRAN_ID%TYPE,
        file_status         giac_upload_file.FILE_STATUS%TYPE,
        nbt_or_req_jv_no    VARCHAR2(100),
        tran_class          giac_upload_file.TRAN_CLASS%TYPE,
        convert_date        giac_upload_file.CONVERT_DATE%TYPE,
        upload_date         giac_upload_file.UPLOAD_DATE%TYPE,
        cancel_date         giac_upload_file.CANCEL_DATE%TYPE,
        gross_tag           giac_upload_file.GROSS_TAG%TYPE,
        nbt_or_tag          giac_file_source.OR_TAG%TYPE,
        nbt_input_vat_rate  giis_intermediary.INPUT_VAT_RATE%TYPE,
        nbt_tran_class      giac_upload_file.TRAN_CLASS%TYPE,
        nbt_gross_tag       giac_upload_file.GROSS_TAG%TYPE,
        nbt_or_date         giac_upload_file.TRAN_DATE%TYPE,
        remarks             giac_upload_file.REMARKS%TYPE,
        no_of_records       giac_upload_file.NO_OF_RECORDS%TYPE             
    );
    
    TYPE guf_tab IS TABLE OF guf_type;
    
    
    FUNCTION get_guf_details(
        p_source_cd         giac_upload_file.SOURCE_CD%TYPE,
        p_file_no           giac_upload_file.FILE_NO%TYPE
    ) RETURN guf_tab PIPELINED;
    
    
    TYPE gupc_type IS RECORD(
        source_cd           GIAC_UPLOAD_PREM_COMM.SOURCE_CD%TYPE,
        file_no             GIAC_UPLOAD_PREM_COMM.FILE_NO%TYPE,
        prem_chk_flag       GIAC_UPLOAD_PREM_COMM.PREM_CHK_FLAG%type,
        comm_chk_flag       GIAC_UPLOAD_PREM_COMM.COMM_CHK_FLAG%type,
        nbt_policy_id       GIPI_POLBASIC.POLICY_ID%TYPE,
        line_cd             GIAC_UPLOAD_PREM_COMM.LINE_CD%TYPE,
        subline_cd          GIAC_UPLOAD_PREM_COMM.SUBLINE_CD%TYPE,
        iss_cd              GIAC_UPLOAD_PREM_COMM.ISS_CD%TYPE,
        issue_yy            GIAC_UPLOAD_PREM_COMM.ISSUE_YY%TYPE,
        pol_seq_no          GIAC_UPLOAD_PREM_COMM.POL_SEQ_NO%type,
        renew_no            GIAC_UPLOAD_PREM_COMM.RENEW_NO%type,
        policy_no           VARCHAR2(30),
        endt_iss_cd         GIAC_UPLOAD_PREM_COMM.ENDT_ISS_CD%type,
        endt_yy             GIAC_UPLOAD_PREM_COMM.ENDT_YY%type,
        endt_seq_no         GIAC_UPLOAD_PREM_COMM.ENDT_SEQ_NO%TYPE,
        endt_no             VARCHAR2(15),
        gross_prem_amt      GIAC_UPLOAD_PREM_COMM.GROSS_PREM_AMT%type,
        comm_amt            GIAC_UPLOAD_PREM_COMM.COMM_AMT%type,
        whtax_amt           GIAC_UPLOAD_PREM_COMM.WHTAX_AMT%type,
        input_vat_amt       GIAC_UPLOAD_PREM_COMM.INPUT_VAT_AMT%type,
        net_amt_due         GIAC_UPLOAD_PREM_COMM.NET_AMT_DUE%type,
        chk_remarks         GIAC_UPLOAD_PREM_COMM.CHK_REMARKS%type,
        payor               GIAC_UPLOAD_PREM_COMM.PAYOR%TYPE,
        gross_tag           GIAC_UPLOAD_PREM_COMM.GROSS_TAG%type,
        gprem_amt_due       GIAC_UPLOAD_PREM_COMM.GPREM_AMT_DUE%type,
        comm_amt_due        GIAC_UPLOAD_PREM_COMM.COMM_AMT_DUE%type,
        whtax_amt_due       GIAC_UPLOAD_PREM_COMM.WHTAX_AMT_DUE%type,
        invat_amt_due       GIAC_UPLOAD_PREM_COMM.INVAT_AMT_DUE%type,
        nbt_gprem_diff      NUMBER(21,2),
        nbt_comm_diff       NUMBER(21,2),
        nbt_whtax_diff      NUMBER(21,2),
        nbt_input_vat_diff  NUMBER(21,2),
        nbt_net_due_diff    NUMBER(21,2),
        nbt_or_no           VARCHAR2(20),
        nbt_assd_no         GIPI_POLBASIC.ASSD_NO%TYPE,
        tran_id             GIAC_UPLOAD_PREM_COMM.TRAN_ID%TYPE,
        currency_cd         GIAC_UPLOAD_PREM_COMM.CURRENCY_CD%TYPE,
        nbt_currency_desc   GIIS_CURRENCY.currency_desc%type,
        convert_rate        GIAC_UPLOAD_PREM_COMM.CONVERT_RATE%type,
        fgross_prem_amt     GIAC_UPLOAD_PREM_COMM.FGROSS_PREM_AMT%type,
        fcomm_amt           GIAC_UPLOAD_PREM_COMM.FCOMM_AMT%type,
        fwhtax_amt          GIAC_UPLOAD_PREM_COMM.FWHTAX_AMT%type,
        finput_vat_amt      GIAC_UPLOAD_PREM_COMM.FINPUT_VAT_AMT%type,
        fnet_amt_due        GIAC_UPLOAD_PREM_COMM.FNET_AMT_DUE%type,
        nbt_fgprem_diff     NUMBER(21,2),
        nbt_fcomm_diff      NUMBER(21,2),
        nbt_fwhtax_diff     NUMBER(21,2),
        nbt_finput_vat_diff NUMBER(21,2),
        nbt_fnet_due_diff   NUMBER(21,2)
    );
    
    TYPE gupc_tab IS TABLE OF gupc_type;
    
    
    FUNCTION get_gupc_records(
        p_source_cd         GIAC_UPLOAD_PREM_COMM.SOURCE_CD%TYPE,
        p_file_no           GIAC_UPLOAD_PREM_COMM.FILE_NO%TYPE,
        p_policy_no         VARCHAR2,
        p_endt_no           VARCHAR2,
        p_gross_prem_amt    GIAC_UPLOAD_PREM_COMM.GROSS_PREM_AMT%TYPE,
        p_comm_amt          GIAC_UPLOAD_PREM_COMM.COMM_AMT%TYPE,
        p_whtax_amt         GIAC_UPLOAD_PREM_COMM.WHTAX_AMT%TYPE,
        p_input_vat_amt     GIAC_UPLOAD_PREM_COMM.INPUT_VAT_AMT%type,
        p_net_amt_due       GIAC_UPLOAD_PREM_COMM.NET_AMT_DUE%TYPE
    ) RETURN gupc_tab PIPELINED;
    
    
    --= ======= start: DV Payment Details =========== 
    
    TYPE gudv_type IS RECORD (
        source_cd               giac_upload_dv_payt_dtl.SOURCE_CD%type,
        file_no                 giac_upload_dv_payt_dtl.FILE_NO%type,
        document_cd             giac_upload_dv_payt_dtl.DOCUMENT_CD%type,
        branch_cd               giac_upload_dv_payt_dtl.BRANCH_CD%type,
        line_cd                 giac_upload_dv_payt_dtl.LINE_CD%type,
        doc_year                giac_upload_dv_payt_dtl.DOC_YEAR%type,
        doc_mm                  giac_upload_dv_payt_dtl.DOC_MM%type,
        doc_seq_no              giac_upload_dv_payt_dtl.DOC_SEQ_NO%type,
        gouc_ouc_id             giac_upload_dv_payt_dtl.GOUC_OUC_ID%type,
        nbt_ouc_cd              giac_oucs.OUC_CD%type,
        nbt_ouc_name            giac_oucs.OUC_NAME%type,
        request_date            giac_upload_dv_payt_dtl.REQUEST_DATE%type,
        payee_class_cd          giac_upload_dv_payt_dtl.PAYEE_CLASS_CD%type,
        payee_cd                giac_upload_dv_payt_dtl.PAYEE_CD%type,
        payee                   giac_upload_dv_payt_dtl.PAYEE%type,
        particulars             giac_upload_dv_payt_dtl.PARTICULARS%type,
        currency_cd             giac_upload_dv_payt_dtl.CURRENCY_CD%type,
        currency_rt             giac_upload_dv_payt_dtl.CURRENCY_RT%type,
        nbt_fshort_name         giis_currency.short_name%type,
        dv_fcurrency_amt        giac_upload_dv_payt_dtl.DV_FCURRENCY_AMT%type,
        nbt_short_name          giac_parameters.param_value_v%type,
        payt_amt                giac_upload_dv_payt_dtl.PAYT_AMT%type
    );
    
    
    TYPE gudv_tab IS TABLE OF gudv_type;
    
    
    FUNCTION get_gudv_details(
        p_source_cd         giac_upload_dv_payt_dtl.SOURCE_CD%TYPE,
        p_file_no           giac_upload_dv_payt_dtl.FILE_NO%TYPE
    ) RETURN gudv_tab PIPELINED;
    
    
    TYPE document_lov_type IS RECORD (
        fund_cd             GIAC_PAYT_REQ_DOCS.GIBR_GFUN_FUND_CD%TYPE,
        branch_cd           GIAC_PAYT_REQ_DOCS.GIBR_BRANCH_CD%TYPE,
        document_cd         GIAC_PAYT_REQ_DOCS.DOCUMENT_CD%TYPE,
        document_name       GIAC_PAYT_REQ_DOCS.DOCUMENT_NAME%TYPE,
        line_cd_tag         GIAC_PAYT_REQ_DOCS.line_cd_tag%TYPE,
        yy_tag              GIAC_PAYT_REQ_DOCS.YY_TAG%TYPE,
        mm_tag              GIAC_PAYT_REQ_DOCS.MM_TAG%TYPE
    );

    TYPE document_lov_tab IS TABLE OF document_lov_type;

    FUNCTION get_document_lov (
        p_fund_cd       GIAC_PAYT_REQ_DOCS.GIBR_GFUN_FUND_CD%TYPE,
        p_branch_cd     GIAC_PAYT_REQ_DOCS.GIBR_BRANCH_CD%TYPE,
        p_keyword       VARCHAR2
    ) RETURN document_lov_tab PIPELINED;
    
    
    TYPE branch_lov_type IS RECORD(
        branch_cd       GIAC_BRANCHES.branch_cd%TYPE,
        branch_name     GIAC_BRANCHES.branch_name%TYPE,
        doc_cd_exists   VARCHAR2(1),
        ouc_id_exists   VARCHAR2(1)
    );
    
    TYPE branch_lov_tab IS TABLE OF branch_lov_type;
    
    FUNCTION get_dv_branch_lov(
        p_user_id       VARCHAR2,
        p_keyword       VARCHAR2,
        p_fund_cd       VARCHAR2,
        p_doc_cd        VARCHAR2,
        p_ouc_id        VARCHAR2
    ) RETURN branch_lov_tab PIPELINED;
    
    
    TYPE line_lov_type IS RECORD(
        line_cd     GIIS_LINE.LINE_CD%TYPE,
        line_name   GIIS_LINE.LINE_NAME%TYPE
    );
    
    TYPE line_lov_tab IS TABLE OF line_lov_type;
    
    FUNCTION get_line_lov(
        p_keyword       VARCHAR2
    ) RETURN line_lov_tab PIPELINED;


    TYPE ouc_lov_type IS RECORD (
        ouc_cd           giac_oucs.ouc_cd%TYPE,
        ouc_id           giac_oucs.ouc_id%TYPE,
        ouc_name         giac_oucs.ouc_name%TYPE
    );
   
    TYPE ouc_lov_tab IS TABLE OF ouc_lov_type;
        
    FUNCTION get_ouc_lov(
        p_fund_cd       VARCHAR2,
        p_branch_cd     VARCHAR2,
        p_keyword       VARCHAR2
    ) RETURN ouc_lov_tab PIPELINED;
    
    
    TYPE payee_class_lov_type IS RECORD(
        payee_class_cd      giis_payee_class.PAYEE_CLASS_CD%type,
        class_desc          giis_payee_class.CLASS_DESC%TYPE
    );
    
    TYPE payee_class_lov_tab IS TABLE OF payee_class_lov_type;
    
    FUNCTION get_payee_class_lov(
        p_keyword   VARCHAR2
    ) RETURN payee_class_lov_tab PIPELINED;
    
    
    TYPE payee_lov_type IS RECORD(
        payee_no            giis_payees.PAYEE_NO%type,
        payee_first_name    giis_payees.PAYEE_FIRST_NAME%type,
        payee_middle_name   giis_payees.PAYEE_MIDDLE_NAME%type,
        payee_last_name     giis_payees.PAYEE_LAST_NAME%type,
        nbt_derive_payee    VARCHAR2(600)
    );
    
    TYPE payee_lov_tab IS TABLE OF payee_lov_type;
    
    FUNCTION get_payee_lov(
        p_payee_class_cd        GIIS_PAYEES.PAYEE_CLASS_CD%TYPE,
        p_keyword               VARCHAR2
    ) RETURN payee_lov_tab PIPELINED;
    
    
    TYPE currency_lov_type IS RECORD (
        short_name          giis_currency.short_name%TYPE,            
        currency_desc       giis_currency.currency_desc%TYPE, 
        main_currency_cd    giis_currency.main_currency_cd%TYPE,
        currency_rt         giis_currency.currency_rt%TYPE
    );
       
    TYPE currency_lov_tab IS TABLE OF currency_lov_type;
            
    FUNCTION get_currency_lov(
        p_keyword       VARCHAR2
    )RETURN currency_lov_tab PIPELINED;
    
    
    PROCEDURE del_gudv(
        p_source_cd     IN  giac_upload_dv_payt_dtl.SOURCE_CD%TYPE,
        p_file_no       IN  giac_upload_dv_payt_dtl.FILE_NO%TYPE
    );
    
    PROCEDURE set_gudv(
        p_rec       giac_upload_dv_payt_dtl%ROWTYPE
    );

    --= ======= end: DV Payment Details =========== 
    
    --= ======= start: JV Payment Details =========== 
    TYPE gujv_type IS RECORD(
        source_cd           GIAC_UPLOAD_JV_PAYT_DTL.SOURCE_CD%TYPE,
        file_no             GIAC_UPLOAD_JV_PAYT_DTL.FILE_NO%TYPE,
        branch_cd           GIAC_UPLOAD_JV_PAYT_DTL.BRANCH_CD%type,
        nbt_branch_name     giac_branches.branch_name%type,
        tran_year           GIAC_UPLOAD_JV_PAYT_DTL.TRAN_YEAR%type,
        tran_month          GIAC_UPLOAD_JV_PAYT_DTL.TRAN_MONTH%type,
        tran_seq_no         GIAC_UPLOAD_JV_PAYT_DTL.TRAN_SEQ_NO%type,
        tran_date           GIAC_UPLOAD_JV_PAYT_DTL.TRAN_DATE%type,
        jv_pref_suff        GIAC_UPLOAD_JV_PAYT_DTL.JV_PREF_SUFF%type,
        jv_no               GIAC_UPLOAD_JV_PAYT_DTL.JV_NO%type,
        particulars         GIAC_UPLOAD_JV_PAYT_DTL.PARTICULARS%type,
        jv_tran_tag         GIAC_UPLOAD_JV_PAYT_DTL.JV_TRAN_TAG%type,
        jv_tran_type        GIAC_UPLOAD_JV_PAYT_DTL.JV_TRAN_TYPE%type,
        nbt_jv_tran_desc    giac_jv_trans.JV_TRAN_DESC%type,
        jv_tran_mm          GIAC_UPLOAD_JV_PAYT_DTL.JV_TRAN_MM%type,
        jv_tran_yy          GIAC_UPLOAD_JV_PAYT_DTL.JV_TRAN_YY%type
    );
    
    TYPE gujv_tab IS TABLE OF gujv_type;
    
    FUNCTION get_gujv_details(
        p_source_cd         GIAC_UPLOAD_JV_PAYT_DTL.SOURCE_CD%type,
        p_file_no           GIAC_UPLOAD_JV_PAYT_DTL.FILE_NO%type
    ) RETURN gujv_tab PIPELINED;
    
    FUNCTION get_jv_branch_lov(
        p_user_id       VARCHAR2,
        p_keyword       VARCHAR2
    ) RETURN branch_lov_tab PIPELINED;
    
    TYPE jv_tran_type_type IS RECORD(
        jv_tran_type        GIAC_JV_TRANS.JV_TRAN_CD%type,
        jv_tran_desc        GIAC_JV_TRANS.JV_TRAN_DESC%type
    );
    
    TYPE jv_tran_type_tab IS TABLE OF jv_tran_type_type;
    
    FUNCTION get_jv_tran_type_lov(
        p_jv_tran_tag       GIAC_JV_TRANS.JV_TRAN_TAG%type,
        p_keyword           VARCHAR2,
        p_row_num           NUMBER
    ) RETURN jv_tran_type_tab PIPELINED;
    
    
    PROCEDURE del_gujv(
        p_source_cd     IN  giac_upload_jv_payt_dtl.SOURCE_CD%TYPE,
        p_file_no       IN  giac_upload_jv_payt_dtl.FILE_NO%TYPE
    );
    
    PROCEDURE set_gujv(
        p_rec       giac_upload_jv_payt_dtl%ROWTYPE
    );
    
    --= ======= end: JV Payment Details =========== 
    
    
    --= ======= start: Collection Details =========== 
    TYPE gucd_type IS RECORD(
        source_cd               GIAC_UPLOAD_COLLN_DTL.SOURCE_CD%type,
        file_no                 GIAC_UPLOAD_COLLN_DTL.FILE_NO%type,
        item_no                 GIAC_UPLOAD_COLLN_DTL.ITEM_NO%type,
        pay_mode                GIAC_UPLOAD_COLLN_DTL.PAY_MODE%type,
        bank_cd                 GIAC_UPLOAD_COLLN_DTL.BANK_CD%type,
        nbt_bank_sname          giac_banks.BANK_SNAME%type,
        check_class             GIAC_UPLOAD_COLLN_DTL.CHECK_CLASS%type,
        check_no                GIAC_UPLOAD_COLLN_DTL.CHECK_NO%type,
        check_date              GIAC_UPLOAD_COLLN_DTL.CHECK_DATE%type,
        amount                  GIAC_UPLOAD_COLLN_DTL.AMOUNT%type,
        nbt_short_name          giis_currency.SHORT_NAME%type,
        currency_cd             GIAC_UPLOAD_COLLN_DTL.CURRENCY_CD%type,
        currency_rt             GIAC_UPLOAD_COLLN_DTL.CURRENCY_RT%type,
        dcb_bank_cd             GIAC_UPLOAD_COLLN_DTL.DCB_BANK_CD%type,
        nbt_dcb_bank_name       giac_banks.BANK_NAME%type,
        dcb_bank_acct_cd        GIAC_UPLOAD_COLLN_DTL.DCB_BANK_ACCT_CD%type,
        nbt_dcb_bank_acct_no    giac_bank_accounts.BANK_ACCT_NO%type,
        particulars             GIAC_UPLOAD_COLLN_DTL.PARTICULARS%type,
        gross_amt               GIAC_UPLOAD_COLLN_DTL.GROSS_AMT%type,
        commission_amt          GIAC_UPLOAD_COLLN_DTL.COMMISSION_AMT%type,
        vat_amt                 GIAC_UPLOAD_COLLN_DTL.VAT_AMT%type,
        fc_gross_amt            GIAC_UPLOAD_COLLN_DTL.FC_GROSS_AMT%type,
        fc_comm_amt             GIAC_UPLOAD_COLLN_DTL.FC_COMM_AMT%type,
        fc_vat_amt              GIAC_UPLOAD_COLLN_DTL.FC_VAT_AMT%type,
        nbt_fc_net_amt          NUMBER(20,2)
    );
    
    TYPE gucd_tab IS TABLE OF gucd_type;
    
    
    FUNCTION get_gucd_records(
        p_source_cd             GIAC_UPLOAD_COLLN_DTL.SOURCE_CD%type,
        p_file_no               GIAC_UPLOAD_COLLN_DTL.FILE_NO%type,
        p_item_no               GIAC_UPLOAD_COLLN_DTL.ITEM_NO%type,
        p_pay_mode              GIAC_UPLOAD_COLLN_DTL.PAY_MODE%type,
        p_check_class           GIAC_UPLOAD_COLLN_DTL.CHECK_CLASS%type,
        p_check_no              GIAC_UPLOAD_COLLN_DTL.CHECK_NO%type,
        p_check_date            VARCHAR2,
        p_amount                GIAC_UPLOAD_COLLN_DTL.AMOUNT%type,
        p_gross_amt             GIAC_UPLOAD_COLLN_DTL.GROSS_AMT%type,
        p_comm_amt              GIAC_UPLOAD_COLLN_DTL.COMMISSION_AMT%type,
        p_vat_amt               GIAC_UPLOAD_COLLN_DTL.VAT_AMT%type
    ) RETURN gucd_tab PIPELINED;
    
    TYPE bank_lov_type IS RECORD(
        bank_cd         giac_banks.BANK_CD%type,
        bank_sname      giac_banks.BANK_SNAME%type,
        bank_name       giac_banks.BANK_NAME%type
    );
    
    TYPE bank_lov_tab IS TABLE OF bank_lov_type;
    
    FUNCTION get_bank_lov(
        p_keyword       VARCHAR2
    ) RETURN bank_lov_tab PIPELINED;
    
    
    FUNCTION get_dcb_bank_lov(
        p_keyword       VARCHAR2
    ) RETURN bank_lov_tab PIPELINED;
    
    
    TYPE dcb_bank_acct_lov_type IS RECORD(
        bank_acct_cd        giac_bank_accounts.BANK_ACCT_CD%type,
        bank_acct_no        giac_bank_accounts.BANK_ACCT_NO%type,
        bank_acct_type      giac_bank_accounts.BANK_ACCT_TYPE%type,
        branch_cd           giac_bank_accounts.BRANCH_CD%type
    );
    
    TYPE dcb_bank_acct_lov_tab IS TABLE OF dcb_bank_acct_lov_type;
    
    FUNCTION get_dcb_bank_acct_lov(
        p_dcb_bank_cd   giac_bank_accounts.BANK_CD%type,
        p_keyword       VARCHAR2
    ) RETURN dcb_bank_acct_lov_tab PIPELINED;
    
    
    PROCEDURE del_gucd(
        p_source_cd     IN  giac_upload_colln_dtl.SOURCE_CD%TYPE,
        p_file_no       IN  giac_upload_colln_dtl.FILE_NO%TYPE,
        p_item_no       IN  giac_upload_colln_dtl.ITEM_NO%type
    );
    
    PROCEDURE set_gucd(
        p_rec       giac_upload_colln_dtl%ROWTYPE
    );
    
    PROCEDURE check_net_colln(
        p_source_cd     IN  giac_upload_colln_dtl.SOURCE_CD%TYPE,
        p_file_no       IN  giac_upload_colln_dtl.FILE_NO%TYPE
    );
    
    --= ======= end: Collection Details =========== 
    
    
    --= ======= upload button ========= --  
    
    PROCEDURE validate_before_upload(
        p_user_id       VARCHAR2,
        p_source_cd     giac_upload_file.SOURCE_CD%TYPE,
        p_file_no       giac_upload_file.FILE_NO%TYPE,
        p_tran_class    giac_upload_file.TRAN_CLASS%TYPE
    );  
    
    TYPE acct_assd_rg_type IS RECORD(
        assd_no         giis_assured.assd_no%TYPE,
        pay_rcv_amt     giac_upload_prem_comm.gross_prem_amt%TYPE
    );
    
    TYPE acct_assd_rg_tab IS TABLE OF acct_assd_rg_type;
    v_acct_assd_list  acct_assd_rg_tab := acct_assd_rg_tab();
    
    v_tran_id            giac_acctrans.tran_id%TYPE;
    v_gen_type          giac_modules.GENERATION_TYPE%TYPE;
    v_n_seq_no            NUMBER := 3;
    v_tran_date            giac_acctrans.tran_date%TYPE;
    
    v_get_prem_pd_tag       VARCHAR2(1);
    v_iss_cd                giac_direct_prem_collns.b140_iss_cd%TYPE;
    v_prem_seq_no            giac_direct_prem_collns.b140_prem_seq_no%TYPE;
    v_transaction_type        giac_direct_prem_collns.transaction_type%TYPE;
    v_inst_no                giac_direct_prem_collns.inst_no%TYPE;
    v_collection_amt        giac_direct_prem_collns.collection_amt%TYPE;
    v_premium_amt            giac_direct_prem_collns.premium_amt%TYPE;
    v_tax_amt                giac_direct_prem_collns.tax_amt%TYPE;
    v_currency_cd             giac_direct_prem_collns.currency_cd%TYPE;
    v_convert_rate            giac_direct_prem_collns.convert_rate%TYPE;
    v_max_collection_amt    giac_direct_prem_collns.collection_amt%TYPE;
    v_max_premium_amt        giac_direct_prem_collns.premium_amt%TYPE;
    v_max_tax_amt            giac_direct_prem_collns.tax_amt%TYPE;
    v_foreign_curr_amt        giac_direct_prem_collns.foreign_curr_amt%TYPE;
    
    
    FUNCTION chk_modified_comm (
        p_iss_cd        gipi_invoice.iss_cd%TYPE, 
        p_prem_seq_no    gipi_invoice.prem_seq_no%TYPE
    ) RETURN BOOLEAN;
        
    PROCEDURE with_tax_allocation(
        p_get_prem_pd_tag       IN  VARCHAR2,   
        p_user_id               IN  VARCHAR2
    );
        
    FUNCTION get_prem_to_be_paid (
        p_iss_cd                giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no            giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_gross_prem_amt        giac_upload_prem_comm.gross_prem_amt%TYPE,
        p_user_id               VARCHAR2,
        p_get_prem_pd_tag       VARCHAR2
    ) RETURN NUMBER;
                           
    PROCEDURE validate_policy(
        p_source_cd             IN  giac_upload_colln_dtl.SOURCE_CD%TYPE,
        p_file_no               IN  giac_upload_colln_dtl.FILE_NO%TYPE,
        p_user_id               IN  VARCHAR2,
        p_get_prem_pd_tag       OUT VARCHAR2
    );
    
    FUNCTION check_user_branch_access(
        p_source_cd     GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no       GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_module_id     VARCHAR2,
        p_user_id       VARCHAR2
    ) RETURN VARCHAR2;
    
    
    PROCEDURE check_payment_before_upload(
        p_source_cd             GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no               GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_dsp_tran_class        VARCHAR2,
        p_user_id                   VARCHAR2,
        p_dcb_no            OUT giac_colln_batch.dcb_no%TYPE
    );
    
    PROCEDURE check_claim_and_override(
        p_source_cd                 GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no                   GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_user_id                   VARCHAR2,
        p_c_override            OUT VARCHAR2,
        p_access_cc_giacs007    OUT VARCHAR2,
        p_o_override            OUT VARCHAR2,
        p_access_ua_giacs607    OUT VARCHAR2
    );
        
    PROCEDURE update_acct_assd_rg(
        p_assd_no         giis_assured.assd_no%TYPE,
        p_pay_rcv_amt     giac_upload_prem_comm.gross_prem_amt%TYPE
    );
    
    FUNCTION get_or_particulars 
        RETURN VARCHAR2;
    
    PROCEDURE gen_misc_op_text (
        p_item_text     giac_op_text.item_text%TYPE,
        p_item_amt        giac_op_text.item_amt%TYPE,
        p_user_id       giac_op_text.USER_ID%TYPE
    );
    
    PROCEDURE gen_comm_op_text(
        p_user_id       giac_op_text.USER_ID%TYPE
    );
    
    PROCEDURE gen_prem_dep_op_text(
        p_user_id       giac_op_text.USER_ID%TYPE
    );
    
    PROCEDURE gen_dpc_op_text_prem (
        p_iss_cd                IN  giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no            IN  giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_inst_no                IN  giac_direct_prem_collns.inst_no%TYPE,
        p_premium_amt            IN  NUMBER,
        p_currency_cd             IN  giac_direct_prem_collns.currency_cd%TYPE,
        p_convert_rate             IN  giac_direct_prem_collns.convert_rate%TYPE,
        p_user_id               IN  VARCHAR2,
        p_zero_prem_op_text     IN OUT VARCHAR2 
    );
    
    PROCEDURE gen_dpc_op_text_prem2 ( 
        p_seq_no            NUMBER,
        p_premium_amt        gipi_invoice.prem_amt%TYPE,
        p_prem_text            VARCHAR2,
        p_currency_cd         giac_direct_prem_collns.currency_cd%TYPE,
        p_convert_rate        giac_direct_prem_collns.convert_rate%TYPE,
        p_user_id           VARCHAR2
    );
    
    PROCEDURE gen_dpc_op_text_tax(
        p_tax_cd            NUMBER,
        p_tax_name            VARCHAR2,
        p_tax_amt             NUMBER,
        p_currency_cd         NUMBER,
        p_convert_rate         NUMBER,
        p_user_id           VARCHAR2
    );
    
    PROCEDURE gen_dpc_op_text(
        p_user_id           VARCHAR2
    );
    
    PROCEDURE create_acct_assd_entries (
        p_user_id           VARCHAR2,
        p_pay_rcv_amt OUT   giac_upload_prem_comm.gross_prem_amt%TYPE
    );
    
    PROCEDURE insert_prem_deposit(
        p_policy_id            gipi_polbasic.policy_id%TYPE,
        p_assd_no            giis_assured.assd_no%TYPE,
        p_line_cd              gipi_polbasic.line_cd%TYPE,
        p_subline_cd           gipi_polbasic.subline_cd%TYPE,
        p_iss_cd               gipi_polbasic.iss_cd%TYPE,
        p_issue_yy             gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no           gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no             gipi_polbasic.renew_no%TYPE,
        p_endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,                             
        p_endt_yy            gipi_polbasic.endt_yy%TYPE,
        p_endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
        p_prem_dep_amt      giac_prem_deposit.collection_amt%TYPE,
        p_prem_dep_comm_amt giac_prem_deposit.collection_amt%TYPE,
        p_user_id           VARCHAR2    
    );
    
    FUNCTION get_parent_intm_no(
        p_intm_no               giac_upload_file.INTM_NO%type
    ) RETURN NUMBER;
    
    PROCEDURE insert_comm_payts (
        p_policy_id              gipi_polbasic.policy_id%TYPE,
        p_comm_amt              giac_comm_payts.comm_amt%TYPE,
        p_whtax_amt                 giac_comm_payts.wtax_amt%TYPE,
        p_invat_amt                 giac_comm_payts.input_vat_amt%TYPE,    
        p_intm_no               giac_upload_file.INTM_NO%TYPE,
        p_parent_intm_no        giis_intermediary.PARENT_INTM_NO%type,
        p_nbt_tran_class        giac_upload_file.TRAN_CLASS%TYPE,
        p_gross_tag             giac_upload_file.GROSS_TAG%TYPE,
        p_nbt_invat_rt          NUMBER,
        p_comm_tag              VARCHAR2,
        p_user_id               giac_upload_file.USER_ID%type,        
        p_rem_comm_amt      OUT  giac_comm_payts.comm_amt%TYPE,
        p_rem_whtax_amt     OUT  giac_comm_payts.comm_amt%TYPE,
        p_rem_invat_amt     OUT  giac_comm_payts.comm_amt%TYPE
    );
    
    PROCEDURE insert_premium_collns (
        p_policy_id             gipi_polbasic.policy_id%TYPE,
        p_assd_no               giis_assured.assd_no%TYPE,
        p_collection_amt        giac_direct_prem_collns.collection_amt%TYPE,
        p_user_id               VARCHAR2,
        p_rem_colln_amt     OUT giac_direct_prem_collns.collection_amt%TYPE
    );
                              
    PROCEDURE process_payments (
        p_source_cd                 GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no                   GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class            GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_payor                        giac_order_of_payts.payor%TYPE,
        p_gross_tag                    giac_order_of_payts.gross_tag%TYPE,
        p_sl_type_cd1               giac_parameters.param_name%TYPE,
        p_sl_type_cd2               giac_parameters.param_name%TYPE,
        p_sl_type_cd3               giac_parameters.param_name%TYPE,
        p_user_id                   giac_op_text.USER_ID%TYPE
    );
    
    PROCEDURE gen_group_or(
        p_source_cd         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no           GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class            GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_dcb_no            GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_sl_type_cd1       giac_parameters.param_name%TYPE,
        p_sl_type_cd2       giac_parameters.param_name%TYPE,
        p_sl_type_cd3       giac_parameters.param_name%TYPE,
        p_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_user_id           giac_op_text.USER_ID%TYPE
    );
    
    TYPE gucd_rg_type IS RECORD (
        item_no                 GIAC_UPLOAD_COLLN_DTL.ITEM_NO%type,
        pay_mode                GIAC_UPLOAD_COLLN_DTL.PAY_MODE%type,
        bank_cd                 GIAC_UPLOAD_COLLN_DTL.BANK_CD%type,
        check_class             GIAC_UPLOAD_COLLN_DTL.CHECK_CLASS%type,
        check_no                GIAC_UPLOAD_COLLN_DTL.CHECK_NO%type,
        check_date              GIAC_UPLOAD_COLLN_DTL.CHECK_DATE%type,
        currency_cd             GIAC_UPLOAD_COLLN_DTL.CURRENCY_CD%type,
        currency_rt             GIAC_UPLOAD_COLLN_DTL.CURRENCY_RT%type,
        particulars             GIAC_UPLOAD_COLLN_DTL.PARTICULARS%type,
        amount                  GIAC_UPLOAD_COLLN_DTL.AMOUNT%type,
        gross_amt               GIAC_UPLOAD_COLLN_DTL.GROSS_AMT%type,
        comm_amt                GIAC_UPLOAD_COLLN_DTL.COMMISSION_AMT%type,
        vat_amt                 GIAC_UPLOAD_COLLN_DTL.VAT_AMT%type,
        fc_gross_amt            GIAC_UPLOAD_COLLN_DTL.FC_GROSS_AMT%type,
        fc_comm_amt             GIAC_UPLOAD_COLLN_DTL.FC_COMM_AMT%type,
        fc_vat_amt              GIAC_UPLOAD_COLLN_DTL.FC_VAT_AMT%type
    );
    
    TYPE gucd_rg_tab IS TABLE OF gucd_rg_type;
    v_gucd_rg_list       gucd_rg_tab;
        
        
    TYPE colln_dtl_rg_type IS RECORD (
        item_no                 GIAC_UPLOAD_COLLN_DTL.ITEM_NO%type,
        pay_mode                GIAC_UPLOAD_COLLN_DTL.PAY_MODE%type,
        bank_cd                 GIAC_UPLOAD_COLLN_DTL.BANK_CD%type,
        check_class             GIAC_UPLOAD_COLLN_DTL.CHECK_CLASS%type,
        check_no                GIAC_UPLOAD_COLLN_DTL.CHECK_NO%type,
        check_date              GIAC_UPLOAD_COLLN_DTL.CHECK_DATE%type,
        currency_cd             GIAC_UPLOAD_COLLN_DTL.CURRENCY_CD%type,
        convert_rate            GIAC_UPLOAD_COLLN_DTL.CURRENCY_RT%type,
        particulars             GIAC_UPLOAD_COLLN_DTL.PARTICULARS%type,
        amount                  GIAC_UPLOAD_COLLN_DTL.AMOUNT%type,
        gross_amt               GIAC_UPLOAD_COLLN_DTL.GROSS_AMT%type,
        comm_amt                GIAC_UPLOAD_COLLN_DTL.COMMISSION_AMT%type,
        vat_amt                 GIAC_UPLOAD_COLLN_DTL.VAT_AMT%type,
        fc_gross_amt            GIAC_UPLOAD_COLLN_DTL.FC_GROSS_AMT%type,
        fc_comm_amt             GIAC_UPLOAD_COLLN_DTL.FC_COMM_AMT%type,
        fc_vat_amt              GIAC_UPLOAD_COLLN_DTL.FC_VAT_AMT%type
    );
        
    TYPE colln_dtl_rg_tab IS TABLE OF colln_dtl_rg_type;        
    v_colln_dtl_rg_list      colln_dtl_rg_tab := colln_dtl_rg_tab();
        
            
    PROCEDURE create_or_colln_dtl(
        p_source_cd             GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no               GIAC_UPLOAD_FILE.FILE_NO%TYPE,        
        p_gross_amt                giac_upload_colln_dtl.gross_amt%TYPE,
        p_comm_amt                 giac_upload_colln_dtl.commission_amt%TYPE,    
        p_amount                giac_upload_colln_dtl.amount%TYPE,
        p_vat_amt                giac_upload_colln_dtl.vat_amt%TYPE, --jason 04/18/2008
        p_fc_gross_amt            giac_upload_colln_dtl.fc_gross_amt%TYPE, --jason 04/18/2008
        p_fc_comm_amt            giac_upload_colln_dtl.fc_comm_amt%TYPE, --jason 04/18/2008
        p_fc_vat_amt            giac_upload_colln_dtl.fc_vat_amt%TYPE
    );
    
    PROCEDURE gen_individual_or(
        p_source_cd         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no           GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class    GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_dcb_no            GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_sl_type_cd1       giac_parameters.param_name%TYPE,
        p_sl_type_cd2       giac_parameters.param_name%TYPE,
        p_sl_type_cd3       giac_parameters.param_name%TYPE,
        p_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_user_id           giac_op_text.USER_ID%TYPE,
        p_or_date           giac_order_of_payts.or_date%TYPE
    );
    
    PROCEDURE gen_dv(
        p_source_cd         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no           GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class            GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_sl_type_cd1       giac_parameters.param_name%TYPE,
        p_sl_type_cd2       giac_parameters.param_name%TYPE,
        p_sl_type_cd3       giac_parameters.param_name%TYPE,
        p_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_user_id           giac_op_text.USER_ID%TYPE
    );
    
    PROCEDURE gen_jv(
        p_source_cd         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no           GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class            GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_sl_type_cd1       giac_parameters.param_name%TYPE,
        p_sl_type_cd2       giac_parameters.param_name%TYPE,
        p_sl_type_cd3       giac_parameters.param_name%TYPE,
        p_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
        p_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
        p_user_id           giac_op_text.USER_ID%TYPE
    );
                            
    PROCEDURE upload_payments(
        p_source_cd                 GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no                   GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_nbt_tran_class            GIAC_UPLOAD_FILE.TRAN_CLASS%TYPE,
        p_dcb_no                    GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_sl_type_cd1               giac_parameters.param_name%TYPE,
        p_sl_type_cd2               giac_parameters.param_name%TYPE,
        p_sl_type_cd3               giac_parameters.param_name%TYPE,
        p_user_id                   VARCHAR2,
        p_or_date                   VARCHAR2
    );
        
    PROCEDURE validate_on_print_btn(
        p_source_cd         IN  GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        p_file_no           IN  GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        p_user_id           IN  GIAC_UPLOAD_FILE.USER_ID%TYPE,
        p_branch_cd         OUT giac_upload_dv_payt_dtl.BRANCH_CD%TYPE,
        p_branch_name       OUT giac_branches.BRANCH_NAME%TYPE,
        p_gacc_tran_id      OUT giac_upload_colln_dtl.TRAN_ID%TYPE,
        p_doc_cd            OUT giac_upload_dv_payt_dtl.DOCUMENT_CD%TYPE,
        p_gprq_ref_id       OUT giac_payt_requests_dtl.gprq_ref_id%TYPE,
        p_upload_query      OUT VARCHAR2
    );
    
    --nieko Accounting Uploading
    PROCEDURE process_payments2 (
       p_source_cd        giac_upload_file.source_cd%TYPE,
       p_file_no          giac_upload_file.file_no%TYPE,
       p_nbt_tran_class   giac_upload_file.tran_class%TYPE,
       p_payor            giac_order_of_payts.payor%TYPE,
       p_gross_tag        giac_order_of_payts.gross_tag%TYPE,
       p_sl_type_cd1      giac_parameters.param_name%TYPE,
       p_sl_type_cd2      giac_parameters.param_name%TYPE,
       p_sl_type_cd3      giac_parameters.param_name%TYPE,
       p_user_id          giac_op_text.user_id%TYPE,
       p_line_cd          giac_upload_prem_comm.line_cd%TYPE,
       p_subline_cd       giac_upload_prem_comm.subline_cd%TYPE,
       p_iss_cd           giac_upload_prem_comm.iss_cd%TYPE,
       p_issue_yy         giac_upload_prem_comm.issue_yy%TYPE,
       p_pol_seq_no       giac_upload_prem_comm.pol_seq_no%TYPE,
       p_renew_no         giac_upload_prem_comm.renew_no%TYPE,
       p_endt_iss_cd      giac_upload_prem_comm.endt_iss_cd%TYPE,
       p_endt_yy          giac_upload_prem_comm.endt_yy%TYPE,
       p_endt_seq_no      giac_upload_prem_comm.endt_seq_no%TYPE
    );
    
    PROCEDURE gen_group_or2 (
       p_source_cd        giac_upload_file.source_cd%TYPE,
       p_file_no          giac_upload_file.file_no%TYPE,
       p_nbt_tran_class   giac_upload_file.tran_class%TYPE,
       p_dcb_no           giac_colln_batch.dcb_no%TYPE,
       p_sl_type_cd1      giac_parameters.param_name%TYPE,
       p_sl_type_cd2      giac_parameters.param_name%TYPE,
       p_sl_type_cd3      giac_parameters.param_name%TYPE,
       p_fund_cd          giac_acct_entries.gacc_gfun_fund_cd%TYPE,
       p_branch_cd        giac_acct_entries.gacc_gibr_branch_cd%TYPE,
       p_user_id          giac_op_text.user_id%TYPE,
       p_or_date          giac_order_of_payts.or_date%TYPE
    );
    
    PROCEDURE check_dcb_no (
        p_branch_cd       VARCHAR2,
        p_user_id         VARCHAR2,
        p_or_date         VARCHAR2
    );
    --nieko end
END GIACS607_PKG;
/

CREATE OR REPLACE PACKAGE CPI.GIACS053_PKG
AS

    TYPE batch_or_type IS RECORD(
        gacc_tran_id                GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        gibr_gfun_fund_cd           GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        gibr_branch_cd              GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        or_flag                     GIAC_ORDER_OF_PAYTS.or_flag%TYPE,
        or_pref_suf                 GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,
        or_no                       GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        or_date                     GIAC_ORDER_OF_PAYTS.or_date%TYPE,
        dsp_or_date                 VARCHAR2(30),
        dsp_or_pref                 VARCHAR2(20),
        dsp_or_no                   VARCHAR2(20),
        payor                       GIAC_ORDER_OF_PAYTS.payor%TYPE,
        particulars                 GIAC_ORDER_OF_PAYTS.particulars%TYPE,
        nbt_repl_or_tag             VARCHAR2(1),
        nbt_tran_flag               VARCHAR2(1),
        generate_flag               VARCHAR2(1),
        printed_flag                VARCHAR2(1),
        or_type                     VARCHAR2(1)
    );
    TYPE batch_or_tab IS TABLE OF batch_or_type;
    
    TYPE batch_or_report_type IS RECORD(
        gacc_tran_id                GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        or_pref                     GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,
        or_no                       GIAC_ORDER_OF_PAYTS.or_no%TYPE
    );
    TYPE batch_or_report_tab IS TABLE OF batch_or_report_type;

    PROCEDURE populate_batch_or_temp_table(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_called_by_upload          VARCHAR2,
        p_upload_query              VARCHAR2
    );
    
    FUNCTION get_batch_or_list(
        p_or_date                   VARCHAR2,
        p_payor                     VARCHAR2,
        p_or_type                   VARCHAR2
    )
      RETURN batch_or_tab PIPELINED;

    PROCEDURE tag_all_ors(
        p_or_date           IN      VARCHAR2,
        p_payor             IN      VARCHAR2,
        p_message1          OUT     VARCHAR2,
        p_message2          OUT     VARCHAR2,
        p_message3          OUT     VARCHAR2
    );
    
    PROCEDURE untag_all_ors;
    
    FUNCTION check_or(
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    )
      RETURN VARCHAR2;

    PROCEDURE validate_or(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_or_pref                   GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE,
        p_or_no                     GIAC_DOC_SEQUENCE.doc_seq_no%TYPE,
        p_or_type                   GIAC_OR_PREF.or_type%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    );
    
    PROCEDURE save_generate_tag(
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_generate_flag             VARCHAR2
    );

    PROCEDURE generate_or_numbers(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_one_or_seq                GIAC_PARAMETERS.param_value_v%TYPE,
        p_vat_nonvat                GIAC_PARAMETERS.param_value_v%TYPE,
        p_vat_pref                  GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,                
        p_vat_seq                   GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_non_vat_pref              GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,
        p_non_vat_seq               GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_other_pref                GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,
        p_other_seq                 GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    );

    FUNCTION determine_or_type(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_one_or_seq                GIAC_PARAMETERS.param_value_v%TYPE,
        p_vat_nonvat                GIAC_PARAMETERS.param_value_v%TYPE
    )
      RETURN VARCHAR2;
      
    FUNCTION check_premium_income_related(
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    )
      RETURN BOOLEAN;
      
    FUNCTION check_vat_nvat(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE
    )
      RETURN VARCHAR2;
      
    FUNCTION get_batch_or_report_list(
        p_or_type                   VARCHAR2
    )
      RETURN batch_or_report_tab PIPELINED;
      
    PROCEDURE process_printed_or(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_or_type                   GIAC_OR_PREF.or_type%TYPE,
        p_last_or_no                GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    );
    
    PROCEDURE ins_upd_giop(
        p_gacc_tran_id	            GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_or_pref  			        GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE,
        p_or_no    			        GIAC_DOC_SEQUENCE.doc_seq_no%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    );
    
    PROCEDURE ins_upd_or(
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_or_pref                   GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE,
        p_or_no                     GIAC_DOC_SEQUENCE.doc_seq_no%TYPE,
        p_doc_name                  GIAC_DOC_SEQUENCE.doc_name%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    );
    
    FUNCTION check_last_printed_or(
        p_last_or_no                GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_last_or_printed           GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_or_type                   GIAC_OR_PREF.or_type%TYPE
    )
      RETURN VARCHAR2;
      
    PROCEDURE spoil_batch_or(
        p_last_or_no                GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_or_type                   GIAC_OR_PREF.or_type%TYPE,
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    );
    
    PROCEDURE spoil_or_record(
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_or_pref                   GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE,
        p_or_no                     GIAC_ORDER_OF_PAYTS.or_no%TYPE,
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE,
        p_user_id                   GIIS_USERS.user_id%TYPE
    );
    
    FUNCTION get_or_dcb_flag(
        p_gacc_tran_id              GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_fund_cd                   GIAC_ORDER_OF_PAYTS.gibr_gfun_fund_cd%TYPE,
        p_branch_cd                 GIAC_ORDER_OF_PAYTS.gibr_branch_cd%TYPE
    )
      RETURN VARCHAR2;
      
    PROCEDURE get_batch_comm_slip_params(
        p_gacc_tran_id_list OUT     VARCHAR2,
        p_message_flag      OUT     VARCHAR2,
        p_or_count          OUT     NUMBER
    );

END GIACS053_PKG;
/



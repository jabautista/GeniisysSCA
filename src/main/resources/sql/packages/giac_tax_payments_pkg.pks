CREATE OR REPLACE PACKAGE CPI.GIAC_TAX_PAYMENTS_PKG
AS

    TYPE giac_tax_payments_type IS RECORD(
        gacc_tran_id            GIAC_TAX_PAYMENTS.gacc_tran_id%TYPE,
        item_no                 GIAC_TAX_PAYMENTS.item_no%TYPE,
        transaction_type        GIAC_TAX_PAYMENTS.transaction_type%TYPE,
        fund_cd                 GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        tax_cd                  GIAC_TAX_PAYMENTS.tax_cd%TYPE,
        branch_cd               GIAC_TAX_PAYMENTS.branch_cd%TYPE,
        tax_amt                 GIAC_TAX_PAYMENTS.tax_amt%TYPE,
        or_print_tag            GIAC_TAX_PAYMENTS.or_print_tag%TYPE,
        remarks                 GIAC_TAX_PAYMENTS.remarks%TYPE,
        user_id                 GIAC_TAX_PAYMENTS.user_id%TYPE,
        last_update             GIAC_TAX_PAYMENTS.last_update%TYPE,
        cpi_rec_no              GIAC_TAX_PAYMENTS.cpi_rec_no%TYPE,
        cpi_branch_cd           GIAC_TAX_PAYMENTS.cpi_branch_cd%TYPE,
        sl_cd                   GIAC_TAX_PAYMENTS.sl_cd%TYPE,
        sl_type_cd              GIAC_TAX_PAYMENTS.sl_type_cd%TYPE,
        sl_name                 GIAC_SL_LISTS.sl_name%TYPE,
        tax_name                GIAC_TAXES.tax_name%TYPE,
        transaction_desc        CG_REF_CODES.rv_meaning%TYPE,
        branch_name             GIAC_BRANCHES.branch_name%TYPE,
        fund_desc               GIIS_FUNDS.fund_desc%TYPE
    );
    TYPE giac_tax_payments_tab IS TABLE OF giac_tax_payments_type;
    
    TYPE giac_taxes_type IS RECORD(
        gl_acct_id              GIAC_TAXES.gl_acct_id%TYPE,
        tax_cd                  GIAC_TAXES.tax_cd%TYPE,
        tax_name                GIAC_TAXES.tax_name%TYPE,
        sl_type_cd              GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE
    );
    TYPE giac_taxes_table IS TABLE OF giac_taxes_type;
    
    TYPE sl_list_type IS RECORD(
        sl_cd                   GIAC_SL_LISTS.sl_cd%TYPE, 
        sl_name                 GIAC_SL_LISTS.sl_name%TYPE, 
        item_no                 GIAC_MODULE_ENTRIES.item_no%TYPE,
        sl_type_cd              GIAC_SL_LISTS.sl_type_cd%TYPE
    );    
    TYPE sl_list_tab IS TABLE OF sl_list_type;
    
    TYPE giacs021_variables_type IS RECORD(
        total_tax               GIAC_TAX_PAYMENTS.tax_amt%TYPE,
        max_item                GIAC_TAX_PAYMENTS.item_no%TYPE
    );
    TYPE giacs021_variables_table IS TABLE OF giacs021_variables_type;
    
    TYPE item_list_type IS RECORD(
        item_no                 GIAC_TAX_PAYMENTS.item_no%TYPE
    );
    TYPE item_list_tab IS TABLE OF item_list_type;

    FUNCTION get_giac_tax_payments(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.gacc_tran_id%TYPE
    )
      RETURN giac_tax_payments_tab PIPELINED;
      
    FUNCTION get_giacs021_variables(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.gacc_tran_id%TYPE
    )
      RETURN giacs021_variables_table PIPELINED;
      
    FUNCTION get_giacs021_item_list(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.gacc_tran_id%TYPE
    )
      RETURN item_list_tab PIPELINED;
      
    FUNCTION get_taxes(
        p_fund_cd               GIAC_TAX_PAYMENTS.fund_cd%TYPE
    )
      RETURN giac_taxes_table PIPELINED;
      
    FUNCTION get_sl_list(
        p_sl_type_cd            GIAC_SL_LISTS.sl_type_cd%TYPE,
        p_find                  GIAC_SL_LISTS.sl_name%TYPE
    )
      RETURN sl_list_tab PIPELINED;
      
    PROCEDURE delete_giac_tax_payment(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.gacc_tran_id%TYPE,
        p_item_no               GIAC_TAX_PAYMENTS.item_no%TYPE
    );
    
    PROCEDURE insert_giac_tax_payment(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.gacc_tran_id%TYPE,
        p_item_no               GIAC_TAX_PAYMENTS.item_no%TYPE,
        p_transaction_type      GIAC_TAX_PAYMENTS.transaction_type%TYPE,
        p_fund_cd               GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_tax_cd                GIAC_TAX_PAYMENTS.tax_cd%TYPE,
        p_branch_cd             GIAC_TAX_PAYMENTS.branch_cd%TYPE,
        p_tax_amt               GIAC_TAX_PAYMENTS.tax_amt%TYPE,
        p_or_print_tag          GIAC_TAX_PAYMENTS.or_print_tag%TYPE,
        p_remarks               GIAC_TAX_PAYMENTS.remarks%TYPE,
        p_user_id               GIAC_TAX_PAYMENTS.user_id%TYPE,
        p_sl_cd                 GIAC_TAX_PAYMENTS.sl_cd%TYPE,
        p_sl_type_cd            GIAC_TAX_PAYMENTS.sl_type_cd%TYPE
    );
      
    PROCEDURE aeg_parameters_giacs021(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_fund_cd               GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_branch_cd             GIAC_TAX_PAYMENTS.branch_cd%TYPE,
        p_user_id               GIAC_TAX_PAYMENTS.user_id%TYPE
    );
    
    PROCEDURE delete_acct_entries_giacs021(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_gen_type              GIAC_MODULES.generation_type%TYPE
    );
    
    PROCEDURE create_acct_entries_giacs021(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_fund_cd               GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_branch_cd             GIAC_TAX_PAYMENTS.branch_cd%TYPE,
        p_user_id               GIAC_TAX_PAYMENTS.user_id%TYPE,
        p_module_id             GIAC_MODULE_ENTRIES.module_id%TYPE,
        p_item_no               GIAC_MODULE_ENTRIES.item_no%TYPE,
        p_gen_type              GIAC_ACCT_ENTRIES.generation_type%TYPE,
        p_gl_acct_category      GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
        p_gl_control_acct       GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
        p_gl_sub_acct_1         GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        p_gl_sub_acct_2   	    GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        p_gl_sub_acct_3	        GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        p_gl_sub_acct_4         GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        p_gl_sub_acct_5   	    GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        p_gl_sub_acct_6	        GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        p_gl_sub_acct_7   	    GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        p_gl_acct_id 	        GIAC_ACCT_ENTRIES.gl_acct_id%TYPE,
        p_acct_amt              GIAC_TAX_PAYMENTS.tax_amt%TYPE,
        p_sl_cd                 GIAC_TAX_PAYMENTS.sl_cd%TYPE,
        p_sl_type_cd            GIAC_TAX_PAYMENTS.sl_type_cd%TYPE
    );
    
    PROCEDURE check_chart_of_account(
        cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
        cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
        cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE 
    );
    
    PROCEDURE insert_update_acct_entries(
        p_gacc_tran_id          GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_fund_cd               GIAC_TAX_PAYMENTS.fund_cd%TYPE,
        p_branch_cd             GIAC_TAX_PAYMENTS.branch_cd%TYPE,
        p_user_id               GIAC_TAX_PAYMENTS.user_id%TYPE,
        iuae_gl_acct_category   GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
        iuae_gl_control_acct    GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
        iuae_gl_sub_acct_1      GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        iuae_gl_sub_acct_2      GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        iuae_gl_sub_acct_3      GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        iuae_gl_sub_acct_4      GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        iuae_gl_sub_acct_5      GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        iuae_gl_sub_acct_6      GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        iuae_gl_sub_acct_7      GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        iuae_generation_type    GIAC_ACCT_ENTRIES.generation_type%TYPE,
        iuae_gl_acct_id         GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
        iuae_debit_amt          GIAC_ACCT_ENTRIES.debit_amt%TYPE,
        iuae_credit_amt         GIAC_ACCT_ENTRIES.credit_amt%TYPE,
        iuae_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE ,
        iuae_sl_type_cd         GIAC_ACCT_ENTRIES.sl_type_cd%TYPE
    );
    
END;
/



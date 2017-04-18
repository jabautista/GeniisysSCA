CREATE OR REPLACE PACKAGE CPI.GIAC_INPUT_VAT_PKG
AS

    TYPE giac_input_vat_type IS RECORD(
        gacc_tran_id            giac_input_vat.gacc_tran_id%TYPE,
        transaction_type        giac_input_vat.transaction_type%TYPE,
        payee_no                giac_input_vat.payee_no%TYPE,
        payee_class_cd          giac_input_vat.payee_class_cd%TYPE,
        reference_no            giac_input_vat.reference_no%TYPE,
        base_amt                giac_input_vat.base_amt%TYPE,
        input_vat_amt           giac_input_vat.input_vat_amt%TYPE,
        gl_acct_id              giac_input_vat.gl_acct_id%TYPE,
        vat_gl_acct_id          giac_input_vat.vat_gl_acct_id%TYPE,
        item_no                 giac_input_vat.item_no%TYPE,
        sl_cd                   giac_input_vat.sl_cd%TYPE,
        or_print_tag            giac_input_vat.or_print_tag%TYPE,
        remarks                 giac_input_vat.remarks%TYPE,
        user_id                 giac_input_vat.user_id%TYPE,
        last_update             giac_input_vat.last_update%TYPE,
        cpi_rec_no              giac_input_vat.cpi_rec_no%TYPE,
        cpi_branch_cd           giac_input_vat.cpi_branch_cd%TYPE,
        vat_sl_cd               giac_input_vat.vat_sl_cd%TYPE,
        dsp_payee_name          VARCHAR2(32000),
        gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
        gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
        gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,         
        gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
        gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
        gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
        gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
        gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
        gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
        gl_acct_name            giac_chart_of_accts.gl_acct_name%TYPE,
        gslt_sl_type_cd         giac_chart_of_accts.gslt_sl_type_cd%TYPE,
        dsp_sl_name             giac_sl_lists.sl_name%TYPE,
        vat_sl_name             giac_sl_lists.sl_name%TYPE,
        transaction_type_desc   cg_ref_codes.rv_meaning%TYPE,
        payee_class_desc        VARCHAR2(32000)
        );
        
    TYPE giac_input_vat_tab IS TABLE OF giac_input_vat_type;
        
    FUNCTION get_giac_input_vat(p_gacc_tran_id  giac_input_vat.gacc_tran_id%TYPE,
                                p_gacc_fund_cd  giac_sl_lists.fund_cd%TYPE)
    RETURN giac_input_vat_tab PIPELINED;
    
    PROCEDURE del_giac_input_vat(
        p_gacc_tran_id            giac_input_vat.gacc_tran_id%TYPE,
        p_transaction_type        giac_input_vat.transaction_type%TYPE,
        p_payee_no                giac_input_vat.payee_no%TYPE,
        p_payee_class_cd          giac_input_vat.payee_class_cd%TYPE,
        p_reference_no            giac_input_vat.reference_no%TYPE
        );
    
    PROCEDURE set_giac_input_vat(
        p_gacc_tran_id            giac_input_vat.gacc_tran_id%TYPE,
        p_transaction_type        giac_input_vat.transaction_type%TYPE,
        p_payee_no                giac_input_vat.payee_no%TYPE,
        p_payee_class_cd          giac_input_vat.payee_class_cd%TYPE,
        p_reference_no            giac_input_vat.reference_no%TYPE,
        p_base_amt                giac_input_vat.base_amt%TYPE,
        p_input_vat_amt           giac_input_vat.input_vat_amt%TYPE,
        p_gl_acct_id              giac_input_vat.gl_acct_id%TYPE,
        p_vat_gl_acct_id          giac_input_vat.vat_gl_acct_id%TYPE,
        p_item_no                 giac_input_vat.item_no%TYPE,
        p_sl_cd                   giac_input_vat.sl_cd%TYPE,
        p_or_print_tag            giac_input_vat.or_print_tag%TYPE,
        p_remarks                 giac_input_vat.remarks%TYPE,
        p_user_id                 giac_input_vat.user_id%TYPE,
        p_last_update             giac_input_vat.last_update%TYPE,
        p_cpi_rec_no              giac_input_vat.cpi_rec_no%TYPE,
        p_cpi_branch_cd           giac_input_vat.cpi_branch_cd%TYPE,
        p_vat_sl_cd               giac_input_vat.vat_sl_cd%TYPE
        );
        
    PROCEDURE update_giac_op_text(p_gacc_tran_id      IN   giac_input_vat.gacc_tran_id%TYPE,
                                 p_module_name        IN   giac_modules.module_name%TYPE,
                                 p_msg_alert          OUT  VARCHAR2);     
                                 
    PROCEDURE aeg_create_acct_entries (
       aeg_collection_amt   giac_bank_collns.collection_amt%TYPE,
       aeg_gen_type         giac_acct_entries.generation_type%TYPE,
       aeg_module_id        giac_modules.module_id%TYPE,
       aeg_item_no          giac_module_entries.item_no%TYPE,
       aeg_sl_cd            giac_acct_entries.sl_cd%TYPE,
       aeg_gl_acct_id       giac_acct_entries.gl_acct_id%TYPE,
       aeg_pop_gl_acct_cd   BOOLEAN,
       aeg_sl_type_cd       giac_acct_entries.sl_type_cd%TYPE,
       p_msg_alert      OUT VARCHAR2,
       p_contra_acct        BOOLEAN,
       p_gacc_branch_cd     giac_acct_entries.GACC_GIBR_BRANCH_CD%TYPE,
       p_gacc_fund_cd       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
       p_gacc_tran_id       giac_acct_entries.gacc_tran_id%TYPE);
    
    PROCEDURE aeg_parameters(
               p_gacc_tran_id     giac_acctrans.tran_id%TYPE,
               p_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
               p_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
               p_module_name      giac_modules.module_name%TYPE,
               p_vat_gl_acct_id   giac_input_vat.vat_gl_acct_id%TYPE,
               p_base_amt         giac_input_vat.base_amt%TYPE,
               p_msg_alert    OUT VARCHAR2);
END;
/



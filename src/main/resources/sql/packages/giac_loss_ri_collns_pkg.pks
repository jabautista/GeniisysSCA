CREATE OR REPLACE PACKAGE CPI.giac_loss_ri_collns_pkg
AS
    PROCEDURE CGFK$CHK_GCRR_GCRR_E150_FK(
            p_a180_ri_cd          giac_loss_ri_collns.a180_ri_cd%TYPE,
            p_e150_line_cd        giac_loss_ri_collns.e150_line_cd%TYPE,
            p_e150_la_yy          giac_loss_ri_collns.e150_la_yy%TYPE,
            p_e150_fla_seq_no     giac_loss_ri_collns.e150_fla_seq_no%TYPE,
            p_msg_alert       OUT VARCHAR2
            );
            
    PROCEDURE GET_DEFAULT_VALUE(
        p_gacc_tran_id        IN  giac_loss_ri_collns.gacc_tran_id%TYPE,
        p_transaction_type    IN  giac_loss_ri_collns.transaction_type%TYPE,
        p_dsp_policy          IN  VARCHAR2,
        p_payee_type          IN  giac_loss_ri_collns.payee_type%TYPE,
        p_a180_ri_cd          IN  giac_loss_ri_collns.a180_ri_cd%TYPE,
        p_e150_line_cd        IN  giac_loss_ri_collns.e150_line_cd%TYPE,
        p_e150_la_yy          IN  giac_loss_ri_collns.e150_la_yy%TYPE,
        p_e150_fla_seq_no     IN  giac_loss_ri_collns.e150_fla_seq_no%TYPE,
        p_sve_collecion_amt   IN  giac_loss_ri_collns.collection_amt%TYPE,
        p_collecion_amt      OUT  giac_loss_ri_collns.collection_amt%TYPE,
        p_foreign_curr_amt   OUT  giac_loss_ri_collns.foreign_curr_amt%TYPE,
        p_currency_cd        OUT  giac_loss_ri_collns.currency_cd%TYPE,
        p_currency_desc      OUT  giis_currency.currency_desc%TYPE,
        p_convert_rate       OUT  giis_currency.currency_rt%TYPE, 
        p_msg_alert          OUT  VARCHAR2
        );

    TYPE loss_advice_list_type IS RECORD(
        dsp_ri_cd               gicl_advs_fla.ri_cd%TYPE,
        dsp_line_cd             gicl_advs_fla.line_cd%TYPE,
        dsp_la_yy               gicl_advs_fla.la_yy%TYPE,
        dsp_fla_seq_no          gicl_advs_fla.fla_seq_no%TYPE,
        dsp_payee_type          gicl_advs_fla_type.payee_type%TYPE,
        dsp_fla_date            gicl_advs_fla.fla_date%TYPE,
        nbt_claim_id            gicl_claims.claim_id%TYPE,
        dsp_clm_line_cd         gicl_claims.line_cd%TYPE,
        dsp_clm_subline_cd      gicl_claims.subline_cd%TYPE,
        dsp_clm_iss_cd          gicl_claims.iss_cd%TYPE,
        dsp_clm_yy              gicl_claims.clm_yy%TYPE,
        dsp_clm_seq_no          gicl_claims.clm_seq_no%TYPE,
        nbt_claim               VARCHAR2(32000),
        dsp_pol_line_cd         gicl_claims.line_cd%TYPE,
        dsp_pol_subline_cd      gicl_claims.subline_cd%TYPE,
        dsp_pol_iss_cd          gicl_claims.iss_cd%TYPE,
        dsp_pol_issue_yy        gicl_claims.issue_yy%TYPE,
        dsp_pol_seq_no          gicl_claims.pol_seq_no%TYPE,
        dsp_pol_renew_no        gicl_claims.renew_no%TYPE,
        nbt_policy              VARCHAR2(32000),
        dsp_loss_date           gicl_claims.loss_date%TYPE,
        dsp_assd_name           gicl_claims.assured_name%TYPE,
        dsp_collection_amt      giac_loss_ri_collns.collection_amt%TYPE,
        nbt_gacc_tran_id        giac_loss_ri_collns.gacc_tran_id%TYPE,
        dsp_foreign_curr_amt    giac_loss_ri_collns.foreign_curr_amt%TYPE,
        dsp_currency_cd         giac_loss_ri_collns.currency_cd%TYPE,
        dsp_currency_desc       giis_currency.currency_desc%TYPE,
        dsp_convert_rate        giis_currency.currency_rt%TYPE, 
        dsp_msg_alert           VARCHAR2(32000)
        );
       
    TYPE loss_advice_list_tab IS TABLE OF loss_advice_list_type;
    
    FUNCTION get_loss_advice_list(
            p_transaction_type    giac_loss_ri_collns.transaction_type%TYPE,  
            p_share_type          giac_loss_ri_collns.share_type%TYPE,
            p_a180_ri_cd          giac_loss_ri_collns.a180_ri_cd%TYPE,
            p_e150_line_cd        giac_loss_ri_collns.e150_line_cd%TYPE,
            p_e150_la_yy          giac_loss_ri_collns.e150_la_yy%TYPE,
            p_e150_fla_seq_no     giac_loss_ri_collns.e150_fla_seq_no%TYPE,
            p_user_id             giis_users.user_id%TYPE --added by robert 03.18.2013
            )
    RETURN loss_advice_list_tab PIPELINED;
    
    TYPE giac_loss_ri_collns_type IS RECORD(
        gacc_tran_id                giac_loss_ri_collns.gacc_tran_id%TYPE,    
        a180_ri_cd                  giac_loss_ri_collns.a180_ri_cd%TYPE,   
        transaction_type            giac_loss_ri_collns.transaction_type%TYPE,   
        e150_line_cd                giac_loss_ri_collns.e150_line_cd%TYPE,   
        e150_la_yy                  giac_loss_ri_collns.e150_la_yy%TYPE,   
        e150_fla_seq_no             giac_loss_ri_collns.e150_fla_seq_no%TYPE,   
        collection_amt              giac_loss_ri_collns.collection_amt%TYPE,   
        claim_id                    giac_loss_ri_collns.claim_id%TYPE,   
        currency_cd                 giac_loss_ri_collns.currency_cd%TYPE,   
        convert_rate                giac_loss_ri_collns.convert_rate%TYPE,   
        foreign_curr_amt            giac_loss_ri_collns.foreign_curr_amt%TYPE,   
        or_print_tag                giac_loss_ri_collns.or_print_tag%TYPE,   
        particulars                 giac_loss_ri_collns.particulars%TYPE,   
        user_id                     giac_loss_ri_collns.user_id%TYPE,   
        last_update                 giac_loss_ri_collns.last_update%TYPE,   
        cpi_rec_no                  giac_loss_ri_collns.cpi_rec_no%TYPE,   
        cpi_branch_cd               giac_loss_ri_collns.cpi_branch_cd%TYPE,   
        share_type                  giac_loss_ri_collns.share_type%TYPE,   
        payee_type                  giac_loss_ri_collns.payee_type%TYPE,
        ri_name                     giis_reinsurer.ri_name%TYPE,
        currency_desc               giis_currency.currency_desc%TYPE,
        share_type_desc             cg_ref_codes.rv_meaning%TYPE,
        transaction_type_desc       cg_ref_codes.rv_meaning%TYPE,
        dsp_policy                  VARCHAR2(32000),
        dsp_claim                   VARCHAR2(32000),
        dsp_assd_name               gicl_claims.assured_name%TYPE
        );
        
    TYPE giac_loss_ri_collns_tab IS TABLE OF giac_loss_ri_collns_type;    
    
    PROCEDURE GET_ASSURED_POL_CLM(
            p_a180_ri_cd          IN  giac_loss_ri_collns.a180_ri_cd%TYPE,
            p_e150_line_cd        IN  giac_loss_ri_collns.e150_line_cd%TYPE,
            p_e150_la_yy          IN  giac_loss_ri_collns.e150_la_yy%TYPE,
            p_e150_fla_seq_no     IN  giac_loss_ri_collns.e150_fla_seq_no%TYPE,
            p_dsp_policy          OUT VARCHAR2,
            p_dsp_claim           OUT VARCHAR2,
            p_dsp_assd_name       OUT VARCHAR2
            );

    FUNCTION get_giac_loss_ri_collns (p_gacc_tran_id    giac_loss_ri_collns.gacc_tran_id%TYPE)
    RETURN giac_loss_ri_collns_tab PIPELINED;
    
    PROCEDURE del_giac_loss_ri_collns(
        p_gacc_tran_id          giac_loss_ri_collns.gacc_tran_id%TYPE,
        p_a180_ri_cd            giac_loss_ri_collns.a180_ri_cd%TYPE,
        p_e150_line_cd          giac_loss_ri_collns.e150_line_cd%TYPE,
        p_e150_la_yy            giac_loss_ri_collns.e150_la_yy%TYPE,
        p_e150_fla_seq_no       giac_loss_ri_collns.e150_fla_seq_no%TYPE,
        p_payee_type            giac_loss_ri_collns.PAYEE_TYPE%type     --added by shan 07.23.2013: SR-13688
        );

    PROCEDURE set_giac_loss_ri_collns(
        p_gacc_tran_id                giac_loss_ri_collns.gacc_tran_id%TYPE,    
        p_a180_ri_cd                  giac_loss_ri_collns.a180_ri_cd%TYPE,   
        p_transaction_type            giac_loss_ri_collns.transaction_type%TYPE,   
        p_e150_line_cd                giac_loss_ri_collns.e150_line_cd%TYPE,   
        p_e150_la_yy                  giac_loss_ri_collns.e150_la_yy%TYPE,   
        p_e150_fla_seq_no             giac_loss_ri_collns.e150_fla_seq_no%TYPE,   
        p_collection_amt              giac_loss_ri_collns.collection_amt%TYPE,   
        p_claim_id                    giac_loss_ri_collns.claim_id%TYPE,   
        p_currency_cd                 giac_loss_ri_collns.currency_cd%TYPE,   
        p_convert_rate                giac_loss_ri_collns.convert_rate%TYPE,   
        p_foreign_curr_amt            giac_loss_ri_collns.foreign_curr_amt%TYPE,   
        p_or_print_tag                giac_loss_ri_collns.or_print_tag%TYPE,   
        p_particulars                 giac_loss_ri_collns.particulars%TYPE,   
        p_user_id                     giac_loss_ri_collns.user_id%TYPE,   
        p_last_update                 giac_loss_ri_collns.last_update%TYPE,   
        p_cpi_rec_no                  giac_loss_ri_collns.cpi_rec_no%TYPE,   
        p_cpi_branch_cd               giac_loss_ri_collns.cpi_branch_cd%TYPE,   
        p_share_type                  giac_loss_ri_collns.share_type%TYPE,   
        p_payee_type                  giac_loss_ri_collns.payee_type%TYPE
        );
    
    TYPE get_sl_type_parameters_type IS RECORD(
        variables_assd_no           giac_parameters.param_value_v%TYPE,
        variables_ri_cd             giac_parameters.param_value_v%TYPE,
        variables_line_cd           giac_parameters.param_value_v%TYPE,
        variables_module_name       giac_modules.module_name%TYPE,
        variables_module_id         giac_modules.module_id%TYPE,
        variables_gen_type          giac_modules.generation_type%TYPE,
        variables_item_no           giac_module_entries.item_no%TYPE,
        variables_sl_type_cd1       VARCHAR2(32000),
        v_msg_Alert                 VARCHAR2(32000)
        );
        
    TYPE get_sl_type_parameters_tab IS TABLE OF get_sl_type_parameters_type;      
    
    PROCEDURE UPDATE_GIAC_OP_TEXT (
        p_gacc_tran_id                giac_loss_ri_collns.gacc_tran_id%TYPE
        );  
    
    FUNCTION get_sl_type_parameters(p_module_name     VARCHAR2)
    RETURN get_sl_type_parameters_tab PIPELINED;
        
    PROCEDURE AEG_Create_Acct_Entries
      (aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE,
       aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
       aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
       aeg_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
       aeg_bill_no            GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
       aeg_line_cd            GIIS_LINE.line_cd%TYPE,
       aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE,
       aeg_acct_amt           GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
       aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
       aeg_share_type         GICL_ADVS_FLA.share_type%TYPE,
       aeg_ri_cd              GICL_ADVS_FLA.ri_cd%TYPE,
       aeg_la_yy              GICL_ADVS_FLA.la_yy%TYPE,
       aeg_fla_seq_no         GICL_ADVS_FLA.fla_seq_no%TYPE,
       p_gacc_branch_cd       GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
       p_gacc_fund_cd         GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
       p_gacc_tran_id         GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
       p_user_id              GIIS_USERS.user_id%TYPE,
       p_msg_alert        OUT VARCHAR2);
       
    PROCEDURE AEG_Parameters(p_gacc_tran_id     GIAC_ACCTRANS.tran_id%TYPE,
                             p_sl_type_cd1      GIAC_PARAMETERS.param_name%TYPE,
                             p_gen_type         GIAC_MODULES.generation_type%TYPE,
                             p_module_id        GIAC_MODULES.module_id%TYPE,
                             p_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
                             p_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                             p_user_id          giis_users.user_id%TYPE,
                             p_msg_alert    OUT VARCHAR2);
                               
END;
/


DROP PUBLIC SYNONYM GIAC_LOSS_RI_COLLNS_PKG;

CREATE PUBLIC SYNONYM GIAC_LOSS_RI_COLLNS_PKG FOR CPI.GIAC_LOSS_RI_COLLNS_PKG;

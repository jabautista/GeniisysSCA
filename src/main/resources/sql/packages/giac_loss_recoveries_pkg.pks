CREATE OR REPLACE PACKAGE CPI.GIAC_LOSS_RECOVERIES_PKG
AS
    TYPE giac_loss_recoveries_type IS RECORD(
        gacc_tran_id                giac_loss_recoveries.gacc_tran_id%TYPE,
        transaction_type            giac_loss_recoveries.transaction_type%TYPE,
        claim_id                    giac_loss_recoveries.claim_id%TYPE,
        recovery_id                 giac_loss_recoveries.recovery_id%TYPE,
        payor_class_cd              giac_loss_recoveries.payor_class_cd%TYPE,
        payor_cd                    giac_loss_recoveries.payor_cd%TYPE,
        collection_amt              giac_loss_recoveries.collection_amt%TYPE,
        currency_cd                 giac_loss_recoveries.currency_cd%TYPE,
        convert_rate                giac_loss_recoveries.convert_rate%TYPE,
        foreign_curr_amt            giac_loss_recoveries.foreign_curr_amt%TYPE,
        or_print_tag                giac_loss_recoveries.or_print_tag%TYPE,
        remarks                     giac_loss_recoveries.remarks%TYPE,
        cpi_rec_no                  giac_loss_recoveries.cpi_rec_no%TYPE,
        cpi_branch_cd               giac_loss_recoveries.cpi_branch_cd%TYPE,
        user_id                     giac_loss_recoveries.user_id%TYPE,
        last_update                 giac_loss_recoveries.last_update%TYPE,
        acct_ent_tag                giac_loss_recoveries.acct_ent_tag%TYPE,
        transaction_type_desc       cg_ref_codes.rv_meaning%TYPE,
        line_cd                     gicl_clm_recovery.line_cd%TYPE,
        iss_cd                      gicl_clm_recovery.iss_cd%TYPE,
        rec_year                    gicl_clm_recovery.rec_year%TYPE,
        rec_seq_no                  gicl_clm_recovery.rec_seq_no%TYPE,
        dsp_claim_no                VARCHAR2(2000),
        dsp_policy_no               VARCHAR2(2000),
        dsp_loss_date               VARCHAR2(50),  --gicl_claims.dsp_loss_date%TYPE,     -- commented out by shan 06.14.2013 for PHILFIRE-QA SR-13432
        dsp_assured_name            gicl_claims.assured_name%TYPE,
        rec_type_cd                 gicl_clm_recovery.rec_type_cd%TYPE,
        rec_type_desc               giis_recovery_type.rec_type_desc%TYPE,
        payor_name                  VARCHAR2(32000),
        payor_class_desc            giis_payee_class.class_desc%TYPE,
        dsp_currency_desc           giis_currency.currency_desc%TYPE
        );
        
    TYPE giac_loss_recoveries_tab IS TABLE OF giac_loss_recoveries_type;
    
    FUNCTION get_giac_loss_recoveries(p_gacc_tran_id    giac_loss_recoveries.gacc_tran_id%TYPE)
    RETURN giac_loss_recoveries_tab PIPELINED;       

    TYPE recovery_no_list_type IS RECORD(
        line_cd                     gicl_clm_recovery.line_cd%TYPE,
        iss_cd                      gicl_clm_recovery.iss_cd%TYPE,
        rec_year                    gicl_clm_recovery.rec_year%TYPE,
        rec_seq_no                  gicl_clm_recovery.rec_seq_no%TYPE,
        claim_id                    giac_loss_recoveries.claim_id%TYPE,
        dsp_claim_no                VARCHAR2(2000),
        dsp_policy_no               VARCHAR2(2000),
        dsp_loss_date               gicl_claims.dsp_loss_date%TYPE,
        dsp_assured_name            gicl_claims.assured_name%TYPE,
        recovery_id                 giac_loss_recoveries.recovery_id%TYPE,
        rec_type_cd                 gicl_clm_recovery.rec_type_cd%TYPE,
        rec_type_desc               giis_recovery_type.rec_type_desc%TYPE,
        payor_name                  VARCHAR2(32000),
        payor_cd                    giac_loss_recoveries.payor_cd%TYPE,                    
        payor_class_desc            giis_payee_class.class_desc%TYPE, 
        payor_class_cd              giac_loss_recoveries.payor_class_cd%TYPE
        --dsp_currency_desc           giis_currency.currency_desc%TYPE
        );
    
    TYPE recovery_no_list_tab IS TABLE OF recovery_no_list_type;
    
    TYPE payor_name_list_type IS RECORD(
	    payor_class_cd              giac_loss_recoveries.payor_class_cd%TYPE,
	    class_desc                  giis_payee_class.class_desc%TYPE,
	    payor_cd                    giac_loss_recoveries.payor_cd%TYPE, 
	    payor_name                  VARCHAR2(32000)
    );
    
    TYPE payor_name_list_tab IS TABLE OF payor_name_list_type;
    
    FUNCTION get_recovery_no_list(p_keyword     VARCHAR,
								  p_user_id 	giis_users.user_id%TYPE) --added by steven 1.26.2013
    RETURN recovery_no_list_tab PIPELINED;
    
    FUNCTION get_recovery_no_list2(p_keyword     VARCHAR,
								   p_user_id 	 giis_users.user_id%TYPE) --added by steven 1.26.2013
    RETURN recovery_no_list_tab PIPELINED;
    
    FUNCTION get_recovery_no_list3(
                p_line_cd     gicl_clm_recovery.line_cd%TYPE,
        		p_iss_cd      gicl_clm_recovery.iss_cd%TYPE,
		        p_rec_year    gicl_clm_recovery.rec_year%TYPE,
		        p_rec_seq_no  gicl_clm_recovery.rec_seq_no%TYPE,
                p_payor_cd    gicl_recovery_payor.payor_cd%TYPE,
                p_payor_class gicl_recovery_payor.payor_class_cd%TYPE)
    RETURN recovery_no_list_tab PIPELINED;
    
    FUNCTION get_recovery_no_list4(
                p_line_cd     gicl_clm_recovery.line_cd%TYPE,
        		p_iss_cd      gicl_clm_recovery.iss_cd%TYPE,
		        p_rec_year    gicl_clm_recovery.rec_year%TYPE,
		        p_rec_seq_no  gicl_clm_recovery.rec_seq_no%TYPE,
                p_payor_cd    gicl_recovery_payor.payor_cd%TYPE,
                p_payor_class gicl_recovery_payor.payor_class_cd%TYPE)
    RETURN recovery_no_list_tab PIPELINED;
    
    FUNCTION get_payor_name(
                p_line_cd     gicl_clm_recovery.line_cd%TYPE,
        		p_iss_cd      gicl_clm_recovery.iss_cd%TYPE,
		        p_rec_year    gicl_clm_recovery.rec_year%TYPE,
		        p_rec_seq_no  gicl_clm_recovery.rec_seq_no%TYPE)
    RETURN payor_name_list_tab PIPELINED;
    
    FUNCTION get_payor_name2(
                p_line_cd     gicl_clm_recovery.line_cd%TYPE,
        		p_iss_cd      gicl_clm_recovery.iss_cd%TYPE,
		        p_rec_year    gicl_clm_recovery.rec_year%TYPE,
		        p_rec_seq_no  gicl_clm_recovery.rec_seq_no%TYPE)
    RETURN payor_name_list_tab PIPELINED;
    
    PROCEDURE get_sum_colln_amt(
                p_collection_amt        giac_loss_recoveries.collection_amt%TYPE,
                p_recovery_id           giac_loss_recoveries.recovery_id%TYPE,
                p_claim_id              giac_loss_recoveries.claim_id%TYPE,
                p_payor_class_cd        giac_loss_recoveries.payor_class_cd%TYPE,
                p_payor_cd              giac_loss_recoveries.payor_cd%TYPE,
                p_msg_alert        OUT  VARCHAR2,
                p_sum              OUT  NUMBER 
                );
                
    PROCEDURE get_currency (
        p_recovery_id          IN  giac_loss_recoveries.recovery_id%TYPE,
        p_claim_id             IN  giac_loss_recoveries.claim_id%TYPE,
        p_dsp_loss_date        IN  VARCHAR2,
        p_collection_amt       IN  giac_loss_recoveries.collection_amt%TYPE,
        p_currency_cd          OUT giac_loss_recoveries.currency_cd%TYPE,
        p_convert_rate         OUT giac_loss_recoveries.convert_rate%TYPE,
        p_dsp_currency_desc    OUT giis_currency.currency_desc%TYPE,
        p_foreign_curr_amt     OUT giac_loss_recoveries.foreign_curr_amt%TYPE,
        p_msg_alert            OUT VARCHAR2                       
        );    
        
    PROCEDURE validate_currency_code (
        p_dsp_loss_date        IN  VARCHAR2,
        p_collection_amt       IN  giac_loss_recoveries.collection_amt%TYPE,
        p_currency_cd          IN  giac_loss_recoveries.currency_cd%TYPE,
        p_convert_rate         OUT giac_loss_recoveries.convert_rate%TYPE,
        p_dsp_currency_desc    OUT giis_currency.currency_desc%TYPE,
        p_foreign_curr_amt     OUT giac_loss_recoveries.foreign_curr_amt%TYPE,
        p_msg_alert            OUT VARCHAR2                       
        );
            
    FUNCTION validate_before_deletion(
        p_claim_id                 giac_loss_recoveries.claim_id%TYPE,
        p_gacc_tran_id             giac_loss_recoveries.gacc_tran_id%TYPE
    )
    RETURN VARCHAR2;
    
    FUNCTION get_tran_flag(p_gacc_tran_id    giac_loss_recoveries.gacc_tran_id%TYPE)
    RETURN VARCHAR2;    
    
    PROCEDURE del_giac_loss_recoveries(
        p_gacc_tran_id           giac_loss_recoveries.gacc_tran_id%TYPE,
        p_claim_id               giac_loss_recoveries.claim_id%TYPE,
        p_recovery_id            giac_loss_recoveries.recovery_id%TYPE,
        p_payor_class_cd         giac_loss_recoveries.payor_class_cd%TYPE,
        p_payor_cd               giac_loss_recoveries.payor_cd%TYPE
        );  
        
    PROCEDURE set_giac_loss_recoveries(
        p_gacc_tran_id                giac_loss_recoveries.gacc_tran_id%TYPE,
        p_transaction_type            giac_loss_recoveries.transaction_type%TYPE,
        p_claim_id                    giac_loss_recoveries.claim_id%TYPE,
        p_recovery_id                 giac_loss_recoveries.recovery_id%TYPE,
        p_payor_class_cd              giac_loss_recoveries.payor_class_cd%TYPE,
        p_payor_cd                    giac_loss_recoveries.payor_cd%TYPE,
        p_collection_amt              giac_loss_recoveries.collection_amt%TYPE,
        p_currency_cd                 giac_loss_recoveries.currency_cd%TYPE,
        p_convert_rate                giac_loss_recoveries.convert_rate%TYPE,
        p_foreign_curr_amt            giac_loss_recoveries.foreign_curr_amt%TYPE,
        p_or_print_tag                giac_loss_recoveries.or_print_tag%TYPE,
        p_remarks                     giac_loss_recoveries.remarks%TYPE,
        p_cpi_rec_no                  giac_loss_recoveries.cpi_rec_no%TYPE,
        p_cpi_branch_cd               giac_loss_recoveries.cpi_branch_cd%TYPE,
        p_user_id                     giac_loss_recoveries.user_id%TYPE,
        p_last_update                 giac_loss_recoveries.last_update%TYPE,
        p_acct_ent_tag                giac_loss_recoveries.acct_ent_tag%TYPE
        );  
   
    PROCEDURE DEL_UPD_RECOVERY(
        p_gacc_tran_id           giac_loss_recoveries.gacc_tran_id%TYPE,
        p_claim_id               giac_loss_recoveries.claim_id%TYPE,
        p_recovery_id            giac_loss_recoveries.recovery_id%TYPE,
        p_payor_class_cd         giac_loss_recoveries.payor_class_cd%TYPE,
        p_payor_cd               giac_loss_recoveries.payor_cd%TYPE
        --p_collection_amt         giac_loss_recoveries.collection_amt%TYPE --lara 02-07-2014
        );
        
    PROCEDURE INSERT_RECOVERY_PAYT (
        p_gacc_tran_id          giac_loss_recoveries.gacc_tran_id%TYPE,
        p_claim_id              gicl_clm_recovery.claim_id%type,
        p_recovery_id           gicl_clm_recovery.recovery_id%type,
        p_payor_class_cd        gicl_recovery_payor.payor_class_cd%type,
        p_payor_cd              gicl_recovery_payor.payor_cd%type,  
        p_collection_amt        giac_loss_recoveries.collection_amt%type
        );  

    PROCEDURE UPDATE_RECOVERY_PAYOR (
        p_claim_id        gicl_clm_recovery.claim_id%type,
        p_recovery_id     gicl_clm_recovery.recovery_id%type,
        p_payor_class_cd  gicl_recovery_payor.payor_class_cd%type,
        p_payor_cd        gicl_recovery_payor.payor_cd%type,  
        p_collection_amt  giac_loss_recoveries.collection_amt%type
        );
        
    PROCEDURE UPDATE_CLM_RECOVERY (
        p_claim_id       gicl_clm_recovery.claim_id%type,
        p_recovery_id    gicl_clm_recovery.recovery_id%type,
        p_collection_amt giac_loss_recoveries.collection_amt%type
        );    
                
    PROCEDURE post_insert_giacs010(
        p_gacc_tran_id           giac_loss_recoveries.gacc_tran_id%TYPE,
        p_claim_id               giac_loss_recoveries.claim_id%TYPE,
        p_recovery_id            giac_loss_recoveries.recovery_id%TYPE,
        p_payor_class_cd         giac_loss_recoveries.payor_class_cd%TYPE,
        p_payor_cd               giac_loss_recoveries.payor_cd%TYPE
        );    
        
    PROCEDURE aeg_insert_update_acct_entries (
       iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
       iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
       iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
       iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
       iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
       iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
       iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
       iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
       iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
       iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
       iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
       iuae_generation_type    giac_acct_entries.generation_type%TYPE,
       iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
       iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
       iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
       p_gacc_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
       p_gacc_fund_cd          giac_acctrans.gfun_fund_cd%TYPE,
       p_gacc_tran_id          giac_acctrans.tran_id%TYPE,
       p_user_id               giis_users.user_id%TYPE);
       
    PROCEDURE aeg_create_acct_entries (
       aeg_sl_cd                giac_acct_entries.sl_cd%TYPE,
       aeg_module_id            giac_module_entries.module_id%TYPE,
       aeg_item_no              giac_module_entries.item_no%TYPE,
       aeg_iss_cd               gicl_claims.iss_cd%TYPE,
       aeg_line_cd              gipi_polbasic.line_cd%TYPE,
       aeg_acct_amt             giac_loss_recoveries.collection_amt%TYPE,
       aeg_gen_type             giac_acct_entries.generation_type%TYPE,
       p_gacc_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
       p_gacc_fund_cd           giac_acctrans.gfun_fund_cd%TYPE,
       p_gacc_tran_id           giac_acctrans.tran_id%TYPE,
       p_user_id                giis_users.user_id%TYPE,
       p_claim_id               gicl_basic_intm_v1.claim_id%TYPE,
       p_msg_alert          OUT VARCHAR2);
       
    PROCEDURE aeg_parameters (
        p_module_name            giac_modules.module_name%TYPE,
        p_gacc_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
        p_gacc_fund_cd           giac_acctrans.gfun_fund_cd%TYPE,
        p_gacc_tran_id           giac_acctrans.tran_id%TYPE,
        p_user_id                giis_users.user_id%TYPE,
        p_claim_id               gicl_basic_intm_v1.claim_id%TYPE,
        p_msg_alert          OUT VARCHAR2);
        
   FUNCTION check_collection_amt(
      p_recovery_id           giac_loss_recoveries.recovery_id%TYPE,
      p_claim_id              giac_loss_recoveries.claim_id%TYPE
   )
     RETURN VARCHAR2;
     
   FUNCTION get_payor_name_tran1(
      p_line_cd               gicl_clm_recovery.line_cd%TYPE,
      p_iss_cd                gicl_clm_recovery.iss_cd%TYPE,
      p_rec_year              gicl_clm_recovery.rec_year%TYPE,
      p_rec_seq_no            gicl_clm_recovery.rec_seq_no%TYPE,
      p_user_id               giis_users.user_id%TYPE
   )
     RETURN payor_name_list_tab PIPELINED;

END;
/



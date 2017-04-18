CREATE OR REPLACE PACKAGE CPI."GICL_ADVICE_PKG" 
AS
   TYPE gicl_advice_type IS RECORD (
      batch_csr_id         gicl_advice.batch_csr_id%TYPE,
      batch_dv_id          gicl_advice.batch_dv_id%TYPE,
      claim_id             gicl_advice.claim_id%TYPE,
      line_cd              gicl_advice.line_cd%TYPE,
      iss_cd               gicl_advice.iss_cd%TYPE,
      advice_year          gicl_advice.advice_year%TYPE,
      advice_seq_no        gicl_advice.advice_seq_no%TYPE,
      advice_id            gicl_advice.advice_id%TYPE,
      advice_flag          gicl_advice.advice_flag%TYPE,
      apprvd_tag           gicl_advice.apprvd_tag%TYPE,
      advice_no            VARCHAR2 (100),
      claim_no             VARCHAR2 (100),
      policy_no            VARCHAR2 (100),
      assd_no              gicl_claims.assd_no%TYPE,
      assured_name         gicl_claims.assured_name%TYPE,
      dsp_loss_date        gicl_claims.dsp_loss_date%TYPE,
      loss_cat_cd          gicl_claims.loss_cat_cd%TYPE,
      dsp_loss_cat_des     giis_loss_ctgry.loss_cat_des%TYPE,
      advice_date          gicl_advice.advice_date%TYPE,
      paid_amt             gicl_advice.paid_amt%TYPE,
      paid_fcurr_amt       gicl_advice.paid_fcurr_amt%TYPE,
      net_amt              gicl_advice.net_amt%TYPE,
      net_fcurr_amt        gicl_advice.net_fcurr_amt%TYPE,
      advise_amt           gicl_advice.advise_amt%TYPE,
      adv_fcurr_amt        gicl_advice.adv_fcurr_amt%TYPE,
      currency_cd          gicl_advice.currency_cd%TYPE,
      currency_desc        giis_currency.currency_desc%TYPE,
      convert_rate         gicl_advice.convert_rate%TYPE,
      clm_stat_cd          gicl_claims.clm_stat_cd%TYPE,
      dsp_clm_stat_desc    giis_clm_stat.clm_stat_desc%TYPE,
      payee_class_cd       giac_batch_dv.payee_class_cd%TYPE,
      payee_cd             giac_batch_dv.payee_cd%TYPE,
      dsp_payee            VARCHAR2 (1000),--VARCHAR2 (290),
      dsp_payee_class      giis_payee_class.class_desc%TYPE,
      check_currency       VARCHAR2 (290),
      dsp_paid_amt         gicl_advice.paid_amt%TYPE,
      dsp_paid_fcurr_amt   gicl_advice.paid_fcurr_amt%TYPE,
      conv_rt              gicl_advice.convert_rate%TYPE,
      loss_curr_cd         gicl_advice.currency_cd%TYPE,
      payee_remarks  gicl_advice.payee_remarks%TYPE,
      generate_sw          varchar2(1),
      payee_type giac_direct_claim_payts.payee_type%type,
      clm_loss_id          giac_batch_dv_dtl.clm_loss_id%TYPE,
      remarks              gicl_advice.remarks%TYPE
   );
   TYPE gicl_advice_tab IS TABLE OF gicl_advice_type;
   
   TYPE cancelled_advice_type IS RECORD(
      advice_id           GICL_ADVICE.advice_id%TYPE,
      claim_id            GICL_ADVICE.claim_id%TYPE,
      line_cd             GICL_ADVICE.line_cd%TYPE,
      iss_cd              GICL_ADVICE.iss_cd%TYPE,
      advice_year         GICL_ADVICE.advice_year%TYPE,
      advice_seq_no       GICL_ADVICE.advice_seq_no%TYPE,
      advice_no           VARCHAR2(100),
      user_id             GICL_ADVICE.user_id%TYPE,
      last_update         GICL_ADVICE.last_update%TYPE
    );

    TYPE cancelled_advice_tab IS TABLE OF cancelled_advice_type;
	
	TYPE gicls260_advice_type IS RECORD(
      advice_id           GICL_ADVICE.advice_id%TYPE,
      claim_id            GICL_ADVICE.claim_id%TYPE,
      line_cd             GICL_ADVICE.line_cd%TYPE,
      iss_cd              GICL_ADVICE.iss_cd%TYPE,
      advice_year         GICL_ADVICE.advice_year%TYPE,
      advice_seq_no       GICL_ADVICE.advice_seq_no%TYPE,
      advice_no           VARCHAR2(100),
	  csr_no			  VARCHAR2(100),
      user_id             GICL_ADVICE.user_id%TYPE,
      last_update         GICL_ADVICE.last_update%TYPE
    );

    TYPE gicls260_advice_tab IS TABLE OF gicls260_advice_type;

   FUNCTION get_gicl_advise_list (
      p_batch_csr_id   gicl_batch_csr.batch_csr_id%TYPE,
      p_module_id      VARCHAR2,
      p_user_id        giis_users.user_id%TYPE,
      p_line_cd        gicl_advice.line_cd%TYPE,
      p_iss_cd         gicl_advice.iss_cd%TYPE,
      p_subline_cd     gicl_claims.subline_cd%TYPE,
      p_advice_year    gicl_advice.advice_year%TYPE,
      p_advice_seq_no  gicl_advice.advice_seq_no%TYPE,
      p_assd_name      VARCHAR2,
      p_loss_date      VARCHAR2,--gicl_claims.dsp_loss_date%TYPE, replaced by: Nica 05.10.2013
      p_advice_date    VARCHAR2,--gicl_advice.advice_date%TYPE,
      p_loss_desc      giis_loss_ctgry.loss_cat_des%TYPE,
      p_paid_amt       gicl_advice.paid_amt%TYPE,
      p_net_amt        gicl_advice.net_amt%TYPE,
      p_advice_amt     gicl_advice.advise_amt%TYPE,
      p_currency       giis_currency.currency_desc%TYPE,
      p_convert_rate   gicl_advice.convert_rate%TYPE  
   )
      RETURN gicl_advice_tab PIPELINED;

   FUNCTION get_gicl_advise_list_2 (
      p_module_id      VARCHAR2,
      p_user_id        giis_users.user_id%TYPE,
      p_line_cd        gicl_advice.line_cd%TYPE,
      p_iss_cd         gicl_advice.iss_cd%TYPE,
      p_subline_cd     gicl_claims.subline_cd%TYPE,
      p_advice_year    gicl_advice.advice_year%TYPE,
      p_advice_seq_no  gicl_advice.advice_seq_no%TYPE,
      p_assd_name      VARCHAR2,
      p_loss_date      VARCHAR2,--gicl_claims.dsp_loss_date%TYPE, replaced by: Nica 05.10.2013
      p_advice_date    VARCHAR2,--gicl_advice.advice_date%TYPE,
      p_loss_desc      giis_loss_ctgry.loss_cat_des%TYPE,
      p_paid_amt       gicl_advice.paid_amt%TYPE,
      p_net_amt        gicl_advice.net_amt%TYPE,
      p_advice_amt     gicl_advice.advise_amt%TYPE,
      p_currency       giis_currency.currency_desc%TYPE,
      p_convert_rate   gicl_advice.convert_rate%TYPE
   )
      RETURN gicl_advice_tab PIPELINED;

   FUNCTION get_giacs086_advise_list (
      p_batch_dv_id      gicl_advice.batch_dv_id%TYPE,
      p_payee_class_cd   giac_batch_dv.payee_class_cd%TYPE,
      p_payee_cd         giac_batch_dv.payee_cd%TYPE,
      p_module_id        VARCHAR2,
      p_user_id          giis_users.user_id%TYPE,
      p_assured_name     gicl_claims.assured_name%TYPE,
      p_dsp_clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      p_loss_date           VARCHAR2,
      p_dsp_loss_cat_des    giis_loss_ctgry.loss_cat_des%TYPE,
      p_dsp_payee_class     giis_payee_class.class_desc%TYPE,
      p_dsp_payee           VARCHAR2,
      p_currency_desc       giis_currency.currency_desc%TYPE,
      p_convert_rate        gicl_advice.convert_rate%TYPE,
       p_line_cd        gicl_advice.line_cd%TYPE,
        p_iss_cd         gicl_advice.iss_cd%TYPE,
      p_subline_cd     gicl_claims.subline_cd%TYPE,
      p_advice_year    gicl_advice.advice_year%TYPE,
      p_advice_seq_no  gicl_advice.advice_seq_no%TYPE
   )
      RETURN gicl_advice_tab PIPELINED;

   FUNCTION get_giacs086_advise_list2 (
      p_batch_dv_id         gicl_advice.batch_dv_id%TYPE,
      p_payee_class_cd      giac_batch_dv.payee_class_cd%TYPE,
      p_payee_cd            giac_batch_dv.payee_cd%TYPE,
      p_module_id           VARCHAR2,
      p_user_id             giis_users.user_id%TYPE,
      p_claim_id            gicl_claims.claim_id%TYPE,
      p_assured_name        gicl_claims.assured_name%TYPE,
      p_dsp_clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      p_loss_date           VARCHAR2,
      p_dsp_loss_cat_des    giis_loss_ctgry.loss_cat_des%TYPE,
      p_dsp_payee_class     giis_payee_class.class_desc%TYPE,
      p_dsp_payee           VARCHAR2,
      p_currency_desc       giis_currency.currency_desc%TYPE,
      p_convert_rate        gicl_advice.convert_rate%TYPE,
      p_condition          number,
       p_line_cd        gicl_advice.line_cd%TYPE,
        p_iss_cd         gicl_advice.iss_cd%TYPE,
      p_subline_cd     gicl_claims.subline_cd%TYPE,
      p_advice_year    gicl_advice.advice_year%TYPE,
      p_advice_seq_no  gicl_advice.advice_seq_no%TYPE
   )
      RETURN gicl_advice_tab PIPELINED;
      
      TYPE advice_cur IS REF CURSOR return gicl_advice_type;
  
    FUNCTION get_advice_list_for_approval(
      p_batch_csr_id   gicl_batch_csr.batch_csr_id%TYPE
   )
      RETURN gicl_advice_tab PIPELINED;    
  
   TYPE gicls032_advice_type IS RECORD (
      claim_id             gicl_advice.claim_id%TYPE,
      line_cd              gicl_advice.line_cd%TYPE,
      iss_cd               gicl_advice.iss_cd%TYPE,
      advice_year          gicl_advice.advice_year%TYPE,
      advice_seq_no        gicl_advice.advice_seq_no%TYPE,
      advice_id            gicl_advice.advice_id%TYPE,
      advice_flag          gicl_advice.advice_flag%TYPE,
      apprvd_tag           gicl_advice.apprvd_tag%TYPE,
      adv_fla_id           gicl_advice.adv_fla_id%TYPE,
      advice_no            VARCHAR2 (100),
      advice_date          gicl_advice.advice_date%TYPE,
      paid_amt             gicl_advice.paid_amt%TYPE,
      paid_fcurr_amt       gicl_advice.paid_fcurr_amt%TYPE,
      net_amt              gicl_advice.net_amt%TYPE,
      net_fcurr_amt        gicl_advice.net_fcurr_amt%TYPE,
      advise_amt           gicl_advice.advise_amt%TYPE,
      adv_fcurr_amt        gicl_advice.adv_fcurr_amt%TYPE,
      currency_cd          gicl_advice.currency_cd%TYPE,
      currency_desc        giis_currency.currency_desc%TYPE,
      convert_rate         gicl_advice.convert_rate%TYPE,
      clm_stat_cd          gicl_claims.clm_stat_cd%TYPE,
      payee_remarks        gicl_advice.payee_remarks%TYPE,
      remarks              gicl_advice.remarks%TYPE,
      batch_csr_id         gicl_advice.batch_csr_id%TYPE,      
      batch_dv_id          gicl_advice.batch_dv_id%TYPE,
      batch_no             VARCHAR2(500)      
   );
   
   TYPE gicls032_advice_tab IS TABLE OF gicls032_advice_type;
   
  FUNCTION get_gicls032_clm_advice_list(
    p_claim_id GICL_CLAIMS.claim_id%TYPE
  ) RETURN gicls032_advice_tab PIPELINED;
  
  FUNCTION check_exist_gicl_advice
  (p_claim_id     IN   GICL_ADVICE.claim_id%TYPE)
   RETURN VARCHAR2;
   
  FUNCTION get_cancelled_gicl_advice_list(p_claim_id  GICL_ADVICE.claim_id%TYPE)
  RETURN cancelled_advice_tab PIPELINED;

  PROCEDURE update_remarks(
    p_claim_id  gicl_advice.claim_id%TYPE,
    p_advice_id gicl_advice.advice_id%TYPE,
    p_remarks   gicl_advice.remarks%TYPE
  );
  
  TYPE giacs017_advice_list_type IS RECORD (
    advice_id               GICL_ADVICE.advice_id%TYPE, --added by reymon 04242013
    iss_cd      			GICL_ADVICE.iss_cd%TYPE,
    advice_year      	    GICL_ADVICE.advice_year%TYPE,
    line_cd     			GICL_ADVICE.line_cd%TYPE,
    advice_seq_no    	    GICL_ADVICE.advice_seq_no%TYPE,
    paid_amt				GICL_CLM_LOSS_EXP.paid_amt%TYPE,
    dsp_payee				VARCHAR2(1000),--changed 100 to 1000 reymon 04242013
    dsp_p_type				VARCHAR2(20),
    payee_class_cd			GIIS_PAYEES.payee_class_cd%TYPE,
    peril_sname				GIIS_PERIL.peril_sname%TYPE,
    net_amt					NUMBER(17,2),
    net_disb_amt			GICL_CLM_LOSS_EXP.paid_amt%TYPE,
    payee_cd				GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    claim_id				GICL_ADVICE.claim_id%TYPE,
    clm_loss_id				GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
    payee_type				GICL_CLM_LOSS_EXP.payee_type%TYPE,
    dsp_advice_no           VARCHAR2(40)   
  );
  
  TYPE giacs017_advice_list_tab IS TABLE OF giacs017_advice_list_type;
  
  FUNCTION get_advice_list_giacs017 (
     p_line_cd              GICL_ADVICE.line_cd%TYPE,
     p_iss_cd               GICL_ADVICE.iss_cd%TYPE,
     p_advice_year          GICL_ADVICE.advice_year%TYPE,
     p_advice_seq_no        GICL_ADVICE.advice_seq_no%TYPE,
     p_ri_iss_cd            GICL_ADVICE.iss_cd%TYPE,
     p_tran_type            GIAC_DIRECT_CLAIM_PAYTS.transaction_type%TYPE,
     p_module_id            GIIS_MODULES.module_id%TYPE,
     p_user_id              GIIS_USERS.user_id%TYPE
  ) RETURN giacs017_advice_list_tab PIPELINED;

  PROCEDURE revert_advice(p_claim_id gicl_advice.claim_id%TYPE);

/**
  * Created by: Andrew Robes
  * Date created: 03.28.2012
  * Referenced by : (GICLS032 - Generate Advice)
  * Description : Record type to hold variables used in generate advice
  */
    TYPE gicls032_variables IS RECORD(
       v_claim_sl_cd            giac_parameters.param_value_n%TYPE,
       v_assd_sl_type           giac_parameters.param_value_v%TYPE,
       v_ri_sl_type             giac_parameters.param_value_v%TYPE,
       v_line_sl_type           giac_parameters.param_value_v%TYPE,
       v_intm_sl_type           giac_parameters.param_value_v%TYPE,
       v_adj_sl_type            giac_parameters.param_value_v%TYPE,
       v_lawyer_sl_type         giac_parameters.param_value_v%TYPE,
       v_motshop_sl_type        giac_parameters.param_value_v%TYPE,
       v_branch_sl_type         giac_parameters.param_value_v%TYPE,
       v_lsp_sl_type            giac_parameters.param_value_v%TYPE,
       v_trty_shr_type          giac_parameters.param_value_v%TYPE,
       v_xol_shr_type           giac_parameters.param_value_v%TYPE,
       v_facul_shr_type         giac_parameters.param_value_v%TYPE,
       v_exp_payee_type         giac_parameters.param_value_v%TYPE,
       v_loss_payee_type        giac_parameters.param_value_v%TYPE,
       v_module_id              giac_modules.module_id%TYPE,
       v_gen_type               giac_modules.generation_type%TYPE,
       v_cur_name               giac_parameters.param_value_v%TYPE,
       v_ri_recov               giac_parameters.param_value_v%TYPE,
       v_setup                  giac_parameters.param_value_n%TYPE,
       v_param                  giac_parameters.param_value_v%TYPE,
       os_module_id             giac_modules.module_id%TYPE,
       v_gl_acct_ctgry          giac_module_entries.gl_acct_category%TYPE,
       v_separate_xol_entries   giac_parameters.param_value_v%TYPE,       
       v_ri_iss_cd              giac_parameters.param_value_v%TYPE,
       v_module_name            giac_modules.module_name%TYPE,
       v_separate_booking       giac_parameters.param_value_v%TYPE,
       v_local_currency         giac_parameters.param_value_n%TYPE
    );

    TYPE final_loss_advice_type IS RECORD(
        advice_id               GICL_ADVICE.advice_id%TYPE,
        advice_no               VARCHAR2(100),
        line_cd                 GICL_ADVICE.line_cd%TYPE,
        iss_cd                  GICL_ADVICE.iss_cd%TYPE,
        advice_year             GICL_ADVICE.advice_year%TYPE,
        advice_seq_no           GICL_ADVICE.advice_seq_no%TYPE,
        currency_cd             GICL_ADVICE.currency_cd%TYPE,
        currency_desc           GIIS_CURRENCY.currency_desc%TYPE,
        paid_amt                GICL_ADVICE.paid_amt%TYPE,
        net_amt                 GICL_ADVICE.net_amt%TYPE,
        advise_amt              GICL_ADVICE.advise_amt%TYPE,
        adv_fla_id              GICL_ADVICE.adv_fla_id%TYPE,
        generate_sw             VARCHAR2(10)
    );
    TYPE final_loss_advice_tab IS TABLE OF final_loss_advice_type;

    FUNCTION get_final_loss_advice_list(
        p_claim_id              GICL_CLAIMS.claim_id%TYPE
    )
    RETURN final_loss_advice_tab PIPELINED;

    FUNCTION check_generated_fla(
        p_claim_id              GICL_ADVICE.claim_id%TYPE,
        p_advice_id             GICL_ADVICE.advice_id%TYPE
    )
    RETURN VARCHAR2;
	
	FUNCTION get_gicls260_advice(
		p_claim_id              GICL_CLAIMS.claim_id%TYPE,
		p_iss_cd				GICL_CLAIMS.iss_cd%TYPE,
        p_advice_id             GICL_ADVICE.advice_id%TYPE,
		p_clm_loss_id			GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
		p_hist_seq_no			GICL_CLM_LOSS_EXP.hist_seq_no%TYPE
	)
 	 RETURN gicls260_advice_tab PIPELINED;

END gicl_advice_pkg;
/



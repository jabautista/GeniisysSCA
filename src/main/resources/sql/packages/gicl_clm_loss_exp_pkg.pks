CREATE OR REPLACE PACKAGE CPI.GICL_CLM_LOSS_EXP_PKG AS

/****************************************************************
 * PACKAGE NAME : GICL_CLAIM_LOSS_EXP_PKG
 * MODULE NAME  : GIACS017
 * CREATED BY   : RENCELA
 * DATE CREATED : 2010-10-11
 * MODIFICATIONS-------------------------------------------------
 * MODIFIED BY  | DATE      | REMARKS 
 * RENCELA        20101011   MODULE CREATED 
*****************************************************************/

   TYPE clm_loss_exp_type IS RECORD(
        claim_id            GICL_CLAIMS.claim_id%TYPE,
        clm_loss_id         GICL_CLM_LOSS_EXP.clm_loss_id%TYPE, 
        hist_seq_no         VARCHAR2(4),
        item_no             GICL_CLM_LOSS_EXP.item_no%TYPE,
        peril_cd            GICL_CLM_LOSS_EXP.peril_cd%TYPE,
        peril_sname         GIIS_PERIL.peril_sname%TYPE,
        item_stat_cd        GICL_CLM_LOSS_EXP.item_stat_cd%TYPE,
        le_stat_desc        GICL_LE_STAT.le_stat_desc%TYPE,
        payee_type          GICL_CLM_LOSS_EXP.payee_type%TYPE,
        payee_cd            VARCHAR2(12),
        payee_class_cd      GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
        ex_gratia_sw        GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,
        user_id             GICL_CLM_LOSS_EXP.user_id%TYPE,
        last_update         GICL_CLM_LOSS_EXP.last_update%TYPE,
        dist_sw             GICL_CLM_LOSS_EXP.dist_sw%TYPE,
        paid_amt            GICL_CLM_LOSS_EXP.paid_amt%TYPE,
        net_amt             GICL_CLM_LOSS_EXP.net_amt%TYPE,
        advice_amt          GICL_CLM_LOSS_EXP.advise_amt%TYPE,
        cpi_rec_no          GICL_CLM_LOSS_EXP.cpi_rec_no%TYPE,
        cpi_branch_cd       GICL_CLM_LOSS_EXP.cpi_branch_cd%TYPE,
        remarks             GICL_CLM_LOSS_EXP.remarks%TYPE,
        cancel_sw           GICL_CLM_LOSS_EXP.cancel_sw%TYPE,
        advice_id           GICL_CLM_LOSS_EXP.advice_id%TYPE,
        tran_id             GICL_CLM_LOSS_EXP.tran_id%TYPE,
        dist_type           GICL_CLM_LOSS_EXP.dist_type%TYPE,
        clm_clmnt_no        GICL_CLM_LOSS_EXP.clm_clmnt_no%TYPE,
        final_tag           GICL_CLM_LOSS_EXP.final_tag%TYPE,
        tran_date           GICL_CLM_LOSS_EXP.tran_date%TYPE,
        currency_cd         GICL_CLM_LOSS_EXP.currency_cd%TYPE,
        currency_rate       GICL_CLM_LOSS_EXP.currency_rate%TYPE,
        grouped_item_no     GICL_CLM_LOSS_EXP.grouped_item_no%TYPE,
        payee_type_desc     VARCHAR2(30),
        payee_class_desc    VARCHAR2(30),
        payee_last_name     GIIS_PAYEES.payee_last_name%TYPE,
        check_no            VARCHAR2(50),
        check_date          GIAC_CHK_DISBURSEMENT.check_date%TYPE,
        csr_no              VARCHAR2(50),
        exist_loss_exp_dtl  VARCHAR2(1),
        exist_loss_exp_ds   VARCHAR2(1),
        exist_le_ds_not_neg VARCHAR2(1),
        exist_loss_exp_tax  VARCHAR2(1),
        exist_gicl_advice   VARCHAR2(1),
        exist_eval_payment  VARCHAR2(1),
        exist_depreciation  VARCHAR2(1)
    );   
   
   TYPE clm_loss_exp_tab IS TABLE OF clm_loss_exp_type;
   
   TYPE clm_loss_subtype IS RECORD (
        claim_loss_id       GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
        payee_type          GICL_CLM_LOSS_EXP.payee_type%TYPE,
        payee_type_desc     VARCHAR2(20),
        payee_class_cd      GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
        payee_cd            GICL_CLM_LOSS_EXP.payee_cd%TYPE,
        payee               VARCHAR2(150),
        peril_cd            GICL_CLM_LOSS_EXP.peril_cd%TYPE,
        peril_sname         GIIS_PERIL.peril_sname%TYPE,
        net_amt             NUMBER(12,2),
        paid_amt            GICL_CLM_LOSS_EXP.paid_amt%TYPE,
        advice_amt          GICL_CLM_LOSS_EXP.advise_amt%TYPE
   );

   TYPE clm_loss_id_tab IS TABLE OF clm_loss_subtype;

   FUNCTION get_clm_loss(
            p_line_cd       GIIS_PERIL.line_cd%TYPE,
            p_advice_id     GICL_CLM_LOSS_EXP.advice_id%TYPE,
            p_claim_id      GICL_CLM_LOSS_EXP.claim_id%TYPE,
            p_claim_loss_id GICL_CLM_LOSS_EXP.clm_loss_id%TYPE
   )RETURN clm_loss_subtype; 
   
   FUNCTION get_clm_loss2(
            p_line_cd       GIIS_PERIL.line_cd%TYPE,
            p_advice_id     GICL_CLM_LOSS_EXP.advice_id%TYPE,
            p_claim_id      GICL_CLM_LOSS_EXP.claim_id%TYPE,
            p_claim_loss_id GICL_CLM_LOSS_EXP.clm_loss_id%TYPE
   )RETURN clm_loss_subtype;
   
   PROCEDURE set_clm_loss_exp(
        p_clm_loss_exp      IN GICL_CLM_LOSS_EXP%ROWTYPE
        /*p_claim_id          IN GICL_CLAIMS.claim_id%TYPE,
        p_clm_loss_id         IN GICL_CLM_LOSS_EXP.clm_loss_id%TYPE, 
        p_hist_seq_no         IN GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,
        p_item_no             IN GICL_CLM_LOSS_EXP.item_no%TYPE,
        p_peril_cd            IN GICL_CLM_LOSS_EXP.peril_cd%TYPE,
        p_item_stat_cd        IN GICL_CLM_LOSS_EXP.item_stat_cd%TYPE,
        p_payee_type          IN GICL_CLM_LOSS_EXP.payee_type%TYPE,
        p_payee_cd            IN GICL_CLM_LOSS_EXP.payee_cd%TYPE,
        p_payee_class_cd      IN GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
        p_ex_gratia_sw        IN GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,
        p_user_id             IN GICL_CLM_LOSS_EXP.user_id%TYPE,
        p_last_update         IN GICL_CLM_LOSS_EXP.last_update%TYPE,
        p_dist_sw             IN GICL_CLM_LOSS_EXP.dist_sw%TYPE,
        p_paid_amt            IN GICL_CLM_LOSS_EXP.paid_amt%TYPE,
        p_net_amt             IN GICL_CLM_LOSS_EXP.net_amt%TYPE,
        p_advice_amt          IN GICL_CLM_LOSS_EXP.advise_amt%TYPE,
        p_cpi_rec_no          IN GICL_CLM_LOSS_EXP.cpi_rec_no%TYPE,
        p_cpi_branch_cd       IN GICL_CLM_LOSS_EXP.cpi_branch_cd%TYPE,
        p_remarks             IN GICL_CLM_LOSS_EXP.remarks%TYPE,
        p_cancel_sw           IN GICL_CLM_LOSS_EXP.cancel_sw%TYPE,
        p_advice_id           IN GICL_CLM_LOSS_EXP.advice_id%TYPE,
        p_tran_id             IN GICL_CLM_LOSS_EXP.tran_id%TYPE,
        p_dist_type           IN GICL_CLM_LOSS_EXP.dist_type%TYPE,
        p_clm_clmnt_no        IN GICL_CLM_LOSS_EXP.clm_clmnt_no%TYPE,
        p_final_tag           IN GICL_CLM_LOSS_EXP.final_tag%TYPE,
        p_tran_date           IN GICL_CLM_LOSS_EXP.tran_date%TYPE,
        p_currency_cd         IN GICL_CLM_LOSS_EXP.currency_cd%TYPE,
        p_currency_rate       IN GICL_CLM_LOSS_EXP.currency_rate%TYPE,
        p_grouped_item_no     IN GICL_CLM_LOSS_EXP.grouped_item_no%TYPE*/     
   );
   FUNCTION get_clm_hist_info (
        p_claim_id      GICL_CLAIMS.claim_id%TYPE,
        p_dsp_item_no   GICL_CLM_LOSS_EXP.item_no%TYPE,
        p_dsp_peril_cd  GICL_CLM_LOSS_EXP.peril_cd%TYPE
    )RETURN clm_loss_exp_tab PIPELINED;
   
   TYPE gicl_clm_loss_exp_type IS RECORD(
      claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
      advice_id       GICL_CLM_LOSS_EXP.advice_id%TYPE,
      clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
      tran_id         GICL_CLM_LOSS_EXP.tran_id%TYPE,
      payee_cd        GICL_CLM_LOSS_EXP.payee_cd%TYPE,
      hist_seq_no     GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,
      item_no         GICL_CLM_LOSS_EXP.item_no%TYPE, 
      grouped_item_no GICL_CLM_LOSS_EXP.grouped_item_no%TYPE,
      dsp_item_title  GICL_CLM_ITEM.item_title%TYPE,
      peril_cd        GICL_CLM_LOSS_EXP.peril_cd%TYPE,
      dsp_peril_sname  GIIS_PERIL.peril_sname%TYPE,
      dsp_peril_name  GIIS_PERIL.peril_name%TYPE,
      item_stat_cd    GICL_CLM_LOSS_EXP.item_stat_cd%TYPE,
      currency_cd     GICL_CLM_LOSS_EXP.currency_cd%TYPE,
      currency_rate   GICL_CLM_LOSS_EXP.currency_rate%TYPE,
      payee_type      GICL_CLM_LOSS_EXP.payee_type%TYPE,
      payee_class_cd  GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
      dsp_payee_last_name  GIIS_PAYEES.payee_last_name%TYPE,
      dsp_payee_name  VARCHAR2(500),
      dist_sw         GICL_CLM_LOSS_EXP.dist_sw%TYPE,
      paid_amt        GICL_CLM_LOSS_EXP.paid_amt%TYPE,
      net_amt         GICL_CLM_LOSS_EXP.net_amt%TYPE,
      advise_amt      GICL_CLM_LOSS_EXP.advise_amt%TYPE,
      close_flag      GICL_ITEM_PERIL.close_flag%type,
      close_flag2     GICL_ITEM_PERIL.close_flag2%type  --added by MAC 02/14/2013 to check Expense Status.        
   );
   
   TYPE gicl_clm_loss_exp_tab IS TABLE OF gicl_clm_loss_exp_type;
   
   FUNCTION get_gicl_clm_loss_exp_list(
      p_claim_id  GICL_CLM_LOSS_EXP.claim_id%TYPE
     ,p_advice_id GICL_CLM_LOSS_EXP.advice_id%TYPE
     ,p_line_cd   GICL_ADVICE.line_cd%TYPE
   ) RETURN gicl_clm_loss_exp_tab PIPELINED;
   
   FUNCTION get_clm_loss_exp_list
    (p_claim_id        IN   GICL_CLM_LOSS_EXP.claim_id%TYPE,   
     p_payee_type      IN   GICL_CLM_LOSS_EXP.payee_type%TYPE,
     p_payee_class_cd  IN   GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
     p_payee_cd        IN   GICL_CLM_LOSS_EXP.payee_cd%TYPE,
     p_item_no         IN   GICL_CLM_LOSS_EXP.item_no%TYPE,
     p_peril_cd        IN   GICL_CLM_LOSS_EXP.peril_cd%TYPE,
     p_clm_clmnt_no    IN   GICL_CLM_LOSS_EXP.clm_clmnt_no%TYPE,
     p_grouped_item_no IN   GICL_CLM_LOSS_EXP.grouped_item_no%TYPE,
     p_hist_seq_no     IN   GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,
     p_le_stat_desc    IN   GICL_LE_STAT.le_stat_desc%TYPE,
     p_advice_amt      IN   GICL_CLM_LOSS_EXP.advise_amt%TYPE,
     p_net_amt         IN   GICL_CLM_LOSS_EXP.net_amt%TYPE,
     p_paid_amt        IN   GICL_CLM_LOSS_EXP.paid_amt%TYPE,
     p_remarks         IN   GICL_CLM_LOSS_EXP.remarks%TYPE)
     
    RETURN clm_loss_exp_tab PIPELINED;
    
   FUNCTION check_exist_clm_loss_exp
    (p_claim_id             GICL_CLM_LOSS_EXP.claim_id%TYPE,
     p_item_no              GICL_CLM_LOSS_EXP.item_no%TYPE,
     p_peril_cd             GICL_CLM_LOSS_EXP.peril_cd%TYPE,
     p_grouped_item_no      GICL_CLM_LOSS_EXP.grouped_item_no%TYPE,
     p_payee_type           GICL_CLM_LOSS_EXP.payee_type%TYPE,
     p_payee_class_cd       GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
     p_payee_cd             GICL_CLM_LOSS_EXP.payee_cd%TYPE)
     
    RETURN VARCHAR2;
    
   FUNCTION get_next_clm_loss_id(p_claim_id   IN  GICL_CLAIMS.claim_id%TYPE)
    RETURN NUMBER;
    
   PROCEDURE set_clm_loss_exp_2
    (p_claim_id          IN  GICL_CLM_LOSS_EXP.claim_id%TYPE,                   
     p_clm_loss_id       IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,       
     p_hist_seq_no       IN  GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,       
     p_item_no           IN  GICL_CLM_LOSS_EXP.item_no%TYPE,            
     p_peril_cd          IN  GICL_CLM_LOSS_EXP.peril_cd%TYPE,          
     p_grouped_item_no   IN  GICL_CLM_LOSS_EXP.grouped_item_no%TYPE,   
     p_clm_clmnt_no      IN  GICL_CLM_LOSS_EXP.clm_clmnt_no%TYPE,      
     p_item_stat_cd      IN  GICL_CLM_LOSS_EXP.item_stat_cd%TYPE,      
     p_payee_type        IN  GICL_CLM_LOSS_EXP.payee_type%TYPE,        
     p_payee_cd          IN  GICL_CLM_LOSS_EXP.payee_cd%TYPE,          
     p_payee_class_cd    IN  GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,    
     p_ex_gratia_sw      IN  GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,      
     p_dist_sw           IN  GICL_CLM_LOSS_EXP.dist_sw%TYPE,           
     p_cancel_sw         IN  GICL_CLM_LOSS_EXP.cancel_sw%TYPE,         
     p_paid_amt          IN  GICL_CLM_LOSS_EXP.paid_amt%TYPE,          
     p_net_amt           IN  GICL_CLM_LOSS_EXP.net_amt%TYPE,           
     p_advise_amt        IN  GICL_CLM_LOSS_EXP.advise_amt%TYPE,        
     p_remarks           IN  GICL_CLM_LOSS_EXP.remarks%TYPE,           
     p_final_tag         IN  GICL_CLM_LOSS_EXP.final_tag%TYPE,         
     p_user_id           IN  GICL_CLM_LOSS_EXP.user_id%TYPE);
     
  PROCEDURE delete_clm_loss_exp(p_claim_id    IN   GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                p_clm_loss_id IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE);
                                
  FUNCTION get_view_hist_clm_loss_exp( 
     p_line_cd         IN   GIIS_LINE.line_cd%TYPE,
     p_claim_id        IN   GICL_CLM_LOSS_EXP.claim_id%TYPE,
     p_item_no         IN   GICL_CLM_LOSS_EXP.item_no%TYPE,
     p_peril_cd        IN   GICL_CLM_LOSS_EXP.peril_cd%TYPE,   
     p_payee_type      IN   GICL_CLM_LOSS_EXP.payee_type%TYPE,
     p_payee_class_cd  IN   GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
     p_payee_cd        IN   GICL_CLM_LOSS_EXP.payee_cd%TYPE,
     p_hist_seq_no     IN   GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,
     p_le_stat_desc    IN   GICL_LE_STAT.le_stat_desc%TYPE,
     p_peril_sname     IN   GIIS_PERIL.peril_sname%TYPE,
     p_payee_name      IN   GIIS_PAYEES.payee_last_name%TYPE,
     p_advice_amt      IN   GICL_CLM_LOSS_EXP.advise_amt%TYPE,
     p_net_amt         IN   GICL_CLM_LOSS_EXP.net_amt%TYPE,
     p_paid_amt        IN   GICL_CLM_LOSS_EXP.paid_amt%TYPE)
     
  RETURN clm_loss_exp_tab PIPELINED;
  
  PROCEDURE cancel_clm_loss_exp
    (p_claim_id       IN   GICL_CLAIMS.claim_id%TYPE,
     p_hist_seq_no    IN   GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,
     p_item_no        IN   GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd       IN   GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type     IN   GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_payee_class_cd IN   GICL_LOSS_EXP_PAYEES.payee_class_cd%TYPE,
     p_payee_cd       IN   GICL_LOSS_EXP_PAYEES.payee_cd%TYPE);
     
  PROCEDURE update_clm_loss_exp_amts
    (p_claim_id     IN  GICL_CLM_LOSS_EXP.claim_id%TYPE,
     p_clm_loss_id  IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_advise_amt   IN  GICL_CLM_LOSS_EXP.advise_amt%TYPE,
     p_paid_amt     IN  GICL_CLM_LOSS_EXP.paid_amt%TYPE,
     p_net_amt      IN  GICL_CLM_LOSS_EXP.net_amt%TYPE,
     p_user_id      IN  GIIS_USERS.user_id%TYPE);
   
  PROCEDURE UPDATE_CLM_LOSS_EXP_ADVICE_ID(
      p_advice_id  GICL_ADVICE.advice_id%TYPE,
      p_claim_id   GICL_ADVICE.claim_id%TYPE,      
      p_clm_loss_id GICL_CLM_LOSS_EXP.clm_loss_id%TYPE
    );  
  
  TYPE gen_acc_clm_loss_type IS RECORD(
    payee_cd GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    payee_class_cd GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    payee_amount NUMBER
  );
  
  TYPE gen_acc_clm_loss_tab IS TABLE OF gen_acc_clm_loss_type;
  
  TYPE loa_csl_type IS RECORD(
    payee_cd            GICL_LOSS_EXP_PAYEES.payee_cd%TYPE,
    payee_class_cd      GICL_LOSS_EXP_PAYEES.payee_class_cd%TYPE,
    class_desc          GIIS_PAYEE_CLASS.class_desc%TYPE,
    paid_amt            GICL_CLM_LOSS_EXP.paid_amt%TYPE,
    payee_name          VARCHAR2(1000),
    claim_id            GICL_CLAIMS.claim_id%TYPE,
    clm_loss_id         GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
    hist_seq_no         GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,
    remarks             GICL_CLM_LOSS_EXP.remarks%TYPE,
    eval_id             GICL_EVAL_PAYMENT.eval_id%TYPE,
    loa_no              VARCHAR2(100),
    csl_no              VARCHAR2(100),
    tp_sw               GICL_EVAL_CSL.tp_sw%TYPE,
    tp_payee_class_cd   GICL_MC_EVALUATION.payee_class_cd%TYPE,
    tp_payee_no         GICL_MC_EVALUATION.payee_no%TYPE     
  );

  TYPE loa_csl_tab IS TABLE OF loa_csl_type;
  
  FUNCTION get_gen_acc_clm_loss (
    p_claim_id GICL_CLM_LOSS_EXP.claim_id%TYPE,
    p_advice_id GICL_CLM_LOSS_EXP.advice_id%TYPE
  ) RETURN gen_acc_clm_loss_tab PIPELINED;
  
  PROCEDURE val_clm_loss_exp_tax(
    p_claim_id gicl_clm_loss_exp.claim_id%TYPE,
    p_advice_id gicl_clm_loss_exp.advice_id%TYPE,
    p_count OUT NUMBER,
    p_message OUT VARCHAR2
  );
  
  PROCEDURE upd_clm_loss_exp_amts_with_tax
    (p_claim_id     IN  GICL_CLM_LOSS_EXP.claim_id%TYPE,
     p_clm_loss_id  IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_user_id      IN  GIIS_USERS.user_id%TYPE);
     
  FUNCTION get_loa_list(p_claim_id    IN  GICL_CLAIMS.claim_id%TYPE)
    RETURN loa_csl_tab PIPELINED;
    
  FUNCTION get_csl_list(p_claim_id    IN  GICL_CLAIMS.claim_id%TYPE)
    RETURN loa_csl_tab PIPELINED;
     
  FUNCTION get_payee_cd(
    p_claim_id       IN  gicl_clm_loss_exp.claim_id%type,
    p_payee_class_cd IN  gicl_clm_loss_exp.payee_class_cd%type
    ) RETURN gicl_clm_loss_exp.payee_cd%type;  
    
    
  TYPE gicls033_dist_dtls_type IS RECORD(
      claim_id                GICL_CLM_LOSS_EXP.claim_id%TYPE,
      advice_id               GICL_CLM_LOSS_EXP.advice_id%TYPE,
      line_cd                 GICL_LOSS_EXP_DS.line_cd%TYPE,
      share_type              GICL_LOSS_EXP_DS.share_type%TYPE,
      grp_seq_no              GICL_LOSS_EXP_DS.grp_seq_no%TYPE,
      trty_name               GIIS_DIST_SHARE.trty_name%TYPE,
      paid_amt                NUMBER(16,2),
      net_amt                 NUMBER(16,2),
      adv_amt                 NUMBER(16,2)
  );
  TYPE gicls033_dist_dtls_tab IS TABLE OF gicls033_dist_dtls_type;
    
  FUNCTION get_gicls033_dist_dtls(
     p_claim_id              GICL_CLM_LOSS_EXP.claim_id%TYPE,
     p_advice_id             GICL_CLM_LOSS_EXP.advice_id%TYPE,
     p_line_cd               GIIS_DIST_SHARE.line_cd%TYPE
  )
  RETURN gicls033_dist_dtls_tab PIPELINED;
  
  PROCEDURE check_hist_seq_no--kenneth 06162015 ST 3616
    (p_claim_id             GICL_CLM_LOSS_EXP.claim_id%TYPE,
     p_item_no              GICL_CLM_LOSS_EXP.item_no%TYPE,
     p_peril_cd             GICL_CLM_LOSS_EXP.peril_cd%TYPE,
     p_grouped_item_no      GICL_CLM_LOSS_EXP.grouped_item_no%TYPE,
     p_payee_type           GICL_CLM_LOSS_EXP.payee_type%TYPE,
     p_payee_class_cd       GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
     p_payee_cd             GICL_CLM_LOSS_EXP.payee_cd%TYPE,
     p_hist_seq_no          GICL_CLM_LOSS_EXP.hist_seq_no%TYPE);
     
END gicl_clm_loss_exp_pkg;
/



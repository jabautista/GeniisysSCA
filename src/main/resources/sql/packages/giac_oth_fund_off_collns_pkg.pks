CREATE OR REPLACE PACKAGE CPI.giac_oth_fund_off_collns_pkg AS

    TYPE giac_oth_fund_off_collns_type IS RECORD (
        gacc_tran_id                    GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE,
        gibr_gfun_fund_cd               GIAC_OTH_FUND_OFF_COLLNS.gibr_gfun_fund_cd%TYPE,
        gibr_gfun_fund_desc             GIIS_FUNDS.fund_desc%TYPE,
        gibr_branch_cd                  GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE,
        gibr_branch_name                GIAC_BRANCHES.branch_name%TYPE,
        item_no                         GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE,
        transaction_type                GIAC_OTH_FUND_OFF_COLLNS.transaction_type%TYPE,
        transaction_type_desc           CG_REF_CODES.rv_meaning%TYPE,
        old_tran_no                     VARCHAR2(1000),
        tran_year                       GIAC_ACCTRANS.tran_year%TYPE,
        tran_month                      GIAC_ACCTRANS.tran_month%TYPE,
        tran_seq_no                     GIAC_ACCTRANS.tran_seq_no%TYPE,
        collection_amt                  GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE,
        gofc_gacc_tran_id               GIAC_OTH_FUND_OFF_COLLNS.gofc_gacc_tran_id%TYPE,
        gofc_gibr_gfun_fund_cd          GIAC_OTH_FUND_OFF_COLLNS.gofc_gibr_gfun_fund_cd%TYPE,
        gofc_gibr_gfun_fund_desc        GIIS_FUNDS.fund_desc%TYPE,
        gofc_gibr_branch_cd             GIAC_OTH_FUND_OFF_COLLNS.gofc_gibr_branch_cd%TYPE,
        gofc_gibr_branch_name           GIAC_BRANCHES.branch_name%TYPE,
        gofc_item_no                    GIAC_OTH_FUND_OFF_COLLNS.gofc_item_no%TYPE,
        or_print_tag                    GIAC_OTH_FUND_OFF_COLLNS.or_print_tag%TYPE,
        particulars                     GIAC_OTH_FUND_OFF_COLLNS.particulars%TYPE,
        user_id                         GIAC_OTH_FUND_OFF_COLLNS.user_id%TYPE,
        last_update                     GIAC_OTH_FUND_OFF_COLLNS.last_update%TYPE
    );
    
    TYPE giac_oth_fund_off_collns_tab IS TABLE OF giac_oth_fund_off_collns_type;
    
    TYPE gofc_gibr_gfun_fund_type IS RECORD (
        gibr_gfun_fund_cd               GIAC_BRANCHES.gfun_fund_cd%TYPE,
        gibr_branch_cd                  GIAC_BRANCHES.branch_cd%TYPE,
        fund_desc                       GIIS_FUNDS.fund_desc%TYPE,
        branch_name                     GIAC_BRANCHES.branch_name%TYPE
    );
    
    TYPE gofc_gibr_gfun_fund_tab IS TABLE OF gofc_gibr_gfun_fund_type;
    
    TYPE gofc_gacc_type IS RECORD (
        gofc_gibr_gfun_fund_cd          GIAC_OTH_FUND_OFF_COLLNS.gofc_gibr_gfun_fund_cd%TYPE,
        gofc_gibr_branch_cd             GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE,
        gofc_gibr_gfun_fund_desc        GIIS_FUNDS.fund_desc%TYPE,
        gofc_gibr_branch_name           GIAC_BRANCHES.branch_name%TYPE,
        tran_year                       GIAC_ACCTRANS.tran_year%TYPE,
        tran_month                      GIAC_ACCTRANS.tran_month%TYPE,
        tran_seq_no                     GIAC_ACCTRANS.tran_seq_no%TYPE,
        old_tran_no                     VARCHAR2(500),
        item_no                         GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE,
        gacc_tran_id                    GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE,
        gfun_fund_cd                    GIAC_ACCTRANS.gfun_fund_cd%TYPE,
        gibr_branch_cd                  GIAC_ACCTRANS.gibr_branch_cd%TYPE,
        tran_date                       GIAC_ACCTRANS.tran_date%TYPE,
        tran_flag                       GIAC_ACCTRANS.tran_flag%TYPE,
        tran_class                      GIAC_ACCTRANS.tran_class%TYPE,
        tran_class_no                   GIAC_ACCTRANS.tran_class_no%TYPE,
        jv_no                           GIAC_ACCTRANS.jv_no%TYPE,
        gofc_gacc_tran_id               GIAC_OTH_FUND_OFF_COLLNS.gofc_gacc_tran_id%TYPE                      
    );
    
    TYPE gofc_gacc_tab  IS TABLE OF gofc_gacc_type;
    
    FUNCTION get_oth_fund_off_collns        (p_gacc_tran_id   GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE)
        RETURN giac_oth_fund_off_collns_tab PIPELINED;
        
    FUNCTION get_gofc_gibr_gfun_fund_list   (p_module    GIAC_MODULES.module_name%TYPE,
                                             p_user_id   GIIS_USERS.user_id%TYPE)
        RETURN gofc_gibr_gfun_fund_tab PIPELINED;
    
    FUNCTION get_old_tran_no_list (p_keyword    VARCHAR2)
        RETURN gofc_gacc_tab PIPELINED;
        
    PROCEDURE get_default_amount
    (p_tran_year                IN       GIAC_ACCTRANS.tran_year%TYPE,
     p_tran_month               IN       GIAC_ACCTRANS.tran_month%TYPE,
     p_tran_seq_no              IN       GIAC_ACCTRANS.tran_seq_no%TYPE,
     p_gofc_gibr_gfun_fund_cd   IN       GIAC_OTH_FUND_OFF_COLLNS.gibr_gfun_fund_cd%TYPE,
     p_gofc_gibr_branch_cd      IN       GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE,
     p_gofc_item_no             IN       GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE,
     p_gacc_tran_id             OUT      GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE,
     p_default_colln_amt        OUT      GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE, 
     p_message                  OUT      VARCHAR2);
     
    PROCEDURE chk_giac_oth_fund_off_col(
     p_check_both               IN BOOLEAN       
    ,p_gibr_branch_cd           IN       GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE      
    ,p_gibr_gfun_fund_cd        IN       GIAC_OTH_FUND_OFF_COLLNS.gibr_gfun_fund_cd%TYPE      
    ,p_item_no                  IN       GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE       
    ,p_gacc_tran_id             IN       GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE
    ,p_message                  OUT      VARCHAR2);
   
   PROCEDURE set_giac_oth_fund_off_collns
    (p_gacc_tran_id				        GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE,
     p_gibr_gfun_fund_cd		        GIAC_OTH_FUND_OFF_COLLNS.gibr_gfun_fund_cd%TYPE,
     p_gibr_branch_cd			        GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE,
     p_item_no					        GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE,
     p_tran_type				        GIAC_OTH_FUND_OFF_COLLNS.transaction_type%TYPE,
     p_colln_amt				        GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE,
     p_gofc_gacc_tran_id		        GIAC_OTH_FUND_OFF_COLLNS.gofc_gacc_tran_id%TYPE,
     p_gofc_gibr_gfun_fund_cd	        GIAC_OTH_FUND_OFF_COLLNS.gofc_gibr_gfun_fund_cd%TYPE,
     p_gofc_gibr_branch_cd		        GIAC_OTH_FUND_OFF_COLLNS.gofc_gibr_branch_cd%TYPE,
     p_gofc_item_no				        GIAC_OTH_FUND_OFF_COLLNS.gofc_item_no%TYPE,
     p_or_print_tag				        GIAC_OTH_FUND_OFF_COLLNS.or_print_tag%TYPE,
     p_particulars				        GIAC_OTH_FUND_OFF_COLLNS.particulars%TYPE);
     
   PROCEDURE del_giac_oth_fund_off_collns
    (p_gacc_tran_id				        GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE,
    p_gibr_gfun_fund_cd		            GIAC_OTH_FUND_OFF_COLLNS.gibr_gfun_fund_cd%TYPE,
    p_gibr_branch_cd			        GIAC_OTH_FUND_OFF_COLLNS.gibr_branch_cd%TYPE,
    p_item_no					        GIAC_OTH_FUND_OFF_COLLNS.item_no%TYPE);
    
   PROCEDURE post_forms_commit_giacs012(
    p_gacc_tran_id				        GIAC_OTH_FUND_OFF_COLLNS.gacc_tran_id%TYPE,
    p_tran_source				        VARCHAR2,
    p_or_flag					        VARCHAR2);
    
    
    PROCEDURE update_acct_entries 
        (p_gacc_branch_cd               GIAC_ACCTRANS.gibr_branch_cd%TYPE,
         p_gacc_fund_cd                 GIAC_ACCTRANS.gfun_fund_cd%TYPE,
         p_gacc_tran_id                 GIAC_ACCTRANS.tran_id%TYPE,
         p_collection_amt		        GIAC_OTH_FUND_OFF_COLLNS.collection_amt%TYPE,
         uae_gl_acct_category  	        GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
         uae_gl_control_acct            GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
         uae_gl_sub_acct_1     	        GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
         uae_gl_sub_acct_2     	        GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
         uae_gl_sub_acct_3     	        GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
         uae_gl_sub_acct_4     	        GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
         uae_gl_sub_acct_5     	        GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
         uae_gl_sub_acct_6     	        GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
         uae_gl_sub_acct_7     	        GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE);
         
    PROCEDURE aeg_ins_upd_acct_entr_giacs012
        (p_gacc_gibr_branch_cd 	        GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
         p_gacc_gfun_fund_cd	        GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
         p_global_gibr_branch_cd  		GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
         p_global_gfun_fund_cd	  		GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
         p_gacc_tran_id			        GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
         iuae_gl_acct_category          GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
         iuae_gl_control_acct           GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
         iuae_gl_sub_acct_1             GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
         iuae_gl_sub_acct_2             GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
         iuae_gl_sub_acct_3             GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
         iuae_gl_sub_acct_4             GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
         iuae_gl_sub_acct_5             GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
         iuae_gl_sub_acct_6             GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
         iuae_gl_sub_acct_7             GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
         iuae_sl_cd                     GIAC_ACCT_ENTRIES.sl_cd%TYPE,
         iuae_generation_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
         iuae_gl_acct_id                GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
         iuae_debit_amt                 GIAC_ACCT_ENTRIES.debit_amt%TYPE,
         iuae_credit_amt                GIAC_ACCT_ENTRIES.credit_amt%TYPE);
             
    PROCEDURE aeg_create_acct_entr_giacs012
      (p_gacc_gibr_branch_cd            GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
       p_gacc_gfun_fund_cd	            GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
       p_global_gibr_branch_cd  		GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
       p_global_gfun_fund_cd	  		GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
       p_gacc_tran_id		            GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
       aeg_module_id                    GIAC_MODULE_ENTRIES.module_id%TYPE,
       aeg_item_no                      GIAC_MODULE_ENTRIES.item_no%TYPE,
       aeg_acct_amt                     GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
       aeg_gen_type                     GIAC_ACCT_ENTRIES.generation_type%TYPE,
       p_message	        OUT	        VARCHAR2);
   
    PROCEDURE aeg_parameters
      (p_global_gibr_branch_cd  		GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
       p_global_gfun_fund_cd	  		GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
       p_gacc_tran_id		  		    GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
       p_module_name  				    GIAC_MODULES.module_name%TYPE,
       p_message	   		OUT         VARCHAR2);
 
END GIAC_OTH_FUND_OFF_COLLNS_PKG;
/



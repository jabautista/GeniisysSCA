CREATE OR REPLACE PACKAGE CPI.GIAC_JOURNAL_ENTRIES_PKG
AS
	TYPE journal_entry_type IS RECORD(
		tran_id			GIAC_ACCTRANS.tran_id%TYPE,
		gfun_fund_cd	GIAC_ACCTRANS.gfun_fund_cd%TYPE,
		gibr_branch_cd	GIAC_ACCTRANS.gibr_branch_cd%TYPE,
		tran_yy		    GIAC_ACCTRANS.tran_year%TYPE,
		tran_mm 		GIAC_ACCTRANS.tran_month%TYPE,
		tran_seq_no		GIAC_ACCTRANS.tran_seq_no%TYPE,
		tran_date		GIAC_ACCTRANS.tran_date%TYPE,
		tran_flag		GIAC_ACCTRANS.tran_flag%TYPE,
		jv_tran_tag		GIAC_ACCTRANS.jv_tran_tag%TYPE,
		tran_class		GIAC_ACCTRANS.tran_class%TYPE,
		tran_class_no	GIAC_ACCTRANS.tran_class_no%TYPE,
		jv_no			GIAC_ACCTRANS.jv_no%TYPE,
		particulars		GIAC_ACCTRANS.particulars%TYPE,
		user_id			GIAC_ACCTRANS.user_id%TYPE,
		last_update		GIAC_ACCTRANS.last_update%TYPE,
		remarks			GIAC_ACCTRANS.remarks%TYPE,
        jv_tran_type	GIAC_ACCTRANS.jv_tran_type%TYPE,
        jv_tran_desc	giac_jv_trans.jv_tran_desc%TYPE,
        jv_tran_mm		GIAC_ACCTRANS.jv_tran_mm%TYPE,
        jv_tran_yy		GIAC_ACCTRANS.jv_tran_yy%TYPE,
        ref_jv_no		GIAC_ACCTRANS.ref_jv_no%TYPE,
        jv_pref_suff	GIAC_ACCTRANS.jv_pref_suff%TYPE,
        create_by		GIAC_ACCTRANS.create_by%TYPE,
        ae_tag		    GIAC_ACCTRANS.ae_tag%TYPE,
        sap_inc_tag		GIAC_ACCTRANS.sap_inc_tag%TYPE,
        upload_tag      GIAC_ACCTRANS.upload_tag%TYPE,
        mean_tran_flag  CG_REF_CODES.rv_meaning%TYPE,
        mean_tran_class CG_REF_CODES.rv_meaning%TYPE,
		branch_name		GIAC_BRANCHES.branch_name%TYPE,
		fund_desc		GIIS_FUNDS.fund_desc%TYPE,
		grac_rac_cd		GIIS_FUNDS.grac_rac_cd%TYPE,
        count_        NUMBER,
        rownum_       NUMBER
    );
    TYPE journal_entry_tab IS TABLE OF journal_entry_type;
    
    TYPE jv_tran_type_lov_type IS RECORD(
        jv_tran_cd  	giac_jv_trans.jv_tran_cd%TYPE,
        jv_tran_desc	giac_jv_trans.jv_tran_desc%TYPE
    );
    TYPE jv_tran_type_lov_tab IS TABLE OF jv_tran_type_lov_type;
    
    TYPE print_opt_type IS RECORD(
        debit_amt  	giac_acct_entries.debit_amt%TYPE,
        credit_amt	giac_acct_entries.credit_amt%TYPE
    );
    TYPE print_opt_tab IS TABLE OF print_opt_type;
	
    FUNCTION get_journal_entry(
        p_tran_id giac_acctrans.tran_id%TYPE
    ) RETURN journal_entry_tab PIPELINED;
    
	FUNCTION get_journal_entry_list(
                                   p_module_id 	    VARCHAR2,
   								   p_user_id	    GIIS_USERS.user_id%TYPE,
								   p_fund_cd	    GIAC_ACCTRANS.gfun_fund_cd%TYPE,
								   p_branch_cd	    GIAC_ACCTRANS.gibr_branch_cd%TYPE,
                                   p_branch_name    GIAC_BRANCHES.branch_name%TYPE,
                                   p_create_by      GIAC_ACCTRANS.create_by%TYPE,
                                   p_jv_no          GIAC_ACCTRANS.jv_no%TYPE,
                                   p_jv_pref_suff   GIAC_ACCTRANS.jv_pref_suff%TYPE,
                                   p_jv_tran_type   GIAC_ACCTRANS.jv_tran_type%TYPE,
                                   p_jv_tran_mm     GIAC_ACCTRANS.jv_tran_mm%TYPE,
                                   p_jv_tran_yy     GIAC_ACCTRANS.jv_tran_yy%TYPE,
                                   p_particulars    GIAC_ACCTRANS.particulars%TYPE,
                                   p_ref_jv_no      GIAC_ACCTRANS.ref_jv_no%TYPE,
                                   p_tran_date      VARCHAR2,
                                   p_tran_year      GIAC_ACCTRANS.tran_year%TYPE,
                                   p_tran_month     GIAC_ACCTRANS.tran_month%TYPE,
                                   p_tran_seq_no    GIAC_ACCTRANS.tran_seq_no%TYPE,
                                   p_filter_user_id GIAC_ACCTRANS.user_id%TYPE,
                                   p_tran_flag      GIAC_ACCTRANS.tran_flag%TYPE,
                                   p_order_by       VARCHAR2,
                                   p_asc_desc_flag  VARCHAR2, 
                                   p_from           NUMBER,
                                   p_to             NUMBER
                                   )
   	RETURN journal_entry_tab PIPELINED;
    
     FUNCTION create_journal_entries(p_user_id     giis_users.user_id%TYPE)
      RETURN journal_entry_tab PIPELINED;
      
    FUNCTION check_or_info(p_tran_id     giac_acctrans.tran_id%TYPE)
        RETURN VARCHAR2;
        
    FUNCTION get_p_branch_cd (p_user_id giis_users.user_id%TYPE)
      RETURN VARCHAR2;
      
    FUNCTION get_closed_tag(p_fund_cd    giac_tran_mm.fund_cd%TYPE,
                           p_branch_cd  giac_tran_mm.branch_cd%TYPE,
  						   p_date       giac_acctrans.tran_date%TYPE)
      RETURN VARCHAR2;
      
    FUNCTION giacs003_check_comm_payts (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN VARCHAR2;
      
    PROCEDURE set_giac_acctrans(p_tran_id			IN OUT VARCHAR2,
                                p_gfun_fund_cd	    IN VARCHAR2,
                                p_gibr_branch_cd	IN VARCHAR2,
                                p_tran_year		    IN NUMBER,
                                p_tran_month 		IN NUMBER,
                                p_tran_seq_no		IN NUMBER,
                                p_tran_date		    IN DATE,
                                p_tran_flag		    IN VARCHAR2,
                                p_jv_tran_tag		IN VARCHAR2,
                                p_tran_class		IN VARCHAR2,
                                --tran_class_no	GIAC_ACCTRANS.tran_class_no%TYPE,
                                --jv_no			GIAC_ACCTRANS.jv_no%TYPE,
                                p_particulars		IN VARCHAR2,
                                p_user_id			IN VARCHAR2,
                                --p_last_update		IN GIAC_ACCTRANS.last_update%TYPE,
                                p_remarks			IN VARCHAR2,
                                p_jv_tran_type	    IN VARCHAR2,
                                --jv_tran_desc	giac_jv_trans.jv_tran_desc%TYPE,
                                p_jv_tran_mm		IN NUMBER,
                                p_jv_tran_yy		IN NUMBER,
                                p_ref_jv_no		    IN VARCHAR2,
                                p_jv_pref_suff	    IN VARCHAR2,
                                p_create_by		    IN VARCHAR2,
                                p_ae_tag		    IN VARCHAR2,
                                p_sap_inc_tag		IN VARCHAR2,
                                p_upload_tag        IN VARCHAR2);
                                
    PROCEDURE set_cancel_opt(p_tran_id			IN NUMBER,
                             p_gfun_fund_cd	    IN VARCHAR2,
                             p_gibr_branch_cd	IN VARCHAR2,
                             p_user_id          IN VARCHAR2,
                             p_jv_no            IN NUMBER,
                             p_msg              OUT VARCHAR2);
                             
    PROCEDURE insert_acctrans_cap(p_fund_cd         IN  giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
                                    p_branch_cd     IN  giac_order_of_payts.gibr_branch_cd%TYPE,
                                    p_rev_tran_date IN  giac_acctrans.tran_date%TYPE,
                                    p_tran_class    IN  giac_acctrans.tran_class%TYPE,
                                    p_user_id       IN  giis_users.user_id%TYPE,
                                    p_jv_no            IN giac_acctrans.jv_no%TYPE,
                                    p_tran_id       OUT giac_acctrans.tran_id%TYPE);
                                    
    PROCEDURE AEG_Parameters_Rev(aeg_tran_id      GIAC_ACCTRANS.tran_id%TYPE,
                                 aeg_module_nm    GIAC_MODULES.module_name%TYPE,
                                 p_fund_cd        giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
                                 p_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
                                 p_tran_id        giac_acctrans.tran_id%TYPE,
                                 p_user_id        giis_users.user_id%TYPE); 
                                 
    PROCEDURE create_rev_entries(p_assd_no          GIPI_POLBASIC.assd_no%TYPE,
                                 p_coll_amt             GIAC_COMM_PAYTS.comm_amt%TYPE,
                                 p_line_cd              giis_line.line_cd%TYPE,
                                 p_module_name          giac_modules.module_name%TYPE,
                                 p_fund_cd              giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
                                 p_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
                                 p_tran_id              giac_acctrans.tran_id%TYPE,
                                 p_user_id              giis_users.user_id%TYPE);
                                 
    PROCEDURE aeg_check_chart_of_accts(cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
                                         cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
                                         cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
                                         cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
                                         cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
                                         cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
                                         cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
                                         cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
                                         cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
                                         cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE );
                                         
    PROCEDURE aeg_insert_update_entries_rev(iuae_gl_acct_category   GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
                                             iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
                                             iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
                                             iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
                                             iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
                                             iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
                                             iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
                                             iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
                                             iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
                                             iuae_sl_type_cd	    GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
                                             iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE,
                                             iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                                             iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
                                             iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
                                             iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
                                             iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE,
                                             p_fund_cd              giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
                                             p_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
                                             p_tran_id              giac_acctrans.tran_id%TYPE,
                                             p_user_id              giis_users.user_id%TYPE);
    PROCEDURE aeg_check_level(cl_level         IN NUMBER,
                              cl_value         IN NUMBER,
                              cl_sub_acct1 IN OUT NUMBER,
                              cl_sub_acct2 IN OUT NUMBER,
                              cl_sub_acct3 IN OUT NUMBER,
                              cl_sub_acct4 IN OUT NUMBER,
                              cl_sub_acct5 IN OUT NUMBER,
                              cl_sub_acct6 IN OUT NUMBER,
                              cl_sub_acct7 IN OUT NUMBER);
    
    PROCEDURE delete_workflow_rec(p_event_desc  IN VARCHAR2,
                                  p_module_id  IN VARCHAR2,
                                  p_user       IN VARCHAR2,
                                  p_col_value IN VARCHAR2);
                                                                                                 
    FUNCTION get_jv_tran_type_lov(p_jv_tran_tag      GIAC_ACCTRANS.jv_tran_tag%TYPE)
        RETURN jv_tran_type_lov_tab PIPELINED;
        
    FUNCTION print_opt(p_tran_id	GIAC_ACCTRANS.tran_id%TYPE)
        RETURN print_opt_tab PIPELINED;
    
    FUNCTION  get_detail_module(p_tran_id	GIAC_ACCTRANS.tran_id%TYPE) 
        RETURN VARCHAR2;
        
    PROCEDURE show_dv_info(p_tran_id      IN NUMBER,
                          p_formcall    IN OUT VARCHAR2,
                          p_dv_tag      IN OUT VARCHAR2,
                          p_cancel_dv   IN OUT VARCHAR2,
                          p_ref_id      IN OUT VARCHAR2,
                          p_payt_request_menu IN OUT VARCHAR2,
                          p_cancel_req        IN OUT VARCHAR2);
                                  
    PROCEDURE get_payt_request_menu(p_tran_id           IN NUMBER,
                                    p_payt_request_menu OUT VARCHAR2,
                                    p_cancel_req        OUT VARCHAR2);

    FUNCTION validate_jv_cancel(p_tran_id   NUMBER) --added by John Daniel SR-2182; check if JV can be cancelled
    RETURN VARCHAR2;                                   
                                  
END;
/



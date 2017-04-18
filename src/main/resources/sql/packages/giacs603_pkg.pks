CREATE OR REPLACE PACKAGE CPI.GIACS603_PKG
AS
    --variables
   variables_user_id            VARCHAR2(12);
   variables_upload_tag	        VARCHAR2(1) := 'N';
   variables_tran_id		    giac_acctrans.tran_id%TYPE;
   variables_prem_payt_for_sp	giac_parameters.param_value_v%TYPE := nvl(giacp.v('PREM_PAYT_FOR_SPECIAL'),'Y');
   variables_fund_cd            giac_acct_entries.gacc_gfun_fund_cd%TYPE := giacp.v('FUND_CD');
   variables_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%TYPE;
   variables_dcb_no			    giac_colln_batch.dcb_no%TYPE;
   variables_max_colln_amt	  	NUMBER;
   variables_max_iss_cd			gipi_invoice.iss_cd%TYPE;
   variables_max_prem_seq_no	gipi_invoice.prem_seq_no%TYPE;
   variables_tran_date		    giac_acctrans.tran_date%TYPE;
   variables_transaction_type	giac_direct_prem_collns.transaction_type%TYPE;
   
   variables_iss_cd				giac_direct_prem_collns.b140_iss_cd%TYPE;
   variables_prem_seq_no		giac_direct_prem_collns.b140_prem_seq_no%TYPE;
   variables_inst_no			giac_direct_prem_collns.inst_no%TYPE;
   variables_max_collection_amt	giac_direct_prem_collns.collection_amt%TYPE;
   variables_max_premium_amt	giac_direct_prem_collns.premium_amt%TYPE;
   variables_max_tax_amt		giac_direct_prem_collns.tax_amt%TYPE;
   variables_collection_amt	    giac_direct_prem_collns.collection_amt%TYPE;
   variables_currency_cd 		giac_direct_prem_collns.currency_cd%TYPE;
   variables_convert_rate		giac_direct_prem_collns.convert_rate%TYPE;
   variables_tax_amt			giac_direct_prem_collns.tax_amt%TYPE;
   variables_premium_amt		giac_direct_prem_collns.premium_amt%TYPE;
   variables_foreign_curr_amt   giac_direct_prem_collns.foreign_curr_amt%TYPE;
   
   variables_gen_type      	    giac_modules.generation_type%TYPE;
   variables_module_id          giac_modules.module_id%TYPE;
   
   variables_n_seq_no		    NUMBER := 3;
   variables_zero_prem_op_text	VARCHAR2(1) := 'N'; 
   variables_evat_cd			NUMBER := giacp.n('EVAT');
   
   variables_tran_class         giac_upload_file.tran_class%TYPE;
   
   
   TYPE get_giacs603_header_type IS RECORD (
        source_cd        giac_upload_file.source_cd%TYPE,
        file_no          giac_upload_file.file_no%TYPE,
        file_name        giac_upload_file.file_name%TYPE,
        dsp_source_name  giac_file_source.source_name%TYPE,
        tran_date        giac_upload_file.tran_date%TYPE,
        tran_id          giac_upload_file.tran_id%TYPE,
        file_status      giac_upload_file.file_status%TYPE,
        transaction_type giac_upload_file.transaction_type%TYPE,
        dsp_or_req_jv_no VARCHAR2(100),
        tran_class       giac_upload_file.tran_class%TYPE,
        dsp_tran_class   giac_upload_file.tran_class%TYPE,
        upload_date      giac_upload_file.upload_date%TYPE,
        convert_date     giac_upload_file.convert_date%TYPE,
        payment_date     giac_upload_file.payment_date%TYPE,
        nbt_or_date      giac_upload_file.tran_date%TYPE,
        cancel_date      giac_upload_file.cancel_date%TYPE,
        branch_cd        GIAC_BRANCHES.branch_cd%TYPE,
        
        remarks             giac_upload_file.remarks%TYPE,
        no_of_records       giac_upload_file.no_of_records%TYPE
   );
   
   TYPE get_giacs603_header_tab IS TABLE OF get_giacs603_header_type;
      
   FUNCTION get_giacs603_header (
        p_source_cd    giac_upload_file.source_cd%type,
        p_file_no      giac_upload_file.file_no%type,
        p_user_id      VARCHAR2
   )
   RETURN get_giacs603_header_tab PIPELINED;
   
   TYPE giacs603_rec_type IS RECORD (
        count_              NUMBER,
        rownum_             NUMBER,
        file_no             GIAC_UPLOAD_PREM.file_no%TYPE,            
        source_cd           GIAC_UPLOAD_PREM.source_cd%TYPE,
        line_cd             GIAC_UPLOAD_PREM.line_cd%TYPE,
        subline_cd          GIAC_UPLOAD_PREM.subline_cd%TYPE,
        iss_cd              GIAC_UPLOAD_PREM.iss_cd%TYPE,
        issue_yy            GIAC_UPLOAD_PREM.issue_yy%TYPE,           
        pol_seq_no          GIAC_UPLOAD_PREM.pol_seq_no%TYPE,
        renew_no            GIAC_UPLOAD_PREM.renew_no%TYPE,
        collection_amt      GIAC_UPLOAD_PREM.collection_amt%TYPE,
        dsp_colln_amt_diff  NUMBER(16,2),
        net_amt_due         GIAC_UPLOAD_PREM.net_amt_due%TYPE,
        prem_chk_flag       GIAC_UPLOAD_PREM.prem_chk_flag%TYPE,
        chk_remarks         GIAC_UPLOAD_PREM.chk_remarks%TYPE,
        payor               GIAC_UPLOAD_PREM.payor%TYPE,
        dsp_payment_details VARCHAR2(200),
        currency_cd         GIAC_UPLOAD_PREM.currency_cd%TYPE,
        dsp_currency        VARCHAR2(20),
        fcollection_amt     GIAC_UPLOAD_PREM.fcollection_amt%TYPE,
        convert_rate        GIAC_UPLOAD_PREM.convert_rate%TYPE,
        dsp_difference      NUMBER(16,2),
        policy_no           VARCHAR2(50)
   );
   
   TYPE giacs603_rec_tab IS TABLE OF giacs603_rec_type;
   
   FUNCTION get_giacs603_rec_list (
          p_source_cd           GIAC_UPLOAD_PREM.source_cd%TYPE,   
          p_file_no             GIAC_UPLOAD_PREM.file_no%TYPE,
          p_from                NUMBER,
          p_to                  NUMBER,
          p_policy_no           VARCHAR2,
          p_collection_amt      NUMBER,
          p_collection_amt_diff NUMBER, 
          p_prem_chk_flag       VARCHAR2,
          p_chk_remarks         VARCHAR2,
          p_order_by            VARCHAR2,
          p_asc_desc_flag       VARCHAR2
    ) 
        RETURN giacs603_rec_tab PIPELINED;
        
        
   TYPE legend_rec_type IS RECORD (
        legend              VARCHAR2(100)
   );
   
   TYPE legend_rec_tab IS TABLE OF legend_rec_type;
        
   FUNCTION populate_legend
        RETURN legend_rec_tab PIPELINED;
        
   TYPE payment_details_dv_type IS RECORD (
        file_no             GIAC_UPLOAD_DV_PAYT_DTL.file_no%TYPE,            
        source_cd           GIAC_UPLOAD_DV_PAYT_DTL.source_cd%TYPE,
        document_cd         GIAC_UPLOAD_DV_PAYT_DTL.document_cd%TYPE,
        branch_cd           GIAC_UPLOAD_DV_PAYT_DTL.branch_cd%TYPE,
        line_cd             GIAC_UPLOAD_DV_PAYT_DTL.line_cd%TYPE,
        doc_year            GIAC_UPLOAD_DV_PAYT_DTL.doc_year%TYPE,
        doc_mm              GIAC_UPLOAD_DV_PAYT_DTL.doc_mm%TYPE,
        doc_seq_no          GIAC_UPLOAD_DV_PAYT_DTL.doc_seq_no%TYPE,
        gouc_ouc_id         GIAC_UPLOAD_DV_PAYT_DTL.gouc_ouc_id%TYPE,
        dsp_dept_cd         GIAC_OUCS.ouc_cd%TYPE,
        dsp_ouc_name        GIAC_OUCS.ouc_name%TYPE,
        request_date        GIAC_UPLOAD_DV_PAYT_DTL.request_date%TYPE,
        payee_class_cd      GIAC_UPLOAD_DV_PAYT_DTL.payee_class_cd%TYPE,
        payee_cd            GIAC_UPLOAD_DV_PAYT_DTL.payee_cd%TYPE,
        payee               GIAC_UPLOAD_DV_PAYT_DTL.payee%TYPE,
        particulars         GIAC_UPLOAD_DV_PAYT_DTL.particulars%TYPE,
        dsp_fshort_name     GIIS_CURRENCY.short_name%TYPE,
        dv_fcurrency_amt    GIAC_UPLOAD_DV_PAYT_DTL.DV_FCURRENCY_AMT%TYPE,
        currency_rt         GIAC_UPLOAD_DV_PAYT_DTL.currency_rt%TYPE,
        dsp_short_name      giac_parameters.param_value_v%TYPE,
        payt_amt            GIAC_UPLOAD_DV_PAYT_DTL.payt_amt%TYPE,
        currency_cd         GIAC_UPLOAD_DV_PAYT_DTL.currency_cd%TYPE,
        nbt_payee_first_name    VARCHAR2(100),
        nbt_payee_middle_name   VARCHAR2(100),
        nbt_payee_last_name     VARCHAR2(100)
   );
   
   TYPE payment_details_dv_tab IS TABLE OF payment_details_dv_type;
   
   FUNCTION get_payment_details (
        p_source_cd    giac_upload_file.source_cd%TYPE,
        p_file_no      giac_upload_file.file_no%TYPE
   )
   RETURN payment_details_dv_tab PIPELINED;
   
   TYPE document_cd_rec_type IS RECORD (
        document_cd         giac_payt_req_docs.document_cd%TYPE,
        branch_cd           giac_payt_req_docs.gibr_branch_cd%TYPE,
        fund_cd             giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
        dsp_document_name   giac_payt_req_docs.document_name%TYPE,
        dsp_line_cd_tag     giac_payt_req_docs.line_cd_tag%TYPE,
        dsp_yy_tag          giac_payt_req_docs.yy_tag%TYPE,
        dsp_mm_tag          giac_payt_req_docs.mm_tag%TYPE
   );
   
   TYPE document_cd_rec_tab IS TABLE OF document_cd_rec_type;
        
   FUNCTION get_document_cd(
        p_branch_cd         VARCHAR2
   )
    RETURN document_cd_rec_tab PIPELINED;
    
   TYPE branch_cd_rec_type IS RECORD (
        branch_cd           giac_branches.branch_cd%TYPE,
        branch_name         giac_branches.branch_name%TYPE 
   );
   
   TYPE branch_cd_rec_tab IS TABLE OF branch_cd_rec_type;
        
   FUNCTION get_branch_cd(
        p_user_id       VARCHAR2,
        p_module_id     VARCHAR2
   )
     RETURN branch_cd_rec_tab PIPELINED;
     
   TYPE line_cd_rec_type IS RECORD (
        line_cd           GIIS_LINE.line_cd%TYPE,
        line_name         GIIS_LINE.line_name%TYPE 
   );
   
   TYPE line_cd_rec_tab IS TABLE OF line_cd_rec_type;
        
   FUNCTION get_line_cd
     RETURN line_cd_rec_tab PIPELINED;
     
   TYPE dept_cd_rec_type IS RECORD (
        ouc_cd           giac_oucs.ouc_cd%TYPE,
        ouc_id           giac_oucs.ouc_id%TYPE,
        ouc_name         giac_oucs.ouc_name%TYPE
   );
   
   TYPE dept_cd_rec_tab IS TABLE OF dept_cd_rec_type;
        
   FUNCTION get_dept_cd(
        p_branch_cd     VARCHAR2
   )
     RETURN dept_cd_rec_tab PIPELINED;
     
   TYPE payee_class_cd_rec_type IS RECORD (
        payee_class_cd      giis_payees.payee_class_cd%TYPE,
        class_desc          giis_payee_class.class_desc%TYPE
   );
   
   TYPE payee_class_cd_rec_tab IS TABLE OF payee_class_cd_rec_type;
        
   FUNCTION get_payee_class_cd
     RETURN payee_class_cd_rec_tab PIPELINED;
     
   TYPE payee_cd_rec_type IS RECORD (
        payee_no            giis_payees.payee_no%TYPE,         
        payee_last_name     giis_payees.payee_last_name%TYPE, 
        payee_first_name    giis_payees.payee_first_name%TYPE,
        payee_middle_name   giis_payees.payee_middle_name%TYPE
   );
   
   TYPE payee_cd_rec_tab IS TABLE OF payee_cd_rec_type;
        
   FUNCTION get_payee_cd(
        p_payee_class_cd  VARCHAR2
   )
     RETURN payee_cd_rec_tab PIPELINED;
     
   TYPE currency_rec_type IS RECORD (
        short_name          giis_currency.short_name%TYPE,            
        currency_desc       giis_currency.currency_desc%TYPE, 
        main_currency_cd    giis_currency.main_currency_cd%TYPE,
        currency_rt         giis_currency.currency_rt%TYPE
   );
   
   TYPE currency_rec_tab IS TABLE OF currency_rec_type;
        
   FUNCTION get_currency
     RETURN currency_rec_tab PIPELINED;
     
   TYPE giac_upload_dv_payt_dtl_type is RECORD (
        source_cd           giac_upload_dv_payt_dtl.source_cd%TYPE,        
        file_no             giac_upload_dv_payt_dtl.file_no%TYPE,          
        document_cd         giac_upload_dv_payt_dtl.document_cd%TYPE,      
        branch_cd           giac_upload_dv_payt_dtl.branch_cd%TYPE,        
        line_cd             giac_upload_dv_payt_dtl.line_cd%TYPE,          
        doc_year            giac_upload_dv_payt_dtl.doc_year%TYPE,         
        doc_mm              giac_upload_dv_payt_dtl.doc_mm%TYPE,           
        doc_seq_no          giac_upload_dv_payt_dtl.doc_seq_no%TYPE,       
        gouc_ouc_id         giac_upload_dv_payt_dtl.gouc_ouc_id%TYPE,      
        dsp_dept_cd         giac_oucs.ouc_cd%TYPE,      
        dsp_ouc_name        giac_oucs.ouc_name%TYPE,     
        request_date        giac_upload_dv_payt_dtl.request_date%TYPE,     
        payee_class_cd      giac_upload_dv_payt_dtl.payee_class_cd%TYPE,   
        payee_cd            giac_upload_dv_payt_dtl.payee_cd%TYPE,         
        payee               giac_upload_dv_payt_dtl.payee%TYPE,            
        particulars         giac_upload_dv_payt_dtl.particulars%TYPE,
        dsp_fshort_name     giis_currency.short_name%TYPE,                          
        dv_fcurrency_amt    giac_upload_dv_payt_dtl.dv_fcurrency_amt%TYPE,                       
        currency_rt         giac_upload_dv_payt_dtl.currency_rt%TYPE,    
        dsp_short_name      giac_parameters.param_value_v%TYPE,                    
        payt_amt            giac_upload_dv_payt_dtl.payt_amt%TYPE,
        currency_cd         giac_upload_dv_payt_dtl.currency_cd%TYPE,      
        payee_first_name    giis_payees.payee_first_name%TYPE, 
        payee_middle_name   giis_payees.payee_middle_name%TYPE,
        payee_last_name     giis_payees.payee_last_name%TYPE,
        --populate_chk_tags procedure
        document_name       giac_payt_req_docs.document_name%TYPE,
        line_cd_tag         giac_payt_req_docs.line_cd_tag%TYPE,  
        yy_tag              giac_payt_req_docs.yy_tag%TYPE,       
        mm_tag              giac_payt_req_docs.mm_tag%TYPE,
        v_exists            VARCHAR2(1)      
   );
   
   TYPE giac_upload_dv_payt_dtl_tab IS TABLE OF giac_upload_dv_payt_dtl_type;
        
   FUNCTION get_giac_upload_dv_payt_dtl(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   )
     RETURN giac_upload_dv_payt_dtl_tab PIPELINED;
     
   PROCEDURE save_giac_upload_dv_payt_dtl (p_rec giac_upload_dv_payt_dtl%ROWTYPE);
   
   PROCEDURE del_giac_upload_dv_payt_dtl (
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2
   );
   
   TYPE giac_upload_jv_payt_dtl_type is RECORD (
        source_cd           giac_upload_jv_payt_dtl.source_cd%TYPE,        
        file_no             giac_upload_jv_payt_dtl.file_no%TYPE,          
        branch_cd           giac_upload_jv_payt_dtl.branch_cd%TYPE,        
        dsp_branch_name     giac_branches.branch_name%TYPE,         
        tran_date           giac_upload_jv_payt_dtl.tran_date%TYPE,
        jv_tran_tag         giac_upload_jv_payt_dtl.jv_tran_tag%TYPE,
        jv_tran_type        giac_upload_jv_payt_dtl.jv_tran_type%TYPE,
        dsp_tran_desc       giac_jv_trans.jv_tran_desc%TYPE,
        jv_tran_mm          giac_upload_jv_payt_dtl.jv_tran_mm%TYPE,
        jv_tran_yy          giac_upload_jv_payt_dtl.jv_tran_yy%TYPE,  
        tran_year           giac_upload_jv_payt_dtl.tran_year%TYPE,   
        tran_month          giac_upload_jv_payt_dtl.tran_month%TYPE,  
        tran_seq_no         giac_upload_jv_payt_dtl.tran_seq_no%TYPE, 
        jv_pref_suff        giac_upload_jv_payt_dtl.jv_pref_suff%TYPE,
        jv_no               giac_upload_jv_payt_dtl.jv_no%TYPE,       
        particulars         giac_upload_jv_payt_dtl.particulars%TYPE, 
        v_exists            VARCHAR2(1)      
   );
   
   TYPE giac_upload_jv_payt_dtl_tab IS TABLE OF giac_upload_jv_payt_dtl_type;
        
   FUNCTION get_giac_upload_jv_payt_dtl(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   )
     RETURN giac_upload_jv_payt_dtl_tab PIPELINED;
     
   PROCEDURE save_giac_upload_jv_payt_dtl (p_rec giac_upload_jv_payt_dtl%ROWTYPE);
   
   PROCEDURE del_giac_upload_jv_payt_dtl (
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2
   );
   
   PROCEDURE check_data_giacs603 (
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   );
   
   PROCEDURE cancel_file_giacs603 (
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   );
   
   PROCEDURE giacs603_validate_upload (
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   );
   
   PROCEDURE get_default_bank (
        p_branch_cd     VARCHAR2,
        p_user_id       VARCHAR2,
        p_dcb_bank_cd      OUT VARCHAR2,
        p_dcb_bank_acct_cd OUT VARCHAR2,
        p_dcb_bank_name    OUT VARCHAR2,
        p_dcb_bank_acct_no OUT VARCHAR2
   );
   
   TYPE giacs603_bank_lov_type IS RECORD (
      bank_cd         giac_bank_accounts.bank_cd%TYPE,
      bank_name       giac_banks.bank_name%TYPE
   ); 

   TYPE giacs603_bank_lov_tab IS TABLE OF giacs603_bank_lov_type;

   FUNCTION get_giacs603_bank_lov(
        p_search        VARCHAR2
   ) 
   RETURN giacs603_bank_lov_tab PIPELINED;
   
   TYPE giacs603_bank_acct_lov_type IS RECORD (
      bank_acct_cd      giac_bank_accounts.bank_acct_cd%TYPE,  
      bank_acct_no      giac_bank_accounts.bank_acct_no%TYPE,  
      bank_acct_type    giac_bank_accounts.bank_acct_type%TYPE,
      branch_cd         giac_bank_accounts.branch_cd%TYPE     
   ); 

   TYPE giacs603_bank_acct_lov_tab IS TABLE OF giacs603_bank_acct_lov_type;
   
   FUNCTION get_giacs603_bank_acct_lov(
        p_search        VARCHAR2,
        p_bank_cd       VARCHAR2
   ) 
   RETURN giacs603_bank_acct_lov_tab PIPELINED;
   
   PROCEDURE process_giacs603 (
        p_or_date         VARCHAR2,
        p_file_no         VARCHAR2,
        p_source_cd       VARCHAR2,
        p_user_id         VARCHAR2,
        p_dcb_no      OUT VARCHAR2,
        p_exists      OUT VARCHAR2
   );
   
   PROCEDURE check_tran_mm (p_date IN giac_acctrans.tran_date%TYPE);
   
   PROCEDURE check_dcb_user (p_date IN giac_acctrans.tran_date%TYPE);
   
   PROCEDURE get_dcb_no (
       p_date     IN       giac_acctrans.tran_date%TYPE,
       p_dcb_no   OUT      giac_colln_batch.dcb_no%TYPE
    );
        
   PROCEDURE check_for_claim(
        p_file_no   VARCHAR2,
        p_source_cd VARCHAR2,
        p_user_id   VARCHAR2,
        p_exists    OUT VARCHAR2
   );
   
   PROCEDURE check_for_override(
        p_file_no   VARCHAR2,
        p_source_cd VARCHAR2,
        p_exists    OUT VARCHAR2
   );
   
   PROCEDURE giacs603_upload_payments(
       p_branch_cd   VARCHAR2,
       p_source_cd   VARCHAR2,
       p_file_no     VARCHAR2,
       p_dcb_no      VARCHAR2,
       p_or_date     VARCHAR2,
       p_payment_date VARCHAR2,
       p_dcb_bank_cd  VARCHAR2,
       p_dcb_bank_acct_cd VARCHAR2,
       p_user_id     VARCHAR2,
       p_tran_class  VARCHAR2
   );
   
   PROCEDURE validate_policy(
        p_source_cd   VARCHAR2,
        p_file_no     VARCHAR2
   );
   
   PROCEDURE gen_multiple_or(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_or_date           VARCHAR2,
        p_dcb_bank_cd       VARCHAR2,
        p_dcb_bank_acct_cd  VARCHAR2,
        p_payment_date      VARCHAR2
   );
   
   PROCEDURE process_payments (
        p_payor        giac_order_of_payts.payor%TYPE,
        p_source_cd    VARCHAR2,
        p_file_no      VARCHAR2
   ); 
   
   FUNCTION get_pol_assd_no (
       p_line_cd      gipi_polbasic.line_cd%TYPE,
       p_subline_cd   gipi_polbasic.subline_cd%TYPE,
       p_iss_cd       gipi_polbasic.iss_cd%TYPE,
       p_issue_yy     gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no     gipi_polbasic.renew_no%TYPE
   )
        RETURN NUMBER;
        
    PROCEDURE insert_premium_collns (
       p_line_cd                gipi_polbasic.line_cd%TYPE,
       p_subline_cd             gipi_polbasic.subline_cd%TYPE,
       p_iss_cd                 gipi_polbasic.iss_cd%TYPE,
       p_issue_yy               gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no             gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no               gipi_polbasic.renew_no%TYPE,
       p_collection_amt         giac_direct_prem_collns.collection_amt%TYPE,
       p_prem_chk_flag          giac_upload_prem.prem_chk_flag%TYPE,
       p_rem_colln_amt    OUT   giac_direct_prem_collns.collection_amt%TYPE
    );
    
    PROCEDURE with_tax_allocation;
    
    PROCEDURE gen_dpc_op_text;
    
    PROCEDURE gen_dpc_op_text_prem (
       p_iss_cd         IN   giac_direct_prem_collns.b140_iss_cd%TYPE,
       p_prem_seq_no    IN   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
       p_inst_no        IN   giac_direct_prem_collns.inst_no%TYPE,
       p_premium_amt    IN   NUMBER,
       p_currency_cd    IN   giac_direct_prem_collns.currency_cd%TYPE,
       p_convert_rate   IN   giac_direct_prem_collns.convert_rate%TYPE
    );
    
    PROCEDURE gen_dpc_op_text_prem2 (
       p_seq_no         NUMBER,
       p_premium_amt    gipi_invoice.prem_amt%TYPE,
       p_prem_text      VARCHAR2,
       p_currency_cd    giac_direct_prem_collns.currency_cd%TYPE,
       p_convert_rate   giac_direct_prem_collns.convert_rate%TYPE
    );
    
    PROCEDURE gen_dpc_op_text_tax (
       p_tax_cd         NUMBER,
       p_tax_name       VARCHAR2,
       p_tax_amt        NUMBER,
       p_currency_cd    NUMBER,
       p_convert_rate   NUMBER
    );
    
    PROCEDURE insert_prem_deposit (
       p_collection_amt   giac_prem_deposit.collection_amt%TYPE
    );
    
    PROCEDURE gen_prem_dep_op_text;
    
    PROCEDURE gen_misc_op_text (
       p_item_text   giac_op_text.item_text%TYPE,
       p_item_amt    giac_op_text.item_amt%TYPE
    );
    
    FUNCTION get_or_particulars (
       p_tran_id            giac_acctrans.tran_id%TYPE,
       p_acct_payable_amt   NUMBER,
       p_prem_dep_amt       NUMBER
    )
    RETURN VARCHAR2;
    
    FUNCTION get_payment_details_prc (
       p_line_cd      giac_upload_prem.line_cd%TYPE,
       p_subline_cd   giac_upload_prem.subline_cd%TYPE,
       p_iss_cd       giac_upload_prem.iss_cd%TYPE,
       p_issue_yy     giac_upload_prem.issue_yy%TYPE,
       p_pol_seq_no   giac_upload_prem.pol_seq_no%TYPE,
       p_renew_no     giac_upload_prem.renew_no%TYPE,
       p_payor        giac_upload_prem.payor%TYPE,
       p_source_cd    VARCHAR2,
       p_file_no      VARCHAR2
    )
       RETURN VARCHAR2;
       
    PROCEDURE gen_jv(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2
    );
    
    PROCEDURE gen_dv(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2
    );
    
    PROCEDURE check_payment_details (
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_tran_class        VARCHAR2,
        p_user_id           VARCHAR2,
        p_dcb_no      OUT   VARCHAR2,
        p_exists      OUT   VARCHAR2
    );
    
    PROCEDURE validate_print_or (
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_branch_cd   OUT   VARCHAR2,
        p_fund_cd     OUT   VARCHAR2,
        p_branch_name OUT   VARCHAR2,
        p_fund_desc   OUT   VARCHAR2,
        p_tran_id     OUT   NUMBER
    );
    
    PROCEDURE validate_print_dv (
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_branch_cd   OUT   VARCHAR2,
        p_gprq_ref_id OUT   VARCHAR2,
        p_doc_cd      OUT   VARCHAR2
    );
    
    PROCEDURE validate_print_jv (
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_fund_cd     OUT   VARCHAR2,
        p_branch_cd   OUT   VARCHAR2,
        p_tran_id     OUT   VARCHAR2
    );
    
    --nieko Accounting Uploading GIACS603
    PROCEDURE validate_print_or2 (
        p_source_cd           VARCHAR2,
        p_file_no             VARCHAR2,
        p_branch_cd     OUT   VARCHAR2,
        p_fund_cd       OUT   VARCHAR2,
        p_branch_name   OUT   VARCHAR2,
        p_fund_desc     OUT   VARCHAR2,
        p_tran_id       OUT   NUMBER,
        p_upload_query  OUT   VARCHAR2
    );
    
    PROCEDURE check_dcb_no (
        p_branch_cd       VARCHAR2,
        p_user_id         VARCHAR2,
        p_or_date         VARCHAR2
    );
    --nieko end
END; 
/


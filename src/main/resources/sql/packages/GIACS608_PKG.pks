CREATE OR REPLACE PACKAGE CPI.GIACS608_PKG
AS
   --variables
   variables_user_id            VARCHAR2(12);
   variables_upload_tag         VARCHAR2(1) := 'N';
   variables_tran_id            giac_acctrans.tran_id%TYPE;
   variables_prem_payt_for_sp   giac_parameters.param_value_v%TYPE := nvl(giacp.v('PREM_PAYT_FOR_SPECIAL'),'Y');
   variables_fund_cd            giac_acct_entries.gacc_gfun_fund_cd%TYPE := giacp.v('FUND_CD');
   variables_branch_cd          giac_acct_entries.gacc_gibr_branch_cd%TYPE;
   variables_dcb_no             giac_colln_batch.dcb_no%TYPE;
   variables_max_colln_amt      NUMBER;
   variables_max_iss_cd         gipi_invoice.iss_cd%TYPE;
   variables_max_prem_seq_no    gipi_invoice.prem_seq_no%TYPE;
   variables_tran_date          giac_acctrans.tran_date%TYPE;
   variables_transaction_type   giac_direct_prem_collns.transaction_type%TYPE;
   
   variables_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE;
   variables_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE;
   variables_inst_no            giac_direct_prem_collns.inst_no%TYPE;
   variables_max_collection_amt giac_direct_prem_collns.collection_amt%TYPE;
   variables_max_premium_amt    giac_direct_prem_collns.premium_amt%TYPE;
   variables_max_tax_amt        giac_direct_prem_collns.tax_amt%TYPE;
   variables_collection_amt     giac_direct_prem_collns.collection_amt%TYPE;
   variables_currency_cd        giac_direct_prem_collns.currency_cd%TYPE;
   variables_currency_rt		gipi_invoice.currency_rt%TYPE;
   variables_convert_rate       giac_direct_prem_collns.convert_rate%TYPE;
   variables_tax_amt            giac_direct_prem_collns.tax_amt%TYPE;
   variables_premium_amt        giac_direct_prem_collns.premium_amt%TYPE;
   variables_foreign_curr_amt   giac_direct_prem_collns.foreign_curr_amt%TYPE;
   variables_wtax				giac_aging_ri_soa_details.wholding_tax_bal%TYPE;
   variables_comm_vat			giac_aging_ri_soa_details.comm_vat%TYPE;
   variables_fcurrency_amt		giac_inwfacul_prem_collns.foreign_curr_amt%TYPE;
   variables_comm_amt			giac_aging_ri_soa_details.comm_balance_due%TYPE;
   variables_prem_amt			giac_aging_ri_soa_details.prem_balance_due%TYPE;
   
   variables_gen_type           giac_modules.generation_type%TYPE;
   variables_module_id          giac_modules.module_id%TYPE;
   
   variables_n_seq_no           NUMBER := 3;
   variables_zero_prem_op_text  VARCHAR2(1) := 'N'; 
   variables_evat_cd            NUMBER := giacp.n('EVAT');
   
   variables_tran_class         giac_upload_file.tran_class%TYPE;
   variables_file_no            giac_upload_file.file_no%TYPE;
   variables_source_cd          giac_upload_file.source_cd%TYPE;
   
   variables_stale_check		GIAC_PARAMETERS.param_value_n%TYPE := giacp.n('STALE_CHECK');
   variables_stale_days		    GIAC_PARAMETERS.param_value_n%TYPE := giacp.n('STALE_DAYS');
   variables_stale_mgr_chk	    GIAC_PARAMETERS.param_value_n%TYPE := giacp.n('STALE_MGR_CHK');
   
   variables_upload_payt_tag	VARCHAR2(1) := 'N';
   variables_reinsurer          giis_reinsurer.ri_name%TYPE;
   variables_sl_type_cd1        giac_parameters.param_name%type;
   variables_sl_type_cd2        giac_parameters.param_name%type;
   variables_sl_type_cd3        giac_parameters.param_name%TYPE;
   variables_sl_type_cd4        giac_parameters.param_name%TYPE;
   variables_sl_type_cd5        giac_parameters.param_name%TYPE;
   variables_sl_type_cd6        giac_parameters.param_name%TYPE;
   variables_assd_no			giac_parameters.param_value_v%TYPE;
   variables_ri_cd              giac_parameters.param_value_v%TYPE;
   variables_line_cd            giac_parameters.param_value_v%TYPE;
   variables_evat_name          giac_taxes.tax_name%TYPE;
   
   TYPE assured_rg_type IS RECORD (
      assd_no        NUMBER,
      pay_rcv_amt    NUMBER
   );
   TYPE assured_rg_tab IS TABLE OF assured_rg_type;
   
   rg_id assured_rg_tab;
   
   TYPE legend_rec_type IS RECORD (
        legend              VARCHAR2(100)
   );
   
   TYPE legend_rec_tab IS TABLE OF legend_rec_type;
        
   FUNCTION populate_legend
        RETURN legend_rec_tab PIPELINED;
        
   TYPE guf_type IS RECORD(
        tran_id             GIAC_UPLOAD_FILE.tran_id%TYPE,        
        file_no             GIAC_UPLOAD_FILE.file_no%TYPE,         
        file_name           GIAC_UPLOAD_FILE.file_name%TYPE,       
        file_status         GIAC_UPLOAD_FILE.file_status%TYPE,     
        source_cd           GIAC_UPLOAD_FILE.source_cd%TYPE,       
        transaction_type    GIAC_UPLOAD_FILE.transaction_type%TYPE,
        convert_date        GIAC_UPLOAD_FILE.convert_date%TYPE,    
        dsp_source_name     GIAC_FILE_SOURCE.source_name%TYPE, 
        ri_cd               GIAC_UPLOAD_FILE.ri_cd%TYPE,           
        dsp_ri              GIIS_REINSURER.ri_name%TYPE,          
        tran_date           GIAC_UPLOAD_FILE.tran_date%TYPE,       
--        dsp_or_req_jv_no    GIAC_UPLOAD_FILE.dsp_or_req_jv_no%TYPE,
        tran_class          GIAC_UPLOAD_FILE.tran_class%TYPE,      
        dsp_tran_class      GIAC_UPLOAD_FILE.tran_class%TYPE,  
        upload_date         GIAC_UPLOAD_FILE.upload_date%TYPE,     
        cancel_date         GIAC_UPLOAD_FILE.cancel_date%TYPE,     
        dsp_or_date         DATE,     
        branch_cd           GIIS_USER_GRP_HDR.grp_iss_cd%TYPE,
        
        no_of_records       GIAC_UPLOAD_FILE.no_of_records%TYPE,
        remarks             GIAC_UPLOAD_FILE.remarks%TYPE
   );
   
   TYPE guf_tab IS TABLE OF guf_type;
   
   FUNCTION get_giacs608_guf(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_user_id           VARCHAR2
   )
        RETURN guf_tab PIPELINED;
        
        
   TYPE giup_type IS RECORD(
        tran_date           giac_upload_inwfacul_prem.tran_date%TYPE,      
        source_cd           giac_upload_inwfacul_prem.source_cd%TYPE,      
        file_no             giac_upload_inwfacul_prem.file_no%TYPE,      
        line_cd             giac_upload_inwfacul_prem.line_cd%TYPE,        
        subline_cd          giac_upload_inwfacul_prem.subline_cd%TYPE,     
        iss_cd              giac_upload_inwfacul_prem.iss_cd%TYPE,         
        issue_yy            giac_upload_inwfacul_prem.issue_yy%TYPE,       
        pol_seq_no          giac_upload_inwfacul_prem.pol_seq_no%TYPE,     
        lprem_amt           giac_upload_inwfacul_prem.lprem_amt%TYPE,      
        ltax_amt            giac_upload_inwfacul_prem.ltax_amt%TYPE,       
        renew_no            giac_upload_inwfacul_prem.renew_no%TYPE,       
        lcomm_amt           giac_upload_inwfacul_prem.lcomm_amt%TYPE,
        lcomm_vat           giac_upload_inwfacul_prem.lcomm_vat%TYPE,
        lcollection_amt     giac_upload_inwfacul_prem.lcollection_amt%TYPE,
        dsp_diff_prem       NUMBER(16,2),
        dsp_prem_vat        NUMBER(16,2),
        dsp_comm_diff       NUMBER(16,2),
        dsp_comm_vat        NUMBER(16,2),
        prem_chk_flag       giac_upload_inwfacul_prem.prem_chk_flag%TYPE,
        assured             giac_upload_inwfacul_prem.assured%TYPE,      
        chk_remarks         giac_upload_inwfacul_prem.chk_remarks%TYPE,  
        prem_amt_due        giac_upload_inwfacul_prem.prem_amt_due%TYPE,
        tax_amt_due         giac_upload_inwfacul_prem.tax_amt_due%TYPE,  
        comm_amt_due        giac_upload_inwfacul_prem.comm_amt_due%TYPE, 
        comm_vat_due        giac_upload_inwfacul_prem.comm_vat_due%TYPE, 
        tot_amt_due         NUMBER(16,2),
        nbt_assd_no         VARCHAR2(12),
        nbt_policy_id       VARCHAR2(12),
        currency_cd         giac_upload_inwfacul_prem.currency_cd%TYPE,
        convert_rate        giac_upload_inwfacul_prem.convert_rate%TYPE,
        dsp_or_date         DATE,
        policy_no           VARCHAR2(50),
        dsp_currency        VARCHAR2(20),
        fprem_amt           giac_upload_inwfacul_prem.fprem_amt%TYPE,
        ftax_amt            giac_upload_inwfacul_prem.ftax_amt%TYPE,
        fcomm_amt           giac_upload_inwfacul_prem.fcomm_amt%TYPE,
        fcomm_vat           giac_upload_inwfacul_prem.fcomm_vat%TYPE,
        fcollection_amt     giac_upload_inwfacul_prem.fcollection_amt%TYPE,
        dsp_fprem_diff      NUMBER(16,2),
        dsp_ftax_diff       NUMBER(16,2),
        dsp_fcomm_diff      NUMBER(16,2),
        dsp_fvat_diff       NUMBER(16,2),
        dsp_fcollect_diff   NUMBER(16,2)
   );
   
   TYPE giup_tab IS TABLE OF giup_type;
        
   FUNCTION get_giacs608_giup(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_user_id           VARCHAR2
   )
        RETURN giup_tab PIPELINED;
        
   PROCEDURE get_giacs608_giup_totals(
        p_source_cd                 VARCHAR2,
        p_file_no                   VARCHAR2,
        p_user_id                   VARCHAR2,
        dsp_tot_prem           OUT  giac_upload_inwfacul_prem.lprem_amt%TYPE,
        dsp_tot_tax            OUT  giac_upload_inwfacul_prem.ltax_amt%TYPE,
        dsp_tot_comm           OUT  giac_upload_inwfacul_prem.lcomm_amt%TYPE,
        dsp_tot_vat            OUT  giac_upload_inwfacul_prem.lcomm_vat%TYPE,
        dsp_tot_collection     OUT  giac_upload_inwfacul_prem.lcollection_amt%TYPE,
        dsp_diff_prem_tot      OUT  giac_upload_inwfacul_prem.lprem_amt%TYPE,
        dsp_diff_prem_vat_tot  OUT  giac_upload_inwfacul_prem.ltax_amt%TYPE,
        dsp_diff_comm_tot      OUT  giac_upload_inwfacul_prem.lcomm_amt%TYPE,
        dsp_comm_vat_diff_tot  OUT  giac_upload_inwfacul_prem.lcomm_vat%TYPE
   );
   
    TYPE gucd_type IS RECORD(
        source_cd               GIAC_UPLOAD_COLLN_DTL.source_cd%TYPE,
        file_no                 GIAC_UPLOAD_COLLN_DTL.file_no%TYPE,
        item_no                 GIAC_UPLOAD_COLLN_DTL.item_no%TYPE,
        pay_mode                GIAC_UPLOAD_COLLN_DTL.pay_mode%TYPE,
        bank_cd                 GIAC_UPLOAD_COLLN_DTL.bank_cd%TYPE,
        dsp_bank                VARCHAR2(10),
        check_class             GIAC_UPLOAD_COLLN_DTL.check_class%TYPE,
        check_no                GIAC_UPLOAD_COLLN_DTL.check_no%TYPE,
        check_date              GIAC_UPLOAD_COLLN_DTL.check_date%TYPE,
        amount                  GIAC_UPLOAD_COLLN_DTL.amount%TYPE,
        fc_gross_amt            GIAC_UPLOAD_COLLN_DTL.fc_gross_amt%TYPE,
        currency_cd             GIAC_UPLOAD_COLLN_DTL.currency_cd%TYPE,
        dsp_currency            VARCHAR2(3),
        dcb_bank_cd             GIAC_UPLOAD_COLLN_DTL.dcb_bank_cd%TYPE, 
        dsp_dcb_bank_name       VARCHAR2(100), --:PARAMETER.DFLT_DCB_BANK_NAME
        dcb_bank_acct_cd        GIAC_UPLOAD_COLLN_DTL.dcb_bank_acct_cd%TYPE,
        dsp_dcb_bank_acct_no    VARCHAR2(50), --:PARAMETER.DFLT_DCB_BANK_ACCT_NO
        particulars             GIAC_UPLOAD_COLLN_DTL.particulars%TYPE,
        gross_amt               GIAC_UPLOAD_COLLN_DTL.gross_amt%TYPE,
        commission_amt          GIAC_UPLOAD_COLLN_DTL.commission_amt%TYPE,
        vat_amt                 GIAC_UPLOAD_COLLN_DTL.vat_amt%TYPE,
        currency_rt             GIAC_UPLOAD_COLLN_DTL.currency_rt%TYPE
   );                           
   
   TYPE gucd_tab IS TABLE OF gucd_type;
        
   FUNCTION get_giacs608_gucd(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_user_id           VARCHAR2
   )
        RETURN gucd_tab PIPELINED;
        
        
    PROCEDURE del_gucd(
        p_source_cd     IN  giac_upload_colln_dtl.SOURCE_CD%TYPE,
        p_file_no       IN  giac_upload_colln_dtl.FILE_NO%TYPE,
        p_item_no       IN  giac_upload_colln_dtl.ITEM_NO%TYPE
    );
    
    PROCEDURE set_gucd(
        p_rec       giac_upload_colln_dtl%ROWTYPE
    );
    
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
     
    PROCEDURE check_data_giacs608 (
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   );
   
   PROCEDURE check_collection_amount(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2
   );
   
   PROCEDURE check_payment_details(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_tran_class    VARCHAR2
   );
   
   PROCEDURE get_parameters(
        p_source_cd                 VARCHAR2,
        p_file_no                   VARCHAR2,
        p_user_id                   VARCHAR2,
        p_branch_cd            OUT  VARCHAR2
   );
   
   PROCEDURE proceed_upload(
        p_source_cd                 VARCHAR2,
        p_file_no                   VARCHAR2,
        p_user_id                   VARCHAR2,
        p_tran_class                VARCHAR2,
        p_override                  VARCHAR2,
        p_or_date                   VARCHAR2
   );
   
   PROCEDURE upload_giacs608(
        p_source_cd                 VARCHAR2,
        p_file_no                   VARCHAR2,
        p_user_id                   VARCHAR2
   );
   
   /*
   ** nieko Accounting Uploading GIACS608 
   */
   PROCEDURE validate_print_or (
        p_source_cd           VARCHAR2,
        p_file_no             VARCHAR2,
        p_branch_cd     OUT   VARCHAR2,
        p_fund_cd       OUT   VARCHAR2,
        p_branch_name   OUT   VARCHAR2,
        p_fund_desc     OUT   VARCHAR2,
        p_tran_id       OUT   NUMBER,
        p_upload_query  OUT   VARCHAR2
    );
    
    TYPE guf_type2 IS RECORD (
        source_cd           giac_upload_file.SOURCE_CD%TYPE,
        nbt_source_name     giac_file_source.SOURCE_NAME%TYPE,
        file_no             giac_upload_file.FILE_NO%TYPE,
        file_name           giac_upload_file.FILE_NAME%TYPE,
        tran_date           giac_upload_file.TRAN_DATE%TYPE,
        tran_id             giac_upload_file.TRAN_ID%TYPE,
        file_status         giac_upload_file.FILE_STATUS%TYPE,
        nbt_or_req_jv_no    VARCHAR2(100),
        tran_class          giac_upload_file.TRAN_CLASS%TYPE,
        convert_date        giac_upload_file.CONVERT_DATE%TYPE,
        upload_date         giac_upload_file.UPLOAD_DATE%TYPE,
        cancel_date         giac_upload_file.CANCEL_DATE%TYPE,
        gross_tag           giac_upload_file.GROSS_TAG%TYPE,
        nbt_or_tag          giac_file_source.OR_TAG%TYPE,
        nbt_tran_class      giac_upload_file.TRAN_CLASS%TYPE,
        nbt_gross_tag       giac_upload_file.GROSS_TAG%TYPE,
        nbt_or_date         giac_upload_file.TRAN_DATE%TYPE             
    );
    
    TYPE guf_tab2 IS TABLE OF guf_type2;
    
    FUNCTION get_guf_details(
        p_source_cd         giac_upload_file.SOURCE_CD%TYPE,
        p_file_no           giac_upload_file.FILE_NO%TYPE
    ) RETURN guf_tab2 PIPELINED;
    
    PROCEDURE gen_individual_or;
    
    PROCEDURE gen_group_or;
    
    PROCEDURE process_payments2 (
       p_line_cd           giac_upload_inwfacul_prem.line_cd%TYPE,
       p_subline_cd        giac_upload_inwfacul_prem.subline_cd%TYPE,
       p_iss_cd            giac_upload_inwfacul_prem.iss_cd%TYPE,
       p_issue_yy          giac_upload_inwfacul_prem.issue_yy%TYPE,
       p_pol_seq_no        giac_upload_inwfacul_prem.pol_seq_no%TYPE,
       p_renew_no          giac_upload_inwfacul_prem.renew_no%TYPE,
       p_ri_cd             giac_upload_inwfacul_prem.ri_cd%TYPE,
       p_nbt_or_tag        giac_file_source.or_tag%TYPE
    );
    
    TYPE gucd_type2 IS RECORD (
      source_cd          giac_upload_colln_dtl.source_cd%TYPE,
      file_no            giac_upload_colln_dtl.file_no%TYPE,
      item_no            giac_upload_colln_dtl.item_no%TYPE,
      pay_mode           giac_upload_colln_dtl.pay_mode%TYPE,
      amount             giac_upload_colln_dtl.amount%TYPE,
      gross_amt          giac_upload_colln_dtl.gross_amt%TYPE,
      commission_amt     giac_upload_colln_dtl.commission_amt%TYPE,
      vat_amt            giac_upload_colln_dtl.vat_amt%TYPE,
      check_class        giac_upload_colln_dtl.check_class%TYPE,
      check_date         giac_upload_colln_dtl.check_date%TYPE,
      check_no           giac_upload_colln_dtl.check_no%TYPE,
      particulars        giac_upload_colln_dtl.particulars%TYPE,
      bank_cd            giac_upload_colln_dtl.bank_cd%TYPE,
      currency_cd        giac_upload_colln_dtl.currency_cd%TYPE,
      currency_rt        giac_upload_colln_dtl.currency_rt%TYPE,
      dcb_bank_cd        giac_upload_colln_dtl.dcb_bank_cd%TYPE,
      dcb_bank_acct_cd   giac_upload_colln_dtl.dcb_bank_acct_cd%TYPE,
      fc_comm_amt        giac_upload_colln_dtl.fc_comm_amt%TYPE,
      fc_vat_amt         giac_upload_colln_dtl.fc_vat_amt%TYPE,
      fc_gross_amt       giac_upload_colln_dtl.fc_gross_amt%TYPE,
      tran_id            giac_upload_colln_dtl.tran_id%TYPE,
      current_amt        giac_upload_colln_dtl.amount%TYPE
   );

   TYPE gucd_tab2 IS TABLE OF gucd_type2;
   
   FUNCTION get_giacs608_gucd2 (
      p_source_cd   VARCHAR2,
      p_file_no     VARCHAR2
   )
      RETURN gucd_tab2 PIPELINED;
      
   PROCEDURE check_dcb_no (
        p_branch_cd       VARCHAR2,
        p_user_id         VARCHAR2,
        p_or_date         VARCHAR2
   );
   
   PROCEDURE check_net_colln(
        p_source_cd     IN  giac_upload_colln_dtl.SOURCE_CD%TYPE,
        p_file_no       IN  giac_upload_colln_dtl.FILE_NO%TYPE
   );
   /*
   ** nieko end
   */ 
END; 
/


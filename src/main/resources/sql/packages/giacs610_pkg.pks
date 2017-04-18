CREATE OR REPLACE PACKAGE CPI.GIACS610_PKG
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
   variables_currency_rt        gipi_invoice.currency_rt%TYPE;
   variables_convert_rate       giac_direct_prem_collns.convert_rate%TYPE;
   variables_tax_amt            giac_direct_prem_collns.tax_amt%TYPE;
   variables_premium_amt        giac_direct_prem_collns.premium_amt%TYPE;
   variables_foreign_curr_amt   giac_direct_prem_collns.foreign_curr_amt%TYPE;
   variables_wtax                giac_aging_ri_soa_details.wholding_tax_bal%TYPE;
   variables_comm_vat            giac_aging_ri_soa_details.comm_vat%TYPE;
   variables_fcurrency_amt        giac_inwfacul_prem_collns.foreign_curr_amt%TYPE;
   variables_comm_amt            giac_aging_ri_soa_details.comm_balance_due%TYPE;
   variables_prem_amt            giac_aging_ri_soa_details.prem_balance_due%TYPE;
   
   variables_gen_type           giac_modules.generation_type%TYPE;
   variables_module_id          giac_modules.module_id%TYPE;
   
   variables_n_seq_no           NUMBER := 3;
   variables_zero_prem_op_text  VARCHAR2(1) := 'N'; 
   variables_evat_cd            NUMBER := giacp.n('EVAT');
   
   variables_tran_class         giac_upload_file.tran_class%TYPE;
   variables_file_no            giac_upload_file.file_no%TYPE;
   variables_source_cd          giac_upload_file.source_cd%TYPE;
   
   variables_stale_check        GIAC_PARAMETERS.param_value_n%TYPE := giacp.n('STALE_CHECK');
   variables_stale_days            GIAC_PARAMETERS.param_value_n%TYPE := giacp.n('STALE_DAYS');
   variables_stale_mgr_chk        GIAC_PARAMETERS.param_value_n%TYPE := giacp.n('STALE_MGR_CHK');
   
   variables_upload_payt_tag    VARCHAR2(1) := 'N';
   variables_reinsurer          giis_reinsurer.ri_name%TYPE;
   variables_sl_type_cd1        giac_parameters.param_name%type;
   variables_sl_type_cd2        giac_parameters.param_name%type;
   variables_sl_type_cd3        giac_parameters.param_name%TYPE;
   variables_sl_type_cd4        giac_parameters.param_name%TYPE;
   variables_sl_type_cd5        giac_parameters.param_name%TYPE;
   variables_sl_type_cd6        giac_parameters.param_name%TYPE;
   variables_assd_no            giac_parameters.param_value_v%TYPE;
   variables_ri_cd              giac_parameters.param_value_v%TYPE;
   variables_line_cd            giac_parameters.param_value_v%TYPE;
   variables_evat_name          giac_taxes.tax_name%TYPE;
   
   variables_upload_no          giac_upload_prem_refno.upload_no%TYPE;
   variables_jv_tran_id			giac_acctrans.tran_id%TYPE;
   
   variables_dcb_bank_cd        VARCHAR2(3);
   variables_dcb_bank_acct_cd	VARCHAR2(4);
   
   variables_v_date             DATE;
   variables_intm_no            giis_intermediary.intm_no%TYPE;
   variables_parent_intm_no	    giac_comm_payts.parent_intm_no%TYPE;
   variables_comm_tag			giac_comm_payts.comm_tag%TYPE;
   variables_process_all		VARCHAR2(1); --Deo [10.06.2016]
   variables_jv_branch_cd       giac_acctrans.gibr_branch_cd%TYPE; --Deo [10.06.2016]
   
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
        file_no             GIAC_UPLOAD_FILE.file_no%TYPE,
        complete_sw         GIAC_UPLOAD_FILE.complete_sw%TYPE,
        file_name           GIAC_UPLOAD_FILE.file_name%TYPE,       
        source_cd           GIAC_UPLOAD_FILE.source_cd%TYPE,
        dsp_source_name     GIAC_FILE_SOURCE.source_name%TYPE, 
        payment_date        GIAC_UPLOAD_FILE.payment_date%TYPE,
        tran_date           GIAC_UPLOAD_FILE.tran_date%TYPE,
        dsp_jv_no           VARCHAR2(50),
        tran_id             GIAC_UPLOAD_FILE.tran_id%TYPE,
        file_status         GIAC_UPLOAD_FILE.file_status%TYPE,  
        no_of_records       GIAC_UPLOAD_FILE.no_of_records%TYPE, 
        transaction_type    GIAC_UPLOAD_FILE.transaction_type%TYPE,
        tran_class          GIAC_UPLOAD_FILE.tran_class%TYPE,      
        dsp_tran_class      GIAC_UPLOAD_FILE.tran_class%TYPE,  
        convert_date        GIAC_UPLOAD_FILE.convert_date%TYPE, 
        nbt_or_date         DATE,
        upload_date         GIAC_UPLOAD_FILE.upload_date%TYPE,     
        cancel_date         GIAC_UPLOAD_FILE.cancel_date%TYPE,
        remarks             giac_upload_file.remarks%TYPE --Deo [10.06.2016]
   );
   
   TYPE guf_tab IS TABLE OF guf_type;
   
   FUNCTION get_giacs610_guf(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_user_id           VARCHAR2
   )
        RETURN guf_tab PIPELINED;
        
        
   TYPE gupr_type IS RECORD(
        source_cd           giac_upload_prem_refno.source_cd%TYPE,        
        file_no             giac_upload_prem_refno.file_no%TYPE,       
        bank_ref_no         giac_upload_prem_refno.bank_ref_no%TYPE,   
        acct_iss_cd         giac_upload_prem_refno.acct_iss_cd%TYPE,   
        nbt_branch_cd       NUMBER,
        nbt_ref_no          NUMBER,    
        nbt_mod_no          NUMBER,   
        collection_amt      giac_upload_prem_refno.collection_amt%TYPE,
        prem_chk_flag       giac_upload_prem_refno.prem_chk_flag%TYPE,
        prem_amt_due        giac_upload_prem_refno.prem_amt_due%TYPE,  
        comm_amt_due        giac_upload_prem_refno.comm_amt_due%TYPE,  
        net_prem_amt        giac_upload_prem_refno.net_prem_amt%TYPE,  
        net_comm_amt        giac_upload_prem_refno.net_comm_amt%TYPE,  
        dsp_or_no           VARCHAR2(50),     
        payor               giac_upload_prem_refno.payor%TYPE,         
        chk_remarks         giac_upload_prem_refno.chk_remarks%TYPE,   
        tran_id             giac_upload_prem_refno.tran_id%TYPE,       
        tran_date           giac_upload_prem_refno.tran_date%TYPE,     
        upload_date         giac_upload_prem_refno.upload_date%TYPE,
        upload_sw           giac_upload_prem_refno.upload_sw%TYPE
        
   );
   
   TYPE gupr_tab IS TABLE OF gupr_type;
        
   FUNCTION get_giacs610_gupr(
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_user_id           VARCHAR2
   )
        RETURN gupr_tab PIPELINED;
        
    PROCEDURE check_data_giacs610 (
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2,
        p_rec_id        VARCHAR2, --Deo [10.06.2016]
        p_chk_flag  OUT VARCHAR2  --Deo [10.06.2016]
   );
   
   PROCEDURE check_validated (
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   );
   
   PROCEDURE get_default_bank (
        p_branch_cd            VARCHAR2,
        p_user_id              VARCHAR2,
        p_dcb_bank_cd      OUT VARCHAR2,
        p_dcb_bank_acct_cd OUT VARCHAR2,
        p_dcb_bank_name    OUT VARCHAR2,
        p_dcb_bank_acct_no OUT VARCHAR2
   );
   
   PROCEDURE check_dcb_no (
        p_source_cd       VARCHAR2,
        p_file_no         VARCHAR2,
        p_branch_cd       VARCHAR2,
        p_user_id         VARCHAR2
   );
   
   PROCEDURE upload_payments (
        p_source_cd       VARCHAR2,
        p_file_no         VARCHAR2,
        p_bank_cd         VARCHAR2,
        p_bank_acct_cd    VARCHAR2,
        p_user_id         VARCHAR2,
        p_process_all     VARCHAR2, --Deo [10.06.2016]
        p_rec_id          VARCHAR2  --Deo [10.06.2016]
   );
   
   --Deo [10.06.2016]: add start
   PROCEDURE validate_tran_date (
      p_date        giac_acctrans.tran_date%TYPE,
      p_branch_cd   VARCHAR2,
      p_source_cd   VARCHAR2,
      p_file_no     VARCHAR2,
      p_user_id     VARCHAR2
   );

   PROCEDURE check_tran_mm (p_date giac_acctrans.tran_date%TYPE);

   PROCEDURE cancel_file (
      p_source_cd   VARCHAR2,
      p_file_no     VARCHAR2,
      p_user_id     VARCHAR2
   );

   PROCEDURE validate_print_or (
      p_source_cd            VARCHAR2,
      p_file_no              VARCHAR2,
      p_branch_cd      OUT   VARCHAR2,
      p_fund_cd        OUT   VARCHAR2,
      p_branch_name    OUT   VARCHAR2,
      p_fund_desc      OUT   VARCHAR2,
      p_upload_query   OUT   VARCHAR2
   );

   PROCEDURE pre_upload_check (
      p_source_cd   VARCHAR2,
      p_file_no     VARCHAR2,
      p_user_id     VARCHAR2
   );

   TYPE giacs610_rec_type IS RECORD (
      count_           NUMBER,
      rownum_          NUMBER,
      source_cd        giac_upload_prem_refno.source_cd%TYPE,
      file_no          giac_upload_prem_refno.file_no%TYPE,
      bank_ref_no      giac_upload_prem_refno.bank_ref_no%TYPE,
      payor            giac_upload_prem_refno.payor%TYPE,
      collection_amt   giac_upload_prem_refno.collection_amt%TYPE,
      prem_amt_due     giac_upload_prem_refno.prem_amt_due%TYPE,
      comm_amt_due     giac_upload_prem_refno.comm_amt_due%TYPE,
      prem_chk_flag    giac_upload_prem_refno.prem_chk_flag%TYPE,
      chk_remarks      giac_upload_prem_refno.chk_remarks%TYPE,
      tran_date        giac_upload_prem_refno.tran_date%TYPE,
      upload_date      VARCHAR2 (50),
      upload_sw        giac_upload_prem_refno.upload_sw%TYPE,
      rec_id           giac_upload_prem_refno.rec_id%TYPE,
      tran_id          giac_upload_prem_refno.tran_id%TYPE,
      dsp_or_no        VARCHAR2 (50),
      valid_sw         VARCHAR2 (1),
      claim_sw         VARCHAR2 (1)
   );

   TYPE giacs610_rec_tab IS TABLE OF giacs610_rec_type;

   FUNCTION get_giacs610_records (
      p_source_cd        giac_upload_prem_refno.source_cd%TYPE,
      p_file_no          giac_upload_prem_refno.file_no%TYPE,
      p_bank_ref_no      giac_upload_prem_refno.bank_ref_no%TYPE,
      p_collection_amt   giac_upload_prem_refno.collection_amt%TYPE,
      p_prem_amt_due     giac_upload_prem_refno.prem_amt_due%TYPE,
      p_comm_amt_due     giac_upload_prem_refno.comm_amt_due%TYPE,
      p_prem_chk_flag    giac_upload_prem_refno.prem_chk_flag%TYPE,
      p_chk_remarks      giac_upload_prem_refno.chk_remarks%TYPE,
      p_from             NUMBER,
      p_to               NUMBER,
      p_order_by         VARCHAR2,
      p_asc_desc_flag    VARCHAR2
   )
      RETURN giacs610_rec_tab PIPELINED;
      
   PROCEDURE set_jv_dtls (p_rec giac_upload_jv_payt_dtl%ROWTYPE);

   PROCEDURE del_jv_dtls (
      p_source_cd   giac_upload_jv_payt_dtl.source_cd%TYPE,
      p_file_no     giac_upload_jv_payt_dtl.file_no%TYPE
   );
   --Deo [10.06.2016]: add ends
END; 
/


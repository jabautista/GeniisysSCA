CREATE OR REPLACE PACKAGE CPI.giac_outfacul_prem_payts_pkg
AS
   TYPE binder_list_type IS RECORD (
      line_cd            giri_binder.line_cd%TYPE,
      binder_yy          giri_binder.binder_yy%TYPE,
      binder_seq_no      giri_binder.binder_seq_no%TYPE,
      binder_date        giri_binder.binder_date%TYPE,
      binder_id          giri_binder.fnl_binder_id%TYPE,
      payt_gacc_tran_id  GIAC_OUTFACUL_PREM_PAYTS.GACC_TRAN_ID%TYPE,    -- gacc_tran_id of corresponding payment of reversal :: SR-19631 : shan 08.17.2015
      record_no          GIAC_OUTFACUL_PREM_PAYTS.RECORD_NO%TYPE,   -- SR-19631 : shan 08.17.2015
      ref_no             VARCHAR2(60),         -- SR-19631 : shan 08.17.2015
      policy_id          gipi_polbasic.policy_id%TYPE,
      pol_line_cd        gipi_polbasic.line_cd%TYPE,
      pol_subline_cd     gipi_polbasic.subline_cd%TYPE,
      pol_iss_cd         gipi_polbasic.iss_cd%TYPE,
      pol_issue_yy       gipi_polbasic.issue_yy%TYPE,
      pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      pol_renew_no       gipi_polbasic.renew_no%TYPE,
      endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy            gipi_polbasic.endt_yy%TYPE,
      endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      endt_type          gipi_polbasic.endt_type%TYPE,
      incept_date        gipi_polbasic.incept_date%TYPE,
      expiry_date        gipi_polbasic.expiry_date%TYPE,
      assd_no            gipi_polbasic.assd_no%TYPE,
      currency_cd        giri_distfrps.currency_cd%TYPE,
      currency_rt        giri_distfrps.currency_rt%TYPE,
      currency_desc      giis_currency.currency_desc%TYPE,
      par_id             gipi_polbasic.par_id%TYPE,
      replaced_flag      giri_binder.replaced_flag%TYPE,
      reverse_sw         giri_frps_ri.reverse_sw%TYPE,
      disbursement_amt   NUMBER,--giac_outfacul_prem_payts.disbursement_amt%TYPE, -- bonok :: 9.22.2015 :: SR 20296 :: changed data type to NUMBER
      disbursement_amt_local   NUMBER(22,2),
      policy_no          VARCHAR2 (1000),
      assd_name          giis_assured.assd_name%TYPE,
      prem_amt           giac_outfacul_prem_payts.prem_amt%TYPE,
      prem_vat           giac_outfacul_prem_payts.prem_vat%TYPE,
      comm_amt           giac_outfacul_prem_payts.comm_amt%TYPE,
      comm_vat           giac_outfacul_prem_payts.comm_vat%TYPE,
      wholding_vat       giac_outfacul_prem_payts.wholding_vat%TYPE,
      remarks            giac_outfacul_prem_payts.remarks%TYPE,
      ri_cd              giri_binder.ri_cd%TYPE,
      ri_name            VARCHAR2 (30000),
      transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
	  or_print_tag   	 giac_outfacul_prem_payts.or_print_tag%TYPE,  --added by steven 07.13.2012
      prem_tag           gipi_polbasic.prem_warr_tag%TYPE,
	  prem_seq_no		 gipi_invoice.prem_seq_no%TYPE,
      MESSAGE            VARCHAR2 (1000),
      cm_tag             giac_outfacul_prem_payts.cm_tag%TYPE -- added by: Nica 06.10.2013 for OR RI Comm Enh.   
   );

   TYPE binder_list_tab IS TABLE OF binder_list_type;

   FUNCTION get_binder_dtls (
      p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
      p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_line_cd            giri_binder.line_cd%TYPE,
      p_binder_yy          giri_binder.binder_yy%TYPE,
      p_gacc_tran_id       giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      p_user               giac_outfacul_prem_payts.user_id%TYPE,
      p_module_name        VARCHAR2,
      p_binder_seq_no      giri_binder.binder_seq_no%TYPE
   )
      RETURN binder_list_tab PIPELINED;

   FUNCTION get_list_disb_amt (
      p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
      p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_line_cd            giri_binder.line_cd%TYPE,
      p_binder_yy          giri_binder.binder_yy%TYPE,
      p_binder_id          giri_binder.fnl_binder_id%TYPE,
      p_binder_seq_no      giri_binder.binder_seq_no%TYPE,
      p_convert_rate       giac_outfacul_prem_payts.convert_rate%TYPE,
      p_policy_id          gipi_polbasic.policy_id%TYPE,
      p_allow_def          VARCHAR2,
      p_gacc_tran_id       GIAC_OUTFACUL_PREM_PAYTS.GACC_TRAN_ID%TYPE   -- SR-19631 : shan 08.17.2015
   )
      RETURN NUMBER;

   FUNCTION get_giac_outfacul_prem_payts (
      p_gacc_tran_id   giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      p_user           VARCHAR2,
      p_module_name    VARCHAR2
   )
      RETURN binder_list_tab PIPELINED;

   PROCEDURE save_giac_outfacul_prem_payts (
      p_gacc_tran_id       giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      p_binder_id          giac_outfacul_prem_payts.d010_fnl_binder_id%TYPE,
      p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
      p_disbursement_amt   giac_outfacul_prem_payts.disbursement_amt%TYPE,
      p_prem_amt           giac_outfacul_prem_payts.prem_amt%TYPE,
      p_prem_vat           giac_outfacul_prem_payts.prem_vat%TYPE,
      p_comm_amt           giac_outfacul_prem_payts.comm_amt%TYPE,
      p_comm_vat           giac_outfacul_prem_payts.comm_vat%TYPE,
      p_wholding_vat       giac_outfacul_prem_payts.wholding_vat%TYPE,
      p_remarks            giac_outfacul_prem_payts.remarks%TYPE,
      p_currency_cd        giac_outfacul_prem_payts.currency_cd%TYPE,
      p_convert_rate       giac_outfacul_prem_payts.convert_rate%TYPE,
      p_foreign_curr_amt   giac_outfacul_prem_payts.foreign_curr_amt%TYPE,
      p_or_print_tag       giac_outfacul_prem_payts.or_print_tag%TYPE,
      p_cm_tag             giac_outfacul_prem_payts.cm_tag%TYPE, -- added by: Nica 06.10.2013
      p_user_id            giac_outfacul_prem_payts.user_id%TYPE,
      p_record_no          giac_outfacul_prem_payts.record_no%TYPE  -- SR_19631 : shan 08.17.2015
   );

   PROCEDURE delete_giac_outfacul_prem (
      p_gacc_tran_id   giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      p_binder_id      giac_outfacul_prem_payts.d010_fnl_binder_id%TYPE,
      p_ri_cd          giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_record_no      giac_outfacul_prem_payts.record_no%type  -- SR-19631 : shan 08.18.2015
   );

   PROCEDURE get_override_disbursement_amt (
      p_transaction_type         giac_outfacul_prem_payts.transaction_type%TYPE,
      p_binder_yy                giri_binder.binder_yy%TYPE,
      p_line_cd                  giri_binder.line_cd%TYPE,
      p_binder_seq_no            giri_binder.binder_seq_no%TYPE,
      p_binder_id                giri_binder.fnl_binder_id%TYPE,
      p_disbursement_amt   OUT   giac_outfacul_prem_payts.disbursement_amt%TYPE,
      p_message            OUT   VARCHAR2
   );

   PROCEDURE get_disb_amt_for_but_revert (
      p_binder_id                giri_binder.fnl_binder_id%TYPE,
      p_transaction_type         giac_outfacul_prem_payts.transaction_type%TYPE,
	  p_gacc_tran_id			 giac_outfacul_prem_payts.gacc_tran_id%type,
	  p_line_cd     			 giri_binder.line_cd%TYPE,
      p_ri_cd       			 giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_disbursement_amt   OUT   giac_outfacul_prem_payts.disbursement_amt%TYPE,
      p_message            OUT   VARCHAR2
   );

   FUNCTION get_iss_prem_seq_no (
      p_binder_id   giri_binder.fnl_binder_id%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_ri_cd       giac_outfacul_prem_payts.a180_ri_cd%TYPE
   )
      RETURN NUMBER;
	  
   PROCEDURE get_facul_iss_cd_prem_seq_no (
      p_binder_id   giri_binder.fnl_binder_id%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_ri_cd       giac_outfacul_prem_payts.a180_ri_cd%TYPE,
	  p_iss_cd		OUT gipi_invoice.iss_cd%type,
	  p_prem_seq_no OUT gipi_invoice.prem_seq_no%type
   );
     
    PROCEDURE validate_binder_no2 (
        p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
        p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
        p_line_cd            giri_binder.line_cd%TYPE,
        p_binder_yy          giri_binder.binder_yy%TYPE,
        p_binder_seq_no      giri_binder.binder_seq_no%TYPE,
        p_override_def       VARCHAR2,
        p_user_id            VARCHAR2,
        v_default_disb_amt  OUT giac_outfacul_prem_payts.disbursement_amt%TYPE,
        v_message           OUT VARCHAR2
    );
   
   
    PROCEDURE get_disbursement_amt(
        p_transaction_type      giac_outfacul_prem_payts.transaction_type%TYPE,      
        p_ri_cd                 giac_outfacul_prem_payts.a180_ri_cd%TYPE,
        p_line_cd               giri_binder.line_cd%TYPE,
        p_binder_yy             giri_binder.binder_yy%TYPE,
        p_binder_seq_no         giri_binder.binder_seq_no%TYPE,
        p_convert_rate          giri_distfrps.CURRENCY_RT%type,
        p_policy_id             gipi_polbasic.POLICY_ID%type,
        p_binder_id             giri_binder.FNL_BINDER_ID%type,
        p_user_id               VARCHAR2,
        v_default_disb_amt  OUT giac_outfacul_prem_payts.disbursement_amt%TYPE,
        v_message           OUT VARCHAR2
    );
    
    -- SR-19792, 19840 : shan 08.06.2015
    FUNCTION get_outfacul_prem_payts_dtls(
        p_gacc_tran_id  giac_outfacul_prem_payts.gacc_tran_id%TYPE
    ) RETURN binder_list_tab PIPELINED;
    -- end SR-19792, 19840
    
    -- SR-19631 : shan 08.13.2015   
    FUNCTION get_binder_dtls_for_override (
      p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
      p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_line_cd            giri_binder.line_cd%TYPE,
      p_binder_yy          giri_binder.binder_yy%TYPE,
      p_gacc_tran_id       giac_outfacul_prem_payts.gacc_tran_id%TYPE,
      p_user               giac_outfacul_prem_payts.user_id%TYPE,
      p_module_name        VARCHAR2,
      p_binder_seq_no      giri_binder.binder_seq_no%TYPE   
    )  RETURN binder_list_tab PIPELINED;
    
    
    FUNCTION check_open_tran(
      p_transaction_type   giac_outfacul_prem_payts.transaction_type%TYPE,
      p_ri_cd              giac_outfacul_prem_payts.a180_ri_cd%TYPE,
      p_binder_id          giri_binder.fnl_binder_id%TYPE,
      p_gacc_tran_id       giac_outfacul_prem_payts.gacc_tran_id%TYPE    
    ) RETURN VARCHAR2; 
    
   
    PROCEDURE update_rev_columns(
        p_gacc_tran_id      GIAC_OUTFACUL_PREM_PAYTS.GACC_TRAN_ID%TYPE,
        p_ri_cd             GIAC_OUTFACUL_PREM_PAYTS.A180_RI_CD%TYPE,
        p_binder_id         GIAC_OUTFACUL_PREM_PAYTS.D010_FNL_BINDER_ID%TYPE,
        p_user_id           GIAC_OUTFACUL_PREM_PAYTS.USER_ID%TYPE,
        p_rev_gacc_tran_id  GIAC_OUTFACUL_PREM_PAYTS.GACC_TRAN_ID%TYPE,
        p_rev_record_no     GIAC_OUTFACUL_PREM_PAYTS.REV_RECORD_NO%TYPE,
        p_add_del_sw        NUMBER
    );    
    
    PROCEDURE renumber_outfacul_prem_payts(
        p_gacc_tran_id      GIAC_OUTFACUL_PREM_PAYTS.GACC_TRAN_ID%TYPE,
        p_user_id           GIAC_OUTFACUL_PREM_PAYTS.USER_ID%TYPE
    );
    -- end SR-19631
END;
/



CREATE OR REPLACE PACKAGE CPI.giac_direct_prem_collns_pkg
AS
   TYPE giac_direct_prem_collns_type IS RECORD (
      b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      transaction_type   giac_direct_prem_collns.transaction_type%TYPE, 
      inst_no            giac_direct_prem_collns.inst_no%TYPE, 
      ref_inv_no         gipi_invoice.ref_inv_no%TYPE, 
      policy_id          gipi_polbasic.policy_id%TYPE,
      line_cd            gipi_polbasic.line_cd%TYPE, 
      subline_cd         gipi_polbasic.subline_cd%TYPE, 
      pol_iss_cd         gipi_polbasic.iss_cd%TYPE,
      issue_yy           gipi_polbasic.issue_yy%TYPE,    
      pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      pol_renew_no       gipi_polbasic.renew_no%TYPE,
      endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy            gipi_polbasic.endt_yy%TYPE,
      endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      endt_type          gipi_polbasic.endt_type%TYPE,
      ref_pol_no         gipi_polbasic.ref_pol_no%TYPE,
      assd_no            gipi_polbasic.assd_no%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      intm_no            giis_intermediary.intm_no%TYPE,
      intm_name          giis_intermediary.intm_name%TYPE,
      collection_amt     giac_invoice_list_v1.collection_amt%TYPE,
      premium_amt        giac_direct_prem_collns.premium_amt%TYPE,
      tax_amt            giac_direct_prem_collns.tax_amt%TYPE,
      collection_amt1    giac_invoice_list_v1.collection_amt%TYPE,
      premium_amt1       giac_direct_prem_collns.premium_amt%TYPE,
      tax_amt1           giac_direct_prem_collns.tax_amt%TYPE,
      tran_id            giac_acctrans.tran_id%TYPE,
      payt_ref_no        VARCHAR2 (1000),
      currency_rt        gipi_invoice.currency_rt%TYPE,
      policy_no          VARCHAR2(100),
      currency_cd        gipi_invoice.currency_cd%TYPE, --added by alfie 04/27/2011
      or_print_tag       giac_direct_prem_collns.or_print_tag%TYPE,
      prem_vatable       giac_direct_prem_collns.prem_vatable%TYPE,
      prem_vat_exempt    giac_direct_prem_collns.prem_vat_exempt%TYPE,
      prem_zero_rated    giac_direct_prem_collns.prem_zero_rated%TYPE,
      rev_gacc_tran_id   giac_direct_prem_collns.rev_gacc_tran_id%TYPE,
      count_             NUMBER,                          --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
      rownum_            NUMBER                           --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
   );

   TYPE giac_direct_prem_collns_tab IS TABLE OF giac_direct_prem_collns_type;

   FUNCTION get_direct_prem_inv_listing (
      p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE
   )
      RETURN giac_direct_prem_collns_tab PIPELINED;

   PROCEDURE save_acct_dtls (
      p_gacc_tran_id              giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_transaction_type          giac_direct_prem_collns.transaction_type%TYPE,
      p_b140_iss_cd               giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no          giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no                   giac_direct_prem_collns.inst_no%TYPE,
      p_fund_cd                   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_param_premium_amt         giac_direct_prem_collns.premium_amt%TYPE,
      p_collection_amt            giac_direct_prem_collns.collection_amt%TYPE,
      p_premium_amt         OUT   giac_direct_prem_collns.premium_amt%TYPE,
      p_tax_amt             OUT   giac_direct_prem_collns.tax_amt%TYPE,
      p_sum_tax_amt               giac_direct_prem_collns.tax_amt%TYPE,
      p_msg_alert           OUT   VARCHAR2
   );

   PROCEDURE save_direct_prem_collns_dtls (
      p_gacc_tran_id       giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
      p_b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no            giac_direct_prem_collns.inst_no%TYPE,
      p_collection_amt     giac_direct_prem_collns.collection_amt%TYPE,
      p_premium_amt        giac_direct_prem_collns.premium_amt%TYPE,
      p_tax_amt            giac_direct_prem_collns.tax_amt%TYPE,
      p_or_print_tag       giac_direct_prem_collns.or_print_tag%TYPE,
      p_particulars        giac_direct_prem_collns.particulars%TYPE,
      p_currency_cd        giac_direct_prem_collns.currency_cd%TYPE,
      p_convert_rate       giac_direct_prem_collns.convert_rate%TYPE,
      p_foreign_curr_amt   giac_direct_prem_collns.foreign_curr_amt%TYPE,
      p_prem_vatable       giac_direct_prem_collns.prem_vatable%TYPE,
      p_prem_vat_exempt    giac_direct_prem_collns.prem_vat_exempt%TYPE,
      p_prem_zero_rated    giac_direct_prem_collns.prem_zero_rated%TYPE,
      p_rev_gacc_tran_id   giac_direct_prem_collns.rev_gacc_tran_id%TYPE
   );

   TYPE giac_direct_prem_collns_type2 IS RECORD (
      gacc_tran_id       giac_direct_prem_collns.gacc_tran_id%TYPE,
      transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
      b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      inst_no            giac_direct_prem_collns.inst_no%TYPE,
      collection_amt     giac_direct_prem_collns.collection_amt%TYPE,
      premium_amt        giac_direct_prem_collns.premium_amt%TYPE,
      tax_amt            giac_direct_prem_collns.tax_amt%TYPE,
      or_print_tag       giac_direct_prem_collns.or_print_tag%TYPE,
      particulars        giac_direct_prem_collns.particulars%TYPE,
      currency_cd        giac_direct_prem_collns.currency_cd%TYPE,
      convert_rate       giac_direct_prem_collns.convert_rate%TYPE,
      foreign_curr_amt   giac_direct_prem_collns.foreign_curr_amt%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      assd_no            giis_assured.assd_no%TYPE,
      policy_id          gipi_polbasic.policy_id%TYPE,
      line_cd            gipi_polbasic.line_cd%TYPE,
      subline_cd         gipi_polbasic.subline_cd%TYPE,
      pol_iss_cd         gipi_polbasic.iss_cd%TYPE,
      issue_yy           gipi_polbasic.issue_yy%TYPE,
      pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      pol_renew_no       gipi_polbasic.renew_no%TYPE,
      endt_iss_cd        gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy            gipi_polbasic.endt_yy%TYPE,
      endt_seq_no        gipi_polbasic.endt_seq_no%TYPE,
      endt_type          gipi_polbasic.endt_type%TYPE,
      policy_no          VARCHAR2(1000), --added by alfie
      balance_amt_due    giac_aging_soa_details.balance_amt_due%TYPE,
      prem_balance_due   giac_aging_soa_details.prem_balance_due%TYPE,
      inc_tag            VARCHAR2(5),
      comm_payt_sw       NUMBER,
      max_colln_amt      giac_aging_soa_details.balance_amt_due%TYPE,
      prem_vatable       giac_direct_prem_collns.prem_vatable%TYPE,
      prem_vat_exempt    giac_direct_prem_collns.prem_vat_exempt%TYPE,
      prem_zero_rated    giac_direct_prem_collns.prem_zero_rated%TYPE,
      rev_gacc_tran_id   giac_direct_prem_collns.rev_gacc_tran_id%TYPE
   );

   TYPE giac_direct_prem_collns_tab2 IS TABLE OF giac_direct_prem_collns_type2;

   FUNCTION get_direct_prem_collns_dtls (
      p_gacc_tran_id   giac_direct_prem_collns.gacc_tran_id%TYPE
   )
      RETURN giac_direct_prem_collns_tab2 PIPELINED;

   PROCEDURE delete_direct_prem_collns_dtls (
      p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
      p_b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no            giac_direct_prem_collns.inst_no%TYPE,
      p_gacc_tran_id       giac_direct_prem_collns.gacc_tran_id%TYPE
   );

   PROCEDURE generate_tax_defaults (
      p_gacc_tran_id              giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_transaction_type          giac_direct_prem_collns.transaction_type%TYPE,
      p_b140_iss_cd               giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no          giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no                   giac_direct_prem_collns.inst_no%TYPE,
      p_fund_cd                   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_param_premium_amt         giac_direct_prem_collns.premium_amt%TYPE,
      p_collection_amt            giac_direct_prem_collns.collection_amt%TYPE,
      p_premium_amt         OUT   giac_direct_prem_collns.premium_amt%TYPE,
      p_tax_amt             OUT   giac_direct_prem_collns.tax_amt%TYPE,
      p_sum_tax_amt               giac_direct_prem_collns.tax_amt%TYPE,
      p_rev_gacc_tran_id          giac_direct_prem_collns.gacc_tran_id%TYPE
   --p_msg_alert           OUT   VARCHAR2
   );

   TYPE giac_related_prem_collns_type IS RECORD (

    premium_amt             GIAC_DIRECT_PREM_COLLNS.premium_amt%TYPE,
    tax_amt                 GIAC_DIRECT_PREM_COLLNS.tax_amt%TYPE,
    collection_amt          GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
    gacc_tran_id            GIAC_DIRECT_PREM_COLLNS.gacc_tran_id%TYPE,
    user_id                 GIAC_DIRECT_PREM_COLLNS.user_id%TYPE,
    particulars             GIAC_DIRECT_PREM_COLLNS.particulars%TYPE,
    last_update             GIAC_DIRECT_PREM_COLLNS.last_update%TYPE,
    transaction_type        GIAC_DIRECT_PREM_COLLNS.transaction_type%TYPE,
    inst_no                 GIAC_DIRECT_PREM_COLLNS.inst_no%TYPE,
    b140_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
    b140_prem_seq_no        GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
    ref_no                  VARCHAR2(50),
    tran_date               DATE,
    tran_date2              VARCHAR2(10), --added by reymon 11112013
    last_update2            VARCHAR2(25) --added by reymon 11112013

  );

  TYPE giac_related_prem_collns_tab IS TABLE OF giac_related_prem_collns_type;

  FUNCTION get_related_prem_collns(p_iss_cd        GIPI_INVOICE.iss_cd%TYPE,
                                   p_prem_seq_no   GIPI_INVOICE.prem_seq_no%TYPE)

    RETURN giac_related_prem_collns_tab PIPELINED;

  FUNCTION get_direct_prem_inv_listing2 (
    p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
    p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
    p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE
  ) RETURN giac_direct_prem_collns_tab PIPELINED;
  
  FUNCTION get_inv_from_policy (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_year   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_ref_pol_no   gipi_polbasic.ref_pol_no%TYPE,
      p_due_tag      VARCHAR2
  ) RETURN giac_direct_prem_collns_tab PIPELINED;
  
  PROCEDURE set_premtax_tran_type (
    p_iss_cd             IN giac_direct_prem_collns.b140_iss_cd%TYPE,
    p_prem_seq_no        IN giac_direct_prem_collns.b140_prem_seq_no%TYPE,
    p_transaction_type   IN giac_direct_prem_collns.transaction_type%TYPE,
    p_inst_no            IN giac_direct_prem_collns.inst_no%TYPE,
    p_premium_amt		 IN giac_direct_prem_collns.premium_amt%TYPE,
    p_prem_vatable       OUT NUMBER,
    p_prem_vat_exempt 	 OUT NUMBER,
    p_prem_zero_rated    OUT NUMBER,
    p_max_prem_vatable   OUT NUMBER
  );
  
    FUNCTION get_gdcp_invoice_listing (
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
		p_inst_no            giac_direct_prem_collns.inst_no%TYPE
    ) RETURN giac_direct_prem_collns_tab PIPELINED;
    
    PROCEDURE validate_giacs007_prem_seq_no (
        p_gacc_tran_id            IN  giac_acctrans.tran_id%TYPE,
		p_prem_seq_no             IN  giac_aging_soa_details.prem_seq_no%TYPE,
		p_iss_cd                  IN  giac_aging_soa_details.iss_cd%TYPE,
		p_transaction_type		  IN  giac_direct_prem_collns.transaction_type%TYPE,
        p_mesg                    OUT VARCHAR2,
        p_alert_msg               OUT VARCHAR2
    );
    
    FUNCTION check_existing_installment (
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
        p_inst_no            giac_direct_prem_collns.inst_no%TYPE
    ) RETURN VARCHAR2;
    
--	FUNCTION check_special_bill (
--		p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
--		p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE             
--	) RETURN VARCHAR2;

    TYPE giac_prem_collns_type IS RECORD (
      gacc_tran_id      giac_direct_prem_collns.gacc_tran_id%TYPE,
      dsp_peril_cd      gipi_invperil.peril_cd%TYPE,
      dsp_peril_name    giis_peril.peril_name%TYPE,
      dsp_prem_amt      gipi_invperil.prem_amt%TYPE,
      b140_prem_seq_no  giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      b140_iss_cd       giac_direct_prem_collns.b140_iss_cd%TYPE
   );

   TYPE giac_prem_collns_tab IS TABLE OF giac_prem_collns_type;
   
   FUNCTION get_prem_collns_listing (
       p_iss_cd         giac_direct_prem_collns.b140_iss_cd%TYPE,
       p_prem_seq_no    giac_direct_prem_collns.b140_prem_seq_no%TYPE
   )
   RETURN giac_prem_collns_tab PIPELINED;
   
   PROCEDURE get_direct_prem_collns_sum (
   		p_gacc_tran_id            IN  giac_acctrans.tran_id%TYPE,
		p_total_collection		  OUT NUMBER,
		p_total_premium		      OUT NUMBER,
		p_total_tax				  OUT NUMBER  
   );
   
   FUNCTION get_gdcp_invoice_listing2 (
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE, 
        p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
        p_inst_no            giac_direct_prem_collns.inst_no%TYPE,  
        p_filter_ref_inv_no  VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_payt_ref_no VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_coll_amt    NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_prem_amt    NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_tax_amt     NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_assd_name   VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_intm_name   VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_ref_pol_no  VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_endt_yy     NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692 
        p_filter_endt_seq_no NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_endt_iss_cd VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_issue_yy    NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_line_cd     VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_pol_seq_no  NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_subline_cd  VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_order_by           VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_asc_desc_flag      VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_first_row          NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_last_row           NUMBER         --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692 
    ) RETURN giac_direct_prem_collns_tab PIPELINED;
    
   PROCEDURE validate_policy(
      p_line_cd         IN    gipi_polbasic.line_cd%TYPE,
      p_subline_cd      IN    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          IN    gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        IN    gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      IN    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        IN    gipi_polbasic.renew_no%TYPE,
      p_ref_pol_no      IN    gipi_polbasic.ref_pol_no%TYPE,
      p_check_due       IN    VARCHAR2,
      p_endt_message    OUT   VARCHAR2,
      p_special_message OUT   VARCHAR2,
      p_open_message    OUT   VARCHAR2,
      p_endt_proceed    OUT   VARCHAR2,
      p_special_proceed OUT   VARCHAR2,
      p_open_proceed    OUT   VARCHAR2
   );
   
   FUNCTION check_previous_installment (
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_inst_no            giac_direct_prem_collns.inst_no%TYPE  
    ) RETURN VARCHAR2;
    
    PROCEDURE check_total_payments( 
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_inst_no            giac_direct_prem_collns.inst_no%TYPE
    );
    FUNCTION get_intm(p_check NUMBER, p_iss_cd VARCHAR, p_prem_seq_no NUMBER)
     RETURN VARCHAR2; 
END;
/



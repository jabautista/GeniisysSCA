CREATE OR REPLACE PACKAGE CPI.giac_pdc_prem_colln_pkg
AS
   TYPE giac_pdc_prem_colln_dtls_type IS RECORD (
      pdc_id             giac_pdc_prem_colln.pdc_id%TYPE,
      iss_cd             giac_pdc_prem_colln.iss_cd%TYPE,
      prem_seq_no        giac_pdc_prem_colln.prem_seq_no%TYPE,
      transaction_type   giac_pdc_prem_colln.transaction_type%TYPE,
      inst_no            giac_pdc_prem_colln.inst_no%TYPE,
      collection_amt     giac_pdc_prem_colln.collection_amt%TYPE,
      currency_cd        giac_pdc_prem_colln.currency_cd%TYPE,
      currency_rt        giac_pdc_prem_colln.currency_rt%TYPE,
      fcurrency_amt      giac_pdc_prem_colln.fcurrency_amt%TYPE,
      premium_amt        giac_pdc_prem_colln.premium_amt%TYPE,
      tax_amt            giac_pdc_prem_colln.tax_amt%TYPE,
      insert_tag         giac_pdc_prem_colln.insert_tag%TYPE
   );

   TYPE giac_pdc_prem_colln_dtls_tab IS TABLE OF giac_pdc_prem_colln_dtls_type;

   FUNCTION get_dated_checks_dtls (p_gacc_tran_id giac_direct_prem_collns.gacc_tran_id%type)
      RETURN giac_pdc_prem_colln_dtls_tab PIPELINED;
	  
   TYPE giac_pdc_premcolln_dtls_type IS RECORD (
      pdc_id			 giac_pdc_prem_colln.pdc_id%TYPE,
      iss_cd             giac_pdc_prem_colln.iss_cd%TYPE,
      prem_seq_no        giac_pdc_prem_colln.prem_seq_no%TYPE,
      transaction_type   giac_pdc_prem_colln.transaction_type%TYPE,
      inst_no            giac_pdc_prem_colln.inst_no%TYPE,
      collection_amt     giac_pdc_prem_colln.collection_amt%TYPE,
      currency_cd        giac_pdc_prem_colln.currency_cd%TYPE,
      currency_rt        giac_pdc_prem_colln.currency_rt%TYPE,
      fcurrency_amt      giac_pdc_prem_colln.fcurrency_amt%TYPE,
      premium_amt        giac_pdc_prem_colln.premium_amt%TYPE,
      tax_amt            giac_pdc_prem_colln.tax_amt%TYPE,
      insert_tag         giac_pdc_prem_colln.insert_tag%TYPE,
	  last_update		 giac_pdc_prem_colln.last_update%TYPE,
      tran_type_desc     VARCHAR2(200),
      policy_no          VARCHAR2(50),
      assd_name          GIIS_ASSURED.assd_name%TYPE
   );
   
   TYPE giac_pdc_premcolln_dtls_tab IS TABLE OF giac_pdc_premcolln_dtls_type;
   
   FUNCTION get_post_dated_checks_dtls(p_pdc_id giac_apdc_payt_dtl.pdc_id%TYPE)
      RETURN giac_pdc_premcolln_dtls_tab PIPELINED;

   FUNCTION get_pdc_prem_colln_listing(p_pdc_id giac_apdc_payt_dtl.pdc_id%TYPE)
      RETURN giac_pdc_premcolln_dtls_tab PIPELINED;
	  
   PROCEDURE validate_prem_seq_no(
        p_pdc_id		IN  GIAC_PDC_PREM_COLLN.pdc_id%TYPE,
		p_tran_type		IN	GIAC_PDC_PREM_COLLN.transaction_type%TYPE,
  		p_iss_cd 		IN	GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		p_prem_seq_no	IN	GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		v_inst_no		OUT GIPI_INSTALLMENT.inst_no%TYPE,
		v_inst_no_count	OUT NUMBER,
		v_tax_amt		OUT GIAC_PDC_PREM_COLLN.tax_amt%TYPE,
		v_premium_amt	OUT GIAC_PDC_PREM_COLLN.premium_amt%TYPE,
		v_colln_amt		OUT GIAC_PDC_PREM_COLLN.collection_amt%TYPE,
		v_assured_name	OUT GIIS_ASSURED.assd_name%TYPE,
		v_policy_no		OUT VARCHAR2,
		v_message		OUT VARCHAR2
	);
	
	PROCEDURE get_pdc_prem_colln_dtls(
	    p_iss_cd	  	IN	  	  GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		p_prem_seq_no	IN	  	  GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		p_inst_no		IN OUT	  GIAC_PDC_PREM_COLLN.inst_no%TYPE,
		v_prem_amt		OUT	      GIAC_PDC_PREM_COLLN.premium_amt%TYPE,  
		v_tax_amt		OUT	      GIAC_PDC_PREM_COLLN.tax_amt%TYPE,
		v_colln_amt		OUT	      GIAC_PDC_PREM_COLLN.collection_amt%TYPE,
		v_assd_name		OUT	      GIIS_ASSURED.assd_name%TYPE,
		v_policy_no		OUT	      VARCHAR2,
		v_bal_due		OUT		  NUMBER); 
		
	PROCEDURE insert_pdc_prem_colln(
		p_pdc_id				 GIAC_PDC_PREM_COLLN.pdc_id%TYPE,
		p_transaction_type		 GIAC_PDC_PREM_COLLN.transaction_type%TYPE,
		p_iss_cd				 GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		p_prem_seq_no			 GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		p_inst_no				 GIAC_PDC_PREM_COLLN.inst_no%TYPE,
		p_collection_amt		 GIAC_PDC_PREM_COLLN.collection_amt%TYPE,
		p_currency_cd			 GIAC_PDC_PREM_COLLN.currency_cd%TYPE,
		p_currency_rt			 GIAC_PDC_PREM_COLLN.currency_rt%TYPE,
		p_fcurrency_amt			 GIAC_PDC_PREM_COLLN.fcurrency_amt%TYPE,
		p_premium_amt			 GIAC_PDC_PREM_COLLN.premium_amt%TYPE,
		p_tax_amt				 GIAC_PDC_PREM_COLLN.tax_amt%TYPE,
		p_insert_tag			 GIAC_PDC_PREM_COLLN.insert_tag%TYPE
	);
	
	PROCEDURE update_pdc_prem_colln(
		p_pdc_id				 GIAC_PDC_PREM_COLLN.pdc_id%TYPE,
		p_transaction_type		 GIAC_PDC_PREM_COLLN.transaction_type%TYPE,
		p_iss_cd				 GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		p_prem_seq_no			 GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		p_inst_no				 GIAC_PDC_PREM_COLLN.inst_no%TYPE,
		p_collection_amt		 GIAC_PDC_PREM_COLLN.collection_amt%TYPE,
		p_currency_cd			 GIAC_PDC_PREM_COLLN.currency_cd%TYPE,
		p_currency_rt			 GIAC_PDC_PREM_COLLN.currency_rt%TYPE,
		p_fcurrency_amt			 GIAC_PDC_PREM_COLLN.fcurrency_amt%TYPE,
		p_premium_amt			 GIAC_PDC_PREM_COLLN.premium_amt%TYPE,
		p_tax_amt				 GIAC_PDC_PREM_COLLN.tax_amt%TYPE,
		p_insert_tag			 GIAC_PDC_PREM_COLLN.insert_tag%TYPE,
		p_new_prem_seq_no		 GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		p_new_transaction_type	 GIAC_PDC_PREM_COLLN.transaction_type%TYPE
	);
	
	PROCEDURE delete_giac_pdc_prem_colln(
		 p_pdc_id			GIAC_PDC_PREM_COLLN.pdc_id%TYPE,
		 p_transaction_type GIAC_PDC_PREM_COLLN.transaction_type%TYPE,
		 p_iss_cd			GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		 p_prem_seq_no		GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE
	);                                
    
	PROCEDURE del_giac_pdc_prem_colln(
		 p_pdc_id			GIAC_PDC_PREM_COLLN.pdc_id%TYPE,
		 p_iss_cd			GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		 p_prem_seq_no		GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE
	);    
    
    PROCEDURE set_giac_pdc_prem_colln(p_colln GIAC_PDC_PREM_COLLN%ROWTYPE);
    
    PROCEDURE get_prem_colln_update_values(p_apdc_id      IN GIAC_APDC_PAYT.apdc_id%TYPE,
                                         p_pdc_id       IN GIAC_APDC_PAYT_DTL.pdc_id%TYPE,
                                         p_iss_cd       IN GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
                                         p_prem_seq_no  IN GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
                                         p_update_flag  IN VARCHAR2, --benjo 10.25.2016 SR-5802
                                         p_payor        OUT VARCHAR2,
                                         p_address1     OUT GIPI_POLBASIC.address1%TYPE,
                                         p_address2     OUT GIPI_POLBASIC.address2%TYPE,
                                         p_address3     OUT GIPI_POLBASIC.address3%TYPE,
                                         p_intm_no      OUT GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE,
                                         p_intm_name    OUT GIIS_INTERMEDIARY.intm_name%TYPE,
                                         p_apdc_particulars OUT VARCHAR2,
                                         p_pdc_particulars  OUT VARCHAR2);
    
    FUNCTION get_particulars_from_pdc_prem(p_apdc_id IN GIAC_APDC_PAYT.apdc_id%TYPE,
                                           p_pdc_id  IN GIAC_APDC_PAYT_DTL.pdc_id%TYPE)
     RETURN VARCHAR2;                                       
    
   /* benjo 11.08.2016 SR-5802 */
   FUNCTION get_ref_pol_no (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN VARCHAR2;
   
   /* benjo 11.08.2016 SR-5802 */
   FUNCTION validate_policy (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE,
      p_check_due    IN   VARCHAR2
   )
      RETURN VARCHAR2;
   
   /* benjo 11.08.2016 SR-5802 */
   TYPE policy_invoices_type IS RECORD (
      tran_type           VARCHAR2 (1),
      tran_type_desc      VARCHAR2 (100),
      line_cd             gipi_polbasic.line_cd%TYPE,
      subline_cd          gipi_polbasic.subline_cd%TYPE,
      iss_cd              gipi_installment.iss_cd%TYPE,
      prem_seq_no         gipi_installment.prem_seq_no%TYPE,
      inst_no             gipi_installment.inst_no%TYPE,
      balance_amt_due     giac_aging_soa_details.balance_amt_due%TYPE,
      f_balance_amt_due   giac_aging_soa_details.balance_amt_due%TYPE,
      prem_balance_due    giac_aging_soa_details.prem_balance_due%TYPE,
      tax_balance_due     giac_aging_soa_details.tax_balance_due%TYPE,
      assd_name           giis_assured.assd_name%TYPE,
      policy_no           VARCHAR2 (100),
      currency_cd         giis_currency.main_currency_cd%TYPE,
      currency_desc       giis_currency.currency_desc%TYPE,
      currency_rt         giis_currency.currency_rt%TYPE
   );
   
   TYPE policy_invoices_tab IS TABLE OF policy_invoices_type;
   
   /* benjo 11.08.2016 SR-5802 */
   FUNCTION get_policy_invoices (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE,
      p_check_due    IN   VARCHAR2
   )
      RETURN policy_invoices_tab PIPELINED;
      
   /* benjo 11.08.2016 SR-5802 */
   FUNCTION get_pack_invoices_tg (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE,
      p_check_due    IN   VARCHAR2
   )
      RETURN policy_invoices_tab PIPELINED;
   
END giac_pdc_prem_colln_pkg;
/



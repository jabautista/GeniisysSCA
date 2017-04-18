CREATE OR REPLACE PACKAGE CPI.giac_inwfacul_prem_collns_pkg
AS
   TYPE giac_inwfacul_prem_collns_type IS RECORD (
      gacc_tran_id            giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      transaction_type        giac_inwfacul_prem_collns.transaction_type%TYPE,
      a180_ri_cd              giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      b140_iss_cd             giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      b140_prem_seq_no        giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      inst_no                 giac_inwfacul_prem_collns.inst_no%TYPE,
      premium_amt             giac_inwfacul_prem_collns.premium_amt%TYPE,
      comm_amt                giac_inwfacul_prem_collns.comm_amt%TYPE,
      wholding_tax            giac_inwfacul_prem_collns.wholding_tax%TYPE,
      particulars             giac_inwfacul_prem_collns.particulars%TYPE,
      currency_cd             giac_inwfacul_prem_collns.currency_cd%TYPE,
      convert_rate            giac_inwfacul_prem_collns.convert_rate%TYPE,
      foreign_curr_amt        giac_inwfacul_prem_collns.foreign_curr_amt%TYPE,
      collection_amt          giac_inwfacul_prem_collns.collection_amt%TYPE,
      or_print_tag            giac_inwfacul_prem_collns.or_print_tag%TYPE,
      user_id                 giac_inwfacul_prem_collns.user_id%TYPE,
      last_update             giac_inwfacul_prem_collns.last_update%TYPE,
      cpi_rec_no              giac_inwfacul_prem_collns.cpi_rec_no%TYPE,
      cpi_branch_cd           giac_inwfacul_prem_collns.cpi_branch_cd%TYPE,
      tax_amount              giac_inwfacul_prem_collns.tax_amount%TYPE,
      comm_vat                giac_inwfacul_prem_collns.comm_vat%TYPE,
      transaction_type_desc   cg_ref_codes.rv_meaning%TYPE,
      ri_name                 giis_reinsurer.ri_name%TYPE,
      assd_no                 giis_assured.assd_no%TYPE,
      assd_name               giis_assured.assd_name%TYPE,
      ri_policy_no            giri_inpolbas.ri_policy_no%TYPE,
      drv_policy_no           VARCHAR2 (32000)                          := '',
      currency_desc           giis_currency.currency_desc%TYPE
   );

   TYPE giac_inwfacul_prem_collns_tab IS TABLE OF giac_inwfacul_prem_collns_type;
   
   FUNCTION get_giac_inwfacul_prem_collns (
      p_gacc_tran_id   giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      p_user_id       giis_users.user_id%TYPE --added by steven 09.01.2014
   )
      RETURN giac_inwfacul_prem_collns_tab PIPELINED;
   /*Added by pjsantos 11/22/2016, for optimization GENQA 5846*/
   TYPE giac_inwfacul_premcollns_type2 IS RECORD ( 
      count_                  NUMBER,
      rownum_                 NUMBER,
      gacc_tran_id            giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      transaction_type        giac_inwfacul_prem_collns.transaction_type%TYPE,
      a180_ri_cd              giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      b140_iss_cd             giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      b140_prem_seq_no        giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      inst_no                 giac_inwfacul_prem_collns.inst_no%TYPE,
      premium_amt             giac_inwfacul_prem_collns.premium_amt%TYPE,
      comm_amt                giac_inwfacul_prem_collns.comm_amt%TYPE,
      wholding_tax            giac_inwfacul_prem_collns.wholding_tax%TYPE,
      particulars             giac_inwfacul_prem_collns.particulars%TYPE,
      currency_cd             giac_inwfacul_prem_collns.currency_cd%TYPE,
      convert_rate            giac_inwfacul_prem_collns.convert_rate%TYPE,
      foreign_curr_amt        giac_inwfacul_prem_collns.foreign_curr_amt%TYPE,
      collection_amt          giac_inwfacul_prem_collns.collection_amt%TYPE,
      or_print_tag            giac_inwfacul_prem_collns.or_print_tag%TYPE,
      user_id                 giac_inwfacul_prem_collns.user_id%TYPE,
      last_update             giac_inwfacul_prem_collns.last_update%TYPE,
      cpi_rec_no              giac_inwfacul_prem_collns.cpi_rec_no%TYPE,
      cpi_branch_cd           giac_inwfacul_prem_collns.cpi_branch_cd%TYPE,
      tax_amount              giac_inwfacul_prem_collns.tax_amount%TYPE,
      comm_vat                giac_inwfacul_prem_collns.comm_vat%TYPE,
      transaction_type_desc   cg_ref_codes.rv_meaning%TYPE, 
      ri_name                 giis_reinsurer.ri_name%TYPE, 
      assd_no                 giis_assured.assd_no%TYPE,
      assd_name               giis_assured.assd_name%TYPE,
      drv_policy_no           VARCHAR2 (32000)                          := '',
      currency_desc           giis_currency.currency_desc%TYPE,
      transaction_type_and_desc VARCHAR2(103),
      ri_policy_no            giri_inpolbas.ri_policy_no%TYPE
   );

   TYPE giac_inwfacul_premcollns_tab2 IS TABLE OF giac_inwfacul_premcollns_type2;
   FUNCTION get_giac_inwfacul_premcollns2 (
      p_gacc_tran_id                    giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      p_user_id                         giis_users.user_id%TYPE,
      p_transaction_type_and_desc       VARCHAR2, 
      p_b140_prem_seq_no                VARCHAR2, 
      p_ri_name                         VARCHAR2,
      p_inst_no                         VARCHAR2,
      p_collection_amt                  VARCHAR2, 
      p_premium_amt                     VARCHAR2, 
      p_tax_amount                      VARCHAR2, 
      p_comm_amt                        VARCHAR2,
      p_comm_vat                        VARCHAR2, 
      p_order_by                        VARCHAR2,      
      p_asc_desc_flag                   VARCHAR2,      
      p_first_row                       NUMBER,        
      p_last_row                        NUMBER
   )
      RETURN giac_inwfacul_premcollns_tab2 PIPELINED;
   --pjsantos end
   TYPE giac_inw_invoice_list_type IS RECORD (
      dsp_iss_cd         gipi_invoice.iss_cd%TYPE,
      dsp_prem_seq_no    gipi_invoice.prem_seq_no%TYPE,
      dsp_inst_no        giac_inwfacul_prem_collns.inst_no%TYPE,
      dsp_line_cd        gipi_polbasic.line_cd%TYPE,
      dsp_subline_cd     gipi_polbasic.subline_cd%TYPE,
      dsp_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      dsp_issue_yy       gipi_polbasic.issue_yy%TYPE,
      dsp_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      dsp_renew_no       gipi_polbasic.renew_no%TYPE,
      dsp_endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
      dsp_endt_yy        gipi_polbasic.endt_yy%TYPE,
      dsp_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE,
      dsp_endt_type      gipi_polbasic.endt_type%TYPE,
      dsp_incept_date    gipi_polbasic.incept_date%TYPE,
      dsp_expiry_date    gipi_polbasic.expiry_date%TYPE,
      str_incept_date    VARCHAR2 (50),
      str_expiry_date    VARCHAR2 (50),
      dsp_ri_policy_no   giri_inpolbas.ri_policy_no%TYPE,
      dsp_ri_endt_no     giri_inpolbas.ri_endt_no%TYPE,
      dsp_ri_binder_no   giri_inpolbas.ri_binder_no%TYPE,
      dsp_assd_no        gipi_polbasic.assd_no%TYPE,
      dsp_assd_name      giis_assured.assd_name%TYPE,
      ri_cd              giri_inpolbas.ri_cd%TYPE,
      drv_policy_no      VARCHAR2 (32000),
      drv_policy_no2     VARCHAR2 (32000),
      collection_amt     giac_inwfacul_prem_collns.collection_amt%TYPE,
      premium_amt        giac_inwfacul_prem_collns.premium_amt%TYPE,
      prem_tax           giac_inwfacul_prem_collns.tax_amount%TYPE,
      wholding_tax       giac_inwfacul_prem_collns.wholding_tax%TYPE,
      comm_amt           giac_inwfacul_prem_collns.comm_amt%TYPE,
      foreign_curr_amt   giac_inwfacul_prem_collns.foreign_curr_amt%TYPE,
      tax_amount         giac_inwfacul_prem_collns.tax_amount%TYPE,
      comm_vat           giac_inwfacul_prem_collns.comm_vat%TYPE,
      currency_rt        gipi_invoice.currency_rt%TYPE,
      currency_cd        gipi_invoice.currency_cd%TYPE,
      currency_desc      giis_currency.currency_desc%TYPE,
      v_msg_alert        VARCHAR2 (32000),
      dsp_colln_amt      giac_inwfacul_prem_collns.collection_amt%TYPE  --robert
   );

   TYPE giac_inw_invoice_list_tab IS TABLE OF giac_inw_invoice_list_type;

   TYPE inst_no_lov_type IS RECORD (
      iss_cd        gipi_invoice.iss_cd%TYPE,
      prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      inst_no       giac_inwfacul_prem_collns.inst_no%TYPE
   );

   TYPE inst_no_lov_tab IS TABLE OF inst_no_lov_type;

   FUNCTION get_inwfacul_invoice_list (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_user_id       giis_users.user_id%TYPE --added by steven 09.01.2014
   )
      RETURN giac_inw_invoice_list_tab PIPELINED;

   FUNCTION validate_invoice (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION validate_inst_no (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no            giac_inwfacul_prem_collns.inst_no%TYPE
   )
      RETURN giac_inw_invoice_list_tab PIPELINED;

   PROCEDURE get_gifc_drv_b140_prem_se2 (         --added by steven 01.11.2013
      p_drv_b140_prem_seq_no    IN OUT   VARCHAR2,
      p_drv_b140_prem_seq_no2   IN OUT   VARCHAR2,
      p_dsp_subline_cd          IN       VARCHAR2,
      p_dsp_pol_seq_no          IN       NUMBER,
      p_dsp_renew_no            IN       NUMBER,
      p_dsp_line_cd             IN       VARCHAR2,
      p_dsp_issue_yy            IN       NUMBER,
      p_dsp_endt_type           IN       VARCHAR2,
      p_dsp_endt_seq_no         IN       NUMBER,
      p_b140_iss_cd             IN       VARCHAR2,
      p_dsp_endt_iss_cd         IN       VARCHAR2,
      p_dsp_endt_yy             IN       VARCHAR2
   );

   PROCEDURE del_giac_inwfacul_prem_collns (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no            giac_inwfacul_prem_collns.inst_no%TYPE,
      p_gacc_tran_id       giac_inwfacul_prem_collns.gacc_tran_id%TYPE
   );

   PROCEDURE set_giac_inwfacul_prem_collns (
      p_gacc_tran_id       giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no            giac_inwfacul_prem_collns.inst_no%TYPE,
      p_premium_amt        giac_inwfacul_prem_collns.premium_amt%TYPE,
      p_comm_amt           giac_inwfacul_prem_collns.comm_amt%TYPE,
      p_wholding_tax       giac_inwfacul_prem_collns.wholding_tax%TYPE,
      p_particulars        giac_inwfacul_prem_collns.particulars%TYPE,
      p_currency_cd        giac_inwfacul_prem_collns.currency_cd%TYPE,
      p_convert_rate       giac_inwfacul_prem_collns.convert_rate%TYPE,
      p_foreign_curr_amt   giac_inwfacul_prem_collns.foreign_curr_amt%TYPE,
      p_collection_amt     giac_inwfacul_prem_collns.collection_amt%TYPE,
      p_or_print_tag       giac_inwfacul_prem_collns.or_print_tag%TYPE,
      p_cpi_rec_no         giac_inwfacul_prem_collns.cpi_rec_no%TYPE,
      p_cpi_branch_cd      giac_inwfacul_prem_collns.cpi_branch_cd%TYPE,
      p_tax_amount         giac_inwfacul_prem_collns.tax_amount%TYPE,
      p_comm_vat           giac_inwfacul_prem_collns.comm_vat%TYPE,
      p_user_id            giac_inwfacul_prem_collns.user_id%TYPE
   );

   PROCEDURE ins_upd_prem_giac_op_text (
      p_seq_no         NUMBER,
      p_premium_amt    gipi_invoice.prem_amt%TYPE,
      p_prem_text      VARCHAR2,
      p_currency_cd    giac_direct_prem_collns.currency_cd%TYPE,
      p_convert_rate   giac_direct_prem_collns.convert_rate%TYPE,
      p_gen_type       giac_modules.generation_type%TYPE,
      p_gacc_tran_id   giac_inwfacul_prem_collns.gacc_tran_id%TYPE
   );

   PROCEDURE insert_update_giac_op_text (
      p_iss_cd              IN   giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no         IN   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_premium_amt         IN   giac_inwfacul_prem_collns.premium_amt%TYPE,
      p_tax_amount          IN   giac_inwfacul_prem_collns.tax_amount%TYPE,
      p_comm_amt            IN   giac_inwfacul_prem_collns.comm_amt%TYPE,
      p_comm_vat            IN   giac_inwfacul_prem_collns.comm_vat%TYPE,
      p_currency_cd         IN   giac_inwfacul_prem_collns.currency_cd%TYPE,
      p_convert_rate        IN   giac_inwfacul_prem_collns.convert_rate%TYPE,
      p_zero_prem_op_text   IN   VARCHAR2,
      p_gacc_tran_id        IN   giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      p_gen_type            IN   giac_modules.generation_type%TYPE,
      p_evat_name           IN   giac_taxes.tax_name%TYPE,
      p_a180_ri_cd          IN   giac_inwfacul_prem_collns.a180_ri_cd%TYPE
   );

   PROCEDURE gen_op_text (
      p_a180_ri_cd          IN       giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd         IN       giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no    IN       giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no             IN       giac_inwfacul_prem_collns.inst_no%TYPE,
      p_gacc_tran_id        IN       giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      p_zero_prem_op_text   IN       VARCHAR2,
      p_gen_type            IN       giac_modules.generation_type%TYPE,
      p_evat_name           IN       giac_taxes.tax_name%TYPE,
      p_cursor_exist        OUT      VARCHAR2
   );

   PROCEDURE update_giac_dv_text_inwfacul (
      p_gacc_tran_id   giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      p_gen_type       giac_modules.generation_type%TYPE
   );

   TYPE giac_related_inwfacul_type IS RECORD (
      gacc_tran_id       giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
      b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      collection_amt     giac_inwfacul_prem_collns.collection_amt%TYPE,
      premium_amt        giac_inwfacul_prem_collns.premium_amt%TYPE,
      user_id            giac_inwfacul_prem_collns.user_id%TYPE,
      particulars        giac_inwfacul_prem_collns.particulars%TYPE,
      last_update        giac_inwfacul_prem_collns.last_update%TYPE,
      tax_amount         giac_inwfacul_prem_collns.tax_amount%TYPE,
      comm_amt           giac_inwfacul_prem_collns.comm_amt%TYPE,
      prem_tax           giac_inwfacul_prem_collns.premium_amt%TYPE,
      comm_wtax          giac_inwfacul_prem_collns.comm_amt%TYPE,
      inst_no            giac_inwfacul_prem_collns.inst_no%TYPE,
      ref_no             VARCHAR2 (50),
      tran_date          DATE
   );

   TYPE giac_related_inwfacul_tab IS TABLE OF giac_related_inwfacul_type;

   FUNCTION get_related_inwfacul (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN giac_related_inwfacul_tab PIPELINED;

   FUNCTION get_inst_no_lov (
      p_prem_seq_no   giac_aging_ri_soa_details.prem_seq_no%TYPE,
      p_ri_cd         giac_aging_ri_soa_details.a180_ri_cd%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_keyword       VARCHAR2
   )
      RETURN inst_no_lov_tab PIPELINED;
      
   
   --added john 11.3.2014
   FUNCTION check_prem_payt_for_ri_special (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE
   )
      RETURN VARCHAR2;
      
   --added john 11.4.2014
   FUNCTION check_prem_payt_for_cancelled (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_user_id            VARCHAR2
   )
      RETURN VARCHAR2;
      
    FUNCTION val_del_rec (p_gacc_tran_id giac_inwfacul_prem_collns.gacc_tran_id%TYPE) 
    RETURN VARCHAR2;
    
   --Deo [01.20.2017]: add start (SR-5909) 
   PROCEDURE update_or_dtls (
      p_tran_id       giac_acctrans.tran_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_ri_cd         giis_reinsurer.ri_cd%TYPE
   );

   FUNCTION get_or_particulars (
      p_tran_id       giac_acctrans.tran_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN VARCHAR2;
      
   PROCEDURE get_updated_or_dtls (
      p_tran_id             giac_acctrans.tran_id%TYPE,
      p_iss_cd              gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
      p_payor         OUT   giac_order_of_payts.payor%TYPE,
      p_msg           OUT   VARCHAR2
   );
   --Deo [01.20.2017]: add ends (SR-5909)
END;
/

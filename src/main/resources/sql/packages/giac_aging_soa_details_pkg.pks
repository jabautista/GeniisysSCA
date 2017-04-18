CREATE OR REPLACE PACKAGE CPI.giac_aging_soa_details_pkg
AS
  TYPE aging_soa_details_type IS RECORD (
        ISS_CD                           GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
      PREM_SEQ_NO                       GIAC_AGING_SOA_DETAILS.prem_seq_no%TYPE,
      INST_NO                           GIAC_AGING_SOA_DETAILS.inst_no%TYPE,
      A150_LINE_CD                       GIAC_AGING_SOA_DETAILS.a150_line_cd%TYPE,
      TOTAL_AMOUNT_DUE                   GIAC_AGING_SOA_DETAILS.total_amount_due%TYPE,
      TOTAL_PAYMENTS                   GIAC_AGING_SOA_DETAILS.total_payments%TYPE,
      TEMP_PAYMENTS                       GIAC_AGING_SOA_DETAILS.temp_payments%TYPE,
      BALANCE_AMT_DUE                   GIAC_AGING_SOA_DETAILS.balance_amt_due%TYPE,
      A020_ASSD_NO                       GIAC_AGING_SOA_DETAILS.a020_assd_no%TYPE
  );
  
  TYPE aging_soa_details_tab IS TABLE OF aging_soa_details_type;

   FUNCTION check_policy_payment (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN NUMBER;
      
   FUNCTION check_pack_policy_payment (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN NUMBER;

   TYPE instno_list_type IS RECORD (
      inst_no       giac_aging_ri_soa_details.inst_no%TYPE,
      prem_seq_no   giac_aging_ri_soa_details.prem_seq_no%TYPE,
      iss_cd        gipi_invoice.iss_cd%TYPE,
      a180_ri_cd    giac_aging_ri_soa_details.a180_ri_cd%TYPE
   );

   TYPE instno_list_tab IS TABLE OF instno_list_type;

/********************************** FUNCTION 1 ************************************
  MODULE:  GIACS008
  RECORD GROUP NAME: LOV_INSTNO
***********************************************************************************/
   FUNCTION get_instno_list
      RETURN instno_list_tab PIPELINED;

   TYPE instno_list_inwfacul_type IS RECORD (
      inst_no            giac_aging_ri_soa_details.inst_no%TYPE,
      prem_seq_no        giac_aging_ri_soa_details.prem_seq_no%TYPE,
      iss_cd             gipi_invoice.iss_cd%TYPE,
      a180_ri_cd         giac_aging_ri_soa_details.a180_ri_cd%TYPE,
      collection_amt     giac_inwfacul_prem_collns.collection_amt%TYPE,
      premium_amt        giac_inwfacul_prem_collns.premium_amt%TYPE,
      prem_tax           giac_inwfacul_prem_collns.tax_amount%TYPE,
      wholding_tax       giac_inwfacul_prem_collns.wholding_tax%TYPE,
      comm_amt           giac_inwfacul_prem_collns.comm_amt%TYPE,
      foreign_curr_amt   giac_inwfacul_prem_collns.foreign_curr_amt%TYPE,
      tax_amount         giac_inwfacul_prem_collns.tax_amount%TYPE,
      comm_vat           giac_inwfacul_prem_collns.comm_vat%TYPE
   );

   TYPE instno_list_inwfacul_tab IS TABLE OF instno_list_inwfacul_type;

   FUNCTION get_instno_list_inwfacul (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd        giac_aging_soa_details.iss_cd%TYPE,
      p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
      p_b140_prem_seq_no   giac_aging_soa_details.prem_seq_no%TYPE
   )
      RETURN instno_list_inwfacul_tab PIPELINED;

   TYPE instno_detail_type IS RECORD (
      iss_cd             giac_aging_soa_details.iss_cd%TYPE,
      prem_seq_no        giac_aging_soa_details.prem_seq_no%TYPE,
      inst_no            giac_aging_soa_details.inst_no%TYPE,
      balance_amt_due    giac_aging_soa_details.balance_amt_due%TYPE,
      prem_balance_due   giac_aging_soa_details.prem_balance_due%TYPE,
      tax_balance_due    giac_aging_soa_details.tax_balance_due%TYPE,
      currency_cd        gipi_invoice.currency_cd%TYPE,
      currency_rt        gipi_invoice.currency_rt%TYPE
   );

   TYPE instno_detail_tab IS TABLE OF instno_detail_type;

   FUNCTION get_instno_details (
      p_iss_cd        giac_aging_soa_details.iss_cd%TYPE,
      p_prem_seq_no   giac_aging_soa_details.prem_seq_no%TYPE
   )
      RETURN instno_detail_tab PIPELINED;
      
   FUNCTION get_instno_details2 (
      p_iss_cd        giac_aging_soa_details.iss_cd%TYPE,
      p_prem_seq_no   giac_aging_soa_details.prem_seq_no%TYPE,
      p_find_text     VARCHAR2
   )
      RETURN instno_detail_tab PIPELINED;     
   
   -- bonok :: 3.15.2016 :: UCPB SR 21681
   FUNCTION get_instno_details3 (
      p_iss_cd        giac_aging_soa_details.iss_cd%TYPE,
      p_prem_seq_no   giac_aging_soa_details.prem_seq_no%TYPE,
      p_find_text     VARCHAR2
   )
      RETURN instno_detail_tab PIPELINED;

   PROCEDURE subt_ri_soa_details (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no            giac_inwfacul_prem_collns.inst_no%TYPE,
      p_collection_amt     giac_inwfacul_prem_collns.collection_amt%TYPE,
      p_premium_amt        giac_inwfacul_prem_collns.premium_amt%TYPE,
      p_comm_amt           giac_inwfacul_prem_collns.comm_amt%TYPE,
      p_wholding_tax       giac_inwfacul_prem_collns.wholding_tax%TYPE,
      p_tax_amount         giac_inwfacul_prem_collns.tax_amount%TYPE,
      p_comm_vat           giac_inwfacul_prem_collns.comm_vat%TYPE
   );

   PROCEDURE add_ri_soa_details (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no            giac_inwfacul_prem_collns.inst_no%TYPE,
      p_collection_amt     giac_inwfacul_prem_collns.collection_amt%TYPE,
      p_premium_amt        giac_inwfacul_prem_collns.premium_amt%TYPE,
      p_comm_amt           giac_inwfacul_prem_collns.comm_amt%TYPE,
      p_wholding_tax       giac_inwfacul_prem_collns.wholding_tax%TYPE,
      p_tax_amount         giac_inwfacul_prem_collns.tax_amount%TYPE,
      p_comm_vat           giac_inwfacul_prem_collns.comm_vat%TYPE
   );

   /*
   **  Created by   :  ANTHONY SANTOS
   **  Date Created :  09.13.2010
   **  Reference By : (GIACS007 -  Direct Premium Collections)
   **  Description  : Policy canvass
   */
   TYPE policy_detail_type IS RECORD (
      line_cd            gipi_polbasic.line_cd%TYPE, --added by alfie 
      subline_cd         gipi_polbasic.subline_cd%TYPE, --added by alfie 
      iss_cd             giac_aging_soa_details.iss_cd%TYPE,
      prem_seq_no        giac_aging_soa_details.prem_seq_no%TYPE,
      inst_no            giac_aging_soa_details.inst_no%TYPE,
      balance_amt_due    giac_aging_soa_details.balance_amt_due%TYPE,
      prem_balance_due   giac_aging_soa_details.prem_balance_due%TYPE,
      tax_balance_due    giac_aging_soa_details.tax_balance_due%TYPE,
      chk_tag            varchar2(1),
      msg_alert          varchar2(32767),
      tran_type          number
   );

   TYPE policy_detail_tab IS TABLE OF policy_detail_type;
   
   FUNCTION get_policy_details (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_year   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_ref_pol_no   gipi_polbasic.ref_pol_no%TYPE,
      p_due_tag      varchar2
   )
      RETURN policy_detail_tab PIPELINED;
      
   FUNCTION get_aging_soa_details (p_keyword       VARCHAR2,
                                      p_iss_cd           GIAC_AGING_SOA_DETAILS.iss_cd%TYPE)
     RETURN aging_soa_details_tab PIPELINED;
      
   TYPE bill_no_lov_type IS RECORD (
      iss_cd             giac_aging_soa_details.iss_cd%TYPE,
      prem_seq_no        giac_aging_soa_details.prem_seq_no%TYPE,
      property           gipi_invoice.property%TYPE,
      ref_inv_no         gipi_invoice.ref_inv_no%TYPE,
      policy_id          gipi_polbasic.policy_id%TYPE,
      policy_no          varchar2(100),
      ref_pol_no         gipi_polbasic.ref_pol_no%TYPE,
      assd_no            giis_assured.assd_no%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      inst_count         number,
      dflt_inst_no       giac_aging_soa_details.inst_no%TYPE,
      total_bal_amt_due number    
   );

   TYPE bill_no_lov_tab IS TABLE OF bill_no_lov_type;
   
   FUNCTION get_bill_no_lov(p_iss_cd GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
                            p_tran_type NUMBER, --kenneth SR 20856 12.02.2015
                            p_find_text VARCHAR2)
     RETURN bill_no_lov_tab PIPELINED;  
        
   FUNCTION get_bill_info(p_iss_cd      GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
                          p_prem_seq_no GIAC_AGING_SOA_DETAILS.prem_seq_no%TYPE,
                          p_tran_type NUMBER) --kenneth SR 20856 12.02.2015
     RETURN bill_no_lov_tab PIPELINED;
            
   FUNCTION get_inst_info(p_iss_cd      GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
                          p_prem_seq_no GIAC_AGING_SOA_DETAILS.prem_seq_no%TYPE,
                          p_inst_no GIAC_AGING_SOA_DETAILS.inst_no%TYPE)
     RETURN instno_detail_tab PIPELINED;
   
   -- bonok :: 4.8.2016 :: UCPB SR 21681  
   FUNCTION get_inst_info2(p_iss_cd      GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
                          p_prem_seq_no GIAC_AGING_SOA_DETAILS.prem_seq_no%TYPE,
                          p_inst_no GIAC_AGING_SOA_DETAILS.inst_no%TYPE)
     RETURN instno_detail_tab PIPELINED;
     
     PROCEDURE get_policy_details (
       p_line_cd            IN       gipi_polbasic.line_cd%TYPE,
       p_subline_cd         IN       gipi_polbasic.subline_cd%TYPE,
       p_iss_cd             IN       gipi_polbasic.iss_cd%TYPE,
       p_issue_yy           IN       gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no         IN       gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no           IN       gipi_polbasic.renew_no%TYPE,
       p_ref_pol_no         IN       VARCHAR2,
       p_nbt_due            IN       VARCHAR2,
       p_new_iss_cd         OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_prem_seq_no        OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_inst_no            OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_balance_amt_due    OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_prem_balance_due   OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_tax_balance_due    OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_currency_cd        OUT      gipi_invoice.currency_cd%TYPE,
       p_convert_rate       OUT      gipi_invoice.currency_rt%TYPE,
       p_nbt_currency_desc  OUT      giis_currency.currency_desc%TYPE,
       p_transaction_type   OUT      giac_direct_prem_collns.transaction_type%TYPE,
       p_msg_alert          OUT      VARCHAR2
    );
    
    TYPE invoice_listing_type IS RECORD (
       line_cd              gipi_polbasic.line_cd%TYPE,
       subline_cd           gipi_polbasic.subline_cd%TYPE,
       iss_cd               giac_aging_soa_details.iss_cd%TYPE,
       prem_seq_no          giac_aging_soa_details.prem_seq_no%TYPE,
       inst_no              giac_aging_soa_details.inst_no%TYPE,
       balance_amt_due      giac_aging_soa_details.balance_amt_due%TYPE
    );

    TYPE invoice_listing_tab IS TABLE OF invoice_listing_type;
    
    FUNCTION get_pack_invoices(
      p_due             VARCHAR2,
      p_line_cd         gipi_pack_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_pack_polbasic.subline_cd%TYPE,
      p_iss_cd          gipi_pack_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_pack_polbasic.issue_yy%TYPE,
      p_pol_seq_no      gipi_pack_polbasic.pol_seq_no%TYPE,
      p_renew_no        gipi_pack_polbasic.renew_no%TYPE,
      p_user_id         VARCHAR2
   )
    RETURN invoice_listing_tab PIPELINED;
    
    TYPE invoice_soa_details_type IS RECORD(
        iss_Cd              giac_aging_soa_details.iss_cd%TYPE,
        prem_seq_no         giac_aging_soa_details.prem_seq_no%TYPE,
        inst_no             giac_aging_soa_details.inst_no%TYPE,
        next_age_level_dt   VARCHAR2(50), --giac_aging_soa_details.next_age_level_dt%TYPE,
        total_amt_due       giac_aging_soa_details.total_amount_due%TYPE,
        total_payments      giac_aging_soa_details.total_payments%TYPE,
        temp_payments       giac_aging_soa_details.temp_payments%TYPE,
        balance_amt_due     giac_aging_soa_details.balance_amt_due%TYPE,
        prem_balance_due    giac_aging_soa_details.prem_balance_due%TYPE,
        tax_balance_due     giac_aging_soa_details.tax_balance_due%TYPE
    );
    
    TYPE invoice_soa_details_tab IS TABLE OF invoice_soa_details_type;
    
    FUNCTION get_soa_details (
        p_iss_Cd            giac_aging_soa_details.iss_Cd%TYPE,
        p_prem_seq_no       giac_aging_soa_details.prem_seq_no%TYPE
   ) RETURN invoice_soa_details_tab PIPELINED;
     
END giac_aging_soa_details_pkg;
/



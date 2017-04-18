CREATE OR REPLACE PACKAGE CPI.GIAC_UPLOADING_PKG
AS
   --Deo [11.29.2016]: add start
   variables_intm_no               giac_upload_file.intm_no%TYPE;
   variables_convert_rate          giis_currency.currency_rt%TYPE;
   variables_ri_cd                 giac_upload_file.ri_cd%TYPE;
   --Deo [11.29.2016]: add ends
   
   PROCEDURE upload_excel_type1 (
      p_check_date        IN       VARCHAR2,
      p_fcollection_amt   IN       VARCHAR2,
      p_policy_no         IN       VARCHAR2,
      p_bill_no           IN       VARCHAR2,
      p_payor             IN       VARCHAR2,
      p_bank              IN       VARCHAR2,
      p_pay_mode          IN       VARCHAR2,
      p_check_class       IN       VARCHAR2,
      p_check_no          IN       VARCHAR2,
      p_payment_date      IN       VARCHAR2,
      p_currency_cd       IN       VARCHAR2,
      p_convert_rate      IN       VARCHAR2,
      p_atm_tag           IN       VARCHAR2,
      p_source_cd         IN       VARCHAR2,
      p_file_no           IN       VARCHAR2,
      p_hash_bill         IN OUT   VARCHAR2,
      p_hash_collection   IN OUT   VARCHAR2,
      p_query             OUT      VARCHAR2
   );

   PROCEDURE upload_excel_type1_b (
      p_or_tag              IN   VARCHAR2,
      p_file_no             IN   VARCHAR2,
      p_source_cd           IN   VARCHAR2,
      p_atm_tag             IN   VARCHAR2,
      p_records_converted   IN   VARCHAR2,
      p_hash_bill           IN   VARCHAR2,
      p_hash_collection     IN   VARCHAR2,
      p_payt_date           IN   VARCHAR2
   );

   PROCEDURE upload_excel_type2 (
      p_intm_no           IN       VARCHAR2,
      p_payor             IN       VARCHAR2,
      p_policy_no         IN       VARCHAR2,
      p_endt_no           IN       VARCHAR2,
      p_fgross_prem_amt   IN       VARCHAR2,
      p_fcomm_amt         IN       VARCHAR2,
      p_fwhtax_amt        IN       VARCHAR2,
      p_finput_vat_amt    IN       VARCHAR2,
      p_fnet_amt_due      IN       VARCHAR2,
      p_gross_tag         IN       VARCHAR2,
      p_currency_cd       IN       VARCHAR2,
      p_convert_rate      IN       VARCHAR2,
      p_source_cd         IN       VARCHAR2,
      p_file_no           IN       VARCHAR2,
      p_hash_bill         IN OUT   VARCHAR2,
      p_hash_collection   IN OUT   VARCHAR2,
      p_query             OUT      VARCHAR2
   );

   PROCEDURE upload_excel_type2_b (
      p_or_tag              IN   VARCHAR2,
      p_file_no             IN   VARCHAR2,
      p_source_cd           IN   VARCHAR2,
      p_records_converted   IN   VARCHAR2,
      p_hash_bill           IN   VARCHAR2,
      p_hash_collection     IN   VARCHAR2,
      p_intm_no             IN   VARCHAR2
   );

   PROCEDURE upload_excel_type3 (
      p_assured           IN       VARCHAR2,
      p_policy_no         IN       VARCHAR2,
      p_fprem_amt         IN       VARCHAR2,
      p_ftax_amt          IN       VARCHAR2,
      p_fcomm_amt         IN       VARCHAR2,
      p_fcomm_vat         IN       VARCHAR2,
      p_fcollection_amt   IN       VARCHAR2,
      p_currency_cd       IN       VARCHAR2,
      p_convert_rate      IN       VARCHAR2,
      p_ri_cd             IN       VARCHAR2,
      p_source_cd         IN       VARCHAR2,
      p_file_no           IN       VARCHAR2,
      p_check_curr        IN       VARCHAR2,
      p_hash_bill         IN OUT   VARCHAR2,
      p_hash_collection   IN OUT   VARCHAR2
   );

   PROCEDURE upload_excel_type3_b (
      p_hash_bill           IN   VARCHAR2,
      p_hash_collection     IN   VARCHAR2,
      p_records_converted   IN   VARCHAR2,
      p_source_cd           IN   VARCHAR2,
      p_file_no             IN   VARCHAR2,
      p_ri_cd               IN   VARCHAR2
   );

   PROCEDURE upload_excel_type4 (
      p_binder_no         IN       VARCHAR2,
      p_fprem_amt         IN       VARCHAR2,
      p_fprem_vat         IN       VARCHAR2,
      p_fcomm_amt         IN       VARCHAR2,
      p_fcomm_vat         IN       VARCHAR2,
      p_fwholding         IN       VARCHAR2,
      p_fdisb_amt         IN       VARCHAR2,
      p_currency          IN       VARCHAR2,
      p_convert_rt        IN       VARCHAR2,
      p_ri_cd             IN       VARCHAR2,
      p_source_cd         IN       VARCHAR2,
      p_file_no           IN       VARCHAR2,
      p_check_curr        IN       VARCHAR2,
      p_hash_bill         IN OUT   VARCHAR2,
      p_hash_collection   IN OUT   VARCHAR2
   );
   
   --Deo [11.29.2016]: add start
   PROCEDURE upload_excel_type4_b (
      p_hash_bill           IN   VARCHAR2,
      p_hash_collection     IN   VARCHAR2,
      p_records_converted   IN   VARCHAR2,
      p_source_cd           IN   VARCHAR2,
      p_file_no             IN   VARCHAR2,
      p_ri_cd               IN   VARCHAR2
   );
   --Deo [11.29.2016]: add ends

   PROCEDURE upload_excel_type5 (
      p_reference_no      IN       VARCHAR2,
      p_payor             IN       VARCHAR2,
      p_famount           IN       VARCHAR2,
      p_fdeposit_date     IN       VARCHAR2,
      p_row               IN       VARCHAR2,
      p_source_cd         IN       VARCHAR2,
      p_file_no           IN       VARCHAR2,
      p_hash_bill         IN OUT   VARCHAR2,
      p_hash_collection   IN OUT   VARCHAR2
   );
   
   PROCEDURE upload_excel_type5_b (
      p_hash_bill           IN   VARCHAR2,
      p_hash_collection     IN   VARCHAR2,
      p_records_converted   IN   VARCHAR2,
      p_source_cd           IN   VARCHAR2,
      p_file_no             IN   VARCHAR2,
      p_deposit_date        IN   VARCHAR2 
   );

   PROCEDURE chk_pol_no (
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_endt_iss_cd   VARCHAR2
   );

   PROCEDURE chk_pay_mode (
      p_pay_mode      giac_upload_prem_dtl.pay_mode%TYPE,
      p_bank          giac_upload_prem_dtl.bank%TYPE,
      p_check_class   giac_upload_prem_dtl.check_class%TYPE,
      p_check_no      giac_upload_prem_dtl.check_no%TYPE,
      p_check_date    giac_upload_prem_dtl.check_date%TYPE
   );
   
   TYPE process_data_list_type IS RECORD (
      file_no           GIAC_UPLOAD_FILE.file_no%TYPE,
      file_name         GIAC_UPLOAD_FILE.file_name%TYPE,
      hash_collection   GIAC_UPLOAD_FILE.hash_collection%TYPE,
      convert_date      GIAC_UPLOAD_FILE.convert_date%TYPE,
      upload_date       GIAC_UPLOAD_FILE.upload_date%TYPE,
      status            VARCHAR2(200),
      remarks           GIAC_UPLOAD_FILE.remarks%TYPE,
      user_id           GIAC_UPLOAD_FILE.user_id%TYPE,
      last_update       VARCHAR2(200),
      transaction_type  GIAC_UPLOAD_FILE.transaction_type%TYPE
   );
   
   TYPE process_data_list_tab IS TABLE OF process_data_list_type;
   
   FUNCTION get_process_data_list (p_source_cd VARCHAR2)
      RETURN process_data_list_tab PIPELINED;
      
      
   PROCEDURE check_for_claim(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_module_id     VARCHAR2
   );
   
   PROCEDURE check_for_override(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_module_id     VARCHAR2,
        p_user_id       VARCHAR2
   );
   
   FUNCTION get_branch_cd(
        p_acct_branch_cd   NUMBER
   )
   RETURN VARCHAR2;
      
END; 
/


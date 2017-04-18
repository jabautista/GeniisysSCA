CREATE OR REPLACE PACKAGE CPI.giacr118c_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      cf_top_date      VARCHAR2 (70), 
      post_tran        VARCHAR2 (200),
      top_date         VARCHAR2 (70),
      gibr_branch_cd   giac_disb_vouchers.gibr_branch_cd%TYPE, 
      branch           giis_issource.iss_name%TYPE,
      pdc_date         DATE,
      gacc_tran_id     giac_disb_vouchers.gacc_tran_id%TYPE,
      ref_no           VARCHAR2 (16),
      tin              giis_payees.tin%TYPE,
      vendor           giac_disb_vouchers.payee%TYPE,
      particulars      giac_disb_vouchers.particulars%TYPE,
      amount           NUMBER (38, 2),
      discount         NUMBER (38, 2),
      input_vat        NUMBER (21, 2),
      net_amount       NUMBER (21, 2)
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN get_details_tab PIPELINED;
END;
/



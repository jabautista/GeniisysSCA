CREATE OR REPLACE PACKAGE CPI.giacr200a_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company           VARCHAR2 (50),
      cf_com_address       VARCHAR2 (200),
      cf_top_date          VARCHAR2 (70),
      based_on             VARCHAR2 (100),
      b140_iss_cd          giac_direct_prem_collns.b140_iss_cd%TYPE,
      iss_name             giis_issource.iss_name%TYPE,
      intm_no              giis_intermediary.intm_no%TYPE,
      intm_name            giis_intermediary.intm_name%TYPE,
      line_cd              gipi_polbasic.line_cd%TYPE,
      book_tag             VARCHAR2 (1),
      policy_no            VARCHAR2 (50),
      assd_name            giis_assured.assd_name%TYPE,
      bill_no              VARCHAR2 (43),
      sum_premium_amt      NUMBER (38, 2),
      sum_tax_amt          NUMBER (38, 2),
      sum_collection_amt   NUMBER (38, 2),
      tran_flag            giac_acctrans.tran_flag%TYPE,
      posting_date         giac_acctrans.posting_date%TYPE,
      posted_amt           NUMBER (38, 2),
      unposted_amt         NUMBER (38, 2),
      exist                VARCHAR2(1)
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   TYPE get_recap_type IS RECORD (
      line_name            giis_line.line_name%TYPE,
      book_tag             VARCHAR2 (18),
      iss_name             giis_issource.iss_name%TYPE,
      sum_collection_amt   NUMBER (38, 2)
   );

   TYPE get_recap_tab IS TABLE OF get_recap_type;

   FUNCTION get_details (
      p_param         NUMBER,
      p_branch_code   gipi_invoice.iss_cd%TYPE,
      p_module_id     VARCHAR2,
      p_date          VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_details_tab PIPELINED;

   FUNCTION get_recap (
      p_param         NUMBER,
      p_branch_code   gipi_invoice.iss_cd%TYPE,
      p_module_id     VARCHAR2,
      p_date          VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_recap_tab PIPELINED;
END;
/



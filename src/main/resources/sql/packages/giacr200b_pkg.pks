CREATE OR REPLACE PACKAGE CPI.giacr200b_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company           VARCHAR2 (50),
      cf_com_address       VARCHAR2 (200),
      cf_top_date          VARCHAR2 (70),
      based_on             VARCHAR2 (100),
      b140_iss_cd          giac_direct_prem_collns.b140_iss_cd%TYPE,
      iss_name             giis_issource.iss_name%TYPE,
      pol_stat             VARCHAR2 (17),
      line_cd              gipi_polbasic.line_cd%TYPE,
      line_name            giis_line.line_name%TYPE,
      tran_flag            giac_acctrans.tran_flag%TYPE,
      posting_date         giac_acctrans.posting_date%TYPE,
      sum_preium_amt       NUMBER (38,2),
      sum_collection_amt   NUMBER (38,2),
      sum_tax_amt          NUMBER (38,2),
      exist                VARCHAR2(1)
   );

   TYPE get_details_tab IS TABLE OF get_details_type;
   
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
END;
/



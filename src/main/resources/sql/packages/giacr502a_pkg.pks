CREATE OR REPLACE PACKAGE CPI.GIACR502A_PKG
AS
   TYPE get_details_type IS RECORD (
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      as_of            VARCHAR2 (30),
      debit            NUMBER (38, 5),
      credit           NUMBER (38, 5),
      balance          NUMBER (38, 5),
      gl_acct_no       VARCHAR2 (4000),
      gl_acct_name     giac_chart_of_accts.gl_acct_name%TYPE
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details (p_tran_mm NUMBER, p_tran_yr NUMBER)
      RETURN get_details_tab PIPELINED;
END;
/



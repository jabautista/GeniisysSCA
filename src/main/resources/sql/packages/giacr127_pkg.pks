CREATE OR REPLACE PACKAGE CPI.GIACR127_PKG
AS
   TYPE giacr127_record_type IS RECORD (
      p_date              VARCHAR2 (20),
      line_name           VARCHAR2 (20),
      subline_name        VARCHAR2 (30),
      pos_neg_inclusion   VARCHAR2 (1),
      tsi_amt             NUMBER (16, 2),
      prem_amt            NUMBER (16, 2),
      tax_amt             NUMBER (12, 2),
      comm_amt            NUMBER (38),
      cf_co_name          VARCHAR2 (100),
      cf_company_add      VARCHAR2 (350),
      cf_spoiled          VARCHAR2 (10)
   );

   TYPE giacr127_record_tab IS TABLE OF giacr127_record_type;

   FUNCTION get_giacr127_record (p_date DATE)
      RETURN giacr127_record_tab PIPELINED;
END;
/



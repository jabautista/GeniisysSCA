CREATE OR REPLACE PACKAGE CPI.GIACR130_PKG
AS
   TYPE giacr130_record_type IS RECORD (
      p_date              VARCHAR2 (50),
      intm_name           VARCHAR2 (240),
      pos_neg_inclusion   VARCHAR2 (1),
      line_name           VARCHAR2 (20),
      subline_name        VARCHAR2 (30),
      tsi_amt             NUMBER (16,2),
      prem_amt            NUMBER (16,2),
      comm_amt            NUMBER (16,2),
      tax_amt             NUMBER (16,2),
      cf_company_name     VARCHAR2 (100),
      cf_company_add      VARCHAR2 (350)
   );

   TYPE giacr130_record_tab IS TABLE OF giacr130_record_type;

   FUNCTION get_giacr130_record (p_date DATE)
      RETURN giacr130_record_tab PIPELINED;
END;
/



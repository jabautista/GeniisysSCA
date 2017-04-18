CREATE OR REPLACE PACKAGE CPI.giacr129_pkg
AS
   TYPE giacr129_record_type IS RECORD (
      p_date              DATE,
      line_name           VARCHAR2 (20),
      subline_name        VARCHAR2 (30),
      pos_neg_inclusion   VARCHAR2 (1),
      policy_no           VARCHAR2 (40),
      incept_date         DATE,
      issue_date          DATE,
      assd_name           VARCHAR2 (500),
      tsi_amt             NUMBER(20,2),
      premium_amt         NUMBER(20,2),
      commission_amt      NUMBER(20,2),
      tax_amt             NUMBER(20,2),
      pol_seq_no          NUMBER (7),
      issue_yy            NUMBER (2),
      company_name        VARCHAR2 (100),
      company_address     VARCHAR2 (350)
   );

   TYPE giacr129_record_tab IS TABLE OF giacr129_record_type;

   FUNCTION get_giacr129_record (p_date DATE)
      RETURN giacr129_record_tab PIPELINED;
END;
/



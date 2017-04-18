CREATE OR REPLACE PACKAGE CPI.giacr107_pkg
AS
   TYPE giacr107_record_type IS RECORD (
      payee_class_cd     VARCHAR2 (2),
      class_desc         VARCHAR2 (30),
      payee_cd           NUMBER (12),
      NAME               VARCHAR2 (700),
      income_amt         NUMBER (12, 2),
      wholding_tax_amt   NUMBER (12, 2),
      company            VARCHAR2 (100),
      company_address    VARCHAR2 (500),
      period             VARCHAR2 (100),
      exist              VARCHAR2 (1)
   );

   TYPE giacr107_record_tab IS TABLE OF giacr107_record_type;

   FUNCTION get_giacr107_records (p_date1 VARCHAR2, p_date2 VARCHAR2, p_exclude_tag VARCHAR2, p_module_id VARCHAR2, p_payee VARCHAR2, p_post_tran_toggle VARCHAR2, p_user_id giis_users.user_id%TYPE)
      RETURN giacr107_record_tab PIPELINED;
END;
/



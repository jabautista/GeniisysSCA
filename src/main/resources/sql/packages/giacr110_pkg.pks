CREATE OR REPLACE PACKAGE CPI.giacr110_pkg
AS
   TYPE giacr110_record_type IS RECORD (
      company            VARCHAR2 (500),
      address            VARCHAR2 (500),
      cf_intm            VARCHAR2 (500),
      cf_emp             VARCHAR2 (500),
      cf_date            VARCHAR2 (500),
      payee_class_cd     VARCHAR2 (2),
      class_desc         VARCHAR2 (30),
      payee_cd           NUMBER (12, 2),
      payee_name         VARCHAR2 (100),
      income_amt         NUMBER (12, 2),
      wholding_tax_amt   NUMBER (12, 2),
      bir_tax_cd         VARCHAR2 (10),
      percent_rate       NUMBER (5, 3),
      whtax_desc         VARCHAR2 (100),
      tin                VARCHAR2 (100)
   );

   TYPE giacr110_record_tab IS TABLE OF giacr110_record_type;

   FUNCTION get_giacr110_records (
      p_date1              VARCHAR2,
      p_date2              VARCHAR2,
      p_exclude_tag        VARCHAR2,
      p_module_id          VARCHAR2,
      p_payee              VARCHAR2,
      p_post_tran_toggle   VARCHAR2,
      p_tax_cd             VARCHAR2, -- Added by Jerome 09.26.2016 SR 5671
      p_user_id            VARCHAR2
   )
      RETURN giacr110_record_tab PIPELINED;
END;
/



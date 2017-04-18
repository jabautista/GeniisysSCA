CREATE OR REPLACE PACKAGE CPI.giacr057_pkg
AS
   TYPE giacr057_type IS RECORD (
      company_name    VARCHAR2 (100),
      document_name   VARCHAR2 (100),
      request_no      VARCHAR2 (50),
      request_date    DATE,
      payee           VARCHAR2 (650),
      particulars     VARCHAR2 (2000),
      amount          NUMBER (16, 2),
      status          VARCHAR2 (105),
      branch_cd       VARCHAR2 (2),
      dv_no           VARCHAR2 (20),
      check_no        VARCHAR2 (20),
      branch_name     VARCHAR2 (100)
   );

   TYPE giacr057_tab IS TABLE OF giacr057_type;

   FUNCTION get_giacr057_tab (
      p_branch_cd       VARCHAR2,
      p_document_cd     VARCHAR2,
      p_document_name   VARCHAR2,
      p_from_date       DATE,
      p_status          VARCHAR2,
      p_to_date         DATE,
      p_user_id         VARCHAR2
   )
      RETURN giacr057_tab PIPELINED;

   TYPE giacr057_header_type IS RECORD (
      company_name      VARCHAR2 (100),
      company_address   VARCHAR2 (250)
   );

   TYPE giacr057_header_tab IS TABLE OF giacr057_header_type;

   FUNCTION get_giacr057_header
      RETURN giacr057_header_tab PIPELINED;
      
    TYPE csv_type IS RECORD(
	    rec                 VARCHAR2(32000)
    );
    TYPE csv_tab IS TABLE OF csv_type;
      
    FUNCTION get_giacr057_csv(
        p_branch_cd         VARCHAR2,
        p_document_cd       VARCHAR2,
        p_document_name     VARCHAR2,
        p_from_date         DATE,
        p_status            VARCHAR2,
        p_to_date           DATE,
        p_user_id           VARCHAR2
    )
      RETURN csv_tab PIPELINED;
      
END;
/



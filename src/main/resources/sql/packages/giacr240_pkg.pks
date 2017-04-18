CREATE OR REPLACE PACKAGE CPI.giacr240_pkg
AS
   TYPE giacr240_type IS RECORD (
      ouc_id           NUMBER (4),
      ouc_name         VARCHAR2 (100),
      branch_cd        VARCHAR2 (2),
      branch_name      VARCHAR2 (50),
      payee_class_cd   VARCHAR2 (2),
      class_desc       VARCHAR2 (30),
      payee_name       VARCHAR2 (500),
      particulars      VARCHAR2 (2000),
      check_no         VARCHAR2 (46),
      check_date       DATE,
      dv_amt           NUMBER (12, 2),
      flag             VARCHAR2 (10),
      comp_name        VARCHAR2 (100),
      comp_add         VARCHAR2 (350),
      top_date         VARCHAR2 (100)
   );

   TYPE giacr240_tab IS TABLE OF giacr240_type;

   FUNCTION get_giacr240_record (
      p_payee            VARCHAR2,
      p_branch           VARCHAR2,
      p_ouc_id           NUMBER,
      p_payee_class_cd   VARCHAR2,
      p_payee_no         NUMBER,
      p_sort_item        VARCHAR2,
      p_begin_date       VARCHAR2,
      p_end_date         VARCHAR2
   )
      RETURN giacr240_tab PIPELINED;
END;
/



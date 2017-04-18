CREATE OR REPLACE PACKAGE CPI.giacr093_pkg
AS
   TYPE giacr093_record_type IS RECORD (
      branch_cd         VARCHAR2 (2),
      apdc_no           VARCHAR2 (100),
      apdcdate          DATE,
      bank_sname        VARCHAR2 (10),
      bank_branch       VARCHAR2 (200),
      bank_cd           VARCHAR2(3),
      check_no          VARCHAR2 (25),
      check_amt         NUMBER (16, 2),
      checkdate         DATE,
      or_date           DATE,
      or_no             VARCHAR2(16), 
      ref_apdc_no       GIAC_APDC_PAYT.REF_APDC_NO%TYPE,  -- VARCHAR2 (15) changed SR-5709 June Mark [10.07.16]
      payor             VARCHAR2 (550),
      branch_name       VARCHAR2 (50),
      company_name      VARCHAR2 (500),
      company_address   VARCHAR2 (500),
      title             VARCHAR2 (200),
      as_of             VARCHAR2 (100),
      cut_off           VARCHAR2 (100)
   );

   TYPE giacr093_record_tab IS TABLE OF giacr093_record_type;

   FUNCTION get_giacr093_records (
      p_as_of           DATE,
      p_begin_extract   VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_cut_off         DATE,
      p_end_extract     VARCHAR2,
      p_pdc             CHARACTER,
      p_user_id         VARCHAR2
   )
      RETURN giacr093_record_tab PIPELINED;
END;
/



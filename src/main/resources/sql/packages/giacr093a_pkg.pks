CREATE OR REPLACE PACKAGE CPI.giacr093a_pkg
AS
   TYPE giacr093a_header_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      title             VARCHAR2 (200),
      as_of             VARCHAR2 (200),
      cut_off           VARCHAR2 (200)
   );

   TYPE giacr093a_header_tab IS TABLE OF giacr093a_header_type;

   FUNCTION populate_giacr093a_header (
      p_pdc       VARCHAR2,
      p_as_of     DATE,
      p_cut_off   DATE
   )
      RETURN giacr093a_header_tab PIPELINED;

   TYPE giacr093a_details_type IS RECORD (
      branch_cd        giac_pdc_ext.branch_cd%type, --CarloR SR-5519 06.28.2016
      branch           VARCHAR2 (200),
      pol_no           VARCHAR2 (100),
      assd_no          giis_assured.assd_no%type,  --CarloR SR-5519 06.28.2016
      assured          giis_assured.ASSD_NAME%type, -- VARCHAR2 (200), -- shan 08.05.2014
      apdc_no          VARCHAR2 (75),
      apdc_date        giac_pdc_ext.apdc_date%TYPE,
      bank             giac_banks.bank_sname%TYPE,
      bank_branch      giac_pdc_ext.bank_branch%TYPE,
      check_no         giac_pdc_ext.check_no%TYPE,
      check_date       giac_pdc_ext.check_date%TYPE,
      check_amt        giac_pdc_ext.check_amt%TYPE,
      bill_no          VARCHAR2 (100),
      iss_cd           giac_pdc_dtl_ext.iss_cd%TYPE,
      collection_amt   giac_pdc_dtl_ext.collection_amt%TYPE,
      or_date          giac_pdc_ext.or_date%TYPE,
      or_no            VARCHAR2 (50),
      ref_apdc_no      giac_apdc_payt.ref_apdc_no%TYPE,
      payor            giac_apdc_payt.payor%TYPE
   );

   TYPE giacr093a_details_tab IS TABLE OF giacr093a_details_type;

   FUNCTION populate_giacr093a_details (
      p_as_of           DATE,
      p_cut_off         DATE,
      p_begin_extract   VARCHAR2,
      p_end_extract     VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN giacr093a_details_tab PIPELINED;
END giacr093a_pkg;
/



CREATE OR REPLACE PACKAGE CPI.giacr170_pkg
AS
   TYPE giacr170_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      f_date            VARCHAR2 (70),
      date_type_title   VARCHAR2 (200)
   );

   TYPE giacr170_tab IS TABLE OF giacr170_type;

   FUNCTION populate_giacr170 (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_date_type   VARCHAR2
   )
      RETURN giacr170_tab PIPELINED;

   TYPE giacr170_details_type IS RECORD (
      or_no              VARCHAR2 (30),
      tran_id            giac_acctrans.tran_id%TYPE,
      tran_date          giac_acctrans.tran_date%TYPE,
      policy_number      VARCHAR2 (45),
      reference_pol_no   VARCHAR2 (30),
      assured            giis_assured.assd_name%TYPE,
      inception_date     gipi_polbasic.incept_date%TYPE,
      expiry_date        gipi_polbasic.expiry_date%TYPE,
      bill_no            VARCHAR2 (45),
      collection_amt     giac_direct_prem_collns.collection_amt%TYPE,
      premium_amt        giac_direct_prem_collns.premium_amt%TYPE,
      tax_amt            giac_direct_prem_collns.tax_amt%TYPE,
      bk_month           giac_advanced_payt.booking_mth%TYPE,
      bk_year            giac_advanced_payt.booking_year%TYPE,
      branch             VARCHAR2 (5)
   );

   TYPE giacr170_details_tab IS TABLE OF giacr170_details_type;

   FUNCTION populate_giacr170_details (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_date_type   VARCHAR2,
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_module_id   VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr170_details_tab PIPELINED;

   TYPE tran_id_type IS RECORD (
      tran_id   VARCHAR2 (50)
   );

   TYPE tran_id_tab IS TABLE OF tran_id_type;

   FUNCTION cf_1formula (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN tran_id_tab PIPELINED;

   TYPE branch_type IS RECORD (
      branch   VARCHAR2 (50)
   );

   TYPE branch_tab IS TABLE OF branch_type;

   FUNCTION cf_branch_nameformula (p_branch VARCHAR2)
      RETURN branch_tab PIPELINED;
END giacr170_pkg;
/



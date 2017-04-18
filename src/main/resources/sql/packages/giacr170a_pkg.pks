CREATE OR REPLACE PACKAGE CPI.giacr170a_pkg
AS
   TYPE giacr170a_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      title             VARCHAR2 (200)
   );

   TYPE giacr170a_tab IS TABLE OF giacr170a_type;

   FUNCTION populate_giacr170a (
      p_date_type   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2
   )
      RETURN giacr170a_tab PIPELINED;

   TYPE giacr170a_details_type IS RECORD (
      cred_branch    gipi_polbasic.cred_branch%TYPE,
      ref_no         VARCHAR2 (50),
      date_decode    DATE,
      policy_no      VARCHAR2 (50),
      assd_name      giis_assured.assd_name%TYPE,
      incept_date    gipi_polbasic.incept_date%TYPE,
      expiry_date    gipi_polbasic.expiry_date%TYPE,
      bill_no        VARCHAR2 (50),
      premium_amt    giac_direct_prem_collns.premium_amt%TYPE,
      tax_amt        giac_direct_prem_collns.tax_amt%TYPE,
      booking_date   VARCHAR2 (50),
      evat           NUMBER,
      branch_name    VARCHAR2 (50)
   );

   TYPE giacr170a_details_tab IS TABLE OF giacr170a_details_type;

   FUNCTION populate_giacr170a_details (
      p_date_type   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2
   )
      RETURN giacr170a_details_tab PIPELINED;
END giacr170a_pkg;
/



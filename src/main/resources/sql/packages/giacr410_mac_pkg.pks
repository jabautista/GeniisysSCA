CREATE OR REPLACE PACKAGE CPI.giacr410_mac_pkg
AS
   TYPE details_type IS RECORD (
      sys_date      VARCHAR2 (50),
      intm_name     giis_intermediary.intm_name%TYPE,
      mail_addr1    giis_intermediary.mail_addr1%TYPE,
      mail_addr2    giis_intermediary.mail_addr1%TYPE,
      mail_addr3    giis_intermediary.mail_addr1%TYPE,
      subline_cd    gipi_polbasic.subline_cd%TYPE,
      policy_no     VARCHAR2 (50),
      endt_no       VARCHAR2 (50),
      short_name    giis_currency.short_name%TYPE,
      incept_date   VARCHAR2 (50),
      expiry_date   VARCHAR2 (50),
      tel_no        giis_issource.tel_no%TYPE
   );

   TYPE details_tab IS TABLE OF details_type;

   TYPE signatory_type IS RECORD (
      signatory     giis_signatory_names.signatory%TYPE,
      designation   giis_signatory_names.designation%TYPE,
      label         giac_rep_signatory.label%TYPE
   );

   TYPE signatory_tab IS TABLE OF signatory_type;

   FUNCTION get_details (
      p_policy_id     giac_cm_dm.gacc_tran_id%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_bal_amt_due   NUMBER
   )
      RETURN details_tab PIPELINED;

   FUNCTION get_cl_signatory (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN signatory_tab PIPELINED;
END giacr410_mac_pkg;
/



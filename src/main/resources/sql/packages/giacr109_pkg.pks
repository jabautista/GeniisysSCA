CREATE OR REPLACE PACKAGE CPI.giacr109_pkg
AS
   TYPE report_type IS RECORD (
      line_nm           VARCHAR2 (200),
      policy_no         VARCHAR2 (100),
      ref_pol_no        gipi_polbasic.ref_pol_no%TYPE,
      incept_date       gipi_polbasic.incept_date%TYPE,
      expiry_date       gipi_polbasic.expiry_date%TYPE,
      acct_ent_date     gipi_polbasic.acct_ent_date%TYPE,
      client            giis_assured.assd_name%TYPE,
      cp_addr           VARCHAR2 (200),
      cp_tin            giis_assured.assd_tin%TYPE,
      invoice_no        VARCHAR2 (200),
      premium           giac_direct_prem_collns.premium_amt%TYPE,
      cf_premium        NUMBER (12,2),
      evat              NUMBER (12, 2),
      cf_evat           NUMBER (12,2),
      pyt_date          giac_acctrans.tran_date%TYPE,
      pyt_ref           VARCHAR2 (100),
      pyt_amt           giac_direct_prem_collns.collection_amt%TYPE,
      cf_pyt_amt        NUMBER (12,2),
      os_bal            NUMBER (12,2),
      cf_os_bal         NUMBER (12, 2),
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      tran_date1        VARCHAR2 (100),
      tran_date2        VARCHAR2 (100),
      exist             VARCHAR2(1)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr_109_report (
      p_branch_cd    VARCHAR2,
      p_include      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_module_id    VARCHAR2,
      p_post_tran    VARCHAR2,
      p_tran_date1   VARCHAR2,
      p_tran_date2   VARCHAR2
   )
      RETURN report_tab PIPELINED;
      
   TYPE giacr109_inward_type IS RECORD (
      line_name         VARCHAR2 (200),
      policy_no         VARCHAR2 (100),
      ref_pol_no        gipi_polbasic.ref_pol_no%TYPE,
      incept_date       gipi_polbasic.incept_date%TYPE,
      expiry_date       gipi_polbasic.expiry_date%TYPE,
      acct_ent_date     gipi_polbasic.acct_ent_date%TYPE,
      client            giis_assured.assd_name%TYPE,
      cp_addr           VARCHAR2 (200),
      cp_tin            giis_assured.assd_tin%TYPE,
      invoice_no        VARCHAR2 (200),
      premium           giac_direct_prem_collns.premium_amt%TYPE,
      cf_premium        NUMBER (12,2),
      evat              NUMBER (12, 2),
      cf_evat           NUMBER (12,2),
      pyt_date          giac_acctrans.tran_date%TYPE,
      pyt_ref           VARCHAR2 (100),
      pyt_amt           giac_direct_prem_collns.collection_amt%TYPE,
      cf_pyt_amt        NUMBER (12,2),
      os_bal            NUMBER (12,2),
      cf_os_bal         NUMBER (12, 2)
   );

   TYPE giacr109_inward_tab IS TABLE OF giacr109_inward_type;

   FUNCTION get_giacr109_inwardreport (
      p_branch_cd    VARCHAR2,
      p_line_cd      VARCHAR2,
      p_post_tran    VARCHAR2,
      p_tran_date1   VARCHAR2,
      p_tran_date2   VARCHAR2
   )
      RETURN giacr109_inward_tab PIPELINED;
END;
/



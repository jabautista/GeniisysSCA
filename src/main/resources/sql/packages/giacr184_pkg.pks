CREATE OR REPLACE PACKAGE CPI.giacr184_pkg
AS
   TYPE giacr184_records_type IS RECORD (
      cf_company           VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_from_date         VARCHAR2 (50),
      cf_to_date           VARCHAR2 (50),
      assd_no              giac_dueto_ext.assd_no%TYPE,
      assd_name            giac_dueto_ext.assd_name%TYPE,
      line_cd              giac_dueto_ext.line_cd%TYPE,
      line_name            giis_line.line_name%TYPE,
      ri_cd                giac_dueto_ext.ri_cd%TYPE,
      ri_name              giac_dueto_ext.ri_name%TYPE,
      fund_cd              giac_dueto_ext.fund_cd%TYPE,
      branch_cd            giac_dueto_ext.branch_cd%TYPE,
      binder_date          giac_dueto_ext.binder_date%TYPE,
      ri_prem_amt          NUMBER (20, 2),
      prem_vat             NUMBER (20, 2),
      ri_comm_amt          NUMBER (20, 2),
      comm_vat             NUMBER (20, 2),
      prem_tax             NUMBER (20, 2),
      wholding_vat         NUMBER (20, 2),
      amt_insured          NUMBER (20, 2),
      policy_no            giac_dueto_ext.policy_no%TYPE,
      binder_no            VARCHAR2(50),
      booking_date         giac_dueto_ext.booking_date%TYPE,
      net_prem             NUMBER (20, 2)
   );

   TYPE giacr184_records_tab IS TABLE OF giacr184_records_type;

   FUNCTION get_giacr184_records (
      p_ri_cd     giri_binder.ri_cd%TYPE,
      p_line_cd   giri_binder.line_cd%TYPE
   )
      RETURN giacr184_records_tab PIPELINED;
END;
/



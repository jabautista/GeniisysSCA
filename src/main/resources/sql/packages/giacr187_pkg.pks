CREATE OR REPLACE PACKAGE CPI.giacr187_pkg
AS
   TYPE giacr187_type IS RECORD (
      cf_company           VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_from_date         VARCHAR2 (50),
      cf_to_date           VARCHAR2 (50),
      cf_cut_off_date      VARCHAR2 (50),
      ri_sname             giac_due_from_ext.ri_sname%TYPE,
      line_name            giis_line.line_name%TYPE,
      policy_no            giac_due_from_ext.policy_no%TYPE,
      incept_date          gipi_polbasic.incept_date%TYPE,
      ref_pol_no           gipi_polbasic.ref_pol_no%TYPE,
      invoice_no           VARCHAR2 (500),
      inst_no              giac_due_from_ext.inst_no%TYPE,
      ri_policy_no         giri_inpolbas.ri_policy_no%TYPE,
      ri_binder_no         giri_inpolbas.ri_binder_no%TYPE,
      amt_insured          giac_due_from_ext.amt_insured%TYPE,
      gross_prem_amt       giac_due_from_ext.gross_prem_amt%TYPE,
      ri_comm_exp          giac_due_from_ext.ri_comm_exp%TYPE,
      net_premium          NUMBER (20, 2),
      prem_vat             giac_due_from_ext.prem_vat%TYPE,
      comm_vat             giac_due_from_ext.comm_vat%TYPE
   );

   TYPE giacr187_tab IS TABLE OF giacr187_type;

   FUNCTION get_giacr187_details (
      p_ri_cd          giac_due_from_ext.ri_cd%TYPE,
      p_from_date      DATE,
      p_to_date        DATE,
      p_cut_off_date   DATE
   )
      RETURN giacr187_tab PIPELINED;
END;
/



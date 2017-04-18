CREATE OR REPLACE PACKAGE CPI.giacr413e_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (150),
      company_address   VARCHAR2 (200),
      period            VARCHAR2 (200),
      tran_post         VARCHAR2 (100),
      cf_intm_type      giis_intm_type.intm_desc%TYPE,
      intm_no           giac_comm_payts.intm_no%TYPE,
      intm_name         giis_intermediary.intm_name%TYPE,
      policy_no         VARCHAR2 (200),
      comm              giac_comm_payts.comm_amt%TYPE,
      wtax              giac_comm_payts.wtax_amt%TYPE,
      input_vat         giac_comm_payts.input_vat_amt%TYPE,
      net               NUMBER (16, 2),
      line_cd           gipi_polbasic.line_cd%TYPE,
      subline_cd        gipi_polbasic.subline_cd%TYPE
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr_413e_report (
      p_from_dt     VARCHAR2,
      p_to_dt       VARCHAR2,
      p_intm_type   VARCHAR2,
      p_module_id   VARCHAR2,
      p_tran_post   NUMBER,
      p_user_id     VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/



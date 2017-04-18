CREATE OR REPLACE PACKAGE CPI.giris013_pkg
AS
   TYPE giris013_type IS RECORD (
      policy_id        gipi_polbasic.policy_id%TYPE,
      iss_cd           gipi_invoice.iss_cd%TYPE,
      prem_seq_no      gipi_invoice.prem_seq_no%TYPE,
      invoice_no       VARCHAR2 (100),
      currency_desc    giis_currency.currency_desc%TYPE,
      net_due          NUMBER (16, 2),
      balance          NUMBER (16, 2),
      collection_amt   NUMBER (16, 2)
   );

   TYPE giris013_tab IS TABLE OF giris013_type;

   FUNCTION get_inw_ri_payt_stat (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN giris013_tab PIPELINED;

   TYPE polno_lov_type IS RECORD (
      policy_no      VARCHAR2 (100),
      line_cd        gipi_polbasic.line_cd%TYPE,
      subline_cd     gipi_polbasic.subline_cd%TYPE,
      iss_cd         gipi_polbasic.iss_cd%TYPE,
      issue_yy       gipi_polbasic.issue_yy%TYPE,
      pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      renew_no       gipi_polbasic.renew_no%TYPE,
      endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy        gipi_polbasic.endt_yy%TYPE,
      endt_seq_no    gipi_polbasic.endt_seq_no%TYPE,
      ri_policy_no   giri_inpolbas.ri_policy_no%TYPE,
      policy_id      gipi_polbasic.policy_id%TYPE,
      ri_endt_no     giri_inpolbas.ri_endt_no%TYPE,
      ri_binder_no   giri_inpolbas.ri_binder_no%TYPE,
      ri_sname       giis_reinsurer.ri_sname%TYPE,
      eff_date       gipi_polbasic.eff_date%TYPE,
      expiry_date    gipi_polbasic.expiry_date%TYPE
   );

   TYPE polno_lov_tab IS TABLE OF polno_lov_type;

   FUNCTION get_polno_lov (p_line_cd giis_line.line_cd%TYPE)
      RETURN polno_lov_tab PIPELINED;

   TYPE giris013_dtls_type IS RECORD (
      ref_no           VARCHAR2 (100),
      pay_date         giac_payt_requests.request_date%TYPE,
      collection_amt   NUMBER (16, 2)
   );

   TYPE giris013_dtls_tab IS TABLE OF giris013_dtls_type;

   FUNCTION get_inw_ri_payt_dtls (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN giris013_dtls_tab PIPELINED;
END;
/



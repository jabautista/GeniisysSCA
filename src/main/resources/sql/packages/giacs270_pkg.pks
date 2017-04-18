CREATE OR REPLACE PACKAGE CPI.giacs270_pkg
AS
   TYPE gipi_invoice_type IS RECORD (
      bill_iss_cd           gipi_invoice.iss_cd%TYPE,
      prem_seq_no           gipi_invoice.prem_seq_no%TYPE,
      policy_id             gipi_invoice.policy_id%TYPE,
      due_date              gipi_invoice.due_date%TYPE,
      ri_cd                 giis_reinsurer.ri_cd%TYPE,
      ri_name               giis_reinsurer.ri_name%TYPE,
      assd_no               giis_assured.assd_no%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      line_cd               gipi_polbasic.line_cd%TYPE,
      subline_cd            gipi_polbasic.subline_cd%TYPE,
      iss_cd                gipi_polbasic.iss_cd%TYPE,
      issue_yy              gipi_polbasic.issue_yy%TYPE,
      pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
      renew_no              gipi_polbasic.renew_no%TYPE,
      endt_iss_cd           gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy               gipi_polbasic.endt_yy%TYPE,
      endt_seq_no           gipi_polbasic.endt_seq_no%TYPE,
      endt_type             gipi_polbasic.endt_type%TYPE,
      pack_line_cd          gipi_pack_polbasic.line_cd%TYPE,
      pack_subline_cd       gipi_pack_polbasic.subline_cd%TYPE,
      pack_iss_cd           gipi_pack_polbasic.iss_cd%TYPE,
      pack_issue_yy         gipi_pack_polbasic.issue_yy%TYPE,
      pack_pol_seq_no       gipi_pack_polbasic.pol_seq_no%TYPE,
      pack_renew_no         gipi_pack_polbasic.renew_no%TYPE,
      pack_endt_iss_cd      gipi_pack_polbasic.endt_iss_cd%TYPE,
      pack_endt_yy          gipi_pack_polbasic.endt_yy%TYPE,
      pack_endt_seq_no      gipi_pack_polbasic.endt_seq_no%TYPE,
      incept_date           gipi_polbasic.incept_date%TYPE,
      expiry_date           gipi_polbasic.expiry_date%TYPE,
      issue_date            gipi_polbasic.issue_date%TYPE,
      pol_flag              gipi_polbasic.pol_flag%TYPE,
      policy_status         VARCHAR2 (150),
      property              gipi_invoice.property%TYPE,
      payt_terms            gipi_invoice.payt_terms%TYPE,
      prem_amt              gipi_invoice.prem_amt%TYPE,
      tax_amt               gipi_invoice.tax_amt%TYPE,
      other_charges         gipi_invoice.other_charges%TYPE,
      comm_amt              gipi_invoice.ri_comm_amt%TYPE,
      comm_vat              gipi_invoice.ri_comm_vat%TYPE,
      curr_desc             giis_currency.currency_desc%TYPE,
      currency_cd           gipi_invoice.currency_cd%TYPE,
      currency_rt           gipi_invoice.currency_rt%TYPE,
      due_date_char         VARCHAR2 (20),
      incept_date_char      VARCHAR2 (20),
      expiry_date_char      VARCHAR2 (20),
      issue_date_char       VARCHAR2 (20),
      local_prem            NUMBER (16, 2),
      local_tax             NUMBER (16, 2),
      local_charges         NUMBER (16, 2),
      local_comm            NUMBER (16, 2),
      local_comm_vat        NUMBER (16, 2),
      local_tot_amt_due     NUMBER (16, 2),
      foreign_prem          NUMBER (16, 2),
      foreign_tax           NUMBER (16, 2),
      foreign_charges       NUMBER (16, 2),
      foreign_comm          NUMBER (16, 2),
      foreign_comm_vat      NUMBER (16, 2),
      foreign_tot_amt_due   NUMBER (16, 2)
   );

   TYPE gipi_invoice_tab IS TABLE OF gipi_invoice_type;

   TYPE giac_inwfacul_prem_collns_type IS RECORD (
      iss_cd                    giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      prem_seq_no               giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      branch_cd                 giac_acctrans.gibr_branch_cd%TYPE,
      tran_class                giac_acctrans.tran_class%TYPE,
      tran_class_no             giac_acctrans.tran_class_no%TYPE,
      jv_no                     giac_acctrans.jv_no%TYPE,
      tran_year                 giac_acctrans.tran_year%TYPE,
      tran_month                giac_acctrans.tran_month%TYPE,
      tran_seq_no               giac_acctrans.tran_seq_no%TYPE,
      tran_date                 giac_acctrans.tran_date%TYPE,
      tran_date_char            VARCHAR(20),
      ref_no                    VARCHAR2 (50),
      transaction_type          giac_inwfacul_prem_collns.transaction_type%TYPE,
      collection_amt            giac_inwfacul_prem_collns.collection_amt%TYPE,
      currency_desc             giis_currency.short_name%TYPE,
      currency_cd               giac_inwfacul_prem_collns.currency_cd%TYPE,
      convert_rate              giac_inwfacul_prem_collns.convert_rate%TYPE,
      foreign_curr_amt          giac_inwfacul_prem_collns.foreign_curr_amt%TYPE,
      total_colln_amt           giac_inwfacul_prem_collns.collection_amt%TYPE,
      balance_due               giac_aging_ri_soa_details.balance_due%TYPE,
      total_foreign_colln_amt   giac_inwfacul_prem_collns.collection_amt%TYPE,
      foreign_balance_due       giac_aging_ri_soa_details.balance_due%TYPE
   );

   TYPE giac_inwfacul_prem_collns_tab IS TABLE OF giac_inwfacul_prem_collns_type;

   TYPE gipi_invoice_lov_type IS RECORD (
      iss_cd        gipi_invoice.iss_cd%TYPE,
      prem_seq_no   VARCHAR2 (12)
   );

   TYPE gipi_invoice_lov_tab IS TABLE OF gipi_invoice_lov_type;

   TYPE giis_reinsurer_lov_type IS RECORD (
      ri_cd     giis_reinsurer.ri_cd%TYPE,
      ri_name   giis_reinsurer.ri_name%TYPE
   );

   TYPE giis_reinsurer_lov_tab IS TABLE OF giis_reinsurer_lov_type;

   TYPE giis_assured_lov_type IS RECORD (
      assd_no     giis_assured.assd_no%TYPE,
      assd_name   giis_assured.assd_name%TYPE
   );

   TYPE giis_assured_lov_tab IS TABLE OF giis_assured_lov_type;

   TYPE gipi_polbasic_lov_type IS RECORD (
      policy_no     VARCHAR2 (50),
      bill_no       VARCHAR2 (15),
      line_cd       gipi_polbasic.line_cd%TYPE,
      subline_cd    gipi_polbasic.subline_cd%TYPE,
      iss_cd        gipi_polbasic.iss_cd%TYPE,
      issue_yy      gipi_polbasic.issue_yy%TYPE,
      pol_seq_no    VARCHAR2 (7),
      renew_no      VARCHAR2 (2),
      endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy       gipi_polbasic.endt_yy%TYPE,
      endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      endt_type     gipi_polbasic.endt_type%TYPE,
      prem_seq_no   VARCHAR2 (12)
   );

   TYPE gipi_polbasic_lov_tab IS TABLE OF gipi_polbasic_lov_type;

   FUNCTION get_gipi_invoice (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN gipi_invoice_tab PIPELINED;

   FUNCTION get_inwfacul_prem_collns (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN giac_inwfacul_prem_collns_tab PIPELINED;

   FUNCTION get_gipi_invoice_lov (
      p_prem_seq_no   VARCHAR2,
      p_ri_cd         VARCHAR2,
      p_assd_no       VARCHAR2,
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date     VARCHAR2,
      p_issue_date      VARCHAR2,
      p_expiry_date     VARCHAR2
   )
      RETURN gipi_invoice_lov_tab PIPELINED;

   FUNCTION get_reinsurer_lov (
      p_ri_cd     VARCHAR2,
      p_assd_no   VARCHAR2,
      p_line_cd   gipi_polbasic.line_cd%TYPE
   )
      RETURN giis_reinsurer_lov_tab PIPELINED;

   FUNCTION get_giis_assured_lov2 (
      p_assd_no   VARCHAR2,
      p_ri_cd     VARCHAR2,
      p_line_cd   gipi_polbasic.line_cd%TYPE
   )
      RETURN giis_assured_lov_tab PIPELINED;

   FUNCTION get_policy_no_lov (
      p_prem_seq_no   VARCHAR2,
      p_ri_cd         VARCHAR2,
      p_assd_no       VARCHAR2,
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      VARCHAR2,
      p_pol_seq_no    VARCHAR2,
      p_renew_no      VARCHAR2
   )
      RETURN gipi_polbasic_lov_tab PIPELINED;
END;
/



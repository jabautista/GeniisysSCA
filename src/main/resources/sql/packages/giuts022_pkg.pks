CREATE OR REPLACE PACKAGE CPI.GIUTS022_PKG
AS
   TYPE policy_info_type IS RECORD (
      line_cd               gipi_polbasic.line_cd%TYPE,
      subline_cd            gipi_polbasic.subline_cd%TYPE,
      iss_cd                gipi_polbasic.iss_cd%TYPE,
      issue_yy              gipi_polbasic.issue_yy%TYPE,
      pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
      renew_no              gipi_polbasic.renew_no%TYPE,
      endt_iss_cd           gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy               gipi_polbasic.endt_yy%TYPE,
      endt_seq_no           gipi_polbasic.endt_seq_no%TYPE,
      assd_name             VARCHAR (500),
      policy_id             gipi_polbasic.policy_id%TYPE,
      par_id                gipi_polbasic.par_id%TYPE,
      assd_no               gipi_polbasic.assd_no%TYPE,
      eff_date              gipi_polbasic.eff_date%TYPE,
      expiry_date           gipi_polbasic.expiry_date%TYPE,
      incept_date           gipi_polbasic.incept_date%TYPE,
      policy_no             VARCHAR (100),
      endt_no               VARCHAR (100),
      endt_type             gipi_polbasic.endt_type%TYPE, --added for optimization SR5693  10.10.2016 MarkS
      pol_flag              gipi_polbasic.pol_flag%TYPE,  --added for optimization SR5693  10.10.2016 MarkS
      count_                NUMBER,             --added for optimization SR5693  10.10.2016 MarkS
      rownum_               NUMBER              --added for optimization SR5693  10.10.2016 MarkS
   );

   TYPE policy_info_tab IS TABLE OF policy_info_type;

   TYPE payterm_type IS RECORD (
      iss_cd                gipi_invoice.iss_cd%TYPE,
      prem_seq_no           gipi_invoice.prem_seq_no%TYPE,
      item_grp              gipi_invoice.item_grp%TYPE,
      property              gipi_invoice.property%TYPE,
      remarks               gipi_invoice.remarks%TYPE,
      prem_amt              gipi_invoice.prem_amt%TYPE,
      tax_amt               gipi_invoice.tax_amt%TYPE,
      other_charges         gipi_invoice.other_charges%TYPE,
      notarial_fee          gipi_invoice.notarial_fee%TYPE,
      due_date              gipi_invoice.due_date%TYPE,
      payt_terms            gipi_invoice.payt_terms%TYPE,
      payt_terms_desc       giis_payterm.payt_terms_desc%TYPE,
      no_of_payt            giis_payterm.no_of_payt%TYPE,
      expiry_date           gipi_invoice.expiry_date%TYPE,
      policy_id             gipi_polbasic.policy_id%TYPE,
      total_amt             NUMBER
   );

   TYPE payterm_tab IS TABLE OF payterm_type;

   TYPE installment_type IS RECORD (
      iss_cd                gipi_invoice.iss_cd%TYPE,
      prem_seq_no           gipi_invoice.prem_seq_no%TYPE,
      inst_no               gipi_installment.inst_no%TYPE,
      share_pct             gipi_installment.share_pct%TYPE,
      tax_amt               gipi_installment.tax_amt%TYPE,
      prem_amt              gipi_installment.prem_amt%TYPE,
      item_grp              gipi_invoice.item_grp%TYPE,
      due_date              gipi_invoice.due_date%TYPE
   );

   TYPE installment_tab IS TABLE OF installment_type;

   TYPE tax_allocation_type IS RECORD (
      tax_id                gipi_inv_tax.tax_id%TYPE,
      prem_seq_no           gipi_inv_tax.prem_seq_no%TYPE,
      tax_cd                gipi_inv_tax.tax_cd%TYPE,
      tax_amt               gipi_inv_tax.tax_amt%TYPE,
      tax_description       VARCHAR2 (200),
      line_cd               gipi_inv_tax.line_cd%TYPE,
      iss_cd                gipi_inv_tax.iss_cd%TYPE,
      rate                  gipi_inv_tax.rate%TYPE,
      tax_allocation_desc   VARCHAR2 (50),
      tax_allocation        gipi_inv_tax.tax_allocation%TYPE,
      fixed_tax_allocation  gipi_inv_tax.fixed_tax_allocation%TYPE
   );

   TYPE tax_allocation_tab IS TABLE OF tax_allocation_type;

   TYPE incept_expiry_type IS RECORD (
      expiry_date           VARCHAR2 (50),
      incept_date           VARCHAR2 (50),
      line_cd               gipi_polbasic.line_cd%TYPE,
      subline_cd            gipi_polbasic.subline_cd%TYPE,
      iss_cd                gipi_polbasic.iss_cd%TYPE,
      issue_yy              gipi_polbasic.issue_yy%TYPE,
      pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
      renew_no              gipi_polbasic.renew_no%TYPE,
      message               VARCHAR2 (300)
   );

   TYPE incept_expiry_tab IS TABLE OF incept_expiry_type;

   FUNCTION get_policy_info (
      p_line_cd             gipi_polbasic.line_cd%TYPE,
      p_subline_cd          gipi_polbasic.subline_cd%TYPE,
      p_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_issue_yy            gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no            gipi_polbasic.renew_no%TYPE,
      p_endt_iss_cd         gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy             gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no         gipi_polbasic.endt_seq_no%TYPE,
      --added for optimization SR5693  10.10.2016 MarkS
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER,
      --end SR5693
      p_user_id             giis_users.user_id%TYPE
   )
      RETURN policy_info_tab PIPELINED;

   FUNCTION get_payterm_info (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN payterm_tab PIPELINED;

   FUNCTION get_installment_info (
      p_iss_cd              gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
      p_item_grp            gipi_invoice.item_grp%TYPE      ---added by kenneth L 06.17.2013
   )
      RETURN installment_tab PIPELINED;

   PROCEDURE update_payment_term (
      p_user_id             gipi_invoice.user_id%TYPE,
      p_iss_cd              gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
      p_item_grp            gipi_invoice.item_grp%TYPE,
      p_policy_id           gipi_invoice.policy_id%TYPE,
      p_due_date            gipi_invoice.due_date%TYPE,
      p_payt_terms_desc     giis_payterm.payt_terms_desc%TYPE,
      p_prem_amt            gipi_invoice.prem_amt%TYPE,
      p_other_charges       gipi_invoice.other_charges%TYPE,
      p_notarial_fee        gipi_invoice.notarial_fee%TYPE,
      p_tax_amt             gipi_invoice.tax_amt%TYPE
   );

   PROCEDURE update_due_date (p_installment gipi_installment%ROWTYPE);

   FUNCTION get_tax_allocation_info (
      p_iss_cd              gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
      p_item_grp            gipi_invoice.item_grp%TYPE      ---added by kenneth L 06.17.2013
   )
      RETURN tax_allocation_tab PIPELINED;

   FUNCTION validate_fully_paid (
      p_iss_cd              gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_incept_expiry (
      p_line_cd             gipi_polbasic.line_cd%TYPE,
      p_subline_cd          gipi_polbasic.subline_cd%TYPE,
      p_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_issue_yy            gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no            gipi_polbasic.renew_no%TYPE,
      p_inv_due_date        DATE
   )
      RETURN incept_expiry_tab PIPELINED;

   PROCEDURE update_due_date_invoice (
      p_due_date            gipi_invoice.due_date%TYPE,
      p_policy_id           gipi_polbasic.policy_id%TYPE
   );

   FUNCTION check_if_can_change (
      p_line_cd             giis_line.line_cd%TYPE,
      p_policy_id           gipi_polbasic.policy_id%TYPE,
      p_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE
   )
      RETURN VARCHAR2;

   PROCEDURE update_workflow_switch (
      p_event_desc   IN     VARCHAR2,
      p_module_id    IN     VARCHAR2,
      p_user         IN     VARCHAR2
   );

   PROCEDURE update_tax_amt (
      p_policy_id           gipi_invoice.policy_id%TYPE,
      p_payt_terms_desc     giis_payterm.payt_terms_desc%TYPE,
      p_iss_cd              gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
      p_tax_amt             gipi_invoice.tax_amt%TYPE
   );

   PROCEDURE update_tax_allocation (p_inv_tax gipi_inv_tax%ROWTYPE);
   
   PROCEDURE get_due_date (
      p_policy_id   IN      gipi_invoice.policy_id%TYPE,
      p_payt_term   IN      VARCHAR2,
      p_prem_seq_no IN      GIPI_INVOICE.prem_seq_no%TYPE,
      p_due_date    OUT     gipi_installment.due_date%TYPE
   );
END GIUTS022_PKG;
/

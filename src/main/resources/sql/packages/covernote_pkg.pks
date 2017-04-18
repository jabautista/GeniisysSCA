CREATE OR REPLACE PACKAGE CPI.covernote_pkg
AS
   TYPE policy_info_type IS RECORD (
      par_id             gipi_parlist.par_id%TYPE,
      --p_days             NUMBER,
      line_cd1            gipi_parlist.line_cd%TYPE,
      line_cd8           VARCHAR2 (20),
      --iss_cd             gipi_parlist.iss_cd%TYPE,
      --par_yy             gipi_parlist.par_yy%TYPE,
      --par_seq_no         gipi_parlist.par_seq_no%TYPE,
      --quote_seq_no       gipi_parlist.quote_seq_no%TYPE,
      line_cd7           VARCHAR2 (20),
      --designation        giis_assured.designation%TYPE,
       assd_name1          VARCHAR2(580),--giis_assured.assd_name%TYPE,  modified by Gzelle 10132014
      --assd_name2         giis_assured.assd_name2%TYPE,
      address1           gipi_wpolbas.address1%TYPE,
      address2           gipi_wpolbas.address2%TYPE,
      address3           gipi_wpolbas.address3%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      incept_date        gipi_wpolbas.incept_date%TYPE,
      incept_time        VARCHAR2 (20),
      expiry_date        gipi_wpolbas.expiry_date%TYPE,
      expiry_time        VARCHAR2 (20),
      ref_pol_no         gipi_wpolbas.ref_pol_no%TYPE,
      subline_time       giis_subline.subline_time%TYPE,
      assd_no            giis_assured.assd_no%TYPE,
      label_tag          VARCHAR2(50),--gipi_wpolbas.label_tag%TYPE,
      acct_of_cd         gipi_wpolbas.acct_of_cd%TYPE,
      covernote_expiry   gipi_wpolbas.covernote_expiry%TYPE
   );

   TYPE policy_info_tab IS TABLE OF policy_info_type;

   TYPE warranties_clauses_type IS RECORD (
      par_id     gipi_wpolwc.par_id%TYPE,
      wc_title   VARCHAR2 (4000)
   );

   TYPE warranties_clauses_tab IS TABLE OF warranties_clauses_type;

   TYPE peril_info_type IS RECORD (
      par_id            gipi_witmperl.par_id%TYPE,
      item_no           gipi_witmperl.item_no%TYPE, --comment by mjcustodio 08162011
      tsi_amt           gipi_witmperl.tsi_amt%TYPE,
      prem_amt          gipi_witmperl.prem_amt%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      peril_type        giis_peril.peril_type%TYPE,
      item_title        gipi_witem.item_title%TYPE,
      currency_rt       gipi_witem.currency_rt%TYPE,
      currency_cd       gipi_witem.currency_cd%TYPE,
      policy_currency   gipi_winvoice.policy_currency%TYPE
   );

   TYPE peril_info_tab IS TABLE OF peril_info_type;

   TYPE deductibles_type IS RECORD (
      par_id             gipi_wdeductibles.par_id%TYPE,
      item_no            gipi_wdeductibles.item_no%TYPE,
      deductible_title   giis_deductible_desc.deductible_title%TYPE
   );

   TYPE deductibles_tab IS TABLE OF deductibles_type;

   TYPE tax_charges_type IS RECORD (
      par_id     gipi_winvoice.par_id%TYPE,
      tax_desc   giis_tax_charges.tax_desc%TYPE,
      tax_amt   gipi_winv_tax.tax_amt%TYPE,
      item_grp   gipi_winv_tax.item_grp%TYPE
   );

   TYPE tax_charges_tab IS TABLE OF tax_charges_type;

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME: CG$Q_B240_POLICY_INFORMATION
***********************************************************************************/
   FUNCTION get_policy_info (p_par_id gipi_parlist.par_id%TYPE)
      RETURN policy_info_tab PIPELINED;

   FUNCTION get_assd_name (p_acct_of_cd IN gipi_wpolbas.acct_of_cd%TYPE)
      RETURN CHAR;

   FUNCTION get_label_tag (p_acct_of_cd IN gipi_wpolbas.acct_of_cd%TYPE)
      RETURN CHAR;

   FUNCTION get_expiry_date (
      p_incept_date   IN   gipi_wpolbas.incept_date%TYPE,
      p_incept_time        VARCHAR2
   )
      RETURN CHAR;

   FUNCTION get_expiry_date_1 (
      p_incept_date   IN   gipi_wpolbas.incept_date%TYPE,
      p_days               NUMBER,
      p_expiry_time        VARCHAR2
   )
      RETURN CHAR;

   FUNCTION get_grand_prem (cp_totalprem NUMBER, cs_1 NUMBER)
      RETURN NUMBER;

   FUNCTION get_header_text
      RETURN CHAR;

   FUNCTION get_days (p_days NUMBER)
      RETURN CHAR;

   FUNCTION get_footnote (cf_days VARCHAR2)
      RETURN CHAR;

   FUNCTION get_expiry_date_2 (
      p_line_cd        IN       gipi_wpolbas.line_cd%TYPE,
      p_incept_date    IN       gipi_wpolbas.incept_date%TYPE,
      p_days                    NUMBER,
      p_subline_time   OUT      giis_subline.subline_time%TYPE
   )
      RETURN CHAR;

   FUNCTION get_incept_date (
      p_line_cd        IN       gipi_wpolbas.line_cd%TYPE,
      p_incept_date    OUT      gipi_wpolbas.incept_date%TYPE,
      p_subline_time   OUT      giis_subline.subline_time%TYPE
   )
      RETURN CHAR;

   FUNCTION cg$cf_b2402_fmla
      RETURN NUMBER;

/********************************** FUNCTION 2 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME: CG$Q_B570_WARRRANTIES_AND_CLAUSES
***********************************************************************************/
   FUNCTION get_warranties_clauses (p_par_id gipi_wpolwc.par_id%TYPE)
      RETURN warranties_clauses_tab PIPELINED;

   FUNCTION cg$cf_b5702_fmla
      RETURN NUMBER;

/********************************** FUNCTION 3 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME: CG$Q_B490_PERILS
***********************************************************************************/
   FUNCTION get_peril_info (p_par_id gipi_witmperl.par_id%TYPE)
      RETURN peril_info_tab PIPELINED;

   FUNCTION get_tsi_spell (
      p_currency_cd   IN   GIPI_WITEM.CURRENCY_CD%TYPE,
      cf_total_tsi         NUMBER
   )
      RETURN CHAR;

   FUNCTION get_total_prem (cp_totalprem OUT NUMBER, cs_totalprem NUMBER)
      RETURN NUMBER;

   FUNCTION get_total_tsi (p_par_id IN gipi_witmperl.par_id%TYPE)
      RETURN NUMBER;

   FUNCTION get_total_tsi_1 (
      p_peril_type   IN   giis_peril.peril_type%TYPE,
      cs_tsiamt           NUMBER
   )
      RETURN NUMBER;

   FUNCTION cg$cf_b4902_fmla
      RETURN NUMBER;

   FUNCTION get_prem_curr (
      p_policy_currency   IN       gipi_winvoice.policy_currency%TYPE,
      p_prem_amt          IN         gipi_witmperl.prem_amt%TYPE,
      p_currency_rt       IN        gipi_witem.currency_rt%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_tsi_curr (
      p_policy_currency   IN       gipi_winvoice.policy_currency%TYPE,
      p_tsi_amt           IN      gipi_witmperl.tsi_amt%TYPE,
      p_currency_rt       IN      gipi_witem.currency_rt%TYPE
   )
      RETURN NUMBER;

/********************************** FUNCTION 4 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME: CG$Q_B350_DEDUCTIONS
***********************************************************************************/
   FUNCTION get_deductibles (p_par_id gipi_wdeductibles.par_id%TYPE)
      RETURN deductibles_tab PIPELINED;

   FUNCTION cg$cf_b3502_fmla
      RETURN NUMBER;

   FUNCTION get_ded_count (
      v_ded_count                NUMBER,
      --cp_dedcount          OUT      NUMBER,
      p_deductible_title   IN         giis_deductible_desc.deductible_title%TYPE
   )
      RETURN VARCHAR2;

/********************************** FUNCTION 5 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME: CG$Q_B450_TAX_CHARGES
***********************************************************************************/
   FUNCTION get_tax_charges (p_par_id gipi_winvoice.par_id%TYPE)
      RETURN tax_charges_tab PIPELINED;

   FUNCTION cg$cf_b4502_fmla
      RETURN NUMBER;

   FUNCTION get_tax (cp_tax OUT NUMBER, cs_totaltax NUMBER)
      RETURN NUMBER;

/********************************** FUNCTION 6 ************************************
  MODULE: GIPIR919
  RECORD GROUP NAME:
***********************************************************************************/
   FUNCTION get_agent_code (p_par_id IN gipi_wcomm_invoices.par_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_company_name
      RETURN VARCHAR2;

   FUNCTION get_signatory (p_par_id IN gipi_parlist.par_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_position (p_par_id IN gipi_parlist.par_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_item_title (p_par_id IN gipi_witem.par_id%TYPE)
      RETURN CHAR;

   FUNCTION get_item_desc (p_par_id IN gipi_witem.par_id%TYPE)
      RETURN CHAR;

   FUNCTION get_location (p_par_id IN gipi_wfireitm.par_id%TYPE)
      RETURN CHAR;

   FUNCTION get_user
      RETURN VARCHAR2;

END covernote_pkg;
/



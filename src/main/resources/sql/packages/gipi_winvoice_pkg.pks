CREATE OR REPLACE PACKAGE CPI.gipi_winvoice_pkg
AS
   TYPE gipi_winvoice_type IS RECORD (
      par_id                 gipi_winvoice.par_id%TYPE,
      item_grp               gipi_winvoice.item_grp%TYPE,
      insured                gipi_winvoice.insured%TYPE,
      property               gipi_winvoice.property%TYPE,
      takeup_seq_no          gipi_winvoice.takeup_seq_no%TYPE,
      multi_booking_mm       gipi_winvoice.multi_booking_mm%TYPE,
      multi_booking_mm_num   NUMBER,               --added by cris 02/22/2010
      multi_booking_yy       gipi_winvoice.multi_booking_yy%TYPE,
      multi_booking_date     VARCHAR2 (50),        --added by cris 02/22/2010
      ref_inv_no             gipi_winvoice.ref_inv_no%TYPE,
      policy_currency        gipi_winvoice.policy_currency%TYPE,
      payt_terms             gipi_winvoice.payt_terms%TYPE,
      payt_terms_desc        giis_payterm.payt_terms_desc%TYPE,
      no_of_payt             giis_payterm.no_of_payt%TYPE,
--    no_of_takeup   GIIS_PAYTERM.no_of_payt%TYPE,
      no_of_takeup           giis_takeup_term.no_of_takeup%TYPE,
      due_date               gipi_winvoice.due_date%TYPE,
      other_charges          gipi_winvoice.other_charges%TYPE,
      tax_amt                gipi_winvoice.tax_amt%TYPE,
      prem_amt               gipi_winvoice.prem_amt%TYPE,
      prem_seq_no            gipi_winvoice.prem_seq_no%TYPE,
      currency_desc          giis_currency.currency_desc%TYPE,
      currency_rt            giis_currency.currency_rt%TYPE,
      remarks                gipi_winvoice.remarks%TYPE,
      ri_comm_amt            gipi_winvoice.ri_comm_amt%TYPE,
      pay_type               gipi_winvoice.pay_type%TYPE,
      card_name              gipi_winvoice.card_name%TYPE,
      card_no                gipi_winvoice.card_no%TYPE,
      expiry_date            gipi_winvoice.expiry_date%TYPE,
      endt_expiry_date       gipi_wpolbas.endt_expiry_date%TYPE,
                                                     --tonio february 2, 2011
      wpolbas_expiry_date    gipi_wpolbas.expiry_date%TYPE,
                                                     --tonio february 2, 2011
      eff_date               gipi_wpolbas.eff_date%TYPE,
                                                     --tonio february 2, 2011
      incept_date            gipi_wpolbas.incept_date%TYPE,
      --added by cris 02/18/2010
      approval_cd            gipi_winvoice.approval_cd%TYPE,
      ri_comm_vat            gipi_winvoice.ri_comm_vat%TYPE,
      changed_tag            gipi_winvoice.changed_tag%TYPE,
      amount_due             gipi_winvoice.bond_tsi_amt%TYPE,
      bond_tsi_amt           gipi_winvoice.bond_tsi_amt%TYPE,
      --added by tonio 11/10/2010
      bond_rate              gipi_winvoice.bond_rate%TYPE,
   --added by tonio 11/10/2010
	  no_of_days			giis_payterm.no_of_days%type,
	  --added by christian 08/17/2012
	  ri_comm_rt			gipi_witmperl.ri_comm_rate%type
   );
   TYPE gipi_winvoice_type2 IS RECORD (
      par_id             gipi_winvoice.par_id%TYPE,
      item_grp           gipi_winvoice.item_grp%TYPE,
      takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE,
      multi_booking_mm   gipi_winvoice.multi_booking_mm%TYPE,
      multi_booking_yy   gipi_winvoice.multi_booking_yy%TYPE,
      insured            giis_assured.assd_name%TYPE
   );
   TYPE gipi_winvoice_type3 IS RECORD (
      par_id          gipi_winvoice.par_id%TYPE,
      item_grp        gipi_winvoice.item_grp%TYPE,
      property        gipi_winvoice.property%TYPE,
      insured         gipi_winvoice.insured%TYPE,
      ref_inv_no      gipi_winvoice.ref_inv_no%TYPE,
      prem_amt        gipi_winvoice.prem_amt%TYPE,
      tax_amt         gipi_winvoice.tax_amt%TYPE,
      other_charges   gipi_winvoice.other_charges%TYPE,
      currency_cd     gipi_winvoice.currency_cd%TYPE,
      currency_desc   giis_currency.currency_desc%TYPE,
      amount_due      NUMBER
   );
   TYPE gipi_winvoice_tab IS TABLE OF gipi_winvoice_type;
   TYPE gipi_winvoice_tab2 IS TABLE OF gipi_winvoice_type2;
   TYPE gipi_winvoice_tab3 IS TABLE OF gipi_winvoice_type3;
   TYPE gipi_winvoice_cur IS REF CURSOR
      RETURN gipi_winvoice_type2;
   TYPE rc_gipi_winvoice_cur IS REF CURSOR
      RETURN gipi_winvoice_type;
   FUNCTION get_gipi_winvoice (
      p_par_id     gipi_winvoice.par_id%TYPE,
      p_item_grp   gipi_winvoice.item_grp%TYPE
   )
      RETURN gipi_winvoice_tab PIPELINED;
   --added steven 07.22.2014
   FUNCTION get_range_amt (
      p_tax_cd             /*NUMBER*/ giis_tax_charges.tax_cd%TYPE ,   
      p_tax_id              giis_tax_charges.tax_id%TYPE ,                -- jhing 11.09.2014 added new field
      p_par_id             /*NUMBER,*/ gipi_parlist.par_id%TYPE ,      -- jhing 11.09.2014 modified declaration
      p_prem_amt           /*NUMBER,*/ gipi_winvoice.prem_amt%TYPE ,  -- jhing 11.09.2014 modified declaration
      p_item_grp           gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE,
      p_takeup_alloc_tag   /*VARCHAR2*/ giis_tax_charges.takeup_alloc_tag%TYPE  -- jhing 11.09.2014 modified declaration
   )
      RETURN NUMBER;
   FUNCTION get_rate_amt ( 
      p_tax_cd             /*NUMBER*/ giis_tax_charges.tax_cd%TYPE ,  -- jhing 11.09.2014 modified declaration
      p_tax_id             giis_tax_charges.tax_id%TYPE,   -- jhing 11.09.2014
      p_par_id             /*NUMBER,*/ gipi_parlist.par_id%TYPE ,   -- jhing 11.09.2014 modified declaration
      p_item_grp           gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE
   )
      RETURN NUMBER;
   -- added by jhing 11.07.2014 
   FUNCTION get_DocStamps_TaxAmt (
      p_tax_cd             giis_tax_charges.tax_cd%TYPE ,
      p_tax_id             giis_tax_charges.tax_id%TYPE,
      p_par_id             gipi_wpolbas.par_id%TYPE,
      p_prem_amt           gipi_winvoice.prem_amt%TYPE,
      p_item_grp           gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE,
      p_takeup_alloc_tag   giis_tax_charges.takeup_alloc_tag%TYPE 
    )
    RETURN NUMBER ;    
   -- added by jhing 11.08.2014 
   FUNCTION get_Fixed_Amount_Tax (
      p_tax_cd             giis_tax_charges.tax_cd%TYPE ,
      p_tax_id             giis_tax_charges.tax_id%TYPE,
      p_par_id             gipi_wpolbas.par_id%TYPE,
      p_prem_amt           gipi_winvoice.prem_amt%TYPE,
      p_tax_amt            giis_tax_charges.tax_amount%TYPE,
      p_item_grp           gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE,
      p_takeup_alloc_tag   giis_tax_charges.takeup_alloc_tag%TYPE 
    )
       RETURN NUMBER ;          
   -- added by jhing 11.11.2014 
   FUNCTION get_Comp_TaxAmt (
      p_tax_cd             giis_tax_charges.tax_cd%TYPE ,
      p_tax_id             giis_tax_charges.tax_id%TYPE,
      p_par_id             gipi_wpolbas.par_id%TYPE,
      p_item_grp           gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE
    )
       RETURN NUMBER ;         
   /**
   * Modified by: Emman 04.27.10
   * Get gipi_winvoice using par_id only as parameter
   */
   FUNCTION get_gipi_winvoice2 (p_par_id gipi_winvoice.par_id%TYPE)
      RETURN gipi_winvoice_tab2 PIPELINED;
   FUNCTION get_gipi_winvoice3 (p_par_id gipi_winvoice.par_id%TYPE)
      RETURN gipi_winvoice_tab PIPELINED;
   PROCEDURE set_gipi_winvoice (p_winvoice gipi_winvoice%ROWTYPE);
   PROCEDURE del_gipi_winvoice (p_par_id IN gipi_winvoice.par_id%TYPE);
   -- p_item_grp    IN  GIPI_WINVOICE.item_grp%TYPE); comment by cris 2/5/10
   /*
   function added by cris: 02/04/2010
   */
   FUNCTION get_distinct_gipi_winvoice (p_par_id gipi_winvoice.par_id%TYPE)
      RETURN gipi_winvoice_tab PIPELINED;
   PROCEDURE update_paytterms_gipi_winvoice (
      p_par_id          gipi_winvoice.par_id%TYPE,
      p_item_grp        gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no   gipi_winvoice.takeup_seq_no%TYPE,
      p_payt_terms      gipi_winvoice.payt_terms%TYPE,
      p_tax_amt         gipi_winvoice.tax_amt%TYPE,
      p_other_charges   gipi_winvoice.other_charges%TYPE,
      p_due_date        gipi_winvoice.due_date%TYPE
   );
   PROCEDURE get_gipi_winvoice_exist (
      p_par_id   IN       gipi_winvoice.par_id%TYPE,
      p_exist    OUT      NUMBER
   );
   PROCEDURE get_gipi_winvoice_exist2 (
      p_par_id   IN       gipi_winvoice.par_id%TYPE,
      p_exist    OUT      NUMBER
   );
   PROCEDURE del_gipi_winvoice1 (p_par_id IN gipi_winvoice.par_id%TYPE);
/***************************************************************************/
/*
** Transfered by: whofeih
** Date: 06.10.2010
** for GIPIS050A
*/
   PROCEDURE create_gipi_winvoice (p_par_id IN NUMBER);
/***************************************************************************/
   --******Anthony Santos Nov 9, 2010*********-
   TYPE gipi_winvoice_bond_type IS RECORD (
      bond_tsi_amt       gipi_winvoice.bond_tsi_amt%TYPE,
      bond_rate          gipi_winvoice.bond_rate%TYPE,
      prem_amt           gipi_winvoice.prem_amt%TYPE,
      ri_comm_amt        gipi_winvoice.ri_comm_amt%TYPE,
      ri_comm_vat        gipi_winvoice.ri_comm_vat%TYPE,
      tax_amt            gipi_winvoice.tax_amt%TYPE,
      ri_comm_rt         gipi_witmperl.ri_comm_rate%TYPE,
      total_amount_due   gipi_winvoice.prem_amt%TYPE,
      takeup_seq_no      gipi_winvoice.takeup_seq_no%TYPE,
      input_vat_rate     giis_reinsurer.input_vat_rate%TYPE
   );
   TYPE gipi_winvoice_bond_tab IS TABLE OF gipi_winvoice_bond_type;
   FUNCTION get_winvoice_bond_dtls (
      p_par_id   gipi_winvoice.par_id%TYPE,
      p_iss_cd   VARCHAR2
   )
      RETURN gipi_winvoice_bond_tab PIPELINED;
   PROCEDURE get_gipi_winvoice_takeup_dtls (
      p_par_id                  NUMBER,
      p_line_cd                 gipi_parlist.line_cd%TYPE,
      p_iss_cd                  gipi_parlist.iss_cd%TYPE,
      p_item_grp                gipi_winvoice.item_grp%TYPE,
      p_takeup_list    OUT      gipi_winvoice_pkg.rc_gipi_winvoice_cur,
      p_bond_tsi_amt   IN OUT   gipi_winvoice.bond_tsi_amt%TYPE,
      p_prem_amt       IN OUT   gipi_winvoice.prem_amt%TYPE,
      p_ri_comm_rt     IN OUT   NUMBER,
      p_bond_rate      IN OUT   gipi_winvoice.bond_rate%TYPE,
      p_ri_comm_amt    IN OUT   gipi_winvoice.ri_comm_amt%TYPE,
      p_ri_comm_vat    IN OUT   gipi_winvoice.ri_comm_vat%TYPE,
      p_tax_amt        IN OUT   gipi_winvoice.tax_amt%TYPE,
      p_message        OUT      VARCHAR2
   );
   PROCEDURE check_gipi_winvoice_for_pack (
      p_pack_par_id   IN       gipi_pack_parlist.pack_par_id%TYPE,
      p_exist         OUT      NUMBER
   );
   PROCEDURE post_forms_commit_gipis026 (
      p_par_id                     gipi_parlist.par_id%TYPE,
      p_pack_par_id                gipi_parlist.pack_par_id%TYPE,
      p_global_pack_par_id         gipi_parlist.pack_par_id%TYPE,
      p_item_grp                   gipi_winvoice.item_grp%TYPE,
      p_takeup_seq_no              gipi_winvoice.takeup_seq_no%TYPE,
      p_ri_comm_vat                gipi_winvoice.ri_comm_vat%TYPE,
      p_version                    VARCHAR2 DEFAULT '1',
      p_due_date                   VARCHAR2,
      p_line_cd                    VARCHAR2,
      p_temp_inst_cur        OUT   gipi_winstallment_pkg.gipi_winstallment_cur,
      p_booking_yy                 gipi_wpolbas.booking_year%TYPE, --belle 09022012
      p_booking_mm                 gipi_wpolbas.booking_mth%TYPE 
   );
   PROCEDURE post_frm_commit_gipis017b (
      p_par_id                  gipi_parlist.par_id%TYPE,
      p_bond_tsi_amt   IN       gipi_winvoice.bond_tsi_amt%TYPE,
      p_prem_amt       IN       gipi_winvoice.prem_amt%TYPE,
      p_bond_rate      IN       gipi_winvoice.bond_rate%TYPE,
      p_iss_cd         IN       gipi_parlist.iss_cd%TYPE,
      p_pay_term       IN       giis_payterm.payt_terms%TYPE,
      p_tax_amt        IN       gipi_winvoice.tax_amt%TYPE,
      p_message        OUT      VARCHAR2,
      p_booking_yy              gipi_wpolbas.booking_year%TYPE, --belle 09022012
      p_booking_mm              gipi_wpolbas.booking_mth%TYPE 
   );
   PROCEDURE del_gipi_winvoice2 (
      p_par_id     IN   gipi_winvoice.par_id%TYPE,
      p_item_grp   IN   gipi_winvoice.item_grp%TYPE
   );
   FUNCTION get_lead_pol_winvoice (p_par_id gipi_winvoice.par_id%TYPE)
      RETURN gipi_winvoice_tab3 PIPELINED;
   FUNCTION get_pack_gipi_winvoice (
      p_pack_par_id   gipi_parlist.pack_par_id%TYPE
   )
      RETURN gipi_winvoice_tab2 PIPELINED;
   PROCEDURE get_annual_amount (
      p_par_id         IN       gipi_parlist.par_id%TYPE,
      p_line_cd        IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN       gipi_polbasic.renew_no%TYPE,
      p_ann_tsi_amt    OUT      gipi_polbasic.ann_tsi_amt%TYPE,
      p_ann_prem_amt   OUT      gipi_polbasic.ann_prem_amt%TYPE,
      p_exist_sw       OUT      VARCHAR2
   );
   /**
       Created By Irwin Tabisora
       Date: Nov. 29, 2011
       Description: Post Form Commit for item Group items
   */
   PROCEDURE post_frm_gipis012_group (
      p_par_id    IN   NUMBER,
      p_line_cd   IN   VARCHAR2,
      p_iss_cd    IN   VARCHAR2
   );
   PROCEDURE post_frm_commit_gipis165b (
      p_par_id                  gipi_parlist.par_id%TYPE,
      p_bond_tsi_amt   IN       gipi_winvoice.bond_tsi_amt%TYPE,
      p_prem_amt       IN       gipi_winvoice.prem_amt%TYPE,
      p_bond_rate      IN       gipi_winvoice.bond_rate%TYPE,
      p_iss_cd         IN       gipi_parlist.iss_cd%TYPE,
      p_pay_term       IN       giis_payterm.payt_terms%TYPE,
      p_tax_amt        IN       gipi_winvoice.tax_amt%TYPE,
      p_ann_tsi        IN       gipi_wpolbas.ann_tsi_amt%TYPE,
      p_ann_prem       IN       gipi_wpolbas.ann_prem_amt%TYPE,
      p_message        OUT      VARCHAR2
   );
   PROCEDURE validate_bond_due_date1(
        p_due_date		    IN OUT  VARCHAR2,
        p_eff_date		    IN      VARCHAR2,
        p_issue_date       IN       VARCHAR2, --apollo cruz sr#19975
        p_expiry_date		IN      VARCHAR2,
        p_org_due_date      IN      VARCHAR2,
        p_takeup_seq_no     IN      NUMBER,
        p_info_msg          OUT     VARCHAR2 
   );
   PROCEDURE validate_bond_due_date2(
        p_due_date		    IN  VARCHAR2,
        p_n_due_date        IN  VARCHAR2,    
        p_takeup_seq_no     IN  NUMBER,
        p_n_takeup_seq_no   IN  NUMBER,
        p_info_msg          OUT VARCHAR2    
   );
   PROCEDURE delete_wdist_tables(
      p_par_id          giuw_pol_dist.par_id%TYPE
   );
   FUNCTION check_for_posted_binders(
      p_par_id          giuw_pol_dist.par_id%TYPE
   ) RETURN VARCHAR2;
   --added by robert GENQA 4828 08.27.15
   PROCEDURE auto_compute_bond_prem(
      p_par_id          gipi_wpolbas.par_id%TYPE
   );
   -- end robert GENQA 4828 08.27.15
END gipi_winvoice_pkg;
/



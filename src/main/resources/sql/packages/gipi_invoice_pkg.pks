CREATE OR REPLACE PACKAGE CPI.GIPI_INVOICE_PKG AS
  TYPE gipi_pol_invoice_type IS RECORD (
  
    policy_id               GIPI_INVOICE.policy_id%TYPE,
    item_grp                GIPI_INVOICE.item_grp%TYPE,
    iss_cd                  GIPI_INVOICE.iss_cd%TYPE,
    insured                 GIPI_INVOICE.insured%TYPE,
    remarks                 GIPI_INVOICE.remarks%TYPE,
    tax_amt                 GIPI_INVOICE.tax_amt%TYPE,
    prem_amt                GIPI_INVOICE.prem_amt%TYPE,
    property                GIPI_INVOICE.property%TYPE,
    ref_inv_no              GIPI_INVOICE.ref_inv_no%TYPE,
    prem_seq_no             GIPI_INVOICE.prem_seq_no%TYPE,
    other_charges           GIPI_INVOICE.other_charges%TYPE,
    currency_desc           GIIS_CURRENCY.currency_desc%TYPE,
    amount_due              NUMBER,
    
    orig_par_id             GIPI_ORIG_INVOICE.par_id%TYPE,
    orig_iss_cd             GIPI_ORIG_INVOICE.iss_cd%TYPE,
    orig_insured            GIPI_ORIG_INVOICE.insured%TYPE,
    orig_tax_amt            GIPI_ORIG_INVOICE.tax_amt%TYPE,
    orig_remarks            GIPI_ORIG_INVOICE.remarks%TYPE,
    orig_prem_amt           GIPI_ORIG_INVOICE.prem_amt%TYPE,
    orig_ref_inv_no         GIPI_ORIG_INVOICE.ref_inv_no%TYPE,
    orig_prem_seq_no        GIPI_ORIG_INVOICE.prem_seq_no%TYPE,
    orig_other_charges      GIPI_ORIG_INVOICE.other_charges%TYPE,
    orig_currency_desc       GIIS_CURRENCY.currency_desc%TYPE,
    orig_amount_due         NUMBER,
     
    prem_coll_mode          VARCHAR2(50)
    
  );
    
  TYPE gipi_pol_invoice_tab IS TABLE OF gipi_pol_invoice_type;
  
  TYPE gipi_invoice_taxes_type IS RECORD (
    tax_cd          GIPI_INV_TAX.tax_cd%TYPE,
    iss_cd          GIPI_INVOICE.iss_cd%TYPE,
    prem_seq_no     GIPI_INVOICE.prem_seq_no%TYPE,
    tax_desc        GIIS_TAX_CHARGES.tax_desc%TYPE,
    tax_amt         GIPI_INV_TAX.tax_amt%TYPE
  );
  
  TYPE gipi_invoice_taxes_tab IS TABLE OF gipi_invoice_taxes_type;
  
  /**
  * Rey Jadlocon
  * 07.29.2011
  * for bill premium main query 
  */
  TYPE bill_premium_type IS RECORD(
      policy_id        gipi_invoice.policy_id%TYPE,
      prem_seq_no      gipi_invoice.prem_seq_no%TYPE,
      item_grp         GIPI_INVOICE.ITEM_GRP%TYPE,
      insured          GIPI_INVOICE.INSURED%TYPE,
      property         GIPI_INVOICE.PROPERTY%TYPE,
      payt_terms       GIPI_INVOICE.PAYT_TERMS%TYPE,
      due_date         GIPI_INVOICE.DUE_DATE%TYPE,
      currency_rt      GIPI_INVOICE.CURRENCY_RT%TYPE,
      policy_currency  GIPI_INVOICE.POLICY_CURRENCY%TYPE,
      remarks          GIPI_INVOICE.REMARKS%TYPE,
      ref_inv_no       GIPI_INVOICE.REF_INV_NO%TYPE,
      other_charges    GIPI_INVOICE.OTHER_CHARGES%TYPE,
      ri_comm_vat      GIPI_INVOICE.RI_COMM_VAT%TYPE,
      ri_comm_amt      GIPI_INVOICE.RI_COMM_AMT%TYPE,
      multi_booking_yy GIPI_INVOICE.MULTI_BOOKING_YY%TYPE,
      multi_booking_mm GIPI_INVOICE.MULTI_BOOKING_MM%TYPE,
      acct_ent_date    GIPI_INVOICE.ACCT_ENT_DATE%TYPE,
      user_id          GIPI_INVOICE.USER_ID%TYPE,
      last_upd_date    GIPI_INVOICE.LAST_UPD_DATE%TYPE,
      amount_due       NUMBER(18, 2),
      iss_cd           GIPI_POLBASIC.ISS_CD%TYPE,
      bill_no          VARCHAR2 (50),
      multi_booking_dt VARCHAR2 (100),
      tax_sum          GIPI_INVOICE.TAX_AMT%TYPE,
      currency_desc    GIIS_CURRENCY.CURRENCY_DESC%TYPE,
      ann_prem_amt     GIPI_ITEM.ANN_PREM_AMT%TYPE,
      ann_tsi_amt      GIPI_ITEM.ANN_TSI_AMT%TYPE,
      tsi_amt          GIPI_ITEM.TSI_AMT%TYPE,
      line_cd          VARCHAR2 (50),
      item_no          GIPI_ITEM.item_no%TYPE,
      item_title       GIPI_ITEM.item_title%TYPE,
      item_prem_amt    GIPI_ITEM.prem_amt%TYPE, -- added by: Nica 05.15.2013
      grp_prem_amt     GIPI_ITEM.ann_prem_amt%TYPE,
      str_due_date     VARCHAR2 (50) -- added by: Angelo 04.22.2014
      );
    
    TYPE bill_premium_tab IS TABLE OF bill_premium_type;
    
    TYPE gipi_invoice_type1 IS RECORD (
        invoice_no      VARCHAR2 (50),
        balance_due     GIAC_AGING_SOA_DETAILS.balance_amt_due%TYPE,
        due_date        GIPI_INVOICE.due_date%TYPE
    );
  
    TYPE gipi_invoice_tab1 IS TABLE OF gipi_invoice_type1;
  
  FUNCTION get_pol_invoice(p_policy_id  GIPI_POLBASIC.policy_id%TYPE)
     
    RETURN gipi_pol_invoice_tab PIPELINED;
  /**
  * Rey Jadlocon
  * 07.29.2011
  * for bill premium main query
  */  
  FUNCTION get_bill_premium_main(
             p_policy_id    GIPI_INVOICE.POLICY_ID%TYPE)
  RETURN bill_premium_tab PIPELINED;
  
  FUNCTION get_invoice_taxes (
    --p_policy_id     GIPI_INVOICE.policy_id%TYPE,
    p_prem_seq_no   GIPI_INVOICE.prem_seq_no%TYPE,
    p_iss_cd        GIPI_POLBASIC.iss_cd%TYPE
   -- p_item_no       GIPI_WITEM.item_no%TYPE,
    --p_peril_cd      GIIS_PERIL.peril_cd%TYPE
  ) RETURN gipi_invoice_taxes_tab PIPELINED;
  
  /**
  * Rey Jadlocon
  * 08.01.2011
  * bill tax list
  **/
  
  TYPE bill_tax_type IS RECORD(
     tax_cd         GIPI_INV_TAX.TAX_CD%TYPE,
     tax_id         GIPI_INV_TAX.TAX_ID%TYPE,
     tax_desc       GIIS_TAX_CHARGES.TAX_DESC%TYPE,
     prem_seq_no    GIPI_INVOICE.PREM_SEQ_NO%TYPE,
     tax_amt        GIPI_INVOICE.TAX_AMT%TYPE,
     tax_sum        GIPI_INVOICE.TAX_AMT%TYPE
    );
    TYPE bill_tax_tab IS TABLE OF bill_tax_type;
    
	FUNCTION get_bill_tax_list(
		p_policy_id   GIPI_INVOICE.policy_id%TYPE,
		p_item_no	  GIPI_ITEM.item_no%TYPE,
		p_item_grp    GIPI_INVOICE.item_grp%TYPE
	)
	  RETURN bill_tax_tab PIPELINED;
  
  FUNCTION get_multi_booking_dt_by_policy  (p_policy_id   GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                              p_dist_no     GIPI_POLBASIC_POL_DIST_V1.dist_no%TYPE)
      RETURN VARCHAR2;
      
  FUNCTION populate_basic_details(
        p_pack_policy_id  gipi_polbasic.pack_policy_id%TYPE,
        p_policy_id       gipi_polbasic.policy_id%TYPE
    )
  RETURN gipi_invoice_tab1 PIPELINED;
  
/**
* Rey Jadlocon
* 10-11-2011
**/
TYPE bond_bill_details_type IS RECORD(
        bond_tsi_amt            gipi_invoice.bond_tsi_amt%TYPE,
        bond_rate               gipi_invoice.bond_rate%TYPE,
        tax_amt                 gipi_invoice.tax_amt%TYPE,
        payt_terms              gipi_invoice.payt_terms%TYPE,
        notarial_fee            gipi_invoice.notarial_fee%TYPE,
        iss_cd                  gipi_invoice.iss_cd%TYPE,
        prem_seq_no             gipi_invoice.prem_seq_no%TYPE,
        ref_inv_no              gipi_invoice.ref_inv_no%TYPE,
        prem_amt                gipi_invoice.prem_amt%TYPE,
        remarks                 gipi_invoice.remarks%TYPE,
        total_amt_due           gipi_invoice.prem_amt%TYPE,
        ri_comm_rate            gipi_itmperil.ri_comm_rate%TYPE,
         --added by hdrtagudin 07222015 SR 19824
        ri_comm_amt             gipi_invoice.ri_comm_amt%TYPE,
        ri_comm_vat             gipi_invoice.ri_comm_vat%TYPE
 );
 
 TYPE bond_bill_details_tab IS TABLE OF bond_bill_details_type;
 
 FUNCTION get_bond_bill_details(p_policy_id          gipi_invoice.policy_id%TYPE)
            RETURN bond_bill_details_tab PIPELINED;
 
 /**
 * Rey Jadlocon
 * 10-11-2011
 **/
 
 TYPE bond_bill_tax_list_type IS RECORD(
            tax_cd          gipi_inv_tax.tax_cd%TYPE,
            tax_desc        giis_tax_charges.tax_desc%TYPE,
            tax_amt         gipi_inv_tax.tax_amt%TYPE
        );
        
   TYPE bond_bill_tax_list_tab IS TABLE OF bond_bill_tax_list_type;
   
FUNCTION get_bond_bill_tax_list(p_policy_id         gipi_invoice.policy_id%TYPE)
            RETURN bond_bill_tax_list_tab PIPELINED;


    /*  Created by:     Chri\stian Santos
    **  Date Created:   04/24/2013
    */ 
    TYPE giacs408_bill_no_list_type IS RECORD(
        iss_cd              gipi_invoice.iss_cd%TYPE,
        prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
        policy_id           gipi_invoice.policy_id%TYPE,
        prem_amt            gipi_invoice.prem_amt%TYPE
     );
     
    TYPE giacs408_bill_no_list_tab IS TABLE OF giacs408_bill_no_list_type;
    
    FUNCTION get_giacs408_bill_no(
      p_iss_cd      gipi_invoice.iss_cd%TYPE, 
      p_user_id giis_users.user_id%TYPE)
    RETURN giacs408_bill_no_list_tab PIPELINED;
    
    FUNCTION get_giacs408_iss_cd(
      p_iss_cd      gipi_invoice.iss_cd%TYPE, 
      p_user_id giis_users.user_id%TYPE)
    RETURN giacs408_bill_no_list_tab PIPELINED;
    
    TYPE gipis156_invoice_type IS RECORD (
       prem_seq_no          gipi_invoice.prem_seq_no%TYPE,
       policy_id            gipi_invoice.policy_id%TYPE,
       multi_booking_yy     gipi_invoice.multi_booking_yy%TYPE,
       multi_booking_mm     gipi_invoice.multi_booking_mm%TYPE,
       acct_ent_date        gipi_invoice.acct_ent_date%TYPE,
       takeup_seq_no        gipi_invoice.takeup_seq_no%TYPE,
       iss_cd               gipi_invoice.iss_cd%TYPE,
       item_grp             gipi_invoice.item_grp%TYPE       
    );
    
    TYPE gipis156_invoice_tab IS TABLE OF gipis156_invoice_type;
    
    FUNCTION get_gipis156_invoice (
       p_policy_id  VARCHAR2
    )
       RETURN gipis156_invoice_tab PIPELINED;      
    
    -- for GIPIS137: View Invoice Information
    TYPE invoice_dtl_type IS RECORD(
        line_cd             gipi_polbasic.line_cd%TYPE,
        subline_cd          gipi_polbasic.subline_cd%TYPE,
        cred_branch         gipi_polbasic.cred_branch%TYPE,
        iss_cd              gipi_invoice.iss_cd%TYPE,
        prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
        item_grp            gipi_invoice.item_grp%TYPE,
        prem_amt            gipi_invoice.prem_amt%TYPE,
        tax_amt             gipi_invoice.tax_amt%TYPE,
        other_charges       gipi_invoice.other_charges%TYPE,
        total_amt_due       NUMBER(20,2), --gipi_invoice.iss_cd%TYPE,
        policy_no           VARCHAR2(100), --gipi_invoice.iss_cd%TYPE,
        endt_no             VARCHAR2(100), --gipi_invoice.iss_cd%TYPE,
        invoice_no          VARCHAR2(100),
        currency_cd         gipi_invoice.currency_cd%TYPE,
        currency_desc       giis_currency.currency_desc%TYPE,
        currency_rate       gipi_invoice.currency_rt%TYPE,
        assd_name           giis_assured.assd_name%TYPE,
        property            gipi_invoice.property%TYPE,
        payt_terms          GIPI_INVOICE.PAYT_TERMS%TYPE,
        payt_terms_Desc     giis_payterm.payt_terms_desc%TYPE,
        remarks             gipi_invoice.remarks%TYPE
    );
    
    TYPE invoice_dtl_tab IS TABLE OF invoice_dtl_type;
    
    FUNCTION get_invoice_list(
        p_user_id       giis_users.user_id%TYPE
    ) RETURN invoice_dtl_tab PIPELINED;
    
END GIPI_INVOICE_PKG;
/



CREATE OR REPLACE PACKAGE CPI.pivot_records
AS
   TYPE crr_mikel_type IS RECORD (
      payment_term       VARCHAR2 (20),
      assured_name       VARCHAR2 (500),
      policy_no          VARCHAR2 (50),
      reference_no       VARCHAR2 (50),
      invoice_no         VARCHAR2 (14),
      inst_no            giac_direct_prem_collns.inst_no%TYPE,
      bal_amt_due        giac_aging_soa_details.balance_amt_due%TYPE,
      prem_bal_due       giac_aging_soa_details.prem_balance_due%TYPE,
      tax_bal_due        giac_aging_soa_details.tax_balance_due%TYPE,
      inv_prem           gipi_invoice.prem_amt%TYPE,
      inv_tax            gipi_invoice.tax_amt%TYPE,
      --b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      --b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      prem_paid          giac_direct_prem_collns.premium_amt%TYPE,
      tax_paid           giac_direct_prem_collns.tax_amt%TYPE,
      inv_evat           gipi_inv_tax.tax_amt%TYPE,
      evat_paid          giac_tax_collns.tax_amt%TYPE,
      evat_should_be     giac_tax_collns.tax_amt%TYPE,
      evat_discrep       giac_tax_collns.tax_amt%TYPE,
      inv_comm           gipi_comm_invoice.commission_amt%TYPE,
      comm_paid          giac_comm_payts.comm_amt%TYPE,
      comm_discrep       giac_comm_payts.comm_amt%TYPE,
      user_id            giac_direct_prem_collns.user_id%TYPE,
      last_update        giac_direct_prem_collns.last_update%TYPE,
      gacc_tran_id       giac_direct_prem_collns.gacc_tran_id%TYPE,
      transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
      collection_amt     giac_direct_prem_collns.collection_amt%TYPE,
      b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      or_date            DATE,
      posting_date       DATE
   );

   TYPE mikel_type IS TABLE OF crr_mikel_type;

   TYPE crr_mikel_type2 IS RECORD (
      payment_term     VARCHAR2 (20),
      assured_name     VARCHAR2 (500),
      policy_no        VARCHAR2 (50),
      reference_no     VARCHAR2 (50),
      invoice_no       VARCHAR2 (14),
      inst_no          giac_direct_prem_collns.inst_no%TYPE,
      bal_amt_due      giac_aging_soa_details.balance_amt_due%TYPE,
      prem_bal_due     giac_aging_soa_details.prem_balance_due%TYPE,
      tax_bal_due      giac_aging_soa_details.tax_balance_due%TYPE,
      inv_prem         gipi_invoice.prem_amt%TYPE,
      inv_tax          gipi_invoice.tax_amt%TYPE,
      prem_paid        giac_direct_prem_collns.premium_amt%TYPE,
      tax_paid         giac_direct_prem_collns.tax_amt%TYPE,
      inv_evat         gipi_inv_tax.tax_amt%TYPE,
      evat_paid        giac_tax_collns.tax_amt%TYPE,
      evat_should_be   giac_tax_collns.tax_amt%TYPE,
      evat_discrep     giac_tax_collns.tax_amt%TYPE,
      inv_comm         gipi_comm_invoice.commission_amt%TYPE,
      comm_paid        giac_comm_payts.comm_amt%TYPE,
      comm_discrep     giac_comm_payts.comm_amt%TYPE,
      --b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      --b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE
      user_id          giac_direct_prem_collns.user_id%TYPE,
      last_update      giac_direct_prem_collns.last_update%TYPE,
      or_date          DATE,
      posting_date     DATE,
      policy_id        gipi_polbasic.policy_id%TYPE
   );

   TYPE mikel_type2 IS TABLE OF crr_mikel_type2;

   TYPE crr_mikel_type3 IS RECORD (
      payment_term     VARCHAR2 (20),
      assured_name     VARCHAR2 (500),
      policy_no        VARCHAR2 (50),
      reference_no     VARCHAR2 (50),
      invoice_no       VARCHAR2 (14),
      inst_no          giac_direct_prem_collns.inst_no%TYPE,
      bal_amt_due      giac_aging_soa_details.balance_amt_due%TYPE,
      prem_bal_due     giac_aging_soa_details.prem_balance_due%TYPE,
      tax_bal_due      giac_aging_soa_details.tax_balance_due%TYPE,
      inv_prem         gipi_invoice.prem_amt%TYPE,
      inv_tax          gipi_invoice.tax_amt%TYPE,
      prem_paid        giac_direct_prem_collns.premium_amt%TYPE,
      tax_paid         giac_direct_prem_collns.tax_amt%TYPE,
      inv_evat         gipi_inv_tax.tax_amt%TYPE,
      evat_paid        giac_tax_collns.tax_amt%TYPE,
      evat_should_be   giac_tax_collns.tax_amt%TYPE,
      evat_discrep     giac_tax_collns.tax_amt%TYPE,
      inv_comm         gipi_comm_invoice.commission_amt%TYPE,
      comm_paid        giac_comm_payts.comm_amt%TYPE,
      comm_discrep     giac_comm_payts.comm_amt%TYPE,
      --b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      --b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE
      user_id          giac_direct_prem_collns.user_id%TYPE,
      last_update      giac_direct_prem_collns.last_update%TYPE,
      or_date          DATE,
      posting_date     DATE
   );

   TYPE mikel_type3 IS TABLE OF crr_mikel_type3;

   TYPE crr_mikel_type4 IS RECORD (
      payment_term     VARCHAR2 (20),
      assured_name     VARCHAR2 (500),
      policy_no        VARCHAR2 (50),
      reference_no     VARCHAR2 (50),
      invoice_no       VARCHAR2 (14),
      inst_no          giac_direct_prem_collns.inst_no%TYPE,
      bal_amt_due      giac_aging_soa_details.balance_amt_due%TYPE,
      prem_bal_due     giac_aging_soa_details.prem_balance_due%TYPE,
      tax_bal_due      giac_aging_soa_details.tax_balance_due%TYPE,
      inv_prem         gipi_invoice.prem_amt%TYPE,
      inv_tax          gipi_invoice.tax_amt%TYPE,
      prem_paid        giac_direct_prem_collns.premium_amt%TYPE,
      tax_paid         giac_direct_prem_collns.tax_amt%TYPE,
      inv_evat         gipi_inv_tax.tax_amt%TYPE,
      evat_paid        giac_tax_collns.tax_amt%TYPE,
      evat_should_be   giac_tax_collns.tax_amt%TYPE,
      evat_discrep     giac_tax_collns.tax_amt%TYPE,
      inv_comm         gipi_comm_invoice.commission_amt%TYPE,
      comm_paid        giac_comm_payts.comm_amt%TYPE,
      comm_discrep     giac_comm_payts.comm_amt%TYPE,
      --b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      --b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE
      user_id          giac_direct_prem_collns.user_id%TYPE,
      last_update      giac_direct_prem_collns.last_update%TYPE,
      or_date          DATE,
      posting_date     DATE,
      policy_id        gipi_polbasic.policy_id%TYPE
   );

   TYPE mikel_type4 IS TABLE OF crr_mikel_type4;

   FUNCTION partially_paid (
      p_display       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_prem_seq_no   NUMBER
   )
      RETURN mikel_type PIPELINED;

   FUNCTION fully_paid
      RETURN mikel_type2 PIPELINED;

   FUNCTION partially_paid2
      RETURN mikel_type3 PIPELINED;

   FUNCTION fully_paid2
      RETURN mikel_type4 PIPELINED;
END;
/



CREATE OR REPLACE PACKAGE CPI.ic_schedules
/* Created by : Mikel, Mac and Deo
** Date Created : 04.10.2014
** Description : Display IC schedules;
                1. Production-CTPL
                2. Collection-CTPL
                3. Losses Paid-CTPL
                4. Collection of Premiums Receivable
                5. Commission Payments
*/
AS
   TYPE collection_rec_type IS RECORD (
      assured_name       VARCHAR2 (500),
      policy_no          VARCHAR2 (50),
      line_name          giis_line.line_name%TYPE,
      iss_cd             gipi_invoice.iss_cd%TYPE,
      prem_seq_no        gipi_invoice.prem_seq_no%TYPE,
      tsi_amt            gipi_invperil.tsi_amt%TYPE,
      prem_amt           gipi_invperil.prem_amt%TYPE,
      dst                giac_tax_collns.tax_amt%TYPE,
      fst                giac_tax_collns.tax_amt%TYPE,
      vat                giac_tax_collns.tax_amt%TYPE,
      lgt                giac_tax_collns.tax_amt%TYPE,
      prem_tax           giac_tax_collns.tax_amt%TYPE,
      notarial_fee       giac_tax_collns.tax_amt%TYPE,
      other_taxes        giac_tax_collns.tax_amt%TYPE,
      collection_amt     giac_direct_prem_collns.collection_amt%TYPE,
      commission_amt     giac_comm_payts.comm_amt%TYPE,
      wtax_amt           giac_comm_payts.wtax_amt%TYPE,
      input_vat_amt      giac_comm_payts.input_vat_amt%TYPE,
      net_comm_amt       giac_comm_payts.comm_amt%TYPE,
      transaction_date   DATE,
      posting_date       DATE,
      or_no              VARCHAR2 (50),
      reference_no       VARCHAR2 (100)
   );

   TYPE collection_type IS TABLE OF collection_rec_type;

   FUNCTION get_ctpl_collection (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN collection_type PIPELINED;

   FUNCTION get_prem_rec_collection (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN collection_type PIPELINED;

   FUNCTION get_comm_payments (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN collection_type PIPELINED;

   --added for Losses Paid by MAC 04/10/2014.
   TYPE losses_paid_rec_type IS RECORD (
      claimant        giis_assured.assd_name%TYPE,
      claim_no        VARCHAR2 (50),
      clm_file_date   VARCHAR2 (20),
      policy_no       VARCHAR2 (50),
      loss_date       VARCHAR2 (20),
      reserve_amt     gicl_clm_res_hist.loss_reserve%TYPE,
      paid_amt        gicl_clm_res_hist.losses_paid%TYPE,
      difference      gicl_clm_res_hist.loss_reserve%TYPE,
      date_paid       VARCHAR2 (20),
      check_no        VARCHAR2 (50),
      tran_class      giac_acctrans.tran_class%TYPE
   );

   TYPE losses_paid_type IS TABLE OF losses_paid_rec_type;

   FUNCTION get_losses_paid (
      p_from_date   DATE,
      p_to_date     DATE,
      p_post_tran   VARCHAR2
   )
      RETURN losses_paid_type PIPELINED;

--end of MAC 04/10/2014.

   --Add Deo [04.11.2014]
   TYPE prod_rec_type IS RECORD (
      assured_name    giis_assured.assd_name%TYPE,
      policy_no       VARCHAR2 (50),
      line_name       giis_line.line_name%TYPE,
      tsi_amt         gipi_invperil.tsi_amt%TYPE,
      prem_amt        gipi_invperil.prem_amt%TYPE,
      dst             gipi_inv_tax.tax_amt%TYPE,
      fst             gipi_inv_tax.tax_amt%TYPE,
      vat             gipi_inv_tax.tax_amt%TYPE,
      lgt             gipi_inv_tax.tax_amt%TYPE,
      other_taxes     gipi_inv_tax.tax_amt%TYPE,
      total_amt_due   gipi_invperil.tsi_amt%TYPE                          --,
   --policy_id       gipi_polbasic.policy_id%TYPE
   );

   TYPE prod_type IS TABLE OF prod_rec_type;

   FUNCTION get_ctpl_production (p_from_date DATE, p_to_date DATE)
      RETURN prod_type PIPELINED;
--End Deo [04.11.2014]
END;
/



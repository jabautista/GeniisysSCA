CREATE OR REPLACE PACKAGE CPI.CSV_AC_DISB_REPORTS
AS
   TYPE get_giacr221B_type IS RECORD (
      branch_code                   VARCHAR (2),
      branch_name                   giis_issource.iss_name%TYPE,
      intermediary_type             giis_intermediary.intm_type%TYPE,
      intermediary_no               giis_intermediary.intm_no%TYPE,  
      intermediary_name             giis_intermediary.intm_name%TYPE,
      policy_no                     VARCHAR2 (50), 
      agent_code                    VARCHAR2 (15),
      issue_code                    giis_issource.iss_cd%TYPE,
      premium_seq_no                gipi_comm_inv_peril.prem_seq_no%TYPE,   
      assured_no                    giis_assured.assd_no%TYPE,      
      assured_name                  giis_assured.assd_name%TYPE,
      peril_code                    giis_peril.peril_cd%TYPE,
      premium_amount                gipi_comm_inv_peril.premium_amt%TYPE,
      commission_rate               gipi_comm_inv_peril.commission_rt%TYPE,
      commission_amount             gipi_comm_inv_peril.commission_amt%TYPE,
      bill_number                   VARCHAR2 (20), 
      withholding_tax               giac_comm_payts.wtax_amt%TYPE,
      input_vat_amount              giac_comm_payts.input_vat_amt%TYPE,
      net_commission                gipi_comm_inv_dtl.commission_amt%TYPE
   );

   TYPE get_giacr221B_tab IS TABLE OF get_giacr221B_type;

   FUNCTION csv_giacr221B(
      p_rep_grp       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_intm_no       VARCHAR2,
      p_module_id     VARCHAR2,
      p_unpaid_prem   VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_giacr221B_tab PIPELINED;
END;
/

CREATE OR REPLACE PACKAGE CPI.Unpaid_Commissions
AS /* created by judyann 03192013; to get amount of unpaid commissions of policies with paid or unpaid premiums */
   TYPE comm_rec_type
   IS
      RECORD (
        branch_cd       giis_issource.iss_cd%TYPE,
        assd_no         giis_assured.assd_no%TYPE,
        assd_name       giis_assured.assd_name%TYPE,
        intm_no         giis_intermediary.intm_no%TYPE,
        intm_name       giis_intermediary.intm_name%TYPE,
        agent_code      VARCHAR2(20),
        policy_no       VARCHAR2(50),
        iss_cd          gipi_invoice.iss_cd%TYPE,
        prem_seq_no     gipi_invoice.prem_seq_no%TYPE,
        policy_id       gipi_polbasic.policy_id%TYPE,
        peril_cd        giis_peril.peril_cd%TYPE,
        peril_name      giis_peril.peril_name%TYPE,
        premium_amt     gipi_comm_inv_peril.premium_amt%TYPE,
        commission_amt  gipi_comm_inv_peril.commission_amt%TYPE,
        wholding_tax    gipi_comm_inv_peril.wholding_tax%TYPE,
        input_vat       gipi_comm_inv_peril.wholding_tax%TYPE,
        commission_rt   gipi_comm_inv_peril.commission_rt%TYPE,
        branch_name     giis_issource.iss_name%TYPE
      );

   TYPE comm_type IS TABLE OF comm_rec_type;

   FUNCTION OS_Comm (p_rep_grp      VARCHAR2,
                     p_inc_tag      VARCHAR2)
      RETURN comm_type
      PIPELINED;
END;
/



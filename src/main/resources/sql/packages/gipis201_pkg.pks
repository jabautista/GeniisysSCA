CREATE OR REPLACE PACKAGE CPI.gipis201_pkg
AS
   TYPE get_prod_policy_details_type IS RECORD (
      policy_no        VARCHAR2 (50),
      endorsement_no   VARCHAR2 (20),
      policy_id        gipi_polbasic.policy_id%TYPE,
      line_cd          gipi_polbasic.line_cd%TYPE,
      subline_cd       gipi_polbasic.subline_cd%TYPE,
      iss_cd           gipi_polbasic.iss_cd%TYPE,
      issue_yy         gipi_polbasic.issue_yy%TYPE,
      pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      endt_iss_cd      gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy          gipi_polbasic.endt_yy%TYPE,
      endt_seq_no      gipi_polbasic.endt_seq_no%TYPE,
      renew_no         gipi_polbasic.renew_no%TYPE,
      par_id           gipi_polbasic.par_id%TYPE,
      eff_date         gipi_polbasic.eff_date%TYPE,
      assd_no          gipi_polbasic.assd_no%TYPE,
      tsi_amt          gipi_polbasic.tsi_amt%TYPE,
      prem_amt         gipi_polbasic.prem_amt%TYPE,
      tax_amt          gipi_inv_tax.tax_amt%TYPE,
      assured          giis_assured.assd_name%TYPE,
      commission       NUMBER,
      issue_date       VARCHAR2 (50),
      expiry_date      VARCHAR2 (50),
      incept_date      VARCHAR2 (50),
      pol_flag         gipi_polbasic.pol_flag%TYPE,
      MESSAGE          VARCHAR2 (200)
   );

   TYPE get_prod_policy_details_tab IS TABLE OF get_prod_policy_details_type;

   TYPE get_comm_dtls_type IS RECORD (
      parent_comm_rt    giac_parent_comm_invprl.commission_rt%TYPE,
      parent_comm_amt   giac_parent_comm_invprl.commission_amt%TYPE,
      child_comm_rt     gipi_comm_inv_peril.commission_rt%TYPE,
      child_comm_amt    gipi_comm_inv_peril.commission_amt%TYPE,
      peril_name        giis_peril.peril_name%TYPE
   );

   TYPE get_comm_dtls_tab IS TABLE OF get_comm_dtls_type;

   FUNCTION get_prod_policy_details (
      p_line_cd1      gipi_polbasic.line_cd%TYPE,
      p_subline_cd1   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd1       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy1     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no1   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no1     gipi_polbasic.renew_no%TYPE,
      p_policy_id     gipi_polbasic.policy_id%TYPE,
      p_param_date    NUMBER,
      p_from_date     DATE,
      p_to_date       DATE,
      p_month         VARCHAR2,
      p_year          NUMBER,
      p_dist_flag     VARCHAR2,
      p_user          gipi_prod_ext.user_id%TYPE
   )
      RETURN get_prod_policy_details_tab PIPELINED;

   FUNCTION val_gipis201_disp_orc
      RETURN VARCHAR2;

   FUNCTION get_comm_dtls (
      p_iss_cd      giac_parent_comm_invprl.iss_cd%TYPE,
      p_line_cd     giis_peril.line_cd%TYPE,
      p_policy_id   gipi_comm_inv_peril.policy_id%TYPE,
      p_intm_no     gipi_comm_inv_peril.intrmdry_intm_no%TYPE
   )
      RETURN get_comm_dtls_tab PIPELINED;
END;
/



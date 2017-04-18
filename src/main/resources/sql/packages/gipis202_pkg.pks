CREATE OR REPLACE PACKAGE CPI.gipis202_pkg
AS
   TYPE get_production_details_type IS RECORD (
      policy_no     VARCHAR2 (100),
      policy_id     gipi_polbasic.policy_id%TYPE,
      line_cd       gipi_polbasic.line_cd%TYPE,
      subline_cd    gipi_polbasic.subline_cd%TYPE,
      iss_cd        gipi_polbasic.iss_cd%TYPE,
      issue_yy      gipi_polbasic.issue_yy%TYPE,
      pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy       gipi_polbasic.endt_yy%TYPE,
      endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      renew_no      gipi_polbasic.renew_no%TYPE,
      par_id        gipi_polbasic.par_id%TYPE,
      eff_date      gipi_polbasic.eff_date%TYPE,
      assd_no       gipi_polbasic.assd_no%TYPE,
      tsi_amt       gipi_polbasic.tsi_amt%TYPE,
      prem_amt      gipi_polbasic.prem_amt%TYPE,
      assured       giis_assured.assd_name%TYPE,
      issue_date    VARCHAR2 (50),
      expiry_date   VARCHAR2 (50),
      incept_date   VARCHAR2 (50)
   );

   TYPE get_production_details_tab IS TABLE OF get_production_details_type;

   FUNCTION get_production_details (
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_polbasic.issue_yy%TYPE,
      p_intm_no         giis_intermediary.intm_no%TYPE,
      p_cred_iss        gipi_polbasic.cred_branch%TYPE,
      p_param_date      NUMBER,
      p_from_date       DATE,
      p_to_date         DATE,
      p_month           gipi_polbasic.booking_mth%TYPE,
      p_year            gipi_polbasic.booking_year%TYPE,
      p_dist_flag       VARCHAR2,
      p_reg_policy_sw   VARCHAR2,
      p_user            gipi_prod_ext.user_id%TYPE
   )
      RETURN get_production_details_tab PIPELINED;
END;
/



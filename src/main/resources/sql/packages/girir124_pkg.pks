CREATE OR REPLACE PACKAGE cpi.girir124_pkg
AS
   TYPE report_type IS RECORD (
      company_name          giis_parameters.param_value_v%TYPE,
      company_address       giis_parameters.param_value_v%TYPE,
      report_title          giis_reports.report_title%TYPE,
      param_date            VARCHAR2 (100),
      line_name             giis_line.line_name%TYPE,
      trty_yy               VARCHAR2 (10),
      trty_name             giis_dist_share.trty_name%TYPE,
      trty_separate         VARCHAR2 (1),
      ri_name               giis_reinsurer.ri_name%TYPE,
      intrty_no             VARCHAR2 (25),
      period                VARCHAR2 (25),
      booking_date          VARCHAR2 (25),
      acct_ent_date         VARCHAR2 (25),
      acct_neg_date         VARCHAR2 (25),
      ri_prem_amt           giri_intreaty.ri_prem_amt%TYPE,
      ri_comm_amt           giri_intreaty.ri_comm_amt%TYPE,
      ri_comm_vat           giri_intreaty.ri_comm_vat%TYPE,
      clm_loss_pd_amt       giri_intreaty.clm_loss_pd_amt%TYPE,
      clm_loss_exp_amt      giri_intreaty.clm_loss_exp_amt%TYPE,
      clm_recoverable_amt   giri_intreaty.clm_recoverable_amt%TYPE,
      charge_amount         giri_intreaty.charge_amount%TYPE,
      total                 NUMBER (12, 2)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_report_details (
      p_report_month   VARCHAR2,
      p_report_year    VARCHAR2,
      p_transaction    VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/
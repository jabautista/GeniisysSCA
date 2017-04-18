CREATE OR REPLACE PACKAGE CPI.giacr120_pkg
AS
   TYPE giacr120_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      same_date         VARCHAR2 (70)
   );

   TYPE giacr120_tab IS TABLE OF giacr120_type;

   FUNCTION populate_giacr120 (p_tran_date1 VARCHAR2, p_tran_date2 VARCHAR2)
      RETURN giacr120_tab PIPELINED;

   TYPE giacr120_details_type IS RECORD (
      iss_name           giis_issource.iss_name%TYPE,
      line_name          giis_line.line_name%TYPE,
      ri_name            giis_reinsurer.ri_name%TYPE,
      assured_name       gicl_claims.assured_name%TYPE,
      policy_number      VARCHAR2 (30),
      claim_number       VARCHAR2 (30),
      advice_number      VARCHAR2 (30),
      fla_date           gicl_advs_fla.fla_date%TYPE,
      total_share        NUMBER,
      total_payments     NUMBER,
      total_amount_due   NUMBER
   );

   TYPE giacr120_details_tab IS TABLE OF giacr120_details_type;

   FUNCTION populate_giacr120_details (
      p_tran_date1   VARCHAR2,
      p_tran_date2   VARCHAR2,
      p              VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_line_cd      VARCHAR2,
      p_ri_cd        NUMBER,
      p_cancel_tag   VARCHAR2
   )
      RETURN giacr120_details_tab PIPELINED;
END giacr120_pkg;
/



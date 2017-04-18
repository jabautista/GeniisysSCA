CREATE OR REPLACE PACKAGE CPI.giacr119_pkg
AS
   TYPE giacr119_header_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      tran_date         VARCHAR2 (70)
   );

   TYPE giacr119_header_tab IS TABLE OF giacr119_header_type;

   FUNCTION populate_giacr119_header (
      p_tran_date1   VARCHAR2,
      p_tran_date2   VARCHAR2
   )
      RETURN giacr119_header_tab PIPELINED;

   TYPE giacr119_details_type IS RECORD (
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

   TYPE giacr119_details_tab IS TABLE OF giacr119_details_type;

   FUNCTION populate_giacr119_details (
      p_tran_date1   VARCHAR2,
      p_tran_date2   VARCHAR2,
      p_p            VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_line_cd      VARCHAR2,
      p_ri_cd        NUMBER
   )
      RETURN giacr119_details_tab PIPELINED;
END giacr119_pkg;
/



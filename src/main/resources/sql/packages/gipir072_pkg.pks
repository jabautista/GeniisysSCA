CREATE OR REPLACE PACKAGE CPI.gipir072_pkg
AS
   TYPE gipir072_record_type IS RECORD (
      policy_no          gixx_mrn_cargo_stat.policy_no%TYPE,
      policy_id          gixx_mrn_cargo_stat.policy_id%TYPE,
      share_cd           gixx_mrn_cargo_stat.share_cd%TYPE,
      subline_name       VARCHAR2 (200),
      cargo_class_cd     gixx_mrn_cargo_stat.cargo_class_cd%TYPE,
      cargo_class_desc   gixx_mrn_cargo_stat.cargo_class_desc%TYPE,
      assd               VARCHAR2 (520),
      assd_name          gixx_mrn_cargo_stat.assd_name%TYPE,
      trty_name          gixx_mrn_cargo_stat.trty_name%TYPE,
      dist_tsi           gixx_mrn_cargo_stat.dist_tsi%TYPE,
      dist_prem          gixx_mrn_cargo_stat.dist_prem%TYPE,
      tax_amt            NUMBER,
      company_name       VARCHAR2 (100),
      company_address    VARCHAR2 (100),
      title              VARCHAR2 (200),
      period             VARCHAR2 (50),
      mjm                VARCHAR2 (1)
   );

   TYPE gipir072_record_tab IS TABLE OF gipir072_record_type;

   FUNCTION get_gipir072_record (
      p_extract_id      NUMBER,
      p_subline_cd      VARCHAR2,
      p_cargo_cd        VARCHAR2,
      p_starting_date   DATE,
      p_ending_date     DATE,
      p_user_id         VARCHAR2
   )
      RETURN gipir072_record_tab PIPELINED;

   FUNCTION cf_tax_amt (p_policy_id NUMBER, p_policy_no VARCHAR2)
      RETURN NUMBER;
END;
/



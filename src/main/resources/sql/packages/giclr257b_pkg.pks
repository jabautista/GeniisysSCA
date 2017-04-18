CREATE OR REPLACE PACKAGE CPI.giclr257b_pkg
AS
   TYPE main_type IS RECORD (
      payee_no          giis_payees.payee_no%TYPE,
      payee_class_cd    giis_payees.payee_class_cd%TYPE,
      payee_name        VARCHAR2 (600),
      dummy             VARCHAR2 (50),
      col1              giis_report_aging.column_title%TYPE,
      col2              giis_report_aging.column_title%TYPE,
      col3              giis_report_aging.column_title%TYPE,
      col4              giis_report_aging.column_title%TYPE,
      tot1              NUMBER,
      tot2              NUMBER,
      tot3              NUMBER,
      tot4              NUMBER,
      company_name      giis_parameters.param_value_v%TYPE,
      col_count         NUMBER,
      company_address   giis_parameters.param_value_v%TYPE,
      dsp_date          VARCHAR2 (1000)
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_main (
      p_payee_no     VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_user_id      VARCHAR2,
      p_search_by    VARCHAR2
   )
      RETURN main_tab PIPELINED;

   TYPE detail_type IS RECORD (
      claim_no        VARCHAR2 (50),
      policy_no       VARCHAR2 (50),
      assd_name       giis_assured.assd_name%TYPE,
      loss_date       gicl_claims.loss_date%TYPE,
      clm_file_date   gicl_claims.clm_file_date%TYPE,
      clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      assign_date     gicl_clm_adjuster.assign_date%TYPE,
      dummy           VARCHAR2 (50),
      claim_id        gicl_claims.claim_id%TYPE
   );

   TYPE detail_tab IS TABLE OF detail_type;

   FUNCTION get_details (
      p_payee_no         VARCHAR2,
      p_payee_class_cd   VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2,
      p_as_of_date       VARCHAR2,
      p_user_id          VARCHAR2,
      p_search_by        VARCHAR2
   )
      RETURN detail_tab PIPELINED;

   TYPE tot_type IS RECORD (
      tot1     NUMBER,
      tot2     NUMBER,
      tot3     NUMBER,
      tot4     NUMBER,
      row_no   NUMBER
   );

   TYPE tot_tab IS TABLE OF tot_type;

   FUNCTION get_grand_totals (
      p_payee_no     VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_user_id      VARCHAR2,
      p_search_by    VARCHAR2
   )
      RETURN tot_tab PIPELINED;

   TYPE amount_type IS RECORD (
      col1     NUMBER,
      col2     NUMBER,
      col3     NUMBER,
      col4     NUMBER,
      row_no   NUMBER
   );

   TYPE amount_tab IS TABLE OF amount_type;

   FUNCTION get_amounts (
      p_policy_number    VARCHAR2,
      p_claim_id         VARCHAR2,
      p_payee_no         VARCHAR2,
      p_payee_class_cd   VARCHAR2
   )
      RETURN amount_tab PIPELINED;
      
   FUNCTION get_totals (
      p_payee_no         VARCHAR2,
      p_payee_class_cd   VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2,
      p_as_of_date       VARCHAR2,
      p_user_id          VARCHAR2,
      p_search_by        VARCHAR2,
      p_dummy            VARCHAR2
   )
      RETURN amount_tab PIPELINED;
      
   FUNCTION get_grand_tots (
      p_payee_no         VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2,
      p_as_of_date       VARCHAR2,
      p_user_id          VARCHAR2,
      p_search_by        VARCHAR2,
      p_dummy            VARCHAR2
   )
      RETURN amount_tab PIPELINED;         
      
END;
/



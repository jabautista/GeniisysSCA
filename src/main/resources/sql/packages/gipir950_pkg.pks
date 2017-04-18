CREATE OR REPLACE PACKAGE CPI.gipir950_pkg
AS
   TYPE gipir950_type IS RECORD (
      comp_name          VARCHAR2 (100),
      comp_add           VARCHAR2 (500),
      date_basis         VARCHAR2 (50),
      cat_cd             VARCHAR2 (1),
      sub_cat_cd         VARCHAR2 (2),
      risk_amt           NUMBER (16, 2),
      risk_pct           VARCHAR2 (100),
      prem_amt           NUMBER (16, 2),
      prem_pct           VARCHAR2 (100),
      ave_pct            VARCHAR2 (100),
      pol_count          NUMBER (12),
      flag               VARCHAR2 (10),
      header             VARCHAR2 (100),
      category_desc      VARCHAR2 (50),
      cp_tot_risk_pct    VARCHAR2 (100),
      cp_tot_prem_pct    VARCHAR2 (100),
      cp_tot_prem_pct2   VARCHAR2 (100),
      cp_tot_risk_pct2   VARCHAR2 (100)
   );

   TYPE gipir950_tab IS TABLE OF gipir950_type;

   TYPE subcategory_type IS RECORD (
      sub_cat_cd_desc   VARCHAR2 (400),
      flag              VARCHAR2 (10)
   );

   TYPE subcategory_tab IS TABLE OF subcategory_type;

   FUNCTION get_gipir950_record (
      p_date_basis   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir950_tab PIPELINED;

   FUNCTION get_gipir950_subcategory (
      p_date_basis   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN subcategory_tab PIPELINED;
END;
/



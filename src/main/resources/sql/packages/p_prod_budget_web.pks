CREATE OR REPLACE PACKAGE CPI.P_PROD_BUDGET_WEB
AS

   PROCEDURE extract_prod_budget(
      p_iss_cd                IN VARCHAR2,
      p_line_cd               IN VARCHAR2,
      p_from_date             IN DATE,
      p_to_date               IN DATE,
      p_date_param            IN NUMBER,
      p_iss_param             IN NUMBER,
      p_special_pol           IN VARCHAR2,
      p_module_id             IN VARCHAR2,
      p_user_id               IN GIIS_USERS.user_id%TYPE,
      p_count                OUT NUMBER
   );

   FUNCTION check_prod_budget_date_policy(
      p_param_date               NUMBER,
      p_from_date                DATE,
      p_to_date                  DATE,
      p_issue_date               DATE,
      p_eff_date                 DATE,
      p_acct_ent_date            DATE,
      p_spld_acct                DATE,
      p_booking_year             GIPI_POLBASIC.booking_year%TYPE,
      p_booking_mth              GIPI_POLBASIC.booking_mth%TYPE
   )
     RETURN NUMBER;
     
END P_PROD_BUDGET_WEB;
/



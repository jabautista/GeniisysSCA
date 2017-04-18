CREATE OR REPLACE PACKAGE CPI.GIACR451_PKG
AS

   TYPE giacr451_type IS RECORD(
      company_name            GIIS_PARAMETERS.param_value_v%TYPE,
      company_address         GIIS_PARAMETERS.param_value_v%TYPE,
      prev_year               GIXX_PROD_BUDGET.prev_year%TYPE,
      curr_year               GIXX_PROD_BUDGET.curr_year%TYPE,
      line_name               GIIS_LINE.line_name%TYPE,
      iss_name                GIIS_ISSOURCE.iss_name%TYPE,
      curr_prem               GIXX_PROD_BUDGET.curr_prem%TYPE,
      prev_prem               GIXX_PROD_BUDGET.prev_prem%TYPE,
      prem_diff               NUMBER(16, 2),
      prem_pct                NUMBER(30, 9),
      budget                  GIXX_PROD_BUDGET.budget%TYPE,
      budget_diff             NUMBER(16, 2),
      budget_pct              NUMBER(30, 9),
      iss_param               GIXX_PROD_BUDGET.iss_param%TYPE
   );
   TYPE giacr451_tab IS TABLE OF giacr451_type;
   
   FUNCTION get_giacr451_records(
      p_line_cd               GIXX_PROD_BUDGET.line_cd%TYPE,
      p_iss_cd                GIXX_PROD_BUDGET.iss_cd%TYPE,
      p_user_id               GIIS_USERS.user_id%TYPE
   )
     RETURN giacr451_tab PIPELINED;

END;
/



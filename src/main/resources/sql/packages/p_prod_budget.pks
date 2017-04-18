CREATE OR REPLACE PACKAGE CPI.P_Prod_Budget
/* rollie 31jan2005 @ CPI QUAD
** This package will hold all the procedures and functions that will
** handle the extraction of budget production
*/
AS
  PROCEDURE EXTRACT(
              p_iss_cd     IN VARCHAR2,
            p_line_cd      IN VARCHAR2,
            p_from_date    IN DATE,
            p_to_date      IN DATE,
            p_date_param   IN NUMBER, /*  1 - based on issue_date
                                          2 - based on incept_date
                                          3 - based on booking_month
                                          4 - based on acct_ent_date */
            p_iss_param    IN NUMBER, /*  1 - based on cred_branch
                                          2 - based on iss_cd */
            p_special_pol  IN VARCHAR2,/* Y - include special policies
                                          N - exclue special policies */
            p_module_id IN VARCHAR2); /*Added: Ronnie 06082012 use to determine module access*/                                          
            

  FUNCTION Check_Date_Policy
   /* rollie 31jan2005 @ CPI QUAD
   ** validates if policy's date is within the given date parameter
   */
   (p_param_date       NUMBER,
    p_from_date        DATE,
    p_to_date          DATE,
     p_issue_date      DATE,
      p_eff_date       DATE,
      p_acct_ent_date  DATE,
      p_spld_acct      DATE,
      p_booking_year   GIPI_POLBASIC.booking_year%TYPE,
    p_booking_mth      GIPI_POLBASIC.booking_mth%TYPE)
   RETURN NUMBER;
END P_Prod_Budget;
/



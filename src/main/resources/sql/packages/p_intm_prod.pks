CREATE OR REPLACE PACKAGE CPI.P_Intm_Prod
/* rollie 13jan2005 @ CPI QUAD
** This package will hold all the procedures and functions that will
** handle the extraction of production by intermediary
*/
AS
  PROCEDURE EXTRACT(
     p_iss_cd       IN VARCHAR2,
   p_intm_no    IN NUMBER,
   p_line_cd     IN VARCHAR2,
   p_date_param   IN NUMBER, /*  1 - based on issue_date
                    2 - based on incept_date
            3 - based on booking_month
            4 - based on acct_ent_date */
            p_from_date    IN DATE,
   p_to_date      IN DATE,
   p_iss_param    IN NUMBER /* 1 - based on cred_branch
                2 - based on iss_cd*/
   );
  FUNCTION Check_Date_Policy
   /** rollie 19july2004
   *** get the dates of certain policy
   **/
   (p_param_date     NUMBER,
    p_from_date     DATE,
    p_to_date         DATE,
  p_issue_date     DATE,
   p_eff_date      DATE,
   p_acct_ent_date   DATE,
   p_spld_acct     DATE,
   p_booking_mth     GIPI_POLBASIC.booking_mth%TYPE,
   p_booking_year    GIPI_POLBASIC.booking_year%TYPE)
  RETURN NUMBER;
  
  /*
    Added by Pol Cruz for GIACS275
  */
  PROCEDURE extract_intm_prod_colln (
      p_branch_param   NUMBER,
      p_branch_cd      gipi_polbasic.iss_cd%TYPE,
      p_line_cd        giis_line.line_cd%TYPE,
      p_intm_no        giis_intermediary.intm_no%TYPE,
      p_param_date     NUMBER,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_user_id        giis_users.user_id%TYPE,
      p_count      OUT NUMBER
   );
   
   /*
    Added by Pol Cruz for GIACS275
  */ 
   PROCEDURE EXTRACT_WEB(
      p_iss_cd      IN VARCHAR2,
      p_intm_no     IN VARCHAR2,
      p_line_cd     IN VARCHAR2,
      p_date_param  IN VARCHAR2,
      p_from_date   IN VARCHAR2,
      p_to_date     IN VARCHAR2,
      p_iss_param   IN VARCHAR2,
      p_user_id     IN VARCHAR2,
      p_count      OUT  NUMBER
   );
  
END P_Intm_Prod;
/



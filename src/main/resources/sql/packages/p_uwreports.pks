CREATE OR REPLACE PACKAGE CPI.P_Uwreports
/* Author     : TERRENCE TO
** Desciption : This package will hold all the procedures and functions that will
**              handle the Extraction for UWREPORTS (GIPIS901A) module.
**
*/
AS

/*PARAMETERS USED :
P_SCOPE -
      1 - Policies Only
      2 - Endorsements Only
   - no longer used, value is always = 3
     All records are extracted, user can choose to print policies only or endorsements only before printing

P_PARAM_DATE -
      1 - Issue Date
      2 - Incept Date
      3 - Booking Month / Year
      4 - Acctg Entry Date / Spld Acct Ent Date

P_FROM_DATE -
        - From date used in extraction

P_TO_DATE -
        - To date used in extraction

P_ISS_CD -
        - used in limiting extracted data

P_LINE_CD -
        - used in limiting extracted data

P_SUBLINE_CD -
        - used in limiting extracted data

P_USER -
        - used in per user extracts

USER may enter parameters before extraction or may
choose all issue source, all lines and all sublines before
extraction and later choose a specific issue source, line or subline before printing
*/

   /*
   **  Created BY:  Jason 8/1/2008
   **  Description: Retrieve the commission amount
   */
   FUNCTION get_comm_amt(p_prem_seq_no NUMBER,
                         p_iss_cd VARCHAR2,
                          -- added by rose to avoid the error in wrong type of arguments 11/04/2009--
                         p_scope      NUMBER,   -- aaron 061009
                         p_param_date  NUMBER,
                         p_from_date    DATE,
                         p_to_date      DATE,
                         p_policy_id  NUMBER) -- 
     RETURN NUMBER;


   FUNCTION Check_Date_Policy
   /** rollie 19july2004
   *** get the dates of certain policy
   **/
   (p_scope          NUMBER,
    p_param_date     NUMBER,
    p_from_date      DATE,
    p_to_date        DATE,
    p_issue_date     DATE,
  p_eff_date       DATE,
  p_acct_ent_date  DATE,
  p_spld_acct     DATE,
  p_booking_mth    GIPI_POLBASIC.booking_mth%TYPE,
  p_booking_year   GIPI_POLBASIC.booking_year%TYPE,
  p_cancel_date    GIPI_POLBASIC.cancel_date%TYPE,--issa01.23.2008 added cancel date to consider p_scope = 3 (cancellation policies)
  p_endt_seq_no    GIPI_POLBASIC.endt_seq_no%TYPE) -- to consider policies only/ endts only
   RETURN NUMBER;

   FUNCTION Check_Date_Dist_Peril
   /** rollie 02/18/04
   *** date parameter of the last endorsement of policy
   *** must not be within the date given, else it will
   *** be exluded
   *** NOTE: policy with pol_flag = '4' only
   **/
   (p_line_cd     GIPI_POLBASIC.line_cd%TYPE,
    p_subline_cd  GIPI_POLBASIC.subline_cd%TYPE,
  p_iss_cd      GIPI_POLBASIC.iss_cd%TYPE,
  p_issue_yy    GIPI_POLBASIC.issue_yy%TYPE,
  p_pol_seq_no  GIPI_POLBASIC.pol_seq_no%TYPE,
  p_renew_no    GIPI_POLBASIC.renew_no%TYPE,
  p_param_date  NUMBER,
  p_from_date   DATE,
  p_to_date     DATE)
   RETURN NUMBER;

   FUNCTION Check_Date
   /** rollie 02/18/04
   *** date parameter of the last endorsement of policy
   *** must be within the date given, else it will
   *** be exluded
   *** NOTE: policy with pol_flag = '4' only
   **/
   (p_scope     NUMBER,
    p_line_cd       GIPI_POLBASIC.line_cd%TYPE,
   p_subline_cd  GIPI_POLBASIC.subline_cd%TYPE,
   p_iss_cd      GIPI_POLBASIC.iss_cd%TYPE,
   p_issue_yy      GIPI_POLBASIC.issue_yy%TYPE,
   p_pol_seq_no  GIPI_POLBASIC.pol_seq_no%TYPE,
   p_renew_no      GIPI_POLBASIC.renew_no%TYPE,
    p_param_date  NUMBER,
   p_from_date  DATE,
   p_to_date      DATE)
   RETURN NUMBER;

   PROCEDURE pol_taxes2
   (p_item_grp       GIPI_INVOICE.item_grp%TYPE,
    p_takeup_seq_no  GIPI_INVOICE.takeup_seq_no%TYPE,
    p_policy_id   GIPI_INVOICE.policy_id%TYPE,
    --ADDED BY ROSE 11042009 TO AVOID ERROR IN WRONG ARGUMENTS--
    p_scope        IN   NUMBER,   -- aaron 061009
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE);

   PROCEDURE pol_gixx_pol_prod
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2,
    p_nonaff_endt  IN   VARCHAR2, --param added rachelle 061808
    p_reinstated    IN   VARCHAR2); --param added abie 08262011
/*
   PROCEDURE pol_gixx_pol_prod_3
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2);
*/
/*--Production Register
    Spoiled Policies are included to preserve policy sequence in  production registers.
  Actual amounts are inserted in extract as these are used in a production register
 with break by acct_ent_date/spld_acct_ent_date. Reports(GIPIR923/924) sets the amounts
 to zero if spld_date is null.
    Applies to extract_tab_1 only.
*/
   PROCEDURE extract_tab1
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2,
    p_nonaff_endt  IN   VARCHAR2  --param added rachelle 061808
    ,p_reinstated   IN   VARCHAR2); --param added, abie 08262011
    
/*--Distribution Register
    Spoiled Policies are not included unless extraction is based on Acctg Entry Date
    Dist Flag must be equal to 3 in both GIPI_POLBASIC and GIUW_POL_DIST
       if extraction is not based on Acctg Entry Date
    Acct Ent Date / Acct Neg Date in GIUW_POL_DIST is used for extraction based on Acctg Entry Date
*/
   PROCEDURE Extract_Tab2
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2);

/*--Outward RI
    Spoiled Policies are not included unless extraction is based on Acctg Entry Date
   Reverse Date in GIRI_BINDER must be null
*/
   PROCEDURE Extract_Tab3 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
      p_parameter    IN   NUMBER,
      p_special_pol  IN   VARCHAR2);


/*--Per Peril / Agent
    Spoiled Policies are not included unless extraction is based on Acctg Entry Date
   ISS_CD <> giacp.v('RI_ISS_CD')
*/
   PROCEDURE extract_tab4 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
   p_parameter    IN   NUMBER,
   p_special_pol  IN   VARCHAR2);


/*--Per Peril / Agent
    Spoiled Policies are not included unless extraction is based on Acctg Entry Date
   ISS_CD = giacp.v('RI_ISS_CD')
*/
   PROCEDURE extract_tab4_ri (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
   p_parameter    IN   NUMBER,
   p_special_pol  IN   VARCHAR2);


/*--Per Assured / Intermediary
    Spoiled Policies are not included unless extraction is based on Acctg Entry Date
   ISS_CD <> giacp.v('RI_ISS_CD')
*/
   PROCEDURE extract_tab5 (
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_scope        IN   NUMBER,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
      p_assd         IN   NUMBER,
      p_intm         IN   NUMBER,
   p_parameter    IN   NUMBER,
   p_special_pol  IN   VARCHAR2,
   p_intm_type    IN   VARCHAR2);


/*--Inward RI
    Spoiled Policies are not included unless extraction is based on Acctg Entry Date
   ISS_CD <> giacp.v('RI_ISS_CD')
*/
   PROCEDURE extract_tab8 (
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_scope        IN   NUMBER,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
--      p_assd         IN   NUMBER,--kim
--      p_intm         IN   NUMBER,--kim
   p_ri     IN   NUMBER,
   p_parameter    IN   NUMBER, 
   p_special_pol  IN   VARCHAR2);

/*   -- JHING 08/05/2011 COMMENTED OUT AND REPLACED FROM OLD VERSION FROM DANNY 
   ---Prodedure added by Anthony Santos Feb 2 2010 -------
   PROCEDURE EDST
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2,
    p_nonaff_endt  IN   VARCHAR2,
    p_inc_negative IN   VARCHAR2); --Added by Anthony Santos
    
    */
    
     ---Prodedure added by Alvin Tumlos 05.26.2010-------
   PROCEDURE EDST
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER);
    
   PROCEDURE COPY_TAB1
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_user         IN   VARCHAR2);
    
END P_Uwreports;
/



CREATE OR REPLACE PACKAGE CPI.P_Tariff_Fromto_Dtl AS
  /* Modified by :  Aaron
  ** Modified on :  October 10, 2008 
  ** Remarks     :  Modified to correct the amounts extracted.
  **                Added the following parameters: 
  **           i.  p_inc_endt   --> parameter to determine whether to include endorsements
  **                    beyond the given date of extraction
  **       ii.  p_inc_exp    --> parameter to determine whether to include expired policies or not
  **         iii.  p_peril_type --> parameter to determine the type of peril to be included;
  **                A (allied only) B (basic only ) AB (both)            
  */
  
  FUNCTION date_ok (
    p_ad         IN DATE,
    p_ed         IN DATE,
    p_id         IN DATE,
    p_mth        IN VARCHAR2,
    p_year       IN NUMBER,
    p_spld_ad    IN DATE,
    p_pol_flag   IN VARCHAR2,
    p_dt_type    IN VARCHAR2,
    p_fmdate     IN DATE,
    p_todate     IN DATE)
  RETURN NUMBER;
  
  PROCEDURE EXTRACT(
    p_from       IN DATE,
    p_to         IN DATE,
    p_bus_cd     IN NUMBER,
    P_Zone       IN VARCHAR2,
    p_type       IN VARCHAR2,
    p_dt_type    IN VARCHAR2,
    p_inc_endt   IN VARCHAR2,  --aaron100808 
    p_peril_type IN VARCHAR2,  --aaron100808 
    p_inc_exp    IN VARCHAR2, --aaron100808 
    p_user       IN VARCHAR2); --edgar 03/09/2015
  
  FUNCTION Get_Dist_Prem_Tsi (
  /* created by bdarusin 01/15/2002
  ** this function returns the dist tsi amount of the policy.
  ** this function is only used for the procedures involving fire stat
  */
    p_line_cd     VARCHAR2,
    p_subline_cd  VARCHAR2,
    p_iss_cd      VARCHAR2,
    p_issue_yy    NUMBER,
    p_pol_seq_no  NUMBER,
    p_renew_no    NUMBER,
    p_item_no     NUMBER,
    p_peril_cd    NUMBER,
    p_share_cd    NUMBER,
    p_dist_no     NUMBER,
    p_type     VARCHAR2,
    p_from        DATE,
    p_to          DATE,
    p_dt_type     VARCHAR2,
    p_prem_tsi    VARCHAR2,
    p_inc_endt    VARCHAR2)  --aaron100808 
  RETURN NUMBER;   
  
  FUNCTION get_tarf_cd
   (p_line_cd      VARCHAR2,
    p_subline_cd   VARCHAR2,
    p_iss_cd       VARCHAR2,
    p_issue_yy     NUMBER,
    p_pol_seq_no   NUMBER,
    p_renew_no     NUMBER,
    p_item_no      NUMBER,
    p_dt_type      VARCHAR2,
    p_from         DATE,
    p_to           DATE,
    p_type         VARCHAR2,
    p_inc_endt     VARCHAR2) --aaron100808 
  RETURN VARCHAR2;

END;
/



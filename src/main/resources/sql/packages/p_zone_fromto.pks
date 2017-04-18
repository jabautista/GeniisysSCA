CREATE OR REPLACE PACKAGE CPI.P_Zone_Fromto AS
  /* Modified by :  Aaron
  ** Modified on :  October 23, 2008 
  ** Remarks     :  Modified to correct the amounts extracted.
  **                Added the following parameters: 
  **           i.  p_inc_endt   --> parameter to determine whether to include endorsements
  **                    beyond the given date of extraction
  **          ii.  p_inc_exp    --> parameter to determine whether to include expired policies or not
  **         iii.  p_peril_type --> parameter to determine the type of peril to be included;
  **                A (allied only) B (basic only ) AB (both)            
  **          iv.   p_risk_cnt  ---> parameter to determine whether count will be per risk ('R') or per policy ('P')          
  */
  
  PROCEDURE EXTRACT(
    p_from      IN DATE,
    p_to        IN DATE,
    p_dt_type   IN VARCHAR2,
    p_bus_cd    IN NUMBER,
    p_zone      IN VARCHAR2,
    p_dsp_zone  IN VARCHAR2,
    p_inc_endt  IN VARCHAR2,
    p_inc_exp   IN VARCHAR2,
    p_peril_type IN VARCHAR2,
    p_risk_cnt  IN VARCHAR2,
    p_user      IN VARCHAR2); --edgar 03/09/2015
  FUNCTION date_ok(
    p_ad       IN DATE,
    p_ed       IN DATE,
    p_id       IN DATE,
    p_mth      IN VARCHAR2,
    p_year     IN NUMBER,
    p_spld_ad  IN DATE,
    p_pol_flag IN VARCHAR2,
    p_dt_type  IN VARCHAR2,
    p_fmdate   IN DATE,
    p_todate   IN DATE)
  RETURN NUMBER;
  FUNCTION risk_count(
    p_fi_zone  IN VARCHAR2,
    p_share_cd IN NUMBER,
    p_type     IN VARCHAR2,
    p_risk_cnt IN VARCHAR2,
    p_user     IN VARCHAR2) --edgar 03/09/2015
  RETURN NUMBER;
    
END;
/



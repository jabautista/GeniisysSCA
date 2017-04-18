DROP FUNCTION CPI.DATE_RISK;

CREATE OR REPLACE FUNCTION CPI.date_risk
   /*Modified by Iris Bordey (01.08.2003)
   **Added the parameters p_month and p_year for p_dt_type = 'BD' (booking date)
   **Evaluates booking month and booking year against p_fmdate and p_todate
   **when p_dt_type = 'BD'*/
  /*  this function checks if the acct_ent_date, eff_date, or issue_date
      of the policy is within the given date range
   revised by bdarusin, 11222002,
   if extract is by acct_ent_date, include spoiled policies but
   check the spld_acct_ent_date*/
  (p_ad       IN DATE,
   p_ed       IN DATE,
   p_id       IN DATE,
   p_month    IN VARCHAR2,
   p_year     IN NUMBER,
   p_spld_ad  IN DATE,
   p_pol_flag IN VARCHAR2,
   p_dt_type  IN VARCHAR2,
   p_fmdate   IN DATE,
   p_todate   IN DATE)
  RETURN NUMBER IS
    v_booking_fmdate  DATE;
 v_booking_todate  DATE;
  BEGIN
    IF p_pol_flag = '5' THEN
    IF p_dt_type = 'AD' AND TRUNC(p_spld_ad) >= p_fmdate
       AND TRUNC(p_spld_ad) <= p_todate THEN
       RETURN (1);
    ELSE
       RETURN (0);
    END IF;
 ELSE
       IF p_dt_type = 'AD' AND TRUNC(p_ad) >= p_fmdate
       AND TRUNC(p_ad) <= p_todate THEN
    RETURN (1);
    ELSIF p_dt_type = 'ED' AND TRUNC(p_ed) >= p_fmdate AND TRUNC(p_ed) <= p_todate THEN
       RETURN (1);
    ELSIF p_dt_type = 'ID' AND TRUNC(p_id) >= p_fmdate AND TRUNC(p_id) <= p_todate THEN
       RETURN (1);
    ELSIF p_dt_type = 'BD' THEN
       DBMS_OUTPUT.PUT_LINE('BD');
       v_booking_fmdate := TO_DATE('01-'||SUBSTR(p_month,1,3)||'-'||TO_CHAR(p_year),'DD-MON-YYYY');
          v_booking_todate := LAST_DAY(TO_DATE('01-'||SUBSTR(p_month,1,3)||'-'||TO_CHAR(p_year),'DD-MON-YYYY'));
       IF v_booking_fmdate >= p_fmdate AND v_booking_todate <= p_todate THEN
             RETURN (1);
          ELSE
             RETURN (0);
          END IF;
    END IF;
    RETURN (0);
 END IF;
  END;
/



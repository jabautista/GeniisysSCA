DROP PROCEDURE CPI.PRO_RATE_PERIL_COMP;

CREATE OR REPLACE PROCEDURE CPI.pro_rate_peril_comp(p_prem_amt         IN OUT NUMBER,
         p_prorate_flag     IN VARCHAR2,
                              p_short_rate       IN NUMBER,
                              p_tsi_amt          IN NUMBER,
                              p_prem_rt          IN NUMBER,
                              p_incept_date      IN DATE,
                              p_expiry_date      IN DATE,
                              p_eff_date         IN DATE,
                              p_endt_expiry_date IN DATE) IS
 p_diff_date          NUMBER := TRUNC(p_expiry_date - p_incept_date);
 p_year               NUMBER := ADD_MONTHS(p_incept_date,12) - p_incept_date;
 e_diff_date          NUMBER := TRUNC(p_endt_expiry_date - p_eff_date);
 pro_date1            NUMBER := (p_tsi_amt*p_prem_rt*e_diff_date/p_year) / 100;
 pro_date2            NUMBER := (p_tsi_amt*p_prem_rt) / 100;
 pro_date3            NUMBER := (p_tsi_amt*p_prem_rt*p_short_rate) / 10000;
BEGIN
 IF p_prorate_flag = '1' THEN
    p_prem_amt := pro_date1;
 ELSIF p_prorate_flag = '2' THEN
    p_prem_amt := pro_date2;
 ELSE
    p_prem_amt := pro_date3;
 END IF;
END;
/



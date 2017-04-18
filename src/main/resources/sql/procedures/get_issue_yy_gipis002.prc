DROP PROCEDURE CPI.GET_ISSUE_YY_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Get_Issue_Yy_Gipis002(
    p_booking_mth            IN VARCHAR2,
    p_booking_year           IN NUMBER,
    p_incept_date            IN VARCHAR2,
    p_issue_date             IN VARCHAR2,
    v_issue_yy              OUT NUMBER,
    v_msg                   OUT VARCHAR2
    ) IS
  v_param           GIIS_PARAMETERS.param_value_v%TYPE := Giisp.V('POL_NO_ISSUE_YY');
  v_incept_date     DATE;
  v_issue_date	    DATE;
  v_booking         gipi_wpolbas.incept_date%TYPE;
  v_result          NUMBER := 0;
BEGIN
  /*Created by Iris Bordey 12.22.2003
  **SPEC # UW-SPECS-GIPIS031-2003-0036
  **PRF  # AUII-2003-08-001
  **Specification (By Ms. Grace):
  **Value of ISSUE_YY in GIPI_POLBASIC should be based on
  **the value of the parameter 'POL_NO_ISSUE_YY' in GIIS_PARAMETERS.
  **If param_value_v = 'ISSUE_DATE' then issue_yy will be based on the
  **INCEPT_DATE else it will be based on the issue_date*/
  /* vin 05.26.2010
  ** The priority now would be the booking month and year
  ** first it would validate if GIISP.V('BOOKING_POL_YY') is equal to 'Y'
  ** if it is, it would then check if the booking month and year is greater than/less than or equal to the incept date
  ** if its greater, issue_yy would be based on issue_date
  ** if it's less, issue_yy would be based on incept_date
  ** if its equal and/or GIISP.V('BOOKING_POL_YY') is equal to 'N' then it would proceed using the old validation 
  */
  
  v_incept_date	   := TO_DATE(p_incept_date,'MM-DD-YYYY');
  v_issue_date	   := TO_DATE(p_issue_date,'MM-DD-YYYY');
      
  IF GIISP.V('BOOKING_POL_YY') = 'Y' THEN
    IF p_booking_mth IS NULL AND p_booking_year IS NULL THEN
      v_booking := TO_DATE (TO_CHAR(v_incept_date,'MM')  ||'-01-'|| TO_CHAR(v_incept_date,'YYYY'),'MM-DD-YYYY');
    ELSE
      v_booking := TO_DATE(p_booking_mth||'-01-'||p_booking_year,'MM-DD-YYYY');
    END IF;    
  
    --would return 1 if its late booking
    --would return -1 if its advanced booking
    --would return 0 if its neither
    SELECT SIGN(v_booking - TRUNC(v_incept_date)) 
      INTO v_result
      FROM dual;  
  
    IF v_result = 1 THEN --late booking
      v_issue_yy := TO_NUMBER(SUBSTR(TO_CHAR(v_issue_date,'MM-DD-YYYY'),9,2));
    ELSIF v_result = -1 THEN --advanced booking
      v_issue_yy := TO_NUMBER(SUBSTR(TO_CHAR(v_incept_date,'MM-DD-YYYY'),9,2));
    ELSIF v_result = 0 OR GIISP.V('BOOKING_POL_YY') = 'N' THEN 
      --if its neither advanced nor late booking OR GIISP.V('BOOKING_POL_YY') = 'N'
      -- use the old validation
      IF v_param IS NULL THEN
           v_issue_yy := TO_NUMBER(SUBSTR(TO_CHAR(v_incept_date,'MM-DD-YYYY'),9,2));
      ELSIF UPPER(v_param) = 'ISSUE_DATE' THEN
           v_issue_yy := TO_NUMBER(SUBSTR(TO_CHAR(v_issue_date,'MM-DD-YYYY'),9,2));
      ELSIF UPPER(v_param) = 'EFF_DATE' THEN
           v_issue_yy := TO_NUMBER(SUBSTR(TO_CHAR(v_incept_date,'MM-DD-YYYY'),9,2));
      ELSE
           v_msg := 'Y';
      END IF;
    END IF;
  ELSE
      IF v_param IS NULL THEN
           v_issue_yy := TO_NUMBER(SUBSTR(TO_CHAR(v_incept_date,'MM-DD-YYYY'),9,2));
      ELSIF UPPER(v_param) = 'ISSUE_DATE' THEN
           v_issue_yy := TO_NUMBER(SUBSTR(TO_CHAR(v_issue_date,'MM-DD-YYYY'),9,2));
      ELSIF UPPER(v_param) = 'EFF_DATE' THEN
           v_issue_yy := TO_NUMBER(SUBSTR(TO_CHAR(v_incept_date,'MM-DD-YYYY'),9,2));
      ELSE
           v_msg := 'Y';
      END IF;
  END IF;
  v_msg := NVL(v_msg,'N');
END;
/



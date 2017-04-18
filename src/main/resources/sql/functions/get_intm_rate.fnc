DROP FUNCTION CPI.GET_INTM_RATE;

CREATE OR REPLACE FUNCTION CPI.GET_INTM_RATE
  (P_INTM_NO   GIIS_INTERMEDIARY.INTM_NO%TYPE,
   P_LINE_CD   GIIS_LINE.LINE_CD%TYPE,
   P_ISS_CD    GIPI_POLBASIC.ISS_CD%TYPE,
   P_PERIL_CD  GIPI_ITMPERIL.PERIL_CD%TYPE)
  RETURN       NUMBER
  IS
BEGIN
  DECLARE
    V_PERIL_NAME         GIIS_PERIL.PERIL_NAME%TYPE;
    V_MESSAGE            VARCHAR2(200);
    V_SP_RT              VARCHAR2(1);
    V_DUMMY              CHAR;
    V_RATE               GIPI_COMM_INV_PERIL.COMMISSION_RT%TYPE:=0;
    V_INTM_TYPE          GIIS_INTERMEDIARY.INTM_TYPE%TYPE;
  BEGIN
    SELECT SPECIAL_RATE, INTM_TYPE
    INTO V_SP_RT  , V_INTM_TYPE
    FROM GIIS_INTERMEDIARY
    WHERE INTM_NO = P_INTM_NO;
    IF V_SP_RT = 'Y' THEN
      BEGIN
        SELECT NVL(RATE,0)
        INTO V_RATE
        FROM GIIS_INTM_SPECIAL_RATE
        WHERE INTM_NO = P_INTM_NO
        AND LINE_CD = P_LINE_CD
        AND ISS_CD = P_ISS_CD
        AND PERIL_CD = P_PERIL_CD;
          RETURN(V_RATE);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            SELECT NVL(COMM_RATE,0)
            INTO V_RATE
            FROM GIIS_INTMDRY_TYPE_RT
            WHERE INTM_TYPE = V_INTM_TYPE
            AND LINE_CD = P_LINE_CD
            AND ISS_CD = P_ISS_CD
            AND PERIL_CD = P_PERIL_CD;
              RETURN(V_RATE);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              BEGIN
                SELECT NVL(INTM_COMM_RT,0)
                INTO V_RATE
                FROM GIIS_PERIL
                WHERE LINE_CD = P_LINE_CD
                AND PERIL_CD = P_PERIL_CD;
                  RETURN(V_RATE);
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  RETURN(V_RATE);
              END;
          END;
      END;
    ELSE    --IF V_SP_RT = 'Y' THEN
      BEGIN
        SELECT NVL(COMM_RATE,0)
        INTO V_RATE
        FROM GIIS_INTMDRY_TYPE_RT
        WHERE INTM_TYPE = V_INTM_TYPE
        AND LINE_CD = P_LINE_CD
        AND ISS_CD = P_ISS_CD
        AND PERIL_CD = P_PERIL_CD;
          RETURN(V_RATE);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            SELECT NVL(INTM_COMM_RT,0)
            INTO V_RATE
            FROM GIIS_PERIL
            WHERE LINE_CD = P_LINE_CD
            AND PERIL_CD = P_PERIL_CD;
              RETURN(V_RATE);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              RETURN(V_RATE);
          END;
      END;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20094, 'INTM NO DOES NOT EXIST IN INTM MASTER FILE.');
  END;
END;
/


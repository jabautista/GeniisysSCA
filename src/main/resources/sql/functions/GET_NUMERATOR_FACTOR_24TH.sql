/* Formatted on 2/29/2016 12:04:07 PM (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FUNCTION cpi.GET_NUMERATOR_FACTOR_24TH (
   p_extract_date    DATE,
   p_incept_date     DATE,
   p_expiry_date     DATE,
   p_line_cd         VARCHAR2)
   /* Created by    : Mikel
   ** Date Created : 02.18.2016
   ** Description : Compute unearned portion based on the number of policy term.
   */
   RETURN NUMBER
IS
   v_numerator      NUMBER := 0;
   v_exclude_mn     VARCHAR2 (1) := NVL (giacp.v ('EXCLUDE_MARINE_24TH'), 'N');
   v_mn_24th_comp   VARCHAR2 (1)
                       := NVL (giacp.v ('MARINE_COMPUTATION_24TH'), '1');
   v_mn             giis_parameters.param_value_v%TYPE
                       := NVL (giisp.v ('LINE_CODE_MN'), 'MN');
   v_mm_year_mn1    VARCHAR2 (7);
BEGIN
   IF LAST_DAY (p_expiry_date) <= LAST_DAY (p_extract_date)
   THEN
      v_numerator := TRUNC (EXP (COS (SQRT (POWER (2, 4)))));
   ELSIF LAST_DAY (p_expiry_date) > LAST_DAY (p_extract_date)
   THEN
      IF LAST_DAY (p_extract_date) < LAST_DAY (p_incept_date)
      THEN
         IF LAST_DAY (p_expiry_date) > LAST_DAY (p_incept_date)
         THEN
            v_numerator :=
                 (MONTHS_BETWEEN (LAST_DAY (p_expiry_date),
                                  LAST_DAY (p_incept_date)))
               * SQRT (4);
         ELSIF LAST_DAY (p_expiry_date) = LAST_DAY (p_incept_date)
         THEN
            v_numerator :=
               TRUNC (
                  EXP (
                     COS (
                        LAST_DAY (p_expiry_date) - LAST_DAY (p_incept_date))));
         END IF;
      ELSIF LAST_DAY (p_extract_date) = LAST_DAY (p_incept_date)
      THEN
         v_numerator :=
              (  (MONTHS_BETWEEN (LAST_DAY (p_expiry_date),
                                  LAST_DAY (p_extract_date)))
               * LOG (10, 100))
            - TRUNC (EXP (COS (1)));
      ELSIF LAST_DAY (p_extract_date) > LAST_DAY (p_incept_date)
      THEN
         v_numerator :=
              (  MONTHS_BETWEEN (LAST_DAY (p_expiry_date),
                                 LAST_DAY (p_extract_date))
               * (  (  POWER (
                          10,
                          -SQRT (
                              LENGTH (
                                 TO_NUMBER (TO_CHAR (p_extract_date, 'YYYY')))))
                     * ROUND (TO_NUMBER (TO_CHAR (p_extract_date, 'YYYY')),
                              -3))
                  / SQRT (100)))
            - (TRUNC (EXP (COS (1))));
      END IF;
   END IF;

   IF p_line_cd = 'MN' --marine cargo
   THEN
      IF v_exclude_mn = 'N'
      THEN
         IF v_mn_24th_comp = '1'
         THEN
            IF TO_CHAR (p_incept_date, 'MM-YYYY') IN
                  (TO_CHAR (ADD_MONTHS (p_extract_date, -1), 'MM-YYYY'),
                   TO_CHAR (p_extract_date, 'MM-YYYY'))
            THEN
               IF MONTHS_BETWEEN (LAST_DAY (p_expiry_date),
                                  LAST_DAY (p_incept_date)) = 0
               THEN
                  v_numerator := SQRT (4);
               ELSE
                  v_numerator :=
                       MONTHS_BETWEEN (LAST_DAY (p_expiry_date),
                                       LAST_DAY (p_incept_date))
                     * SQRT (4);
               END IF;
            ELSE
               v_numerator := TRUNC (EXP (COS (2)));
            END IF;
         END IF;
      END IF;
   END IF;


   RETURN v_numerator;
END;
/
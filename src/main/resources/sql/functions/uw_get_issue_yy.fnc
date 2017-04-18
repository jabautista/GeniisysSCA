DROP FUNCTION CPI.UW_GET_ISSUE_YY;

CREATE OR REPLACE FUNCTION CPI.uw_get_issue_yy (
   p_booking_mth    IN   VARCHAR2,
   p_booking_year   IN   NUMBER,
   p_incept_date    IN   gipi_wpolbas.incept_date%TYPE,
   p_issue_date     IN   gipi_wpolbas.issue_date%TYPE,
   p_err            OUT  varchar2
)
   RETURN NUMBER
IS
   v_param      giis_parameters.param_value_v%TYPE  := giisp.v ('POL_NO_ISSUE_YY');
   v_issue_yy   gipi_wpolbas.issue_yy%TYPE;
   v_booking    gipi_wpolbas.incept_date%TYPE;
   v_result     NUMBER;
BEGIN
   /*Created by Iris Bordey 12.22.2003
   **SPEC # UW-SPECS-GIPIS031-2003-0036
   **PRF  # AUII-2003-08-001
   **Specification (By Ms. Grace):
   **Value of ISSUE_YY in GIPI_POLBASIC should be based on
   **the value of the parameter 'POL_NO_ISSUE_YY' in GIIS_PARAMETERS.
   **If param_value_v = 'ISSUE_DATE' then issue_yy will be based on the
   **ISSUE_DATE else it will be based on the incept_date*/
   /* vin 05.26.2010
   ** The priority now would be the booking month and year
   ** first it would validate if GIISP.V('BOOKING_POL_YY') is equal to 'Y'
   ** if it is, it would then check if the booking month and year is greater than/less than or equal to the incept date
   ** if its greater, issue_yy would be based on issue_date
   ** if it's less, issue_yy would be based on incept_date
   ** if its equal and/or GIISP.V('BOOKING_POL_YY') is equal to 'N' then it would proceed using the old validation
   */
   IF NVL(giisp.v ('BOOKING_POL_YY'), 'N') = 'Y'
   THEN
      IF p_booking_mth IS NULL AND p_booking_year IS NULL
      THEN
         v_booking :=
            TO_DATE (   TO_CHAR (p_incept_date, 'MM')
                     || '-01-'
                     || TO_CHAR (p_incept_date, 'RRRR'),
                     'MM-DD-RRRR'
                    );
      ELSE
         v_booking :=
            TO_DATE (p_booking_mth || '-01-' || p_booking_year, 'MM-DD-RRRR');
      END IF;

      --would return 1 if its late booking
      --would return -1 if its advanced booking
      --would return 0 if its neither
                SELECT SIGN (v_booking - TRUNC (p_incept_date))
                  INTO v_result
                  FROM DUAL;

      IF v_result = 1
      THEN                                                      --late booking
         v_issue_yy :=
              TO_NUMBER (SUBSTR (TO_CHAR (p_issue_date, 'MM-DD-YYYY'), 9, 2));
      ELSIF v_result = -1
      THEN                                                  --advanced booking
         v_issue_yy :=
             TO_NUMBER (SUBSTR (TO_CHAR (p_incept_date, 'MM-DD-YYYY'), 9, 2));
      ELSIF v_result = 0
/*OR GIISP.V('BOOKING_POL_YY') = 'N'*/
--comment out by mikel 12.09.2011; "OR GIISP.V('BOOKING_POL_YY') = 'N'" is not applicable here because value of booking_pol_yy is Y
      THEN
         --if its neither advanced nor late booking OR GIISP.V('BOOKING_POL_YY') = 'N'
         -- use the old validation
         IF v_param IS NULL
         THEN
            v_issue_yy :=
               TO_NUMBER (SUBSTR (TO_CHAR (p_incept_date, 'MM-DD-YYYY'), 9, 2)
                         );
         ELSIF UPPER (v_param) = 'ISSUE_DATE'
         THEN
            v_issue_yy :=
               TO_NUMBER (SUBSTR (TO_CHAR (p_issue_date, 'MM-DD-YYYY'), 9, 2));
         ELSIF UPPER (v_param) = 'EFF_DATE'
         THEN
            v_issue_yy :=
               TO_NUMBER (SUBSTR (TO_CHAR (p_incept_date, 'MM-DD-YYYY'), 9, 2)
                         );
         ELSE
            p_err := 'Y';
         END IF;
      END IF;
   /* mikel 12.09.2011
      added condition to use the old validation POL_NO_ISSUE_YY */
   ELSIF NVL(giisp.v ('BOOKING_POL_YY'), 'N') = 'N'
   THEN
      IF v_param IS NULL
      THEN
         v_issue_yy :=
             TO_NUMBER (SUBSTR (TO_CHAR (p_incept_date, 'MM-DD-YYYY'), 9, 2));
      ELSIF UPPER (v_param) = 'ISSUE_DATE'
      THEN
         v_issue_yy :=
              TO_NUMBER (SUBSTR (TO_CHAR (p_issue_date, 'MM-DD-YYYY'), 9, 2));
      ELSIF UPPER (v_param) = 'EFF_DATE'
      THEN
         v_issue_yy :=
             TO_NUMBER (SUBSTR (TO_CHAR (p_incept_date, 'MM-DD-YYYY'), 9, 2));
      ELSE
         p_err := 'Y';
      END IF;

      /* end mikel 12.09.2011 */
      
   END IF;
   RETURN (v_issue_yy);
END;                                               --end function get_issue_yy
/



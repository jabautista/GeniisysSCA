CREATE OR REPLACE FUNCTION cpi.GET_DENOMINATOR_FACTOR_24TH (
   p_extract_date   DATE,
   p_incept_date    DATE,
   p_expiry_date    DATE
)
/* Created by    : Mikel
** Date Created : 02.18.2016
** Description : Compute the number of policy term.
*/
RETURN NUMBER
IS
   CURSOR denominator
   IS
      SELECT   DECODE (MONTHS_BETWEEN (LAST_DAY (p_expiry_date),
                                       LAST_DAY (p_incept_date)
                                      ),
                       0, 1,
                       MONTHS_BETWEEN (LAST_DAY (p_expiry_date),
                                       LAST_DAY (p_incept_date)
                                      )
                      )
             * 2 denominator
        FROM DUAL;

   v_denominator   NUMBER := 0;
BEGIN
   OPEN denominator;

   FETCH denominator
    INTO v_denominator;

   CLOSE denominator;

   RETURN v_denominator;
END;
/
DROP FUNCTION CPI.VALIDATE_BOOKING_DATE;

CREATE OR REPLACE FUNCTION CPI.validate_booking_date (p_booking_year VARCHAR2,
                                                      p_booking_mth VARCHAR2,
                                                      p_issue_date VARCHAR2,
                                                      p_incept_date VARCHAR2)
  RETURN VARCHAR2
IS
  v_msg VARCHAR2 (3200);
  v_var_vdate NUMBER;
  v_var_ndate VARCHAR2 (250);
  v_var_idate DATE;
  v_tag giis_booking_month.booked_tag%TYPE;
  v_advance_booking giis_parameters.param_value_v%TYPE;
  v_issue DATE;
  v_incept DATE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information)
  **  Description  : when-validate-item and pre-text-item B540 booking year
  */
  v_issue := TO_DATE (p_issue_date, 'MM-DD-YYYY');
  v_incept := TO_DATE (p_incept_date, 'MM-DD-YYYY');
  when_newform_inst_b_gipis002 (v_var_vdate);

  IF v_var_vdate = 1
  THEN
    v_var_idate := v_issue;
  ELSIF v_var_vdate = 2
  THEN
    v_var_idate := v_incept;
  ELSIF v_var_vdate = 3
  THEN
    IF v_issue > v_incept
    THEN
      v_var_idate := v_issue;
      v_var_ndate := 'issue';
    ELSE
      v_var_idate := v_incept;
      v_var_ndate := 'effectivity';
    END IF;
  ELSIF v_var_vdate = 4
  THEN
    IF v_issue > v_incept
    THEN
      v_var_idate := v_incept;
      v_var_ndate := 'effectivity';
    ELSE
      v_var_idate := v_issue;
      v_var_ndate := 'issue';
    END IF;
  END IF;

  IF p_booking_mth IS NOT NULL
  THEN
    b540_bookyr_wvi_b_gipis002 (p_booking_year, p_booking_mth, v_tag);

    /*determined IF advance booking DATE should be ALLOW
       **by deriving the value of param_name 'ALLOW_BOOKING_IN_ADVANCE'
       **from giis_parameters and  assigning it on variable v_advance_booking */
    v_advance_booking := 'N';

    FOR e IN (SELECT param_value_v
              FROM giis_parameters
              WHERE param_name = 'ALLOW_BOOKING_IN_ADVANCE')
    LOOP
      v_advance_booking := e.param_value_v;
    END LOOP;

    IF TO_CHAR (
         TO_DATE ('01-' || SUBSTR (p_booking_mth, 1, 3) || '-' || TO_CHAR (p_booking_year),
                  'DD-MON-YYYY'),
         'J'
       ) <
         TO_CHAR (
           TO_DATE ('01-' || TO_CHAR (v_var_idate, 'MON') || '-' || TO_CHAR (v_var_idate, 'YYYY'),
                    'DD-MON-YYYY'),
           'J'
         )
   AND v_advance_booking = 'N'
    THEN
      IF v_var_vdate = 1
      THEN
        v_msg :=
             'You cannot book this policy to '
          || p_booking_mth
          || ' '
          || TO_CHAR (p_booking_year)
          || '. The booking month is earlier than the issue date '
          || TO_CHAR (v_var_idate, 'fmMonth DD, YYYY')
          || ' of the policy.';
      ELSIF v_var_vdate = 2
      THEN
        v_msg :=
             'You cannot book this policy to '
          || p_booking_mth
          || ' '
          || TO_CHAR (p_booking_year)
          || '. The booking month is earlier than the effectivity date '
          || TO_CHAR (v_var_idate, 'fmMonth DD, YYYY')
          || ' of the policy.';
      ELSIF v_var_vdate = 3
      THEN
        v_msg :=
             'You cannot book this policy to '
          || p_booking_mth
          || ' '
          || TO_CHAR (p_booking_year)
          || '. The booking month is earlier than the '
          || v_var_ndate
          || ' date '
          || TO_CHAR (v_var_idate, 'fmMonth DD, YYYY')
          || ' of the policy.';
      ELSIF v_var_vdate = 4
      THEN
        v_msg :=
             'You cannot book this policy to '
          || p_booking_mth
          || ' '
          || TO_CHAR (p_booking_year)
          || '. The booking month is earlier than the '
          || v_var_ndate
          || ' date '
          || TO_CHAR (v_var_idate, 'fmMonth DD, YYYY')
          || ' of the policy.';
      END IF;
    ELSIF v_tag = 'Y'
    THEN
      v_msg :=
           'You cannot book this policy to '
        || p_booking_mth
        || ' '
        || TO_CHAR (p_booking_year)
        || '. The booking month has already been booked.';
    ELSIF v_tag IS NULL
    THEN
      v_msg :=
           'You cannot book this policy to '
        || p_booking_mth
        || ' '
        || TO_CHAR (p_booking_year)
        || '. The booking month is not existing in the maintenance for booking date.';
    END IF;
  ELSIF TO_NUMBER (TO_CHAR (v_var_idate, 'YYYY')) < p_booking_year AND v_advance_booking = 'N'
  THEN
    IF v_var_vdate = 1
    THEN
      v_msg :=
           'You cannot book this policy to '
        || TO_CHAR (p_booking_year)
        || '. The booking month is earlier than the issue date '
        || TO_CHAR (v_var_idate, 'fmMonth DD, YYYY')
        || ' of the policy.';
    ELSIF v_var_vdate = 2
    THEN
      v_msg :=
           'You cannot book this policy to '
        || TO_CHAR (p_booking_year)
        || '. The booking month is earlier than the effectivity date '
        || TO_CHAR (v_var_idate, 'fmMonth DD, YYYY')
        || ' of the policy.';
    ELSIF v_var_vdate = 3
    THEN
      v_msg :=
           'You cannot book this policy to '
        || TO_CHAR (p_booking_year)
        || '. The booking month is earlier than the '
        || v_var_ndate
        || ' date '
        || TO_CHAR (v_var_idate, 'fmMonth DD, YYYY')
        || ' of the policy.';
    ELSIF v_var_vdate = 4
    THEN
      v_msg :=
           'You cannot book this policy to '
        || TO_CHAR (p_booking_year)
        || '. The booking month is earlier than the '
        || v_var_ndate
        || ' date '
        || TO_CHAR (v_var_idate, 'fmMonth DD, YYYY')
        || ' of the policy.';
    END IF;
  END IF;

  RETURN v_msg;
END;
/



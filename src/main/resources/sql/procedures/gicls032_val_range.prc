DROP PROCEDURE CPI.GICLS032_VAL_RANGE;

CREATE OR REPLACE PROCEDURE CPI.gicls032_val_range (
   p_claim_id              gicl_claims.claim_id%TYPE,
   p_advise_amt            gicl_advice.advise_amt%TYPE,
   p_user_name             VARCHAR2,
   p_password              VARCHAR2,
   p_ovr_range_user_name   VARCHAR2
)
IS
   v_line_cd    giis_line.line_cd%TYPE;
   v_iss_cd     gicl_claims.iss_cd%TYPE;
   v_override   VARCHAR2 (1)              := 'N';
   v_range_to   NUMBER                    := 0;
BEGIN
   IF p_user_name IS NULL AND p_password IS NULL
   THEN
      SELECT line_cd, iss_cd
        INTO v_line_cd, v_iss_cd
        FROM gicl_claims
       WHERE claim_id = p_claim_id;

      FOR rec IN (SELECT range_to
                    FROM gicl_adv_line_amt
                   WHERE adv_user = giis_users_pkg.app_user AND line_cd = v_line_cd AND iss_cd = v_iss_cd)
      LOOP
         v_range_to := rec.range_to;
      END LOOP;

      IF p_advise_amt > v_range_to
      THEN
         IF p_ovr_range_user_name IS NULL
         THEN
            raise_application_error
                                   (-20001,
                                       'Geniisys Exception#CONFIRM_RANGE_OVERRIDE#Advice amount exceeds the range allowable for '
                                    || giis_users_pkg.app_user
                                    || '. Would you like to override?'
                                   );
         ELSE
            FOR rec IN (SELECT range_to
                          FROM gicl_adv_line_amt
                         WHERE adv_user = p_ovr_range_user_name AND line_cd = v_line_cd AND iss_cd = v_iss_cd)
            LOOP
               v_range_to := rec.range_to;
               v_override := 'Y';
            END LOOP;

            IF v_override = 'Y'
            THEN
               IF p_advise_amt > v_range_to
               THEN
                  raise_application_error
                                       (-20001,
                                           'Geniisys Exception#E#Override failed. Advice amount exceeds the range allowable for '
                                        || p_ovr_range_user_name
                                        || '.'
                                       );
               END IF;
            ELSE
               raise_application_error (-20001,
                                           'Geniisys Exception#E#'
                                        || p_ovr_range_user_name
                                        || ' is not allowed to approve advice amount.'
                                       );
            END IF;
         END IF;
      END IF;
   END IF;
END;
/



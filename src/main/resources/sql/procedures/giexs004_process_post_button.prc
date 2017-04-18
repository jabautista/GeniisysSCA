CREATE OR REPLACE PROCEDURE CPI.giexs004_process_post_button (
    p_module_id                   VARCHAR2,
    p_user               IN       giex_expiries_v.extract_user%TYPE,
    p_all_user           IN       giis_users.all_user_sw%TYPE,
    p_line_cd            IN       giex_expiries_v.line_cd%TYPE,
    p_subline_cd         IN       giex_expiries_v.subline_cd%TYPE,
    p_iss_cd             IN       giex_expiries_v.iss_cd%TYPE,
    p_issue_yy           IN       giex_expiries_v.issue_yy%TYPE,
    p_pol_seq_no         IN       giex_expiries_v.pol_seq_no%TYPE,
    p_renew_no           IN       giex_expiries_v.renew_no%TYPE,
    p_claim_sw           IN       giex_expiries_v.claim_flag%TYPE,
    p_balance_sw         IN       giex_expiries_v.balance_flag%TYPE,
    p_intm_name          IN       giis_intermediary.intm_name%TYPE,
    p_intm_no            IN       giex_expiries_v.intm_no%TYPE,
    p_range_type         IN       VARCHAR2,
    p_range              IN       VARCHAR2,
    p_fm_date            IN       DATE,
    p_to_date            IN       DATE,
    p_fm_mon             IN       NUMBER, --marco - 08.29.2014 - changed types from DATE
    p_to_mon             IN       NUMBER, --
    p_fm_year            IN       NUMBER, --
    p_to_year            IN       NUMBER, --
    p_override_renewal   IN       VARCHAR2,
    temp_ac_override     OUT      VARCHAR2,
    temp_ab_override     OUT      VARCHAR2,
    temp_rb_override     OUT      VARCHAR2,
    temp_ar_override     OUT      VARCHAR2,
    MESSAGE              OUT      VARCHAR2,
    renew_flag           OUT      VARCHAR2,
    p_confirm_branch_sw  IN       VARCHAR2,
    p_confirm_fmv_sw     IN       VARCHAR2, --benjo 11.24.2016 SR-5621
    p_validate_mc_fmv    IN       VARCHAR2, --benjo 11.24.2016 SR-5621
    p_count              OUT      NUMBER    --benjo 11.24.2016 SR-5621
)
IS
   v_update_invalid   VARCHAR2 (3)   := 'XYZ';
   v_tagged           VARCHAR2 (1)   := 'N';
   v_rec_sw           VARCHAR2 (1)   := 'N';
   v_par_sw           VARCHAR2 (1)   := 'N';
   v_ala              VARCHAR2 (1)   := NULL;
   v_msg              VARCHAR2 (500) := NULL;
   v_all_user         VARCHAR2(1)    := 'N'; --added by joanne 06.25.14, default all_user_sw is N
   v_issue_place      giis_issource.iss_cd%TYPE;
   v_pol_issue_place  gipi_polbasic.place_cd%TYPE;
   v_user_iss_cd      giis_issource.iss_cd%TYPE;
   v_cred_branch      gipi_polbasic.cred_branch%TYPE;
   v_cred_branch_renew giis_parameters.param_value_v%TYPE := GIISP.V('CRED_BRANCH_RENEWAL');
   v_allow_other_branch_renew giis_parameters.param_value_v%TYPE := GIISP.V('ALLOW_OTHER_BRANCH_RENEWAL');
   v_count            NUMBER := 0;            --benjo 11.24.2016 SR-5621
   v_line_cd          giis_line.line_cd%TYPE; --benjo 11.24.2016 SR-5621
   v_dummy            NUMBER := 0;            --benjo 11.24.2016 SR-5621
BEGIN
   BEGIN
     SELECT b.grp_iss_cd, a.all_user_sw
       INTO v_user_iss_cd, v_all_user
       FROM giis_users a
           ,giis_user_grp_hdr b           
      WHERE a.user_id = p_user
        AND b.user_grp = a.user_grp;
   END;

   IF NVL(p_confirm_branch_sw, 'N') = 'N' 
      AND (v_cred_branch_renew = 'Y' OR v_allow_other_branch_renew = 'Y')
   THEN
       FOR a IN
          (SELECT policy_id, iss_cd, is_package --benjo 12.20.2016 SR-5621 added is_package
             FROM TABLE (giex_expiries_v_pkg.get_expired_policies2 (p_user,
                                                                   v_all_user,
                                                                   p_line_cd,
                                                                   p_subline_cd,
                                                                   p_iss_cd,
                                                                   p_issue_yy,
                                                                   p_pol_seq_no,
                                                                   p_renew_no,
                                                                   p_claim_sw,
                                                                   p_balance_sw,
                                                                   p_intm_name,
                                                                   p_intm_no,
                                                                   p_range_type,
                                                                   p_range,
                                                                   p_fm_date,
                                                                   p_to_date,
                                                                   p_fm_mon,
                                                                   p_to_mon,
                                                                   p_fm_year,
                                                                   p_to_year
                                                                  )
                        )
            WHERE update_flag = 'Y' AND NVL (post_flag, 'N') = 'N')
       LOOP
           IF NVL(a.is_package, 'N') = 'Y' THEN --benjo 12.20.2016 SR-5621 added condition
               SELECT cred_branch, place_cd
                 INTO v_cred_branch, v_pol_issue_place
                 FROM gipi_pack_polbasic
                WHERE pack_policy_id = a.policy_id;
           ELSE
               SELECT cred_branch, place_cd
                 INTO v_cred_branch, v_pol_issue_place
                 FROM gipi_polbasic
                WHERE policy_id = a.policy_id;
           END IF;
                       
           IF v_cred_branch_renew = 'Y' 
              AND v_pol_issue_place IS NOT NULL
              AND a.iss_cd <> v_cred_branch
           THEN
               BEGIN
                 SELECT place_cd
                   INTO v_issue_place
                   FROM giis_issource_place
                  WHERE iss_cd = v_cred_branch
                    AND place_cd = v_pol_issue_place;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                     MESSAGE := '0';
                     EXIT;   
               END;               
           END IF;
                                     
           IF v_allow_other_branch_renew = 'Y'
              AND v_pol_issue_place IS NOT NULL 
              AND a.iss_cd <> v_user_iss_cd
           THEN
               BEGIN      
                 SELECT place_cd
                   INTO v_issue_place
                   FROM giis_issource_place
                  WHERE iss_cd = v_user_iss_cd
                    AND place_cd = v_pol_issue_place;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                     MESSAGE := '0';
                     EXIT;  
               END;               
           END IF;
       END LOOP;
   END IF;
   
   /* benjo 11.24.2016 SR-5621 */
   IF NVL (p_confirm_fmv_sw, 'N') = 'N'
      AND NVL (p_validate_mc_fmv, '1') <> '1'
   THEN
      FOR i IN
         (SELECT policy_id, line_cd, ADD_MONTHS (incept_date, 12) eff_date, is_package
            FROM TABLE
                     (giex_expiries_v_pkg.get_expired_policies2 (p_user,
                                                                 v_all_user,
                                                                 p_line_cd,
                                                                 p_subline_cd,
                                                                 p_iss_cd,
                                                                 p_issue_yy,
                                                                 p_pol_seq_no,
                                                                 p_renew_no,
                                                                 p_claim_sw,
                                                                 p_balance_sw,
                                                                 p_intm_name,
                                                                 p_intm_no,
                                                                 p_range_type,
                                                                 p_range,
                                                                 p_fm_date,
                                                                 p_to_date,
                                                                 p_fm_mon,
                                                                 p_to_mon,
                                                                 p_fm_year,
                                                                 p_to_year
                                                                )
                     )
           WHERE update_flag = 'Y' AND NVL (post_flag, 'N') = 'N')
      LOOP
         IF NVL(i.is_package, 'N') = 'Y' THEN
            FOR j IN (SELECT policy_id, line_cd
                        FROM giex_expiry
                       WHERE pack_policy_id = i.policy_id)
            LOOP
                v_count := v_count + 1;

                SELECT NVL (menu_line_cd, line_cd)
                  INTO v_line_cd
                  FROM giis_line
                 WHERE line_cd = j.line_cd;

                IF v_line_cd = 'MC'
                THEN
                   FOR x IN (SELECT   a.car_company_cd, a.make_cd, a.series_cd,
                                      a.model_year,
                                      SUM (NVL (c.tsi_amt, NVL (b.tsi_amt, 0))
                                          ) tsi_amt
                                 FROM gipi_vehicle a,
                                      giex_old_group_itmperil b,
                                      giex_itmperil c,
                                      giis_peril d
                                WHERE a.policy_id = b.policy_id
                                  AND a.item_no = b.item_no
                                  AND b.policy_id = c.policy_id(+)
                                  AND b.item_no = c.item_no(+)
                                  AND b.peril_cd = c.peril_cd(+)
                                  AND b.line_cd = d.line_cd
                                  AND b.peril_cd = d.peril_cd
                                  AND b.policy_id = j.policy_id
                                  AND d.peril_type = 'B'
                             GROUP BY a.car_company_cd,
                                      a.make_cd,
                                      a.series_cd,
                                      a.model_year)
                   LOOP
                      BEGIN
                         SELECT   1
                             INTO v_dummy
                             FROM giis_mc_fmv a
                            WHERE a.car_company_cd = x.car_company_cd
                              AND a.make_cd = x.make_cd
                              AND a.series_cd = x.series_cd
                              AND a.model_year = x.model_year
                              AND TRUNC (a.eff_date) <= TRUNC (i.eff_date)
                              AND (   x.tsi_amt = a.fmv_value
                                   OR x.tsi_amt BETWEEN a.fmv_value_min
                                                    AND a.fmv_value_max
                                  )
                              AND NVL (a.delete_sw, 'N') <> 'Y'
                              AND ROWNUM = 1
                         ORDER BY a.hist_no DESC;
                      EXCEPTION
                         WHEN NO_DATA_FOUND
                         THEN
                            IF p_validate_mc_fmv = '3'
                            THEN
                               IF giac_validate_user_fn (p_user, 'OF', p_module_id) = 'TRUE'
                               THEN
                                  MESSAGE := '4';
                               ELSE
                                  MESSAGE := '5';
                               END IF;
                            ELSE
                               MESSAGE := '6';
                            END IF;
                             
                            EXIT;
                      END;
                   END LOOP;
                END IF;
            END LOOP;
         ELSE
            v_count := v_count + 1;

            SELECT NVL (menu_line_cd, line_cd)
              INTO v_line_cd
              FROM giis_line
             WHERE line_cd = i.line_cd;

            IF v_line_cd = 'MC'
            THEN
               FOR x IN (SELECT   a.car_company_cd, a.make_cd, a.series_cd,
                                  a.model_year,
                                  SUM (NVL (c.tsi_amt, NVL (b.tsi_amt, 0))
                                      ) tsi_amt
                             FROM gipi_vehicle a,
                                  giex_old_group_itmperil b,
                                  giex_itmperil c,
                                  giis_peril d
                            WHERE a.policy_id = b.policy_id
                              AND a.item_no = b.item_no
                              AND b.policy_id = c.policy_id(+)
                              AND b.item_no = c.item_no(+)
                              AND b.peril_cd = c.peril_cd(+)
                              AND b.line_cd = d.line_cd
                              AND b.peril_cd = d.peril_cd
                              AND b.policy_id = i.policy_id
                              AND d.peril_type = 'B'
                         GROUP BY a.car_company_cd,
                                  a.make_cd,
                                  a.series_cd,
                                  a.model_year)
               LOOP
                  BEGIN
                     SELECT   1
                         INTO v_dummy
                         FROM giis_mc_fmv a
                        WHERE a.car_company_cd = x.car_company_cd
                          AND a.make_cd = x.make_cd
                          AND a.series_cd = x.series_cd
                          AND a.model_year = x.model_year
                          AND TRUNC (a.eff_date) <= TRUNC (i.eff_date)
                          AND (   x.tsi_amt = a.fmv_value
                               OR x.tsi_amt BETWEEN a.fmv_value_min
                                                AND a.fmv_value_max
                              )
                          AND NVL (a.delete_sw, 'N') <> 'Y'
                          AND ROWNUM = 1
                     ORDER BY a.hist_no DESC;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        IF p_validate_mc_fmv = '3'
                        THEN
                           IF giac_validate_user_fn (p_user, 'OF', p_module_id) = 'TRUE'
                           THEN
                              MESSAGE := '4';
                           ELSE
                              MESSAGE := '5';
                           END IF;
                        ELSE
                           MESSAGE := '6';
                        END IF;
                         
                        EXIT;
                  END;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      p_count := v_count;

      IF MESSAGE IN ('4', '5', '6')
      THEN
         RETURN;
      END IF;
   END IF;
   /* end SR-5278 */
   
   /*
   **  Created by   : Irwin Tabisora
   **  Date Created : 8-3-2012
   **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
   **  Description  : changed the majority of the condition based on the latest module 5/9/2012
   */
   FOR a IN
      (SELECT renew_flag, auto_sw, claim_flag, balance_flag, policy_id,
              is_package
         FROM TABLE (giex_expiries_v_pkg.get_expired_policies2 (p_user,
                                                               v_all_user, --p_all_user, joanne 06.25.14
                                                               p_line_cd,
                                                               p_subline_cd,
                                                               p_iss_cd,
                                                               p_issue_yy,
                                                               p_pol_seq_no,
                                                               p_renew_no,
                                                               p_claim_sw,
                                                               p_balance_sw,
                                                               p_intm_name,
                                                               p_intm_no,
                                                               p_range_type,
                                                               p_range,
                                                               p_fm_date,
                                                               p_to_date,
                                                               p_fm_mon,
                                                               p_to_mon,
                                                               p_fm_year,
                                                               p_to_year	/*JOANNE*/
                                                              )
                    )
        WHERE update_flag = 'Y' AND NVL (post_flag, 'N') = 'N')
   LOOP
    v_cred_branch := NULL;
    
    IF NVL(a.is_package, 'N') = 'Y' THEN --benjo 12.20.2016 SR-5621 added condition
        SELECT cred_branch
          INTO v_cred_branch
          FROM gipi_pack_polbasic
         WHERE pack_policy_id = a.policy_id;
    ELSE
        SELECT cred_branch
          INTO v_cred_branch
          FROM gipi_polbasic
         WHERE policy_id = a.policy_id;
    END IF;
        
    IF v_cred_branch IS NULL
    THEN
        raise_application_error(-20001, 'Geniisys Exception#E#Unable to proceed with renewal processing. There are policy/policies with no crediting branch.');
    END IF;    
     
	if a.renew_flag <> 1 then
		renew_flag := 'Y';
	end if;

      v_rec_sw := 'Y';

      IF a.renew_flag = '2'
      THEN
         v_par_sw := 'Y';
      END IF;

    -- for aAR
     IF  a.renew_flag = 3
        AND giac_validate_user_fn (p_user, 'AR', p_module_id) = 'FALSE'
     THEN
        temp_ar_override := 'Y';
        RETURN;
     END IF;

      IF a.renew_flag = '3'
      THEN
         IF NVL (a.auto_sw, 'N') = 'N'
         THEN
            v_update_invalid := REPLACE (v_update_invalid, 'X', 'A');
         ELSIF NVL (a.claim_flag, 'N') = 'Y'
         THEN
            v_update_invalid := REPLACE (v_update_invalid, 'Y', 'C');
         ELSIF NVL (a.balance_flag, 'N') = 'Y'
         THEN
            v_update_invalid := REPLACE (v_update_invalid, 'Z', 'B');
         /*ELSIF NVL(a.dist_sw,'Y') = 'N' THEN
            MSG_ALERT('Policy cannot be auto-renewed , policy or it''s endorsement is not yet distributed.','I',true);*/
         END IF;

          FOR i IN 1 .. 3 --joanne 011314, nilipat sa loob ng IF a.renew_flag = '3' (for AR)
          LOOP
             v_ala := SUBSTR (v_update_invalid, i, 1);

             IF v_ala = 'A'
             THEN
                v_msg := 'with endorsement(s),';
             ELSIF v_ala = 'C'
             THEN
                IF giac_validate_user_fn (p_user, 'AC', p_module_id) <> 'TRUE'
                THEN
                   temp_ac_override := 'Y';
                END IF;
             ELSIF v_ala = 'B'
             THEN
                /*v_msg := v_msg || 'with premium balance(s)';*/
                IF giac_validate_user_fn (p_user, 'AB', p_module_id) <> 'TRUE'
                THEN
                   temp_ab_override := 'Y';
                END IF;
             END IF;
          END LOOP;

          IF v_msg IS NOT NULL
          THEN
             raise_application_error
                (-20001,
                    'Geniisys Exception#I#Policies '
                 || v_msg
                 || ' exists and cannot be auto-renewed. Cannot proceed with processing policies'
                );
          END IF;--end joanne
      END IF;


      IF v_rec_sw = 'N'
      THEN
         raise_application_error
                               (-20001,
                                'Geniisys Exception#I#There are no records tagged for processing.'
                               );
      END IF;

      IF MESSAGE = 0
      THEN
        RETURN;
      END IF;

      IF NVL (p_override_renewal, 'N') = 'Y' THEN
         IF a.renew_flag <> 3 THEN   --joanne 011314, not AR
             IF a.balance_flag = 'Y' AND a.claim_flag = 'Y'
                AND a.renew_flag <> '1'
             THEN
                IF v_par_sw = 'Y'
                THEN
                   IF giac_validate_user_fn (p_user, 'RB', p_module_id) <> 'TRUE'
                      AND a.renew_flag = 2
                   THEN                           -- Udel 11032011 added condition
                      temp_rb_override := 'Y';
                   END IF;
                END IF;

                MESSAGE := '1';
                RETURN;
             --raise_application_error (-20001, 'Geniisys Exception#I#1');
             ELSIF     a.balance_flag = 'Y'
                   AND NVL (a.claim_flag, 'N') = 'N'
                   AND a.renew_flag <> '1'
             THEN
                IF v_par_sw = 'Y'
                THEN
                   IF giac_validate_user_fn (p_user, 'RB', p_module_id) <> 'TRUE'
                      AND a.renew_flag = 2
                   THEN                           -- Udel 11032011 added condition
                      temp_rb_override := 'Y';
                   END IF;
                END IF;

                MESSAGE := '2';
                RETURN;
             --raise_application_error (-20001, 'Geniisys Exception#I#2');
             ELSIF     NVL (a.balance_flag, 'N') = 'N'
                   AND a.claim_flag = 'Y'
                   AND a.renew_flag <> '1'
             THEN
                IF v_par_sw = 'Y'
                THEN
                   IF giac_validate_user_fn (p_user, 'RB', p_module_id) <> 'TRUE'
                      AND a.renew_flag = 2
                   THEN                           -- Udel 11032011 added condition
                      temp_rb_override := 'Y';
                   END IF;
                END IF;

                MESSAGE := '3';
                RETURN;
             -- raise_application_error (-20001, 'Geniisys Exception#I#3');
             END IF;
          END IF;
      END IF;
   END LOOP;
END;
/



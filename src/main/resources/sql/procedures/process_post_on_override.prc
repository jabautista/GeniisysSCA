DROP PROCEDURE CPI.PROCESS_POST_ON_OVERRIDE;

CREATE OR REPLACE PROCEDURE CPI.process_post_on_override(
    p_user                  IN  giex_expiries_v.extract_user%TYPE,
    p_all_user              IN  giis_users.all_user_sw%TYPE,
    p_function_cd           IN  giac_user_functions.function_code%TYPE,
    p_process               IN  VARCHAR2,
    p_line_ac               IN  gipi_polbasic.line_cd%TYPE,
    p_menu_line_cd      IN OUT  giis_line.line_cd%TYPE,
    p_line_ca               IN  gipi_polbasic.line_cd%TYPE,
    p_line_av               IN  gipi_polbasic.line_cd%TYPE,
    p_line_fi               IN  gipi_polbasic.line_cd%TYPE,
    p_line_mc               IN  gipi_polbasic.line_cd%TYPE,
    p_line_mn               IN  gipi_polbasic.line_cd%TYPE,
    p_line_mh               IN  gipi_polbasic.line_cd%TYPE,
    p_line_en               IN  gipi_polbasic.line_cd%TYPE,
    p_vessel_cd             IN  giis_vessel.vessel_cd%TYPE,
    p_subline_bpv       IN OUT  gipi_wpolbas.subline_cd%TYPE,
    p_subline_mop           IN  gipi_wpolbas.subline_cd%TYPE,
    p_subline_mrn           IN  gipi_wpolbas.subline_cd%TYPE,
    p_line_su               IN  gipi_polbasic.line_cd%TYPE,
    p_subline_bbi           IN  gipi_wpolbas.subline_cd%TYPE,
    p_iss_ri                IN  gipi_polbasic.iss_cd%TYPE,
    p_from_post_query       IN  VARCHAR2,
    p_peril_pol_id         OUT  giex_expiry.policy_id%TYPE,
    p_need_commit          OUT  VARCHAR2,
    p_override_ok          OUT  VARCHAR2,
    p_msg                  OUT  VARCHAR2,
    p_msg2                 OUT  VARCHAR2,
    p_message_box          OUT  VARCHAR2,
    p_msg_alert            OUT  VARCHAR2
)
IS
    v_auto_renew_sw   VARCHAR2(1)             := 'N';
    v_rec_sw          VARCHAR2(1)             := 'N';
    v_par_sw          VARCHAR2(1)             := 'N';
    v_all_user        VARCHAR2(1)             := 'N'; --added by joanne 06.25.14, default all_user_sw is N
BEGIN
    /*
    **  Created by   : Robert Virrey
    **  Date Created : 11-17-2011
    **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
    **  Description  : WHEN-BUTTON-PRESSED trigger in OK_BTN in overide_canvas
    */
    FOR i IN (SELECT *
                FROM TABLE(giex_expiries_v_pkg.get_expired_policies(p_user,v_all_user)))--p_all_user))) joanne 06.25.14
    LOOP
        IF i.update_flag = 'Y' THEN
           IF p_function_cd = 'RB' THEN --vin 9.22.2010 added to separate override for 'AR' and 'RB'
              IF giac_validate_user_fn(upper(p_user),'RB','GIEXS004') = 'TRUE' THEN
               --IF v_usr = TRUE THEN
                  -- :CG$CTRL.user_name := null;
                  -- :CG$CTRL.password := null;
                   IF p_process = 'TRUE' THEN -- if the window is called from the process btn.
                         --p_process := FALSE;
                      BEGIN
                              --IF p_form_status = 'QUERY' THEN
                                    -- TEMPORARY for AUTO-RENEWAL RBD 08/31/2000
                                     -- BEGIN
                                 FOR A2 IN (SELECT '1'
                                              FROM giex_expiries_v --giex_expiry (gmi 061207)
                                             WHERE renew_flag = '3'
                                               AND NVL(post_flag,'N') = 'N')
                                 LOOP
                                   v_auto_renew_sw := 'Y';
                                   EXIT;
                                 END LOOP;

                                 /*IF v_auto_renew_sw = 'Y' THEN
                                         MSG_ALERT('Automatic renewal to Policy is temporarily disabled ...','I',TRUE);
                                   END IF;
                                 */
                                     --END

                                 FOR A IN (SELECT '1'
                                             FROM giex_expiries_v --giex_expiry (gmi 061207)
                                            WHERE update_flag = 'Y'
                                              AND NVL(post_flag,'N') = 'N')
                                 LOOP
                                   v_rec_sw   := 'Y';
                                   FOR A2 IN (SELECT '1'
                                                FROM giex_expiries_v --giex_expiry (gmi 061207)
                                               WHERE renew_flag = '2')
                                   LOOP
                                     v_par_sw  := 'Y';
                                     EXIT;
                                   END LOOP;
                                 END LOOP;
                                 IF v_rec_sw = 'Y' THEN
                                    IF v_par_sw = 'Y' THEN
                                          /*FOR A IN (SELECT '1'
                                                   FROM giex_expiry
                                                  WHERE NVL(update_flag,'N')    = 'Y'
                                                    AND NVL(post_flag, 'N')     = 'N'
                                                    AND NVL(balance_flag, 'N')  = 'Y'
                                                    AND extract_user = user)
                                       LOOP
                                         v_switch := 'Y';
                                           EXIT;
                                       END LOOP;
                                       IF v_switch = 'Y' THEN
                                            DECLARE
                                            alert_id       ALERT;
                                            alert_but      NUMBER;
                                          BEGIN
                                            alert_id   := FIND_ALERT('WITH_BALANCE');
                                            alert_but  := SHOW_ALERT(ALERT_ID);
                                            IF alert_but = ALERT_BUTTON2 THEN
                                               RETURN;
                                            END IF;
                                          END;
                                       END IF;   */ --commented by jen 06.06.05
                                       p_msg_alert := 3;
                                       --p_msg := 'Policy(s) that will be renewed to PAR will not copy discount records and co-insurance information.';
                                    END IF;
                                    --CLEAR_MESSAGE;
                                    PROCESS_POST(v_all_user/*p_all_user, joanne 06.25.14*/, p_user, p_line_ac, p_menu_line_cd, p_line_ca, p_line_av, p_line_fi, p_line_mc, p_line_mn, p_line_mh, p_line_en, p_vessel_cd, p_subline_bpv,
                                         p_subline_mop, p_subline_mrn, i.line_cd, p_line_su, i.line_cd, i.iss_cd, p_subline_bbi, p_iss_ri, p_msg, p_message_box);
                                         IF p_msg_alert is null THEN
                                            p_msg_alert := 4;
                                         END IF;
                                    --:CONTROL.TAG_FOR_PERILS := NULL;
                                 ELSE
                                    --MSG_ALERT('There are no records tagged for processing.','I',TRUE);
                                    p_msg := 'There are no records tagged for processing.';
                                 END IF;
                              /*ELSE
                                  IF p_renew_flag = '1' THEN
                                      FOR a IN(SELECT DISTINCT param_value_v status
                                                 FROM giis_parameters
                                                WHERE param_name LIKE 'REQUIRE_NON_RENEW_REASON')
                                      LOOP
                                          v_status := a.status;
                                      END LOOP;
                                      IF v_status = 'Y' AND p_non_ren_reason IS NULL THEN
                                          --go_item('F000.non_ren_reason');
                                          msg_alert('Please enter non-renewal reason.','I',TRUE);
                                      END IF;
                                  END IF;

                              MSG_ALERT('Please save changes first before pressing the PROCESS button.','I',TRUE);*/
                             -- END IF;
                          EXCEPTION
                                 WHEN DUP_VAL_ON_INDEX THEN
                                     p_msg_alert := 1;
                                     p_msg := 'Cannot insert record, duplicate records monitored.';
                                     RETURN;
                                 WHEN NO_DATA_FOUND THEN
                                     p_msg_alert := 1;
                                     p_msg := 'Cannot find record, please call your DBA.';
                                     RETURN;
                          END;
                END IF;
               --ELSE
               --         msg_alert(' '||' Username or Password is wrong.', 'E', TRUE);
               --        variables.v_proceed := 'N';

               --END IF;

              --added by vin 9.28.2010 to do the last validations
               --:F000.UPDATE_FLAG := 'Y';
               --variables.v_proceed := 'Y';
                  -- animate_overide_popup('OVERIDE_WINDOW', 'Overide User', 'OVERIDE_CANVAS', 'f000','HIDE');
                  -- go_item('F000.renew_flag');
                   --ar_VALIDATION;
              giex_expiry_pkg.ar_validation(i.is_package, p_from_post_query, i.policy_id, i.update_flag, i.same_polno_sw, i.summary_sw,
                                            i.non_ren_reason, i.non_ren_reason_cd, p_peril_pol_id, p_need_commit, p_override_ok, p_msg2);

              ELSE
                  p_msg_alert := 1;
                  p_msg:=UPPER(p_user)||' is not allowed to process policy.';
                   --:f000.update_flag := 'N';
                  --SET_RECORD_PROPERTY(:SYSTEM.CURSOR_RECORD, 'f000', STATUS, QUERY_STATUS);
                  --p_proceed := 'N';
              END IF;

           -- vin 9.22.2010 added for 'AR' OVERRIDE
           --------------------------------------------------------------------------------------------
           ELSE
              IF giac_validate_user_fn(upper(p_user),'AR','GIEXS004') = 'TRUE' THEN
                p_msg_alert := 2;
                RETURN;
                /*IF v_usr = TRUE THEN
                   :CG$CTRL.user_name := null;
                   :CG$CTRL.password := null;
                   variables.v_proceed := 'Y';
                   go_item('F000.renew_flag');
                   animate_overide_popup('OVERIDE_WINDOW', 'Overide User', 'OVERIDE_CANVAS', 'f000','HIDE');
                   verify_override_rb;
                  ELSE
                        msg_alert(' '||' Username or Password is wrong.', 'E', TRUE);
                        variables.v_proceed := 'N';
                END IF; */
              ELSE
                   --msg_alert(UPPER(:cg$ctrl.user_name)||' is not allowed to process policy.', 'E', TRUE);
                   p_msg_alert := 1;
                   p_msg:=UPPER(p_user)||' is not allowed to process policy.';
                   --:f000.update_flag := 'N';
                   --SET_RECORD_PROPERTY(:SYSTEM.CURSOR_RECORD, 'f000', STATUS, QUERY_STATUS);
                   --variables.v_proceed := 'N';
              END IF;
            --------------------------------------------------------------------------------------------
           END IF;
        END IF;
    END LOOP;
END;
/



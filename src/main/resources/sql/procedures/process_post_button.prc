DROP PROCEDURE CPI.PROCESS_POST_BUTTON;

CREATE OR REPLACE PROCEDURE CPI.PROCESS_POST_BUTTON(
    p_user                  IN  giex_expiries_v.extract_user%TYPE,
    p_all_user              IN  giis_users.all_user_sw%TYPE,
    p_override_ok           IN  VARCHAR2,
    p_override              IN  giis_parameters.param_value_v%TYPE,
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
    p_allow_ar_wdist        IN  VARCHAR2, --joanne 06.25.14
    p_msg_alert            OUT  VARCHAR2,
    p_msg                  OUT  VARCHAR2,
    p_message_box          OUT  VARCHAR2
)
IS
    v_rec_sw          VARCHAR2(1)             := 'N';
    v_par_sw          VARCHAR2(1)             := 'N';
    v_update_invalid  VARCHAR2(3)             :='XYZ';
    v_ala             VARCHAR2(1)             :=NULL;
    v_msg             VARCHAR2(500)           :=NULL;
    v_auto_renew_sw   VARCHAR2(1)             := 'N';
    v_switch          VARCHAR2(1)             := 'N';
    v_tagged          VARCHAR2(1)             := 'N';
    v_all_user        VARCHAR2(1)             := 'N'; --added by joanne 06.25.14, default all_user_sw is N
BEGIN
    /*
    **  Created by   : Robert Virrey
    **  Date Created : 11-17-2011
    **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
    **  Description  : WHEN-BUTTON-PRESSED trigger in POST_BUTTON
    */
    FOR i IN (SELECT *
                FROM TABLE(giex_expiries_v_pkg.get_expired_policies(p_user, v_all_user)))--p_all_user))) joanne 06.25.14
    LOOP
        IF i.update_flag = 'Y' THEN
              v_tagged := 'Y';
              FOR A IN (SELECT renew_flag, auto_sw, claim_flag, balance_flag, policy_id, is_package
                          FROM giex_expiries_v --giex_expiry (gmi 061207)
                         WHERE update_flag = 'Y'
                           AND NVL(post_flag,'N') = 'N')
              LOOP
                v_rec_sw   := 'Y';
                IF a.renew_flag = '2' THEN
                    v_par_sw  := 'Y';
                END IF;
                IF a.renew_flag = '3' THEN
                    IF nvl(a.auto_sw,'N') = 'N' THEN
                       v_update_invalid := REPLACE(v_update_invalid,'X', 'A');
                    ELSIF nvl(a.claim_flag,'N') = 'Y' THEN
                       v_update_invalid := REPLACE(v_update_invalid,'Y', 'C');
                    ELSIF NVL(a.balance_flag,'N') = 'Y' THEN
                       v_update_invalid := REPLACE(v_update_invalid,'Z', 'B');
                    /*ELSIF NVL(a.dist_sw,'Y') = 'N' THEN
                       MSG_ALERT('Policy cannot be auto-renewed , policy or it''s endorsement is not yet distributed.','I',true);*/
                    END IF;
                    END IF;
              END LOOP;
              FOR i IN 1.. 3 LOOP
                  v_ala := SUBSTR(v_update_invalid, i, 1);
                  IF v_ala = 'A' THEN
                      v_msg := 'with endorsement(s),';
                  ELSIF v_ala = 'C' THEN
                      v_msg := v_msg||'with pending claims,';
                  ELSIF v_ala = 'B' THEN
                      v_msg := v_msg||'with premium balance(s)';
                  END IF;
              END LOOP;
              IF v_msg IS NOT NULL AND p_override_ok = 'N' THEN
                  p_msg_alert := 6;
                  p_msg := 'Policies '||v_msg||' exists and cannot be auto-renewed. Cannot proceed with processing policies';
                  RETURN;
              END IF;
              /*IF v_rec_sw = 'N' THEN
                  p_msg := 'There are no records tagged for processing.';
                  RETURN;
              END IF;*/
              /* added by gmi
              ** checking of auto_renewal upon creation of policy.. auto_renew tagged on basic info..
              ** do not allow processing of auto-renewal for policy with outstanding balance

              IF :f000.renew_flag = '3' THEN
                 IF nvl(:f000.auto_sw,'N') = 'N' THEN
                    MSG_ALERT('Policy with endorsement(s) cannot be auto-renewed.','I',true);
                 ELSIF nvl(:f000.claim_flag,'N') = 'Y' THEN
                    MSG_ALERT('Policy with pending claims cannot be auto-renewed.','I',true);
                 ELSIF NVL(:f000.balance_flag,'N') = 'Y' THEN
                    MSG_ALERT('Policy with premium balance(s) cannot be auto-renewed.','I',true);
                 ELSIF NVL(:f000.dist_sw,'Y') = 'N' THEN
                    MSG_ALERT('Policy cannot be auto-renewed , policy or it''s endorsement is not yet distributed.','I',true);
                 END IF;
              END IF;*/

                /*Added by jen 05.30.05
                **To know if the user is allowed to override. */
              IF nvl(p_override,'N') = 'Y' THEN
                   IF i.balance_flag = 'Y' AND i.claim_flag ='Y' AND i.renew_flag <> '1'  AND p_override_ok = 'N' THEN
                        p_msg_alert := 1;
                        p_msg := 'Policy has an outstanding premium balance and claim. Cannot process policy for renewal. Would you like to override?';
                        RETURN;
                         /*v_alert_msg := 'Policy has an outstanding premium balance and claim. '||
                                        'Cannot process policy for renewal. Would you like to override?';
                         v_alert_id := FIND_ALERT('CHECK_BAL_DUE');
                         SET_ALERT_PROPERTY(v_alert_id,ALERT_MESSAGE_TEXT,v_alert_msg);
                         v_alert_btn := SHOW_ALERT(v_alert_id);
                         IF v_alert_btn = ALERT_BUTTON1 THEN
                              variables.v_process := TRUE;
                             animate_overide_popup('OVERIDE_WINDOW', 'Overide User', 'OVERIDE_CANVAS', 'f000','show');
                         /*
                         ELSE
                              :f000.update_flag := 'N';
                              SET_RECORD_PROPERTY(:SYSTEM.CURSOR_RECORD, 'f000', STATUS, QUERY_STATUS);

                         END IF;*/
                   ELSIF i.balance_flag = 'Y' AND nvl(i.claim_flag,'N') ='N' AND i.renew_flag <> '1'  AND p_override_ok = 'N'  THEN
                        p_msg_alert := 2;
                        p_msg := 'Policy has an outstanding premium balance. Cannot process policy for renewal. Would you like to override?';
                        RETURN;
                         /*v_alert_msg := 'Policy has an outstanding premium balance. '||
                                        'Cannot process policy for renewal. Would you like to override?';
                         v_alert_id := FIND_ALERT('CHECK_BAL_DUE');
                         SET_ALERT_PROPERTY(v_alert_id,ALERT_MESSAGE_TEXT,v_alert_msg);
                         v_alert_btn := SHOW_ALERT(v_alert_id);
                         IF v_alert_btn = ALERT_BUTTON1 THEN
                              variables.v_process := TRUE;
                             animate_overide_popup('OVERIDE_WINDOW', 'Overide User', 'OVERIDE_CANVAS', 'f000','show');
                         /*
                         ELSE
                              :f000.update_flag := 'N';
                              SET_RECORD_PROPERTY(:SYSTEM.CURSOR_RECORD, 'f000', STATUS, QUERY_STATUS);
                        END IF;*/
                   ELSIF nvl(i.balance_flag,'N') = 'N' AND i.claim_flag ='Y' AND i.renew_flag <> '1'  AND p_override_ok = 'N'  THEN
                        p_msg_alert := 3;
                        p_msg := 'Policy has claim. Cannot process policy for renewal. Would you like to override?';
                        RETURN;
                         /*v_alert_msg := 'Policy has claim. '||
                                        'Cannot process policy for renewal. Would you like to override?';
                         v_alert_id := FIND_ALERT('CHECK_BAL_DUE');
                         SET_ALERT_PROPERTY(v_alert_id,ALERT_MESSAGE_TEXT,v_alert_msg);
                         v_alert_btn := SHOW_ALERT(v_alert_id);
                         IF v_alert_btn = ALERT_BUTTON1 THEN
                              variables.v_process := TRUE;
                             animate_overide_popup('OVERIDE_WINDOW', 'Overide User', 'OVERIDE_CANVAS', 'f000','show');
                         /*
                         ELSE
                              :f000.update_flag := 'N';
                              SET_RECORD_PROPERTY(:SYSTEM.CURSOR_RECORD, 'f000', STATUS, QUERY_STATUS);

                         END IF;     */
                   ELSE
                   --ELSIF variables.v_override_ok = 'Y'  THEN
                         BEGIN
                              --msg_alert(:system.form_status,'i',false);
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
                                 IF v_par_sw = 'Y' THEN
                                       FOR A IN (SELECT '1'
                                                   FROM giex_expiries_v --giex_expiry (gmi 061207)
                                                  WHERE NVL(update_flag,'N')    = 'Y'
                                                    AND NVL(post_flag, 'N')     = 'N'
                                                    AND NVL(balance_flag, 'N')  = 'Y'
                                                    --AND decode(p_all_user,'Y',p_user,extract_user) = p_user) joanne 06.25.14
                                                    AND decode(v_all_user,'Y',p_user,extract_user) = p_user)
                                    LOOP
                                        v_switch := 'Y';
                                        EXIT;
                                    END LOOP;
                                    /*IF v_switch = 'Y' THEN
                                       p_msg_alert := 5;
                                       RETURN;
                                       /*  DECLARE
                                        alert_id       ALERT;
                                        alert_but      NUMBER;
                                       BEGIN
                                        alert_id   := FIND_ALERT('WITH_BALANCE');
                                        alert_but  := SHOW_ALERT(ALERT_ID);
                                          IF alert_but = ALERT_BUTTON2 THEN
                                             RETURN;
                                          END IF;
                                       END;  */
                                    /*END IF; */
                                    IF i.renew_flag <> '1' THEN
                                       p_msg_alert := 7;
                                       --p_msg := 'Policy(s) that will be renewed to PAR will not copy discount records and co-insurance information.';
                                    END IF;
                                 END IF;

                                --CLEAR_MESSAGE;
                                --msg_alert('1','i',false);
                                PROCESS_POST(v_all_user/*p_all_user, joanne 06.25.14*/, p_user, p_line_ac, p_menu_line_cd, p_line_ca, p_line_av, p_line_fi, p_line_mc, p_line_mn, p_line_mh, p_line_en, p_vessel_cd, p_subline_bpv,
                                             p_subline_mop, p_subline_mrn, i.line_cd, p_line_su, i.line_cd, i.iss_cd, p_subline_bbi, p_iss_ri, p_msg, p_message_box);
                                IF p_msg_alert is null THEN
                                    p_msg_alert := 8;
                                END IF;
                                --msg_alert('2','i',false);
                                --:CONTROL.TAG_FOR_PERILS := NULL;
                              /*ELSE--modified by VJ 120905
                                  IF p_renew_flag = '1' THEN
                                      IF p_require_nr_reason = 'Y' AND p_non_ren_reason_cd IS NULL THEN --mod by randell 03062007, checks if cd field is null (previously set to description)
                                          --go_item('F000.non_ren_reason_cd');
                                          p_msg := 'Please enter non-renewal reason.';
                                          RETURN;
                                      END IF;
                                  END IF;
                                 p_msg := 'Please save changes first before pressing the PROCESS button.';
                                 RETURN;
                              END IF;*/
                            EXCEPTION
                               WHEN DUP_VAL_ON_INDEX THEN
                                 p_msg_alert := 4;
                                 p_msg := 'Cannot insert record, duplicate records monitored.';
                                 RETURN;
                               WHEN NO_DATA_FOUND THEN
                                 p_msg_alert := 4;
                                 p_msg := 'Cannot find record, please call your DBA.';
                                 RETURN;
                            END;
                   END IF;
              ELSE
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
                                   FOR A IN (SELECT '1'
                                               FROM giex_expiries_v --giex_expiry (gmi 061207)
                                              WHERE NVL(update_flag,'N')    = 'Y'
                                                AND NVL(post_flag, 'N')     = 'N'
                                                AND NVL(balance_flag, 'N')  = 'Y'
                                                --AND decode(p_all_user,'Y',p_user,extract_user) = p_user)
                                                AND decode(v_all_user,'Y',p_user,extract_user) = p_user)
                               LOOP
                                    v_switch := 'Y';
                                    EXIT;
                               END LOOP;
                               /*IF v_switch = 'Y' THEN
                                   p_msg := 5;
                                   RETURN;
                                 /*    DECLARE
                                    alert_id       ALERT;
                                    alert_but      NUMBER;
                                  BEGIN
                                    alert_id   := FIND_ALERT('WITH_BALANCE');
                                    alert_but  := SHOW_ALERT(ALERT_ID);
                                    IF alert_but = ALERT_BUTTON2 THEN
                                       RETURN;
                                    END IF;
                                  END;  */
                               /*END IF;*/
                               IF i.renew_flag <> '1' THEN
                                   --MSG_ALERT(:f000.renew_flag,'i',FALSE);
                                   p_msg_alert := 7;
                                   --p_msg := 'Policy(s) that will be renewed to PAR will not copy discount records and co-insurance information.';
                               END IF;
                            END IF;
                            --CLEAR_MESSAGE;
                            PROCESS_POST(v_all_user/*p_all_user, joanne 06.25.14*/, p_user, p_line_ac, p_menu_line_cd, p_line_ca, p_line_av, p_line_fi, p_line_mc, p_line_mn, p_line_mh, p_line_en, p_vessel_cd, p_subline_bpv,
                                             p_subline_mop, p_subline_mrn, i.line_cd, p_line_su, i.line_cd, i.iss_cd, p_subline_bbi, p_iss_ri, p_msg, p_message_box);
                            IF p_msg_alert is null THEN
                                p_msg_alert := 8;
                            END IF;
                            --:CONTROL.TAG_FOR_PERILS := NULL;
                         ELSE
                            p_msg := 'There are no records tagged for processing.';
                         END IF;
                      /*ELSE
                          IF p_renew_flag = '1' THEN
                              IF p_require_nr_reason = 'Y' AND p_non_ren_reason IS NULL THEN
                                  --go_item('F000.non_ren_reason');
                                  p_msg := 'Please enter non-renewal reason.';
                              END IF;
                          END IF;
                          p_msg := 'Please save changes first before pressing the PROCESS button.';
                      END IF;*/
                     EXCEPTION
                           WHEN DUP_VAL_ON_INDEX THEN
                             p_msg_alert := 4;
                             p_msg := 'Cannot insert record, duplicate records monitored.';
                             RETURN;
                           WHEN NO_DATA_FOUND THEN
                             p_msg_alert := 4;
                             p_msg := 'Cannot find record, please call your DBA.';
                             RETURN;
                        END;
                END IF;
        END IF;
    END LOOP;
    IF v_tagged = 'N' THEN
        p_msg_alert := 9;
        p_msg := 'There are no records tagged for processing.';
    END IF;
END;
/



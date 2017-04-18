DROP PROCEDURE CPI.PROCESS_POST;

CREATE OR REPLACE PROCEDURE CPI.PROCESS_POST(
    p_all_user              IN  VARCHAR2,
    p_user                  IN  giex_expiry.extract_user%TYPE,
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
    p_nbt_line_cd           IN  gipi_pack_polbasic.line_cd%TYPE,
    p_line_su               IN  gipi_polbasic.line_cd%TYPE,
    p_dsp_line_cd           IN  giis_line_subline_coverages.line_cd%TYPE,
    p_dsp_iss_cd            IN  giis_intm_special_rate.iss_cd%TYPE,
    p_subline_bbi           IN  gipi_wpolbas.subline_cd%TYPE,
    p_iss_ri                IN  gipi_polbasic.iss_cd%TYPE,
    p_msg                  OUT  VARCHAR2,
    p_message_box          OUT  VARCHAR2
)
IS
x_policy         NUMBER(8);
x_acct_ent_date  DATE;
x_line_cd        GIPI_PARLIST.line_cd%TYPE;  -- 14 September 1997 (MiB)
                                             -- To be used as parameter to determine the line
                                             -- code by using the giis_parameters.
x_subline_cd     GIPI_POLBASIC.subline_cd%TYPE;
                                             -- Would only be used for cases
                                             -- where the line code = 'MN'
                                             -- and subline used is an open policy.
x_var            NUMBER  :=  1;
v_where          VARCHAR2(32767);


v_new_pack_par_id     gipi_parlist.pack_par_id%TYPE := NULL;
v_new_pack_policy_id  gipi_polbasic.pack_policy_id%TYPE := NULL;
v_is_package          VARCHAR2(1);
v_new_par_id          gipi_wpolnrep.par_id%TYPE;
v_new_policy_id       gipi_polbasic.policy_id%TYPE;
v_old_pol_id          giex_expiry.policy_id%TYPE;
v_user_id             giex_expiry.user_id%TYPE;
v_last_update         DATE;
v_proc_expiry_date    giex_expiry.expiry_date%TYPE;
v_proc_subline_cd     giex_expiry.subline_cd%TYPE;
v_proc_line_cd        giex_expiry.line_cd%TYPE;
v_proc_iss_cd         giex_expiry.iss_cd%TYPE;
v_proc_assd_no        giex_expiry.assd_no%TYPE;
v_proc_incept_date    giex_expiry.incept_date%TYPE;
v_proc_renew_flag     giex_expiry.renew_flag%TYPE;
v_proc_same_polno_sw  giex_expiry.same_polno_sw%TYPE;
v_proc_summary_sw     giex_expiry.summary_sw%TYPE;
v_proc_intm_no        giex_expiry.intm_no%TYPE;
v_old_pol_id_pack     giex_expiry.pack_policy_id%TYPE;
v_open_flag           giis_subline.op_flag%TYPE;
v_open_policy_sw      giis_subline.open_policy_sw%TYPE;
v_policy_id           gipi_wpolnrep.old_policy_id%TYPE;
v_pack_sw             gipi_pack_polbasic.pack_pol_flag%TYPE;
v_long                gipi_polgenin.gen_info%TYPE;
v_bpv			      giis_parameters.param_name%TYPE := 'BOILER_AND_PRESSURE_VESSEL';
v_dist_no_new         giuw_pol_dist.dist_no%TYPE;
v_dist_no_old   	  giuw_pol_dist.dist_no%TYPE;
v_is_subpolicy        VARCHAR2(1);
v_allow_ar_wdist      VARCHAR2(1); --joanne 06.25.14, parameter for copy_policy
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-24-2011
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
  **  Description  : PROCESS_POST program unit
  */
    --v_where := get_block_property('F000',default_where); -- to get the original where condition
    --INCREASE_ITEM_WIDTH(:cg$ctrl.message);
    --GO_BLOCK('F000');
--    FIRST_RECORD;

    --joanne 06.25.14, get value of parameter for copy_policy proc
    BEGIN
         SELECT param_value_v
           INTO v_allow_ar_wdist
           FROM giis_parameters
          WHERE param_name LIKE 'ALLOW_AUTO_RENEW_WITH_DIST';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_allow_ar_wdist := 'N';
      END;

--    WHILE (x_var = 1) LOOP
      FOR A IN (SELECT policy_id, expiry_date, line_cd, subline_cd, renew_flag,
                     summary_sw, same_polno_sw, assd_no, incept_date, iss_cd,
                     intm_no, pack_policy_id, issue_yy, pol_seq_no, renew_no, is_package,balance_flag
                FROM (SELECT POLICY_ID, EXPIRY_DATE, RENEW_FLAG, LINE_CD, SUBLINE_CD, SAME_POLNO_SW, CPI_REC_NO, CPI_BRANCH_CD, ISS_CD, POST_FLAG, BALANCE_FLAG, CLAIM_FLAG, EXTRACT_USER, EXTRACT_DATE, USER_ID, LAST_UPDATE, DATE_PRINTED, NO_OF_COPIES, AUTO_RENEW_FLAG, UPDATE_FLAG, TSI_AMT, PREM_AMT, SUMMARY_SW, INCEPT_DATE, ASSD_NO, AUTO_SW, TAX_AMT, POLICY_TAX_AMT, ISSUE_YY, POL_SEQ_NO, RENEW_NO, COLOR, MOTOR_NO, MODEL_YEAR, MAKE, SERIALNO, PLATE_NO, REN_NOTICE_CNT, REN_NOTICE_DATE, ITEM_TITLE, LOC_RISK1, LOC_RISK2, LOC_RISK3, CAR_COMPANY, INTM_NO, REMARKS, ORIG_TSI_AMT, SMS_FLAG, RENEWAL_ID, REG_POLICY_SW, ASSD_SMS, INTM_SMS, EMAIL_DOC, EMAIL_SW, EMAIL_STAT, ASSD_EMAIL, INTM_EMAIL, NON_REN_REASON, COC_SERIAL_NO, NON_REN_REASON_CD, NVL(PACK_POLICY_ID,0) PACK_POLICY_ID, 'N' IS_PACKAGE
                        FROM GIEX_EXPIRY
                     UNION ALL
                    SELECT PACK_POLICY_ID, EXPIRY_DATE, RENEW_FLAG, LINE_CD, SUBLINE_CD, SAME_POLNO_SW, -23, '-O', ISS_CD, POST_FLAG, BALANCE_FLAG, CLAIM_FLAG, EXTRACT_USER, EXTRACT_DATE, USER_ID, LAST_UPDATE, DATE_PRINTED, NO_OF_COPIES, AUTO_RENEW_FLAG, UPDATE_FLAG, TSI_AMT, PREM_AMT, SUMMARY_SW, INCEPT_DATE, ASSD_NO, AUTO_SW, TAX_AMT, POLICY_TAX_AMT, ISSUE_YY, POL_SEQ_NO, RENEW_NO, COLOR, MOTOR_NO, MODEL_YEAR, MAKE, SERIALNO, PLATE_NO, REN_NOTICE_CNT, REN_NOTICE_DATE, ITEM_TITLE, LOC_RISK1, LOC_RISK2, LOC_RISK3, CAR_COMPANY, INTM_NO, REMARKS, ORIG_TSI_AMT, SMS_FLAG, RENEWAL_ID, REG_POLICY_SW, ASSD_SMS, INTM_SMS, EMAIL_DOC, EMAIL_SW, EMAIL_STAT, ASSD_EMAIL, INTM_EMAIL, NON_REN_REASON, COC_SERIAL_NO, NON_REN_REASON_CD, PACK_POLICY_ID, 'Y' IS_PACKAGE
                      FROM GIEX_PACK_EXPIRY) a
               WHERE NVL(update_flag,'N') = 'Y'
                 AND NVL(post_flag, 'N')  = 'N'
                 --AND NVL(balance_flag,'Y') = 'N' ----ANTHONY SANTOS 05/01/2008------
                 AND decode(p_all_user,'Y',p_user,extract_user) = p_user
               ORDER BY pack_policy_id, is_package DESC)
    LOOP
          --SYNCHRONIZE;
          v_is_subpolicy        := 'N';
          IF a.is_package = 'Y' THEN
              v_new_pack_par_id    := NULL;
              v_new_pack_policy_id := NULL;
          ELSE
              IF a.pack_policy_id > 0 THEN
                  v_is_subpolicy    := 'Y';
              ELSE
                  v_new_pack_par_id    := NULL;
                  v_new_pack_policy_id := NULL;
                  --NULL;
              END IF;
          END IF;
          v_is_package         := a.is_package;
          /* Initialize the variables */
          --v_item_no            := NULL;
          --v_peril_cd           := NULL;
          v_new_par_id         := NULL;
          v_new_policy_id      := NULL;
          v_old_pol_id         := a.policy_id;
          --v_new_pol_seq_no     := NULL;
          --v_def_where          := NULL;
          --v_remarks            := NULL;
          v_user_id            := p_user;
          v_last_update        := sysdate;
          --v_status_cd          := NULL;
          v_proc_expiry_date   := a.expiry_date;
          x_subline_cd         := a.subline_cd;
          x_line_cd            := a.line_cd;
          v_proc_subline_cd    := a.subline_cd;
          v_proc_line_cd       := a.line_cd;
          v_proc_iss_cd        := a.iss_cd;
          v_proc_assd_no       := a.assd_no;
          v_proc_incept_date   := a.incept_date;
          v_proc_renew_flag    := a.renew_flag;
          v_proc_same_polno_sw := a.same_polno_sw;
          v_proc_summary_sw    := a.summary_sw;
          v_proc_intm_no       := a.intm_no;
          v_old_pol_id_pack    := a.pack_policy_id;
    IF v_is_package = 'N' THEN --start IF V_IS_PACKAGE ("1st IF" is for package detail records AND non-package records..)
        FOR B IN (SELECT line_cd, subline_cd,iss_cd, issue_yy, pol_seq_no, renew_no
                    FROM gipi_polbasic
                   WHERE policy_id = v_old_pol_id)
        LOOP
           IF v_is_subpolicy = 'N' THEN
                /*recgrp_row('DISPLAY_RENEWALS',variables.old_pol_id,
                           p_pol=>b.line_cd||'-'||b.subline_cd||'-'|| b.iss_cd||'-'||
                         to_char(b.issue_yy,'09')||'-'||to_char(b.pol_seq_no,'0999999')||'-'||to_char(b.renew_no,'09') -- pol_num
                         );*/
              p_message_box  := 'Processing Policy No.                          '||
                                                        b.line_cd||'-'||b.subline_cd||'-'|| b.iss_cd||'-'||
                                    to_char(b.issue_yy,'09')||'-'||to_char(b.pol_seq_no,'0999999')||'-'||to_char(b.renew_no,'09');
            END IF;
          BEGIN
            SELECT op_flag,open_policy_sw
              INTO v_open_flag,v_open_policy_sw
              FROM giis_subline
             WHERE line_cd    = v_proc_line_cd AND
                   subline_cd = v_proc_subline_cd;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                p_msg := 'No record found in giis subline for line and subline of policy '||
                           b.line_cd||'-'||b.subline_cd||'-'|| b.iss_cd||'-'||
                           to_char(b.issue_yy,'09')||to_char(b.pol_seq_no,'0999999')||'-'||to_char(b.renew_no,'09');
          END;
        END LOOP;

    UPDATE giex_expiry
       SET post_flag = 'Y'
     WHERE policy_id = v_old_pol_id;

    IF a.RENEW_FLAG = '1' THEN -- Non renewed
            IF a.expiry_date >= SYSDATE THEN
                 UPDATE gipi_polbasic
                    SET renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
            ELSE
                 UPDATE gipi_polbasic
                    SET pol_flag = 'X',
                        renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
            END IF;
            IF v_is_subpolicy = 'N' THEN
               p_message_box:= p_message_box||'   Policy not renewed.';
            END IF;
     ELSIF a.RENEW_FLAG = '2' THEN -- Renewed
         extract_summary(v_is_package, v_proc_expiry_date, v_proc_assd_no, v_proc_same_polno_sw, v_old_pol_id, v_proc_summary_sw, v_proc_renew_flag, v_new_pack_par_id, v_user_id,v_new_par_id,
                        v_old_pol_id_pack, p_line_ac, p_menu_line_cd, p_line_ca, p_line_av, p_line_fi, p_line_mc, p_line_mn, p_line_mh, p_line_en, p_vessel_cd, p_subline_bpv, v_open_flag,
                        p_nbt_line_cd, p_line_su, v_proc_intm_no, p_dsp_line_cd, p_dsp_iss_cd, v_proc_line_cd, v_proc_subline_cd, p_subline_bbi, v_is_subpolicy, p_message_box, p_msg);
         IF a.expiry_date >= SYSDATE THEN
                 UPDATE gipi_polbasic
                    SET renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
              ELSE
                 UPDATE gipi_polbasic
                    SET pol_flag = 'X',
                        renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
              END IF;
         ELSIF a.RENEW_FLAG = '3' THEN -- Auto-renewal
        copy_policy(v_proc_line_cd,p_menu_line_cd,v_is_package,v_new_policy_id,v_new_pack_policy_id,p_msg,
                p_message_box,v_old_pol_id,v_policy_id,v_proc_expiry_date,v_proc_incept_date,v_proc_assd_no,
                v_proc_same_polno_sw,v_new_par_id,v_new_pack_par_id,v_proc_renew_flag,v_user_id,v_pack_sw, v_long,
                v_proc_iss_cd,p_iss_ri,p_line_mn,v_open_flag,p_line_ac,p_line_su,p_line_ca,p_line_en,v_bpv,
                p_subline_bpv,v_proc_subline_cd,p_line_fi,p_line_mc,p_line_mh,p_line_av,p_subline_mop,p_subline_mrn,
                v_is_subpolicy,v_dist_no_old,v_dist_no_new,v_allow_ar_wdist); --joanne 06.25.14, add v_allow_ar_wdist
              IF a.expiry_date >= SYSDATE THEN
                 UPDATE gipi_polbasic
                    SET renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
              ELSE
                 UPDATE gipi_polbasic
                    SET pol_flag = 'X',
                        renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
              END IF;

           END IF;
           /*IF :system.last_record = 'TRUE' THEN
              X_VAR := 0;
           ELSE
              NEXT_RECORD;
           END IF;*/
    ELSE -- else IF of V_IS_PACKAGE ("else" is for package main records..)
         FOR B IN (SELECT line_cd, subline_cd,iss_cd, issue_yy, pol_seq_no, renew_no
                    FROM gipi_pack_polbasic
                   WHERE pack_policy_id = v_old_pol_id)
        LOOP
          /*recgrp_row('DISPLAY_RENEWALS',variables.old_pol_id,
                                 p_pol=>b.line_cd||'-'||b.subline_cd||'-'|| b.iss_cd||'-'||
                                to_char(b.issue_yy,'09')||'-'||to_char(b.pol_seq_no,'0999999')||'-'||to_char(b.renew_no,'09')-- pol_num
                                );*/
          p_message_box:= 'Processing Package Policy No.                          '||
                                                    b.line_cd||'-'||b.subline_cd||'-'|| b.iss_cd||'-'||
                                to_char(b.issue_yy,'09')||'-'||to_char(b.pol_seq_no,'0999999')||'-'||to_char(b.renew_no,'09');
          BEGIN
            SELECT op_flag,open_policy_sw
              INTO v_open_flag,v_open_policy_sw
              FROM giis_subline
             WHERE line_cd    = v_proc_line_cd AND
                   subline_cd = v_proc_subline_cd;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                p_msg := 'No record found in giis subline for line and subline of package '||
                           b.line_cd||'-'||b.subline_cd||'-'|| b.iss_cd||'-'||
                           to_char(b.issue_yy,'09')||to_char(b.pol_seq_no,'0999999')||'-'||to_char(b.renew_no,'09');
          END;
        END LOOP;
    UPDATE giex_pack_expiry
       SET post_flag = 'Y'
     WHERE pack_policy_id = v_old_pol_id;

    IF a.RENEW_FLAG = '1' THEN -- Non renewed
            IF a.expiry_date >= SYSDATE THEN
                 UPDATE gipi_pack_polbasic
                    SET renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND pack_policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
            ELSE
                 UPDATE gipi_pack_polbasic
                    SET pol_flag = 'X',
                        renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND pack_policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
            END IF;
            p_message_box:= p_message_box||'   Package policy not renewed.';

    ELSIF a.RENEW_FLAG = '2' THEN -- Renewed
          extract_summary(v_is_package, v_proc_expiry_date, v_proc_assd_no, v_proc_same_polno_sw, v_old_pol_id, v_proc_summary_sw, v_proc_renew_flag, v_new_pack_par_id, v_user_id,v_new_par_id,
                        v_old_pol_id_pack, p_line_ac, p_menu_line_cd, p_line_ca, p_line_av, p_line_fi, p_line_mc, p_line_mn, p_line_mh, p_line_en, p_vessel_cd, p_subline_bpv, v_open_flag,
                        p_nbt_line_cd, p_line_su, v_proc_intm_no, p_dsp_line_cd, p_dsp_iss_cd, v_proc_line_cd, v_proc_subline_cd, p_subline_bbi, v_is_subpolicy, p_message_box, p_msg);
         IF a.expiry_date >= SYSDATE THEN
                 UPDATE gipi_pack_polbasic
                    SET renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND pack_policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
              ELSE
                 UPDATE gipi_pack_polbasic
                    SET pol_flag = 'X',
                        renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND pack_policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
              END IF;
    ELSIF a.RENEW_FLAG = '3' THEN -- Auto-renewal
        copy_policy(v_proc_line_cd,p_menu_line_cd,v_is_package,v_new_policy_id,v_new_pack_policy_id,p_msg,
                p_message_box,v_old_pol_id,v_policy_id,v_proc_expiry_date,v_proc_incept_date,v_proc_assd_no,
                v_proc_same_polno_sw,v_new_par_id,v_new_pack_par_id,v_proc_renew_flag,v_user_id,v_pack_sw, v_long,
                v_proc_iss_cd,p_iss_ri,p_line_mn,v_open_flag,p_line_ac,p_line_su,p_line_ca,p_line_en,v_bpv,
                p_subline_bpv,v_proc_subline_cd,p_line_fi,p_line_mc,p_line_mh,p_line_av,p_subline_mop,p_subline_mrn,
                v_is_subpolicy,v_dist_no_old,v_dist_no_new,v_allow_ar_wdist); --joanne 06.25.14, add v_allow_ar_wdist
              IF a.expiry_date >= SYSDATE THEN
                 UPDATE gipi_pack_polbasic
                    SET renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND pack_policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
              ELSE
                 UPDATE gipi_pack_polbasic
                    SET pol_flag = 'X',
                        renew_flag = a.renew_flag
                  WHERE 1=1
                    --AND pack_policy_id = a.policy_id;
                    AND line_cd = a.line_cd
                    AND subline_cd = a.subline_cd
                    AND iss_cd = a.iss_cd
                    AND issue_yy = a.issue_yy
                    AND pol_seq_no = a.pol_seq_no
                    AND renew_no = a.renew_no;
              END IF;

           END IF;
          /* IF :system.last_record = 'TRUE' THEN
              X_VAR := 0;
           ELSE
              NEXT_RECORD;
           END IF;*/
       END IF; -- end IF of V_IS_PACKAGE

   END LOOP;
   p_msg := 'Your expiration process was successful.';
   --COMMIT;
   --CLEAR_MESSAGE;
   --GO_BLOCK('F000');
   --CLEAR_BLOCK(NO_VALIDATE);
   --*-- commented by iris bordey 08.12.2002
   --FIRST_RECORD;
   --set_block_property('F000',default_where,v_where); -- ROLLIE to bringing back original where condition
   --EXECUTE_QUERY;
   --DECREASE_ITEM_HEIGHT;
   --MESSAGE('Your expiration process was successful...',NO_ACKNOWLEDGE);
   --animate_processed_popup('RENEWED_WINDOW', 'Policy Renewed to (Policy/PAR) Number', 'RENEWED_CANVAS', 'BRENEWED','show');
--** End of procedure.  **--
END;
/



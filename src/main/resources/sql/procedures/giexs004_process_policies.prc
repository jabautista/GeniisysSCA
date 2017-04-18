CREATE OR REPLACE PROCEDURE CPI.giexs004_process_policies (
   p_all_user       IN       VARCHAR2,
   p_user           IN       giex_expiry.extract_user%TYPE,
   p_line_ac        IN       gipi_polbasic.line_cd%TYPE,
   p_menu_line_cd   IN OUT   giis_line.line_cd%TYPE,
   p_line_ca        IN       gipi_polbasic.line_cd%TYPE,
   p_line_av        IN       gipi_polbasic.line_cd%TYPE,
   p_line_fi        IN       gipi_polbasic.line_cd%TYPE,
   p_line_mc        IN       gipi_polbasic.line_cd%TYPE,
   p_line_mn        IN       gipi_polbasic.line_cd%TYPE,
   p_line_mh        IN       gipi_polbasic.line_cd%TYPE,
   p_line_en        IN       gipi_polbasic.line_cd%TYPE,
   p_vessel_cd      IN       giis_vessel.vessel_cd%TYPE,
   p_subline_bpv    IN OUT   gipi_wpolbas.subline_cd%TYPE,
   p_subline_mop    IN       gipi_wpolbas.subline_cd%TYPE,
   p_subline_mrn    IN       gipi_wpolbas.subline_cd%TYPE,
   p_line_su        IN       gipi_polbasic.line_cd%TYPE,
   p_subline_bbi    IN       gipi_wpolbas.subline_cd%TYPE,
   p_iss_ri         IN       gipi_polbasic.iss_cd%TYPE,
   p_msg            OUT      VARCHAR2,
   p_message_box    OUT      VARCHAR2,
   p_allow_ar_wdist in varchar2,
   p_line_cd        IN        giex_expiries_v.line_cd%TYPE, --marco - 08.08.2014 - added parameters below
   p_subline_cd     IN        giex_expiries_v.subline_cd%TYPE,
   p_iss_cd         IN        giex_expiries_v.iss_cd%TYPE,
   p_issue_yy       IN        giex_expiries_v.issue_yy%TYPE,
   p_pol_seq_no     IN        giex_expiries_v.pol_seq_no%TYPE,
   p_renew_no       IN        giex_expiries_v.renew_no%TYPE,
   p_claim_sw       IN        giex_expiries_v.claim_flag%TYPE,
   p_balance_sw     IN        giex_expiries_v.balance_flag%TYPE,
   p_intm_name      IN        giis_intermediary.intm_name%TYPE,
   p_intm_no        IN        giex_expiries_v.intm_no%TYPE,
   p_range_type     IN        VARCHAR2,
   p_range          IN        VARCHAR2,
   p_fm_date        IN        DATE,
   p_to_date        IN        DATE,
   p_fm_mon         IN        NUMBER,
   p_to_mon         IN        NUMBER,
   p_fm_year        IN        NUMBER,
   p_to_year        IN        NUMBER
)
IS
   x_policy               NUMBER (8);
   x_acct_ent_date        DATE;
   x_line_cd              gipi_parlist.line_cd%TYPE;
                             -- 14 September 1997 (MiB)
                             -- To be used as parameter to determine the line
                             -- code by using the giis_parameters.
   x_subline_cd           gipi_polbasic.subline_cd%TYPE;
   -- Would only be used for cases
   -- where the line code = 'MN'
   -- and subline used is an open policy.
   x_var                  NUMBER                                  := 1;
   v_where                VARCHAR2 (32767);
   v_new_pack_par_id      gipi_parlist.pack_par_id%TYPE           := NULL;
   v_new_pack_policy_id   gipi_polbasic.pack_policy_id%TYPE       := NULL;
   v_is_package           VARCHAR2 (1);
   v_new_par_id           gipi_wpolnrep.par_id%TYPE;
   v_new_policy_id        gipi_polbasic.policy_id%TYPE;
   v_old_pol_id           giex_expiry.policy_id%TYPE;
   v_user_id              giex_expiry.user_id%TYPE;
   v_last_update          DATE;
   v_proc_expiry_date     giex_expiry.expiry_date%TYPE;
   v_proc_subline_cd      giex_expiry.subline_cd%TYPE;
   v_proc_line_cd         giex_expiry.line_cd%TYPE;
   v_proc_iss_cd          giex_expiry.iss_cd%TYPE;
   v_proc_assd_no         giex_expiry.assd_no%TYPE;
   v_proc_incept_date     giex_expiry.incept_date%TYPE;
   v_proc_renew_flag      giex_expiry.renew_flag%TYPE;
   v_proc_same_polno_sw   giex_expiry.same_polno_sw%TYPE;
   v_proc_summary_sw      giex_expiry.summary_sw%TYPE;
   v_proc_intm_no         giex_expiry.intm_no%TYPE;
   v_old_pol_id_pack      giex_expiry.pack_policy_id%TYPE;
   v_open_flag            giis_subline.op_flag%TYPE;
   v_open_policy_sw       giis_subline.open_policy_sw%TYPE;
   v_policy_id            gipi_wpolnrep.old_policy_id%TYPE;
   v_pack_sw              gipi_pack_polbasic.pack_pol_flag%TYPE;
   v_long                 gipi_polgenin.gen_info%TYPE;
   v_bpv                  giis_parameters.param_name%TYPE
                                              := 'BOILER_AND_PRESSURE_VESSEL';
   v_dist_no_new          giuw_pol_dist.dist_no%TYPE;
   v_dist_no_old          giuw_pol_dist.dist_no%TYPE;
   v_is_subpolicy         VARCHAR2 (1);
   v_all_user             VARCHAR2(1)   := 'N'; --added by joanne 06.25.14, default all_user_sw is N
   v_package_renew_flag   VARCHAR2(1);  --added by robert SR 19682 07.14.15
BEGIN
  giis_users_pkg.app_user := p_user; -- andrew 11.16.2012 - added to set the application user before the execution of procedures

   BEGIN
     SELECT a.all_user_sw
       INTO v_all_user
       FROM giis_users a          
      WHERE a.user_id = p_user;
   END;

  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-24-2011
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
  **  Description  : PROCESS_POST program unit
  */--v_where := get_block_property('F000',default_where); -- to get the original where condition
    --INCREASE_ITEM_WIDTH(:cg$ctrl.message);
    --GO_BLOCK('F000');
--    FIRST_RECORD;

   --    WHILE (x_var = 1) LOOP
   FOR a IN (SELECT   policy_id, expiry_date, line_cd, subline_cd,
                      renew_flag, summary_sw, same_polno_sw, assd_no,
                      incept_date, iss_cd, intm_no, pack_policy_id, issue_yy,
                      pol_seq_no, renew_no, is_package, balance_flag
                 FROM (SELECT policy_id, expiry_date, renew_flag, line_cd,
                              subline_cd, same_polno_sw, cpi_rec_no,
                              cpi_branch_cd, iss_cd, post_flag, balance_flag,
                              claim_flag, extract_user, extract_date, user_id,
                              last_update, date_printed, no_of_copies,
                              auto_renew_flag, update_flag, tsi_amt, prem_amt,
                              summary_sw, incept_date, assd_no, auto_sw,
                              tax_amt, policy_tax_amt, issue_yy, pol_seq_no,
                              renew_no, color, motor_no, model_year, make,
                              serialno, plate_no, ren_notice_cnt,
                              ren_notice_date, item_title, loc_risk1,
                              loc_risk2, loc_risk3, car_company, intm_no,
                              remarks, orig_tsi_amt, sms_flag, renewal_id,
                              reg_policy_sw, assd_sms, intm_sms, email_doc,
                              email_sw, email_stat, assd_email, intm_email,
                              non_ren_reason, coc_serial_no,
                              non_ren_reason_cd,
                              NVL (pack_policy_id, 0) pack_policy_id,
                              'N' is_package, processor
                         FROM giex_expiry
                        WHERE pack_policy_id IS NULL --dren 09.09.2015 SR: 0020086 - To avoid generating duplicate PAR for renewal of PACK Policy
                       UNION ALL
                       SELECT pack_policy_id, expiry_date, renew_flag,
                              line_cd, subline_cd, same_polno_sw, -23, '-O',
                              iss_cd, post_flag, balance_flag, claim_flag,
                              extract_user, extract_date, user_id,
                              last_update, date_printed, no_of_copies,
                              auto_renew_flag, update_flag, tsi_amt, prem_amt,
                              summary_sw, incept_date, assd_no, auto_sw,
                              tax_amt, policy_tax_amt, issue_yy, pol_seq_no,
                              renew_no, color, motor_no, model_year, make,
                              serialno, plate_no, ren_notice_cnt,
                              ren_notice_date, item_title, loc_risk1,
                              loc_risk2, loc_risk3, car_company, intm_no,
                              remarks, orig_tsi_amt, sms_flag, renewal_id,
                              reg_policy_sw, assd_sms, intm_sms, email_doc,
                              email_sw, email_stat, assd_email, intm_email,
                              non_ren_reason, coc_serial_no,
                              non_ren_reason_cd, pack_policy_id,
                              'Y' is_package, processor
                         FROM giex_pack_expiry) a
                WHERE update_flag = 'Y'
                  AND NVL (post_flag, 'N') = 'N'
                  --AND NVL(balance_flag,'Y') = 'N' ----ANTHONY SANTOS 05/01/2008------
                  AND processor = p_user
                  --marco - 08.29.2014 - added lines below to process queried records only
                  AND line_cd = NVL (p_line_cd, line_cd)
                  AND subline_cd = NVL (p_subline_cd, subline_cd)
                  AND iss_cd = NVL (p_iss_cd, iss_cd)
                  AND issue_yy = NVL (p_issue_yy, issue_yy)
                  AND pol_seq_no = NVL (p_pol_seq_no, pol_seq_no)
                  AND renew_no = NVL (p_renew_no, renew_no)
                  AND NVL (claim_flag, 'N') = DECODE (NVL (p_claim_sw, 'N'), 'Y', 'Y', NVL (claim_flag, 'N'))
                  AND NVL (balance_flag, 'N') = DECODE (NVL (p_balance_sw, 'N'), 'Y', 'Y', NVL (balance_flag, 'N'))
                  AND ((p_intm_name IS NULL AND p_intm_no IS NULL)
                    OR (p_intm_no IS NOT NULL AND intm_no = p_intm_no)
                    OR (p_intm_name IS NOT NULL
                  AND intm_no IN (SELECT intm_no
                               FROM giis_intermediary
                              WHERE intm_name LIKE '%' || p_intm_name || '%')))
                  AND ((p_range_type = '2'
                     AND p_range = '2'
                     AND p_fm_date IS NOT NULL
                     AND p_to_date IS NOT NULL
                     AND TRUNC (expiry_date) >= TRUNC (p_fm_date)
                     AND TRUNC (expiry_date) <= TRUNC (p_to_date))
                  OR (p_range_type = '2'
                     AND p_range = '1'
                     AND p_fm_mon IS NOT NULL
                     AND p_to_mon IS NOT NULL
                     AND TO_DATE (TO_CHAR (expiry_date, 'MM-YYYY'), 'MM-YYYY') >=
                        TO_DATE (LTRIM (LPAD (p_fm_mon, 2, '0')) || '-' || LTRIM (TO_CHAR (p_fm_year, '0999')), 'MM-YYYY')
                     AND TO_DATE (TO_CHAR (expiry_date, 'MM-YYYY'), 'MM-YYYY') <=
                        TO_DATE (LTRIM (LPAD (p_to_mon, 2, '0')) || '-'|| LTRIM (TO_CHAR (p_to_year, '0999')), 'MM-YYYY'))
                  OR (p_range_type <> '2'
                     AND p_range = '2'
                     AND p_fm_date IS NOT NULL
                     AND TRUNC (expiry_date) <= TRUNC (p_fm_date))
                  OR (p_range_type <> '2'
                     AND p_range = '1'
                     AND p_fm_mon IS NOT NULL
                     AND p_fm_year IS NOT NULL
                     AND TO_CHAR (expiry_date, 'MM-YYYY') <= LTRIM (LPAD (p_fm_mon, 2, '0')) || '-' || LTRIM (TO_CHAR (p_fm_year, '0999')))
                  OR (p_fm_date IS NULL
                     AND p_to_date IS NULL
                     AND p_fm_mon IS NULL
                     AND p_to_mon IS NULL
                     AND p_fm_year IS NULL
                     AND p_to_year IS NULL)) --end - 08.28.2014
             ORDER BY pack_policy_id, is_package DESC)
   LOOP
      --SYNCHRONIZE;
      v_is_subpolicy := 'N';

      IF a.is_package = 'Y'
      THEN
         v_new_pack_par_id := NULL;
         v_new_pack_policy_id := NULL;
      ELSE
         IF a.pack_policy_id > 0
         THEN
            v_is_subpolicy := 'Y';
         ELSE
            v_new_pack_par_id := NULL;
            v_new_pack_policy_id := NULL;
         --NULL;
         END IF;
      END IF;

      v_is_package := a.is_package;
      /* Initialize the variables */
      --v_item_no            := NULL;
      --v_peril_cd           := NULL;
      v_new_par_id := NULL;
      v_new_policy_id := NULL;
      v_old_pol_id := a.policy_id;
      --v_new_pol_seq_no     := NULL;
      --v_def_where          := NULL;
      --v_remarks            := NULL;
      v_user_id := p_user;
      v_last_update := SYSDATE;
      --v_status_cd          := NULL;
      v_proc_expiry_date := a.expiry_date;
      x_subline_cd := a.subline_cd;
      x_line_cd := a.line_cd;
      v_proc_subline_cd := a.subline_cd;
      v_proc_line_cd := a.line_cd;
      v_proc_iss_cd := a.iss_cd;
      v_proc_assd_no := a.assd_no;
      v_proc_incept_date := a.incept_date;
      v_proc_renew_flag := a.renew_flag;
      v_proc_same_polno_sw := a.same_polno_sw;
      v_proc_summary_sw := a.summary_sw;
      v_proc_intm_no := a.intm_no;
      v_old_pol_id_pack := a.pack_policy_id;

      IF v_is_package = 'N'
      THEN
--start IF V_IS_PACKAGE ("1st IF" is for package detail records AND non-package records..)
         FOR b IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                          renew_no
                     FROM gipi_polbasic
                    WHERE policy_id = v_old_pol_id)
         LOOP
            IF v_is_subpolicy = 'N'
            THEN
               /*recgrp_row('DISPLAY_RENEWALS',variables.old_pol_id,
                          p_pol=>b.line_cd||'-'||b.subline_cd||'-'|| b.iss_cd||'-'||
                        to_char(b.issue_yy,'09')||'-'||to_char(b.pol_seq_no,'0999999')||'-'||to_char(b.renew_no,'09') -- pol_num
                        );*/
               p_message_box :=
                     'Processing Policy No.                          '
                  || b.line_cd
                  || '-'
                  || b.subline_cd
                  || '-'
                  || b.iss_cd
                  || '-'
                  || TO_CHAR (b.issue_yy, '09')
                  || '-'
                  || TO_CHAR (b.pol_seq_no, '0999999')
                  || '-'
                  || TO_CHAR (b.renew_no, '09');
            END IF;

            BEGIN
               SELECT op_flag, open_policy_sw
                 INTO v_open_flag, v_open_policy_sw
                 FROM giis_subline
                WHERE line_cd = v_proc_line_cd
                  AND subline_cd = v_proc_subline_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  p_msg :=
                        'No record found in giis subline for line and subline of policy '
                     || b.line_cd
                     || '-'
                     || b.subline_cd
                     || '-'
                     || b.iss_cd
                     || '-'
                     || TO_CHAR (b.issue_yy, '09')
                     || TO_CHAR (b.pol_seq_no, '0999999')
                     || '-'
                     || TO_CHAR (b.renew_no, '09');
            END;
         END LOOP;

         UPDATE giex_expiry
            SET post_flag = 'Y'
          WHERE policy_id = v_old_pol_id;

         IF a.renew_flag = '1'
         THEN                                                   -- Non renewed
            IF a.expiry_date >= SYSDATE
            THEN
               UPDATE gipi_polbasic
                  SET renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ( '1', '2', '3') ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            ELSE
               UPDATE gipi_polbasic
                  SET pol_flag = 'X',
                      renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ( '1', '2', '3') ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            END IF;

            IF v_is_subpolicy = 'N'
            THEN
               p_message_box := p_message_box || '   Policy not renewed.';
            END IF;
         ELSIF a.renew_flag = '2'
         THEN                                                       -- Renewed
            extract_summary (v_is_package,
                             v_proc_expiry_date,
                             v_proc_assd_no,
                             v_proc_same_polno_sw,
                             v_old_pol_id,
                             v_proc_summary_sw,
                             v_proc_renew_flag,
                             v_new_pack_par_id,
                             v_user_id,
                             v_new_par_id,
                             v_old_pol_id_pack,
                             p_line_ac,
                             p_menu_line_cd,
                             p_line_ca,
                             p_line_av,
                             p_line_fi,
                             p_line_mc,
                             p_line_mn,
                             p_line_mh,
                             p_line_en,
                             p_vessel_cd,
                             p_subline_bpv,
                             v_open_flag,
                             a.line_cd,
                             p_line_su,
                             v_proc_intm_no,
                             a.line_cd,
                             a.iss_cd,
                             v_proc_line_cd,
                             v_proc_subline_cd,
                             p_subline_bbi,
                             v_is_subpolicy,
                             p_message_box,
                             p_msg
                            );

            IF a.expiry_date >= SYSDATE
            THEN
               UPDATE gipi_polbasic
                  SET renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ( '1', '2', '3') ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            ELSE
               UPDATE gipi_polbasic
                  SET pol_flag = 'X',
                      renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ('1', '2', '3');  -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            END IF;
         ELSIF a.renew_flag = '3'
         THEN                                                  -- Auto-renewal
            copy_policy (v_proc_line_cd,
                         p_menu_line_cd,
                         v_is_package,
                         v_new_policy_id,
                         v_new_pack_policy_id,
                         p_msg,
                         p_message_box,
                         v_old_pol_id,
                         v_policy_id,
                         v_proc_expiry_date,
                         v_proc_incept_date,
                         v_proc_assd_no,
                         v_proc_same_polno_sw,
                         v_new_par_id,
                         v_new_pack_par_id,
                         v_proc_renew_flag,
                         v_user_id,
                         v_pack_sw,
                         v_long,
                         v_proc_iss_cd,
                         p_iss_ri,
                         p_line_mn,
                         v_open_flag,
                         p_line_ac,
                         p_line_su,
                         p_line_ca,
                         p_line_en,
                         v_bpv,
                         p_subline_bpv,
                         v_proc_subline_cd,
                         p_line_fi,
                         p_line_mc,
                         p_line_mh,
                         p_line_av,
                         p_subline_mop,
                         p_subline_mrn,
                         v_is_subpolicy,
                         v_dist_no_old,
                         v_dist_no_new,
                         p_allow_ar_wdist
                        );

            IF a.expiry_date >= SYSDATE
            THEN
               UPDATE gipi_polbasic
                  SET renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ( '1', '2', '3') ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            ELSE
               UPDATE gipi_polbasic
                  SET pol_flag = 'X',
                      renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ( '1', '2' , '3' ) ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            END IF;
         END IF;
      /*IF :system.last_record = 'TRUE' THEN
         X_VAR := 0;
      ELSE
         NEXT_RECORD;
      END IF;*/
      ELSE   -- else IF of V_IS_PACKAGE ("else" is for package main records..)
         FOR b IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                          renew_no
                     FROM gipi_pack_polbasic
                    WHERE pack_policy_id = v_old_pol_id)
         LOOP
            /*recgrp_row('DISPLAY_RENEWALS',variables.old_pol_id,
                                   p_pol=>b.line_cd||'-'||b.subline_cd||'-'|| b.iss_cd||'-'||
                                  to_char(b.issue_yy,'09')||'-'||to_char(b.pol_seq_no,'0999999')||'-'||to_char(b.renew_no,'09')-- pol_num
                                  );*/
            p_message_box :=
                  'Processing Package Policy No.                          '
               || b.line_cd
               || '-'
               || b.subline_cd
               || '-'
               || b.iss_cd
               || '-'
               || TO_CHAR (b.issue_yy, '09')
               || '-'
               || TO_CHAR (b.pol_seq_no, '0999999')
               || '-'
               || TO_CHAR (b.renew_no, '09');

            BEGIN
               SELECT op_flag, open_policy_sw
                 INTO v_open_flag, v_open_policy_sw
                 FROM giis_subline
                WHERE line_cd = v_proc_line_cd
                  AND subline_cd = v_proc_subline_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  p_msg :=
                        'No record found in giis subline for line and subline of package '
                     || b.line_cd
                     || '-'
                     || b.subline_cd
                     || '-'
                     || b.iss_cd
                     || '-'
                     || TO_CHAR (b.issue_yy, '09')
                     || TO_CHAR (b.pol_seq_no, '0999999')
                     || '-'
                     || TO_CHAR (b.renew_no, '09');
            END;
         END LOOP;

         UPDATE giex_pack_expiry
            SET post_flag = 'Y'
          WHERE pack_policy_id = v_old_pol_id;

         IF a.renew_flag = '1'
         THEN                                                   -- Non renewed
            IF a.expiry_date >= SYSDATE
            THEN
               UPDATE gipi_pack_polbasic
                  SET renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND pack_policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ( '1', '2', '3') ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            ELSE
               UPDATE gipi_pack_polbasic
                  SET pol_flag = 'X',
                      renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND pack_policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ( '1', '2' , '3' ) ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            END IF;

            p_message_box := p_message_box || '   Package policy not renewed.';
         ELSIF a.renew_flag = '2'
         THEN                                                       -- Renewed
            extract_summary (v_is_package,
                             v_proc_expiry_date,
                             v_proc_assd_no,
                             v_proc_same_polno_sw,
                             v_old_pol_id,
                             v_proc_summary_sw,
                             v_proc_renew_flag,
                             v_new_pack_par_id,
                             v_user_id,
                             v_new_par_id,
                             v_old_pol_id_pack,
                             p_line_ac,
                             p_menu_line_cd,
                             p_line_ca,
                             p_line_av,
                             p_line_fi,
                             p_line_mc,
                             p_line_mn,
                             p_line_mh,
                             p_line_en,
                             p_vessel_cd,
                             p_subline_bpv,
                             v_open_flag,
                             a.line_cd,
                             p_line_su,
                             v_proc_intm_no,
                             a.line_cd,
                             a.iss_cd,
                             v_proc_line_cd,
                             v_proc_subline_cd,
                             p_subline_bbi,
                             v_is_subpolicy,
                             p_message_box,
                             p_msg
                            );

            IF a.expiry_date >= SYSDATE
            THEN
               UPDATE gipi_pack_polbasic
                  SET renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND pack_policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ( '1', '2', '3') ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            ELSE
               UPDATE gipi_pack_polbasic
                  SET pol_flag = 'X',
                      renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND pack_policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ( '1' ,'2' , '3' ) ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            END IF;
         ELSIF a.renew_flag = '3'
         THEN                                                  -- Auto-renewal
            copy_policy (v_proc_line_cd,
                         p_menu_line_cd,
                         v_is_package,
                         v_new_policy_id,
                         v_new_pack_policy_id,
                         p_msg,
                         p_message_box,
                         v_old_pol_id,
                         v_policy_id,
                         v_proc_expiry_date,
                         v_proc_incept_date,
                         v_proc_assd_no,
                         v_proc_same_polno_sw,
                         v_new_par_id,
                         v_new_pack_par_id,
                         v_proc_renew_flag,
                         v_user_id,
                         v_pack_sw,
                         v_long,
                         v_proc_iss_cd,
                         p_iss_ri,
                         p_line_mn,
                         v_open_flag,
                         p_line_ac,
                         p_line_su,
                         p_line_ca,
                         p_line_en,
                         v_bpv,
                         p_subline_bpv,
                         v_proc_subline_cd,
                         p_line_fi,
                         p_line_mc,
                         p_line_mh,
                         p_line_av,
                         p_subline_mop,
                         p_subline_mrn,
                         v_is_subpolicy,
                         v_dist_no_old,
                         v_dist_no_new,
                         p_allow_ar_wdist
                        );

            IF a.expiry_date >= SYSDATE
            THEN
               UPDATE gipi_pack_polbasic
                  SET renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND pack_policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ( '1', '2', '3') ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            ELSE
               UPDATE gipi_pack_polbasic
                  SET pol_flag = 'X',
                      renew_flag = a.renew_flag
                WHERE 1 = 1
                  --AND pack_policy_id = a.policy_id;
                  AND line_cd = a.line_cd
                  AND subline_cd = a.subline_cd
                  AND iss_cd = a.iss_cd
                  AND issue_yy = a.issue_yy
                  AND pol_seq_no = a.pol_seq_no
                  AND renew_no = a.renew_no
                  AND pol_flag IN ( '1' , '2' , '3') ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
            END IF;
         END IF;
         
           --added by robert SR 19682 07.14.15
           --query for package sub-policies
           v_package_renew_flag := a.renew_flag;
           FOR cur_subpolicies IN (SELECT policy_id, expiry_date, renew_flag,
                                          line_cd, subline_cd, same_polno_sw,
                                          cpi_rec_no, cpi_branch_cd, iss_cd,
                                          post_flag, balance_flag, claim_flag,
                                          extract_user, extract_date, user_id,
                                          last_update, date_printed, no_of_copies,
                                          auto_renew_flag, update_flag, tsi_amt,
                                          prem_amt, summary_sw, incept_date, assd_no,
                                          auto_sw, tax_amt, policy_tax_amt, issue_yy,
                                          pol_seq_no, renew_no, color, motor_no,
                                          model_year, make, serialno, plate_no,
                                          ren_notice_cnt, ren_notice_date,
                                          item_title, loc_risk1, loc_risk2,
                                          loc_risk3, car_company, intm_no, remarks,
                                          orig_tsi_amt, sms_flag, renewal_id,
                                          reg_policy_sw, assd_sms, intm_sms,
                                          email_doc, email_sw, email_stat,
                                          assd_email, intm_email, non_ren_reason,
                                          coc_serial_no, non_ren_reason_cd,
                                          NVL (pack_policy_id, 0) pack_policy_id,
                                          'N' is_package, bank_ref_no
                                     FROM giex_expiry
                                    WHERE pack_policy_id = v_old_pol_id)
           LOOP
              v_is_subpolicy := 'Y';
              v_is_package := 'N';
              v_new_par_id := NULL;
              v_new_policy_id := NULL;
              v_old_pol_id := cur_subpolicies.policy_id;
              v_proc_expiry_date := cur_subpolicies.expiry_date;
              x_subline_cd := cur_subpolicies.subline_cd;
              x_line_cd := cur_subpolicies.line_cd;
              v_proc_subline_cd := cur_subpolicies.subline_cd;
              v_proc_line_cd := cur_subpolicies.line_cd;
              v_proc_iss_cd := cur_subpolicies.iss_cd;
              v_proc_assd_no := cur_subpolicies.assd_no;
              v_proc_incept_date := cur_subpolicies.incept_date;
              v_proc_renew_flag := cur_subpolicies.renew_flag;
              v_proc_intm_no := cur_subpolicies.intm_no;
              v_old_pol_id_pack := cur_subpolicies.pack_policy_id;
              
              UPDATE giex_expiry
                 SET post_flag = 'Y'
               WHERE policy_id = v_old_pol_id;

              IF v_package_renew_flag = '1'
              THEN   -- Non renewed
                 IF a.expiry_date >= SYSDATE
                 THEN
                    UPDATE gipi_polbasic
                       SET renew_flag = v_package_renew_flag
                     WHERE 1 = 1
                       AND line_cd = cur_subpolicies.line_cd
                       AND subline_cd = cur_subpolicies.subline_cd
                       AND iss_cd = cur_subpolicies.iss_cd
                       AND issue_yy = cur_subpolicies.issue_yy
                       AND pol_seq_no = cur_subpolicies.pol_seq_no
                       AND renew_no = cur_subpolicies.renew_no
                       AND pol_flag IN ( '1', '2', '3') ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
                 ELSE
                    UPDATE gipi_polbasic
                       SET pol_flag = 'X',
                           renew_flag = v_package_renew_flag
                     WHERE 1 = 1
                       AND line_cd = cur_subpolicies.line_cd
                       AND subline_cd = cur_subpolicies.subline_cd
                       AND iss_cd = cur_subpolicies.iss_cd
                       AND issue_yy = cur_subpolicies.issue_yy
                       AND pol_seq_no = cur_subpolicies.pol_seq_no
                       AND renew_no = cur_subpolicies.renew_no
                       --AND pol_flag != '5';
                       AND pol_flag NOT IN ( '4', '5') ; -- jhing 08.04.2015 included cancelled in the excluded pol_flag GENQA SR# 0004850
                 END IF;
              ELSIF v_package_renew_flag = '2'
              THEN  -- Renewed
                 extract_summary (v_is_package,
                                  v_proc_expiry_date,
                                  v_proc_assd_no,
                                  v_proc_same_polno_sw,
                                  v_old_pol_id,
                                  v_proc_summary_sw,
                                  v_proc_renew_flag,
                                  v_new_pack_par_id,
                                  v_user_id,
                                  v_new_par_id,
                                  v_old_pol_id_pack,
                                  p_line_ac,
                                  p_menu_line_cd,
                                  p_line_ca,
                                  p_line_av,
                                  p_line_fi,
                                  p_line_mc,
                                  p_line_mn,
                                  p_line_mh,
                                  p_line_en,
                                  p_vessel_cd,
                                  p_subline_bpv,
                                  v_open_flag,
                                  a.line_cd,
                                  p_line_su,
                                  v_proc_intm_no,
                                  a.line_cd,
                                  a.iss_cd,
                                  v_proc_line_cd,
                                  v_proc_subline_cd,
                                  p_subline_bbi,
                                  v_is_subpolicy,
                                  p_message_box,
                                  p_msg
                                 );

                 IF a.expiry_date >= SYSDATE
                 THEN
                    UPDATE gipi_polbasic
                       SET renew_flag = v_package_renew_flag
                     WHERE 1 = 1
                       AND line_cd = cur_subpolicies.line_cd
                       AND subline_cd = cur_subpolicies.subline_cd
                       AND iss_cd = cur_subpolicies.iss_cd
                       AND issue_yy = cur_subpolicies.issue_yy
                       AND pol_seq_no = cur_subpolicies.pol_seq_no
                       AND renew_no = cur_subpolicies.renew_no
                       AND pol_flag IN ( '1', '2', '3') ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
                 ELSE
                    UPDATE gipi_polbasic
                       SET pol_flag = 'X',
                           renew_flag = v_package_renew_flag
                     WHERE 1 = 1
                       AND line_cd = cur_subpolicies.line_cd
                       AND subline_cd = cur_subpolicies.subline_cd
                       AND iss_cd = cur_subpolicies.iss_cd
                       AND issue_yy = cur_subpolicies.issue_yy
                       AND pol_seq_no = cur_subpolicies.pol_seq_no
                       AND renew_no = cur_subpolicies.renew_no
                       --AND pol_flag != '5'
                       AND pol_flag NOT IN ( '4', '5') ; -- jhing 08.04.2015 included cancelled in the excluded pol_flag GENQA SR# 0004850
                 END IF;
              ELSIF v_package_renew_flag = '3'
              THEN  -- Auto-renewal
                 copy_policy (v_proc_line_cd,
                              p_menu_line_cd,
                              v_is_package,
                              v_new_policy_id,
                              v_new_pack_policy_id,
                              p_msg,
                              p_message_box,
                              v_old_pol_id,
                              v_policy_id,
                              v_proc_expiry_date,
                              v_proc_incept_date,
                              v_proc_assd_no,
                              v_proc_same_polno_sw,
                              v_new_par_id,
                              v_new_pack_par_id,
                              v_proc_renew_flag,
                              v_user_id,
                              v_pack_sw,
                              v_long,
                              v_proc_iss_cd,
                              p_iss_ri,
                              p_line_mn,
                              v_open_flag,
                              p_line_ac,
                              p_line_su,
                              p_line_ca,
                              p_line_en,
                              v_bpv,
                              p_subline_bpv,
                              v_proc_subline_cd,
                              p_line_fi,
                              p_line_mc,
                              p_line_mh,
                              p_line_av,
                              p_subline_mop,
                              p_subline_mrn,
                              v_is_subpolicy,
                              v_dist_no_old,
                              v_dist_no_new,
                              p_allow_ar_wdist
                             );

                 IF a.expiry_date >= SYSDATE
                 THEN
                    UPDATE gipi_polbasic
                       SET renew_flag = v_package_renew_flag
                     WHERE 1 = 1
                       AND line_cd = cur_subpolicies.line_cd
                       AND subline_cd = cur_subpolicies.subline_cd
                       AND iss_cd = cur_subpolicies.iss_cd
                       AND issue_yy = cur_subpolicies.issue_yy
                       AND pol_seq_no = cur_subpolicies.pol_seq_no
                       AND renew_no = cur_subpolicies.renew_no
                       AND pol_flag IN ( '1', '2', '3') ; -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
                 ELSE
                    UPDATE gipi_polbasic
                       SET pol_flag = 'X',
                           renew_flag = v_package_renew_flag
                     WHERE 1 = 1
                       AND line_cd = cur_subpolicies.line_cd
                       AND subline_cd = cur_subpolicies.subline_cd
                       AND iss_cd = cur_subpolicies.iss_cd
                       AND issue_yy = cur_subpolicies.issue_yy
                       AND pol_seq_no = cur_subpolicies.pol_seq_no
                       AND renew_no = cur_subpolicies.renew_no
                       AND pol_flag IN ( '1', '2', '3') ;  -- jhing 08.04.2015 added pol_flag GENQA SR# 0004850
                 END IF;
              END IF;
           END LOOP;
           --end robert SR 19682 07.14.15
         
      /* IF :system.last_record = 'TRUE' THEN
          X_VAR := 0;
       ELSE
          NEXT_RECORD;
       END IF;*/
      END IF;                                        -- end IF of V_IS_PACKAGE
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

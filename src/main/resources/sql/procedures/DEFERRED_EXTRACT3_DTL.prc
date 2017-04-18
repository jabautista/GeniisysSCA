/* Formatted on 3/1/2016 2:45:38 PM (QP5 v5.227.12220.39754) */
CREATE OR REPLACE PROCEDURE CPI.deferred_extract3_dtl (p_ext_year    NUMBER,
                                                       p_ext_mm      NUMBER,
                                                       p_year        NUMBER,
                                                       p_mm          NUMBER,
                                                       p_method      NUMBER)
IS
   v_mm_year         VARCHAR2 (7);
   v_mm_year_mn1     VARCHAR2 (7);
   v_mm_year_mn2     VARCHAR2 (7);
   v_num_factor      NUMBER (20);
   v_num_factor2     NUMBER (4);
   v_den_factor      NUMBER (20);
   v_pol_term        NUMBER (10);
   v_earned_days     NUMBER (10);
   v_unearned_days   NUMBER (10);
   v_def_prem        NUMBER (16, 2);
   v_iss_cd_ri       VARCHAR2 (2) := giisp.v ('ISS_CD_RI');
   v_iss_cd_rv       VARCHAR2 (2) := giisp.v ('ISS_CD_RV');
   v_start_date      DATE
      := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   v_user_id         VARCHAR2 (8) := NVL (giis_users_pkg.app_user, USER);
   --added by Gzelle 05.31.2013, replaced all USER with v_user_id
   v_24th_comp       VARCHAR2 (1)
                        := NVL (giacp.v ('24TH_METHOD_DEF_COMP'), 'Y'); --test mikel 02.04.2016
   --fj
   v_paramdate       VARCHAR2 (1) := giacp.v ('24TH_METHOD_PARAMDATE');
   --fj
   v_exclude_mn      VARCHAR2 (1)
                        := NVL (giacp.v ('EXCLUDE_MARINE_24TH'), 'N');
   --fj
   v_mn              giis_parameters.param_value_v%TYPE
                        := NVL (giisp.v ('LINE_CODE_MN'), 'MN');
   v_next_round      NUMBER := 1;
   --fj
   v_mn_24th_comp    VARCHAR2 (1) := giacp.v ('MARINE_COMPUTATION_24TH');
--fj
--v_def_comm_prod   VARCHAR2(1) := NVL(Giacp.v('DEF_COMM_PROD_ENTRY'),'N');
/*
** Created by:   Mikel
** Date Created: 08.28.2012
** Description:  Extracts detailed data required for the daily computation of 1/365 Method
*/

/*
** Modified by: Mikel
** Description: Changed the computation of numerator and denominator factor.
**                   Denominator factor is based on the no. of months of the policy term.
**                  Numerator factor is based on the period that has yet to be utilized.
**              Handles endorsement with change of policy term. Numerator and denominator factors are based on the new policy term.
*/

BEGIN
   IF v_24th_comp = 'Y'
   THEN
      --v_paramdate     := Giacp.v('24TH_METHOD_PARAMDATE');
      v_mm_year := LPAD (TO_CHAR (p_mm), 2, '0') || '-' || TO_CHAR (p_year);
      v_mm_year_mn1 :=
            TO_CHAR (
                 TO_DATE (
                       LPAD (TO_CHAR (p_ext_mm), 2, '0')
                    || '-'
                    || TO_CHAR (p_ext_year),
                    'MM-YYYY')
               - 1,
               'MM')
         || '-'
         || TO_CHAR (
                 TO_DATE (
                       LPAD (TO_CHAR (p_ext_mm), 2, '0')
                    || '-'
                    || TO_CHAR (p_ext_year),
                    'MM-YYYY')
               - 1,
               'YYYY');
      v_mm_year_mn2 :=
         LPAD (TO_CHAR (p_ext_mm), 2, '0') || '-' || TO_CHAR (p_ext_year);

      -----------------------------------------------------------------------OK
      --GROSS PREMIUMS
      FOR loop_twice IN 1 .. 2                              --mikel 12.11.2012
      LOOP
         FOR gross
            IN (                                      /* Checked 11/13/2014 */
                SELECT   NVL (b.cred_branch, a.iss_cd) iss_cd,
                         b.line_cd,
                         get_policy_no (b.policy_id) policy_no,
                         /*TRUNC (b.eff_date) eff_date,
                         TRUNC (NVL (b.endt_expiry_date, b.expiry_date)
                               ) expiry_date,*/
                         --mikel 02.19.2016; comment out and replaced by codes below
                         invoice_takeupterm.get_eff_date (a.policy_id,
                                                          a.takeup_seq_no,
                                                          v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                            eff_date,
                         invoice_takeupterm.get_exp_date (a.policy_id,
                                                          a.takeup_seq_no,
                                                          v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                            expiry_date,
                         SUM (
                            ROUND (
                                 DECODE (
                                    TO_CHAR (b.spld_acct_ent_date, 'MM-YYYY'),
                                    v_mm_year, -1,
                                    1)
                               * a.prem_amt
                               * a.currency_rt,
                               2))
                            premium,
                         /*DECODE
                            (MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', b.acct_ent_date,
                                                              'E', b.eff_date
                                                             )
                                                     )
                                           ),
                             0, 1,
                             MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', b.acct_ent_date,
                                                              'E', b.eff_date
                                                             )
                                                     )
                                           )
                            )
                       * 2 denominator,
                       DECODE
                          (SIGN
                              (MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (TO_DATE (   p_ext_mm
                                                               || '-'
                                                               || p_ext_year,
                                                               'MM-YYYY'
                                                              )
                                                     )
                                           )
                              ),
                           -1, 0,
                           DECODE
                              (SIGN
                                  (MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                            )
                                  ),
                               -1, DECODE
                                     (MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', b.acct_ent_date,
                                                              'E', b.eff_date
                                                             )
                                                     )
                                           ),
                                      0, 1,
                                      MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', b.acct_ent_date,
                                                              'E', b.eff_date
                                                             )
                                                     )
                                           )
                                     )
                                * 2,
                               DECODE
                                  (SIGN
                                      (  (  MONTHS_BETWEEN
                                               (LAST_DAY
                                                      (NVL (b.endt_expiry_date,
                                                            b.expiry_date
                                                           )
                                                      ),
                                                LAST_DAY
                                                      (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                               )
                                          * 2
                                         )
                                       - (  (  MONTHS_BETWEEN
                                                  (LAST_DAY
                                                         (TO_DATE (   p_ext_mm
                                                                   || '-'
                                                                   || p_ext_year,
                                                                   'MM-YYYY'
                                                                  )
                                                         ),
                                                   LAST_DAY
                                                      (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                                  )
                                             * 2
                                            )
                                          + 1
                                         )
                                      ),
                                   -1, 0,
                                     (  MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', b.acct_ent_date,
                                                              'E', b.eff_date
                                                             )
                                                     )
                                           )
                                      * 2
                                     )
                                   - (  (  MONTHS_BETWEEN
                                              (LAST_DAY (TO_DATE (   p_ext_mm
                                                                  || '-'
                                                                  || p_ext_year,
                                                                  'MM-YYYY'
                                                                 )
                                                        ),
                                               LAST_DAY
                                                      (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                              )
                                         * 2
                                        )
                                      + 1
                                     )
                                  )
                              )
                          ) numerator,*/
                         --mikel 02.19.2016; comment out and replaced by codes below
                         get_numerator_factor_24th (
                            TO_DATE (
                                  LPAD (TO_CHAR (p_ext_mm), 2, '0')
                               || '-'
                               || TO_CHAR (p_ext_year),
                               'MM-YYYY'),
                            invoice_takeupterm.get_eff_date (a.policy_id,
                                                             a.takeup_seq_no,
                                                             v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                            invoice_takeupterm.get_exp_date (a.policy_id,
                                                             a.takeup_seq_no,
                                                             v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                            NVL (c.menu_line_cd, c.line_cd))
                            numerator,
                         get_denominator_factor_24th (
                            TO_DATE (
                                  LPAD (TO_CHAR (p_ext_mm), 2, '0')
                               || '-'
                               || TO_CHAR (p_ext_year),
                               'MM-YYYY'),
                            invoice_takeupterm.get_eff_date (a.policy_id,
                                                             a.takeup_seq_no,
                                                             v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                            invoice_takeupterm.get_exp_date (a.policy_id,
                                                             a.takeup_seq_no,
                                                             v_mm_year_mn2)) --Deo [08.22.2016]: SR-22527
                            denominator,                --end mikel 02.19.2016
                         a.acct_ent_date,
                         a.spoiled_acct_ent_date
                    FROM gipi_invoice a, gipi_polbasic b, giis_line c --mikel 02.29.2016
                   WHERE     a.policy_id = b.policy_id
                         AND b.line_cd = c.line_cd          --mikel 02.29.2016
                         AND (   (    v_exclude_mn = 'Y'
                                  AND NVL (c.menu_line_cd, c.line_cd) <> 'MN')
                              OR (v_exclude_mn = 'N'))      --mikel 02.29.2016
                         AND DECODE (
                                v_start_date,
                                NULL, SYSDATE,
                                DECODE (v_next_round,
                                        1, b.acct_ent_date,
                                        b.spld_acct_ent_date)) >=
                                DECODE (v_start_date,
                                        NULL, SYSDATE,
                                        v_start_date)
                         AND ( (v_paramdate = 'E') OR v_paramdate = 'A')
                         AND (   (    TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                                         v_mm_year
                                  AND v_next_round = 1) --mikel 07.09.2013; added v_next_round
                              OR (    TO_CHAR (a.spoiled_acct_ent_date,
                                               'MM-YYYY') = v_mm_year
                                  AND v_next_round = 2))
                         AND b.reg_policy_sw = 'Y'
                         --  and (acct_ent_date between 1 year
                         --   or acct_ent_date not between 1 year pero hindi expired as of extract date (mm-yyyy nov 30, 2014))
                         /*AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                              OR (       v_exclude_mn = 'N'
                                     AND v_mn_24th_comp = '1'
                                     AND (       b.line_cd = v_mn
                                             AND (   (    v_paramdate = 'A'
                                                      AND v_mm_year IN
                                                                   (v_mm_year_mn1, v_mm_year_mn2)
                                                     )
                                                  OR (    v_paramdate = 'E'
                                                      AND v_mm_year IN
                                                                   (v_mm_year_mn1, v_mm_year_mn2)
                                                     )
                                                 )
                                          OR b.line_cd <> v_mn
                                         )
                                  OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                                 )
                             ) */
                         ----Added by FJ 11/12/2014 TO INCLUDE RECORDS ONLY FROM V_START_DATE
                         --THAT ARE NOT YET EXPIRED AS OF EXTRACTION DATE
                         AND (   (    /*TRUNC (
                                         NVL (b.endt_expiry_date,
                                              b.expiry_date)) >*/ --mikel 06.09.2016;UCPBGEN SR 22527
                                       invoice_takeupterm.get_exp_date (a.policy_id,
                                                          a.takeup_seq_no,
                                                          v_mm_year_mn2) > --Deo [08.22.2016]: SR-22527
                                         LAST_DAY (
                                            TO_DATE (
                                                  LPAD (TO_CHAR (p_ext_mm),
                                                        2,
                                                        '0')
                                               || '-'
                                               || TO_CHAR (p_ext_year),
                                               'MM-YYYY'))
                                  AND (   (    b.acct_ent_date <
                                                  LAST_DAY (
                                                     TO_DATE (
                                                           LPAD (
                                                              TO_CHAR (
                                                                 p_ext_mm),
                                                              2,
                                                              '0')
                                                        || '-'
                                                        || TO_CHAR (p_ext_year),
                                                        'MM-YYYY'))
                                           AND v_next_round = 1)
                                       OR (    b.spld_acct_ent_date <
                                                  LAST_DAY (
                                                     TO_DATE (
                                                           LPAD (
                                                              TO_CHAR (
                                                                 p_ext_mm),
                                                              2,
                                                              '0')
                                                        || '-'
                                                        || TO_CHAR (p_ext_year),
                                                        'MM-YYYY'))
                                           AND v_next_round = 2)))
                              OR (   (    b.acct_ent_date BETWEEN ADD_MONTHS (
                                                                     TO_DATE (
                                                                           LPAD (
                                                                              TO_CHAR (
                                                                                 p_ext_mm),
                                                                              2,
                                                                              '0')
                                                                        || '-'
                                                                        || TO_CHAR (
                                                                              p_ext_year),
                                                                        'MM-YYYY'),
                                                                     -11)
                                                              AND LAST_DAY (
                                                                     TO_DATE (
                                                                           LPAD (
                                                                              TO_CHAR (
                                                                                 p_ext_mm),
                                                                              2,
                                                                              '0')
                                                                        || '-'
                                                                        || TO_CHAR (
                                                                              p_ext_year),
                                                                        'MM-YYYY'))
                                      AND v_next_round = 1)
                                  OR (    b.spld_acct_ent_date BETWEEN ADD_MONTHS (
                                                                          TO_DATE (
                                                                                LPAD (
                                                                                   TO_CHAR (
                                                                                      p_ext_mm),
                                                                                   2,
                                                                                   '0')
                                                                             || '-'
                                                                             || TO_CHAR (
                                                                                   p_ext_year),
                                                                             'MM-YYYY'),
                                                                          -11)
                                                                   AND LAST_DAY (
                                                                          TO_DATE (
                                                                                LPAD (
                                                                                   TO_CHAR (
                                                                                      p_ext_mm),
                                                                                   2,
                                                                                   '0')
                                                                             || '-'
                                                                             || TO_CHAR (
                                                                                   p_ext_year),
                                                                             'MM-YYYY'))
                                      AND v_next_round = 2)))
                GROUP BY NVL (b.cred_branch, a.iss_cd),
                         b.line_cd,
                         b.policy_id,
                         b.eff_date,
                         b.endt_expiry_date,
                         b.expiry_date,
                         b.acct_ent_date,
                         a.acct_ent_date,
                         a.spoiled_acct_ent_date,
                         a.policy_id,
                         a.takeup_seq_no,
                         NVL (c.menu_line_cd, c.line_cd))   --mikel 02.09.2016
         LOOP
            --      IF gross.eff_date > gross.expiry_date THEN
            --        RAISE_APPLICATION_ERROR (-20001, 'Effectivity date is greater than the expiry date.');
            --      END IF;
            v_pol_term := (gross.expiry_date + 1) - gross.eff_date;
            v_earned_days :=
                 (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1)
               - gross.eff_date;

            IF gross.eff_date > LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY'))
            THEN
               v_earned_days := 0;
            END IF;

            IF v_earned_days > v_pol_term
            THEN
               v_earned_days := v_pol_term;
            END IF;

            --v_unearned_days := v_pol_term - (v_earned_days);
            v_num_factor := gross.numerator;
            -- v_num_factor2   := v_earned_days;
            v_den_factor := gross.denominator;

            UPDATE giac_deferred_gross_prem_pol gprem_pol
               SET gprem_pol.prem_amt = gprem_pol.prem_amt + gross.premium,
                   gprem_pol.numerator_factor = v_num_factor,
                   gprem_pol.denominator_factor = v_den_factor
             WHERE     gprem_pol.extract_year = p_ext_year
                   AND gprem_pol.extract_mm = p_ext_mm
                   AND gprem_pol.procedure_id = p_method
                   AND gprem_pol.iss_cd = gross.iss_cd
                   AND gprem_pol.line_cd = gross.line_cd
                   AND gprem_pol.policy_no = gross.policy_no
                   AND gprem_pol.comp_sw = 'Y';

            IF SQL%NOTFOUND
            THEN
               INSERT
                 INTO giac_deferred_gross_prem_pol (extract_year,
                                                    extract_mm,
                                                    procedure_id,
                                                    iss_cd,
                                                    line_cd,
                                                    policy_no,
                                                    prem_amt,
                                                    eff_date,
                                                    expiry_date,
                                                    numerator_factor,
                                                    denominator_factor,
                                                    def_prem_amt,
                                                    user_id,
                                                    last_update,
                                                    comp_sw,
                                                    acct_ent_date,
                                                    spoiled_acct_ent_date)
               VALUES (p_ext_year,
                       p_ext_mm,
                       p_method,
                       gross.iss_cd,
                       gross.line_cd,
                       gross.policy_no,
                       gross.premium,
                       gross.eff_date,
                       gross.expiry_date,
                       v_num_factor,
                       v_den_factor,
                       v_def_prem,
                       v_user_id,
                       SYSDATE,
                       'Y',
                       gross.acct_ent_date,
                       gross.spoiled_acct_ent_date);
            END IF;
         END LOOP;

         v_next_round := v_next_round + 1;                  --mikel 12.11.2012
      END LOOP;

      --------------------------------------------------------------------------------------------------------------------------------OK
      --RI PREMIUMS CEDED
      --Treaty
      --Premiuims
      FOR trty_prem
         IN (  SELECT NVL (b.cred_branch, b.iss_cd) iss_cd,
                      a.line_cd,
                      get_policy_no (b.policy_id) policy_no,
                      /*TRUNC (b.eff_date) eff_date,
                      TRUNC (NVL (b.endt_expiry_date, b.expiry_date))
                                                                     expiry_date,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      invoice_takeupterm.get_eff_date (a.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         eff_date,
                      invoice_takeupterm.get_exp_date (a.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         expiry_date,
                      SUM (NVL (a.premium_amt, 0)) dist_prem,
                      NVL (c.acct_trty_type, 0) acct_trty_type,
                      /*DECODE
                         (MONTHS_BETWEEN (LAST_DAY (NVL (b.endt_expiry_date,
                                                         b.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', b.acct_ent_date,
                                                            'E', b.eff_date
                                                           )
                                                   )
                                         ),
                          0, 1,
                          MONTHS_BETWEEN (LAST_DAY (NVL (b.endt_expiry_date,
                                                         b.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', b.acct_ent_date,
                                                            'E', b.eff_date
                                                           )
                                                   )
                                         )
                         )
                    * 2 denominator,
                    DECODE
                       (SIGN
                           (MONTHS_BETWEEN (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (TO_DATE (   p_ext_mm
                                                               || '-'
                                                               || p_ext_year,
                                                               'MM-YYYY'
                                                              )
                                                     )
                                           )
                           ),
                        -1, 0,
                        DECODE
                           (SIGN
                               (MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                            )
                               ),
                            -1, DECODE
                                  (MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', b.acct_ent_date,
                                                              'E', b.eff_date
                                                             )
                                                     )
                                           ),
                                   0, 1,
                                   MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', b.acct_ent_date,
                                                              'E', b.eff_date
                                                             )
                                                     )
                                           )
                                  )
                             * 2,
                            DECODE
                               (SIGN
                                   (  (  MONTHS_BETWEEN
                                            (LAST_DAY (NVL (b.endt_expiry_date,
                                                            b.expiry_date
                                                           )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                            )
                                       * 2
                                      )
                                    - (  (  MONTHS_BETWEEN
                                               (LAST_DAY (TO_DATE (   p_ext_mm
                                                                   || '-'
                                                                   || p_ext_year,
                                                                   'MM-YYYY'
                                                                  )
                                                         ),
                                                LAST_DAY
                                                      (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                               )
                                          * 2
                                         )
                                       + 1
                                      )
                                   ),
                                -1, 0,
                                  (  MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', b.acct_ent_date,
                                                              'E', b.eff_date
                                                             )
                                                     )
                                           )
                                   * 2
                                  )
                                - (  (  MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                            )
                                      * 2
                                     )
                                   + 1
                                  )
                               )
                           )
                       ) numerator,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      get_numerator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (a.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (a.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         NVL (e.menu_line_cd, e.line_cd))
                         numerator,
                      get_denominator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (a.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (a.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2)) --Deo [08.22.2016]: SR-22527
                         denominator,                   --end mikel 02.19.2016
                      d.acct_ent_date,
                      d.acct_neg_date
                 FROM giac_treaty_cessions a,
                      gipi_polbasic b,
                      giis_dist_share c,
                      giuw_pol_dist d,
                      giis_line e                           --mikel 02.29.2016
                WHERE     a.policy_id = b.policy_id
                      --Added by FJ to connect giuw_pol_dist
                      AND d.policy_id = b.policy_id
                      AND a.dist_no = d.dist_no
                      -------
                      AND b.line_cd = e.line_cd             --mikel 02.29.2016
                      AND (   (    v_exclude_mn = 'Y'
                               AND NVL (e.menu_line_cd, e.line_cd) <> 'MN')
                           OR (v_exclude_mn = 'N'))         --mikel 02.29.2016
                      AND a.cession_year = p_year
                      AND a.cession_mm = p_mm
                      AND a.line_cd = c.line_cd
                      AND a.share_cd = c.share_cd
                      AND DECODE (
                             v_start_date,
                             NULL, SYSDATE,
                             LAST_DAY (
                                TO_DATE (a.cession_mm || '-' || a.cession_year,
                                         'MM-YYYY'))) >=
                             DECODE (v_start_date, NULL, SYSDATE, v_start_date) --mikel 01.14.2013
                      AND b.reg_policy_sw = 'Y'
                      --AND b.expiry_date IS NOT NULL --jm test
                      -----fj
                      AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                           OR (    v_exclude_mn = 'N'
                               AND (b.line_cd = v_mn OR b.line_cd <> v_mn)))
                      AND ( (v_paramdate = 'E' -- mildred 01292013 comment to include late booking policies
                                              /*AND TRUNC (b.eff_date) >
                                                     LAST_DAY (ADD_MONTHS (TO_DATE (   p_ext_mm
                                                                                    || '-'
                                                                                    || p_ext_year,
                                                                                    'MM-YYYY'
                                                                                   ),
                                                                           -12
                                                                          )
                                                              )*/
                                              /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                           ) OR v_paramdate = 'A')
                      AND b.reg_policy_sw = 'Y'
                      /*AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                           OR (       v_exclude_mn = 'N'
                                  AND v_mn_24th_comp = '1'
                                  AND (       b.line_cd = v_mn
                                          AND (   (    v_paramdate = 'A'
                                                   AND v_mm_year IN
                                                                (v_mm_year_mn1, v_mm_year_mn2)
                                                  )
                                               OR (    v_paramdate = 'E'
                                                   AND v_mm_year IN
                                                                (v_mm_year_mn1, v_mm_year_mn2)
                                                  )
                                              )
                                       OR b.line_cd <> v_mn
                                      )
                               OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                              )
                          ) */
                      ----Added by FJ 11/12/2014 TO INCLUDE RECORDS ONLY FROM V_START_DATE
                      --THAT ARE NOT YET EXPIRED AS OF EXTRACTION DATE
                      AND (   (    /*TRUNC (
                                         NVL (b.endt_expiry_date,
                                              b.expiry_date)) >*/ --mikel 06.09.2016;UCPBGEN SR 22527
                                       invoice_takeupterm.get_exp_date (a.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2) > --Deo [08.22.2016]: SR-22527
                                      LAST_DAY (
                                         TO_DATE (
                                               LPAD (TO_CHAR (p_ext_mm),
                                                     2,
                                                     '0')
                                            || '-'
                                            || TO_CHAR (p_ext_year),
                                            'MM-YYYY'))
                               AND ( (TO_DATE (
                                         cession_mm || '-' || cession_year,
                                         'MM-YYYY') <
                                         LAST_DAY (
                                            TO_DATE (
                                                  LPAD (TO_CHAR (p_ext_mm),
                                                        2,
                                                        '0')
                                               || '-'
                                               || TO_CHAR (p_ext_year),
                                               'MM-YYYY')))))
                           OR TO_DATE (cession_mm || '-' || cession_year,
                                       'MM-YYYY') BETWEEN ADD_MONTHS (
                                                             TO_DATE (
                                                                   LPAD (
                                                                      TO_CHAR (
                                                                         p_ext_mm),
                                                                      2,
                                                                      '0')
                                                                || '-'
                                                                || TO_CHAR (
                                                                      p_ext_year),
                                                                'MM-YYYY'),
                                                             -11)
                                                      AND LAST_DAY (
                                                             TO_DATE (
                                                                   LPAD (
                                                                      TO_CHAR (
                                                                         p_ext_mm),
                                                                      2,
                                                                      '0')
                                                                || '-'
                                                                || TO_CHAR (
                                                                      p_ext_year),
                                                                'MM-YYYY')))
             --     AND NVL (b.endt_expiry_date, b.expiry_date) >
             --            LAST_DAY (TO_DATE (   LPAD (TO_CHAR (p_ext_mm), 2, '0')
             --                               || '-'
             --                               || TO_CHAR (p_ext_year),
             --                               'MM-YYYY'
             --                              )
             --                     )
             GROUP BY NVL (b.cred_branch, b.iss_cd),
                      b.policy_id,
                      b.eff_date,
                      b.expiry_date,
                      b.endt_expiry_date,
                      a.line_cd,
                      c.acct_trty_type,
                      b.acct_ent_date,
                      d.acct_ent_date,
                      d.acct_neg_date,
                      a.policy_id,
                      d.takeup_seq_no,
                      NVL (e.menu_line_cd, e.line_cd))      --mikel 02.09.2016
      LOOP
         v_pol_term := (trty_prem.expiry_date + 1) - trty_prem.eff_date;
         v_earned_days :=
              (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1)
            - trty_prem.eff_date;

         IF trty_prem.eff_date >
               LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY'))
         THEN
            v_earned_days := 0;
         END IF;

         IF v_earned_days > v_pol_term
         THEN
            v_earned_days := v_pol_term;
         END IF;

         --v_unearned_days := v_pol_term - (v_earned_days);
         v_num_factor := trty_prem.numerator;
         -- v_num_factor2   := v_earned_days;
         v_den_factor := trty_prem.denominator;

         UPDATE giac_deferred_ri_prem_cede_pol griprem_pol
            SET griprem_pol.dist_prem =
                   griprem_pol.dist_prem + trty_prem.dist_prem,
                griprem_pol.numerator_factor = v_num_factor,
                griprem_pol.denominator_factor = v_den_factor
          WHERE     griprem_pol.extract_year = p_ext_year
                AND griprem_pol.extract_mm = p_ext_mm
                AND griprem_pol.procedure_id = p_method
                AND griprem_pol.iss_cd = trty_prem.iss_cd
                AND griprem_pol.line_cd = trty_prem.line_cd
                AND griprem_pol.policy_no = trty_prem.policy_no
                AND griprem_pol.share_type = '2'
                AND griprem_pol.acct_trty_type = trty_prem.acct_trty_type
                AND griprem_pol.comp_sw = 'Y';

         IF SQL%NOTFOUND
         THEN
            INSERT INTO giac_deferred_ri_prem_cede_pol (extract_year,
                                                        extract_mm,
                                                        procedure_id,
                                                        iss_cd,
                                                        line_cd,
                                                        share_type,
                                                        acct_trty_type,
                                                        policy_no,
                                                        dist_prem,
                                                        eff_date,
                                                        expiry_date,
                                                        numerator_factor,
                                                        denominator_factor,
                                                        def_dist_prem,
                                                        user_id,
                                                        last_update,
                                                        comp_sw,
                                                        acct_ent_date,
                                                        acct_neg_date)
                 VALUES (p_ext_year,
                         p_ext_mm,
                         p_method,
                         trty_prem.iss_cd,
                         trty_prem.line_cd,
                         '2',
                         trty_prem.acct_trty_type,
                         trty_prem.policy_no,
                         trty_prem.dist_prem,
                         trty_prem.eff_date,
                         trty_prem.expiry_date,
                         v_num_factor,
                         v_den_factor,
                         v_def_prem,
                         v_user_id,
                         SYSDATE,
                         'Y',
                         trty_prem.acct_ent_date,
                         trty_prem.acct_neg_date);
         END IF;
      END LOOP;

      ----------------------------------------------------------------------------------------------------------------------------

      --Commission Income - Treaty
      FOR trty_ri_comm
         IN (  SELECT NVL (b.cred_branch, b.iss_cd) iss_cd,
                      a.line_cd,
                      get_policy_no (b.policy_id) policy_no,
                      /*TRUNC (b.eff_date) eff_date,
                      TRUNC (NVL (b.endt_expiry_date, b.expiry_date))
                                                                     expiry_date,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      invoice_takeupterm.get_eff_date (a.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         eff_date,
                      invoice_takeupterm.get_exp_date (a.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         expiry_date,
                      SUM (NVL (a.commission_amt, 0)) commission,
                      NVL (c.acct_trty_type, 0) acct_trty_type,
                      a.ri_cd,
                      /*DECODE
                         (MONTHS_BETWEEN (LAST_DAY (NVL (b.endt_expiry_date,
                                                         b.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', b.acct_ent_date,
                                                            'E', b.eff_date
                                                           )
                                                   )
                                         ),
                          0, 1,
                          MONTHS_BETWEEN (LAST_DAY (NVL (b.endt_expiry_date,
                                                         b.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', b.acct_ent_date,
                                                            'E', b.eff_date
                                                           )
                                                   )
                                         )
                         )
                    * 2 denominator,
                    DECODE
                       (SIGN
                           (MONTHS_BETWEEN (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (TO_DATE (   p_ext_mm
                                                               || '-'
                                                               || p_ext_year,
                                                               'MM-YYYY'
                                                              )
                                                     )
                                           )
                           ),
                        -1, 0,
                        DECODE
                           (SIGN
                               (MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                            )
                               ),
                            -1, DECODE
                                  (MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', b.acct_ent_date,
                                                              'E', b.eff_date
                                                             )
                                                     )
                                           ),
                                   0, 1,
                                   MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', b.acct_ent_date,
                                                              'E', b.eff_date
                                                             )
                                                     )
                                           )
                                  )
                             * 2,
                            DECODE
                               (SIGN
                                   (  (  MONTHS_BETWEEN
                                            (LAST_DAY (NVL (b.endt_expiry_date,
                                                            b.expiry_date
                                                           )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                            )
                                       * 2
                                      )
                                    - (  (  MONTHS_BETWEEN
                                               (LAST_DAY (TO_DATE (   p_ext_mm
                                                                   || '-'
                                                                   || p_ext_year,
                                                                   'MM-YYYY'
                                                                  )
                                                         ),
                                                LAST_DAY
                                                      (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                               )
                                          * 2
                                         )
                                       + 1
                                      )
                                   ),
                                -1, 0,
                                  (  MONTHS_BETWEEN
                                           (LAST_DAY (NVL (b.endt_expiry_date,
                                                           b.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', b.acct_ent_date,
                                                              'E', b.eff_date
                                                             )
                                                     )
                                           )
                                   * 2
                                  )
                                - (  (  MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', b.acct_ent_date,
                                                               'E', b.eff_date
                                                              )
                                                      )
                                            )
                                      * 2
                                     )
                                   + 1
                                  )
                               )
                           )
                       ) numerator,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      get_numerator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (a.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (a.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         NVL (e.menu_line_cd, e.line_cd))
                         numerator,
                      get_denominator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (a.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (a.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2)) --Deo [08.22.2016]: SR-22527
                         denominator,                   --end mikel 02.19.2016
                      d.acct_ent_date,
                      d.acct_neg_date
                 FROM giac_treaty_cessions a,
                      gipi_polbasic b,
                      giis_dist_share c,
                      giuw_pol_dist d,
                      giis_line e                           --mikel 02.29.2016
                WHERE     a.policy_id = b.policy_id
                      --Added by FJ to connect giuw_pol_dist
                      AND d.policy_id = b.policy_id
                      AND a.dist_no = d.dist_no
                      -------
                      AND b.line_cd = e.line_cd             --mikel 02.29.2016
                      AND (   (    v_exclude_mn = 'Y'
                               AND NVL (e.menu_line_cd, e.line_cd) <> 'MN')
                           OR (v_exclude_mn = 'N'))         --mikel 02.29.2016
                      AND a.cession_year = p_year
                      AND a.cession_mm = p_mm
                      AND a.line_cd = c.line_cd
                      AND a.share_cd = c.share_cd
                      AND DECODE (
                             v_start_date,
                             NULL, SYSDATE,
                             LAST_DAY (
                                TO_DATE (a.cession_mm || '-' || a.cession_year,
                                         'MM-YYYY'))) >=
                             DECODE (v_start_date, NULL, SYSDATE, v_start_date) --mikel 01.14.2013
                      /*  AND TRUNC (b.eff_date) >
                               LAST_DAY (ADD_MONTHS (TO_DATE (   p_ext_mm
                                                              || '-'
                                                              || p_ext_year,
                                                              'MM-YYYY'
                                                             ),
                                                     -12
                                                    )
                                        )*/
                      AND b.reg_policy_sw = 'Y'
                      AND b.expiry_date IS NOT NULL                  --jm test
                      -----fj
                      --     AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                      --          OR     (    v_exclude_mn = 'N'
                      --                  AND (b.line_cd = v_mn OR b.line_cd <> v_mn)
                      --                 )
                      --             AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                      --                  OR (       v_exclude_mn = 'N'
                      --                         AND v_mn_24th_comp = '1'
                      --                         AND (       b.line_cd = v_mn
                      --                                 AND (   (    v_paramdate = 'A'
                      --                                          AND v_mm_year IN
                      --                                                 (v_mm_year_mn1,
                      --                                                  v_mm_year_mn2)
                      --                                         )
                      --                                      OR (    v_paramdate = 'E'
                      --                                          /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                      --                                                       -- mildred 01292013 comment to include late booking policies
                      --                                                               /* AND (   TO_CHAR (b.eff_date,
                      --                                                                                 'MM-YYYY'
                      --                                                                                ) IN
                      --                                                                           (v_mm_year_mn1,
                      --                                                                            v_mm_year_mn2
                      --                                                                           )
                      --                                                                     OR TRUNC (b.eff_date) >
                      --                                                                           LAST_DAY
                      --                                                                               (TO_DATE (   p_ext_mm
                      --                                                                                         || '-'
                      --                                                                                         || p_ext_year,
                      --                                                                                         'MM-YYYY'
                      --                                                                                        )
                      --                                                                               )
                      --                                                                    )*/
                      --                                                       -- replace with --
                      --                                          AND v_mm_year IN
                      --                                                 (v_mm_year_mn1,
                      --                                                  v_mm_year_mn2)
                      --                                         )
                      --                                     )
                      --                              OR b.line_cd <> v_mn
                      --                             )
                      --                      OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                      --                     )
                      --                 )
                      --         )
                      ----Added by FJ 11/12/2014 TO INCLUDE RECORDS ONLY FROM V_START_DATE
                      --THAT ARE NOT YET EXPIRED AS OF EXTRACTION DATE
                      AND (   (    /*TRUNC (
                                         NVL (b.endt_expiry_date,
                                              b.expiry_date)) >*/ --mikel 06.09.2016;UCPBGEN SR 22527
                                       invoice_takeupterm.get_exp_date (a.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2) > --Deo [08.22.2016]: SR-22527
                                      LAST_DAY (
                                         TO_DATE (
                                               LPAD (TO_CHAR (p_ext_mm),
                                                     2,
                                                     '0')
                                            || '-'
                                            || TO_CHAR (p_ext_year),
                                            'MM-YYYY'))
                               AND ( (TO_DATE (
                                         cession_mm || '-' || cession_year,
                                         'MM-YYYY') <
                                         LAST_DAY (
                                            TO_DATE (
                                                  LPAD (TO_CHAR (p_ext_mm),
                                                        2,
                                                        '0')
                                               || '-'
                                               || TO_CHAR (p_ext_year),
                                               'MM-YYYY')))))
                           OR TO_DATE (cession_mm || '-' || cession_year,
                                       'MM-YYYY') BETWEEN ADD_MONTHS (
                                                             TO_DATE (
                                                                   LPAD (
                                                                      TO_CHAR (
                                                                         p_ext_mm),
                                                                      2,
                                                                      '0')
                                                                || '-'
                                                                || TO_CHAR (
                                                                      p_ext_year),
                                                                'MM-YYYY'),
                                                             -11)
                                                      AND LAST_DAY (
                                                             TO_DATE (
                                                                   LPAD (
                                                                      TO_CHAR (
                                                                         p_ext_mm),
                                                                      2,
                                                                      '0')
                                                                || '-'
                                                                || TO_CHAR (
                                                                      p_ext_year),
                                                                'MM-YYYY')))
             --     AND NVL (b.endt_expiry_date, b.expiry_date) >
             --            LAST_DAY (TO_DATE (   LPAD (TO_CHAR (p_ext_mm), 2, '0')
             --                               || '-'
             --                               || TO_CHAR (p_ext_year),
             --                               'MM-YYYY'
             --                              )
             --                     )                                                --end fj
             GROUP BY NVL (b.cred_branch, b.iss_cd),
                      a.line_cd,
                      b.policy_id,
                      b.eff_date,
                      b.expiry_date,
                      b.endt_expiry_date,
                      c.acct_trty_type,
                      a.ri_cd,
                      b.acct_ent_date,
                      d.acct_ent_date,
                      d.acct_neg_date,
                      a.policy_id,
                      d.takeup_seq_no,
                      NVL (e.menu_line_cd, e.line_cd))      --mikel 02.09.2016
      LOOP
         v_pol_term := (trty_ri_comm.expiry_date + 1) - trty_ri_comm.eff_date;
         v_earned_days :=
              (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1)
            - trty_ri_comm.eff_date;

         IF trty_ri_comm.eff_date >
               LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY'))
         THEN
            v_earned_days := 0;
         END IF;

         IF v_earned_days > v_pol_term
         THEN
            v_earned_days := v_pol_term;
         END IF;

         v_unearned_days := v_pol_term - (v_earned_days);
         /*IF v_def_comm_prod = 'Y' THEN
            v_num_factor   := v_earned_days;
         ELSE
            v_num_factor   := v_unearned_days;
         END IF;*/
         v_num_factor := trty_ri_comm.numerator;
         v_den_factor := trty_ri_comm.denominator;

         UPDATE giac_deferred_comm_income_pol gricomm_pol
            SET gricomm_pol.comm_income =
                   gricomm_pol.comm_income + trty_ri_comm.commission,
                gricomm_pol.numerator_factor = v_num_factor,
                gricomm_pol.denominator_factor = v_den_factor
          WHERE     gricomm_pol.extract_year = p_ext_year
                AND gricomm_pol.extract_mm = p_ext_mm
                AND gricomm_pol.procedure_id = p_method
                AND gricomm_pol.iss_cd = trty_ri_comm.iss_cd
                AND gricomm_pol.line_cd = trty_ri_comm.line_cd
                AND gricomm_pol.policy_no = trty_ri_comm.policy_no
                AND gricomm_pol.share_type = '2'
                AND gricomm_pol.acct_trty_type = trty_ri_comm.acct_trty_type
                AND gricomm_pol.ri_cd = trty_ri_comm.ri_cd
                AND gricomm_pol.comp_sw = 'Y';

         IF SQL%NOTFOUND
         THEN
            INSERT INTO giac_deferred_comm_income_pol (extract_year,
                                                       extract_mm,
                                                       procedure_id,
                                                       iss_cd,
                                                       line_cd,
                                                       share_type,
                                                       acct_trty_type,
                                                       policy_no,
                                                       ri_cd,
                                                       comm_income,
                                                       eff_date,
                                                       expiry_date,
                                                       numerator_factor,
                                                       denominator_factor,
                                                       def_comm_income,
                                                       user_id,
                                                       last_update,
                                                       comp_sw,
                                                       acct_ent_date,
                                                       acct_neg_date)
                 VALUES (p_ext_year,
                         p_ext_mm,
                         p_method,
                         trty_ri_comm.iss_cd,
                         trty_ri_comm.line_cd,
                         '2',
                         trty_ri_comm.acct_trty_type,
                         trty_ri_comm.policy_no,
                         trty_ri_comm.ri_cd,
                         trty_ri_comm.commission,
                         trty_ri_comm.eff_date,
                         trty_ri_comm.expiry_date,
                         v_num_factor,
                         v_den_factor,
                         v_def_prem,
                         v_user_id,
                         SYSDATE,
                         'Y',
                         trty_ri_comm.acct_ent_date,
                         trty_ri_comm.acct_neg_date);
         END IF;
      END LOOP;

      --------------------------------------------------------------------------------ok
      -- Facultative
      --Premiums
      FOR facul_prem
         IN (  SELECT a.line_cd,
                      NVL (e.cred_branch, e.iss_cd) iss_cd,
                      get_policy_no (e.policy_id) policy_no,
                      /*TRUNC (e.eff_date) eff_date,
                      TRUNC (NVL (e.endt_expiry_date, e.expiry_date))
                                                                     expiry_date,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      invoice_takeupterm.get_eff_date (d.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         eff_date,
                      invoice_takeupterm.get_exp_date (d.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         expiry_date,
                      a.ri_cd,
                      SUM (
                         ROUND (
                            NVL (
                                 DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),
                                         v_mm_year, -1,
                                         1)
                               * a.ri_prem_amt
                               * c.currency_rt,
                               0),
                            2))
                         premium,
                      /*DECODE
                         (MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                         e.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', e.acct_ent_date,
                                                            'E', e.eff_date
                                                           )
                                                   )
                                         ),
                          0, 1,
                          MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                         e.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', e.acct_ent_date,
                                                            'E', e.eff_date
                                                           )
                                                   )
                                         )
                         )
                    * 2 denominator,
                    DECODE
                       (SIGN
                           (MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (TO_DATE (   p_ext_mm
                                                               || '-'
                                                               || p_ext_year,
                                                               'MM-YYYY'
                                                              )
                                                     )
                                           )
                           ),
                        -1, 0,
                        DECODE
                           (SIGN
                               (MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                               ),
                            -1, DECODE
                                  (MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           ),
                                   0, 1,
                                   MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           )
                                  )
                             * 2,
                            DECODE
                               (SIGN
                                   (  (  MONTHS_BETWEEN
                                            (LAST_DAY (NVL (e.endt_expiry_date,
                                                            e.expiry_date
                                                           )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                                       * 2
                                      )
                                    - (  (  MONTHS_BETWEEN
                                               (LAST_DAY (TO_DATE (   p_ext_mm
                                                                   || '-'
                                                                   || p_ext_year,
                                                                   'MM-YYYY'
                                                                  )
                                                         ),
                                                LAST_DAY
                                                      (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                               )
                                          * 2
                                         )
                                       + 1
                                      )
                                   ),
                                -1, 0,
                                  (  MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           )
                                   * 2
                                  )
                                - (  (  MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                                      * 2
                                     )
                                   + 1
                                  )
                               )
                           )
                       ) numerator,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      get_numerator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         NVL (f.menu_line_cd, f.line_cd))
                         numerator,
                      get_denominator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2)) --Deo [08.22.2016]: SR-22527
                         denominator,                   --end mikel 02.19.2016
                      a.acc_ent_date,
                      e.spld_acct_ent_date,
                      d.acct_neg_date
                 FROM giri_binder a,
                      giri_frps_ri b,
                      giri_distfrps c,
                      giuw_pol_dist d,
                      gipi_polbasic e,
                      giis_line f                           --mikel 02.29.2016
                WHERE     a.fnl_binder_id = b.fnl_binder_id
                      AND b.line_cd = c.line_cd
                      AND b.frps_yy = c.frps_yy
                      AND b.frps_seq_no = c.frps_seq_no
                      AND c.dist_no = d.dist_no
                      AND d.policy_id = e.policy_id
                      AND e.line_cd = f.line_cd             --mikel 02.29.2016
                      AND (   (    v_exclude_mn = 'Y'
                               AND NVL (f.menu_line_cd, f.line_cd) <> 'MN')
                           OR (v_exclude_mn = 'N'))         --mikel 02.29.2016
                      AND DECODE (v_start_date, NULL, SYSDATE, a.acc_ent_date) >=
                             DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                      ----Added by FJ 11/12/2014 TO INCLUDE RECORDS ONLY FROM V_START_DATE
                      --THAT ARE NOT YET EXPIRED AS OF EXTRACTION DATE
                      AND (   (    /*TRUNC (
                                         NVL (e.endt_expiry_date,
                                              e.expiry_date)) >*/ --mikel 06.09.2016;UCPBGEN SR 22527
                                       invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2) > --Deo [08.22.2016]: SR-22527
                                      LAST_DAY (
                                         TO_DATE (
                                               LPAD (TO_CHAR (p_ext_mm),
                                                     2,
                                                     '0')
                                            || '-'
                                            || TO_CHAR (p_ext_year),
                                            'MM-YYYY'))
                               AND (   (a.acc_ent_date <
                                           LAST_DAY (
                                              TO_DATE (
                                                    LPAD (TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                 || '-'
                                                 || TO_CHAR (p_ext_year),
                                                 'MM-YYYY')))
                                    OR (a.acc_rev_date <
                                           LAST_DAY (
                                              TO_DATE (
                                                    LPAD (TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                 || '-'
                                                 || TO_CHAR (p_ext_year),
                                                 'MM-YYYY')))))
                           OR (   a.acc_ent_date BETWEEN ADD_MONTHS (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'),
                                                            -11)
                                                     AND LAST_DAY (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'))
                               OR a.acc_rev_date BETWEEN ADD_MONTHS (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'),
                                                            -11)
                                                     AND LAST_DAY (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'))))
                      --     AND NVL (e.endt_expiry_date, e.expiry_date) >
                      --            LAST_DAY (TO_DATE (   LPAD (TO_CHAR (p_ext_mm), 2, '0')
                      --                               || '-'
                      --                               || TO_CHAR (p_ext_year),
                      --                               'MM-YYYY'
                      --                              )
                      --                     )                                      --mikel 01.14.2013
                      --AND a.acc_ent_date = LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')) -- pjsantos 09/30/2014,  from deferred_extract2.
                      AND TO_CHAR (a.acc_ent_date, 'MM-YYYY') = v_mm_year
                      --pjsantos 09/30/2014,  from deferred_extract2.
                      AND LAST_DAY (d.acct_ent_date) <=
                             --pjsantos 09/30/2014, from deferred_extract2.
                             LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
                      AND ( (v_paramdate = 'E') OR v_paramdate = 'A')
                      /*AND TRUNC (e.eff_date) >
                             LAST_DAY (ADD_MONTHS (TO_DATE (   p_ext_mm
                                                            || '-'
                                                            || p_ext_year,
                                                            'MM-YYYY'
                                                           ),
                                                   -12
                                                  )
                                      )*/
                      --pjsantos 09/30/2014, from deferred_extract2.
                      AND e.reg_policy_sw = 'Y'
                      --     AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                      --          OR (       v_exclude_mn = 'N'
                      --                 AND v_mn_24th_comp = '1'
                      --                 AND (       e.line_cd = v_mn
                      --                         AND (   (    v_paramdate = 'A'
                      --                                  AND v_mm_year IN
                      --                                               (v_mm_year_mn1, v_mm_year_mn2)
                      --                                 )
                      --                              OR (    v_paramdate = 'E'
                      --                                  /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                      --                                               -- mildred 01292013 comment to include late booking MN binders
                      --                                                                /*AND (   TO_CHAR (e.eff_date,
                      --                                                                                 'MM-YYYY'
                      --                                                                                ) IN
                      --                                                                           (v_mm_year_mn1_fac,
                      --                                                                            v_mn_year_mn2_fac
                      --                                                                           )
                      --                                                                     OR TRUNC (e.eff_date) >
                      --                                                                           LAST_DAY
                      --                                                                                 (TO_DATE (v_mm_year,
                      --                                                                                           'MM-YYYY'
                      --                                                                                          )
                      --                                                                                 )
                      --                                                                    )*/
                      --                                                -- replace with --
                      --                                                                  --AND v_mm_year IN (v_mm_year_mn1_fac,v_mn_year_mn2_fac) comment out by pjsantos,  from deferred_extract2.
                      --                                  AND v_mm_year IN
                      --                                               (v_mm_year_mn1, v_mm_year_mn2)
                      --                                 --added by pjsantos ,  from deferred_extract2.
                      --                                            --mikel 02.27.2013
                      --                                 )
                      --                             )
                      --                      OR e.line_cd <> v_mn
                      --                     )
                      --              OR v_mn_24th_comp = '2' AND e.line_cd = e.line_cd
                      --             )
                      --         )
                      --AND e.expiry_date IS NOT NULL --jm test
                      -----fj
                      AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                           OR (    v_exclude_mn = 'N'
                               AND (e.line_cd = v_mn OR e.line_cd <> v_mn))) --end fj
             GROUP BY NVL (e.cred_branch, e.iss_cd),
                      a.line_cd,
                      a.ri_cd,
                      e.policy_id,
                      e.eff_date,
                      e.expiry_date,
                      e.endt_expiry_date,
                      e.acct_ent_date,
                      e.spld_acct_ent_date,
                      a.acc_ent_date,
                      d.acct_ent_date,
                      d.acct_neg_date,
                      /*added by pjsantos, from deferred_extract2*/
                      DECODE (
                         v_paramdate,
                         'A', p_year,
                         'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                             DECODE (
                                 SIGN (
                                      LAST_DAY (
                                         TO_DATE (
                                            p_ext_mm || '-' || p_ext_year,
                                            'MM-YYYY'))
                                    - LAST_DAY (TRUNC (e.eff_date))),
                                 -1, p_ext_year,
                                 TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY')))),
                      DECODE (
                         v_paramdate,
                         'A', p_mm,
                         'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                             DECODE (
                                 SIGN (
                                      LAST_DAY (
                                         TO_DATE (
                                            p_ext_mm || '-' || p_ext_year,
                                            'MM-YYYY'))
                                    - LAST_DAY (TRUNC (e.eff_date))),
                                 -1, 99,
                                 --albert 01242014; to handle expired policies
                                 DECODE (
                                    SIGN (
                                         (  LAST_DAY (
                                               TO_DATE (
                                                     p_ext_mm
                                                  || '-'
                                                  || p_ext_year,
                                                  'MM-YYYY'))
                                          - LAST_DAY (
                                               TRUNC (
                                                  NVL (e.endt_expiry_date,
                                                       e.expiry_date))))
                                       + 1),
                                    1, 99,
                                    --end albert 01242014
                                    TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))))),
                      d.policy_id,
                      d.takeup_seq_no,
                      NVL (f.menu_line_cd, f.line_cd)       --mikel 02.09.2016
             /*pjsantos end*/
             UNION
               SELECT a.line_cd,
                      NVL (e.cred_branch, e.iss_cd) iss_cd,
                      get_policy_no (e.policy_id) policy_no,
                      /*TRUNC (e.eff_date) eff_date,
                      TRUNC (NVL (e.endt_expiry_date, e.expiry_date))
                                                                     expiry_date,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      invoice_takeupterm.get_eff_date (d.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         eff_date,
                      invoice_takeupterm.get_exp_date (d.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         expiry_date,
                      a.ri_cd,
                      SUM (
                         ROUND (
                            NVL (
                                 DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),
                                         v_mm_year, -1,
                                         1)
                               * a.ri_prem_amt
                               * c.currency_rt,
                               0),
                            2))
                         premium,
                      /*DECODE
                         (MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                         e.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', e.acct_ent_date,
                                                            'E', e.eff_date
                                                           )
                                                   )
                                         ),
                          0, 1,
                          MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                         e.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', e.acct_ent_date,
                                                            'E', e.eff_date
                                                           )
                                                   )
                                         )
                         )
                    * 2 denominator,
                    DECODE
                       (SIGN
                           (MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (TO_DATE (   p_ext_mm
                                                               || '-'
                                                               || p_ext_year,
                                                               'MM-YYYY'
                                                              )
                                                     )
                                           )
                           ),
                        -1, 0,
                        DECODE
                           (SIGN
                               (MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                               ),
                            -1, DECODE
                                  (MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           ),
                                   0, 1,
                                   MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           )
                                  )
                             * 2,
                            DECODE
                               (SIGN
                                   (  (  MONTHS_BETWEEN
                                            (LAST_DAY (NVL (e.endt_expiry_date,
                                                            e.expiry_date
                                                           )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                                       * 2
                                      )
                                    - (  (  MONTHS_BETWEEN
                                               (LAST_DAY (TO_DATE (   p_ext_mm
                                                                   || '-'
                                                                   || p_ext_year,
                                                                   'MM-YYYY'
                                                                  )
                                                         ),
                                                LAST_DAY
                                                      (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                               )
                                          * 2
                                         )
                                       + 1
                                      )
                                   ),
                                -1, 0,
                                  (  MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           )
                                   * 2
                                  )
                                - (  (  MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                                      * 2
                                     )
                                   + 1
                                  )
                               )
                           )
                       ) numerator,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      get_numerator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         NVL (f.menu_line_cd, f.line_cd))
                         numerator,
                      get_denominator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2)) --Deo [08.22.2016]: SR-22527
                         denominator,                   --end mikel 02.19.2016
                      a.acc_ent_date,
                      e.spld_acct_ent_date,
                      d.acct_neg_date
                 FROM giri_binder a,
                      giri_frps_ri b,
                      giri_distfrps c,
                      giuw_pol_dist d,
                      gipi_polbasic e,
                      giis_line f                           --mikel 02.29.2016
                WHERE     a.fnl_binder_id = b.fnl_binder_id
                      AND b.line_cd = c.line_cd
                      AND b.frps_yy = c.frps_yy
                      AND b.frps_seq_no = c.frps_seq_no
                      AND c.dist_no = d.dist_no
                      AND d.policy_id = e.policy_id
                      AND e.line_cd = f.line_cd             --mikel 02.29.2016
                      AND (   (    v_exclude_mn = 'Y'
                               AND NVL (f.menu_line_cd, f.line_cd) <> 'MN')
                           OR (v_exclude_mn = 'N'))         --mikel 02.29.2016
                      AND DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >=
                             DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                      ----Added by FJ 11/12/2014 TO INCLUDE RECORDS ONLY FROM V_START_DATE
                      --THAT ARE NOT YET EXPIRED AS OF EXTRACTION DATE
                      AND (   (    /*TRUNC (
                                         NVL (e.endt_expiry_date,
                                              e.expiry_date)) >*/ --mikel 06.09.2016;UCPBGEN SR 22527
                                       invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2) > --Deo [08.22.2016]: SR-22527
                                      LAST_DAY (
                                         TO_DATE (
                                               LPAD (TO_CHAR (p_ext_mm),
                                                     2,
                                                     '0')
                                            || '-'
                                            || TO_CHAR (p_ext_year),
                                            'MM-YYYY'))
                               AND (   (a.acc_ent_date <
                                           LAST_DAY (
                                              TO_DATE (
                                                    LPAD (TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                 || '-'
                                                 || TO_CHAR (p_ext_year),
                                                 'MM-YYYY')))
                                    OR (a.acc_rev_date <
                                           LAST_DAY (
                                              TO_DATE (
                                                    LPAD (TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                 || '-'
                                                 || TO_CHAR (p_ext_year),
                                                 'MM-YYYY')))))
                           OR (   a.acc_ent_date BETWEEN ADD_MONTHS (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'),
                                                            -11)
                                                     AND LAST_DAY (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'))
                               OR a.acc_rev_date BETWEEN ADD_MONTHS (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'),
                                                            -11)
                                                     AND LAST_DAY (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'))))
                      --     AND NVL (e.endt_expiry_date, e.expiry_date) >
                      --            LAST_DAY (TO_DATE (   LPAD (TO_CHAR (p_ext_mm), 2, '0')
                      --                               || '-'
                      --                               || TO_CHAR (p_ext_year),
                      --                               'MM-YYYY'
                      --                              )
                      --                     )                                      --mikel 01.14.2013
                      --AND a.acc_rev_date = LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')) --comment out by pjsantos
                      AND TO_CHAR (a.acc_rev_date, 'MM-YYYY') = v_mm_year
                      --pjsantos 09/30/2014, from deferred_extract2.
                      AND (   (d.dist_flag = '3' AND b.reverse_sw = 'Y') --pjsantos 09/30/2014, from deferred_extract2.
                           OR (    d.dist_flag = '4'
                               AND TO_CHAR (d.acct_neg_date, 'MM-YYYY') =
                                      v_mm_year)
                           OR (d.dist_flag = '5'))
                      AND ( (v_paramdate = 'E') OR v_paramdate = 'A')
                      /* AND TRUNC (e.eff_date) >
                              LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year,
                                                             'MM-YYYY'
                                                            ),
                                                    -12
                                                   )
                                     )*/
                      --pjsantos 09/30/2014, from deferred_extract2.
                      AND e.reg_policy_sw = 'Y'
                      /* added by pjsantos,  from deferred_extract2.*/
                      --     AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                      --          OR (       v_exclude_mn = 'N'
                      --                 AND v_mn_24th_comp = '1'
                      --                 AND (       e.line_cd = v_mn
                      --                         AND (   (    v_paramdate = 'A'
                      --                                  AND v_mm_year IN
                      --                                               (v_mm_year_mn1, v_mm_year_mn2)
                      --                                 )
                      --                              OR (    v_paramdate = 'E'
                      --                                  /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                      --                                               -- mildred 01292013 comment to include late booking MN binders
                      --                                                               /* AND (   TO_CHAR (e.eff_date,
                      --                                                                                 'MM-YYYY'
                      --                                                                                ) IN
                      --                                                                           (v_mm_year_mn1_fac,
                      --                                                                            v_mn_year_mn2_fac
                      --                                                                           )
                      --                                                                     OR TRUNC (e.eff_date) >
                      --                                                                           LAST_DAY
                      --                                                                                 (TO_DATE (v_mm_year,
                      --                                                                                           'MM-YYYY'
                      --                                                                                          )
                      --                                                                                 )
                      --                                                                    )*/
                      --                                               -- replace with --
                      --                                                                   --AND v_mm_year IN (v_mm_year_mn1_fac,v_mn_year_mn2_fac)
                      --                                  AND v_mm_year IN
                      --                                               (v_mm_year_mn1, v_mm_year_mn2)
                      --                                 --mikel 02.27.2013
                      --                                 )
                      --                             )
                      --                      OR e.line_cd <> v_mn
                      --                     )
                      --              OR v_mn_24th_comp = '2' AND e.line_cd = e.line_cd
                      --             )
                      --         )
                      /*pjsantos end*/
                      -----fj
                      AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                           OR (    v_exclude_mn = 'N'
                               AND (e.line_cd = v_mn OR e.line_cd <> v_mn))) -- end fj
             GROUP BY NVL (e.cred_branch, e.iss_cd),
                      a.line_cd,
                      a.ri_cd,
                      e.policy_id,
                      e.eff_date,
                      e.expiry_date,
                      e.endt_expiry_date,
                      e.spld_acct_ent_date,
                      e.acct_ent_date,
                      a.acc_ent_date,
                      d.acct_ent_date,
                      d.acct_neg_date,
                      /*added by pjsantos, from deferred_extract2*/
                      DECODE (
                         v_paramdate,
                         'A', p_year,
                         'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                             DECODE (
                                 SIGN (
                                      LAST_DAY (
                                         TO_DATE (
                                            p_ext_mm || '-' || p_ext_year,
                                            'MM-YYYY'))
                                    - LAST_DAY (TRUNC (e.eff_date))),
                                 -1, p_ext_year,
                                 TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY')))),
                      DECODE (
                         v_paramdate,
                         'A', p_mm,
                         'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                             DECODE (
                                 SIGN (
                                      LAST_DAY (
                                         TO_DATE (
                                            p_ext_mm || '-' || p_ext_year,
                                            'MM-YYYY'))
                                    - LAST_DAY (TRUNC (e.eff_date))),
                                 -1, 99,
                                 --albert 01242014; to handle expired policies
                                 DECODE (
                                    SIGN (
                                         (  LAST_DAY (
                                               TO_DATE (
                                                     p_ext_mm
                                                  || '-'
                                                  || p_ext_year,
                                                  'MM-YYYY'))
                                          - LAST_DAY (
                                               TRUNC (
                                                  NVL (e.endt_expiry_date,
                                                       e.expiry_date))))
                                       + 1),
                                    1, 99,
                                    --end albert 01242014
                                    TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))))),
                      d.policy_id,
                      d.takeup_seq_no,
                      NVL (f.menu_line_cd, f.line_cd))   --mikel 02.09.2016  )
      LOOP
         v_pol_term := (facul_prem.expiry_date + 1) - facul_prem.eff_date;
         v_earned_days :=
              (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1)
            - facul_prem.eff_date;

         IF facul_prem.eff_date >
               LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY'))
         THEN
            v_earned_days := 0;
         END IF;

         IF v_earned_days > v_pol_term
         THEN
            v_earned_days := v_pol_term;
         END IF;

         v_unearned_days := v_pol_term - (v_earned_days);
         v_num_factor := facul_prem.numerator;
         v_num_factor2 := v_earned_days;
         v_den_factor := facul_prem.denominator;

         UPDATE giac_deferred_ri_prem_cede_pol gfacprem_pol
            SET gfacprem_pol.dist_prem =
                   gfacprem_pol.dist_prem + facul_prem.premium,
                gfacprem_pol.numerator_factor = v_num_factor,
                gfacprem_pol.denominator_factor = v_den_factor
          WHERE     gfacprem_pol.extract_year = p_ext_year
                AND gfacprem_pol.extract_mm = p_ext_mm
                AND gfacprem_pol.iss_cd = facul_prem.iss_cd
                AND gfacprem_pol.line_cd = facul_prem.line_cd
                AND gfacprem_pol.procedure_id = p_method
                AND gfacprem_pol.policy_no = facul_prem.policy_no
                AND gfacprem_pol.share_type = '3'
                AND gfacprem_pol.acct_trty_type = 0
                AND gfacprem_pol.comp_sw = 'Y';

         IF SQL%NOTFOUND
         THEN
            INSERT
              INTO giac_deferred_ri_prem_cede_pol (extract_year,
                                                   extract_mm,
                                                   procedure_id,
                                                   iss_cd,
                                                   line_cd,
                                                   share_type,
                                                   policy_no,
                                                   dist_prem,
                                                   eff_date,
                                                   expiry_date,
                                                   numerator_factor,
                                                   denominator_factor,
                                                   def_dist_prem,
                                                   user_id,
                                                   last_update,
                                                   comp_sw,
                                                   acct_ent_date,
                                                   spoiled_acct_ent_date,
                                                   acct_neg_date)
            VALUES (p_ext_year,
                    p_ext_mm,
                    p_method,
                    facul_prem.iss_cd,
                    facul_prem.line_cd,
                    '3',
                    facul_prem.policy_no,
                    facul_prem.premium,
                    facul_prem.eff_date,
                    facul_prem.expiry_date,
                    v_num_factor,
                    v_den_factor,
                    v_def_prem,
                    v_user_id,
                    SYSDATE,
                    'Y',
                    facul_prem.acc_ent_date,
                    facul_prem.spld_acct_ent_date,
                    facul_prem.acct_neg_date);
         END IF;
      END LOOP;

      --Commission Income - Facultative
      FOR facul_ri_comm
         IN (  SELECT a.line_cd,
                      NVL (e.cred_branch, e.iss_cd) iss_cd,
                      get_policy_no (e.policy_id) policy_no,
                      /*TRUNC (e.eff_date) eff_date,
                      TRUNC (NVL (e.endt_expiry_date, e.expiry_date))
                                                                     expiry_date,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      invoice_takeupterm.get_eff_date (d.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         eff_date,
                      invoice_takeupterm.get_exp_date (d.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         expiry_date,
                      a.ri_cd,
                      SUM (
                         ROUND (
                            NVL (
                                 DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),
                                         v_mm_year, -1,
                                         1)
                               * a.ri_comm_amt
                               * c.currency_rt,
                               0),
                            2))
                         commission,
                      /*DECODE
                         (MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                         e.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', e.acct_ent_date,
                                                            'E', e.eff_date
                                                           )
                                                   )
                                         ),
                          0, 1,
                          MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                         e.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', e.acct_ent_date,
                                                            'E', e.eff_date
                                                           )
                                                   )
                                         )
                         )
                    * 2 denominator,
                    DECODE
                       (SIGN
                           (MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (TO_DATE (   p_ext_mm
                                                               || '-'
                                                               || p_ext_year,
                                                               'MM-YYYY'
                                                              )
                                                     )
                                           )
                           ),
                        -1, 0,
                        DECODE
                           (SIGN
                               (MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                               ),
                            -1, DECODE
                                  (MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           ),
                                   0, 1,
                                   MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           )
                                  )
                             * 2,
                            DECODE
                               (SIGN
                                   (  (  MONTHS_BETWEEN
                                            (LAST_DAY (NVL (e.endt_expiry_date,
                                                            e.expiry_date
                                                           )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                                       * 2
                                      )
                                    - (  (  MONTHS_BETWEEN
                                               (LAST_DAY (TO_DATE (   p_ext_mm
                                                                   || '-'
                                                                   || p_ext_year,
                                                                   'MM-YYYY'
                                                                  )
                                                         ),
                                                LAST_DAY
                                                      (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                               )
                                          * 2
                                         )
                                       + 1
                                      )
                                   ),
                                -1, 0,
                                  (  MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           )
                                   * 2
                                  )
                                - (  (  MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                                      * 2
                                     )
                                   + 1
                                  )
                               )
                           )
                       ) numerator,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      get_numerator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         NVL (f.menu_line_cd, f.line_cd))
                         numerator,
                      get_denominator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2)) --Deo [08.22.2016]: SR-22527
                         denominator,                   --end mikel 02.19.2016
                      a.acc_ent_date,
                      d.acct_neg_date
                 FROM giri_binder a,
                      giri_frps_ri b,
                      giri_distfrps c,
                      giuw_pol_dist d,
                      gipi_polbasic e,
                      giis_line f                           --mikel 02.29.2016
                WHERE     a.fnl_binder_id = b.fnl_binder_id
                      AND b.line_cd = c.line_cd
                      AND b.frps_yy = c.frps_yy
                      AND b.frps_seq_no = c.frps_seq_no
                      AND c.dist_no = d.dist_no
                      AND d.policy_id = e.policy_id
                      AND e.line_cd = f.line_cd             --mikel 02.29.2016
                      AND (   (    v_exclude_mn = 'Y'
                               AND NVL (f.menu_line_cd, f.line_cd) <> 'MN')
                           OR (v_exclude_mn = 'N'))         --mikel 02.29.2016
                      AND DECODE (v_start_date, NULL, SYSDATE, a.acc_ent_date) >=
                             DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                      ----Added by FJ 11/12/2014 TO INCLUDE RECORDS ONLY FROM V_START_DATE
                      --THAT ARE NOT YET EXPIRED AS OF EXTRACTION DATE
                      AND (   (    /*TRUNC (
                                         NVL (e.endt_expiry_date,
                                              e.expiry_date)) >*/ --mikel 06.09.2016;UCPBGEN SR 22527
                                       invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2) > --Deo [08.22.2016]: SR-22527
                                      LAST_DAY (
                                         TO_DATE (
                                               LPAD (TO_CHAR (p_ext_mm),
                                                     2,
                                                     '0')
                                            || '-'
                                            || TO_CHAR (p_ext_year),
                                            'MM-YYYY'))
                               AND (   (a.acc_ent_date <
                                           LAST_DAY (
                                              TO_DATE (
                                                    LPAD (TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                 || '-'
                                                 || TO_CHAR (p_ext_year),
                                                 'MM-YYYY')))
                                    OR (a.acc_rev_date <
                                           LAST_DAY (
                                              TO_DATE (
                                                    LPAD (TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                 || '-'
                                                 || TO_CHAR (p_ext_year),
                                                 'MM-YYYY')))))
                           OR (   a.acc_ent_date BETWEEN ADD_MONTHS (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'),
                                                            -11)
                                                     AND LAST_DAY (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'))
                               OR a.acc_rev_date BETWEEN ADD_MONTHS (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'),
                                                            -11)
                                                     AND LAST_DAY (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'))))
                      --mikel 01.14.2013
                      --AND a.acc_ent_date = LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')) -- pjsantos 09/30/2014,  from deferred_extract2.
                      AND TO_CHAR (a.acc_ent_date, 'MM-YYYY') = v_mm_year
                      --pjsantos 09/30/2014,  from deferred_extract2.
                      AND LAST_DAY (d.acct_ent_date) <=
                             --pjsantos 09/30/2014, from deferred_extract2.
                             LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
                      AND ( (v_paramdate = 'E') OR v_paramdate = 'A')
                      AND e.reg_policy_sw = 'Y'
                      --     AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                      --          OR (       v_exclude_mn = 'N'
                      --                 AND v_mn_24th_comp = '1'
                      --                 AND (       e.line_cd = v_mn
                      --                         AND (   (    v_paramdate = 'A'
                      --                                  AND v_mm_year IN
                      --                                               (v_mm_year_mn1, v_mm_year_mn2)
                      --                                 )
                      --                              OR (    v_paramdate = 'E'
                      --                                  /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                      --                                               -- mildred 01292013 comment to include late booking MN binders
                      --                                                                /*AND (   TO_CHAR (e.eff_date,
                      --                                                                                 'MM-YYYY'
                      --                                                                                ) IN
                      --                                                                           (v_mm_year_mn1_fac,
                      --                                                                            v_mn_year_mn2_fac
                      --                                                                           )
                      --                                                                     OR TRUNC (e.eff_date) >
                      --                                                                           LAST_DAY
                      --                                                                                 (TO_DATE (v_mm_year,
                      --                                                                                           'MM-YYYY'
                      --                                                                                          )
                      --                                                                                 )
                      --                                                                    )*/
                      --                                                -- replace with --
                      --                                                                  --AND v_mm_year IN (v_mm_year_mn1_fac,v_mn_year_mn2_fac) comment out by pjsantos,  from deferred_extract2.
                      --                                  AND v_mm_year IN
                      --                                               (v_mm_year_mn1, v_mm_year_mn2)
                      --                                 --added by pjsantos ,  from deferred_extract2.
                      --                                            --mikel 02.27.2013
                      --                                 )
                      --                             )
                      --                      OR e.line_cd <> v_mn
                      --                     )
                      --              OR v_mn_24th_comp = '2' AND e.line_cd = e.line_cd
                      --             )
                      --         )
                      --AND e.expiry_date IS NOT NULL --jm test
                      -----fj
                      AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                           OR (    v_exclude_mn = 'N'
                               AND (e.line_cd = v_mn OR e.line_cd <> v_mn))) --end fj
             GROUP BY NVL (e.cred_branch, e.iss_cd),
                      a.line_cd,
                      a.ri_cd,
                      e.policy_id,
                      e.eff_date,
                      e.expiry_date,
                      e.endt_expiry_date,
                      e.acct_ent_date,
                      a.acc_ent_date,
                      d.acct_ent_date,
                      d.acct_neg_date,
                      /*added by pjsantos, from deferred_extract2*/
                      DECODE (
                         v_paramdate,
                         'A', p_year,
                         'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                             DECODE (
                                 SIGN (
                                      LAST_DAY (
                                         TO_DATE (
                                            p_ext_mm || '-' || p_ext_year,
                                            'MM-YYYY'))
                                    - LAST_DAY (TRUNC (e.eff_date))),
                                 -1, p_ext_year,
                                 TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY')))),
                      DECODE (
                         v_paramdate,
                         'A', p_mm,
                         'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                             DECODE (
                                 SIGN (
                                      LAST_DAY (
                                         TO_DATE (
                                            p_ext_mm || '-' || p_ext_year,
                                            'MM-YYYY'))
                                    - LAST_DAY (TRUNC (e.eff_date))),
                                 -1, 99,
                                 --albert 01242014; to handle expired policies
                                 DECODE (
                                    SIGN (
                                         (  LAST_DAY (
                                               TO_DATE (
                                                     p_ext_mm
                                                  || '-'
                                                  || p_ext_year,
                                                  'MM-YYYY'))
                                          - LAST_DAY (
                                               TRUNC (
                                                  NVL (e.endt_expiry_date,
                                                       e.expiry_date))))
                                       + 1),
                                    1, 99,
                                    --end albert 01242014
                                    TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))))),
                      d.policy_id,
                      d.takeup_seq_no,
                      NVL (f.menu_line_cd, f.line_cd)       --mikel 02.09.2016
             /*pjsantos end*/
             UNION
               SELECT a.line_cd,
                      NVL (e.cred_branch, e.iss_cd) iss_cd,
                      get_policy_no (e.policy_id) policy_no,
                      /*TRUNC (e.eff_date) eff_date,
                      TRUNC (NVL (e.endt_expiry_date, e.expiry_date))
                                                                     expiry_date,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      invoice_takeupterm.get_eff_date (d.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         eff_date,
                      invoice_takeupterm.get_exp_date (d.policy_id,
                                                       d.takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         expiry_date,
                      a.ri_cd,
                      SUM (
                         ROUND (
                            NVL (
                                 DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),
                                         v_mm_year, -1,
                                         1)
                               * a.ri_comm_amt
                               * c.currency_rt,
                               0),
                            2))
                         commission,
                      /*DECODE
                         (MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                         e.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', e.acct_ent_date,
                                                            'E', e.eff_date
                                                           )
                                                   )
                                         ),
                          0, 1,
                          MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                         e.expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', e.acct_ent_date,
                                                            'E', e.eff_date
                                                           )
                                                   )
                                         )
                         )
                    * 2 denominator,
                    DECODE
                       (SIGN
                           (MONTHS_BETWEEN (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (TO_DATE (   p_ext_mm
                                                               || '-'
                                                               || p_ext_year,
                                                               'MM-YYYY'
                                                              )
                                                     )
                                           )
                           ),
                        -1, 0,
                        DECODE
                           (SIGN
                               (MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                               ),
                            -1, DECODE
                                  (MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           ),
                                   0, 1,
                                   MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           )
                                  )
                             * 2,
                            DECODE
                               (SIGN
                                   (  (  MONTHS_BETWEEN
                                            (LAST_DAY (NVL (e.endt_expiry_date,
                                                            e.expiry_date
                                                           )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                                       * 2
                                      )
                                    - (  (  MONTHS_BETWEEN
                                               (LAST_DAY (TO_DATE (   p_ext_mm
                                                                   || '-'
                                                                   || p_ext_year,
                                                                   'MM-YYYY'
                                                                  )
                                                         ),
                                                LAST_DAY
                                                      (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                               )
                                          * 2
                                         )
                                       + 1
                                      )
                                   ),
                                -1, 0,
                                  (  MONTHS_BETWEEN
                                           (LAST_DAY (NVL (e.endt_expiry_date,
                                                           e.expiry_date
                                                          )
                                                     ),
                                            LAST_DAY (DECODE (v_paramdate,
                                                              'A', e.acct_ent_date,
                                                              'E', e.eff_date
                                                             )
                                                     )
                                           )
                                   * 2
                                  )
                                - (  (  MONTHS_BETWEEN
                                            (LAST_DAY (TO_DATE (   p_ext_mm
                                                                || '-'
                                                                || p_ext_year,
                                                                'MM-YYYY'
                                                               )
                                                      ),
                                             LAST_DAY (DECODE (v_paramdate,
                                                               'A', e.acct_ent_date,
                                                               'E', e.eff_date
                                                              )
                                                      )
                                            )
                                      * 2
                                     )
                                   + 1
                                  )
                               )
                           )
                       ) numerator,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      get_numerator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         NVL (f.menu_line_cd, f.line_cd))
                         numerator,
                      get_denominator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2)) --Deo [08.22.2016]: SR-22527
                         denominator,                   --end mikel 02.19.2016
                      a.acc_ent_date,
                      d.acct_neg_date
                 FROM giri_binder a,
                      giri_frps_ri b,
                      giri_distfrps c,
                      giuw_pol_dist d,
                      gipi_polbasic e,
                      giis_line f                           --mikel 02.29.2016
                WHERE     a.fnl_binder_id = b.fnl_binder_id
                      AND b.line_cd = c.line_cd
                      AND b.frps_yy = c.frps_yy
                      AND b.frps_seq_no = c.frps_seq_no
                      AND c.dist_no = d.dist_no
                      AND d.policy_id = e.policy_id
                      AND e.line_cd = f.line_cd             --mikel 02.29.2016
                      AND (   (    v_exclude_mn = 'Y'
                               AND NVL (f.menu_line_cd, f.line_cd) <> 'MN')
                           OR (v_exclude_mn = 'N'))         --mikel 02.29.2016
                      AND DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >=
                             DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                      ----Added by FJ 11/12/2014 TO INCLUDE RECORDS ONLY FROM V_START_DATE
                      --THAT ARE NOT YET EXPIRED AS OF EXTRACTION DATE
                      AND (   (    /*TRUNC (
                                         NVL (e.endt_expiry_date,
                                              e.expiry_date)) >*/ --mikel 06.09.2016;UCPBGEN SR 22527
                                       invoice_takeupterm.get_exp_date (d.policy_id,
                                                          d.takeup_seq_no,
                                                          v_mm_year_mn2) > --Deo [08.22.2016]: SR-22527
                                      LAST_DAY (
                                         TO_DATE (
                                               LPAD (TO_CHAR (p_ext_mm),
                                                     2,
                                                     '0')
                                            || '-'
                                            || TO_CHAR (p_ext_year),
                                            'MM-YYYY'))
                               AND (   (a.acc_ent_date <
                                           LAST_DAY (
                                              TO_DATE (
                                                    LPAD (TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                 || '-'
                                                 || TO_CHAR (p_ext_year),
                                                 'MM-YYYY')))
                                    OR (a.acc_rev_date <
                                           LAST_DAY (
                                              TO_DATE (
                                                    LPAD (TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                 || '-'
                                                 || TO_CHAR (p_ext_year),
                                                 'MM-YYYY')))))
                           OR (   a.acc_ent_date BETWEEN ADD_MONTHS (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'),
                                                            -11)
                                                     AND LAST_DAY (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'))
                               OR a.acc_rev_date BETWEEN ADD_MONTHS (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'),
                                                            -11)
                                                     AND LAST_DAY (
                                                            TO_DATE (
                                                                  LPAD (
                                                                     TO_CHAR (
                                                                        p_ext_mm),
                                                                     2,
                                                                     '0')
                                                               || '-'
                                                               || TO_CHAR (
                                                                     p_ext_year),
                                                               'MM-YYYY'))))
                      AND TO_CHAR (a.acc_rev_date, 'MM-YYYY') = v_mm_year
                      --pjsantos 09/30/2014, from deferred_extract2.
                      AND (   (d.dist_flag = '3' AND b.reverse_sw = 'Y') --pjsantos 09/30/2014, from deferred_extract2.
                           OR (    d.dist_flag = '4'
                               AND TO_CHAR (d.acct_neg_date, 'MM-YYYY') =
                                      v_mm_year)
                           OR (d.dist_flag = '5'))
                      AND ( (v_paramdate = 'E') OR v_paramdate = 'A')
                      /* AND TRUNC (e.eff_date) >
                              LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year,
                                                             'MM-YYYY'
                                                            ),
                                                    -12
                                                   )
                                     )*/
                      --pjsantos 09/30/2014, from deferred_extract2.
                      AND e.reg_policy_sw = 'Y'
                      /* added by pjsantos,  from deferred_extract2.*/
                      --     AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                      --          OR (       v_exclude_mn = 'N'
                      --                 AND v_mn_24th_comp = '1'
                      --                 AND (       e.line_cd = v_mn
                      --                         AND (   (    v_paramdate = 'A'
                      --                                  AND v_mm_year IN
                      --                                               (v_mm_year_mn1, v_mm_year_mn2)
                      --                                 )
                      --                              OR (    v_paramdate = 'E'
                      --                                  /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                      --                                               -- mildred 01292013 comment to include late booking MN binders
                      --                                                               /* AND (   TO_CHAR (e.eff_date,
                      --                                                                                 'MM-YYYY'
                      --                                                                                ) IN
                      --                                                                           (v_mm_year_mn1_fac,
                      --                                                                            v_mn_year_mn2_fac
                      --                                                                           )
                      --                                                                     OR TRUNC (e.eff_date) >
                      --                                                                           LAST_DAY
                      --                                                                                 (TO_DATE (v_mm_year,
                      --                                                                                           'MM-YYYY'
                      --                                                                                          )
                      --                                                                                 )
                      --                                                                    )*/
                      --                                               -- replace with --
                      --                                                                   --AND v_mm_year IN (v_mm_year_mn1_fac,v_mn_year_mn2_fac)
                      --                                  AND v_mm_year IN
                      --                                               (v_mm_year_mn1, v_mm_year_mn2)
                      --                                 --mikel 02.27.2013
                      --                                 )
                      --                             )
                      --                      OR e.line_cd <> v_mn
                      --                     )
                      --              OR v_mn_24th_comp = '2' AND e.line_cd = e.line_cd
                      --             )
                      --         )
                      /*pjsantos end*/
                      -----fj
                      AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                           OR (    v_exclude_mn = 'N'
                               AND (e.line_cd = v_mn OR e.line_cd <> v_mn))) -- end fj
             GROUP BY NVL (e.cred_branch, e.iss_cd),
                      a.line_cd,
                      a.ri_cd,
                      e.policy_id,
                      e.eff_date,
                      e.expiry_date,
                      e.endt_expiry_date,
                      e.acct_ent_date,
                      a.acc_ent_date,
                      d.acct_ent_date,
                      d.acct_neg_date,
                      /*added by pjsantos, from deferred_extract2*/
                      DECODE (
                         v_paramdate,
                         'A', p_year,
                         'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                             DECODE (
                                 SIGN (
                                      LAST_DAY (
                                         TO_DATE (
                                            p_ext_mm || '-' || p_ext_year,
                                            'MM-YYYY'))
                                    - LAST_DAY (TRUNC (e.eff_date))),
                                 -1, p_ext_year,
                                 TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY')))),
                      DECODE (
                         v_paramdate,
                         'A', p_mm,
                         'E', --TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                             DECODE (
                                 SIGN (
                                      LAST_DAY (
                                         TO_DATE (
                                            p_ext_mm || '-' || p_ext_year,
                                            'MM-YYYY'))
                                    - LAST_DAY (TRUNC (e.eff_date))),
                                 -1, 99,
                                 --albert 01242014; to handle expired policies
                                 DECODE (
                                    SIGN (
                                         (  LAST_DAY (
                                               TO_DATE (
                                                     p_ext_mm
                                                  || '-'
                                                  || p_ext_year,
                                                  'MM-YYYY'))
                                          - LAST_DAY (
                                               TRUNC (
                                                  NVL (e.endt_expiry_date,
                                                       e.expiry_date))))
                                       + 1),
                                    1, 99,
                                    --end albert 01242014
                                    TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))))),
                      d.policy_id,
                      d.takeup_seq_no,
                      NVL (f.menu_line_cd, f.line_cd))      --mikel 02.09.2016
      /*pjsantos end*/
      LOOP
         v_pol_term :=
            (facul_ri_comm.expiry_date + 1) - facul_ri_comm.eff_date;
         v_earned_days :=
              (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1)
            - facul_ri_comm.eff_date;

         IF facul_ri_comm.eff_date >
               LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY'))
         THEN
            v_earned_days := 0;
         END IF;

         IF v_earned_days > v_pol_term
         THEN
            v_earned_days := v_pol_term;
         END IF;

         v_unearned_days := v_pol_term - (v_earned_days);
         /*IF v_def_comm_prod = 'Y' THEN
            v_num_factor   := v_earned_days;
         ELSE
            v_num_factor   := v_unearned_days;
         END IF;*/
         v_num_factor := facul_ri_comm.numerator;
         v_den_factor := facul_ri_comm.denominator;

         UPDATE giac_deferred_comm_income_pol gfaccomm_pol
            SET gfaccomm_pol.comm_income =
                   gfaccomm_pol.comm_income + facul_ri_comm.commission,
                gfaccomm_pol.denominator_factor = v_den_factor,
                gfaccomm_pol.numerator_factor = v_num_factor
          WHERE     gfaccomm_pol.extract_year = p_ext_year
                AND gfaccomm_pol.extract_mm = p_ext_mm
                AND gfaccomm_pol.iss_cd = facul_ri_comm.iss_cd
                AND gfaccomm_pol.line_cd = facul_ri_comm.line_cd
                AND gfaccomm_pol.procedure_id = p_method
                AND gfaccomm_pol.policy_no = facul_ri_comm.policy_no
                AND gfaccomm_pol.share_type = '3'
                AND gfaccomm_pol.acct_trty_type = 0
                AND gfaccomm_pol.ri_cd = facul_ri_comm.ri_cd
                AND gfaccomm_pol.comp_sw = 'Y';

         IF SQL%NOTFOUND
         THEN
            INSERT INTO giac_deferred_comm_income_pol (extract_year,
                                                       extract_mm,
                                                       procedure_id,
                                                       iss_cd,
                                                       line_cd,
                                                       share_type,
                                                       policy_no,
                                                       ri_cd,
                                                       comm_income,
                                                       eff_date,
                                                       expiry_date,
                                                       numerator_factor,
                                                       denominator_factor,
                                                       def_comm_income,
                                                       user_id,
                                                       last_update,
                                                       comp_sw,
                                                       acct_ent_date,
                                                       acct_neg_date)
                 VALUES (p_ext_year,
                         p_ext_mm,
                         p_method,
                         facul_ri_comm.iss_cd,
                         facul_ri_comm.line_cd,
                         '3',
                         facul_ri_comm.policy_no,
                         facul_ri_comm.ri_cd,
                         facul_ri_comm.commission,
                         facul_ri_comm.eff_date,
                         facul_ri_comm.expiry_date,
                         v_num_factor,
                         v_den_factor,
                         v_def_prem,
                         v_user_id,
                         SYSDATE,
                         'Y',
                         facul_ri_comm.acc_ent_date,
                         facul_ri_comm.acct_neg_date);
         END IF;
      END LOOP;

	  --Deo [08.25.2016]: GENQA 5594
      IF NVL (giacp.v ('EXCLUDE_24TH_COMM_EXP'), 'N') = 'Y'
      THEN
         RETURN;
      END IF;
      --Deo [08.25.2016]: add ends
      
      -- Commission Expense
      -- Direct
      FOR dicomm_exp
         IN (  SELECT iss_cd,
                      line_cd,
                      intm_no,
                      policy_no,
                      /*eff_date,
                      expiry_date,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      invoice_takeupterm.get_eff_date (policy_id,
                                                       takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         eff_date,
                      invoice_takeupterm.get_exp_date (policy_id,
                                                       takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         expiry_date,
                      SUM (comm_expense) comm_expense,
                      /*DECODE (
                         MONTHS_BETWEEN (
                            LAST_DAY (NVL (endt_expiry_date, expiry_date)),
                            LAST_DAY (
                               DECODE (v_paramdate,
                                       'A', acct_ent_date,
                                       'E', eff_date))),
                         0, 1,
                         MONTHS_BETWEEN (
                            LAST_DAY (NVL (endt_expiry_date, expiry_date)),
                            LAST_DAY (
                               DECODE (v_paramdate,
                                       'A', acct_ent_date,
                                       'E', eff_date))))
                    * 2
                       denominator,
                    DECODE (
                       SIGN (
                          MONTHS_BETWEEN (
                             LAST_DAY (NVL (endt_expiry_date, expiry_date)),
                             LAST_DAY (
                                TO_DATE (p_ext_mm || '-' || p_ext_year,
                                         'MM-YYYY')))),
                       -1, 0,
                       DECODE (
                          SIGN (
                             MONTHS_BETWEEN (
                                LAST_DAY (
                                   TO_DATE (p_ext_mm || '-' || p_ext_year,
                                            'MM-YYYY')),
                                LAST_DAY (
                                   DECODE (v_paramdate,
                                           'A', acct_ent_date,
                                           'E', eff_date)))),
                          -1,   DECODE (
                                   MONTHS_BETWEEN (
                                      LAST_DAY (
                                         NVL (endt_expiry_date, expiry_date)),
                                      LAST_DAY (
                                         DECODE (v_paramdate,
                                                 'A', acct_ent_date,
                                                 'E', eff_date))),
                                   0, 1,
                                   MONTHS_BETWEEN (
                                      LAST_DAY (
                                         NVL (endt_expiry_date, expiry_date)),
                                      LAST_DAY (
                                         DECODE (v_paramdate,
                                                 'A', acct_ent_date,
                                                 'E', eff_date))))
                              * 2,
                          DECODE (
                             SIGN (
                                  (  MONTHS_BETWEEN (
                                        LAST_DAY (
                                           NVL (endt_expiry_date,
                                                expiry_date)),
                                        LAST_DAY (
                                           DECODE (v_paramdate,
                                                   'A', acct_ent_date,
                                                   'E', eff_date)))
                                   * 2)
                                - (  (  MONTHS_BETWEEN (
                                           LAST_DAY (
                                              TO_DATE (
                                                    p_ext_mm
                                                 || '-'
                                                 || p_ext_year,
                                                 'MM-YYYY')),
                                           LAST_DAY (
                                              DECODE (v_paramdate,
                                                      'A', acct_ent_date,
                                                      'E', eff_date)))
                                      * 2)
                                   + 1)),
                             -1, 0,
                               (  MONTHS_BETWEEN (
                                     LAST_DAY (
                                        NVL (endt_expiry_date, expiry_date)),
                                     LAST_DAY (
                                        DECODE (v_paramdate,
                                                'A', acct_ent_date,
                                                'E', eff_date)))
                                * 2)
                             - (  (  MONTHS_BETWEEN (
                                        LAST_DAY (
                                           TO_DATE (
                                              p_ext_mm || '-' || p_ext_year,
                                              'MM-YYYY')),
                                        LAST_DAY (
                                           DECODE (v_paramdate,
                                                   'A', acct_ent_date,
                                                   'E', eff_date)))
                                   * 2)
                                + 1))))
                       numerator,*/
                      --mikel 02.29.2016; comment out and replaced by codes below
                      get_numerator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (policy_id,
                                                          takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (policy_id,
                                                          takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         menu_line_cd)
                         numerator,
                      get_denominator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (policy_id,
                                                          takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (policy_id,
                                                          takeup_seq_no,
                                                          v_mm_year_mn2)) --Deo [08.22.2016]: SR-22527
                         denominator,                   --end mikel 02.29.2016
                      acct_ent_date,
                      spoiled_acct_ent_date
                 FROM (SELECT NVL (b.cred_branch, a.iss_cd) iss_cd,
                              b.line_cd,
                              NVL (c.menu_line_cd, c.line_cd) menu_line_cd,
                              a.policy_id,
                              a.takeup_seq_no,              --mikel 02.29.2016
                              d.intrmdry_intm_no intm_no,
                              get_policy_no (b.policy_id) policy_no,
                              TRUNC (b.eff_date) eff_date,
                              TRUNC (NVL (b.endt_expiry_date, b.expiry_date))
                                 expiry_date,
                              ROUND (
                                   d.commission_amt
                                 * DECODE (
                                      TO_CHAR (a.spoiled_acct_ent_date,
                                               'MM-YYYY'),
                                      v_mm_year, -1,
                                      1)
                                 * a.currency_rt,
                                 2)
                                 comm_expense,
                              b.acct_ent_date,
                              b.endt_expiry_date,
                              a.spoiled_acct_ent_date
                         FROM gipi_invoice a,
                              gipi_polbasic b,
                              gipi_comm_invoice d,
                              giis_line c                   --mikel 02.29.2016
                        WHERE     a.iss_cd = d.iss_cd
                              AND a.prem_seq_no = d.prem_seq_no
                              AND a.policy_id = d.policy_id
                              AND a.policy_id = b.policy_id
                              AND b.line_cd = c.line_cd     --mikel 02.29.2016
                              AND (   (    v_exclude_mn = 'Y'
                                       AND NVL (c.menu_line_cd, c.line_cd) <>
                                              'MN')
                                   OR (v_exclude_mn = 'N')) --mikel 02.29.2016
                              AND (   (    /*TRUNC (
                                         NVL (b.endt_expiry_date,
                                              b.expiry_date)) >*/ --mikel 06.09.2016;UCPBGEN SR 22527
                                       invoice_takeupterm.get_exp_date (a.policy_id,
                                                          a.takeup_seq_no,
                                                          v_mm_year_mn2) > --Deo [08.22.2016]: SR-22527
                                              LAST_DAY (
                                                 TO_DATE (
                                                       LPAD (
                                                          TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                    || '-'
                                                    || TO_CHAR (p_ext_year),
                                                    'MM-YYYY'))
                                       AND (   (b.acct_ent_date <
                                                   LAST_DAY (
                                                      TO_DATE (
                                                            LPAD (
                                                               TO_CHAR (
                                                                  p_ext_mm),
                                                               2,
                                                               '0')
                                                         || '-'
                                                         || TO_CHAR (
                                                               p_ext_year),
                                                         'MM-YYYY')))
                                            OR (b.spld_acct_ent_date <
                                                   LAST_DAY (
                                                      TO_DATE (
                                                            LPAD (
                                                               TO_CHAR (
                                                                  p_ext_mm),
                                                               2,
                                                               '0')
                                                         || '-'
                                                         || TO_CHAR (
                                                               p_ext_year),
                                                         'MM-YYYY')))))
                                   OR (   b.acct_ent_date BETWEEN ADD_MONTHS (
                                                                     TO_DATE (
                                                                           LPAD (
                                                                              TO_CHAR (
                                                                                 p_ext_mm),
                                                                              2,
                                                                              '0')
                                                                        || '-'
                                                                        || TO_CHAR (
                                                                              p_ext_year),
                                                                        'MM-YYYY'),
                                                                     -11)
                                                              AND LAST_DAY (
                                                                     TO_DATE (
                                                                           LPAD (
                                                                              TO_CHAR (
                                                                                 p_ext_mm),
                                                                              2,
                                                                              '0')
                                                                        || '-'
                                                                        || TO_CHAR (
                                                                              p_ext_year),
                                                                        'MM-YYYY'))
                                       OR b.spld_acct_ent_date BETWEEN ADD_MONTHS (
                                                                          TO_DATE (
                                                                                LPAD (
                                                                                   TO_CHAR (
                                                                                      p_ext_mm),
                                                                                   2,
                                                                                   '0')
                                                                             || '-'
                                                                             || TO_CHAR (
                                                                                   p_ext_year),
                                                                             'MM-YYYY'),
                                                                          -11)
                                                                   AND LAST_DAY (
                                                                          TO_DATE (
                                                                                LPAD (
                                                                                   TO_CHAR (
                                                                                      p_ext_mm),
                                                                                   2,
                                                                                   '0')
                                                                             || '-'
                                                                             || TO_CHAR (
                                                                                   p_ext_year),
                                                                             'MM-YYYY'))))
                              -----------------------
                              AND (   DECODE (v_start_date,
                                              NULL, SYSDATE,
                                              a.acct_ent_date) >=
                                         DECODE (v_start_date,
                                                 NULL, SYSDATE,
                                                 v_start_date)
                                   OR DECODE (v_start_date,
                                              NULL, SYSDATE,
                                              a.spoiled_acct_ent_date) >=
                                         DECODE (v_start_date,
                                                 NULL, SYSDATE,
                                                 v_start_date))
                              AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                                         v_mm_year
                                   OR TO_CHAR (a.spoiled_acct_ent_date,
                                               'MM-YYYY') = v_mm_year)
                              AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                              AND b.reg_policy_sw = 'Y'
                              AND b.expiry_date IS NOT NULL          --jm test
                              -----fj
                              AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                                   OR (    v_exclude_mn = 'N'
                                       AND (   b.line_cd = v_mn
                                            OR b.line_cd <> v_mn)))   --end fj
                              AND NOT EXISTS
                                         (SELECT 'X'
                                            FROM giac_prev_comm_inv g,
                                                 giac_new_comm_inv h
                                           WHERE     g.fund_cd = h.fund_cd
                                                 AND g.branch_cd = h.branch_cd
                                                 AND g.comm_rec_id =
                                                        h.comm_rec_id
                                                 AND g.intm_no = h.intm_no
                                                 AND TO_CHAR (g.acct_ent_date,
                                                              'MM-YYYY') =
                                                        v_mm_year
                                                 AND h.acct_ent_date >
                                                        LAST_DAY (
                                                           TO_DATE (v_mm_year,
                                                                    'MM-YYYY'))
                                                 AND h.tran_flag = 'P'
                                                 AND h.iss_cd = d.iss_cd
                                                 AND h.prem_seq_no =
                                                        d.prem_seq_no
                                                 AND DECODE (v_start_date,
                                                             NULL, SYSDATE,
                                                             h.acct_ent_date) >=
                                                        DECODE (v_start_date,
                                                                NULL, SYSDATE,
                                                                v_start_date))
                       UNION ALL
                       --SELECT stmnt for comms modified in the succeeding months
                       SELECT NVL (b.cred_branch, a.iss_cd) iss_cd,
                              b.line_cd,
                              NVL (e.menu_line_cd, e.line_cd) menu_line_cd,
                              a.policy_id,
                              a.takeup_seq_no,              --mikel 02.29.2016
                              c.intm_no,
                              get_policy_no (b.policy_id) policy_no,
                              TRUNC (b.eff_date) eff_date,
                              TRUNC (NVL (b.endt_expiry_date, b.expiry_date))
                                 expiry_date,
                              ROUND (
                                   c.commission_amt
                                 * DECODE (
                                      TO_CHAR (a.spoiled_acct_ent_date,
                                               'MM-YYYY'),
                                      v_mm_year, -1,
                                      1)
                                 * a.currency_rt,
                                 2)
                                 comm_expense,
                              b.acct_ent_date,
                              b.endt_expiry_date,
                              a.spoiled_acct_ent_date
                         FROM gipi_invoice a,
                              gipi_polbasic b,
                              giac_prev_comm_inv c,
                              giac_new_comm_inv d,
                              giis_line e                   --mikel 02.29.2016
                        WHERE     a.policy_id = b.policy_id
                              AND a.iss_cd = d.iss_cd
                              AND a.prem_seq_no = d.prem_seq_no
                              AND a.policy_id = d.policy_id
                              AND b.line_cd = e.line_cd     --mikel 02.29.2016
                              AND (   (    v_exclude_mn = 'Y'
                                       AND NVL (e.menu_line_cd, e.line_cd) <>
                                              'MN')
                                   OR (v_exclude_mn = 'N')) --mikel 02.29.2016
                              AND (   (    /*TRUNC (
                                         NVL (b.endt_expiry_date,
                                              b.expiry_date)) >*/ --mikel 06.09.2016;UCPBGEN SR 22527
                                       invoice_takeupterm.get_exp_date (a.policy_id,
                                                          a.takeup_seq_no,
                                                          v_mm_year_mn2) > --Deo [08.22.2016]: SR-22527
                                              LAST_DAY (
                                                 TO_DATE (
                                                       LPAD (
                                                          TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                    || '-'
                                                    || TO_CHAR (p_ext_year),
                                                    'MM-YYYY'))
                                       AND (   (b.acct_ent_date <
                                                   LAST_DAY (
                                                      TO_DATE (
                                                            LPAD (
                                                               TO_CHAR (
                                                                  p_ext_mm),
                                                               2,
                                                               '0')
                                                         || '-'
                                                         || TO_CHAR (
                                                               p_ext_year),
                                                         'MM-YYYY')))
                                            OR (b.spld_acct_ent_date <
                                                   LAST_DAY (
                                                      TO_DATE (
                                                            LPAD (
                                                               TO_CHAR (
                                                                  p_ext_mm),
                                                               2,
                                                               '0')
                                                         || '-'
                                                         || TO_CHAR (
                                                               p_ext_year),
                                                         'MM-YYYY')))))
                                   OR (   b.acct_ent_date BETWEEN ADD_MONTHS (
                                                                     TO_DATE (
                                                                           LPAD (
                                                                              TO_CHAR (
                                                                                 p_ext_mm),
                                                                              2,
                                                                              '0')
                                                                        || '-'
                                                                        || TO_CHAR (
                                                                              p_ext_year),
                                                                        'MM-YYYY'),
                                                                     -11)
                                                              AND LAST_DAY (
                                                                     TO_DATE (
                                                                           LPAD (
                                                                              TO_CHAR (
                                                                                 p_ext_mm),
                                                                              2,
                                                                              '0')
                                                                        || '-'
                                                                        || TO_CHAR (
                                                                              p_ext_year),
                                                                        'MM-YYYY'))
                                       OR b.spld_acct_ent_date BETWEEN ADD_MONTHS (
                                                                          TO_DATE (
                                                                                LPAD (
                                                                                   TO_CHAR (
                                                                                      p_ext_mm),
                                                                                   2,
                                                                                   '0')
                                                                             || '-'
                                                                             || TO_CHAR (
                                                                                   p_ext_year),
                                                                             'MM-YYYY'),
                                                                          -11)
                                                                   AND LAST_DAY (
                                                                          TO_DATE (
                                                                                LPAD (
                                                                                   TO_CHAR (
                                                                                      p_ext_mm),
                                                                                   2,
                                                                                   '0')
                                                                             || '-'
                                                                             || TO_CHAR (
                                                                                   p_ext_year),
                                                                             'MM-YYYY'))))
                              ---------------------------------
                              AND (   DECODE (v_start_date,
                                              NULL, SYSDATE,
                                              a.acct_ent_date) >=
                                         DECODE (v_start_date,
                                                 NULL, SYSDATE,
                                                 v_start_date)
                                   OR DECODE (v_start_date,
                                              NULL, SYSDATE,
                                              a.spoiled_acct_ent_date) >=
                                         DECODE (v_start_date,
                                                 NULL, SYSDATE,
                                                 v_start_date))
                              AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                                         v_mm_year
                                   OR TO_CHAR (a.spoiled_acct_ent_date,
                                               'MM-YYYY') = v_mm_year)
                              AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                              AND b.reg_policy_sw = 'Y'
                              AND b.expiry_date IS NOT NULL          --jm test
                              -----fj
                              AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                                   OR (    v_exclude_mn = 'N'
                                       AND (   b.line_cd = v_mn
                                            OR b.line_cd <> v_mn)))   --end fj
                              AND c.fund_cd = d.fund_cd
                              AND c.branch_cd = d.branch_cd
                              AND c.comm_rec_id = d.comm_rec_id
                              AND c.intm_no = d.intm_no
                              AND TO_CHAR (c.acct_ent_date, 'MM-YYYY') =
                                     v_mm_year
                              AND d.acct_ent_date >
                                     LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
                              AND d.tran_flag = 'P'
                              AND c.comm_rec_id =
                                     (SELECT MIN (g.comm_rec_id)
                                        FROM giac_prev_comm_inv g,
                                             giac_new_comm_inv h
                                       WHERE     g.fund_cd = h.fund_cd
                                             AND g.branch_cd = h.branch_cd
                                             AND g.comm_rec_id = h.comm_rec_id
                                             AND g.intm_no = h.intm_no
                                             AND TO_CHAR (g.acct_ent_date,
                                                          'MM-YYYY') =
                                                    v_mm_year
                                             AND h.acct_ent_date >
                                                    LAST_DAY (
                                                       TO_DATE (v_mm_year,
                                                                'MM-YYYY'))
                                             AND h.tran_flag = 'P'
                                             AND h.iss_cd = d.iss_cd
                                             AND h.prem_seq_no = d.prem_seq_no)
                       UNION ALL
                       --SELECT stmnt for comms modified within selected month
                       SELECT NVL (b.cred_branch, a.iss_cd) iss_cd,
                              b.line_cd,
                              NVL (c.menu_line_cd, c.line_cd) menu_line_cd,
                              a.policy_id,
                              a.takeup_seq_no,              --mikel 02.29.2016
                              d.intm_no,
                              get_policy_no (b.policy_id) policy_no,
                              TRUNC (b.eff_date) eff_date,
                              TRUNC (NVL (b.endt_expiry_date, b.expiry_date))
                                 expiry_date,
                              ROUND ( (d.commission_amt * a.currency_rt), 2)
                                 comm_expense,
                              b.acct_ent_date,
                              b.endt_expiry_date,
                              a.spoiled_acct_ent_date
                         FROM gipi_invoice a,
                              gipi_polbasic b,
                              giac_new_comm_inv d,
                              giis_line c                   --mikel 02.29.2016
                        WHERE     a.policy_id = b.policy_id
                              AND a.iss_cd = d.iss_cd
                              AND a.prem_seq_no = d.prem_seq_no
                              AND a.policy_id = d.policy_id
                              AND b.line_cd = c.line_cd     --mikel 02.29.2016
                              AND (   (    v_exclude_mn = 'Y'
                                       AND NVL (c.menu_line_cd, c.line_cd) <>
                                              'MN')
                                   OR (v_exclude_mn = 'N')) --mikel 02.29.2016
                              AND (   (    /*TRUNC (
                                         NVL (b.endt_expiry_date,
                                              b.expiry_date)) >*/ --mikel 06.09.2016;UCPBGEN SR 22527
                                       invoice_takeupterm.get_exp_date (a.policy_id,
                                                          a.takeup_seq_no,
                                                          v_mm_year_mn2) > --Deo [08.22.2016]: SR-22527
                                              LAST_DAY (
                                                 TO_DATE (
                                                       LPAD (
                                                          TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                    || '-'
                                                    || TO_CHAR (p_ext_year),
                                                    'MM-YYYY'))
                                       AND ( (d.acct_ent_date <
                                                 LAST_DAY (
                                                    TO_DATE (
                                                          LPAD (
                                                             TO_CHAR (p_ext_mm),
                                                             2,
                                                             '0')
                                                       || '-'
                                                       || TO_CHAR (p_ext_year),
                                                       'MM-YYYY')))))
                                   OR (d.acct_ent_date BETWEEN ADD_MONTHS (
                                                                  TO_DATE (
                                                                        LPAD (
                                                                           TO_CHAR (
                                                                              p_ext_mm),
                                                                           2,
                                                                           '0')
                                                                     || '-'
                                                                     || TO_CHAR (
                                                                           p_ext_year),
                                                                     'MM-YYYY'),
                                                                  -11)
                                                           AND LAST_DAY (
                                                                  TO_DATE (
                                                                        LPAD (
                                                                           TO_CHAR (
                                                                              p_ext_mm),
                                                                           2,
                                                                           '0')
                                                                     || '-'
                                                                     || TO_CHAR (
                                                                           p_ext_year),
                                                                     'MM-YYYY'))))
                              -----------------------------------------
                              AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                              AND b.reg_policy_sw = 'Y'
                              AND b.expiry_date IS NOT NULL          --jm test
                              -----fj
                              AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                                   OR (    v_exclude_mn = 'N'
                                       AND (   b.line_cd = v_mn
                                            OR b.line_cd <> v_mn)))   --end fj
                              AND (   DECODE (v_start_date,        -- 7/1/2014
                                              NULL, SYSDATE,
                                              d.acct_ent_date     -- 7/31/2014
                                                             ) >=
                                         DECODE (v_start_date,     -- 7/1/2014
                                                 NULL, SYSDATE,
                                                 v_start_date)
                                   OR DECODE (v_start_date,        -- 7/1/2014
                                              NULL, SYSDATE,
                                              a.acct_ent_date     -- 7/25/2014
                                                             ) >=
                                         DECODE (v_start_date,     -- 7/1/2014
                                                 NULL, SYSDATE,
                                                 v_start_date      -- 7/1/2014
                                                             ))
                              AND TO_CHAR (d.acct_ent_date, 'MM-YYYY') =
                                     v_mm_year
                              AND NVL (d.delete_sw, 'N') = 'N'
                              AND d.tran_flag = 'P'
                       UNION ALL
                       /*include reversals of modified commissions */
                       --SELECT stmnt for reversal of comms modified within selected month
                       SELECT NVL (b.cred_branch, a.iss_cd) iss_cd,
                              b.line_cd,
                              NVL (e.menu_line_cd, e.line_cd) menu_line_cd,
                              a.policy_id,
                              a.takeup_seq_no,              --mikel 02.29.2016
                              c.intm_no,
                              get_policy_no (b.policy_id) policy_no,
                              TRUNC (b.eff_date) eff_date,
                              TRUNC (NVL (b.endt_expiry_date, b.expiry_date))
                                 expiry_date,
                              ROUND (
                                 ( (c.commission_amt * a.currency_rt) * -1),
                                 2)
                                 comm_expense,
                              b.acct_ent_date,
                              b.endt_expiry_date,
                              a.spoiled_acct_ent_date
                         FROM gipi_invoice a,
                              gipi_polbasic b,
                              giac_prev_comm_inv c,
                              --                 giac_new_comm_inv d
                              (SELECT DISTINCT comm_rec_id,
                                               tran_flag,
                                               delete_sw,
                                               acct_ent_date,
                                               iss_cd,
                                               prem_seq_no,
                                               policy_id
                                 FROM giac_new_comm_inv) d,
                              giis_line e                   --mikel 02.29.2016
                        WHERE     a.policy_id = b.policy_id
                              AND a.iss_cd = d.iss_cd
                              AND a.prem_seq_no = d.prem_seq_no
                              AND a.policy_id = d.policy_id
                              AND b.line_cd = e.line_cd     --mikel 02.29.2016
                              AND (   (    v_exclude_mn = 'Y'
                                       AND NVL (e.menu_line_cd, e.line_cd) <>
                                              'MN')
                                   OR (v_exclude_mn = 'N')) --mikel 02.29.2016
                              AND c.comm_rec_id = d.comm_rec_id
                              AND (   (    /*TRUNC (
                                         NVL (b.endt_expiry_date,
                                              b.expiry_date)) >*/ --mikel 06.09.2016;UCPBGEN SR 22527
                                       invoice_takeupterm.get_exp_date (a.policy_id,
                                                          a.takeup_seq_no,
                                                          v_mm_year_mn2) > --Deo [08.22.2016]: SR-22527
                                              LAST_DAY (
                                                 TO_DATE (
                                                       LPAD (
                                                          TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                    || '-'
                                                    || TO_CHAR (p_ext_year),
                                                    'MM-YYYY'))
                                       AND ( (d.acct_ent_date <
                                                 LAST_DAY (
                                                    TO_DATE (
                                                          LPAD (
                                                             TO_CHAR (p_ext_mm),
                                                             2,
                                                             '0')
                                                       || '-'
                                                       || TO_CHAR (p_ext_year),
                                                       'MM-YYYY')))))
                                   OR (d.acct_ent_date BETWEEN ADD_MONTHS (
                                                                  TO_DATE (
                                                                        LPAD (
                                                                           TO_CHAR (
                                                                              p_ext_mm),
                                                                           2,
                                                                           '0')
                                                                     || '-'
                                                                     || TO_CHAR (
                                                                           p_ext_year),
                                                                     'MM-YYYY'),
                                                                  -11)
                                                           AND LAST_DAY (
                                                                  TO_DATE (
                                                                        LPAD (
                                                                           TO_CHAR (
                                                                              p_ext_mm),
                                                                           2,
                                                                           '0')
                                                                     || '-'
                                                                     || TO_CHAR (
                                                                           p_ext_year),
                                                                     'MM-YYYY'))))
                              AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                              AND b.reg_policy_sw = 'Y'
                              AND b.expiry_date IS NOT NULL          --jm test
                              -----fj
                              AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                                   OR (    v_exclude_mn = 'N'
                                       AND (   b.line_cd = v_mn
                                            OR b.line_cd <> v_mn)))   --end fj
                              AND (   DECODE (v_start_date,
                                              NULL, SYSDATE,
                                              d.acct_ent_date) >=
                                         DECODE (v_start_date,
                                                 NULL, SYSDATE,
                                                 v_start_date)
                                   OR DECODE (v_start_date,
                                              NULL, SYSDATE,
                                              a.acct_ent_date) >=
                                         DECODE (v_start_date,
                                                 NULL, SYSDATE,
                                                 v_start_date))
                              AND TO_CHAR (d.acct_ent_date, 'MM-YYYY') =
                                     v_mm_year
                              AND NVL (d.delete_sw, 'N') = 'N'
                              AND d.tran_flag = 'P')
             GROUP BY iss_cd,
                      line_cd,
                      intm_no,
                      policy_no,
                      eff_date,
                      expiry_date,
                      endt_expiry_date,
                      acct_ent_date,
                      spoiled_acct_ent_date,
                      policy_id,
                      takeup_seq_no,
                      menu_line_cd)                         --mikel 02.29.2016
      LOOP
         v_pol_term := (dicomm_exp.expiry_date + 1) - dicomm_exp.eff_date;
         v_earned_days :=
              (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1)
            - dicomm_exp.eff_date;

         IF dicomm_exp.eff_date >
               LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY'))
         THEN
            v_earned_days := 0;
         END IF;

         IF v_earned_days > v_pol_term
         THEN
            v_earned_days := v_pol_term;
         END IF;

         v_unearned_days := v_pol_term - (v_earned_days);
         v_num_factor := dicomm_exp.numerator;
         v_den_factor := dicomm_exp.denominator;

         UPDATE giac_deferred_comm_expense_pol gdicomm_exp
            SET gdicomm_exp.comm_expense =
                   gdicomm_exp.comm_expense + dicomm_exp.comm_expense,
                gdicomm_exp.denominator_factor = v_den_factor,
                gdicomm_exp.numerator_factor = v_num_factor
          WHERE     gdicomm_exp.extract_year = p_ext_year
                AND gdicomm_exp.extract_mm = p_ext_mm
                AND gdicomm_exp.iss_cd = dicomm_exp.iss_cd
                AND gdicomm_exp.line_cd = dicomm_exp.line_cd
                AND gdicomm_exp.intm_ri = dicomm_exp.intm_no
                AND gdicomm_exp.procedure_id = p_method
                AND gdicomm_exp.policy_no = dicomm_exp.policy_no
                AND gdicomm_exp.comp_sw = 'Y';

         IF SQL%NOTFOUND
         THEN
            INSERT
              INTO giac_deferred_comm_expense_pol (extract_year,
                                                   extract_mm,
                                                   iss_cd,
                                                   line_cd,
                                                   procedure_id,
                                                   policy_no,
                                                   eff_date,
                                                   expiry_date,
                                                   numerator_factor,
                                                   denominator_factor,
                                                   comm_expense,
                                                   intm_ri,
                                                   user_id,
                                                   last_update,
                                                   comp_sw,
                                                   acct_ent_date,
                                                   spoiled_acct_ent_date)
            VALUES (p_ext_year,
                    p_ext_mm,
                    dicomm_exp.iss_cd,
                    dicomm_exp.line_cd,
                    p_method,
                    dicomm_exp.policy_no,
                    dicomm_exp.eff_date,
                    dicomm_exp.expiry_date,
                    v_num_factor,
                    v_den_factor,
                    dicomm_exp.comm_expense,
                    dicomm_exp.intm_no,
                    v_user_id,
                    SYSDATE,
                    'Y',
                    dicomm_exp.acct_ent_date,
                    dicomm_exp.spoiled_acct_ent_date);
         END IF;
      END LOOP;

      FOR ri_comm_exp
         IN (  SELECT iss_cd,
                      line_cd,
                      ri_cd,
                      policy_no, --eff_date, expiry_date, --mikel 02.19.2016; comment out and replaced by codes below
                      invoice_takeupterm.get_eff_date (policy_id,
                                                       takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         eff_date,
                      invoice_takeupterm.get_exp_date (policy_id,
                                                       takeup_seq_no,
                                                       v_mm_year_mn2) --Deo [08.22.2016]: SR-22527
                         expiry_date,
                      SUM (comm_expense) comm_expense,
                      /*DECODE
                         (MONTHS_BETWEEN (LAST_DAY (NVL (endt_expiry_date,
                                                         expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', acct_ent_date,
                                                            'E', eff_date
                                                           )
                                                   )
                                         ),
                          0, 1,
                          MONTHS_BETWEEN (LAST_DAY (NVL (endt_expiry_date,
                                                         expiry_date
                                                        )
                                                   ),
                                          LAST_DAY (DECODE (v_paramdate,
                                                            'A', acct_ent_date,
                                                            'E', eff_date
                                                           )
                                                   )
                                         )
                         )
                    * 2 denominator,
                    DECODE
                       (SIGN (MONTHS_BETWEEN (LAST_DAY (NVL (endt_expiry_date,
                                                             expiry_date
                                                            )
                                                       ),
                                              LAST_DAY (TO_DATE (   p_ext_mm
                                                                 || '-'
                                                                 || p_ext_year,
                                                                 'MM-YYYY'
                                                                )
                                                       )
                                             )
                             ),
                        -1, 0,
                        DECODE
                           (SIGN
                               (MONTHS_BETWEEN
                                              (LAST_DAY (TO_DATE (   p_ext_mm
                                                                  || '-'
                                                                  || p_ext_year,
                                                                  'MM-YYYY'
                                                                 )
                                                        ),
                                               LAST_DAY (DECODE (v_paramdate,
                                                                 'A', acct_ent_date,
                                                                 'E', eff_date
                                                                )
                                                        )
                                              )
                               ),
                            -1, DECODE
                                  (MONTHS_BETWEEN
                                             (LAST_DAY (NVL (endt_expiry_date,
                                                             expiry_date
                                                            )
                                                       ),
                                              LAST_DAY (DECODE (v_paramdate,
                                                                'A', acct_ent_date,
                                                                'E', eff_date
                                                               )
                                                       )
                                             ),
                                   0, 1,
                                   MONTHS_BETWEEN
                                             (LAST_DAY (NVL (endt_expiry_date,
                                                             expiry_date
                                                            )
                                                       ),
                                              LAST_DAY (DECODE (v_paramdate,
                                                                'A', acct_ent_date,
                                                                'E', eff_date
                                                               )
                                                       )
                                             )
                                  )
                             * 2,
                            DECODE
                               (SIGN
                                   (  (  MONTHS_BETWEEN
                                             (LAST_DAY (NVL (endt_expiry_date,
                                                             expiry_date
                                                            )
                                                       ),
                                              LAST_DAY (DECODE (v_paramdate,
                                                                'A', acct_ent_date,
                                                                'E', eff_date
                                                               )
                                                       )
                                             )
                                       * 2
                                      )
                                    - (  (  MONTHS_BETWEEN
                                               (LAST_DAY (TO_DATE (   p_ext_mm
                                                                   || '-'
                                                                   || p_ext_year,
                                                                   'MM-YYYY'
                                                                  )
                                                         ),
                                                LAST_DAY
                                                        (DECODE (v_paramdate,
                                                                 'A', acct_ent_date,
                                                                 'E', eff_date
                                                                )
                                                        )
                                               )
                                          * 2
                                         )
                                       + 1
                                      )
                                   ),
                                -1, 0,
                                  (  MONTHS_BETWEEN
                                             (LAST_DAY (NVL (endt_expiry_date,
                                                             expiry_date
                                                            )
                                                       ),
                                              LAST_DAY (DECODE (v_paramdate,
                                                                'A', acct_ent_date,
                                                                'E', eff_date
                                                               )
                                                       )
                                             )
                                   * 2
                                  )
                                - (  (  MONTHS_BETWEEN
                                              (LAST_DAY (TO_DATE (   p_ext_mm
                                                                  || '-'
                                                                  || p_ext_year,
                                                                  'MM-YYYY'
                                                                 )
                                                        ),
                                               LAST_DAY (DECODE (v_paramdate,
                                                                 'A', acct_ent_date,
                                                                 'E', eff_date
                                                                )
                                                        )
                                              )
                                      * 2
                                     )
                                   + 1
                                  )
                               )
                           )
                       ) numerator,*/
                      --mikel 02.19.2016; comment out and replaced by codes below
                      get_numerator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (policy_id,
                                                          takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (policy_id,
                                                          takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         menu_line_cd)
                         numerator,
                      get_denominator_factor_24th (
                         TO_DATE (
                               LPAD (TO_CHAR (p_ext_mm), 2, '0')
                            || '-'
                            || TO_CHAR (p_ext_year),
                            'MM-YYYY'),
                         invoice_takeupterm.get_eff_date (policy_id,
                                                          takeup_seq_no,
                                                          v_mm_year_mn2), --Deo [08.22.2016]: SR-22527
                         invoice_takeupterm.get_exp_date (policy_id,
                                                          takeup_seq_no,
                                                          v_mm_year_mn2)) --Deo [08.22.2016]: SR-22527
                         denominator,                   --end mikel 02.19.2016
                      acct_ent_date,
                      spoiled_acct_ent_date
                 FROM (SELECT NVL (b.cred_branch, a.iss_cd) iss_cd,
                              b.line_cd,
                              --SELECT stmnt for unmodified commissions
                              NVL (d.menu_line_cd, b.line_cd) menu_line_cd, --mikel 02.29.2016
                              c.ri_cd,
                              get_policy_no (b.policy_id) policy_no,
                              TRUNC (b.eff_date) eff_date,
                              TRUNC (NVL (b.endt_expiry_date, b.expiry_date))
                                 expiry_date,
                              ROUND (
                                   a.ri_comm_amt
                                 * DECODE (
                                      TO_CHAR (a.spoiled_acct_ent_date,
                                               'MM-YYYY'),
                                      v_mm_year, -1,
                                      1)
                                 * a.currency_rt,
                                 2)
                                 comm_expense,
                              b.acct_ent_date,
                              b.endt_expiry_date,
                              a.spoiled_acct_ent_date,
                              a.policy_id,
                              a.takeup_seq_no               --mikel 02.24.2016
                         FROM gipi_invoice a,
                              gipi_polbasic b,
                              giri_inpolbas c,
                              giis_line d
                        WHERE     a.policy_id = b.policy_id
                              AND b.policy_id = c.policy_id
                              AND b.line_cd = d.line_cd     --mikel 02.29.2016
                              AND (   (    v_exclude_mn = 'Y'
                                       AND NVL (d.menu_line_cd, d.line_cd) <>
                                              'MN')
                                   OR (v_exclude_mn = 'N')) --mikel 02.29.2016
                              AND ( (v_paramdate = 'E') OR v_paramdate = 'A')
                              AND DECODE (v_start_date,
                                          NULL, SYSDATE,
                                          a.acct_ent_date) >=
                                     DECODE (v_start_date,
                                             NULL, SYSDATE,
                                             v_start_date)
                              AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                                         v_mm_year
                                   OR TO_CHAR (a.spoiled_acct_ent_date,
                                               'MM-YYYY') = v_mm_year)
                              AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                              AND b.reg_policy_sw = 'Y'
                              AND b.expiry_date IS NOT NULL          --jm test
                              --------------------------------------------------------------------------
                              AND TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                                     v_mm_year
                              AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                              AND b.reg_policy_sw = 'Y'
                              --             AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                              --                  OR (       v_exclude_mn = 'N'
                              --                         AND v_mn_24th_comp = '1'
                              --                         AND (       b.line_cd = v_mn
                              --                                 AND (   (    v_paramdate = 'A'
                              --                                          AND v_mm_year IN
                              --                                                 (v_mm_year_mn1,
                              --                                                  v_mm_year_mn2)
                              --                                         )
                              --                                      OR (    v_paramdate = 'E'
                              --                                          AND v_mm_year IN
                              --                                                 (v_mm_year_mn1,
                              --                                                  v_mm_year_mn2)
                              --                                         )
                              --                                     )
                              --                              OR b.line_cd <> v_mn
                              --                             )
                              --                      OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                              --                     )
                              --                 )
                              ---------------------------------------------------------------------------------
                              AND (   (    TRUNC (
                                              NVL (b.endt_expiry_date,
                                                   b.expiry_date)) >
                                              LAST_DAY (
                                                 TO_DATE (
                                                       LPAD (
                                                          TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                    || '-'
                                                    || TO_CHAR (p_ext_year),
                                                    'MM-YYYY'))
                                       AND (   (b.acct_ent_date <
                                                   LAST_DAY (
                                                      TO_DATE (
                                                            LPAD (
                                                               TO_CHAR (
                                                                  p_ext_mm),
                                                               2,
                                                               '0')
                                                         || '-'
                                                         || TO_CHAR (
                                                               p_ext_year),
                                                         'MM-YYYY')))
                                            OR (b.spld_acct_ent_date <
                                                   LAST_DAY (
                                                      TO_DATE (
                                                            LPAD (
                                                               TO_CHAR (
                                                                  p_ext_mm),
                                                               2,
                                                               '0')
                                                         || '-'
                                                         || TO_CHAR (
                                                               p_ext_year),
                                                         'MM-YYYY')))))
                                   OR (   b.acct_ent_date BETWEEN ADD_MONTHS (
                                                                     TO_DATE (
                                                                           LPAD (
                                                                              TO_CHAR (
                                                                                 p_ext_mm),
                                                                              2,
                                                                              '0')
                                                                        || '-'
                                                                        || TO_CHAR (
                                                                              p_ext_year),
                                                                        'MM-YYYY'),
                                                                     -11)
                                                              AND LAST_DAY (
                                                                     TO_DATE (
                                                                           LPAD (
                                                                              TO_CHAR (
                                                                                 p_ext_mm),
                                                                              2,
                                                                              '0')
                                                                        || '-'
                                                                        || TO_CHAR (
                                                                              p_ext_year),
                                                                        'MM-YYYY'))
                                       OR b.spld_acct_ent_date BETWEEN ADD_MONTHS (
                                                                          TO_DATE (
                                                                                LPAD (
                                                                                   TO_CHAR (
                                                                                      p_ext_mm),
                                                                                   2,
                                                                                   '0')
                                                                             || '-'
                                                                             || TO_CHAR (
                                                                                   p_ext_year),
                                                                             'MM-YYYY'),
                                                                          -11)
                                                                   AND LAST_DAY (
                                                                          TO_DATE (
                                                                                LPAD (
                                                                                   TO_CHAR (
                                                                                      p_ext_mm),
                                                                                   2,
                                                                                   '0')
                                                                             || '-'
                                                                             || TO_CHAR (
                                                                                   p_ext_year),
                                                                             'MM-YYYY'))))
                              AND NOT EXISTS
                                         (SELECT 'X'
                                            FROM giac_ri_comm_hist c
                                           WHERE     c.policy_id = b.policy_id
                                                 AND TO_CHAR (c.acct_ent_date,
                                                              'MM-YYYY') =
                                                        v_mm_year
                                                 AND LAST_DAY (
                                                        TRUNC (c.post_date)) >
                                                        LAST_DAY (
                                                           TO_DATE (v_mm_year,
                                                                    'MM-YYYY')))
                       UNION ALL
                       SELECT NVL (b.cred_branch, a.iss_cd) iss_cd,
                              b.line_cd,
                              NVL (e.menu_line_cd, b.line_cd) menu_line_cd, --mikel 02.29.2016
                              d.ri_cd,
                              get_policy_no (b.policy_id) policy_no,
                              TRUNC (b.eff_date) eff_date,
                              TRUNC (NVL (b.endt_expiry_date, b.expiry_date))
                                 expiry_date,
                              ROUND (
                                   c.old_ri_comm_amt
                                 * DECODE (
                                      TO_CHAR (a.spoiled_acct_ent_date,
                                               'MM-YYYY'),
                                      v_mm_year, -1,
                                      1)
                                 * a.currency_rt,
                                 2)
                                 comm_expense,
                              b.acct_ent_date,
                              b.endt_expiry_date,
                              a.spoiled_acct_ent_date,
                              a.policy_id,
                              a.takeup_seq_no               --mikel 02.24.2016
                         FROM gipi_invoice a,
                              giac_ri_comm_hist c,
                              gipi_polbasic b,
                              giri_inpolbas d,
                              giis_line e                   --mikel 02.29.2016
                        WHERE     a.policy_id = b.policy_id
                              AND b.policy_id = c.policy_id
                              AND b.policy_id = d.policy_id
                              AND b.line_cd = e.line_cd     --mikel 02.29.2016
                              AND (   (    v_exclude_mn = 'Y'
                                       AND NVL (e.menu_line_cd, e.line_cd) <>
                                              'MN')
                                   OR (v_exclude_mn = 'N')) --mikel 02.29.2016
                              AND DECODE (v_start_date,
                                          NULL, SYSDATE,
                                          c.acct_ent_date) >=
                                     DECODE (v_start_date,
                                             NULL, SYSDATE,
                                             v_start_date)
                              AND TO_CHAR (c.acct_ent_date, 'MM-YYYY') =
                                     v_mm_year
                              AND LAST_DAY (TRUNC (c.post_date)) >
                                     LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
                              AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                                         v_mm_year
                                   OR TO_CHAR (a.spoiled_acct_ent_date,
                                               'MM-YYYY') = v_mm_year)
                              AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                              AND b.reg_policy_sw = 'Y'
                              AND ( (v_paramdate = 'E') OR v_paramdate = 'A')
                              AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                                         v_mm_year
                                   OR TO_CHAR (a.spoiled_acct_ent_date,
                                               'MM-YYYY') = v_mm_year)
                              AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                              AND b.reg_policy_sw = 'Y'
                              --             AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                              --                  OR (       v_exclude_mn = 'N'
                              --                         AND v_mn_24th_comp = '1'
                              --                         AND (       b.line_cd = v_mn
                              --                                 AND (   (    v_paramdate = 'A'
                              --                                          AND v_mm_year IN
                              --                                                 (v_mm_year_mn1,
                              --                                                  v_mm_year_mn2)
                              --                                         )
                              --                                      OR (    v_paramdate = 'E'
                              --                                          AND v_mm_year IN
                              --                                                 (v_mm_year_mn1,
                              --                                                  v_mm_year_mn2)
                              --                                         )
                              --                                     )
                              --                              OR b.line_cd <> v_mn
                              --                             )
                              --                      OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                              --                     )
                              --                 )
                              AND (   (    TRUNC (
                                              NVL (b.endt_expiry_date,
                                                   b.expiry_date)) >
                                              LAST_DAY (
                                                 TO_DATE (
                                                       LPAD (
                                                          TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                    || '-'
                                                    || TO_CHAR (p_ext_year),
                                                    'MM-YYYY'))
                                       AND (   (b.acct_ent_date <
                                                   LAST_DAY (
                                                      TO_DATE (
                                                            LPAD (
                                                               TO_CHAR (
                                                                  p_ext_mm),
                                                               2,
                                                               '0')
                                                         || '-'
                                                         || TO_CHAR (
                                                               p_ext_year),
                                                         'MM-YYYY')))
                                            OR (b.spld_acct_ent_date <
                                                   LAST_DAY (
                                                      TO_DATE (
                                                            LPAD (
                                                               TO_CHAR (
                                                                  p_ext_mm),
                                                               2,
                                                               '0')
                                                         || '-'
                                                         || TO_CHAR (
                                                               p_ext_year),
                                                         'MM-YYYY')))))
                                   OR (   b.acct_ent_date BETWEEN ADD_MONTHS (
                                                                     TO_DATE (
                                                                           LPAD (
                                                                              TO_CHAR (
                                                                                 p_ext_mm),
                                                                              2,
                                                                              '0')
                                                                        || '-'
                                                                        || TO_CHAR (
                                                                              p_ext_year),
                                                                        'MM-YYYY'),
                                                                     -11)
                                                              AND LAST_DAY (
                                                                     TO_DATE (
                                                                           LPAD (
                                                                              TO_CHAR (
                                                                                 p_ext_mm),
                                                                              2,
                                                                              '0')
                                                                        || '-'
                                                                        || TO_CHAR (
                                                                              p_ext_year),
                                                                        'MM-YYYY'))
                                       OR b.spld_acct_ent_date BETWEEN ADD_MONTHS (
                                                                          TO_DATE (
                                                                                LPAD (
                                                                                   TO_CHAR (
                                                                                      p_ext_mm),
                                                                                   2,
                                                                                   '0')
                                                                             || '-'
                                                                             || TO_CHAR (
                                                                                   p_ext_year),
                                                                             'MM-YYYY'),
                                                                          -11)
                                                                   AND LAST_DAY (
                                                                          TO_DATE (
                                                                                LPAD (
                                                                                   TO_CHAR (
                                                                                      p_ext_mm),
                                                                                   2,
                                                                                   '0')
                                                                             || '-'
                                                                             || TO_CHAR (
                                                                                   p_ext_year),
                                                                             'MM-YYYY'))))
                              AND b.expiry_date IS NOT NULL          --jm test
                              AND c.tran_id_rev =
                                     (SELECT MIN (tran_id_rev)
                                        FROM giac_ri_comm_hist d
                                       WHERE     d.policy_id = b.policy_id
                                             AND TO_CHAR (d.acct_ent_date,
                                                          'MM-YYYY') =
                                                    v_mm_year
                                             AND LAST_DAY (TRUNC (d.post_date)) >
                                                    LAST_DAY (
                                                       TO_DATE (v_mm_year,
                                                                'MM-YYYY')))
                       UNION ALL
                       SELECT NVL (b.cred_branch, a.iss_cd) iss_cd,
                              b.line_cd,
                              NVL (e.menu_line_cd, b.line_cd) menu_line_cd, --mikel 02.29.2016
                              d.ri_cd,
                              get_policy_no (b.policy_id) policy_no,
                              TRUNC (b.eff_date) eff_date,
                              TRUNC (NVL (b.endt_expiry_date, b.expiry_date))
                                 expiry_date,
                              ROUND (
                                   c.new_ri_comm_amt
                                 * DECODE (
                                      TO_CHAR (a.spoiled_acct_ent_date,
                                               'MM-YYYY'),
                                      v_mm_year, -1,
                                      1)
                                 * a.currency_rt,
                                 2)
                                 comm_expense,
                              b.acct_ent_date,
                              b.endt_expiry_date,
                              a.spoiled_acct_ent_date,
                              a.policy_id,
                              a.takeup_seq_no               --mikel 02.24.2016
                         FROM gipi_invoice a,
                              giac_ri_comm_hist c,
                              gipi_polbasic b,
                              giri_inpolbas d,
                              giis_line e                   --mikel 02.29.2016
                        WHERE     a.policy_id = b.policy_id
                              AND b.policy_id = c.policy_id
                              AND b.policy_id = d.policy_id
                              AND b.line_cd = e.line_cd     --mikel 02.29.2016
                              AND (   (    v_exclude_mn = 'Y'
                                       AND NVL (e.menu_line_cd, e.line_cd) <>
                                              'MN')
                                   OR (v_exclude_mn = 'N')) --mikel 02.29.2016
                              AND DECODE (v_start_date,
                                          NULL, SYSDATE,
                                          b.acct_ent_date) >=
                                     DECODE (v_start_date,
                                             NULL, SYSDATE,
                                             v_start_date)
                              AND TO_CHAR (c.post_date, 'MM-YYYY') = v_mm_year
                              AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                              AND b.reg_policy_sw = 'Y'
                              AND b.expiry_date IS NOT NULL          --jm test
                              AND ( (v_paramdate = 'E') OR v_paramdate = 'A')
                              AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                              AND b.reg_policy_sw = 'Y'
                              --             AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                              --                  OR (       v_exclude_mn = 'N'
                              --                         AND v_mn_24th_comp = '1'
                              --                         AND (       b.line_cd = v_mn
                              --                                 AND (   (    v_paramdate = 'A'
                              --                                          AND v_mm_year IN
                              --                                                 (v_mm_year_mn1,
                              --                                                  v_mm_year_mn2)
                              --                                         )
                              --                                      OR (    v_paramdate = 'E'
                              --                                          AND v_mm_year IN
                              --                                                 (v_mm_year_mn1,
                              --                                                  v_mm_year_mn2)
                              --                                         )
                              --                                     )
                              --                              OR b.line_cd <> v_mn
                              --                             )
                              --                      OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                              --                     )
                              --                 )
                              AND (   (    TRUNC (
                                              NVL (b.endt_expiry_date,
                                                   b.expiry_date)) >
                                              LAST_DAY (
                                                 TO_DATE (
                                                       LPAD (
                                                          TO_CHAR (p_ext_mm),
                                                          2,
                                                          '0')
                                                    || '-'
                                                    || TO_CHAR (p_ext_year),
                                                    'MM-YYYY'))
                                       AND (   (b.acct_ent_date <
                                                   LAST_DAY (
                                                      TO_DATE (
                                                            LPAD (
                                                               TO_CHAR (
                                                                  p_ext_mm),
                                                               2,
                                                               '0')
                                                         || '-'
                                                         || TO_CHAR (
                                                               p_ext_year),
                                                         'MM-YYYY')))
                                            OR (b.spld_acct_ent_date <
                                                   LAST_DAY (
                                                      TO_DATE (
                                                            LPAD (
                                                               TO_CHAR (
                                                                  p_ext_mm),
                                                               2,
                                                               '0')
                                                         || '-'
                                                         || TO_CHAR (
                                                               p_ext_year),
                                                         'MM-YYYY')))))
                                   OR b.acct_ent_date BETWEEN ADD_MONTHS (
                                                                 TO_DATE (
                                                                       LPAD (
                                                                          TO_CHAR (
                                                                             p_ext_mm),
                                                                          2,
                                                                          '0')
                                                                    || '-'
                                                                    || TO_CHAR (
                                                                          p_ext_year),
                                                                    'MM-YYYY'),
                                                                 -11)
                                                          AND LAST_DAY (
                                                                 TO_DATE (
                                                                       LPAD (
                                                                          TO_CHAR (
                                                                             p_ext_mm),
                                                                          2,
                                                                          '0')
                                                                    || '-'
                                                                    || TO_CHAR (
                                                                          p_ext_year),
                                                                    'MM-YYYY')))
                              AND c.tran_id =
                                     (SELECT MAX (tran_id)
                                        FROM giac_ri_comm_hist d
                                       WHERE     d.policy_id = b.policy_id
                                             AND TO_CHAR (d.post_date,
                                                          'MM-YYYY') =
                                                    v_mm_year))
             GROUP BY iss_cd,
                      line_cd,
                      ri_cd,
                      policy_no,
                      eff_date,
                      expiry_date,
                      endt_expiry_date,
                      acct_ent_date,
                      spoiled_acct_ent_date,
                      policy_id,
                      takeup_seq_no,
                      line_cd,
                      menu_line_cd)                         --mikel 02.24.2016
      LOOP
         v_pol_term := (ri_comm_exp.expiry_date + 1) - ri_comm_exp.eff_date;
         v_earned_days :=
              (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1)
            - ri_comm_exp.eff_date;

         IF ri_comm_exp.eff_date >
               LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY'))
         THEN
            v_earned_days := 0;
         END IF;

         IF v_earned_days > v_pol_term
         THEN
            v_earned_days := v_pol_term;
         END IF;

         v_unearned_days := v_pol_term - (v_earned_days);
         /*IF v_def_comm_prod = 'Y' THEN
            v_num_factor   := v_earned_days;
         ELSE
            v_num_factor   := v_unearned_days;
         END IF;*/
         v_num_factor := ri_comm_exp.numerator;
         v_den_factor := ri_comm_exp.denominator;

         UPDATE giac_deferred_comm_expense_pol gricomm_exp
            SET gricomm_exp.comm_expense =
                   gricomm_exp.comm_expense + ri_comm_exp.comm_expense,
                gricomm_exp.numerator_factor = v_num_factor,
                gricomm_exp.denominator_factor = v_den_factor
          WHERE     gricomm_exp.extract_year = p_ext_year
                AND gricomm_exp.extract_mm = p_ext_mm
                AND gricomm_exp.iss_cd = ri_comm_exp.iss_cd
                AND gricomm_exp.line_cd = ri_comm_exp.line_cd
                AND gricomm_exp.intm_ri = ri_comm_exp.ri_cd
                AND gricomm_exp.procedure_id = p_method
                AND gricomm_exp.policy_no = ri_comm_exp.policy_no
                AND gricomm_exp.comp_sw = 'Y';

         IF SQL%NOTFOUND
         THEN
            INSERT
              INTO giac_deferred_comm_expense_pol (extract_year,
                                                   extract_mm,
                                                   iss_cd,
                                                   line_cd,
                                                   procedure_id,
                                                   policy_no,
                                                   eff_date,
                                                   expiry_date,
                                                   numerator_factor,
                                                   denominator_factor,
                                                   comm_expense,
                                                   intm_ri,
                                                   user_id,
                                                   last_update,
                                                   comp_sw,
                                                   acct_ent_date,
                                                   spoiled_acct_ent_date)
            VALUES (p_ext_year,
                    p_ext_mm,
                    ri_comm_exp.iss_cd,
                    ri_comm_exp.line_cd,
                    p_method,
                    ri_comm_exp.policy_no,
                    ri_comm_exp.eff_date,
                    ri_comm_exp.expiry_date,
                    v_num_factor,
                    v_den_factor,
                    ri_comm_exp.comm_expense,
                    ri_comm_exp.ri_cd,
                    v_user_id,
                    SYSDATE,
                    'Y',
                    ri_comm_exp.acct_ent_date,
                    ri_comm_exp.spoiled_acct_ent_date);
         END IF;
      END LOOP;
   ----------------------------------------------------------------------------------------------------------------------------------
   END IF;
END deferred_extract3_dtl;
/
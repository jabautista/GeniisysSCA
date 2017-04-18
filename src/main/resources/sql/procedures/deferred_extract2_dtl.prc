DROP PROCEDURE CPI.DEFERRED_EXTRACT2_DTL;

CREATE OR REPLACE PROCEDURE CPI.deferred_extract2_dtl (
   p_ext_year   NUMBER,
   p_ext_mm     NUMBER,
   p_year       NUMBER,
   p_mm         NUMBER,
   p_method     NUMBER
)
IS
   v_iss_cd_ri         gipi_polbasic.iss_cd%TYPE;
   --holds param value of the parameter 'ISS_CD_RI' in giis_parameters
   v_iss_cd_rv         gipi_polbasic.iss_cd%TYPE;
   --holds param value of the parameter 'ISS_CD_RV' in giis_parameters
   v_paramdate         VARCHAR2 (1)                         := 'A';
   v_mm_year           VARCHAR2 (7);
   v_mm_year_mn1       VARCHAR2 (7);
   v_mm_year_mn2       VARCHAR2 (7);
   v_mm_year_mn1_fac   VARCHAR2 (10);
   v_mn_year_mn2_fac   VARCHAR2 (10);
   v_exclude_mn        VARCHAR2 (1)
                                := NVL (giacp.v ('EXCLUDE_MARINE_24TH'), 'N');
   v_mn                giis_parameters.param_value_v%TYPE; --totel--2/11/2008
   v_mn_24th_comp      VARCHAR2 (1);
   v_start_date        DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   v_next_round        NUMBER                               := 1;
   --mikel 12.11.2012
   v_exists            VARCHAR2 (1);                      -- mikel 12.11.2012
/*
** Created by:   Vincent
** Date Created: 062305
** Description:  Extracts detailed data required for the monthly computation of 24th Method
*/

/*
** Modified by:   Vincent
** Date Modified: 100705
** Description:   Modified SELECT statements to handle extraction for effectivity date
*/

/*
** Modified by: judyann
** Date Modified: 03012007
** Description: Removed hard-coding of line; Used parameters
*/

/*
** Modified by: totel
** Date Modified: 2/11/2008
** Description: tune procedure for GIACS044 (24th Method)
**              Put the value of Giisp.v('LINE_CODE_MN') in a variable v_mn
**              then replace all Giisp.v('LINE_CODE_MN') conditions in where clause with v_mn
**              Added NVL
*/

/*
** Modified by: judyann
** Date Modified: 04182008
** Description: Modified conditions to handle take-up of long-term policies
*/

/* Modified by:    Alfie
** Date Modified:  06082010
** Description:    Handles the additional factors for monthly computation of 24th Method, additional factors spans up to 13 months
*/

/* Modified by: judyann
** Date Modified: 08032010
** Description: Added checking of parameter MARINE_COMPUTATION_24TH for appropriate extraction of records for Marine Cargo
*/
BEGIN
   --added by totel--2/11/2008--@fpac--for tuning purpose
   SELECT giisp.v ('LINE_CODE_MN')
     INTO v_mn
     FROM DUAL;

   --end--totel--2/11/2008
   v_iss_cd_ri := giisp.v ('ISS_CD_RI');
   v_iss_cd_rv := giisp.v ('ISS_CD_RV');
   v_paramdate := giacp.v ('24TH_METHOD_PARAMDATE');
   v_mm_year := LPAD (TO_CHAR (p_mm), 2, '0') || '-' || TO_CHAR (p_year);
   v_mm_year_mn1 :=
         TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_ext_mm), 2, '0')
                             || '-'
                             || TO_CHAR (p_ext_year),
                             'MM-YYYY'
                            )
                  - 1,
                  'MM'
                 )
      || '-'
      || TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_ext_mm), 2, '0')
                             || '-'
                             || TO_CHAR (p_ext_year),
                             'MM-YYYY'
                            )
                  - 1,
                  'YYYY'
                 );
   v_mm_year_mn2 :=
               LPAD (TO_CHAR (p_ext_mm), 2, '0') || '-'
               || TO_CHAR (p_ext_year);
   v_mm_year_mn1_fac :=
         TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_mm), 2, '0')
                             || '-'
                             || TO_CHAR (p_year),
                             'MM-YYYY'
                            )
                  - 1,
                  'MM'
                 )
      || '-'
      || TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_mm), 2, '0')
                             || '-'
                             || TO_CHAR (p_year),
                             'MM-YYYY'
                            )
                  - 1,
                  'YYYY'
                 );
   v_mn_year_mn2_fac :=
                       LPAD (TO_CHAR (p_mm), 2, '0') || '-'
                       || TO_CHAR (p_year);
   v_mn_24th_comp := giacp.v ('MARINE_COMPUTATION_24TH');

   IF    (p_mm != p_ext_mm AND p_ext_year != p_year
         )  --do not allow JANUARY 2008 if JANUARY 2009 is the extraction date
      OR (p_mm <= p_ext_mm AND p_ext_year = p_year)
   THEN                                               --added condition :alfie
      --GROSS PREMIUMS
      DELETE FROM gross_prem
            WHERE extract_year = p_ext_year
              AND extract_mm = p_ext_mm
              AND procedure_id = p_method;

      FOR loop_twice IN 1 .. 2                              --mikel 12.11.2012
      LOOP
         FOR gross IN
            (SELECT   NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd,
                      SUM (  DECODE (TO_CHAR (b.spld_acct_ent_date, 'MM-YYYY'),
                                     v_mm_year, -1,
                                     1
                                    )
                           * ROUND (a.prem_amt * a.currency_rt, 2)
                          ) premium,
                      DECODE
                         (v_paramdate,
                          'A', p_year,
                          'E',
                          --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                          DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                             || '-'
                                                             || p_ext_year,
                                                             'MM-YYYY'
                                                            )
                                                   )
                                        - LAST_DAY (TRUNC (b.eff_date))
                                       ),
                                  -1, p_ext_year,
                                  TO_NUMBER (TO_CHAR (b.eff_date, 'YYYY'))
                                 )
                         ) grp_year,
                      DECODE
                         (v_paramdate,
                          'A', p_mm,
                          'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                          DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                             || '-'
                                                             || p_ext_year,
                                                             'MM-YYYY'
                                                            )
                                                   )
                                        - LAST_DAY (TRUNC (b.eff_date))
                                       ),
                                  -1, 99,
                                  TO_NUMBER (TO_CHAR (b.eff_date, 'MM'))
                                 )
                         ) grp_mm,
                      b.policy_id                          --mikel 12.11.2012
                 FROM gipi_invoice a, gipi_polbasic b
                WHERE a.policy_id = b.policy_id
                  /*AND DECODE (v_start_date, NULL, SYSDATE, b.acct_ent_date) >=
                               DECODE (v_start_date,
                                       NULL, SYSDATE,
                                       v_start_date
                                      )*/ --mikel 12.11.2012
                  AND DECODE (v_start_date,
                              NULL, SYSDATE,
                              DECODE (v_next_round,
                                      1, b.acct_ent_date,
                                      b.spld_acct_ent_date
                                     )
                             ) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                  AND ((v_paramdate = 'E'
                                         -- mildred 01292013 comment to include late booking policies
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
                  /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = v_mm_year
                       OR
                       TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = v_mm_year)*/   -- judyann 04182008
                  AND (   (    TO_CHAR (a.acct_ent_date, 'MM-YYYY') =
                                                                     v_mm_year
                           AND v_next_round = 1
                          )             --mikel 07.09.2013; added v_next_round
                       OR (    TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') =
                                                                     v_mm_year
                           AND v_next_round = 2
                          )
                      )
                  AND b.reg_policy_sw = 'Y'
                  AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                       OR (       v_exclude_mn = 'N'
                              AND v_mn_24th_comp = '1'
                              AND (       b.line_cd = v_mn
                                      AND (   (    v_paramdate = 'A'
                                               AND v_mm_year IN
                                                      (v_mm_year_mn1,
                                                       v_mm_year_mn2
                                                      )
                                              )
                                           OR (    v_paramdate = 'E'
                                               -- mildred 01292013 comment to include late booking MN policies
                                                  /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                                    /* AND (   TO_CHAR (b.eff_date,
                                                                                      'MM-YYYY'
                                                                                     ) IN
                                                                                (v_mm_year_mn1,
                                                                                 v_mm_year_mn2
                                                                                )
                                                                          OR TRUNC (b.eff_date) >
                                                                                LAST_DAY
                                                                                   (TO_DATE
                                                                                       (   p_ext_mm
                                                                                        || '-'
                                                                                        || p_ext_year,
                                                                                        'MM-YYYY'
                                                                                       )
                                                                                   )
                                                                         )*/
                                               AND v_mm_year IN
                                                      (v_mm_year_mn1,
                                                       v_mm_year_mn2
                                                      )
                                              )
                                          )
                                   OR b.line_cd <> v_mn
                                  )
                           OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                          )
                      )
             GROUP BY NVL (b.cred_branch, a.iss_cd),
                      b.line_cd,
                      DECODE (v_paramdate,
                              'A', p_year,
                              'E', DECODE
                                      (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                                  || '-'
                                                                  || p_ext_year,
                                                                  'MM-YYYY'
                                                                 )
                                                        )
                                             - LAST_DAY (TRUNC (b.eff_date))
                                            ),
                                       -1, p_ext_year,
                                       TO_NUMBER (TO_CHAR (b.eff_date, 'YYYY'))
                                      )
                             ),
                      DECODE (v_paramdate,
                              'A', p_mm,
                              'E', DECODE
                                      (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                                  || '-'
                                                                  || p_ext_year,
                                                                  'MM-YYYY'
                                                                 )
                                                        )
                                             - LAST_DAY (TRUNC (b.eff_date))
                                            ),
                                       -1, 99,
                                       TO_NUMBER (TO_CHAR (b.eff_date, 'MM'))
                                      )
                             ),
                      b.policy_id                           --mikel 12.11.2012
                                 )
         LOOP
            --mikel 12.11.2012
            BEGIN
               SELECT 'X'
                 INTO v_exists
                 FROM gross_prem
                WHERE extract_year = p_ext_year
                  AND extract_mm = p_ext_mm
                  AND YEAR = gross.grp_year
                  AND mm = gross.grp_mm
                  AND iss_cd = gross.iss_cd
                  AND line_cd = gross.line_cd
                  AND procedure_id = p_method
                  AND policy_id = gross.policy_id
                  AND prem_amt = gross.premium;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  INSERT INTO gross_prem
                              (extract_year, extract_mm, YEAR,
                               mm, iss_cd, line_cd,
                               procedure_id, policy_id, prem_amt
                              )
                       VALUES (p_ext_year, p_ext_mm, gross.grp_year,
                               gross.grp_mm, gross.iss_cd, gross.line_cd,
                               p_method, gross.policy_id, gross.premium
                              );
            END;

            IF v_exists IS NULL
            THEN                                            --mikel 12.11.2012
               UPDATE giac_deferred_gross_prem_dtl gprem_dtl
                  SET gprem_dtl.prem_amt = gprem_dtl.prem_amt + gross.premium
                WHERE gprem_dtl.extract_year = p_ext_year
                  AND gprem_dtl.extract_mm = p_ext_mm
                  AND gprem_dtl.YEAR = gross.grp_year
                  AND gprem_dtl.mm = gross.grp_mm
                  AND gprem_dtl.iss_cd = gross.iss_cd
                  AND gprem_dtl.line_cd = gross.line_cd
                  AND gprem_dtl.procedure_id = p_method;

               IF SQL%NOTFOUND
               THEN
                  INSERT INTO giac_deferred_gross_prem_dtl
                              (extract_year, extract_mm, YEAR,
                               mm, iss_cd, line_cd,
                               procedure_id, prem_amt, user_id, last_update
                              )
                       VALUES (p_ext_year, p_ext_mm, gross.grp_year,
                               gross.grp_mm, gross.iss_cd, gross.line_cd,
                               p_method, gross.premium, USER, SYSDATE
                              );
               END IF;
            END IF;                                         --mikel 12.11.2012
         END LOOP;

         v_next_round := v_next_round + 1;                  --mikel 12.11.2012
      END LOOP;

      --RI PREMIUMS CEDED AND COMMISSION INCOME
      --Treaty
      --Premiums
      FOR ri_prem1 IN
         (SELECT   NVL (b.cred_branch, b.iss_cd) iss_cd, a.line_cd,
                   SUM (NVL (a.premium_amt, 0)) premium,
                   
                   --sum(nvl(a.commission_amt,0)) commission,
                   NVL (c.acct_trty_type, 0) acct_trty_type,
                   DECODE
                      (v_paramdate,
                       'A', p_year,
                       'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (b.eff_date))
                                    ),
                               -1, p_ext_year,
                               TO_NUMBER (TO_CHAR (b.eff_date, 'YYYY'))
                              )
                      ) grp_year,
                   DECODE
                      (v_paramdate,
                       'A', p_mm,
                       'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (b.eff_date))
                                    ),
                               -1, 99,
                               TO_NUMBER (TO_CHAR (b.eff_date, 'MM'))
                              )
                      ) grp_mm
              FROM giac_treaty_cessions a, gipi_polbasic b, giis_dist_share c
             WHERE a.policy_id = b.policy_id
               AND DECODE (v_start_date,
                           NULL, SYSDATE,
                           LAST_DAY (TO_DATE (   a.cession_mm
                                              || '-'
                                              || a.cession_year,
                                              'MM-YYYY'
                                             )
                                    )
                          ) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
               AND a.cession_year = p_year
               AND a.cession_mm = p_mm
               AND a.line_cd = c.line_cd
               AND a.share_cd = c.share_cd
               AND ((v_paramdate = 'E'
                                      -- mildred 01292013 comment to include late booking policies
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
               AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                    OR (       v_exclude_mn = 'N'
                           AND v_mn_24th_comp = '1'
                           AND (       b.line_cd = v_mn
                                   AND (   (    v_paramdate = 'A'
                                            AND v_mm_year IN
                                                   (v_mm_year_mn1,
                                                    v_mm_year_mn2
                                                   )
                                           )
                                        OR (    v_paramdate = 'E'
                                            /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                            -- mildred 01292013 comment to include late booking MN policies
                                                                           /* AND (   TO_CHAR (b.eff_date,
                                                                                             'MM-YYYY'
                                                                                            ) IN
                                                                                       (v_mm_year_mn1,
                                                                                        v_mm_year_mn2
                                                                                       )
                                                                                 OR TRUNC (b.eff_date) >
                                                                                       LAST_DAY
                                                                                          (TO_DATE
                                                                                                 (   p_ext_mm
                                                                                                  || '-'
                                                                                                  || p_ext_year,
                                                                                                  'MM-YYYY'
                                                                                                 )
                                                                                          )
                                                                                )*/
                                                              -- replace with --
                                            AND v_mm_year IN
                                                   (v_mm_year_mn1,
                                                    v_mm_year_mn2
                                                   )
                                           )
                                       )
                                OR b.line_cd <> v_mn
                               )
                        OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                       )
                   )
          GROUP BY NVL (b.cred_branch, b.iss_cd),
                   a.line_cd,
                   c.acct_trty_type,
                   DECODE (v_paramdate,
                           'A', p_year,
                           'E', DECODE
                                      (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                                  || '-'
                                                                  || p_ext_year,
                                                                  'MM-YYYY'
                                                                 )
                                                        )
                                             - LAST_DAY (TRUNC (b.eff_date))
                                            ),
                                       -1, p_ext_year,
                                       TO_NUMBER (TO_CHAR (b.eff_date, 'YYYY'))
                                      )
                          ),
                   DECODE (v_paramdate,
                           'A', p_mm,
                           'E', DECODE
                                      (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                                  || '-'
                                                                  || p_ext_year,
                                                                  'MM-YYYY'
                                                                 )
                                                        )
                                             - LAST_DAY (TRUNC (b.eff_date))
                                            ),
                                       -1, 99,
                                       TO_NUMBER (TO_CHAR (b.eff_date, 'MM'))
                                      )
                          ))
      LOOP
         UPDATE giac_deferred_ri_prem_cede_dtl ri_prem_dtl
            SET ri_prem_dtl.dist_prem =
                                      ri_prem_dtl.dist_prem + ri_prem1.premium
          WHERE ri_prem_dtl.extract_year = p_ext_year
            AND ri_prem_dtl.extract_mm = p_ext_mm
            AND ri_prem_dtl.YEAR = ri_prem1.grp_year
            AND ri_prem_dtl.mm = ri_prem1.grp_mm
            AND ri_prem_dtl.iss_cd = ri_prem1.iss_cd
            AND ri_prem_dtl.line_cd = ri_prem1.line_cd
            AND ri_prem_dtl.procedure_id = p_method
            AND ri_prem_dtl.share_type = '2'
            AND ri_prem_dtl.acct_trty_type = ri_prem1.acct_trty_type;

         IF SQL%NOTFOUND
         THEN
            INSERT INTO giac_deferred_ri_prem_cede_dtl
                        (extract_year, extract_mm, YEAR,
                         mm, iss_cd, line_cd,
                         procedure_id, share_type, acct_trty_type,
                         dist_prem, user_id, last_update
                        )
                 VALUES (p_ext_year, p_ext_mm, ri_prem1.grp_year,
                         ri_prem1.grp_mm, ri_prem1.iss_cd, ri_prem1.line_cd,
                         p_method, '2', ri_prem1.acct_trty_type,
                         ri_prem1.premium, USER, SYSDATE
                        );
         END IF;
      END LOOP;
   END IF;

   --Comm Income
   FOR ri_comm1 IN
      (SELECT   NVL (b.cred_branch, b.iss_cd) iss_cd, a.line_cd,
                SUM (NVL (a.commission_amt, 0)) commission,
                NVL (c.acct_trty_type, 0) acct_trty_type, a.ri_cd,
                DECODE
                    (v_paramdate,
                     'A', p_year,
                     'E', DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                             || '-'
                                                             || p_ext_year,
                                                             'MM-YYYY'
                                                            )
                                                   )
                                        - LAST_DAY (TRUNC (b.eff_date))
                                       ),
                                  -1, p_ext_year,
                                  TO_NUMBER (TO_CHAR (b.eff_date, 'YYYY'))
                                 )
                    ) grp_year,
                DECODE
                      (v_paramdate,
                       'A', p_mm,
                       'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (b.eff_date))
                                    ),
                               -1, 99,
                               TO_NUMBER (TO_CHAR (b.eff_date, 'MM'))
                              )
                      ) grp_mm
           FROM giac_treaty_cessions a, gipi_polbasic b, giis_dist_share c
          WHERE NVL (a.policy_id, a.policy_id) = b.policy_id
            --totel--2/11/2008--@fpac--tune--added NVL
            AND a.cession_year = p_year
            AND a.cession_mm = p_mm
            AND DECODE (v_start_date,
                        NULL, SYSDATE,
                        LAST_DAY (TO_DATE (a.cession_mm || '-'
                                           || a.cession_year,
                                           'MM-YYYY'
                                          )
                                 )
                       ) >= DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
            AND a.line_cd = c.line_cd
            AND a.share_cd = c.share_cd
            AND ((v_paramdate = 'E'
                                   -- mildred 01292013 comment to include late booking MN policies
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
            AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                 OR (       v_exclude_mn = 'N'
                        AND v_mn_24th_comp = '1'
                        AND (       b.line_cd = v_mn
                                AND (   (    v_paramdate = 'A'
                                         AND v_mm_year IN
                                                (v_mm_year_mn1, v_mm_year_mn2)
                                        )
                                     OR (    v_paramdate = 'E'
                                         /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                      -- mildred 01292013 comment to include late booking policies
                                                              /* AND (   TO_CHAR (b.eff_date,
                                                                                'MM-YYYY'
                                                                               ) IN
                                                                          (v_mm_year_mn1,
                                                                           v_mm_year_mn2
                                                                          )
                                                                    OR TRUNC (b.eff_date) >
                                                                          LAST_DAY
                                                                              (TO_DATE (   p_ext_mm
                                                                                        || '-'
                                                                                        || p_ext_year,
                                                                                        'MM-YYYY'
                                                                                       )
                                                                              )
                                                                   )*/
                                                      -- replace with --
                                         AND v_mm_year IN
                                                (v_mm_year_mn1, v_mm_year_mn2)
                                        )
                                    )
                             OR b.line_cd <> v_mn
                            )
                     OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                    )
                )
       GROUP BY NVL (b.cred_branch, b.iss_cd),
                a.line_cd,
                c.acct_trty_type,
                a.ri_cd,
                DECODE (v_paramdate,
                        'A', p_year,
                        'E',
                        --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (b.eff_date))
                                     ),
                                -1, p_ext_year,
                                TO_NUMBER (TO_CHAR (b.eff_date, 'YYYY'))
                               )
                       ),
                DECODE (v_paramdate,
                        'A', p_mm,
                        'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (b.eff_date))
                                     ),
                                -1, 99,
                                TO_NUMBER (TO_CHAR (b.eff_date, 'MM'))
                               )
                       ))
   LOOP
      UPDATE giac_deferred_comm_income_dtl comm_inc_dtl
         SET comm_inc_dtl.comm_income =
                                comm_inc_dtl.comm_income + ri_comm1.commission
       WHERE comm_inc_dtl.extract_year = p_ext_year
         AND comm_inc_dtl.extract_mm = p_ext_mm
         AND comm_inc_dtl.YEAR = ri_comm1.grp_year
         AND comm_inc_dtl.mm = ri_comm1.grp_mm
         AND comm_inc_dtl.iss_cd = ri_comm1.iss_cd
         AND comm_inc_dtl.line_cd = ri_comm1.line_cd
         AND comm_inc_dtl.procedure_id = p_method
         AND comm_inc_dtl.share_type = '2'
         AND comm_inc_dtl.acct_trty_type = ri_comm1.acct_trty_type
         AND comm_inc_dtl.ri_cd = ri_comm1.ri_cd;

      IF SQL%NOTFOUND
      THEN
         INSERT INTO giac_deferred_comm_income_dtl
                     (extract_year, extract_mm, YEAR,
                      mm, iss_cd, line_cd,
                      procedure_id, share_type, acct_trty_type,
                      ri_cd, comm_income, user_id, last_update
                     )
              VALUES (p_ext_year, p_ext_mm, ri_comm1.grp_year,
                      ri_comm1.grp_mm, ri_comm1.iss_cd, ri_comm1.line_cd,
                      p_method, '2', ri_comm1.acct_trty_type,
                      ri_comm1.ri_cd, ri_comm1.commission, USER, SYSDATE
                     );
      END IF;
   END LOOP;

   IF    (p_mm != p_ext_mm AND p_ext_year != p_year)
      OR (p_mm <= p_ext_mm AND p_ext_year = p_year)
   THEN                                               --added condition: alfie
      --Facultative
      --Premiums
      FOR ri_prem2 IN
         (SELECT   NVL (e.cred_branch, e.iss_cd) iss_cd, a.line_cd,
                   SUM (  DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),
                                  v_mm_year, -1,
                                  1
                                 )
                        * a.ri_prem_amt
                        * c.currency_rt
                       ) premium,
                   
                   --sum(nvl(decode(to_char(a.acc_rev_date,'MM-YYYY'), v_mm_year, -1, 1)
                   --  * a.ri_comm_amt * c.currency_rt, 0)) commission,
                   DECODE
                      (v_paramdate,
                       'A', p_year,
                       'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (e.eff_date))
                                    ),
                               -1, p_ext_year,
                               TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY'))
                              )
                      ) grp_year,
                   DECODE
                      (v_paramdate,
                       'A', p_mm,
                       'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (e.eff_date))
                                    ),
                               -1, 99,
                               TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))
                              )
                      ) grp_mm
              FROM giri_binder a,
                   giri_frps_ri b,
                   giri_distfrps c,
                   giuw_pol_dist d,
                   gipi_polbasic e
             WHERE a.fnl_binder_id = b.fnl_binder_id
               AND b.line_cd = c.line_cd
               AND b.frps_yy = c.frps_yy
               AND b.frps_seq_no = c.frps_seq_no
               AND c.dist_no = d.dist_no
               AND d.policy_id = e.policy_id
               AND DECODE (v_start_date, NULL, SYSDATE, a.acc_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                  -- OR
                  -- DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date))
               --AND ((TO_CHAR(a.acc_ent_date,'MM-YYYY') = v_mm_year
               --         AND (DECODE(a.acc_ent_date, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')), a.acc_ent_date,
               --                 a.acc_rev_date) <= LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY'))
               --              OR a.acc_rev_date IS NULL))
               --     OR
               --     TO_CHAR(a.acc_rev_date,'MM-YYYY') = v_mm_year)
               --AND (DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) = DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')))
               --     OR
               --     DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) > DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')))
               --     )
               -- comment by mildred for change of cut off date 01292013
               --AND a.acc_ent_date = LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
               AND TO_CHAR (a.acc_ent_date, 'MM-YYYY') = v_mm_year
                                                          -- replace condition
               --AND d.acct_ent_date <= LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
               AND LAST_DAY (d.acct_ent_date) <=
                                     LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
               --mikel 02.28.2013
               AND ((v_paramdate = 'E'
/*  mildred 01292013 comment to include late booking binders*/
                      /*  AND TRUNC (e.eff_date) >
                               LAST_DAY (ADD_MONTHS (TO_DATE (v_mm_year,
                                                              'MM-YYYY'
                                                             ),
                                                     -12
                                                    )
                                        )*/
                       /*AND TRUNC(e.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                    ) OR v_paramdate = 'A')
               AND e.reg_policy_sw = 'Y'
               AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                    OR (       v_exclude_mn = 'N'
                           AND v_mn_24th_comp = '1'
                           AND (       e.line_cd = v_mn
                                   AND (   (    v_paramdate = 'A'
                                            AND v_mm_year IN
                                                   (v_mm_year_mn1,
                                                    v_mm_year_mn2
                                                   )
                                           )
                                        OR (    v_paramdate = 'E'
                                            /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                            -- replace with condition  mildred 01292013
                                                            --AND v_mm_year IN (v_mm_year_mn1_fac,v_mn_year_mn2_fac)
                                            AND v_mm_year IN
                                                   (v_mm_year_mn1,
                                                    v_mm_year_mn2
                                                   )        --mikel 02.27.2013
                                           --comment out mildred 01292013 to include late booking MN binders
                                           /*AND (   TO_CHAR (e.eff_date,
                                                            'MM-YYYY'
                                                           ) IN
                                                      (v_mm_year_mn1_fac,
                                                       v_mn_year_mn2_fac
                                                      )
                                                OR TRUNC (e.eff_date) >
                                                      LAST_DAY
                                                         (TO_DATE (v_mm_year,
                                                                   'MM-YYYY'
                                                                  )
                                                         )
                                               )*/
                                           )
                                       )
                                OR e.line_cd <> v_mn
                               )
                        OR v_mn_24th_comp = '2' AND e.line_cd = e.line_cd
                       )
                   )
          GROUP BY NVL (e.cred_branch, e.iss_cd),
                   a.line_cd,
                   DECODE (v_paramdate,
                           'A', p_year,
                           'E',
                           --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                           DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                              || '-'
                                                              || p_ext_year,
                                                              'MM-YYYY'
                                                             )
                                                    )
                                         - LAST_DAY (TRUNC (e.eff_date))
                                        ),
                                   -1, p_ext_year,
                                   TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY'))
                                  )
                          ),
                   DECODE (v_paramdate,
                           'A', p_mm,
                           'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                           DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                              || '-'
                                                              || p_ext_year,
                                                              'MM-YYYY'
                                                             )
                                                    )
                                         - LAST_DAY (TRUNC (e.eff_date))
                                        ),
                                   -1, 99,
                                   TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))
                                  )
                          )
          UNION
          SELECT   NVL (e.cred_branch, e.iss_cd) iss_cd, a.line_cd,
                   SUM (  DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),
                                  v_mm_year, -1,
                                  1
                                 )
                        * a.ri_prem_amt
                        * c.currency_rt
                       ) premium,
                   
                   --sum(nvl(decode(to_char(a.acc_rev_date,'MM-YYYY'), v_mm_year, -1, 1)
                   --  * a.ri_comm_amt * c.currency_rt, 0)) commission,
                   DECODE
                      (v_paramdate,
                       'A', p_year,
                       'E', --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (e.eff_date))
                                    ),
                               -1, p_ext_year,
                               TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY'))
                              )
                      ) grp_year,
                   DECODE
                      (v_paramdate,
                       'A', p_mm,
                       'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (e.eff_date))
                                    ),
                               -1, 99,
                               TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))
                              )
                      ) grp_mm
              FROM giri_binder a,
                   giri_frps_ri b,
                   giri_distfrps c,
                   giuw_pol_dist d,
                   gipi_polbasic e
             WHERE a.fnl_binder_id = b.fnl_binder_id
               AND b.line_cd = c.line_cd
               AND b.frps_yy = c.frps_yy
               AND b.frps_seq_no = c.frps_seq_no
               AND c.dist_no = d.dist_no
               AND d.policy_id = e.policy_id
               AND DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                  -- OR
                  -- DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date))
               --AND ((TO_CHAR(a.acc_ent_date,'MM-YYYY') = v_mm_year
               --         AND (DECODE(a.acc_ent_date, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')), a.acc_ent_date,
               --                 a.acc_rev_date) <= LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY'))
               --              OR a.acc_rev_date IS NULL))
               --     OR
               --     TO_CHAR(a.acc_rev_date,'MM-YYYY') = v_mm_year)
               --AND (DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) = DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')))
               --     OR
               --     DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) > DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')))
               --     )
               --AND a.acc_rev_date = LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')) -- mildred 01292013
               -- mildred comment 01292013 for cut off date <> last day of the month and replace with --
               AND TO_CHAR (a.acc_rev_date, 'MM-YYYY') = v_mm_year
               AND (   ( /*d.dist_flag = '3' AND */b.reverse_sw = 'Y'
                       )             --mikel 06.18.2013; removed dist_flag = 3
                    OR (    d.dist_flag = '4'
                        AND TO_CHAR (d.acct_neg_date, 'MM-YYYY') = v_mm_year
                         --mikel 06.18.2013; added d.acct_neg_date = v_mm_year
                       --AND TO_CHAR (d.acct_neg_date, 'MM-YYYY') = v_mm_year
                       --AND d.acct_neg_date <= LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')) --mikel 02.28.2013
                       /*AND DECODE(SIGN(LAST_DAY(d.acct_neg_date) - LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))),
                       1, LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')) + 1,
                       0, LAST_DAY(d.acct_neg_date), -1, LAST_DAY(d.acct_neg_date))
                        <= LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')) --mikel 03.01.2013*/
                       )
                    OR (d.dist_flag = '5'
                       )             --mikel 06.18.2013; include redistributed
                   )
               AND ((v_paramdate = 'E'
/*  mildred 01292013 comment to include late booking binders*/
                        /*AND TRUNC (e.eff_date) >
                               LAST_DAY (ADD_MONTHS (TO_DATE (v_mm_year,
                                                              'MM-YYYY'
                                                             ),
                                                     -12
                                                    )
                                        )*/
                       /*AND TRUNC(e.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                    ) OR v_paramdate = 'A')
               AND e.reg_policy_sw = 'Y'
               AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                    OR (       v_exclude_mn = 'N'
                           AND v_mn_24th_comp = '1'
                           AND (       e.line_cd = v_mn
                                   AND (   (    v_paramdate = 'A'
                                            AND v_mm_year IN
                                                   (v_mm_year_mn1,
                                                    v_mm_year_mn2
                                                   )
                                           )
                                        OR (    v_paramdate = 'E'
                            /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
/*  mildred 01292013 comment to include late booking MN binders*/
                 /*AND (   TO_CHAR (e.eff_date,
                                  'MM-YYYY'
                                 ) IN
                            (v_mm_year_mn1_fac,
                             v_mn_year_mn2_fac
                            )
                      OR TRUNC (e.eff_date) >
                            LAST_DAY
                               (TO_DATE (v_mm_year,
                                         'MM-YYYY'
                                        )
                               )
                     )*/
                                            -- replace with condition
                                                  --AND v_mm_year IN (v_mm_year_mn1_fac,v_mn_year_mn2_fac)
                                            AND v_mm_year IN
                                                   (v_mm_year_mn1,
                                                    v_mm_year_mn2
                                                   )        --mikel 02.27.2013
                                           )
                                       )
                                OR e.line_cd <> v_mn
                               )
                        OR v_mn_24th_comp = '2' AND e.line_cd = e.line_cd
                       )
                   )
          GROUP BY NVL (e.cred_branch, e.iss_cd),
                   a.line_cd,
                   DECODE (v_paramdate,
                           'A', p_year,
                           'E',
                           --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                           DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                              || '-'
                                                              || p_ext_year,
                                                              'MM-YYYY'
                                                             )
                                                    )
                                         - LAST_DAY (TRUNC (e.eff_date))
                                        ),
                                   -1, p_ext_year,
                                   TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY'))
                                  )
                          ),
                   DECODE (v_paramdate,
                           'A', p_mm,
                           'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                           DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                              || '-'
                                                              || p_ext_year,
                                                              'MM-YYYY'
                                                             )
                                                    )
                                         - LAST_DAY (TRUNC (e.eff_date))
                                        ),
                                   -1, 99,
                                   TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))
                                  )
                          ))
      LOOP
         UPDATE giac_deferred_ri_prem_cede_dtl ri_prem_dtl
            SET ri_prem_dtl.dist_prem =
                                      ri_prem_dtl.dist_prem + ri_prem2.premium
          WHERE ri_prem_dtl.extract_year = p_ext_year
            AND ri_prem_dtl.extract_mm = p_ext_mm
            AND ri_prem_dtl.YEAR = ri_prem2.grp_year
            AND ri_prem_dtl.mm = ri_prem2.grp_mm
            AND ri_prem_dtl.iss_cd = ri_prem2.iss_cd
            AND ri_prem_dtl.line_cd = ri_prem2.line_cd
            AND ri_prem_dtl.procedure_id = p_method
            AND ri_prem_dtl.share_type = '3'
            AND ri_prem_dtl.acct_trty_type = 0;

         IF SQL%NOTFOUND
         THEN
            INSERT INTO giac_deferred_ri_prem_cede_dtl
                        (extract_year, extract_mm, YEAR,
                         mm, iss_cd, line_cd,
                         procedure_id, share_type, dist_prem, user_id,
                         last_update
                        )
                 VALUES (p_ext_year, p_ext_mm, ri_prem2.grp_year,
                         ri_prem2.grp_mm, ri_prem2.iss_cd, ri_prem2.line_cd,
                         p_method, '3', ri_prem2.premium, USER,
                         SYSDATE
                        );
         END IF;
      END LOOP;
   END IF;

   --Comm Income
   FOR ri_comm2 IN
      (SELECT   a.fnl_binder_id,                             --albert 08312013
                                NVL (e.cred_branch, e.iss_cd) iss_cd,
                a.line_cd, a.ri_cd,
                SUM (NVL (  DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),
                                    v_mm_year, -1,
                                    1
                                   )
                          * a.ri_comm_amt
                          * c.currency_rt,
                          0
                         )
                    ) commission,
                DECODE
                   (v_paramdate,
                    'A', p_year,
                    'E',    --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                    DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                       || '-'
                                                       || p_ext_year,
                                                       'MM-YYYY'
                                                      )
                                             )
                                  - LAST_DAY (TRUNC (e.eff_date))
                                 ),
                            -1, p_ext_year,
                            TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY'))
                           )
                   ) grp_year,
                DECODE
                      (v_paramdate,
                       'A', p_mm,
                       'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (e.eff_date))
                                    ),
                               -1, 99,
                               TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))
                              )
                      ) grp_mm
           FROM giri_binder a,
                giri_frps_ri b,
                giri_distfrps c,
                giuw_pol_dist d,
                gipi_polbasic e
          WHERE a.fnl_binder_id = b.fnl_binder_id
            AND b.line_cd = c.line_cd
            AND b.frps_yy = c.frps_yy
            AND b.frps_seq_no = c.frps_seq_no
            AND c.dist_no = d.dist_no
            AND d.policy_id = e.policy_id
            AND DECODE (v_start_date, NULL, SYSDATE, a.acc_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                   --OR
                   --DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date))
            --   AND (TO_CHAR(a.acc_ent_date,'MM-YYYY') = v_mm_year
            --        OR
            --        TO_CHAR(a.acc_rev_date,'MM-YYYY') = v_mm_year)
               --AND ((TO_CHAR(a.acc_ent_date,'MM-YYYY') = v_mm_year
               --             AND (DECODE(a.acc_ent_date, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')), a.acc_ent_date,
               --                     a.acc_rev_date) <= LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY'))
               --                  OR a.acc_rev_date IS NULL))
               --         OR
               --         TO_CHAR(a.acc_rev_date,'MM-YYYY') = v_mm_year)
               --AND (DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) = DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')))
                --        OR
                --        DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) > DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')))
                --        )
            --AND a.acc_ent_date = LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
            -- mildred comment 01292013 for cut off date <> last day of the month and replace with --
            AND TO_CHAR (a.acc_ent_date, 'MM-YYYY') = v_mm_year
            --AND d.acct_ent_date <= LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
            AND LAST_DAY (d.acct_ent_date) <=
                                     LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
            --mikel 03.01.2013
            AND ((v_paramdate = 'E'
                                   -- mildred 01292013 comment to include late booking binders
                                                /*AND TRUNC (e.eff_date) >
                                                       LAST_DAY (ADD_MONTHS (TO_DATE (v_mm_year,
                                                                                      'MM-YYYY'
                                                                                     ),
                                                                             -12
                                                                            )
                                                                )*/
                                               /*AND TRUNC(e.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                 ) OR v_paramdate = 'A')
            AND e.reg_policy_sw = 'Y'
            AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                 OR (       v_exclude_mn = 'N'
                        AND v_mn_24th_comp = '1'
                        AND (       e.line_cd = v_mn
                                AND (   (    v_paramdate = 'A'
                                         AND v_mm_year IN
                                                (v_mm_year_mn1, v_mm_year_mn2)
                                        )
                                     OR (    v_paramdate = 'E'
                                         /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                      -- mildred 01292013 comment to include late booking MN binders
                                                                       /*AND (   TO_CHAR (e.eff_date,
                                                                                        'MM-YYYY'
                                                                                       ) IN
                                                                                  (v_mm_year_mn1_fac,
                                                                                   v_mn_year_mn2_fac
                                                                                  )
                                                                            OR TRUNC (e.eff_date) >
                                                                                  LAST_DAY
                                                                                        (TO_DATE (v_mm_year,
                                                                                                  'MM-YYYY'
                                                                                                 )
                                                                                        )
                                                                           )*/
                                                       -- replace with --
                                                                         --AND v_mm_year IN (v_mm_year_mn1_fac,v_mn_year_mn2_fac)
                                         AND v_mm_year IN
                                                (v_mm_year_mn1, v_mm_year_mn2)
                                        --mikel 02.27.2013
                                        )
                                    )
                             OR e.line_cd <> v_mn
                            )
                     OR v_mn_24th_comp = '2' AND e.line_cd = e.line_cd
                    )
                )
       GROUP BY a.fnl_binder_id,                             --albert 08312013
                NVL (e.cred_branch, e.iss_cd),
                a.line_cd,
                a.ri_cd,
                DECODE (v_paramdate,
                        'A', p_year,
                        'E',
                        --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (e.eff_date))
                                     ),
                                -1, p_ext_year,
                                TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY'))
                               )
                       ),
                DECODE (v_paramdate,
                        'A', p_mm,
                        'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (e.eff_date))
                                     ),
                                -1, 99,
                                TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))
                               )
                       )
       UNION
       SELECT   a.fnl_binder_id,                             --albert 08312013
                                NVL (e.cred_branch, e.iss_cd) iss_cd,
                a.line_cd, a.ri_cd,
                SUM (NVL (  DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),
                                    v_mm_year, -1,
                                    1
                                   )
                          * a.ri_comm_amt
                          * c.currency_rt,
                          0
                         )
                    ) commission,
                DECODE
                   (v_paramdate,
                    'A', p_year,
                    'E',    --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                    DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                       || '-'
                                                       || p_ext_year,
                                                       'MM-YYYY'
                                                      )
                                             )
                                  - LAST_DAY (TRUNC (e.eff_date))
                                 ),
                            -1, p_ext_year,
                            TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY'))
                           )
                   ) grp_year,
                DECODE
                      (v_paramdate,
                       'A', p_mm,
                       'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (e.eff_date))
                                    ),
                               -1, 99,
                               TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))
                              )
                      ) grp_mm
           FROM giri_binder a,
                giri_frps_ri b,
                giri_distfrps c,
                giuw_pol_dist d,
                gipi_polbasic e
          WHERE a.fnl_binder_id = b.fnl_binder_id
            AND b.line_cd = c.line_cd
            AND b.frps_yy = c.frps_yy
            AND b.frps_seq_no = c.frps_seq_no
            AND c.dist_no = d.dist_no
            AND d.policy_id = e.policy_id
            AND DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                   --OR
                   --DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date))
            --   AND (TO_CHAR(a.acc_ent_date,'MM-YYYY') = v_mm_year
            --        OR
            --        TO_CHAR(a.acc_rev_date,'MM-YYYY') = v_mm_year)
               --AND ((TO_CHAR(a.acc_ent_date,'MM-YYYY') = v_mm_year
               --             AND (DECODE(a.acc_ent_date, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')), a.acc_ent_date,
               --                     a.acc_rev_date) <= LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY'))
               --                  OR a.acc_rev_date IS NULL))
               --         OR
               --         TO_CHAR(a.acc_rev_date,'MM-YYYY') = v_mm_year)
               --AND (DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) = DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')))
                --        OR
                --        DECODE(a.acc_rev_date, NULL, sysdate,a.acc_rev_date) > DECODE(a.acc_rev_date, NULL,sysdate, LAST_DAY(TO_DATE (v_mm_year, 'MM-YYYY')))
                --        )
            --AND a.acc_rev_date = LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
            -- mildred comment 01292013 for cut off date <> last day of the month and replace with --
            AND TO_CHAR (a.acc_rev_date, 'MM-YYYY') = v_mm_year
            AND (   ( /*d.dist_flag = '3' AND */b.reverse_sw = 'Y'
                    )                --mikel 06.18.2013; removed dist_flag = 3
                 OR (    d.dist_flag = '4'
                     AND TO_CHAR (d.acct_neg_date, 'MM-YYYY') = v_mm_year
                         --mikel 06.18.2013; added d.acct_neg_date = v_mm_year
                    --AND TO_CHAR (d.acct_neg_date, 'MM-YYYY') = v_mm_year
                    --AND d.acct_neg_date <= LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')) --mikel 02.28.2013
                    /*AND DECODE(SIGN(LAST_DAY(d.acct_neg_date) - LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))),
                    1, LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')) + 1,
                    0, LAST_DAY(d.acct_neg_date), -1, LAST_DAY(d.acct_neg_date))
                     <= LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')) --mikel 03.01.2013*/
                    )
                 OR (d.dist_flag = '5'
                    )                --mikel 06.18.2013; include redistributed
                )
            AND ((v_paramdate = 'E'
-- mildred 01292013 comment to include late booking binders
                     /*AND TRUNC (e.eff_date) >
                            LAST_DAY (ADD_MONTHS (TO_DATE (v_mm_year,
                                                           'MM-YYYY'
                                                          ),
                                                  -12
                                                 )
                                     )*/
                    /*AND TRUNC(e.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                 ) OR v_paramdate = 'A')
            AND e.reg_policy_sw = 'Y'
            AND (   (v_exclude_mn = 'Y' AND e.line_cd <> v_mn)
                 OR (       v_exclude_mn = 'N'
                        AND v_mn_24th_comp = '1'
                        AND (       e.line_cd = v_mn
                                AND (   (    v_paramdate = 'A'
                                         AND v_mm_year IN
                                                (v_mm_year_mn1, v_mm_year_mn2)
                                        )
                                     OR (    v_paramdate = 'E'
                                         /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                      -- mildred 01292013 comment to include late booking MN binders
                                                                      /* AND (   TO_CHAR (e.eff_date,
                                                                                        'MM-YYYY'
                                                                                       ) IN
                                                                                  (v_mm_year_mn1_fac,
                                                                                   v_mn_year_mn2_fac
                                                                                  )
                                                                            OR TRUNC (e.eff_date) >
                                                                                  LAST_DAY
                                                                                        (TO_DATE (v_mm_year,
                                                                                                  'MM-YYYY'
                                                                                                 )
                                                                                        )
                                                                           )*/
                                                      -- replace with --
                                                                          --AND v_mm_year IN (v_mm_year_mn1_fac,v_mn_year_mn2_fac)
                                         AND v_mm_year IN
                                                (v_mm_year_mn1, v_mm_year_mn2)
                                        --mikel 02.27.2013
                                        )
                                    )
                             OR e.line_cd <> v_mn
                            )
                     OR v_mn_24th_comp = '2' AND e.line_cd = e.line_cd
                    )
                )
       GROUP BY a.fnl_binder_id,                             --albert 08312013
                NVL (e.cred_branch, e.iss_cd),
                a.line_cd,
                a.ri_cd,
                DECODE (v_paramdate,
                        'A', p_year,
                        'E',
                        --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (e.eff_date))
                                     ),
                                -1, p_ext_year,
                                TO_NUMBER (TO_CHAR (e.eff_date, 'YYYY'))
                               )
                       ),
                DECODE (v_paramdate,
                        'A', p_mm,
                        'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (e.eff_date))
                                     ),
                                -1, 99,
                                TO_NUMBER (TO_CHAR (e.eff_date, 'MM'))
                               )
                       ))
   LOOP
      UPDATE giac_deferred_comm_income_dtl comm_inc_dtl
         SET comm_inc_dtl.comm_income =
                                comm_inc_dtl.comm_income + ri_comm2.commission
       WHERE comm_inc_dtl.extract_year = p_ext_year
         AND comm_inc_dtl.extract_mm = p_ext_mm
         AND comm_inc_dtl.YEAR = ri_comm2.grp_year
         AND comm_inc_dtl.mm = ri_comm2.grp_mm
         AND comm_inc_dtl.iss_cd = ri_comm2.iss_cd
         AND comm_inc_dtl.line_cd = ri_comm2.line_cd
         AND comm_inc_dtl.procedure_id = p_method
         AND comm_inc_dtl.share_type = '3'
         AND comm_inc_dtl.acct_trty_type = 0
         AND comm_inc_dtl.ri_cd = ri_comm2.ri_cd;

      IF SQL%NOTFOUND
      THEN
         INSERT INTO giac_deferred_comm_income_dtl
                     (extract_year, extract_mm, YEAR,
                      mm, iss_cd, line_cd,
                      procedure_id, share_type, ri_cd, comm_income,
                      user_id, last_update
                     )
              VALUES (p_ext_year, p_ext_mm, ri_comm2.grp_year,
                      ri_comm2.grp_mm, ri_comm2.iss_cd, ri_comm2.line_cd,
                      p_method, '3', ri_comm2.ri_cd, ri_comm2.commission,
                      USER, SYSDATE
                     );
      END IF;
   END LOOP;

   --COMMISSION EXPENSE
   --Direct Extract
   FOR expdi IN
      (SELECT   iss_cd, line_cd, intm_no, SUM (comm_expense) comm_expense,
                DECODE
                   (v_paramdate,
                    'A', p_year,
                    'E',    --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                    DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                       || '-'
                                                       || p_ext_year,
                                                       'MM-YYYY'
                                                      )
                                             )
                                  - LAST_DAY (TRUNC (eff_date))
                                 ),
                            -1, p_ext_year,
                            TO_NUMBER (TO_CHAR (eff_date, 'YYYY'))
                           )
                   ) grp_year,
                DECODE
                      (v_paramdate,
                       'A', p_mm,
                       'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (eff_date))
                                    ),
                               -1, 99,
                               TO_NUMBER (TO_CHAR (eff_date, 'MM'))
                              )
                      ) grp_mm
           FROM (                    /* mikel 07.17.2013; get booked comm amt
                                     ** moved the original codes at the bottom
                                     */
                 SELECT   NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd,
                          d.intrmdry_intm_no intm_no,
                          SUM
                             (get_booked_comm_amt
                                   (a.iss_cd,
                                    a.prem_seq_no,
                                    d.intrmdry_intm_no,
                                    --mikel 08.31.2013; added d.intrmdry_intm_no
                                    DECODE (TO_CHAR (a.spoiled_acct_ent_date,
                                                     'MM-YYYY'
                                                    ),
                                            v_mm_year, a.spoiled_acct_ent_date,
                                            a.acct_ent_date
                                           )
                                   )
                             ) comm_expense,
                          b.eff_date
                     FROM gipi_invoice a, gipi_polbasic b,
                          gipi_comm_invoice d
                    WHERE a.iss_cd = d.iss_cd
                      AND a.prem_seq_no = d.prem_seq_no
                      AND a.policy_id = d.policy_id
                      AND a.policy_id = b.policy_id
                      AND ((v_paramdate = 'E') OR v_paramdate = 'A')
                      AND DECODE (v_start_date,
                                  NULL, SYSDATE,
                                  a.acct_ent_date
                                 ) >=
                             DECODE (v_start_date,
                                     NULL, SYSDATE,
                                     v_start_date
                                    )
                      /* OR DECODE (v_start_date, NULL, SYSDATE, a.spoiled_acct_ent_date) >=
                                        DECODE (v_start_date,
                                                NULL, SYSDATE,
                                                v_start_date
                                               )
                      )*/--commented out by albert 09252013
                      AND TO_CHAR (a.acct_ent_date, 'MM-YYYY') = v_mm_year
                      /* OR TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') = v_mm_year
                      )*/--commented out by albert 09252013
                      AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                      AND b.reg_policy_sw = 'Y'
                      AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                           OR (       v_exclude_mn = 'N'
                                  AND v_mn_24th_comp = '1'
                                  AND (       b.line_cd = v_mn
                                          AND (   (    v_paramdate = 'A'
                                                   AND v_mm_year IN
                                                          (v_mm_year_mn1,
                                                           v_mm_year_mn2
                                                          )
                                                  )
                                               OR (    v_paramdate = 'E'
                                                   AND v_mm_year IN
                                                          (v_mm_year_mn1,
                                                           v_mm_year_mn2
                                                          )
                                                  )
                                              )
                                       OR b.line_cd <> v_mn
                                      )
                               OR     v_mn_24th_comp = '2'
                                  AND b.line_cd = b.line_cd
                              )
                          )
                 GROUP BY NVL (b.cred_branch, a.iss_cd),
                          b.line_cd,
                          d.intrmdry_intm_no,
                          b.eff_date
                 --end mikel 07.17.2013
                 UNION ALL
                 --SELECT stmnt for comms modified within selected month
                 SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd,
                        d.intm_no,
                        (d.commission_amt * a.currency_rt) comm_expense,
                        b.eff_date
                   FROM gipi_invoice a, gipi_polbasic b, giac_new_comm_inv d
                  WHERE a.policy_id = b.policy_id
                    AND a.iss_cd = d.iss_cd
                    AND a.prem_seq_no = d.prem_seq_no
                    AND a.policy_id = d.policy_id
                    AND ((v_paramdate = 'E'
                                           -- mildred 01292013 to include late booking
                                                 /*AND TRUNC (b.eff_date) >
                                                        LAST_DAY
                                                               (ADD_MONTHS (TO_DATE (   p_ext_mm
                                                                                     || '-'
                                                                                     || p_ext_year,
                                                                                     'MM-YYYY'
                                                                                    ),
                                                                            -12
                                                                           )
                                                               )*/
                                                /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                         ) OR v_paramdate = 'A')
                    AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                    AND b.reg_policy_sw = 'Y'
                    AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                         OR (       v_exclude_mn = 'N'
                                AND v_mn_24th_comp = '1'
                                AND (       b.line_cd = v_mn
                                        AND (   (    v_paramdate = 'A'
                                                 AND v_mm_year IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )
                                                )
                                             OR (    v_paramdate = 'E'
                                                 /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                                      -- mildred 01292013 to include late booking
                                                                                /* AND (   TO_CHAR (b.eff_date,
                                                                                                  'MM-YYYY'
                                                                                                 ) IN
                                                                                            (v_mm_year_mn1,
                                                                                             v_mm_year_mn2
                                                                                            )
                                                                                      OR TRUNC (b.eff_date) >
                                                                                            LAST_DAY
                                                                                               (TO_DATE
                                                                                                   (   p_ext_mm
                                                                                                    || '-'
                                                                                                    || p_ext_year,
                                                                                                    'MM-YYYY'
                                                                                                   )
                                                                                               )
                                                                                     )*/
                                                                       --AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2) --mikel 07.15.2013
                                                 AND TO_CHAR (d.acct_ent_date,
                                                              'MM-YYYY'
                                                             ) IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )   --mikel 07.15.2013
                                                )
                                            )
                                     OR b.line_cd <> v_mn
                                    )
                             OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                            )
                        )
                    AND (   DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    d.acct_ent_date
                                   ) >=
                               DECODE (v_start_date,
                                       NULL, SYSDATE,
                                       v_start_date
                                      )
                         OR DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    a.acct_ent_date
                                   ) >=
                               DECODE (v_start_date,
                                       NULL, SYSDATE,
                                       v_start_date
                                      )
                        )
                    AND TO_CHAR (d.acct_ent_date, 'MM-YYYY') = v_mm_year
                    AND NVL (d.delete_sw, 'N') = 'N'
                    AND d.tran_flag = 'P'
                 /*AND d.comm_rec_id = (SELECT MAX(e.comm_rec_id)
                                        FROM GIAC_NEW_COMM_INV e
                                       WHERE TO_CHAR(e.acct_ent_date,'MM-YYYY') = v_mm_year
                                         AND NVL(e.delete_sw,'N') = 'N'
                                         AND e.tran_flag = 'P'
                                         AND e.iss_cd = d.iss_cd
                                         AND e.prem_seq_no = d.prem_seq_no)*/ -- commented by judyann 08202009; should include all modified comm records of taken-up policies
                 UNION ALL
/* added by judyann 08202009; should include reversals of modified commissions */
                 --SELECT stmnt for reversal of comms modified within selected month
                 SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd,
                        d.intm_no,
                        ((c.commission_amt * a.currency_rt) * -1
                        ) comm_expense, b.eff_date
                   FROM gipi_invoice a,
                        gipi_polbasic b,
                        giac_prev_comm_inv c,
                        giac_new_comm_inv d
                  WHERE a.policy_id = b.policy_id
                    AND a.iss_cd = d.iss_cd
                    AND a.prem_seq_no = d.prem_seq_no
                    AND a.policy_id = d.policy_id
                    AND c.comm_rec_id = d.comm_rec_id
                    AND c.intm_no = d.intm_no                --albert 09252013
                    AND ((v_paramdate = 'E'
                                           -- mildred 01292013  commented to include late booking
                                                   /*AND TRUNC (b.eff_date) >
                                                          LAST_DAY
                                                                 (ADD_MONTHS (TO_DATE (   p_ext_mm
                                                                                       || '-'
                                                                                       || p_ext_year,
                                                                                       'MM-YYYY'
                                                                                      ),
                                                                              -12
                                                                             )
                                                                 )*/
                                                  /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                         ) OR v_paramdate = 'A')
                    AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                    AND b.reg_policy_sw = 'Y'
                    AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                         OR (       v_exclude_mn = 'N'
                                AND v_mn_24th_comp = '1'
                                AND (       b.line_cd = v_mn
                                        AND (   (    v_paramdate = 'A'
                                                 AND v_mm_year IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )
                                                )
                                             OR (    v_paramdate = 'E'
                                                 /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                                      -- mildred 01292013  commented to include late booking
                                                                                /*AND (   TO_CHAR (b.eff_date,
                                                                                                 'MM-YYYY'
                                                                                                ) IN
                                                                                           (v_mm_year_mn1,
                                                                                            v_mm_year_mn2
                                                                                           )
                                                                                     OR TRUNC (b.eff_date) >
                                                                                           LAST_DAY
                                                                                              (TO_DATE
                                                                                                  (   p_ext_mm
                                                                                                   || '-'
                                                                                                   || p_ext_year,
                                                                                                   'MM-YYYY'
                                                                                                  )
                                                                                              )
                                                                                    )*/
                                                                              --AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2) --mikel 07.15.2013
                                                 AND TO_CHAR (d.acct_ent_date,
                                                              'MM-YYYY'
                                                             ) IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )   --mikel 07.15.2013
                                                )
                                            )
                                     OR b.line_cd <> v_mn
                                    )
                             OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                            )
                        )
                    AND (   DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    d.acct_ent_date
                                   ) >=
                               DECODE (v_start_date,
                                       NULL, SYSDATE,
                                       v_start_date
                                      )
                         OR DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    a.acct_ent_date
                                   ) >=
                               DECODE (v_start_date,
                                       NULL, SYSDATE,
                                       v_start_date
                                      )
                        )
                    AND TO_CHAR (d.acct_ent_date, 'MM-YYYY') = v_mm_year
                    AND NVL (d.delete_sw, 'N') = 'N'
                    AND c.tran_flag = 'P'--AND d.tran_flag = 'P' --modified by albert 01282015; tran flag should be based on prev comm table
                 UNION ALL
                 --albert 09252013, to handle policies with changes between prev_comm and new_comm
                 SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd,
                        d.intm_no,
                        ((c.commission_amt * a.currency_rt) * -1
                        ) comm_expense, b.eff_date
                   FROM gipi_invoice a,
                        gipi_polbasic b,
                        giac_prev_comm_inv c,
                        giac_new_comm_inv d
                  WHERE a.policy_id = b.policy_id
                    AND a.iss_cd = d.iss_cd
                    AND a.prem_seq_no = d.prem_seq_no
                    AND a.policy_id = d.policy_id
                    AND c.comm_rec_id = d.comm_rec_id
                    AND c.intm_no = d.intm_no                --albert 09252013
                    AND ((v_paramdate = 'E'
                                           -- mildred 01292013  commented to include late booking
                                                   /*AND TRUNC (b.eff_date) >
                                                          LAST_DAY
                                                                 (ADD_MONTHS (TO_DATE (   p_ext_mm
                                                                                       || '-'
                                                                                       || p_ext_year,
                                                                                       'MM-YYYY'
                                                                                      ),
                                                                              -12
                                                                             )
                                                                 )*/
                                                  /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                         ) OR v_paramdate = 'A')
                    AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                    AND b.reg_policy_sw = 'Y'
                    AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                         OR (       v_exclude_mn = 'N'
                                AND v_mn_24th_comp = '1'
                                AND (       b.line_cd = v_mn
                                        AND (   (    v_paramdate = 'A'
                                                 AND v_mm_year IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )
                                                )
                                             OR (    v_paramdate = 'E'
                                                 /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                                      -- mildred 01292013  commented to include late booking
                                                                                /*AND (   TO_CHAR (b.eff_date,
                                                                                                 'MM-YYYY'
                                                                                                ) IN
                                                                                           (v_mm_year_mn1,
                                                                                            v_mm_year_mn2
                                                                                           )
                                                                                     OR TRUNC (b.eff_date) >
                                                                                           LAST_DAY
                                                                                              (TO_DATE
                                                                                                  (   p_ext_mm
                                                                                                   || '-'
                                                                                                   || p_ext_year,
                                                                                                   'MM-YYYY'
                                                                                                  )
                                                                                              )
                                                                                    )*/
                                                                              --AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2) --mikel 07.15.2013
                                                 AND TO_CHAR (d.acct_ent_date,
                                                              'MM-YYYY'
                                                             ) IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )   --mikel 07.15.2013
                                                )
                                            )
                                     OR b.line_cd <> v_mn
                                    )
                             OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                            )
                        )
                    AND (   DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    d.acct_ent_date
                                   ) >=
                               DECODE (v_start_date,
                                       NULL, SYSDATE,
                                       v_start_date
                                      )
                         OR DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    a.acct_ent_date
                                   ) >=
                               DECODE (v_start_date,
                                       NULL, SYSDATE,
                                       v_start_date
                                      )
                        )
                    AND TO_CHAR (d.acct_ent_date, 'MM-YYYY') = v_mm_year
                    AND NVL (d.delete_sw, 'N') = 'Y'
                    AND c.tran_flag = 'P') --AND d.tran_flag = 'P') --modified by albert 01282015; tran flag should be based on prev comm table
       --end albert 09252013
       GROUP BY iss_cd,
                line_cd,
                intm_no,
                DECODE (v_paramdate,
                        'A', p_year,
                        'E',
                        --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (eff_date))
                                     ),
                                -1, p_ext_year,
                                TO_NUMBER (TO_CHAR (eff_date, 'YYYY'))
                               )
                       ),
                DECODE (v_paramdate,
                        'A', p_mm,
                        'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (eff_date))
                                     ),
                                -1, 99,
                                TO_NUMBER (TO_CHAR (eff_date, 'MM'))
                               )
                       ),
                intm_no
       UNION ALL
       --albert 09252013, to handle spoiled policies
       SELECT   iss_cd, line_cd, intm_no, SUM (comm_expense) comm_expense,
                DECODE
                   (v_paramdate,
                    'A', p_year,
                    'E',    --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                    DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                       || '-'
                                                       || p_ext_year,
                                                       'MM-YYYY'
                                                      )
                                             )
                                  - LAST_DAY (TRUNC (eff_date))
                                 ),
                            -1, p_ext_year,
                            TO_NUMBER (TO_CHAR (eff_date, 'YYYY'))
                           )
                   ) grp_year,
                DECODE
                      (v_paramdate,
                       'A', p_mm,
                       'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (eff_date))
                                    ),
                               -1, 99,
                               TO_NUMBER (TO_CHAR (eff_date, 'MM'))
                              )
                      ) grp_mm
           FROM (                    /* mikel 07.17.2013; get booked comm amt
                                     ** moved the original codes at the bottom
                                     */
                 SELECT   NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd,
                          d.intrmdry_intm_no intm_no,
                          SUM
                             (get_booked_comm_amt
                                   (a.iss_cd,
                                    a.prem_seq_no,
                                    d.intrmdry_intm_no,
                                    --mikel 08.31.2013; added d.intrmdry_intm_no
                                    DECODE (TO_CHAR (a.spoiled_acct_ent_date,
                                                     'MM-YYYY'
                                                    ),
                                            v_mm_year, a.spoiled_acct_ent_date,
                                            a.acct_ent_date
                                           )
                                   )
                             ) comm_expense,
                          b.eff_date
                     FROM gipi_invoice a, gipi_polbasic b,
                          gipi_comm_invoice d
                    WHERE a.iss_cd = d.iss_cd
                      AND a.prem_seq_no = d.prem_seq_no
                      AND a.policy_id = d.policy_id
                      AND a.policy_id = b.policy_id
                      AND ((v_paramdate = 'E') OR v_paramdate = 'A')
                      AND DECODE (v_start_date,
                                  NULL, SYSDATE,
                                  a.spoiled_acct_ent_date
                                 ) >=
                             DECODE (v_start_date,
                                     NULL, SYSDATE,
                                     v_start_date
                                    )
                      AND TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') =
                                                                     v_mm_year
                      AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                      AND b.reg_policy_sw = 'Y'
                      AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                           OR (       v_exclude_mn = 'N'
                                  AND v_mn_24th_comp = '1'
                                  AND (       b.line_cd = v_mn
                                          AND (   (    v_paramdate = 'A'
                                                   AND v_mm_year IN
                                                          (v_mm_year_mn1,
                                                           v_mm_year_mn2
                                                          )
                                                  )
                                               OR (    v_paramdate = 'E'
                                                   AND v_mm_year IN
                                                          (v_mm_year_mn1,
                                                           v_mm_year_mn2
                                                          )
                                                  )
                                              )
                                       OR b.line_cd <> v_mn
                                      )
                               OR     v_mn_24th_comp = '2'
                                  AND b.line_cd = b.line_cd
                              )
                          )
                 GROUP BY b.policy_id,
                          NVL (b.cred_branch, a.iss_cd),
                          b.line_cd,
                          d.intrmdry_intm_no,
                          b.eff_date)
       --end mikel 07.17.2013
       GROUP BY iss_cd,
                line_cd,
                intm_no,
                DECODE (v_paramdate,
                        'A', p_year,
                        'E',
                        --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (eff_date))
                                     ),
                                -1, p_ext_year,
                                TO_NUMBER (TO_CHAR (eff_date, 'YYYY'))
                               )
                       ),
                DECODE (v_paramdate,
                        'A', p_mm,
                        'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (eff_date))
                                     ),
                                -1, 99,
                                TO_NUMBER (TO_CHAR (eff_date, 'MM'))
                               )
                       ),
                intm_no
           --end albert 09252013
          )
   LOOP
      UPDATE giac_deferred_comm_expense_dtl comm_exp_dtl
         SET comm_exp_dtl.comm_expense =
                                comm_exp_dtl.comm_expense + expdi.comm_expense
       WHERE comm_exp_dtl.extract_year = p_ext_year
         AND comm_exp_dtl.extract_mm = p_ext_mm
         AND comm_exp_dtl.YEAR = expdi.grp_year
         AND comm_exp_dtl.mm = expdi.grp_mm
         AND comm_exp_dtl.iss_cd = expdi.iss_cd
         AND comm_exp_dtl.line_cd = expdi.line_cd
         AND comm_exp_dtl.intm_ri = expdi.intm_no
         AND comm_exp_dtl.procedure_id = p_method;

      IF SQL%NOTFOUND
      THEN
         INSERT INTO giac_deferred_comm_expense_dtl
                     (extract_year, extract_mm, YEAR, mm,
                      iss_cd, line_cd, procedure_id,
                      comm_expense, intm_ri, user_id, last_update
                     )
              VALUES (p_ext_year, p_ext_mm, expdi.grp_year, expdi.grp_mm,
                      expdi.iss_cd, expdi.line_cd, p_method,
                      expdi.comm_expense, expdi.intm_no, USER, SYSDATE
                     );
      END IF;
   END LOOP;

   --RI extract
   FOR expri IN
      (SELECT   iss_cd, line_cd, ri_cd, SUM (comm_expense) comm_expense,
                DECODE
                   (v_paramdate,
                    'A', p_year,
                    'E',    --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                    DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                       || '-'
                                                       || p_ext_year,
                                                       'MM-YYYY'
                                                      )
                                             )
                                  - LAST_DAY (TRUNC (eff_date))
                                 ),
                            -1, p_ext_year,
                            TO_NUMBER (TO_CHAR (eff_date, 'YYYY'))
                           )
                   ) grp_year,
                DECODE
                      (v_paramdate,
                       'A', p_mm,
                       'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (eff_date))
                                    ),
                               -1, 99,
                               TO_NUMBER (TO_CHAR (eff_date, 'MM'))
                              )
                      ) grp_mm
           --FROM (SELECT NVL (b.cred_branch, a.iss_cd) iss_cd,
       FROM     (SELECT b.iss_cd,                            --albert 09242013
                                 --SELECT stmnt for unmodified commissions
                                 b.line_cd, c.ri_cd,
                        
                          /*a.ri_comm_amt
                            * DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                            * a.currency_rt comm_expense*/   -- judyann 04182008
                          a.ri_comm_amt
                        * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'),
                                  v_mm_year, -1,
                                  1
                                 )
                        * a.currency_rt comm_expense,
                        b.eff_date
                   FROM gipi_invoice a, gipi_polbasic b, giri_inpolbas c
                  WHERE a.policy_id = b.policy_id
                    AND b.policy_id = c.policy_id
                    AND ((v_paramdate = 'E'
                                           -- mildred 01292013 comment to include late booking policies
                                                    /*AND TRUNC (b.eff_date) >
                                                           LAST_DAY
                                                                  (ADD_MONTHS (TO_DATE (   p_ext_mm
                                                                                        || '-'
                                                                                        || p_ext_year,
                                                                                        'MM-YYYY'
                                                                                       ),
                                                                               -12
                                                                              )
                                                                  )*/
                                                   /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                         ) OR v_paramdate = 'A')
                    /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = v_mm_year
                         OR
                         TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = v_mm_year)*/   -- judyann 04182008
                    AND DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                     --added by mikel 07.18.2013
                     /*OR DECODE (v_start_date,
                                NULL, SYSDATE,
                                a.spoiled_acct_ent_date
                               ) >=
                           DECODE (v_start_date,
                                   NULL, SYSDATE,
                                   v_start_date
                                  )
                    --end mikel 07.18.2013
                    )*/         --commented out by albert 09252013
                    AND TO_CHAR (a.acct_ent_date, 'MM-YYYY') = v_mm_year
                     /*OR TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') =
                                                                 v_mm_year
                    )*/         --commented out by albert 09252013
                    AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                    AND b.reg_policy_sw = 'Y'
                    AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                         OR (       v_exclude_mn = 'N'
                                AND v_mn_24th_comp = '1'
                                AND (       b.line_cd = v_mn
                                        AND (   (    v_paramdate = 'A'
                                                 AND v_mm_year IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )
                                                )
                                             OR (    v_paramdate = 'E'
                                                 /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                                      -- mildred 01292013 comment to include late booking policies
                                                                                      /* AND (   TO_CHAR (b.eff_date,
                                                                                                        'MM-YYYY'
                                                                                                       ) IN
                                                                                                  (v_mm_year_mn1,
                                                                                                   v_mm_year_mn2
                                                                                                  )
                                                                                            OR TRUNC (b.eff_date) >
                                                                                                  LAST_DAY
                                                                                                     (TO_DATE
                                                                                                         (   p_ext_mm
                                                                                                          || '-'
                                                                                                          || p_ext_year,
                                                                                                          'MM-YYYY'
                                                                                                         )
                                                                                                     )
                                                                                           )*/
                                                                      -- replace with --
                                                 AND v_mm_year IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )
                                                )
                                            )
                                     OR b.line_cd <> v_mn
                                    )
                             OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                            )
                        )
                    AND NOT EXISTS (
                           SELECT 'X'
                             FROM giac_ri_comm_hist c
                            WHERE c.policy_id = b.policy_id
                              AND TO_CHAR (c.acct_ent_date, 'MM-YYYY') =
                                                                     v_mm_year
                              AND LAST_DAY (TRUNC (c.post_date)) >
                                     LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')))
                 UNION ALL
                 --SELECT stmnt for comms modified in the succeeding months
                 --SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd,
                 SELECT b.iss_cd, b.line_cd,                 --albert 09242013
                                            d.ri_cd,
                        
                          /*c.old_ri_comm_amt
                            * DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                            * a.currency_rt comm_expense*/
                          c.old_ri_comm_amt
                        * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'),
                                  v_mm_year, -1,
                                  1
                                 )
                        * a.currency_rt comm_expense,
                        b.eff_date
                   FROM gipi_invoice a,
                        giac_ri_comm_hist c,
                        gipi_polbasic b,
                        giri_inpolbas d
                  WHERE a.policy_id = b.policy_id
                    AND b.policy_id = c.policy_id
                    AND b.policy_id = d.policy_id
                    AND DECODE (v_start_date, NULL, SYSDATE, c.acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                    AND TO_CHAR (c.acct_ent_date, 'MM-YYYY') = v_mm_year
                    AND LAST_DAY (TRUNC (c.post_date)) >
                                     LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
                    AND ((v_paramdate = 'E'
                                           -- mildred 01292013 comment to include late booking policies
                                                   /* AND TRUNC (b.eff_date) >
                                                           LAST_DAY
                                                                  (ADD_MONTHS (TO_DATE (   p_ext_mm
                                                                                        || '-'
                                                                                        || p_ext_year,
                                                                                        'MM-YYYY'
                                                                                       ),
                                                                               -12
                                                                              )
                                                                  )*/
                                                   /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                         ) OR v_paramdate = 'A')
                    /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = v_mm_year
                         OR
                         TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = v_mm_year)*/   -- judyann 04182008
                    AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') = v_mm_year
                         OR TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') =
                                                                     v_mm_year
                        )
                    AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                    AND b.reg_policy_sw = 'Y'
                    AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                         OR (       v_exclude_mn = 'N'
                                AND v_mn_24th_comp = '1'
                                AND (       b.line_cd = v_mn
                                        AND (   (    v_paramdate = 'A'
                                                 AND v_mm_year IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )
                                                )
                                             OR (    v_paramdate = 'E'
                                                 /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                                      -- mildred 01292013 comment to include late booking policies
                                                                                     /*AND (   TO_CHAR (b.eff_date,
                                                                                                      'MM-YYYY'
                                                                                                     ) IN
                                                                                                (v_mm_year_mn1,
                                                                                                 v_mm_year_mn2
                                                                                                )
                                                                                          OR TRUNC (b.eff_date) >
                                                                                                LAST_DAY
                                                                                                   (TO_DATE
                                                                                                       (   p_ext_mm
                                                                                                        || '-'
                                                                                                        || p_ext_year,
                                                                                                        'MM-YYYY'
                                                                                                       )
                                                                                                   )
                                                                                         )*/
                                                                        -- replace with ---
                                                 AND v_mm_year IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )
                                                )
                                            )
                                     OR b.line_cd <> v_mn
                                    )
                             OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                            )
                        )
                    AND c.tran_id_rev =
                           (SELECT MIN (tran_id_rev)
                              FROM giac_ri_comm_hist d
                             WHERE d.policy_id = b.policy_id
                               AND TO_CHAR (d.acct_ent_date, 'MM-YYYY') =
                                                                     v_mm_year
                               AND LAST_DAY (TRUNC (d.post_date)) >
                                      LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')))
                 UNION ALL
                 --SELECT stmnt for comms modified within selected month
                 --SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd,
                 SELECT b.iss_cd, b.line_cd,                 --albert 09242013
                                            d.ri_cd,
                        
                          /*c.new_ri_comm_amt
                            * DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                            * a.currency_rt comm_expense*/   -- judyann 04182008
                          c.new_ri_comm_amt
                        * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'),
                                  v_mm_year, -1,
                                  1
                                 )
                        * a.currency_rt comm_expense,
                        b.eff_date
                   FROM gipi_invoice a,
                        giac_ri_comm_hist c,
                        gipi_polbasic b,
                        giri_inpolbas d
                  WHERE a.policy_id = b.policy_id
                    AND b.policy_id = c.policy_id
                    AND b.policy_id = d.policy_id
                    AND DECODE (v_start_date, NULL, SYSDATE, b.acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                    AND TO_CHAR (c.post_date, 'MM-YYYY') = v_mm_year
                    AND ((v_paramdate = 'E'
                                           -- mildred 01292013 comment to include late booking policies
                                                   /* AND TRUNC (b.eff_date) >
                                                           LAST_DAY
                                                                  (ADD_MONTHS (TO_DATE (   p_ext_mm
                                                                                        || '-'
                                                                                        || p_ext_year,
                                                                                        'MM-YYYY'
                                                                                       ),
                                                                               -12
                                                                              )
                                                                  )*/
                                                   /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                         ) OR v_paramdate = 'A')
                    AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                    AND b.reg_policy_sw = 'Y'
                    AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                         OR (       v_exclude_mn = 'N'
                                AND v_mn_24th_comp = '1'
                                AND (       b.line_cd = v_mn
                                        AND (   (    v_paramdate = 'A'
                                                 AND v_mm_year IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )
                                                )
                                             OR (    v_paramdate = 'E'
                                                 /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                                      -- mildred 01292013 comment to include late booking policies
                                                                               /*AND (   TO_CHAR (b.eff_date,
                                                                                                'MM-YYYY'
                                                                                               ) IN
                                                                                          (v_mm_year_mn1,
                                                                                           v_mm_year_mn2
                                                                                          )
                                                                                    OR TRUNC (b.eff_date) >
                                                                                          LAST_DAY
                                                                                             (TO_DATE
                                                                                                 (   p_ext_mm
                                                                                                  || '-'
                                                                                                  || p_ext_year,
                                                                                                  'MM-YYYY'
                                                                                                 )
                                                                                             )
                                                                                   )*/
                                                                      -- replace with --
                                                 AND v_mm_year IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )
                                                )
                                            )
                                     OR b.line_cd <> v_mn
                                    )
                             OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                            )
                        )
                    AND c.tran_id =
                           (SELECT MAX (tran_id)
                              FROM giac_ri_comm_hist d
                             WHERE d.policy_id = b.policy_id
                               AND TO_CHAR (d.post_date, 'MM-YYYY') =
                                                                     v_mm_year))
       GROUP BY iss_cd,
                line_cd,
                ri_cd,
                DECODE (v_paramdate,
                        'A', p_year,
                        'E',
                        --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (eff_date))
                                     ),
                                -1, p_ext_year,
                                TO_NUMBER (TO_CHAR (eff_date, 'YYYY'))
                               )
                       ),
                DECODE (v_paramdate,
                        'A', p_mm,
                        'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (eff_date))
                                     ),
                                -1, 99,
                                TO_NUMBER (TO_CHAR (eff_date, 'MM'))
                               )
                       )
       UNION ALL
       --albert 09252013, to handle spoiled policies
       SELECT   iss_cd, line_cd, ri_cd, SUM (comm_expense) comm_expense,
                DECODE
                   (v_paramdate,
                    'A', p_year,
                    'E',    --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                    DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                       || '-'
                                                       || p_ext_year,
                                                       'MM-YYYY'
                                                      )
                                             )
                                  - LAST_DAY (TRUNC (eff_date))
                                 ),
                            -1, p_ext_year,
                            TO_NUMBER (TO_CHAR (eff_date, 'YYYY'))
                           )
                   ) grp_year,
                DECODE
                      (v_paramdate,
                       'A', p_mm,
                       'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                       DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         )
                                                )
                                     - LAST_DAY (TRUNC (eff_date))
                                    ),
                               -1, 99,
                               TO_NUMBER (TO_CHAR (eff_date, 'MM'))
                              )
                      ) grp_mm
           --FROM (SELECT NVL (b.cred_branch, a.iss_cd) iss_cd,
       FROM     (SELECT b.iss_cd,                            --albert 09242013
                                 --SELECT stmnt for unmodified commissions
                                 b.line_cd, c.ri_cd,
                        
                          /*a.ri_comm_amt
                            * DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
                            * a.currency_rt comm_expense*/   -- judyann 04182008
                          a.ri_comm_amt
                        * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'),
                                  v_mm_year, -1,
                                  1
                                 )
                        * a.currency_rt comm_expense,
                        b.eff_date
                   FROM gipi_invoice a, gipi_polbasic b, giri_inpolbas c
                  WHERE a.policy_id = b.policy_id
                    AND b.policy_id = c.policy_id
                    AND ((v_paramdate = 'E'
                                           -- mildred 01292013 comment to include late booking policies
                                                    /*AND TRUNC (b.eff_date) >
                                                           LAST_DAY
                                                                  (ADD_MONTHS (TO_DATE (   p_ext_mm
                                                                                        || '-'
                                                                                        || p_ext_year,
                                                                                        'MM-YYYY'
                                                                                       ),
                                                                               -12
                                                                              )
                                                                  )*/
                                                   /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
                         ) OR v_paramdate = 'A')
                    /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = v_mm_year
                         OR
                         TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = v_mm_year)*/   -- judyann 04182008
                    AND DECODE (v_start_date,
                                NULL, SYSDATE,
                                a.spoiled_acct_ent_date
                               ) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                    --end mikel 07.18.2013
                    AND TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') =
                                                                     v_mm_year
                    AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                    AND b.reg_policy_sw = 'Y'
                    AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
                         OR (       v_exclude_mn = 'N'
                                AND v_mn_24th_comp = '1'
                                AND (       b.line_cd = v_mn
                                        AND (   (    v_paramdate = 'A'
                                                 AND v_mm_year IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )
                                                )
                                             OR (    v_paramdate = 'E'
                                                 /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
                                                                      -- mildred 01292013 comment to include late booking policies
                                                                                      /* AND (   TO_CHAR (b.eff_date,
                                                                                                        'MM-YYYY'
                                                                                                       ) IN
                                                                                                  (v_mm_year_mn1,
                                                                                                   v_mm_year_mn2
                                                                                                  )
                                                                                            OR TRUNC (b.eff_date) >
                                                                                                  LAST_DAY
                                                                                                     (TO_DATE
                                                                                                         (   p_ext_mm
                                                                                                          || '-'
                                                                                                          || p_ext_year,
                                                                                                          'MM-YYYY'
                                                                                                         )
                                                                                                     )
                                                                                           )*/
                                                                      -- replace with --
                                                 AND v_mm_year IN
                                                        (v_mm_year_mn1,
                                                         v_mm_year_mn2
                                                        )
                                                )
                                            )
                                     OR b.line_cd <> v_mn
                                    )
                             OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
                            )
                        )
                    AND NOT EXISTS (
                           SELECT 'X'
                             FROM giac_ri_comm_hist c
                            WHERE c.policy_id = b.policy_id
                              AND TO_CHAR (c.acct_ent_date, 'MM-YYYY') =
                                                                     v_mm_year
                              AND LAST_DAY (TRUNC (c.post_date)) >
                                     LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))))
       GROUP BY iss_cd,
                line_cd,
                ri_cd,
                DECODE (v_paramdate,
                        'A', p_year,
                        'E',
                        --TO_NUMBER(TO_CHAR(b.eff_date,'YYYY'))) grp_year,
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (eff_date))
                                     ),
                                -1, p_ext_year,
                                TO_NUMBER (TO_CHAR (eff_date, 'YYYY'))
                               )
                       ),
                DECODE (v_paramdate,
                        'A', p_mm,
                        'E',
--TO_NUMBER(TO_CHAR(b.eff_date,'MM'))) grp_mm commented by alfie: 06/30/2011: to add a row for advance booking policies
                        DECODE (SIGN (  LAST_DAY (TO_DATE (   p_ext_mm
                                                           || '-'
                                                           || p_ext_year,
                                                           'MM-YYYY'
                                                          )
                                                 )
                                      - LAST_DAY (TRUNC (eff_date))
                                     ),
                                -1, 99,
                                TO_NUMBER (TO_CHAR (eff_date, 'MM'))
                               )
                       )
                        --end albert 09252013
      )
   LOOP
      UPDATE giac_deferred_comm_expense_dtl comm_exp_dtl
         SET comm_exp_dtl.comm_expense =
                                comm_exp_dtl.comm_expense + expri.comm_expense
       WHERE comm_exp_dtl.extract_year = p_ext_year
         AND comm_exp_dtl.extract_mm = p_ext_mm
         AND comm_exp_dtl.YEAR = expri.grp_year
         AND comm_exp_dtl.mm = expri.grp_mm
         AND comm_exp_dtl.iss_cd = expri.iss_cd
         AND comm_exp_dtl.line_cd = expri.line_cd
         AND comm_exp_dtl.intm_ri = expri.ri_cd
         AND comm_exp_dtl.procedure_id = p_method;

      IF SQL%NOTFOUND
      THEN
         INSERT INTO giac_deferred_comm_expense_dtl
                     (extract_year, extract_mm, YEAR, mm,
                      iss_cd, line_cd, procedure_id,
                      comm_expense, intm_ri, user_id, last_update
                     )
              VALUES (p_ext_year, p_ext_mm, expri.grp_year, expri.grp_mm,
                      expri.iss_cd, expri.line_cd, p_method,
                      expri.comm_expense, expri.ri_cd, USER, SYSDATE
                     );
      END IF;
   END LOOP;
/* mikel 07.16.2013; para lang malinis ung nasa taas na codes.. =)
*/
--   SELECT NVL (b.cred_branch, a.iss_cd) iss_cd,
--                                     --SELECT stmnt for unmodified commissions
--                                                             b.line_cd,
--                        d.intrmdry_intm_no intm_no,
--
--                          /*d.commission_amt
--                            * DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
--                            * a.currency_rt comm_expense*/   -- judyann 04182008
--                          d.commission_amt
--                        * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'),
--                                  v_mm_year, -1,
--                                  1
--                                 )
--                        * a.currency_rt comm_expense,
--                        b.eff_date
--                   FROM GIPI_INVOICE a, GIPI_POLBASIC b, GIPI_COMM_INVOICE d
--                  WHERE a.iss_cd = d.iss_cd
--                    AND a.prem_seq_no = d.prem_seq_no
--                    AND a.policy_id = d.policy_id
--                    AND a.policy_id = b.policy_id
--                    AND (   (    v_paramdate = 'E'
--                    --  mildred 01292013 comment to include late booking policies
--                             /*AND TRUNC (b.eff_date) >
--                                    LAST_DAY
--                                           (ADD_MONTHS (TO_DATE (   p_ext_mm
--                                                                 || '-'
--                                                                 || p_ext_year,
--                                                                 'MM-YYYY'
--                                                                ),
--                                                        -12
--                                                       )
--                                           )*/
--                            /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
--                            )
--                         OR v_paramdate = 'A'
--                        )
--                    /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = v_mm_year
--                         OR
--                         TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = v_mm_year)*/   -- judyann 04182008
--                    AND (   DECODE (v_start_date,
--                                    NULL, SYSDATE,
--                                    a.acct_ent_date
--                                   ) >=
--                               DECODE (v_start_date,
--                                       NULL, SYSDATE,
--                                       v_start_date
--                                      )
--                         OR DECODE (v_start_date,
--                                    NULL, SYSDATE,
--                                    a.spoiled_acct_ent_date
--                                   ) >=
--                               DECODE (v_start_date,
--                                       NULL, SYSDATE,
--                                       v_start_date
--                                      )
--                        )
--                    AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') = v_mm_year
--                         OR TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') =
--                                                                     v_mm_year
--                        )
--                    AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
--                    AND b.reg_policy_sw = 'Y'
--                    AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
--                         OR (       v_exclude_mn = 'N'
--                                AND v_mn_24th_comp = '1'
--                                AND (       b.line_cd = v_mn
--                                        AND (   (    v_paramdate = 'A'
--                                                 AND v_mm_year IN
--                                                        (v_mm_year_mn1,
--                                                         v_mm_year_mn2
--                                                        )
--                                                )
--                                             OR (    v_paramdate =
--                                                        'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
--                                --  mildred 01292013 comment to include late booking policies
--                                                /* AND (   TO_CHAR (b.eff_date,
--                                                                  'MM-YYYY'
--                                                                 ) IN
--                                                            (v_mm_year_mn1,
--                                                             v_mm_year_mn2
--                                                            )
--                                                      OR TRUNC (b.eff_date) >
--                                                            LAST_DAY
--                                                               (TO_DATE
--                                                                   (   p_ext_mm
--                                                                    || '-'
--                                                                    || p_ext_year,
--                                                                    'MM-YYYY'
--                                                                   )
--                                                               )
--                                                     )*/
--                                   -- replace with --
--                                                  AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)
--                                                )
--                                            )
--                                     OR b.line_cd <> v_mn
--                                    )
--                             OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
--                            )
--                        )
--                    AND NOT EXISTS (
--                           SELECT 'X'
--                             FROM GIAC_PREV_COMM_INV g, GIAC_NEW_COMM_INV h
--                            WHERE g.fund_cd = h.fund_cd
--                              AND g.branch_cd = h.branch_cd
--                              AND g.comm_rec_id = h.comm_rec_id
--                              AND g.intm_no = h.intm_no
--                              AND TO_CHAR (g.acct_ent_date, 'MM-YYYY') = v_mm_year
--                              AND h.acct_ent_date >
--                                     LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
--                              AND h.tran_flag = 'P'
--                              AND h.iss_cd = d.iss_cd
--                              AND h.prem_seq_no = d.prem_seq_no
--                              AND DECODE (v_start_date,
--                                          NULL, SYSDATE,
--                                          h.acct_ent_date
--                                         ) >=
--                                     DECODE (v_start_date,
--                                             NULL, SYSDATE,
--                                             v_start_date
--                                            ))
--                 UNION ALL
--                 --SELECT stmnt for comms modified in the succeeding months
--                 SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd,
--                        c.intm_no,
--
--                          /*c.commission_amt
--                            * DECODE(TO_CHAR(b.spld_acct_ent_date,'MM-YYYY'), v_mm_year, -1, 1)
--                            * a.currency_rt comm_expense*/    -- judyann 04182008
--                          c.commission_amt
--                        * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'),
--                                  v_mm_year, -1,
--                                  1
--                                 )
--                        * a.currency_rt comm_expense,
--                        b.eff_date
--                   FROM GIPI_INVOICE a,
--                        GIPI_POLBASIC b,
--                        GIAC_PREV_COMM_INV c,
--                        GIAC_NEW_COMM_INV d
--                  WHERE a.policy_id = b.policy_id
--                    AND a.iss_cd = d.iss_cd
--                    AND a.prem_seq_no = d.prem_seq_no
--                    AND a.policy_id = d.policy_id
--                    AND (   (    v_paramdate = 'E'
--                    --  mildred 01292013 comment to include late booking policies
--                            /* AND TRUNC (b.eff_date) >
--                                    LAST_DAY
--                                           (ADD_MONTHS (TO_DATE (   p_ext_mm
--                                                                 || '-'
--                                                                 || p_ext_year,
--                                                                 'MM-YYYY'
--                                                                ),
--                                                        -12
--                                                       )
--                                           )*/
--                            /*AND TRUNC(b.eff_date) BETWEEN ADD_MONTHS(TO_DATE(p_ext_mm||'-'||p_ext_year,'MM-YYYY'),-11) AND LAST_DAY(TO_DATE(v_mm_year,'MM-YYYY'))*/
--                            )
--                         OR v_paramdate = 'A'
--                        )
--                    /*AND (TO_CHAR(b.acct_ent_date,'MM-YYYY') = v_mm_year
--                         OR
--                         TO_CHAR(b.spld_acct_ent_date,'MM-YYYY') = v_mm_year)*/   -- judyann 04182008
--                    AND (   DECODE (v_start_date,
--                                    NULL, SYSDATE,
--                                    a.acct_ent_date
--                                   ) >=
--                               DECODE (v_start_date,
--                                       NULL, SYSDATE,
--                                       v_start_date
--                                      )
--                         OR DECODE (v_start_date,
--                                    NULL, SYSDATE,
--                                    a.spoiled_acct_ent_date
--                                   ) >=
--                               DECODE (v_start_date,
--                                       NULL, SYSDATE,
--                                       v_start_date
--                                      )
--                        )
--                    AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') = v_mm_year
--                         OR TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') =
--                                                                     v_mm_year
--                        )
--                    AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
--                    AND b.reg_policy_sw = 'Y'
--                    AND (   (v_exclude_mn = 'Y' AND b.line_cd <> v_mn)
--                         OR (       v_exclude_mn = 'N'
--                                AND v_mn_24th_comp = '1'
--                                AND (       b.line_cd = v_mn
--                                        AND (   (    v_paramdate = 'A'
--                                                 AND v_mm_year IN
--                                                        (v_mm_year_mn1,
--                                                         v_mm_year_mn2
--                                                        )
--                                                )
--                                             OR (    v_paramdate =
--                                                        'E' /*AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)*/
--                                             -- mildred 01292013 to include late booking
--                                                 /*AND (   TO_CHAR (b.eff_date,
--                                                                  'MM-YYYY'
--                                                                 ) IN
--                                                            (v_mm_year_mn1,
--                                                             v_mm_year_mn2
--                                                            )
--                                                      OR TRUNC (b.eff_date) >
--                                                            LAST_DAY
--                                                               (TO_DATE
--                                                                   (   p_ext_mm
--                                                                    || '-'
--                                                                    || p_ext_year,
--                                                                    'MM-YYYY'
--                                                                   )
--                                                               )
--                                                     )*/
--                                             AND v_mm_year IN (v_mm_year_mn1,v_mm_year_mn2)
--                                                )
--                                            )
--                                     OR b.line_cd <> v_mn
--                                    )
--                             OR v_mn_24th_comp = '2' AND b.line_cd = b.line_cd
--                            )
--                        )
--                    AND c.fund_cd = d.fund_cd
--                    AND c.branch_cd = d.branch_cd
--                    AND c.comm_rec_id = d.comm_rec_id
--                    AND c.intm_no = d.intm_no
--                    AND TO_CHAR (c.acct_ent_date, 'MM-YYYY') = v_mm_year
--                    AND d.acct_ent_date >
--                                     LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
--                    --AND d.acct_ent_date >
--                    --       LAST_DAY (TO_DATE (p_ext_mm || '-' || p_ext_year,
--                    --                         'MM-YYYY'
--                    --                         )
--                    --                )
--                    AND d.tran_flag = 'P'
--                    AND c.comm_rec_id =
--                           (SELECT MIN (g.comm_rec_id)
--                              FROM GIAC_PREV_COMM_INV g, GIAC_NEW_COMM_INV h
--                             WHERE g.fund_cd = h.fund_cd
--                               AND g.branch_cd = h.branch_cd
--                               AND g.comm_rec_id = h.comm_rec_id
--                               AND g.intm_no = h.intm_no --mikel 07.16.2013
--                               --AND TO_CHAR (g.acct_ent_date, 'MM-YYYY') = v_mm_year --mikel 07.16.2013
--                               AND h.acct_ent_date >--= --mikel 07.12.2013; added =
--                                      LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
--                               AND h.tran_flag = 'P'
--                               AND NVL(h.delete_sw, 'N') = 'N' --mikel 07.16.2013
--                               AND h.iss_cd = d.iss_cd
--                               AND h.prem_seq_no = d.prem_seq_no
--                               AND DECODE (v_start_date,
--                                          NULL, SYSDATE,
--                                          h.acct_ent_date
--                                         ) >=
--                                     DECODE (v_start_date,
--                                             NULL, SYSDATE,
--                                             v_start_date
--                                            ) --mikel 07.16.2013
--                               --AND h.intm_no = d.intm_no COMMENTED BY ALFIE TO INCLUDE CHANGE INTERMEDIARY : 08/31/2011
--                               )
END deferred_extract2_dtl;
/



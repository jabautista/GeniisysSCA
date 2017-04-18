CREATE OR REPLACE PROCEDURE CPI.deferred_extract3 (
   p_year     NUMBER,
   p_mm       NUMBER,
   p_method   NUMBER
)
IS
   v_exists        NUMBER;
   v_month         NUMBER;
   --v_def_comm_entry   VARCHAR2 (1) := giacp.v ('DEF_COMM_PROD_ENTRY');
   v_start_date    DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   v_year          NUMBER;
   v_user_id       VARCHAR2 (8) := NVL (giis_users_pkg.app_user, USER);
               --added by Gzelle 05.31.2013, replaced all USER with v_user_id
   v_24th_comp     VARCHAR2 (1) := NVL(giacp.v ('24TH_METHOD_DEF_COMP'), 'Y'); --test mikel 02.04.2016
   
   v_max_cnt       NUMBER;  --ben 01182016
   
   invalid_month   EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_month, -1843);
/*
** Created by:   Mikel
** Date Created: 08.28.2012
** Description:  Extracts detailed data required for the daily computation of 1/365 Method
*/
BEGIN
   IF v_24th_comp = 'Y'
   THEN
      v_exists := 0;

      /* Check for previous extract */
      FOR chk IN (SELECT gen_tag
                    FROM giac_deferred_extract
                   WHERE YEAR = p_year
                     AND mm = p_mm
                     AND procedure_id = p_method
                     AND comp_sw = 'Y')               -- Added by FJ 9/16/2014
      LOOP
         --delete records from main tables
         DELETE FROM giac_deferred_gross_prem
               WHERE YEAR = p_year
                 AND mm = p_mm
                 AND procedure_id = p_method
                 AND comp_sw = 'Y';                   --added by fj 9/22/2014;

         DELETE FROM giac_deferred_ri_prem_ceded
               WHERE YEAR = p_year
                 AND mm = p_mm
                 AND procedure_id = p_method
                 AND comp_sw = 'Y';                   --added by fj 9/22/2014;

         DELETE FROM giac_deferred_comm_income
               WHERE YEAR = p_year
                 AND mm = p_mm
                 AND procedure_id = p_method
                 AND comp_sw = 'Y';                   --added by fj 9/22/2014;

         DELETE FROM giac_deferred_comm_expense
               WHERE YEAR = p_year
                 AND mm = p_mm
                 AND procedure_id = p_method
                 AND comp_sw = 'Y';                   --added by fj 9/22/2014;

         /* Delete previous extract if records have been extracted before */
         DELETE FROM giac_deferred_gross_prem_pol
               WHERE extract_year = p_year
                 AND extract_mm = p_mm
                 AND procedure_id = p_method
                 AND comp_sw = 'Y';                   --added by fj 9/22/2014;

         DELETE FROM giac_deferred_ri_prem_cede_pol
               WHERE extract_year = p_year
                 AND extract_mm = p_mm
                 AND procedure_id = p_method
                 AND comp_sw = 'Y';                   --added by fj 9/22/2014;

         DELETE FROM giac_deferred_comm_income_pol
               WHERE extract_year = p_year
                 AND extract_mm = p_mm
                 AND procedure_id = p_method
                 AND comp_sw = 'Y';                   --added by fj 9/22/2014;

         DELETE FROM giac_deferred_comm_expense_pol
               WHERE extract_year = p_year
                 AND extract_mm = p_mm
                 AND procedure_id = p_method
                 AND comp_sw = 'Y';                   --added by fj 9/22/2014;

         v_exists := 1;
         EXIT;
      END LOOP;

      IF v_exists = 0
      THEN
         INSERT INTO giac_deferred_extract
                     (YEAR, mm, procedure_id, gen_tag, user_id,
                      last_extract, comp_sw
                     )                        -- added comp_sw by fj 9/22/2014
              VALUES (p_year, p_mm, p_method, 'N', v_user_id,
                      SYSDATE, 'Y'
                     );
      ELSE
         UPDATE giac_deferred_extract
            SET gen_tag = 'N',
                user_id = v_user_id,
                last_extract = SYSDATE,
                last_compute = NULL,
                comp_sw = 'Y'                 -- added comp_sw by fj 9/22/2014
          WHERE YEAR = p_year
            AND mm = p_mm
            AND procedure_id = p_method
            AND comp_sw = 'Y';                -- added comp_sw by fj 9/22/2014
      END IF;

      BEGIN
         --start of modification by ben 01182016
         /*--commented out by ben, replaced by below scripts
         v_month :=
            SUBSTR (TO_CHAR (ADD_MONTHS (TO_DATE (p_mm || '-' || p_year,
                                                  'MM-YYYY'
                                                 ),
                                         -11
                                        ),
                             'mm-yyyy'
                            ),
                    1,
                    2
                   );
         v_year :=
            SUBSTR (TO_CHAR (ADD_MONTHS (TO_DATE (p_mm || '-' || p_year,
                                                  'MM-YYYY'
                                                 ),
                                         -11
                                        ),
                             'mm-yyyy'
                            ),
                    4,
                    4
                   );
         */
         
         --to properly get all unearned premiums starting from 24TH_METHOD_START_DATE until the extraction date
         v_month :=
            SUBSTR (TO_CHAR (v_start_date,
                             'mm-yyyy'
                            ),
                    1,
                    2
                   );
                   
         v_year :=
            SUBSTR (TO_CHAR (v_start_date,
                             'mm-yyyy'
                            ),
                    4,
                    4
                   );
          
         v_max_cnt := TRUNC(MONTHS_BETWEEN  (TO_DATE (p_mm || '-' || p_year, 'MM-YYYY'), v_start_date )) + 2;
         
         FOR rec IN 1 .. v_max_cnt  --changed fro 13 to computed v_max_count
         --end of modification by ben 01812016
         LOOP
            IF v_month = 13
            THEN
               v_month := 1;
               v_year := v_year + 1;
            END IF;

            IF v_start_date <=
                    LAST_DAY (TO_DATE (v_month || '-' || (v_year), 'MM-YYYY'))
            THEN
               IF v_month > p_mm AND v_year = p_year
               THEN
                  EXIT;
               ELSIF v_year > p_year
               THEN
                  EXIT;
               ELSE
                  deferred_extract3_dtl (p_year,
                                         p_mm,
                                         v_year,
                                         v_month,
                                         p_method
                                        );
               END IF;
            END IF;

            v_month := v_month + 1;
         END LOOP;
      END;

      --END IF;

      -- --to extract policies from prior acct ent date
      -- IF Giacp.v('24TH_METHOD_PARAMDATE') = 'E' THEN
       --    IF v_start_date <= LAST_DAY(TO_DATE(p_mm||'-'||(p_year),'MM-YYYY')) THEN
       --      deferred_extract365_prior_dtl(p_year,p_mm, p_year, 99, p_method);
       --    END IF;
       --END IF;

      /* insert records in detail tables to the main tables */
      FOR gross IN (SELECT   iss_cd, line_cd, SUM (prem_amt) prem_amt
                        FROM giac_deferred_gross_prem_pol
                       WHERE extract_year = p_year
                         AND extract_mm = p_mm
                         AND procedure_id = p_method
                         AND comp_sw = 'Y'    -- added comp_sw by fj 9/22/2014
                    GROUP BY iss_cd, line_cd)
      LOOP
         INSERT INTO giac_deferred_gross_prem
                     (YEAR, mm, iss_cd, line_cd, procedure_id,
                      prem_amt, user_id, last_update,
                      comp_sw                 -- added comp_sw by fj 9/22/2014
                     )
              VALUES (p_year, p_mm, gross.iss_cd, gross.line_cd, p_method,
                      gross.prem_amt, v_user_id, SYSDATE,
                      'Y'
                     );
      END LOOP;

      FOR ri_prem IN (SELECT   iss_cd, line_cd, share_type, acct_trty_type,
                               SUM (dist_prem) dist_prem
                          FROM giac_deferred_ri_prem_cede_pol
                         WHERE extract_year = p_year
                           AND extract_mm = p_mm
                           AND procedure_id = p_method
                           AND comp_sw = 'Y'  -- added comp_sw by fj 9/22/2014
                      GROUP BY iss_cd, line_cd, share_type, acct_trty_type)
      LOOP
         INSERT INTO giac_deferred_ri_prem_ceded
                     (YEAR, mm, iss_cd, line_cd,
                      procedure_id, share_type, acct_trty_type,
                      dist_prem, user_id, last_update,
                      comp_sw                 -- added comp_sw by fj 9/22/2014
                     )
              VALUES (p_year, p_mm, ri_prem.iss_cd, ri_prem.line_cd,
                      p_method, ri_prem.share_type, ri_prem.acct_trty_type,
                      ri_prem.dist_prem, v_user_id, SYSDATE,
                      'Y'                     -- added comp_sw by fj 9/22/2014
                     );
      END LOOP;

      FOR comm IN (SELECT   iss_cd, line_cd, share_type, acct_trty_type,
                            ri_cd, SUM (comm_income) comm_income
                       FROM giac_deferred_comm_income_pol
                      WHERE extract_year = p_year
                        AND extract_mm = p_mm
                        AND procedure_id = p_method
                        AND comp_sw = 'Y'     -- added comp_sw by fj 9/22/2014
                   GROUP BY iss_cd, line_cd, share_type, acct_trty_type,
                            ri_cd)
      LOOP
         INSERT INTO giac_deferred_comm_income
                     (YEAR, mm, iss_cd, line_cd, procedure_id,
                      share_type, acct_trty_type, ri_cd,
                      comm_income, user_id, last_update,
                      comp_sw                 -- added comp_sw by fj 9/22/2014
                     )
              VALUES (p_year, p_mm, comm.iss_cd, comm.line_cd, p_method,
                      comm.share_type, comm.acct_trty_type, comm.ri_cd,
                      comm.comm_income, v_user_id, SYSDATE,
                      'Y'                     -- added comp_sw by fj 9/22/2014
                     );
      END LOOP;

      FOR expen IN (SELECT   iss_cd, line_cd, intm_ri,
                             SUM (comm_expense) comm_expense
                        FROM giac_deferred_comm_expense_pol
                       WHERE extract_year = p_year
                         AND extract_mm = p_mm
                         AND procedure_id = p_method
                         AND comp_sw = 'Y'    -- added comp_sw by fj 9/22/2014
                    GROUP BY iss_cd, line_cd, intm_ri)
      LOOP
         INSERT INTO giac_deferred_comm_expense
                     (YEAR, mm, iss_cd, line_cd,
                      intm_ri, procedure_id, comm_expense,
                      user_id, last_update,
                      comp_sw                 -- added comp_sw by fj 9/22/2014
                     )
              VALUES (p_year, p_mm, expen.iss_cd, expen.line_cd,
                      expen.intm_ri, p_method, expen.comm_expense,
                      v_user_id, SYSDATE,
                      'Y'                     -- added comp_sw by fj 9/22/2014
                     );
      END LOOP;
---------------------------------------------------------------------------------------------------------------------
   END IF;
END deferred_extract3;
/
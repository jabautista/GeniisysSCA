CREATE OR REPLACE PACKAGE BODY CPI.giacr101_pkg
AS
   FUNCTION populate_giacr101 (
      p_from_date     DATE,
      p_to_date       DATE,
      p_module_id     VARCHAR2,
      p_user_id       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_branch_type   VARCHAR2
   )
      RETURN giacr101_tab PIPELINED
   AS
      v_rec           giacr101_type;
      v_not_exist     BOOLEAN       := TRUE;
      v_other_taxes   NUMBER;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_add := giacp.v ('COMPANY_ADDRESS');
      v_rec.date_range :=
            'From '
         || ' '
         || (   TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
             || ' to '
             || TO_CHAR (p_to_date, 'fmMonth DD, YYYY')
            );

      FOR i IN
         (SELECT   gi.iss_cd iss_cd1, gi.iss_name iss_name,
                   gp.policy_id policy_id, gp.line_cd line_cd,
                   gp.subline_cd subline_cd,
                   DECODE (p_branch_type,
                           1, gp.cred_branch,
                           gp.iss_cd
                          ) iss_cd, gp.issue_yy issue_yy,
                   gp.pol_seq_no pol_seq_no, gp.renew_no renew_no,
                   gp.endt_iss_cd endt_iss_cd, gp.endt_yy endt_yy,
                   gp.endt_seq_no endt_seq_no, gp.incept_date incept_date,
                   gp.expiry_date expiry_date, gl.line_name line_name,
                   gs.subline_name subline_name, gp.tsi_amt tsi_amt,
                   gp.prem_amt prem_amt, giv.acct_ent_date acct_ent_date,
                   SUM (  DECODE (gpr.param_name, 'EVAT', git.tax_amt, 0)
                        * giv.currency_rt
                       ) evat,
                   SUM (  DECODE (gpr.param_name, 'PREM_TAX', git.tax_amt, 0)
                        * giv.currency_rt
                       ) prem_tax,
                   SUM (  DECODE (gpr.param_name, 'FST', git.tax_amt, 0)
                        * giv.currency_rt
                       ) fst,
                   SUM (  DECODE (gpr.param_name, 'LGT', git.tax_amt, 0)
                        * giv.currency_rt
                       ) lgt,
                   SUM (  DECODE (gpr.param_name,
                                  'DOC_STAMPS', git.tax_amt,
                                  0
                                 )
                        * giv.currency_rt
                       ) doc_stamps
              FROM giis_issource gi,                -- added by Joy 01/09/2001
                   gipi_polbasic gp,
                   giis_line gl,
                   giis_subline gs,
                   giac_parameters gpr,
                   gipi_inv_tax git,
                   gipi_invoice giv
             WHERE gp.line_cd = gl.line_cd
               AND gp.iss_cd = gi.iss_cd            -- added by Joy 01/09/2001
               AND gp.subline_cd = gs.subline_cd
               AND gl.line_cd = gs.line_cd
               AND gp.policy_id = giv.policy_id
               AND giv.iss_cd = git.iss_cd(+)
               AND giv.prem_seq_no = git.prem_seq_no(+)
               AND git.tax_cd = gpr.param_value_n(+)
               --AND GP.POLICY_ID = 21509
               AND DECODE (gp.iss_cd, 'BB', 0, 'RI', 0, 1) = 1
               AND (TRUNC (giv.acct_ent_date)
                                             /*Modified gp.acct_ent_date by Jonan 05/06/2008*/
                    BETWEEN p_from_date AND p_to_date
                   )
     /*added by Liezl A. 07-13-2001*/
/*AND (((TRUNC(gp.acct_ent_date) BETWEEN :MISC.FROM_DATE AND :MISC.TO_DATE)
      AND (TRUNC(gp.spld_acct_ent_date) BETWEEN :MISC.FROM_DATE AND :MISC.TO_DATE))
    OR (TRUNC(gp.acct_ent_date) BETWEEN :MISC.FROM_DATE AND :MISC.TO_DATE))*/
               AND gi.iss_cd = NVL (p_iss_cd, gi.iss_cd)
               /*by LIEZL A. 07/12/2001*/
               AND check_user_per_iss_cd_acctg2 (NULL,
                                                 gi.iss_cd,
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1
               --added by reymon 05282012
               AND gl.line_cd = NVL (p_line_cd, gl.line_cd)
               /*by LIEZL A. 07/12/2001*/
               AND gs.subline_cd = NVL (p_subline_cd, gs.subline_cd)
               /*by LIEZL A. 07/12/2001*/
               AND DECODE (p_branch_type, 1, gp.cred_branch, gp.iss_cd) =
                      DECODE (p_branch_type,
                              1, NVL (gp.cred_branch, gp.iss_cd),
                              NVL (p_iss_cd, gp.iss_cd)
                             )                                   --rutty081607
               AND check_user_per_iss_cd_acctg2 (NULL,
                                                 DECODE (p_branch_type,
                                                         1, gp.cred_branch,
                                                         gp.iss_cd
                                                        ),
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1
          --added by reymon 05282012
          GROUP BY gi.iss_cd,
                   gi.iss_name,
                   gp.policy_id,
                   gp.line_cd,
                   gp.subline_cd,
                   DECODE (p_branch_type, 1, gp.cred_branch, gp.iss_cd),
                   --gp.iss_cd, changed by reymon 05282012
                   gp.issue_yy,
                   gp.pol_seq_no,
                   gp.renew_no,
                   gp.endt_iss_cd,
                   gp.endt_yy,
                   gp.endt_seq_no,
                   gp.incept_date,
                   gp.expiry_date,
                   gl.line_name,
                   gs.subline_name,
                   gp.tsi_amt,
                   gp.prem_amt,
                   giv.acct_ent_date
          --Modified gp.acct_ent_date by Jonan 05/06/2008
          UNION ALL                                 --addded by Joy 01/15/2001
          SELECT   gi.iss_cd gi_iss_cd,             -- added by Joy 01/09/2001
                                       gi.iss_name gi_iss_name,
                   
                   -- added by Joy 01/09/2001
                   gp.policy_id gp_policy_id, gp.line_cd gp_line_cd,
                   gp.subline_cd gp_subline_cd,
                   DECODE (p_branch_type,
                           1, gp.cred_branch,
                           gp.iss_cd
                          ) gp_iss_cd,
                   gp.issue_yy gp_issue_yy, gp.pol_seq_no gp_pol_seq_no,
                   gp.renew_no gp_renew_no, gp.endt_iss_cd gp_endt_iss_cd,
                   gp.endt_yy gp_endt_yy, gp.endt_seq_no gp_endt_seq_no,
                   gp.incept_date gp_incept_date,
                   gp.expiry_date gp_expiry_date, gl.line_name gl_line_name,
                   gs.subline_name gs_subline_name,
                   DECODE (gp.pol_flag,
                           TO_CHAR (5), (gp.tsi_amt) * (-1),
                           gp.tsi_amt
                          ) gp_tsi_amt,                    --by joy 01/08/2001
                   DECODE (gp.pol_flag,
                           TO_CHAR (5), (gp.prem_amt) * (-1),
                           gp.prem_amt
                          ) gp_prem_amt,                   --by joy 01/08/2001
                   giv.acct_ent_date giv_acct_ent_date,
                   
                   --Modified gp.acct_ent_date by Jonan 06/05/2008
                   DECODE (gp.pol_flag,
                           TO_CHAR (5), (  SUM (  DECODE (gpr.param_name,
                                                          'EVAT', git.tax_amt,
                                                          0
                                                         )
                                                * giv.currency_rt
                                               )
                                         * (-1)
                            ),
                           SUM (  DECODE (gpr.param_name,
                                          'EVAT', git.tax_amt,
                                          0
                                         )
                                * giv.currency_rt
                               )
                          ) gparam_evat,                   --by Joy 01/15/2001
                   DECODE (gp.pol_flag,
                           TO_CHAR (5), (  SUM (  DECODE (gpr.param_name,
                                                          'PREM_TAX', git.tax_amt,
                                                          0
                                                         )
                                                * giv.currency_rt
                                               )
                                         * (-1)
                            ),
                           SUM (  DECODE (gpr.param_name,
                                          'PREM_TAX', git.tax_amt,
                                          0
                                         )
                                * giv.currency_rt
                               )
                          ) gparam_prem_tax,               --by Joy 01/15/2001
                   DECODE (gp.pol_flag,
                           TO_CHAR (5), (  SUM (  DECODE (gpr.param_name,
                                                          'FST', git.tax_amt,
                                                          0
                                                         )
                                                * giv.currency_rt
                                               )
                                         * (-1)
                            ),
                           SUM (  DECODE (gpr.param_name,
                                          'FST', git.tax_amt,
                                          0
                                         )
                                * giv.currency_rt
                               )
                          ) gparam_fst,                    --by Joy 01/15/2001
                   DECODE (gp.pol_flag,
                           TO_CHAR (5), (  SUM (  DECODE (gpr.param_name,
                                                          'LGT', git.tax_amt,
                                                          0
                                                         )
                                                * giv.currency_rt
                                               )
                                         * (-1)
                            ),
                           SUM (  DECODE (gpr.param_name,
                                          'LGT', git.tax_amt,
                                          0
                                         )
                                * giv.currency_rt
                               )
                          ) gparam_lgt,                    --by Joy 01/15/2001
                   DECODE (gp.pol_flag,
                           TO_CHAR (5), (  SUM (  DECODE (gpr.param_name,
                                                          'DOC_STAMPS', git.tax_amt,
                                                          0
                                                         )
                                                * giv.currency_rt
                                               )
                                         * (-1)
                            ),
                           SUM (  DECODE (gpr.param_name,
                                          'DOC_STAMPS', git.tax_amt,
                                          0
                                         )
                                * giv.currency_rt
                               )
                          ) gparam_doc_stamps              --by Joy 01/15/2001
              FROM giis_issource gi,                -- added by Joy 01/09/2001
                   gipi_polbasic gp,
                   giis_line gl,
                   giis_subline gs,
                   giac_parameters gpr,
                   gipi_inv_tax git,
                   gipi_invoice giv
             WHERE gp.line_cd = gl.line_cd
               AND gp.iss_cd = gi.iss_cd            -- added by Joy 01/09/2001
               AND gp.subline_cd = gs.subline_cd
               AND gl.line_cd = gs.line_cd
               AND gp.policy_id = giv.policy_id
               AND giv.iss_cd = git.iss_cd(+)
               AND giv.prem_seq_no = git.prem_seq_no(+)
               AND git.tax_cd = gpr.param_value_n(+)
               --AND GP.POLICY_ID = 21509
               AND DECODE (gp.iss_cd, 'BB', 0, 'RI', 0, 1) = 1
               --AND ((TRUNC(gp.acct_ent_date) BETWEEN :MISC.FROM_DATE AND :MISC.TO_DATE)
               AND (TRUNC (giv.spoiled_acct_ent_date)
                                                      /*Modified gp.spld_acct_ent_dateby Jonan 05/06/2008*/
                                                      BETWEEN p_from_date
                                                          AND p_to_date
                   )
               /*added by Liezl A. 07-13-2001*/
/*AND ((TRUNC(gp.acct_ent_date) BETWEEN :MISC.FROM_DATE AND :MISC.TO_DATE)
  OR (TRUNC(gp.spld_acct_ent_date) BETWEEN :MISC.FROM_DATE AND :MISC.TO_DATE)) */
               AND (   gp.pol_flag = TO_CHAR (1)
                    OR gp.pol_flag = TO_CHAR (2)
                    OR gp.pol_flag = TO_CHAR (3)
                    OR gp.pol_flag = TO_CHAR (4)
                    OR gp.pol_flag = TO_CHAR (5)
                   )
               AND gi.iss_cd = NVL (p_iss_cd, gi.iss_cd)
               /*by LIEZL A. 07/12/2001*/
               AND check_user_per_iss_cd_acctg2 (NULL,
                                                 gi.iss_cd,
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1
               --added by reymon 05282012
               AND gl.line_cd = NVL (p_line_cd, gl.line_cd)
               /*by LIEZL A. 07/12/2001*/
               AND gs.subline_cd = NVL (p_subline_cd, gs.subline_cd)
               /*by LIEZL A. 07/12/2001*/
               AND DECODE (p_branch_type, 1, gp.cred_branch, gp.iss_cd) =
                      DECODE (p_branch_type,
                              1, NVL (gp.cred_branch, gp.iss_cd),
                              NVL (p_iss_cd, gp.iss_cd)
                             )                                   --rutty081607
               AND check_user_per_iss_cd_acctg2 (NULL,
                                                 DECODE (p_branch_type,
                                                         1, gp.cred_branch,
                                                         gp.iss_cd
                                                        ),
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1
          --added by reymon 05282012
          GROUP BY giv.spoiled_acct_ent_date,
                   gp.pol_flag,
                   --Modified gp.spld_acct_ent_dateby Jonan 06/05/2008
                   gi.iss_cd,
                   gi.iss_name,
                   gp.policy_id,
                   gp.line_cd,
                   gp.subline_cd,
                   DECODE (p_branch_type, 1, gp.cred_branch, gp.iss_cd),
                   --gp.iss_cd, changed by reymon 05282012
                   gp.issue_yy,
                   gp.pol_seq_no,
                   gp.renew_no,
                   gp.endt_iss_cd,
                   gp.endt_yy,
                   gp.endt_seq_no,
                   gp.incept_date,
                   gp.expiry_date,
                   gl.line_name,
                   gs.subline_name,
                   gp.tsi_amt,
                   gp.prem_amt,
                   giv.acct_ent_date
          --Modified gp.acct_ent_date by Jonan 05/06/2008
          ORDER BY 1, 4, 5, 6, 7, 8, 9, 10, 11, 12)
      LOOP
         v_not_exist := FALSE;
         v_rec.iss_cd1 := i.iss_cd1;
         v_rec.iss_name := i.iss_name;
         v_rec.line_name := i.line_name;
         v_rec.subline_name := i.subline_name;
         v_rec.POLICY :=
               i.line_cd
            || '-'
            || i.subline_cd
            || '-'
            || i.iss_cd
            || '-'
            || LTRIM (TO_CHAR (i.issue_yy, '00'))
            || '-'
            || LTRIM (TO_CHAR (i.pol_seq_no, '0000000'))
            || '-'
            || LTRIM (TO_CHAR (i.renew_no, '00'));

         IF i.endt_seq_no <> 0
         THEN
            v_rec.POLICY :=
                  v_rec.POLICY
               || '/'
               || i.endt_iss_cd
               || '-'
               || LTRIM (TO_CHAR (i.endt_yy, '00'))
               || '-'
               || LTRIM (TO_CHAR (i.endt_seq_no, '000000'));
         END IF;

         v_rec.incept_date := TO_CHAR (i.incept_date, get_rep_date_format);
         v_rec.expiry_date := TO_CHAR (i.expiry_date, get_rep_date_format);
         v_rec.total_tsi := i.tsi_amt;
         v_rec.total_premium := i.prem_amt;
         v_rec.evat := i.evat;
         v_rec.prem_tax := i.prem_tax;
         v_rec.fst := i.fst;
         v_rec.lgt := i.lgt;
         v_rec.doc_stamps := i.doc_stamps;
         v_rec.total_tax := i.evat + i.prem_tax + i.fst + i.lgt + i.doc_stamps;
         v_rec.iss_cd := i.iss_cd;

         BEGIN                                    --modified by Joy 01/16/2001
            FOR otax IN
               (SELECT   gpb.policy_id gpb_policy_id,
                         SUM (git.tax_amt * giv.currency_rt) git_otax_amt
                    FROM gipi_inv_tax git,
                         gipi_invoice giv,
                         gipi_polbasic gpb
                   WHERE gpb.policy_id = giv.policy_id
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.prem_seq_no >= 0
                     AND git.tax_cd >= 0
                     AND gpb.policy_id = i.policy_id
                     AND (TRUNC (gpb.acct_ent_date) BETWEEN p_from_date
                                                        AND p_to_date
                         )
                     /*added by Liezl A. 07-13-2001*/
                     /*AND ((TRUNC(gpb.acct_ent_date) BETWEEN :MISC.FROM_DATE AND :MISC.TO_DATE) --added by Joy 01/16/2001
                     AND (TRUNC(gpb.spld_acct_ent_date) BETWEEN :MISC.FROM_DATE AND :MISC.TO_DATE)) --added by Joy 01/16/2001*/
                     AND (   gpb.pol_flag = TO_CHAR (1)
                          OR gpb.pol_flag = TO_CHAR (2)
                          OR gpb.pol_flag = TO_CHAR (3)
                          OR gpb.pol_flag = TO_CHAR (4)
                          OR gpb.pol_flag = TO_CHAR (5)
                         )
                     AND NOT EXISTS (
                            SELECT gp.param_value_n
                              FROM giac_parameters gp
                             WHERE gp.param_name IN
                                      ('EVAT', 'FST', 'LGT', 'PREM_TAX',
                                       'DOC_STAMPS')
                               AND git.tax_cd = gp.param_value_n)
                     AND gpb.line_cd = NVL (p_line_cd, gpb.line_cd)
                     /*by LIEZL A. 07/12/2001*/
                     AND gpb.subline_cd = NVL (p_subline_cd, gpb.subline_cd)
                     /*by LIEZL A. 07/12/2001*/
                     AND git.iss_cd = NVL (p_iss_cd, git.iss_cd)
                     /*by LIEZL A. 07/12/2001*/
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       git.iss_cd,
                                                       p_module_id,
                                                       p_user_id
                                                      ) = 1
                --added by reymon 05282012
                GROUP BY gpb.policy_id
                UNION ALL                            --added by Joy 01/16/2001
                SELECT   gpb.policy_id gpb_policy_id,
                         DECODE (gpb.pol_flag,
                                 TO_CHAR (5), SUM (  git.tax_amt
                                                   * giv.currency_rt
                                                  ) * (-1),
                                 SUM (git.tax_amt * giv.currency_rt)
                                ) git_otax_amt             --by Joy 01/16/2001
                    FROM gipi_inv_tax git, gipi_invoice giv,
                         gipi_polbasic gpb
                   WHERE gpb.policy_id = giv.policy_id
                     AND giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND git.prem_seq_no >= 0
                     AND git.tax_cd >= 0
                     AND gpb.policy_id = i.policy_id
                     AND (TRUNC (gpb.spld_acct_ent_date) BETWEEN p_from_date
                                                             AND p_to_date
                         )
                     /*added by Liezl A. 07-13-2001*/
                     /*AND ((TRUNC(gpb.acct_ent_date) BETWEEN :MISC.FROM_DATE AND :MISC.TO_DATE) --added by Joy 01/16/2001
                     OR (TRUNC(gpb.spld_acct_ent_date) BETWEEN :MISC.FROM_DATE AND :MISC.TO_DATE)) --added by Joy 01/16/2001*/
                     AND (   gpb.pol_flag = TO_CHAR (1)
                          OR gpb.pol_flag = TO_CHAR (2)
                          OR gpb.pol_flag = TO_CHAR (3)
                          OR gpb.pol_flag = TO_CHAR (4)
                          OR gpb.pol_flag = TO_CHAR (5)
                         )
                     AND NOT EXISTS (
                            SELECT gp.param_value_n
                              FROM giac_parameters gp
                             WHERE gp.param_name IN
                                      ('EVAT', 'FST', 'LGT', 'PREM_TAX',
                                       'DOC_STAMPS')
                               AND git.tax_cd = gp.param_value_n)
                     AND gpb.line_cd = NVL (p_line_cd, gpb.line_cd)
                     /*by LIEZL A. 07/12/2001*/
                     AND gpb.subline_cd = NVL (p_subline_cd, gpb.subline_cd)
                     /*by LIEZL A. 07/12/2001*/
                     AND git.iss_cd = NVL (p_iss_cd, git.iss_cd)
                     /*by LIEZL A. 07/12/2001*/
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       git.iss_cd,
                                                       p_module_id,
                                                       p_user_id
                                                      ) = 1
                GROUP BY gpb.policy_id, gpb.pol_flag)
            LOOP
               v_other_taxes := NVL (otax.git_otax_amt, 0);

               IF NVL (v_other_taxes, 0) = 0
               THEN
                  v_rec.other_taxes := 0;
                  v_rec.total_tax :=
                           i.evat + i.prem_tax + i.fst + i.lgt + i.doc_stamps;
               ELSE
                  v_rec.other_taxes := v_other_taxes;
                  v_rec.total_tax :=
                       i.evat
                     + i.prem_tax
                     + i.fst
                     + i.lgt
                     + i.doc_stamps
                     + v_other_taxes;
               END IF;
            END LOOP;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.flag := 'T';
         PIPE ROW (v_rec);
      ELSE
         v_rec.flag := NULL;
      END IF;
   END populate_giacr101;
END giacr101_pkg;
/



DROP PROCEDURE CPI.PRE_PRODUCTION_EXTRACT;

CREATE OR REPLACE PROCEDURE CPI.PRE_PRODUCTION_EXTRACT (
   p_from_date         DATE,
   p_to_date           DATE,
   p_user_id           giis_users.user_id%TYPE,
   p_message     OUT   VARCHAR2
)
IS
   var_with_invoice_tag   gipi_open_liab.with_invoice_tag%TYPE;
   var_counter_negative   NUMBER                                 := 0;
   var_counter_positive   NUMBER                                 := 0;
   ctr                    NUMBER                                 := 0;
   bb_line_cd             giis_line.line_cd%TYPE                 := 'BB';
   fund_cd                giac_parameters.param_value_v%TYPE;
   marine_line            giis_line.line_cd%TYPE                 := 'MN';
   marine_subline         giis_subline.subline_cd%TYPE           := 'MOP';
BEGIN
   fund_cd := giacp.v ('FUND_CD');

   FOR rec IN
      (SELECT DISTINCT a.policy_id, a.iss_cd, d.acct_branch_cd,
                       d.branch_name, a.line_cd, b.acct_line_cd, b.line_name,
                       a.subline_cd, c.acct_subline_cd, c.subline_name,
                       a.acct_ent_date, a.spld_acct_ent_date, a.prem_amt,
                       a.tsi_amt, a.booking_mth, a.incept_date, a.issue_date,
                       e.assd_no,
                       DECODE (a.endt_seq_no,
                               0, SUBSTR (   a.line_cd
                                          || '-'
                                          || a.subline_cd
                                          || '-'
                                          || a.iss_cd
                                          || '-'
                                          || TO_CHAR (a.issue_yy)
                                          || '-'
                                          || TO_CHAR (a.pol_seq_no),
                                          1,
                                          37
                                         ),
                               SUBSTR (   a.line_cd
                                       || '-'
                                       || a.subline_cd
                                       || '-'
                                       || a.iss_cd
                                       || '-'
                                       || TO_CHAR (a.issue_yy)
                                       || '-'
                                       || TO_CHAR (a.pol_seq_no)
                                       || '-'
                                       || a.endt_iss_cd
                                       || '-'
                                       || TO_CHAR (a.endt_yy)
                                       || '-'
                                       || TO_CHAR (a.endt_seq_no)
                                       || '-'
                                       || TO_CHAR (a.renew_no),
                                       1,
                                       37
                                      )
                              ) policy_no
                  FROM gipi_polbasic a,
                       giis_line b,
                       giis_subline c,
                       giac_branches d,
                       gipi_parlist e
                 WHERE (   TRUNC (a.acct_ent_date) BETWEEN TRUNC (p_from_date)
                                                       AND TRUNC (p_to_date)
                        OR TRUNC (a.spld_acct_ent_date)
                              BETWEEN TRUNC (p_from_date)
                                  AND TRUNC (p_to_date)
                       )
                   AND a.line_cd <> bb_line_cd
                   AND NVL (a.endt_type, 'A') = 'A'
                   AND a.line_cd = b.line_cd
                   AND a.line_cd = c.line_cd
                   AND a.subline_cd = c.subline_cd
                   AND a.iss_cd = d.branch_cd
                   AND d.gfun_fund_cd = fund_cd
                   AND a.par_id = e.par_id
                   AND check_user_per_iss_cd_acctg2 (NULL,
                                                     NVL (d.branch_cd,
                                                          a.iss_cd
                                                         ),
                                                     'GIACS124',
                                                     p_user_id
                                                    ) = 1
                   AND b.sc_tag IS NULL
              ORDER BY a.acct_ent_date,
                       d.acct_branch_cd,
                       b.acct_line_cd,
                       c.acct_subline_cd)
   LOOP
      IF rec.line_cd = marine_line AND rec.subline_cd = marine_subline
      THEN
         SELECT NVL (with_invoice_tag, 'N')
           INTO var_with_invoice_tag
           FROM gipi_open_liab
          WHERE policy_id = rec.policy_id;

         IF var_with_invoice_tag = 'N'
         THEN
            NULL;
         ELSE
            IF TRUNC (rec.acct_ent_date) BETWEEN TRUNC (p_from_date)
                                             AND TRUNC (p_to_date)
            THEN
               var_counter_positive := NVL (var_counter_positive, 0) + 1;

               INSERT INTO giac_production_ext
                           (policy_id, iss_cd, acct_branch_cd,
                            branch_name, line_cd, acct_line_cd,
                            line_name, subline_cd,
                            acct_subline_cd, subline_name,
                            prem_amt, tsi_amt, incept_date,
                            issue_date, booking_mth,
                            acct_ent_date, pos_neg_inclusion,
                            spld_acct_ent_date, fund_cd, policy_no,
                            assd_no
                           )
                    VALUES (rec.policy_id, rec.iss_cd, rec.acct_branch_cd,
                            rec.branch_name, rec.line_cd, rec.acct_line_cd,
                            rec.line_name, rec.subline_cd,
                            rec.acct_subline_cd, rec.subline_name,
                            rec.prem_amt, rec.tsi_amt, rec.incept_date,
                            rec.issue_date, rec.booking_mth,
                            rec.acct_ent_date, 'P',
                            rec.spld_acct_ent_date, fund_cd, rec.policy_no,
                            rec.assd_no
                           );

               ctr := ctr + 1;
            ELSE
               var_counter_negative := NVL (var_counter_negative, 0) + 1;

               INSERT INTO giac_production_ext
                           (policy_id, iss_cd, acct_branch_cd,
                            branch_name, line_cd, acct_line_cd,
                            line_name, subline_cd,
                            acct_subline_cd, subline_name,
                            prem_amt, tsi_amt, incept_date,
                            issue_date, booking_mth,
                            acct_ent_date, pos_neg_inclusion,
                            spld_acct_ent_date, fund_cd, policy_no,
                            assd_no
                           )
                    VALUES (rec.policy_id, rec.iss_cd, rec.acct_branch_cd,
                            rec.branch_name, rec.line_cd, rec.acct_line_cd,
                            rec.line_name, rec.subline_cd,
                            rec.acct_subline_cd, rec.subline_name,
                            rec.prem_amt, rec.tsi_amt, rec.incept_date,
                            rec.issue_date, rec.booking_mth,
                            rec.acct_ent_date, 'N',
                            rec.acct_ent_date, fund_cd, rec.policy_no,
                            rec.assd_no
                           );

               ctr := ctr + 1;
            END IF;
         END IF;
      ELSE
         IF rec.spld_acct_ent_date IS NULL
         THEN
            var_counter_positive := NVL (var_counter_positive, 0) + 1;

            INSERT INTO giac_production_ext
                        (policy_id, iss_cd, acct_branch_cd,
                         branch_name, line_cd, acct_line_cd,
                         line_name, subline_cd, acct_subline_cd,
                         subline_name, prem_amt, tsi_amt,
                         incept_date, issue_date, booking_mth,
                         acct_ent_date, pos_neg_inclusion,
                         spld_acct_ent_date, fund_cd, policy_no,
                         assd_no
                        )
                 VALUES (rec.policy_id, rec.iss_cd, rec.acct_branch_cd,
                         rec.branch_name, rec.line_cd, rec.acct_line_cd,
                         rec.line_name, rec.subline_cd, rec.acct_subline_cd,
                         rec.subline_name, rec.prem_amt, rec.tsi_amt,
                         rec.incept_date, rec.issue_date, rec.booking_mth,
                         rec.acct_ent_date, 'P',
                         rec.spld_acct_ent_date, fund_cd, rec.policy_no,
                         rec.assd_no
                        );

            ctr := ctr + 1;
         ELSE
            var_counter_negative := NVL (var_counter_negative, 0) + 1;

            INSERT INTO giac_production_ext
                        (policy_id, iss_cd, acct_branch_cd,
                         branch_name, line_cd, acct_line_cd,
                         line_name, subline_cd, acct_subline_cd,
                         subline_name, prem_amt, tsi_amt,
                         incept_date, issue_date, booking_mth,
                         acct_ent_date, pos_neg_inclusion,
                         spld_acct_ent_date, fund_cd, policy_no,
                         assd_no
                        )
                 VALUES (rec.policy_id, rec.iss_cd, rec.acct_branch_cd,
                         rec.branch_name, rec.line_cd, rec.acct_line_cd,
                         rec.line_name, rec.subline_cd, rec.acct_subline_cd,
                         rec.subline_name, rec.prem_amt, rec.tsi_amt,
                         rec.incept_date, rec.issue_date, rec.booking_mth,
                         rec.acct_ent_date, 'N',
                         rec.acct_ent_date, fund_cd, rec.policy_no,
                         rec.assd_no
                        );

            ctr := ctr + 1;
         END IF;
      END IF;
   END LOOP;

   p_message :=
         'Geniisys Exception#I#There are '
      || TO_CHAR (var_counter_positive)
      || ' policies included for POSITIVE inclusion processing...#I#There are '
      || TO_CHAR (var_counter_negative)
      || ' policies included for NEGATIVE inclusion processing...#'
      || TO_CHAR (var_counter_positive)
      || '#'
      || TO_CHAR (var_counter_negative);
END;
/



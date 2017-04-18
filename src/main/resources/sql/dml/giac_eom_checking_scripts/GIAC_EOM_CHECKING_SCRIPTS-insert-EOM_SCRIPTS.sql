BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE CPI.GIAC_EOM_CHECKING_SCRIPTS';

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE)
        VALUES (
                  1,
                  'Policies without crediting branch',
                  'SELECT get_policy_no(a.policy_id) policy_no, a.policy_id, d.user_name
  FROM gipi_polbasic a, giis_subline b, gipi_invoice c,
       giis_users d
 WHERE a.policy_id = c.policy_id
   AND a.cred_branch IS NULL
   AND a.pol_flag <> ''5''
   AND a.reg_policy_sw = ''Y''
   AND a.subline_cd = b.subline_cd
   AND a.line_cd = b.line_cd
   AND a.user_id = b.user_id
   AND b.op_flag = ''N''',
                  'What to do

1. Query policy in Underwriting>Utilities>Update Policy Booking Date(gipis156) to update the crediting branch in gipi_polbasic.
',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'UW',
                  'Y');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE)
        VALUES (
                  2,
                  'Policies with commission share percent not equal to 100%',
                  'SELECT x.policy_no, x.policy_id, x.iss_cd, x.prem_seq_no, x.premium_amt,
       x.commission_amt, x.share_percentage, x.COUNT, x.user_name
  FROM (SELECT   get_policy_no (b.policy_id) policy_no, b.policy_id, b.iss_cd,
                 b.prem_seq_no, SUM (a.premium_amt) premium_amt,
                 SUM (a.commission_amt) commission_amt,
                 SUM (a.share_percentage) share_percentage,
                 COUNT (intrmdry_intm_no) COUNT, c.user_name
            FROM gipi_comm_invoice a, gipi_invoice b, giis_users c
           WHERE a.policy_id = b.policy_id
             AND a.iss_cd = b.iss_cd
             AND a.prem_seq_no = b.prem_seq_no
             AND b.user_id = c.user_id
             AND b.acct_ent_date IS NULL
        GROUP BY b.policy_id, b.iss_cd, b.prem_seq_no, c.user_name
          HAVING SUM (a.share_percentage) <> 100) x,
       gipi_invoice y,
       gipi_polbasic z
 WHERE x.policy_id = y.policy_id 
   AND y.policy_id = z.policy_id
   AND z.reg_policy_sw = ''Y''',
                  'What to do

1. Modify the commission using Modify Commission Invoice in Accounting
',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'UW',
                  'Y');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE)
        VALUES (
                  3,
                  'Undistributed Policies',
                  'SELECT DISTINCT b.dist_flag, r.rv_meaning, l.line_name,
                s.subline_name, get_policy_no (b.policy_id) policy_no,
                reg_policy_sw, b.booking_mth, b.booking_year, b.issue_date,
                b.incept_date, a.assd_name, b.tsi_amt, b.prem_amt,
                b.policy_id, c.acct_ent_date, c.acct_neg_date, u.user_name
           FROM cg_ref_codes r,
                giis_line l,
                gipi_polbasic b,
                giis_subline s,
                giis_assured a,
                gipi_parlist p,
                giuw_pol_dist c,
                gipi_invoice d,
                giis_users u
          WHERE b.policy_id = d.policy_id
            AND r.rv_low_value = b.dist_flag
            AND r.rv_low_value IN (''1'', ''2'')
            AND b.dist_flag IN (''1'', ''2'')
            AND r.rv_domain = ''GIPI_POLBASIC.DIST_FLAG''
            AND l.line_cd = b.line_cd
            AND c.par_id = b.par_id
            AND s.subline_cd = b.subline_cd
            AND s.line_cd = l.line_cd
            AND a.assd_no = b.assd_no
            AND p.par_id = b.par_id
            AND b.dist_flag = c.dist_flag
            AND c.user_id = u.user_id
            AND b.pol_flag <> ''5''
            AND b.reg_policy_sw = ''Y''
            AND NVL (b.endt_type, 0) <> ''N''
            AND s.op_flag = ''N''
            AND (   c.acct_ent_date IS NULL
                 OR (    c.dist_flag = ''4''
                     AND c.acct_ent_date IS NOT NULL
                     AND c.acct_neg_date IS NULL
                    )
                )',
                  'What to do: 

1. Distribute the Policies so that it will be included in the cut off for production.',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'UW',
                  'Y');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE)
        VALUES (
                  4,
                  'Undistributed replacement distribution for taken up policies',
                  'SELECT a.dist_no, get_policy_no (a.policy_id) policy_no, a.policy_id, a.dist_flag, a.negate_date,
       a.acct_neg_date, c.dist_no_new,
       (SELECT dist_flag
          FROM giuw_pol_dist
         WHERE dist_no = c.dist_no_new) dist_flag_new, d.user_name
  FROM giuw_pol_dist a, gipi_polbasic b, giuw_distrel c, giis_users d
 WHERE a.policy_id = b.policy_id
   AND a.dist_no = c.dist_no_old
   AND a.user_id = d.user_id
   AND b.pol_flag <> ''5''
   AND a.dist_flag = ''4''
   AND a.acct_ent_date IS NOT NULL
   AND a.dist_no = (SELECT MAX (dist_no)
                      FROM giuw_pol_dist d
                     WHERE a.policy_id = d.policy_id AND dist_flag = ''4'')
   AND EXISTS (SELECT ''x''
                 FROM giuw_pol_dist e
                WHERE c.dist_no_new = e.dist_no AND dist_flag IN (''1'', ''2''))',
                  'What to do

1. Distribute the policy.

Note: Do these next steps if dist_flag is 2.

1. Go to FRPS listing and query the policy. (giris006)
2. Create an RI Placement. (giris001)
3. Post the binder',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'UW');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE)
        VALUES (
                  5,
                  'Negated distribution with no replacement distribution',
                  'SELECT a.policy_id, get_policy_no (a.policy_id) policy_no, b.dist_no,
       c.multi_booking_mm, c.multi_booking_yy, a.dist_flag dist_polbasic,
       b.dist_flag dist_poldist, a.pol_flag, d.user_name
  FROM gipi_polbasic a, giuw_pol_dist b, gipi_invoice c, giis_users d
 WHERE a.policy_id = b.policy_id
   AND a.policy_id = c.policy_id
   AND b.user_id = d.user_id
   AND b.dist_flag = ''4''
   AND NOT EXISTS (SELECT ''1''
                     FROM giuw_distrel c
                    WHERE c.dist_no_old = b.dist_no)
   AND a.pol_flag <> ''5''
   AND (   (b.dist_flag = ''3'' AND b.acct_ent_date IS NULL)
        OR (b.dist_flag = ''4'' AND b.acct_ent_date IS NOT NULL and b.acct_neg_date IS NULL)
       ) ',
                  'What to do

1. Go to Underwriting> Distribution> Set-Up Groups for Distribution (Item)
  a. Query the policy 
  b. Then press CREATE ITEMS

2. Go to Underwriting> Distribution> Distribution By Group
  a. Query the policy 
  b. Enter the distribution details
  c. Save then POST DISTRIBUTION',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'UW');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE)
        VALUES (
                  6,
                  'No Treaty Perils Setup',
                  'SELECT DISTINCT get_policy_no (d.policy_id) policy_no, d.policy_id, d.dist_no,
                a.line_cd, a.share_cd, a.peril_cd, b.peril_name, c.trty_name,
                e.user_id
           FROM giuw_itemperilds_dtl a,
                giis_peril b,
                giis_dist_share c,
                giuw_pol_dist d,
                gipi_polbasic e,
                gipi_invoice f
          WHERE 1 = 1
            AND a.line_cd = b.line_cd
            AND a.peril_cd = b.peril_cd
            AND a.line_cd = c.line_cd
            AND a.share_cd = c.share_cd
            AND c.share_type = 2
            AND a.dist_no = d.dist_no
            AND e.policy_id = f.policy_id
            AND (   (d.dist_flag <> ''4'' AND d.acct_ent_date IS NULL)
                 OR (    d.dist_flag = ''4''
                     AND d.acct_ent_date IS NOT NULL
                     AND d.acct_neg_date IS NULL
                    )
                )
            AND NOT EXISTS (
                   SELECT ''X''
                     FROM giis_trty_peril
                    WHERE line_cd = a.line_cd
                      AND trty_seq_no = a.share_cd
                      AND peril_cd = a.peril_cd)
            AND d.policy_id = e.policy_id
            AND reg_policy_sw = ''Y''
            AND pol_flag <> ''5''',
                  'What to do

1. Maintain Perils via Underwriting \ File Maintenance \ Distribution Share 
2. Query the Line
3. Tag Proportional Treaty
4. Query the Share Code then double-click or click Treaty Details button
5. Click Treaty Peril button
6. Add the Peril code. Input Comm Rate then Save',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'UW',
                  'Y');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE)
        VALUES (
                  7,
                  'Inward Policies of Foreign Ceding Companies with Premium VAT',
                  'SELECT a.policy_id,
       get_policy_no (a.policy_id) policy_no, c.iss_cd, c.prem_seq_no,
       d.ri_cd, d.ri_name, tax_amt, e.user_name
  FROM gipi_polbasic a,
       giri_inpolbas b,
       gipi_invoice c,
       giis_reinsurer d,
       giis_users e
 WHERE a.policy_id = b.policy_id
   AND a.policy_id = c.policy_id
   AND b.ri_cd = d.ri_cd
   AND c.user_id = e.user_id
   AND a.iss_cd = ''RI''
   AND a.pol_flag <> ''5''
   AND a.reg_policy_sw <> ''N''
   AND c.tax_amt IS NOT NULL
   AND c.tax_amt <> 0
   AND d.local_foreign_sw IN (''F'', ''A'')',
                  'What to do

1. Confirm with the Underwriters whether the encoded RI was correct  and/or whether premium vat/tax amount was wrongly entered.

2. If tax amount should be zero;
3. Run the script below
  UPDATE gipi_invoice
          SET tax_amt = 0
   WHERE policy_id = :policy_id; --enter policy_id

UPDATE gipi_installment
          SET tax_amt = 0
   WHERE iss_cd = :iss_cd; --enter iss_cd
          AND prem_seq_no = :prem_seq_no --enter prem_seq_no',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'UW',
                  'Y');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE)
        VALUES (
                  8,
                  'Tagged for Spoilage',
                  'SELECT get_policy_no (a.policy_id) policy_no, a.policy_id, b.multi_booking_mm,
       b.multi_booking_yy, spld_flag, c.user_name
  FROM gipi_polbasic a, gipi_invoice b, giis_users c
 WHERE a.policy_id = b.policy_id
   AND a.user_id = c.user_id
   AND a.spld_date IS NOT NULL
   AND a.spld_flag <> ''3''
   AND a.pol_flag <> ''5''',
                  'What to do

 1. If spld_flag = ''2''; post the spoilage.
 a. Go to Underwriting > Spoil a Posted Policy.
 b. Query the policy number.
 c. Press the [Post Spoilage] button',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'UW',
                  'Y');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE)
        VALUES (
                  9,
                  'Policies without commission record',
                  'SELECT get_policy_no (d.policy_id) policy_no,
       d.policy_id,
       f.iss_cd, f.prem_seq_no,
       f.multi_booking_mm,
       f.multi_booking_yy,
       pol_flag,
       e.op_flag,
       h.user_name
  FROM gipi_polbasic d,
       giis_subline e,
       gipi_invoice f,
       gipi_endttext g,
       giis_users h
 WHERE     1 = 1
       AND NOT EXISTS
              (SELECT ''X''
                 FROM gipi_comm_inv_peril x
                WHERE x.policy_id = f.policy_id)
       AND NVL (endt_type, ''A'') != ''N''
       AND d.iss_cd != ''RI''
       AND d.pol_flag <> ''5''
       AND NVL (d.reg_policy_sw, ''Y'') = ''Y''
       AND d.line_cd = e.line_cd
       AND d.subline_cd = e.subline_cd
       AND d.policy_id = f.policy_id
       AND e.op_flag <> ''Y''
       AND NVL (g.endt_tax, ''N'') != ''Y''
       AND g.policy_id(+) = d.policy_id
       AND d.user_id = h.user_id
       AND f.prem_amt != 0
       AND f.acct_ent_date IS NULL',
                  'What to do

1. Ask the client for the intermediary.
2. Get the intermediary number in the intermediary maintenance.
3. Run the script below to populate the commission tables.



4. Modify the commission rate to compute correct commission per peril.
    Go to Accounting > General Disbursement > Utilities > Modify Commission, query the bill/invoice number.
5. Save and post changes.    ',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'UW',
                  'Y');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE)
        VALUES (
                  10,
                  'Claim records with problem in distribution per Share Code and per Reinsurer.',
                  'SELECT   a.claim_id, get_claim_number (a.claim_id) claim_number,
         c.booking_month || '' '' || c.booking_year booking_month,
         a.clm_res_hist_id, c.item_no, c.peril_cd, a.clm_dist_no,
         a.grp_seq_no,
         (ROUND (a.shr_pct, 4) - ROUND (b.shr_pct, 4)) diff_shr_pct,
         ROUND (total_shr_ri_pct_real, 2) total_shr_ri_pct_real,
         (NVL (a.shr_loss_res_amt, 0) - NVL (b.shr_loss_res_amt, 0)
         ) diff_shr_loss_res_amt,
         (NVL (a.shr_exp_res_amt, 0) - NVL (b.shr_exp_res_amt, 0)
         ) diff_shr_exp_res_amt,
         e.user_name
    FROM (SELECT claim_id, clm_res_hist_id, clm_dist_no, grp_seq_no, shr_pct,
                 shr_loss_res_amt, shr_exp_res_amt, user_id
            FROM gicl_reserve_ds) a,
         (SELECT   claim_id, clm_res_hist_id, clm_dist_no, grp_seq_no,
                   SUM (shr_ri_pct) shr_pct,
                   SUM (shr_ri_pct_real) total_shr_ri_pct_real,
                   SUM (shr_loss_ri_res_amt) shr_loss_res_amt,
                   SUM (shr_exp_ri_res_amt) shr_exp_res_amt
              FROM gicl_reserve_rids
          GROUP BY claim_id, clm_res_hist_id, clm_dist_no, grp_seq_no) b,
         gicl_clm_res_hist c,
         gicl_claims d,
         giis_users e
   WHERE a.claim_id = b.claim_id
     AND a.clm_res_hist_id = b.clm_res_hist_id
     AND a.clm_dist_no = b.clm_dist_no
     AND a.grp_seq_no = b.grp_seq_no
     AND a.claim_id = c.claim_id
     AND a.clm_res_hist_id = c.clm_res_hist_id
     AND a.user_id = e.user_id
     AND NVL (c.dist_sw, ''Y'') = ''Y''
     AND (   (ROUND (a.shr_pct, 4) != ROUND (b.shr_pct, 4))
          OR (ROUND (total_shr_ri_pct_real, 2) != 100)
          OR (NVL (a.shr_loss_res_amt, 0) != NVL (b.shr_loss_res_amt, 0))
          OR (NVL (a.shr_exp_res_amt, 0) != NVL (b.shr_exp_res_amt, 0))
         )
     AND c.claim_id = d.claim_id
     AND d.clm_stat_cd NOT IN (''CC'', ''CD'', ''WD'', ''DN'')
ORDER BY TO_DATE (c.booking_month || ''-01-'' || c.booking_year,
                  ''MONTH-DD-RRRR'') DESC,
         claim_number',
                  'What to do

 1. Redistribute reserve of claim.
',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'CL');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE)
        VALUES (
                  11,
                  'Claim records with no distribution but included in Batch OS',
                  'SELECT get_claim_number (a.claim_id) claim_number, b.claim_id,
       b.clm_res_hist_id, b.item_no, b.peril_cd, b.loss_reserve,
       b.expense_reserve, booking_month, booking_year
  FROM gicl_claims c, gicl_clm_res_hist b, gicl_item_peril a
 WHERE c.claim_id = b.claim_id
   AND b.claim_id = a.claim_id
   AND b.item_no = a.item_no
   AND b.peril_cd = a.peril_cd
   AND c.clm_stat_cd NOT IN (''CC'', ''CD'', ''WD'', ''DN'')
   AND NVL (b.dist_sw, ''N'') = ''Y''
   AND (a.close_date IS NULL OR a.close_date2 IS NULL)
   AND NOT EXISTS (
          SELECT 1
            FROM gicl_reserve_ds d
           WHERE d.claim_id = b.claim_id
             AND d.clm_res_hist_id = b.clm_res_hist_id)',
                  'What to do

 1.Redistribute distribution of claim
',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'CL');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE)
        VALUES (
                  12,
                  'Claim''s Payment with no distribution',
                  'SELECT get_claim_number (a.claim_id) claim_number, a.claim_id, a.clm_loss_id,
          b.line_cd
       || ''-''
       || iss_cd
       || ''-''
       || advice_year
       || ''-''
       || advice_seq_no advice_no,
       a.advice_id, get_ref_no (a.tran_id) reference_number, a.tran_id,
       a.paid_amt, a.advise_amt, tran_date
  FROM gicl_clm_loss_exp a, gicl_advice b
 WHERE NVL (a.dist_sw, ''N'') = ''Y''
   AND a.claim_id = b.claim_id
   AND a.advice_id = b.advice_id
   AND NOT EXISTS (
          SELECT 1
            FROM gicl_loss_exp_ds b
           WHERE a.claim_id = b.claim_id
             AND a.clm_loss_id = b.clm_loss_id
             AND NVL (b.negate_tag, ''N'') = ''N'')
   AND EXISTS (SELECT ''X''
                 FROM gicl_clm_res_hist
                WHERE claim_id = a.claim_id AND advice_id = a.advice_id
               HAVING (SUM (losses_paid) != 0 OR SUM (expenses_paid) != 0))',
                  'What to do

 1. Check UW distribution. If it has errors then do the following otherwise consult CPI:
a.    Create new settlement history with same details as the record being corrected.
b.    Check the share perentage per share type in distribution details.
    b.1    If there are no negative or more than 100 percent share percentage, proceed to the next step.
    b.2    If with error, consult CPI.
c.    Proceed to the generation of advice (do not approve or generate A.E.).
d.    Create a JV with Collection Type for the new settlement history created in step A, then Refund Type for the advice selected in script with incorrect details.
e.    Close the transaction.
',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'CL');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE)
        VALUES (
                  13,
                  'Claim Payment with more than 1 valid distribution',
                  'SELECT get_claim_number (a.claim_id) claim_no, a.claim_id, a.clm_res_hist_id,
       a.clm_loss_id, get_ref_no (a.tran_id) ref_no
  FROM gicl_clm_res_hist a,
       giac_acctrans b,
       (SELECT   claim_id, clm_loss_id,
                 COUNT (DISTINCT clm_dist_no) ctr_dist_no
            FROM gicl_loss_exp_ds
           WHERE NVL (negate_tag, ''N'') = ''N''
        GROUP BY claim_id, clm_loss_id) c
 WHERE a.tran_id = b.tran_id
   AND b.tran_flag IN (''C'', ''P'') 
   AND a.claim_id = c.claim_id
   AND a.clm_loss_id = c.clm_loss_id
   AND c.ctr_dist_no > 1',
                  'What to do

 For records found, consult CPI.',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'CL');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE)
        VALUES (
                  14,
                  'Claim''s Payment with inconsistency on distribution',
                  'SELECT   get_claim_number (a.claim_id) claim_number, a.claim_id,
         a.clm_loss_id,
            c.line_cd
         || ''-''
         || iss_cd
         || ''-''
         || advice_year
         || ''-''
         || advice_seq_no advice_no,
         a.advice_id, get_ref_no (a.tran_id) reference_number, a.advise_amt,
         b.advise_amt dist_adv_amt, a.advise_amt - b.advise_amt diff
    FROM gicl_clm_loss_exp a,
         (SELECT   claim_id, clm_loss_id, clm_dist_no,
                   ROUND (SUM (b.shr_le_adv_amt), 2) advise_amt
              FROM gicl_loss_exp_ds b
             WHERE NVL (b.negate_tag, ''N'') = ''N''
          GROUP BY claim_id, clm_loss_id, clm_dist_no) b,
         gicl_advice c
   WHERE NVL (a.dist_sw, ''N'') = ''Y''
     AND b.claim_id = a.claim_id(+)
     AND b.clm_loss_id = a.clm_loss_id(+)
     AND a.claim_id = c.claim_id
     AND a.advice_id = c.advice_id
     AND ABS (a.advise_amt - b.advise_amt) > 1
     AND EXISTS (SELECT ''X''
                   FROM gicl_clm_res_hist
                  WHERE claim_id = a.claim_id AND advice_id = a.advice_id
                 HAVING (SUM (losses_paid) != 0 OR SUM (expenses_paid) != 0))
ORDER BY 1, clm_loss_id',
                  'What to do

 1. Check UW distribution. If it has errors then do the following otherwise consult CPI:
a.    Create new settlement history with same details as the record being corrected.
b.    Check the share perentage per share type in distribution details.
    b.1    If there are no negative or more than 100 percent share percentage, proceed to the next step.
    b.2    If with error, consult CPI.
c.    Proceed to the generation of advice (do not approve or generate A.E.).
d.    Create a JV with Collection Type for the new settlement history created in step A, then Refund Type for the advice selected in script with incorrect details.
e.    Close the transaction.
',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'CL');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE)
        VALUES (
                  15,
                  'Claim''s Payment with negative or more than 100 percent share percentage',
                  'SELECT   get_claim_number (a.claim_id) claim_no,a.claim_id,
            e.line_cd
         || ''-''
         || iss_cd
         || ''-''
         || advice_year
         || ''-''
         || advice_seq_no advice_no,  a.advice_id,
          b.clm_loss_id, b.clm_dist_no, b.share_type, b.grp_seq_no,
         d.trty_name, b.shr_loss_exp_ri_pct dist_shr_ri_pct, shr_loss_exp_ri_pct
    FROM gicl_clm_res_hist a,
         gicl_loss_exp_rids b,
         giac_acctrans c,
         giis_dist_share d,
         gicl_advice e
   WHERE a.claim_id = b.claim_id
     AND a.clm_loss_id = b.clm_loss_id
     AND a.dist_no = b.clm_dist_no
     AND a.tran_id = c.tran_id
     AND c.tran_flag IN (''C'', ''P'')
     AND b.line_cd = d.line_cd
     AND b.grp_seq_no = d.share_cd
     AND a.claim_id = e.claim_id
     AND a.advice_id = e.advice_id
     AND (b.shr_loss_exp_ri_pct < 0 OR b.shr_loss_exp_ri_pct > 100)
     AND EXISTS (SELECT ''X''
                   FROM gicl_clm_res_hist
                  WHERE claim_id = a.claim_id 
                    AND advice_id = a.advice_id
                 HAVING (SUM (losses_paid) != 0 OR SUM (expenses_paid) != 0))
ORDER BY 1, clm_loss_id',
                  'What to do

 1. Check UW distribution. If it has errors then do the following otherwise consult CPI:
a.    Create new settlement history with same details as the record being corrected.
b.    Check the share perentage per share type in distribution details.
    b.1    If there are no negative or more than 100 percent share percentage, proceed to the next step.
    b.2    If with error, consult CPI.
c.    Proceed to the generation of advice (do not approve or generate A.E.).
d.    Create a JV with Collection Type for the new settlement history created in step A, then Refund Type for the advice selected in script with incorrect details.
e.    Close the transaction.
',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'CL');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              SCRIPT_TYPE)
        VALUES (
                  16,
                  'Special Claim Settlement with incomplete details',
                  'SELECT a.batch_dv_id, a.tran_id, get_ref_no (a.tran_id) ref_no, a.paid_amt
  FROM giac_batch_dv a, giac_acctrans c
 WHERE NVL (a.batch_flag, ''N'') = ''N''
   AND a.tran_id = c.tran_id
   AND c.tran_flag IN (''C'', ''P'')
   AND EXISTS (
       SELECT   1
           FROM giac_batch_dv_dtl b
          WHERE b.batch_dv_id = a.batch_dv_id
       GROUP BY b.batch_dv_id
         HAVING ROUND (SUM (b.paid_amt) * a.convert_rate, 2) != a.paid_amt)',
                  'What to do

 For records found, consult CPI.',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'CL');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  17,
                  'Different booking month in GIPI_POLBASIC and GIPI_INVOICE',
                  'SELECT a.policy_id, get_pack_policy_no (a.pack_policy_id) ip_policy_no,
       get_policy_no (a.policy_id) policy_no,
       a.booking_mth || '' '' || a.booking_year gipi_polbasic_booking,
       b.multi_booking_mm || '' '' || b.multi_booking_yy gipi_invoice_booking,
       b.acct_ent_date, c.user_name
  FROM gipi_polbasic a, gipi_invoice b, giis_users c
 WHERE a.booking_mth || '' '' || a.booking_year <>
                               b.multi_booking_mm || '' '' || b.multi_booking_yy
   AND a.policy_id = b.policy_id
   AND b.user_id = c.user_id
   AND a.acct_ent_date IS NULL
   AND b.acct_ent_date IS NULL
   AND a.reg_policy_sw = ''Y''
   AND a.pol_flag <> ''5''
   AND a.spld_date IS NULL
   AND a.takeup_term = ''ST''
   AND NOT EXISTS
              (SELECT ''X''
                 FROM GIPI_INVOICE X
                WHERE x.policy_id = a.policy_id
               HAVING COUNT (1) > 1)',
                  'What to do

1. Update Booking Month Go to Underwriting >Utilities >Update Policy Booking Date
2. Query the Policy then UPDATE then SAVE. Check booking month should be the same.',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'pol_BookingMonth',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  18,
                  'Records having incorrect premium per intermediary. Premium not based on intermediary''s share percentage',
                  'SELECT x.policy_no, x.policy_id, x.iss_cd, x.prem_seq_no, x.prem_amt_inv,
       x.prem_amt, x.prem_amt_peril, x.user_name
  FROM (SELECT   b.policy_id, get_policy_no (b.policy_id) policy_no, b.iss_cd,
                 b.prem_seq_no, SUM (a.premium_amt) prem_amt_inv, b.prem_amt,
                 c.premium_amt prem_amt_peril, d.user_name
            FROM gipi_comm_invoice a,
                 gipi_invoice b,
                 (SELECT   policy_id, iss_cd, prem_seq_no,
                           SUM (premium_amt) premium_amt
                      FROM gipi_comm_inv_peril
                     WHERE policy_id IN (
                              SELECT d.policy_id
                                FROM gipi_invoice d, gipi_polbasic e
                               WHERE d.policy_id = e.policy_id)
                  GROUP BY policy_id, iss_cd, prem_seq_no) c,
                 giis_users d
           WHERE a.policy_id = b.policy_id
             AND a.policy_id = c.policy_id (+)
             AND a.iss_cd = b.iss_cd
             AND a.prem_seq_no = b.prem_seq_no
             AND a.iss_cd = c.iss_cd (+)
             AND a.prem_seq_no = c.prem_seq_no (+)
             AND b.user_id = d.user_id
        GROUP BY b.policy_id,
                 b.iss_cd,
                 b.prem_seq_no,
                 b.prem_amt,
                 c.premium_amt,
                 d.user_name
          HAVING SUM (NVL (a.premium_amt, 0)) != NVL (b.prem_amt, 0)
              OR NVL (b.prem_amt, 0) != NVL (c.premium_amt, 0)
              OR SUM (NVL (a.premium_amt, 0)) != NVL (c.premium_amt, 0)
        ORDER BY b.policy_id) x,
       gipi_invoice y,
       gipi_polbasic z
 WHERE x.policy_id = y.policy_id
   AND x.iss_cd = y.iss_cd
   AND x.prem_seq_no = y.prem_seq_no
   AND y.policy_id = z.policy_id
   AND z.reg_policy_sw = ''Y''
   AND z.pol_flag != ''5''
   AND y.acct_ent_date IS NULL',
                  'What to do

1. Modify the commission using Modify Commission Invoice in Accounting. 
2. Re-enter the share percent for each intermediary then press ''Apply'' button',
                  'CPI',
                  TO_DATE ('08/16/2016 14:40:22', 'MM/DD/YYYY HH24:MI:SS'),
                  'pol_PremComm',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  19,
                  'Policies with different amounts between gipi_comm_invoice and gipi_comm_inv_peril',
                  'SELECT get_policy_no (a.policy_id) policy_no,
       a.policy_id,
       pol_flag,
       NVL (comm_inv, 0) comm_inv,
       NVL (comm_inv_peril, 0) comm_inv_peril,
       NVL (comm_inv, 0) - NVL (comm_inv_peril, 0) diff,
       multi_booking_mm,
       multi_booking_yy,
       d.user_name
  FROM (  SELECT b.policy_id,
                 b.iss_cd,
                 b.prem_seq_no,
                 SUM (commission_amt) comm_inv_peril,
                 multi_booking_mm,
                 multi_booking_yy,
                 b.acct_ent_date,
                 b.spoiled_acct_ent_date
            FROM gipi_comm_inv_peril a, gipi_invoice b
           WHERE     a.iss_cd = b.iss_cd
                 AND a.prem_seq_no = b.prem_seq_no
        GROUP BY b.iss_cd,
                 b.prem_seq_no,
                 b.policy_id,
                 multi_booking_mm,
                 multi_booking_yy,
                 b.acct_ent_date,
                 b.spoiled_acct_ent_date) a,
       (  SELECT b.iss_cd,
                 b.prem_seq_no,
                 b.policy_id,
                 SUM (commission_amt) comm_inv,
                 b.user_id
            FROM gipi_comm_invoice a, gipi_invoice b
           WHERE     a.iss_cd = b.iss_cd
                 AND a.prem_seq_no = b.prem_seq_no
        GROUP BY b.iss_cd,
                 b.prem_seq_no,
                 b.policy_id,
                 b.user_id) b,
       gipi_polbasic c,
       giis_users d
 WHERE     a.policy_id = b.policy_id(+)
       AND a.policy_id = c.policy_id
       AND a.iss_cd = b.iss_cd(+)
       AND a.prem_seq_no = b.prem_seq_no(+)
       AND b.user_id = d.user_id
       AND NVL (reg_policy_sw, ''Y'') = ''Y''
       AND c.pol_flag != ''5''
       AND NVL (comm_inv, 0) - NVL (comm_inv_peril, 0) <> 0
       AND a.acct_ent_date IS NULL',
                  'What to do

 For records found consult CPI',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'pol_PremComm',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  20,
                  'Different premium amount in GIPI_INVOICE, GIPI_INVPERIL, GIPI_COMM_INV_PERIL',
                  'SELECT get_policy_no (a.policy_id) policy_no, a.policy_id, a.iss_cd,
       a.prem_seq_no, a.multi_booking_mm, a.multi_booking_yy, a.prem_amt,
       c.invperil, d.comm_invperil, a.prem_amt - d.comm_invperil diff,
       e.user_name
  FROM gipi_invoice a,
       gipi_polbasic b,
       giis_users e,
       (SELECT   iss_cd, prem_seq_no, SUM (prem_amt) invperil
            FROM gipi_invperil
        GROUP BY iss_cd, prem_seq_no) c,
       (SELECT   policy_id, iss_cd, prem_seq_no,
                 SUM (premium_amt) comm_invperil
            FROM gipi_comm_inv_peril
        GROUP BY policy_id, iss_cd, prem_seq_no) d
 WHERE a.policy_id = b.policy_id
   AND a.iss_cd = c.iss_cd
   AND a.prem_seq_no = c.prem_seq_no
   AND a.iss_cd = d.iss_cd(+)
   AND a.prem_seq_no = d.prem_seq_no(+)
   AND a.user_id = e.user_id
   AND (   NVL (a.prem_amt, 0) <> NVL (comm_invperil, 0)
        OR NVL (a.prem_amt, 0) <> NVL (invperil, 0)
        OR NVL (comm_invperil, 0) <> NVL (invperil, 0)
       )
   AND b.pol_flag <> ''5''
   AND b.iss_cd <> ''RI''
   AND NOT EXISTS (SELECT 1
                     FROM gipi_endttext
                    WHERE policy_id = a.policy_id AND endt_tax = ''Y'')
   AND a.acct_ent_date IS NULL',
                  'What to do

Consult CPI.',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'pol_PremComm',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  21,
                  'Direct policy has RI comm amt value in gipi_invoice',
                  'SELECT get_policy_no (a.policy_id) policy_no,
       a.policy_id, b.user_name
  FROM gipi_invoice a, giis_users b, gipi_polbasic c
 WHERE a.user_id = b.user_id
   AND a.policy_id = c.policy_id
   AND a.iss_cd != ''RI''
   AND a.ri_comm_amt != 0',
                  'What to do

 1. Update records queried to have an RI comm amt equal to zero.

a.Run the following script:

UPDATE gipi_invoice
   SET ri_comm_amt = 0
 WHERE 1=1
   AND iss_cd != ''RI''
   AND ri_comm_amt != 0;

COMMIT;',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'pol_RiComm',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  22,
                  'Difference in RI comm amt -  INVOICE vs ITMPERIL vs INVPERIL',
                  'SELECT a.policy_id,
       get_policy_no (a.policy_id) policy_no,
       a.ri_comm_amt item_peril_ri_comm,
       e.ri_comm_amt inv_peril_ri_comm,
       b.ri_comm_amt,
       booking_mth,
       booking_year,
       f.user_name
  FROM gipi_polbasic d,
       gipi_invoice b,
       giis_users f,
       (  SELECT a.policy_id, b.item_grp, SUM (a.ri_comm_amt) ri_comm_amt
            FROM gipi_itmperil a, gipi_item b
           WHERE A.policy_id = b.policy_id AND a.item_no = b.item_no
        GROUP BY a.policy_id, b.item_grp) a,
       (  SELECT b.policy_id, b.item_grp, SUM (c.ri_comm_amt) ri_comm_amt
            FROM gipi_invoice b, gipi_invperil c
           WHERE b.iss_cd = c.iss_cd AND b.prem_seq_no = c.prem_seq_no
        GROUP BY b.policy_id,
                 b.multi_booking_mm,
                 b.multi_booking_yy,
                 b.item_grp) e
 WHERE     d.policy_id = a.policy_id
       AND d.policy_id = e.policy_id
       AND d.policy_id = b.policy_id
       AND a.item_grp = e.item_grp
       AND d.pol_flag <> ''5''
       AND NVL (d.reg_policy_sw, ''Y'') = ''Y''
       AND b.iss_cd = ''RI''
       AND b.user_id = f.user_id
       AND (   a.ri_comm_amt != e.ri_comm_amt
            OR a.ri_comm_amt != b.ri_comm_amt
            OR e.ri_comm_amt != b.ri_comm_amt)
       AND NOT EXISTS
                  (SELECT ''X''
                     FROM giac_inwfacul_prem_collns x,
                          gipi_invoice y,
                          giac_acctrans z
                    WHERE     x.b140_iss_cd = y.iss_cd
                          AND x.b140_prem_seq_no = y.prem_seq_no
                          AND x.gacc_tran_id = z.tran_id
                          AND y.iss_cd = b.iss_cd
                          AND y.prem_seq_no = b.prem_seq_no
                          AND z.tran_flag != ''D''
                          AND NOT EXISTS
                                     (SELECT ''Y''
                                        FROM giac_reversals j,
                                             giac_acctrans m
                                       WHERE     j.reversing_tran_id =
                                                    m.tran_id
                                             AND j.gacc_tran_id =
                                                    x.gacc_tran_id
                                             AND m.tran_flag != ''D''))
       AND b.acct_ent_date IS NULL',
                  'What to do

For records found consult CPI',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'pol_RiComm',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              DISPLAY_SW)
        VALUES (
                  23,
                  'Spoiled Package Policies where sub-policies pol_flag is not spoiled (pol_flag=''1'')',
                  'SELECT a.pack_policy_id,
          a.line_cd
       || ''-''
       || a.subline_cd
       || ''-''
       || a.iss_cd
       || ''-''
       || a.issue_yy
       || ''-''
       || a.pol_seq_no
       || ''-''
       || a.renew_no "PACKAGE POLICY NO",
       policy_id, get_policy_no(b.policy_id) policy_no,
       c.user_name
  FROM gipi_pack_polbasic a, gipi_polbasic b, giis_users c
 WHERE a.pol_flag = ''5''
   AND a.spld_flag = ''3''
   AND a.pack_policy_id = b.pack_policy_id
   AND b.user_id = c.user_id
   AND b.pol_flag <> ''5''
   AND b.spld_flag = ''3''',
                  'What to do

1. Update the pol_flag to ''5'' (spoiled)

UPDATE gipi_polbasic
   SET pol_flag = ''5''
 WHERE (policy_id, pack_policy_id) IN (
          SELECT b.policy_id, b.pack_policy_id
            FROM gipi_pack_polbasic a, gipi_polbasic b
           WHERE a.pol_flag = ''5''
             AND a.spld_flag = ''3''
             AND a.pack_policy_id = b.pack_policy_id
             AND b.pol_flag <> ''5''
     AND b.spld_flag = ''3'');',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'pol_SpoiledPolFlag',
                  'UW',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  24,
                  'Undistributed policies (if no distribution in UW )',
                  'SELECT a.policy_id,
       get_policy_no (a.policy_id) policy_no, a.par_id, a.endt_type,
       a.tsi_amt, a.prem_amt, a.ann_tsi_amt, a.eff_date, a.expiry_date,
       a.booking_mth, a.booking_year,
       d.user_name
  FROM gipi_polbasic a, giis_subline b, gipi_invoice c, giis_users d
 WHERE a.policy_id = c.policy_id
   AND NOT EXISTS (SELECT ''1''
                     FROM giuw_pol_dist b
                    WHERE a.policy_id = b.policy_id)
   AND a.reg_policy_sw = ''Y''
   AND a.pol_flag != ''5''
   AND NVL (endt_type, ''A'') != ''N''
   AND a.reg_policy_sw = ''Y''
   AND a.subline_cd = b.subline_cd
   AND a.line_cd = b.line_cd
   AND a.user_id = d.user_id
   AND b.op_flag = ''N''',
                  'What to do

1. Go to Underwriting> Distribution> Set-Up Groups for Distribution (Item)
  a. Query the policy 
  b. Then press CREATE ITEMS

2. Go to Underwriting> Distribution> Distribution By Group
  a. Query the policy 
  b. Enter the distribution details
  c. Save then POST DISTRIBUTION',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'pol_AutoCreateDist',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  25,
                  'Undistributed endorsement tax',
                  'SELECT a.policy_id, a.iss_cd, b.dist_no, a.dist_flag,
       b.dist_flag, c.endt_tax, get_policy_no (a.policy_id) policy_no,
       endt_seq_no, e.user_name, d.multi_booking_mm
  FROM gipi_polbasic a,
       giuw_pol_dist b,
       gipi_endttext c,
       gipi_invoice d,
       giis_users e
 WHERE 1 = 1
   AND a.policy_id = b.policy_id
   AND a.policy_id = c.policy_id
   AND a.policy_id = d.policy_id
   AND b.user_id = e.user_id
   AND a.reg_policy_sw = ''Y''
   AND a.pol_flag != ''5''
   AND NVL (a.endt_type, ''A'') != ''N''
   AND b.dist_flag <> ''3''
   AND endt_tax = ''Y''
   AND NOT EXISTS (SELECT ''1''
                     FROM giuw_itemds d
                    WHERE d.dist_no = b.dist_no)',
                  'What to do

1. Update the gipi_polbasic and giuw_pol_dist table with this update statement:
      
UPDATE giuw_pol_dist e
   SET dist_flag = 3
 WHERE EXISTS (
        SELECT ''1''
       FROM gipi_polbasic a, giuw_pol_dist b, gipi_endttext c, gipi_invoice d
           WHERE 1 = 1
             AND a.policy_id = b.policy_id
 AND a.policy_id = d.policy_id 
             AND a.reg_policy_sw = ''Y''
             AND a.pol_flag != ''5''
             AND d.multi_booking_yy = :booking_yy  --for modification
             AND NVL (a.endt_type, ''A'') != ''N''
             AND b.dist_flag <> ''3''
             AND a.policy_id = c.policy_id
             AND endt_tax = ''Y''
             AND NOT EXISTS (SELECT ''1''
                               FROM giuw_itemds d
                              WHERE d.dist_no = b.dist_no)
             AND b.policy_id = e.policy_id);',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'dist_EndtTax',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  26,
                  'No TakeUp Sequence number in GIPI_INVOICE and GIUW_POL_DIST',
                  'SELECT get_policy_no(b.policy_id) policy_no, b.policy_id, a.dist_no, d.user_name
  FROM giuw_pol_dist a, gipi_invoice b, gipi_polbasic c, giis_users d
 WHERE 1 = 1
   AND a.policy_id = b.policy_id
   AND a.policy_id = c.policy_id
   AND a.user_id = d.user_id
   --AND a.dist_flag = 3
   AND c.takeup_term = ''ST''
   AND (a.takeup_seq_no IS NULL OR b.takeup_seq_no IS NULL)',
                  'What to do
1. Run the update script below.

SET SERVEROUTPUT ON;
DECLARE
   v_count   NUMBER := 0;
BEGIN
   FOR upd IN (SELECT b.policy_id, a.dist_no
           FROM gipi_invoice b, giuw_pol_dist a, gipi_polbasic c
                WHERE 1 = 1
                  AND a.policy_id = b.policy_id
                  AND a.policy_id = c.policy_id
                  --AND a.dist_flag = 3
                  AND c.takeup_term = ''ST''
                  AND (a.takeup_seq_no IS NULL OR b.takeup_seq_no IS NULL))
   LOOP
      UPDATE gipi_invoice
         SET takeup_seq_no = 1
       WHERE policy_id = upd.policy_id AND takeup_seq_no IS NULL;

      UPDATE giuw_pol_dist
         SET takeup_seq_no = 1
       WHERE policy_id = upd.policy_id
         AND dist_no = upd.dist_no
         AND takeup_seq_no IS NULL;

      v_count := v_count + 1;
   END LOOP;
   COMMIT;
   DBMS_OUTPUT.put_line (v_count || '' records updated.'');
END;',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'dist_TakeUpSeqNo',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  27,
                  'No records on the distribution details',
                  'SELECT get_policy_no (x.policy_id) policy_no, a.policy_id, a.dist_no,
       x.booking_mth, x.booking_year, a.prem_amt, y.endt_tax, d.user_name
  FROM giuw_pol_dist a, gipi_polbasic x, gipi_endttext y, giis_users d, gipi_invoice e
 WHERE (   (NOT EXISTS (SELECT 1
                          FROM giuw_perilds_dtl b
                         WHERE a.dist_no = b.dist_no))
        OR (NOT EXISTS (SELECT 1
                          FROM giuw_itemperilds_dtl c
                         WHERE a.dist_no = c.dist_no))
       )
   AND a.dist_flag = 3
   AND x.pol_flag != ''5''
   AND x.policy_id = a.policy_id
   AND x.policy_id = e.policy_id
   AND x.policy_id = y.policy_id(+)
   AND a.user_id = d.user_id
   AND NVL (y.endt_tax, ''N'') != ''Y''
   AND a.acct_ent_date IS NULL
   AND NVL (a.prem_amt, 0) != 0',
                  'What to do

 1. Go to Underwriting > Distribution > Populate Missing Distribution Records
 2. Query the policy
 3. Then Press Create Distribution Records',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'dist_Undist',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  28,
                  'Policies with null premium in distribution tables',
                  'SELECT DISTINCT get_policy_no (x.policy_id) policy_no,
                x.policy_id, x.dist_no, y.multi_booking_mm,
                y.multi_booking_yy, x.endt_type, x.prem_amt, x.dist_prem,
                x.user_name
           FROM (SELECT DISTINCT get_policy_no (b.policy_id) policy_no,
                                 b.policy_id, a.dist_no, d.endt_type, c.prem_amt,
                                 a.dist_prem, f.user_name
                            FROM giuw_perilds_dtl a,
                                 giuw_pol_dist b,
                                 gipi_invoice c,
                                 gipi_polbasic d,
                                 giis_users f
                           WHERE a.dist_no = b.dist_no
                             AND b.policy_id = c.policy_id
                             AND b.policy_id = d.policy_id
                             AND b.user_id = f.user_id
                             AND d.pol_flag <> ''5''
                             AND b.dist_flag <> ''4''
                             AND NVL (d.endt_type, ''A'') != ''N''
                             AND b.acct_ent_date IS NULL
                             AND dist_prem IS NULL
                 UNION
                 SELECT DISTINCT get_policy_no (b.policy_id) policy_no,
                                 b.policy_id, a.dist_no, d.endt_type, c.prem_amt,
                                 a.dist_prem, f.user_name
                            FROM giuw_itemperilds_dtl a,
                                 giuw_pol_dist b,
                                 gipi_invoice c,
                                 gipi_polbasic d,
                                 giis_users f
                           WHERE a.dist_no = b.dist_no
                             AND b.policy_id = c.policy_id
                             AND b.policy_id = d.policy_id
                             AND b.user_id = f.user_id
                             AND d.pol_flag <> ''5''
                             AND b.dist_flag <> ''4''
                             AND NVL (d.endt_type, ''A'') != ''N''
                             AND b.acct_ent_date IS NULL
                             AND dist_prem IS NULL) x,
                gipi_invoice y,
                gipi_polbasic z
          WHERE x.policy_id = y.policy_id 
            AND y.policy_id = z.policy_id',
                  'What to do

1. Go to Underwriting> Distribution> Negate Posted Distribution
    a. Query the policy
    b. Press Negate Distribution button

2. Go to Underwriting> Distribution> Set-Up Groups for Distribution (Item)
    a. Query the policy 
    b. Then press CREATE ITEMS

3. Go to Underwriting> Distribution> Distribution By Group
    a. Query the policy 
    b. Enter the distribution details
    c. Save then POST DISTRIBUTION',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'dist_Undist',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  29,
                  'Different item numbers in distribution tables',
                  'SELECT get_policy_no (x.policy_id) policy_no, x.policy_id, x.dist_no,
       x.item_no, y.multi_booking_mm, y.multi_booking_yy, x.user_name
  FROM (SELECT a.policy_id, get_policy_no (a.policy_id) policy_no, b.dist_no,
               c.item_no, f.user_name
          FROM gipi_polbasic a,
               giuw_pol_dist b,
               giuw_itemds c,
               gipi_invoice d,
               giis_users f
         WHERE a.policy_id = b.policy_id
           AND b.dist_no = c.dist_no
           AND a.policy_id = d.policy_id
           AND b.user_id = f.user_id
           AND b.dist_flag <> ''4''
           AND b.acct_ent_date IS NULL
           AND c.item_no NOT IN (SELECT item_no
                                   FROM gipi_item d
                                  WHERE d.policy_id = a.policy_id)
        UNION
        SELECT a.policy_id, get_policy_no (a.policy_id) policy_no, b.dist_no,
               c.item_no, f.user_name
          FROM gipi_polbasic a,
               giuw_pol_dist b,
               giuw_itemds_dtl c,
               gipi_invoice d,
               giis_users f
         WHERE a.policy_id = b.policy_id
           AND b.dist_no = c.dist_no
           AND a.policy_id = d.policy_id
           AND b.user_id = f.user_id
           AND b.dist_flag <> ''4''
           AND b.acct_ent_date IS NULL
           AND c.item_no NOT IN (SELECT item_no
                                   FROM gipi_item d
                                  WHERE d.policy_id = a.policy_id)
        UNION
        SELECT a.policy_id, get_policy_no (a.policy_id) policy_no, b.dist_no,
               c.item_no, f.user_name
          FROM gipi_polbasic a,
               giuw_pol_dist b,
               giuw_itemperilds c,
               gipi_invoice d,
               giis_users f
         WHERE a.policy_id = b.policy_id
           AND b.dist_no = c.dist_no
           AND a.policy_id = d.policy_id
           AND b.user_id = f.user_id
           AND b.dist_flag <> ''4''
           AND b.acct_ent_date IS NULL
           AND c.item_no NOT IN (SELECT item_no
                                   FROM gipi_item d
                                  WHERE d.policy_id = a.policy_id)
        UNION
        SELECT a.policy_id, get_policy_no (a.policy_id) policy_no, b.dist_no,
               c.item_no, f.user_name
          FROM gipi_polbasic a,
               giuw_pol_dist b,
               giuw_itemperilds_dtl c,
               gipi_invoice d,
               giis_users f
         WHERE a.policy_id = b.policy_id
           AND b.dist_no = c.dist_no
           AND a.policy_id = d.policy_id
           AND b.user_id = f.user_id
           AND b.dist_flag <> ''4''
           AND b.acct_ent_date IS NULL
           AND c.item_no NOT IN (SELECT item_no
                                   FROM gipi_item d
                                  WHERE d.policy_id = a.policy_id)) x,
       gipi_invoice y,
       gipi_polbasic z
 WHERE x.policy_id = y.policy_id 
   AND y.policy_id = z.policy_id',
                  'What to do

1. Run this script below.
 SELECT *
    FROM GIPI_ITEM
WHERE policy_id = :policy_id

2. If there''s a record, update the dist_flag column in and set to:  
 a. gipi_polbasic.dist_flag = 1 (Undistributed)
 b. giuw_pol_dist.dist_flag = 1 (Undistributed)

3. Recreate items in UW>Distribution>Set-up Groups for Dist (Item)  (giuws010).
4. Post the distribution of the policy.',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'dist_Undist',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  30,
                  'Posted Distribution without distribution set up',
                  'SELECT a.policy_id, a.iss_cd, a.endt_type, b.dist_no,
       a.dist_flag, b.dist_flag, get_policy_no (a.policy_id) policy_no,
       e.multi_booking_mm, a.tsi_amt, a.prem_amt, f.user_name
  FROM gipi_polbasic a,
       giuw_pol_dist b,
       gipi_endttext c,
       giis_subline d,
       gipi_invoice e,
       giis_users f
 WHERE 1 = 1
   AND a.policy_id = b.policy_id
   AND a.policy_id = c.policy_id(+)
   AND a.line_cd = d.line_cd
   AND a.subline_cd = d.subline_cd
   AND a.policy_id = e.policy_id
   AND b.user_id = f.user_id
   AND d.op_flag = ''N''
   AND c.endt_tax != ''Y''
   AND a.reg_policy_sw = ''Y''
   AND a.pol_flag != ''5''
   AND NVL (a.endt_type, ''A'') != ''N''
   AND b.dist_flag = 3
   AND NOT EXISTS (SELECT ''1''
                     FROM giuw_itemds c
                    WHERE b.dist_no = c.dist_no)',
                  'What to do

Distribute the policy.
1. Go to Underwriting > Distribution > Set-up Groups for Dist (item).
2. Query the policy and press "Create Items" button
3. Group the items and save.
4. Go to Underwriting > Distribution > Distribution by Group.
5. Query the policy and enter the distribution share.
6. Save and post the distribution.',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'dist_Undist',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  31,
                  'Unposted Distribution without distribution set up',
                  'SELECT a.policy_id, a.iss_cd, a.endt_type, b.dist_no,
       a.dist_flag, b.dist_flag, get_policy_no (a.policy_id) policy_no,
       e.multi_booking_mm, a.tsi_amt, a.prem_amt, f.user_name
  FROM gipi_polbasic a,
       giuw_pol_dist b,
       gipi_endttext c,
       giis_subline d,
       gipi_invoice e,
       giis_users f
 WHERE 1 = 1
   AND a.policy_id = b.policy_id
   AND a.policy_id = c.policy_id(+)
   AND a.line_cd = d.line_cd
   AND a.subline_cd = d.subline_cd
   AND a.policy_id = e.policy_id
   AND b.user_id = f.user_id
   AND d.op_flag = ''N''
   AND c.endt_tax != ''Y''
   AND a.reg_policy_sw = ''Y''
   AND a.pol_flag != ''5''
   AND NVL (a.endt_type, ''A'') != ''N''
   AND b.dist_flag IN (''1'', ''2'')
   AND NOT EXISTS (SELECT ''1''
                     FROM giuw_witemds c
                    WHERE b.dist_no = c.dist_no)',
                  'What to do

1. Update the following columns:
 a. gipi_polbasic.dist_flag = 1 
 b. giuw_pol_dist.dist_flag = 1

2. After updating the dist_flag in both tables, set-up the groups (giuws013) for distribution.
3. Distribute the policy',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'dist_Undist',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  32,
                  'Check for unplaced RI Binders: Binder records that do not have records in GIRI_DISTFRPS',
                  'SELECT get_policy_no (x.policy_id) policy_no, x.policy_id, x.dist_no,
       multi_booking_mm, booking_mth, x.user_name
  FROM (SELECT a.dist_no, a.policy_id, get_policy_no (a.policy_id) policy_no,
               d.user_name
          FROM giuw_pol_dist a,
               giuw_policyds_dtl b,
               gipi_polbasic c,
               giis_users d
         WHERE a.dist_no = b.dist_no
           AND b.share_cd = 999
           AND a.policy_id = c.policy_id
           AND a.user_id = d.user_id
           AND c.pol_flag <> ''5''
           AND a.dist_flag = 3
           AND b.dist_spct <> 0
           AND a.acct_ent_date IS NULL
        MINUS
        SELECT a.dist_no, a.policy_id, get_policy_no (a.policy_id),
               d.user_name
          FROM giuw_pol_dist a, giri_distfrps b, giis_users d
         WHERE a.dist_no = b.dist_no 
           AND a.user_id = d.user_id
           AND a.acct_ent_date IS NULL) x,
       gipi_invoice y,
       gipi_polbasic z
 WHERE x.policy_id = y.policy_id
   AND y.policy_id = z.policy_id
   AND z.pol_flag <> ''5''
   AND z.reg_policy_sw = ''Y''',
                  'What to do

1. Update the following columns:
 a. gipi_polbasic.dist_flag = 1
 b. giuw_pol_dist.dist_flag = 1

2. After updating the dist_flag in both tables, set-up the groups (giuws013) for distribution.
3. Distribute the policy',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'dist_Undist',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              DISPLAY_SW)
        VALUES (
                  33,
                  'Distributed policies with facultative but have no FRPS and binder records',
                  'SELECT get_policy_no (e.policy_id) policy_no, e.policy_id, e.dist_no,
       get_binder_no (a.fnl_binder_id) binder_no, a.fnl_binder_id,
       c.user_name
  FROM giri_binder a,
       giri_frps_ri b,
       giis_users c,
       giri_distfrps d,
       giuw_pol_dist e
 WHERE a.fnl_binder_id = b.fnl_binder_id
   AND a.user_id = c.user_id
   AND acc_ent_date IS NOT NULL
   AND acc_rev_date IS NULL
   AND reverse_sw = ''Y''
   AND b.line_cd = d.line_cd
   AND b.frps_yy = d.frps_yy
   AND b.frps_seq_no = d.frps_seq_no
   AND d.dist_no = e.dist_no
   AND d.ri_flag = 3',
                  'What to do

1. Update the dist_flag column in and set to:  
--gipi_polbasic.dist_flag = 1 (Undistributed)

UPDATE gipi_polbasic
   SET dist_flag = ''1''
 WHERE policy_id =
          (SELECT DISTINCT a.policy_id
                      FROM gipi_polbasic a,
                           giuw_pol_dist b,
                           giuw_itemperilds_dtl c,
                           gipi_invoice d
                     WHERE a.policy_id = b.policy_id
                       AND b.dist_no = c.dist_no
                       AND a.policy_id = d.policy_id
                       AND b.dist_flag = ''3''
                       AND c.share_cd = 999
                       AND c.dist_spct <> 0
                       AND d.multi_booking_yy = 2012        --for modification
                       AND d.multi_booking_mm = ''SEPTEMBER'' --for modification
                       AND NOT EXISTS (SELECT ''1''
                                         FROM giri_distfrps d
                                        WHERE d.dist_no = b.dist_no));

Note:  Don''t forget to ''COMMIT''

1. Recreate items in UW>Distribution>Set-up Groups for Dist (Item)  
                      (giuws010).
2. Post the distribution of the policy.UW>Distribution>Distribution by peril

Note: Do these next steps if there is a facultative.
1. Go to FRPS listing and query the policy. (giris006)
2. Create an RI Placement. (giris001)
3. Post the binder.',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'dist_Undist',
                  'UW',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  34,
                  'Different amounts between distribution tables',
                  'SELECT get_policy_no (e.policy_id) policy_no,
       e.policy_id, a.dist_no, a.share_cd, d.booking_mth, d.booking_year,
       a.dist_prem perilds_amt, b.dist_prem itemperilds_amt, f.user_name,
       c.acct_ent_date, c.acct_neg_date
  FROM (SELECT   dist_no, share_cd, SUM (NVL (dist_prem, 0)) dist_prem
            FROM giuw_perilds_dtl
        GROUP BY dist_no, share_cd) a,
       (SELECT   dist_no, share_cd, SUM (NVL (dist_prem, 0)) dist_prem
            FROM giuw_itemperilds_dtl
        GROUP BY dist_no, share_cd) b,
       giuw_pol_dist c,
       gipi_polbasic d,
       gipi_invoice e,
       giis_users f
 WHERE 1 = 1
   AND a.dist_no = b.dist_no
   AND a.dist_no = c.dist_no
   AND c.policy_id = d.policy_id
   AND c.policy_id = e.policy_id
   AND a.share_cd = b.share_cd
   AND c.user_id = f.user_id
   AND ABS (NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0)) > 0.99
   AND c.dist_flag = ''3'' 
   AND c.acct_ent_date IS NULL
',
                  'What to do

 1.Run the script below:

DELETE FROM GIUW_PERILDS_DTL
WHERE DIST_NO = :DIST_NO --DIST_NO;
    
2.Go to Underwriting> Distribution> Populate Missing Distribution Records
       a. Query the policy 
 b. Then press CREATE DISTRIBUTION RECORDS
',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'dist_Undist',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  35,
                  'Invoice currency rate is different from distribution',
                  'SELECT b.currency_rt inv_rate,
       d.currency_rt frps_rate,
       get_policy_no (a.policy_id) policy_no,
       a.policy_id,
       b.iss_cd,
       b.prem_seq_no,
       f.line_cd || ''-'' || f.binder_yy || ''-'' || LPAD (f.binder_seq_no, 5, 0)
          binder_no,
       a.booking_mth,
       a.booking_year,
       d.dist_no,
       d.dist_seq_no,
       g.user_name
  FROM gipi_polbasic a,
       gipi_invoice b,
       giuw_pol_dist c,
       giri_distfrps d,
       giri_frps_ri e,
       giri_binder f,
       giis_users g
 WHERE     a.policy_id = b.policy_id
       AND a.policy_id = c.policy_id
       AND c.dist_no = d.dist_no
       AND b.item_grp = c.item_grp
       AND a.line_cd = d.line_cd
       AND d.line_cd = e.line_cd
       AND d.frps_yy = e.frps_yy
       AND d.frps_seq_no = e.frps_seq_no
       AND e.fnl_binder_id = f.fnl_binder_id
       AND b.user_id = g.user_id
       AND b.currency_rt != d.currency_rt
       AND a.pol_flag != ''5''
       AND c.acct_ent_date IS NULL',
                  'What to do

 For records found consult CPI
',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'dist_CurrencyRt',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              CHECK_BOOK_DATE,
                                              DISPLAY_SW)
        VALUES (
                  36,
                  'Different Premium, Commission and Commission Vat amount in table GIRI_BINDER and GIRI_FRPERIL',
                  'SELECT get_policy_no (w.policy_id) policy_no,
       w.policy_id,
       get_binder_no (y.fnl_binder_id) binder_no,
       y.fnl_binder_id,
       y.ri_cd,
       y.ri_seq_no,
       y.ri_prem_amt,
       y.ri_comm_amt,
       y.ri_comm_vat,
       prem_diff,
       comm_diff,
       comm_vat_diff,
       x.user_id
  FROM giri_distfrps x,
       giuw_pol_dist z,
       gipi_polbasic w,
       gipi_invoice a,
       (SELECT c.fnl_binder_id,
               c.line_cd,
               d.frps_yy,
               d.frps_seq_no,
               d.ri_seq_no,
               c.ri_cd,
               c.ri_prem_amt,
               prem_frperil,
               c.ri_prem_amt - prem_frperil prem_diff,
               c.ri_comm_amt,
               comm_frperil,
               c.ri_comm_amt - comm_frperil comm_diff,
               c.ri_comm_vat,
               vat_frperil,
               c.ri_comm_vat - vat_frperil comm_vat_diff
          FROM (SELECT fnl_binder_id,
                       line_cd,
                       ri_cd,
                       ri_prem_amt,
                       ri_comm_amt,
                       ri_comm_vat
                  FROM cpi.giri_binder
                 WHERE (   acc_ent_date IS NULL AND reverse_date IS NULL
                        OR (    reverse_date IS NOT NULL
                            AND acc_rev_date IS NULL
                            AND acc_ent_date IS NOT NULL))) c,
               (  SELECT b.fnl_binder_id,
                         a.line_cd,
                         a.frps_yy,
                         a.frps_seq_no,
                         a.ri_seq_no,
                         SUM (a.ri_prem_amt) prem_frperil,
                         SUM (a.ri_comm_amt) comm_frperil,
                         SUM (a.ri_comm_vat) vat_frperil
                    FROM cpi.giri_frperil a, cpi.giri_frps_ri b
                   WHERE     a.line_cd = b.line_cd
                         AND a.frps_yy = b.frps_yy
                         AND a.frps_seq_no = b.frps_seq_no
                         AND a.ri_seq_no = b.ri_seq_no
                GROUP BY b.fnl_binder_id,
                         a.line_cd,
                         a.frps_yy,
                         a.frps_seq_no,
                         a.ri_seq_no) d
         WHERE     c.fnl_binder_id = d.fnl_binder_id
               AND (   c.ri_prem_amt <> prem_frperil
                    OR c.ri_comm_amt <> comm_frperil
                    OR c.ri_comm_vat <> vat_frperil)) y
 WHERE     x.line_cd = y.line_cd
       AND x.frps_yy = y.frps_yy
       AND x.frps_seq_no = y.frps_seq_no
       AND x.dist_no = z.dist_no
       AND z.policy_id = w.policy_id
       AND z.policy_id = a.policy_id
       AND (   (z.dist_flag = ''3'' AND z.acct_ent_date IS NULL)
            OR (    z.dist_flag IN (''4'', ''5'')
                AND z.acct_ent_date IS NOT NULL
                AND z.acct_neg_date IS NULL))',
                  'What to do

 1. Run the update script below.

SET SERVEROUTPUT ON;

BEGIN
   FOR rec1 IN (SELECT   w.subline_cd, w.iss_cd, w.issue_yy, w.pol_seq_no,
                         w.renew_no, y.fnl_binder_id, y.ri_cd, y.ri_seq_no,
                         y.ri_prem_amt, y.ri_comm_amt, y.ri_comm_vat,
                         x.line_cd, x.frps_yy, x.frps_seq_no
                    FROM cpi.giri_distfrps x,
                         cpi.giuw_pol_dist z,
                         cpi.gipi_polbasic w,
                         (SELECT c.fnl_binder_id, c.line_cd, d.frps_yy,
                                 d.frps_seq_no, d.ri_seq_no, c.ri_cd,
                                 c.ri_prem_amt, prem_frperil,
                                 c.ri_prem_amt - prem_frperil prem_diff,
                                 c.ri_comm_amt, comm_frperil,
                                 c.ri_comm_amt - comm_frperil comm_diff,
                                 c.ri_comm_vat, vat_frperil,
                                 c.ri_comm_vat - vat_frperil comm_vat_diff
                            FROM (SELECT fnl_binder_id, line_cd, ri_cd,
                                         ri_prem_amt, ri_comm_amt,
                                         ri_comm_vat
                                    FROM cpi.giri_binder
                                   WHERE (       acc_ent_date IS NULL
                                             AND reverse_date IS NULL
                                          OR (    reverse_date IS NOT NULL
                                              AND acc_rev_date IS NULL
                                              AND acc_ent_date IS NOT NULL
                                             )
                                         )) c,
                                 (SELECT   b.fnl_binder_id, a.line_cd,
                                           a.frps_yy, a.frps_seq_no,
                                           a.ri_seq_no,
                                           SUM (a.ri_prem_amt) prem_frperil,
                                           SUM (a.ri_comm_amt) comm_frperil,
                                           SUM (a.ri_comm_vat) vat_frperil
                                      FROM cpi.giri_frperil a,
                                           cpi.giri_frps_ri b
                                     WHERE a.line_cd = b.line_cd
                                       AND a.frps_yy = b.frps_yy
                                       AND a.frps_seq_no = b.frps_seq_no
                                       AND a.ri_seq_no = b.ri_seq_no
                                  GROUP BY b.fnl_binder_id,
                                           a.line_cd,
                                           a.frps_yy,
                                           a.frps_seq_no,
                                           a.ri_seq_no) d
                           WHERE c.fnl_binder_id = d.fnl_binder_id
                             AND (   c.ri_prem_amt <> prem_frperil
                                  OR c.ri_comm_amt <> comm_frperil
                                  OR c.ri_comm_vat <> vat_frperil
                                 )) y
                   WHERE x.line_cd = y.line_cd
                     AND x.frps_yy = y.frps_yy
                     AND x.frps_seq_no = y.frps_seq_no
                     AND x.dist_no = z.dist_no
                     AND z.policy_id = w.policy_id
                     AND (   (z.dist_flag = ''3'' AND z.acct_ent_date IS NULL)
                          OR (    z.dist_flag IN (''4'', ''5'')
                              AND z.acct_ent_date IS NOT NULL
                              AND z.acct_neg_date IS NULL
                             )
                         )
                ORDER BY y.fnl_binder_id,
                         w.line_cd,
                         w.subline_cd,
                         w.iss_cd,
                         w.issue_yy,
                       ',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'binder_Amounts',
                  'UW',
                  'Y',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              DISPLAY_SW)
        VALUES (
                  37,
                  'Direct Claims inserted in Inward Claim Payment',
                  'SELECT get_ref_no (a.gacc_tran_id) ref_no, a.gacc_tran_id,
       get_claim_number (a.claim_id) claim_no, a.claim_id, a.advice_id,
       a.clm_loss_id, a.disbursement_amt
  FROM giac_inw_claim_payts a, giac_acctrans b, gicl_claims c
 WHERE a.gacc_tran_id = b.tran_id
   AND b.tran_flag IN (''C'', ''P'')
   AND a.claim_id = c.claim_id
   AND c.pol_iss_cd != ''RI''',
                  'What to do

 1. Run the script below.

SET SERVEROUTPUT ON;

DECLARE
   v_count   NUMBER := 0;
BEGIN
   FOR j IN (SELECT get_ref_no (a.gacc_tran_id) ref_no, a.gacc_tran_id,
                    get_claim_number (a.claim_id) claim_no, a.claim_id,
                    a.advice_id, a.clm_loss_id, a.disbursement_amt
               FROM giac_inw_claim_payts a, giac_acctrans b, gicl_claims c
              WHERE a.gacc_tran_id = b.tran_id
                AND b.tran_flag IN (''C'', ''P'')
                AND a.claim_id = c.claim_id
                AND c.pol_iss_cd != ''RI''
                AND NOT EXISTS (
                       SELECT ''X''
                         FROM giac_direct_claim_payts
                        WHERE gacc_tran_id = a.gacc_tran_id
                          AND claim_id = a.claim_id
                          AND clm_loss_id = a.clm_loss_id
                          AND advice_id = a.advice_id))
   LOOP
      INSERT INTO giac_direct_claim_payts
         SELECT *
           FROM giac_inw_claim_payts
          WHERE gacc_tran_id = j.gacc_tran_id
            AND claim_id = j.claim_id
            AND clm_loss_id = j.clm_loss_id
            AND advice_id = j.advice_id;

      DELETE FROM giac_inw_claim_payts
            WHERE gacc_tran_id = j.gacc_tran_id
              AND claim_id = j.claim_id
              AND clm_loss_id = j.clm_loss_id
              AND advice_id = j.advice_id;

      v_count := v_count + 1;
   END LOOP;

   COMMIT;
   
END;   ',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'claim_DirectPayt',
                  'CL',
                  'N');

   INSERT INTO CPI.GIAC_EOM_CHECKING_SCRIPTS (EOM_SCRIPT_NO,
                                              EOM_SCRIPT_TITLE,
                                              EOM_SCRIPT_TEXT_1,
                                              EOM_SCRIPT_SOLN,
                                              USER_ID,
                                              LAST_UPDATE,
                                              EOM_SCRIPT_TAG,
                                              SCRIPT_TYPE,
                                              DISPLAY_SW)
        VALUES (
                  38,
                  'Claim Payment with no reference on distribution tables',
                  'SELECT get_claim_number (a.claim_id) claim_no, a.claim_id, a.clm_res_hist_id,
       get_ref_no (a.tran_id) ref_no, a.clm_loss_id
  FROM gicl_clm_res_hist a, giac_acctrans b
 WHERE a.tran_id = b.tran_id
   AND b.tran_flag IN (''C'', ''P'')
   AND a.dist_no IS NULL
   AND NOT EXISTS (
          SELECT   1
              FROM gicl_loss_exp_ds c
             WHERE NVL (c.negate_tag, ''N'') = ''N''
               AND c.claim_id = a.claim_id
               AND c.clm_loss_id = a.clm_loss_id
          GROUP BY c.claim_id, c.clm_loss_id
            HAVING COUNT (DISTINCT c.clm_dist_no) > 1)
   AND EXISTS (
          SELECT 1
            FROM gicl_loss_exp_ds c
           WHERE NVL (c.negate_tag, ''N'') = ''N''
             AND c.claim_id = a.claim_id
             AND c.clm_loss_id = a.clm_loss_id)',
                  'What to do

 1. Run the script below.

UPDATE gicl_clm_res_hist a
   SET dist_no =
          (SELECT DISTINCT b.clm_dist_no
                      FROM gicl_loss_exp_ds b
                     WHERE b.claim_id = a.claim_id
                       AND b.clm_loss_id = a.clm_loss_id
                       AND NVL (b.negate_tag, ''N'') = ''N'')
 WHERE EXISTS (
          SELECT 1
            FROM giac_acctrans b
           WHERE b.tran_id = a.tran_id
             AND b.tran_flag IN (''C'', ''P'')
             AND b.tran_date BETWEEN :p_from_date AND :p_to_date)
   AND a.dist_no IS NULL
   AND NOT EXISTS (
          SELECT   1
              FROM gicl_loss_exp_ds d
             WHERE NVL (d.negate_tag, ''N'') = ''N''
               AND d.claim_id = a.claim_id
               AND d.clm_loss_id = a.clm_loss_id
          GROUP BY d.claim_id, d.clm_loss_id
            HAVING COUNT (DISTINCT d.clm_dist_no) > 1)
   AND EXISTS (
          SELECT 1
            FROM gicl_loss_exp_ds d
           WHERE NVL (d.negate_tag, ''N'') = ''N''
             AND d.claim_id = a.claim_id
             AND d.clm_loss_id = a.clm_loss_id);

 COMMIT;',
                  'CPI',
                  TO_DATE ('08/16/2016 14:38:31', 'MM/DD/YYYY HH24:MI:SS'),
                  'claim_DistNo',
                  'CL',
                  'N');

   COMMIT;
END;
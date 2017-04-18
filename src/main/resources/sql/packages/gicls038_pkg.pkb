CREATE OR REPLACE PACKAGE BODY CPI.gicls038_pkg
AS
   FUNCTION get_reserve_list (
      p_line_cd   gicl_claims.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN reserve_tab PIPELINED
   AS
      v_list   reserve_type;
   BEGIN
      FOR i IN (SELECT   a.claim_id, a.line_cd, a.subline_cd, a.iss_cd,
                         a.clm_yy, a.clm_seq_no, a.pol_iss_cd, a.issue_yy,
                         a.pol_seq_no, a.renew_no, b.clm_res_hist_id,
                         b.hist_seq_no, b.item_no, b.peril_cd,
                         b.loss_reserve, b.expense_reserve, a.clm_file_date,
                         a.loss_date, a.pol_eff_date eff_date, a.expiry_date,
                         a.catastrophic_cd, b.grouped_item_no, b.currency_cd,
                         b.convert_rate,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0000009'))
                                                                    claim_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (renew_no, '09')) policy_no
                    FROM gicl_claims a, gicl_clm_res_hist b
                   WHERE b.claim_id = a.claim_id
                     AND b.dist_sw = 'Y'
                     AND b.tran_id IS NULL
                     AND a.clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND check_user_per_iss_cd_acctg2 (a.line_cd,
                                                       a.iss_cd,
                                                       'GICLS038',
                                                       p_user_id
                                                      ) = 1
                     AND check_user_per_line2 (a.line_cd,
                                               a.iss_cd,
                                               'GICLS038',
                                               p_user_id
                                              ) = 1
                ORDER BY a.claim_id)
      LOOP
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.item_no := i.item_no;
         v_list.peril_cd := i.peril_cd;
         v_list.loss_reserve := NVL (i.loss_reserve, 0);
         v_list.expense_reserve := NVL (i.expense_reserve, 0);
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.clm_yy := i.clm_yy;
         v_list.clm_seq_no := i.clm_seq_no;
         v_list.pol_iss_cd := i.pol_iss_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.claim_id := i.claim_id;
         v_list.loss_date := i.loss_date;
         v_list.grouped_item_no := i.grouped_item_no;
         v_list.currency_cd := i.currency_cd;
         v_list.convert_rate := i.convert_rate;
         v_list.catastrophic_cd := i.catastrophic_cd;
         v_list.clm_file_date := i.clm_file_date;

         BEGIN
            --SELECT peril_cd || ' - ' || peril_name
            SELECT peril_name
              INTO v_list.dsp_peril_sname
              FROM giis_peril
             WHERE line_cd = i.line_cd AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.dsp_peril_sname := 'N/A';
            WHEN TOO_MANY_ROWS
            THEN
               v_list.dsp_peril_sname := 'N/A';
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_reserve_list;

   FUNCTION get_lossexpense_list (
      p_line_cd   gicl_claims.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN lossexpense_tab PIPELINED
   AS
      v_list   lossexpense_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd,
                          a.clm_yy, a.clm_seq_no, a.pol_iss_cd, a.issue_yy,
                          a.pol_seq_no, a.renew_no, b.hist_seq_no,
                          b.item_stat_cd, b.item_no, b.grouped_item_no,
                          b.peril_cd, b.currency_cd, b.currency_rate,
                          b.payee_type, b.payee_class_cd, b.payee_cd,
                          b.paid_amt, b.net_amt, b.advise_amt,
                          a.clm_file_date, a.loss_date,
                          a.pol_eff_date eff_date, a.expiry_date,
                          b.clm_loss_id, a.catastrophic_cd,
                             a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.clm_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.clm_seq_no, '0000009'))
                                                                    claim_no,
                             a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.pol_iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                          || '-'
                          || LTRIM (TO_CHAR (renew_no, '09')) policy_no
                     FROM gicl_claims a,
                          gicl_clm_loss_exp b,
                          gicl_loss_exp_ds c
                    WHERE b.claim_id = a.claim_id
                      AND c.claim_id = b.claim_id
                      AND c.clm_loss_id = b.clm_loss_id
                      AND b.dist_sw = 'Y'
                      AND b.tran_id IS NULL
                      AND b.advice_id IS NULL
                      AND c.clm_dist_no IN (
                             SELECT MAX (clm_dist_no) clm_dist_no
                               FROM gicl_loss_exp_ds
                              WHERE clm_loss_id = b.clm_loss_id
                                AND claim_id = a.claim_id)
                      AND a.clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                      AND a.line_cd = NVL (p_line_cd, a.line_cd)
                      AND check_user_per_iss_cd_acctg2 (a.line_cd,
                                                        a.iss_cd,
                                                        'GICLS038',
                                                        p_user_id
                                                       ) = 1
                      AND check_user_per_line2 (a.line_cd,
                                                a.iss_cd,
                                                'GICLS038',
                                                p_user_id
                                               ) = 1
                 ORDER BY claim_id)
      LOOP
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.hist_seq_no := i.hist_seq_no;
         v_list.item_stat_cd := i.item_stat_cd;
         v_list.item_no := i.item_no;
         v_list.grouped_item_no := i.grouped_item_no;
         v_list.peril_cd := i.peril_cd;
         v_list.currency_cd := i.currency_cd;
         v_list.currency_rate := i.currency_rate;
         v_list.payee_type := i.payee_type;
         v_list.payee_cd := i.payee_cd;
         v_list.paid_amt := i.paid_amt;
         v_list.net_amt := i.net_amt;
         v_list.advise_amt := i.advise_amt;
         v_list.subline_cd := i.subline_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.clm_yy := i.clm_yy;
         v_list.clm_seq_no := i.clm_seq_no;
         v_list.pol_iss_cd := i.pol_iss_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.claim_id := i.claim_id;
         v_list.clm_loss_id := i.clm_loss_id;
         v_list.loss_date := i.loss_date;
         v_list.eff_date := i.eff_date;
         v_list.expiry_date := i.expiry_date;
         v_list.catastrophic_cd := i.catastrophic_cd;
         v_list.line_cd := i.line_cd;
         v_list.clm_file_date := i.clm_file_date;

         BEGIN
            --SELECT peril_cd || ' - ' || peril_name
            SELECT peril_name
              INTO v_list.dsp_peril_sname
              FROM giis_peril
             WHERE line_cd = i.line_cd AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.dsp_peril_sname := 'N/A';
            WHEN TOO_MANY_ROWS
            THEN
               v_list.dsp_peril_sname := 'N/A';
         END;

         BEGIN
            SELECT    payee_last_name
                   || ', '
                   || payee_first_name
                   || ' '
                   || payee_middle_name
              INTO v_list.dsp_payee_name
              FROM giis_payees
             WHERE payee_no = i.payee_cd AND payee_class_cd = i.payee_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.dsp_payee_name := 'N/A';
            WHEN TOO_MANY_ROWS
            THEN
               v_list.dsp_payee_name := 'N/A';
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_lossexpense_list;

   FUNCTION get_subline_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN subline_tab PIPELINED
   IS
      v_list   subline_type;
   BEGIN
      FOR i IN (SELECT subline_cd, subline_name
                  FROM giis_subline
                 WHERE 1 = 1
                   AND line_cd = NVL (p_line_cd, line_cd)
                   AND (   UPPER (subline_cd) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                        OR UPPER (subline_name) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                       ))
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_subline_lov;

   FUNCTION get_branch_lov (
      p_line_cd   giis_line.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN branch_tab PIPELINED
   IS
      v_list   branch_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE 1 = 1
                   AND check_user_per_iss_cd_acctg2 (p_line_cd,
                                                     iss_cd,
                                                     'GICLS038',
                                                     p_user_id
                                                    ) = 1
                   AND check_user_per_line2 (p_line_cd,
                                             iss_cd,
                                             'GICLS038',
                                             p_user_id
                                            ) = 1
                   AND (   UPPER (iss_cd) LIKE UPPER (NVL (p_keyword, '%'))
                        OR UPPER (iss_name) LIKE UPPER (NVL (p_keyword, '%'))
                       ))
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_branch_lov;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.gipir923c_pkg
AS
/* ******************************************************** **
** Created By: Benjo Brito
** Date Created: 06.25.2015
** GENQA-AFPGEN-IMPLEM-SR-4616 : UW-SPECS-2015-054-FULLWEB
** ******************************************************** */
   FUNCTION get_report_details (
      p_tab          VARCHAR2,
      p_iss_param    NUMBER,
      p_scope        NUMBER,
      p_line_cd      VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2,
      p_reinstated VARCHAR2 
   )
      RETURN get_details_tab PIPELINED
   AS
      v_rec          get_details_type;
      v_param_date   gipi_uwreports_ext.param_date%TYPE;
      v_from_date    gipi_uwreports_ext.from_date%TYPE;
      v_to_date      gipi_uwreports_ext.TO_DATE%TYPE;
   BEGIN
      SELECT param_date, from_date, TO_DATE
        INTO v_param_date, v_from_date, v_to_date
        FROM gipi_uwreports_ext
       WHERE user_id = p_user_id AND tab_number = p_tab AND ROWNUM = 1;

      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');

      SELECT DECODE (v_param_date,
                     3, 'List of Cancelled Policies',
                     4, 'List of Spoiled Policies',
                     'Detailed Production Register'
                    )
        INTO v_rec.report_title
        FROM DUAL;

      SELECT    DECODE (v_param_date,
                        1, 'Based on Issue Date',
                        2, 'Based on Inception Date',
                        3, 'Based on Booking month - year',
                        'Based on Acctg Entry Date'
                       )
             || '/'
             || DECODE (p_scope,
                        1, 'Policies Only',
                        2, 'Endorsements Only',
                        'Policies and Endorsements'
                       )
        INTO v_rec.based_on
        FROM DUAL;

      IF v_param_date = 3
      THEN
         IF TO_CHAR (v_from_date, 'MMYYYY') = TO_CHAR (v_to_date, 'MMYYYY')
         THEN
            v_rec.heading :=
                'For the month of ' || TO_CHAR (v_from_date, 'fmMonth, yyyy');
         ELSE
            v_rec.heading :=
                  'For the period of '
               || TO_CHAR (v_from_date, 'fmMonth, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth, yyyy');
         END IF;
      ELSE
         IF v_from_date = v_to_date
         THEN
            v_rec.heading :=
                          'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
         ELSE
            v_rec.heading :=
                  'For the period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
         END IF;
      END IF;

      FOR i IN
         ( -- jhing 08.26.2015 commented out. Replace the query with a union to display both acct and spld acct entries and to cater to the changes on the 
          -- extract table. 
         /* SELECT   DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd ) branch_cd, a.line_cd, a.subline_cd,
                   TO_NUMBER (NVL (TO_CHAR (DECODE (a.rec_type, 'R', a.spld_acct_ent_date, a.acct_ent_date), 'RRRRMM'), '0')) acct_seq,
                   NVL (TO_CHAR (DECODE (a.rec_type, 'R', a.spld_acct_ent_date, a.acct_ent_date), 'FmMonth, RRRR'), 'NOT TAKEN UP') acct_ent_date,
                   a.policy_id, a.assd_no, a.issue_date, a.incept_date, a.expiry_date, a.spld_date, 
                   SUM (a.total_tsi) total_tsi,
                   SUM (a.total_prem) total_prem, 
                   SUM (a.evatprem) evatprem,
                   SUM (a.lgt) lgt, 
                   SUM (a.doc_stamps) doc_stamps,
                   SUM (a.fst) fst, 
                   SUM (a.other_taxes) other_taxes,
                   a.other_charges
              FROM gipi_uwreports_ext a
             WHERE a.tab_number = p_tab
               AND a.user_id = p_user_id
               AND DECODE (p_iss_param, 1, NVL (a.cred_branch, a.iss_cd), a.iss_cd) =
                      NVL (p_iss_cd, DECODE (p_iss_param, 1, NVL (a.cred_branch, a.iss_cd), a.iss_cd))
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
               AND (   (p_scope = 1 AND a.endt_seq_no = 0)
                    OR (p_scope = 2 AND a.endt_seq_no <> 0)
                    OR (p_scope = 3 AND a.pol_flag = '4')
                    OR (p_scope = 4 AND a.pol_flag = '5')
                    OR (p_scope = 5 AND a.pol_flag <> '5')
                   )
          GROUP BY DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                   a.line_cd,
                   a.subline_cd,
                   a.rec_type,
                   a.spld_acct_ent_date,
                   a.acct_ent_date,
                   a.policy_id,
                   a.assd_no,
                   a.issue_date,
                   a.incept_date,
                   a.expiry_date,
                   a.spld_date,
                   a.other_charges
          ORDER BY acct_seq,
                   DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                   a.line_cd,
                   a.subline_cd,
                   a.policy_id*/
                   -- jhing revised query 08.26.2015 
                  SELECT rownum,
                         tx.acctg_seq acct_seq,
                         tx.acctg_seq_year,
                         tx.acct_ent_date,
                         tx.line_cd,
                         tx.subline_cd,
                         tx.iss_cd,
                         tx.iss_cd_header branch_cd,
                         tx.cred_branch,
                         tx.issue_yy,
                         tx.pol_seq_no,
                         tx.renew_no,
                         tx.endt_iss_cd,
                         tx.endt_yy,
                         tx.endt_seq_no,
                         tx.policy_no,
                         tx.issue_date,
                         tx.incept_date,
                         tx.expiry_date,
                         tx.spld_date, 
                         SUM (tx.total_tsi) total_tsi,
                         SUM (tx.total_prem) total_prem,
                         SUM (tx.evatprem) evatprem,
                         SUM (tx.lgt) lgt,
                         SUM (tx.doc_stamps) doc_stamps,
                         SUM (tx.fst) fst,
                         SUM (tx.other_taxes) other_taxes,
                         SUM (tx.total_charges) total_charges,
                         tx.param_date,
                         tx.from_date,
                         tx.TO_DATE,
                         tx.scope,
                         tx.user_id,
                         tx.policy_id,
                         tx.assd_no,
                         tx.record_flag
                    FROM (SELECT TO_NUMBER (NVL (TO_CHAR (acct_ent_date, 'MM'), '13'))
                                    acctg_seq,
                                 TO_NUMBER (NVL (TO_CHAR (acct_ent_date, 'YYYY'), '9999'))
                                    acctg_seq_year,
                                 NVL (TO_CHAR (acct_ent_date, 'FmMonth, RRRR'), 'NOT TAKEN UP')
                                    acct_ent_date,
                                 line_cd,
                                 subline_cd,
                                 iss_cd,
                                 cred_branch,
                                 DECODE (p_iss_param,
                                         1, NVL (a.cred_branch, a.iss_cd),
                                         a.iss_cd)
                                    iss_cd_header,
                                 issue_yy,
                                 pol_seq_no,
                                 renew_no,
                                 endt_iss_cd,
                                 endt_yy,
                                 endt_seq_no,
                                 get_policy_no (policy_id) policy_no,
                                 issue_date,
                                 incept_date,
                                 expiry_date,
                                 spld_date, 
                                 NVL (total_tsi, 0) total_tsi,
                                 NVL (total_prem, 0) total_prem,
                                 NVL (evatprem, 0) evatprem,
                                 NVL (lgt, 0) lgt,
                                 NVL (doc_stamps, 0) doc_stamps,
                                 NVL (fst, 0) fst,
                                 NVL (other_taxes, 0) other_taxes,
                                 (  NVL (total_prem, 0)
                                  + NVL (evatprem, 0)
                                  + NVL (lgt, 0)
                                  + NVL (doc_stamps, 0)
                                  + NVL (fst, 0)
                                  + NVL (other_taxes, 0))
                                    total_charges,
                                 param_date,
                                 from_date,
                                 TO_DATE,
                                 scope,
                                 user_id,
                                 policy_id,
                                 assd_no,
                                 'O' record_flag
                            FROM gipi_uwreports_ext a
                           WHERE     user_id = p_user_id
                                 AND DECODE (p_iss_param,
                                             1, NVL (a.cred_branch, a.iss_cd),
                                             a.iss_cd) =
                                        NVL (
                                           p_iss_cd,
                                           DECODE (p_iss_param,
                                                   1, NVL (a.cred_branch, a.iss_cd),
                                                   a.iss_cd))
                                 AND line_cd = NVL (p_line_cd, line_cd)
                                 AND subline_cd = NVL (p_subline_cd, subline_cd)
                                 AND (   (    p_scope = 5
                                          AND endt_seq_no = endt_seq_no
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 1
                                          AND endt_seq_no = 0
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 2
                                          AND endt_seq_no > 0
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 4
                                          AND pol_flag = '5'
                                          AND NVL (reinstate_tag, 'N') =
                                                 DECODE (NVL (p_reinstated, 'N'),
                                                         'N', NVL (reinstate_tag, 'N'),
                                                         'Y'))
                                      OR p_scope = 6) --Added by pjsntos 03/15/2017, GENQA 5955
                          UNION
                          SELECT TO_NUMBER (NVL (TO_CHAR (spld_acct_ent_date, 'MM'), '13'))
                                    acctg_seq,
                                 TO_NUMBER (NVL (TO_CHAR (spld_acct_ent_date, 'YYYY'), '9999'))
                                    acctg_seq_year,
                                 NVL (TO_CHAR (spld_acct_ent_date, 'FmMonth, RRRR'),
                                      'NOT TAKEN UP')
                                    acct_ent_date,
                                 line_cd,
                                 subline_cd,
                                 iss_cd,
                                 cred_branch,
                                 DECODE (p_iss_param,
                                         1, NVL (a.cred_branch, a.iss_cd),
                                         a.iss_cd)
                                    iss_cd_header,
                                 issue_yy,
                                 pol_seq_no,
                                 renew_no,
                                 endt_iss_cd,
                                 endt_yy,
                                 endt_seq_no,
                                 get_policy_no (policy_id) || '*' policy_no,
                                 issue_date,
                                 incept_date,
                                 expiry_date,
                                 spld_date,
                                 -1 * NVL (total_tsi, 0) total_tsi,
                                 -1 * NVL (total_prem, 0) total_prem,
                                 -1 * NVL (evatprem, 0) evatprem,
                                 -1 * NVL (lgt, 0) lgt,
                                 -1 * NVL (doc_stamps, 0) doc_stamp,
                                 -1 * NVL (fst, 0) fst,
                                 -1 * NVL (other_taxes, 0) other_taxes,
                                   -1
                                 * (  NVL (total_prem, 0)
                                    + NVL (evatprem, 0)
                                    + NVL (lgt, 0)
                                    + NVL (doc_stamps, 0)
                                    + NVL (fst, 0)
                                    + NVL (other_taxes, 0))
                                    total_charges,
                                 param_date,
                                 from_date,
                                 TO_DATE,
                                 scope,
                                 user_id,
                                 policy_id,
                                 assd_no,
                                 'R' record_flag
                            FROM gipi_uwreports_ext a
                           WHERE     user_id = p_user_id
                                 AND DECODE (p_iss_param,
                                             1, NVL (a.cred_branch, a.iss_cd),
                                             a.iss_cd) =
                                        NVL (
                                           p_iss_cd,
                                           DECODE (p_iss_param,
                                                   1, NVL (a.cred_branch, a.iss_cd),
                                                   a.iss_cd))
                                 AND line_cd = NVL (p_line_cd, line_cd)
                                 AND subline_cd = NVL (p_subline_cd, subline_cd)
                                 AND (   (    p_scope = 5
                                          AND endt_seq_no = endt_seq_no
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 1
                                          AND endt_seq_no = 0
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 2
                                          AND endt_seq_no > 0
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 4
                                          AND pol_flag = '5'
                                          AND NVL (reinstate_tag, 'N') =
                                                 DECODE (NVL (p_reinstated, 'N'),
                                                         'N', NVL (reinstate_tag, 'N'),
                                                         'Y'))
                                      OR p_scope = 6)--Added by pjsntos 03/15/2017, GENQA 5955
                                 AND spld_acct_ent_date IS NOT NULL) tx
                   WHERE tx.user_id = p_user_id
                GROUP BY tx.policy_id,
                         tx.acctg_seq,
                         tx.acctg_seq_year,
                         tx.acct_ent_date,
                         tx.line_cd,
                         tx.subline_cd,
                         tx.iss_cd,
                         tx.iss_cd_header,
                         tx.cred_branch,
                         tx.issue_yy,
                         tx.pol_seq_no,
                         tx.renew_no,
                         tx.endt_iss_cd,
                         tx.endt_yy,
                         tx.endt_seq_no,
                         tx.policy_no,
                         tx.issue_date,
                         tx.incept_date,
                         tx.expiry_date,
                         tx.spld_date,
                         tx.param_date,
                         tx.from_date,
                         tx.TO_DATE,
                         tx.scope,
                         tx.user_id,
                         tx.policy_id,
                         tx.assd_no,
                         tx.record_flag,
                         rownum
                ORDER BY tx.acctg_seq,
                         tx.acctg_seq_year,
                         tx.line_cd,
                         tx.subline_cd,
                         tx.iss_cd,
                         tx.issue_yy,
                         tx.pol_seq_no,
                         tx.renew_no,
                         tx.endt_iss_cd,
                         tx.endt_yy,
                         tx.endt_seq_no      )
      LOOP
         v_rec.branch_cd := i.branch_cd;
         v_rec.branch_name := get_iss_name (i.branch_cd);
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := get_line_name (i.line_cd);
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := get_subline_name (i.subline_cd);
         v_rec.acct_seq := i.acct_seq;
         v_rec.acct_ent_date := i.acct_ent_date;
         v_rec.policy_id := i.policy_id;
         v_rec.policy_no := get_policy_no (i.policy_id);
         v_rec.assd_name := SUBSTR(get_assd_name (i.assd_no), 1, 50);
         v_rec.issue_date := get_date_format (i.issue_date);
         v_rec.incept_date := get_date_format (i.incept_date);
         v_rec.expiry_date := get_date_format (i.expiry_date);
         v_rec.spld_date := get_date_format (i.spld_date);
         v_rec.total_tsi := NVL (i.total_tsi, 0);
         v_rec.total_prem := NVL (i.total_prem, 0);
         v_rec.evatprem := NVL (i.evatprem, 0);
         v_rec.lgt := NVL (i.lgt, 0);
         v_rec.doc_stamps := NVL (i.doc_stamps, 0);
         v_rec.fst := NVL (i.fst, 0);
         v_rec.other_charges := /*NVL (i.other_charges, 0) +*/  NVL (i.other_taxes, 0);
         v_rec.total_amt :=
              v_rec.total_prem
            + v_rec.evatprem
            + v_rec.lgt
            + v_rec.doc_stamps
            + v_rec.fst
            + v_rec.other_charges;
          
        IF GIISP.V('PRD_POL_CNT') = 1 THEN 
            v_rec.pol_count := 1;
        ELSIF GIISP.V('PRD_POL_CNT') = 2 THEN 
          IF i.endt_seq_no != 0 THEN
            v_rec.pol_count := 0;
          ELSE 
            v_rec.pol_count := 1;
          END IF;
        ELSIF GIISP.V('PRD_POL_CNT') = 3 THEN 
            v_rec.pol_count := 1;
            FOR j IN (
                  SELECT rownum,
                         tx.acctg_seq acct_seq,
                         tx.acctg_seq_year,
                         tx.acct_ent_date,
                         tx.line_cd,
                         tx.subline_cd,
                         tx.iss_cd,
                         tx.iss_cd_header branch_cd,
                         tx.cred_branch,
                         tx.issue_yy,
                         tx.pol_seq_no,
                         tx.renew_no,
                         tx.endt_iss_cd,
                         tx.endt_yy,
                         tx.endt_seq_no,
                         tx.policy_no,
                         tx.issue_date,
                         tx.incept_date,
                         tx.expiry_date,
                         tx.spld_date, 
                         SUM (tx.total_tsi) total_tsi,
                         SUM (tx.total_prem) total_prem,
                         SUM (tx.evatprem) evatprem,
                         SUM (tx.lgt) lgt,
                         SUM (tx.doc_stamps) doc_stamps,
                         SUM (tx.fst) fst,
                         SUM (tx.other_taxes) other_taxes,
                         SUM (tx.total_charges) total_charges,
                         tx.param_date,
                         tx.from_date,
                         tx.TO_DATE,
                         tx.scope,
                         tx.user_id,
                         tx.policy_id,
                         tx.assd_no,
                         tx.record_flag
                    FROM (SELECT TO_NUMBER (NVL (TO_CHAR (acct_ent_date, 'MM'), '13'))
                                    acctg_seq,
                                 TO_NUMBER (NVL (TO_CHAR (acct_ent_date, 'YYYY'), '9999'))
                                    acctg_seq_year,
                                 NVL (TO_CHAR (acct_ent_date, 'FmMonth, RRRR'), 'NOT TAKEN UP')
                                    acct_ent_date,
                                 line_cd,
                                 subline_cd,
                                 iss_cd,
                                 cred_branch,
                                 DECODE (p_iss_param,
                                         1, NVL (a.cred_branch, a.iss_cd),
                                         a.iss_cd)
                                    iss_cd_header,
                                 issue_yy,
                                 pol_seq_no,
                                 renew_no,
                                 endt_iss_cd,
                                 endt_yy,
                                 endt_seq_no,
                                 get_policy_no (policy_id) policy_no,
                                 issue_date,
                                 incept_date,
                                 expiry_date,
                                 spld_date, 
                                 NVL (total_tsi, 0) total_tsi,
                                 NVL (total_prem, 0) total_prem,
                                 NVL (evatprem, 0) evatprem,
                                 NVL (lgt, 0) lgt,
                                 NVL (doc_stamps, 0) doc_stamps,
                                 NVL (fst, 0) fst,
                                 NVL (other_taxes, 0) other_taxes,
                                 (  NVL (total_prem, 0)
                                  + NVL (evatprem, 0)
                                  + NVL (lgt, 0)
                                  + NVL (doc_stamps, 0)
                                  + NVL (fst, 0)
                                  + NVL (other_taxes, 0))
                                    total_charges,
                                 param_date,
                                 from_date,
                                 TO_DATE,
                                 scope,
                                 user_id,
                                 policy_id,
                                 assd_no,
                                 'O' record_flag
                            FROM gipi_uwreports_ext a
                           WHERE     user_id = p_user_id
                                 AND DECODE (p_iss_param,
                                             1, NVL (a.cred_branch, a.iss_cd),
                                             a.iss_cd) =
                                        NVL (
                                           p_iss_cd,
                                           DECODE (p_iss_param,
                                                   1, NVL (a.cred_branch, a.iss_cd),
                                                   a.iss_cd))
                                 AND line_cd = NVL (p_line_cd, line_cd)
                                 AND subline_cd = NVL (p_subline_cd, subline_cd)
                                 AND (   (    p_scope = 5
                                          AND endt_seq_no = endt_seq_no
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 1
                                          AND endt_seq_no = 0
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 2
                                          AND endt_seq_no > 0
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 4
                                          AND pol_flag = '5'
                                          AND NVL (reinstate_tag, 'N') =
                                                 DECODE (NVL (p_reinstated, 'N'),
                                                         'N', NVL (reinstate_tag, 'N'),
                                                         'Y'))
                                      OR p_scope = 6) --Added by pjsntos 03/15/2017, GENQA 5955
                          UNION
                          SELECT TO_NUMBER (NVL (TO_CHAR (spld_acct_ent_date, 'MM'), '13'))
                                    acctg_seq,
                                 TO_NUMBER (NVL (TO_CHAR (spld_acct_ent_date, 'YYYY'), '9999'))
                                    acctg_seq_year,
                                 NVL (TO_CHAR (spld_acct_ent_date, 'FmMonth, RRRR'),
                                      'NOT TAKEN UP')
                                    acct_ent_date,
                                 line_cd,
                                 subline_cd,
                                 iss_cd,
                                 cred_branch,
                                 DECODE (p_iss_param,
                                         1, NVL (a.cred_branch, a.iss_cd),
                                         a.iss_cd)
                                    iss_cd_header,
                                 issue_yy,
                                 pol_seq_no,
                                 renew_no,
                                 endt_iss_cd,
                                 endt_yy,
                                 endt_seq_no,
                                 get_policy_no (policy_id) || '*' policy_no,
                                 issue_date,
                                 incept_date,
                                 expiry_date,
                                 spld_date,
                                 -1 * NVL (total_tsi, 0) total_tsi,
                                 -1 * NVL (total_prem, 0) total_prem,
                                 -1 * NVL (evatprem, 0) evatprem,
                                 -1 * NVL (lgt, 0) lgt,
                                 -1 * NVL (doc_stamps, 0) doc_stamp,
                                 -1 * NVL (fst, 0) fst,
                                 -1 * NVL (other_taxes, 0) other_taxes,
                                   -1
                                 * (  NVL (total_prem, 0)
                                    + NVL (evatprem, 0)
                                    + NVL (lgt, 0)
                                    + NVL (doc_stamps, 0)
                                    + NVL (fst, 0)
                                    + NVL (other_taxes, 0))
                                    total_charges,
                                 param_date,
                                 from_date,
                                 TO_DATE,
                                 scope,
                                 user_id,
                                 policy_id,
                                 assd_no,
                                 'R' record_flag
                            FROM gipi_uwreports_ext a
                           WHERE     user_id = p_user_id
                                 AND DECODE (p_iss_param,
                                             1, NVL (a.cred_branch, a.iss_cd),
                                             a.iss_cd) =
                                        NVL (
                                           p_iss_cd,
                                           DECODE (p_iss_param,
                                                   1, NVL (a.cred_branch, a.iss_cd),
                                                   a.iss_cd))
                                 AND line_cd = NVL (p_line_cd, line_cd)
                                 AND subline_cd = NVL (p_subline_cd, subline_cd)
                                 AND (   (    p_scope = 5
                                          AND endt_seq_no = endt_seq_no
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 1
                                          AND endt_seq_no = 0
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 2
                                          AND endt_seq_no > 0
                                          AND spld_date IS NULL)
                                      OR (    p_scope = 4
                                          AND pol_flag = '5'
                                          AND NVL (reinstate_tag, 'N') =
                                                 DECODE (NVL (p_reinstated, 'N'),
                                                         'N', NVL (reinstate_tag, 'N'),
                                                         'Y'))
                                      OR p_scope = 6)--Added by pjsntos 03/15/2017, GENQA 5955
                                 AND spld_acct_ent_date IS NOT NULL) tx
                   WHERE tx.user_id = p_user_id
                GROUP BY tx.policy_id,
                         tx.acctg_seq,
                         tx.acctg_seq_year,
                         tx.acct_ent_date,
                         tx.line_cd,
                         tx.subline_cd,
                         tx.iss_cd,
                         tx.iss_cd_header,
                         tx.cred_branch,
                         tx.issue_yy,
                         tx.pol_seq_no,
                         tx.renew_no,
                         tx.endt_iss_cd,
                         tx.endt_yy,
                         tx.endt_seq_no,
                         tx.policy_no,
                         tx.issue_date,
                         tx.incept_date,
                         tx.expiry_date,
                         tx.spld_date,
                         tx.param_date,
                         tx.from_date,
                         tx.TO_DATE,
                         tx.scope,
                         tx.user_id,
                         tx.policy_id,
                         tx.assd_no,
                         tx.record_flag,
                         rownum
                ORDER BY tx.acctg_seq,
                         tx.acctg_seq_year,
                         tx.line_cd,
                         tx.subline_cd,
                         tx.iss_cd,
                         tx.issue_yy,
                         tx.pol_seq_no,
                         tx.renew_no,
                         tx.endt_iss_cd,
                         tx.endt_yy,
                         tx.endt_seq_no     
            )
            LOOP
                IF I.ROWNUM > J.ROWNUM THEN
                    IF i.line_cd =  j.line_cd AND
                       i.subline_cd = j.subline_cd AND
                       i.issue_yy = j.issue_yy AND
                       i.pol_seq_no = j.pol_seq_no AND
                       i.renew_no = j.renew_no AND
                       i.endt_seq_no = j.endt_seq_no AND
                       i.iss_cd = j.iss_cd AND
                       check_unique_policy(i.policy_id,j.policy_id) = 'F' THEN
                       
                       V_REC.POL_COUNT := 1;
                    ELSE
                       V_REC.POL_COUNT := 0;
                    END IF;
                ELSE
                    EXIT;
                END IF;
            END LOOP;                            
        ELSE
            v_rec.pol_count := 1;
        END IF;  
            
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_report_details;

   FUNCTION get_date_format (p_date DATE)
      RETURN VARCHAR2
   AS
      v_date   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT TO_CHAR (p_date, giisp.v ('REP_DATE_FORMAT'))
        INTO v_date
        FROM DUAL;

      RETURN v_date;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_date := TO_CHAR (p_date, 'MM/DD/RRRR');
         RETURN v_date;
   END;
   FUNCTION check_unique_policy(pol_id_i gipi_uwreports_ext.policy_id%TYPE,pol_id_j gipi_uwreports_ext.policy_id%TYPE) 
   RETURN CHAR 
   IS
	v_acct_ent_date_i DATE;
    v_acct_ent_date_j DATE;
    v_incept_date_i DATE;
    v_incept_date_j DATE;
    v_issue_date_i DATE;
    v_issue_date_j DATE;
	BEGIN
    
		BEGIN
			SELECT acct_ent_date, incept_date, issue_date
			  INTO v_acct_ent_date_i, v_incept_date_i, v_issue_date_i
			  FROM gipi_polbasic
			 WHERE policy_id = pol_id_i;
			EXCEPTION
			   WHEN NO_DATA_FOUND or TOO_MANY_ROWS THEN
				 NULL;
	  	END;
        
        BEGIN
			SELECT acct_ent_date, incept_date, issue_date
			  INTO v_acct_ent_date_j, v_incept_date_j, v_issue_date_j
			  FROM gipi_polbasic
			 WHERE policy_id = pol_id_i;
			EXCEPTION
			   WHEN NO_DATA_FOUND or TOO_MANY_ROWS THEN
				 NULL;
	  	END;
        
      IF NVL(v_acct_ent_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_acct_ent_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) AND 
          NVL(v_incept_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_incept_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) 
          AND NVL(v_issue_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_issue_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) THEN
          RETURN('T');
      ELSE
          RETURN('F');
      END IF;   
	    
	END;
END gipir923c_pkg;
/

CREATE OR REPLACE PACKAGE BODY cpi.giacr216_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 07.22.2013
   **  Reference By : GIACR216- Production Register ( Assumed Business)
   **  Description  :
   */
   FUNCTION get_giacr216_records (
      p_from_date     DATE,
      p_to_date       DATE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_module_id     VARCHAR2,
      p_user_id       giis_users.user_id%TYPE,
      p_issue_code    VARCHAR2,
      p_policy_endt   VARCHAR2
   )
      RETURN giacr216_records_tab PIPELINED
   IS
      v_rec                 giacr216_records_type;
      v_date_format         VARCHAR2 (30);
      cf_evat_param         gipi_inv_tax.tax_cd%TYPE;
      cf_prem_tax_param     gipi_inv_tax.tax_cd%TYPE;
      cf_fst_param          gipi_inv_tax.tax_cd%TYPE;
      cf_lgt_param          gipi_inv_tax.tax_cd%TYPE;
      cf_doc_stamps_param   gipi_inv_tax.tax_cd%TYPE;
   BEGIN
      v_rec.rec_exist := 'N';
      v_rec.cf_company := giisp.v ('COMPANY_NAME');
      v_rec.cf_company_address := giisp.v ('COMPANY_ADDRESS');
      v_rec.cf_from_date := TO_CHAR (p_from_date, 'FMMonth DD, YYYY');
      v_rec.cf_to_date := TO_CHAR (p_to_date, 'FMMonth DD, YYYY');
      v_date_format := get_rep_date_format;
      FOR i IN
         (SELECT   d.iss_cd branch_cd, d.line_cd, d.subline_cd, a.line_name,
                   c.subline_name, b.iss_name, d.policy_id,
                      d.line_cd
                   || '-'
                   || d.subline_cd
                   || '-'
                   || d.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (d.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (d.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (d.renew_no, '09')) POLICY,
                   d.pol_seq_no, d.renew_no,
                      d.endt_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (d.endt_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (d.endt_seq_no, '099999')) endt,
                   d.endt_seq_no, d.incept_date, d.expiry_date,
                   d.spld_acct_ent_date, d.pol_flag,
                      f.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (f.prem_seq_no, '0999999')) inv_no,
                   f.prem_seq_no bill_no, d.tsi_amt tsi, d.prem_amt prem,
                   f.ri_comm_amt, (d.prem_amt - f.ri_comm_amt) due_from_ri,
                   e.assd_name, h.ri_cd, gr.ri_name
              FROM giis_reinsurer gr,
                   gipi_parlist l,
                   gipi_polbasic d,
                   gipi_invoice f,
                   giri_inpolbas h,
                   giis_assured e,
                   giis_subline c,
                   giis_issource b,
                   giis_line a
             WHERE d.par_id = l.par_id
               AND a.line_cd = c.line_cd
               AND d.line_cd = a.line_cd
               AND d.iss_cd = b.iss_cd
               AND d.subline_cd = c.subline_cd
               AND d.policy_id = h.policy_id
               AND l.assd_no = e.assd_no
               AND d.policy_id = f.policy_id
               AND h.ri_cd = gr.ri_cd
               AND NVL (endt_type, 'A') = 'A'
               AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND d.pol_flag != '5'
               /* replaced check_user_per_iss_cd_acctg2 with codes below : shan 09.04.2014
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                 DECODE (p_issue_code,
                                                         'C', d.cred_branch,
                                                         d.iss_cd
                                                        ),
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1*/
               AND ((SELECT access_tag
                             FROM giis_user_modules
                            WHERE userid = NVL (p_user_id, USER)
                              AND module_id = p_module_id
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = NVL (p_user_id, USER)
                                                 AND b.iss_cd = DECODE (p_issue_code,
                                                                         'C', d.cred_branch,
                                                                         d.iss_cd
                                                                        )
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = p_module_id)) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = p_module_id
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = NVL (p_user_id, USER)
                                                                AND b.iss_cd = DECODE (p_issue_code,
                                                                                     'C', d.cred_branch,
                                                                                     d.iss_cd
                                                                                    )
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = p_module_id)) = 1)
                /* end 09.04.2014 */ 
               AND DECODE (p_issue_code, 'C', d.cred_branch, d.iss_cd) =
                      DECODE (p_issue_code,
                              'C', NVL (p_iss_cd, d.cred_branch),
                              NVL (p_iss_cd, d.iss_cd)
                             )
               AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                    OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                    OR (d.endt_seq_no = d.endt_seq_no AND p_policy_endt = 'A'
                       )
                    OR (d.endt_seq_no = d.endt_seq_no
                        AND p_policy_endt IS NULL
                       )
                   )
          UNION
          SELECT   d.iss_cd branch_cd, d.line_cd, d.subline_cd, a.line_name,
                   c.subline_name, b.iss_name, d.policy_id,
                      d.line_cd
                   || '-'
                   || d.subline_cd
                   || '-'
                   || d.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (d.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (d.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (d.renew_no, '09')) POLICY,
                   d.pol_seq_no, d.renew_no,
                      d.endt_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (d.endt_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (d.endt_seq_no, '099999')) endt,
                   d.endt_seq_no, d.incept_date, d.expiry_date,
                   d.spld_acct_ent_date, d.pol_flag,
                      f.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (f.prem_seq_no, '0999999')) inv_no,
                   f.prem_seq_no bill_no, (d.tsi_amt * -1) tsi,
                   (d.prem_amt * -1) prem, (f.ri_comm_amt * -1) ri_comm_amt,
                   ((d.prem_amt - f.ri_comm_amt) * -1) due_from_ri,
                   e.assd_name, h.ri_cd, gr.ri_name
              FROM giis_reinsurer gr,
                   gipi_parlist l,
                   gipi_polbasic d,
                   gipi_invoice f,
                   giri_inpolbas h,
                   giis_assured e,
                   giis_subline c,
                   giis_issource b,
                   giis_line a
             WHERE d.par_id = l.par_id
               AND a.line_cd = c.line_cd
               AND d.line_cd = a.line_cd
               AND d.iss_cd = b.iss_cd
               AND d.subline_cd = c.subline_cd
               AND d.policy_id = h.policy_id
               AND l.assd_no = e.assd_no
               AND d.policy_id = f.policy_id
               AND h.ri_cd = gr.ri_cd
               AND NVL (endt_type, 'A') = 'A'
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND d.acct_ent_date IS NOT NULL
               AND d.spld_acct_ent_date IS NOT NULL
               AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date AND p_to_date
               AND d.pol_flag = '5'
               /* replaced check_user_per_iss_cd_acctg2 with codes below : shan 09.04.2014 */ 
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                 DECODE (p_issue_code,
                                                         'C', d.cred_branch,
                                                         d.iss_cd
                                                        ),
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1*/
               AND ((SELECT access_tag
                             FROM giis_user_modules
                            WHERE userid = NVL (p_user_id, USER)
                              AND module_id = p_module_id
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = NVL (p_user_id, USER)
                                                 AND b.iss_cd = DECODE (p_issue_code,
                                                                         'C', d.cred_branch,
                                                                         d.iss_cd
                                                                        )
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = p_module_id)) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = p_module_id
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = NVL (p_user_id, USER)
                                                                AND b.iss_cd = DECODE (p_issue_code,
                                                                                     'C', d.cred_branch,
                                                                                     d.iss_cd
                                                                                    )
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = p_module_id)) = 1)
                /* end 09.04.2014 */ 
               AND DECODE (p_issue_code, 'C', d.cred_branch, d.iss_cd) =
                      DECODE (p_issue_code,
                              'C', NVL (p_iss_cd, d.cred_branch),
                              NVL (p_iss_cd, d.iss_cd)
                             )
               AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                    OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                    OR (d.endt_seq_no = d.endt_seq_no AND p_policy_endt = 'A'
                       )
                    OR (d.endt_seq_no = d.endt_seq_no
                        AND p_policy_endt IS NULL
                       )
                   )
          ORDER BY 1, 2, 3, 9, 10, 12)
      LOOP
         v_rec.rec_exist := 'Y';
         v_rec.branch_cd := i.branch_cd;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.line_name := i.line_name;
         v_rec.subline_name := i.subline_name;
         v_rec.iss_name := i.iss_name;
         v_rec.policy_id := i.policy_id;
         v_rec.POLICY := i.POLICY;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.endt := i.endt;
         v_rec.endt_seq_no := i.endt_seq_no;
         v_rec.incept_date := TO_CHAR (i.incept_date, v_date_format);
         v_rec.expiry_date := TO_CHAR (i.expiry_date, v_date_format);
         v_rec.spld_acct_ent_date := i.spld_acct_ent_date;
         v_rec.pol_flag := i.pol_flag;
         v_rec.inv_no := i.inv_no;
         v_rec.bill_no := i.bill_no;
         v_rec.tsi := i.tsi;
         v_rec.prem := i.prem;
         v_rec.ri_comm_amt := i.ri_comm_amt;
         v_rec.due_from_ri := i.due_from_ri;
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         v_rec.assd_name := i.assd_name;

         IF i.endt_seq_no = 0
         THEN
            v_rec.cnt_policy := 1;
            v_rec.cnt_endt := 0;
         ELSIF i.endt_seq_no > 0
         THEN
            v_rec.cnt_endt := 1;
            v_rec.cnt_policy := 0;
         END IF;

         BEGIN
            SELECT COUNT (pol_seq_no)
              INTO v_rec.cnt_spoiled_policy
              FROM gipi_polbasic
             WHERE line_cd = i.line_cd
               AND subline_cd = i.subline_cd
               AND iss_cd = i.branch_cd
               AND pol_seq_no = i.pol_seq_no
               AND renew_no = i.renew_no
               AND pol_flag = '5'
               AND endt_seq_no = 0
               AND spld_acct_ent_date = i.spld_acct_ent_date
               AND spld_acct_ent_date BETWEEN p_from_date AND p_to_date;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.cnt_spoiled_policy := 0;
         END;

         BEGIN
            SELECT COUNT (pol_seq_no)
              INTO v_rec.cnt_spoiled_endt
              FROM gipi_polbasic
             WHERE line_cd = i.line_cd
               AND subline_cd = i.subline_cd
               AND iss_cd = i.branch_cd
               AND pol_seq_no = i.pol_seq_no
               AND renew_no = i.renew_no
               AND pol_flag = '5'
               AND endt_seq_no > 0
               AND spld_acct_ent_date = i.spld_acct_ent_date
               AND spld_acct_ent_date BETWEEN p_from_date AND p_to_date;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.cnt_spoiled_endt := 0;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      IF v_rec.rec_exist = 'N'
      THEN
         PIPE ROW (v_rec);
      END IF;
   END;

   FUNCTION get_peril_by_policy (
      p_from_date     DATE,
      p_to_date       DATE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_policy_id     gipi_polbasic.policy_id%TYPE,
      p_policy_endt   VARCHAR2
   )
      RETURN peril_by_policy_tab PIPELINED
   IS
      v_rec   peril_by_policy_type;
   BEGIN
      FOR i IN (SELECT d.policy_id, ' ' || i.peril_sname peril_sname,
                       i.peril_cd, (j.tsi_amt * f.currency_rt) tsi_amt1,
                       (j.prem_amt * f.currency_rt) prem_amt1,
                       (j.ri_comm_amt * f.currency_rt) ri_comm_amt1,
                       ((j.prem_amt - j.ri_comm_amt) * f.currency_rt
                       ) due_from_ri1
                  FROM gipi_polbasic d,
                       gipi_invoice f,
                       giis_peril i,
                       gipi_invperil j
                 WHERE d.line_cd = i.line_cd
                   AND f.iss_cd = j.iss_cd
                   AND d.policy_id = p_policy_id
                   AND d.policy_id = f.policy_id
                   AND f.prem_seq_no = j.prem_seq_no
                   AND i.peril_cd = j.peril_cd
                   AND NVL (endt_type, 'A') = 'A'
                   AND d.acct_ent_date BETWEEN p_from_date AND p_to_date
                   AND d.pol_flag != '5'
                   AND d.line_cd = NVL (p_line_cd, d.line_cd)
                   AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                        OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                        OR (    d.endt_seq_no = d.endt_seq_no
                            AND p_policy_endt = 'A'
                           )
                        OR (    d.endt_seq_no = d.endt_seq_no
                            AND p_policy_endt IS NULL
                           )
                       )
                UNION
                SELECT d.policy_id, ' ' || i.peril_sname, i.peril_cd,
                       (j.tsi_amt * f.currency_rt * -1) tsi_amt1,
                       (j.prem_amt * f.currency_rt * -1) prem_amt1,
                       (j.ri_comm_amt * f.currency_rt * -1) ri_comm_amt1,
                       ((j.prem_amt - j.ri_comm_amt) * f.currency_rt * -1
                       ) due_from_ri1
                  FROM gipi_polbasic d,
                       gipi_invoice f,
                       giis_peril i,
                       gipi_invperil j
                 WHERE d.line_cd = i.line_cd
                   AND f.iss_cd = j.iss_cd
                   AND d.policy_id = p_policy_id
                   AND d.policy_id = f.policy_id
                   AND f.prem_seq_no = j.prem_seq_no
                   AND i.peril_cd = j.peril_cd
                   AND NVL (endt_type, 'A') = 'A'
                   AND d.acct_ent_date BETWEEN p_from_date AND p_to_date
                   AND d.acct_ent_date IS NOT NULL
                   AND d.spld_acct_ent_date IS NOT NULL
                   AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date
                                                        AND p_to_date
                   AND d.pol_flag = '5'
                   AND d.line_cd = NVL (p_line_cd, d.line_cd)
                   AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                        OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                        OR (    d.endt_seq_no = d.endt_seq_no
                            AND p_policy_endt = 'A'
                           )
                        OR (    d.endt_seq_no = d.endt_seq_no
                            AND p_policy_endt IS NULL
                           )
                       ))
      LOOP
         v_rec.policy_id := i.policy_id;
         v_rec.peril_sname := i.peril_sname;
         v_rec.peril_cd := i.peril_cd;
         v_rec.tsi_amt := i.tsi_amt1;
         v_rec.prem_amt := i.prem_amt1;
         v_rec.ri_comm_amt := i.ri_comm_amt1;
         v_rec.due_from_ri := i.due_from_ri1;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_peril_by_subline (
      p_from_date     DATE,
      p_to_date       DATE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_policy_endt   VARCHAR2
   )
      RETURN peril_by_subline_tab PIPELINED
   IS
      v_rec   peril_by_subline_type;
   BEGIN
      FOR i IN (SELECT   d.line_cd, d.subline_cd, d.iss_cd branch_cd,
                         i.peril_type,
                         DECODE (i.peril_type,
                                 'B', '*' || i.peril_sname,
                                 ' ' || i.peril_sname
                                ) peril_sname,
                         SUM (j.tsi_amt * f.currency_rt) tsi_amt,
                         SUM (j.prem_amt * f.currency_rt) prem_amt,
                         SUM (j.ri_comm_amt * f.currency_rt) ri_comm_amt6,
                         SUM ((j.prem_amt - j.ri_comm_amt) * f.currency_rt
                             ) due_from_ri2
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.line_cd = p_line_cd
                     AND d.subline_cd = p_subline_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.pol_flag != '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                          OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt = 'A'
                             )
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt IS NULL
                             )
                         )
                GROUP BY d.line_cd,
                         d.subline_cd,
                         d.iss_cd,
                         i.peril_sname,
                         i.peril_type
                UNION
                SELECT   d.line_cd, d.subline_cd, d.iss_cd branch_cd,
                         i.peril_type,
                         DECODE (i.peril_type,
                                 'B', '*' || i.peril_sname,
                                 ' ' || i.peril_sname
                                ) peril_sname,
                         SUM (j.tsi_amt * f.currency_rt * -1) tsi_amt,
                         SUM (j.prem_amt * f.currency_rt * -1) prem_amt,
                         SUM (j.ri_comm_amt * f.currency_rt * -1)
                                                                 ri_comm_amt6,
                         SUM ((j.prem_amt - j.ri_comm_amt) * f.currency_rt
                              * -1
                             ) due_from_ri2
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.line_cd = p_line_cd
                     AND d.subline_cd = p_subline_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.acct_ent_date IS NOT NULL
                     AND d.spld_acct_ent_date IS NOT NULL
                     AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date
                                                          AND p_to_date
                     AND d.pol_flag = '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                          OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt = 'A'
                             )
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt IS NULL
                             )
                         )
                GROUP BY d.line_cd,
                         d.subline_cd,
                         d.iss_cd,
                         i.peril_sname,
                         i.peril_type)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.branch_cd := i.branch_cd;
         v_rec.peril_type := i.peril_type;
         v_rec.peril_sname := i.peril_sname;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.ri_comm_amt := i.ri_comm_amt6;
         v_rec.due_from_ri := i.due_from_ri2;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_peril_by_line (
      p_from_date     DATE,
      p_to_date       DATE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_policy_endt   VARCHAR2
   )
      RETURN peril_by_line_tab PIPELINED
   IS
      v_rec   peril_by_line_type;
   BEGIN
      FOR i IN (SELECT   d.line_cd, d.iss_cd branch_cd,
                         DECODE (i.peril_type,
                                 'B', '*' || i.peril_sname,
                                 ' ' || i.peril_sname
                                ) peril_sname,
                         SUM (j.tsi_amt * f.currency_rt) tsi_amt,
                         SUM (j.prem_amt * f.currency_rt) prem_amt,
                         SUM (j.ri_comm_amt * f.currency_rt) ri_comm_amt2,
                         SUM ((j.prem_amt - j.ri_comm_amt) * f.currency_rt
                             ) due_from_ri3
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.pol_flag != '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                          OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt = 'A'
                             )
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt IS NULL
                             )
                         )
                GROUP BY d.line_cd, d.iss_cd, i.peril_sname, i.peril_type
                UNION
                SELECT   d.line_cd, d.iss_cd branch_cd,
                         DECODE (i.peril_type,
                                 'B', '*' || i.peril_sname,
                                 ' ' || i.peril_sname
                                ) peril_sname,
                         SUM (j.tsi_amt * f.currency_rt * -1) tsi_amt,
                         SUM (j.prem_amt * f.currency_rt * -1) prem_amt,
                         SUM (j.ri_comm_amt * f.currency_rt * -1)
                                                                 ri_comm_amt2,
                         SUM ((j.prem_amt - j.ri_comm_amt) * f.currency_rt
                              * -1
                             ) due_from_ri3
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.acct_ent_date IS NOT NULL
                     AND d.spld_acct_ent_date IS NOT NULL
                     AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date
                                                          AND p_to_date
                     AND d.pol_flag = '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                          OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt = 'A'
                             )
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt IS NULL
                             )
                         )
                GROUP BY d.line_cd, d.iss_cd, i.peril_sname, i.peril_type)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.branch_cd := i.branch_cd;
         v_rec.peril_sname := i.peril_sname;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.ri_comm_amt := i.ri_comm_amt2;
         v_rec.due_from_ri := i.due_from_ri3;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_peril_by_branch (
      p_from_date     DATE,
      p_to_date       DATE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_policy_endt   VARCHAR2
   )
      RETURN peril_by_branch_tab PIPELINED
   IS
      v_rec   peril_by_branch_type;
   BEGIN
      FOR i IN (SELECT   d.iss_cd branch_cd,
                         DECODE (i.peril_type,
                                 'B', '*' || i.peril_sname,
                                 ' ' || i.peril_sname
                                ) peril_sname,
                         SUM (j.tsi_amt * f.currency_rt) tsi_amt,
                         SUM (j.prem_amt * f.currency_rt) prem_amt,
                         SUM (j.ri_comm_amt * f.currency_rt) ri_comm_amt4,
                         SUM ((j.prem_amt - j.ri_comm_amt) * f.currency_rt
                             ) due_from_ri5
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.pol_flag != '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                          OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt = 'A'
                             )
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt IS NULL
                             )
                         )
                GROUP BY d.iss_cd, i.peril_sname, i.peril_type
                UNION
                SELECT   d.iss_cd branch_cd,
                         DECODE (i.peril_type,
                                 'B', '*' || i.peril_sname,
                                 ' ' || i.peril_sname
                                ) peril_sname,
                         SUM (j.tsi_amt * f.currency_rt * -1) tsi_amt,
                         SUM (j.prem_amt * f.currency_rt * -1) prem_amt,
                         SUM (j.ri_comm_amt * f.currency_rt * -1)
                                                                 ri_comm_amt4,
                         SUM ((j.prem_amt - j.ri_comm_amt) * f.currency_rt
                              * -1
                             ) due_from_ri5
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.acct_ent_date IS NOT NULL
                     AND d.spld_acct_ent_date IS NOT NULL
                     AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date
                                                          AND p_to_date
                     AND d.pol_flag = '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                          OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt = 'A'
                             )
                          OR (    d.endt_seq_no = d.endt_seq_no
                              AND p_policy_endt IS NULL
                             )
                         )
                GROUP BY d.iss_cd, i.peril_sname, i.peril_type)
      LOOP
         v_rec.branch_cd := i.branch_cd;
         v_rec.peril_sname := i.peril_sname;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.ri_comm_amt := i.ri_comm_amt4;
         v_rec.due_from_ri := i.due_from_ri5;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_total_peril (
      p_from_date     DATE,
      p_to_date       DATE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_issue_code    VARCHAR2,
      p_line_cd       giis_line.line_cd%TYPE,
      p_policy_endt   VARCHAR2,
      p_module_id     VARCHAR2,
      p_user_id       giis_users.user_id%TYPE
   )
      RETURN peril_by_branch_tab PIPELINED
   IS
      v_rec   peril_by_branch_type;
   BEGIN
      FOR i IN
         (SELECT   DECODE (i.peril_type,
                           'B', '*' || i.peril_sname,
                           '     ' || i.peril_sname
                          ) peril_sname,
                   j.iss_cd, SUM (j.tsi_amt * f.currency_rt) tsi_amt,
                   SUM (j.prem_amt * f.currency_rt) prem_amt,
                   SUM (j.ri_comm_amt * f.currency_rt) ri_comm_amt3,
                   SUM ((j.prem_amt - j.ri_comm_amt) * f.currency_rt
                       ) due_from_ri4
              FROM gipi_polbasic d,
                   gipi_invoice f,
                   giis_peril i,
                   gipi_invperil j
             WHERE d.line_cd = i.line_cd
               AND f.iss_cd = j.iss_cd
               AND DECODE (p_issue_code, 'C', d.cred_branch, d.iss_cd) =
                      DECODE (p_issue_code,
                              'C', NVL (d.cred_branch,
                                        NVL (p_iss_cd, d.iss_cd)
                                       ),
                              NVL (p_iss_cd, d.iss_cd)
                             )
                /*  replaced check_user_per_iss_cd_acctg2 with codes below : shan 09.04.2014 */
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                 DECODE (p_issue_code,
                                                         'C', d.cred_branch,
                                                         d.iss_cd
                                                        ),
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1*/
               AND ((SELECT access_tag
                             FROM giis_user_modules
                            WHERE userid = NVL (p_user_id, USER)
                              AND module_id = p_module_id
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = NVL (p_user_id, USER)
                                                 AND b.iss_cd = DECODE (p_issue_code,
                                                                         'C', d.cred_branch,
                                                                         d.iss_cd
                                                                        )
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = p_module_id)) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = p_module_id
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = NVL (p_user_id, USER)
                                                                AND b.iss_cd = DECODE (p_issue_code,
                                                                                     'C', d.cred_branch,
                                                                                     d.iss_cd
                                                                                    )
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = p_module_id)) = 1)
                /* end 09.04.2014 */ 
               AND d.policy_id = f.policy_id
               AND f.prem_seq_no = j.prem_seq_no
               AND i.peril_cd = j.peril_cd
               AND NVL (endt_type, 'A') = 'A'
               AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
               AND d.pol_flag != '5'
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                    OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                    OR (d.endt_seq_no = d.endt_seq_no AND p_policy_endt = 'A'
                       )
                    OR (d.endt_seq_no = d.endt_seq_no
                        AND p_policy_endt IS NULL
                       )
                   )
          GROUP BY j.iss_cd, i.peril_sname, i.peril_type
          UNION
          SELECT   DECODE (i.peril_type,
                           'B', '*' || i.peril_sname,
                           ' ' || i.peril_sname
                          ) peril_sname,
                   j.iss_cd, SUM (j.tsi_amt * f.currency_rt * -1) tsi_amt,
                   SUM (j.prem_amt * f.currency_rt * -1) prem_amt,
                   SUM (j.ri_comm_amt * f.currency_rt * -1) ri_comm_amt3,
                   SUM ((j.prem_amt - j.ri_comm_amt) * f.currency_rt * -1
                       ) due_from_ri4
              FROM gipi_polbasic d,
                   gipi_invoice f,
                   giis_peril i,
                   gipi_invperil j
             WHERE d.line_cd = i.line_cd
               AND f.iss_cd = j.iss_cd
               AND DECODE (p_issue_code, 'C', d.cred_branch, d.iss_cd) =
                      DECODE (p_issue_code,
                              'C', NVL (d.cred_branch,
                                        NVL (p_iss_cd, d.iss_cd)
                                       ),
                              NVL (p_iss_cd, d.iss_cd)
                             )
               /*  replaced check_user_iss_cd_acctg2 with codes below : shan 09.04.2014 */
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                 DECODE (p_issue_code,
                                                         'C', d.cred_branch,
                                                         d.iss_cd
                                                        ),
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1*/
               AND ((SELECT access_tag
                             FROM giis_user_modules
                            WHERE userid = NVL (p_user_id, USER)
                              AND module_id = p_module_id
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = NVL (p_user_id, USER)
                                                 AND b.iss_cd = DECODE (p_issue_code,
                                                                         'C', d.cred_branch,
                                                                         d.iss_cd
                                                                        )
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = p_module_id)) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = p_module_id
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = NVL (p_user_id, USER)
                                                                AND b.iss_cd = DECODE (p_issue_code,
                                                                                     'C', d.cred_branch,
                                                                                     d.iss_cd
                                                                                    )
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = p_module_id)) = 1)
                /* end 09.04.2014 */ 
               AND d.policy_id = f.policy_id
               AND f.prem_seq_no = j.prem_seq_no
               AND i.peril_cd = j.peril_cd
               AND NVL (endt_type, 'A') = 'A'
               AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
               AND d.acct_ent_date IS NOT NULL
               AND d.spld_acct_ent_date IS NOT NULL
               AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date AND p_to_date
               AND d.pol_flag = '5'
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND (   (d.endt_seq_no = 0 AND p_policy_endt = 'P')
                    OR (d.endt_seq_no <> 0 AND p_policy_endt = 'E')
                    OR (d.endt_seq_no = d.endt_seq_no AND p_policy_endt = 'A'
                       )
                    OR (d.endt_seq_no = d.endt_seq_no
                        AND p_policy_endt IS NULL
                       )
                   )
          GROUP BY j.iss_cd, i.peril_sname, i.peril_type)
      LOOP
         v_rec.peril_sname := i.peril_sname;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.ri_comm_amt := i.ri_comm_amt3;
         v_rec.due_from_ri := i.due_from_ri4;
         PIPE ROW (v_rec);
      END LOOP;
   END;

END;
/
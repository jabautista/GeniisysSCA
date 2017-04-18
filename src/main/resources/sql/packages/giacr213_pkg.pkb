CREATE OR REPLACE PACKAGE BODY cpi.giacr213_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 07.03.2013
   **  Reference By : GIACR213- Production Register (Direct Bussiness)
   **  Description  :
   */
   FUNCTION get_giacr213_records (
      p_from_date     DATE,
      p_to_date       DATE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_module_id     VARCHAR2,
      p_user_id       giis_users.user_id%TYPE,
      p_issue_code    VARCHAR2,
      p_policy_endt   VARCHAR2
   )
      RETURN giacr213_records_tab PIPELINED
   IS
      v_rec                 giacr213_records_type;
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
      cf_evat_param := giacp.n ('EVAT');
      cf_prem_tax_param := giacp.n ('PREM_TAX');
      cf_fst_param := giacp.n ('FST');
      cf_lgt_param := giacp.n ('LGT');
      cf_doc_stamps_param := giacp.n ('DOC_STAMPS');

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
                   h.commission_amt, e.assd_name, h.intrmdry_intm_no,
                   d.user_id
              FROM gipi_parlist l,
                   gipi_polbasic d,
                   gipi_invoice f,
                   gipi_comm_invoice h,
                   giac_parent_comm_invoice h1,
                   giis_assured e,
                   giis_subline c,
                   giis_issource b,
                   giis_line a
             WHERE d.par_id = l.par_id
               AND a.line_cd = c.line_cd
               AND d.line_cd = a.line_cd
               AND d.iss_cd = b.iss_cd
               AND f.iss_cd = h.iss_cd
               AND d.subline_cd = c.subline_cd
               AND l.assd_no = e.assd_no
               AND d.policy_id = f.policy_id
               AND f.prem_seq_no = h.prem_seq_no
               AND h.intrmdry_intm_no = h1.intm_no(+)
               AND h.iss_cd = h1.iss_cd(+)
               AND h.prem_seq_no = h1.prem_seq_no(+)
               AND NVL (endt_type, 'A') = 'A'
               AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               /*and DECODE(:P_ISS_CD,'C',D.CRED_BRANCH,D.ISS_CD)  in (select iss_cd from giis_issource
                             WHERE iss_cd in DECODE(check_user_per_iss_cd2(NVL(:p_line_code,d.line_cd), iss_cd, 'GIACS111',                                                                                                                                                                             user),1,iss_cd,NULL)) --added by czie, 3/12/2009 -- use to filter user access branches only when 'all branches is selected' (iss_cd)*/
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
               --added by reymon 07042012
               AND DECODE (p_issue_code, 'C', d.cred_branch, d.iss_cd) =
                      DECODE
                         (p_issue_code,
                          'C', NVL
                             (p_iss_cd, d.cred_branch) /*czie, 03/12/2009 comment out the other reference for cred_branch to get the entered  p_iss_cd */                                                                    /* NVL(D.CRED_BRANCH,NVL(:P_ISSUE_CODE,D.ISS_CD))*/,
                          NVL (p_iss_cd, d.iss_cd)
                         )                                      ---rutty111307
               /*AND D.USER_ID = NVL(:P_USER, D.USER_ID) ---rutty111307 (commented by ailene to disable the restriction in checking the user id in gipi_polbasic so that the user can print even those policies that he/she did not create )*/
               AND d.pol_flag != '5'
               AND (   (p_policy_endt = 'A' AND d.endt_seq_no = d.endt_seq_no
                       )
                    OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                    OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
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
                   (d.prem_amt * -1) prem,
                   (h.commission_amt * -1) commission_amt, e.assd_name,
                   h.intrmdry_intm_no, d.user_id
              FROM gipi_parlist l,
                   gipi_polbasic d,
                   gipi_invoice f,
                   gipi_comm_invoice h,
                   giac_parent_comm_invoice h1,
                   giis_assured e,
                   giis_subline c,
                   giis_issource b,
                   giis_line a
             WHERE d.par_id = l.par_id
               AND a.line_cd = c.line_cd
               AND d.line_cd = a.line_cd
               AND d.iss_cd = b.iss_cd
               AND f.iss_cd = h.iss_cd
               AND h.intrmdry_intm_no = h1.intm_no(+)
               AND h.iss_cd = h1.iss_cd(+)
               AND h.prem_seq_no = h1.prem_seq_no(+)
               AND d.subline_cd = c.subline_cd
               AND l.assd_no = e.assd_no
               AND d.policy_id = f.policy_id
               AND f.prem_seq_no = h.prem_seq_no
               AND NVL (endt_type, 'A') = 'A'
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               /*and DECODE(:P_ISS_CD,'C',D.CRED_BRANCH,D.ISS_CD)  in (select iss_cd from giis_issource
                             WHERE iss_cd in DECODE(check_user_per_iss_cd2(NVL(:p_line_code,d.line_cd), iss_cd, 'GIACS111',  
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
               --added by reymon 07042012
               AND DECODE (p_issue_code, 'C', d.cred_branch, d.iss_cd) =
                      DECODE
                         (p_issue_code,
                          'C', NVL
                             (p_iss_cd, d.cred_branch) /*czie, 03/12/2009 comment out the other reference for cred_branch to get the entered  p_iss_cd */                                                                    /* NVL(D.CRED_BRANCH,NVL(:P_ISSUE_CODE,D.ISS_CD))*/,
                          NVL (p_iss_cd, d.iss_cd)
                         )                                      ---rutty111307
               AND d.acct_ent_date IS NOT NULL
               AND d.spld_acct_ent_date IS NOT NULL
               AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date AND p_to_date
               AND d.pol_flag = '5'
               /*AND D.USER_ID = NVL(:P_USER, D.USER_ID) ---rutty111307 (commented by ailene to disable the restriction in checking the user id in gipi_polbasic so that the user can print even those policies that he/she did not create )*/
               AND (   (p_policy_endt = 'A' AND d.endt_seq_no = d.endt_seq_no
                       )
                    OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                    OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
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
         v_rec.commission_amt := i.commission_amt;
         v_rec.assd_name := i.assd_name;
         v_rec.intrmdry_intm_no := i.intrmdry_intm_no;
         v_rec.user_id := i.user_id;
         v_rec.evat_amt :=
            giacr213_pkg.get_tax_amt (p_from_date,
                                      p_to_date,
                                      i.branch_cd,
                                      i.bill_no,
                                      cf_evat_param,
                                      i.spld_acct_ent_date,
                                      i.pol_flag
                                     );

         IF v_rec.evat_amt = 0
         THEN
            v_rec.evat_amt := NULL;
         END IF;

         v_rec.prem_tax_amt :=
            giacr213_pkg.get_tax_amt (p_from_date,
                                      p_to_date,
                                      i.branch_cd,
                                      i.bill_no,
                                      cf_prem_tax_param,
                                      i.spld_acct_ent_date,
                                      i.pol_flag
                                     );

         IF v_rec.prem_tax_amt = 0
         THEN
            v_rec.prem_tax_amt := NULL;
         END IF;

         v_rec.fst_amt :=
            giacr213_pkg.get_tax_amt (p_from_date,
                                      p_to_date,
                                      i.branch_cd,
                                      i.bill_no,
                                      cf_fst_param,
                                      i.spld_acct_ent_date,
                                      i.pol_flag
                                     );

         IF v_rec.fst_amt = 0
         THEN
            v_rec.fst_amt := NULL;
         END IF;

         v_rec.lgt_amt :=
            giacr213_pkg.get_tax_amt (p_from_date,
                                      p_to_date,
                                      i.branch_cd,
                                      i.bill_no,
                                      cf_lgt_param,
                                      i.spld_acct_ent_date,
                                      i.pol_flag
                                     );

         IF v_rec.lgt_amt = 0
         THEN
            v_rec.lgt_amt := NULL;
         END IF;

         v_rec.doc_stamps_amt :=
            giacr213_pkg.get_tax_amt (p_from_date,
                                      p_to_date,
                                      i.branch_cd,
                                      i.bill_no,
                                      cf_doc_stamps_param,
                                      i.spld_acct_ent_date,
                                      i.pol_flag
                                     );

         IF v_rec.doc_stamps_amt = 0
         THEN
            v_rec.doc_stamps_amt := NULL;
         END IF;

         BEGIN
            SELECT SUM (tax_amt)
              INTO v_rec.other_tax_amt
              FROM gipi_inv_tax
             WHERE 1 = 1
               AND iss_cd = i.branch_cd
               AND prem_seq_no = i.bill_no
               AND tax_cd NOT IN
                      (cf_evat_param,
                       cf_prem_tax_param,
                       cf_fst_param,
                       cf_lgt_param,
                       cf_doc_stamps_param
                      );

            IF     i.spld_acct_ent_date BETWEEN p_from_date AND p_to_date
               AND i.pol_flag = '5'
            THEN
               v_rec.other_tax_amt := (-1 * v_rec.other_tax_amt);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.other_tax_amt := NULL;
         END;

         IF v_rec.other_tax_amt = 0
         THEN
            v_rec.other_tax_amt := NULL;
         END IF;

         v_rec.prem_rec :=
              NVL (i.prem, 0)
            + NVL (v_rec.evat_amt, 0)
            + NVL (v_rec.prem_tax_amt, 0)
            + NVL (v_rec.fst_amt, 0)
            + NVL (v_rec.lgt_amt, 0)
            + NVL (v_rec.doc_stamps_amt, 0)
            + NVL (v_rec.other_tax_amt, 0);

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
      FOR i IN (SELECT d.policy_id, i.peril_sname || '*' peril_sname,
                       i.peril_cd, (j.tsi_amt * f.currency_rt) tsi_amt1,
                       (j.prem_amt * f.currency_rt) prem_amt1,
                       TO_CHAR (k.commission_rt, '990') || '%' comm_rt,
                       (k.commission_amt * f.currency_rt) comm1
                  FROM gipi_polbasic d,
                       gipi_invoice f,
                       giis_peril i,
                       gipi_invperil j,
                       gipi_comm_inv_peril k,
                       giac_parent_comm_invprl k1
                 WHERE d.line_cd = i.line_cd
                   AND f.iss_cd = j.iss_cd
                   AND f.iss_cd = k.iss_cd
                   AND d.policy_id = p_policy_id
                   AND d.policy_id = f.policy_id
                   AND f.prem_seq_no = j.prem_seq_no
                   AND f.prem_seq_no = k.prem_seq_no
                   AND i.peril_cd = j.peril_cd
                   AND i.peril_cd = k.peril_cd
                   AND k.iss_cd = k1.iss_cd(+)
                   AND k.prem_seq_no = k1.prem_seq_no(+)
                   AND k.intrmdry_intm_no = k1.intm_no(+)
                   AND k.peril_cd = k1.peril_cd(+)
                   AND NVL (endt_type, 'A') = 'A'
                   AND d.acct_ent_date BETWEEN p_from_date AND p_to_date
                   AND d.pol_flag != '5'
                   AND d.line_cd = NVL (p_line_cd, d.line_cd)
                   AND (   (    p_policy_endt = 'A'
                            AND d.endt_seq_no = d.endt_seq_no
                           )
                        OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                        OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
                       )
                UNION
                SELECT d.policy_id, ' ' || i.peril_sname peril_sname,
                       i.peril_cd, (j.tsi_amt * f.currency_rt * -1) tsi_amt1,
                       (j.prem_amt * f.currency_rt * -1) prem_amt1,
                       TO_CHAR (k.commission_rt, '990') || '%' comm_rt,
                       (k.commission_amt * f.currency_rt * -1) comm1
                  FROM gipi_polbasic d,
                       gipi_invoice f,
                       giis_peril i,
                       gipi_invperil j,
                       gipi_comm_inv_peril k,
                       giac_parent_comm_invprl k1
                 WHERE d.line_cd = i.line_cd
                   AND f.iss_cd = j.iss_cd
                   AND f.iss_cd = k.iss_cd
                   AND d.policy_id = p_policy_id
                   AND d.policy_id = f.policy_id
                   AND f.prem_seq_no = j.prem_seq_no
                   AND f.prem_seq_no = k.prem_seq_no
                   AND i.peril_cd = j.peril_cd
                   AND i.peril_cd = k.peril_cd
                   AND k.iss_cd = k1.iss_cd(+)
                   AND k.prem_seq_no = k1.prem_seq_no(+)
                   AND k.intrmdry_intm_no = k1.intm_no(+)
                   AND k.peril_cd = k1.peril_cd(+)
                   AND NVL (endt_type, 'A') = 'A'
                   AND d.acct_ent_date BETWEEN p_from_date AND p_to_date
                   AND d.acct_ent_date IS NOT NULL
                   AND d.spld_acct_ent_date IS NOT NULL
                   AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date
                                                        AND p_to_date
                   AND d.pol_flag = '5'
                   AND d.line_cd = NVL (p_line_cd, d.line_cd)
                   AND (   (    p_policy_endt = 'A'
                            AND d.endt_seq_no = d.endt_seq_no
                           )
                        OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                        OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
                       ))
      LOOP
         v_rec.policy_id := i.policy_id;
         v_rec.peril_sname := i.peril_sname;
         v_rec.peril_cd := i.peril_cd;
         v_rec.tsi_amt1 := i.tsi_amt1;
         v_rec.prem_amt1 := i.prem_amt1;
         v_rec.comm_rt := i.comm_rt;
         v_rec.comm1 := i.comm1;
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
                                 'B', i.peril_sname || '*',
                                 ' ' || i.peril_sname
                                ) peril_sname,
                         SUM (j.tsi_amt * f.currency_rt) tsi_amt,
                         SUM (j.prem_amt * f.currency_rt) prem_amt,
                         SUM (k.commission_amt * f.currency_rt) comm
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j,
                         gipi_comm_inv_peril k,
                         giac_parent_comm_invprl k1
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = k.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.line_cd = p_line_cd
                     AND d.subline_cd = p_subline_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND f.prem_seq_no = k.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND i.peril_cd = k.peril_cd
                     AND k.iss_cd = k1.iss_cd(+)
                     AND k.prem_seq_no = k1.prem_seq_no(+)
                     AND k.intrmdry_intm_no = k1.intm_no(+)
                     AND k.peril_cd = k1.peril_cd(+)
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.pol_flag != '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (    p_policy_endt = 'A'
                              AND d.endt_seq_no = d.endt_seq_no
                             )
                          OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                          OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
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
                         SUM (k.commission_amt * f.currency_rt * -1) comm
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j,
                         gipi_comm_inv_peril k,
                         giac_parent_comm_invprl k1
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = k.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.line_cd = p_line_cd
                     AND d.subline_cd = p_subline_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND f.prem_seq_no = k.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND i.peril_cd = k.peril_cd
                     AND k.iss_cd = k1.iss_cd(+)
                     AND k.prem_seq_no = k1.prem_seq_no(+)
                     AND k.intrmdry_intm_no = k1.intm_no(+)
                     AND k.peril_cd = k1.peril_cd(+)
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.acct_ent_date IS NOT NULL
                     AND d.spld_acct_ent_date IS NOT NULL
                     AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date
                                                          AND p_to_date
                     AND d.pol_flag = '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (    p_policy_endt = 'A'
                              AND d.endt_seq_no = d.endt_seq_no
                             )
                          OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                          OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
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
         v_rec.comm := i.comm;
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
                                 'B', i.peril_sname || '*',
                                 ' ' || i.peril_sname
                                ) peril_sname,
                         SUM (j.tsi_amt * f.currency_rt) tsi_amt,
                         SUM (j.prem_amt * f.currency_rt) prem_amt,
                         SUM (k.commission_amt * f.currency_rt) comm
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j,
                         gipi_comm_inv_peril k,
                         giac_parent_comm_invprl k1
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = k.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND f.prem_seq_no = k.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND i.peril_cd = k.peril_cd
                     AND k.iss_cd = k1.iss_cd(+)
                     AND k.prem_seq_no = k1.prem_seq_no(+)
                     AND k.intrmdry_intm_no = k1.intm_no(+)
                     AND k.peril_cd = k1.peril_cd(+)
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.pol_flag != '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (    p_policy_endt = 'A'
                              AND d.endt_seq_no = d.endt_seq_no
                             )
                          OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                          OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
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
                         SUM (k.commission_amt * f.currency_rt * -1) comm
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j,
                         gipi_comm_inv_peril k,
                         giac_parent_comm_invprl k1
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = k.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND f.prem_seq_no = k.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND i.peril_cd = k.peril_cd
                     AND k.iss_cd = k1.iss_cd(+)
                     AND k.prem_seq_no = k1.prem_seq_no(+)
                     AND k.intrmdry_intm_no = k1.intm_no(+)
                     AND k.peril_cd = k1.peril_cd(+)
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.acct_ent_date IS NOT NULL
                     AND d.spld_acct_ent_date IS NOT NULL
                     AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date
                                                          AND p_to_date
                     AND d.pol_flag = '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (    p_policy_endt = 'A'
                              AND d.endt_seq_no = d.endt_seq_no
                             )
                          OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                          OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
                         )
                GROUP BY d.line_cd, d.iss_cd, i.peril_sname, i.peril_type)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.branch_cd := i.branch_cd;
         v_rec.peril_sname := i.peril_sname;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.comm := i.comm;
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
                                 'B', i.peril_sname || '*',
                                 ' ' || i.peril_sname
                                ) peril_sname,
                         SUM (j.tsi_amt * f.currency_rt) tsi_amt,
                         SUM (j.prem_amt * f.currency_rt) prem_amt,
                         SUM (k.commission_amt * f.currency_rt) comm
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j,
                         gipi_comm_inv_peril k,
                         giac_parent_comm_invprl k1
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = k.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND f.prem_seq_no = k.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND i.peril_cd = k.peril_cd
                     AND k.iss_cd = k1.iss_cd(+)
                     AND k.prem_seq_no = k1.prem_seq_no(+)
                     AND k.intrmdry_intm_no = k1.intm_no(+)
                     AND k.peril_cd = k1.peril_cd(+)
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.pol_flag != '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (    p_policy_endt = 'A'
                              AND d.endt_seq_no = d.endt_seq_no
                             )
                          OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                          OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
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
                         SUM (k.commission_amt * f.currency_rt * -1) comm
                    FROM gipi_polbasic d,
                         gipi_invoice f,
                         giis_peril i,
                         gipi_invperil j,
                         gipi_comm_inv_peril k,
                         giac_parent_comm_invprl k1
                   WHERE d.line_cd = i.line_cd
                     AND f.iss_cd = j.iss_cd
                     AND f.iss_cd = k.iss_cd
                     AND f.iss_cd = p_iss_cd
                     AND d.policy_id = f.policy_id
                     AND f.prem_seq_no = j.prem_seq_no
                     AND f.prem_seq_no = k.prem_seq_no
                     AND i.peril_cd = j.peril_cd
                     AND i.peril_cd = k.peril_cd
                     AND k.iss_cd = k1.iss_cd(+)
                     AND k.prem_seq_no = k1.prem_seq_no(+)
                     AND k.intrmdry_intm_no = k1.intm_no(+)
                     AND k.peril_cd = k1.peril_cd(+)
                     AND NVL (endt_type, 'A') = 'A'
                     AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     AND d.acct_ent_date IS NOT NULL
                     AND d.spld_acct_ent_date IS NOT NULL
                     AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date
                                                          AND p_to_date
                     AND d.pol_flag = '5'
                     AND d.line_cd = NVL (p_line_cd, d.line_cd)
                     AND (   (    p_policy_endt = 'A'
                              AND d.endt_seq_no = d.endt_seq_no
                             )
                          OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                          OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
                         )
                GROUP BY d.iss_cd, i.peril_sname, i.peril_type)
      LOOP
         v_rec.branch_cd := i.branch_cd;
         v_rec.peril_sname := i.peril_sname;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.comm := i.comm;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_total_peril (
      p_from_date     DATE,
      p_to_date       DATE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
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
                           'B', i.peril_sname || '*',
                           ' ' || i.peril_sname
                          ) peril_sname,
                   SUM (j.tsi_amt * f.currency_rt) tsi_amt,
                   SUM (j.prem_amt * f.currency_rt) prem_amt,
                   SUM (k.commission_amt * f.currency_rt) comm
              FROM gipi_polbasic d,
                   gipi_invoice f,
                   giis_peril i,
                   gipi_invperil j,
                   gipi_comm_inv_peril k,
                   giac_parent_comm_invprl k1
             WHERE d.line_cd = i.line_cd
               AND f.iss_cd = j.iss_cd
               AND f.iss_cd = k.iss_cd
               AND DECODE (p_iss_cd, 'C', d.cred_branch, d.iss_cd) =
                      DECODE (p_iss_cd,
                              'C', NVL (d.cred_branch,
                                        NVL (p_iss_cd, d.iss_cd)
                                       ),
                              NVL (p_iss_cd, d.iss_cd)
                             )
               ---rutty111307 --(added by ailene to add restriction in user access for a specific branch.....adopted from the main query 052208)
               /* replaced check_user_per_iss_cd_acctg2 with codes below : shan 09.04.2014 */  
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                DECODE (p_iss_cd,
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
                                                 AND b.iss_cd = DECODE (p_iss_cd,
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
                                                                AND b.iss_cd = DECODE (p_iss_cd,
                                                                                     'C', d.cred_branch,
                                                                                     d.iss_cd
                                                                                    )
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = p_module_id)) = 1)
                /* end 09.04.2014 */ 
               --added by reymon 07042012
               AND d.policy_id = f.policy_id
               AND f.prem_seq_no = j.prem_seq_no
               AND f.prem_seq_no = k.prem_seq_no
               AND i.peril_cd = j.peril_cd
               AND i.peril_cd = k.peril_cd
               AND k.iss_cd = k1.iss_cd(+)
               AND k.prem_seq_no = k1.prem_seq_no(+)
               AND k.intrmdry_intm_no = k1.intm_no(+)
               AND k.peril_cd = k1.peril_cd(+)
               AND NVL (endt_type, 'A') = 'A'
               AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
               AND d.pol_flag != '5'
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND (   (p_policy_endt = 'A' AND d.endt_seq_no = d.endt_seq_no
                       )
                    OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                    OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
                   )
          GROUP BY i.peril_sname, i.peril_type
          UNION
          SELECT   DECODE (i.peril_type,
                           'B', '*' || i.peril_sname,
                           ' ' || i.peril_sname
                          ) peril_sname,
                   SUM (j.tsi_amt * f.currency_rt * -1) tsi_amt,
                   SUM (j.prem_amt * f.currency_rt * -1) prem_amt,
                   SUM (k.commission_amt * f.currency_rt * -1) comm
              FROM gipi_polbasic d,
                   gipi_invoice f,
                   giis_peril i,
                   gipi_invperil j,
                   gipi_comm_inv_peril k,
                   giac_parent_comm_invprl k1
             WHERE d.line_cd = i.line_cd
               AND f.iss_cd = j.iss_cd
               AND f.iss_cd = k.iss_cd
               AND DECODE (p_iss_cd, 'C', d.cred_branch, d.iss_cd) =
                      DECODE (p_iss_cd,
                              'C', NVL (d.cred_branch,
                                        NVL (p_iss_cd, d.iss_cd)
                                       ),
                              NVL (p_iss_cd, d.iss_cd)
                             )
               ---rutty111307 --(added by ailene to add restriction in user access for a specific branch.....adopted from the main query 052208)
               /* replaced check_user_per_iss_cd_acctg2 with codes below : shan 09.04.2014 */  
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                DECODE (p_iss_cd,
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
                                                 AND b.iss_cd = DECODE (p_iss_cd,
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
                                                                AND b.iss_cd = DECODE (p_iss_cd,
                                                                                     'C', d.cred_branch,
                                                                                     d.iss_cd
                                                                                    )
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = p_module_id)) = 1)
                /* end 09.04.2014 */ 
               --added by reymon 07042012
               AND d.policy_id = f.policy_id
               AND f.prem_seq_no = j.prem_seq_no
               AND f.prem_seq_no = k.prem_seq_no
               AND i.peril_cd = j.peril_cd
               AND i.peril_cd = k.peril_cd
               AND k.iss_cd = k1.iss_cd(+)
               AND k.prem_seq_no = k1.prem_seq_no(+)
               AND k.intrmdry_intm_no = k1.intm_no(+)
               AND k.peril_cd = k1.peril_cd(+)
               AND NVL (endt_type, 'A') = 'A'
               AND TRUNC (d.acct_ent_date) BETWEEN p_from_date AND p_to_date
               AND d.acct_ent_date IS NOT NULL
               AND d.spld_acct_ent_date IS NOT NULL
               AND TRUNC (d.spld_acct_ent_date) BETWEEN p_from_date AND p_to_date
               AND d.pol_flag = '5'
               AND d.line_cd = NVL (p_line_cd, d.line_cd)
               AND (   (p_policy_endt = 'A' AND d.endt_seq_no = d.endt_seq_no
                       )
                    OR (p_policy_endt = 'P' AND d.endt_seq_no = 0)
                    OR (p_policy_endt = 'E' AND d.endt_seq_no > 0)
                   )
          GROUP BY i.peril_sname, i.peril_type)
      LOOP
         v_rec.peril_sname := i.peril_sname;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.comm := i.comm;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_tax_amt (
      p_from_date            DATE,
      p_to_date              DATE,
      p_iss_cd               giis_issource.iss_cd%TYPE,
      p_bill_no              gipi_invoice.prem_seq_no%TYPE,
      p_tax_cd_param         gipi_inv_tax.tax_cd%TYPE,
      p_spld_acct_ent_date   gipi_polbasic.spld_acct_ent_date%TYPE,
      p_pol_flag             gipi_polbasic.pol_flag%TYPE
   )
      RETURN NUMBER
   IS
      v_tax_amt   gipi_inv_tax.tax_amt%TYPE;
   BEGIN
      SELECT tax_amt
        INTO v_tax_amt
        FROM gipi_inv_tax
       WHERE 1 = 1
         AND iss_cd = p_iss_cd
         AND prem_seq_no = p_bill_no
         AND tax_cd = p_tax_cd_param;

      IF     p_spld_acct_ent_date BETWEEN p_from_date AND p_to_date
         AND p_pol_flag = '5'
      THEN
         v_tax_amt := (-1 * v_tax_amt);
      END IF;

      RETURN (v_tax_amt);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (NULL);
   END;
END;
/
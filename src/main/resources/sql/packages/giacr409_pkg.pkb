CREATE OR REPLACE PACKAGE BODY CPI.giacr409_pkg
AS
   FUNCTION populate_giacr409 (
      p_branch_type   VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_flag          VARCHAR2,
      p_fr_date       VARCHAR2,
      p_to_date       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_prem_seq_no   NUMBER,
      p_tran_no       VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN giacr409_tab PIPELINED
   AS
      v_rec           giacr409_type;
      v_not_exist     BOOLEAN                             := TRUE;
      v_from          DATE               := TO_DATE (p_fr_date, 'MM/DD/RRRR');
      v_to            DATE               := TO_DATE (p_to_date, 'MM/DD/RRRR');
      v_prev_branch   giac_prev_comm_inv.branch_cd%TYPE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');

      IF v_from = v_to
      THEN
         v_rec.as_of := TO_CHAR (v_from, 'fmMonth DD, YYYY');
      ELSE
         v_rec.as_of :=
               'From '
            || TO_CHAR (v_from, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to, 'fmMonth DD, YYYY');
      END IF;
    
      v_bill_list   := NULL;
      
      FOR i IN
         (SELECT DISTINCT TRUNC (d.tran_date) trans_date,
                          DECODE (p_branch_type,
                                  'I', d.iss_cd,
                                  'C', b.cred_branch
                                 ) branch,
                          b.line_cd, d.iss_cd, d.prem_seq_no,
                             d.iss_cd
                          || '-'
                          || LPAD (LTRIM (TO_CHAR (d.prem_seq_no,
                                                   '99999999999'
                                                  )
                                         ),
                                   12,
                                   0
                                  ) bill_no,
                          d.comm_rec_id,                /*d.intm_no new_intm,
                                         d.share_percentage new_shr,*/ d.policy_id,
                          d.tran_flag status, d.user_id modified_by,
                          b.branch_cd new_branch
                     FROM giac_new_comm_inv d, gipi_polbasic b
                    WHERE d.iss_cd = NVL (p_iss_cd, d.iss_cd)
                      AND d.prem_seq_no = NVL (p_prem_seq_no, d.prem_seq_no)
                      AND d.tran_no = NVL (p_tran_no, d.tran_no)
                      AND b.CRED_BRANCH = NVL(p_cred_branch, b.cred_branch) -- used when Crediting Branch is tagged : shan 02.25.2015
                      AND (   EXISTS (
                                 --added by steven 12.03.2014; to replace check_user_per_iss_cd_acctg2
                                 SELECT d.access_tag
                                   FROM giis_users a,
                                        giis_user_iss_cd b2,
                                        giis_modules_tran c,
                                        giis_user_modules d
                                  WHERE a.user_id = p_user_id
                                    AND b2.iss_cd =
                                           DECODE (p_branch_type,
                                                   'I', d.iss_cd,
                                                   'C', b.cred_branch
                                                  )
                                    AND c.module_id = p_module_id
                                    AND a.user_id = b2.userid
                                    AND d.userid = a.user_id
                                    AND b2.tran_cd = c.tran_cd
                                    AND d.tran_cd = c.tran_cd
                                    AND d.module_id = c.module_id)
                           OR EXISTS (
                                 SELECT d.access_tag
                                   FROM giis_users a,
                                        giis_user_grp_dtl b2,
                                        giis_modules_tran c,
                                        giis_user_grp_modules d
                                  WHERE a.user_id = p_user_id
                                    AND b2.iss_cd =
                                           DECODE (p_branch_type,
                                                   'I', d.iss_cd,
                                                   'C', b.cred_branch
                                                  )
                                    AND c.module_id = p_module_id
                                    AND a.user_grp = b2.user_grp
                                    AND d.user_grp = a.user_grp
                                    AND b2.tran_cd = c.tran_cd
                                    AND d.tran_cd = c.tran_cd
                                    AND d.module_id = c.module_id)
                          )
                      AND b.line_cd = NVL (p_line_cd, b.line_cd)
                      AND d.policy_id = b.policy_id
                      AND d.iss_cd = b.iss_cd
                      AND (   (    TRUNC (d.tran_date) BETWEEN v_from
                                                           AND NVL (v_to,
                                                                    v_from
                                                                   )
                               AND p_flag = 'P'
                               AND d.tran_flag = 'P'
                              )
                           OR (    TRUNC (d.tran_date) BETWEEN v_from
                                                           AND NVL (v_to,
                                                                    v_from
                                                                   )
                               AND p_flag = 'U'
                               AND d.tran_flag = 'U'
                              )
                           OR (    TRUNC (d.tran_date) BETWEEN v_from
                                                           AND NVL (v_to,
                                                                    v_from
                                                                   )
                               AND p_flag = 'A'
                               AND d.tran_flag IN ('U', 'P')
                              )
                          )
                      AND d.delete_sw <> 'Y'
                 ORDER BY TRUNC (d.tran_date),
                          DECODE (p_branch_type,
                                  'I', d.iss_cd,
                                  'C', b.cred_branch
                                 ),
                          b.line_cd,
                          d.iss_cd,
                          d.prem_seq_no,
                             d.iss_cd
                          || '-'
                          || LPAD (LTRIM (TO_CHAR (d.prem_seq_no,
                                                   '99999999999'
                                                  )
                                         ),
                                   12,
                                   0
                                  ),
                          d.comm_rec_id)
      LOOP
         v_not_exist := FALSE;
         v_rec.trans_date := i.trans_date;
         v_rec.iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.bill_no := i.bill_no;
--            v_rec.prev_intm := i.prev_intm;
--            v_rec.prev_intm_name := get_intm_name(i.prev_intm);
--            v_rec.prev_share := i.prev_shr;
         v_rec.comm_rec_id := i.comm_rec_id;
--            v_rec.tran_no := i.tran_no;
         v_rec.status := i.status;
         v_rec.modified_by := i.modified_by;
         --v_rec.new_intm := i.new_intm;
         --v_rec.new_share := i.new_shr;
         --v_rec.new_intm_name := get_intm_name (i.new_intm);
         v_rec.line_cd := i.line_cd;
         v_rec.policy_id := i.policy_id;
         v_rec.sum_prem_prev :=
                               giacr409_pkg.get_sum_prem_prev (i.comm_rec_id);
         v_rec.sum_comm_prev :=
                               giacr409_pkg.get_sum_comm_prev (i.comm_rec_id);
         v_rec.sum_wtax_prev :=
                               giacr409_pkg.get_sum_wtax_prev (i.comm_rec_id);
         v_rec.sum_prem_new :=
            giacr409_pkg.get_sum_prem_new (p_branch_type,
                                           p_cred_branch,
                                           p_flag,
                                           p_fr_date,
                                           p_to_date,
                                           i.iss_cd,
                                           p_line_cd,
                                           p_module_id,
                                           i.prem_seq_no,
                                           p_tran_no,
                                           p_user_id,
                                           i.comm_rec_id
                                          );
         v_rec.sum_comm_new :=
            giacr409_pkg.get_sum_comm_new (p_branch_type,
                                           p_cred_branch,
                                           p_flag,
                                           p_fr_date,
                                           p_to_date,
                                           i.iss_cd,
                                           p_line_cd,
                                           p_module_id,
                                           i.prem_seq_no,
                                           p_tran_no,
                                           p_user_id,
                                           i.comm_rec_id
                                          );
         v_rec.sum_wtax_new :=
            giacr409_pkg.get_sum_wtax_new (p_branch_type,
                                           p_cred_branch,
                                           p_flag,
                                           p_fr_date,
                                           p_to_date,
                                           i.iss_cd,
                                           p_line_cd,
                                           p_module_id,
                                           i.prem_seq_no,
                                           p_tran_no,
                                           p_user_id,
                                           i.comm_rec_id
                                          );

         FOR f IN (SELECT SUBSTR (booking_mth, 0, 3) || ' '
                          || booking_year bm
                     FROM gipi_polbasic gp, gipi_invoice gi
                    WHERE gp.policy_id = gi.policy_id
                      --AND gi.iss_cd||'-'|| LTRIM(TO_CHAR(gi.prem_seq_no,'99999999999')) = i.bill_no --change by stenen 12.03.2014 for optimization
                      AND gi.iss_cd = i.iss_cd
                      AND gi.prem_seq_no = i.prem_seq_no)
         LOOP
            v_rec.booking_month := f.bm;
            EXIT;
         END LOOP;

         IF p_branch_type = 'I'
         THEN
            FOR a IN (SELECT iss_name
                        FROM giis_issource
                       WHERE iss_cd = i.branch)
            LOOP
               v_rec.branch :=
                         'Issue Branch : ' || i.branch || ' - ' || a.iss_name;
               EXIT;
            END LOOP;
         ELSIF p_branch_type = 'C'
         THEN
            FOR a IN (SELECT branch_name
                        FROM giac_branches
                       WHERE branch_cd = i.branch)
            LOOP
               v_rec.branch :=
                  'Crediting Branch : ' || i.branch || ' - ' || a.branch_name;
               EXIT;
            END LOOP;
         END IF;

         FOR d IN (SELECT line_name
                     FROM giis_line
                    WHERE line_cd = i.line_cd)
         LOOP
            v_rec.line_name := 'Line: ' || d.line_name;
            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
         
         IF v_bill_list IS NULL THEN
            v_bill_list := i.bill_no;
         ELSE
            v_bill_list := v_bill_list || ',' || i.bill_no;
         END IF;
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.flag := 'T';
         PIPE ROW (v_rec);
      END IF;
   END populate_giacr409;

   FUNCTION get_main_new_comm (
      p_branch_type   VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_flag          VARCHAR2,
      p_fr_date       VARCHAR2,
      p_to_date       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_prem_seq_no   NUMBER,
      p_tran_no       VARCHAR2,
      p_user_id       VARCHAR2,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE
   )
      RETURN main_new_comm_tab PIPELINED
   AS
      v_rec    main_new_comm_type;
      v_from   DATE               := TO_DATE (p_fr_date, 'MM/DD/RRRR');
      v_to     DATE               := TO_DATE (p_to_date, 'MM/DD/RRRR');
   BEGIN
      FOR i IN (SELECT   TRUNC (d.tran_date),
                         DECODE (p_branch_type,
                                 'I', d.iss_cd,
                                 'C', b.cred_branch
                                ) branch,
                         b.line_cd, d.iss_cd, d.prem_seq_no,
                            d.iss_cd
                         || '-'
                         || LPAD (LTRIM (TO_CHAR (d.prem_seq_no,
                                                  '99999999999')
                                        ),
                                  12,
                                  0
                                 ) bill_no,
                         d.comm_rec_id, d.intm_no new_intm,
                         d.share_percentage new_shr, d.policy_id,
                         d.tran_flag status, d.user_id modified_by
                    FROM giac_new_comm_inv d, gipi_polbasic b
                   WHERE d.comm_rec_id = p_comm_rec_id
                     AND d.iss_cd = NVL (p_iss_cd, d.iss_cd)
                     AND d.prem_seq_no = NVL (p_prem_seq_no, d.prem_seq_no)
                     AND d.tran_no = NVL (p_tran_no, d.tran_no)
                     AND (   EXISTS (
                                SELECT d.access_tag
                                  FROM giis_users a,
                                       giis_user_iss_cd b2,
                                       giis_modules_tran c,
                                       giis_user_modules d
                                 WHERE a.user_id = p_user_id
                                   AND b2.iss_cd =
                                          DECODE (p_branch_type,
                                                  'I', d.iss_cd,
                                                  'C', b.cred_branch
                                                 )
                                   AND c.module_id = p_module_id
                                   AND a.user_id = b2.userid
                                   AND d.userid = a.user_id
                                   AND b2.tran_cd = c.tran_cd
                                   AND d.tran_cd = c.tran_cd
                                   AND d.module_id = c.module_id)
                          OR EXISTS (
                                SELECT d.access_tag
                                  FROM giis_users a,
                                       giis_user_grp_dtl b2,
                                       giis_modules_tran c,
                                       giis_user_grp_modules d
                                 WHERE a.user_id = p_user_id
                                   AND b2.iss_cd =
                                          DECODE (p_branch_type,
                                                  'I', d.iss_cd,
                                                  'C', b.cred_branch
                                                 )
                                   AND c.module_id = p_module_id
                                   AND a.user_grp = b2.user_grp
                                   AND d.user_grp = a.user_grp
                                   AND b2.tran_cd = c.tran_cd
                                   AND d.tran_cd = c.tran_cd
                                   AND d.module_id = c.module_id)
                         )
                     AND b.line_cd = NVL (p_line_cd, b.line_cd)
                     AND d.policy_id = b.policy_id
                     AND d.iss_cd = b.iss_cd
                     AND (   (    TRUNC (d.tran_date) BETWEEN v_from
                                                          AND NVL (v_to,
                                                                   v_from
                                                                  )
                              AND p_flag = 'P'
                              AND d.tran_flag = 'P'
                             )
                          OR (    TRUNC (d.tran_date) BETWEEN v_from
                                                          AND NVL (v_to,
                                                                   v_from
                                                                  )
                              AND p_flag = 'U'
                              AND d.tran_flag = 'U'
                             )
                          OR (    TRUNC (d.tran_date) BETWEEN v_from
                                                          AND NVL (v_to,
                                                                   v_from
                                                                  )
                              AND p_flag = 'A'
                              AND d.tran_flag IN ('U', 'P')
                             )
                         )
                     AND d.delete_sw <> 'Y'
                ORDER BY TRUNC (d.tran_date),
                         DECODE (p_branch_type,
                                 'I', d.iss_cd,
                                 'C', b.cred_branch
                                ),
                         b.line_cd,
                         d.iss_cd,
                         d.prem_seq_no,
                            d.iss_cd
                         || '-'
                         || LPAD (LTRIM (TO_CHAR (d.prem_seq_no,
                                                  '99999999999')
                                        ),
                                  12,
                                  0
                                 ),
                         d.comm_rec_id,
                         d.intm_no)
      LOOP
         v_rec.comm_rec_id := i.comm_rec_id;
         v_rec.new_intm := i.new_intm;
         v_rec.new_share := i.new_shr;
         v_rec.new_intm_name := get_intm_name (i.new_intm);
         v_rec.line_cd := i.line_cd;
         v_rec.policy_id := i.policy_id;
         PIPE ROW (v_rec);
      END LOOP;
   END get_main_new_comm;

   FUNCTION get_main_prev_comm (
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE
   )
      RETURN main_prev_comm_tab PIPELINED
   AS
      v_rec   main_prev_comm_type;
   BEGIN
      FOR i IN (SELECT   a.comm_rec_id, a.intm_no prev_intm, a.tran_no,
                         a.share_percentage prev_shr
                    FROM giac_prev_comm_inv a
                   WHERE a.comm_rec_id = p_comm_rec_id AND a.tran_flag <> 'C'
                ORDER BY a.comm_rec_id, a.intm_no)
      LOOP
         v_rec.comm_rec_id := i.comm_rec_id;
         v_rec.tran_no := i.tran_no;
         v_rec.prev_intm := i.prev_intm;
         v_rec.prev_share := i.prev_shr;
         v_rec.prev_intm_name := get_intm_name (i.prev_intm);
         PIPE ROW (v_rec);
      END LOOP;
   END get_main_prev_comm;

   FUNCTION get_prev_comm_invoice (
      p_tran_no       giac_prev_comm_inv.tran_no%TYPE,
      p_prev_intm     giac_prev_comm_inv.intm_no%TYPE,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE,
      p_policy_id     giac_new_comm_inv.policy_id%TYPE,
      p_prev_share    giac_prev_comm_inv.share_percentage%TYPE
   )
      RETURN prev_comm_tab PIPELINED
   AS
      v_rec            prev_comm_type;
      v_line_cd        gipi_polbasic.line_cd%TYPE;
      v_sum_prem_amt   giac_prev_comm_inv_peril.premium_amt%TYPE;
   BEGIN
      FOR i IN (SELECT line_cd
                  FROM gipi_polbasic
                 WHERE policy_id = p_policy_id)
      LOOP
         v_line_cd := i.line_cd;
         EXIT;
      END LOOP;

      FOR i IN (SELECT SUM (premium_amt) sum_prem_amt
                  FROM giac_prev_comm_inv_peril
                 WHERE tran_flag <> 'C' AND comm_rec_id = p_comm_rec_id)
      LOOP
         v_sum_prem_amt := i.sum_prem_amt;
         EXIT;
      END LOOP;

      FOR i IN (SELECT b.comm_rec_id, b.tran_no, b.intm_no,
                       b.premium_amt prem_prl, b.peril_cd,
                       b.commission_amt comm_prl, b.commission_rt,
                       b.wholding_tax wtax_prl
                  FROM giac_prev_comm_inv_peril b
                 WHERE b.tran_no = NVL (p_tran_no, b.tran_no)
                   AND b.tran_flag <> 'C'
                   AND b.intm_no = NVL (p_prev_intm, b.intm_no)
                   AND b.comm_rec_id = p_comm_rec_id)
      LOOP
         v_rec.prev_intm := i.intm_no;
         v_rec.comm_rec_id := i.comm_rec_id;
         v_rec.peril_cd := i.peril_cd;
         v_rec.prev_intm_name := get_intm_name (i.intm_no);
         v_rec.prev_share := p_prev_share;
         v_rec.prem_prl := i.prem_prl;
         v_rec.commission_rt := i.commission_rt;
         v_rec.comm_prl := i.comm_prl;
         v_rec.wtax_prl := i.wtax_prl;
         v_rec.sum_prem_amt := v_sum_prem_amt;

         FOR z IN (SELECT peril_sname
                     FROM giis_peril
                    WHERE peril_cd = i.peril_cd AND line_cd = v_line_cd)
         LOOP
            v_rec.peril_name := z.peril_sname;
            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;
   END get_prev_comm_invoice;

   FUNCTION get_new_comm_invoice (
      p_iss_cd        giac_new_comm_inv_peril.iss_cd%TYPE,
      p_prem_seq_no   giac_new_comm_inv_peril.prem_seq_no%TYPE,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE,
      p_new_intm      giac_new_comm_inv.intm_no%TYPE,
      p_new_share     giac_new_comm_inv.share_percentage%TYPE,
      p_policy_id     giac_new_comm_inv.policy_id%TYPE
   )
      RETURN new_comm_tab PIPELINED
   AS
      v_rec       new_comm_type;
      v_line_cd   gipi_polbasic.line_cd%TYPE;
   BEGIN
      FOR i IN (SELECT line_cd
                  FROM gipi_polbasic
                 WHERE policy_id = p_policy_id)
      LOOP
         v_line_cd := i.line_cd;
         EXIT;
      END LOOP;

      FOR i IN (SELECT b.iss_cd, b.prem_seq_no, b.comm_rec_id, b.tran_no,
                       b.intm_no, b.peril_cd, b.premium_amt prem_prl,
                       b.commission_amt comm_prl, b.commission_rt,
                       b.wholding_tax wtax_prl, p_new_share new_share
                  FROM giac_new_comm_inv_peril b
                 WHERE b.iss_cd = NVL (p_iss_cd, b.iss_cd)
                   AND b.prem_seq_no = NVL (p_prem_seq_no, b.prem_seq_no)
                   AND b.intm_no = p_new_intm
                   AND b.comm_rec_id = p_comm_rec_id)
      LOOP
         v_rec.new_share := i.new_share;
         v_rec.prem_prl := i.prem_prl;
         v_rec.commission_rt := i.commission_rt;
         v_rec.comm_prl := i.comm_prl;
         v_rec.wtax_prl := i.wtax_prl;

         FOR z IN (SELECT peril_sname
                     FROM giis_peril
                    WHERE peril_cd = i.peril_cd AND line_cd = v_line_cd)
         LOOP
            v_rec.peril_name := z.peril_sname;
            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;
   END get_new_comm_invoice;

   FUNCTION get_taken_comm (
      p_fr_date   VARCHAR2,
      p_to_date   VARCHAR2,
      p_branch    giac_acctrans.gibr_branch_cd%TYPE,
   --added by steven 12.03.2014
      p_line_cd         VARCHAR2,   -- added by shan 02.11.2015
      p_flag            VARCHAR2
   )
      RETURN taken_comm_tab PIPELINED
   AS
      v_rec         taken_comm_type;
      v_fr          DATE            := TO_DATE (p_fr_date, 'MM/DD/YYYY');
      v_to          DATE            := TO_DATE (p_to_date, 'MM/DD/YYYY');
      v_not_exist   BOOLEAN         := TRUE;
   BEGIN
      FOR i IN (SELECT      a.gl_acct_category
                         || '-'
                         || a.gl_control_acct
                         || '-'
                         || a.gl_sub_acct_1
                         || '-'
                         || a.gl_sub_acct_2
                         || '-'
                         || a.gl_sub_acct_3
                         || '-'
                         || a.gl_sub_acct_4
                         || '-'
                         || a.gl_sub_acct_5
                         || '-'
                         || a.gl_sub_acct_6
                         || '-'
                         || a.gl_sub_acct_7 AS gl_account_code,
                         c.gl_acct_name, SUM (a.debit_amt) debit_amt,
                         SUM (a.credit_amt) credit_amt,
                         a.sl_cd --added by steven 12.03.2014 base on SR 3794
                    FROM giac_acct_entries a,
                         giac_acctrans b,
                         giac_chart_of_accts c
                   WHERE a.gacc_tran_id = b.tran_id
                     AND b.tran_class = 'MR'
                     AND a.gl_acct_id = c.gl_acct_id
                     --AND b.gibr_branch_cd = NVL(p_branch, b.GIBR_BRANCH_CD)
                     AND b.GIBR_BRANCH_CD IN (SELECT iss_cd
                                                FROM TABLE(extract_bill_from_list))
                     --added by RCDatu 05.23.2014
                     AND TRUNC (b.tran_date) BETWEEN v_fr AND NVL (v_to, v_fr)
                     -- added by shan 02.11.2015
                     AND NVL(p_flag, 'A') != 'U'
                     AND b.tran_id IN (SELECT gacc_tran_id      
                                         FROM giac_prev_comm_inv i
                                        WHERE iss_cd = b.gibr_branch_cd
                                          AND prem_seq_no IN (SELECT prem_seq_no
                                                                FROM TABLE(extract_bill_from_list))
                                          AND EXISTS (SELECT comm_rec_id     
                                                        FROM giac_new_comm_inv a
                                                       WHERE a.comm_rec_id = i.comm_rec_id
                                                         AND EXISTS (SELECT 1
                                                                       FROM gipi_polbasic
                                                                      WHERE line_cd = NVL(p_line_cd, line_cd)
                                                                        AND policy_id = a.policy_id)))
                GROUP BY    a.gl_acct_category
                         || '-'
                         || a.gl_control_acct
                         || '-'
                         || a.gl_sub_acct_1
                         || '-'
                         || a.gl_sub_acct_2
                         || '-'
                         || a.gl_sub_acct_3
                         || '-'
                         || a.gl_sub_acct_4
                         || '-'
                         || a.gl_sub_acct_5
                         || '-'
                         || a.gl_sub_acct_6
                         || '-'
                         || a.gl_sub_acct_7,
                         c.gl_acct_name,
                         a.sl_cd)
      LOOP
         v_not_exist := FALSE;
         v_rec.gl_account_code := i.gl_account_code;
         v_rec.gl_acct_name := i.gl_acct_name;
         v_rec.debit_amt := i.debit_amt;
         v_rec.credit_amt := i.credit_amt;
         v_rec.sl_cd := i.sl_cd;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.flag := 'T';
         PIPE ROW (v_rec);
      END IF;
   END get_taken_comm;

   FUNCTION get_new_comm (
      p_fr_date   VARCHAR2,
      p_to_date   VARCHAR2,
      p_branch    giac_acctrans.gibr_branch_cd%TYPE,
   --added by steven 12.03.2014
      p_line_cd         VARCHAR2,   -- added by shan 02.11.2015
      p_flag            VARCHAR2
   )
      RETURN new_commissions_tab PIPELINED
   AS
      v_rec         new_commissions_type;
      v_fr          DATE                 := TO_DATE (p_fr_date, 'MM/DD/YYYY');
      v_to          DATE                 := TO_DATE (p_to_date, 'MM/DD/YYYY');
      v_not_exist   BOOLEAN              := TRUE;
   BEGIN
      FOR i IN (SELECT      a.gl_acct_category
                         || '-'
                         || a.gl_control_acct
                         || '-'
                         || a.gl_sub_acct_1
                         || '-'
                         || a.gl_sub_acct_2
                         || '-'
                         || a.gl_sub_acct_3
                         || '-'
                         || a.gl_sub_acct_4
                         || '-'
                         || a.gl_sub_acct_5
                         || '-'
                         || a.gl_sub_acct_6
                         || '-'
                         || a.gl_sub_acct_7 AS gl_account_code,
                         c.gl_acct_name, SUM (a.debit_amt) debit_amt,
                         SUM (a.credit_amt) credit_amt,
                         a.sl_cd --added by steven 12.03.2014 base on SR 3794
                    FROM giac_acct_entries a,
                         giac_acctrans b,
                         giac_chart_of_accts c
                   WHERE a.gacc_tran_id = b.tran_id
                     AND b.tran_class = 'MC'
                     AND a.gl_acct_id = c.gl_acct_id
                     --AND b.gibr_branch_cd = NVL(p_branch, b.GIBR_BRANCH_CD)
                     AND b.GIBR_BRANCH_CD IN (SELECT iss_cd
                                                FROM TABLE(extract_bill_from_list))
                     --added by RCDatu 05.23.2014
                     AND TRUNC (b.tran_date) BETWEEN v_fr AND NVL (v_to, v_fr)
                     -- added by shan 02.11.2015
                     AND NVL(p_flag, 'A') != 'U'
                     AND b.tran_id IN (SELECT gacc_tran_id      
                                         FROM giac_new_comm_inv a
                                        WHERE iss_cd = b.gibr_branch_cd
                                          AND prem_seq_no IN (SELECT prem_seq_no
                                                                FROM TABLE(extract_bill_from_list))
                                          AND EXISTS (SELECT 1
                                                        FROM gipi_polbasic
                                                       WHERE line_cd = NVL(p_line_cd, line_cd)
                                                         AND policy_id = a.policy_id))
                GROUP BY    a.gl_acct_category
                         || '-'
                         || a.gl_control_acct
                         || '-'
                         || a.gl_sub_acct_1
                         || '-'
                         || a.gl_sub_acct_2
                         || '-'
                         || a.gl_sub_acct_3
                         || '-'
                         || a.gl_sub_acct_4
                         || '-'
                         || a.gl_sub_acct_5
                         || '-'
                         || a.gl_sub_acct_6
                         || '-'
                         || a.gl_sub_acct_7,
                         c.gl_acct_name,
                         a.sl_cd)
      LOOP
         v_not_exist := FALSE;
         v_rec.gl_account_code := i.gl_account_code;
         v_rec.gl_acct_name := i.gl_acct_name;
         v_rec.debit_amt := i.debit_amt;
         v_rec.credit_amt := i.credit_amt;
         v_rec.sl_cd := i.sl_cd;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.flag := 'T';
         PIPE ROW (v_rec);
      END IF;
   END get_new_comm;

   FUNCTION get_sum_prem_prev (
      p_comm_rec_id   giac_prev_comm_inv_peril.comm_rec_id%TYPE
   )
      RETURN NUMBER
   IS
      v_sum_prem_amt   giac_prev_comm_inv_peril.premium_amt%TYPE;
   BEGIN
      FOR i IN (SELECT SUM (premium_amt) sum_prem_amt
                  FROM giac_prev_comm_inv_peril
                 WHERE tran_flag <> 'C' AND comm_rec_id = p_comm_rec_id)
      LOOP
         v_sum_prem_amt := i.sum_prem_amt;
      END LOOP;

      RETURN v_sum_prem_amt;
   END;

   FUNCTION get_sum_comm_prev (
      p_comm_rec_id   giac_prev_comm_inv_peril.comm_rec_id%TYPE
   )
      RETURN NUMBER
   IS
      v_sum_comm_amt   giac_prev_comm_inv_peril.commission_amt%TYPE;
   BEGIN
      FOR i IN (SELECT SUM (commission_amt) sum_comm_amt
                  FROM giac_prev_comm_inv_peril
                 WHERE tran_flag <> 'C' AND comm_rec_id = p_comm_rec_id)
      LOOP
         v_sum_comm_amt := i.sum_comm_amt;
      END LOOP;

      RETURN v_sum_comm_amt;
   END;

   FUNCTION get_sum_wtax_prev (
      p_comm_rec_id   giac_prev_comm_inv_peril.comm_rec_id%TYPE
   )
      RETURN NUMBER
   IS
      v_sum_wtax   giac_prev_comm_inv_peril.wholding_tax%TYPE;
   BEGIN
      FOR i IN (SELECT SUM (wholding_tax) sum_wtax
                  FROM giac_prev_comm_inv_peril
                 WHERE tran_flag <> 'C' AND comm_rec_id = p_comm_rec_id)
      LOOP
         v_sum_wtax := i.sum_wtax;
      END LOOP;

      RETURN v_sum_wtax;
   END;

   FUNCTION get_sum_prem_new (
      p_branch_type   VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_flag          VARCHAR2,
      p_fr_date       VARCHAR2,
      p_to_date       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_prem_seq_no   NUMBER,
      p_tran_no       VARCHAR2,
      p_user_id       VARCHAR2,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE
   )
      RETURN NUMBER
   IS
      v_sum_prem_amt   giac_new_comm_inv_peril.premium_amt%TYPE;
   BEGIN
      FOR i IN
         (SELECT SUM (premium_amt) sum_prem_amt
            FROM giac_new_comm_inv_peril
           WHERE tran_flag <> 'C'
             AND comm_rec_id = p_comm_rec_id
             AND iss_cd = p_iss_cd
             AND prem_seq_no = p_prem_seq_no
             AND intm_no IN (
                    SELECT new_intm
                      FROM TABLE
                               (giacr409_pkg.get_main_new_comm (p_branch_type,
                                                                p_cred_branch,
                                                                p_flag,
                                                                p_fr_date,
                                                                p_to_date,
                                                                p_iss_cd,
                                                                p_line_cd,
                                                                p_module_id,
                                                                p_prem_seq_no,
                                                                p_tran_no,
                                                                p_user_id,
                                                                p_comm_rec_id
                                                               )
                               )))
      LOOP
         v_sum_prem_amt := i.sum_prem_amt;
      END LOOP;

      RETURN v_sum_prem_amt;
   END;

   FUNCTION get_sum_comm_new (
      p_branch_type   VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_flag          VARCHAR2,
      p_fr_date       VARCHAR2,
      p_to_date       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_prem_seq_no   NUMBER,
      p_tran_no       VARCHAR2,
      p_user_id       VARCHAR2,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE
   )
      RETURN NUMBER
   IS
      v_sum_comm_amt   giac_new_comm_inv_peril.commission_amt%TYPE;
   BEGIN
      FOR i IN
         (SELECT SUM (commission_amt) sum_comm_amt
            FROM giac_new_comm_inv_peril
           WHERE tran_flag <> 'C'
             AND comm_rec_id = p_comm_rec_id
             AND iss_cd = p_iss_cd
             AND prem_seq_no = p_prem_seq_no
             AND intm_no IN (
                    SELECT new_intm
                      FROM TABLE
                               (giacr409_pkg.get_main_new_comm (p_branch_type,
                                                                p_cred_branch,
                                                                p_flag,
                                                                p_fr_date,
                                                                p_to_date,
                                                                p_iss_cd,
                                                                p_line_cd,
                                                                p_module_id,
                                                                p_prem_seq_no,
                                                                p_tran_no,
                                                                p_user_id,
                                                                p_comm_rec_id
                                                               )
                               )))
      LOOP
         v_sum_comm_amt := i.sum_comm_amt;
      END LOOP;

      RETURN v_sum_comm_amt;
   END;

   FUNCTION get_sum_wtax_new (
      p_branch_type   VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_flag          VARCHAR2,
      p_fr_date       VARCHAR2,
      p_to_date       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_prem_seq_no   NUMBER,
      p_tran_no       VARCHAR2,
      p_user_id       VARCHAR2,
      p_comm_rec_id   giac_prev_comm_inv.comm_rec_id%TYPE
   )
      RETURN NUMBER
   IS
      v_sum_wtax   giac_new_comm_inv_peril.wholding_tax%TYPE;
   BEGIN
      FOR i IN
         (SELECT SUM (wholding_tax) sum_wtax
            FROM giac_new_comm_inv_peril
           WHERE tran_flag <> 'C'
             AND comm_rec_id = p_comm_rec_id
             AND iss_cd = p_iss_cd
             AND prem_seq_no = p_prem_seq_no
             AND intm_no IN (
                    SELECT new_intm
                      FROM TABLE
                               (giacr409_pkg.get_main_new_comm (p_branch_type,
                                                                p_cred_branch,
                                                                p_flag,
                                                                p_fr_date,
                                                                p_to_date,
                                                                p_iss_cd,
                                                                p_line_cd,
                                                                p_module_id,
                                                                p_prem_seq_no,
                                                                p_tran_no,
                                                                p_user_id,
                                                                p_comm_rec_id
                                                               )
                               )))
      LOOP
         v_sum_wtax := i.sum_wtax;
      END LOOP;

      RETURN v_sum_wtax;
   END;
   
   
    FUNCTION extract_bill_from_list
        RETURN bill_no_tab PIPELINED
    AS
        rec     bill_no_type;
        
       start_pos     PLS_INTEGER     := 0;
       end_pos       PLS_INTEGER     := 0;
       clob_length   PLS_INTEGER;
       bill_no       VARCHAR2 (4000);
    BEGIN
        clob_length := DBMS_LOB.getlength (v_bill_list);

       WHILE end_pos <= clob_length
       LOOP
          start_pos := end_pos + 1;
          end_pos := DBMS_LOB.INSTR (v_bill_list, ',', start_pos, 1);

          IF end_pos <= 0 THEN
             end_pos := clob_length + 1;
          END IF;

          bill_no := DBMS_LOB.SUBSTR (v_bill_list, end_pos - start_pos, start_pos);
          
          rec.iss_cd := SUBSTR(bill_no, 1, INSTR(bill_no, '-', 1, 1) - 1);
          rec.prem_seq_no := TO_NUMBER(SUBSTR(bill_no, INSTR(bill_no, '-', 1, 1) +1));
          PIPE ROW (rec);
       END LOOP;
    END extract_bill_from_list;
   
END giacr409_pkg;
/



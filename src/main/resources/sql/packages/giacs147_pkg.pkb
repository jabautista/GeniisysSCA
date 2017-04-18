CREATE OR REPLACE PACKAGE BODY CPI.GIACS147_PKG
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 06.04.2013
    **  Reference By : GIACS147 - PRINT PREMIUM DEPOSIT
    */
   v_counter           NUMBER                                      := 0;
   v_main_tran         NUMBER;
   v_total_row         NUMBER;
   v_collection2       NUMBER;
   v_temp_item2        NUMBER;
   v_temp_item         NUMBER;
   v_insert_payment    NUMBER;
   v_payment2          NUMBER;
   v_tran_key          NUMBER;
   v_item_no_key       NUMBER;
   v_tran_key2         NUMBER;
   v_count             NUMBER;
   v_ctr               NUMBER                                      := 0;
   v_user              VARCHAR2 (25);
   v_fund              giac_premdeposit_ext.fund_cd%TYPE;
   v_branch            giac_premdeposit_ext.branch_cd%TYPE;
   v_ref               giac_premdeposit_ext.ref_no%TYPE;
   v_rev_tran_id       giac_premdeposit_ext.rev_tran_id%TYPE;
   v_rev_old_tran_id   giac_premdeposit_ext.rev_tran_id%TYPE;
   v_rev_prem_dep      giac_premdeposit_ext.rev_coll_amt%TYPE;
   v_rev_trandate      giac_premdeposit_ext.rev_tran_date%TYPE;
   v_tran_class        giac_premdeposit_ext.tran_class%TYPE;
   v_rev_trantype      giac_premdeposit_ext.rev_tran_type%TYPE;
   v_rev_ref           giac_premdeposit_ext.rev_ref_no%TYPE;
   v_item_no           giac_premdeposit_ext.item_no%TYPE;
   v_tran_date         giac_premdeposit_ext.tran_date%TYPE;
   v_collection_amt    giac_premdeposit_ext.collection_amt%TYPE;
   v_assured_name      giac_premdeposit_ext.assured_name%TYPE;
   v_assd_no           giac_premdeposit_ext.assd_no%TYPE;
   v_remarks           giac_premdeposit_ext.remarks%TYPE;
   v_tran_type         giac_premdeposit_ext.tran_type%TYPE;
   v_date_flag         giac_premdeposit_ext.date_flag%TYPE;
   v_dep_flag          giac_premdeposit_ext.dep_flag%TYPE;
   v_tran_class2       giac_premdeposit_ext.tran_class%TYPE;
   v_tran_year         giac_premdeposit_ext.tran_year%TYPE;
   v_tran_month        giac_premdeposit_ext.tran_month%TYPE;
   v_tran_seq_no       giac_premdeposit_ext.tran_seq_no%TYPE;
   v_rev_tranclass     giac_premdeposit_ext.rev_tran_class%TYPE;
   v_rev_tranyear      giac_premdeposit_ext.rev_tran_year%TYPE;
   v_rev_tranmonth     giac_premdeposit_ext.rev_tran_month%TYPE;
   v_rev_transeqno     giac_premdeposit_ext.rev_tran_seq_no%TYPE;
   
   v_param_branch_cd   giac_premdeposit_ext.param_branch_cd%TYPE;
   v_param_assd_no     giac_premdeposit_ext.param_assd_no%TYPE;  
   v_param_dep_flag    giac_premdeposit_ext.param_dep_flag%TYPE; 
   v_param_rdo_dep     giac_premdeposit_ext.param_rdo_dep%TYPE;  

    FUNCTION get_last_extract (p_user_id giis_users.user_id%TYPE)
       RETURN last_extract_tab PIPELINED
    IS
       v_last        last_extract_type;
       v_date_flag   giac_premdeposit_ext.date_flag%TYPE;
       v_user        VARCHAR2 (50);
    BEGIN
       BEGIN
          SELECT DISTINCT user_id
                     INTO v_user
                     FROM giac_premdeposit_ext
                    WHERE user_id = p_user_id;

          IF v_user IS NOT NULL
          THEN
             FOR x IN (SELECT DISTINCT cutoff_date, from_date, TO_DATE,
                                       date_flag, param_branch_cd, param_assd_no,
                                       param_dep_flag, param_rdo_dep
                                  FROM giac_premdeposit_ext
                                 WHERE user_id = p_user_id)
             LOOP
                v_last.cut_off_date_dep := TRUNC (x.cutoff_date);
                v_last.from_date_dep := TRUNC (x.from_date);
                v_last.to_date_dep := TRUNC (x.TO_DATE);
                v_date_flag := x.date_flag;
                v_last.param_branch_cd := x.param_branch_cd;
                v_last.param_assd_no   := x.param_assd_no;  
                v_last.param_dep_flag  := x.param_dep_flag;
                v_last.param_rdo_dep   := x.param_rdo_dep;  

                IF v_date_flag = 'T'
                THEN
                   v_last.transaction_dep := 'T';
                   v_last.posting_dep := 'X';
                ELSIF v_date_flag = 'P'
                THEN
                   v_last.transaction_dep := 'X';
                   v_last.posting_dep := 'P';
                END IF;
                
                IF x.param_branch_cd IS NOT NULL THEN
                    SELECT branch_name 
                      INTO v_last.param_branch_name
                      FROM giac_branches
                      WHERE branch_cd = x.param_branch_cd;
                ELSE
                    v_last.param_branch_name := 'ALL BRANCHES';
                END IF;
                
                IF x.param_assd_no IS NOT NULL THEN
                    SELECT assd_name
                      INTO v_last.param_assd_name
                      FROM giis_assured
                      WHERE assd_no = x.param_assd_no;
                ELSE
                    v_last.param_assd_name := 'ALL ASSURED';
                END IF;
                
                IF x.param_dep_flag IS NOT NULL THEN
                    SELECT rv_meaning
                      INTO v_last.param_dep_desc 
                      FROM cg_ref_codes
                     WHERE rv_domain = 'GIAC_PREM_DEPOSIT.DEP_FLAG'
                       AND rv_low_value = x.param_dep_flag;
                ELSE
                    v_last.param_dep_desc  := 'ALL DEPOSIT FLAGS';
                END IF;
                    

                PIPE ROW (v_last);
             END LOOP;
          END IF;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_last.cut_off_date_dep := NULL;
             v_last.from_date_dep := NULL;
             v_last.to_date_dep := NULL;
             v_last.transaction_dep := NULL;
             v_last.posting_dep := NULL;
             PIPE ROW (v_last);
       END;
    END;
   
   FUNCTION get_branch_lov (p_user_id giis_users.user_id%TYPE)
      RETURN brach_lov_tab PIPELINED
   IS
      v_branch   brach_lov_type;
   BEGIN
      FOR i IN (SELECT   branch_cd, branch_name
                    FROM giac_branches
                   WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                       branch_cd,
                                                       'GIACS147',
                                                       p_user_id
                                                      ) = 1
                ORDER BY 1)
      LOOP
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         PIPE ROW (v_branch);
      END LOOP;

      RETURN;
   END get_branch_lov;

   FUNCTION get_assd_lov
      RETURN assd_lov_tab PIPELINED
   IS
      v_assd   assd_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT 99999 assd_no,
                                'No Assured Specified' assured_name
                           FROM DUAL
                UNION ALL
                SELECT DISTINCT b.assd_no, b.assured_name
                           FROM giac_prem_deposit b, giac_acctrans c
                          WHERE c.tran_flag <> 'D'
                            AND b.gacc_tran_id = c.tran_id(+)
                            AND b.assured_name IS NOT NULL)
      LOOP
         v_assd.assd_no := i.assd_no;
         v_assd.assd_name := i.assured_name;
         PIPE ROW (v_assd);
      END LOOP;

      RETURN;
   END get_assd_lov;

   FUNCTION get_dep_flag_lov
      RETURN dep_flag_lov_tab PIPELINED
   IS
      v_dep_flag   dep_flag_lov_type;
   BEGIN
      FOR i IN (SELECT   rv_low_value, rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIAC_PREM_DEPOSIT.DEP_FLAG'
                ORDER BY 1)
      LOOP
         v_dep_flag.rv_low_value := i.rv_low_value;
         v_dep_flag.rv_meaning := i.rv_meaning;
         PIPE ROW (v_dep_flag);
      END LOOP;

      RETURN;
   END get_dep_flag_lov;

   PROCEDURE extract_premium_deposit (p_user_id giis_users.user_id%TYPE)
   IS
   BEGIN
      DELETE FROM giac_premdeposit_ext
            WHERE user_id = p_user_id;
      v_counter := 0;
   END extract_premium_deposit;

   PROCEDURE extract_wid_no_reversal (
      p_user_id             giis_users.user_id%TYPE,
      p_posting             VARCHAR2,
      p_transaction         VARCHAR2,
      p_from_date           DATE,
      p_to_date             DATE,
      p_branch_cd           VARCHAR2,
      p_reversal            VARCHAR2,
      p_cut_off             DATE,
      p_dep_flag            VARCHAR2,
      p_assd_no             VARCHAR2,
      p_rdo_dep             VARCHAR2,
      p_row_count     OUT   VARCHAR2
   )
   IS
   BEGIN
       v_param_branch_cd   := p_branch_cd;
       v_param_assd_no     := p_assd_no;  
       v_param_dep_flag    := p_dep_flag; 
       v_param_rdo_dep     := p_rdo_dep;  
   
       IF p_assd_no = 99999 THEN
        FOR z IN
             (SELECT DISTINCT a.gacc_tran_id
                         FROM giac_acctrans c, giac_prem_deposit a
                        WHERE (   (    p_posting = 'P'
                                   AND TRUNC (c.posting_date) BETWEEN p_from_date
                                                                  AND p_to_date
                                  )
                               OR (    p_transaction = 'T'
                                   AND TRUNC (c.tran_date) BETWEEN p_from_date
                                                               AND p_to_date
                                  )
                              )
                          AND a.gacc_tran_id = c.tran_id
                          AND dep_flag = NVL(p_dep_flag, dep_flag)
                          AND a.assd_no IS NULL
                          AND a.transaction_type IN (1, 3)
                          AND c.tran_flag <> 'D')
          LOOP
             v_main_tran := z.gacc_tran_id;
             giacs147_pkg.main_ext (p_user_id,
                                    p_posting,
                                    p_transaction,
                                    p_from_date,
                                    p_to_date,
                                    v_main_tran,
                                    p_branch_cd,
                                    p_reversal,
                                    p_cut_off,
                                    p_dep_flag,
                                    p_assd_no
                                   );
             p_row_count := v_counter;
          END LOOP;
       ELSIF p_assd_no IS NULL THEN
        FOR z IN
             (SELECT DISTINCT a.gacc_tran_id
                         FROM giac_acctrans c, giac_prem_deposit a
                        WHERE (   (    p_posting = 'P'
                                   AND TRUNC (c.posting_date) BETWEEN p_from_date
                                                                  AND p_to_date
                                  )
                               OR (    p_transaction = 'T'
                                   AND TRUNC (c.tran_date) BETWEEN p_from_date
                                                               AND p_to_date
                                  )
                              )
                          AND a.gacc_tran_id = c.tran_id
                          AND dep_flag = NVL(p_dep_flag, dep_flag)
                          AND a.transaction_type IN (1, 3)
                          AND c.tran_flag <> 'D')
          LOOP
             v_main_tran := z.gacc_tran_id;
             giacs147_pkg.main_ext (p_user_id,
                                    p_posting,
                                    p_transaction,
                                    p_from_date,
                                    p_to_date,
                                    v_main_tran,
                                    p_branch_cd,
                                    p_reversal,
                                    p_cut_off,
                                    p_dep_flag,
                                    p_assd_no
                                   );
             p_row_count := v_counter;
          END LOOP;
       ELSE
        FOR z IN
             (SELECT DISTINCT a.gacc_tran_id
                         FROM giac_acctrans c, giac_prem_deposit a
                        WHERE (   (    p_posting = 'P'
                                   AND TRUNC (c.posting_date) BETWEEN p_from_date
                                                                  AND p_to_date
                                  )
                               OR (    p_transaction = 'T'
                                   AND TRUNC (c.tran_date) BETWEEN p_from_date
                                                               AND p_to_date
                                  )
                              )
                          AND a.gacc_tran_id = c.tran_id
                          AND dep_flag = NVL(p_dep_flag, dep_flag)
                          AND a.assd_no = p_assd_no
                          AND a.transaction_type IN (1, 3)
                          AND c.tran_flag <> 'D')
          LOOP
             v_main_tran := z.gacc_tran_id;
             giacs147_pkg.main_ext (p_user_id,
                                    p_posting,
                                    p_transaction,
                                    p_from_date,
                                    p_to_date,
                                    v_main_tran,
                                    p_branch_cd,
                                    p_reversal,
                                    p_cut_off,
                                    p_dep_flag,
                                    p_assd_no
                                   );
             p_row_count := v_counter;
          END LOOP;
       END IF;
   END extract_wid_no_reversal;

   PROCEDURE extract_wid_reversal (
      p_user_id             giis_users.user_id%TYPE,
      p_posting             VARCHAR2,
      p_transaction         VARCHAR2,
      p_from_date           DATE,
      p_to_date             DATE,
      p_branch_cd           VARCHAR2,
      p_reversal            VARCHAR2,
      p_cut_off             DATE,
      p_dep_flag            VARCHAR2,
      p_assd_no             VARCHAR2,
      p_rdo_dep             VARCHAR2,
      p_row_count     OUT   NUMBER
   )
   IS
   BEGIN
       v_param_branch_cd   := p_branch_cd;
       v_param_assd_no     := p_assd_no;  
       v_param_dep_flag    := p_dep_flag; 
       v_param_rdo_dep     := p_rdo_dep;
   
    IF p_assd_no = 99999 THEN
        FOR z IN
         (SELECT DISTINCT a.gacc_tran_id
                     FROM giac_acctrans c, giac_prem_deposit a
                    WHERE (   (    p_posting = 'P'
                               AND TRUNC (c.posting_date) BETWEEN p_from_date
                                                              AND p_to_date
                              )
                           OR (    p_transaction = 'T'
                               AND TRUNC (c.tran_date) BETWEEN p_from_date
                                                           AND p_to_date
                              )
                          )
                      AND a.gacc_tran_id = c.tran_id
                      AND a.transaction_type IN (1, 3)
                      AND c.tran_flag <> 'D'
                      AND dep_flag = NVL(p_dep_flag, dep_flag)
                      AND a.assd_no is null
                      AND a.gacc_tran_id NOT IN (
                             SELECT c.gacc_tran_id
                               FROM giac_acctrans d, giac_reversals c
                              WHERE c.reversing_tran_id = d.tran_id
                                AND d.tran_flag <> 'D'))
      LOOP
         v_main_tran := z.gacc_tran_id;
         giacs147_pkg.main_ext (p_user_id,
                                p_posting,
                                p_transaction,
                                p_from_date,
                                p_to_date,
                                v_main_tran,
                                p_branch_cd,
                                p_reversal,
                                p_cut_off,
                                p_dep_flag,
                                p_assd_no
                               );
         p_row_count := v_counter;
      END LOOP;
      
    ELSIF p_assd_no IS NULL THEN
        FOR z IN
         (SELECT DISTINCT a.gacc_tran_id
                     FROM giac_acctrans c, giac_prem_deposit a
                    WHERE (   (    p_posting = 'P'
                               AND TRUNC (c.posting_date) BETWEEN p_from_date
                                                              AND p_to_date
                              )
                           OR (    p_transaction = 'T'
                               AND TRUNC (c.tran_date) BETWEEN p_from_date
                                                           AND p_to_date
                              )
                          )
                      AND a.gacc_tran_id = c.tran_id
                      AND a.transaction_type IN (1, 3)
                      AND c.tran_flag <> 'D'
                      AND dep_flag = NVL(p_dep_flag, dep_flag)
                      AND a.gacc_tran_id NOT IN (
                             SELECT c.gacc_tran_id
                               FROM giac_acctrans d, giac_reversals c
                              WHERE c.reversing_tran_id = d.tran_id
                                AND d.tran_flag <> 'D'))
      LOOP
         v_main_tran := z.gacc_tran_id;
         giacs147_pkg.main_ext (p_user_id,
                                p_posting,
                                p_transaction,
                                p_from_date,
                                p_to_date,
                                v_main_tran,
                                p_branch_cd,
                                p_reversal,
                                p_cut_off,
                                p_dep_flag,
                                p_assd_no
                               );
         p_row_count := v_counter;
      END LOOP;  
      
    ELSE 
        FOR z IN
         (SELECT DISTINCT a.gacc_tran_id
                     FROM giac_acctrans c, giac_prem_deposit a
                    WHERE (   (    p_posting = 'P'
                               AND TRUNC (c.posting_date) BETWEEN p_from_date
                                                              AND p_to_date
                              )
                           OR (    p_transaction = 'T'
                               AND TRUNC (c.tran_date) BETWEEN p_from_date
                                                           AND p_to_date
                              )
                          )
                      AND a.gacc_tran_id = c.tran_id
                      AND a.transaction_type IN (1, 3)
                      AND c.tran_flag <> 'D'
                      AND dep_flag = NVL(p_dep_flag, dep_flag)
                      AND a.assd_no = p_assd_no
                      AND a.gacc_tran_id NOT IN (
                             SELECT c.gacc_tran_id
                               FROM giac_acctrans d, giac_reversals c
                              WHERE c.reversing_tran_id = d.tran_id
                                AND d.tran_flag <> 'D'))
      LOOP
         v_main_tran := z.gacc_tran_id;
         giacs147_pkg.main_ext (p_user_id,
                                p_posting,
                                p_transaction,
                                p_from_date,
                                p_to_date,
                                v_main_tran,
                                p_branch_cd,
                                p_reversal,
                                p_cut_off,
                                p_dep_flag,
                                p_assd_no
                               );
         p_row_count := v_counter;
      END LOOP;
    END IF;
   END extract_wid_reversal;

-----//////////////////////////////////////////////////////////////////////////////////////////////////////////-----
   PROCEDURE main_ext (
      p_user_id       giis_users.user_id%TYPE,
      p_posting       VARCHAR2,
      p_transaction   VARCHAR2,
      p_from_date     DATE,
      p_to_date       DATE,
      p_main_tran     NUMBER,
      p_branch_cd     VARCHAR2,
      p_reversal      VARCHAR2,
      p_cut_off       DATE,
      p_dep_flag      VARCHAR2,
      p_assd_no       VARCHAR2
   )
   IS
   BEGIN
      SELECT param_value_v
        INTO v_fund
        FROM giac_parameters
       WHERE param_name = 'FUND_CD';

      FOR k IN (SELECT a.item_no, a.gacc_tran_id, a.old_tran_id, c.tran_date,
                       (a.collection_amt * NVL (a.convert_rate, 1)
                       ) collection_amt,
                       a.assd_no, a.assured_name, a.remarks, c.tran_class,
                       a.transaction_type, c.gibr_branch_cd, c.tran_year,
                       c.tran_month, c.tran_seq_no, dep_flag
                  FROM giac_acctrans c, giac_prem_deposit a
                 WHERE a.gacc_tran_id = c.tran_id
                   AND (   (    p_posting = 'P'
                            AND TRUNC (c.posting_date) BETWEEN p_from_date
                                                           AND p_to_date
                           )
                        OR (    p_transaction = 'T'
                            AND TRUNC (c.tran_date) BETWEEN p_from_date
                                                        AND p_to_date
                           )
                       )
                   AND a.transaction_type IN (1, 3)
                   AND tran_flag IN ('C', 'P')
                   AND gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
                   /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                     gibr_branch_cd,
                                                     'GIACS147',
                                                     p_user_id
                                                    ) = 1*/
                   --replaced by john 11.26.2014 - optimization for extraction of records for GIACS147 
                   AND ((SELECT access_tag
                              FROM giis_user_modules
                             WHERE userid = NVL (p_user_id, USER)   
                               AND module_id = 'GIACS147'
                               AND tran_cd IN (
                                      SELECT b.tran_cd         
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS147')) = 1
                     OR (SELECT access_tag
                              FROM giis_user_grp_modules
                             WHERE module_id = 'GIACS147'
                               AND (user_grp, tran_cd) IN (
                                      SELECT a.user_grp, b.tran_cd
                                        FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                       WHERE a.user_grp = b.user_grp
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS147')) = 1
                   )
                   AND a.gacc_tran_id = p_main_tran)
      LOOP

         BEGIN
            v_assured_name := k.assured_name;
            v_assd_no := k.assd_no;
            v_remarks := k.remarks;
            v_dep_flag := k.dep_flag;

            IF k.remarks IS NULL AND k.tran_class NOT IN ('COL', 'DV')
            THEN
               FOR b IN (SELECT particulars
                           FROM giac_acctrans
                          WHERE tran_id = k.gacc_tran_id)
               LOOP
                  v_remarks := b.particulars;
               END LOOP;
            END IF;

            v_ref := NULL;

            IF k.tran_class = 'JV'
            THEN
               FOR j IN (SELECT jv_pref_suff
                                || TO_CHAR (tran_class_no) ref_no
                           FROM giac_acctrans
                          WHERE tran_id = k.gacc_tran_id)
               LOOP
                  v_ref := j.ref_no;
               END LOOP;
            ELSIF k.tran_class = 'DV'
            THEN
               FOR d IN (SELECT    dv_pref
                                || DECODE (dv_pref, NULL, NULL, '-')
                                || TO_CHAR (dv_no) ref_no
                           FROM giac_disb_vouchers
                          WHERE gacc_tran_id = k.gacc_tran_id)
               LOOP
                  v_ref := d.ref_no;
               END LOOP;

               IF v_ref = NULL
               THEN
                  FOR r IN (SELECT    b.document_cd
                                   || '-'
                                   || TO_CHAR (b.doc_year)
                                   || '-'
                                   || TO_CHAR (b.doc_mm)
                                   || '-'
                                   || TO_CHAR (b.doc_seq_no) ref_no
                              FROM giac_payt_requests_dtl a,
                                   giac_payt_requests b
                             WHERE a.gprq_ref_id = b.ref_id
                               AND tran_id = v_rev_tran_id)
                  LOOP
                     v_ref := r.ref_no;
                  END LOOP;
               END IF;

               IF k.assured_name IS NULL
               THEN
                  v_assd_no := NULL;
                  v_assured_name := 'No Assured Specified';
               END IF;

               IF k.remarks IS NULL
               THEN
                  FOR b IN (SELECT NVL (gidv.particulars,
                                        gprd.particulars
                                       ) particulars
                              FROM giac_disb_vouchers gidv,
                                   giac_payt_requests_dtl gprd
                             WHERE gidv.gacc_tran_id(+) = gprd.tran_id
                               AND gprd.tran_id = k.gacc_tran_id)
                  LOOP
                     v_remarks := b.particulars;
                  END LOOP;
               END IF;
            ELSIF k.tran_class = 'COL'
            THEN
               FOR c IN (SELECT    or_pref_suf
                                || DECODE (or_pref_suf, NULL, NULL, '-')
                                || TO_CHAR (or_no) ref_no
                           FROM giac_order_of_payts
                          WHERE gacc_tran_id = k.gacc_tran_id)
               LOOP
                  v_ref := c.ref_no;
               END LOOP;

               IF k.assured_name IS NULL
               THEN
                  v_assd_no := NULL;
                  v_assured_name := 'No Assured Specified';
               END IF;

               IF k.remarks IS NULL
               THEN
                  FOR b IN (SELECT particulars
                              FROM giac_order_of_payts
                             WHERE gacc_tran_id = k.gacc_tran_id)
                  LOOP
                     v_remarks := b.particulars;
                  END LOOP;
               END IF;
            ELSE
               FOR t IN (SELECT tran_class || '-' || tran_class_no ref_no
                           FROM giac_acctrans
                          WHERE tran_id = k.gacc_tran_id)
               LOOP
                  v_ref := t.ref_no;
               END LOOP;
            END IF;
            
            v_ref := get_ref_no(k.gacc_tran_id); --added by john 11.26.2014
         END;

         v_tran_key := k.gacc_tran_id;
         v_item_no_key := k.item_no;
         v_item_no := k.item_no;
         v_tran_date := k.tran_date;
         v_collection_amt := k.collection_amt;
         v_tran_type := k.transaction_type;
         v_branch := k.gibr_branch_cd;
         v_tran_class2 := k.tran_class;
         v_tran_year := k.tran_year;
         v_tran_month := k.tran_month;
         v_tran_seq_no := k.tran_seq_no;

         IF p_transaction = 'T'
         THEN
            v_date_flag := 'T';

            IF p_reversal = 'X'
            THEN
               giacs147_pkg.find_rev_yescan (p_user_id,
                                             p_posting,
                                             p_transaction,
                                             p_from_date,
                                             p_to_date,
                                             p_cut_off
                                            );
            ELSIF p_reversal = 'E'
            THEN
               giacs147_pkg.find_rev_nocan (p_user_id,
                                            p_posting,
                                            p_transaction,
                                            p_from_date,
                                            p_to_date,
                                            p_cut_off
                                           );
            ELSE
               --MESSAGE('UNKNOWN VALUE IN REVERSAL CHECK BOX');
               RETURN;
            END IF;
         ELSIF p_posting = 'P'
         THEN
            v_date_flag := 'P';

            IF p_reversal = 'X'
            THEN
               IF p_reversal = 'X'
               THEN
                  giacs147_pkg.find_rev_yescan (p_user_id,
                                                p_posting,
                                                p_transaction,
                                                p_from_date,
                                                p_to_date,
                                                p_cut_off
                                               );
               ELSIF p_reversal = 'E'
               THEN
                  giacs147_pkg.find_rev_nocan (p_user_id,
                                               p_posting,
                                               p_transaction,
                                               p_from_date,
                                               p_to_date,
                                               p_cut_off
                                              );
               ELSE
                  --MESSAGE('UNKNOWN VALUE IN REVERSAL CHECK BOX');
                  RETURN;
               END IF;
            ELSIF p_reversal = 'E'
            THEN
               giacs147_pkg.find_rev2 (p_posting,
                                       p_transaction,
                                       p_cut_off,
                                       p_user_id,
                                       p_from_date,
                                       p_to_date
                                      );
            ELSE
               RETURN;
            --MESSAGE('INVALID VALUE FOR REVERSAL');
            END IF;
         ELSE
            RETURN;
         --MESSAGE('IVALID VALUE FOR CHECK BOX');
         END IF;

         --v_counter := v_counter + 1;
      END LOOP;
   END;

   PROCEDURE find_rev2 (
      p_posting       VARCHAR2,
      p_transaction   VARCHAR2,
      p_cut_off       DATE,
      p_user_id       giis_users.user_id%TYPE,
      p_from_date     DATE,
      p_to_date       DATE
   )
   IS
   BEGIN
      BEGIN
         SELECT a.gacc_tran_id
           INTO v_tran_key2
           FROM giac_acctrans c, giac_prem_deposit a
          WHERE a.gacc_tran_id = c.tran_id
            AND old_tran_id = v_tran_key
            AND old_item_no = v_item_no_key
            AND (   (p_posting = 'P' AND TRUNC (c.posting_date) <= p_cut_off)
                 OR (p_transaction = 'T' AND TRUNC (c.tran_date) <= p_cut_off
                    )
                );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tran_key2 := NULL;
         WHEN TOO_MANY_ROWS
         THEN
            v_tran_key2 := 1;
      END;

      IF v_tran_key2 IS NULL
      THEN
         v_count := 0;
      ELSE
         v_count := 1;
      END IF;

      IF v_count = 0
      THEN
         v_rev_tran_id := NULL;
         v_rev_old_tran_id := NULL;
         v_rev_prem_dep := NULL;
         v_collection2 := NULL;
         v_rev_trandate := NULL;
         v_tran_class := NULL;
         v_rev_trantype := NULL;
         v_rev_ref := NULL;
         v_rev_tranclass := NULL;
         v_rev_tranyear := NULL;
         v_rev_tranmonth := NULL;
         v_rev_transeqno := NULL;
         
         IF v_param_rdo_dep = 'A' THEN
            giacs147_pkg.insert_d_values (p_user_id,
                                       p_from_date,
                                       p_to_date,
                                       p_cut_off
                                      );
                                      
            v_counter := v_counter + 1;
                                      
         ELSE
             IF (v_collection_amt + v_rev_prem_dep) != 0 THEN
                giacs147_pkg.insert_d_values (p_user_id,
                                       p_from_date,
                                       p_to_date,
                                       p_cut_off
                                      );
                v_counter := v_counter + 1;                      
             END IF;                           
         END IF;
         
      ELSE
         v_temp_item2 := 0;
         v_payment2 := 0;

         FOR m IN (SELECT a.gacc_tran_id, a.old_item_no, a.old_tran_id,
                          (a.collection_amt * NVL (a.convert_rate, 1)
                          ) collection_amt,
                          c.tran_date, c.tran_class, a.transaction_type,
                          c.tran_year, c.tran_month, c.tran_seq_no
                     FROM giac_prem_deposit a, giac_acctrans c
                    WHERE a.gacc_tran_id = c.tran_id
                      AND p_posting = 'P'
                      AND TRUNC (c.posting_date) <= p_cut_off
                      AND a.transaction_type IN (2, 4)
                      AND a.old_tran_id = v_tran_key
                      AND a.old_tran_id IS NOT NULL
                      AND a.old_item_no = v_item_no
                      AND c.tran_flag <> 'D')
         LOOP
            v_temp_item := m.old_item_no;

            IF v_temp_item2 = v_temp_item
            THEN
               v_insert_payment := m.collection_amt + v_payment2;
               v_temp_item2 := v_temp_item;
            ELSE
               v_insert_payment := m.collection_amt;
               v_temp_item2 := v_temp_item;
               v_payment2 := m.collection_amt;
            END IF;

            v_rev_tran_id := m.gacc_tran_id;
            v_rev_old_tran_id := m.old_tran_id;
            v_rev_prem_dep := v_insert_payment;
            v_collection2 := m.collection_amt;
            v_rev_trandate := m.tran_date;
            v_tran_class := m.tran_class;
            v_rev_trantype := m.transaction_type;
            v_rev_tranclass := m.tran_class;
            v_rev_tranyear := m.tran_year;
            v_rev_tranmonth := m.tran_month;
            v_rev_transeqno := m.tran_seq_no;

            BEGIN
               v_rev_ref := NULL;

               IF v_tran_class = 'JV'
               THEN
                  FOR j IN (SELECT    jv_pref_suff
                                   || TO_CHAR (tran_class_no) ref_no
                              FROM giac_acctrans
                             WHERE tran_id = v_rev_tran_id)
                  LOOP
                     v_rev_ref := j.ref_no;
                  END LOOP;
               ELSIF v_tran_class = 'DV'
               THEN
                  BEGIN
                     FOR d IN (SELECT    dv_pref
                                      || DECODE (dv_pref, NULL, NULL, '-')
                                      || TO_CHAR (dv_no) ref_no
                                 FROM giac_disb_vouchers
                                WHERE gacc_tran_id = v_rev_tran_id)
                     LOOP
                        v_rev_ref := d.ref_no;
                     END LOOP;

                     IF v_rev_ref IS NULL
                     THEN
                        FOR r IN (SELECT    b.document_cd
                                         || '-'
                                         || TO_CHAR (b.doc_year)
                                         || '-'
                                         || TO_CHAR (b.doc_mm)
                                         || '-'
                                         || TO_CHAR (b.doc_seq_no) ref_no
                                    FROM giac_payt_requests_dtl a,
                                         giac_payt_requests b
                                   WHERE a.gprq_ref_id = b.ref_id
                                     AND tran_id = v_rev_tran_id)
                        LOOP
                           v_rev_ref := r.ref_no;
                        END LOOP;
                     END IF;
                  END;
               ELSIF v_tran_class = 'COL'
               THEN
                  FOR c IN (SELECT    or_pref_suf
                                   || DECODE (or_pref_suf, NULL, NULL, '-')
                                   || TO_CHAR (or_no) ref_no
                              FROM giac_order_of_payts
                             WHERE gacc_tran_id = v_rev_tran_id)
                  LOOP
                     v_rev_ref := c.ref_no;
                  END LOOP;
               ELSE
                  FOR t IN (SELECT tran_class || '-' || tran_class_no ref_no
                              FROM giac_acctrans
                             WHERE tran_id = v_rev_tran_id)
                  LOOP
                     v_rev_ref := t.ref_no;
                  END LOOP;
               END IF;
            END;

            IF v_param_rdo_dep = 'A' THEN
                giacs147_pkg.insert_d_values (p_user_id,
                                           p_from_date,
                                           p_to_date,
                                           p_cut_off
                                          );
                v_counter := v_counter + 1;                          
                                          
             ELSE
                 IF (v_collection_amt + v_rev_prem_dep) != 0 THEN
                    giacs147_pkg.insert_d_values (p_user_id,
                                           p_from_date,
                                           p_to_date,
                                           p_cut_off
                                          );
                    v_counter := v_counter + 1;                      
                 END IF;                           
             END IF;
         END LOOP;
      END IF;
   END;

   PROCEDURE insert_d_values (
      p_user_id     giis_users.user_id%TYPE,
      p_from_date   DATE,
      p_to_date     DATE,
      p_cut_off     DATE
   )
   IS
   BEGIN
      INSERT INTO giac_premdeposit_ext
                  (fund_cd, branch_cd, tran_id, tran_date, ref_no,
                   item_no, tran_type, collection_amt,
                   assd_no,
                   assured_name,
                   remarks, rev_tran_date,
                   rev_coll_amt, rev_tran_id, rev_tran_type, rev_ref_no,
                   balance, from_date,
                   TO_DATE, cutoff_date, date_flag, user_id,
                   tran_class, tran_year, tran_month, tran_seq_no,
                   rev_tran_class, rev_tran_year, rev_tran_month,
                   rev_tran_seq_no, dep_flag, param_branch_cd,
                   param_assd_no, param_dep_flag, param_rdo_dep
                  )
           VALUES (v_fund, v_branch, v_tran_key, v_tran_date, v_ref,
                   v_item_no, v_tran_type, v_collection_amt,
                   NVL (v_assd_no, NULL),
                   NVL (v_assured_name, 'No Assured Specified'),
                   NVL (v_remarks, 'No Remarks Specified'), v_rev_trandate,
                   v_collection2, v_rev_tran_id, v_rev_trantype, v_rev_ref,
                   (v_collection_amt + v_rev_prem_dep
                   ), p_from_date,
                   p_to_date, p_cut_off, v_date_flag, p_user_id,
                   v_tran_class, v_tran_year, v_tran_month, v_tran_seq_no,
                   v_rev_tranclass, v_rev_tranyear, v_rev_tranmonth,
                   v_rev_transeqno, v_dep_flag, v_param_branch_cd,
                   v_param_assd_no, v_param_dep_flag , v_param_rdo_dep  
                  );

      v_ctr := v_ctr + 1;
   END;

   PROCEDURE find_rev_yescan (
      p_user_id       giis_users.user_id%TYPE,
      p_posting       VARCHAR2,
      p_transaction   VARCHAR2,
      p_from_date     DATE,
      p_to_date       DATE,
      p_cut_off       DATE
   )
   IS
   BEGIN
      BEGIN
         SELECT a.gacc_tran_id
           INTO v_tran_key2
           FROM giac_acctrans c, giac_prem_deposit a
          WHERE a.gacc_tran_id = c.tran_id
            AND old_tran_id = v_tran_key
            AND old_item_no = v_item_no_key
            AND c.tran_flag <> 'D'
            AND (   (p_posting = 'P' AND TRUNC (c.posting_date) <= p_cut_off)
                 OR (p_transaction = 'T' AND TRUNC (c.tran_date) <= p_cut_off
                    )
                )
            AND a.gacc_tran_id NOT IN (
                   SELECT c.gacc_tran_id
                     FROM giac_acctrans d, giac_reversals c
                    WHERE c.reversing_tran_id = d.tran_id
                      AND d.tran_flag <> 'D');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tran_key2 := NULL;
         WHEN TOO_MANY_ROWS
         THEN
            v_tran_key2 := 1;
      END;

      IF v_tran_key2 IS NULL
      THEN
         v_count := 0;
      ELSE
         v_count := 1;
      END IF;

      IF v_count = 0
      THEN
         v_rev_tran_id := NULL;
         v_rev_old_tran_id := NULL;
         v_rev_prem_dep := NULL;
         v_collection2 := NULL;
         v_rev_trandate := NULL;
         v_tran_class := NULL;
         v_rev_trantype := NULL;
         v_rev_ref := NULL;
         v_rev_tranclass := NULL;
         v_rev_tranyear := NULL;
         v_rev_tranmonth := NULL;
         v_rev_transeqno := NULL;
         IF v_param_rdo_dep = 'A' THEN
            giacs147_pkg.insert_d_values (p_user_id,
                                       p_from_date,
                                       p_to_date,
                                       p_cut_off
                                      );
            v_counter := v_counter + 1;                          
                                      
         ELSE
             IF (v_collection_amt + v_rev_prem_dep) != 0 THEN
                giacs147_pkg.insert_d_values (p_user_id,
                                       p_from_date,
                                       p_to_date,
                                       p_cut_off
                                      );
                v_counter := v_counter + 1;                     
             END IF;                           
         END IF;
      ELSE
         v_temp_item2 := 0;
         v_payment2 := 0;

         FOR m IN
            (SELECT a.gacc_tran_id, a.old_item_no, a.old_tran_id,
                    (a.collection_amt * NVL (a.convert_rate, 1)
                    ) collection_amt,
                    c.tran_date, c.tran_class, a.transaction_type,
                    c.tran_year, c.tran_month, c.tran_seq_no
               FROM giac_acctrans c, giac_prem_deposit a
              WHERE a.gacc_tran_id = c.tran_id
                AND (   (p_posting = 'P'
                         AND TRUNC (c.posting_date) <= p_cut_off
                        )
                     OR (    p_transaction = 'T'
                         AND TRUNC (c.tran_date) <= p_cut_off
                        )
                    )
                AND a.transaction_type IN (2, 4)
                AND a.old_tran_id = v_tran_key
                AND a.old_tran_id IS NOT NULL
                AND a.old_item_no = v_item_no
                AND c.tran_flag <> 'D'
                AND a.gacc_tran_id NOT IN (
                       SELECT c.gacc_tran_id
                         FROM giac_acctrans d, giac_reversals c
                        WHERE c.reversing_tran_id = d.tran_id
                          AND d.tran_flag <> 'D'))
         LOOP
            v_temp_item := m.old_item_no;

            IF v_temp_item2 = v_temp_item
            THEN
               v_insert_payment := m.collection_amt + v_payment2;
               v_temp_item2 := v_temp_item;
            ELSE
               v_insert_payment := m.collection_amt;
               v_temp_item2 := v_temp_item;
               v_payment2 := m.collection_amt;
            END IF;

            v_rev_tran_id := m.gacc_tran_id;
            v_rev_old_tran_id := m.old_tran_id;
            v_rev_prem_dep := v_insert_payment;
            v_collection2 := m.collection_amt;
            v_rev_trandate := m.tran_date;
            v_tran_class := m.tran_class;
            v_rev_trantype := m.transaction_type;
            v_rev_tranclass := m.tran_class;
            v_rev_tranyear := m.tran_year;
            v_rev_tranmonth := m.tran_month;
            v_rev_transeqno := m.tran_seq_no;

            BEGIN
               v_rev_ref := NULL;

               IF v_tran_class = 'JV'
               THEN
                  FOR j IN (SELECT    jv_pref_suff
                                   || TO_CHAR (tran_class_no) ref_no
                              FROM giac_acctrans
                             WHERE tran_id = v_rev_tran_id)
                  LOOP
                     v_rev_ref := j.ref_no;
                  END LOOP;
               ELSIF v_tran_class = 'DV'
               THEN
                  BEGIN
                     FOR d IN (SELECT    dv_pref
                                      || DECODE (dv_pref, NULL, NULL, '-')
                                      || TO_CHAR (dv_no) ref_no
                                 FROM giac_disb_vouchers
                                WHERE gacc_tran_id = v_rev_tran_id)
                     LOOP
                        v_rev_ref := d.ref_no;
                     END LOOP;

                     IF v_rev_ref IS NULL
                     THEN
                        FOR r IN (SELECT    b.document_cd
                                         || '-'
                                         || TO_CHAR (b.doc_year)
                                         || '-'
                                         || TO_CHAR (b.doc_mm)
                                         || '-'
                                         || TO_CHAR (b.doc_seq_no) ref_no
                                    FROM giac_payt_requests_dtl a,
                                         giac_payt_requests b
                                   WHERE a.gprq_ref_id = b.ref_id
                                     AND tran_id = v_rev_tran_id)
                        LOOP
                           v_rev_ref := r.ref_no;
                        END LOOP;
                     END IF;
                  END;
               ELSIF v_tran_class = 'COL'
               THEN
                  FOR c IN (SELECT    or_pref_suf
                                   || DECODE (or_pref_suf, NULL, NULL, '-')
                                   || TO_CHAR (or_no) ref_no
                              FROM giac_order_of_payts
                             WHERE gacc_tran_id = v_rev_tran_id)
                  LOOP
                     v_rev_ref := c.ref_no;
                  END LOOP;
               ELSE
                  FOR t IN (SELECT tran_class || '-' || tran_class_no ref_no
                              FROM giac_acctrans
                             WHERE tran_id = v_rev_tran_id)
                  LOOP
                     v_rev_ref := t.ref_no;
                  END LOOP;
               END IF;
            END;

            IF v_param_rdo_dep = 'A' THEN
                giacs147_pkg.insert_d_values (p_user_id,
                                           p_from_date,
                                           p_to_date,
                                           p_cut_off
                                          );
                v_counter := v_counter + 1;                          
                                          
             ELSE
                 IF (v_collection_amt + v_rev_prem_dep) != 0 THEN
                    giacs147_pkg.insert_d_values (p_user_id,
                                           p_from_date,
                                           p_to_date,
                                           p_cut_off
                                          );
                    v_counter := v_counter + 1;                      
                 END IF;                           
             END IF;
         END LOOP;
      END IF;
   END;

   PROCEDURE find_rev_nocan (
      p_user_id       giis_users.user_id%TYPE,
      p_posting       VARCHAR2,
      p_transaction   VARCHAR2,
      p_from_date     DATE,
      p_to_date       DATE,
      p_cut_off       DATE
   )
   IS
   BEGIN
      BEGIN
         SELECT a.gacc_tran_id
           INTO v_tran_key2
           FROM giac_acctrans c, giac_prem_deposit a
          WHERE a.gacc_tran_id = c.tran_id
            AND old_tran_id = v_tran_key
            AND old_item_no = v_item_no_key
            AND c.tran_flag <> 'D'
            AND (   (p_posting = 'P' AND TRUNC (c.posting_date) <= p_cut_off)
                 OR (p_transaction = 'T' AND TRUNC (c.tran_date) <= p_cut_off
                    )
                );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_tran_key2 := NULL;
         WHEN TOO_MANY_ROWS
         THEN
            v_tran_key2 := 1;
      END;

      IF v_tran_key2 IS NULL
      THEN
         v_count := 0;
      ELSE
         v_count := 1;
      END IF;

      IF v_count = 0
      THEN
         v_rev_tran_id := NULL;
         v_rev_old_tran_id := NULL;
         v_rev_prem_dep := NULL;
         v_collection2 := NULL;
         v_rev_trandate := NULL;
         v_tran_class := NULL;
         v_rev_trantype := NULL;
         v_rev_ref := NULL;
         v_rev_tranclass := NULL;
         v_rev_tranyear := NULL;
         v_rev_tranmonth := NULL;
         v_rev_transeqno := NULL;
         IF v_param_rdo_dep = 'A' THEN
            giacs147_pkg.insert_d_values (p_user_id,
                                       p_from_date,
                                       p_to_date,
                                       p_cut_off
                                      );
            v_counter := v_counter + 1;                         
                                      
         ELSE
             IF (v_collection_amt + v_rev_prem_dep) != 0 THEN
                giacs147_pkg.insert_d_values (p_user_id,
                                       p_from_date,
                                       p_to_date,
                                       p_cut_off
                                      );
                v_counter := v_counter + 1;                      
             END IF;                           
         END IF;
      ELSE
         v_temp_item2 := 0;
         v_payment2 := 0;

         FOR m IN (SELECT a.gacc_tran_id, a.old_item_no, a.old_tran_id,
                          (a.collection_amt * NVL (a.convert_rate, 1)
                          ) collection_amt,
                          c.tran_date, c.tran_class, a.transaction_type,
                          c.tran_year, c.tran_month, c.tran_seq_no
                     FROM giac_acctrans c, giac_prem_deposit a
                    WHERE a.gacc_tran_id = c.tran_id
                      AND (   (    p_posting = 'P'
                               AND TRUNC (c.posting_date) <= p_cut_off
                              )
                           OR (    p_transaction = 'T'
                               AND TRUNC (c.tran_date) <= p_cut_off
                              )
                          )
                      AND a.transaction_type IN (2, 4)
                      AND a.old_tran_id = v_tran_key
                      AND a.old_tran_id IS NOT NULL
                      AND a.old_item_no = v_item_no
                      AND c.tran_flag <> 'D')
         LOOP
            v_temp_item := m.old_item_no;

            IF v_temp_item2 = v_temp_item
            THEN
               v_insert_payment := m.collection_amt + v_payment2;
               v_temp_item2 := v_temp_item;
            ELSE
               v_insert_payment := m.collection_amt;
               v_temp_item2 := v_temp_item;
               v_payment2 := m.collection_amt;
            END IF;

            v_rev_tran_id := m.gacc_tran_id;
            v_rev_old_tran_id := m.old_tran_id;
            v_rev_prem_dep := v_insert_payment;
            v_collection2 := m.collection_amt;
            v_rev_trandate := m.tran_date;
            v_tran_class := m.tran_class;
            v_rev_trantype := m.transaction_type;
            v_rev_tranclass := m.tran_class;
            v_rev_tranyear := m.tran_year;
            v_rev_tranmonth := m.tran_month;
            v_rev_transeqno := m.tran_seq_no;

            BEGIN
               v_rev_ref := NULL;

               IF v_tran_class = 'JV'
               THEN
                  FOR j IN (SELECT    jv_pref_suff
                                   || TO_CHAR (tran_class_no) ref_no
                              FROM giac_acctrans
                             WHERE tran_id = v_rev_tran_id)
                  LOOP
                     v_rev_ref := j.ref_no;
                  END LOOP;
               ELSIF v_tran_class = 'DV'
               THEN
                  BEGIN
                     FOR d IN (SELECT    dv_pref
                                      || DECODE (dv_pref, NULL, NULL, '-')
                                      || TO_CHAR (dv_no) ref_no
                                 FROM giac_disb_vouchers
                                WHERE gacc_tran_id = v_rev_tran_id)
                     LOOP
                        v_rev_ref := d.ref_no;
                     END LOOP;

                     IF v_rev_ref IS NULL
                     THEN
                        FOR r IN (SELECT    b.document_cd
                                         || '-'
                                         || TO_CHAR (b.doc_year)
                                         || '-'
                                         || TO_CHAR (b.doc_mm)
                                         || '-'
                                         || TO_CHAR (b.doc_seq_no) ref_no
                                    FROM giac_payt_requests_dtl a,
                                         giac_payt_requests b
                                   WHERE a.gprq_ref_id = b.ref_id
                                     AND tran_id = v_rev_tran_id)
                        LOOP
                           v_rev_ref := r.ref_no;
                        END LOOP;
                     END IF;
                  END;
               ELSIF v_tran_class = 'COL'
               THEN
                  FOR c IN (SELECT    or_pref_suf
                                   || DECODE (or_pref_suf, NULL, NULL, '-')
                                   || TO_CHAR (or_no) ref_no
                              FROM giac_order_of_payts
                             WHERE gacc_tran_id = v_rev_tran_id)
                  LOOP
                     v_rev_ref := c.ref_no;
                  END LOOP;
               ELSE
                  FOR t IN (SELECT tran_class || '-' || tran_class_no ref_no
                              FROM giac_acctrans
                             WHERE tran_id = v_rev_tran_id)
                  LOOP
                     v_rev_ref := t.ref_no;
                  END LOOP;
               END IF;
            END;

            IF v_param_rdo_dep = 'A' THEN
                giacs147_pkg.insert_d_values (p_user_id,
                                           p_from_date,
                                           p_to_date,
                                           p_cut_off
                                          );
                v_counter := v_counter + 1;                          
                                          
             ELSE
                 IF (v_collection_amt + v_rev_prem_dep) != 0 THEN
                    giacs147_pkg.insert_d_values (p_user_id,
                                           p_from_date,
                                           p_to_date,
                                           p_cut_off
                                          );
                    v_counter := v_counter + 1;                      
                 END IF;                           
             END IF;
         END LOOP;
      END IF;
   END;
END GIACS147_PKG;
/



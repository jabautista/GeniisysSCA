CREATE OR REPLACE PACKAGE BODY CPI.GIACR062_PKG
AS
   FUNCTION get_main_rep (
      p_user_id      VARCHAR2,
      p_module_id    VARCHAR2,
      p_fund_cd      VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_category     VARCHAR2,
      p_control      VARCHAR2,
      p_tran_class   VARCHAR2,
      p_tran_flag    VARCHAR2,
      p_tran_post    VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_sub_1        VARCHAR2,
      p_sub_2        VARCHAR2,
      p_sub_3        VARCHAR2,
      p_sub_4        VARCHAR2,
      p_sub_5        VARCHAR2,
      p_sub_6        VARCHAR2,
      p_sub_7        VARCHAR2
   )
      RETURN main_tab PIPELINED
   IS
      v_list main_type;
   BEGIN
      FOR i IN (SELECT  TO_CHAR (a.gl_acct_category)
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00')) gl_acct_code,
                         e.gl_acct_name gl_acct_name,
                         SUM (a.debit_amt) db_amt, SUM (a.credit_amt) cd_amt, a.gl_acct_id
                    FROM giac_chart_of_accts e,
                         giac_disb_vouchers d,   
                         giac_order_of_payts c, 
                         giac_acctrans b,
                         giac_acct_entries a
                   WHERE a.gacc_tran_id = b.tran_id
                     AND check_user_per_iss_cd_acctg2 (NULL, a.gacc_gibr_branch_cd, p_module_id, p_user_id) = 1  
                     AND a.gacc_tran_id = c.gacc_tran_id(+)
                     AND a.gacc_tran_id = d.gacc_tran_id(+)
                     AND a.gacc_gibr_branch_cd = NVL (p_branch_cd, a.gacc_gibr_branch_cd)
                     AND a.gacc_gfun_fund_cd = p_fund_cd
                     AND a.gl_acct_category = NVL (p_category, a.gl_acct_category)
                     AND a.gl_control_acct = NVL (p_control, a.gl_control_acct)
                     AND a.gl_sub_acct_1 = NVL (p_sub_1, a.gl_sub_acct_1)
                     AND a.gl_sub_acct_2 = NVL (p_sub_2, a.gl_sub_acct_2)
                     AND a.gl_sub_acct_3 = NVL (p_sub_3, a.gl_sub_acct_3)
                     AND a.gl_sub_acct_4 = NVL (p_sub_4, a.gl_sub_acct_4)
                     AND a.gl_sub_acct_5 = NVL (p_sub_5, a.gl_sub_acct_5)
                     AND a.gl_sub_acct_6 = NVL (p_sub_6, a.gl_sub_acct_6)
                     AND a.gl_sub_acct_7 = NVL (p_sub_7, a.gl_sub_acct_7)
                     AND b.tran_class = NVL (p_tran_class, b.tran_class)
                     AND a.gl_acct_id = e.gl_acct_id
                     AND b.tran_flag <> 'D'
                     AND b.tran_flag NOT IN (p_tran_flag)
                     AND DECODE (p_tran_post,
                                 'T', TRUNC(b.tran_date),
                                 'P', TRUNC(b.posting_date),
                                      TRUNC(b.tran_date)) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                GROUP BY TO_CHAR (a.gl_acct_category)
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00')),
                         e.gl_acct_name, a.gl_acct_id)
      LOOP
         v_list.gl_acct_code := i.gl_acct_code;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.db_amt := i.db_amt;
         v_list.cd_amt := i.cd_amt;
         v_list.bal := NVL(i.db_amt, 0) - NVL(i.cd_amt, 0);
         
         IF v_list.company_name IS NULL THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;
         
         IF v_list.from_date IS NULL THEN
            v_list.from_date := TRIM(TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.to_date := TRIM(TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
         
         IF v_list.branch IS NULL AND p_branch_cd IS NOT NULL THEN
            BEGIN
               SELECT branch_name
                 INTO v_list.branch
                 FROM giac_branches
                WHERE  branch_cd = p_branch_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     v_list.branch := NULL;    
            END;
         END IF;   
      
         PIPE ROW(v_list);
      END LOOP;
   END get_main_rep;
   
   FUNCTION get_details (
      p_user_id      VARCHAR2,
      p_module_id    VARCHAR2,
      p_fund_cd      VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_category     VARCHAR2,
      p_control      VARCHAR2,
      p_tran_class   VARCHAR2,
      p_tran_flag    VARCHAR2,
      p_tran_post    VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_gl_acct_code   VARCHAR2
   )
      RETURN details_tab PIPELINED
   IS
      v_list details_type;
      v_ctr NUMBER(3) := 0;
      v_ref_no VARCHAR2(1000);
   BEGIN      
      FOR i IN (SELECT   a.gacc_tran_id, LPAD (a.gacc_tran_id, 12, 0) tran_id,
                     DECODE (p_tran_post,
                             'T', TRUNC (b.tran_date),
                             'P', TRUNC (b.posting_date)) tran_post,
                     b.tran_class,
                     c.or_pref_suf || '-' || LPAD (TO_CHAR (c.or_no), 10, '0') col_ref_no,
                     LPAD (TO_CHAR (b.tran_class_no), 10, '0') jv_ref_no,
                     DECODE (b.tran_class,
                             'COL', c.particulars,
                             'DV', d.particulars,
                             'JV', b.particulars,
                             b.particulars
                            ) particulars,
                     SUM (a.debit_amt) db_amt, SUM (a.credit_amt) cd_amt, 
                     b.jv_pref, b.jv_seq_no -- added by gab 09.14.2015
                FROM giac_chart_of_accts e, 
                     giac_disb_vouchers d,
                     giac_order_of_payts c,
                     giac_acctrans b,
                     giac_acct_entries a
               WHERE a.gacc_tran_id = b.tran_id
                 AND check_user_per_iss_cd_acctg (NULL, a.gacc_gibr_branch_cd, 'GIACS060') = 1                                                               
                 AND a.gacc_tran_id = c.gacc_tran_id(+)
                 AND a.gacc_tran_id = d.gacc_tran_id(+)
                 AND a.gacc_gibr_branch_cd = NVL (p_branch_cd, a.gacc_gibr_branch_cd)
                 AND a.gacc_gfun_fund_cd = p_fund_cd
                 AND a.gl_acct_category = NVL (p_category, a.gl_acct_category)
                 AND a.gl_control_acct = NVL (p_control, a.gl_control_acct)
                 AND TO_CHAR (a.gl_acct_category)
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00')) = p_gl_acct_code
                 AND b.tran_class = NVL (p_tran_class, b.tran_class)
                 AND a.gl_acct_id = e.gl_acct_id
                 AND b.tran_flag <> 'D'
                 AND b.tran_flag NOT IN (p_tran_flag)
                 AND DECODE (p_tran_post,
                                 'T', TRUNC(b.tran_date),
                                 'P', TRUNC(b.posting_date),
                                      TRUNC(b.tran_date)) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
            GROUP BY a.gacc_tran_id,
                     LPAD (a.gacc_tran_id, 12, 0),
                        TO_CHAR (a.gl_acct_category)
                     || '-'
                     || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                     || '-'
                     || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                     || '-'
                     || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                     || '-'
                     || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                     || '-'
                     || LTRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                     || '-'
                     || LTRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                     || '-'
                     || LTRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                     || '-'
                     || LTRIM (TO_CHAR (a.gl_sub_acct_7, '00')),
                     e.gl_acct_name,
                     DECODE (p_tran_post,
                             'T', TRUNC (b.tran_date),
                             'P', TRUNC (b.posting_date)),
                     b.tran_class,
                     c.or_pref_suf || '-' || LPAD (TO_CHAR (c.or_no), 10, '0'),
                     LPAD (TO_CHAR (b.tran_class_no), 10, '0'),
                     DECODE (b.tran_class,
                             'COL', c.particulars,
                             'DV', d.particulars,
                             'JV', b.particulars,
                             b.particulars
                             ), b.jv_pref,
                             b.jv_seq_no)
      LOOP
         v_list.tran_post := i.tran_post;
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.tran_id := i.tran_id;
         v_list.tran_class := i.tran_class;
         v_list.jv_ref_no := i.jv_ref_no;
         v_list.col_ref_no := i.col_ref_no;
         v_list.particulars := i.particulars;
         v_list.db_amt := i.db_amt;
         v_list.cd_amt := i.cd_amt;
         v_list.balance := NVL(i.db_amt, 0) - NVL(i.cd_amt, 0);
         v_list.jv_ref_no2 := i.jv_pref || ' ' || LPAD (TO_CHAR(i.jv_seq_no), 12, '0'); --added by gab 09.14.2015
         
         BEGIN
           IF i.tran_class = 'COL'
           THEN
              v_ref_no := i.col_ref_no;
           ELSIF i.tran_class = 'DV' THEN
              BEGIN
                 SELECT    a.dv_pref
                        || '-'
                        || LPAD (TO_CHAR (a.dv_no), 10, '0')
                        || '/'
                        ||                            
                           b.check_pref_suf
                        || '-'
                        || LPAD (TO_CHAR (b.check_no), 10, '0')
                   INTO v_ref_no
                   FROM giac_disb_vouchers a, giac_chk_disbursement b
                  WHERE b.check_stat = 2
                    AND a.gacc_tran_id = b.gacc_tran_id
                    AND a.gacc_tran_id = i.tran_id;
              EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                    SELECT    document_cd
                           || '-'
                           || branch_cd
                           || '-'
                           || LPAD (TO_CHAR (doc_year), 4, '0')
                           || '-'
                           || LPAD (TO_CHAR (doc_mm), 2, '0')
                           || '-'
                           || LPAD
                                 (TO_CHAR (doc_seq_no), 6, '0')
                                                          
                      INTO v_ref_no
                      FROM giac_payt_requests a, giac_payt_requests_dtl b
                     WHERE a.ref_id = b.gprq_ref_id AND tran_id = i.tran_id;
                 WHEN TOO_MANY_ROWS
                 THEN
                    FOR x IN
                       (SELECT    a.dv_pref
                               || '-'
                               || LPAD (TO_CHAR (a.dv_no), 10, '0')
                               || '/'
                               ||                     
                                  b.check_pref_suf
                               || '-'
                               || LPAD (TO_CHAR (b.check_no), 10, '0') refno
                                                         
                        FROM   giac_disb_vouchers a, giac_chk_disbursement b
                         WHERE b.check_stat = 2
                           AND a.gacc_tran_id = b.gacc_tran_id
                           AND a.gacc_tran_id = i.tran_id)
                    LOOP
                       v_ctr := v_ctr + 1;

                       IF v_ctr > 1
                       THEN
                          v_ref_no := v_ref_no || CHR (10) || x.refno;
                       END IF;
                    END LOOP;
              END;
           ELSIF i.tran_class = 'JV' THEN                                            
              BEGIN
                 SELECT    DECODE (ref_jv_no, NULL, NULL, ref_jv_no || ' / ')
                        || tran_year
                        || '-'
                        || tran_month
                        || '-'
                        || tran_seq_no
                        || ' / '
                        || jv_pref_suff
                        || '-'
                        || LPAD (TO_CHAR (jv_no), 6, '0')
                                                      
                   INTO v_ref_no
                   FROM giac_acctrans
                  WHERE tran_id = i.tran_id;
              EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                    v_ref_no := NULL;
                 WHEN TOO_MANY_ROWS
                 THEN
                    v_ref_no := v_ref_no;
              END;
           ELSE
              v_ref_no := get_ref_no (i.gacc_tran_id);                   
           END IF;

           v_list.cf_ref_no := v_ref_no;
        END;
         
         PIPE ROW(v_list);
      END LOOP;      
   END get_details;
   
   -- new function by jhing - GENQA 5280, 5200
   FUNCTION generate_giacr062 (p_branch_cd       VARCHAR2,
                               p_category        VARCHAR2,
                               p_fund_cd         VARCHAR2,
                               p_control         VARCHAR2,
                               p_from_date       VARCHAR2,
                               p_to_date         VARCHAR2,
                               p_tran_post       VARCHAR2,
                               p_sub1            VARCHAR2,
                               p_sub2            VARCHAR2,
                               p_sub3            VARCHAR2,
                               p_sub4            VARCHAR2,
                               p_sub5            VARCHAR2,
                               p_sub6            VARCHAR2,
                               p_sub7            VARCHAR2,
                               p_tran_flag       VARCHAR2,
                               p_tran_class      VARCHAR2,
                               p_all_branches  VARCHAR2,
                               p_user_id       VARCHAR2,
                               p_module_id     VARCHAR2)
      RETURN giacr062_tab
      PIPELINED
   IS
      v_list               giacr062_type;
      v_1                  NUMBER;
      v_2                  NUMBER;
      v_3                  NUMBER;

      v_rec1               giacr062_type;
      v_tempTbl            giacr062_tab;
      v_withCnt            VARCHAR2 (1);
      v_branch_accessible  VARCHAR2(2000); 
      v_withTargetRec      VARCHAR2(1);
      v_recPrinted         NUMBER ;

      TYPE tempRec IS RECORD
      (
         gacc_tran_id       giac_acctrans.tran_id%TYPE,
         gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
         gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
         gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
         gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
         gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
         gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
         gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
         gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
         gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE,
         tran_class         giac_acctrans.tran_class%TYPE,
         month_grp          VARCHAR2 (100),
         month_grp_seq      NUMBER,
         year_grp_seq       NUMBER,
         gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
         tot_debit_amt      NUMBER (16, 2),
         tot_credit_amt     NUMBER (16, 2),
         gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
         tran_date          giac_acctrans.tran_date%TYPE,
         posting_date       giac_acctrans.posting_date%TYPE,
         tran_flag          giac_acctrans.tran_flag%TYPE,
         particulars        giac_acctrans.particulars%TYPE,
         jv_ref_no          VARCHAR2 (10),
         jv_pref            giac_acctrans.jv_pref%TYPE,
         jv_seq_no          giac_acctrans.jv_seq_no%TYPE
      );

      TYPE tempRecTbl IS TABLE OF tempRec;

      v_tempTable          tempRecTbl;

      v_limit              NUMBER := 500;
      v_temp_indx          NUMBER := 0;
      
      v_cntExt             NUMBER := 0 ; 

      TYPE v_totals_rec IS TABLE OF NUMBER
         INDEX BY BINARY_INTEGER;


      v_gl_totals_indx     v_totals_rec;

      v_company_name       giis_parameters.param_value_v%TYPE;
      v_company_address    giis_parameters.param_value_v%TYPE;
		v_company_tin        giis_parameters.param_value_v%TYPE; -- bonok :: 3.22.2017 :: SR 5964
		v_gen_version        giis_parameters.param_value_v%TYPE; -- bonok :: 3.22.2017 :: SR 5964


      CURSOR getAllRecords ( p_branches_withAcc VARCHAR2 ) 
      IS
           SELECT a.gacc_tran_id,
                  e.gl_acct_category,
                  e.gl_control_acct,
                  e.gl_sub_acct_1,
                  e.gl_sub_acct_2,
                  e.gl_sub_acct_3,
                  e.gl_sub_acct_4,
                  e.gl_sub_acct_5,
                  e.gl_sub_acct_6,
                  e.gl_sub_acct_7,
                  b.tran_class,
                  DECODE (p_tran_post,
                          'T', TO_CHAR (b.tran_date, 'MM YYYY'),
                          'P', TO_CHAR (b.posting_date, 'MM YYYY'))
                     month_grp,
                  DECODE (p_tran_post,
                          'T', EXTRACT (MONTH FROM b.tran_date),
                          'P', EXTRACT (MONTH FROM b.posting_date))
                     month_grp_seq,
                  DECODE (p_tran_post,
                          'T', EXTRACT (YEAR FROM b.tran_date),
                          'P', EXTRACT (YEAR FROM b.posting_date))
                     year_grp_seq,
                  e.gl_acct_name,
                  SUM (NVL (a.debit_amt, 0)) tot_debit_amt,
                  SUM (NVL (a.credit_amt, 0)) tot_credit_amt,
                  e.gl_acct_id,
                  b.tran_date,
                  b.posting_date,
                  b.tran_flag,
                  b.particulars particulars,
                  LPAD (TO_CHAR (b.tran_class_no), 10, '0') jv_ref_no,
                  b.jv_pref,
                  b.jv_seq_no
             FROM giac_acct_entries a, giac_acctrans b, giac_chart_of_accts e
            WHERE     1 = 1
                  AND a.gacc_tran_id = b.tran_id
                  AND a.gl_acct_id = e.gl_acct_id
                  AND a.gacc_gfun_fund_cd = p_fund_cd
                  AND a.gacc_gibr_branch_cd =
                         DECODE (p_all_branches,
                                 'N', NVL (p_branch_cd, a.gacc_gibr_branch_cd),
                                 a.gacc_gibr_branch_cd)
                  AND a.gacc_gibr_branch_cd IN (SELECT *
                                                    FROM TABLE (
                                                            SPLIT_COMMA_SEPARATED_STRING (
                                                                                 p_branches_withAcc)))
                  AND a.gl_acct_category = NVL (p_category, a.gl_acct_category)
                  AND a.gl_control_acct = NVL (p_control, a.gl_control_acct)
                  AND a.gl_sub_acct_1 = NVL (p_sub1, a.gl_sub_acct_1)
                  AND a.gl_sub_acct_2 = NVL (p_sub2, a.gl_sub_acct_2)
                  AND a.gl_sub_acct_3 = NVL (p_sub3, a.gl_sub_acct_3)
                  AND a.gl_sub_acct_4 = NVL (p_sub4, a.gl_sub_acct_4)
                  AND a.gl_sub_acct_5 = NVL (p_sub5, a.gl_sub_acct_5)
                  AND a.gl_sub_acct_6 = NVL (p_sub6, a.gl_sub_acct_6)
                  AND a.gl_sub_acct_7 = NVL (p_sub7, a.gl_sub_acct_7)
                  AND b.tran_class = NVL (p_tran_class, b.tran_class)
                  AND b.tran_flag <> 'D'
                  AND b.tran_flag NOT IN (p_tran_flag)
                  AND DECODE (p_tran_post,
                              'T', TRUNC (b.tran_date),
                              'P', TRUNC (b.posting_date),
                              TRUNC (b.tran_date)) BETWEEN TO_DATE (
                                                              p_from_date,
                                                              'mm-dd-yyyy')
                                                       AND TO_DATE (
                                                              p_to_date,
                                                              'mm-dd-yyyy')
         GROUP BY a.gacc_tran_id,
                  e.gl_acct_category,
                  e.gl_control_acct,
                  e.gl_sub_acct_1,
                  e.gl_sub_acct_2,
                  e.gl_sub_acct_3,
                  e.gl_sub_acct_4,
                  e.gl_sub_acct_5,
                  e.gl_sub_acct_6,
                  e.gl_sub_acct_7,
                  e.gl_acct_id,
                  b.tran_date,
                  b.posting_date,
                  b.tran_class,
                  e.gl_acct_name,
                  b.tran_date,
                  b.posting_date,
                  b.tran_flag,
                  b.particulars,
                  b.jv_pref,
                  b.jv_seq_no,
                  b.tran_class_no
            ORDER BY e.gl_acct_category,
                  e.gl_control_acct,
                  e.gl_sub_acct_1,
                  e.gl_sub_acct_2,
                  e.gl_sub_acct_3,
                  e.gl_sub_acct_4,
                  e.gl_sub_acct_5,
                  e.gl_sub_acct_6,
                  e.gl_sub_acct_7,
                  DECODE (p_tran_post,
                          'T', TO_CHAR (b.tran_date, 'MM YYYY'),
                          'P', TO_CHAR (b.posting_date, 'MM YYYY')),
                  b.tran_class, 
                  a.gacc_tran_id  ;

      PROCEDURE set_gl_acct_code (
         p_gl_acct_category   IN     giac_acct_entries.gl_acct_category%TYPE,
         p_gl_control_acct    IN     giac_acct_entries.gl_control_acct%TYPE,
         p_gl_sub_acct_1      IN     giac_acct_entries.gl_sub_acct_1%TYPE,
         p_gl_sub_acct_2      IN     giac_acct_entries.gl_sub_acct_2%TYPE,
         p_gl_sub_acct_3      IN     giac_acct_entries.gl_sub_acct_3%TYPE,
         p_gl_sub_acct_4      IN     giac_acct_entries.gl_sub_acct_4%TYPE,
         p_gl_sub_acct_5      IN     giac_acct_entries.gl_sub_acct_5%TYPE,
         p_gl_sub_acct_6      IN     giac_acct_entries.gl_sub_acct_6%TYPE,
         p_gl_sub_acct_7      IN     giac_acct_entries.gl_sub_acct_7%TYPE,
         p_gl_acct_code          OUT VARCHAR2)
      IS
         v_gl_acct_code   VARCHAR2 (100);
      BEGIN

         v_gl_acct_code :=
               TO_CHAR (p_gl_acct_category)
            || '-'
            || LTRIM (TO_CHAR (p_gl_control_acct, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_1, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_2, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_3, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_4, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_5, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_6, '00'))
            || '-'
            || LTRIM (TO_CHAR (p_gl_sub_acct_7, '00'));



         p_gl_acct_code := v_gl_acct_code;
      END set_gl_acct_code;

      PROCEDURE set_otherDtlInfo (
         p_tran_id               giac_acctrans.tran_id%TYPE,
         p_particulars           giac_acctrans.particulars%TYPE,
         p_tran_class            giac_acctrans.tran_class%TYPE,
         p_ref_no            OUT VARCHAR2,
         p_name              OUT VARCHAR2,
         p_fin_particulars   OUT VARCHAR2)
      IS
         v_ref_no        VARCHAR2 (100);
         v_col_ref_no    VARCHAR2 (100);
         v_name          VARCHAR2 (1000);
         v_particulars   VARCHAR2 (2000);
      BEGIN
         v_particulars := p_particulars;

         IF p_tran_class = 'COL'
         THEN
            FOR tb IN (SELECT or_pref_suf,
                              or_no,
                              particulars,
                              payor
                         FROM giac_order_of_payts a
                        WHERE a.gacc_tran_id = p_tran_id)
            LOOP
               v_col_ref_no :=
                  tb.or_pref_suf || ' ' || LPAD (TO_CHAR (tb.or_no), 10, '0');
               v_particulars := tb.particulars;
               v_name := tb.payor;
               EXIT;
            END LOOP;
         ELSIF p_tran_class = 'DV'
         THEN
            FOR tb IN (SELECT payee, particulars
                         FROM giac_disb_vouchers a
                        WHERE a.gacc_tran_id = p_tran_id)
            LOOP
               v_particulars := tb.particulars;
               v_name := tb.payee;
               EXIT;
            END LOOP;
         END IF;


         p_fin_particulars := v_particulars;
         p_name := v_name;

         v_ref_no :=
            GIACR062_PKG.get_cf_ref_no (p_tran_id,
                                        v_col_ref_no,
                                        p_tran_class);
         p_ref_no := v_ref_no;
      END set_otherDtlInfo;
    

   BEGIN
      v_withTargetRec := 'N';
      v_recPrinted    := 0 ; 
      v_company_name := giisp.v ('COMPANY_NAME');
      v_company_address := giisp.v ('COMPANY_ADDRESS');
      v_company_tin := 'VAT REG TIN ' || giisp.v ('COMPANY_TIN'); -- bonok :: 3.22.2017 :: SR 5964
      v_gen_version := giisp.v ('GEN_VERSION'); -- bonok :: 3.22.2017 :: SR 5964
      v_branch_accessible  := giacr060_pkg.get_Branch_WithAccess (p_module_id, p_user_id ); 
      
      IF v_branch_accessible IS NOT NULL THEN
         v_withTargetRec := 'Y' ; 
      END IF;
      

      IF v_withTargetRec = 'Y' THEN 
          OPEN getAllRecords ( v_branch_accessible );

          LOOP
             FETCH getAllRecords
                BULK COLLECT INTO v_tempTable
                LIMIT v_limit;

             EXIT WHEN v_tempTable.COUNT = 0;

             FOR ctr IN 1 .. v_tempTable.COUNT
             LOOP
                v_list.tran_id :=
                   LPAD (TO_CHAR (v_tempTable (ctr).gacc_tran_id), 12, '0');


                v_list.month_grp :=
                   TO_CHAR (TO_DATE (v_tempTable (ctr).month_grp, 'MMYYYY'),
                            'fmMONTH YYYY');
                v_list.tran_class := v_tempTable (ctr).tran_class;
                v_list.month_grp_seq := v_tempTable (ctr).month_grp_seq;
                v_list.year_grp_seq := v_tempTable (ctr).year_grp_seq;
                v_list.tot_debit_amt := v_tempTable (ctr).tot_debit_amt;
                v_list.tot_credit_amt := v_tempTable (ctr).tot_credit_amt;
                v_list.tot_balance :=
                     NVL (v_tempTable (ctr).tot_debit_amt, 0)
                   - NVL (v_tempTable (ctr).tot_credit_amt, 0);
                   
                IF v_list.branch_name IS NULL AND p_branch_cd IS NOT NULL THEN
                    BEGIN
                       SELECT branch_name
                         INTO v_list.branch_name
                         FROM giac_branches
                        WHERE  branch_cd = p_branch_cd;
                       EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                             v_list.branch_name := NULL;    
                    END;
                END IF;     

                set_gl_acct_code (v_tempTable (ctr).gl_acct_category,
                                  v_tempTable (ctr).gl_control_acct,
                                  v_tempTable (ctr).gl_sub_acct_1,
                                  v_tempTable (ctr).gl_sub_acct_2,
                                  v_tempTable (ctr).gl_sub_acct_3,
                                  v_tempTable (ctr).gl_sub_acct_4,
                                  v_tempTable (ctr).gl_sub_acct_5,
                                  v_tempTable (ctr).gl_sub_acct_6,
                                  v_tempTable (ctr).gl_sub_acct_7,
                                  v_list.gl_acct_code);


                set_otherDtlInfo (v_tempTable (ctr).gacc_tran_id,
                                  v_tempTable (ctr).particulars,
                                  v_tempTable (ctr).tran_class,
                                  v_list.ref_no,
                                  v_list.name,
                                  v_list.particulars);
                v_list.gl_acct_name := v_tempTable (ctr).gl_acct_name;

                -- jhing additional fields  - GENQA 5280, 5200
                v_list.tran_date := v_tempTable (ctr).tran_date;
                v_list.posting_date := v_tempTable (ctr).posting_date;
                --            v_list.name := i.name;
                v_list.tran_flag := v_tempTable (ctr).tran_flag;
                v_list.jv_ref_no :=
                      v_tempTable (ctr).jv_pref
                   || ' '
                   || LPAD (TO_CHAR (v_tempTable (ctr).jv_seq_no), 12, '0');


                v_list.company_name := v_company_name;
                v_list.company_address := v_company_address;
                v_list.company_tin := v_company_tin; -- bonok :: 3.22.2017 :: SR 5964
                v_list.gen_version := v_gen_version; -- bonok :: 3.22.2017 :: SR 5964
                v_list.from_date :=
                      TRIM (
                         TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month'))
                   || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
                v_list.TO_DATE :=
                      TRIM (TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month'))
                   || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');

                v_list.month_grp :=
                   TO_CHAR (TO_DATE (v_tempTable (ctr).month_grp, 'MMYYYY'),
                            'fmMONTH YYYY');
                            
                IF  p_tran_post = 'P' THEN            
                    v_list.p_date_rec :=     v_tempTable (ctr).posting_date;
                ELSIF p_tran_post = 'T' THEN     
                    v_list.p_date_rec :=     v_tempTable (ctr).tran_date;    
                END IF;        

                v_recPrinted := v_recPrinted + 1 ; 
                PIPE ROW (v_list);
             END LOOP;
          END LOOP;
          
          
          v_withCnt := 'N';
          
          IF v_tempTable.count > 0 THEN
            v_withCnt := 'Y' ;
          END IF;
          
          IF v_withCnt = 'Y' THEN 
             v_tempTable.delete;      
          END IF;         
    END IF;
    
    IF v_withTargetRec = 'N' OR  v_recPrinted = 0 THEN
         v_list.company_name := v_company_name;
         v_list.company_address := v_company_address;
         v_list.from_date :=
                  TRIM (
                     TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month'))
               || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
         v_list.TO_DATE :=
                  TRIM (TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month'))
               || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');  
                       
         IF  p_branch_cd IS NOT NULL THEN
            BEGIN
                SELECT branch_name
                     INTO v_list.branch_name
                     FROM giac_branches
                    WHERE  branch_cd = p_branch_cd;
                   EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                         v_list.branch_name := NULL;    
            END;
         END IF; 
         PIPE ROW (v_list);                          
    END IF; 

   END generate_giacr062;
   
   FUNCTION get_cf_ref_no (p_tran_id       VARCHAR2,
                           p_col_ref_no    VARCHAR2,
                           p_tran_class    VARCHAR2)
      RETURN VARCHAR2
   IS
      v_ref_no      VARCHAR2 (1000);
      v_ctr         NUMBER (3) := 0;
      v_exist_rev   NUMBER := 0;
   BEGIN
      BEGIN
         SELECT 1
           INTO v_exist_rev
           FROM GIAC_REVERSALS
          WHERE REVERSING_TRAN_ID = p_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exist_rev := 0;
      END;

      IF v_exist_rev = 1
      THEN
         BEGIN
            SELECT    'REV-'
                   || tran_year
                   || '-'
                   || tran_month
                   || '-'
                   || tran_seq_no
              INTO v_ref_no
              FROM giac_acctrans
             WHERE tran_id = p_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_ref_no := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               v_ref_no := v_ref_no;
         END;
      ELSE
         IF p_tran_class = 'COL'
         THEN
            RETURN (p_col_ref_no );
         ELSIF p_tran_class = 'DV'
         THEN
            BEGIN
               SELECT    a.dv_pref
                      || '-'
                      || LPAD (TO_CHAR (a.dv_no), 10, '0')
                      || '/'
                      || b.check_pref_suf
                      || '-'
                      || LPAD (TO_CHAR (b.check_no), 10, '0')
                 INTO v_ref_no
                 FROM giac_disb_vouchers a, giac_chk_disbursement b
                WHERE     b.check_stat = 2
                      AND a.gacc_tran_id = b.gacc_tran_id
                      AND a.gacc_tran_id = p_tran_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  SELECT    document_cd
                         || '-'
                         || branch_cd
                         || '-'
                         || LPAD (TO_CHAR (doc_year), 4, '0')
                         || '-'
                         || LPAD (TO_CHAR (doc_mm), 2, '0')
                         || '-'
                         || LPAD (TO_CHAR (doc_seq_no), 6, '0')
                    INTO v_ref_no
                    FROM giac_payt_requests a, giac_payt_requests_dtl b
                   WHERE a.ref_id = b.gprq_ref_id AND tran_id = p_tran_id;
               WHEN TOO_MANY_ROWS
               THEN
                  FOR X
                     IN (SELECT    a.dv_pref
                                || '-'
                                || LPAD (TO_CHAR (a.dv_no), 10, '0')
                                || '/'
                                || b.check_pref_suf
                                || '-'
                                || LPAD (TO_CHAR (b.check_no), 10, '0')
                                   REFNO
                           FROM giac_disb_vouchers a, giac_chk_disbursement b
                          WHERE     b.check_stat = 2
                                AND a.gacc_tran_id = b.gacc_tran_id
                                AND a.gacc_tran_id = p_tran_id)
                  LOOP
                     v_ctr := v_ctr + 1;

                     IF v_ctr > 1
                     THEN
                        v_ref_no := v_ref_no || CHR (10) || X.REFNO;
                     END IF;
                  END LOOP;
            END;
         ELSIF p_tran_class = 'JV'
         THEN
            BEGIN
               SELECT    DECODE (ref_jv_no, NULL, NULL, ref_jv_no || ' / ')
                      || tran_year
                      || '-'
                      || tran_month
                      || '-'
                      || tran_seq_no
                      || ' / '
                      || jv_pref_suff
                      || '-'
                      || LPAD (TO_CHAR (jv_no), 6, '0')
                 INTO v_ref_no
                 FROM giac_acctrans
                WHERE tran_id = p_tran_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ref_no := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_ref_no := v_ref_no;
            END;
         ELSE
            v_ref_no := CPI.get_ref_no (p_tran_id);
         END IF;
      END IF;

      RETURN (v_ref_no  );
   END get_cf_ref_no;   
   
END;
/

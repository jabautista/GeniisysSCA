CREATE OR REPLACE PACKAGE BODY CPI.GIACR061_PKG
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
      p_sub_7        VARCHAR2,
      p_sl_cd        VARCHAR2,
      p_sl_type_cd   VARCHAR2
   )
      RETURN main_tab PIPELINED
   IS
      v_list main_type;
   BEGIN
      FOR i IN (SELECT DISTINCT TO_CHAR (a.gl_acct_category)
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
                         e.gl_acct_name, NVL (SUM (a.debit_amt), 0) db_amt,
                         NVL (SUM (a.credit_amt), 0) cd_amt
                    FROM giac_chart_of_accts e, giac_acctrans b, giac_acct_entries a
                   WHERE a.gacc_tran_id = b.tran_id
                     AND check_user_per_iss_cd_acctg2 (NULL, a.gacc_gibr_branch_cd, p_module_id, p_user_id) = 1
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
                     AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
                     AND NVL (a.sl_type_cd, '-') =
                                                  NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
                     AND b.tran_flag <> 'D'
                     AND b.tran_flag NOT IN (p_tran_flag)
                     AND DECODE (p_tran_post,
                                 'T', TRUNC(b.tran_date),
                                 'P', TRUNC(b.posting_date),
                                 TRUNC(b.tran_date)) 
                            BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy')
                               AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                GROUP BY a.gl_acct_category,
                         a.gl_control_acct,
                         a.gl_sub_acct_1,
                         a.gl_sub_acct_2,
                         a.gl_sub_acct_3,
                         a.gl_sub_acct_4,
                         a.gl_sub_acct_5,
                         a.gl_sub_acct_6,
                         a.gl_sub_acct_7,
                         e.gl_acct_name)
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
   
   FUNCTION get_month_grps (
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
      p_gl_acct_code   VARCHAR2,
      p_sl_cd        VARCHAR2,
      p_sl_type_cd   VARCHAR2
   )
      RETURN month_grp_tab PIPELINED
   IS
      v_list month_grp_type;
   BEGIN
      FOR i IN (SELECT DISTINCT DECODE (p_tran_post,
                             'T', TRIM(TO_CHAR (b.tran_date, 'MONTH')) || ' ' || TRIM(TO_CHAR (b.tran_date, 'YYYY')),
                             'P', TRIM(TO_CHAR (b.posting_date, 'MONTH')) || ' ' || TRIM(TO_CHAR (b.posting_date, 'YYYY'))
                            ) month_grp,
                            DECODE (p_tran_post,
                             'T', TO_CHAR(b.tran_date, 'MM YYYY'),
                             'P', TO_CHAR(b.posting_date, 'MM YYYY')
                            ) month_grp2 
                    FROM giac_chart_of_accts e, giac_acctrans b, giac_acct_entries a
                   WHERE a.gacc_tran_id = b.tran_id
                     AND check_user_per_iss_cd_acctg2 (NULL, a.gacc_gibr_branch_cd, p_module_id, p_user_id) = 1
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
                     AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
                     AND NVL (a.sl_type_cd, '-') =
                                                  NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
                     AND b.tran_flag <> 'D'
                     AND b.tran_flag NOT IN (p_tran_flag)
                     AND DECODE (p_tran_post,
                                 'T', TRUNC(b.tran_date),
                                 'P', TRUNC(b.posting_date),
                                 TRUNC(b.tran_date)) 
                            BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy')
                               AND TO_DATE(p_to_date, 'mm-dd-yyyy'))
      LOOP
         v_list.month_grp := i.month_grp;
         v_list.month_grp2 := i.month_grp2;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_month_grps;
   
   FUNCTION get_tran_class (
      p_user_id        VARCHAR2,
      p_module_id      VARCHAR2,
      p_fund_cd        VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_category       VARCHAR2,
      p_control        VARCHAR2,
      p_tran_class     VARCHAR2,
      p_tran_flag      VARCHAR2,
      p_tran_post      VARCHAR2,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_gl_acct_code   VARCHAR2,
      p_sl_cd          VARCHAR2,
      p_sl_type_cd     VARCHAR2,
      p_month_grp      VARCHAR2
   )
      RETURN tran_class_tab PIPELINED
   IS
      v_list tran_class_type;
   BEGIN
      FOR i IN (SELECT b.tran_class, NVL (SUM (a.debit_amt), 0) db_amt,
                       NVL (SUM (a.credit_amt), 0) cd_amt
                    FROM giac_chart_of_accts e, giac_acctrans b, giac_acct_entries a
                   WHERE a.gacc_tran_id = b.tran_id
                     AND check_user_per_iss_cd_acctg2 (NULL, a.gacc_gibr_branch_cd, p_module_id, p_user_id) = 1
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
                     AND DECODE (p_tran_post,
                             'T', TRIM(TO_CHAR (b.tran_date, 'MONTH')) || ' ' || TRIM(TO_CHAR (b.tran_date, 'YYYY')),
                             'P', TRIM(TO_CHAR (b.posting_date, 'MONTH')) || ' ' || TRIM(TO_CHAR (b.posting_date, 'YYYY'))
                            ) = p_month_grp    
                     AND b.tran_class = NVL (p_tran_class, b.tran_class)
                     AND a.gl_acct_id = e.gl_acct_id
                     AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
                     AND NVL (a.sl_type_cd, '-') =
                                                  NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
                     AND b.tran_flag <> 'D'
                     AND b.tran_flag NOT IN (p_tran_flag)
                     AND DECODE (p_tran_post,
                                 'T', TRUNC(b.tran_date),
                                 'P', TRUNC(b.posting_date),
                                 TRUNC(b.tran_date)) 
                            BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy')
                               AND TO_DATE(p_to_date, 'mm-dd-yyyy')
               GROUP BY 
--               a.gacc_gibr_branch_cd, a.gl_acct_category,
--                         a.gl_control_acct,
--                         a.gl_sub_acct_1,
--                         a.gl_sub_acct_2,
--                         a.gl_sub_acct_3,
--                         a.gl_sub_acct_4,
--                         a.gl_sub_acct_5,
--                         a.gl_sub_acct_6,
--                         a.gl_sub_acct_7,
--                         e.gl_acct_name,
                         b.tran_class--,
--                         a.sl_source_cd,
--                         a.sl_type_cd,
--                         a.sl_cd,
--                         DECODE (p_tran_post,
--                             'T', TRIM(TO_CHAR (b.tran_date, 'MONTH')) || ' ' || TRIM(TO_CHAR (b.tran_date, 'YYYY')),
--                             'P', TRIM(TO_CHAR (b.posting_date, 'MONTH')) || ' ' || TRIM(TO_CHAR (b.posting_date, 'YYYY'))
--                            )
                            )
      LOOP
         v_list.tran_class := i.tran_class;
         v_list.cd_amt := i.cd_amt;
         v_list.db_amt := i.db_amt;
         v_list.balance := NVL(i.db_amt, 0) - NVL(i.cd_amt, 0);
         
         PIPE ROW(v_list);
      END LOOP;
   END get_tran_class;
   
   FUNCTION get_details(
      p_user_id        VARCHAR2,
      p_module_id      VARCHAR2,
      p_fund_cd        VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_category       VARCHAR2,
      p_control        VARCHAR2,
      p_tran_class     VARCHAR2,
      p_tran_flag      VARCHAR2,
      p_tran_post      VARCHAR2,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_gl_acct_code   VARCHAR2,
      p_sl_cd          VARCHAR2,
      p_sl_type_cd     VARCHAR2,
      p_month_grp      VARCHAR2,
      p_tran_class2    VARCHAR2
   )
      RETURN details_tab PIPELINED
   IS
      v_list details_type;
   BEGIN
      FOR i IN (SELECT a.sl_source_cd, a.sl_type_cd,
                       a.sl_cd, NVL (SUM (a.debit_amt), 0) db_amt,
                       NVL (SUM (a.credit_amt), 0) cd_amt
                    FROM giac_chart_of_accts e, giac_acctrans b, giac_acct_entries a
                   WHERE a.gacc_tran_id = b.tran_id
                     AND check_user_per_iss_cd_acctg2 (NULL, a.gacc_gibr_branch_cd, p_module_id, p_user_id) = 1
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
                     AND DECODE (p_tran_post,
                             'T', TRIM(TO_CHAR (b.tran_date, 'MONTH')) || ' ' || TRIM(TO_CHAR (b.tran_date, 'YYYY')),
                             'P', TRIM(TO_CHAR (b.posting_date, 'MONTH')) || ' ' || TRIM(TO_CHAR (b.posting_date, 'YYYY'))
                            ) = p_month_grp    
                     AND b.tran_class = p_tran_class2
                     AND a.gl_acct_id = e.gl_acct_id
                     AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
                     AND NVL (a.sl_type_cd, '-') =
                                                  NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
                     AND b.tran_flag <> 'D'
                     AND b.tran_flag NOT IN (p_tran_flag)
                     AND DECODE (p_tran_post,
                                 'T', TRUNC(b.tran_date),
                                 'P', TRUNC(b.posting_date),
                                 TRUNC(b.tran_date)) 
                            BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy')
                               AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                GROUP BY 
--                a.gacc_gibr_branch_cd, a.gl_acct_category,
--                         a.gl_control_acct,
--                         a.gl_sub_acct_1,
--                         a.gl_sub_acct_2,
--                         a.gl_sub_acct_3,
--                         a.gl_sub_acct_4,
--                         a.gl_sub_acct_5,
--                         a.gl_sub_acct_6,
--                         a.gl_sub_acct_7,
--                         e.gl_acct_name,
--                         b.tran_class,
                         a.sl_source_cd,
                         a.sl_type_cd,
                         a.sl_cd,
                         DECODE (p_tran_post,
                             'T', TRIM(TO_CHAR (b.tran_date, 'MONTH')) || ' ' || TRIM(TO_CHAR (b.tran_date, 'YYYY')),
                             'P', TRIM(TO_CHAR (b.posting_date, 'MONTH')) || ' ' || TRIM(TO_CHAR (b.posting_date, 'YYYY'))
                            ))
      LOOP
        v_list.sl_source_cd := i.sl_source_cd;
        v_list.sl_type_cd := i.sl_type_cd;
        v_list.sl_cd := i.sl_cd;
        v_list.db_amt := i.db_amt;
        v_list.cd_amt := i.cd_amt;
        v_list.balance := NVL(i.db_amt, 0) - NVL(i.cd_amt, 0);
        
        BEGIN
           IF i.sl_cd IS NOT NULL
           THEN
              IF i.sl_source_cd = '2'
              THEN
                 FOR c1 IN (SELECT DECODE (payee_first_name,
                                           NULL, payee_last_name
                                            || ' '
                                            || payee_first_name
                                            || ' '
                                            || payee_middle_name
                                            || '  *',
                                              payee_last_name
                                           || ', '
                                           || payee_first_name
                                           || ' '
                                           || payee_middle_name
                                           || '  *'
                                          ) sl_nm
                              FROM giis_payees
                             WHERE payee_class_cd = i.sl_type_cd
                               AND payee_no = i.sl_cd)
                 LOOP
                    v_list.sl_nm := c1.sl_nm;
                    EXIT;
                 END LOOP;
              ELSE
                 FOR c2 IN (SELECT sl_name sl_nm
                              FROM giac_sl_lists
                             WHERE sl_type_cd = i.sl_type_cd AND sl_cd = i.sl_cd)
                 LOOP
                    v_list.sl_nm := c2.sl_nm;
                    EXIT;
                 END LOOP;
              END IF;
           ELSE
              v_list.sl_nm := '_______No SL Code_______';
           END IF;
        END;
        
        PIPE ROW(v_list);
      END LOOP;
   END get_details;
   
   -- added by jhing  - GENQA 5280, 5200  
   FUNCTION generate_mainrec (  p_user_id      VARCHAR2,
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
      p_sub_7        VARCHAR2,
      p_sl_cd        VARCHAR2,
      p_sl_type_cd   VARCHAR2,
      p_all_branches VARCHAR2)
      RETURN mainrec_grp_tble
      PIPELINED
   IS
      v_list               mainrec_grp_type;
      v_1                  NUMBER;
      v_2                  NUMBER;
      v_3                  NUMBER;

      v_rec1               mainrec_grp_type;
      v_tempTbl            mainrec_grp_tble;
      v_withCnt            VARCHAR2 (1);
      v_branch_accessible  VARCHAR2(2000); 

      TYPE tempRec IS RECORD
      ( gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
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
         sl_source_cd       giac_acct_entries.sl_source_cd%TYPE, 
         sl_type_cd         giac_acct_entries.sl_type_cd%TYPE, 
         sl_cd              giac_acct_entries.sl_cd%TYPE  
      );

      TYPE tempRecTbl IS TABLE OF tempRec;

      v_tempTable          tempRecTbl;

      v_limit              NUMBER := 500;
      v_temp_indx          NUMBER := 0;

      v_company_name       giis_parameters.param_value_v%TYPE;
      v_company_address    giis_parameters.param_value_v%TYPE;
      v_withTargetRec      VARCHAR2(1); 
      v_recPrinted         NUMBER ;



      CURSOR getAllRecords ( p_branches_withAcc VARCHAR2 ) 
      IS
           SELECT 
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
                  e.gl_acct_id, a.sl_source_cd, a.sl_type_cd, a.sl_cd  
            FROM giac_acct_entries a, giac_acctrans b, giac_chart_of_accts e
            WHERE     1 = 1
                  AND a.gacc_tran_id = b.tran_id
                  AND a.gl_acct_id = e.gl_acct_id
                  AND a.gacc_gibr_branch_cd =
                         DECODE (p_ALL_BRANCHES,
                                 'N', NVL (p_branch_cd, a.gacc_gibr_branch_cd),
                                 a.gacc_gibr_branch_cd)
                  AND a.gacc_gibr_branch_cd IN (SELECT *
                                                    FROM TABLE (
                                                            SPLIT_COMMA_SEPARATED_STRING (
                                                                                 p_branches_withAcc)))               
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
                  AND b.tran_flag <> 'D'
                  AND b.tran_flag NOT IN (p_tran_flag)
                  AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
                  AND NVL (a.sl_type_cd, '-') =
                                                  NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
                  AND DECODE (p_tran_post,
                              'T', TRUNC (b.tran_date),
                              'P', TRUNC (b.posting_date),
                              TRUNC (b.tran_date)) BETWEEN TO_DATE (
                                                              p_from_date,
                                                              'mm-dd-yyyy')
                                                       AND TO_DATE (
                                                              p_to_date,
                                                              'mm-dd-yyyy')
         GROUP BY e.gl_acct_category,
                  e.gl_control_acct,
                  e.gl_sub_acct_1,
                  e.gl_sub_acct_2,
                  e.gl_sub_acct_3,
                  e.gl_sub_acct_4,
                  e.gl_sub_acct_5,
                  e.gl_sub_acct_6,
                  e.gl_sub_acct_7,
                  e.gl_acct_id,                  
                  b.tran_class,
                  e.gl_acct_name  ,
                   DECODE (p_tran_post,
                          'T', TO_CHAR (b.tran_date, 'MM YYYY'),
                          'P', TO_CHAR (b.posting_date, 'MM YYYY'))
                     ,
                  DECODE (p_tran_post,
                          'T', EXTRACT (MONTH FROM b.tran_date),
                          'P', EXTRACT (MONTH FROM b.posting_date))
                     ,
                  DECODE (p_tran_post,
                          'T', EXTRACT (YEAR FROM b.tran_date),
                          'P', EXTRACT (YEAR FROM b.posting_date))
                     ,  e.gl_acct_id, a.sl_source_cd, a.sl_type_cd, a.sl_cd  ;              
                  

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

   BEGIN

      v_withTargetRec := 'N';
      v_recPrinted := 0 ; 
      v_company_name := giisp.v ('COMPANY_NAME');
      v_company_address := giisp.v ('COMPANY_ADDRESS');
      v_branch_accessible  := giacr060_pkg.get_Branch_WithAccess (p_module_id, p_user_id ); 
      
      IF v_branch_accessible IS NOT NULL THEN
        v_withTargetRec := 'Y';
      END IF; 
      
      IF v_withTargetRec = 'Y' THEN 

          OPEN getAllRecords ( v_branch_accessible ) ;

          LOOP
             FETCH getAllRecords
                BULK COLLECT INTO v_tempTable
                LIMIT v_limit;

             EXIT WHEN v_tempTable.COUNT = 0;

             FOR ctr IN 1 .. v_tempTable.COUNT
             LOOP

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


                v_list.gl_acct_name := v_tempTable (ctr).gl_acct_name;

                v_list.company_name := v_company_name;
                v_list.company_address := v_company_address;
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
                            
               v_list.sl_source_cd := v_tempTable (ctr).sl_source_cd;
               v_list.sl_type_cd := v_tempTable (ctr).sl_type_cd;     
               v_list.sl_cd := v_tempTable (ctr).sl_cd;          
               BEGIN
                       IF v_tempTable (ctr).sl_cd IS NOT NULL
                       THEN
                          IF v_tempTable (ctr).sl_source_cd = '2'
                          THEN
                             FOR c1 IN (SELECT DECODE (payee_first_name,
                                                       NULL, payee_last_name
                                                        || ' '
                                                        || payee_first_name
                                                        || ' '
                                                        || payee_middle_name
                                                        || '  *',
                                                          payee_last_name
                                                       || ', '
                                                       || payee_first_name
                                                       || ' '
                                                       || payee_middle_name
                                                       || '  *'
                                                      ) sl_nm
                                          FROM giis_payees
                                         WHERE payee_class_cd = v_tempTable (ctr).sl_type_cd
                                           AND payee_no = v_tempTable (ctr).sl_cd)
                             LOOP
                                v_list.sl_nm := c1.sl_nm;
                                EXIT;
                             END LOOP;
                          ELSE
                             FOR c2 IN (SELECT sl_name sl_nm
                                          FROM giac_sl_lists
                                         WHERE sl_type_cd = v_tempTable (ctr).sl_type_cd AND sl_cd = v_tempTable (ctr).sl_cd)
                             LOOP
                                v_list.sl_nm := c2.sl_nm;
                                EXIT;
                             END LOOP;
                          END IF;
                       ELSE
                          v_list.sl_nm := '_______No SL Code_______';
                       END IF;
                    END;                       
                            
                v_recPrinted := v_recPrinted + 1 ; 
                PIPE ROW (v_list);
             END LOOP;
          END LOOP;
      END IF;       
      
      
      IF v_withTargetRec = 'N' OR v_recPrinted = 0
      THEN
          v_list.company_name := v_company_name;
          v_list.company_address := v_company_address;
          v_list.from_date :=
                TRIM (TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month'))
             || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
          v_list.TO_DATE :=
                TRIM (TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month'))
             || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');


          IF p_branch_cd IS NOT NULL
          THEN
             BEGIN
                SELECT branch_name
                  INTO v_list.branch_name
                  FROM giac_branches
                 WHERE branch_cd = p_branch_cd;
             EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                   v_list.branch_name := NULL;
             END;
          END IF; 
        PIPE ROW (v_list); 
      END IF; 

   END generate_mainrec;
          
   
END;
/



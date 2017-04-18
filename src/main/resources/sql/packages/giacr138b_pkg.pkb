CREATE OR REPLACE PACKAGE BODY CPI.GIACR138B_PKG
AS

    FUNCTION get_main_rep (
      p_user_id      VARCHAR2,
      p_module_id    VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_tran_class   VARCHAR2,
      p_jv_tran_cd   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_tran_post    VARCHAR2,
      p_coldv        VARCHAR2
   )
      RETURN main_tab PIPELINED
   IS
      v_list main_type;
   BEGIN
      FOR i IN (SELECT   b.gfun_fund_cd,
                            LTRIM (TO_CHAR (c.gl_acct_category))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_control_acct, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_1, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_2, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_3, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_4, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_5, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_6, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_7, '09')) gl_acct_no,
                         c.gl_acct_name , SUM (a.debit_amt) db_amt,
                         SUM (a.credit_amt) cd_amt
                    FROM giac_acct_entries a,
                         giac_acctrans b,
                         giac_chart_of_accts c,
                         giac_branches gb
                   WHERE a.gacc_tran_id = b.tran_id
                     AND a.gl_acct_category = c.gl_acct_category
                     AND a.gl_control_acct = c.gl_control_acct
                     AND a.gl_sub_acct_1 = c.gl_sub_acct_1
                     AND a.gl_sub_acct_2 = c.gl_sub_acct_2
                     AND a.gl_sub_acct_3 = c.gl_sub_acct_3
                     AND a.gl_sub_acct_4 = c.gl_sub_acct_4
                     AND a.gl_sub_acct_5 = c.gl_sub_acct_5
                     AND a.gl_sub_acct_6 = c.gl_sub_acct_6
                     AND a.gl_sub_acct_7 = c.gl_sub_acct_7
                     AND b.gfun_fund_cd = gb.gfun_fund_cd
                     AND b.gibr_branch_cd = gb.branch_cd
                     AND b.gibr_branch_cd = NVL (p_branch_cd, b.gibr_branch_cd)
                     AND b.tran_class = NVL (p_tran_class, b.tran_class)
                     AND (   (    TRUNC (posting_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                              AND p_tran_post = 'P'
                             )
                          OR (    TRUNC (tran_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                              AND p_tran_post = 'T'
                             )
                         )
                     AND (   (tran_flag = 'P' AND p_tran_post = 'P')
                          OR (tran_flag IN ('C', 'P') AND p_tran_post = 'T')
                         )
                     AND b.tran_class NOT IN
                            (DECODE (p_coldv, 'Y', 'XX', 'COL'),
                             DECODE (p_coldv, 'Y', 'XX', 'DV')
                            )
                     AND b.tran_flag != 'D'
                     AND NVL (b.jv_tran_type, 'XXX') =
                                              NVL (p_jv_tran_cd, NVL (b.jv_tran_type, 'XXX'))
                     AND NVL (p_branch_cd, b.gibr_branch_cd) IN (
                            SELECT iss_cd
                              FROM giis_issource
                             WHERE iss_cd =
                                      DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                                           iss_cd,
                                                                           p_module_id,
                                                                           p_user_id
                                                                          ),
                                              1, iss_cd,
                                              NULL
                                             ))
                GROUP BY b.gfun_fund_cd,
                            LTRIM (TO_CHAR (c.gl_acct_category))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_control_acct, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_1, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_2, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_3, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_4, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_5, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_6, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (c.gl_sub_acct_7, '09')),
                         c.gl_acct_name
                ORDER BY 1)
      
      LOOP
         v_list.gfun_fund_cd := i.gfun_fund_cd;
         v_list.gl_acct_no := i.gl_acct_no;
         v_list.gl_acct_name := i.gl_acct_name;
         --v_list.db_amt := i.db_amt; --commented out by MarkS 8.5.2016 SR5599
         --v_list.cd_amt := i.cd_amt;
         --added by MarkS 8.5.2016 SR5599
         IF i.db_amt > i.cd_amt THEN
            v_list.db_amt := i.db_amt - i.cd_amt;   
         ELSE
            v_list.db_amt :=   0; 
         END IF;
          
         IF i.cd_amt > i.db_amt  THEN
            v_list.cd_amt := i.cd_amt - i.db_amt; 
         ELSE
            v_list.cd_amt := 0;
         END IF;
         --END 8.5.2016 SR5599
         
         IF v_list.company_name IS NULL THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
            v_list.company_tin := 'VAT REG TIN ' || giisp.v ('COMPANY_TIN'); -- bonok :: 3.22.2017 :: SR 5964
            v_list.gen_version := giisp.v ('GEN_VERSION'); -- bonok :: 3.22.2017 :: SR 5964
         END IF;
         
         IF v_list.from_date IS NULL THEN
            v_list.from_date := TRIM(TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.to_date := TRIM(TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_main_rep;      

END;
/



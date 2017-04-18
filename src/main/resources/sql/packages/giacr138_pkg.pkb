CREATE OR REPLACE PACKAGE BODY CPI.GIACR138_PKG
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
      v_memo VARCHAR2(100);
   BEGIN
      FOR i IN (SELECT b.gfun_fund_cd, b.gibr_branch_cd, gb.branch_name, b.tran_date,
                       b.posting_date, b.tran_class, LPAD(b.jv_no,6,0) jv_no, b.ref_jv_no, 
                       b.tran_id, b.tran_year, LPAD(b.tran_month,2,0) tran_month,
                       LPAD(b.tran_seq_no,6,0) tran_seq_no, b.jv_tran_type, b.particulars, SUM(a.debit_amt) db_amt,
                       SUM(a.credit_amt) cd_amt, 
                       b.jv_pref, b.jv_seq_no -- added by gab 09.14.2015
                  FROM giac_acct_entries a, 
                       giac_acctrans b,
                       giac_chart_of_accts c,
                       giac_branches gb
                 WHERE a.gacc_tran_id = b.tran_id
                   AND a.gl_acct_id = c.gl_acct_id 
                   AND b.gfun_fund_cd=gb.gfun_fund_cd
                   AND b.gibr_branch_cd=gb.branch_cd
                   AND b.gibr_branch_cd=NVL(p_branch_cd, b.gibr_branch_cd)
                   AND b.tran_class=nvl(p_tran_class,b.tran_class)
                   AND ((TRUNC(posting_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy') AND p_tran_post='P')
                         OR (TRUNC(tran_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy') and p_tran_post='T'))
                   AND ((tran_flag='P' AND p_tran_post ='P')
                         OR (tran_flag IN ('C','P') AND p_tran_post ='T'))
                   AND b.tran_class NOT IN (DECODE(p_coldv, 'Y', 'XX', 'COL'), DECODE(p_coldv, 'Y', 'XX', 'DV'))
                   AND b.tran_flag != 'D'
                   AND NVL(b.jv_tran_type, 'XXX') = NVL(p_jv_tran_cd,nvl(b.jv_tran_type,'XXX')) 
                   AND NVL(p_branch_cd, b.gibr_branch_cd) IN (SELECT iss_cd
                                                              FROM giis_issource
                                                             WHERE iss_cd = DECODE (check_user_per_iss_cd_acctg2 (NULL, iss_cd, p_module_id, p_user_id), 1, iss_cd, NULL))
                GROUP BY b.gfun_fund_cd,
                         b.gibr_branch_cd,
                         gb.branch_name,
                         b.tran_date, 
                         b.posting_date,
                         b.tran_class,
                         b.jv_no, 
                         b.ref_jv_no, 
                         b.tran_id,
                         b.tran_year,
                         b.tran_month,
                         b.tran_seq_no, 
                         b.jv_tran_type,
                         b.particulars,
                         b.sap_inc_tag,
                         b.jv_pref,
                         b.jv_seq_no)
      LOOP
         v_list.gfun_fund_cd := i.gfun_fund_cd;
         v_list.gibr_branch_cd := i.gibr_branch_cd;
         v_list.branch_name := i.branch_name;
         v_list.tran_date := i.tran_date;
--         v_list.tran_year := i.tran_year;
--         v_list.tran_month := i.tran_month;
--         v_list.tran_seq_no := i.tran_seq_no;
         v_list.particulars := i.particulars;
         v_list.posting_date := i.posting_date;
--         v_list.tran_class := i.tran_class;
         v_list.tran_id := TO_CHAR(i.tran_id, '000000000009');
         v_list.jv_tran_type := i.jv_tran_type;
--         v_list.sap_inc_tag := i.sap_inc_tag;
--         v_list.ref_jv_no := i.ref_jv_no;
--         v_list.jv_no := i.jv_no;
--         v_list.gl_acct_no := i.gl_acct_no;
--         v_list.acct_name := i.acct_name;
         v_list.db_amt := i.db_amt;
         v_list.cd_amt := i.cd_amt;
         v_list.jv_ref_no := i.jv_pref || '-' ||LPAD (TO_CHAR(i.jv_seq_no), 12, '0'); -- added by gab 09.14.2015
         v_list.ref_no := get_ref_no(i.tran_id); --added to correct display of ref_no below by robert SR 5201 02.05.2016
--         BEGIN
--            IF i.tran_class = 'JV' AND i.ref_jv_no IS NOT NULL  THEN
--                v_list.ref_no := i.ref_jv_no||chr(10)||i.tran_year||'-'||i.tran_month||'-'||i.tran_seq_no||'/'||i.tran_class||'-'||i.jv_no
--                                 ||chr(10)||LPAD(i.tran_id,12,0);
--              ELSIF i.tran_class = 'JV' AND i.ref_jv_no IS NULL  THEN
--                v_list.ref_no := i.tran_year||'-'||i.tran_month||'-'||i.tran_seq_no||'/'||i.tran_class||'-'||i.jv_no
--                                 ||chr(10)||LPAD(i.tran_id,12,0);
--              ELSIF i.tran_class IN ('CM','DM') THEN
--                FOR x IN (SELECT a.memo_year||'-'||a.memo_seq_no memo
--                            FROM giac_cm_dm a
--                           WHERE a.gacc_tran_id = i.tran_id)
--                LOOP
--                    v_memo := x.memo;
--                 EXIT;            
--                END LOOP; 
--                v_list.ref_no := i.tran_class||'-'||v_memo
--                                  ||chr(10)||LPAD(i.tran_id,12,0);
--              ELSE
--                v_list.ref_no := i.tran_class||'-'||i.tran_year||'-'||i.tran_month||'-'||i.tran_seq_no
--                                  ||chr(10)||LPAD(i.tran_id,12,0);
--              END IF;
--         END;
         
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
   
   FUNCTION get_accts (
      p_tran_id     VARCHAR2
   )
      RETURN acct_tab PIPELINED
   IS
      v_list acct_type;
   BEGIN
      FOR i IN (SELECT      LTRIM (TO_CHAR (c.gl_acct_category))
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
                         c.gl_acct_name acct_name, SUM (a.debit_amt) db_amt,
                         SUM (a.credit_amt) cd_amt
                    FROM giac_acct_entries a, giac_acctrans b, giac_chart_of_accts c
                   WHERE a.gacc_tran_id = b.tran_id
                     AND a.gl_acct_id = c.gl_acct_id
                     AND b.tran_id = p_tran_id
                GROUP BY    LTRIM (TO_CHAR (c.gl_acct_category))
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
                         c.gl_acct_name)
      LOOP
         v_list.gl_acct_no := i.gl_acct_no;
         v_list.acct_name := i.acct_name;
         v_list.db_amt := i.db_amt;
         v_list.cd_amt := i.cd_amt;
         PIPE ROW(v_list);
      END LOOP;
   END get_accts;
   
   FUNCTION get_summ (
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
      RETURN summ_tab PIPELINED
   IS
      v_list summ_type;
   BEGIN
      FOR i IN (SELECT   b.gfun_fund_cd, b.gibr_branch_cd,
                         gb.branch_name,
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
                         c.gl_acct_name acct_name, SUM (a.debit_amt) db_amt,
                         SUM (a.credit_amt) cd_amt
                    FROM giac_acct_entries a,
                         giac_acctrans b,
                         giac_chart_of_accts c,
                         giac_branches gb
                   WHERE a.gacc_tran_id = b.tran_id
                     AND a.gl_acct_id = c.gl_acct_id
                     AND b.gfun_fund_cd = gb.gfun_fund_cd
                     AND b.gibr_branch_cd = gb.branch_cd
                     AND b.gibr_branch_cd = NVL (p_branch_cd, b.gibr_branch_cd)
                     AND b.tran_class = NVL (p_tran_class, b.tran_class)
                     AND ((TRUNC (posting_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
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
                             WHERE iss_cd = DECODE (check_user_per_iss_cd_acctg2 (NULL, iss_cd, p_module_id, p_user_id ), 1, iss_cd, NULL))
                GROUP BY b.gfun_fund_cd,
                         b.gibr_branch_cd,
                         gb.branch_name,
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
         v_list.gibr_branch_cd := i.gibr_branch_cd;
         v_list.branch_name := i.branch_name;
         v_list.gl_acct_no := i.gl_acct_no;
         v_list.acct_name := i.acct_name;
         v_list.db_amt := i.db_amt;
         v_list.cd_amt := i.cd_amt;
         
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
   END get_summ;   
   
   
END ;
/

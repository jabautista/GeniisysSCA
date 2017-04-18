CREATE OR REPLACE PACKAGE BODY CPI.GIACR281_PKG
AS

   FUNCTION get_giacr281 (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_module_id      VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN giacr281_main_tab PIPELINED
   IS
      v_list giacr281_main_type;
   BEGIN   
      FOR i IN (  SELECT DISTINCT   d.bank_name || '-' || c.bank_acct_no bank_acct,
                         c.bank_acct_no, c.bank_acct_cd,
                         a.branch_cd, e.branch_name, SUM(a.amount) amount
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_branches e
                   WHERE a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = e.branch_cd
                     AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                     AND c.bank_acct_cd = NVL (p_bank_acct_cd, c.bank_acct_cd)
                     AND a.branch_cd IN (SELECT iss_cd
                                           FROM giis_issource
                                          WHERE iss_cd = DECODE (check_user_per_iss_cd_acctg2 (NULL, iss_cd, p_module_id, p_user_id), 1, iss_cd, NULL))
                     AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                           OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')))
                GROUP BY d.bank_name || '-' || c.bank_acct_no,
                         c.bank_acct_no, c.bank_acct_cd,
                         a.branch_cd, e.branch_name           
                ORDER BY 1, 2)
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.branch_name := i.branch_name;
         v_list.bank_acct := i.bank_acct;
         v_list.bank_acct_no := i.bank_acct_no;
         v_list.bank_acct_cd := i.bank_acct_cd;
         v_list.amount := i.amount;
         
         IF v_list.company_name IS NULL THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;
         
         IF v_list.from_date IS NULL THEN
            v_list.from_date := TRIM(TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.to_date := TRIM(TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         PIPE ROW(v_list);
      END LOOP;
      
      IF v_list.company_name IS NULL THEN
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         v_list.from_date := TRIM(TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
         v_list.to_date := TRIM(TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');
         PIPE ROW(v_list);
      END IF;
      
   END;
   
   FUNCTION get_giacr281_dates (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_bank_acct_no   VARCHAR2,
      p_bank_acct_cd   VARCHAR2
   )
      RETURN giacr281_date_tab PIPELINED
   IS
      v_list giacr281_date_type;
   BEGIN   
      FOR i IN (  SELECT DISTINCT TRUNC(b.tran_date) tran_date, TRUNC(b.posting_date) posting_date
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c
                   WHERE a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND a.branch_cd = p_branch_cd
                     AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                           OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')))
                     AND c.bank_acct_no = p_bank_acct_no
                     AND c.bank_acct_cd = p_bank_acct_cd
                ORDER BY 1, 2)
      LOOP
         v_list.tran_date := i.tran_date;
         v_list.posting_date := i.posting_date;
         PIPE ROW(v_list);
      END LOOP;
   END get_giacr281_dates;
   
   FUNCTION get_giacr281_dcb_nos (
      p_branch_cd       VARCHAR2,
      p_bank_acct_cd    VARCHAR2,
      p_bank_acct_no    VARCHAR2,
      p_tran_date       DATE,
      p_posting_date    DATE
   )
      RETURN giacr281_dcb_no_tab PIPELINED
   IS
      v_list giacr281_dcb_no_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.dcb_year || '-' || a.dcb_no dcb_no
                  FROM giac_dcb_bank_dep a,
                       giac_acctrans b,
                       giac_bank_accounts c,
                       giac_banks d,
                       giac_branches e
                 WHERE a.gacc_tran_id = b.tran_id
                   AND a.fund_cd = b.gfun_fund_cd
                   AND a.branch_cd = b.gibr_branch_cd
                   AND b.tran_flag <> 'D'
                   AND a.bank_cd = c.bank_cd
                   AND a.bank_acct_cd = c.bank_acct_cd
                   AND c.bank_cd = d.bank_cd
                   AND a.branch_cd = e.branch_cd
                   AND a.branch_cd = p_branch_cd
                   AND c.bank_acct_cd = p_bank_acct_cd
                   AND c.bank_acct_no = p_bank_acct_no
                   AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                   AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
              ORDER BY 1)
      LOOP
         v_list.dcb_no := i.dcb_no;
         PIPE ROW(v_list);
      END LOOP;
   END get_giacr281_dcb_nos;
   
   FUNCTION get_giacr281_amounts (
      p_branch_cd      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_bank_acct_no   VARCHAR2,
      p_tran_date      DATE,
      p_posting_date   DATE,
      p_dcb_no         VARCHAR2
   )
      RETURN giacr281_amounts_tab PIPELINED
   IS
      v_list giacr281_amounts_type;
   BEGIN
      FOR i IN( SELECT DISTINCT a.pay_mode, SUM(a.amount) amount,
                  d.bank_cd,d.bank_name,e.branch_name --edited by MarkS SR-5533 7.11.2016
                  FROM giac_dcb_bank_dep a,
                       giac_acctrans b,
                       giac_bank_accounts c,
                       giac_banks d,
                       giac_branches e
                 WHERE a.gacc_tran_id = b.tran_id
                   AND a.fund_cd = b.gfun_fund_cd
                   AND a.branch_cd = b.gibr_branch_cd
                   AND b.tran_flag <> 'D'
                   AND a.bank_cd = c.bank_cd
                   AND a.bank_acct_cd = c.bank_acct_cd
                   AND c.bank_cd = d.bank_cd
                   AND a.branch_cd = e.branch_cd
                   AND a.branch_cd = p_branch_cd
                   AND c.bank_acct_cd = p_bank_acct_cd
                   AND c.bank_acct_no = p_bank_acct_no
                   AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                   AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                   AND  a.dcb_year || '-' || a.dcb_no = p_dcb_no
              GROUP BY a.pay_mode,d.bank_cd,d.bank_name,e.branch_name --edited by MarkS SR-5533 7.11.2016          
              ORDER BY 1, 2)
      LOOP
         v_list.pay_mode := i.pay_mode;
         v_list.amount := i.amount;
         v_list.bank_cd := i.bank_cd;         --edited by MarkS SR-5533 7.11.2016
         v_list.bank_name := i.bank_name;     --edited by MarkS SR-5533 7.11.2016
         v_list.branch_name := i.branch_name; --edited by MarkS SR-5533 7.11.2016  
         PIPE ROW(v_list);
      END LOOP;
   END get_giacr281_amounts;
   
   
   FUNCTION get_giacr281a_columns (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2
   )
      RETURN giacr281a_column_tab PIPELINED
   IS
      v_list giacr281a_column_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.pay_mode
                  FROM giac_dcb_bank_dep a,
                       giac_acctrans b,
                       giac_bank_accounts c,
                       giac_banks d,
                       giac_branches e
                 WHERE a.gacc_tran_id = b.tran_id
                   AND a.fund_cd = b.gfun_fund_cd
                   AND a.branch_cd = b.gibr_branch_cd
                   AND b.tran_flag <> 'D'
                   AND a.bank_cd = c.bank_cd
                   AND a.bank_acct_cd = c.bank_acct_cd
                   AND c.bank_cd = d.bank_cd
                   AND a.branch_cd = e.branch_cd
                   AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                   AND c.bank_acct_cd = NVL (p_bank_acct_cd, c.bank_acct_cd)
                   AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                         OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')))
              ORDER BY 1)
      LOOP
         v_list.pay_mode := i.pay_mode;
         PIPE ROW(v_list);
      END LOOP; 
   END get_giacr281a_columns;
   
   FUNCTION get_giacr281a_amounts (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no   VARCHAR2,
      p_tran_date      DATE,
      p_posting_date   DATE,
      p_dcb_no         VARCHAR2
   )
      RETURN giacr281a_amount_tab PIPELINED
   IS
      v_list giacr281a_amount_type;
   BEGIN   
      FOR i IN (SELECT ROWNUM, pay_mode
                  FROM TABLE(GIACR281_PKG.get_giacr281a_columns(p_from_date, p_to_date, p_tran_post, p_bank_acct_cd, p_branch_cd))
              ORDER BY 1)
      LOOP
      
         BEGIN
            SELECT SUM(NVL(a.amount, 0))
              INTO v_list.amount
              FROM giac_dcb_bank_dep a,
                   giac_acctrans b,
                   giac_bank_accounts c,
                   giac_banks d,
                   giac_branches e
             WHERE a.gacc_tran_id = b.tran_id
               AND a.fund_cd = b.gfun_fund_cd
               AND a.branch_cd = b.gibr_branch_cd
               AND b.tran_flag <> 'D'
               AND a.bank_cd = c.bank_cd
               AND a.bank_acct_cd = c.bank_acct_cd
               AND c.bank_cd = d.bank_cd
               AND a.branch_cd = e.branch_cd
               AND a.branch_cd = NVL(p_branch_cd, a.branch_cd)
               AND c.bank_acct_cd = NVL(p_bank_acct_cd, c.bank_acct_cd)
               AND a.branch_cd = p_branch_cd2
               AND c.bank_acct_cd = p_bank_acct_cd2
               AND c.bank_acct_no = p_bank_acct_no
               AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
               AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
               AND  a.dcb_year || '-' || a.dcb_no = p_dcb_no
               AND a.pay_mode = i.pay_mode;
               
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_list.amount := 0;      
         END;
         
         IF v_list.amount IS NULL THEN
            v_list.amount := 0; 
         END IF;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_giacr281a_amounts;
   
   FUNCTION get_account_totals (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no   VARCHAR2
   )
      RETURN giacr281a_amount_tab PIPELINED
   IS
      v_list giacr281a_amount_type;
   BEGIN
      FOR i IN (SELECT ROWNUM, pay_mode
                  FROM TABLE(GIACR281_PKG.get_giacr281a_columns(p_from_date, p_to_date, p_tran_post, p_bank_acct_cd, p_branch_cd))
              ORDER BY 1)
      LOOP
      
         BEGIN
            SELECT SUM(NVL(a.amount, 0))
              INTO v_list.amount
              FROM giac_dcb_bank_dep a,
                   giac_acctrans b,
                   giac_bank_accounts c,
                   giac_banks d,
                   giac_branches e
             WHERE a.gacc_tran_id = b.tran_id
               AND a.fund_cd = b.gfun_fund_cd
               AND a.branch_cd = b.gibr_branch_cd
               AND b.tran_flag <> 'D'
               AND a.bank_cd = c.bank_cd
               AND a.bank_acct_cd = c.bank_acct_cd
               AND c.bank_cd = d.bank_cd
               AND a.branch_cd = e.branch_cd
               AND a.branch_cd = NVL(p_branch_cd, a.branch_cd)
               AND c.bank_acct_cd = NVL(p_bank_acct_cd, c.bank_acct_cd)
               AND a.branch_cd = p_branch_cd2
               AND c.bank_acct_cd = p_bank_acct_cd2
               AND c.bank_acct_no = p_bank_acct_no
               AND a.pay_mode = i.pay_mode
               AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                           OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')));
               
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_list.amount := 0;      
         END;
         
         IF v_list.amount IS NULL THEN
            v_list.amount := 0; 
         END IF;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_account_totals;
   
   FUNCTION get_branch_totals (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_branch_cd2      VARCHAR2
   )
      RETURN giacr281a_amount_tab PIPELINED
   IS
      v_list giacr281a_amount_type;
   BEGIN
      FOR i IN (SELECT ROWNUM, pay_mode
                  FROM TABLE(GIACR281_PKG.get_giacr281a_columns(p_from_date, p_to_date, p_tran_post, p_bank_acct_cd, p_branch_cd))
              ORDER BY 1)
      LOOP
      
         BEGIN
            SELECT SUM(NVL(a.amount, 0))
              INTO v_list.amount
              FROM giac_dcb_bank_dep a,
                   giac_acctrans b,
                   giac_bank_accounts c,
                   giac_banks d,
                   giac_branches e
             WHERE a.gacc_tran_id = b.tran_id
               AND a.fund_cd = b.gfun_fund_cd
               AND a.branch_cd = b.gibr_branch_cd
               AND b.tran_flag <> 'D'
               AND a.bank_cd = c.bank_cd
               AND a.bank_acct_cd = c.bank_acct_cd
               AND c.bank_cd = d.bank_cd
               AND a.branch_cd = e.branch_cd
               AND a.branch_cd = NVL(p_branch_cd, a.branch_cd)
               AND c.bank_acct_cd = NVL(p_bank_acct_cd, c.bank_acct_cd)
               AND a.branch_cd = p_branch_cd2
               AND a.pay_mode = i.pay_mode
               AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                           OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')));
               
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_list.amount := 0;      
         END;
         
         IF v_list.amount IS NULL THEN
            v_list.amount := 0; 
         END IF;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_branch_totals;
   
   FUNCTION get_grand_totals (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2
   )
      RETURN giacr281a_amount_tab PIPELINED
   IS
      v_list giacr281a_amount_type;
   BEGIN
      FOR i IN (SELECT ROWNUM, pay_mode
                  FROM TABLE(GIACR281_PKG.get_giacr281a_columns(p_from_date, p_to_date, p_tran_post, p_bank_acct_cd, p_branch_cd))
              ORDER BY 1)
      LOOP
      
         BEGIN
            SELECT SUM(NVL(a.amount, 0))
              INTO v_list.amount
              FROM giac_dcb_bank_dep a,
                   giac_acctrans b,
                   giac_bank_accounts c,
                   giac_banks d,
                   giac_branches e
             WHERE a.gacc_tran_id = b.tran_id
               AND a.fund_cd = b.gfun_fund_cd
               AND a.branch_cd = b.gibr_branch_cd
               AND b.tran_flag <> 'D'
               AND a.bank_cd = c.bank_cd
               AND a.bank_acct_cd = c.bank_acct_cd
               AND c.bank_cd = d.bank_cd
               AND a.branch_cd = e.branch_cd
               AND a.branch_cd = NVL(p_branch_cd, a.branch_cd)
               AND c.bank_acct_cd = NVL(p_bank_acct_cd, c.bank_acct_cd)
               AND a.pay_mode = i.pay_mode
               AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                           OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')));
               
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_list.amount := 0;      
         END;
         
         IF v_list.amount IS NULL THEN
            v_list.amount := 0; 
         END IF;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_grand_totals;      

END;
/



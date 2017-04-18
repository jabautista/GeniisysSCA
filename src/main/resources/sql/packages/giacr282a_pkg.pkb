CREATE OR REPLACE PACKAGE BODY CPI.giacr282a_pkg
AS
   FUNCTION get_main_rep (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_module_id      VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN main_tab PIPELINED
   IS
      v_list   main_type;
   BEGIN
      FOR i IN (SELECT c.bank_acct_cd, c.bank_acct_no,
                       d.bank_name || '-' || c.bank_acct_no bank_acct, a.branch_cd, SUM(a.amount) amount
                  FROM giac_dcb_bank_dep a,
                       giac_acctrans b,
                       giac_bank_accounts c,
                       giac_banks d,
                       giac_bank_cm e
                 WHERE a.gacc_tran_id = e.gacc_tran_id
                   AND a.fund_cd = e.fund_cd
                   AND a.branch_cd = e.branch_cd
                   AND a.dcb_year = e.dcb_year
                   AND a.dcb_no = e.dcb_no
                   AND a.item_no = e.item_no
                   AND a.gacc_tran_id = b.tran_id
                   AND a.fund_cd = b.gfun_fund_cd
                   AND a.branch_cd = b.gibr_branch_cd
                   AND b.tran_flag <> 'D'
                   AND a.bank_cd = c.bank_cd
                   AND a.bank_acct_cd = c.bank_acct_cd
                   AND c.bank_cd = d.bank_cd
                   AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                   AND a.branch_cd IN (
                                SELECT iss_cd
                                  FROM giis_issource
                                 WHERE iss_cd =
                                          DECODE (check_user_per_iss_cd_acctg2 (NULL, b.gibr_branch_cd, p_module_id, p_user_id), 1, iss_cd, NULL))
                         AND c.bank_acct_cd = NVL (p_bank_acct_cd, c.bank_acct_cd)
                         AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                         OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')))
              GROUP BY c.bank_acct_cd, c.bank_acct_no, a.dcb_year || '-' || a.dcb_no,
         a.pay_mode,
         b.tran_date,
         b.posting_date,
         d.bank_name || '-' || c.bank_acct_no,
         c.branch_bank,
         a.branch_cd,
         NULL,
         NULL,
         e.or_pref || '-' || e.or_no,
         e.amount
              UNION
                SELECT c.bank_acct_cd, c.bank_acct_no,
                       d.bank_name || '-' || c.bank_acct_no bank_acct,
                       a.branch_cd, SUM(a.amount) amount
                  FROM giac_dcb_bank_dep a,
                       giac_acctrans b,
                       giac_bank_accounts c,
                       giac_banks d,
                       giac_bank_dep_slips e,
                       giac_bank_dep_slip_dtl f
                 WHERE e.dep_id = f.dep_id
                   AND a.gacc_tran_id = e.gacc_tran_id
                   AND a.fund_cd = e.fund_cd
                   AND a.branch_cd = e.branch_cd
                   AND a.dcb_year = e.dcb_year
                   AND a.dcb_no = e.dcb_no
                   AND a.item_no = e.item_no
                   AND a.gacc_tran_id = b.tran_id
                   AND a.fund_cd = b.gfun_fund_cd
                   AND a.branch_cd = b.gibr_branch_cd
                   AND b.tran_flag <> 'D'
                   AND a.bank_cd = c.bank_cd
                   AND a.bank_acct_cd = c.bank_acct_cd
                   AND c.bank_cd = d.bank_cd
                   AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                   AND a.branch_cd IN (
                                SELECT iss_cd
                                  FROM giis_issource
                                 WHERE iss_cd =
                                          DECODE (check_user_per_iss_cd_acctg2 (NULL, b.gibr_branch_cd, p_module_id, p_user_id), 1, iss_cd, NULL))
                         AND c.bank_acct_cd = NVL (p_bank_acct_cd, c.bank_acct_cd)
                         AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                         OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')))
              GROUP BY c.bank_acct_cd, c.bank_acct_no, a.dcb_year || '-' || a.dcb_no,
         a.pay_mode,
         b.tran_date,
         b.posting_date,
         d.bank_name || '-' || c.bank_acct_no,
         c.branch_bank,
         a.branch_cd,
         e.dep_no,
         e.amount,
         f.or_pref || '-' || f.or_no,
         f.amount
              UNION
                SELECT c.bank_acct_cd, c.bank_acct_no,
                       d.bank_name || '-' || c.bank_acct_no bank_acct,
                       a.branch_cd, SUM(a.amount) amount
                  FROM giac_dcb_bank_dep a,
                       giac_acctrans b,
                       giac_bank_accounts c,
                       giac_banks d,
                       giac_order_of_payts e,
                       giac_collection_dtl f,
                       giac_bank_dep_slips g
                 WHERE a.gacc_tran_id = g.gacc_tran_id
                   AND a.fund_cd = g.fund_cd
                   AND a.branch_cd = g.branch_cd
                   AND a.dcb_year = g.dcb_year
                   AND a.dcb_no = g.dcb_no
                   AND a.item_no = g.item_no
                   AND e.gacc_tran_id = f.gacc_tran_id
                   AND a.pay_mode = 'CA'
                   AND a.pay_mode = f.pay_mode
                   AND a.dcb_no = e.dcb_no
                   AND TRUNC (a.dcb_date) = TRUNC (e.or_date)
                   AND a.gacc_tran_id = b.tran_id
                   AND a.fund_cd = b.gfun_fund_cd
                   AND a.branch_cd = b.gibr_branch_cd
                   AND b.tran_flag <> 'D'
                   AND a.bank_cd = c.bank_cd
                   AND a.bank_acct_cd = c.bank_acct_cd
                   AND c.bank_cd = d.bank_cd
                   AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                   AND a.branch_cd IN (
                                SELECT iss_cd
                                  FROM giis_issource
                                 WHERE iss_cd =
                                          DECODE (check_user_per_iss_cd_acctg2 (NULL, b.gibr_branch_cd, p_module_id, p_user_id), 1, iss_cd, NULL))
                         AND c.bank_acct_cd = NVL (p_bank_acct_cd, c.bank_acct_cd)
                         AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                         OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')))
              GROUP BY c.bank_acct_cd, c.bank_acct_no, a.dcb_year || '-' || a.dcb_no,
         a.pay_mode,
         b.tran_date,
         b.posting_date,
         d.bank_name || '-' || c.bank_acct_no,
         c.branch_bank,
         a.branch_cd,
         g.dep_no,
         g.amount,
         e.or_pref_suf || '-' || e.or_no,
         e.gross_amt)
      LOOP
         v_list.bank_acct := i.bank_acct;
         v_list.bank_acct_no := i.bank_acct_no;
         v_list.bank_acct_cd := i.bank_acct_cd;
         v_list.branch_cd := i.branch_cd;
         v_list.amount := i.amount;
         
         IF v_list.company_name IS NULL THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;
         
         IF v_list.from_date IS NULL THEN
            v_list.from_date := TRIM(TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.to_date := TRIM(TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_list.company_name IS NULL THEN
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         v_list.from_date := TRIM(TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
         v_list.to_date := TRIM(TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');
         PIPE ROW(v_list);
      END IF;
      
   END get_main_rep;
   
   FUNCTION get_dates (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd2  VARCHAR2,
      p_bank_acct_no   VARCHAR2,
      p_branch_cd2    VARCHAR2
   )
      RETURN date_tab PIPELINED
   IS
      v_list date_type;
   BEGIN
      FOR i IN (  SELECT DISTINCT b.tran_date, b.posting_date
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_bank_cm e
                   WHERE a.gacc_tran_id = e.gacc_tran_id
                     AND a.fund_cd = e.fund_cd
                     AND a.branch_cd = e.branch_cd
                     AND a.dcb_year = e.dcb_year
                     AND a.dcb_no = e.dcb_no
                     AND a.item_no = e.item_no
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                                         OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')))
                GROUP BY b.tran_date, b.posting_date
                UNION
                SELECT   DISTINCT b.tran_date, b.posting_date
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_bank_dep_slips e,
                         giac_bank_dep_slip_dtl f
                   WHERE e.dep_id = f.dep_id
                     AND a.gacc_tran_id = e.gacc_tran_id
                     AND a.fund_cd = e.fund_cd
                     AND a.branch_cd = e.branch_cd
                     AND a.dcb_year = e.dcb_year
                     AND a.dcb_no = e.dcb_no
                     AND a.item_no = e.item_no
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                                         OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')))
                GROUP BY b.tran_date, b.posting_date
                UNION
                SELECT   DISTINCT b.tran_date, b.posting_date
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_order_of_payts e,
                         giac_collection_dtl f,
                         giac_bank_dep_slips g
                   WHERE a.gacc_tran_id = g.gacc_tran_id
                     AND a.fund_cd = g.fund_cd
                     AND a.branch_cd = g.branch_cd
                     AND a.dcb_year = g.dcb_year
                     AND a.dcb_no = g.dcb_no
                     AND a.item_no = g.item_no
                     AND e.gacc_tran_id = f.gacc_tran_id
                     AND a.pay_mode = 'CA'
                     AND a.pay_mode = f.pay_mode
                     AND a.dcb_no = e.dcb_no
                     AND TRUNC (a.dcb_date) = TRUNC (e.or_date)
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND ((TRUNC (b.tran_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.tran_date) AND (p_tran_post = 'T'))
                                         OR (TRUNC (b.posting_date) BETWEEN NVL (TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date) AND NVL (TO_DATE(p_to_date, 'mm-dd-yyyy'), b.posting_date) AND (p_tran_post = 'P')))
                GROUP BY b.tran_date, b.posting_date)
      LOOP
         v_list.tran_date := i.tran_date;
         v_list.posting_date := i.posting_date;
         PIPE ROW(v_list);
      END LOOP;      
   END get_dates;
   
   FUNCTION get_dcb_nos (
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no    VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_tran_date       DATE,
      p_posting_date    DATE
   )
      RETURN dcb_no_tab PIPELINED
   IS
      v_list dcb_no_type;
   BEGIN
      FOR i IN (SELECT   DISTINCT a.dcb_year || '-' || a.dcb_no dcb_no, SUM(a.amount) amount
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_bank_cm e
                   WHERE a.gacc_tran_id = e.gacc_tran_id
                     AND a.fund_cd = e.fund_cd
                     AND a.branch_cd = e.branch_cd
                     AND a.dcb_year = e.dcb_year
                     AND a.dcb_no = e.dcb_no
                     AND a.item_no = e.item_no
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                GROUP BY a.dcb_year || '-' || a.dcb_no,
         a.pay_mode,
         b.tran_date,
         b.posting_date,
         d.bank_name || '-' || c.bank_acct_no,
         c.branch_bank,
         a.branch_cd,
         NULL,
         NULL,
         e.or_pref || '-' || e.or_no,
         e.amount
                UNION
                SELECT   DISTINCT a.dcb_year || '-' || a.dcb_no dcb_no, SUM(a.amount) amount
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_bank_dep_slips e,
                         giac_bank_dep_slip_dtl f
                   WHERE e.dep_id = f.dep_id
                     AND a.gacc_tran_id = e.gacc_tran_id
                     AND a.fund_cd = e.fund_cd
                     AND a.branch_cd = e.branch_cd
                     AND a.dcb_year = e.dcb_year
                     AND a.dcb_no = e.dcb_no
                     AND a.item_no = e.item_no
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                GROUP BY a.dcb_year || '-' || a.dcb_no,
         a.pay_mode,
         b.tran_date,
         b.posting_date,
         d.bank_name || '-' || c.bank_acct_no,
         c.branch_bank,
         a.branch_cd,
         e.dep_no,
         e.amount,
         f.or_pref || '-' || f.or_no,
         f.amount
                UNION
                SELECT   DISTINCT a.dcb_year || '-' || a.dcb_no dcb_no, SUM(a.amount) amount
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_order_of_payts e,
                         giac_collection_dtl f,
                         giac_bank_dep_slips g
                   WHERE a.gacc_tran_id = g.gacc_tran_id
                     AND a.fund_cd = g.fund_cd
                     AND a.branch_cd = g.branch_cd
                     AND a.dcb_year = g.dcb_year
                     AND a.dcb_no = g.dcb_no
                     AND a.item_no = g.item_no
                     AND e.gacc_tran_id = f.gacc_tran_id
                     AND a.pay_mode = 'CA'
                     AND a.pay_mode = f.pay_mode
                     AND a.dcb_no = e.dcb_no
                     AND TRUNC (a.dcb_date) = TRUNC (e.or_date)
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                GROUP BY a.dcb_year || '-' || a.dcb_no,
         a.pay_mode,
         b.tran_date,
         b.posting_date,
         d.bank_name || '-' || c.bank_acct_no,
         c.branch_bank,
         a.branch_cd,
         g.dep_no,
         g.amount,
         e.or_pref_suf || '-' || e.or_no,
         e.gross_amt)
   LOOP
      v_list.dcb_no := i.dcb_no;
      v_list.amount := i.amount;
      PIPE ROW(v_list);
   END LOOP;                         
   END get_dcb_nos;
   
   
   FUNCTION get_pay_modes (
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no    VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_tran_date       DATE,
      p_posting_date    DATE,
      p_dcb_no          VARCHAR2
   )
      RETURN pay_mode_tab PIPELINED
   IS
      v_list pay_mode_type;
   BEGIN
      FOR i IN (SELECT   a.pay_mode, SUM(a.amount) amount
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_bank_cm e
                   WHERE a.gacc_tran_id = e.gacc_tran_id
                     AND a.fund_cd = e.fund_cd
                     AND a.branch_cd = e.branch_cd
                     AND a.dcb_year = e.dcb_year
                     AND a.dcb_no = e.dcb_no
                     AND a.item_no = e.item_no
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                     AND a.dcb_year || '-' || a.dcb_no = p_dcb_no
                GROUP BY a.dcb_year || '-' || a.dcb_no,
                         a.pay_mode,
                         b.tran_date,
                         b.posting_date,
                         d.bank_name || '-' || c.bank_acct_no,
                         c.branch_bank,
                         a.branch_cd,
                         NULL,
                         NULL,
                         e.or_pref || '-' || e.or_no,
                         e.amount
                UNION
                SELECT   a.pay_mode, SUM(a.amount) amount
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_bank_dep_slips e,
                         giac_bank_dep_slip_dtl f
                   WHERE e.dep_id = f.dep_id
                     AND a.gacc_tran_id = e.gacc_tran_id
                     AND a.fund_cd = e.fund_cd
                     AND a.branch_cd = e.branch_cd
                     AND a.dcb_year = e.dcb_year
                     AND a.dcb_no = e.dcb_no
                     AND a.item_no = e.item_no
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                     AND a.dcb_year || '-' || a.dcb_no = p_dcb_no
                GROUP BY a.dcb_year || '-' || a.dcb_no,
                         a.pay_mode,
                         b.tran_date,
                         b.posting_date,
                         d.bank_name || '-' || c.bank_acct_no,
                         c.branch_bank,
                         a.branch_cd,
                         e.dep_no,
                         e.amount,
                         f.or_pref || '-' || f.or_no,
                         f.amount
                UNION
                SELECT   a.pay_mode, SUM(a.amount) amount
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_order_of_payts e,
                         giac_collection_dtl f,
                         giac_bank_dep_slips g
                   WHERE a.gacc_tran_id = g.gacc_tran_id
                     AND a.fund_cd = g.fund_cd
                     AND a.branch_cd = g.branch_cd
                     AND a.dcb_year = g.dcb_year
                     AND a.dcb_no = g.dcb_no
                     AND a.item_no = g.item_no
                     AND e.gacc_tran_id = f.gacc_tran_id
                     AND a.pay_mode = 'CA'
                     AND a.pay_mode = f.pay_mode
                     AND a.dcb_no = e.dcb_no
                     AND TRUNC (a.dcb_date) = TRUNC (e.or_date)
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                     AND a.dcb_year || '-' || a.dcb_no = p_dcb_no
                GROUP BY a.dcb_year || '-' || a.dcb_no,
                         a.pay_mode,
                         b.tran_date,
                         b.posting_date,
                         d.bank_name || '-' || c.bank_acct_no,
                         c.branch_bank,
                         a.branch_cd,
                         g.dep_no,
                         g.amount,
                         e.or_pref_suf || '-' || e.or_no,
                         e.gross_amt)
      LOOP
         v_list.pay_mode := i.pay_mode;
         v_list.amount := i.amount;
         PIPE ROW(v_list);
      END LOOP;
   END get_pay_modes;
   
   FUNCTION get_dep_nos (
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no    VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_tran_date       DATE,
      p_posting_date    DATE,
      p_dcb_no          VARCHAR2,
      p_pay_mode        VARCHAR2
   )
      RETURN dep_no_tab PIPELINED
   IS
      v_list dep_no_type;
   BEGIN
      FOR i IN (SELECT   NULL dep_no, NULL amount
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_bank_cm e
                   WHERE a.gacc_tran_id = e.gacc_tran_id
                     AND a.fund_cd = e.fund_cd
                     AND a.branch_cd = e.branch_cd
                     AND a.dcb_year = e.dcb_year
                     AND a.dcb_no = e.dcb_no
                     AND a.item_no = e.item_no
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                     AND a.dcb_year || '-' || a.dcb_no = p_dcb_no
                     AND a.pay_mode = p_pay_mode
                GROUP BY a.dcb_year || '-' || a.dcb_no,
                         a.pay_mode,
                         b.tran_date,
                         b.posting_date,
                         d.bank_name || '-' || c.bank_acct_no,
                         c.branch_bank,
                         a.branch_cd,
                         NULL,
                         NULL,
                         e.or_pref || '-' || e.or_no,
                         e.amount
                UNION
                SELECT   e.dep_no, e.amount
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_bank_dep_slips e,
                         giac_bank_dep_slip_dtl f
                   WHERE e.dep_id = f.dep_id
                     AND a.gacc_tran_id = e.gacc_tran_id
                     AND a.fund_cd = e.fund_cd
                     AND a.branch_cd = e.branch_cd
                     AND a.dcb_year = e.dcb_year
                     AND a.dcb_no = e.dcb_no
                     AND a.item_no = e.item_no
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                     AND a.dcb_year || '-' || a.dcb_no = p_dcb_no
                     AND a.pay_mode = p_pay_mode
                GROUP BY a.dcb_year || '-' || a.dcb_no,
                         a.pay_mode,
                         b.tran_date,
                         b.posting_date,
                         d.bank_name || '-' || c.bank_acct_no,
                         c.branch_bank,
                         a.branch_cd,
                         e.dep_no,
                         e.amount,
                         f.or_pref || '-' || f.or_no,
                         f.amount
                UNION
                SELECT   g.dep_no, g.amount
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_order_of_payts e,
                         giac_collection_dtl f,
                         giac_bank_dep_slips g
                   WHERE a.gacc_tran_id = g.gacc_tran_id
                     AND a.fund_cd = g.fund_cd
                     AND a.branch_cd = g.branch_cd
                     AND a.dcb_year = g.dcb_year
                     AND a.dcb_no = g.dcb_no
                     AND a.item_no = g.item_no
                     AND e.gacc_tran_id = f.gacc_tran_id
                     AND a.pay_mode = 'CA'
                     AND a.pay_mode = f.pay_mode
                     AND a.dcb_no = e.dcb_no
                     AND TRUNC (a.dcb_date) = TRUNC (e.or_date)
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                     AND a.dcb_year || '-' || a.dcb_no = p_dcb_no
                     AND a.pay_mode = p_pay_mode
                GROUP BY a.dcb_year || '-' || a.dcb_no,
                         a.pay_mode,
                         b.tran_date,
                         b.posting_date,
                         d.bank_name || '-' || c.bank_acct_no,
                         c.branch_bank,
                         a.branch_cd,
                         g.dep_no,
                         g.amount,
                         e.or_pref_suf || '-' || e.or_no,
                         e.gross_amt)
      LOOP
         v_list.dep_no := i.dep_no;
         v_list.amount := i.amount;
         PIPE ROW(v_list);
      END LOOP;                         
   END get_dep_nos;
   
   
   FUNCTION get_refs (
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no    VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_tran_date       DATE,
      p_posting_date    DATE,
      p_dcb_no          VARCHAR2,
      p_pay_mode        VARCHAR2   
   )
      RETURN ref_tab PIPELINED
   IS
      v_list ref_type;
   BEGIN
      FOR i IN (SELECT  DISTINCT e.or_pref || '-' || e.or_no ref_no, e.amount,
                        NULL dep_no, NULL dp_amount,a.pay_mode, SUM(a.amount) p_amount, --added by MarkS 7.14.2016 SR5536 to make the cs used the same package for csv printing
                        a.dcb_year || '-' || a.dcb_no dcb_no,SUM(a.amount) dcb_amount,a.dcb_year,
                        d.bank_cd,d.bank_name,f.branch_name --added by MarkS SR-5536 7.15.2016
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_bank_cm e,
                         giac_branches f --added by MarkS SR-5536 7.15.2016
                   WHERE a.gacc_tran_id = e.gacc_tran_id
                     AND a.fund_cd = e.fund_cd
                     AND a.branch_cd = e.branch_cd
                     AND a.dcb_year = e.dcb_year
                     AND a.dcb_no = e.dcb_no
                     AND a.item_no = e.item_no
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND a.branch_cd = f.branch_cd --added by MarkS SR-5536 7.15.2016
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                     AND a.dcb_year || '-' || a.dcb_no = p_dcb_no
                     AND a.pay_mode = p_pay_mode
                GROUP BY a.dcb_year || '-' || a.dcb_no,
                         a.pay_mode,
                         b.tran_date,
                         b.posting_date,
                         d.bank_name || '-' || c.bank_acct_no,
                         c.branch_bank,
                         a.branch_cd,
                         NULL,
                         NULL,
                         e.or_pref || '-' || e.or_no,
                         e.amount,a.dcb_year,
                         d.bank_cd,d.bank_name,f.branch_name --added by MarkS SR-5536 7.15.2016
                UNION
                SELECT   DISTINCT f.or_pref || '-' || f.or_no, f.amount,
                         e.dep_no, e.amount dp_amount,a.pay_mode, SUM(a.amount) p_amount, --added by MarkS 7.14.2016 SR5536 to make the cs used the same package for csv printing
                         a.dcb_year || '-' || a.dcb_no dcb_no,SUM(a.amount) dcb_amount,a.dcb_year,
                         d.bank_cd,d.bank_name,g.branch_name --added by MarkS SR-5536 7.15.2016
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_bank_dep_slips e,
                         giac_bank_dep_slip_dtl f,
                         giac_branches g --added by MarkS SR-5536 7.15.2016
                   WHERE e.dep_id = f.dep_id
                     AND a.gacc_tran_id = e.gacc_tran_id
                     AND a.fund_cd = e.fund_cd
                     AND a.branch_cd = e.branch_cd
                     AND a.dcb_year = e.dcb_year
                     AND a.dcb_no = e.dcb_no
                     AND a.item_no = e.item_no
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND a.branch_cd = g.branch_cd --added by MarkS SR-5536 7.15.2016
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                     AND a.dcb_year || '-' || a.dcb_no = p_dcb_no
                     AND a.pay_mode = p_pay_mode
                GROUP BY a.dcb_year || '-' || a.dcb_no,
                         a.pay_mode,
                         b.tran_date,
                         b.posting_date,
                         d.bank_name || '-' || c.bank_acct_no,
                         c.branch_bank,
                         a.branch_cd,
                         e.dep_no,
                         e.amount,
                         f.or_pref || '-' || f.or_no,
                         f.amount,a.dcb_year,
                         d.bank_cd,d.bank_name,g.branch_name --added by MarkS SR-5536 7.15.2016
                UNION
                SELECT   DISTINCT e.or_pref_suf || '-' || e.or_no, e.gross_amt,
                         g.dep_no, g.amount dp_amount,a.pay_mode, SUM(a.amount) p_amount, --added by MarkS 7.14.2016 SR5536 to make the csv used the same package for csv printing
                         a.dcb_year || '-' || a.dcb_no dcb_no,SUM(a.amount) dcb_amount,a.dcb_year,
                         d.bank_cd,d.bank_name,h.branch_name --added by MarkS SR-5536 7.15.2016
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_order_of_payts e,
                         giac_collection_dtl f,
                         giac_bank_dep_slips g,
                         giac_branches h --added by MarkS SR-5536 7.15.2016
                   WHERE a.gacc_tran_id = g.gacc_tran_id
                     AND a.fund_cd = g.fund_cd
                     AND a.branch_cd = g.branch_cd
                     AND a.branch_cd = h.branch_cd --added by MarkS SR-5536 7.15.2016
                     AND a.dcb_year = g.dcb_year
                     AND a.dcb_no = g.dcb_no
                     AND a.item_no = g.item_no
                     AND e.gacc_tran_id = f.gacc_tran_id
                     AND a.pay_mode = 'CA'
                     AND a.pay_mode = f.pay_mode
                     AND a.dcb_no = e.dcb_no
                     AND TRUNC (a.dcb_date) = TRUNC (e.or_date)
                     AND a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     --07.15.2016
                     AND a.bank_cd = f.dcb_bank_cd
                     AND a.bank_acct_cd = f.dcb_bank_acct_cd
                     --end
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(TRUNC(b.posting_date), SYSDATE))
                     AND a.dcb_year || '-' || a.dcb_no = p_dcb_no
                     AND a.pay_mode = p_pay_mode
                GROUP BY a.dcb_year || '-' || a.dcb_no,
                         a.pay_mode,
                         b.tran_date,
                         b.posting_date,
                         d.bank_name || '-' || c.bank_acct_no,
                         c.branch_bank,
                         a.branch_cd,
                         g.dep_no,
                         g.amount,
                         e.or_pref_suf || '-' || e.or_no,
                         e.gross_amt,a.dcb_year,
                         d.bank_cd,d.bank_name,h.branch_name) --added by MarkS SR-5536 7.15.2016
      LOOP
         v_list.ref_no := i.ref_no;
         v_list.amount := i.amount;
         --added by MarkS SR-5536 7.15.2016
         v_list.dep_no    := i.dep_no;
         v_list.dp_amount := i.dp_amount;
         v_list.dcb_amount := i.dcb_amount;
         v_list.dcb_year := i.dcb_year;
         v_list.bank_cd := i.bank_cd;         
         v_list.bank_name := i.bank_name;     
         v_list.branch_name := i.branch_name;
         v_list.p_amount := i.p_amount; 
         --end sr5536 
         PIPE ROW(v_list);
      END LOOP;                         
   END get_refs;   
      
END;
/

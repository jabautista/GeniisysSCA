CREATE OR REPLACE PACKAGE BODY CPI.GIACR282_PKG 
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
      v_list main_type;
   BEGIN
      FOR i IN (SELECT   DISTINCT d.bank_name || '-' || c.bank_acct_no bank_acct, 
                         c.bank_acct_no, c.bank_acct_cd, a.branch_cd,
                         SUM(a.amount) amount
                    FROM giac_dcb_bank_dep a,
                         giac_acctrans b,
                         giac_bank_accounts c,
                         giac_banks d
                   WHERE a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND c.bank_cd = d.bank_cd
                     AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                     AND c.bank_acct_cd = NVL (p_bank_acct_cd, c.bank_acct_cd)
                     AND a.branch_cd in (select iss_cd from giis_issource where iss_cd = DECODE(check_user_per_iss_cd_acctg2(NULL, iss_cd, p_module_id, p_user_id),1,iss_cd,NULL))
                     AND ((TRUNC(b.tran_date) BETWEEN NVL(TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL(TO_DATE(p_to_date, 'mm-dd-yyyy') ,b.tran_date) AND (p_tran_post = 'T'))
                           OR (TRUNC(b.posting_date) BETWEEN NVL(TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date)  AND NVL(TO_DATE(p_to_date, 'mm-dd-yyyy'),b.posting_date) AND (p_tran_post = 'P')))
                GROUP BY d.bank_name || '-' || c.bank_acct_no, 
                         c.bank_acct_no, c.bank_acct_cd, a.branch_cd)
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
         
         PIPE ROW(v_list);
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
      p_branch_cd2      VARCHAR2,
      p_bank_acct_no   VARCHAR2
   )
      RETURN date_tab PIPELINED
   IS
      v_list date_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.tran_date, b.posting_date
                  FROM giac_dcb_bank_dep a,
                       giac_acctrans b,
                       giac_bank_accounts c
                 WHERE a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND ((TRUNC(b.tran_date) BETWEEN NVL(TO_DATE(p_from_date, 'mm-dd-yyyy'), b.tran_date) AND NVL(TO_DATE(p_to_date, 'mm-dd-yyyy') ,b.tran_date) AND (p_tran_post = 'T'))
                           OR (TRUNC(b.posting_date) BETWEEN NVL(TO_DATE(p_from_date, 'mm-dd-yyyy'), b.posting_date)  AND NVL(TO_DATE(p_to_date, 'mm-dd-yyyy'),b.posting_date) AND (p_tran_post = 'P')))) 
      LOOP
         v_list.tran_date := i.tran_date;
         v_list.posting_date := i.posting_date;
         PIPE ROW(v_list);
      END LOOP;
   END get_dates;
   
   FUNCTION get_dcb_nos (
      p_tran_date       DATE,
      p_posting_date    DATE,
      p_bank_acct_cd2   VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_bank_acct_no    VARCHAR2
   )
      RETURN dcb_no_tab PIPELINED
   IS
      v_list dcb_no_type;
   BEGIN
      FOR i IN (SELECT a.dcb_year || '-' || a.dcb_no dcb_no,
                       SUM(a.amount) amount
                 FROM  giac_dcb_bank_dep a,
                       giac_acctrans b,
                       giac_bank_accounts c
                 WHERE a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND a.branch_cd = p_branch_cd2
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(b.posting_date, SYSDATE))
                GROUP BY a.dcb_year || '-' || a.dcb_no    
                  )
      LOOP
         v_list.dcb_no := i.dcb_no;
         v_list.amount := i.amount;
         PIPE ROW(v_list);
      END LOOP;
   END get_dcb_nos;
   
   FUNCTION get_pay_modes (
      p_tran_date       DATE,
      p_posting_date    DATE,
      p_bank_acct_cd2   VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_bank_acct_no    VARCHAR2,
      p_dcb_no          VARCHAR2
   )
      RETURN pay_mode_tab PIPELINED
   IS
      v_list pay_mode_type;
   BEGIN
      FOR i IN (SELECT a.pay_mode, SUM(a.amount) amount,
                        d.bank_cd,d.bank_name,e.branch_name --edited by MarkS SR-5535 7.12.2016
                 FROM  giac_dcb_bank_dep a,
                       giac_acctrans b,
                       giac_bank_accounts c,
                       giac_banks d, --edited by MarkS SR-5535 7.12.2016
                       giac_branches e --edited by MarkS SR-5535 7.12.2016
                 WHERE a.gacc_tran_id = b.tran_id
                     AND a.fund_cd = b.gfun_fund_cd
                     AND a.branch_cd = b.gibr_branch_cd
                     AND b.tran_flag <> 'D'
                     AND a.bank_cd = c.bank_cd
                     AND c.bank_cd = d.bank_cd --edited by MarkS SR-5535 7.12.2016
                     AND a.bank_acct_cd = c.bank_acct_cd
                     AND a.branch_cd = p_branch_cd2
                     AND a.branch_cd = e.branch_cd --edited by MarkS SR-5535 7.12.2016
                     AND c.bank_acct_cd = p_bank_acct_cd2
                     AND c.bank_acct_no = p_bank_acct_no
                     AND TRUNC(b.tran_date) = TRUNC(p_tran_date)
                     AND NVL(TRUNC(b.posting_date), SYSDATE) = NVL(TRUNC(p_posting_date), NVL(b.posting_date, SYSDATE))
                     AND a.dcb_year || '-' || a.dcb_no = p_dcb_no
                GROUP BY a.pay_mode,d.bank_cd,d.bank_name,e.branch_name)
      LOOP
         v_list.pay_mode := i.pay_mode;
         v_list.amount := i.amount;
         v_list.bank_cd := i.bank_cd;         --edited by MarkS SR-5535 7.12.2016
         v_list.bank_name := i.bank_name;     --edited by MarkS SR-5535 7.12.2016
         v_list.branch_name := i.branch_name; --edited by MarkS SR-5535 7.12.2016
         PIPE ROW(v_list);
      END LOOP;
   END get_pay_modes;
   
END;
/

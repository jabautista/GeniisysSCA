CREATE OR REPLACE PACKAGE BODY CPI.GIACS240_PKG
AS
   FUNCTION get_giacs240_list(
      p_from_date       giac_pd_checks_v.check_date%TYPE,
      p_to_date        giac_pd_checks_v.check_date%TYPE,
      p_fund_cd         giac_pd_checks_v.fund_cd%TYPE,
      p_branch_cd       giac_pd_checks_v.branch_cd%TYPE,
      p_payee_class_cd  giac_pd_checks_v.payee_class_cd%TYPE,
      p_payee_no        giac_pd_checks_v.payee_no%TYPE,
      --added by MarkS SR-5862 12.12.2016 optimization
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER,
      p_check_no        VARCHAR2,
      p_dept            VARCHAR2,
      p_bank_name       VARCHAR2,
      p_bank_acct_no    VARCHAR2
      --SR-5862
   ) RETURN giacs240_tab PIPELINED AS
      TYPE cur_type IS REF CURSOR;
      res               giacs240_type;
      c                 cur_type;
      v_rec             giacs240_type;
      v_sql             VARCHAR2(32767);
   BEGIN
   --added by MarkS SR-5862 12.12.2016 optimization
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT check_no, check_date, TO_CHAR(ouc_id) ||'' - ''|| ouc_name department, bank_name, bank_acct_no, dv_amt, particulars, user_id, last_update
                                      FROM giac_pd_checks_v
                                    WHERE TRUNC(check_date) >= NVL(:p_from_date, check_date) 
                                       AND TRUNC(check_date) <= NVL(:p_to_date, check_date)
                                       AND fund_cd = '''||p_fund_cd||'''
                                       AND branch_cd = '''|| p_branch_cd ||'''
                                       AND payee_class_cd = '''||p_payee_class_cd||'''
                                       AND payee_no = '|| NVL(p_payee_no,-1) ||' '; -- nvl -1 to avoid error missing expression as oracle doesnt want null for numbers in dynamic query
      IF p_check_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER(CHECK_NO) LIKE UPPER('''|| p_check_no ||''') ';
      END IF;
      
      IF p_dept IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER(TO_CHAR(ouc_id) ||'' - ''|| ouc_name) LIKE UPPER('''|| p_dept ||''')';
      END IF;
      
      IF p_bank_name IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER(BANK_NAME) LIKE UPPER('''|| p_bank_name ||''')';
      END IF;
      
      IF p_bank_acct_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER(BANK_ACCT_NO) LIKE UPPER('''|| p_bank_acct_no ||''')';
      END IF;
      
      IF p_order_by IS NOT NULL
        THEN

        IF p_order_by = 'checkNo'
        THEN        
            v_sql := v_sql || ' ORDER BY CHECK_NO ';
        ELSIF p_order_by = 'checkDate'
        THEN
            v_sql := v_sql || ' ORDER BY CHECK_DATE ';
        ELSIF p_order_by = 'department'
        THEN
            v_sql := v_sql || ' ORDER BY TO_CHAR(ouc_id) ||'' - ''|| ouc_name ';
        ELSIF p_order_by = 'bankName'
        THEN
            v_sql := v_sql || ' ORDER BY BANK_NAME ';
        ELSIF p_order_by = 'bankAcctNo'
        THEN
            v_sql := v_sql || ' ORDER BY BANK_ACCT_NO ';
        ELSIF p_order_by = 'dvAmt'
        THEN
            v_sql := v_sql || ' ORDER BY DV_AMT ';            
        END IF;        
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      END IF;
      
      v_sql := v_sql ||                  ') innersql';            
      v_sql := v_sql || '
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;                                    
      OPEN c FOR v_sql using p_from_date,p_to_date ;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.check_no,
                      v_rec.check_date,
                      v_rec.department,
                      v_rec.bank_name,
                      v_rec.bank_acct_no,
                      v_rec.dv_amt,
                      v_rec.particulars,
                      v_rec.user_id,
                      v_rec.last_update;                            
         EXIT WHEN c%NOTFOUND;     
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;                               
      -----------------------------------------------------------
      -----------------------------------------------------------
--    commented out By markS 12.12.2016 SR5862 optimization
--      FOR i IN (SELECT check_no, check_date, TO_CHAR(ouc_id) ||' - '|| ouc_name department, bank_name, bank_acct_no, dv_amt, particulars, user_id, last_update
--                  FROM giac_pd_checks_v
--                 WHERE TRUNC(check_date) >= NVL(p_from_date, check_date) 
--                   AND TRUNC(check_date) <= NVL(p_to_date, check_date)
--                   AND fund_cd = p_fund_cd
--                   AND branch_cd = p_branch_cd
--                   AND payee_class_cd = p_payee_class_cd
--                   AND payee_no = p_payee_no
--                 ORDER BY ouc_id, payee_class_cd, payee_last_name, payee_first_name, payee_middle_name)
--      LOOP
--         res.check_no := i.check_no;
--         res.check_date := i.check_date;
--         res.department := i.department;
--         res.bank_name := i.bank_name;
--         res.bank_acct_no := i.bank_acct_no;
--         res.dv_amt := i.dv_amt;
--         res.particulars := i.particulars;
--         res.user_id := i.user_id;
--         res.last_update := i.last_update;
--         
--         PIPE ROW(res);
--      END LOOP;
   END;
   
   FUNCTION get_payee_lov(
      p_payee_class_cd  giis_payees.payee_class_cd%TYPE,
      --added by MarkS SR-5862 12.12.2016 optimization
      p_find_text       VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER,
      p_search_string   VARCHAR2
   ) RETURN payee_tab PIPELINED AS
      res               payee_type;
      TYPE cur_type IS REF CURSOR;
      c                 cur_type;
      v_rec             payee_type;
      v_sql             VARCHAR2(32767);
   BEGIN
      --added by MarkS SR-5862 12.12.2016 optimization
       v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT a.payee_no, a.payee_class_cd, b.class_desc, a.payee_last_name||'' ''||a.payee_first_name||'' ''||a.payee_middle_name payee_name 
                                      FROM giis_payees a, giis_payee_class b 
                                     WHERE  a.payee_class_cd = b.payee_class_cd ';
      IF p_payee_class_cd IS NOT NULL 
      THEN
        v_sql := v_sql || ' AND a.payee_class_cd = '''||p_payee_class_cd||''' ';
      
      END IF; 
      
      IF p_find_text IS NOT NULL
      THEN
        v_sql := v_sql || ' AND  (PAYEE_NO LIKE NVL('''|| p_find_text ||''', PAYEE_NO)
								 OR UPPER(a.payee_last_name||'' ''||a.payee_first_name||'' ''||a.payee_middle_name) LIKE UPPER('''|| p_find_text ||''')) ';
      ELSE
        v_sql := v_sql || ' AND (PAYEE_NO LIKE NVL('''|| p_search_string ||''', PAYEE_NO)
								   OR UPPER(a.payee_last_name||'' ''||a.payee_first_name||'' ''||a.payee_middle_name) LIKE UPPER(NVL('''|| p_search_string ||''', a.payee_last_name||'' ''||a.payee_first_name||'' ''||a.payee_middle_name)))';                                 
      END IF;
      
      IF p_order_by IS NOT NULL
        THEN

        IF p_order_by = 'payeeNo'
        THEN        
            v_sql := v_sql || ' ORDER BY PAYEE_NO ';
        ELSIF p_order_by = 'payeeName'
        THEN
            v_sql := v_sql || ' ORDER BY a.payee_last_name||'' ''||a.payee_first_name||'' ''||a.payee_middle_name ';          
        END IF;        
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      END IF;
      v_sql := v_sql ||      ') innersql';            
      v_sql := v_sql || '
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;                           
       
      OPEN c FOR v_sql;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.payee_no,
                      v_rec.payee_class_cd,
                      v_rec.class_desc,
                      v_rec.payee_name;                            
         EXIT WHEN c%NOTFOUND;     
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;  
      -----------------------------------------------------
      -----------------------------------------------------
--    commented out By markS 12.12.2016 SR5862 optimization                  
--      FOR i IN (SELECT a.payee_no, a.payee_class_cd, b.class_desc, a.payee_last_name||' '||a.payee_first_name||' '||a.payee_middle_name payee_name 
--                  FROM giis_payees a, giis_payee_class b 
--                 WHERE a.payee_class_cd = NVL(p_payee_class_cd, a.payee_class_cd)
--                   AND a.payee_class_cd = b.payee_class_cd)
--      LOOP
--         res.payee_no := i.payee_no;
--         res.payee_class_cd := i.payee_class_cd;
--         res.class_desc := i.class_desc;
--         res.payee_name := i.payee_name;
--         
--         PIPE ROW(res);
--      END LOOP;
   END;
   
   FUNCTION validate_fund_cd(
      p_fund_cd         giis_funds.fund_cd%TYPE,
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE
   ) RETURN VARCHAR2 AS
      v_fund_desc       giis_funds.fund_desc%TYPE;
      v_exists          NUMBER;
   BEGIN
      SELECT DISTINCT 1
		  INTO v_exists
		  FROM giac_branches
		 WHERE gfun_fund_cd = p_fund_cd
		   AND check_user_per_iss_cd_acctg2(NULL, branch_cd, p_module_id, p_user_id) = 1;
         
	   IF v_exists = 1 THEN
		   SELECT fund_desc
		     INTO v_fund_desc
		     FROM giis_funds
		    WHERE fund_cd = p_fund_cd;
	   END IF;
      
      RETURN v_fund_desc;
   END;
   
   FUNCTION validate_branch_cd(
      p_branch_cd       giac_branches.branch_cd%TYPE,
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE
   ) RETURN VARCHAR2 AS
      v_branch_name     giac_branches.branch_name%TYPE;
   BEGIN
      SELECT branch_name
		  INTO v_branch_name
		  FROM giac_branches
		 WHERE branch_cd = p_branch_cd
         AND check_user_per_iss_cd_acctg2(NULL, branch_cd, p_module_id, p_user_id) = 1;
         
      RETURN v_branch_name;
   END;
   
   PROCEDURE validate_payee_no(
      p_payee_class_cd  IN OUT giis_payees.payee_class_cd%TYPE,
      p_payee_no        IN giis_payees.payee_no%TYPE,
      p_class_desc      OUT giis_payee_class.class_desc%TYPE,
      p_payee_name      OUT VARCHAR2
   ) AS
   BEGIN
      SELECT a.payee_class_cd, b.class_desc, a.payee_last_name||' '||a.payee_first_name||' '||a.payee_middle_name payee_name
        INTO p_payee_class_cd, p_class_desc, p_payee_name 
        FROM giis_payees a, giis_payee_class b 
       WHERE a.payee_class_cd = p_payee_class_cd
         AND a.payee_no = p_payee_no
         AND a.payee_class_cd = b.payee_class_cd;
   EXCEPTION WHEN no_data_found THEN
      p_payee_class_cd := '';
      p_class_desc := '';
      p_payee_name := '';
   END;
END GIACS240_PKG;
/



CREATE OR REPLACE PACKAGE BODY CPI.CSV_24TH_METHOD
AS
   /* Created by: Mikel 02.24.2016
   ** Description: To be able to query extracted records per policy that will be used in csv pinting for 24th method.
   */
   
  -- added by carlo rubenecia 04.05.2016 SR-5490--START
   FUNCTION cf_addressformula 
        RETURN VARCHAR2
    IS
      v_address        varchar2(500);
    BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN UPPER(v_address);
    RETURN NULL; EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN(NULL);
    END cf_addressformula;
    
    FUNCTION cf_company_nameformula 
        RETURN VARCHAR2 
    IS
        v_company        varchar2(100);
    BEGIN
      SELECT param_value_v
        INTO v_company
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN(v_company);
    RETURN NULL; EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN(NULL);
    END cf_company_nameformula;
   
   FUNCTION cf_dateformula(
        p_extract_mm       NUMBER,
        p_extract_year     NUMBER
    )
        RETURN CHAR 
    IS
        v_date        varchar2(30);
    BEGIN
        SELECT DECODE(p_extract_mm,1,'JANUARY'  , 2,'FEBRUARY', 3,'MARCH'    , 4,'APRIL',
                               5,'MAY'      , 6,'JUNE'    , 7,'JULY'     , 8,'AUGUST',
                               9,'SEPTEMBER', 10,'OCTOBER', 11,'NOVEMBER', 12,'DECEMBER')||' '||p_extract_year 
        INTO v_date
        FROM dual;
      RETURN (v_date);
    END cf_dateformula;
    
    FUNCTION cf_branchformula(
        p_iss_cd giac_deferred_gross_prem_pol.iss_cd%TYPE
    )
        RETURN VARCHAR2
    IS
        v_branch varchar2(50);
        
    BEGIN
        SELECT ISS_NAME INTO v_branch FROM GIIS_ISSOURCE WHERE ISS_CD=p_iss_cd;
        
        RETURN(v_branch);
    END cf_branchformula;
    
    FUNCTION cf_lineformula(
        p_line_cd              giac_deferred_gross_prem_pol.line_cd%TYPE
    )
        RETURN VARCHAR2
    IS
        v_line_name varchar2(50);
        
    BEGIN
        SELECT LINE_NAME INTO v_line_name FROM giis_line WHERE LINE_CD=p_line_cd;
        
        RETURN(v_line_name);
    END cf_lineformula;
    
    
    FUNCTION GIACR045 (p_report_type     VARCHAR2,
                      p_extract_year    giac_deferred_extract.year%TYPE,
                      p_extract_mm      giac_deferred_extract.mm%TYPE)
      RETURN detailed_list_tab
      PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_list              detailed_list_type;
      c                   cur_typ;
      v_query             VARCHAR2 (2000);
      p_dtl_table         VARCHAR2 (100);
      p_amount            VARCHAR2 (100);
      p_deferred_amount   VARCHAR2 (100);
      v_procedure_id      NUMBER; -- Added by Jerome 09.21.2016 SR 5658
   BEGIN
      v_list.company_name    := cf_company_nameformula;
      v_list.company_address := cf_addressformula;
      v_list.cf_date         := cf_dateformula(p_extract_mm, p_extract_year);
      CSV_24TH_METHOD.pop_dynamic_obj (p_report_type,
                                       p_dtl_table,
                                       p_amount,
                                       p_deferred_amount);
      p_dtl_table := p_dtl_table;
      
      BEGIN --Added by Jerome 09.21.2016 SR 5658
        FOR a IN (SELECT MAX(last_extract), procedure_id
                    FROM giac_deferred_extract
                GROUP BY procedure_id)
        LOOP
            v_procedure_id := a.procedure_id;
            EXIT;
        END LOOP;
      END;
      
      v_query :=
         'SELECT extract_year, extract_mm, iss_cd, line_cd, policy_no,
                         eff_date, expiry_date, numerator_factor, denominator_factor ';
      v_query :=
            v_query
         || ', '
         || p_amount
         || ', '
         || p_deferred_amount
         || ' FROM '
         || p_dtl_table
         || ' WHERE extract_year = '
         || p_extract_year
         || ' AND extract_mm = '
         || p_extract_mm
         || ' AND procedure_id = ' --Added by Jerome 09.21.2016 SR 5658
         || v_procedure_id
         || 'ORDER BY expiry_date';

      OPEN c FOR v_query;

      LOOP
         FETCH c
            INTO v_list.extract_year,
                 v_list.extract_mm,
                 v_list.iss_cd,
                 v_list.line_cd,
                 v_list.policy_no,
                 v_list.eff_date,
                 v_list.expiry_date,
                 v_list.numerator_factor,
                 v_list.denominator_factor,
                 v_list.amount,
                 v_list.deferred_amount;

         EXIT WHEN c%NOTFOUND;
         v_list.branch := cf_branchformula(v_list.iss_cd);
         v_list.line_name := cf_lineformula(v_list.line_cd); 
         PIPE ROW (v_list);
      END LOOP;

      CLOSE c;
   END;

   
   FUNCTION CSV_GIACR045 (p_report_type     VARCHAR2,
                      p_extract_year    giac_deferred_extract.year%TYPE,
                      p_extract_mm      giac_deferred_extract.mm%TYPE)
      RETURN csv_giacr045_tab
      PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_list              csv_giacr045_type;
      v_amount            giac_deferred_gross_prem_pol.prem_amt%TYPE;
      v_deffered          giac_deferred_gross_prem_pol.def_prem_amt%TYPE;
      c                   cur_typ;
      v_query             VARCHAR2 (2000);
      p_dtl_table         VARCHAR2 (100);
      p_amount            VARCHAR2 (100);
      p_deferred_amount   VARCHAR2 (100);
      v_eff_date          giac_deferred_gross_prem_pol.eff_date%TYPE;
      v_exp_date          giac_deferred_gross_prem_pol.expiry_date%TYPE;
      v_procedure_id      NUMBER; -- Added by Jerome 10.27.2016 SR 5658
   BEGIN
      csv_24th_method.pop_dynamic_obj (p_report_type,
                                       p_dtl_table,
                                       p_amount,
                                       p_deferred_amount);
      p_dtl_table := p_dtl_table;
      
      BEGIN --Added by Jerome 10.27.2016 SR 5658
        FOR a IN (SELECT MAX(last_extract), procedure_id
                    FROM giac_deferred_extract
                GROUP BY procedure_id)
        LOOP
            v_procedure_id := a.procedure_id;
            EXIT;
        END LOOP;
      END;
      
      v_query :=
         'SELECT extract_year, extract_mm, iss_cd, line_cd, policy_no,
                         eff_date, expiry_date, numerator_factor, denominator_factor ';
      v_query :=
            v_query
         || ', '
         || p_amount
         || ', '
         || p_deferred_amount
         || ' FROM '
         || p_dtl_table
         || ' WHERE extract_year = '
         || p_extract_year
         || ' AND extract_mm = '
         || p_extract_mm
         || ' AND procedure_id = ' --Added by Jerome 10.27.2016 SR 5658
         || v_procedure_id
         || 'ORDER BY expiry_date';

      OPEN c FOR v_query;

      LOOP
         FETCH c
            INTO v_list.extract_year,
                 v_list.extract_mm,
                 v_list.iss_cd,
                 v_list.line_cd,
                 v_list.policy_no,
                 v_eff_date,
                 v_exp_date,
                 v_list.numerator_factor,
                 v_list.denominator_factor,
                 v_amount,
                 v_deffered;

         EXIT WHEN c%NOTFOUND;
         v_list.eff_date := TO_CHAR(v_eff_date, 'MM/dd/yyyy');
         v_list.expiry_date  := TO_CHAR(v_exp_date, 'MM/dd/yyyy');
         v_list.amount := TRIM(TO_CHAR(v_amount, '999,999,999,990.00'));
         v_list.deferred_amount := TRIM(TO_CHAR(v_deffered, '999,999,999,990.00'));
         PIPE ROW (v_list);
      END LOOP;

      CLOSE c;
   END;
    
    -- added by carlo rubenecia 04.05.2016 SR 5490--END

   PROCEDURE pop_dynamic_obj (p_report_type       IN     VARCHAR2,
                              p_dtl_table         IN OUT VARCHAR2,
                              p_amount            IN OUT VARCHAR2,
                              p_deferred_amount   IN OUT VARCHAR2)
   IS
   BEGIN
      IF p_report_type = 'DGP'
      THEN
         --table
         p_dtl_table := 'giac_deferred_gross_prem_pol';
         --columns
         p_amount := 'prem_amt';
         p_deferred_amount := 'def_prem_amt';
      ELSIF p_report_type = 'DPC'
      THEN
         --table
         p_dtl_table := 'giac_deferred_ri_prem_cede_pol';
         --columns
         p_amount := 'dist_prem';
         p_deferred_amount := 'def_dist_prem';
      ELSIF p_report_type = 'DCI'
      THEN
         --table
         p_dtl_table := 'giac_deferred_comm_income_pol';
         --columns
         p_amount := 'comm_income';
         p_deferred_amount := 'def_comm_income';
      ELSIF p_report_type = 'DCE'
      THEN
         --table
         p_dtl_table := 'giac_deferred_comm_expense_pol';
         --columns
         p_amount := 'comm_expense';
         p_deferred_amount := 'def_comm_expense';
      END IF;
   END;

--Added by Carlo de guzman 03.10.201 for SR-5344 and SR-5343 -Start   
    FUNCTION cf_tran_class_nameformula(
        p_tran_class     cg_ref_codes.rv_low_value%TYPE
    )
        RETURN CHAR 
    IS
        v_name    VARCHAR2(500);
    BEGIN
      FOR rec IN (SELECT rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIAC_ACCTRANS.TRAN_CLASS'
                     AND rv_low_value = p_tran_class)
        LOOP
            v_name := rec.rv_meaning;
            EXIT;
        END LOOP;
        
        RETURN (v_name);
    END cf_tran_class_nameformula;  
--Added by Carlo de guzman 03.10.201 for SR-5344 and SR-5343 -End

--Added by Carlo de guzman 03.10.2016 SR-5344 -Start       
    FUNCTION csv_giacr044R(
        p_mm            NUMBER,
        p_year          NUMBER,
        p_branch_cd     VARCHAR2
    )
        RETURN giacr044r_record_tab PIPELINED
    IS
        v_rep   giacr044r_record_type;
        v_header       BOOLEAN := TRUE;
    BEGIN
           
        FOR q IN(SELECT b.tran_class, a.gl_acct_id,        
                        TO_CHAR(a.gl_acct_category) ||'-'||
                        TO_CHAR(a.gl_control_acct) ||'-'||
                        TO_CHAR(a.gl_sub_acct_1) ||'-'||
                        TO_CHAR(a.gl_sub_acct_2) ||'-'||
                        TO_CHAR(a.gl_sub_acct_3) ||'-'||
                        TO_CHAR(a.gl_sub_acct_4) ||'-'||
                        TO_CHAR(a.gl_sub_acct_5) ||'-'||
                        TO_CHAR(a.gl_sub_acct_6) ||'-'||
                        TO_CHAR(a.gl_sub_acct_7) gl_acct,
                        a.gl_acct_name, 
                        NVL(SUM(c.debit_amt),0) debit_amt,
                        NVL(SUM(c.credit_amt),0) credit_amt,
                        (NVL(SUM(c.debit_amt),0) - NVL(SUM(c.credit_amt),0)) balance_amt
                   FROM giac_chart_of_accts a, 
                        giac_acctrans b,
                         giac_acct_entries c
                  WHERE a.gl_acct_id = c.gl_acct_id
                    AND c.gacc_tran_id = b.tran_id
                    AND b.tran_class IN ('RGP','RPC','RCI','RCE')
                    AND b.tran_flag IN ('C','P')
                    AND b.tran_month = p_mm
                    AND b.tran_year  =   p_year
                    AND b.gibr_branch_cd = NVL(p_branch_cd, b.gibr_branch_cd)
                 HAVING SUM(c.debit_amt) > 0
                     OR SUM(c.credit_amt) > 0             
               GROUP BY b.tran_date, b.tran_class, a.gl_acct_id,
                        TO_CHAR(a.gl_acct_category) ||'-'||
                        TO_CHAR(a.gl_control_acct) ||'-'||
                        TO_CHAR(a.gl_sub_acct_1) ||'-'||
                        TO_CHAR(a.gl_sub_acct_2) ||'-'||
                        TO_CHAR(a.gl_sub_acct_3) ||'-'||
                        TO_CHAR(a.gl_sub_acct_4) ||'-'||
                        TO_CHAR(a.gl_sub_acct_5) ||'-'||
                        TO_CHAR(a.gl_sub_acct_6) ||'-'||
                        TO_CHAR(a.gl_sub_acct_7),        
                        a.gl_acct_name  
               ORDER BY b.tran_class, a.gl_acct_id)
        LOOP
            v_header := FALSE;
            v_rep.transaction_class     := cf_tran_class_nameformula(q.tran_class);
            v_rep.gl_account_no         := q.gl_acct;
            v_rep.gl_account_name       := q.gl_acct_name;
            v_rep.debit_amount          := trim(to_char(q.debit_amt, '999,999,999,990.00'));
            v_rep.credit_amount         := trim(to_char(q.credit_amt, '999,999,999,990.00'));
            PIPE ROW(v_rep);
        END LOOP;
                           
    END csv_giacr044R;   
--Added by Carlo de guzman 03.10.2016 SR-5344 -End      
  
--Added by Carlo de guzman 03.10.2016 SR-5343 -Start
      FUNCTION csv_giacr044 (
      p_mm          NUMBER,
      p_year        NUMBER,
      p_branch_cd   VARCHAR2
    )
        RETURN giacr044_record_tab PIPELINED
    IS
        v_rep   giacr044_record_type;
        v_header       BOOLEAN := TRUE;
    BEGIN   
        
        FOR q IN(SELECT b.tran_date, b.tran_class, a.gl_acct_id,        
                        TO_CHAR(a.gl_acct_category) ||'-'||
                        TO_CHAR(a.gl_control_acct) ||'-'||
                        TO_CHAR(a.gl_sub_acct_1) ||'-'||
                        TO_CHAR(a.gl_sub_acct_2) ||'-'||
                        TO_CHAR(a.gl_sub_acct_3) ||'-'||
                        TO_CHAR(a.gl_sub_acct_4) ||'-'||
                        TO_CHAR(a.gl_sub_acct_5) ||'-'||
                        TO_CHAR(a.gl_sub_acct_6) ||'-'||
                        TO_CHAR(a.gl_sub_acct_7) gl_acct,
                        a.gl_acct_name,
                        NVL(SUM(c.debit_amt),0) debit_amt,
                        NVL(SUM(c.credit_amt),0) credit_amt,
                        (NVL(SUM(c.debit_amt),0) - NVL(SUM(c.credit_amt),0)) balance_amt
                   FROM giac_chart_of_accts a, 
                        giac_acctrans b,
                        giac_acct_entries c
                  WHERE a.gl_acct_id = c.gl_acct_id
                    AND c.gacc_tran_id = b.tran_id
                    AND b.tran_class IN ('DGP','DPC','DCI','DCE')
                    AND b.tran_flag IN ('C','P')
                    AND b.tran_month = p_mm
                    AND b.tran_year  =   p_year
                    AND b.gibr_branch_cd = NVL(p_branch_cd, b.gibr_branch_cd)
                 HAVING SUM(c.debit_amt) > 0
                        OR SUM(c.credit_amt) > 0             
               GROUP BY b.tran_date, b.tran_class, a.gl_acct_id,
                        TO_CHAR(a.gl_acct_category) ||'-'||
                        TO_CHAR(a.gl_control_acct) ||'-'||
                        TO_CHAR(a.gl_sub_acct_1) ||'-'||
                        TO_CHAR(a.gl_sub_acct_2) ||'-'||
                        TO_CHAR(a.gl_sub_acct_3) ||'-'||
                        TO_CHAR(a.gl_sub_acct_4) ||'-'||
                        TO_CHAR(a.gl_sub_acct_5) ||'-'||
                        TO_CHAR(a.gl_sub_acct_6) ||'-'||
                        TO_CHAR(a.gl_sub_acct_7),        
                        a.gl_acct_name
               ORDER BY b.tran_class, gl_acct)
        LOOP
            v_header := FALSE;
            --v_rep.transaction_class      := q.tran_class;
            v_rep.transaction_class     := cf_tran_class_nameformula(q.tran_class);
            v_rep.gl_account_no         := q.gl_acct;
            v_rep.gl_account_name       := q.gl_acct_name;
            v_rep.debit_amount          := trim(to_char(q.debit_amt, '999,999,999,990.00'));
            v_rep.credit_amount         := trim(to_char(q.credit_amt, '999,999,999,990.00'));
            v_rep.balance_amount        := trim(to_char(q.balance_amt, '999,999,999,990.00'));
            PIPE ROW(v_rep);  
        END LOOP;
    END csv_giacr044;     
--Added by Carlo de guzman 03.10.20169 SR-5343 -End   

END;
/

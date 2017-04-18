CREATE OR REPLACE PACKAGE BODY CPI.GIACR044R_PKG
AS
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 06.25.2013
   **  Reference By : giacr044r - report for reversed entries
   */
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
        p_mm       NUMBER,
        p_year     NUMBER
    )
        RETURN CHAR 
    IS
        v_date        varchar2(30);
    BEGIN
        SELECT DECODE(p_mm,1,'JANUARY'  , 2,'FEBRUARY', 3,'MARCH'    , 4,'APRIL',
                               5,'MAY'      , 6,'JUNE'    , 7,'JULY'     , 8,'AUGUST',
                               9,'SEPTEMBER', 10,'OCTOBER', 11,'NOVEMBER', 12,'DECEMBER')||' '||p_year
        INTO v_date
        FROM dual;
      RETURN (v_date);
    END cf_dateformula;

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

    FUNCTION get_report (
        p_mm            NUMBER,
        p_year          NUMBER,
        p_branch_cd     VARCHAR2
    )
        RETURN giacr044r_record_tab PIPELINED
    IS
        v_rep   giacr044r_record_type;
        v_header       BOOLEAN := TRUE;
    BEGIN
        v_rep.company_name    := cf_company_nameformula;
        v_rep.company_address := cf_addressformula;
        v_rep.cf_date         := cf_dateformula(p_mm, p_year);
           
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
                        NVL(SUM(c.credit_amt),0) credit_amt
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
               ORDER BY 4)
        LOOP
            v_header := FALSE;
            v_rep.header_flag := 'N';
            v_rep.tran_class      := q.tran_class;
            v_rep.tran_class_name := cf_tran_class_nameformula(q.tran_class);
            v_rep.gl_acct_id      := q.gl_acct_id;
            v_rep.gl_acct         := q.gl_acct;
            v_rep.gl_acct_name    := q.gl_acct_name;
            v_rep.debit_amt       := q.debit_amt;
            v_rep.credit_amt      := q.credit_amt;
            PIPE ROW(v_rep);
        END LOOP;
        
        IF v_header THEN
            v_rep.header_flag  := 'Y';
            PIPE ROW(v_rep);
        END IF;          
    END get_report;
END;
/



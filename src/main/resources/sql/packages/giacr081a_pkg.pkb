CREATE OR REPLACE PACKAGE BODY CPI.GIACR081A_PKG
AS
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.10.2013
   **  Reference By : GIACR081A (report for GIACS081)
   */    
    FUNCTION cf_company_name
       RETURN CHAR
    IS
       comp_name VARCHAR2(1000);
    BEGIN
        SELECT param_value_v
          INTO comp_name
          FROM giis_parameters
         WHERE param_name = 'COMPANY_NAME';     
        RETURN(comp_name);
    END cf_company_name;    

    FUNCTION cf_company_address
       RETURN CHAR
    IS
       v_add  VARCHAR2(1000);
    BEGIN
        SELECT param_value_v
          INTO v_add
          FROM giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
        RETURN (v_add);
    RETURN NULL; 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_add := '(NO PARAMETER COMPANY_ADDRESS IN GIIS_PARAMETERS)';
        RETURN (v_add);
        WHEN TOO_MANY_ROWS THEN
            v_add := '(TOO MANY VALUES OF COMPANY_ADDRESS IN GIIS_PARAMETERS)';
        RETURN (v_add);
    END cf_company_address;

    FUNCTION get_dv_records(
        p_replenish_id  giac_replenish_dv.replenish_id%TYPE
    )
        RETURN main_report_record_tab PIPELINED
    IS
        v_rep   main_report_record_type;
    BEGIN
        FOR q IN(SELECT a.branch_cd||'-'||a.replenish_year||'-'||a.replenish_seq_no replenishment_no, 
                        c.gl_acct_category||'-'|| TO_CHAR(c.gl_control_acct,'fm09')||'-'||TO_CHAR(c.gl_sub_acct_1,'fm09')||'-'||TO_CHAR(c.gl_sub_acct_2,'fm09')
                        ||'-'||TO_CHAR(c.gl_sub_acct_3,'fm09')||'-'||TO_CHAR(c.gl_sub_acct_4,'fm09')||'-'||TO_CHAR(c.gl_sub_acct_5,'fm09')
                        ||'-'||TO_CHAR(c.gl_sub_acct_6,'fm09')||'-'||TO_CHAR(c.gl_sub_acct_7,'fm09') gl_acct_no,
			            d.gl_acct_name,
                        SUM(NVL(c.debit_amt, 0)) debit_amt,
                        SUM(NVL(c.credit_amt, 0)) credit_amt
                   FROM giac_replenish_dv a, 
                        giac_replenish_dv_dtl b, 
                        giac_acct_entries c,
                        giac_chart_of_accts d 
                  WHERE a.replenish_id = b.replenish_id 
                    AND b.dv_tran_id = c.gacc_tran_id
                    AND NVL(b.include_tag, 'Y') = 'Y'
                    AND c.gl_acct_id = d.gl_acct_id
                    AND a.replenish_id = p_replenish_id
               GROUP BY a.replenish_id, a.branch_cd||'-'||a.replenish_year||'-'||a.replenish_seq_no,
                        c.gl_acct_category||'-'|| TO_CHAR(c.gl_control_acct,'fm09')||'-'||TO_CHAR(c.gl_sub_acct_1,'fm09')||'-'||TO_CHAR(c.gl_sub_acct_2,'fm09')
                        ||'-'||TO_CHAR(c.gl_sub_acct_3,'fm09')||'-'||TO_CHAR(c.gl_sub_acct_4,'fm09')||'-'||TO_CHAR(c.gl_sub_acct_5,'fm09')
                        ||'-'||TO_CHAR(c.gl_sub_acct_6,'fm09')||'-'||TO_CHAR(c.gl_sub_acct_7,'fm09'),d.gl_acct_name)
        LOOP
            v_rep.company_name     := cf_company_name;
            v_rep.company_address  := cf_company_address;
            v_rep.replenishment_no := q.replenishment_no;
            v_rep.gl_acct_no       := q.gl_acct_no;
            v_rep.gl_acct_name     := q.gl_acct_name;
            v_rep.debit_amt        := q.debit_amt;
            v_rep.credit_amt       := q.credit_amt;
            PIPE ROW(v_rep);
        END LOOP;
    END get_dv_records;
    
END GIACR081A_PKG;
/



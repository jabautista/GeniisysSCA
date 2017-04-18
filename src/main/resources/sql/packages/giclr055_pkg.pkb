CREATE OR REPLACE PACKAGE BODY CPI.GICLR055_PKG AS
    
    FUNCTION populate_giclr055 (
        p_tran_id           GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE
    ) RETURN giclr055_acct_entries_tab PIPELINED IS
        v_giclr055          giclr055_acct_entries_type;
    BEGIN
        FOR i IN (
            SELECT a.gl_acct_id,        
                   to_char(a.gl_acct_category) ||'-'||
                   to_char(a.gl_control_acct) ||'-'||
                   to_char(a.gl_sub_acct_1) ||'-'||
                   to_char(a.gl_sub_acct_2) ||'-'||
                   to_char(a.gl_sub_acct_3) ||'-'||
                   to_char(a.gl_sub_acct_4) ||'-'||
                   to_char(a.gl_sub_acct_5) ||'-'||
                   to_char(a.gl_sub_acct_6) ||'-'||
                   to_char(a.gl_sub_acct_7) gl_acct,
                   a.gl_acct_name, 
                   sum(d.debit_amt) debit_amt,
                   sum(d.credit_amt) credit_amt,
                   d.gacc_tran_id
              FROM giac_chart_of_accts a,
                giac_acct_entries d
             WHERE a.gl_acct_id = d.gl_acct_id
               AND d.gacc_tran_id = p_tran_id
            HAVING sum(d.debit_amt) > 0
                     OR sum(d.credit_amt) > 0             
             GROUP BY a.gl_acct_id,
                   to_char(a.gl_acct_category) ||'-'||
                   to_char(a.gl_control_acct) ||'-'||
                   to_char(a.gl_sub_acct_1) ||'-'||
                   to_char(a.gl_sub_acct_2) ||'-'||
                   to_char(a.gl_sub_acct_3) ||'-'||
                   to_char(a.gl_sub_acct_4) ||'-'||
                   to_char(a.gl_sub_acct_5) ||'-'||
                   to_char(a.gl_sub_acct_6) ||'-'||
                   to_char(a.gl_sub_acct_7),        
                   a.gl_acct_name,
                   d.gacc_tran_id
        ) LOOP
            v_giclr055.gl_acct_id       := i.gl_acct_id;
            v_giclr055.gl_acct          := i.gl_acct;
            v_giclr055.gl_acct_name     := i.gl_acct_name;
            v_giclr055.debit_amt        := i.debit_amt;
            v_giclr055.credit_amt       := i.credit_amt;
            v_giclr055.gacc_tran_id     := i.gacc_tran_id;
            
            BEGIN
              SELECT param_value_v
                INTO v_giclr055.v_company_name
                FROM giis_parameters
               WHERE param_name = 'COMPANY_NAME';

            EXCEPTION
              when NO_DATA_FOUND then
                null;
            END;
            
            BEGIN
              SELECT param_value_v
                INTO v_giclr055.v_company_address
                FROM giis_parameters
               WHERE param_name = 'COMPANY_ADDRESS';
            EXCEPTION
              when NO_DATA_FOUND then
               null;
            END;
            
            PIPE ROW(v_giclr055);
        END LOOP;
    END populate_giclr055;

END;
/



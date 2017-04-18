CREATE OR REPLACE PACKAGE BODY CPI.GIACR500B_PKG AS
FUNCTION populate_GIACR500B
(
    p_month       NUMBER,
    p_year        NUMBER,
    p_user_id     VARCHAR2
)
RETURN GIACR500B_tab PIPELINED as 
    v_rec GIACR500B_type;
    rep_header BOOLEAN := TRUE;
BEGIN
    v_rec.company_name      :=  giacp.v('COMPANY_NAME');
    v_rec.company_address   :=  giacp.v('COMPANY_ADDRESS');
    
    FOR a IN(
            SELECT  b.gl_acct_name, 
                    a.gl_acct_id, 
                    get_gl_acct_no(a.gl_acct_id) gl_no, 
                    SUM(debit) DEBIT,
                    SUM(credit) CREDIT,
                    'For The Month '|| decode(p_month,1,'January',
                         2,'February',
                         3,'March',
                         4,'April',
                         5,'May',
                         6,'June',
                         7,'July',
                         8,'August',
                         9,'September',
                         10,'October',
                         11,'November',
                         12,'December') ||', '|| to_char(p_year) as_of_date 
            FROM    giac_trial_balance_summary a, 
                    giac_chart_of_accts b
            WHERE   a.user_id = p_user_id
            AND     a.gl_acct_id = b.gl_acct_id
            GROUP BY b.gl_acct_name, a.gl_acct_id, get_gl_acct_no(a.gl_acct_id)
            ORDER BY 3
        )

        LOOP
            rep_header := FALSE;
            v_rec.gl_acct_name      :=  a.gl_acct_name;
            v_rec.gl_acct_id        :=  a.gl_acct_id;
            v_rec.gl_no             :=  a.gl_no;
            v_rec.debit             :=  a.debit;
            v_rec.credit            :=  a.credit;
            v_rec.as_of_date        :=  a.as_of_date;     
            PIPE ROW (v_rec);
        END LOOP;
        
        IF rep_header = TRUE
        THEN
            PIPE ROW (v_rec);
        END IF;
 
END populate_GIACR500B;
END GIACR500B_PKG;
/



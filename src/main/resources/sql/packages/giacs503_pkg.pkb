CREATE OR REPLACE PACKAGE BODY CPI.GIACS503_PKG 
AS

    PROCEDURE new_form_instance(
        p_year                  IN OUT NUMBER,
        p_month                 IN OUT NUMBER,
        p_first_posting_date    IN OUT NUMBER
    ) IS
        v_first_posting_date        NUMBER := NULL;  -- for variables.first_posting_date
        v_tran_year_mm              NUMBER;
        v_date                      DATE;
        v_year                      NUMBER;
        v_month                     NUMBER;
    BEGIN
        --FOR c IN (SELECT DISTINCT (TO_CHAR(MIN(tran_year),'0999')*100) + (TO_CHAR(MIN(tran_mm),'09')) posting_date
        --            FROM giac_monthly_totals) --marco - 08.26.2014 - replaced select statement
        FOR c IN(SELECT TO_CHAR(tran_year,'0999') * 100 + (TO_CHAR(tran_mm,'09')) posting_date
                   FROM giac_monthly_totals
                  ORDER BY tran_year, tran_mm)
        LOOP 
            v_first_posting_date := c.posting_date;
            EXIT;
        END LOOP;
        
        BEGIN
            FOR c IN (SELECT MAX(tran_year * 100 + tran_mm) num
                        FROM giac_tb_sl_ext)
            LOOP
                v_tran_year_mm := c.num;
            END LOOP;
        END;
        
        IF v_tran_year_mm IS NULL THEN
            v_tran_year_mm := v_first_posting_date+1000000;
        END IF;
        
        IF v_tran_year_mm > 1000000 THEN
            v_date := TO_DATE (v_tran_year_mm-1000000, 'YYYYMM');
            v_year := TO_NUMBER (TO_CHAR (v_date, 'yyyy'));
            v_month := TO_NUMBER (TO_CHAR (v_date, 'mm'));
        ELSE --IF v_tran_year_mm > 1000000 THEN
            v_date := TO_DATE (v_tran_year_mm, 'YYYYMM')+31;
            v_year := TO_NUMBER (TO_CHAR (v_date, 'yyyy'));
            v_month := TO_NUMBER (TO_CHAR (v_date, 'mm'));
        END IF; --IF v_tran_year_mm > 1000000 THEN
        
        p_year := v_year;
        p_month := v_month;
        p_first_posting_date := v_first_posting_date;
        
    END new_form_instance;
    
    PROCEDURE post_sl(
        p_year                  IN  NUMBER,
        p_month                 IN  NUMBER,
        p_first_posting_date    IN  NUMBER,
        p_message               OUT VARCHAR2
    ) IS
        v_dummy                       NUMBER;
        v_tran_year_mm                NUMBER;
    BEGIN
        p_message := '';
        IF p_year * 100 + p_month < p_first_posting_date THEN
            --msg_alert ('Posting should not be earlier than '|| TO_CHAR (TO_DATE (variables.first_posting_date, 'yyyymm'),'fmMonth, YYYY')|| '.','I',TRUE);
            raise_application_error(-20001,'Geniisys Exception#I#Posting should not be earlier than ' || TO_CHAR (TO_DATE (p_first_posting_date, 'yyyymm'),'fmMonth, YYYY') || '.');
        END IF;

        BEGIN
            v_dummy := NULL;

            FOR c1 IN (SELECT 1 one
                         FROM giac_tb_sl_ext
                        WHERE tran_mm = DECODE (p_month, 1, 12, p_month - 1)
                          AND tran_year = DECODE (p_month, 1, p_year - 1, p_year)
                          AND ROWNUM = 1)
            LOOP
                v_dummy := c1.one;
            END LOOP;

            IF v_dummy IS NULL THEN
                FOR c IN  (SELECT MAX (tran_year * 100 + tran_mm) num
                             FROM giac_tb_sl_ext)
                LOOP
                    v_tran_year_mm := c.num;
                END LOOP;

                IF v_tran_year_mm IS NULL THEN
                    v_tran_year_mm := p_first_posting_date + 1000000;
                END IF;

                IF v_tran_year_mm > 1000000 THEN
                    IF TO_NUMBER ( TO_CHAR ( TO_DATE (v_tran_year_mm - 1000000, 'YYYYMM'), 'YYYYMM')) < p_year*100+p_month THEN
                        --msg_alert ('Please post ' || TO_CHAR ( TO_DATE (v_tran_year_mm - 1000000, 'yyyymm'), 'fmMonth, YYYY') || ' first.', 'I', TRUE);
                        raise_application_error(-20001, 'Geniisys Exception#I#Please post ' || TO_CHAR ( TO_DATE (v_tran_year_mm - 1000000, 'yyyymm'), 'fmMonth, YYYY') || ' first.');
                    END IF;
                ELSE --v_tran_year_mm > 1000000
                    IF TO_NUMBER ( TO_CHAR ( TO_DATE (v_tran_year_mm, 'YYYYMM'), 'YYYYMM')) < p_year*100+p_month THEN
                        --msg_alert ( 'Please post ' || TO_CHAR ( TO_DATE (v_tran_year_mm, 'yyyymm') + 31, 'fmMonth, YYYY') || ' first.', 'I', TRUE);
                        raise_application_error(-20001, 'Geniisys Exception#I#Please post '|| TO_CHAR ( TO_DATE (v_tran_year_mm, 'yyyymm') + 31, 'fmMonth, YYYY') || ' first.');
                    END IF;
                END IF;
            END IF;
        
        END;

        --message ('Working...');
        --synchronize;
        post_gl_per_sl (p_month, p_year);
        --clear_message;
        --msg_alert ('Process Completed','I',TRUE);---PJD 09/01/2012 added to populate message "Process Completed" when post button is clicked.
        p_message := 'SUCCESS';        
    
    END post_sl;
    
    FUNCTION validate_bef_print(
        p_year      IN  NUMBER,
        p_month     IN  NUMBER
    ) RETURN NUMBER
    IS
        v_dummy     NUMBER := NULL;
    BEGIN
        FOR c IN (SELECT gl_acct_id
                    FROM giac_tb_sl_ext
                   WHERE tran_mm    = p_month
                     AND tran_year  = p_year
                     AND ROWNUM     = 1)
        LOOP
            v_dummy := c.gl_acct_id;
        END LOOP;
        
        RETURN (v_dummy);
    
    END validate_bef_print;

END GIACS503_PKG;
/



CREATE OR REPLACE PACKAGE BODY CPI.giacr279c_pkg AS

/*
**Created by: Benedict G. Castillo
**Date Created: 07/18/2013
**Description: GIACR279C-Losses Recoverable from Facultative RI
*/

FUNCTION populate_giacr279c(
    p_as_of_date            VARCHAR2,
    p_cut_off_date          VARCHAR2,
    p_line_cd               VARCHAR2,
    p_payee_type            VARCHAR2,
    p_payee_type2           VARCHAR2,
    p_ri_cd                 VARCHAR2,
    p_user_id               VARCHAR2
)
RETURN giacr279c_tab PIPELINED AS

v_rec           giacr279c_type;
v_not_exist     BOOLEAN := TRUE;
v_as_of_date    DATE := TO_DATE(p_as_of_date, 'MM/DD/RRRR');
v_cut_off_date  DATE := TO_DATE(p_cut_off_date, 'MM/DD/RRRR');
BEGIN
    v_rec.company_name          := giacp.v('COMPANY_NAME');
    v_rec.company_address       := giacp.v('COMPANY_ADDRESS');
    
    IF p_payee_type LIKE 'L' AND p_payee_type2 IS NULL THEN
  	    v_rec.title             := ('Losses Recoverable from Facultative RI (LOSS)');
    ELSIF p_payee_type like 'E' AND p_payee_type2 IS NULL THEN
        v_rec.title             := ('Losses Recoverable from Facultative RI (EXPENSE)');
    ELSE    v_rec.title         := ('Losses Recoverable from Facultative RI');    
    END IF;
    v_rec.as_of                 := 'As of '|| TO_CHAR(v_as_of_date, 'fmMonth DD, RRRR');
    v_rec.cut_off               := 'Cut-off '|| TO_CHAR(v_cut_off_date, 'fmMonth DD, RRRR');
    
    FOR i IN(SELECT    a .ri_cd, 
                       a.ri_name,
                       a.line_cd, 
                       a.line_name,
                       a.fla_date,
                       a.claim_no, 
                       a.claim_id,
                       a.policy_no, 
                       a.fla_no, 
                       a.fla_id,
                       a.assd_no, --RCarlo SR-5352 06.27.2016
                       a.assd_name, 
                       a.as_of_date, 
                       a.cut_off_date,
                       a.payee_type, 
                       a.amount_due,
                       c.short_name, 
                       a.currency_cd, 
                       a.convert_rate, 
                       a.orig_curr_rate
            from giac_loss_rec_soa_ext a, giis_currency c
            where 1=1
            and     a.amount_due <> 0
            and     a.as_of_date = v_as_of_date
            and     a.cut_off_date = v_cut_off_date
            and     a.ri_cd = nvl(p_ri_cd, a.ri_cd)
            and     a.line_cd = nvl(p_line_cd, a.line_cd)
            and     a.user_id = p_user_id
            and     a.currency_cd = c.main_currency_cd
            AND  (payee_type = p_payee_type OR payee_type =p_payee_type2) 
            order by a .ri_cd, 
                       a.line_cd, 
                       a.fla_date,
                       a.claim_no, 
                       a.claim_id,
                       a.policy_no, 
                       a.fla_no, 
                       a.fla_id,
                       a.assd_name, 
                       a.as_of_date, 
                       a.cut_off_date,
                       a.payee_type, 
                       a.amount_due)
    LOOP
        v_not_exist         := FALSE;
        v_rec.ri_cd         := i.ri_cd;
        v_rec.ri_name       := i.ri_name;
        v_rec.line_cd       := i.line_cd;
        v_rec.line_name     := i.line_name;
        v_rec.short_name    := i.short_name;
        v_rec.convert_rate  := i.convert_rate;
        v_rec.convert_rates := TO_CHAR(i.convert_rate, '999.999999999');
        v_rec.fla_date      := i.fla_date;
        v_rec.fla_no        := i.fla_no;
        v_rec.claim_id      := i.claim_id;
        v_rec.claim_no      := i.claim_no;
        v_rec.policy_no     := i.policy_no;
        v_rec.assd_no       := i.assd_no;--RCarlo SR-5352 06.27.2016
        v_rec.assd_name     := i.assd_name;
        v_rec.payee_type    := i.payee_type;
        v_rec.amount_due    := i.amount_due;
        IF i.currency_cd = giacp.n('CURRENCY_CD') then
            v_rec.convert_amt := i.amount_due * i.orig_curr_rate;
        ELSIF i.currency_cd <> giacp.n('CURRENCY_CD') then
            v_rec.convert_amt := i.amount_due;
        END IF;  
  
        PIPE ROW(v_rec);
    END LOOP;
    IF v_not_exist THEN
        v_rec.flag          := 'T';
        PIPE ROW(v_rec);
    ELSE null;
    END IF;
END populate_giacr279c;

FUNCTION get_giacr279c_matrix_header RETURN matrix_header_tab PIPELINED AS

v_rec       matrix_header_type;

BEGIN
    FOR i IN(select column_no, column_title
            from giis_report_aging
            where report_id = 'GIACR279A'
            order by column_no asc)
    LOOP
        v_rec.column_no     := i.column_no;
        v_rec.column_title  := i.column_title;
        PIPE ROW(v_rec);
    END LOOP;

END get_giacr279c_matrix_header;

FUNCTION get_giacr279c_matrix_details(
    p_as_of_date            VARCHAR2,
    p_cut_off_date          VARCHAR2,
    p_ri_cd                 VARCHAR2,
    p_line_cd               VARCHAR2,
    p_user_id               VARCHAR2,
    p_policy_no             giac_loss_rec_soa_ext.policy_no%TYPE,
    p_claim_no              giac_loss_rec_soa_ext.claim_no%TYPE, 
    p_payee_type            giac_loss_rec_soa_ext.payee_type%TYPE,
    p_payee_type2           giac_loss_rec_soa_ext.payee_type%TYPE,
    p_fla_no                giac_loss_rec_soa_ext.fla_no%TYPE,
    p_amount_due            giac_loss_rec_soa_ext.amount_due%TYPE,
    p_convert_rate          giac_loss_rec_soa_ext.convert_rate%TYPE,
    p_short_name            giis_currency.short_name%TYPE
    
)
RETURN matrix_details_tab PIPELINED AS
v_rec       matrix_details_type;
v_as_of_date    DATE := TO_DATE(p_as_of_date, 'MM/DD/RRRR');
v_cut_off_date  DATE := TO_DATE(p_cut_off_date, 'MM/DD/RRRR');
v_not_exist     BOOLEAN := TRUE;
BEGIN
    FOR i IN(select column_no, column_title
            from giis_report_aging
            where report_id = 'GIACR279A'
            order by column_no asc)
    LOOP
        v_rec.column_no     := i.column_no;
        FOR rec IN(select  a .ri_cd, 
                           a.line_cd, 
                           a.fla_date,
                           a.claim_no, 
                           a.claim_id,
                           a.policy_no, 
                           a.fla_no, 
                           a.fla_id,
                           a.assd_name, 
                           a.as_of_date, 
                           a.cut_off_date,
                           a.payee_type, 
                           a.amount_due, 
                           b.column_no, 
                           c.short_name, 
                           a.currency_cd, 
                           a.convert_rate, 
                           a.orig_curr_rate
                    from giac_loss_rec_soa_ext a, giis_report_aging b, giis_currency c
                    where 1=1
                    and     a.amount_due <> 0
                    and     a.column_no = b.column_no
                    and     a.as_of_date = v_as_of_date
                    and     a.cut_off_date = v_cut_off_date
                    and     a.ri_cd = nvl(p_ri_cd, a.ri_cd)
                    and     a.line_cd = nvl(p_line_cd, a.line_cd)
                    and     a.user_id = p_user_id
                    and     b.report_id = 'GIACR279A'
                    and     a.currency_cd = c.main_currency_cd
                    --
                    AND a.policy_no = NVL(p_policy_no, a.policy_no)
                    AND a.claim_no = nvl(p_claim_no, a.claim_no)
                    AND a.amount_due = NVL(p_amount_due, a.amount_due)
                    AND (payee_type =p_payee_type OR payee_type = p_payee_type2) 
                    AND a.fla_no = NVL(p_fla_no,a.fla_no)
                    AND c.short_name = NVL(p_short_name, c.short_name)
                    AND a.convert_rate = NVL(p_convert_rate, a.convert_rate) )     
        LOOP
            v_not_exist         := FALSE;
            v_rec.claim_no      := rec.claim_no;
            v_rec.convert_rate  := rec.convert_rate;
            v_rec.short_name    := rec.short_name;
            v_rec.line_cd       := rec.line_cd;
            v_rec.ri_cd         := rec.ri_cd;
            IF rec.column_no = i.column_no THEN
                IF rec.currency_cd = giacp.n('CURRENCY_CD') then
                    v_rec.convert_amt := rec.amount_due * rec.orig_curr_rate;
                ELSIF rec.currency_cd <> giacp.n('CURRENCY_CD') then
                    v_rec.convert_amt := rec.amount_due;
                END IF;
            ELSE v_rec.convert_amt := 0.00;
            END IF;
            PIPE ROW(v_rec);
        END LOOP;
        IF v_not_exist THEN
            v_rec.flag := 'T';
            PIPE ROW(v_rec);
        ELSE null;
        END IF;
        
    END LOOP; 
    
    

END get_giacr279c_matrix_details;


END giacr279c_pkg;
/



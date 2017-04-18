CREATE OR REPLACE PACKAGE BODY CPI.giacr279a_pkg AS

/*
**Created by: Benedict G. Castillo
**Date Created: 07.16.2013
**Description: GIACR279A - Losses Recoverable from Facultative RI 
*/

FUNCTION populate_giacr279a(
    p_as_of_date        VARCHAR2,
    p_cut_off_date      VARCHAR2,
    p_line_cd           VARCHAR2,
    p_ri_cd             VARCHAR2,
    p_user_id           VARCHAR2,
    p_payee_type        VARCHAR2,
    p_payee_type2       VARCHAR2
)
RETURN giacr279a_tab PIPELINED AS

v_rec           giacr279a_type;
v_as_of_date    DATE := TO_DATE(p_as_of_date, 'MM/DD/RRRR');
v_cut_off_date  DATE := TO_DATE(p_cut_off_date, 'MM/DD/RRRR');
v_not_exist     BOOLEAN := TRUE;
BEGIN
    v_rec.company_name      := giacp.v('COMPANY_NAME');
    v_rec.company_address   := giacp.v('COMPANY_ADDRESS');
    v_rec.as_of_date        := ('As of '||TO_CHAR(v_as_of_date, 'Month DD, YYYY'));
    v_rec.cut_off_date      := ('Cut-off '||TO_CHAR(v_cut_off_date,'Month DD, YYYY'));
    
    IF p_payee_type LIKE 'L' AND p_payee_type2 IS NULL THEN
  	    v_rec.title         := ('Losses Recoverable from Facultative (LOSS)');
    ELSIF p_payee_type like 'E' AND p_payee_type2 IS NULL THEN
        v_rec.title         := ('Losses Recoverable from Facultative (EXPENSE)');
    ELSE v_rec.title         := ('Losses Recoverable from Facultative RI');
    END IF;
    
    FOR i IN(select  a.ri_cd, 
                     a.ri_name,
                     a.line_cd, 
                     a.line_name,
                     a.fla_date,
                     a.claim_no, 
                     a.claim_id,
                     a.policy_no, 
                     a.fla_no, 
                     a.fla_id,
                     a.assd_name, 
                     a.assd_no, --CarloR SR-5350 06.24.2016
                     a.as_of_date, 
                     a.cut_off_date,
                     a.payee_type, 
                     a.amount_due
             from giac_loss_rec_soa_ext a, giis_report_aging b
            WHERE 1=1
            AND     a.amount_due <> 0
            AND     a.column_no = b.column_no
            AND     a.as_of_date = v_as_of_date
            AND     a.cut_off_date = v_cut_off_date
            AND     a.ri_cd = nvl(p_ri_cd, a.ri_cd)
            AND     a.line_cd = nvl(p_line_cd, a.line_cd)
            AND     a.user_id = p_user_id
            AND  b.report_id = 'GIACR279A'
             AND  (payee_type =p_payee_type OR payee_type = p_payee_type2) 
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
                       a.amount_due, 
                       b.column_no)
    LOOP
        v_not_exist         := FALSE;
        v_rec.ri_cd         := i.ri_cd;
        v_rec.ri_name       := i.ri_name;
        v_rec.line_cd       := i.line_cd;
        v_rec.line_name     := i.line_name;
        v_rec.fla_date      := i.fla_date;
        v_rec.fla_no        := i.fla_no;
        v_rec.claim_no      := i.claim_no;
        v_rec.claim_id      := i.claim_id;
        v_rec.policy_no     := i.policy_no;
        v_rec.assd_name     := i.assd_name;
        v_rec.assd_no       := i.assd_no; --CarloR SR-5350 06.24.2016
        v_rec.payee_type    := i.payee_type;
        v_rec.amount_due    := i.amount_due;
        PIPE ROW(v_rec);
    END LOOP;
    
    IF v_not_exist THEN
        v_rec.flag          := 'T';
        PIPE ROW(v_rec);
    ELSE null;
    END IF;
END populate_giacr279a;

FUNCTION get_column_title RETURN column_title_tab PIPELINED AS

v_rec       column_title_type;
BEGIN
    FOR i IN(SELECT column_no, column_title
             FROM giis_report_aging
             WHERE report_id = 'GIACR279A'
             ORDER BY column_no asc)
    LOOP
        v_rec.column_no     := i.column_no;
        v_rec.column_title  := i.column_title;
        PIPE ROW(v_rec);
    END LOOP;
END get_column_title;

FUNCTION get_matrix_details(
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
    p_amount_due            giac_loss_rec_soa_ext.amount_due%TYPE
)
RETURN matrix_details_tab PIPELINED AS
    
v_rec       matrix_details_type;
v_as_of_date    DATE := TO_DATE(p_as_of_date, 'MM/DD/RRRR');
v_cut_off_date  DATE := TO_DATE(p_cut_off_date, 'MM/DD/RRRR');
BEGIN
    FOR i IN (SELECT column_no, column_title
             FROM giis_report_aging
             WHERE report_id = 'GIACR279A'
             ORDER BY column_no asc)
    LOOP
        v_rec.column_no     := i.column_no;
        FOR rec IN (select a .ri_cd, 
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
                           b.column_no
                    from giac_loss_rec_soa_ext a, giis_report_aging b
                    where 1=1
                    and     a.amount_due <> 0
                    and     a.column_no = b.column_no
                    and     a.as_of_date = v_as_of_date
                    and     a.cut_off_date = v_cut_off_date
                    and     a.ri_cd = nvl(p_ri_cd, a.ri_cd)
                    and     a.line_cd = nvl(p_line_cd, a.line_cd)
                    and     a.user_id = p_user_id
                    AND  b.report_id = 'GIACR279A'
                    --
                    AND a.policy_no = NVL(p_policy_no, a.policy_no)
                    AND a.claim_no = nvl(p_claim_no, a.claim_no)
                    AND a.amount_due = NVL(p_amount_due, a.amount_due)
                    AND (payee_type =p_payee_type OR payee_type = p_payee_type2) 
                    AND a.fla_no = NVL(p_fla_no,a.fla_no))        
        LOOP
            v_rec.policy_no     := rec.policy_no;
            v_rec.claim_no      := rec.claim_no;
            v_rec.payee_type    := rec.payee_type;
            v_rec.fla_no        := rec.fla_no;
            v_rec.ri_cd         := rec.ri_cd;
            v_rec.line_cd       := rec.line_cd;
            IF rec.column_no = i.column_no THEN
                v_rec.amount_due    := rec.amount_due;
            ELSE v_rec.amount_due    := null;
            END IF;
            PIPE ROW(v_rec);
        END LOOP;
    
    END LOOP;

END get_matrix_details;

END giacr279a_pkg;
/



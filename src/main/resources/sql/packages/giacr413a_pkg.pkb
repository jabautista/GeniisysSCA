CREATE OR REPLACE PACKAGE BODY CPI.giacr413a_pkg AS

/*
** Created by : Benedict G. Castillo
** Date Created : 07.11.2013
** Description : GIACR413A_PKG-Commisions Paid
*/

FUNCTION populate_giacr413a(
    p_branch            VARCHAR2,
    p_from_date         VARCHAR2,
    p_to_date           VARCHAR2,
    p_tran_post         VARCHAR2,
    p_module_id         VARCHAR2,
    p_intm_type         VARCHAR2,
    p_user_id           VARCHAR2
)
RETURN giacr413a_tab PIPELINED AS

v_rec       giacr413a_type;
v_from_date DATE := TO_DATE(p_from_date, 'MM/DD/RRRR');
v_to_date   DATE := TO_DATE(p_to_date, 'MM/DD/RRRR');
v_not_exist BOOLEAN := TRUE;
BEGIN
    v_rec.company_name      := giacp.v('COMPANY_NAME');
    v_rec.company_address   := giisp.v('COMPANY_ADDRESS');
    v_rec.period            := ('From '||to_char(v_from_date , 'fm Month dd, yyyy')
                                ||' to '||to_char(v_to_date , 'fm Month dd, yyyy'));
    IF p_tran_post = 1  Then
       v_rec.tran_post := 'Based on Transaction Date' ;
    Else
       v_rec.tran_post := 'Based on Posting Date' ;
    End IF;
    FOR i IN(SELECT d.intm_type, 
                    a.intm_no, 
                    e.line_cd, 
                    f.ISS_CD, 
                    d.intm_name, 
                    SUM (a.comm_amt) comm,
                    SUM (a.wtax_amt) wtax, 
                    SUM (input_vat_amt) input_vat
             FROM gipi_polbasic e,
                  giac_comm_payts a,
                  gipi_comm_invoice f,
                  giac_acctrans b,
                  giis_intermediary d
             WHERE d.intm_type = nvl(p_intm_type, d.intm_type)
               AND ((p_tran_post = 1 AND TRUNC (b.tran_date) BETWEEN v_from_date AND v_to_date)
                    OR (p_tran_post = 2 AND TRUNC (b.posting_date) BETWEEN v_from_date AND v_to_date))
               AND b.tran_flag <> 'D'
               --AND b.tran_flag <> 'CP' --mikel 12.12.2016;
               AND b.tran_class NOT IN ('CP', 'CPR') --mikel 12.12.2016; SR 5874 - excluded transactions that are processed from cancelled policies module (GIACS412) 
               AND b.tran_id > 0
               AND a.gacc_tran_id = b.tran_id
               AND a.iss_cd = NVL (p_branch, a.iss_cd)
               --AND check_user_per_iss_cd_acctg2 (NULL, a.iss_cd, p_module_id,p_user_id) = 1  --mikel 12.12.2016;
               AND EXISTS (SELECT 'X'
                                   FROM table (security_access.get_branch_line('AC', p_module_id, p_user_id))
                                  WHERE branch_cd = a.iss_cd) --mikel 12.12.2016; SR 5874 - optimization 
               AND f.intrmdry_intm_no > 0
               AND f.iss_cd = a.iss_cd
               AND f.prem_seq_no = a.prem_seq_no
               AND f.intrmdry_intm_no = a.intm_no     -- judyann 12262012; to handle bills with multiple intermediaries -- SR-11684 : shan 09.03.2015
               AND a.intm_no = d.intm_no
               AND e.policy_id = f.policy_id
               AND NOT EXISTS ( SELECT c.gacc_tran_id
                                FROM giac_reversals c, giac_acctrans d
                                WHERE c.reversing_tran_id = d.tran_id
                                  AND d.tran_flag <> 'D'
                                  AND c.gacc_tran_id = a.gacc_tran_id)
             GROUP BY d.intm_type, a.intm_no, e.line_cd, d.intm_name, f.ISS_CD
             ORDER BY d.intm_type, d.intm_name)
    LOOP
        v_not_exist         := FALSE;
        v_rec.iss_cd        := i.iss_cd;
        FOR z IN(SELECT iss_name
                 FROM giis_issource
                 WHERE iss_cd = i.iss_cd)
        LOOP
            v_rec.branch_name   := z.iss_name;
            exit;
        END LOOP;
        v_rec.intm_type     := i.intm_type;
        FOR h IN(SELECT intm_desc
                 FROM GIIS_INTM_TYPE
                 WHERE intm_type = i.intm_type)
        LOOP
            v_rec.intm_desc     := h.intm_desc;
            EXIT;
        END LOOP;
        v_rec.intm_no       := i.intm_no;
        v_rec.intm_name     := i.intm_name;
        v_rec.line_cd       := i.line_cd;
        v_rec.comm          := i.comm;
        v_rec.wtax          := i.wtax;
        v_rec.input_vat     := i.input_vat;
        v_rec.net_amt       := (i.comm - i.wtax + i.input_vat);
        PIPE ROW(v_rec);
    END LOOP;
    
    
    IF v_not_exist THEN
        v_rec.flag  := 'T';
        PIPE ROW(v_rec);
    ELSE null;
    END IF;

END populate_giacr413a;


END giacr413a_pkg;
/
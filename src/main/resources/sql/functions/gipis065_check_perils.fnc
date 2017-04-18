DROP FUNCTION CPI.GIPIS065_CHECK_PERILS;

CREATE OR REPLACE FUNCTION CPI.GIPIS065_CHECK_PERILS (
    p_par_id IN gipi_wpolbas.par_id%TYPE,
    p_item_no IN gipi_witem.item_no%TYPE)
RETURN VARCHAR2
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 05.31.2011
    **  Reference By     : (GIPIS065- Endt Item Information - AC)
    **  Description     : Checks if there are existing perils in gipi_witmperl
    **                     : if records exists, restrict user from inserting additional perils in grouped item level
    **                     : checking: (WITH item peril record, and WITHOUT grouped item peril records, user restriction ON)
    **                   : (WITH item peril record, and WITH grouped item peril records, user restriction OFF)
    **                   : (WITHOUT item peril record, and WITH grouped item peril records, user restriction OFF)  
    **                   : (WITHOUT item peril record, and WITHOUT grouped item peril records, user restriction OFF)  
    */
    v_exist VARCHAR2(1) := 'N';
BEGIN
    FOR i IN (
        SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
               eff_date
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP
        FOR a IN (
            SELECT 1
              FROM gipi_itmperil b
             WHERE EXISTS (SELECT '1'
                             FROM gipi_polbasic a
                            WHERE a.line_cd = i.line_cd
                              AND a.iss_cd = i.iss_cd
                              AND a.subline_cd = i.subline_cd
                              AND a.issue_yy = i.issue_yy
                              AND a.pol_seq_no = i.pol_seq_no
                              AND a.renew_no = i.renew_no
                              AND a.pol_flag IN ('1', '2', '3', 'X')
                              AND TRUNC(a.eff_date) <= TRUNC(i.eff_date)
                              AND NVL(a.endt_expiry_date, a.expiry_date) >= i.eff_date
                              AND a.policy_id = b.policy_id)
               AND b.item_no = p_item_no)
        LOOP
            v_exist := 'Y';
            EXIT;
        END LOOP;
        
        FOR b IN (
            SELECT 2
              FROM gipi_itmperil_grouped b
             WHERE EXISTS(SELECT '1'
                            FROM gipi_polbasic a
                           WHERE a.line_cd = i.line_cd
                             AND a.iss_cd = i.iss_cd
                             AND a.subline_cd = i.subline_cd
                             AND a.issue_yy = i.issue_yy
                             AND a.pol_seq_no = i.pol_seq_no
                             AND a.renew_no = i.renew_no
                             AND a.pol_flag IN ('1', '2', '3', 'X')
                             AND TRUNC(a.eff_date) <= TRUNC(i.eff_date)
                             AND NVL(a.endt_expiry_date, a.expiry_date) >= i.eff_date
                             AND a.policy_id = b.policy_id)
               AND b.item_no = p_item_no)
        LOOP
            v_exist := 'N';
            EXIT;
        END LOOP;
    END LOOP;
    
    RETURN v_exist;
END GIPIS065_CHECK_PERILS;
/



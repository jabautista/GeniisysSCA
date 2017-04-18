DROP FUNCTION CPI.CHECK_ITMPERL_EXISTS;

CREATE OR REPLACE FUNCTION CPI.CHECK_ITMPERL_EXISTS (
    p_item_no           GIPI_WITEM.item_no%TYPE,
    p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
    p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
    p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
    p_eff_date          GIPI_POLBASIC.eff_date%TYPE
) RETURN VARCHAR2 IS
         /*
   **  Created by      : D.Alcantara
   **  Date Created    : 07.22.2011
   **  Reference By    : (GIPIS065 - Endt Accident Information)
   **  Description     : Returns character value indicating if item peril exists
   */
     v_exists        VARCHAR2(1);
BEGIN
     v_exists := 'N';
     FOR a IN (SELECT 1 
                              FROM gipi_itmperil b 
                             WHERE EXISTS ( SELECT '1'
                               FROM gipi_polbasic a
                              WHERE a.line_cd     =  p_line_cd
                                AND a.iss_cd      =  p_iss_cd
                                AND a.subline_cd  =  p_subline_cd
                                AND a.issue_yy    =  p_issue_yy
                                AND a.pol_seq_no  =  p_pol_seq_no
                                AND a.renew_no    =  p_renew_no
                                AND a.pol_flag    IN( '1','2','3','X')
                                AND TRUNC(a.eff_date) <= TRUNC(p_eff_date)
                                AND NVL(a.endt_expiry_date,a.expiry_date) >=  p_eff_date
                                AND a.policy_id = b.policy_id)
                AND b.item_no = p_item_no) LOOP
         v_exists := 'Y';
         EXIT;
     END LOOP;
     
     FOR b IN (SELECT 2 
                              FROM gipi_itmperil_grouped b
                             WHERE EXISTS ( SELECT '1'
                               FROM gipi_polbasic a
                              WHERE a.line_cd     =  p_line_cd
                                AND a.iss_cd      =  p_iss_cd
                                AND a.subline_cd  =  p_subline_cd
                                AND a.issue_yy    =  p_issue_yy
                                AND a.pol_seq_no  =  p_pol_seq_no
                                AND a.renew_no    =  p_renew_no
                                AND a.pol_flag    IN( '1','2','3','X')
                                AND TRUNC(a.eff_date) <= TRUNC(p_eff_date)
                                AND NVL(a.endt_expiry_date,a.expiry_date) >=  p_eff_date
                                AND a.policy_id = b.policy_id)
                AND b.item_no = p_item_no) LOOP    
         v_exists := 'N';     
         EXIT;
     END LOOP;
     
     RETURN v_exists;
END CHECK_ITMPERL_EXISTS;
/



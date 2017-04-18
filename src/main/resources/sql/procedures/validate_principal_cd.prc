DROP PROCEDURE CPI.VALIDATE_PRINCIPAL_CD;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_PRINCIPAL_CD(
    p_par_id        IN  GIPI_WGROUPED_ITEMS.par_id%TYPE,
    p_item_no       IN  GIPI_WGROUPED_ITEMS.item_no%TYPE,
    p_principal_cd  IN  GIPI_WGROUPED_ITEMS.principal_cd%TYPE,
    p_message       OUT VARCHAR2
)
IS
    v_line_cd       GIPI_PARLIST.line_cd%TYPE;
    v_iss_cd        GIPI_PARLIST.iss_cd%TYPE;
    v_subline_cd    GIPI_WPOLBAS.subline_cd%TYPE;
    v_issue_yy      GIPI_WPOLBAS.issue_yy%TYPE;
    v_pol_seq_no    GIPI_WPOLBAS.pol_seq_no%TYPE;
    v_renew_no      GIPI_WPOLBAS.renew_no%TYPE;
    v_exist        VARCHAR2(1) := 'N';
BEGIN
    p_message := 'SUCCESS';

    BEGIN
        SELECT line_cd, iss_cd
          INTO v_line_cd, v_iss_cd
          FROM GIPI_PARLIST
         WHERE par_id = p_par_id;
    END;
    
    BEGIN
        SELECT subline_cd, issue_yy, pol_seq_no, renew_no
          INTO v_subline_cd, v_issue_yy, v_pol_seq_no, v_renew_no
          FROM GIPI_WPOLBAS
         WHERE par_id = p_par_id;
    END;
    
    FOR pol IN (SELECT policy_id
                  FROM GIPI_POLBASIC
                 WHERE line_cd = v_line_cd
                   AND iss_cd = v_iss_cd
                   AND subline_cd = v_subline_cd 
                   AND issue_yy = v_issue_yy
                   AND pol_seq_no = v_pol_seq_no  
                   AND renew_no = v_renew_no
                   AND pol_flag IN ('1','2','3','X')
                 ORDER BY eff_date)
    LOOP
        FOR a IN(SELECT grouped_item_no, principal_cd											
                   FROM GIPI_GROUPED_ITEMS
	              WHERE grouped_item_no = p_principal_cd
                    AND item_no = p_item_no 
                    AND NVL(delete_sw,'N')!= 'Y' 
                    AND policy_id = pol.policy_id)
        LOOP
            v_exist := 'Y';
            EXIT;
        END LOOP;
    END LOOP;
    
    FOR par_prin IN (SELECT 1
                       FROM GIPI_WGROUPED_ITEMS
                      WHERE grouped_item_no = p_principal_cd
                        AND item_no = p_item_no
                        AND par_id = p_par_id)
    LOOP
        v_exist := 'Y';
        EXIT;
    END LOOP;
    
    IF v_exist = 'N' THEN
        p_message := 'Non-existing enrollee could not be used as a Principal enrollee';
    END IF;
END;
/



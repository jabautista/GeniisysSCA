DROP FUNCTION CPI.CHECK_COC_SERIAL_NO_IN_POL_PAR;

CREATE OR REPLACE FUNCTION CPI.Check_Coc_Serial_No_In_Pol_Par (
    p_par_id        IN gipi_wvehicle.par_id%TYPE,
    p_item_no       IN gipi_wvehicle.item_no%TYPE,
    p_coc_type      IN gipi_wvehicle.coc_type%TYPE,
    p_coc_serial_no IN gipi_wvehicle.coc_serial_no%TYPE,
    p_coc_yy        IN gipi_wvehicle.coc_yy%TYPE)
RETURN VARCHAR2
IS
    /*
    **  Created by       : Mark JM
    **  Date Created    : 01.04.2011
    **  Reference By    : (GIPIS010 - Item Information)
    **  Description     : Checks for coc_serial_no in Policy and Par
    */
    /*
    **  Edited by       : Robert Virrey
    **  Date Created    : 06.20.2013
    **  Reference By    : (GIPIS010 - Item Information)
    **  Description     : added coc_yy , sr 13500
    */
    
    v_result       VARCHAR2(4000);
    
    -- following variables added by: Nica 11.09.2011
    v_policy_id    GIPI_POLBASIC.policy_id%TYPE;
    v_line_cd      GIPI_POLBASIC.line_cd%TYPE;
    v_subline_cd   GIPI_POLBASIC.subline_cd%TYPE;
    v_iss_cd       GIPI_POLBASIC.iss_cd%TYPE;
    v_issue_yy     GIPI_POLBASIC.issue_yy%TYPE;
    v_pol_seq_no   GIPI_POLBASIC.pol_seq_no%TYPE;
    v_renew_no     GIPI_POLBASIC.renew_no%TYPE;
    v_par_type     GIPI_PARLIST.par_type%TYPE;
    
BEGIN
    
    /* Modified by: Nica 11.09.2011 - to disregard the coc_serial_no 
      of the policy being endorse if par_type = 'E'*/
      
    FOR i IN (SELECT b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy,
                     b.pol_seq_no, b.renew_no, A.par_type, A.par_id
              FROM gipi_parlist A, gipi_wpolbas b
              WHERE A.par_id = b.par_id
              AND A.par_id =  p_par_id)
    LOOP
        v_line_cd    := i.line_cd;
        v_subline_cd := i.subline_cd;
        v_iss_cd     := i.iss_cd;
        v_issue_yy   := i.issue_yy;
        v_pol_seq_no := i.pol_seq_no;
        v_renew_no   := i.renew_no;
        v_par_type   := i.par_type;
    END LOOP;
    
                                 
    IF(NVL(v_par_type, 'P') = 'E') THEN
        
        v_policy_id := GET_POLICY_ID(v_line_cd, v_subline_cd, v_iss_cd,
                                     v_issue_yy,v_pol_seq_no, v_renew_no);                           
                               
        FOR chk_rec IN (
            SELECT coc_serial_no, policy_id
              FROM GIPI_VEHICLE
             WHERE coc_serial_no = p_coc_serial_no
               AND coc_yy = p_coc_yy --added by robert 06.20.2013
               AND coc_type = p_coc_type
               AND (policy_id != v_policy_id 
                 OR (policy_id = v_policy_id 
                     AND item_no != p_item_no)))
        LOOP     
            FOR A IN (
                SELECT line_cd || '-' || subline_cd || '-' || iss_cd || '-' ||
                       LTRIM(TO_CHAR(issue_yy, '09')) || '-' || 
                       LTRIM(TO_CHAR(pol_seq_no, '0999999')) || '-' ||  
                       LTRIM(TO_CHAR(renew_no, '09')) POLICY_NO, pol_flag
                  FROM GIPI_POLBASIC
                 WHERE policy_id = chk_rec.policy_id)
            LOOP            
                IF A.pol_flag <> '5' THEN
                    v_result := 'COC Serial No. ' || p_coc_serial_no || ' already exists in Policy No. ' || A.POLICY_NO || '.';                
                    EXIT;
                END IF;
            END LOOP;
        END LOOP;
        
    ELSE
        FOR chk_rec IN (
            SELECT coc_serial_no, policy_id
              FROM GIPI_VEHICLE
             WHERE coc_serial_no = p_coc_serial_no
               AND coc_yy = p_coc_yy --added by robert 06.20.2013
               AND coc_type = p_coc_type
        )
        LOOP     
            FOR A IN (
                SELECT line_cd || '-' || subline_cd || '-' || iss_cd || '-' ||
                       LTRIM(TO_CHAR(issue_yy, '09')) || '-' || 
                       LTRIM(TO_CHAR(pol_seq_no, '0999999')) || '-' ||  
                       LTRIM(TO_CHAR(renew_no, '09')) POLICY_NO, pol_flag
                  FROM GIPI_POLBASIC
                 WHERE policy_id = chk_rec.policy_id)
            LOOP            
                IF A.pol_flag <> '5' THEN
                    v_result := 'COC Serial No. ' || p_coc_serial_no || ' already exists in Policy No. ' || A.POLICY_NO || '.';                
                    EXIT;
                END IF;
            END LOOP;
        END LOOP;
    END IF;
                                 
    /* end of modification - Nica 11.09.2011*/
    
    IF v_result IS NOT NULL THEN
        RETURN v_result;
    END IF;
    
    FOR chk_rec2 IN (
        SELECT coc_serial_no, par_id
          FROM gipi_wvehicle
         WHERE coc_type = p_coc_type
           AND coc_serial_no = p_coc_serial_no
           AND coc_yy = p_coc_yy --added by robert 06.20.2013
           AND coc_type = p_coc_type
           AND (par_id != p_par_id 
            OR (par_id = p_par_id 
           AND item_no != p_item_no)))
     LOOP
        FOR b IN (
            SELECT par_status
              FROM gipi_parlist
             WHERE par_id = chk_rec2.par_id)
        LOOP 
            IF b.par_status NOT IN (98,99) THEN
                v_result := 'COC_SERIAL_NO ' || p_coc_serial_no || ' already exists in other records.';            
                EXIT;
            END IF;
        END LOOP;
    END LOOP;
    
    RETURN v_result;
END Check_Coc_Serial_No_In_Pol_Par;
/



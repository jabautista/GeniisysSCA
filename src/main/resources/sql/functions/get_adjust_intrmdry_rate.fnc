DROP FUNCTION CPI.GET_ADJUST_INTRMDRY_RATE;

CREATE OR REPLACE FUNCTION CPI.GET_ADJUST_INTRMDRY_RATE(p_intm_no IN NUMBER,
                                  p_policy_id IN NUMBER,
                                  p_peril_cd IN VARCHAR2) RETURN NUMBER IS
  v_co_intm_type    giis_intermediary.co_intm_type%TYPE;
  v_parent_intm_no  giis_intermediary.parent_intm_no%TYPE;
  v_comm_rate       giis_spl_override_rt.comm_rate%TYPE := 0;
  v_line_cd   gipi_polbasic.line_cd%TYPE;
  v_subline_cd   gipi_polbasic.subline_cd%TYPE;
  v_iss_cd   gipi_polbasic.iss_cd%TYPE;
BEGIN
  FOR c1 IN (SELECT 1
               FROM giis_intermediary
              WHERE intm_no = p_intm_no
                      AND lic_tag = 'N')
  LOOP
    BEGIN
      SELECT line_cd,subline_cd, iss_cd
        INTO v_line_cd, v_subline_cd, v_iss_cd
        FROM gipi_polbasic
       WHERE policy_id = p_policy_id;
    END;    
    FOR gip_trg IN (SELECT 1
                      FROM giis_intm_special_rate
                     WHERE intm_no = p_intm_no
                       AND line_cd = v_line_cd
                       AND iss_cd = v_iss_cd
                       AND peril_cd = p_peril_cd
                       AND subline_cd = v_subline_cd
                       AND override_tag = 'Y') 
    LOOP
      BEGIN
          SELECT a.co_intm_type typ, b.parent_intm_no
            INTO v_co_intm_type, v_parent_intm_no
          FROM giis_intermediary a,
               giis_intermediary b
         WHERE a.intm_no = b.parent_intm_no            
           AND b.intm_no = p_intm_no;    
        END;
        BEGIN
          SELECT a.comm_rate
            INTO v_comm_rate
          FROM giis_spl_override_rt a
         WHERE intm_no = v_parent_intm_no
           AND line_cd = v_line_cd
           AND iss_cd = v_iss_cd
           AND peril_cd = p_peril_cd
           AND subline_cd = v_subline_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
          BEGIN
                SELECT comm_rate
                  INTO v_comm_rate
              FROM giis_intm_type_comrt
             WHERE co_intm_type = v_co_intm_type
               AND line_cd = v_line_cd
               AND iss_cd = v_iss_cd
               AND peril_cd = p_peril_cd
               AND subline_cd = v_subline_cd;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     v_comm_rate := 0; 
              END;           
      END;
    END LOOP;    
  END LOOP; 
  RETURN(v_comm_rate); 
END;
/



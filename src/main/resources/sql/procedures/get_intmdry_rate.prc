DROP PROCEDURE CPI.GET_INTMDRY_RATE;

CREATE OR REPLACE PROCEDURE CPI.GET_INTMDRY_RATE(
    p_proc_intm_no      giis_intermediary.intm_no%TYPE,
    p_new_par_id        gipi_wpolbas.par_id%TYPE,
    p_dsp_line_cd       giis_intm_special_rate.line_cd%TYPE,
    p_dsp_iss_cd        giis_intermediary.iss_cd%TYPE,
    p_peril_cd          giis_intm_special_rate.peril_cd%TYPE,
    p_rate          OUT giis_intm_special_rate.rate%TYPE
) 
IS

  v_peril_name     giis_peril.peril_name%TYPE;
  v_message        VARCHAR2(200);
  v_sp_rt          VARCHAR2(1);
  V_SUBLINE_CD     GIPI_WPOLBAS.SUBLINE_cD%TYPE;
  v_dummy          VARCHAR2(1);
  v_intm           gipi_wcomm_invoices.intrmdry_intm_no%TYPE;
  v_intm_type      giis_intermediary.intm_type%TYPE;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : GET_INTMDRY_RATE program unit 
  */
    FOR A IN (SELECT intm_type, special_rate
                FROM giis_intermediary
               WHERE intm_no = p_proc_intm_no)
  LOOP              
      v_intm_type := a.intm_type;
      v_sp_rt := a.special_rate;
      EXIT;
  END LOOP;     
  FOR B IN (SELECT subline_cd
              FROM gipi_wpolbas
             WHERE par_id = p_new_par_id)
  LOOP
      V_SUBLINE_CD := b.subline_cd;
      EXIT;
  END LOOP;               

  IF v_sp_rt = 'Y' THEN
     BEGIN
       SELECT rate
         INTO  p_rate 
         FROM giis_intm_special_rate
        WHERE intm_no    = p_proc_intm_no
          AND line_cd    = p_dsp_line_cd
          AND iss_cd     = p_dsp_iss_cd
          AND peril_cd   = p_peril_cd
          AND SUBLINE_cd = V_SUBLINE_cd; 
       EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          BEGIN 
            SELECT comm_rate
              INTO p_rate
              FROM giis_intmdry_type_rt
             WHERE intm_type    = v_intm_type
               AND line_cd      = p_dsp_line_cd
               AND iss_cd       = p_dsp_iss_cd
               AND peril_cd     = p_peril_cd
               AND subline_cd   = V_SUBLINE_cd;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              BEGIN
                    SELECT intm_comm_rt
                      INTO p_rate
                      FROM giis_peril
                     WHERE line_cd   = p_dsp_line_cd
                     AND peril_cd  = p_peril_cd;
                 EXCEPTION
                WHEN NO_DATA_FOUND THEN
                            p_rate := 0;
              END;
          END;
     END;
  ELSE
     BEGIN
       SELECT comm_rate
         INTO p_rate
         FROM giis_intmdry_type_rt
        WHERE intm_type    = v_intm_type
          AND line_cd      = p_dsp_line_cd
          AND iss_cd       = p_dsp_iss_cd
          AND peril_cd     = p_peril_cd
          AND SUBLINE_cD   = V_SUBLINE_CD;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
         BEGIN
               SELECT intm_comm_rt
                   INTO p_rate
                   FROM giis_peril
                  WHERE line_cd   = p_dsp_line_cd
                  AND peril_cd  = p_peril_cd;
                 EXCEPTION 
                   WHEN no_data_found THEN
                     p_rate := 0;
         END;
     END;
  END IF;
END;
/



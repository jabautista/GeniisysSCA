DROP PROCEDURE CPI.GET_PACKAGE_INTM_RATE;

CREATE OR REPLACE PROCEDURE CPI.GET_PACKAGE_INTM_RATE( 
    PIR_ITEM_NO     GIPI_WITMPERL.item_no%TYPE,
    PIR_line_cd     GIPI_WITEM.pack_line_cd%TYPE,
    PIR_peril_cd    GIPI_WITMPERL.peril_cd%TYPE,
    PIR_item_grp    GIPI_WITEM.item_grp%TYPE,
    p_proc_intm_no  giis_intermediary.intm_no%TYPE,
    p_new_par_id    GIPI_WITEM.par_id%TYPE,
    p_dsp_iss_cd    giis_intm_special_rate.iss_cd%TYPE,
    p_iss_cd        giis_intmdry_type_rt.iss_cd%TYPE,
    p_rate      OUT giis_peril.intm_comm_rt%TYPE
) 
IS
  v_peril_name     giis_peril.peril_name%TYPE;
  v_message        VARCHAR2(200);
  v_sp_rt          VARCHAR2(1);
  v_dummy          VARCHAR2(1);
  v_subline_cd     gipi_witem.pack_subline_cd%TYPE;
  v_intm_no        gipi_wcomm_invoices.intrmdry_intm_no%TYPE;
  v_intm_type      giis_intermediary.intm_type%TYPE;         

BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : GET_PACKAGE_INTM_RATE program unit 
  */
  FOR intm_type IN (SELECT intm_type
                      FROM giis_intermediary
                     WHERE intm_no = p_proc_intm_no)
  LOOP              
      v_intm_type := intm_type.intm_type;
      EXIT;
  END LOOP;     
            
  SELECT special_rate
    INTO v_sp_rt
    FROM giis_intermediary
   WHERE intm_no = p_proc_intm_no;

  SELECT DISTINCT PACK_SUBLINE_CD
    INTO V_SUBLINE_CD
    FROM GIPI_WITEM 
   WHERE PAR_ID = p_new_par_id
     AND ITEM_GRP = PIR_ITEM_GRP;   

  IF v_sp_rt = 'Y' THEN
     BEGIN
         SELECT rate
           INTO p_rate
           FROM giis_intm_special_rate
          WHERE intm_no    = p_proc_intm_no
            AND line_cd    = PIR_line_cd
            AND iss_cd     = p_dsp_iss_cd
            AND peril_cd   = PIR_peril_cd
            AND subline_cd = v_subline_cd;

     EXCEPTION
       WHEN NO_DATA_FOUND THEN 
         BEGIN 
           SELECT comm_rate
             INTO p_rate
             FROM giis_intmdry_type_rt
            WHERE intm_type    = v_intm_type
              AND line_cd      = PIR_line_cd 
              AND iss_cd       = p_iss_cd
              AND peril_cd     = PIR_peril_cd
              AND subline_cd   = v_subline_cd;

           EXCEPTION
           WHEN NO_DATA_FOUND THEN
             BEGIN
                   SELECT intm_comm_rt
                     INTO p_rate
                     FROM giis_peril
                    WHERE line_cd   = PIR_line_cd
                    AND peril_cd  = PIR_peril_cd;
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
          AND line_cd      = PIR_line_cd 
          AND iss_cd       = p_iss_cd
          AND peril_cd     = PIR_peril_cd
          AND SUBLINE_CD   = V_SUBLINE_CD;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
         BEGIN
             SELECT intm_comm_rt
               INTO p_rate
               FROM giis_peril
              WHERE line_cd   = PIR_line_cd 
              AND peril_cd  = PIR_peril_cd;
               EXCEPTION
                   WHEN no_data_found THEN
                     p_rate := 0;
         END;
     END;
  END IF;
END;
/



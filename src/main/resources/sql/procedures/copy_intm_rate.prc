DROP PROCEDURE CPI.COPY_INTM_RATE;

CREATE OR REPLACE PROCEDURE CPI.Copy_Intm_Rate 
  (p_intm_no_to                         IN GIIS_INTM_SPECIAL_RATE.INTM_NO%TYPE,  
   p_intm_no_from      IN GIIS_INTM_SPECIAL_RATE.INTM_NO%TYPE,
   p_iss_cd_from      IN GIIS_INTM_SPECIAL_RATE.ISS_CD%TYPE,
   p_line_cd       IN GIIS_INTM_SPECIAL_RATE.LINE_CD%TYPE,
   p_subline_cd       IN GIIS_INTM_SPECIAL_RATE.SUBLINE_CD%TYPE,
   p_giis_int_sp_rt_dtl_ovde_tg       IN GIIS_INTM_SPECIAL_RATE.OVERRIDE_TAG%TYPE,   
   p_giis_int_spe_rt_dtl_user_id  IN GIIS_INTM_SPECIAL_RATE.USER_ID%TYPE,
   p_giis_int_spe_rt_dtl_last_upd     IN GIIS_INTM_SPECIAL_RATE.LAST_UPDATE%TYPE,
   p_PARAMETER_COPIED        OUT VARCHAR2,
   p_PARAMETER_WHERE          OUT VARCHAR2,
   v_msg_alert         OUT NUMBER,
   variables_v_line_cd        IN GIIS_INTM_SPECIAL_RATE.LINE_CD%TYPE,
   variables_v_subline_cd    IN GIIS_INTM_SPECIAL_RATE.SUBLINE_CD%TYPE
)IS
 v_intm_no     NUMBER(5)      := p_intm_no_to;
 v_iss_cd      VARCHAR2(2)    := p_iss_cd_from;  
 V_line_cd     VARCHAR2(2)    := variables_v_line_cd;
 v_subline_cd  VARCHAR2(7)    := variables_v_subline_cd;
    p_where       VARCHAR2(3000); --used to handle the condition used in the set_block_property    
BEGIN
 /** Created by : marion 02.04.2010
     Description: A database procedure for copying the rates maintained based on filters provided*/
 IF p_intm_no_from IS NULL AND p_intm_no_to IS NULL THEN
    v_msg_alert := 1;  
--    msg_alert('Please specify intermediary to copy from and to copy to.', 'I', TRUE);
 ELSIF p_intm_no_from IS NULL THEN
    v_msg_alert := 2;
--    msg_alert('Please specify intermediary to copy from.', 'I', TRUE);
  ELSIF p_intm_no_to IS NULL THEN
    v_msg_alert := 3; 
--    msg_alert('Please specify intermediary to copy to.', 'I', TRUE);
  END IF;
-- insert condition varies by input parameters   
-- by iss code, line code and subline code
IF p_iss_cd_from IS NOT NULL AND p_line_cd IS NOT NULL AND p_subline_cd IS NOT NULL THEN 
  FOR C IN (
    SELECT peril_cd,rate
      FROM GIIS_INTM_SPECIAL_RATE
     WHERE intm_no    = p_intm_no_from
       AND iss_cd     = p_iss_cd_from 
       AND line_cd    = p_line_cd 
       AND subline_cd = p_subline_cd
       AND peril_cd NOT IN (SELECT peril_cd
                    FROM GIIS_INTM_SPECIAL_RATE
                  WHERE intm_no    = p_intm_no_to
                               AND iss_cd     = p_iss_cd_from  -- p_iss_cd_to
                               AND line_cd    = p_line_cd      -- variables.v_line_cd
                               AND subline_cd = p_subline_cd   -- variables.v_subline_cd                             
                           ))
    LOOP
   INSERT INTO GIIS_INTM_SPECIAL_RATE
      (intm_no,iss_cd,line_cd,subline_cd,peril_cd,rate,override_tag,user_id,last_update) 
    VALUES
      (p_intm_no_to,p_iss_cd_from/*p_iss_cd_to*/,p_line_cd /*variables.v_line_cd*/ ,p_subline_cd
       /*variables.v_subline_cd*/,C.peril_cd,/*p_giis_int_spe_rt_dtl_rate*/c.rate,
       p_giis_int_sp_rt_dtl_ovde_tg,p_giis_int_spe_rt_dtl_user_id,
       p_giis_int_spe_rt_dtl_last_upd);
  END LOOP;
 -- by iss code and line_cd
ELSIF p_iss_cd_from IS NOT NULL AND p_line_cd IS NOT NULL AND p_subline_cd IS NULL THEN
  FOR C IN (
    SELECT peril_cd,rate, subline_cd
      FROM GIIS_INTM_SPECIAL_RATE
     WHERE intm_no    = p_intm_no_from
       AND iss_cd     = p_iss_cd_from 
       AND line_cd    = p_line_cd 
       AND peril_cd NOT IN (SELECT peril_cd
                    FROM GIIS_INTM_SPECIAL_RATE
                  WHERE intm_no    = p_intm_no_to
                               AND iss_cd     = p_iss_cd_from  -- p_iss_cd_to
                               AND line_cd    = p_line_cd      -- variables.v_line_cd
                           ))
                                             
  LOOP
   v_subline_cd := C.subline_cd;  
   INSERT INTO GIIS_INTM_SPECIAL_RATE
      (intm_no,iss_cd,line_cd,subline_cd,peril_cd,rate,override_tag,user_id,last_update) 
    VALUES
      (p_intm_no_to,p_iss_cd_from/*p_iss_cd_to*/,p_line_cd /*variables.v_line_cd*/ ,v_subline_cd
       /*variables.v_subline_cd*/,C.peril_cd,/*p_giis_int_spe_rt_dtl_rate*/c.rate,
       p_giis_int_sp_rt_dtl_ovde_tg,p_giis_int_spe_rt_dtl_user_id,
       p_giis_int_spe_rt_dtl_last_upd);
  END LOOP;
-- by line_cd and subline_cd
ELSIF p_iss_cd_from IS NULL AND p_line_cd IS NOT NULL AND p_subline_cd IS NOT NULL THEN
  FOR C IN (
    SELECT peril_cd,rate, subline_cd, iss_cd
      FROM GIIS_INTM_SPECIAL_RATE
     WHERE intm_no    = p_intm_no_from
       AND line_cd     = p_line_cd
       AND subline_cd    = p_subline_cd 
       AND peril_cd NOT IN (SELECT peril_cd
                    FROM GIIS_INTM_SPECIAL_RATE
                  WHERE intm_no    = p_intm_no_to
                               AND line_cd     = p_line_cd  
                               AND subline_cd    = p_subline_cd      
                           ))
                                             
  LOOP  
   INSERT INTO GIIS_INTM_SPECIAL_RATE
      (intm_no,iss_cd,line_cd,subline_cd,peril_cd,rate,override_tag,user_id,last_update) 
    VALUES
      (p_intm_no_to,C.iss_cd/*p_iss_cd_to*/,p_line_cd /*variables.v_line_cd*/ ,p_subline_cd
       /*variables.v_subline_cd*/,C.peril_cd,/*p_giis_int_spe_rt_dtl_rate*/c.rate,
       p_giis_int_sp_rt_dtl_ovde_tg,p_giis_int_spe_rt_dtl_user_id,
       p_giis_int_spe_rt_dtl_last_upd);
  END LOOP;
-- by iss code
ELSIF p_iss_cd_from IS NOT NULL AND p_line_cd IS NULL AND p_subline_cd IS NULL THEN 
  FOR C IN (
    SELECT peril_cd,rate, line_cd, subline_cd
      FROM GIIS_INTM_SPECIAL_RATE
     WHERE intm_no    = p_intm_no_from
       AND iss_cd     = p_iss_cd_from 
    AND peril_cd NOT IN (SELECT peril_cd
                    FROM GIIS_INTM_SPECIAL_RATE
                  WHERE intm_no    = p_intm_no_to
                               AND iss_cd     = p_iss_cd_from  -- p_iss_cd_to
                            ))                
                           
  LOOP
    v_line_cd := C.line_cd;
    v_subline_cd := C.subline_cd; 
   INSERT INTO GIIS_INTM_SPECIAL_RATE
      (intm_no,iss_cd,line_cd,subline_cd,peril_cd,rate,override_tag,user_id,last_update) 
    VALUES
      (p_intm_no_to,p_iss_cd_from/*p_iss_cd_to*/,v_line_cd /*variables.v_line_cd*/ ,v_subline_cd
       /*variables.v_subline_cd*/,C.peril_cd,/*p_giis_int_spe_rt_dtl_rate*/c.rate,
       p_giis_int_sp_rt_dtl_ovde_tg,p_giis_int_spe_rt_dtl_user_id,
       p_giis_int_spe_rt_dtl_last_upd);
  END LOOP;
-- by line_cd
ELSIF p_iss_cd_from IS NULL AND p_line_cd IS NOT NULL AND p_subline_cd IS NULL THEN 
  FOR C IN (
    SELECT peril_cd,rate, line_cd, subline_cd, iss_cd
      FROM GIIS_INTM_SPECIAL_RATE
     WHERE intm_no    = p_intm_no_from
       AND line_cd     = p_line_cd 
    AND peril_cd NOT IN (SELECT peril_cd
                    FROM GIIS_INTM_SPECIAL_RATE
                  WHERE intm_no    = p_intm_no_to
                               AND line_cd     = p_line_cd  
                                      ))                
                           
  LOOP
    v_iss_cd  := C.iss_cd;
    v_line_cd := C.line_cd;
    v_subline_cd := C.subline_cd; 
   INSERT INTO GIIS_INTM_SPECIAL_RATE
      (intm_no,iss_cd,line_cd,subline_cd,peril_cd,rate,override_tag,user_id,last_update) 
    VALUES
      (p_intm_no_to,v_iss_cd/*p_iss_cd_to*/,v_line_cd /*variables.v_line_cd*/ ,v_subline_cd
       /*variables.v_subline_cd*/,C.peril_cd,/*p_giis_int_spe_rt_dtl_rate*/c.rate,
       p_giis_int_sp_rt_dtl_ovde_tg,p_giis_int_spe_rt_dtl_user_id,
       p_giis_int_spe_rt_dtl_last_upd);
  END LOOP;  
-- all  
ELSIF p_iss_cd_from IS NULL AND p_line_cd IS NULL AND p_subline_cd IS NULL THEN 
  FOR C IN (
    SELECT peril_cd,rate, iss_cd, line_cd, subline_cd
      FROM GIIS_INTM_SPECIAL_RATE
     WHERE intm_no    = p_intm_no_from
       AND peril_cd NOT IN (SELECT peril_cd
                    FROM GIIS_INTM_SPECIAL_RATE
                  WHERE intm_no    = p_intm_no_to
                            ))                       
  LOOP
    v_iss_cd     := C.iss_cd;
    v_line_cd    := C.line_cd;
    v_subline_cd := C.subline_cd;
   INSERT INTO GIIS_INTM_SPECIAL_RATE
      (intm_no,iss_cd,line_cd,subline_cd,peril_cd,rate,override_tag,user_id,last_update) 
    VALUES
      (p_intm_no_to,v_iss_cd/*p_iss_cd_to*/,v_line_cd /*variables.v_line_cd*/ ,v_subline_cd
       /*variables.v_subline_cd*/,C.peril_cd,/*p_giis_int_spe_rt_dtl_rate*/c.rate,
       p_giis_int_sp_rt_dtl_ovde_tg,p_giis_int_spe_rt_dtl_user_id,
       p_giis_int_spe_rt_dtl_last_upd);
  END LOOP;
END IF;

  -- end of C
 COMMIT;
   p_PARAMETER_COPIED := 'Y';
   p_PARAMETER_WHERE:='intm_no ='||v_intm_no||' and '||
                 'iss_cd ='||''''||v_iss_cd||''''||' and '||
                  'line_cd='||''''||v_line_cd||''''||' and '||
                  'subline_cd ='||''''||v_subline_cd||'''';
END;-- end of main
/



CREATE OR REPLACE PACKAGE BODY CPI.Giis_Geog_Class_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS006 
  RECORD GROUP NAME: CGFK$B340_DSP_GEOG_DESC 
***********************************************************************************/

  FUNCTION get_geog_list(p_par_id GIPI_WVES_AIR.par_id%TYPE)
    RETURN geog_list_tab PIPELINED IS
    
    v_geog         geog_list_type;

  BEGIN
    FOR i IN (
        SELECT a.geog_desc, a.geog_cd, substr(b.rv_meaning,1,20) type ,a.class_type
          FROM GIIS_GEOG_CLASS a, CG_REF_CODES b 
         WHERE a.class_type = b.rv_low_value 
           AND b.rv_domain  = 'GIIS_GEOG_CLASS.CLASS_TYPE' 
           AND class_type in (SELECT vessel_flag 
                                     FROM GIIS_VESSEL
                                 WHERE vessel_cd IN (SELECT vessel_cd 
                                                            FROM GIPI_WVES_AIR 
                                                      WHERE par_id = p_par_id))
		 ORDER BY upper(geog_desc))
    LOOP
        v_geog.geog_desc    := upper(i.geog_desc ||' - '|| i.type);
        v_geog.geog_cd      := i.geog_cd;
        v_geog.type         := i.type;
		v_geog.class_type	:= i.class_type;
      PIPE ROW(v_geog);
    END LOOP;
  
    RETURN;
  END get_geog_list;


/********************************** FUNCTION 1 ************************************
  MODULE: GIIMM002 
  RECORD GROUP NAME: GEOG_DESC 
***********************************************************************************/

  FUNCTION get_geog2_list(p_quote_id    GIPI_QUOTE_VES_AIR.quote_id%TYPE)
    RETURN geog_list_tab PIPELINED IS
    
    v_geog         geog_list_type;

  BEGIN
    FOR i IN (
        SELECT a.geog_desc geog_desc, a.geog_cd geog_cd, substr(b.rv_meaning,1,20) type ,a.class_type
          FROM GIIS_GEOG_CLASS a, CG_REF_CODES b 
         WHERE a.class_type = b.rv_low_value 
           AND b.rv_domain = 'GIIS_GEOG_CLASS.CLASS_TYPE' 
           AND class_type IN (SELECT vessel_flag 
                                FROM GIIS_VESSEL c 
                               WHERE c.vessel_cd IN (SELECT vessel_cd 
                                                       FROM GIPI_QUOTE_VES_AIR
                                                      WHERE quote_id = p_quote_id)) 
         ORDER BY upper(b.rv_meaning))
    LOOP
        v_geog.geog_desc    := i.geog_desc;
        v_geog.geog_cd      := i.geog_cd;
        v_geog.type         := i.type;
		v_geog.class_type	:= i.class_type;
      PIPE ROW(v_geog);
    END LOOP;
  
    RETURN;
  END;  
  

  FUNCTION get_all_geog_list 
    RETURN geog_list_tab PIPELINED IS
  
    v_geog         geog_list_type;

  BEGIN
    FOR i IN (
        SELECT a.geog_desc, a.geog_cd, substr(b.rv_meaning,1,20) type ,a.class_type
          FROM GIIS_GEOG_CLASS a
              ,CG_REF_CODES    b 
         WHERE a.class_type = b.rv_low_value 
           AND b.rv_domain  = 'GIIS_GEOG_CLASS.CLASS_TYPE' 
         ORDER BY upper(a.geog_desc))
    LOOP
        v_geog.geog_desc 	:= i.geog_desc;
        v_geog.geog_cd   	:= i.geog_cd;
        v_geog.type      	:= i.type;
		v_geog.class_type	:= i.class_type;
      PIPE ROW(v_geog);
    END LOOP;
  
    RETURN;
  END get_all_geog_list;    


/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  August 09, 2010
**  Reference By :  (GIPIS068 - Endt Marine Cargo Item Information) 
**  Description  : Function to get geog list of previous policy/ies. 
*/       
  FUNCTION get_endt_geog_list (p_par_id GIPI_WPOLBAS.par_id%TYPE)
    RETURN geog_list_tab PIPELINED IS
    
    v_geog geog_list_type;
    
  BEGIN
    FOR i IN (
      SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
        FROM GIPI_WPOLBAS
       WHERE par_id = p_par_id)
    LOOP   
      FOR j IN (
        SELECT a.geog_desc, a.geog_cd, a.class_type,
               SUBSTR (b.rv_meaning, 1, 20) type
          FROM giis_geog_class a, cg_ref_codes b
         WHERE a.class_type = b.rv_low_value
           AND b.rv_domain = 'GIIS_GEOG_CLASS.CLASS_TYPE'
           AND class_type IN (SELECT vessel_flag
                                FROM giis_vessel c
                               WHERE c.vessel_cd IN (SELECT vessel_cd
                                                       FROM gipi_wves_air
                                                      WHERE par_id = p_par_id)
                                  OR vessel_cd IN (SELECT vessel_cd
                                                     FROM gipi_ves_air a, gipi_polbasic b
                                                    WHERE line_cd     = i.line_cd
                                                      AND subline_cd  = i.subline_cd
                                                      AND iss_cd      = i.iss_cd
                                                      AND issue_yy    = i.issue_yy
                                                      AND pol_seq_no  = i.pol_seq_no
                                                      AND renew_no    = i.renew_no
                                                      AND a.policy_id = b.policy_id))
         ORDER BY b.rv_meaning)
      LOOP
        v_geog.geog_cd    := j.geog_cd;
        v_geog.geog_desc  := j.geog_desc;
        v_geog.type       := j.type;
        v_geog.class_type := j.class_type;
        PIPE ROW(v_geog);         
      END LOOP;
      
      EXIT;
    END LOOP;
    RETURN;
  END get_endt_geog_list;
  
END Giis_Geog_Class_Pkg;
/



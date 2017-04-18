DROP PROCEDURE CPI.INITIALIZE_PARAMETERS_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Initialize_Parameters_Gipis002
  (cg$ctrl_date_format IN OUT VARCHAR2,
   variables_lc_MH IN OUT VARCHAR2,
   variables_lc_AV IN OUT VARCHAR2,
   variables_lc_MC IN OUT VARCHAR2,
   variables_lc_AC IN OUT VARCHAR2,
   variables_lc_FI IN OUT VARCHAR2,
   variables_lc_MN IN OUT VARCHAR2,
   variables_lc_CA IN OUT VARCHAR2,
   variables_lc_EN IN OUT VARCHAR2,
   variables_v_ri_cd IN OUT VARCHAR2,
   variables_subline_bbi IN OUT VARCHAR2,
   variables_subline_MI IN OUT VARCHAR2,
   variables_subline_MOP IN OUT VARCHAR2,
   variables_v_advance_booking  IN OUT VARCHAR2,
   variables_dflt_takeup_term IN OUT VARCHAR2,
   var_dflt_takeup_term_desc IN OUT VARCHAR2,
   variables_override_takeup_term IN OUT VARCHAR2) IS
   v_param_value_v  GIIS_PARAMETERS.param_value_v%TYPE;
BEGIN
  FOR A IN ( SELECT param_value_v 
             FROM GIIS_PARAMETERS 
             WHERE param_name LIKE '%DATE_FORMAT%') LOOP
      
     v_param_value_v      :=  A.param_value_v;
     cg$ctrl_date_format :=  A.param_value_v;
     --SET_ITEM_PROPERTY('b540.incept_date', FORMAT_MASK, v_param_value_v);
     --SET_ITEM_PROPERTY('b540.expiry_date', FORMAT_MASK, v_param_value_v);
     EXIT;
  END LOOP;
  
  FOR A1 IN (SELECT  A.param_value_v  a_param_value_v,
                     b.param_value_v  b_param_value_v,
                     c.param_value_v  c_param_value_v,
                     d.param_value_v  d_param_value_v,
                     e.param_value_v  e_param_value_v,
                     f.param_value_v  f_param_value_v,
                     g.param_value_v  g_param_value_v,
                     h.param_value_v  h_param_value_v
               FROM  GIIS_PARAMETERS A,
                     GIIS_PARAMETERS b,
                     GIIS_PARAMETERS c,
                     GIIS_PARAMETERS d,
                     GIIS_PARAMETERS e,
                     GIIS_PARAMETERS f,
                     GIIS_PARAMETERS g,
                     GIIS_PARAMETERS h
              WHERE  A.param_name LIKE 'LINE_CODE_MH'
                AND  b.param_name LIKE 'LINE_CODE_AV'
                AND  c.param_name LIKE 'LINE_CODE_MC'
                AND  d.param_name LIKE 'LINE_CODE_AC'
                AND  e.param_name LIKE 'LINE_CODE_FI'
                AND  f.param_name LIKE 'LINE_CODE_MN'
                AND  g.param_name LIKE 'LINE_CODE_CA'
                AND  h.param_name LIKE 'LINE_CODE_EN') LOOP
     variables_lc_MH  := a1.a_param_value_v;
     variables_lc_AV  := a1.b_param_value_v;
     variables_lc_MC  := a1.c_param_value_v;
     variables_lc_AC  := a1.d_param_value_v;
     variables_lc_FI  := a1.e_param_value_v;
     variables_lc_MN  := a1.f_param_value_v;
     variables_lc_CA  := a1.g_param_value_v;
     variables_lc_EN  := a1.h_param_value_v;
     EXIT;
  END LOOP;

  FOR R IN (SELECT  param_value_v
              FROM  GIIS_PARAMETERS
             WHERE  param_name LIKE 'ISS_CD_RI') LOOP
    variables_v_ri_cd := r.param_value_v;
    EXIT;
  END LOOP;

  FOR B IN (SELECT  param_value_v
              FROM  GIIS_PARAMETERS
             WHERE  param_name LIKE 'BANKERS BLANKET INSURANCE') LOOP
    variables_subline_bbi := b.param_value_v;
    EXIT;
  END LOOP;
  
  FOR C IN (SELECT  param_value_v
              FROM  GIIS_PARAMETERS
             WHERE  param_name LIKE 'MEDICAL INSURANCE') LOOP
    variables_subline_MI := C.param_value_v;
    EXIT;
  END LOOP;           
             
  FOR D IN (SELECT  param_value_v
              FROM  GIIS_PARAMETERS
             WHERE  param_name LIKE 'MN_SUBLINE_MOP') LOOP
    variables_subline_MOP := D.param_value_v;
    EXIT;
  END LOOP;
           
--BETH 03092000 determined if advance booking date should be allow
--     by deriving the value of param_name 'ALLOW_BOOKING_IN_ADVANCE'
--     from giis_parameters and  assigning it on variable v_advance_booking
  variables_v_advance_booking := 'N';
  FOR E IN (SELECT param_value_v
              FROM GIIS_PARAMETERS
             WHERE param_name = 'ALLOW_BOOKING_IN_ADVANCE')
  LOOP
      variables_v_advance_booking := E.param_value_v;
  END LOOP;
/*  
  IF variables.v_advance_booking = 'Y' THEN
       SET_LOV_PROPERTY('BOOKED', GROUP_NAME,'BOOKED2');
  ELSE
     SET_LOV_PROPERTY('BOOKED', GROUP_NAME,'BOOKED');
  END IF;        
*/  
  --Vincent 11162007: get the default takeup_term
  FOR A IN (SELECT param_value_v
              FROM GIIS_PARAMETERS
             WHERE param_name = 'TAKEUP_TERM')
  LOOP
      variables_dflt_takeup_term := A.param_value_v; 
        FOR rec IN (SELECT takeup_term_desc
                      FROM GIIS_TAKEUP_TERM
                     WHERE takeup_term = variables_dflt_takeup_term)
        LOOP
            var_dflt_takeup_term_desc := rec.takeup_term_desc;
        END LOOP;      
      EXIT;
  END LOOP;    
      
  --Vincent 11192007: get the value of parameter OVERRIDE_TAKEUP_TERM
  variables_override_takeup_term := Giisp.v('OVERRIDE_TAKEUP_TERM');
END;
/



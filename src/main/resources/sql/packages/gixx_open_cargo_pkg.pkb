CREATE OR REPLACE PACKAGE BODY CPI.GIXX_OPEN_CARGO_PKG 
AS
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 11, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves open cargo  list
  */
  FUNCTION get_open_cargo_list(
        p_extract_id    gixx_open_cargo.extract_id%TYPE,
        p_geog_cd       gixx_open_cargo.geog_cd%TYPE
  ) RETURN open_cargo_tab PIPELINED
  IS
    v_open_cargo    open_cargo_type;
  BEGIN
    FOR rec IN (SELECT extract_id, geog_cd,
                       cargo_class_cd, rec_flag
                  FROM gixx_open_cargo
                 WHERE extract_id = p_extract_id
                   AND geog_cd = p_geog_cd)
    LOOP
        v_open_cargo.extract_id := rec.extract_id;
        v_open_cargo.geog_cd := rec.geog_cd;
        v_open_cargo.cargo_class_cd := rec.cargo_class_cd;
        v_open_cargo.rec_flag := rec.rec_flag;
        
        FOR a IN (SELECT cargo_class_desc
                    FROM giis_cargo_class
                   WHERE cargo_class_cd = rec.cargo_class_cd)
        LOOP
            v_open_cargo.cargo_class_desc := a.cargo_class_desc;
        END LOOP;
        
        PIPE ROW(v_open_cargo);
    END LOOP;
    
  END get_open_cargo_list;

END GIXX_OPEN_CARGO_PKG;
/



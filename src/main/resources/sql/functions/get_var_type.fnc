DROP FUNCTION CPI.GET_VAR_TYPE;

CREATE OR REPLACE FUNCTION CPI.get_var_type(
    v_is_gpa                VARCHAR2,
    pg_dsp_peril_type       giis_peril.peril_type%TYPE,
    ig_line_cd              giex_itmperil_grouped.line_cd%TYPE,
    pg_peril_cd             giex_itmperil_grouped.peril_cd%TYPE,
    p_validate_sw           VARCHAR2,
    p_old_type              giis_peril.peril_type%TYPE,
    p_dsp_peril_type        giis_peril.peril_type%TYPE,
    i_line_cd               giex_itmperil.line_cd%TYPE,
    i_subline_cd            giex_itmperil.subline_cd%TYPE,
    p_peril_cd              giis_peril.peril_type%TYPE
)
RETURN VARCHAR2
IS
    var_type            giis_peril.peril_type%TYPE;
    v_dsp_peril_type    giis_peril.peril_type%TYPE;
    vg_dsp_peril_type   giis_peril.peril_type%TYPE;
BEGIN
    v_dsp_peril_type    :=  p_dsp_peril_type;
    IF v_is_gpa = 'Y' THEN
        /* Determine peril type of peril being processed to determine whether
        ** we would consider its tsi amount as part of the tsi computation
        ** in the item level.
        */
        IF pg_dsp_peril_type IS NULL THEN
          FOR A1 IN (
             SELECT   peril_type
               FROM   giis_peril
              WHERE   line_cd    = ig_line_cd
                AND   subline_cd IS NULL
                AND   peril_cd   = pg_peril_cd) 
          LOOP
                vg_dsp_peril_type :=  A1.peril_type;
          END LOOP;
        END IF;
        IF p_validate_sw  = 'Y' THEN
          var_type := nvl(p_old_type,vg_dsp_peril_type);
        ELSE 
          var_type := vg_dsp_peril_type;
        END IF;
    ELSE    
        /* Determine peril type of peril being processed to determine whether
        ** we would consider its tsi amount as part of the tsi computation
        ** in the item level.
        */
        IF p_dsp_peril_type IS NULL THEN
         FOR A1 IN (
             SELECT   peril_type
               FROM   giis_peril
              WHERE   line_cd    = i_line_cd
                AND  (subline_cd = i_subline_cd OR
                      subline_cd IS NULL)
                AND   peril_cd   = p_peril_cd) 
          LOOP
            v_dsp_peril_type :=  A1.peril_type;
          END LOOP;
        END IF;
        IF p_validate_sw  = 'Y' THEN
          var_type := nvl(p_old_type,v_dsp_peril_type);
        ELSE
          var_type := v_dsp_peril_type;
        END IF;
    END IF;
    
   RETURN(var_type);
END;
/



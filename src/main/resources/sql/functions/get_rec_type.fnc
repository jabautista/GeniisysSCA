DROP FUNCTION CPI.GET_REC_TYPE;

CREATE OR REPLACE FUNCTION CPI.get_rec_type (p_rec_id VARCHAR2)
RETURN VARCHAR2 AS
  v_rec_desc  giis_recovery_type.rec_type_desc%TYPE;
BEGIN
  FOR cd IN (SELECT rec_type_cd
                FROM gicl_clm_recovery b
               WHERE recovery_id = p_rec_id)
  LOOP
    FOR rec IN (SELECT rec_type_desc
                  FROM giis_recovery_type
                 WHERE rec_type_cd = cd.rec_type_cd)
    LOOP
      v_rec_desc := rec.rec_type_desc;
      EXIT;
    END LOOP;
  END LOOP;
  RETURN (v_rec_desc);
END;
/



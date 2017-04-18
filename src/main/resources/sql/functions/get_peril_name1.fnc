DROP FUNCTION CPI.GET_PERIL_NAME1;

CREATE OR REPLACE FUNCTION CPI.get_peril_name1 (p_claim_id NUMBER, p_peril_cd VARCHAR2)
RETURN VARCHAR2 AS
  v_peril_name giis_peril.peril_name%TYPE;
  v_line_cd    gicl_clm_recovery.line_cd%TYPE;
BEGIN
  FOR rec IN (SELECT line_cd
                FROM gicl_clm_recovery
               WHERE claim_id = p_claim_id)
  LOOP
    v_line_cd := rec.line_cd;
    FOR NAME IN (SELECT peril_name
                   FROM giis_peril
                  WHERE line_cd = v_line_cd
                    AND peril_cd = p_peril_cd)
    LOOP
      v_peril_name := NAME.peril_name;
      EXIT;
    END LOOP;
  END LOOP;
  RETURN (v_peril_name);
END;
/



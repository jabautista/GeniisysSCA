DROP FUNCTION CPI.GET_FROM_DATE_GIPIR025;

CREATE OR REPLACE FUNCTION CPI.GET_FROM_DATE_GIPIR025 (
    p_policy_id     GIPI_POLBASIC.policy_id%TYPE,
    p_fromdate      GIPI_POLBASIC.eff_date%TYPE
  ) RETURN DATE IS
  v_pol_line_cd    giis_line.line_cd%TYPE := NULL;
  mc_line_cd            giis_line.line_cd%TYPE := NULL;
  mn_line_cd            giis_line.line_cd%TYPE := NULL;
  v_etd						gipi_cargo.etd%TYPE :=  NULL;
BEGIN
    FOR param_rec IN (
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_MC')
    LOOP
        mc_line_cd := param_rec.param_value_v;
    EXIT;
    END LOOP;

    FOR param_rec IN (
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_MN')
    LOOP
        mn_line_cd := param_rec.param_value_v;
    EXIT;
    END LOOP;

    FOR line_rec in (
      SELECT line_cd 
        FROM gipi_polbasic
       WHERE policy_id = p_policy_id)
    LOOP
        v_pol_line_cd := line_rec.line_cd;
    EXIT;
    END LOOP;
    IF mc_line_cd = v_pol_line_cd THEN
        RETURN (p_fromdate);
    ELSIF mn_line_cd = v_pol_line_cd THEN
        FOR etd IN (SELECT etd
                  FROM gipi_cargo
                         WHERE policy_id = p_policy_id)
        LOOP
            v_etd := etd.etd;
            EXIT;
        END LOOP;
        RETURN (v_etd);
    ELSE
        RETURN (p_fromdate);
    END IF;
    RETURN NULL;
END GET_FROM_DATE_GIPIR025;
/



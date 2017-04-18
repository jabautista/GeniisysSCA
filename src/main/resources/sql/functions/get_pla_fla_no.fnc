DROP FUNCTION CPI.GET_PLA_FLA_NO;

CREATE OR REPLACE FUNCTION CPI.GET_PLA_FLA_NO (
     pla_fla_flag VARCHAR2, --values are either PLA or FLA
     pla_fla_id NUMBER 
)
    RETURN VARCHAR2
IS 
    pla_fla_no VARCHAR2(50);
BEGIN
    IF LTRIM ( RTRIM ( UPPER ( pla_fla_flag ) ) ) = 'PLA' THEN --for PLA
        SELECT line_cd||'-'||LPAD(la_yy, 2, 0)||'-'||LPAD(pla_seq_no, 7, 0)
          INTO pla_fla_no
            FROM gicl_advs_pla
         WHERE pla_id = pla_fla_id;
    ELSIF LTRIM ( RTRIM ( UPPER ( pla_fla_flag ) ) ) = 'FLA' THEN --for FLA
        SELECT line_cd||'-'||LPAD(la_yy, 2, 0)||'-'||LPAD(fla_seq_no, 7, 0)
          INTO pla_fla_no
            FROM gicl_advs_fla
         WHERE fla_id = pla_fla_id;
    END IF;
    RETURN pla_fla_no;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN TOO_MANY_ROWS THEN
        RETURN NULL;
END GET_PLA_FLA_NO;
/



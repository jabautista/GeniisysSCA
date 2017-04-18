DROP FUNCTION CPI.GET_ENDT_TAX2_GIPIS091;

CREATE OR REPLACE FUNCTION CPI.get_endt_tax2_gipis091 (
    p_policy_id     GIPI_POLBASIC.policy_id%TYPE
) RETURN VARCHAR2 IS
    v_endt_tax2     VARCHAR2(1) := 'N';
BEGIN
     /*
   **  Created by      : D.Alcantara
   **  Date Created    : 04.18.2012
   **  Reference By    : GIPI091
   **  Description     : retrieve endt_tax
   */
    FOR B IN (SELECT endt_tax
                    FROM gipi_endttext gend, gipi_polbasic gpol
                   WHERE gpol.pack_policy_id = p_policy_id
                   AND   gend.policy_id = gpol.policy_id) 
        LOOP
          v_endt_tax2 := NVL(b.endt_tax, 'N');
          EXIT;
        END LOOP;
    RETURN v_endt_tax2;
END get_endt_tax2_gipis091;
/



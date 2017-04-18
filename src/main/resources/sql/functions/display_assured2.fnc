DROP FUNCTION CPI.DISPLAY_ASSURED2;

CREATE OR REPLACE FUNCTION CPI.Display_Assured2 (p_assd_no   GIIS_ASSURED.assd_no%TYPE)
RETURN VARCHAR2 AS
    v_name     VARCHAR2(600);
BEGIN
	-- retrives the assured name for policy docs based on the assd_no or old_assd_no
	-- d.alcantara, 05-25-2012
    FOR i IN (
        SELECT DECODE(A020.designation, NULL, A020.assd_name||' '
               ||A020.assd_name2, A020.designation ||' '||A020.assd_name
               ||' '||A020.assd_name2) ASSD_NAME
          FROM GIIS_ASSURED A020
         WHERE assd_no = p_assd_no
    ) LOOP
        v_name := i.ASSD_NAME;
        EXIT;
    END LOOP;
    RETURN v_name;
END Display_Assured2;
/



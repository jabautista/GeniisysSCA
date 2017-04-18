DROP FUNCTION CPI.GET_SIGNATORY_ID;

CREATE OR REPLACE FUNCTION CPI.Get_Signatory_Id (p_signatory_id IN giis_signatory_names.signatory_id%TYPE)
                  RETURN VARCHAR2 AS
/* Created by Pia 10/10/01.
** To sort by signatory, using signatory_id; where signatory is not a base-table_item.
** Used in GICLS181.*/
CURSOR c1 (p_signatory_id IN giis_signatory_names.signatory_id%TYPE) IS
   SELECT a.signatory
     FROM giis_signatory_names a
    WHERE a.signatory_id = p_signatory_id;

 p_signatory_name  giis_signatory_names.signatory%TYPE;
BEGIN
  OPEN c1 (p_signatory_id);
  FETCH c1 INTO p_signatory_name;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_signatory_name;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/



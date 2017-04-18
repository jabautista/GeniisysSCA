DROP FUNCTION CPI.GET_LINECD;

CREATE OR REPLACE FUNCTION CPI.Get_Linecd (p_line_cd IN giis_line.line_cd%TYPE)
                  RETURN VARCHAR2 AS

/* Created by Pia 10/10/01.
** To sort by line_name, using line_cd; where line_name is not a base-table item.
** Used in GICLS180 */
CURSOR c1 (p_line_cd IN giis_line.line_cd%TYPE) IS
   SELECT a.line_name
     FROM giis_line a
    WHERE a.line_cd = p_line_cd;

 p_line_name  giis_line.line_name%TYPE;
BEGIN
  OPEN c1 (p_line_cd);
  FETCH c1 INTO p_line_name;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_line_name;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/



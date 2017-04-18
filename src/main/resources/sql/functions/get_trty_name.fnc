DROP FUNCTION CPI.GET_TRTY_NAME;

CREATE OR REPLACE FUNCTION CPI.get_trty_name (
                         p_line_cd     IN giis_dist_share.line_cd%TYPE,
                         p_share_cd  IN giis_dist_share.share_cd%TYPE)
         RETURN VARCHAR2 AS
CURSOR c1 (p_line_cd   IN giis_dist_share.line_cd%TYPE,
           p_share_cd  IN giis_dist_share.share_cd%TYPE) IS
/*created by mon 011003
**return trty_name, using line_cd and share_cd;
** where trty_name is not a base-table item.
*/
SELECT trty_name
  FROM giis_dist_share
 WHERE line_cd = p_line_cd
   AND share_cd = p_share_cd;
 p_trty_name         giis_dist_share.trty_name%TYPE;
BEGIN
  OPEN c1 (p_line_cd, p_share_cd);
  FETCH c1 INTO p_trty_name;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_trty_name;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/



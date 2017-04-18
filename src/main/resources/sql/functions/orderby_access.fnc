DROP FUNCTION CPI.ORDERBY_ACCESS;

CREATE OR REPLACE FUNCTION CPI.Orderby_Access (p_axes_tag IN cg_ref_codes.rv_meaning%TYPE)
                  RETURN VARCHAR2 AS
/* Created by Pia 11/20/01.
** To sort by the rv_meaning of access_tag; where the rv_meaning ('user_access field in
** giis_modules_user block is not a base-table item
** Used in GIISS081 */
CURSOR c1 (p_axes_tag IN cg_ref_codes.rv_meaning%TYPE) IS
   SELECT rv_meaning
     FROM cg_ref_codes
    WHERE rv_domain = 'GIIS_MODULES_USER.ACCESS_TAG'
      AND rv_low_value = p_axes_tag;
 p_meaning  cg_ref_codes.rv_meaning%TYPE;
BEGIN
  OPEN c1 (p_axes_tag);
  FETCH c1 INTO p_meaning;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_meaning;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/



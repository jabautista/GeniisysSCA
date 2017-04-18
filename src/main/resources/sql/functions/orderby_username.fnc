DROP FUNCTION CPI.ORDERBY_USERNAME;

CREATE OR REPLACE FUNCTION CPI.Orderby_Username (p_muser_id IN GIIS_USERS.user_id%TYPE)
                  RETURN VARCHAR2 AS
/* Created by Pia 11/20/01.
** To sort by user_name, using module_user_id; where user_name is not a base-table item; not a column in the block
** Used in GIISS081 */
CURSOR c1 (p_muser_id IN GIIS_USERS.user_id%TYPE) IS
   SELECT user_name
     FROM GIIS_USERS
    WHERE user_id = p_muser_id;
 p_user_name  GIIS_USERS.user_name%TYPE;
BEGIN
  OPEN c1 (p_muser_id);
  FETCH c1 INTO p_user_name;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_user_name;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/



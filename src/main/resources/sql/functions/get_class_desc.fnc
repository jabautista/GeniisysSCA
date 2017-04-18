DROP FUNCTION CPI.GET_CLASS_DESC;

CREATE OR REPLACE FUNCTION CPI.Get_Class_Desc (p_payee_class_cd IN giis_payee_class.payee_class_cd%TYPE)
          RETURN VARCHAR2 AS
/* return class_desc from giis_payee_class using payee_class_cd
** by Pia, 1/2/02 */
 CURSOR c1 (p_payee_class_cd IN giis_payee_class.payee_class_cd%TYPE) IS
    SELECT class_desc
      FROM giis_payee_class
     WHERE payee_class_cd = p_payee_class_cd;
    p_class_desc  giis_payee_class.class_desc%TYPE;
 BEGIN
   OPEN c1 (p_payee_class_cd);
   FETCH c1 INTO p_class_desc;
   IF c1%FOUND THEN
     CLOSE c1;
     RETURN p_class_desc;
   ELSE
     CLOSE c1;
     RETURN NULL;
   END IF;
 END;
/



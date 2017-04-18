DROP FUNCTION CPI.GET_PAYEE_NAME;

CREATE OR REPLACE FUNCTION CPI.Get_Payee_Name (p_clmnt_no IN giis_payees.payee_no%TYPE, p_payee_class_cd IN giis_payees.payee_class_cd%TYPE)
          RETURN VARCHAR2 AS
/* return first_, last_ and midle_name from giis_payees using clmnt_no
** (from gicl_clm_clmnt)and payee_class_cd
** by Pia, 1/2/02 */
 CURSOR c1 (p_clmnt_no IN giis_payees.payee_no%TYPE, p_payee_class_cd IN giis_payees.payee_class_cd%TYPE) IS
    SELECT DECODE(payee_first_name,NULL,payee_last_name, payee_last_name||', '||
           payee_first_name ||' '||payee_middle_name) payee
      FROM giis_payees
     WHERE payee_no       = p_clmnt_no
       AND payee_class_cd = p_payee_class_cd;
    p_payee_name  VARCHAR2(300);
 BEGIN
   OPEN c1 (p_clmnt_no, p_payee_class_cd);
   FETCH c1 INTO p_payee_name;
   IF c1%FOUND THEN
     CLOSE c1;
     RETURN p_payee_name;
   ELSE
     CLOSE c1;
     RETURN NULL;
   END IF;
 END;
/



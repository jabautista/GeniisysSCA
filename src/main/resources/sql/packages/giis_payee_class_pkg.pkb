CREATE OR REPLACE PACKAGE BODY CPI.giis_payee_class_pkg
AS
   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.21.2010
   **  Reference By : (GIACS039 - Direct Trans - Input Vat)
   **  Description  : PAYEE_CLS record groups
   */
   FUNCTION get_payee_class_list
      RETURN payee_class_list_tab PIPELINED
   IS
      v_list   payee_class_list_type;
   BEGIN
      FOR i IN (SELECT   a.payee_class_cd, a.class_desc
                    FROM giis_payee_class a
                ORDER BY UPPER (class_desc))
      LOOP
         v_list.payee_class_cd := i.payee_class_cd;
         v_list.class_desc := i.class_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_replace_company_type_list (p_find_text VARCHAR2)
      RETURN payee_class_list_tab PIPELINED
   IS
      v_list   payee_class_list_type;
   BEGIN
      FOR i IN (SELECT class_desc, payee_class_cd
                  FROM giis_payee_class
                 WHERE NVL (eval_sw, 'N') = 'Y'
                   AND UPPER (class_desc) LIKE NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_list.payee_class_cd := i.payee_class_cd;
         v_list.class_desc := i.class_desc;
         PIPE ROW (v_list);
      END LOOP;
   END;
   
   FUNCTION validate_payee_class_cd(
      p_payee_class_cd        giis_payee_class.payee_class_cd%TYPE
   ) RETURN VARCHAR2 AS
      v_class_desc            giis_payee_class.class_desc%TYPE;
   BEGIN
      SELECT class_desc
        INTO v_class_desc 
        FROM giis_payee_class
       WHERE payee_class_cd = p_payee_class_cd;
       
      RETURN v_class_desc; 
   END;
END;
/



CREATE OR REPLACE PACKAGE CPI.giis_payee_class_pkg
AS
   TYPE payee_class_list_type IS RECORD (
      payee_class_cd   giis_payee_class.payee_class_cd%TYPE,
      class_desc       giis_payee_class.class_desc%TYPE
   );

   TYPE payee_class_list_tab IS TABLE OF payee_class_list_type;

   FUNCTION get_payee_class_list
      RETURN payee_class_list_tab PIPELINED;

   FUNCTION get_replace_company_type_list(p_find_text varchar2)
      RETURN payee_class_list_tab PIPELINED;

   FUNCTION validate_payee_class_cd(
      p_payee_class_cd        giis_payee_class.payee_class_cd%TYPE
   ) RETURN VARCHAR2;
   
END;
/



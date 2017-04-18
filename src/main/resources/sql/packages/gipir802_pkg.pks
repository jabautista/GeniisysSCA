CREATE OR REPLACE PACKAGE CPI.gipir802_pkg
AS
   TYPE gipir802_record_type IS RECORD (
      company_name      VARCHAR2 (500),
      company_address   VARCHAR2 (500),
      code              giis_line.line_cd%TYPE,
      line              giis_line.line_name%TYPE,
      PACKAGE           VARCHAR2 (3)
   );

   TYPE gipir802_record_tab IS TABLE OF gipir802_record_type;

   FUNCTION get_gipir802_record (p_user_id giis_users.user_id%TYPE)
      RETURN gipir802_record_tab PIPELINED;
END gipir802_pkg;
/



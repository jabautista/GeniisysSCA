CREATE OR REPLACE PACKAGE CPI.giacs181_pkg
AS
   TYPE line_lov_type IS RECORD (
      line_cd     giri_binder.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   TYPE ri_lov_type IS RECORD (
      ri_cd     giri_binder.ri_cd%TYPE,
      ri_name   giis_reinsurer.ri_name%TYPE
   );

   TYPE ri_lov_tab IS TABLE OF ri_lov_type;

   TYPE giac_dueto_ext_type IS RECORD (
      from_date   VARCHAR2 (20),
      TO_DATE     VARCHAR2 (20)
   );

   TYPE giac_dueto_ext_tab IS TABLE OF giac_dueto_ext_type;

   FUNCTION get_line_lov
      RETURN line_lov_tab PIPELINED;

   FUNCTION get_ri_lov
      RETURN ri_lov_tab PIPELINED;

   FUNCTION validate_print (p_from_date VARCHAR2, p_until_date VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_giac_dueto_ext_params
      RETURN giac_dueto_ext_tab PIPELINED;

   PROCEDURE extract_to_table (
      p_from_date          DATE,
      p_until_date         DATE,
      p_user_id            giis_users.user_id%TYPE,
      p_exist        OUT   VARCHAR2
   );
END;
/



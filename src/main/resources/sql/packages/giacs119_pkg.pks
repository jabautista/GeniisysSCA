CREATE OR REPLACE PACKAGE CPI.giacs119_pkg
AS
   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   TYPE ri_lov_type IS RECORD (
      ri_cd      gicl_advs_fla.ri_cd%TYPE,
      ri_name    giis_reinsurer.ri_name%TYPE,
      ri_sname   giis_reinsurer.ri_sname%TYPE
   );

   TYPE ri_lov_tab IS TABLE OF ri_lov_type;

   FUNCTION get_line_lov
      RETURN line_lov_tab PIPELINED;

   FUNCTION get_ri_lov
      RETURN ri_lov_tab PIPELINED;
END;
/



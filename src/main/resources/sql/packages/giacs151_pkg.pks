CREATE OR REPLACE PACKAGE CPI.giacs151_pkg
AS
   TYPE report_lov_type IS RECORD (
      rep_cd      giac_eom_rep.rep_cd%TYPE,
      rep_title   giac_eom_rep.rep_title%TYPE
   );

   TYPE report_lov_tab IS TABLE OF report_lov_type;

   FUNCTION get_report_lov
      RETURN report_lov_tab PIPELINED;
END;
/



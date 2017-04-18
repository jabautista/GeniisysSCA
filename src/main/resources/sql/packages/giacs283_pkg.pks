CREATE OR REPLACE PACKAGE CPI.GIACS283_PKG
AS

   TYPE giacs283_status_lov_type IS RECORD (
      status_cd           cg_ref_codes.rv_low_value%TYPE,
      status_desc         cg_ref_codes.rv_meaning%TYPE
   ); 

   TYPE giacs283_status_lov_tab IS TABLE OF giacs283_status_lov_type;

   FUNCTION get_giacs283_status_lov
   RETURN giacs283_status_lov_tab PIPELINED;
   
END;
/



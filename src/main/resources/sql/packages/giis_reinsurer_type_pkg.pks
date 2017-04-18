CREATE OR REPLACE PACKAGE CPI.giis_reinsurer_type_pkg
AS
   TYPE get_ri_type_lov_type IS RECORD (
      ri_type        giis_reinsurer_type.ri_type%TYPE,
      ri_type_desc   giis_reinsurer_type.ri_type_desc%TYPE
   );

   TYPE get_ri_type_lov_tab IS TABLE OF get_ri_type_lov_type;

/*  FUNCTION get_ri_type_lov
 *  REMARKS: Get RI Type LOV
 *  BY: Fons 09/18/13     */
   FUNCTION get_ri_type_lov
      RETURN get_ri_type_lov_tab PIPELINED;
END giis_reinsurer_type_pkg;
/



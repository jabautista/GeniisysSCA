CREATE OR REPLACE PACKAGE CPI.giis_ri_status_pkg
AS
   TYPE get_ri_status_lov_type IS RECORD (
      status_cd     giis_ri_status.status_cd%TYPE,
      status_desc   giis_ri_status.status_desc%TYPE
   );

   TYPE get_ri_status_lov_tab IS TABLE OF get_ri_status_lov_type;

/*  FUNCTION get_ri_status_lov
 *  REMARKS: Get RI Status LOV
 *  BY: Fons 09/18/13     */
   FUNCTION get_ri_status_lov
      RETURN get_ri_status_lov_tab PIPELINED;
END giis_ri_status_pkg;
/



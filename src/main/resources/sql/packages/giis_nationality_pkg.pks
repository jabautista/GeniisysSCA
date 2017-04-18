CREATE OR REPLACE PACKAGE CPI.giis_nationality_pkg
AS
/******************************************************************************
   NAME:       giis_nationality_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/14/2011   Irwin Tabisora          1. Created this package.
******************************************************************************/
   TYPE nationality_lov_type IS RECORD (
      nationality_cd     giis_nationality.nationality_cd%TYPE,
      nationality_desc   giis_nationality.nationality_desc%TYPE
   );

   TYPE nationality_lov_tab IS TABLE OF nationality_lov_type;

   FUNCTION get_nationality_list (p_find_text IN VARCHAR2)
      RETURN nationality_lov_tab PIPELINED;
END giis_nationality_pkg;
/



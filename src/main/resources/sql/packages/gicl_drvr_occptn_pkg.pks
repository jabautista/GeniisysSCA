CREATE OR REPLACE PACKAGE CPI.gicl_drvr_occptn_pkg
AS
/******************************************************************************
   NAME:       gicl_drvr_occptn_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/14/2011   Irwin Tabisora          1. Created this package.
******************************************************************************/
   TYPE drvr_occptn_lov_type IS RECORD (
      drvr_occ_cd   gicl_drvr_occptn.drvr_occ_cd%TYPE,
      occ_desc      gicl_drvr_occptn.occ_desc%TYPE
   );

   TYPE drvr_occptn_lov_tab IS TABLE OF drvr_occptn_lov_type;

   FUNCTION drvr_occptn_list (p_find_text IN VARCHAR2)
      RETURN drvr_occptn_lov_tab PIPELINED;
END gicl_drvr_occptn_pkg;
/



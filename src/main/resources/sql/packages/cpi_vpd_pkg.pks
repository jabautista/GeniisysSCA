CREATE OR REPLACE PACKAGE CPI.cpi_vpd_pkg
AS
/*
**Created by totel
**11/21/2008
**To prevent un authorized access on GenIISys table
*/
  FUNCTION vpd_delete_fn (p_Owner VARCHAR2, p_Objname VARCHAR2) RETURN VARCHAR2;
END;
/


DROP PACKAGE CPI.CPI_VPD_PKG;
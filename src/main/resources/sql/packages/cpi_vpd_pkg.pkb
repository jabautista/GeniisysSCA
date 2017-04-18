CREATE OR REPLACE PACKAGE BODY CPI.cpi_vpd_pkg IS
/*
**Created by totel
**11/21/2008
**To prevent un authorized access on GenIISys table
*/
  FUNCTION vpd_delete_fn(p_Owner VARCHAR2, p_Objname VARCHAR2)RETURN VARCHAR2 IS
    v_Predicate VARCHAR2(20) := '1=2';
  BEGIN
    IF USER='CPI' THEN
      v_Predicate := '1=1';
    END IF;
    RETURN v_Predicate;
  END;
END;
/

DROP PACKAGE CPI.CPI_VPD_PKG;
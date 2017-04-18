CREATE OR REPLACE PACKAGE CPI.giacr131_pkg
AS
/*
**Created by: Benedict G. Castillo
**Date Created:07.16.2013
**Description:GIACR131:DIRECT BUSINESS PRODUCTION TAKE UP PER SOURCE OF BUSINESS
*/
   TYPE giacr131_type IS RECORD (
      company_name      VARCHAR2 (100),
      company_address   giac_parameters.param_value_v%TYPE,
      flag              VARCHAR2 (2),
      v_date            VARCHAR2 (100),
      branch            giac_production_ext.branch_name%TYPE,
      source_of_buss    giis_intm_type.intm_desc%TYPE,
      line_name         giac_production_ext.line_name%TYPE,
      subline_name      giac_production_ext.subline_name%TYPE,
      tsi_amt           NUMBER (16, 2),
      prem_amt          NUMBER (16, 2),
      tax_amt           NUMBER (16, 2),
      comm_amt          NUMBER (16, 2)
   );

   TYPE giacr131_tab IS TABLE OF giacr131_type;

   FUNCTION populate_giacr131 (p_date VARCHAR2)
      RETURN giacr131_tab PIPELINED;
END giacr131_pkg;
/



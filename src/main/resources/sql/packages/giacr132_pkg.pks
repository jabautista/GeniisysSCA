CREATE OR REPLACE PACKAGE CPI.giacr132_pkg
AS
/*
**Created by: Benedict G. Castillo
**Date Created: 07.16.2013
**Descritpion: GIACR132 - PRODUCTION TAKE UP PER  SOURCE OF BUSINESS - DETAILED
*/
   TYPE giacr132_type IS RECORD (
      company_name      VARCHAR2 (100),
      company_address   giac_parameters.param_value_v%TYPE,
      flag              VARCHAR2 (2),
      accnt_ent_date    VARCHAR2 (100),
      source_of_buss    giis_intermediary.intm_name%TYPE,
      line_name         giac_production_ext.line_name%TYPE,
      subline_name      giac_production_ext.subline_name%TYPE,
      policy_no         giac_production_ext.policy_no%TYPE,
      spoiled           VARCHAR2 (10),
      tsi_amt           NUMBER (16, 2),
      prem_amt          NUMBER (16, 2),
      comm_amt          NUMBER (16, 2),
      tax_amt           NUMBER (16, 2)
   );

   TYPE giacr132_tab IS TABLE OF giacr132_type;

   FUNCTION populate_giacr132 (p_date VARCHAR2)
      RETURN giacr132_tab PIPELINED;
END giacr132_pkg;
/



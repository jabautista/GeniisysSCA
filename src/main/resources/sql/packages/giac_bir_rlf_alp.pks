CREATE OR REPLACE PACKAGE CPI.giac_bir_rlf_alp
AS
   PROCEDURE map_expanded (
      p_return_month   giac_map_expanded_ext.return_month%TYPE,
      p_return_myear   giac_map_expanded_ext.return_year%TYPE,
      --mikel 02.15.2013; added new parameters to extract records on a montly and yearly basis
      p_return_yyear   giac_map_expanded_ext.return_year%TYPE,
      p_period_tag     giac_map_expanded_ext.period_tag%TYPE
   );

   --added by reymon 07232013 for SAWT report
   PROCEDURE sawt_expanded (
      p_return_month   giac_sawt_ext.return_month%TYPE,
      p_return_myear   giac_sawt_ext.return_year%TYPE,
      p_return_yyear   giac_sawt_ext.return_year%TYPE,
      p_period_tag     giac_sawt_ext.period_tag%TYPE
   );

   PROCEDURE sls_vat (
      p_return_month   giac_relief_sls_ext.return_month%TYPE,
      p_return_myear   giac_relief_sls_ext.return_year%TYPE,
      p_return_yyear   giac_relief_sls_ext.return_year%TYPE,
      p_period_tag     giac_relief_sls_ext.period_tag%TYPE
   );

   FUNCTION get_valid_tin (p_tin VARCHAR2)
      RETURN VARCHAR2;
END;
/



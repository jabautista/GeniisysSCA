CREATE OR REPLACE PACKAGE cpi.gipir948_pkg
AS
/*
** Created By:   Benjo Brito
** Date Created: 07.09.2015
** Description:  Redesign of GIPIR948, also merged reports GIPIR947 and GIPIR947B
**               UW-SPECS-2015-048 | GENQA AFPGEN-IMPLEM SR 4268, 4264, 4577
*/
   TYPE gipir948_header_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      title             VARCHAR2 (100),
      term              VARCHAR2 (200),
      print_page2       VARCHAR2 (1),
      print_page3       VARCHAR2 (1)
   );

   TYPE gipir948_header_tab IS TABLE OF gipir948_header_type;

   TYPE gipir948_details_type IS RECORD (
      range_from     VARCHAR2 (25),
      range_to       VARCHAR2 (25),
      policy_count   gipi_risk_profile.policy_count%TYPE,
      tarf_cd        gipi_risk_profile.tarf_cd%TYPE,
      tarf_desc      VARCHAR2 (100),
      line_cd        gipi_risk_profile.line_cd%TYPE,
      line_name      VARCHAR2 (25),
      subline_cd     gipi_risk_profile.subline_cd%TYPE,
      subline_name   VARCHAR2 (40),
      header1        VARCHAR2 (30),
      header2        VARCHAR2 (30),
      header3        VARCHAR2 (30),
      header4        VARCHAR2 (30),
      header5        VARCHAR2 (30),
      header6        VARCHAR2 (30),
      header7        VARCHAR2 (30),
      header8        VARCHAR2 (30),
      header9        VARCHAR2 (30),
      header10       VARCHAR2 (30),
      header11       VARCHAR2 (30),
      header12       VARCHAR2 (30),
      header13       VARCHAR2 (30),
      header14       VARCHAR2 (30),
      header15       VARCHAR2 (30),
      tsi1           NUMBER,
      tsi2           NUMBER,
      tsi3           NUMBER,
      tsi4           NUMBER,
      tsi5           NUMBER,
      tsi6           NUMBER,
      tsi7           NUMBER,
      tsi8           NUMBER,
      tsi9           NUMBER,
      tsi10          NUMBER,
      tsi11          NUMBER,
      tsi12          NUMBER,
      tsi13          NUMBER,
      tsi14          NUMBER,
      tsi15          NUMBER,
      prem1          NUMBER,
      prem2          NUMBER,
      prem3          NUMBER,
      prem4          NUMBER,
      prem5          NUMBER,
      prem6          NUMBER,
      prem7          NUMBER,
      prem8          NUMBER,
      prem9          NUMBER,
      prem10         NUMBER,
      prem11         NUMBER,
      prem12         NUMBER,
      prem13         NUMBER,
      prem14         NUMBER,
      prem15         NUMBER
   );

   TYPE gipir948_details_tab IS TABLE OF gipir948_details_type;

   FUNCTION get_gipir948_header (
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_param_date      VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN gipir948_header_tab PIPELINED;

   FUNCTION get_gipir948_details (
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_param_date      VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN gipir948_details_tab PIPELINED;
END;
/

CREATE OR REPLACE PUBLIC SYNONYM gipir948_pkg FOR cpi.gipir948_pkg;
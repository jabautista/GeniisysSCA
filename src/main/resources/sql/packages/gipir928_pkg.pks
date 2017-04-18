/*
Created by Apollo Francis A. Cruz
05.21.2015
AFPGEN-IMPLEM-SR  0004366
Matrix Reloaded!

Redesigned version of gipir928_pkg
-to handle displaying of treaties exceeding the page width
-for faster report generation
*/

CREATE OR REPLACE PACKAGE cpi.gipir928_pkg
AS
   TYPE main_type IS RECORD (
      iss_cd            giis_issource.iss_cd%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      line_cd           giis_line.line_cd%TYPE,
      line_name         giis_line.line_name%TYPE,
      dummy_group       VARCHAR2 (100),
      subline_cd        giis_subline.subline_cd%TYPE,
      subline_name      giis_subline.subline_name%TYPE,
      policy_id         gipi_polbasic.policy_id%TYPE,
      policy_no         VARCHAR2 (100),
      peril_cd          giis_peril.peril_cd%TYPE,
      peril_sname       VARCHAR2 (5),
      peril_row_no      NUMBER,
      share_cds         VARCHAR2 (10000),
      company_name      giac_parameters.param_value_v%TYPE,
      company_address   giac_parameters.param_value_v%TYPE,
      report_title      giis_reports.report_title%TYPE,
      date_range        VARCHAR2 (200),
      based_on          VARCHAR2 (100),
      tsi1              NUMBER,
      prem1             NUMBER,
      tsi2              NUMBER,
      prem2             NUMBER,
      tsi3              NUMBER,
      prem3             NUMBER,
      tsi4              NUMBER,
      prem4             NUMBER,
      tsi5              NUMBER,
      prem5             NUMBER,
      pol_tsi1          NUMBER,
      pol_prem1         NUMBER,
      pol_tsi2          NUMBER,
      pol_prem2         NUMBER,
      pol_tsi3          NUMBER,
      pol_prem3         NUMBER,
      pol_tsi4          NUMBER,
      pol_prem4         NUMBER,
      pol_tsi5          NUMBER,
      pol_prem5         NUMBER
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_main (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN main_tab PIPELINED;

   TYPE col_type IS RECORD (
      dummy_group   VARCHAR2 (100),
      col1          giis_dist_share.trty_name%TYPE,
      col2          giis_dist_share.trty_name%TYPE,
      col3          giis_dist_share.trty_name%TYPE,
      col4          giis_dist_share.trty_name%TYPE,
      col5          giis_dist_share.trty_name%TYPE
   );

   TYPE col_tab IS TABLE OF col_type;

   FUNCTION get_cols (
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_share_cds   VARCHAR2
   )
      RETURN col_tab PIPELINED;

   TYPE recap_type IS RECORD (
      peril_sname   VARCHAR2 (5),
      dummy_group   VARCHAR2 (50),
      tsi1          NUMBER,
      prem1         NUMBER,
      tsi2          NUMBER,
      prem2         NUMBER,
      tsi3          NUMBER,
      prem3         NUMBER,
      tsi4          NUMBER,
      prem4         NUMBER,
      tsi5          NUMBER,
      prem5         NUMBER
   );

   TYPE recap_tab IS TABLE OF recap_type;

   FUNCTION get_recaps (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2,
      p_share_cds    VARCHAR2
   )
      RETURN recap_tab PIPELINED;
END gipir928_pkg;
/
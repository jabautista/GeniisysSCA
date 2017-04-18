CREATE OR REPLACE PACKAGE CPI.gipir902c_pkg
AS
   TYPE col_type IS RECORD (
      peril_cd     giis_peril.peril_cd%TYPE,
      peril_name   giis_peril.peril_name%TYPE
   );

   TYPE col_tab IS TABLE OF col_type;

   FUNCTION get_cols (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2,
      p_date_from    VARCHAR2,
      p_date_to      VARCHAR2
   )
      RETURN col_tab PIPELINED;

   TYPE main_type IS RECORD (
      comp_name        giis_parameters.param_value_v%TYPE := giisp.v ('COMPANY_NAME'),
      comp_add         giis_parameters.param_value_v%TYPE := giisp.v ('COMPANY_ADDRESS'),
      date_from        VARCHAR2 (100),
      date_to          VARCHAR2 (100),
      loss_date_from   VARCHAR2 (100),
      loss_date_to     VARCHAR2 (100),
      peril_cd_1       giis_peril.peril_cd%TYPE,
      peril_name_1     giis_peril.peril_name%TYPE,
      peril_cd_2       giis_peril.peril_cd%TYPE,
      peril_name_2     giis_peril.peril_name%TYPE,
      peril_cd_3       giis_peril.peril_cd%TYPE,
      peril_name_3     giis_peril.peril_name%TYPE,
      row_count        NUMBER
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_main (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2
   )
      RETURN main_tab PIPELINED;

   TYPE detail_type IS RECORD (
      range_from       NUMBER,
      ranges           VARCHAR2 (200),
      policy_count_1   NUMBER,
      policy_count_2   NUMBER,
      policy_count_3   NUMBER,
      claim_count_1    NUMBER,
      claim_count_2    NUMBER,
      claim_count_3    NUMBER,
      peril_tsi_1      NUMBER,
      peril_tsi_2      NUMBER,
      peril_tsi_3      NUMBER,
      peril_prem_1     NUMBER,
      peril_prem_2     NUMBER,
      peril_prem_3     NUMBER,
      loss_1           NUMBER,
      loss_2           NUMBER,
      loss_3           NUMBER,
      row_count        NUMBER
   );

   TYPE detail_tab IS TABLE OF detail_type;

   FUNCTION get_details (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2
   )
      RETURN detail_tab PIPELINED;
END;
/



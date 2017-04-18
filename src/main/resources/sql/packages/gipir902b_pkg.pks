CREATE OR REPLACE PACKAGE CPI.gipir902b_pkg
AS
   TYPE gipir902b_type IS RECORD (
      range_from            gipi_risk_loss_profile.range_from%TYPE,
      range_to              gipi_risk_loss_profile.range_to%TYPE, --added by gab 06.20.2016 SR 21538
      ranges2               VARCHAR2 (100),
      pol1                  VARCHAR2 (100),
      sum_insured           NUMBER,
      premium               NUMBER,
      net_ret_sum_insured   NUMBER,
      net_ret_premium       NUMBER,
      net_ret_loss          NUMBER,
      treaty_sum_insured    NUMBER,
      treaty_premium        NUMBER,
      treaty_loss           NUMBER,
      facul_sum_insured     NUMBER,
      facul_premium         NUMBER,
      facul_loss            NUMBER,
      claim_count           NUMBER,
      policy_count          NUMBER,
      comp_name             giis_parameters.param_value_v%TYPE := giisp.v ('COMPANY_NAME'),
      comp_add              giis_parameters.param_value_v%TYPE := giisp.v ('COMPANY_ADDRESS'),
      date_from             VARCHAR2 (100),
      date_to               VARCHAR2 (100),
      loss_date_from        VARCHAR2 (100),
      loss_date_to          VARCHAR2 (100)
   );

   TYPE gipir902b_tab IS TABLE OF gipir902b_type;

   FUNCTION get_gipir902b (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_all_line_tag     VARCHAR2
   )
      RETURN gipir902b_tab PIPELINED;
END;
/



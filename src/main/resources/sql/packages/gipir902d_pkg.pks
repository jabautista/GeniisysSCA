CREATE OR REPLACE PACKAGE CPI.gipir902d_pkg
AS
   TYPE gipir902d_type IS RECORD (
      comp_name             giis_parameters.param_value_v%TYPE := giisp.v ('COMPANY_NAME'),
      comp_add              giis_parameters.param_value_v%TYPE := giisp.v ('COMPANY_ADDRESS'),
      date_from             VARCHAR2 (100),
      date_to               VARCHAR2 (100),
      loss_date_from        VARCHAR2 (100),
      loss_date_to          VARCHAR2 (100),
      subline               VARCHAR2 (100),
      range_from            NUMBER,
      range_to              NUMBER, --added by gab 06.20.2016 SR 21538
      ranges2               VARCHAR2 (100),
      pol1                  VARCHAR2 (100),
      sum_insured           NUMBER,
      premium               NUMBER,
      net_ret_sum_insured   NUMBER,
      net_ret_premium       NUMBER,
      net_ret_loss_amt0     NUMBER,
      treaty_sum_insured    NUMBER,
      treaty_premium        NUMBER,
      treaty_loss_amt0      NUMBER,
      facul_sum_insured     NUMBER,
      facul_premium         NUMBER,
      facul_loss_amt0       NUMBER,
      subline_cd            giis_subline.subline_cd%TYPE,
      claim_id              gicl_claims.claim_id%TYPE,
      close_sw              VARCHAR2 (1),
      line_name             giis_line.line_name%TYPE,
      policy_count          NUMBER,
      claim_count           NUMBER
   );

   TYPE gipir902d_tab IS TABLE OF gipir902d_type;

   FUNCTION get_gipir902d (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_all_line_tag     VARCHAR2
   )
      RETURN gipir902d_tab PIPELINED;
END;
/



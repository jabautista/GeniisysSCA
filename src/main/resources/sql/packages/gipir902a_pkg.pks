CREATE OR REPLACE PACKAGE CPI.gipir902a_pkg
AS
   TYPE gipir902a_type IS RECORD (
      treaty_prem        NUMBER,
      line_cd            giis_line.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      range_from         NUMBER,
      range_to           NUMBER (16, 2),
      policy_count       NUMBER,
      claim_count        NUMBER,
      gross_tsi          NUMBER,
      gross_prem         NUMBER,
      cf_from            VARCHAR2 (100),
      cf_to              NUMBER,
      gross_loss         NUMBER,
      retention_tsi      NUMBER,
      retention_loss     NUMBER,
      treaty_tsi         NUMBER,
      retention_prem     NUMBER,
      treaty_loss        NUMBER,
      facultative_tsi    NUMBER,
      facultative_prem   NUMBER,
      facultative_loss   NUMBER,
      comp_name          giis_parameters.param_value_v%TYPE := giisp.v('COMPANY_NAME'),
      comp_add           giis_parameters.param_value_v%TYPE := giisp.v('COMPANY_ADDRESS'),
      date_from          VARCHAR2(100),
      date_to            VARCHAR2(100),
      loss_date_from     VARCHAR2(100),
      loss_date_to       VARCHAR2(100)
      
   );

   TYPE gipir902a_tab IS TABLE OF gipir902a_type;

   FUNCTION get_gipir902a (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2
   )
      RETURN gipir902a_tab PIPELINED;
END;
/



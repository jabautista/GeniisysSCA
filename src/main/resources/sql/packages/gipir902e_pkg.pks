CREATE OR REPLACE PACKAGE CPI.gipir902e_pkg
AS
   TYPE col_type IS RECORD (
      block_risk   VARCHAR2 (100)
   );

   TYPE col_tab IS TABLE OF col_type;

   FUNCTION get_cols (
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2
   )
      RETURN col_tab PIPELINED;
      
   TYPE rep_type IS RECORD (
      row_no            NUMBER,
      range_from        NUMBER,
      block_risk1       VARCHAR2(200),
      block_risk2       VARCHAR2(200),
      block_risk3       VARCHAR2(200),
      risk_count1       NUMBER,
      risk_count2       NUMBER,
      risk_count3       NUMBER,
      sum_insured1      NUMBER,
      sum_insured2      NUMBER,
      sum_insured3      NUMBER,
      prem_amt1         NUMBER,
      prem_amt2         NUMBER,
      prem_amt3         NUMBER,
      loss_amt1         NUMBER,
      loss_amt2         NUMBER,
      loss_amt3         NUMBER,      
      ranges            VARCHAR2 (200),
      line_name         giis_line.line_name%TYPE,
      comp_name         giis_parameters.param_value_v%TYPE := giisp.v ('COMPANY_NAME'),
      comp_add          giis_parameters.param_value_v%TYPE := giisp.v ('COMPANY_ADDRESS'),
      date_from         VARCHAR2 (100),
      date_to           VARCHAR2 (100),
      loss_date_from    VARCHAR2 (100),
      loss_date_to      VARCHAR2 (100)
   );      
   
   TYPE rep_tab IS TABLE OF rep_type;
   
   FUNCTION get_rep (
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2   
   )
      RETURN rep_tab PIPELINED;
      
END;
/



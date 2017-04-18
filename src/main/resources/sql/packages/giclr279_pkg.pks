CREATE OR REPLACE PACKAGE CPI.GICLR279_PKG
AS

/*
**  Created by   : Windell Valle
**  Date Created : May 07 2013
**  Description  : Report called from module GICLR279 (Claim Listing  Per Block)
*/

   TYPE giclr279_type IS RECORD (
      district          VARCHAR2 (200),
      block             VARCHAR2 (200),
      claim_no          VARCHAR2 (100),
      policy_no         VARCHAR2 (200),
      assured_name      VARCHAR2 (700),
      item              VARCHAR2 (700),
      loss_date         DATE,
      loss_reserve      NUMBER (16, 2),
      losses_paid       NUMBER (16, 2),
      expense_reserve   NUMBER (16, 2),
      expenses_paid     NUMBER (16, 2),
      --
      block_id          INTEGER,
      claim_id          INTEGER,
      clm_file_date     GICL_CLAIMS.clm_file_date%TYPE,
      --      
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      systemDate        VARCHAR2(100),
      systemTime        VARCHAR2(100),
      dateType          VARCHAR(200)
   );

   TYPE giclr279_tab IS TABLE OF giclr279_type;

   FUNCTION get_report_master (
      p_as_of_date      VARCHAR2,
      p_as_of_ldate     VARCHAR2,
      p_block_id        NUMBER,
      p_search_by       VARCHAR2,
      p_date_condition  VARCHAR2,
      p_from_date       VARCHAR2,
      p_from_ldate      VARCHAR2,
      p_to_date         VARCHAR2,
      p_to_ldate        VARCHAR2
   )
      RETURN giclr279_tab PIPELINED;

END;
/



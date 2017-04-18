CREATE OR REPLACE PACKAGE CPI.gipir902f_pkg
AS
   TYPE gipir902f_type IS RECORD (
      range_from       NUMBER,
      RANGE            VARCHAR2 (100),
      subline_cd       giis_subline.subline_cd%TYPE,
      iss_cd           giis_issource.iss_cd%TYPE,
      renew_no         gipi_polbasic.renew_no%TYPE,
      pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      issue_yy         gipi_polbasic.issue_yy%TYPE,
      line_cd          giis_line.line_cd%TYPE,
      pol              VARCHAR2 (100),
      loss_amt         NUMBER,
      item             VARCHAR2(500),
      ann_tsi_amt      NUMBER,
      prem_amt         NUMBER,
      comp_name        giis_parameters.param_value_v%TYPE := giisp.v ('COMPANY_NAME'),
      comp_add         giis_parameters.param_value_v%TYPE := giisp.v ('COMPANY_ADDRESS'),
      date_from        VARCHAR2 (100),
      date_to          VARCHAR2 (100),
      loss_date_from   VARCHAR2 (100),
      loss_date_to     VARCHAR2 (100)
   );

   TYPE gipir902f_tab IS TABLE OF gipir902f_type;

   FUNCTION get_gipir902f (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_all_line_tag     VARCHAR2
   )
      RETURN gipir902f_tab PIPELINED;
END;
/



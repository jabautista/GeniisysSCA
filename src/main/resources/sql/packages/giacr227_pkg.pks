CREATE OR REPLACE PACKAGE CPI.GIACR227_PKG
AS
   TYPE giacr227_record_type IS RECORD (
      line_cd           VARCHAR2 (2),
      line_name         VARCHAR2 (20),
      company_name      VARCHAR2 (100),
      company_address   VARCHAR2 (100),
      f_date            VARCHAR2 (100),
      subline_cd        VARCHAR2 (7),
      subline_name      VARCHAR2 (30),
      peril_cd          NUMBER (5),
      peril_sname       VARCHAR2 (4),
      v_flag            VARCHAR2 (1)
   );

   TYPE giacr227_record_tab IS TABLE OF giacr227_record_type;

   TYPE col_header_record_type IS RECORD (
      trty_name   VARCHAR2 (25),
      share_cd    NUMBER (3),
      line_cd     VARCHAR2 (2)
   );

   TYPE col_header_record_tab IS TABLE OF col_header_record_type;

   TYPE subline_details_type IS RECORD (
      d_line_cd      VARCHAR2 (2),
      d_subline_cd   VARCHAR2 (7),
      d_peril_cd     NUMBER (5),
      d_trty_name    VARCHAR2 (25),
      d_dist_tsi     NUMBER,
      d_dist_prem    NUMBER,
      d_share_cd     NUMBER (3)
   );

   TYPE subline_details_tab IS TABLE OF subline_details_type;

   TYPE line_details_record_type IS RECORD (
      peril_cd      NUMBER (5),
      peril_sname   VARCHAR2 (4),
      line_cd       VARCHAR2 (2)
   );

   TYPE line_details_record_tab IS TABLE OF line_details_record_type;

   TYPE line_ttl_details_type IS RECORD (
      d_line_cd     VARCHAR2 (2),
      d_peril_cd    NUMBER (5),
      d_trty_name   VARCHAR2 (25),
      d_dist_tsi    NUMBER,
      d_dist_prem   NUMBER,
      d_share_cd    NUMBER (3)
   );

   TYPE line_ttl_details_tab IS TABLE OF line_ttl_details_type;

   TYPE giacr227_linettl_type IS RECORD (
      d_line_cd     VARCHAR2 (2),
      d_peril_cd    NUMBER (5),
      d_trty_name   VARCHAR2 (25),
      d_dist_tsi    NUMBER,
      d_dist_prem   NUMBER,
      d_share_cd    NUMBER (3)
   );

   TYPE giacr227_linettl_tab IS TABLE OF giacr227_linettl_type;

   TYPE gl_acct_record_type IS RECORD (
      gl_acct           VARCHAR2 (100),
      gl_acct_name      VARCHAR2 (100),
      debit_amt         NUMBER (12, 2),
      credit_amt        NUMBER (12, 2),
      sl_cd             NUMBER (12),
      gslt_sl_type_cd   VARCHAR2 (2),
      gacc_tran_id      NUMBER (12),
      v_flag            VARCHAR2 (1)
   );

   TYPE gl_acct_record_tab IS TABLE OF gl_acct_record_type;

   FUNCTION get_giacr227_record (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_user_id          VARCHAR2
   )
      RETURN giacr227_record_tab PIPELINED;

   FUNCTION get_col_header_record (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_user_id          VARCHAR2
   )
      RETURN col_header_record_tab PIPELINED;

   FUNCTION get_subline_detail (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_peril_cd         NUMBER,
      p_dist_tsi         NUMBER,
      p_dist_prem        NUMBER,
      p_trty_name        VARCHAR2,
      p_user_id          VARCHAR2
   )
      RETURN subline_details_tab PIPELINED;

   FUNCTION get_line_details_record (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_user_id          VARCHAR2
   )
      RETURN line_details_record_tab PIPELINED;

   FUNCTION populate_line_ttl_details (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_line_cd          VARCHAR2,
      p_peril_cd         NUMBER,
      p_dist_tsi         NUMBER,
      p_dist_prem        NUMBER,
      p_trty_name        VARCHAR2,
      p_user_id          VARCHAR2
   )
      RETURN line_ttl_details_tab PIPELINED;

   FUNCTION populate_matrix_linettl (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_line_cd          VARCHAR2,
      p_peril_cd         NUMBER,
      p_dist_tsi         NUMBER,
      p_dist_prem        NUMBER,
      p_trty_name        VARCHAR2,
      p_user_id          VARCHAR2
   )
      RETURN giacr227_linettl_tab PIPELINED;

   FUNCTION get_gl_acct_record (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_user_id          VARCHAR2
   )
      RETURN gl_acct_record_tab PIPELINED;
END GIACR227_PKG;
/



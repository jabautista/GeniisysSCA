CREATE OR REPLACE PACKAGE CPI.giiss113_pkg
AS
   TYPE rec_type IS RECORD (
      coverage_cd     giis_coverage.coverage_cd%TYPE,
      coverage_desc   giis_coverage.coverage_desc%TYPE,
      line_cd         giis_coverage.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE,
      subline_cd      giis_coverage.subline_cd%TYPE,
      subline_name    giis_subline.subline_name%TYPE,
      cpi_rec_no      giis_coverage.cpi_rec_no%TYPE,
      cpi_branch_cd   giis_coverage.cpi_branch_cd%TYPE,
      remarks         giis_coverage.remarks%TYPE,
      user_id         giis_coverage.user_id%TYPE,
      last_update     VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_coverage_cd     giis_coverage.coverage_cd%TYPE,
      p_coverage_desc   giis_coverage.coverage_desc%TYPE,
      p_line_cd         giis_coverage.line_cd%TYPE,
      p_subline_cd      giis_coverage.subline_cd%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE val_add_rec (p_coverage_desc giis_coverage.coverage_desc%TYPE);

   PROCEDURE val_del_rec (p_coverage_cd giis_coverage.coverage_cd%TYPE);

   PROCEDURE set_rec (p_rec giis_coverage%ROWTYPE);

   PROCEDURE del_rec (p_coverage_cd giis_coverage.coverage_cd%TYPE);

   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   FUNCTION get_line_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN line_lov_tab PIPELINED;

   TYPE subline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_lov_tab IS TABLE OF subline_lov_type;

   FUNCTION get_subline_lov (
      p_user_id   VARCHAR2,
      p_keyword   VARCHAR2,
      p_line_cd   VARCHAR2
   )
      RETURN subline_lov_tab PIPELINED;
      
   FUNCTION get_all_coverage_desc
      RETURN rec_tab PIPELINED;
END;
/



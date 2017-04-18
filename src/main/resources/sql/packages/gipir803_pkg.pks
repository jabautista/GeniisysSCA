CREATE OR REPLACE PACKAGE CPI.GIPIR803_PKG
AS
   TYPE get_gipir803_record_type IS RECORD (
      line_cd           giis_line.line_cd%TYPE,
      line_desc         VARCHAR2(100),
      subline_cd        giis_subline.subline_cd%TYPE,
      subline_name      giis_subline.subline_name%TYPE,
      op_flag           VARCHAR2 (100),
      default_time      VARCHAR2 (100),
      company_name      VARCHAR2 (500),
      company_address   VARCHAR2 (500)
   );

   TYPE get_gipir803_record_tab IS TABLE OF get_gipir803_record_type;

   FUNCTION get_gipir803_record (p_user_id giis_users.user_id%TYPE)
      RETURN get_gipir803_record_tab PIPELINED;
END GIPIR803_PKG;
/



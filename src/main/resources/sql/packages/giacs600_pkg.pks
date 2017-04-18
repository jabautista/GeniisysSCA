CREATE OR REPLACE PACKAGE CPI.giacs600_pkg
AS
   TYPE giexs600_file_source_type IS RECORD (
      source_cd         giac_file_source.source_cd%TYPE,
      source_name       giac_file_source.source_name%TYPE,
      or_tag            giac_file_source.or_tag%TYPE,
      or_tag_desc       VARCHAR2 (100),
      atm_tag           giac_file_source.atm_tag%TYPE,
      address_1         giac_file_source.address_1%TYPE,
      address_2         giac_file_source.address_2%TYPE,
      address_3         giac_file_source.address_3%TYPE,
      tin               giac_file_source.tin%TYPE,
      user_id           giac_file_source.user_id%TYPE,
      last_update       VARCHAR2 (100),
      remarks           giac_file_source.remarks%TYPE,
      utility_tag       giac_file_source.utility_tag%TYPE,
      original_source   VARCHAR2 (100),
      add_update        VARCHAR2 (100)
   );

   TYPE giexs600_file_source_tab IS TABLE OF giexs600_file_source_type;

   FUNCTION get_file_source_records
      RETURN giexs600_file_source_tab PIPELINED;

   PROCEDURE delete_file_source (p_source_cd giac_file_source.source_cd%TYPE);

   PROCEDURE set_file_source (
      p_original_source   VARCHAR2,
      p_add_update        VARCHAR2,
      p_source_cd         VARCHAR2,
      p_source_name       VARCHAR2,
      p_or_tag            VARCHAR2,
      p_atm_tag           VARCHAR2,
      p_address_1         VARCHAR2,
      p_address_2         VARCHAR2,
      p_address_3         VARCHAR2,
      p_tin               VARCHAR2,
      p_remarks           VARCHAR2,
      p_utility_tag       VARCHAR2,
      p_user_id           VARCHAR2
   );
END giacs600_pkg;
/



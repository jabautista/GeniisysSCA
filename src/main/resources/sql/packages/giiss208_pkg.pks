CREATE OR REPLACE PACKAGE CPI.giiss208_pkg
AS
   /*
     **  Created by        : Christopher Jubilo
     **  Date Created     : 10.16.2012
     **  Reference By     : (GIISS208- Peril Depreciation
     **  Description     : Returns record listing for  Peril Depreciation
     **  Modified By      : Kenneth L. 11.12.2012
     */

   --record for line_cd
   TYPE giis_line_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE giis_line_tab IS TABLE OF giis_line_type;

   TYPE giis_peril_list_type IS RECORD (
      line_cd       giis_line.line_cd%TYPE,
      line_name     giis_line.line_name%TYPE,
      peril_cd      giis_peril.peril_cd%TYPE,
      peril_name    giis_peril.peril_name%TYPE,
      rate          giex_dep_perl.rate%TYPE,
      user_id       giex_dep_perl.user_id%TYPE,
      last_update   giex_dep_perl.last_update%TYPE
   );

   TYPE giis_peril_list_tab IS TABLE OF giis_peril_list_type;

   --record for peril depreciation
   TYPE giis_peril_depreciation_type IS RECORD (
      line_cd       giis_line.line_cd%TYPE,
      line_name     giis_line.line_name%TYPE,
      peril_cd      giis_peril.peril_cd%TYPE,
      peril_name    giis_peril.peril_name%TYPE,
      rate          giex_dep_perl.rate%TYPE,
      user_id       giex_dep_perl.user_id%TYPE,
      last_update   VARCHAR2 (100),
      remarks       giex_dep_perl.remarks%TYPE
   );

   TYPE giis_peril_depreciation_tab IS TABLE OF giis_peril_depreciation_type;

   FUNCTION get_giis_line_item(p_user_id VARCHAR2)
      RETURN giis_line_tab PIPELINED;

   FUNCTION get_giis_peril_list_item (
       p_line_cd giis_line.line_cd%TYPE, 
       p_peril_cd VARCHAR2,         --added by : kenneth L.
       p_peril_name giis_peril.peril_name%TYPE)     --added by : kenneth L.
      RETURN giis_peril_list_tab PIPELINED;

   FUNCTION get_giis_peril_dep_item (p_line_cd giis_line.line_cd%TYPE)
      RETURN giis_peril_depreciation_tab PIPELINED;

   FUNCTION validate_add_perilcd (
      p_line_cd    giis_line.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   )
      RETURN VARCHAR2;

   PROCEDURE set_giis_peril_dep_item (p_dep_perl giex_dep_perl%ROWTYPE);

   PROCEDURE del_giis_peril_dep_item (
      p_line_cd    giis_line.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   );
END;
/



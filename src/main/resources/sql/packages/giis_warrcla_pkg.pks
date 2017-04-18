CREATE OR REPLACE PACKAGE CPI.Giis_Warrcla_Pkg AS

  TYPE warrcla_with_text IS RECORD
    (line_cd           GIIS_WARRCLA.line_cd%TYPE,
     main_wc_cd        GIIS_WARRCLA.main_wc_cd%TYPE,
     print_sw          GIIS_WARRCLA.print_sw%TYPE,
     wc_title          GIIS_WARRCLA.wc_title%TYPE,
     wc_text           VARCHAR2(32767),
     wc_text01         GIIS_WARRCLA.wc_text01%TYPE,
     wc_text02         GIIS_WARRCLA.wc_text02%TYPE,
     wc_text03         GIIS_WARRCLA.wc_text03%TYPE,
     wc_text04         GIIS_WARRCLA.wc_text04%TYPE,
     wc_text05         GIIS_WARRCLA.wc_text05%TYPE,
     wc_text06         GIIS_WARRCLA.wc_text06%TYPE,
     wc_text07         GIIS_WARRCLA.wc_text07%TYPE,
     wc_text08         GIIS_WARRCLA.wc_text08%TYPE,
     wc_text09         GIIS_WARRCLA.wc_text09%TYPE,
     wc_text10         GIIS_WARRCLA.wc_text10%TYPE,
     wc_text11         GIIS_WARRCLA.wc_text11%TYPE,
     wc_text12         GIIS_WARRCLA.wc_text12%TYPE,
     wc_text13         GIIS_WARRCLA.wc_text13%TYPE,
     wc_text14         GIIS_WARRCLA.wc_text14%TYPE,
     wc_text15         GIIS_WARRCLA.wc_text15%TYPE,
     wc_text16         GIIS_WARRCLA.wc_text16%TYPE,
     wc_text17         GIIS_WARRCLA.wc_text17%TYPE,
     text_update_sw    GIIS_WARRCLA.text_update_sw%TYPE,
     wc_sw             VARCHAR2(20),
     remarks           GIIS_WARRCLA.remarks%TYPE);

  TYPE warrcla_with_text_tab IS TABLE OF warrcla_with_text;

  FUNCTION get_warrcla_list (p_line_cd GIIS_WARRCLA.line_cd%TYPE,
                             p_find_text VARCHAR2)
    RETURN warrcla_with_text_tab PIPELINED;

END Giis_Warrcla_Pkg;
/



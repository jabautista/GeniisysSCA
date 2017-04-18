CREATE OR REPLACE PACKAGE CPI.GIISS034_PKG AS

  TYPE warrcla_with_text IS RECORD
    (line_cd           GIIS_WARRCLA.line_cd%TYPE,
     main_wc_cd        GIIS_WARRCLA.main_wc_cd%TYPE,
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
     wc_sw_desc        VARCHAR2(20),
     wc_sw             GIIS_WARRCLA.wc_sw%TYPE,
     print_sw          GIIS_WARRCLA.print_sw%TYPE,
     remarks           GIIS_WARRCLA.remarks%TYPE,
     user_id           GIIS_WARRCLA.user_id%TYPE,
     last_update       VARCHAR2(100),
     active_tag        GIIS_WARRCLA.active_tag%TYPE --carlo 01-26-2017 SR 5915	
     );

  TYPE warrcla_with_text_tab IS TABLE OF warrcla_with_text;
  
  TYPE line_list IS RECORD 
    (line_cd           GIIS_LINE.line_cd%TYPE,
     line_name         GIIS_LINE.line_name%TYPE
    );
  
  TYPE line_list_tab IS TABLE OF line_list;

  FUNCTION get_warrcla_list (p_line_cd GIIS_WARRCLA.line_cd%TYPE
  )
    RETURN warrcla_with_text_tab PIPELINED;
  
  FUNCTION get_giis_line_list(p_user_id GIIS_USERS.user_id%TYPE --added by reymon 05042013
  )
      
    RETURN line_list_tab PIPELINED;
  
  PROCEDURE delete_giis_warr_cla_row ( 
     p_line_cd  giis_warrcla.line_cd%TYPE,
     p_main_wc_cd  giis_warrcla.main_wc_cd%TYPE
  );
  
  PROCEDURE set_giis_warr_cla_group ( 
     p_warr_cla giis_warrcla%ROWTYPE
  );
  
  FUNCTION validate_delete_warr_cla (
	 p_line_cd	    giis_warrcla.line_cd%TYPE,
	 p_main_wc_cd	giis_warrcla.main_wc_cd%TYPE
  )

	RETURN VARCHAR2;
  FUNCTION VALIDATE_ADD_WARR_CLA (
	 p_main_wc_cd	giis_warrcla.main_wc_cd%TYPE,
     p_line_cd	    giis_warrcla.line_cd%TYPE
  )
  
  RETURN VARCHAR2;

END GIISS034_PKG;
/



CREATE OR REPLACE PACKAGE CPI.giiss218_pkg
AS

   TYPE banc_type IS RECORD(
      banc_type_cd               giis_banc_type.banc_type_cd%TYPE,
      banc_type_desc             giis_banc_type.banc_type_desc%TYPE,
      rate                       giis_banc_type.rate%TYPE,
      user_id                    giis_banc_type.user_id%TYPE,
      last_update                giis_banc_type.last_update%TYPE
   );
   TYPE banc_tab IS TABLE OF banc_type;

   TYPE giis_banc_type_dtl_type IS RECORD(
      banc_type_cd               giis_banc_type_dtl.banc_type_cd%TYPE,
      item_no                    giis_banc_type_dtl.item_no%TYPE,
      intm_no                    giis_banc_type_dtl.intm_no%TYPE,
      intm_type                  giis_banc_type_dtl.intm_type%TYPE,
      share_percentage           giis_banc_type_dtl.share_percentage%TYPE,
      remarks                    giis_banc_type_dtl.remarks%TYPE,
      user_id                    giis_banc_type_dtl.user_id%TYPE,
      last_update                giis_banc_type_dtl.last_update%TYPE,
      dsp_last_update            VARCHAR2(50),
      fixed_tag                  giis_banc_type_dtl.fixed_tag%TYPE,
      intm_name                  giis_intermediary.intm_name%TYPE,
      intm_type_desc             giis_intm_type.intm_desc%TYPE,
      max_item_no                giis_banc_type_dtl.item_no%TYPE
   );
   TYPE giis_banc_type_dtl_tab IS TABLE OF giis_banc_type_dtl_type;
   
   TYPE intm_lov_type IS RECORD(
      intm_no                    giis_intermediary.intm_no%TYPE,
      intm_name                  giis_intermediary.intm_name%TYPE,
      intm_type                  giis_intm_type.intm_type%TYPE,
      intm_desc                  giis_intm_type.intm_desc%TYPE
   );
   TYPE intm_lov_tab IS TABLE OF intm_lov_type;
   
   TYPE intm_type_lov_type IS RECORD(
      intm_type                  giis_intm_type.intm_type%TYPE,
      intm_name                  giis_intm_type.intm_desc%TYPE
   );
   TYPE intm_type_lov_tab IS TABLE OF intm_type_lov_type;
   
   FUNCTION get_banc_type_list(
      p_banc_type_cd             giis_banc_type.banc_type_cd%TYPE,
      p_banc_type_desc           giis_banc_type.banc_type_desc%TYPE,
      p_rate                     giis_banc_type.rate%TYPE
   )
     RETURN banc_tab PIPELINED;
   
   FUNCTION get_banc_type_details(
      p_banc_type_cd             giis_banc_type_dtl.banc_type_cd%TYPE,
      p_item_no                  giis_banc_type_dtl.item_no%TYPE,
      p_share_percentage         giis_banc_type_dtl.share_percentage%TYPE
   )
     RETURN giis_banc_type_dtl_tab PIPELINED;
     
   FUNCTION get_intm_lov(
      p_banc_type_cd             giis_banc_type.banc_type_cd%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN intm_lov_tab PIPELINED;
     
   FUNCTION get_intm_type_lov(
      p_find_text                VARCHAR2
   )
     RETURN intm_type_lov_tab PIPELINED;
     
   PROCEDURE val_add_rec(
      p_banc_type_cd             giis_banc_type.banc_type_cd%TYPE
   );
     
   PROCEDURE set_banc_type(
      p_rec                      giis_banc_type%ROWTYPE
   );
   
   PROCEDURE del_banc_type(
      p_banc_type_cd             giis_banc_type.banc_type_cd%TYPE
   );
   
   PROCEDURE val_add_dtl(
      p_banc_type_cd             giis_banc_type_dtl.banc_type_cd%TYPE,
      p_item_no                  giis_banc_type_dtl.item_no%TYPE
   );
   
   PROCEDURE set_banc_type_dtl(
      p_rec                      giis_banc_type_dtl%ROWTYPE
   );
   
   PROCEDURE del_banc_type_dtl(
      p_banc_type_cd             giis_banc_type_dtl.banc_type_cd%TYPE,
      p_item_no                  giis_banc_type_dtl.item_no%TYPE
   );
   
   FUNCTION get_max_item_no(
      p_banc_type_cd             giis_banc_type_dtl.banc_type_cd%TYPE
   )
     RETURN NUMBER;

END;
/



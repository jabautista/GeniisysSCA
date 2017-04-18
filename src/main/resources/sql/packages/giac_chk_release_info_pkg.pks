CREATE OR REPLACE PACKAGE CPI.giac_chk_release_info_pkg
AS
/******************************************************************************
   NAME:        GIAC_CHK_RELEASE_INFO_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/20/2012   Irwin tabisora 1. Created this package.
******************************************************************************/
   TYPE giac_chk_release_info_type IS RECORD (
      gacc_tran_id         giac_chk_release_info.gacc_tran_id%TYPE,
      item_no              giac_chk_release_info.item_no%TYPE,
      check_no             giac_chk_release_info.check_no%TYPE,
      check_release_date   giac_chk_release_info.check_release_date%TYPE,
      check_released_by    giac_chk_release_info.check_released_by%TYPE,
      check_received_by    giac_chk_release_info.check_received_by%TYPE,
      check_pref_suf       giac_chk_release_info.check_pref_suf%TYPE,
      or_no                giac_chk_release_info.or_no%TYPE,
      or_date              giac_chk_release_info.or_date%TYPE,
      user_id              giac_chk_release_info.user_id%TYPE,
      last_update          giac_chk_release_info.last_update%TYPE,
      clearing_date        giac_chk_release_info.clearing_date%TYPE
   );

   TYPE giac_chk_release_info_tab IS TABLE OF giac_chk_release_info_type;

   FUNCTION get_giacs016_chk_release_info (
      p_gacc_tran_id   giac_chk_release_info.gacc_tran_id%TYPE,
	  p_item_no   giac_chk_release_info.item_no%TYPE
   )
      RETURN giac_chk_release_info_tab PIPELINED;
      
   FUNCTION validate_chk_release(
        p_tran_id           giac_chk_release_info.gacc_tran_id%TYPE,
        p_item_no           giac_chk_release_info.item_no%TYPE,
        p_check_pref_suf    giac_chk_release_info.check_pref_suf%TYPE,
        p_check_no          giac_chk_release_info.check_no%TYPE
   ) RETURN VARCHAR2;
   
   
   FUNCTION get_giacs002_chk_release_info(
        p_gacc_tran_id      giac_chk_release_info.gacc_tran_id%TYPE,
        p_item_no           giac_chk_release_info.item_no%TYPE
   ) RETURN giac_chk_release_info_tab PIPELINED;
   
  PROCEDURE insert_chk_release_info(
        p_gacc_tran_id          giac_chk_release_info.gacc_tran_id%TYPE,
        p_item_no               giac_chk_release_info.item_no%TYPE,
        p_check_pref_suf       giac_chk_release_info.check_pref_suf%TYPE,
        p_check_no             giac_chk_release_info.check_no%TYPE,
        p_check_received_by    giac_chk_release_info.check_received_by%TYPE,
        p_check_release_date   giac_chk_release_info.check_release_date%TYPE,
        p_or_date              giac_chk_release_info.or_date%TYPE,
        p_check_released_by    giac_chk_release_info.check_released_by%TYPE,
        p_or_no                giac_chk_release_info.or_no%TYPE,
        p_user_id              giac_chk_release_info.user_id%TYPE,
        p_last_update          giac_chk_release_info.last_update%TYPE
   );
   
END giac_chk_release_info_pkg;
/



CREATE OR REPLACE PACKAGE CPI.giis_banc_type_dtl_pkg
AS
  TYPE giis_banc_type_dtl_type IS RECORD(
  	  item_no				   GIIS_BANC_TYPE_DTL.item_no%TYPE,
	  intm_no				   GIIS_BANC_TYPE_DTL.intm_no%TYPE,
	  intm_name				   GIIS_INTERMEDIARY.intm_name%TYPE,
	  intm_type				   GIIS_BANC_TYPE_DTL.intm_type%TYPE,
	  fixed_tag				   GIIS_BANC_TYPE_DTL.fixed_tag%TYPE,
	  banc_type_cd			   GIIS_BANC_TYPE_DTL.banc_type_cd%TYPE,
	  intm_type_desc		   GIIS_INTM_TYPE.intm_desc%TYPE,
	  share_percentage		   GIIS_BANC_TYPE_DTL.share_percentage%TYPE,
	  parent_intm_no		   GIIS_INTERMEDIARY.intm_no%TYPE,
	  parent_intm_name		   GIIS_INTERMEDIARY.intm_name%TYPE
  	);

  TYPE giis_banc_type_dtl_tab IS TABLE OF giis_banc_type_dtl_type;

  TYPE giis_banc_type_dtl_cur IS REF CURSOR RETURN giis_banc_type_dtl_type;

  FUNCTION get_giis_banc_type_dtl(p_banc_type_cd			 GIIS_BANC_TYPE_DTL.banc_type_cd%TYPE)
    RETURN giis_banc_type_dtl_tab PIPELINED;

END giis_banc_type_dtl_pkg;
/



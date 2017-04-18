CREATE OR REPLACE PACKAGE BODY CPI.giis_banc_type_dtl_pkg
AS

  FUNCTION get_giis_banc_type_dtl(p_banc_type_cd			 GIIS_BANC_TYPE_DTL.banc_type_cd%TYPE)
    RETURN giis_banc_type_dtl_tab PIPELINED
  IS
  	v_banc_type_dtl				  giis_banc_type_dtl_type;
  BEGIN

  	FOR i IN (SELECT a.item_no, a.intm_no, b.intm_name, a.intm_type, a.fixed_tag, a.banc_type_cd, a.share_percentage
		  	    FROM GIIS_BANC_TYPE_DTL a, GIIS_INTERMEDIARY b
			   WHERE a.banc_type_cd = p_banc_type_cd
			     AND b.intm_no (+) = a.intm_no)
	LOOP
	  v_banc_type_dtl.item_no				   := i.item_no;
	  v_banc_type_dtl.intm_no				   := i.intm_no;
	  v_banc_type_dtl.intm_name				   := i.intm_name;
	  v_banc_type_dtl.intm_type				   := i.intm_type;
	  v_banc_type_dtl.fixed_tag				   := i.fixed_tag;
	  v_banc_type_dtl.banc_type_cd			   := i.banc_type_cd;
	  v_banc_type_dtl.share_percentage		   := i.share_percentage;
	END LOOP;

  END get_giis_banc_type_dtl;

END giis_banc_type_dtl_pkg;
/



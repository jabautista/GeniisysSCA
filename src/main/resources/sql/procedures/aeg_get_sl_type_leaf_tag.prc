DROP PROCEDURE CPI.AEG_GET_SL_TYPE_LEAF_TAG;

CREATE OR REPLACE PROCEDURE CPI.aeg_get_sl_type_leaf_tag(
    p_gl_acct_id GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
	p_sl_cd		 GIAC_ACCT_ENTRIES.sl_cd%TYPE,
	p_message	OUT varchar2) IS

  v_sl_type    giac_chart_of_accts.gslt_sl_type_cd%TYPE;
  v_leaf_tag   giac_chart_of_accts.leaf_tag%TYPE;
BEGIN
  SELECT gslt_sl_type_cd, leaf_tag
    INTO v_sl_type, v_leaf_tag
    FROM giac_chart_of_accts
    WHERE gl_acct_id = p_gl_acct_id;

  IF v_sl_type <> p_sl_cd THEN
    p_message := 'The SL type of this account(gl_acct_id: ' ||
              TO_CHAR(p_gl_acct_id) ||
              ') ' ||
              'does not match that in RI_SL_CD (GIAC PARAMETERS).';
  END IF;

  IF v_leaf_tag = 'N' THEN
    p_message := 'This account(gl_acct_id: ' ||
              TO_CHAR(p_gl_acct_id) ||
              ') ' ||
              'is not a posting account.';
  END IF;
END;
/



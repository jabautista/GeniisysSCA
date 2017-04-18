DROP FUNCTION CPI.GET_OP_FLAG_GIUTS008A;

CREATE OR REPLACE FUNCTION CPI.get_op_flag_giuts008a(
    p_line_cd	 giis_subline.line_cd%TYPE,
    p_subline_cd giis_subline.subline_cd%TYPE
)
RETURN VARCHAR2 IS
    v_op_flag VARCHAR2(1);
BEGIN
    BEGIN
		SELECT op_flag
		  INTO v_op_flag
		  FROM giis_subline
		 WHERE line_cd = p_line_cd
		   AND subline_cd = p_subline_cd;
    END;
    RETURN v_op_flag;
END;
/



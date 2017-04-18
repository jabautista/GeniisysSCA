CREATE OR REPLACE PACKAGE BODY CPI.Q_DEDUCTIBLES
AS
	FUNCTION get_records (
		p_extract_id	IN GIXX_DEDUCTIBLES.extract_id%TYPE,
		p_item_no		IN GIXX_DEDUCTIBLES.item_no%TYPE)
	RETURN deductible_tab PIPELINED
	IS
		v_deductible_table deductible_type;
		CURSOR G_EXTRACT_ID11 IS
			SELECT ALL DEDUCTIBLES.EXTRACT_ID,
				   DEDUCTIBLES.ITEM_NO DEDUCTIBLES_ITEM_NO,
				   DEDUCT_DESC.DEDUCTIBLE_TITLE DEDUCTDESC_DEDUCTIBLE_TITLE,
				   DECODE(DEDUCTIBLES.DEDUCTIBLE_TEXT, NULL, DEDUCT_DESC.DEDUCTIBLE_TEXT, DEDUCTIBLES.DEDUCTIBLE_TEXT)	DEDUCTIBLES_DEDUCTIBLE_TEXT,
				   DECODE(DEDUCTIBLES.DEDUCTIBLE_AMT, NULL, DEDUCT_DESC.DEDUCTIBLE_AMT, DEDUCTIBLES.DEDUCTIBLE_AMT) DEDUCTIBLES_DEDUCTIBLE_AMT,
				   DEDUCTIBLES.DED_LINE_CD DEDUCTIBLES_DED_LINE_CD,
				   DEDUCTIBLES.DED_SUBLINE_CD DEDUCTIBLES_DED_SUBLINE_CD,
				   DEDUCTIBLES.DED_DEDUCTIBLE_CD DEDUCTIBLES_DED_DEDUCTIBLE_CD,
				   TO_CHAR(DECODE(DEDUCTIBLES.DEDUCTIBLE_RT, NULL, NULL, DEDUCTIBLES.DEDUCTIBLE_RT),'99.999') DEDUCTIBLES_DEDUCTIBLE_RT,
				   PERIL.PERIL_SNAME DEDUCTIBLES_PERIL_SNAME,
				   DECODE(DEDUCTIBLES.DEDUCTIBLE_AMT, NULL, NULL, DEDUCTIBLES.DEDUCTIBLE_AMT) DEDUCTIBLE_AMOUNT
			  FROM GIXX_DEDUCTIBLES DEDUCTIBLES,
				   GIIS_DEDUCTIBLE_DESC DEDUCT_DESC,
				   GIIS_PERIL PERIL
			 WHERE DEDUCTIBLES.DED_DEDUCTIBLE_CD = DEDUCT_DESC.DEDUCTIBLE_CD (+)
			   AND DEDUCTIBLES.DED_SUBLINE_CD = DEDUCT_DESC.SUBLINE_CD (+)
			   AND DEDUCTIBLES.DED_LINE_CD = DEDUCT_DESC.LINE_CD (+)
			   AND DEDUCTIBLES.DED_LINE_CD = PERIL.LINE_CD (+)
			   AND DEDUCTIBLES.PERIL_CD = PERIL.PERIL_CD (+)
			   AND DEDUCTIBLES.EXTRACT_ID = p_extract_id
			   AND DEDUCTIBLES.ITEM_NO = p_item_no;
	BEGIN
		FOR i IN G_EXTRACT_ID11
		LOOP
			v_deductible_table.extract_id			:= i.extract_id;
			v_deductible_table.item_no				:= i.DEDUCTIBLES_ITEM_NO;
			v_deductible_table.deductible_title	    := i.DEDUCTDESC_DEDUCTIBLE_TITLE;
			v_deductible_table.ded_deductible_text	:= i.DEDUCTIBLES_DEDUCTIBLE_TEXT;
			v_deductible_table.ded_deductible_amt	:= i.DEDUCTIBLES_DEDUCTIBLE_AMT;
			v_deductible_table.ded_line_cd			:= i.DEDUCTIBLES_DED_LINE_CD;
			v_deductible_table.ded_subline_cd		:= i.DEDUCTIBLES_DED_SUBLINE_CD;
			v_deductible_table.ded_deductible_cd	:= i.DEDUCTIBLES_DED_DEDUCTIBLE_CD;
			v_deductible_table.deductible_rt		:= i.DEDUCTIBLES_DEDUCTIBLE_RT;
			v_deductible_table.ded_peril_sname		:= i.DEDUCTIBLES_PERIL_SNAME;
			v_deductible_table.deductible_amt		:= i.DEDUCTIBLE_AMOUNT;

			v_deductible_table.f_deductible_amt := Q_DEDUCTIBLES.get_deductible_amount(p_extract_id, p_item_no, i.deductible_amount);

			PIPE ROW(v_deductible_table);
		END LOOP;

	END get_records;

    FUNCTION get_records (
		p_extract_id	IN GIXX_DEDUCTIBLES.extract_id%TYPE,
		p_item_no		IN GIXX_DEDUCTIBLES.item_no%TYPE,
		p_report_id		VARCHAR2)
	RETURN deductible_tab PIPELINED
	IS
		v_deductible_table deductible_type;
		CURSOR G_EXTRACT_ID11 IS
			SELECT ALL DEDUCTIBLES.EXTRACT_ID,
				   DEDUCTIBLES.ITEM_NO DEDUCTIBLES_ITEM_NO,
				   DEDUCT_DESC.DEDUCTIBLE_TITLE DEDUCTDESC_DEDUCTIBLE_TITLE,
				   DECODE(DEDUCTIBLES.DEDUCTIBLE_TEXT, NULL, DEDUCT_DESC.DEDUCTIBLE_TEXT, DEDUCTIBLES.DEDUCTIBLE_TEXT)	DEDUCTIBLES_DEDUCTIBLE_TEXT,
				   DECODE(DEDUCTIBLES.DEDUCTIBLE_AMT, NULL, DEDUCT_DESC.DEDUCTIBLE_AMT, DEDUCTIBLES.DEDUCTIBLE_AMT) DEDUCTIBLES_DEDUCTIBLE_AMT,
				   DEDUCTIBLES.DED_LINE_CD DEDUCTIBLES_DED_LINE_CD,
				   DEDUCTIBLES.DED_SUBLINE_CD DEDUCTIBLES_DED_SUBLINE_CD,
				   DEDUCTIBLES.DED_DEDUCTIBLE_CD DEDUCTIBLES_DED_DEDUCTIBLE_CD,
				   TO_CHAR(DECODE(DEDUCTIBLES.DEDUCTIBLE_RT, NULL, DECODE(p_report_id, 'MARINE_CARGO', DEDUCT_DESC.DEDUCTIBLE_RT, NULL), DEDUCTIBLES.DEDUCTIBLE_RT),'99.999') DEDUCTIBLES_DEDUCTIBLE_RT,
				   PERIL.PERIL_SNAME DEDUCTIBLES_PERIL_SNAME,
				   DECODE(DEDUCTIBLES.DEDUCTIBLE_AMT, NULL, DECODE(p_report_id, 'MARINE_CARGO', DEDUCT_DESC.DEDUCTIBLE_AMT, NULL), DEDUCTIBLES.DEDUCTIBLE_AMT) DEDUCTIBLE_AMOUNT
			  FROM GIXX_DEDUCTIBLES DEDUCTIBLES,
				   GIIS_DEDUCTIBLE_DESC DEDUCT_DESC,
				   GIIS_PERIL PERIL
			 WHERE DEDUCTIBLES.DED_DEDUCTIBLE_CD = DEDUCT_DESC.DEDUCTIBLE_CD (+)
			   AND DEDUCTIBLES.DED_SUBLINE_CD = DEDUCT_DESC.SUBLINE_CD (+)
			   AND DEDUCTIBLES.DED_LINE_CD = DEDUCT_DESC.LINE_CD (+)
			   AND DEDUCTIBLES.DED_LINE_CD = PERIL.LINE_CD (+)
			   AND DEDUCTIBLES.PERIL_CD = PERIL.PERIL_CD (+)
			   AND DEDUCTIBLES.EXTRACT_ID = p_extract_id
			   AND DEDUCTIBLES.ITEM_NO = p_item_no;
	BEGIN
		FOR i IN G_EXTRACT_ID11
		LOOP
			v_deductible_table.extract_id			:= i.extract_id;
			v_deductible_table.item_no				:= i.DEDUCTIBLES_ITEM_NO;
			v_deductible_table.deductible_title	    := i.DEDUCTDESC_DEDUCTIBLE_TITLE;
			v_deductible_table.ded_deductible_text	:= i.DEDUCTIBLES_DEDUCTIBLE_TEXT;
			v_deductible_table.ded_deductible_amt	:= i.DEDUCTIBLES_DEDUCTIBLE_AMT;
			v_deductible_table.ded_line_cd			:= i.DEDUCTIBLES_DED_LINE_CD;
			v_deductible_table.ded_subline_cd		:= i.DEDUCTIBLES_DED_SUBLINE_CD;
			v_deductible_table.ded_deductible_cd	:= i.DEDUCTIBLES_DED_DEDUCTIBLE_CD;
			v_deductible_table.deductible_rt		:= i.DEDUCTIBLES_DEDUCTIBLE_RT;
			v_deductible_table.ded_peril_sname		:= i.DEDUCTIBLES_PERIL_SNAME;
			v_deductible_table.deductible_amt		:= i.DEDUCTIBLE_AMOUNT;

			v_deductible_table.f_deductible_amt := Q_DEDUCTIBLES.get_deductible_amount(p_extract_id, p_item_no, i.deductible_amount);

			PIPE ROW(v_deductible_table);
		END LOOP;

	END get_records;


	FUNCTION get_deductible_amount (
		p_extract_id		IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no			IN GIXX_ITEM.item_no%TYPE,
		p_deductible_amt	IN GIXX_DEDUCTIBLES.deductible_amt%TYPE)
	RETURN NUMBER
	IS
		v_currency_rt		GIPI_ITEM.currency_rt%TYPE;
		v_policy_currency   GIPI_INVOICE.policy_currency%TYPE;
	BEGIN
		FOR A IN (
			SELECT b.currency_rt,NVL(a.policy_currency,'N') policy_currency
				FROM GIXX_ITEM b, GIXX_INVOICE a
			   WHERE b.extract_id = p_extract_id
				 AND a.extract_id = b.extract_id
				 AND b.item_no      = p_item_no)
		LOOP
			v_currency_rt := A.currency_rt;
			v_policy_currency := A.policy_currency;
		END LOOP;

		IF NVL(v_policy_currency,'N') = 'Y' THEN
			RETURN(NVL(p_deductible_amt , 0));
		ELSE
			RETURN(NVL((p_deductible_amt  * NVL(v_currency_rt,1)), 0));
		END IF;
	END get_deductible_amount;

END Q_DEDUCTIBLES;
/



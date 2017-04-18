DROP PROCEDURE CPI.GIPIS003_REQUIRED_FIRE_COLS;

CREATE OR REPLACE PROCEDURE CPI.Gipis003_Required_Fire_Cols (
	p_fi_risk_tag		OUT GIIS_PARAMETERS.param_value_v%TYPE,
	p_fi_construction	OUT GIIS_PARAMETERS.param_value_v%TYPE,
	p_fi_occupancy		OUT GIIS_PARAMETERS.param_value_v%TYPE,
	p_fi_risk_no		OUT GIIS_PARAMETERS.param_value_v%TYPE,
	p_fi_item_type		OUT GIIS_PARAMETERS.param_value_v%TYPE,
	p_result			OUT VARCHAR2)
AS
BEGIN
	p_result := 'SUCCESS';
	FOR i IN (
		SELECT Giisp.v('REQUIRE_FI_RISK_TAG') risk_tag,
			   Giisp.v('REQUIRE_FI_CONSTRUCTION') construction,
			   Giisp.v('REQUIRE_FI_OCCUPANCY') occupancy,
			   Giisp.v('REQUIRE_FI_RISK_NO') risk_no,
			   Giisp.v('REQUIRE_FI_FIREITEM_TYPE') item_type
		  FROM dual)
	LOOP
		p_fi_risk_tag		:= i.risk_tag;
		p_fi_construction	:= i.construction;
		p_fi_occupancy		:= i.occupancy;
		p_fi_risk_no		:= i.risk_no;
		p_fi_item_type		:= i.item_type;
	END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		p_result := SQLERRM;
END;
/



CREATE OR REPLACE PACKAGE CPI.GIIS_PACKAGE_BENEFIT_DTL_PKG
AS

 TYPE giis_package_benefit_dtl_type IS RECORD
    (pack_ben_cd 			GIIS_PACKAGE_BENEFIT_DTL.pack_ben_cd%TYPE,
	 peril_cd				GIIS_PACKAGE_BENEFIT_DTL.peril_cd%TYPE,
	 peril_name				GIIS_PERIL.peril_name%TYPE,
	 benefit				GIIS_PACKAGE_BENEFIT_DTL.benefit%TYPE,
	 prem_pct				GIIS_PACKAGE_BENEFIT_DTL.prem_pct%TYPE,
	 remarks				GIIS_PACKAGE_BENEFIT_DTL.remarks%TYPE,
	 user_id				GIIS_PACKAGE_BENEFIT_DTL.user_id%TYPE,
	 last_update			GIIS_PACKAGE_BENEFIT_DTL.last_update%TYPE,
	 prem_amt				GIIS_PACKAGE_BENEFIT_DTL.prem_amt%TYPE,
	 no_of_days				GIIS_PACKAGE_BENEFIT_DTL.no_of_days%TYPE,
	 aggregate_sw			GIIS_PACKAGE_BENEFIT_DTL.aggregate_sw%TYPE,
	 peril_type				GIIS_PERIL.peril_type%TYPE
	 );

  TYPE giis_package_benefit_dtl_tab IS TABLE OF giis_package_benefit_dtl_type;	 
	
  FUNCTION get_giis_package_benefit_dtl(p_line_cd		GIPI_WPOLBAS.line_cd%TYPE)
    RETURN giis_package_benefit_dtl_tab PIPELINED;
END;
/



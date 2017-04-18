CREATE OR REPLACE PACKAGE BODY CPI.GIIS_PACKAGE_BENEFIT_DTL_PKG
AS

	 /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 06.02.2010
	**  Reference By 	: (GIPIS012- Item Information - Accident - Grouped Items - Coverage)
	**  Description 	: for populate/overwrite perils for  grouped item
	*/
  FUNCTION get_giis_package_benefit_dtl(p_line_cd		GIPI_WPOLBAS.line_cd%TYPE)
    RETURN giis_package_benefit_dtl_tab PIPELINED IS
	v_dtl giis_package_benefit_dtl_type;
  BEGIN
    FOR i IN (SELECT a.pack_ben_cd,      a.peril_cd,      a.benefit,
		  	 		 a.prem_pct, 		 a.remarks, 	  a.user_id,
					 a.last_update, 	 a.prem_amt, 	  a.no_of_days,
					 a.aggregate_sw,	 b.peril_type,	  b.peril_name
		  	    FROM GIIS_PACKAGE_BENEFIT_DTL a,
					 GIIS_PERIL b
			   WHERE a.peril_cd = b.peril_cd(+)
			     AND b.line_cd(+) = p_line_cd
		  	   ORDER BY upper(pack_ben_cd))
	LOOP
	  v_dtl.pack_ben_cd 	:= i.pack_ben_cd;
	  v_dtl.peril_cd		:= i.peril_cd;
	  v_dtl.benefit			:= i.benefit;
	  v_dtl.prem_pct		:= i.prem_pct;
	  v_dtl.remarks			:= i.remarks;
	  v_dtl.user_id			:= i.user_id;
	  v_dtl.last_update		:= i.last_update;
	  v_dtl.prem_amt		:= i.prem_amt;
	  v_dtl.no_of_days		:= i.no_of_days;
	  v_dtl.aggregate_sw	:= i.aggregate_sw;
	  v_dtl.peril_name		:= i.peril_name;
	  v_dtl.peril_type		:= i.peril_type;
	  PIPE ROW(v_dtl);
	END LOOP;
	RETURN;
  END;

END;
/



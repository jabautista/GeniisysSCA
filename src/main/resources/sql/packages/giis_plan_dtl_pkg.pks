CREATE OR REPLACE PACKAGE CPI.GIIS_PLAN_DTL_PKG AS

  TYPE giis_plan_dtl_type IS RECORD (
      peril_cd			  GIIS_PLAN_DTL.peril_cd%TYPE,
	  aggregate_sw		  GIIS_PLAN_DTL.aggregate_sw%TYPE,
	  base_amt			  GIIS_PLAN_DTL.base_amt%TYPE,
	  line_cd			  GIIS_PLAN_DTL.line_cd%TYPE,
	  no_of_days		  GIIS_PLAN_DTL.no_of_days%TYPE,
	  prem_amt			  GIIS_PLAN_DTL.prem_amt%TYPE,
	  prem_rt		      GIIS_PLAN_DTL.prem_rt%TYPE,
	  tsi_amt			  GIIS_PLAN_DTL.tsi_amt%TYPE,
	  peril_type		  GIIS_PERIL.peril_type%TYPE
   );
   
  TYPE giis_plan_dtl_tab IS TABLE OF giis_plan_dtl_type;
  
  FUNCTION get_giis_plan_dtls(p_par_id	GIPI_WPOLBAS.par_id%TYPE)
    RETURN giis_plan_dtl_tab PIPELINED;
  
END GIIS_PLAN_DTL_PKG;
/



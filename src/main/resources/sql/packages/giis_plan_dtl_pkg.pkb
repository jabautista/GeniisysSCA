CREATE OR REPLACE PACKAGE BODY CPI.GIIS_PLAN_DTL_PKG AS

  /*   Created by 		  : Bryan Joseph g. Abuluyan
   *   Date Created		  : November 9, 2010
   *   Module			  : GIPIS038
   */ 
  FUNCTION get_giis_plan_dtls(p_par_id	GIPI_WPOLBAS.par_id%TYPE)
    RETURN giis_plan_dtl_tab PIPELINED IS
	
	v_plan_dtl    giis_plan_dtl_type;
  
  BEGIN
  
    FOR i IN (
	     SELECT a.peril_cd, a.aggregate_sw, nvl(a.base_amt,0) base_amt, a.line_cd,
		 		nvl(a.no_of_days,0) no_of_days, nvl(a.prem_amt,0) prem_amt, nvl(a.prem_rt,0) prem_rt,
				nvl(a.tsi_amt,0) tsi_amt, c.peril_type 
		   FROM GIIS_PLAN_DTL a, GIPI_WPOLBAS b, GIIS_PERIL c
		  WHERE a.plan_cd = b.plan_cd 
		    AND a.peril_cd = c.peril_cd
            AND a.line_cd = c.line_cd
			AND b.par_id = p_par_id
		  ORDER BY c.peril_type DESC)
	LOOP
	  v_plan_dtl.peril_cd  		   := i.peril_cd;
	  v_plan_dtl.aggregate_sw  	   := i.aggregate_sw;
	  v_plan_dtl.base_amt  		   := i.base_amt;
	  v_plan_dtl.line_cd  		   := i.line_cd;
	  v_plan_dtl.no_of_days  	   := i.no_of_days;
	  v_plan_dtl.prem_amt  		   := i.prem_amt;
	  v_plan_dtl.prem_rt  		   := i.prem_rt;
	  v_plan_dtl.tsi_amt  		   := i.tsi_amt;
	  v_plan_dtl.peril_type  	   := i.peril_type;
	  PIPE ROW(v_plan_dtl);
	END LOOP;
	
	RETURN;
  
  END get_giis_plan_dtls;

END GIIS_PLAN_DTL_PKG;
/



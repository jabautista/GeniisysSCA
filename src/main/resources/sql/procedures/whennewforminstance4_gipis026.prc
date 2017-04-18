DROP PROCEDURE CPI.WHENNEWFORMINSTANCE4_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.WHENNEWFORMINSTANCE4_GIPIS026(
	   	  		  			 PG_PACK_PAR_ID    IN  GIPI_PARLIST.PACK_PAR_ID%TYPE
							,PG_CG$B240_PAR_ID IN  GIPI_WOPEN_PERIL.PAR_ID%TYPE
							,PV_LC_MN 		   OUT GIIS_PARAMETERS.PARAM_VALUE_V%TYPE
							,P_EXIST 		   OUT VARCHAR2 ) IS						
BEGIN
 FOR B IN( SELECT param_value_v
             FROM giis_parameters
            WHERE param_name LIKE 'LINE_CODE_MN') LOOP
 PV_LC_MN := b.param_value_v;
 EXIT;
 END LOOP;
 IF PG_PACK_PAR_ID IS NOT NULL THEN
	         FOR A IN( SELECT '1'
	                     FROM gipi_wopen_peril a,
	                          gipi_parlist b
	                    WHERE a.par_id = b.par_id
	                      AND b.pack_par_id = PG_PACK_PAR_ID
	                      AND a.prem_rate IS NOT NULL) LOOP
	             P_EXIST := 'Y';
	             EXIT;
	         END LOOP;
 ELSE	
	         FOR A IN( SELECT '1'
	                     FROM gipi_wopen_peril
	                    WHERE par_id = PG_CG$B240_PAR_ID
	                      AND prem_rate IS NOT NULL) LOOP
	             P_EXIST := 'Y';
	             EXIT;
	         END LOOP;
END IF;
END;
/



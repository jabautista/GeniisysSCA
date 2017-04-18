DROP FUNCTION CPI.CF_CAR_COMPANY_MAKEFORMULA;

CREATE OR REPLACE FUNCTION CPI.cf_car_company_makeformula(
	   p_policy_id  gipi_vehicle.policy_id%TYPE) RETURN CHAR IS
	   v_car_company_make VARCHAR2(100);
BEGIN
	 SELECT a.car_company || ' ' || b.make car_company_make
	   INTO v_car_company_make
	   FROM GIIS_MC_CAR_COMPANY a, GIPI_VEHICLE b
	  WHERE a.car_company_cd = b.car_company_cd
	    AND b.policy_id = p_policy_id;
		
	 RETURN(v_car_company_make);
	 
	 EXCEPTION WHEN NO_DATA_FOUND THEN
	 	 RETURN (NULL);
END;
/



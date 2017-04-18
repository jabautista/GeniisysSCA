DROP FUNCTION CPI.GET_CAR_COMPANY_GIPIR915;

CREATE OR REPLACE FUNCTION CPI.GET_CAR_COMPANY_GIPIR915(
       p_policy_id  gipi_vehicle.policy_id%TYPE,
       p_item_no    gipi_vehicle.item_no%TYPE) RETURN CHAR IS
       v_car_company_make VARCHAR2(100);
BEGIN
     SELECT a.car_company || ' ' || b.make car_company_make
       INTO v_car_company_make
       FROM GIIS_MC_CAR_COMPANY a, GIPI_VEHICLE b
      WHERE a.car_company_cd = b.car_company_cd
        AND b.policy_id = p_policy_id
        AND b.item_no = p_item_no;
        
     RETURN(v_car_company_make);
     
     EXCEPTION WHEN NO_DATA_FOUND THEN
          RETURN (NULL);
END;
/



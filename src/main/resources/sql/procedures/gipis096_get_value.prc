DROP PROCEDURE CPI.GIPIS096_GET_VALUE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS096_GET_VALUE
(p_subline_motorcycle    OUT  GIIS_PARAMETERS.param_value_v%TYPE,
 p_subline_commercial    OUT  GIIS_PARAMETERS.param_value_v%TYPE,
 p_subline_private       OUT  GIIS_PARAMETERS.param_value_v%TYPE,
 p_subline_lto           OUT  GIIS_PARAMETERS.param_value_v%TYPE,
 p_coc_lto               OUT  GIIS_PARAMETERS.param_value_v%TYPE,
 p_coc_nlto              OUT  GIIS_PARAMETERS.param_value_v%TYPE) 
IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : July 21, 2011
**  Reference By : (GIPIS096 - Package Endt PAR Policy Items)
**  Description  : Equivalent to the Program Unit GET_VALUE in GIPIS096 module
*/

  counter   NUMBER;
BEGIN
  FOR LINE IN( SELECT param_value_v cd
               FROM GIIS_PARAMETERS
               WHERE param_name = 'MOTOR CAR')
  LOOP
       counter := NVL(counter,0) + 1;
  END LOOP;
  
  IF NVL(counter,0) = 0 THEN
       RAISE_APPLICATION_ERROR(-20001, 'Error in getting values from GIIS_PARAMETERS for parameter name MOTOR CAR');
  ELSIF NVL(counter,0) > 1 THEN
       RAISE_APPLICATION_ERROR(-20001,'Too many rows fetch from GIIS_PARAMETERS for parameter name MOTOR CAR');
  END IF;
  
  counter := 0;    
  FOR MOTORCYCLE IN ( SELECT param_value_v cd
                      FROM GIIS_PARAMETERS
                      WHERE param_name = 'MOTORCYCLE')
  LOOP
       p_subline_motorcycle := motorcycle.cd;
       counter := NVL(counter,0) + 1;
  END LOOP;
  
  IF NVL(counter,0) = 0 THEN
       RAISE_APPLICATION_ERROR(-20001,'Error in getting values from GIIS_PARAMETERS for parameter name MOTORCYCLE');
  ELSIF NVL(counter,0) > 1 THEN
       RAISE_APPLICATION_ERROR(-20001,'Too many rows fetch from GIIS_PARAMETERS for parameter name MOTORCYCLE');
  END IF;
  
  counter := 0;
  FOR COMMERCIAL IN ( SELECT param_value_v cd
                      FROM GIIS_PARAMETERS
                      WHERE param_name = 'COMMERCIAL VEHICLE')
  LOOP
       p_subline_commercial := commercial.cd;
       counter := NVL(counter,0) + 1;
  END LOOP;
  
  IF NVL(counter,0) = 0 THEN
       RAISE_APPLICATION_ERROR(-20001,'Error in getting values from GIIS_PARAMETERS for parameter name COMMERCIAL VEHICLE');
  ELSIF NVL(counter,0) > 1 THEN
       RAISE_APPLICATION_ERROR(-20001,'Too many rows fetch from GIIS_PARAMETERS for parameter name COMMERCIAL VEHICLE');
  END IF;
  
  counter := 0;
  FOR PRIVATE_CAR IN ( SELECT param_value_v cd
                       FROM GIIS_PARAMETERS
                       WHERE param_name = 'PRIVATE CAR')
  LOOP
       p_subline_private := private_car.cd;
       counter := NVL(counter,0) + 1;
  END LOOP;
  
  IF NVL(counter,0) = 0 THEN
       RAISE_APPLICATION_ERROR(-20001,'Error in getting values from GIIS_PARAMETERS for parameter name PRIVATE CAR');
  ELSIF NVL(counter,0) > 1 THEN
       RAISE_APPLICATION_ERROR(-20001,'Too many rows fetch from GIIS_PARAMETERS for parameter name PRIVATE CAR');
  END IF;
  
  counter := 0;
  FOR LTO IN ( SELECT param_value_v cd
               FROM GIIS_PARAMETERS
               WHERE param_name = 'LAND TRANS. OFFICE')
  LOOP
       p_subline_lto := lto.cd;
       counter := NVL(counter,0) + 1;
  END LOOP;
  
  IF NVL(counter,0) = 0 THEN
       RAISE_APPLICATION_ERROR(-20001,'Error in getting values from GIIS_PARAMETERS for parameter name LAND TRANS. OFFICE');
  ELSIF NVL(counter,0) > 1 THEN
       RAISE_APPLICATION_ERROR(-20001,'Too many rows fetch from GIIS_PARAMETERS for parameter name LAND TRANS. OFFICE');
  END IF;
  
  counter := 0;
  FOR LTO_TYPE IN ( SELECT param_value_v cd
                    FROM GIIS_PARAMETERS
                    WHERE param_name = 'COC_TYPE_LTO')
  LOOP
       p_coc_lto := lto_type.cd;
       counter := NVL(counter,0) + 1;
  END LOOP;
  
  IF NVL(counter,0) = 0 THEN
       RAISE_APPLICATION_ERROR(-20001,'Error in getting values from GIIS_PARAMETERS for parameter name COC_TYPE_LTO');
  ELSIF NVL(counter,0) > 1 THEN
       RAISE_APPLICATION_ERROR(-20001,'Too many rows fetch from GIIS_PARAMETERS for parameter name COC_TYPE_LTO');
  END IF;
  
  counter := 0;    
  FOR NLTO_TYPE IN( SELECT param_value_v cd
                    FROM GIIS_PARAMETERS
                    WHERE param_name = 'COC_TYPE_NLTO')
  LOOP
       p_coc_nlto := nlto_type.cd;
       counter := NVL(counter,0) + 1;
  END LOOP;
  
  IF NVL(counter,0) = 0 THEN
       RAISE_APPLICATION_ERROR(-20001,'Error in getting values from GIIS_PARAMETERS for parameter name COC_TYPE_NLTO');
  ELSIF NVL(counter,0) > 1 THEN
       RAISE_APPLICATION_ERROR(-20001,'Too many rows fetch from GIIS_PARAMETERS for parameter name COC_TYPE_NLTO');
  END IF;
          
END;
/



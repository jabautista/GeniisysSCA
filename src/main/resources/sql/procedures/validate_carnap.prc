DROP PROCEDURE CPI.VALIDATE_CARNAP;

CREATE OR REPLACE PROCEDURE CPI.Validate_Carnap(
                       p_par_id            IN  GIPI_PARLIST.par_id%TYPE,        
                       p_msg_alert        OUT VARCHAR2
                       )
        IS
  v_param_value        GIIS_PARAMETERS.param_value_v%TYPE;
  v_msg_alert        VARCHAR2(2000) := '';
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : Validate_Carnap program unit
  */
  
  /*BEGIN
    SELECT param_value_v 
      INTO v_param_value
      FROM giis_parameters
     WHERE param_name='CHECK_CLTLOSS';
  
  EXCEPTION --added by Connie 12/04/06
         WHEN no_data_found THEN
           v_param_value := 'N'; 
  END;*/
 
 v_param_value := NVL(Giisp.v('CHECK_CLTLOSS'),'N');
    
 IF  v_param_value ='Y' THEN             
             FOR B IN (SELECT DISTINCT item_no 
                              FROM GIPI_WITEM
                              WHERE par_id=p_par_id)
          LOOP
                      FOR C IN (SELECT plate_no,serial_no,motor_no 
                                  FROM GIPI_WVEHICLE
                                  WHERE plate_no IS NOT NULL
                                  AND item_no=B.item_no
                                  AND par_id=p_par_id)
                      LOOP
                                  FOR D IN (SELECT 1 
                                                      FROM FP_CLTLOSS 
                                                      WHERE veh_plate    =c.plate_no
                                                      OR    veh_chasSis=c.serial_no
                                                      OR        veh_motor    =c.motor_no)
                                  LOOP
                                      v_msg_alert := 'Vehicle exists in total loss and carnap claims tabel Cannot Proceed with transaction';      
                                  END LOOP;
                      END LOOP;                        
          END LOOP;     
 END IF;
 p_msg_alert := NVL(v_msg_alert,'');
       
END;
/



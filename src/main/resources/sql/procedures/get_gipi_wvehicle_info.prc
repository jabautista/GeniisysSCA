DROP PROCEDURE CPI.GET_GIPI_WVEHICLE_INFO;

CREATE OR REPLACE PROCEDURE CPI.GET_GIPI_WVEHICLE_INFO
(p_policy_id        IN      GIPI_VEHICLE.policy_id%TYPE,
 p_item_no          IN      GIPI_VEHICLE.item_no%TYPE,
 p_subline_cd       OUT     GIPI_VEHICLE.subline_cd%TYPE,
 p_motor_no         OUT     GIPI_VEHICLE.motor_no%TYPE,
 p_serial_no        OUT     GIPI_VEHICLE.serial_no%TYPE,
 p_plate_no         OUT     GIPI_VEHICLE.plate_no%TYPE,
 p_coc_type         OUT     GIPI_VEHICLE.coc_type%TYPE,
 p_coc_yy           OUT     GIPI_VEHICLE.coc_yy%TYPE,
 p_unladen_wt       OUT     GIPI_VEHICLE.unladen_wt%TYPE,
 p_mot_type         OUT     GIPI_VEHICLE.mot_type%TYPE,
 p_subline_type_cd  OUT     GIPI_VEHICLE.subline_type_cd%TYPE,
 p_motor_coverage   OUT     GIPI_VEHICLE.motor_coverage%TYPE) 
 
IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : July 21, 2011
**  Reference By : (GIPIS096 - Package Endt PAR Policy Items)
**  Description  : Gets the vehicle information if item exists in the policy being endorsed.
*/

BEGIN
  FOR C2 IN (SELECT  subline_cd,
                     motor_no,
                     plate_no,
                     serial_no,
                     coc_type,coc_yy,
                     mot_type,           
                     unladen_wt,         
                     subline_type_cd,    
                     motor_coverage      
               FROM  GIPI_VEHICLE
              WHERE  policy_id = p_policy_id
                AND  item_no   = p_item_no)    
  LOOP      
    p_subline_cd :=  c2.subline_cd;
    p_motor_no   :=  c2.motor_no;
    p_serial_no  :=  c2.serial_no;
    p_plate_no   :=  c2.plate_no;
    p_coc_type   :=  c2.coc_type;
    p_coc_yy     :=  c2.coc_yy;
    p_unladen_wt :=  c2.unladen_wt;       
    p_mot_type    :=  c2.mot_type;         
    p_subline_type_cd := c2.subline_type_cd;   
    p_motor_coverage  :=  c2.motor_coverage;  
    EXIT;
  END LOOP;
   
END;
/



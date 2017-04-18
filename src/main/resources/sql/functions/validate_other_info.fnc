DROP FUNCTION CPI.VALIDATE_OTHER_INFO;

CREATE OR REPLACE FUNCTION CPI.Validate_Other_Info(p_par_id	IN GIPI_WVEHICLE.par_id%TYPE, p_item_no	IN GIPI_WVEHICLE.item_no%TYPE) --added p_item_no Kenneth L. 03.27.2014
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.26.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Returns a message if the record's plate no/chassis no/engine no
	**					  already exists in other records
	*/
	v_mess			VARCHAR2(2000);
	pol_motor		GIPI_POLBASIC.policy_id%TYPE;
	pol_serial		GIPI_POLBASIC.policy_id%TYPE;
	pol_plate		GIPI_POLBASIC.policy_id%TYPE;
	par_motor		GIPI_WPOLBAS.par_id%TYPE;
	par_serial		GIPI_WPOLBAS.par_id%TYPE;
	par_plate		GIPI_WPOLBAS.par_id%TYPE;
	cnt_motor		NUMBER :=0;
	cnt_serial		NUMBER :=0;
	cnt_plate		NUMBER :=0;
	cnt_motor1		NUMBER :=0;
	cnt_serial1        NUMBER :=0;
    cnt_plate1        NUMBER :=0;        
    v_pol_flag        GIPI_POLBASIC.pol_flag%TYPE;
    v_par_stat        GIPI_PARLIST.par_status%TYPE;
    v_result        VARCHAR2(160);
BEGIN
    FOR A1 IN ( 
        SELECT item_no, motor_no, serial_no, plate_no
          FROM GIPI_WVEHICLE
         WHERE par_id = p_par_id
          AND item_no = p_item_no)--added p_item_no Kenneth L. 03.27.2014
    LOOP
        pol_motor    := NULL;
        pol_serial   := NULL;
        pol_plate    := NULL;
        par_motor    := NULL;
        par_serial   := NULL;
        par_plate    := NULL;        
        cnt_motor    := 0;
        cnt_serial   := 0;
        cnt_plate    := 0;
        cnt_motor1   := 0;
        cnt_serial1  := 0;
        cnt_plate1   := 0;
        
        FOR A2 IN (
            SELECT policy_id, item_no, plate_no,serial_no, motor_no
              FROM GIPI_VEHICLE
             WHERE motor_no  = a1.motor_no
                OR serial_no = a1.serial_no
                OR plate_no  = a1.plate_no
        ORDER BY policy_id, item_no)
        LOOP
            IF a2.motor_no = a1.motor_no THEN
                IF a2.policy_id <> NVL(pol_motor,0) THEN
                    cnt_motor := cnt_motor +1;
                END IF;   
                IF cnt_motor = 1 THEN
                    pol_motor  := a2.policy_id;
                END IF;
            END IF;      
            IF a2.plate_no = a1.plate_no THEN
                IF a2.policy_id <> NVL(pol_plate,0) THEN
                    cnt_plate := cnt_plate +1;
                END IF;   
                IF cnt_plate = 1 THEN
                    pol_plate  := a2.policy_id;
                END IF;
            END IF;            
            IF a2.serial_no = a1.serial_no THEN
                IF a2.policy_id <> NVL(pol_serial,0) THEN
                    cnt_serial := cnt_serial +1;
                END IF;
                IF cnt_serial = 1 THEN
                    pol_serial  := a2.policy_id;
                END IF;
            END IF;
            FOR B2 IN (
                SELECT pol_flag
                FROM GIPI_POLBASIC
                WHERE policy_id = a2.policy_id)
            LOOP
                v_pol_flag := b2.pol_flag;
            END LOOP;
        END LOOP;     
        
        FOR A3 IN (
            SELECT par_id, item_no, plate_no,serial_no,motor_no
            FROM GIPI_WVEHICLE
            WHERE motor_no  = a1.motor_no
                OR serial_no = a1.serial_no
                OR plate_no  = a1.plate_no
        ORDER BY par_id, item_no)
        LOOP
            IF (p_par_id <> a3.par_id) OR (p_par_id = a3.par_id AND a1.item_no <> a3.item_no) THEN                                                 
                IF a3.motor_no = a1.motor_no THEN
                    IF a3.par_id <> NVL(par_motor,0) THEN
                        cnt_motor1 := cnt_motor1 +1;
                    END IF;
                    IF cnt_motor1 = 1 THEN
                        par_motor  := a3.par_id;
                    END IF;
                END IF;      
                IF a3.plate_no = a1.plate_no THEN
                    IF a3.par_id <> NVL(par_plate,0) THEN
                        cnt_plate1:= cnt_plate1 +1;
                    END IF;
                    IF cnt_plate1 = 1 THEN
                        par_plate  := a3.par_id;
                    END IF;
                END IF;            
                IF a3.serial_no = a1.serial_no THEN
                    IF a3.par_id <> NVL(par_serial,0) THEN
                        cnt_serial1 := cnt_serial1 +1;
                    END IF;
                    IF cnt_serial1 = 1 THEN
                        par_serial  := a3.par_id;
                    END IF;
                END IF;
                FOR B3 IN (
                    SELECT par_status
                    FROM GIPI_PARLIST
                    WHERE par_id = a3.par_id)
                LOOP
                    v_par_stat := b3.par_status;
                END LOOP;
            END IF;
        END LOOP;
         
        IF ((cnt_motor + cnt_plate +  cnt_serial ) > 0 AND v_pol_flag <> '5') OR
            ((cnt_motor1 + cnt_plate1 +  cnt_serial1 ) > 0 AND v_par_stat NOT IN (98,99)) THEN        
            v_result := 'Vehicle item information (plate no, chassis no, engine no) already exist in other record/s. ' || 
                        'Please check the details at View motor issuance screen.';
            EXIT;            
        END IF;        

    END LOOP;
    RETURN v_result;
END;
/



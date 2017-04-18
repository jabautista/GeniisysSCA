DROP PROCEDURE CPI.VALIDATE_SERIAL_MOTOR;

CREATE OR REPLACE PROCEDURE CPI.Validate_Serial_Motor(
	   	  		  p_par_id			IN  GIPI_PARLIST.par_id%TYPE,
				  p_msg_alert		OUT VARCHAR2
	   	  		  )
	    IS

v_exist_in  			VARCHAR2(1):='N';
v_exist     			VARCHAR2(1):='N';
cnt_item  				NUMBER:=0;
v_plate_no				VARCHAR2(10);
v_plate_cnt 			NUMBER:=0;
v_claims				NUMBER:=0;
v_line_cd				GIPI_POLBASIC.line_cd%TYPE;
v_subline_cd			GIPI_POLBASIC.subline_cd%TYPE;
v_iss_cd				GIPI_POLBASIC.iss_cd%TYPE;
v_issue_yy				GIPI_POLBASIC.issue_yy%TYPE;
v_pol_seq_no			GIPI_POLBASIC.pol_seq_no%TYPE;
v_renew_no				GIPI_POLBASIC.renew_no%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : Validate_Serial_Motor program unit
  */
	SELECT COUNT(*) INTO cnt_item FROM GIPI_WITEM --count items for that PAR
  WHERE par_id =p_par_id;

/*check if the motor_no  exist in gicl_motor_car_dtl  and  the gicl_claims.total_tag ='Y'*/
  		FOR B IN (SELECT DISTINCT item_no 
  							FROM GIPI_WITEM
  							WHERE par_id=p_par_id)
  		LOOP
  				v_exist_in:='N';
  				
  			  FOR C IN (SELECT motor_no,serial_no 
  					FROM GIPI_WVEHICLE
  					WHERE plate_no IS NOT NULL
  					AND item_no=B.item_no
  					AND par_id=p_par_id)
					LOOP
						
							FOR D IN (SELECT 1 FROM  GICL_MOTOR_CAR_DTL a ,GICL_CLAIMS b --if record exist, posting will not continue
												WHERE a.motor_no=c.motor_no
													AND a. claim_id=b.claim_id 
													AND b.total_tag='Y'
													AND clm_stat_cd NOT IN ('CC','WD','DN'))
							LOOP
								v_exist_in:='Y';
						  	p_msg_alert := 'Motor no - '||c.motor_no||' already tagged as total loss.'||CHR(10)||' Change the motor no before posting';  	
								EXIT;			
							END LOOP;	
							
							IF v_exist_in='N' THEN
									FOR D IN (SELECT 1 FROM  GICL_MOTOR_CAR_DTL a ,GICL_CLAIMS b --if record exist, posting will not continue
												WHERE a.serial_no=c.serial_no
													AND a. claim_id=b.claim_id 
													AND b.total_tag='Y'
													AND clm_stat_cd NOT IN ('CC','WD','DN'))
									LOOP
										v_exist_in:='Y';
						  			p_msg_alert := 'Serial No. - '||c.serial_no||' already tagged as total loss.'||CHR(10)||' Change the serial no before posting';  	
										EXIT;			
									END LOOP;	
							END IF;
									
					END LOOP;	
  		END LOOP;	


END;
/



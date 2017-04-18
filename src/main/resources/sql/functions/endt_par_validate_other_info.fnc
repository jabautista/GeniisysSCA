DROP FUNCTION CPI.ENDT_PAR_VALIDATE_OTHER_INFO;

CREATE OR REPLACE FUNCTION CPI.ENDT_PAR_VALIDATE_OTHER_INFO(
	   p_par_id	  			GIPI_WPOLBAS.par_id%TYPE,
	   p_func_part			NUMBER, -- Part of the function, this function has two parts, separated by a confirm dialog.
	   p_alert_confirm		VARCHAR2 --The answer choice of user to the confirm dialog query
 ) RETURN VARCHAR2 IS
  v_mess           VARCHAR2(2000);
  pol_motor        gipi_polbasic.policy_id%TYPE;
  pol_serial       gipi_polbasic.policy_id%TYPE;
  pol_plate        gipi_polbasic.policy_id%TYPE;
  par_motor        gipi_wpolbas.par_id%TYPE;
  par_serial       gipi_wpolbas.par_id%TYPE;
  par_plate        gipi_wpolbas.par_id%TYPE;
  cnt_motor        NUMBER :=0;
  cnt_serial       NUMBER :=0;
  cnt_plate        NUMBER :=0;
  cnt_motor1       NUMBER :=0;
  cnt_serial1      NUMBER :=0;
  cnt_plate1       NUMBER :=0;   	    
  serial_name      VARCHAR2(50);
  motor_name       VARCHAR2(50);
  plate_name       VARCHAR2(50);
  serial_name1     VARCHAR2(50);
  motor_name1      VARCHAR2(50);
  plate_name1      VARCHAR2(50);
  v_pol_flag       gipi_polbasic.pol_flag%TYPE;
  v_par_stat       gipi_parlist.par_status%TYPE;
BEGIN
   
   IF p_func_part = 2 AND p_alert_confirm = 'N' THEN
	  RETURN 'SUCCESS';
   END IF;

   FOR b540 IN
   	   ( SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
	       FROM GIPI_WPOLBAS
		  WHERE par_id = p_par_id
   	   ) LOOP
	  FOR A1 IN 
	      ( SELECT item_no, motor_no, serial_no, plate_no
	          FROM gipi_wvehicle
	         WHERE par_id = p_par_id
	      ) LOOP
	      pol_motor    := NULL;
	      pol_serial   := NULL;
	      pol_plate    := NULL;
	      par_motor    := NULL;
	      par_serial   := NULL;
	      par_plate    := NULL;
	      motor_name   := NULL;
	      serial_name  := NULL;
	      plate_name   := NULL;
	      motor_name1  := NULL;
	      serial_name1 := NULL;
	      plate_name1  := NULL;      
	      cnt_motor    := 0;
	      cnt_serial   := 0;
	      cnt_plate    := 0;
	      cnt_motor1   := 0;
	      cnt_serial1  := 0;
	      cnt_plate1   := 0;
	      FOR A2 IN 
	          ( SELECT policy_id, item_no, plate_no,serial_no, motor_no
	              FROM gipi_vehicle
	             WHERE (motor_no  = a1.motor_no
	                OR serial_no = a1.serial_no
	                OR plate_no  = a1.plate_no)
	               AND policy_id NOT IN 
	                   (SELECT policy_id
	                      FROM gipi_polbasic
	                     WHERE line_cd = b540.line_cd
	                       AND subline_cd = b540.subline_cd
	                       AND iss_cd = b540.iss_cd
	                       AND issue_yy = b540.issue_yy
	                       AND pol_seq_no = b540.pol_seq_no
	                       AND renew_no = b540.renew_no)
	            ORDER BY policy_id, item_no
	           ) LOOP
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
	           FOR B2 IN  --added by Connie, 06/28/2007
	             ( SELECT pol_flag
	                 FROM gipi_polbasic
	                WHERE policy_id = a2.policy_id
	              ) LOOP
	                  v_pol_flag := b2.pol_flag;
	                END LOOP;
	      END LOOP;     
	      FOR A3 IN 
	          ( SELECT par_id, item_no, plate_no,serial_no,motor_no
	              FROM gipi_wvehicle
	             WHERE motor_no  = a1.motor_no
	                OR serial_no = a1.serial_no
	                OR plate_no  = a1.plate_no
	            ORDER BY par_id, item_no
	           ) LOOP
	        IF (p_par_id <> a3.par_id) THEN                 	                    	    
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
	            FOR B3 IN  --added by Connie, 06/28/2007
	             ( SELECT par_status
	                 FROM gipi_parlist
	                WHERE par_id = a3.par_id
	              ) LOOP
	                  v_par_stat := b3.par_status;
	                END LOOP;            
	        END IF;
	      END LOOP;
	      IF cnt_motor = 1 THEN
	         FOR POL1 IN
	             ( SELECT LTRIM(RTRIM(ltrim(rtrim(line_cd))||'-'||ltrim(rtrim(subline_cd))||'-'||ltrim(rtrim(iss_cd))||'-'||
	                      ltrim(rtrim(to_char(issue_yy,'09')))||'-'||ltrim(rtrim(to_char(pol_seq_no,'0999999')))||'-'||ltrim(rtrim(to_char(renew_no,'09'))))) policy,
	                      decode(NVL(endt_seq_no,0),0,'*',' / '|| ltrim(rtrim(endt_iss_cd||'-'||
	                      ltrim(rtrim(to_char(endt_yy,'09')))||'-'||ltrim(rtrim(to_char(endt_seq_no,'0999999')))))) endt
	                 FROM gipi_polbasic
	                WHERE policy_id = pol_motor
	              ) LOOP 
	              motor_name := pol1.policy;
	              IF NVL(pol1.endt, '*') <> '*' THEN
	              	 motor_name := motor_name || pol1.endt;
	              END IF;
	         END LOOP;
	      END IF; 
	      IF cnt_serial = 1 THEN
	         FOR POL2 IN
	             ( SELECT LTRIM(RTRIM(ltrim(rtrim(line_cd))||'-'||ltrim(rtrim(subline_cd))||'-'||ltrim(rtrim(iss_cd))||'-'||
	                      ltrim(rtrim(to_char(issue_yy,'09')))||'-'||ltrim(rtrim(to_char(pol_seq_no,'0999999')))||'-'||ltrim(rtrim(to_char(renew_no,'09'))))) policy,
	                      decode(NVL(endt_seq_no,0),0,'*',' / '|| ltrim(rtrim(endt_iss_cd||'-'||
	                      ltrim(rtrim(to_char(endt_yy,'09')))||'-'||ltrim(rtrim(to_char(endt_seq_no,'0999999')))))) endt
	                 FROM gipi_polbasic
	                WHERE policy_id = pol_serial
	              ) LOOP 
	              serial_name := pol2.policy;
	              IF NVL(pol2.endt, '*') <> '*' THEN
	              	 serial_name := serial_name || pol2.endt;
	              END IF;
	         END LOOP;
	      END IF;       
	      IF cnt_plate = 1 THEN
	         FOR POL3 IN
	             ( SELECT LTRIM(RTRIM(ltrim(rtrim(line_cd))||'-'||ltrim(rtrim(subline_cd))||'-'||ltrim(rtrim(iss_cd))||'-'||
	                      ltrim(rtrim(to_char(issue_yy,'09')))||'-'||ltrim(rtrim(to_char(pol_seq_no,'0999999')))||'-'||ltrim(rtrim(to_char(renew_no,'09'))))) policy,
	                      decode(NVL(endt_seq_no,0),0,'*',' / '|| ltrim(rtrim(endt_iss_cd||'-'||
	                      ltrim(rtrim(to_char(endt_yy,'09')))||'-'||ltrim(rtrim(to_char(endt_seq_no,'0999999')))))) endt
	                 FROM gipi_polbasic
	                WHERE policy_id = pol_plate
	              ) LOOP 
	              plate_name := pol3.policy;
	              IF NVL(pol3.endt, '*') <> '*' THEN
	              	 plate_name := plate_name || pol3.endt;
	              END IF;
	         END LOOP;
	      END IF;       
	      IF (cnt_motor + cnt_plate +  cnt_serial ) > 0 
	      	 AND v_pol_flag <> '5' THEN --added by Connie 06/28/2007
	         IF cnt_motor = 1 AND cnt_plate = 1 AND cnt_serial = 1 AND
	            pol_motor = pol_plate AND pol_motor = pol_serial THEN
	             v_mess := 'ITEM ' ||to_char(a1.item_no)||'- serial no.('||a1.serial_no||
	                       ') / motor no.('||a1.motor_no||') / plate no.('||a1.plate_no||
	                       ') already exists in policy '||serial_name;                            
	         ELSIF cnt_motor = 1 AND cnt_plate = 1 AND
	               pol_motor = pol_plate THEN
	                 v_mess := 'ITEM ' ||to_char(a1.item_no)||'- motor no.('||a1.motor_no||
	                           ') / plate no.('||a1.plate_no||') already exists in policy '||plate_name;
	            IF cnt_serial > 1 THEN
	            	 v_mess := v_mess ||' / serial no.('||a1.serial_no||') already exists in various policies';
	            ELSIF cnt_serial = 1 THEN
	               v_mess := v_mess ||' / serial no.('||a1.serial_no||') already exists in policy '||serial_name;
	            END IF;       
	         ELSIF cnt_serial = 1 AND cnt_plate = 1 AND
	               pol_serial = pol_plate THEN
	                 v_mess := 'ITEM ' ||to_char(a1.item_no)||'- serial no.('||a1.serial_no||
	                           ') / plate no.('||a1.plate_no||') already exists in policy '||plate_name;
	            IF cnt_motor > 1 THEN
	            	 v_mess := v_mess ||' / motor no.('||a1.motor_no||') already exists in various policies';
	            ELSIF cnt_motor = 1 THEN
	               v_mess := v_mess ||' / motor no.('||a1.motor_no||') already exists in policy '||motor_name;
	            END IF;                
	         ELSIF cnt_serial = 1 AND cnt_motor = 1 AND
	               pol_serial = pol_motor THEN
	                 v_mess := 'ITEM ' ||to_char(a1.item_no)||'- motor no.('||a1.motor_no||
	                           ') / serial no.('||a1.serial_no||') already exists in policy '||serial_name;
	            IF cnt_plate > 1 THEN
	            	 v_mess := v_mess ||' / plate no.('||a1.plate_no||') already exists in various policies';
	            ELSIF cnt_plate = 1 THEN
	               v_mess := v_mess ||' / plate no.('||a1.plate_no||') already exists in policy '||plate_name;
	            END IF;
	         ELSIF cnt_motor > 1 AND cnt_serial > 1 AND cnt_plate > 1 THEN    
	             v_mess := 'ITEM ' ||to_char(a1.item_no)||'- serial no.('||a1.serial_no||
	                       ') / motor no.('||a1.motor_no||') / plate no.('||a1.plate_no||
	                       ') already exists in various policies';
	         ELSE
	            v_mess := 'ITEM ' ||to_char(a1.item_no)||'-'; 
	            IF cnt_motor = 1 THEN
	            	 v_mess := v_mess ||' motor no.('||a1.motor_no||') already exists in '||
	            	           motor_name;
	            ELSIF cnt_motor > 1 THEN
	               v_mess := v_mess ||' motor no.('||a1.motor_no||') already exists in various policies';
	            END IF;
	            IF cnt_motor > 0 AND cnt_serial > 0 THEN
	            	 v_mess := v_mess ||' / ';
	            END IF;
	            IF cnt_serial = 1 THEN
	               v_mess := v_mess ||' serial no.('||a1.serial_no||') already exists in '||
	                        serial_name;
	            ELSIF cnt_serial > 1 THEN
	               v_mess := v_mess ||' serial no.('||a1.serial_no||') already exists in various policies';
	            END IF;   
	            IF( cnt_motor > 0 OR  cnt_serial > 0 )and cnt_plate > 0 THEN
	            	 v_mess := v_mess ||' / ';
	            END IF;
	            IF cnt_plate = 1 THEN
	               v_mess := v_mess ||' plate no.('||a1.plate_no||') already exists in '||
	                        plate_name;
	            ELSIF cnt_plate > 1 THEN
	               v_mess := v_mess ||' plate no.('||a1.plate_no||') already exists in various policies';
	            END IF;               
	         END IF;
	         v_mess := v_mess||'.';
			 IF p_func_part = 1 THEN
				RETURN '1 ' || v_mess; --The number indicates the current part of the function. Space appended for string splitting
			 END IF;          
	      END IF;    
	      IF cnt_motor1 = 1 THEN
	         FOR PAR1 IN
	             ( SELECT LTRIM(RTRIM(ltrim(rtrim(line_cd))||'-'||ltrim(rtrim(iss_cd))||'-'||
	                      ltrim(rtrim(to_char(par_yy,'09')))||'-'||ltrim(rtrim(to_char(par_seq_no,'0999999'))))) par
	                 FROM gipi_parlist
	                WHERE par_id = par_motor
	              ) LOOP 
	              motor_name1 := par1.par;
	         END LOOP;
	      END IF;             
	      IF cnt_serial1 = 1 THEN
	         FOR PAR2 IN
	             ( SELECT LTRIM(RTRIM(ltrim(rtrim(line_cd))||'-'||ltrim(rtrim(iss_cd))||'-'||
	                      ltrim(rtrim(to_char(par_yy,'09')))||'-'||ltrim(rtrim(to_char(par_seq_no,'0999999'))))) par
	                 FROM gipi_parlist
	                WHERE par_id = par_serial
	              ) LOOP 
	              serial_name1 := par2.par;
	         END LOOP;
	      END IF;                   
	      IF cnt_plate1 = 1 THEN
	         FOR PAR3 IN
	             ( SELECT LTRIM(RTRIM(ltrim(rtrim(line_cd))||'-'||ltrim(rtrim(iss_cd))||'-'||
	                      ltrim(rtrim(to_char(par_yy,'09')))||'-'||ltrim(rtrim(to_char(par_seq_no,'0999999'))))) par
	                 FROM gipi_parlist
	                WHERE par_id = par_plate
	              ) LOOP 
	              plate_name1 := par3.par;
	         END LOOP;
	      END IF; 
	      IF (cnt_motor1 + cnt_plate1 +  cnt_serial1 ) > 0  
	         AND v_par_stat NOT IN (98,99) THEN  --added by Connie 06/28/2007
	         IF cnt_motor1 = 1 AND cnt_plate1 = 1 AND cnt_serial1 = 1 AND
	            par_motor = par_plate AND par_motor = par_serial THEN
	             v_mess := 'ITEM ' ||to_char(a1.item_no)||'- serial no.('||a1.serial_no||
	                       ') / motor no.('||a1.motor_no||') / plate no.('||a1.plate_no||
	                       ') already exists in PAR '||serial_name1;                            
	         ELSIF cnt_motor1 = 1 AND cnt_plate1 = 1 AND
	               par_motor = par_plate THEN
	                 v_mess := 'ITEM ' ||to_char(a1.item_no)||'- motor no.('||a1.motor_no||
	                           ') / plate no.('||a1.plate_no||') already exists in PAR '||plate_name1;
	            IF cnt_serial1 > 1 THEN
	            	 v_mess := v_mess ||' / serial no.('||a1.serial_no||') already exists in various PARs';
	            ELSIF cnt_serial1 = 1 THEN
	               v_mess := v_mess ||' / serial no.('||a1.serial_no||') already exists in PAR '||serial_name1;
	            END IF;       
	         ELSIF cnt_serial1 = 1 AND cnt_plate1 = 1 AND
	               par_serial = par_plate THEN
	                 v_mess := 'ITEM ' ||to_char(a1.item_no)||'- serial no.('||a1.serial_no||
	                           ') / plate no.('||a1.plate_no||') already exists in PAR '||plate_name1;
	            IF cnt_motor1 > 1 THEN
	            	 v_mess := v_mess ||' / motor no.('||a1.motor_no||') already exists in various PARs';
	            ELSIF cnt_motor1 = 1 THEN
	               v_mess := v_mess ||' / motor no.('||a1.motor_no||') already exists in PAR '||motor_name1;
	            END IF;                
	         ELSIF cnt_serial1 = 1 AND cnt_motor1 = 1 AND
	               par_serial = par_motor THEN
	                 v_mess := 'ITEM ' ||to_char(a1.item_no)||'- motor no.('||a1.motor_no||
	                           ') / serial no.('||a1.serial_no||') already exists in PAR '||serial_name1;
	            IF cnt_plate1 > 1 THEN
	            	 v_mess := v_mess ||' / plate no.('||a1.plate_no||') already exists in various PARs';
	            ELSIF cnt_plate1 = 1 THEN
	               v_mess := v_mess ||' / plate no.('||a1.plate_no||') already exists in PAR '||plate_name1;
	            END IF;
	         ELSIF cnt_motor1 > 1 AND cnt_serial1 > 1 AND cnt_plate1 > 1 THEN    
	             v_mess := 'ITEM ' ||to_char(a1.item_no)||'- serial no.('||a1.serial_no||
	                       ') / motor no.('||a1.motor_no||') / plate no.('||a1.plate_no||
	                       ') already exists in various PARs';
	         ELSE
	            v_mess := 'ITEM ' ||to_char(a1.item_no)||'-'; 
	            IF cnt_motor1 = 1 THEN
	            	 v_mess := v_mess ||' motor no.('||a1.motor_no||') already exists in PAR '||
	            	           motor_name1;
	            ELSIF cnt_motor1 > 1 THEN
	               v_mess := v_mess ||' motor no.('||a1.motor_no||') already exists in various PARs';
	            END IF;
	            IF cnt_motor1 > 0 AND cnt_serial1 > 0 THEN
	            	 v_mess := v_mess ||' / ';
	            END IF;
	            IF cnt_serial1 = 1 THEN
	               v_mess := v_mess ||' serial no.('||a1.serial_no||') already exists in PAR '||
	                        serial_name1;
	            ELSIF cnt_serial1 > 1 THEN
	               v_mess := v_mess ||' serial no.('||a1.serial_no||') already exists in various PARs';
	            END IF;   
	            IF( cnt_motor1 > 0 OR  cnt_serial1 > 0 )and cnt_plate1 > 0 THEN
	            	 v_mess := v_mess ||' / ';
	            END IF;
	            IF cnt_plate1 = 1 THEN
	               v_mess := v_mess ||' plate no.('||a1.plate_no||') already exists in PAR '||
	                        plate_name1;
	            ELSIF cnt_plate1 > 1 THEN
	               v_mess := v_mess ||' plate no.('||a1.plate_no||') already exists in various PARs';
	            END IF;               
	         END IF;
	         v_mess := v_mess||'.';
	         RETURN '2 ' || v_mess; --The number indicates the current part of the function. Space appended for string splitting   
	      END IF;
	  END LOOP;
   END LOOP;
   
   RETURN 'SUCCESS';
END;
/



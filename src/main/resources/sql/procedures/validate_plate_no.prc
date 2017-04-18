DROP PROCEDURE CPI.VALIDATE_PLATE_NO;

CREATE OR REPLACE PROCEDURE CPI.Validate_Plate_No(
	   	  		  p_par_id			IN  GIPI_PARLIST.par_id%TYPE,		
	   	  		  p_msg_alert		OUT VARCHAR2,
                  p_msg_icon        OUT VARCHAR2,
				  p_par_type		IN GIPI_PARLIST.par_type%TYPE	
				  )	
 IS
v_exist     		    VARCHAR2(1):='N';
cnt_item  				NUMBER:=0;
v_plate_no				GIPI_WVEHICLE.plate_no%TYPE;
v_plate_cnt 			NUMBER:=0;
v_claims				NUMBER:=0;
v_line_cd				GIPI_POLBASIC.line_cd%TYPE;
v_subline_cd			GIPI_POLBASIC.subline_cd%TYPE;
v_iss_cd				GIPI_POLBASIC.iss_cd%TYPE;
v_issue_yy				GIPI_POLBASIC.issue_yy%TYPE;
v_pol_seq_no			GIPI_POLBASIC.pol_seq_no%TYPE;
v_renew_no				GIPI_POLBASIC.renew_no%TYPE;
v_msg_alert				VARCHAR2(32000) := '';
v_msg_alert1		    VARCHAR2(32000) := '';
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : Validate_Plate_No program unit
  */

	SELECT COUNT(*) 
      INTO cnt_item 
      FROM GIPI_WITEM 
     WHERE par_id =p_par_id;

    /*check if the plate no exist in gicl_claims and total_tag ='Y'*/
  		FOR B IN (SELECT DISTINCT item_no 
  							FROM GIPI_WITEM
  							WHERE par_id=p_par_id)
  		LOOP
  			  FOR C IN (SELECT plate_no 
  					FROM GIPI_WVEHICLE
  					WHERE plate_no IS NOT NULL
  					AND item_no=B.item_no
  					AND par_id=p_par_id)
					LOOP
							FOR D IN (SELECT 1 FROM GICL_CLAIMS --if record exist, posting will not continue
												WHERE  plate_no=c.plate_no
												AND 	 total_tag='Y'
												AND clm_stat_cd NOT IN ('CC','WD','DN'))
							LOOP
						  	    p_msg_alert := 'Plate Number - '||c.plate_no||' already tagged as total loss Posting will not continue';  	
                                p_msg_icon  := 'E';
								EXIT;
                                RETURN;			
							END LOOP;						
					END LOOP;	
  		END LOOP;
		
--=======================================================================================

/*check if plate no already exist in other PAR or other policy*/	

IF p_par_type='P' THEN   
  IF cnt_item=1 THEN-- for PAR w/ 1 item
   BEGIN
     SELECT plate_no 
       INTO v_plate_no
       FROM GIPI_WVEHICLE
      WHERE plate_no IS NOT NULL
        AND par_id=p_par_id;
   
   EXCEPTION --added by Connie 12/09/06
     WHEN NO_DATA_FOUND THEN NULL;
   END;
   
   SELECT COUNT(*) -- count no of occurence of plate_no
     INTO v_plate_cnt
     FROM GIPI_WVEHICLE
    WHERE plate_no=v_plate_no;
   
   IF v_plate_cnt > 1 THEN--if it occurs more than 1, plate already exist in other PAR
  	  v_exist:='Y';
  	  Check_Exist_Par_Policy(p_par_id,v_msg_alert,'PAR','PLATE_NO',v_plate_no);
   END IF	;
   
   IF v_exist='N' THEN--if it does not occurs in other PAR, then check other Policy
   		FOR A IN (SELECT 1 FROM GIPI_VEHICLE
   							WHERE plate_no=v_plate_no	)
   		LOOP
			  	v_exist:='Y';
			  	Check_Exist_Par_Policy(p_par_id,v_msg_alert,'POLICY','PLATE_NO',v_plate_no);
   				EXIT;
   		END LOOP;
   END IF;
   
  
  END IF; 
 
  IF cnt_item > 1 THEN --for PAR w/ more than 1 item 
  		FOR B IN (SELECT DISTINCT item_no 
  							FROM GIPI_WITEM
  							WHERE par_id=p_par_id)
  		LOOP
  			v_exist:='N';
  			FOR C IN (SELECT plate_no 
  								FROM GIPI_WVEHICLE
  								WHERE plate_no IS NOT NULL
  								AND item_no=B.item_no
  								AND par_id=p_par_id)
  			LOOP
  				   SELECT COUNT(*) 
  					 INTO v_plate_cnt
   					 FROM GIPI_WVEHICLE
   					 WHERE plate_no=C.plate_no;
						 
						 IF v_plate_cnt > 1 THEN
  						  v_exist:='Y';
  						  Check_Exist_Par_Policy(p_par_id,v_msg_alert,'PAR','PLATE_NO',c.plate_no);-- adpascual 05112012 changed from v_msg_alert1 to v_msg_alert
   					 END IF	;
  						
  					 IF v_exist='N' THEN
   							FOR A IN (SELECT 1 FROM GIPI_VEHICLE
   												WHERE plate_no=C.plate_no	)
   							LOOP
			  					v_exist:='Y';
			  					Check_Exist_Par_Policy(p_par_id,v_msg_alert1,'POLICY','PLATE_NO',c.plate_no);
   							EXIT;
   							END LOOP;
  					 END IF;
  			END LOOP;						
  		END LOOP;						
        --adpascual - 05112012     
        IF v_msg_alert IS NOT NULL and v_msg_alert1 IS NOT NULL THEN
           v_msg_alert := v_msg_alert||'-*|@geniisys@|*-'||v_msg_alert1;
        ELSIF v_msg_alert1 IS NOT NULL AND v_msg_alert IS NULL THEN
           v_msg_alert := v_msg_alert1; 
        END IF;  
  END IF;	


  ELSIF P_par_type='E' THEN--validation for endorsements,exclude same policy no or previous endorsements				
				  	
  			SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no --policy_no of the PAR to be posted
  			INTO	v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no
  			FROM GIPI_WPOLBAS
  			WHERE par_id=p_par_id;
  			
		 		FOR B IN (SELECT DISTINCT item_no 
  							FROM GIPI_WITEM
  							WHERE par_id=p_par_id)
  			LOOP
  						v_exist:='N';			
  						FOR C IN (SELECT  plate_no --plate no  of the PAR to be post
  								FROM GIPI_WVEHICLE
  								WHERE plate_no IS NOT NULL
  								AND item_no=B.item_no
  								AND par_id=p_par_id)
  						LOOP
  								FOR D IN (SELECT policy_id FROM GIPI_VEHICLE--to be compare to the policy_no of PAR to be posted
   													WHERE plate_no=C.plate_no	)
   								LOOP
   												FOR E IN (SELECT 1 FROM GIPI_POLBASIC
   																	WHERE 1=1
   																	AND (line_cd 	<> v_line_cd
   																	 OR subline_cd<> v_subline_cd
   																	 OR iss_cd		<> v_iss_cd
   																	 OR issue_yy 	<> v_issue_yy
   																	 OR pol_seq_no<> v_pol_seq_no
   																	 OR renew_no	<> v_renew_no)
   																	AND policy_id	=D.policy_id	)
				   								
				   								LOOP
 						  								v_exist:='Y';
 						  								Check_Exist_Par_Policy(p_par_id,v_msg_alert,'POLICY','PLATE_NO',c.plate_no);-- adpascual 05112012 changed from v_msg_alert1 to v_msg_alert
   														EXIT;
   												END LOOP;
											    IF v_exist = 'Y' THEN
											    	 EXIT;
											    END IF;	
									END LOOP;
  								
  								IF v_exist='N' THEN
  										
  									FOR F IN (SELECT par_id 
  														FROM GIPI_WVEHICLE
  														WHERE plate_no=c.plate_no)
  									LOOP						
  												FOR E IN (SELECT 1 FROM GIPI_WPOLBAS
   																	WHERE 1=1
   																	AND (line_cd 	<> v_line_cd
   																	 OR subline_cd<> v_subline_cd
   																	 OR iss_cd		<> v_iss_cd
   																	 OR issue_yy 	<> v_issue_yy
   																	 OR pol_seq_no<> v_pol_seq_no
   																	 OR renew_no	<> v_renew_no)
   																	AND par_id=F.par_id	)
				   													
				   								LOOP
 						  								v_exist:='Y';
 						  								Check_Exist_Par_Policy(p_par_id,v_msg_alert1,'PAR','PLATE_NO',c.plate_no);
   														EXIT;
   												END LOOP;
											    IF v_exist = 'Y' THEN
											    	 EXIT;
											    END IF;	
  									END LOOP;
  								
  								END IF;	
  						END LOOP;						
  			
  			END LOOP;	
        --adpascual - 05112012     
        IF v_msg_alert IS NOT NULL and v_msg_alert1 IS NOT NULL THEN
           v_msg_alert := v_msg_alert||'-*|@geniisys@|*-'||v_msg_alert1;
        ELSIF v_msg_alert1 IS NOT NULL AND v_msg_alert IS NULL THEN
           v_msg_alert := v_msg_alert1; 
        END IF;
END IF;  	
--=============================================================================
p_msg_alert := v_msg_alert;	
p_msg_icon  := 'W';
END;
/



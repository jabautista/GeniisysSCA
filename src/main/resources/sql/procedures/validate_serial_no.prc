DROP PROCEDURE CPI.VALIDATE_SERIAL_NO;

CREATE OR REPLACE PROCEDURE CPI.Validate_Serial_No(
    p_par_id            IN  GIPI_PARLIST.par_id%TYPE,        
    p_msg_alert        OUT  VARCHAR2,
    p_par_type          IN  GIPI_PARLIST.par_type%TYPE
    ) IS 
--v_exist_in              VARCHAR2(15):= NULL;
v_exist                     VARCHAR2(1):='N';
v_cnt_item                  NUMBER:=0;
v_serial_no                 GIPI_WVEHICLE.serial_no%TYPE;
v_serial_cnt                NUMBER:=0;
v_claims                    NUMBER:=0;
v_line_cd                   GIPI_POLBASIC.line_cd%TYPE;
v_subline_cd                GIPI_POLBASIC.subline_cd%TYPE;
v_iss_cd                    GIPI_POLBASIC.iss_cd%TYPE;
v_issue_yy                  GIPI_POLBASIC.issue_yy%TYPE;
v_pol_seq_no                GIPI_POLBASIC.pol_seq_no%TYPE;
v_renew_no                  GIPI_POLBASIC.renew_no%TYPE;
v_msg_alert                 VARCHAR2(32000) := '';
v_msg_alert1                VARCHAR2(32000) := '';
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : Validate_Serial_No program unit
  */
/*check if serial_no already exist in other PAR or other policy*/    
  SELECT COUNT(*) 
    INTO v_cnt_item 
    FROM GIPI_WITEM --count items for that PAR
   WHERE par_id =p_par_id;

    IF p_par_type='P' THEN   
      IF v_cnt_item=1 THEN-- for PAR w/ 1 item
        BEGIN
          SELECT serial_no 
            INTO v_serial_no
            FROM GIPI_WVEHICLE
           WHERE serial_no IS NOT NULL
             AND par_id=p_par_id;

        EXCEPTION --added by Connie 12/09/06
          WHEN NO_DATA_FOUND THEN NULL;
        END;
       
        SELECT COUNT(*) -- count no of occurence of serial_no
          INTO v_serial_cnt
          FROM GIPI_WVEHICLE
         WHERE serial_no=v_serial_no;
       
        IF v_serial_cnt > 1 THEN--if it occurs more than 1, serial already exist in other PAR
            v_exist:='Y';
            Check_Exist_Par_Policy(p_par_id,v_msg_alert,'PAR','SERIAL_NO',v_serial_no);
        END IF    ;
       
        IF v_exist='N' THEN--if it does not occurs in other PAR, then check other Policy
            FOR A IN (SELECT 1 FROM GIPI_VEHICLE
                                   WHERE serial_no=v_serial_no    )
            LOOP
                v_exist:='Y';
                Check_Exist_Par_Policy(p_par_id,v_msg_alert,'POLICY','SERIAL_NO',v_serial_no);
                EXIT;
            END LOOP;
        END IF;
      END IF; 
     
      IF v_cnt_item > 1 THEN --for PAR w/ more than 1 item 
        FOR B IN (SELECT DISTINCT item_no 
                          FROM GIPI_WITEM
                         WHERE par_id=p_par_id)
        LOOP
           v_exist:='N';
           FOR C IN (SELECT serial_no 
                       FROM GIPI_WVEHICLE
                      WHERE serial_no IS NOT NULL
                        AND item_no=B.item_no
                        AND par_id=p_par_id)
           LOOP
                SELECT COUNT(*) 
                  INTO v_serial_cnt
                  FROM GIPI_WVEHICLE
                 WHERE serial_no=C.serial_no;
                             
                IF v_serial_cnt > 1 THEN
                    v_exist:='Y';
                    Check_Exist_Par_Policy(p_par_id,v_msg_alert,'PAR','SERIAL_NO',c.serial_no); -- adpascual 05112012 changed from v_msg_alert1 to v_msg_alert
                END IF;
                              
                IF v_exist='N' THEN
                    FOR A IN (SELECT 1 FROM GIPI_VEHICLE
                               WHERE serial_no=C.serial_no    )
                    LOOP
                        v_exist:='Y';
                        Check_Exist_Par_Policy(p_par_id,v_msg_alert1,'POLICY','SERIAL_NO',c.serial_no);
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


    ELSIF p_par_type='E' THEN--validation for endorsements,exclude same policy no or previous endorsements                
        SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no --policy_no of the PAR to be posted
          INTO v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no
          FROM GIPI_WPOLBAS
         WHERE par_id=p_par_id;
                  
        FOR B IN (SELECT DISTINCT item_no 
                    FROM GIPI_WITEM
                   WHERE par_id=p_par_id)
        LOOP
            v_exist:='N';            
            FOR C IN (SELECT  serial_no --serial no and par_id of the PAR to be post
                        FROM GIPI_WVEHICLE
                       WHERE serial_no IS NOT NULL
                         AND item_no=B.item_no
                         AND par_id=p_par_id)
            LOOP
                FOR D IN (SELECT policy_id 
                            FROM GIPI_VEHICLE--to be compare to the policy_no of PAR to be posted
                           WHERE serial_no=C.serial_no    )
                LOOP
                    FOR E IN (SELECT 1 
                                FROM GIPI_POLBASIC
                               WHERE 1=1
                                 AND (line_cd     <> v_line_cd
                                  OR subline_cd<> v_subline_cd
                                  OR iss_cd        <> v_iss_cd
                                  OR issue_yy     <> v_issue_yy
                                  OR pol_seq_no<> v_pol_seq_no
                                  OR renew_no    <> v_renew_no)
                                 AND policy_id    =D.policy_id)
                    LOOP
                        v_exist:='Y';
                        Check_Exist_Par_Policy(p_par_id,v_msg_alert,'POLICY','SERIAL_NO',c.serial_no); -- adpascual 05112012 changed from v_msg_alert1 to v_msg_alert
                        EXIT;
                    END LOOP;
                    
                    IF v_exist = 'Y' THEN
                        EXIT;
                    END IF;                                                
                END LOOP;
                                      
                IF v_exist='N' THEN
                     FOR F IN (SELECT par_id 
                                 FROM GIPI_WVEHICLE
                                WHERE serial_no=c.serial_no)
                     LOOP                        
                            FOR E IN (SELECT 1 
                                        FROM GIPI_WPOLBAS
                                       WHERE 1=1
                                         AND (line_cd     <> v_line_cd
                                          OR subline_cd<> v_subline_cd
                                          OR iss_cd        <> v_iss_cd
                                          OR issue_yy     <> v_issue_yy
                                          OR pol_seq_no<> v_pol_seq_no
                                          OR renew_no    <> v_renew_no)
                                         AND par_id=F.par_id    )
                                                                           
                     LOOP
                        v_exist:='Y';
                        Check_Exist_Par_Policy(p_par_id,v_msg_alert1,'PAR','SERIAL_NO',c.serial_no);
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
END;
/



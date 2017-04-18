DROP PROCEDURE CPI.VALIDATE_COC_SERIAL_NO;

CREATE OR REPLACE PROCEDURE CPI.Validate_Coc_Serial_No (
                       p_par_id            IN  GIPI_PARLIST.par_id%TYPE,        
                       p_msg_alert        OUT VARCHAR2,
                  p_par_type        IN GIPI_PARLIST.par_type%TYPE
                       )
        IS
--v_exist_in               VARCHAR2(15):= NULL;
    v_exist                   VARCHAR2(1):='N';
    v_cnt_item                NUMBER:=0;
    v_coc_serial_no              GIPI_WVEHICLE.coc_serial_no%TYPE;
    v_coc_yy                     GIPI_WVEHICLE.coc_yy%TYPE; --koks 10.17.14
    v_coc_serial_cnt          NUMBER:=0;
    v_claims                 NUMBER:=0;
    v_line_cd                 GIPI_POLBASIC.line_cd%TYPE;
    v_subline_cd             GIPI_POLBASIC.subline_cd%TYPE;
    v_iss_cd                 GIPI_POLBASIC.iss_cd%TYPE;
    v_issue_yy                  GIPI_POLBASIC.issue_yy%TYPE;
    v_pol_seq_no              GIPI_POLBASIC.pol_seq_no%TYPE;
    v_renew_no                  GIPI_POLBASIC.renew_no%TYPE;
    v_msg_alert                 VARCHAR2(32000) := '';
    v_existing_cocs             VARCHAR2(32000) := null;

    FUNCTION check_coc_match_result(v_mesg VARCHAR2, v_coc_list VARCHAR2, v_coc GIPI_WVEHICLE.coc_serial_no%TYPE)
    RETURN varchar2 IS
        v_result     VARCHAR2(1) := '0';
        v_coc_list2             VARCHAR2(32000) := v_coc_list;
    BEGIN
        IF v_mesg like ('COC Serial Number - %already exist%') THEN
            v_result := '1';
        END IF;
        
        IF v_result = '1' THEN
            IF v_coc_list2 is null THEN
                v_coc_list2 := to_char(v_coc);
            ELSE 
                v_coc_list2 := v_coc_list2||', '||v_coc;
            END IF;
        END IF;
        RETURN v_coc_list2;
    END;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : Validate_Coc_Serial_No program unit
  */
    SELECT COUNT(*) INTO v_cnt_item FROM GIPI_WITEM --count items for that PAR
  WHERE par_id =p_par_id;
  
--=======================================================================================

/*check if coc_serial_no already exist in other PAR or other policy*/    

IF p_par_type='P' THEN   
  IF v_cnt_item=1 THEN-- for PAR w/ 1 item
     BEGIN
       SELECT coc_serial_no, coc_yy --koks 10.17.14
         INTO v_coc_serial_no, v_coc_yy --koks 10.17.14 
         FROM GIPI_WVEHICLE
        WHERE coc_serial_no IS NOT NULL
          AND par_id=p_par_id;
     
     EXCEPTION --added by Connie 12/04/06
          WHEN NO_DATA_FOUND THEN NULL;
     END;
     
     SELECT COUNT(*) -- count no of occurence of coc_serial_no
       INTO v_coc_serial_cnt
       FROM GIPI_WVEHICLE
      WHERE coc_serial_no=v_coc_serial_no
        AND coc_yy = v_coc_yy; --koks 10.17.14
     
     IF v_coc_serial_cnt > 1 AND nvl(v_coc_serial_no, 0) > 0 THEN--if it occurs more than 1, coc_serial_no already exist in other PAR
        v_exist:='Y';
        --A.R.C. 12.08.2006
        --msg_alert('COC Serial Number - '|| v_coc_serial_cnt||' already exist in other PAR No. / Policy No.','W',FALSE);      
        Check_Exist_Par_Policy(p_par_id,v_msg_alert,'PAR','COC_SERIAL_NO',v_coc_serial_no);
        IF v_msg_alert like ('COC Serial Number - %already exist%') THEN
            v_msg_alert := 'ERROR#'||v_msg_alert;
        END IF;
     END IF    ;
   
     IF v_exist='N' AND nvl(v_coc_serial_no, 0) > 0 THEN--if it does not occurs in other PAR, then check other Policy
             FOR A IN (SELECT 1 FROM GIPI_VEHICLE
                               WHERE coc_serial_no=v_coc_serial_no
                               AND coc_yy = v_coc_yy) --koks
             LOOP
                v_exist:='Y';
                --A.R.C. 12.08.2006
                  --msg_alert('COC Serial Number - '|| v_coc_serial_cnt||' already exist in other PAR No. / Policy No.','W',FALSE);      
                  Check_Exist_Par_Policy(p_par_id,v_msg_alert,'POLICY','COC_SERIAL_NO',v_coc_serial_no);
                  IF v_msg_alert like ('COC Serial Number - %already exist%') THEN
                    v_msg_alert := 'ERROR#'||v_msg_alert;
                END IF;
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
              FOR C IN (SELECT coc_serial_no , coc_yy --koks  
                                  FROM GIPI_WVEHICLE
                                  WHERE coc_serial_no IS NOT NULL
                                  AND item_no=B.item_no
                                  AND par_id=p_par_id)
              LOOP
                     SELECT COUNT(*) 
                       INTO v_coc_serial_cnt
                        FROM GIPI_WVEHICLE
                        WHERE coc_serial_no=C.coc_serial_no
                        AND coc_yy = c.coc_yy; --koks
                         
                     IF v_coc_serial_cnt > 1 AND nvl(c.coc_serial_no, 0) > 0 THEN
                          v_exist:='Y';
                          --A.R.C. 12.08.2006
                          --msg_alert('COC Serial Number - '||C.coc_serial_no||' already exist in other PAR No. / Policy No.','W',FALSE);      
                          Check_Exist_Par_Policy(p_par_id,v_msg_alert,'PAR','COC_SERIAL_NO',c.coc_serial_no);
                          v_existing_cocs := check_coc_match_result(v_msg_alert, v_existing_cocs, c.coc_serial_no);
                          --jcmbrigino 01212014 UCPBGEN-14750
                          v_msg_alert := 'ERROR#COC Serial Number/s - '''||v_existing_cocs||''' already exist in VARIOUS POLICIES.';
                        END IF    ;
                          
                       IF v_exist='N' AND nvl(c.coc_serial_no, 0) > 0 THEN
                               FOR A IN (SELECT 1 FROM GIPI_VEHICLE
                                                   WHERE coc_serial_no=C.coc_serial_no
                                                   AND coc_yy = c.coc_yy    ) --koks
                               LOOP
                                  v_exist:='Y';
                                  --A.R.C. 12.08.2006
                                  --msg_alert('COC Serial Number - '||C.coc_serial_no||' already exist in other PAR No. / Policy No.','W',FALSE);      
                                  Check_Exist_Par_Policy(p_par_id,v_msg_alert,'POLICY','COC_SERIAL_NO',c.coc_serial_no);
                                  v_existing_cocs := check_coc_match_result(v_msg_alert, v_existing_cocs, c.coc_serial_no);
                                  --jcmbrigino 01212014 UCPBGEN-14750
                                  v_msg_alert := 'ERROR#COC Serial Number/s - '''||v_existing_cocs||''' already exist in VARIOUS POLICIES.';
                                   EXIT;
                               END LOOP;
                       END IF;
                     --v_msg_alert := 'ERROR#COC Serial Number/s - '''||v_existing_cocs||''' already exist in VARIOUS POLICIES.'; comment out by jdiago | 03.25.2014
              END LOOP;                        
          END LOOP;                        
  END IF;    


  ELSIF p_par_type='E' THEN--validation for endorsements,exclude same policy no or previous endorsements                
                      
              SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no --policy_no of the PAR to be posted
              INTO    v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no
              FROM GIPI_WPOLBAS
              WHERE par_id=p_par_id;
              
          --    message(v_line_cd||'-'||v_subline_cd||'-'||v_iss_cd||'-'||v_issue_yy||'-'||v_pol_seq_no||'-'||v_renew_no);--dd
      --        message(v_line_cd||'-'||v_subline_cd||'-'||v_iss_cd||'-'||v_issue_yy||'-'||v_pol_seq_no||'-'||v_renew_no);--dd
              
                 FOR B IN (SELECT DISTINCT item_no 
                              FROM GIPI_WITEM
                              WHERE par_id=p_par_id)
              LOOP
                          v_exist:='N';            
                          FOR C IN (SELECT  coc_serial_no,coc_yy --coc serial no  of the PAR to be post --koks
                                  FROM GIPI_WVEHICLE
                                  WHERE coc_serial_no IS NOT NULL
                                  AND item_no=B.item_no
                                  AND par_id=p_par_id)
                          LOOP
                                      
                                  FOR D IN (SELECT policy_id FROM GIPI_VEHICLE--to be compare to the policy_no of PAR to be posted
                                                       WHERE coc_serial_no=C.coc_serial_no
                                                       AND coc_yy = c.coc_yy    )
                                   LOOP
                                               --    message(D.policy_id);
                                               --    message(D.policy_id);
                                                   
                                                   FOR E IN (SELECT 1 FROM GIPI_POLBASIC
                                                                       WHERE 1=1
                                                                       --A.R.C. 12.07.2006
                                                                       --to correct checking if existing in another policy
                                                                       /*AND renew_no    <> v_renew_no
                                                                       AND pol_seq_no<> v_pol_seq_no
                                                                       AND issue_yy     <> v_issue_yy
                                                                       AND iss_cd        <> v_iss_cd
                                                                       AND subline_cd<> v_subline_cd
                                                                       AND line_cd     <> v_line_cd*/
                                                                       AND (line_cd     <> v_line_cd
                                                                        OR subline_cd<> v_subline_cd
                                                                        OR iss_cd        <> v_iss_cd
                                                                        OR issue_yy     <> v_issue_yy
                                                                        OR pol_seq_no<> v_pol_seq_no
                                                                        OR renew_no    <> v_renew_no)
                                                                       AND policy_id    =D.policy_id    )
                                                   
                                                   LOOP
                                                           v_exist:='Y';
                                                           --A.R.C. 12.08.2006
                                                          --msg_alert('COC Serial Number - '||C.coc_serial_no||' already exist in other PAR No. / Policy No.','W',FALSE);      
                                                          Check_Exist_Par_Policy(p_par_id,v_msg_alert,'POLICY','COC_SERIAL_NO',c.coc_serial_no);
                                                           EXIT;
                                                   END LOOP;
                                                IF v_exist = 'Y' THEN
                                                     EXIT;
                                                END IF;    
                                            
                                    END LOOP;
                                  
                                  IF v_exist='N' THEN
                                          
                                      FOR F IN (SELECT par_id 
                                                          FROM GIPI_WVEHICLE
                                                          WHERE coc_serial_no=c.coc_serial_no
                                                          AND coc_yy = c.coc_yy) --koks
                                      LOOP                        
                                                  FOR E IN (SELECT 1 FROM GIPI_WPOLBAS
                                                                       WHERE 1=1
                                                                       --A.R.C. 12.07.2006
                                                                       --to correct checking if existing in another policy
                                                                       /*AND renew_no    <> v_renew_no
                                                                       AND pol_seq_no<> v_pol_seq_no
                                                                       AND issue_yy     <> v_issue_yy
                                                                       AND iss_cd        <> v_iss_cd
                                                                       AND subline_cd<> v_subline_cd
                                                                       AND line_cd     <> v_line_cd*/
                                                                       AND (line_cd     <> v_line_cd
                                                                        OR subline_cd<> v_subline_cd
                                                                        OR iss_cd        <> v_iss_cd
                                                                        OR issue_yy     <> v_issue_yy
                                                                        OR pol_seq_no<> v_pol_seq_no
                                                                        OR renew_no    <> v_renew_no)
                                                                       AND par_id=F.par_id    )
                                                                       
                                                   LOOP
                                                           v_exist:='Y';
                                                           --A.R.C. 12.08.2006
                                                          --msg_alert('COC Serial Number - '||C.coc_serial_no||' already exist in other PAR No. / Policy No.','W',FALSE);      
                                                          Check_Exist_Par_Policy(p_par_id,v_msg_alert,'PAR','COC_SERIAL_NO',c.coc_serial_no);
                                                           EXIT;
                                                   END LOOP;
                                                IF v_exist = 'Y' THEN
                                                     EXIT;
                                                END IF;    
                                      END LOOP;
                                  
                                  END IF;    
                                  
                                  
                          END LOOP;                        
              
              END LOOP;    

END IF;      
p_msg_alert := v_msg_alert;
END;
/



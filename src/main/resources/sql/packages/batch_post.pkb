CREATE OR REPLACE PACKAGE BODY CPI.BATCH_POST AS
parameter_change_stat VARCHAR2(1):='N';
skip_parid            VARCHAR2(1):='N';
v_final_post          BOOLEAN:=TRUE;
v_par_id              gipi_parlist.par_id%TYPE;
v_line_cd             gipi_parlist.line_cd%TYPE;
v_iss_cd        gipi_parlist.iss_cd%TYPE;
v_par_type        gipi_parlist.par_type%TYPE;
v_back_endt           VARCHAR2(1);
subline_mop        gipi_wpolbas.subline_cd%TYPE := 'MOP';
subline_mrn        gipi_wpolbas.subline_cd%TYPE := 'MRN';
subline_bbb          gipi_wpolbas.subline_cd%TYPE := 'BBB';
subline_ddd          gipi_wpolbas.subline_cd%TYPE := 'DDD';
subline_mrsb         gipi_wpolbas.subline_cd%TYPE := 'MRSB';
subline_mspr         gipi_wpolbas.subline_cd%TYPE := 'MSPR';
policy_no            VARCHAR2(35)                 :=null;
open_flag        giis_subline.op_flag%TYPE;
open_policy_sw       giis_subline.open_policy_sw%TYPE;
affecting        VARCHAR2(1);
quote_seq_no          gipi_parlist.quote_seq_no%TYPE;
bpv             giis_parameters.param_name%TYPE := 'BOILER_AND_PRESSURE_VESSEL';
subline_bpv        gipi_wpolbas.subline_cd%TYPE;
issue_ri        gipi_parlist.iss_cd%TYPE;
line_su               giis_line.line_cd%TYPE := 'SU';
eff_date              gipi_wpolbas.eff_date%TYPE;
v_menu_ln_cd          giis_line.menu_line_cd%TYPE;
postpar_par_seq_no    gipi_parlist.par_seq_no%TYPE;
postpar_par_yy        gipi_parlist.par_yy%TYPE;
postpar_par_id        gipi_parlist.par_id%TYPE;
postpar_line_cd       gipi_parlist.line_cd%TYPE;
postpar_par_type      gipi_parlist.par_type%TYPE;
postpar_subline_cd    gipi_wpolbas.subline_cd%TYPE;
postpar_pol_stat      gipi_wpolbas.pol_flag%TYPE;
postpar_iss_cd        gipi_wpolbas.iss_cd%TYPE;
postpar_issue_yy      gipi_wpolbas.issue_yy%TYPE;
postpar_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE;
postpar_renew_no      gipi_wpolbas.renew_no%TYPE;
postpar_ann_tsi_amt   gipi_wpolbas.ann_tsi_amt%TYPE;
postpar_pack          gipi_wpolbas.pack_pol_flag%TYPE; 
postpar_policy_id     gipi_polbasic.policy_id%TYPE;
postpar_accident_cd   giis_parameters.param_value_v%TYPE;
postpar_aviation_cd   giis_parameters.param_value_v%TYPE;
postpar_casualty_cd   giis_parameters.param_value_v%TYPE;
postpar_engrng_cd     giis_parameters.param_value_v%TYPE;
postpar_fire_cd       giis_parameters.param_value_v%TYPE;
postpar_motor_cd      giis_parameters.param_value_v%TYPE;
postpar_hull_cd       giis_parameters.param_value_v%TYPE;
postpar_cargo_cd      giis_parameters.param_value_v%TYPE;
postpar_surety_cd     giis_parameters.param_value_v%TYPE;
postpar_dumm_var      VARCHAR2(30);
postpar_ws_long_var   gipi_wendttext.endt_text01%TYPE;
postpar_ws_long_var1  gipi_wendttext.endt_text01%TYPE;
postpar_ws_long_var2  gipi_wendttext.endt_text02%TYPE;
postpar_ws_long_var3  gipi_wendttext.endt_text03%TYPE;
postpar_ws_long_var4  gipi_wendttext.endt_text04%TYPE;
postpar_ws_long_var5  gipi_wendttext.endt_text05%TYPE;
postpar_ws_long_var6  gipi_wendttext.endt_text06%TYPE;
postpar_ws_long_var7  gipi_wendttext.endt_text07%TYPE;
postpar_ws_long_var8  gipi_wendttext.endt_text08%TYPE;
postpar_ws_long_var9  gipi_wendttext.endt_text09%TYPE;
postpar_ws_long_var10 gipi_wendttext.endt_text10%TYPE;
postpar_ws_long_var11 gipi_wendttext.endt_text11%TYPE;
postpar_ws_long_var12 gipi_wendttext.endt_text12%TYPE;
postpar_ws_long_var13 gipi_wendttext.endt_text13%TYPE;
postpar_ws_long_var14 gipi_wendttext.endt_text14%TYPE;
postpar_ws_long_var15 gipi_wendttext.endt_text15%TYPE;
postpar_ws_long_var16 gipi_wendttext.endt_text16%TYPE;
postpar_ws_long_var17 gipi_wendttext.endt_text17%TYPE;
postpar_mrn_cd        VARCHAR2(5);
postpar_cmi_cd        VARCHAR2(5);
postpar_dumm_num      NUMBER; 
postpar_ws_initial    gipi_wpolgenin.initial_info01%TYPE; 
postpar_ws_initial02  gipi_wpolgenin.initial_info02%TYPE;
postpar_ws_initial03  gipi_wpolgenin.initial_info03%TYPE;
postpar_ws_initial04  gipi_wpolgenin.initial_info04%TYPE;
postpar_ws_initial05  gipi_wpolgenin.initial_info05%TYPE;
postpar_ws_initial06  gipi_wpolgenin.initial_info06%TYPE;
postpar_ws_initial07  gipi_wpolgenin.initial_info07%TYPE;
postpar_ws_initial08  gipi_wpolgenin.initial_info08%TYPE;
postpar_ws_initial09  gipi_wpolgenin.initial_info09%TYPE;
postpar_ws_initial10  gipi_wpolgenin.initial_info10%TYPE;
postpar_ws_initial11  gipi_wpolgenin.initial_info11%TYPE;
postpar_ws_initial12  gipi_wpolgenin.initial_info12%TYPE;
postpar_ws_initial13  gipi_wpolgenin.initial_info13%TYPE;
postpar_ws_initial14  gipi_wpolgenin.initial_info14%TYPE;
postpar_ws_initial15  gipi_wpolgenin.initial_info15%TYPE;
postpar_ws_initial16  gipi_wpolgenin.initial_info16%TYPE;
postpar_ws_initial17  gipi_wpolgenin.initial_info17%TYPE;
postpar_prem_seq_no   gipi_installment.prem_seq_no%TYPE;
postpar_dist_no       giuw_pol_dist.dist_no%TYPE;
PROCEDURE PRE_POST_ERROR (p_par_id  IN NUMBER,
                          p_remarks IN VARCHAR2
                          ) IS
BEGIN
  ROLLBACK;
  INSERT INTO GIIS_POST_ERROR_LOG(PAR_ID, REMARKS)
  VALUES (p_par_id, p_remarks);
  COMMIT;
  skip_parid := 'Y';
END;
--A.R.C. 12.08.2006
--to check for existing PAR or POLICY
--p_par_policy = PAR or POLICY
--p_no = PLATE_NO, SERIAL_NO, MOTOR_NO OR COC_SERIAL_NO
--p_value = value of PLATE_NO, SERIAL_NO, MOTOR_NO OR COC_SERIAL_NO
PROCEDURE CHECK_EXIST_PAR_POLICY(p_par_policy VARCHAR2,
                                 p_no VARCHAR2,
                                 p_value IN VARCHAR2) IS         
  v_par_no  VARCHAR2(32000);                                                         
  v_policy_no  VARCHAR2(32000);
BEGIN
IF skip_parid = 'N' THEN
 IF p_par_policy = 'PAR' THEN
  v_par_no := NULL;
    IF p_no = 'PLATE_NO' THEN
    FOR c1 IN (SELECT c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(c.par_yy,'09'))||'-'||LTRIM(TO_CHAR(c.par_seq_no,'0999999')) par_no
          FROM gipi_parlist c,
               gipi_wpolbas b, 
               gipi_wvehicle a 
         WHERE 1=1 
           AND c.par_id = b.par_id
           AND b.par_id = a.par_id 
           AND a.plate_no = p_value
           AND NOT EXISTS (SELECT 1 
                             FROM gipi_wpolbas z 
                         WHERE z.line_cd = b.line_cd 
                           AND z.subline_cd = b.subline_cd 
                    AND z.iss_cd = b.iss_cd 
                    AND z.issue_yy = b.issue_yy 
                    AND z.pol_seq_no = b.pol_seq_no 
                    AND z.renew_no = b.renew_no 
                    AND z.par_id =  v_par_id))
    LOOP
     IF v_par_no IS NULL THEN
       v_par_no := c1.par_no;   
     ELSE
       v_par_no := v_par_no||', '||c1.par_no;
     END IF; 
    END LOOP;
    PRE_POST_ERROR( v_par_id, 'Plate Number - '||p_value||' already exist in PAR No. '||v_par_no);
    ELSIF p_no = 'SERIAL_NO' THEN  
    FOR c1 IN (SELECT c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(c.par_yy,'09'))||'-'||LTRIM(TO_CHAR(c.par_seq_no,'0999999')) par_no
          FROM gipi_parlist c,
               gipi_wpolbas b, 
               gipi_wvehicle a 
         WHERE 1=1 
           AND c.par_id = b.par_id
           AND b.par_id = a.par_id 
           AND a.serial_no = p_value
           AND NOT EXISTS (SELECT 1 
                             FROM gipi_wpolbas z 
                         WHERE z.line_cd = b.line_cd 
                           AND z.subline_cd = b.subline_cd 
                    AND z.iss_cd = b.iss_cd 
                    AND z.issue_yy = b.issue_yy 
                    AND z.pol_seq_no = b.pol_seq_no 
                    AND z.renew_no = b.renew_no 
                    AND z.par_id =  v_par_id))
    LOOP
     IF v_par_no IS NULL THEN
       v_par_no := c1.par_no;   
     ELSE
       v_par_no := v_par_no||','||c1.par_no;
     END IF; 
    END LOOP;
    PRE_POST_ERROR( v_par_id, 'Serial Number - '||p_value||' already exist in PAR No. '||v_par_no);
    ELSIF p_no = 'MOTOR_NO' THEN  
    FOR c1 IN (SELECT c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(c.par_yy,'09'))||'-'||LTRIM(TO_CHAR(c.par_seq_no,'0999999')) par_no
          FROM gipi_parlist c,
               gipi_wpolbas b, 
               gipi_wvehicle a 
         WHERE 1=1 
           AND c.par_id = b.par_id
           AND b.par_id = a.par_id 
           AND a.motor_no = p_value
           AND NOT EXISTS (SELECT 1 
                             FROM gipi_wpolbas z 
                         WHERE z.line_cd = b.line_cd 
                           AND z.subline_cd = b.subline_cd 
                    AND z.iss_cd = b.iss_cd 
                    AND z.issue_yy = b.issue_yy 
                    AND z.pol_seq_no = b.pol_seq_no 
                    AND z.renew_no = b.renew_no 
                    AND z.par_id =  v_par_id))
    LOOP
     IF v_par_no IS NULL THEN
       v_par_no := c1.par_no;   
     ELSE
       v_par_no := v_par_no||','||c1.par_no;
     END IF; 
    END LOOP;
    PRE_POST_ERROR( v_par_id, 'Motor Number - '||p_value||' already exist in PAR No. '||v_par_no);
    ELSIF p_no = 'COC_SERIAL_NO' THEN   
    FOR c1 IN (SELECT c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(c.par_yy,'09'))||'-'||LTRIM(TO_CHAR(c.par_seq_no,'0999999')) par_no
          FROM gipi_parlist c,
               gipi_wpolbas b, 
               gipi_wvehicle a 
         WHERE 1=1 
           AND c.par_id = b.par_id
           AND b.par_id = a.par_id 
           AND a.coc_serial_no = p_value
           AND NOT EXISTS (SELECT 1 
                             FROM gipi_wpolbas z 
                         WHERE z.line_cd = b.line_cd 
                           AND z.subline_cd = b.subline_cd 
                    AND z.iss_cd = b.iss_cd 
                    AND z.issue_yy = b.issue_yy 
                    AND z.pol_seq_no = b.pol_seq_no 
                    AND z.renew_no = b.renew_no 
                    AND z.par_id =  v_par_id))
    LOOP
     IF v_par_no IS NULL THEN
       v_par_no := c1.par_no;   
     ELSE
       v_par_no := v_par_no||','||c1.par_no;
     END IF; 
    END LOOP;
    PRE_POST_ERROR( v_par_id,'COC Serial Number - '||p_value||' already exist in PAR No. '||v_par_no);
    END IF; 
 ELSIF p_par_policy = 'POLICY' THEN
  v_policy_no := NULL;
    IF p_no = 'PLATE_NO' THEN
    FOR c1 IN (SELECT GET_POLICY_NO(b.policy_id) policy_no
          FROM gipi_polbasic b, 
               gipi_vehicle a 
         WHERE 1=1 
           AND b.policy_id = a.policy_id 
           AND a.plate_no = p_value
           AND NOT EXISTS (SELECT 1 
                             FROM gipi_wpolbas z 
                         WHERE z.line_cd = b.line_cd 
                           AND z.subline_cd = b.subline_cd 
                    AND z.iss_cd = b.iss_cd 
                    AND z.issue_yy = b.issue_yy 
                    AND z.pol_seq_no = b.pol_seq_no 
                    AND z.renew_no = b.renew_no 
                    AND z.par_id =  v_par_id))
    LOOP
     IF v_policy_no IS NULL THEN
       v_policy_no := c1.policy_no;   
     ELSE
       v_policy_no := v_policy_no||','||c1.policy_no;
     END IF; 
    END LOOP;
    PRE_POST_ERROR( v_par_id,'Plate Number - '||p_value||' already exist in Policy No. '||v_policy_no);
    ELSIF p_no = 'SERIAL_NO' THEN  
    FOR c1 IN (SELECT GET_POLICY_NO(b.policy_id) policy_no
          FROM gipi_polbasic b, 
               gipi_vehicle a 
         WHERE 1=1 
           AND b.policy_id = a.policy_id 
           AND a.serial_no = p_value
           AND NOT EXISTS (SELECT 1 
                             FROM gipi_wpolbas z 
                         WHERE z.line_cd = b.line_cd 
                           AND z.subline_cd = b.subline_cd 
                    AND z.iss_cd = b.iss_cd 
                    AND z.issue_yy = b.issue_yy 
                    AND z.pol_seq_no = b.pol_seq_no 
                    AND z.renew_no = b.renew_no 
                    AND z.par_id =  v_par_id))
    LOOP
     IF v_policy_no IS NULL THEN
       v_policy_no := c1.policy_no;   
     ELSE
       v_policy_no := v_policy_no||','||c1.policy_no;
     END IF; 
    END LOOP;
    PRE_POST_ERROR( v_par_id,'Serial Number - '||p_value||' already exist in Policy No. '||v_policy_no);
    ELSIF p_no = 'MOTOR_NO' THEN  
    FOR c1 IN (SELECT GET_POLICY_NO(b.policy_id) policy_no
          FROM gipi_polbasic b, 
               gipi_vehicle a 
         WHERE 1=1 
           AND b.policy_id = a.policy_id 
           AND a.motor_no = p_value
           AND NOT EXISTS (SELECT 1 
                             FROM gipi_wpolbas z 
                         WHERE z.line_cd = b.line_cd 
                           AND z.subline_cd = b.subline_cd 
                    AND z.iss_cd = b.iss_cd 
                    AND z.issue_yy = b.issue_yy 
                    AND z.pol_seq_no = b.pol_seq_no 
                    AND z.renew_no = b.renew_no 
                    AND z.par_id =  v_par_id))
    LOOP
     IF v_policy_no IS NULL THEN
       v_policy_no := c1.policy_no;   
     ELSE
       v_policy_no := v_policy_no||','||c1.policy_no;
     END IF; 
    END LOOP;
    PRE_POST_ERROR( v_par_id,'Motor Number - '||p_value||' already exist in Policy No. '||v_policy_no);
    ELSIF p_no = 'COC_SERIAL_NO' THEN   
    FOR c1 IN (SELECT GET_POLICY_NO(b.policy_id) policy_no
          FROM gipi_polbasic b, 
               gipi_vehicle a 
         WHERE 1=1 
           AND b.policy_id = a.policy_id 
           AND a.coc_serial_no = p_value
           AND NOT EXISTS (SELECT 1 
                             FROM gipi_wpolbas z 
                         WHERE z.line_cd = b.line_cd 
                           AND z.subline_cd = b.subline_cd 
                    AND z.iss_cd = b.iss_cd 
                    AND z.issue_yy = b.issue_yy 
                    AND z.pol_seq_no = b.pol_seq_no 
                    AND z.renew_no = b.renew_no 
                    AND z.par_id =  v_par_id))
    LOOP
     IF v_policy_no IS NULL THEN
       v_policy_no := c1.policy_no;   
     ELSE
       v_policy_no := v_policy_no||','||c1.policy_no;
     END IF; 
    END LOOP;
    PRE_POST_ERROR( v_par_id, 'COC Serial Number - '||p_value||' already exist in Policy No. '||v_policy_no);
    END IF; 
 END IF;
END IF;  
END;
/*check plate_no,chasis_no  if exist in FP_CLTLOSS 
 when parameter CHECK_CLTLOSS param_value_v ='Y'. If exist transaction will not proceed*/
PROCEDURE validate_carnap IS
v_param_value  giis_parameters.param_value_v%TYPE;
BEGIN
IF skip_parid = 'N' THEN  
  BEGIN
    SELECT param_value_v 
      INTO v_param_value
      FROM giis_parameters
     WHERE param_name='CHECK_CLTLOSS';  
  EXCEPTION
      WHEN no_data_found THEN
        v_param_value := 'N'; 
  END;    
 IF  v_param_value ='Y' THEN    
    FOR B IN (SELECT distinct item_no 
         FROM GIPI_WITEM
         WHERE par_id= v_par_id)
    LOOP
       FOR C IN (SELECT plate_no,serial_no,motor_no 
          FROM gipi_wvehicle
          WHERE plate_no IS NOT NULL
          AND item_no=B.item_no
          AND par_id= v_par_id)
       LOOP
          FOR D IN (SELECT 1 
               FROM FP_CLTLOSS 
               WHERE veh_plate =c.plate_no
               OR    veh_chasSis=c.serial_no
               OR  veh_motor =c.motor_no)
          LOOP
           PRE_POST_ERROR( v_par_id,'Vehicle exists in total loss and carnap claims tabel'
                 ||chr(10)||'Cannot Proceed with transaction' );           
          END LOOP;
       END LOOP;      
    END LOOP;  
 END IF;
END IF;    
END;
PROCEDURE validate_coc_serial_no IS
v_exist        VARCHAR2(1):='N';
v_cnt_item     NUMBER:=0;
v_coc_serial_no  gipi_wvehicle.coc_serial_no%TYPE;
v_coc_serial_cnt NUMBER:=0;
v_claims     NUMBER:=0;
v_line_cd     gipi_polbasic.line_cd%TYPE;
v_subline_cd   gipi_polbasic.subline_cd%TYPE;
v_iss_cd     gipi_polbasic.iss_cd%TYPE;
v_issue_yy    gipi_polbasic.issue_yy%TYPE;
v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
v_renew_no    gipi_polbasic.renew_no%TYPE;
BEGIN 
IF skip_parid = 'N' THEN
 SELECT count(*) INTO v_cnt_item FROM gipi_witem --count items for that PAR
  WHERE par_id = v_par_id;
/*check if coc_serial_no already exist in other PAR or other policy*/
IF  v_par_type='P' THEN   
  IF v_cnt_item=1 THEN
     BEGIN
       SELECT coc_serial_no 
         INTO v_coc_serial_no
         FROM gipi_wvehicle
        WHERE coc_serial_no IS NOT NULL
          AND par_id= v_par_id;     
     EXCEPTION
       WHEN NO_DATA_FOUND THEN 
         NULL;
     END;
     SELECT count(*) -- count no of occurence of coc_serial_no
       INTO v_coc_serial_cnt
       FROM gipi_wvehicle
      WHERE coc_serial_no=v_coc_serial_no;
     IF v_coc_serial_cnt > 1 THEN--if it occurs more than 1, coc_serial_no already exist in other PAR
        v_exist:='Y';      
        CHECK_EXIST_PAR_POLICY('PAR','COC_SERIAL_NO',v_coc_serial_no);
     END IF ;
     IF v_exist='N' THEN--if it does not occurs in other PAR, then check other Policy
       FOR A IN (SELECT 1 FROM gipi_vehicle
          WHERE coc_serial_no=v_coc_serial_no)
       LOOP
       v_exist:='Y';       
      CHECK_EXIST_PAR_POLICY('POLICY','COC_SERIAL_NO',v_coc_serial_no);
       EXIT;
       END LOOP;
     END IF;
  END IF; 
  IF v_cnt_item > 1 THEN --for PAR w/ more than 1 item 
    FOR B IN (SELECT distinct item_no 
         FROM GIPI_WITEM
         WHERE par_id= v_par_id)
    LOOP
     v_exist:='N';
     FOR C IN (SELECT coc_serial_no 
          FROM gipi_wvehicle
          WHERE coc_serial_no IS NOT NULL
          AND item_no=B.item_no
          AND par_id= v_par_id)
     LOOP
         SELECT count(*) 
        INTO v_coc_serial_cnt
         FROM gipi_wvehicle
         WHERE coc_serial_no=C.coc_serial_no;
       IF v_coc_serial_cnt > 1 THEN
        v_exist:='Y';     
        CHECK_EXIST_PAR_POLICY('PAR','COC_SERIAL_NO',c.coc_serial_no);
         END IF ;
        IF v_exist='N' THEN
          FOR A IN (SELECT 1 FROM gipi_vehicle
               WHERE coc_serial_no=C.coc_serial_no )
          LOOP
          v_exist:='Y';          
          CHECK_EXIST_PAR_POLICY('POLICY','COC_SERIAL_NO',c.coc_serial_no);
           EXIT;
          END LOOP;
        END IF;
     END LOOP;      
    END LOOP;      
  END IF; 
  ELSIF  v_par_type='E' THEN--validation for endorsements,exclude same policy no or previous endorsements    
     SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no --policy_no of the PAR to be posted
       INTO v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no
       FROM gipi_wpolbas
      WHERE par_id= v_par_id;
     FOR B IN (SELECT distinct item_no 
             FROM GIPI_WITEM
            WHERE par_id= v_par_id)
     LOOP
        v_exist:='N';   
        FOR C IN (SELECT  coc_serial_no --coc serial no  of the PAR to be post
          FROM gipi_wvehicle
          WHERE coc_serial_no IS NOT NULL
          AND item_no=B.item_no
          AND par_id= v_par_id)
        LOOP
          FOR D IN (SELECT policy_id FROM gipi_vehicle--to be compare to the policy_no of PAR to be posted
                 WHERE coc_serial_no=C.coc_serial_no )
           LOOP
            FOR E IN (SELECT 1 FROM gipi_polbasic
                  WHERE 1=1                 
                    --to correct checking if existing in another policy                    
                    AND (line_cd  <> v_line_cd
                     OR subline_cd<> v_subline_cd
                     OR iss_cd  <> v_iss_cd
                     OR issue_yy  <> v_issue_yy
                     OR pol_seq_no<> v_pol_seq_no
                     OR renew_no <> v_renew_no)
                    AND policy_id =D.policy_id )
               LOOP
                 v_exist:='Y';                 
                CHECK_EXIST_PAR_POLICY('POLICY','COC_SERIAL_NO',c.coc_serial_no);
                 exit;
               END LOOP;
               IF v_exist = 'Y' THEN
                 EXIT;
               END IF;
         END LOOP;
          IF v_exist='N' THEN
           FOR F in (SELECT par_id 
                  FROM gipi_wvehicle
                 WHERE coc_serial_no=c.coc_serial_no)
           LOOP      
              FOR E IN (SELECT 1 
                          FROM gipi_wpolbas
                     WHERE 1=1                    
                       AND (line_cd  <> v_line_cd
                       OR subline_cd<> v_subline_cd
                       OR iss_cd  <> v_iss_cd
                       OR issue_yy  <> v_issue_yy
                       OR pol_seq_no<> v_pol_seq_no
                       OR renew_no <> v_renew_no)
                      AND par_id=F.par_id )
               LOOP
                 v_exist:='Y';                 
                CHECK_EXIST_PAR_POLICY('PAR','COC_SERIAL_NO',c.coc_serial_no);
                 exit;
               END LOOP;
               IF v_exist = 'Y' THEN
                 EXIT;
               END IF; 
           END LOOP;
          END IF; 
        END LOOP;      
     END LOOP; 
END IF;
END IF;   
END;
PROCEDURE validate_motor_no IS
v_exist       VARCHAR2(1):='N';
v_cnt_item    NUMBER:=0;
v_motor_no   gipi_wvehicle.motor_no%TYPE;
v_motor_cnt   NUMBER:=0;
v_claims    NUMBER:=0;
v_line_cd    gipi_polbasic.line_cd%TYPE;
v_subline_cd  gipi_polbasic.subline_cd%TYPE;
v_iss_cd    gipi_polbasic.iss_cd%TYPE;
v_issue_yy   gipi_polbasic.issue_yy%TYPE;
v_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE;
v_renew_no   gipi_polbasic.renew_no%TYPE;
BEGIN
IF skip_parid = 'N' THEN
/*check if motor_no already exist in other PAR or other policy*/ 
 SELECT count(*) INTO v_cnt_item FROM gipi_witem --count items for that PAR
  WHERE par_id = v_par_id;
IF  v_par_type='P' THEN   
  IF v_cnt_item=1 THEN-- for PAR w/ 1 item
   BEGIN
     SELECT motor_no 
       INTO v_motor_no
       FROM gipi_wvehicle
      WHERE motor_no IS NOT NULL
        AND par_id= v_par_id;
    EXCEPTION --added by Connie 12/09/06
      WHEN NO_DATA_FOUND THEN NULL;
   END;
   SELECT count(*) -- count no of occurence of serial_no
     INTO v_motor_cnt
     FROM gipi_wvehicle
    WHERE motor_no=v_motor_no;
   IF v_motor_cnt > 1 THEN--if it occurs more than 1, serial already exist in other PAR
     v_exist:='Y';
     --A.R.C. 12.07.2006
     --change to warning and allow continuation according to miss j.   
     --msg_alert('Motor Number - '||v_motor_no||' already exist in other PAR No. / Policy No.'||CHR(10)||'Change the motor no before posting','E',TRUE);
     CHECK_EXIST_PAR_POLICY('PAR','MOTOR_NO',v_motor_no);
   END IF ;
   IF v_exist='N' THEN--if it does not occurs in other PAR, then check other Policy
     FOR A IN (SELECT 1 FROM gipi_vehicle
          WHERE motor_no=v_motor_no )
     LOOP
      v_exist:='Y';
         --A.R.C. 12.07.2006
         --change to warning and allow continuation according to miss j.   
      --msg_alert('Motor Number - '||v_motor_no||' already exist in other PAR No. / Policy No.'||chr(10)||'Change the motor no before posting','E',TRUE);
      CHECK_EXIST_PAR_POLICY('POLICY','MOTOR_NO',v_motor_no);
       EXIT;
     END LOOP;
   END IF;
  END IF; 
  IF v_cnt_item > 1 THEN --for PAR w/ more than 1 item 
    FOR B IN (SELECT distinct item_no 
         FROM GIPI_WITEM
         WHERE par_id= v_par_id)
    LOOP
     v_exist:='N';
     FOR C IN (SELECT motor_no 
          FROM gipi_wvehicle
          WHERE motor_no IS NOT NULL
          AND item_no=B.item_no
          AND par_id= v_par_id)
     LOOP
         SELECT count(*) 
        INTO v_motor_cnt
         FROM gipi_wvehicle
         WHERE motor_no=C.motor_no;
       IF v_motor_cnt > 1 THEN
          v_exist:='Y';
          --A.R.C. 12.07.2006
          --change to warning and allow continuation according to miss j.   
          --msg_alert('Motor Number - '||C.motor_no||' already exist in other PAR No. / Policy No.'||chr(10)||'Change the motor no before posting','E',TRUE);
          CHECK_EXIST_PAR_POLICY('PAR','MOTOR_NO',c.motor_no);
         END IF ;
        IF v_exist='N' THEN
          FOR A IN (SELECT 1 FROM gipi_vehicle
               WHERE motor_no=C.motor_no )
          LOOP
          v_exist:='Y';
         --A.R.C. 12.07.2006
         --change to warning and allow continuation according to miss j.   
         --msg_alert('Motor Number - '||C.motor_no||' already exist in other PAR No. / Policy No.'||chr(10)||'Change the motor no before posting','E',TRUE);
         CHECK_EXIST_PAR_POLICY('POLICY','MOTOR_NO',c.motor_no);
          EXIT;
          END LOOP;
        END IF;
     END LOOP;      
    END LOOP;      
  END IF; 
  ELSIF  v_par_type='E' THEN--validation for endorsements,exclude same policy no or previous endorsements    
     SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no --policy_no of the PAR to be posted
     INTO v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no
     FROM gipi_wpolbas
     WHERE par_id= v_par_id;
    -- message(v_line_cd||'-'||v_subline_cd||'-'||v_iss_cd||'-'||v_issue_yy||'-'||v_pol_seq_no||'-'||v_renew_no);--dd
   --  message(v_line_cd||'-'||v_subline_cd||'-'||v_iss_cd||'-'||v_issue_yy||'-'||v_pol_seq_no||'-'||v_renew_no);--dd
     FOR B IN (SELECT distinct item_no 
         FROM GIPI_WITEM
         WHERE par_id= v_par_id)
     LOOP
        v_exist:='N';   
        FOR C IN (SELECT  motor_no --motor no  of the PAR to be post
          FROM gipi_wvehicle
          WHERE motor_no IS NOT NULL
          AND item_no=B.item_no
          AND par_id= v_par_id)
        LOOP
          FOR D IN (SELECT policy_id FROM gipi_vehicle--to be compare to the policy_no of PAR to be posted
                WHERE motor_no=C.motor_no )
           LOOP
              -- message(D.policy_id);
              -- message(D.policy_id);
               FOR E IN (SELECT 1 FROM gipi_polbasic
                    WHERE 1=1
                    --A.R.C. 12.07.2006
                    --to correct checking if existing in another policy
                    /*AND renew_no <> v_renew_no
                    AND pol_seq_no<> v_pol_seq_no
                    AND issue_yy  <> v_issue_yy
                    AND iss_cd  <> v_iss_cd
                    AND subline_cd<> v_subline_cd
                    AND line_cd  <> v_line_cd*/
                    AND (line_cd  <> v_line_cd
                     OR subline_cd<> v_subline_cd
                     OR iss_cd  <> v_iss_cd
                     OR issue_yy  <> v_issue_yy
                     OR pol_seq_no<> v_pol_seq_no
                     OR renew_no <> v_renew_no)
                    AND policy_id =D.policy_id )
               LOOP
                 v_exist:='Y';
                --A.R.C. 12.07.2006
                --change to warning and allow continuation according to miss j.   
                --msg_alert('Motor Number - '||C.motor_no||' already exist in other PAR No. / Policy No.'||chr(10)||'Change the motor no before posting','E',TRUE);
                CHECK_EXIST_PAR_POLICY('POLICY','MOTOR_NO',c.motor_no);
                 exit;
               END LOOP;
               IF v_exist = 'Y' THEN
                 EXIT;
               END IF;            
         END LOOP;
          IF v_exist='N' THEN
           FOR F in (SELECT par_id 
                FROM gipi_wvehicle
                WHERE motor_no=c.motor_no)
           LOOP      
              FOR E IN (SELECT 1 FROM gipi_wpolbas
                    WHERE 1=1
                    --A.R.C. 12.07.2006
                    --to correct checking if existing in another policy
                    /*AND renew_no <> v_renew_no
                    AND pol_seq_no<> v_pol_seq_no
                    AND issue_yy  <> v_issue_yy
                    AND iss_cd  <> v_iss_cd
                    AND subline_cd<> v_subline_cd
                    AND line_cd  <> v_line_cd*/
                    AND (line_cd  <> v_line_cd
                     OR subline_cd<> v_subline_cd
                     OR iss_cd  <> v_iss_cd
                     OR issue_yy  <> v_issue_yy
                     OR pol_seq_no<> v_pol_seq_no
                     OR renew_no <> v_renew_no)
                    AND par_id=F.par_id )
               LOOP
                 v_exist:='Y';
                --A.R.C. 12.07.2006
                --change to warning and allow continuation according to miss j.   
                --msg_alert('Motor Number - '||C.motor_no||' already exist in other PAR No. / Policy No.'||chr(10)||'Change the motor no before posting','E',TRUE);
                CHECK_EXIST_PAR_POLICY('PAR','MOTOR_NO',c.motor_no);
                 exit;
               END LOOP;
               IF v_exist = 'Y' THEN
                 EXIT;
               END IF; 
           END LOOP;
          END IF; 
        END LOOP;      
     END LOOP; 
END IF;   
--=============================================================================
END IF;
END;
--added by dannel 10162006
--validations for plate no before posting
PROCEDURE validate_plate_no IS
--v_exist_in   VARCHAR2(15):= NULL;
v_exist       VARCHAR2(1):='N';
cnt_item     NUMBER:=0;
v_plate_no   gipi_wvehicle.plate_no%TYPE;
v_plate_cnt   NUMBER:=0;
v_claims    NUMBER:=0;
v_line_cd    gipi_polbasic.line_cd%TYPE;
v_subline_cd  gipi_polbasic.subline_cd%TYPE;
v_iss_cd    gipi_polbasic.iss_cd%TYPE;
v_issue_yy   gipi_polbasic.issue_yy%TYPE;
v_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE;
v_renew_no   gipi_polbasic.renew_no%TYPE;
BEGIN
IF skip_parid = 'N' THEN
 SELECT count(*) INTO cnt_item FROM gipi_witem --count items for that PAR
  WHERE par_id = v_par_id;
/*check if the plate no exist in gicl_claims and total_tag ='Y'*/
    FOR B IN (SELECT distinct item_no 
         FROM GIPI_WITEM
         WHERE par_id= v_par_id)
    LOOP
       FOR C IN (SELECT plate_no 
       FROM gipi_wvehicle
       WHERE plate_no IS NOT NULL
       AND item_no=B.item_no
       AND par_id= v_par_id)
     LOOP
       FOR D IN (SELECT 1 FROM gicl_claims --if record exist, posting will not continue
            WHERE  plate_no=c.plate_no
            AND   total_tag='Y')
       LOOP
         PRE_POST_ERROR( v_par_id, 'Plate Number - '||c.plate_no||' already tagged as total loss');
       END LOOP;      
     END LOOP; 
    END LOOP; 
--=======================================================================================
/*check if plate no already exist in other PAR or other policy*/ 
IF  v_par_type='P' THEN   
  IF cnt_item=1 THEN-- for PAR w/ 1 item
   BEGIN
     SELECT plate_no 
       INTO v_plate_no
       FROM gipi_wvehicle
      WHERE plate_no IS NOT NULL
        AND par_id= v_par_id;
   EXCEPTION --added by Connie 12/09/06
     WHEN NO_DATA_FOUND THEN NULL;
   END;
   SELECT count(*) -- count no of occurence of plate_no
     INTO v_plate_cnt
     FROM gipi_wvehicle
    WHERE plate_no=v_plate_no;
   IF v_plate_cnt > 1 THEN--if it occurs more than 1, plate already exist in other PAR
     v_exist:='Y';
     --A.R.C. 12.08.2006
     --msg_alert('Plate Number - '||v_plate_no||' already exist in other PAR No. / Policy No.','W',FALSE);   
     CHECK_EXIST_PAR_POLICY('PAR','PLATE_NO',v_plate_no);
   END IF ;
   IF v_exist='N' THEN--if it does not occurs in other PAR, then check other Policy
     FOR A IN (SELECT 1 FROM gipi_vehicle
          WHERE plate_no=v_plate_no )
     LOOP
      v_exist:='Y';
      --A.R.C. 12.08.2006
      --msg_alert('Plate Number - '||v_plate_no||' already exist in other PAR No. / Policy No.','W',FALSE);   
      CHECK_EXIST_PAR_POLICY('POLICY','PLATE_NO',v_plate_no);
       EXIT;
     END LOOP;
   END IF;
  END IF; 
  IF cnt_item > 1 THEN --for PAR w/ more than 1 item 
    FOR B IN (SELECT distinct item_no 
         FROM GIPI_WITEM
         WHERE par_id= v_par_id)
    LOOP
     v_exist:='N';
     FOR C IN (SELECT plate_no 
          FROM gipi_wvehicle
          WHERE plate_no IS NOT NULL
          AND item_no=B.item_no
          AND par_id= v_par_id)
     LOOP
         SELECT count(*) 
        INTO v_plate_cnt
         FROM gipi_wvehicle
         WHERE plate_no=C.plate_no;
       IF v_plate_cnt > 1 THEN
          v_exist:='Y';
          --A.R.C. 12.08.2006
          --msg_alert('Plate Number - '||C.plate_no||' already exist in other PAR No. / Policy No.','W',FALSE);   
          CHECK_EXIST_PAR_POLICY('PAR','PLATE_NO',c.plate_no);
         END IF ;
        IF v_exist='N' THEN
          FOR A IN (SELECT 1 FROM gipi_vehicle
               WHERE plate_no=C.plate_no )
          LOOP
          v_exist:='Y';
          --A.R.C. 12.08.2006
          --msg_alert('Plate Number - '||C.plate_no||' already exist in other PAR No. / Policy No.','W',FALSE);   
          CHECK_EXIST_PAR_POLICY('POLICY','PLATE_NO',c.plate_no);
          EXIT;
          END LOOP;
        END IF;
     END LOOP;      
    END LOOP;      
  END IF; 
  ELSIF  v_par_type='E' THEN--validation for endorsements,exclude same policy no or previous endorsements    
     SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no --policy_no of the PAR to be posted
     INTO v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no
     FROM gipi_wpolbas
     WHERE par_id= v_par_id;
    -- message(v_line_cd||'-'||v_subline_cd||'-'||v_iss_cd||'-'||v_issue_yy||'-'||v_pol_seq_no||'-'||v_renew_no);--dd
   --  message(v_line_cd||'-'||v_subline_cd||'-'||v_iss_cd||'-'||v_issue_yy||'-'||v_pol_seq_no||'-'||v_renew_no);--dd
     FOR B IN (SELECT distinct item_no 
         FROM GIPI_WITEM
         WHERE par_id= v_par_id)
     LOOP
        v_exist:='N';   
        FOR C IN (SELECT  plate_no --plate no  of the PAR to be post
          FROM gipi_wvehicle
          WHERE plate_no IS NOT NULL
          AND item_no=B.item_no
          AND par_id= v_par_id)
        LOOP
          FOR D IN (SELECT policy_id FROM gipi_vehicle--to be compare to the policy_no of PAR to be posted
                WHERE plate_no=C.plate_no )
           LOOP
              -- message(D.policy_id);
              -- message(D.policy_id);
               FOR E IN (SELECT 1 FROM gipi_polbasic
                    WHERE 1=1
                    --A.R.C. 12.07.2006
                    --to correct checking if existing in another policy
                    /*AND renew_no <> v_renew_no
                    AND pol_seq_no<> v_pol_seq_no
                    AND issue_yy  <> v_issue_yy
                    AND iss_cd  <> v_iss_cd
                    AND subline_cd<> v_subline_cd
                    AND line_cd  <> v_line_cd*/
                    AND (line_cd  <> v_line_cd
                     OR subline_cd<> v_subline_cd
                     OR iss_cd  <> v_iss_cd
                     OR issue_yy  <> v_issue_yy
                     OR pol_seq_no<> v_pol_seq_no
                     OR renew_no <> v_renew_no)
                    AND policy_id =D.policy_id )
               LOOP
                 v_exist:='Y';
                 --A.R.C. 12.08.2006
                 --msg_alert('Plate Number - '||C.plate_no||' already exist in other PAR No. / Policy No.','W',FALSE);   
                 CHECK_EXIST_PAR_POLICY('POLICY','PLATE_NO',c.plate_no);
                 exit;
               END LOOP;
               IF v_exist = 'Y' THEN
                 EXIT;
               END IF; 
         END LOOP;
          IF v_exist='N' THEN
           FOR F in (SELECT par_id 
                FROM gipi_wvehicle
                WHERE plate_no=c.plate_no)
           LOOP      
              FOR E IN (SELECT 1 FROM gipi_wpolbas
                    WHERE 1=1
                    --A.R.C. 12.07.2006
                    --to correct checking if existing in another policy
                    /*AND renew_no <> v_renew_no
                    AND pol_seq_no<> v_pol_seq_no
                    AND issue_yy  <> v_issue_yy
                    AND iss_cd  <> v_iss_cd
                    AND subline_cd<> v_subline_cd
                    AND line_cd  <> v_line_cd*/
                    AND (line_cd  <> v_line_cd
                     OR subline_cd<> v_subline_cd
                     OR iss_cd  <> v_iss_cd
                     OR issue_yy  <> v_issue_yy
                     OR pol_seq_no<> v_pol_seq_no
                     OR renew_no <> v_renew_no)
                    AND par_id=F.par_id )
               LOOP
                 v_exist:='Y';
                 --A.R.C. 12.08.2006
                 --msg_alert('Plate Number - '||C.plate_no||' already exist in other PAR No. / Policy No.','W',FALSE);   
                 CHECK_EXIST_PAR_POLICY('PAR','PLATE_NO',c.plate_no);
                 exit;
               END LOOP;
               IF v_exist = 'Y' THEN
                 EXIT;
               END IF; 
           END LOOP;
          END IF; 
        END LOOP;      
     END LOOP; 
END IF;   
--=============================================================================
END IF;
END;
PROCEDURE validate_serial_motor IS
v_exist_in    VARCHAR2(1):='N';
v_exist       VARCHAR2(1):='N';
cnt_item     NUMBER:=0;
v_plate_no   VARCHAR2(10);
v_plate_cnt   NUMBER:=0;
v_claims    NUMBER:=0;
v_line_cd    gipi_polbasic.line_cd%TYPE;
v_subline_cd  gipi_polbasic.subline_cd%TYPE;
v_iss_cd    gipi_polbasic.iss_cd%TYPE;
v_issue_yy   gipi_polbasic.issue_yy%TYPE;
v_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE;
v_renew_no   gipi_polbasic.renew_no%TYPE;
BEGIN
IF skip_parid = 'N' THEN 
 SELECT count(*) INTO cnt_item FROM gipi_witem --count items for that PAR
  WHERE par_id = v_par_id;
/*check if the motor_no  exist in gicl_motor_car_dtl  and  the gicl_claims.total_tag ='Y'*/
    FOR B IN (SELECT distinct item_no 
         FROM GIPI_WITEM
         WHERE par_id= v_par_id)
    LOOP
      v_exist_in:='N';
       FOR C IN (SELECT motor_no,serial_no 
       FROM gipi_wvehicle
       WHERE plate_no IS NOT NULL
       AND item_no=B.item_no
       AND par_id= v_par_id)
     LOOP
       FOR D IN (SELECT 1 FROM  gicl_motor_car_dtl a ,gicl_claims b --if record exist, posting will not continue
            WHERE a.motor_no=c.motor_no
             AND a. claim_id=b.claim_id 
             AND b.total_tag='Y')
       LOOP
        v_exist_in:='Y';
         PRE_POST_ERROR( v_par_id, 'Motor no -'||c.motor_no||'already tagged as total loss'||CHr(10)||'Change the motor no before posting');           
       END LOOP; 
       IF v_exist_in='N' THEN
         FOR D IN (SELECT 1 FROM  gicl_motor_car_dtl a ,gicl_claims b --if record exist, posting will not continue
            WHERE a.serial_no=c.serial_no
             AND a. claim_id=b.claim_id 
             AND b.total_tag='Y')
         LOOP
          v_exist_in:='Y';
           PRE_POST_ERROR( v_par_id, 'Serial No. -'||c.serial_no||'already tagged as total loss'||CHr(10)||'Change the serial no before posting');
         END LOOP; 
       END IF;
     END LOOP; 
    END LOOP; 
END IF;
END;
PROCEDURE validate_serial_no IS
--v_exist_in   VARCHAR2(15):= NULL;
v_exist       VARCHAR2(1):='N';
v_cnt_item    NUMBER:=0;
v_serial_no   gipi_wvehicle.serial_no%TYPE;
v_serial_cnt   NUMBER:=0;
v_claims    NUMBER:=0;
v_line_cd    gipi_polbasic.line_cd%TYPE;
v_subline_cd  gipi_polbasic.subline_cd%TYPE;
v_iss_cd    gipi_polbasic.iss_cd%TYPE;
v_issue_yy   gipi_polbasic.issue_yy%TYPE;
v_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE;
v_renew_no   gipi_polbasic.renew_no%TYPE;
BEGIN
IF skip_parid = 'N' THEN
/*check if serial_no already exist in other PAR or other policy*/ 
 SELECT count(*) INTO v_cnt_item FROM gipi_witem --count items for that PAR
  WHERE par_id = v_par_id;
IF  v_par_type='P' THEN   
  IF v_cnt_item=1 THEN-- for PAR w/ 1 item
   BEGIN
     SELECT serial_no 
       INTO v_serial_no
       FROM gipi_wvehicle
      WHERE serial_no IS NOT NULL
        AND par_id= v_par_id;
   EXCEPTION --added by Connie 12/09/06
       WHEN NO_DATA_FOUND THEN NULL;
   END;
   SELECT count(*) -- count no of occurence of serial_no
     INTO v_serial_cnt
     FROM gipi_wvehicle
    WHERE serial_no=v_serial_no;
   IF v_serial_cnt > 1 THEN--if it occurs more than 1, serial already exist in other PAR
     v_exist:='Y';
     --A.R.C. 12.07.2006
     --change to warning and allow continuation according to miss j.      
     --msg_alert('Serial Number - '||v_serial_no||' already exist in other PAR No. / Policy No.'||chr(10)||'Change the serial no before posting','E',TRUE);
     CHECK_EXIST_PAR_POLICY('PAR','SERIAL_NO',v_serial_no);
   END IF ;
   IF v_exist='N' THEN--if it does not occurs in other PAR, then check other Policy
     FOR A IN (SELECT 1 FROM gipi_vehicle
          WHERE serial_no=v_serial_no )
     LOOP
      v_exist:='Y';
      --A.R.C. 12.07.2006
      --change to warning and allow continuation according to miss j.   
      --msg_alert('Serial Number - '||v_serial_no||' already exist in other PAR No. / Policy No.'||chr(10)||'Change the serial no before posting','E',TRUE);
      CHECK_EXIST_PAR_POLICY('POLICY','SERIAL_NO',v_serial_no);
       EXIT;
     END LOOP;
   END IF;
  END IF; 
  IF v_cnt_item > 1 THEN --for PAR w/ more than 1 item 
    FOR B IN (SELECT distinct item_no 
         FROM GIPI_WITEM
         WHERE par_id= v_par_id)
    LOOP
     v_exist:='N';
     FOR C IN (SELECT serial_no 
          FROM gipi_wvehicle
          WHERE serial_no IS NOT NULL
          AND item_no=B.item_no
          AND par_id= v_par_id)
     LOOP
         SELECT count(*) 
        INTO v_serial_cnt
         FROM gipi_wvehicle
         WHERE serial_no=C.serial_no;
       IF v_serial_cnt > 1 THEN
        v_exist:='Y';
        --A.R.C. 12.07.2006
        --change to warning and allow continuation according to miss j.   
         --msg_alert('Serial Number - '||C.serial_no||' already exist in other PAR No. / Policy No.'||chr(10)||'Change the serial no before posting','E',TRUE);
         CHECK_EXIST_PAR_POLICY('PAR','SERIAL_NO',c.serial_no);
         END IF ;
        IF v_exist='N' THEN
          FOR A IN (SELECT 1 FROM gipi_vehicle
               WHERE serial_no=C.serial_no )
          LOOP
          v_exist:='Y';
          --A.R.C. 12.07.2006
          --change to warning and allow continuation according to miss j.   
           --msg_alert('Serial Number - '||C.serial_no||' already exist in other PAR No. / Policy No.'||chr(10)||'Change the serial no before posting','E',TRUE);
           CHECK_EXIST_PAR_POLICY('POLICY','SERIAL_NO',c.serial_no);
          EXIT;
          END LOOP;
        END IF;
     END LOOP;      
    END LOOP;      
  END IF; 
  ELSIF  v_par_type='E' THEN--validation for endorsements,exclude same policy no or previous endorsements    
     SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no --policy_no of the PAR to be posted
     INTO v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no
     FROM gipi_wpolbas
     WHERE par_id= v_par_id;
    -- message(v_line_cd||'-'||v_subline_cd||'-'||v_iss_cd||'-'||v_issue_yy||'-'||v_pol_seq_no||'-'||v_renew_no);--dd
   --  message(v_line_cd||'-'||v_subline_cd||'-'||v_iss_cd||'-'||v_issue_yy||'-'||v_pol_seq_no||'-'||v_renew_no);--dd
     FOR B IN (SELECT distinct item_no 
         FROM GIPI_WITEM
         WHERE par_id= v_par_id)
     LOOP
        v_exist:='N';   
        FOR C IN (SELECT  serial_no --serial no  of the PAR to be post
          FROM gipi_wvehicle
          WHERE serial_no IS NOT NULL
          AND item_no=B.item_no
          AND par_id= v_par_id)
        LOOP
          FOR D IN (SELECT policy_id FROM gipi_vehicle--to be compare to the policy_no of PAR to be posted
                WHERE serial_no=C.serial_no )
           LOOP
              -- message(D.policy_id);
              -- message(D.policy_id);
               FOR E IN (SELECT 1 FROM gipi_polbasic
                    WHERE 1=1
                    --A.R.C. 12.07.2006
                    --to correct checking if existing in another policy
                    /*AND renew_no <> v_renew_no
                    AND pol_seq_no<> v_pol_seq_no
                    AND issue_yy  <> v_issue_yy
                    AND iss_cd  <> v_iss_cd
                    AND subline_cd<> v_subline_cd
                    AND line_cd  <> v_line_cd*/
                    AND (line_cd  <> v_line_cd
                     OR subline_cd<> v_subline_cd
                     OR iss_cd  <> v_iss_cd
                     OR issue_yy  <> v_issue_yy
                     OR pol_seq_no<> v_pol_seq_no
                     OR renew_no <> v_renew_no)
                    AND policy_id =D.policy_id )
               LOOP
                 v_exist:='Y';
                --A.R.C. 12.07.2006
                --change to warning and allow continuation according to miss j.   
                 --msg_alert('Serial Number - '||C.serial_no||' already exist in other PAR No. / Policy No.'||chr(10)||'Change the serial no before posting','E',TRUE);
                 CHECK_EXIST_PAR_POLICY('POLICY','SERIAL_NO',c.serial_no);
                 exit;
               END LOOP;
               IF v_exist = 'Y' THEN
                 EXIT;
               END IF;            
         END LOOP;
          IF v_exist='N' THEN
           FOR F in (SELECT par_id 
                FROM gipi_wvehicle
                WHERE serial_no=c.serial_no)
           LOOP      
              FOR E IN (SELECT 1 FROM gipi_wpolbas
                    WHERE 1=1
                    --A.R.C. 12.07.2006
                    --to correct checking if existing in another policy
                    /*AND renew_no <> v_renew_no
                    AND pol_seq_no<> v_pol_seq_no
                    AND issue_yy  <> v_issue_yy
                    AND iss_cd  <> v_iss_cd
                    AND subline_cd<> v_subline_cd
                    AND line_cd  <> v_line_cd*/
                    AND (line_cd  <> v_line_cd
                     OR subline_cd<> v_subline_cd
                     OR iss_cd  <> v_iss_cd
                     OR issue_yy  <> v_issue_yy
                     OR pol_seq_no<> v_pol_seq_no
                     OR renew_no <> v_renew_no)
                    AND par_id=F.par_id )
               LOOP
                 v_exist:='Y';
                --A.R.C. 12.07.2006
                --change to warning and allow continuation according to miss j.   
                 --msg_alert('Serial Number - '||C.serial_no||' already exist in other PAR No. / Policy No.'||chr(10)||'Change the serial no before posting','E',TRUE);
                 CHECK_EXIST_PAR_POLICY('PAR','SERIAL_NO',c.serial_no);
                 exit;
               END LOOP;
               IF v_exist = 'Y' THEN
                 EXIT;
               END IF;                
           END LOOP;
          END IF; 
        END LOOP;      
     END LOOP; 
END IF;   
--=============================================================================
END IF;
END;
PROCEDURE validate_wopen_liab IS
BEGIN
IF skip_parid = 'N' THEN
  SELECT geog_cd
    INTO postpar_dumm_var
    FROM gipi_wopen_liab 
   WHERE par_id = postpar_par_id;
END IF;    
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    pre_post_error(v_par_id,'PAR should have OPEN LIABILITY existing.');
END;
PROCEDURE validate_wves_air IS
BEGIN
IF skip_parid = 'N' THEN
  SELECT vessel_cd 
    INTO postpar_dumm_var
    FROM gipi_wves_air 
   WHERE gipi_wves_air.par_id = postpar_par_id;
END IF;    
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    pre_post_error(v_par_id,'PAR should have a vessel/conveyance description.');
  WHEN TOO_MANY_ROWS THEN
    NULL;
END;
PROCEDURE validate_wopen_policy IS
BEGIN
IF skip_parid = 'N' THEN
  SELECT par_id
    INTO postpar_dumm_var
    FROM gipi_wopen_policy
   WHERE par_id  = postpar_par_id;
END IF;   
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    IF postpar_iss_cd  != issue_ri then 
    pre_post_error(v_par_id,'PAR should have OPEN POLICY existing.');
    end if;
END;
PROCEDURE validate_wcollateral_dtl(p_coll_flag gipi_wbond_basic.coll_flag%TYPE) IS
  v_coll_cd gipi_collateral_par.coll_id%TYPE;
BEGIN
IF skip_parid = 'N' THEN
  IF p_coll_flag = 'Q' OR p_coll_flag = 'S' OR p_coll_flag = 'P' THEN 
     BEGIN
       SELECT coll_id
         INTO v_coll_cd
         FROM gipi_collateral_par
        WHERE par_id = postpar_par_id;
     EXCEPTION    
       WHEN NO_DATA_FOUND THEN
          NULL;
          --removed to allow posting even without gipi_collateral - edsel - 7/25/01
            --msg_alert('A collateral is required.','I',FALSE);
            --error_rtn;
       WHEN TOO_MANY_ROWS THEN
            NULL;
     END;
  ELSIF p_coll_flag = 'R' THEN
     BEGIN
       SELECT coll_id
         INTO v_coll_cd
         FROM gipi_collateral_par
        WHERE par_id = postpar_par_id;
     EXCEPTION    
       WHEN NO_DATA_FOUND THEN
          NULL;
       WHEN TOO_MANY_ROWS THEN
            NULL;
     END;
  END IF;
END IF;  
END;
PROCEDURE validate_WBOND_BASIC IS
    v_coll_flag  gipi_wbond_basic.coll_flag%TYPE;
BEGIN
IF skip_parid = 'N' THEN
  IF affecting = 'Y' THEN  --bdarusin, 010302
                                    --will check bond basic only when endt is affecting
    BEGIN
    SELECT par_id,coll_flag
      INTO postpar_dumm_var,v_coll_flag
      FROM gipi_wbond_basic
     WHERE par_id = postpar_par_id;
    IF v_coll_flag = 'Q' OR v_coll_flag = 'S' OR v_coll_flag = 'P' OR v_coll_flag = 'R' THEN
       validate_wcollateral_dtl(v_coll_flag);  -- at least one record w/out release date for
    END IF;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
          pre_post_error(v_par_id,'PAR should have BOND BASIC existing.');
    END;        
  END IF;
END IF;  
END;
PROCEDURE recompute_items IS
  p_error         VARCHAR2(1) := 'N';
BEGIN
IF skip_parid = 'N' THEN
  FOR D IN (SELECT item_no,prem_amt,tsi_amt
              FROM gipi_witem
             WHERE par_id  =  postpar_par_id) LOOP
       FOR E IN (SELECT   sum(a.prem_amt) prem_amt,sum(b.tsi_amt) tsi_amt
                   FROM   gipi_witmperl a,gipi_witmperl b,giis_peril c
                  WHERE   a.par_id   =  b.par_id
                    AND   a.item_no  =  b.item_no
                    AND   a.par_id   =  postpar_par_id
                    AND   a.item_no  =  D.item_no
                    AND   b.peril_cd =  c.peril_cd
                    AND   c.line_cd  =  b.line_cd
                    AND   c.peril_type = 'B') LOOP
              IF ((NVL(E.prem_amt,0) != NVL(D.prem_amt,0)) OR 
                  (NVL(E.tsi_amt,0) != NVL(D.tsi_amt,0))) THEN
                   UPDATE    gipi_witem
                      SET    tsi_amt  =  D.tsi_amt,
                             prem_amt =  D.prem_amt
                    WHERE    par_id   =  postpar_par_id
                      AND    item_no  =  D.item_no;
                    p_error   :=  'Y';
              END IF;
        END LOOP;
  END LOOP;
  IF p_error = 'Y' THEN
      CREATE_WINVOICE(0,0,0,postpar_par_id,postpar_line_cd,postpar_iss_cd); -- modified by aivhie 120601 
      cr_bill_dist.get_tsi(postpar_par_id);
      UPDATE  gipi_parlist
         SET  par_status  =  5
       WHERE  par_id      =  postpar_par_id;
      pre_post_error(v_par_id,'Internal computation error, will now call Bill Information Module.');
  END IF;
END IF; 
END;
PROCEDURE validate_wfireitm(p_item_no IN gipi_witem.item_no%TYPE) IS
  x NUMBER;
BEGIN
IF skip_parid = 'N' THEN
  SELECT item_no
    INTO x
    FROM gipi_wfireitm 
   WHERE par_id  = postpar_par_id AND
         item_no = p_item_no;
END IF;   
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       pre_post_error(v_par_id,'Item '||to_char(p_item_no)||
                 ' should have an additional information.');
  WHEN TOO_MANY_ROWS THEN
       NULL;
END;
PROCEDURE validate_witem_ves(p_item_no IN gipi_witem.item_no%TYPE) IS
  x NUMBER;
BEGIN
IF skip_parid = 'N' THEN
  SELECT item_no
    INTO x
    FROM gipi_witem_ves
   WHERE par_id  = postpar_par_id AND
         item_no = p_item_no;
END IF;     
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       pre_post_error(v_par_id,'Item ' || to_char(p_item_no) ||
                 ' should have an additional information.');   
END;
PROCEDURE validate_wcargo(p_item_no in GIPI_WITEM.ITEM_NO%TYPE) IS
          x NUMBER;
BEGIN
IF skip_parid = 'N' THEN
  BEGIN
    SELECT item_no
      INTO x
      FROM gipi_wcargo
     WHERE par_id  = postpar_par_id AND
           item_no = p_item_no;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         pre_post_error(v_par_id,'Item ' || to_char(p_item_no) || 
                   ' should have an additional information.');
  END;
END IF;  
END;
PROCEDURE validate_wmotcar_item(p_item_no in GIPI_WITEM.ITEM_NO%TYPE) IS
  x  NUMBER;
BEGIN
IF skip_parid = 'N' THEN
  BEGIN
    SELECT item_no
      INTO x
      FROM gipi_wmcacc
     WHERE par_id  = postpar_par_id AND
           item_no = p_item_no;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      null;
    WHEN TOO_MANY_ROWS THEN
      NULL;
  END;
  BEGIN
    SELECT item_no
      INTO x
      FROM  gipi_wvehicle
     WHERE par_id  = postpar_par_id AND
           item_no = p_item_no;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      pre_post_error(v_par_id,'Item '||to_char(p_item_no)||' should have an additional information.');
    WHEN TOO_MANY_ROWS THEN
      NULL;
  END;
END IF;  
END;
PROCEDURE validate_WENGR_ITEM(p_item_no in GIPI_WITEM.ITEM_NO%TYPE) IS
          x NUMBER;
BEGIN
IF skip_parid = 'N' THEN  
  BEGIN
    SELECT item_no
      INTO x
      FROM gipi_wlocation
     WHERE par_id  = postpar_par_id AND
           item_no = p_item_no;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         pre_post_error(v_par_id, 'Item '||to_char(p_item_no)||
                   ' should have an additional information for location.');
    WHEN TOO_MANY_ROWS THEN
         NULL;
  END;
END IF;  
END;
PROCEDURE validate_witmperl(p_item_no      IN gipi_witem.item_no%TYPE,
              p_grouped_item_no IN gipi_wgrouped_items.grouped_item_no%TYPE,
                            p_rec_stat     IN gipi_witem.rec_flag%TYPE,
                            p_item_tsi     IN gipi_witem.tsi_amt%TYPE,
                            p_item_prem    IN gipi_witem.prem_amt%TYPE,
                            p_item_anntsi  IN gipi_witem.ann_tsi_amt%TYPE,
                            p_item_annprem IN gipi_witem.ann_prem_amt%TYPE,
                            p_line_cd      IN gipi_witmperl.line_cd%TYPE)IS
  CURSOR witmperl_cursor IS SELECT item_no,peril_cd,tsi_amt,ann_tsi_amt,prem_amt,ann_prem_amt
                              FROM gipi_witmperl
                             WHERE par_id  = postpar_par_id AND
                                   line_cd = p_line_cd AND
                                   item_no = p_item_no;
--**--gmi 09/23/05--**--                                   
  CURSOR witmperl_grp_cursor IS SELECT item_no,grouped_item_no,peril_cd,tsi_amt,ann_tsi_amt,prem_amt,ann_prem_amt
                              FROM gipi_witmperl_grouped
                             WHERE par_id  = postpar_par_id AND
                                   line_cd = p_line_cd AND                                 
                                   item_no = p_item_no AND
                                   grouped_item_no = p_grouped_item_no;  
--**--gmi--**--                                   
  x   NUMBER;
  y   NUMBER;
  j   NUMBER;--gmi :used for grouped item perils
  v_rec_not_found  CHAR;
  v_perl_type  giis_peril.peril_type%TYPE;
  v_perl_cd  gipi_witmperl.peril_cd%TYPE;
  v_basic_cd  giis_peril.basc_perl_cd%TYPE;
  v_linename  giis_line.line_name%TYPE;
  v_tsi   gipi_witmperl.tsi_amt%TYPE  := 0;
  v_prem  gipi_witmperl.prem_amt%TYPE  := 0;
  v_anntsi  gipi_witmperl.ann_tsi_amt%TYPE  := 0;
  v_annprem  gipi_witmperl.ann_prem_amt%TYPE  := 0;
/* to check for existing perils for each item */
BEGIN
IF skip_parid = 'N' THEN
  x := 0;
  j := 0;--gmi
   FOR witmperl_cursor_rec IN witmperl_cursor LOOP
        x := x + 1;
        v_tsi     := v_tsi     + NVL(witmperl_cursor_rec.tsi_amt,0);
        v_prem    := v_prem    + NVL(witmperl_cursor_rec.prem_amt,0);
        v_anntsi  := v_anntsi  + NVL(witmperl_cursor_rec.ann_tsi_amt,0);
        v_annprem := v_annprem + NVL(witmperl_cursor_rec.ann_prem_amt,0);
        -- for casualty's wperil_section -nski 101196 --
    END LOOP;
--**--gmi--**--    
  FOR witmperl_grp_cursor_rec IN witmperl_grp_cursor LOOP
        j := j + 1;        
  END LOOP;
/*  IF p_grouped_item_no IS NULL THEN
   j := 0;
  END IF;*/
--**--gmi--**--  
    IF x > 0 OR j > 0 THEN
       NULL;
     ELSE
      IF postpar_par_type = 'E' THEN
          IF p_line_cd IN
             (postpar_fire_cd,postpar_hull_cd,postpar_cargo_cd) THEN
             IF p_rec_stat NOT IN ('C','D') THEN
                pre_post_error(v_par_id,'Item ' || to_char(p_item_no) ||
                          ' should have at least one peril.');
             END IF;
          /* All lines should not delete their items
          ** September 1, 1997
          */
          END IF;
       ELSE
          pre_post_error(v_par_id,'Item ' || to_char(p_item_no) ||
                    ' should have at least one peril.');
       END IF;
    END IF;
END IF;   
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
        pre_post_error(v_par_id, 'NO DATA FOUND');
END;
PROCEDURE validate_witem IS
          v_item_no1   NUMBER := 0 ;
          v_item_no2   NUMBER;
          v_item_no3  NUMBER := 0 ; --**gmi**--
          v_item_no4   NUMBER;    --**gmi**--
          v_exists   VARCHAR2(1) := 'N'; --**gmi**--
  CURSOR witem_cursor IS
         SELECT item_no,item_title,rec_flag,tsi_amt,ann_tsi_amt,prem_amt,ann_prem_amt
           FROM gipi_witem
          WHERE par_id = postpar_par_id;
--**--gmi 09/26/05--**--          
  CURSOR witem_grp_cursor IS
         SELECT a.item_no,a.grouped_item_no,a.grouped_item_title,b.rec_flag,b.tsi_amt,b.ann_tsi_amt,b.prem_amt,b.ann_prem_amt
           FROM gipi_wgrouped_items a, gipi_witem b          
          WHERE b.par_id = postpar_par_id 
            AND a.par_id = b.par_id
            AND a.item_no = b.item_no;        
--**--gmi--**--
  CURSOR pack IS
         SELECT pack_line_cd,pack_subline_cd
           FROM gipi_wpack_line_subline
          WHERE par_id = postpar_par_id;
  CURSOR pack_item(p_line_cd gipi_witem.pack_line_cd%TYPE,
                   p_subline gipi_witem.pack_subline_cd%TYPE) IS
         SELECT item_no,item_title,rec_flag,tsi_amt,ann_tsi_amt,prem_amt,ann_prem_amt,
                pack_line_cd,pack_subline_cd
           FROM gipi_witem
          WHERE par_id = postpar_par_id
            AND pack_line_cd    = p_line_cd
            AND pack_subline_cd = p_subline;
BEGIN
IF skip_parid = 'N' THEN
  FOR a IN (SELECT 1
              FROM gipi_witmperl_grouped
             WHERE par_id  = postpar_par_id) LOOP
  v_exists := 'Y';
  EXIT;
  END LOOP;              
  IF NOT(postpar_pack = 'Y') THEN 
   IF postpar_line_cd IN (postpar_hull_cd,postpar_cargo_cd) THEN
     IF v_exists = 'N' THEN --added by gmi
     FOR witem_cursor_rec IN witem_cursor LOOP
         v_item_no1 := v_item_no1 + 1;
         IF    ((witem_cursor_rec.item_title IS NULL) AND (postpar_par_type = 'P')) THEN
            pre_post_error(v_par_id,'Item no. '||TO_CHAR(witem_cursor_rec.item_no)||
                      ' should have an item title');
         END IF;
         IF NOT (postpar_line_cd  = postpar_hull_cd) AND
            (NOT (postpar_par_type = 'E' AND witem_cursor_rec.rec_flag IN ('C','D','A')) AND
                  postpar_subline_cd != subline_mop) THEN
            validate_wcargo(witem_cursor_rec.item_no);
      ELSIF (postpar_line_cd = postpar_hull_cd AND postpar_par_type = 'P') THEN
            validate_witem_ves(witem_cursor_rec.item_no);
         END IF;
         validate_witmperl(witem_cursor_rec.item_no, null,
                   witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt, witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt, witem_cursor_rec.ann_prem_amt,
                           postpar_line_cd);
     END LOOP;
     ELSIF v_exists = 'Y' THEN --added by gmi
     --**--gmi 09/26/05--**--
     FOR witem_grp_cursor_rec IN witem_grp_cursor LOOP
         v_item_no3 := v_item_no3 + 1;
         IF    ((witem_grp_cursor_rec.grouped_item_title IS NULL) AND (postpar_par_type = 'P')) THEN
            pre_post_error(v_par_id,'Grouped Item no. '||TO_CHAR(witem_grp_cursor_rec.grouped_item_no)||
                      ' should have an item title');
         END IF;
         IF NOT (postpar_line_cd  = postpar_hull_cd) AND
            (NOT (postpar_par_type = 'E' AND witem_grp_cursor_rec.rec_flag IN ('C','D','A')) AND
                  postpar_subline_cd !=  subline_mop) THEN
            validate_wcargo(witem_grp_cursor_rec.item_no);
   null;
      ELSIF (postpar_line_cd = postpar_hull_cd AND postpar_par_type = 'P') THEN
            validate_witem_ves(witem_grp_cursor_rec.item_no);
         END IF;
         validate_witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,
                     witem_grp_cursor_rec.rec_flag,
                             witem_grp_cursor_rec.tsi_amt, witem_grp_cursor_rec.prem_amt,
                             witem_grp_cursor_rec.ann_tsi_amt, witem_grp_cursor_rec.ann_prem_amt,
                             postpar_line_cd);
     END LOOP;
     END IF;
     --**--gmi--**--
  ELSIF postpar_line_cd = postpar_fire_cd THEN
     IF v_exists = 'N' THEN --added by gmi 
     FOR witem_cursor_rec in witem_cursor LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Item no. ' || to_char(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title');
         END IF;
         IF postpar_par_type = 'P' THEN
            validate_wfireitm(witem_cursor_rec.item_no);
         END IF;
         validate_witmperl(witem_cursor_rec.item_no, null,       
                   witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,       witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,   witem_cursor_rec.ann_prem_amt,
                           postpar_line_cd);
     END LOOP;
     --**--gmi 09/26/05--**--
     ELSIF v_exists = 'Y' THEN --added by gmi
     FOR witem_grp_cursor_rec in witem_grp_cursor LOOP
         v_item_no3 := v_item_no3 + 1;
         IF witem_grp_cursor_rec.grouped_item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Grouped Item no. ' || to_char(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
                      ' should have an item title');
         END IF;
         IF postpar_par_type = 'P' THEN
            validate_wfireitm(witem_grp_cursor_rec.item_no);
         END IF;
         validate_witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,
                   witem_grp_cursor_rec.rec_flag,
                           witem_grp_cursor_rec.tsi_amt,       witem_grp_cursor_rec.prem_amt,
                           witem_grp_cursor_rec.ann_tsi_amt,   witem_grp_cursor_rec.ann_prem_amt,
                           postpar_line_cd);
     END LOOP;
     END IF;
     --**--gmi--**--
  ELSIF postpar_line_cd = postpar_motor_cd THEN
     IF v_exists = 'N' THEN --added by gmi 
     FOR witem_cursor_rec IN witem_cursor LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Item no. ' || to_char(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title');
         END IF;
         IF postpar_par_type = 'P' THEN
            validate_wmotcar_item(witem_cursor_rec.item_no);
         END IF;
         validate_witmperl(witem_cursor_rec.item_no, null,      
                   witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,      witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,  witem_cursor_rec.ann_prem_amt,
                           postpar_line_cd);
     END LOOP;
     --**--gmi 09/26/05--**--
     ELSIF v_exists = 'Y' THEN --added by gmi
     FOR witem_grp_cursor_rec in witem_grp_cursor LOOP
         v_item_no3 := v_item_no3 + 1;
         IF witem_grp_cursor_rec.grouped_item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Grouped Item no. ' || to_char(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
                      ' should have an item title');
         END IF;
         IF postpar_par_type = 'P' THEN
            validate_wmotcar_item(witem_grp_cursor_rec.item_no);
null;
         END IF;
         validate_witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,
                   witem_grp_cursor_rec.rec_flag,
                           witem_grp_cursor_rec.tsi_amt,       witem_grp_cursor_rec.prem_amt,
                           witem_grp_cursor_rec.ann_tsi_amt,   witem_grp_cursor_rec.ann_prem_amt,
                           postpar_line_cd);
     END LOOP;
     END IF;
     --**--gmi--**--
  ELSIF postpar_line_cd = postpar_engrng_cd THEN
     IF v_exists = 'N' THEN --added by gmi 
     FOR witem_cursor_rec IN witem_cursor LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Item no. ' || to_char(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title');
         END IF;
         IF (postpar_par_type = 'P') THEN
            IF postpar_subline_cd =  subline_bpv THEN
               validate_wengr_item(witem_cursor_rec.item_no);
            -- made into a comment by GRACE Mar. 30, 2001
            -- deductible information is no longer required for engineering items
            --ELSE
            --   validate_wengr_item2(witem_cursor_rec.item_no);
   null;
            END IF;
         END IF;
         validate_witmperl(witem_cursor_rec.item_no, null,     
                   witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,     witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt, witem_cursor_rec.ann_prem_amt,
                           postpar_line_cd); 
     END LOOP;
     --**--gmi 09/26/05--**--
     ELSIF v_exists = 'Y' THEN --added by gmi
     FOR witem_grp_cursor_rec in witem_grp_cursor LOOP
         v_item_no3 := v_item_no3 + 1;
         IF witem_grp_cursor_rec.grouped_item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Grouped Item no. ' || to_char(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
                      ' should have an item title');
         END IF;
         IF postpar_par_type = 'P' THEN
            validate_wengr_item(witem_grp_cursor_rec.item_no);
         END IF;
         validate_witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,
                   witem_grp_cursor_rec.rec_flag,
                           witem_grp_cursor_rec.tsi_amt,       witem_grp_cursor_rec.prem_amt,
                           witem_grp_cursor_rec.ann_tsi_amt,   witem_grp_cursor_rec.ann_prem_amt,
                           postpar_line_cd);
     END LOOP;
     END IF;
     --**--gmi--**--
  ELSIF postpar_line_cd = postpar_casualty_cd THEN
     IF v_exists = 'N' THEN --added by gmi 
     FOR witem_cursor_rec IN witem_cursor LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Item no. ' || to_char(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title');
         END IF;
         validate_witmperl(witem_cursor_rec.item_no, null,     
                    witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,     witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt, witem_cursor_rec.ann_prem_amt,
                           postpar_line_cd);
     END LOOP;
     --**--gmi 09/26/05--**--
     ELSIF v_exists = 'Y' THEN --added by gmi
     FOR witem_grp_cursor_rec in witem_grp_cursor LOOP
         v_item_no3 := v_item_no3 + 1;
         IF witem_grp_cursor_rec.grouped_item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Grouped Item no. ' || to_char(WITEM_grp_cursor_rec.grouped_ITEM_NO) ||
                      ' should have an item title');
         END IF;
         validate_witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,
                   witem_grp_cursor_rec.rec_flag,
                           witem_grp_cursor_rec.tsi_amt,       witem_grp_cursor_rec.prem_amt,
                           witem_grp_cursor_rec.ann_tsi_amt,   witem_grp_cursor_rec.ann_prem_amt,
                           postpar_line_cd);
     END LOOP;
     END IF;
     --**--gmi--**--
   ELSE
     IF v_exists = 'N' THEN --added by gmi
     FOR witem_cursor_rec in witem_cursor loop
         v_item_no1 := v_item_no1 + 1;
         postpar_dumm_num := postpar_dumm_num + 1;
         validate_witmperl(witem_cursor_rec.item_no,      null,
                   witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,      witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,  witem_cursor_rec.ann_prem_amt,
                           postpar_line_cd);
     END LOOP;
     --**--gmi 09/26/05 --**--
     ELSIF v_exists = 'Y' THEN --added by gmi
     FOR witem_grp_cursor_rec in witem_grp_cursor loop
         v_item_no3 := v_item_no3 + 1;
         IF postpar_dumm_num = 0 THEN
         postpar_dumm_num := postpar_dumm_num + 1;
         END IF;
         validate_witmperl(witem_grp_cursor_rec.item_no, witem_grp_cursor_rec.grouped_item_no,      
                   witem_grp_cursor_rec.rec_flag,
                           witem_grp_cursor_rec.tsi_amt,      witem_grp_cursor_rec.prem_amt,
                           witem_grp_cursor_rec.ann_tsi_amt,  witem_grp_cursor_rec.ann_prem_amt,
                           postpar_line_cd);
     END LOOP;
     END IF;
     --**--gmi--**--
   END IF;
  ELSE
   FOR A IN pack LOOP
      IF A.pack_line_cd IN (postpar_hull_cd,postpar_cargo_cd) THEN
        FOR B IN pack_item(A.pack_line_cd,A.pack_subline_cd) LOOP
         v_item_no1 := v_item_no1 + 1;
         IF    ((B.item_title IS NULL) AND (postpar_par_type = 'P')) THEN
            pre_post_error(v_par_id,'Item no. '||TO_CHAR(B.item_no)||
                      ' should have an item title');
         END IF;
         IF NOT (B.pack_line_cd  = postpar_hull_cd) AND
            (NOT (postpar_par_type = 'E' AND B.rec_flag IN ('C','D','A')) AND
                  B.pack_subline_cd !=  subline_mop) THEN
            validate_wcargo(B.item_no);
  ELSIF (B.pack_line_cd = postpar_hull_cd AND postpar_par_type = 'P') THEN
            validate_witem_ves(B.item_no);
         END IF;
         validate_witmperl(B.item_no, null,
                   B.rec_flag,
                           B.tsi_amt, B.prem_amt,
                           B.ann_tsi_amt, B.ann_prem_amt,
                           B.pack_line_cd);
        END LOOP;
      ELSIF A.pack_line_cd = postpar_fire_cd THEN
        FOR witem_cursor_rec in pack_item(A.pack_line_cd,A.pack_subline_cd) LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Item no. ' || to_char(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title');
         END IF;
         IF postpar_par_type = 'P' THEN
            validate_wfireitm(witem_cursor_rec.item_no);
null;
         END IF;
         validate_witmperl(witem_cursor_rec.item_no,       null,
                   witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,       witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,   witem_cursor_rec.ann_prem_amt,
                           witem_cursor_rec.pack_line_cd);
        END LOOP;
      ELSIF A.pack_line_cd = postpar_motor_cd THEN
        FOR witem_cursor_rec IN pack_item(A.pack_line_cd,A.pack_subline_cd) LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Item no. ' || to_char(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title');
         END IF;
         IF postpar_par_type = 'P' THEN
            validate_wmotcar_item(witem_cursor_rec.item_no);
         END IF;
         validate_witmperl(witem_cursor_rec.item_no,      null,
                   witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,      witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,  witem_cursor_rec.ann_prem_amt,
                           witem_cursor_rec.pack_line_cd);
        END LOOP;
      ELSIF A.pack_line_cd = postpar_engrng_cd THEN
        FOR witem_cursor_rec IN pack_item(A.pack_line_cd,A.pack_subline_cd) LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Item no. ' || to_char(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title');
         END IF;
         IF (postpar_par_type = 'P') THEN
            IF A.pack_subline_cd =  subline_bpv THEN
               validate_wengr_item(witem_cursor_rec.item_no);
            -- made into a comment by GRACE Mar. 30, 2001
            -- deductible information is no longer required for engineering items
            --ELSE
            --   validate_wengr_item2(witem_cursor_rec.item_no);
            END IF;
         END IF;
         validate_witmperl(witem_cursor_rec.item_no,     null,
                   witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,     witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt, witem_cursor_rec.ann_prem_amt,
                           witem_cursor_rec.pack_line_cd);
        END LOOP;
      ELSIF A.pack_line_cd = postpar_casualty_cd THEN
        FOR witem_cursor_rec IN pack_item(A.pack_line_cd,A.pack_subline_cd) LOOP
         v_item_no1 := v_item_no1 + 1;
         IF witem_cursor_rec.item_title IS NULL AND (postpar_par_type = 'P') THEN
            pre_post_error(v_par_id,'Item no. ' || to_char(WITEM_cursor_rec.ITEM_NO) ||
                      ' should have an item title');
         END IF;
         validate_witmperl(witem_cursor_rec.item_no,     null,
                   witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,     witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt, witem_cursor_rec.ann_prem_amt,
                           witem_cursor_rec.pack_line_cd);
        END LOOP;
      ELSE
        FOR witem_cursor_rec in pack_item(A.pack_line_cd,A.pack_subline_cd) loop
         v_item_no1 := v_item_no1 + 1;
         postpar_dumm_num := postpar_dumm_num + 1;
         validate_witmperl(witem_cursor_rec.item_no,      null,
                    witem_cursor_rec.rec_flag,
                           witem_cursor_rec.tsi_amt,      witem_cursor_rec.prem_amt,
                           witem_cursor_rec.ann_tsi_amt,  witem_cursor_rec.ann_prem_amt,
                           witem_cursor_rec.pack_line_cd);
        END LOOP;
      END IF;
   END LOOP;
  END IF;
  FOR A IN (SELECT  '1'
              FROM  giis_subline
             WHERE  line_cd  =  postpar_line_cd
               AND  line_cd  =  postpar_cargo_cd               
               AND  op_flag  =  'Y') LOOP
    IF v_item_no1 = 0 AND postpar_par_type = 'P' THEN
       pre_post_error(v_par_id,'PAR must have a complete Cargo Limits of Liabilities information including PERIL Info.');
    END IF;
    EXIT;
  END LOOP;
  IF postpar_pack != 'Y' THEN
    SELECT COUNT(DISTINCT item_no) INTO v_item_no2
      FROM gipi_witmperl 
     WHERE line_cd = postpar_line_cd and
           par_id  = postpar_par_id;
    FOR a IN (SELECT COUNT(DISTINCT grouped_item_no) grp_count-- INTO v_item_no4
           FROM gipi_witmperl_grouped
          WHERE line_cd = postpar_line_cd    
            AND par_id  = postpar_par_id
          GROUP BY item_no) LOOP   
  v_item_no4 := NVL(v_item_no4,0) + a.grp_count;
  END LOOP;            
--message(v_item_no1||' : '||v_item_no2);message(v_item_no1||' : '||v_item_no2);
--message(v_item_no3||' : '||v_item_no4);message(v_item_no3||' : '||v_item_no4);
   IF ((v_item_no1 != v_item_no2 AND v_item_no1 <> 0) OR (v_item_no3 != v_item_no4 AND v_item_no3 <> 0)) 
      AND postpar_par_type = 'P' THEN
    --null;
    --ELSE
     IF v_item_no3 != v_item_no4 THEN
      SELECT COUNT(item_no)
        INTO v_item_no1
        FROM gipi_witem
       WHERE par_id  = postpar_par_id;       
     END IF;
     IF v_item_no1 != v_item_no2 THEN
       pre_post_error(v_par_id,'No. of items in WITEM not equal to that in WITMPERL.'); 
      END IF; 
    END IF;
  END IF;
END IF;  
END;
PROCEDURE validate_witem_grouping IS
  CURSOR c IS SELECT distinct item_grp 
                FROM gipi_witem
               WHERE par_id = v_par_id;
  v_item_grp   gipi_witem.item_grp%TYPE;
  v_currency_cd  gipi_witem.currency_cd%TYPE;
BEGIN
IF skip_parid = 'N' THEN
  OPEN c;
  LOOP
    FETCH c INTO v_item_grp;
       IF c%NOTFOUND THEN
          EXIT;
       ELSE
          BEGIN 
            SELECT distinct currency_cd
              INTO v_currency_cd
              FROM gipi_witem
             WHERE item_grp = v_item_grp AND
                   par_id   = v_par_id;
          EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                 pre_post_error(v_par_id,'An item group should have a distinct currency code');
          END;
       END IF;
  END LOOP; 
  CLOSE c;
END IF;  
END;
/* BETH 10-02-98
**      validate if policy have the corresponding Commission Information
*/
PROCEDURE validate_wcomm_invoice IS
  x   NUMBER;
  x2            NUMBER;
  v_su_line_cd  giis_line.line_cd%TYPE;
BEGIN
IF skip_parid = 'N' THEN
IF postpar_iss_cd  != NVL(issue_ri,'&&') AND
   postpar_line_cd  != postpar_cargo_cd  AND
   postpar_subline_cd != subline_mop THEN
  IF postpar_par_type = 'E' THEN
     BEGIN
      FOR A IN ( SELECT 1
         FROM gipi_winvoice
        WHERE par_id = v_par_id) LOOP
         affecting  := 'A';
      END LOOP;
     END;
      IF affecting IS NULL THEN
            affecting := 'N';
      END IF;
  END IF;
  IF (postpar_par_type = 'P') 
     OR (NVL(affecting,'N') = 'A') THEN
--BETH 12/11/98 validate if Invoice Commission had been entered for all item grp.
   FOR su IN (
     SELECT param_value_v 
       FROM giis_parameters
      WHERE param_name = 'LINE_CODE_SU')
   LOOP
     v_su_line_cd := su.param_value_v;
   END LOOP;
   FOR COMM_CUR IN (SELECT item_grp
                      FROM gipi_winvoice
                     WHERE par_id = postpar_par_id) LOOP
       SELECT count(*)
         INTO x
         FROM gipi_wcomm_invoices
        WHERE par_id  = postpar_par_id
          AND item_grp = comm_cur.item_grp;
       IF postpar_line_cd != v_su_line_cd THEN
         IF X >= 1 THEN
            SELECT count(*)
            INTO x2
            FROM gipi_wcomm_inv_perils
           WHERE par_id  = postpar_par_id
             AND item_grp = comm_cur.item_grp;
            IF X2 < 1 THEN
              pre_post_error(v_par_id,'Commission Peril Information for Item Group '||to_char(comm_cur.item_grp)||' is needed.');
            END IF;        
         ELSE 
           pre_post_error(v_par_id,'Commission Information for Item Group '||to_char(comm_cur.item_grp)||' is needed.');
         END IF;
       END IF;
   END LOOP;
   END IF;
ELSE
NULL;
END IF;
END IF;
  END;
PROCEDURE validate_invoice_info2 IS
  CURSOR c IS SELECT payt_terms,tax_amt
                FROM gipi_winvoice
               WHERE gipi_winvoice.par_id = postpar_par_id;
BEGIN
IF skip_parid = 'N' THEN
  FOR c_rec IN c LOOP
      IF c_rec.tax_amt > 0 THEN
         IF c_rec.payt_terms IS NULL THEN
            pre_post_error(v_par_id, 'Invoice Payment Terms must be entered first before 
                       posting the PAR.');
         END IF;
      END IF;
  END LOOP;
END IF;  
END;
PROCEDURE validate_invoice_info IS
  x   NUMBER;
  v_pay_flag VARCHAR2(1);
  v_pay_tag giis_payterm.no_of_payt%TYPE;
  v_prem1    NUMBER(12,2) := 0;
  v_prem2    NUMBER(12,2) := 0;
  v_prem3   NUMBER(12,2) := 0; --gmi 09/26/05
  v_su_line     giis_line.line_cd%TYPE; 
  CURSOR winvoice_cursor IS SELECT property,prem_amt,payt_terms
                              FROM gipi_winvoice
                             WHERE par_id = postpar_par_id;
BEGIN
IF skip_parid = 'N' THEN
  v_pay_flag := 'A';
  x := 0;
  FOR su IN (
    SELECT param_value_v 
      FROM giis_parameters
     WHERE param_name = 'LINE_CODE_SU')
  LOOP
    v_su_line := su.param_value_v;
  END LOOP;
  FOR winvoice_cursor_rec IN winvoice_cursor LOOP
      v_prem1 := v_prem1 + NVL(winvoice_cursor_rec.prem_amt,0);
    IF postpar_line_cd = v_su_line THEN
      IF winvoice_cursor_rec.prem_amt IS NOT NULL THEN
         x := x + 1;
      END IF;
    ELSIF winvoice_cursor_rec.prem_amt IS NOT NULL AND
       (winvoice_cursor_rec.property IS NOT NULL) THEN
         BEGIN
           SELECT no_of_payt INTO v_pay_tag
             FROM giis_payterm
            WHERE payt_terms = winvoice_cursor_rec.payt_terms;
         EXCEPTION
           WHEN TOO_MANY_ROWS THEN
                NULL;
           WHEN NO_DATA_FOUND THEN
                v_pay_flag := 'X';
                EXIT;
         END;
         x := x + 1;
    END IF; 
  END LOOP;
  IF v_pay_flag = 'X' THEN
     pre_post_error(v_par_id,'Invalid or no payment term in invoice information.');     
     recompute_items;
  END IF;
  IF x = 0 AND (postpar_par_type = 'P' AND nvl(open_flag,'N') <> 'Y') THEN
     pre_post_error(v_par_id,'Invoice information not yet entered.');
     recompute_items;
  END IF;
  SELECT SUM(NVL(prem_amt,0)) INTO v_prem2
    FROM gipi_witem
   WHERE par_id = postpar_par_id;
  --**--gmi 09/26/05 --**-- 
  /*SELECT SUM(NVL(ann_prem_amt,0)) INTO v_prem3
    FROM gipi_wgrouped_items
   WHERE par_id = postpar_par_id;*/
  --**-- gmi --**--   
  --IF ((v_prem1 <> v_prem2 AND v_prem2 <> 0) OR v_prem1 <> v_prem3 THEN --added condition gmi
   --NULL;
  --ELSE 
   --**--modified by gmi prin... 06.02.06--**--
  IF v_prem1 <> v_prem2 THEN
     pre_post_error(v_par_id,'Internal computation made an error, will create another bill.');
     recompute_items;
  END IF;
  -- to enforce payment term entry for PAR's with invoice
  FOR A IN (SELECT   '1'
              FROM   giis_subline
             WHERE   line_cd    =  postpar_line_cd
               AND   subline_cd =  postpar_subline_cd 
               AND   op_flag    = 'Y') LOOP
    validate_INVOICE_info2 ;
    EXIT;
  END LOOP;
  FOR A IN (SELECT '1'
              FROM gipi_witmperl
             WHERE par_id = postpar_par_id)
  LOOP                        
    VALIDATE_WCOMM_INVOICE;
    EXIT;
  END LOOP;
END IF;   
END;
PROCEDURE validate_prelimds IS
          v_prelim_tsi giuw_pol_dist.tsi_amt%TYPE;
          v_pol_tsi gipi_wpolbas.tsi_amt%TYPE;
          v_count NUMBER;
BEGIN
IF skip_parid = 'N' THEN
  /*BETH 031099 this was replaced with a select statement which sum tsi 
  **            of all items instead of getting it from polbasic  
  SELECT NVL(tsi_amt,0)
    INTO v_pol_tsi
    FROM gipi_wpolbas
   WHERE par_id = postpar_par_id;
  */
/*  FOR A1 IN(SELECT (NVL(tsi_amt,0)*NVL(currency_rt,0)) tsi
              FROM gipi_witem
             WHERE par_id = postpar_par_id)LOOP
         v_pol_tsi := NVL(v_pol_tsi,0) + A1.tsi;
  END LOOP; */
  SELECT SUM((NVL(tsi_amt,0)*NVL(currency_rt,0))) tsi
    INTO v_pol_tsi
    FROM gipi_witem
   WHERE par_id = postpar_par_id;
  SELECT SUM(NVL(tsi_amt,0))
    INTO v_prelim_tsi
    FROM giuw_pol_dist
   WHERE par_id = postpar_par_id;
  IF v_prelim_tsi IS NOT NULL THEN
     IF v_pol_tsi != v_prelim_tsi THEN
        pre_post_error(v_par_id,'TSI amount does not match the TSI set by Underwriting.');
        recompute_items;
     END IF; 
  ELSE
     IF postpar_par_type = 'E' AND
        postpar_line_cd  = postpar_hull_cd AND
        postpar_subline_cd IN (postpar_mrn_cd,postpar_cmi_cd) THEN
        BEGIN
          v_count:=0;
          SELECT COUNT(*)
            INTO v_count
            FROM gipi_witmperl
           WHERE par_id  =postpar_par_id;
          IF v_count!=0 THEN
             pre_post_error(v_par_id,'Underwriting must first set a preliminary distribution.');
          END IF;
        EXCEPTION 
          WHEN NO_DATA_FOUND THEN NULL;
        END;
     END IF;
  END IF;
END IF;  
END;
PROCEDURE validate_addl_items IS
BEGIN
IF skip_parid = 'N' THEN
  IF postpar_pack = 'Y' THEN
    FOR A IN (SELECT  pack_line_cd line_cd,pack_subline_cd subline_cd
                FROM  gipi_wpack_line_subline
               WHERE  par_id  =  postpar_par_id) LOOP
     IF A.line_cd    = postpar_engrng_cd THEN
        NULL;
     ELSIF A.line_cd    = postpar_casualty_cd AND
        A.subline_cd = subline_bbb  OR 
        A.subline_cd = subline_ddd  OR
        A.subline_cd = subline_mrsb OR
        A.subline_cd = subline_mspr THEN
        NULL;
     ELSIF A.line_cd    = postpar_accident_cd THEN
        NULL;
     ELSIF A.line_cd    = postpar_surety_cd THEN
        validate_wbond_basic;
   null;
     ELSIF A.line_cd IN (postpar_hull_cd,postpar_cargo_cd) THEN
        IF A.line_cd = postpar_cargo_cd THEN
           IF A.line_cd = postpar_cargo_cd AND open_policy_sw = 'Y' THEN
              validate_wopen_policy;
           validate_wves_air;
           END IF;
           IF A.line_cd = postpar_cargo_cd AND open_flag = 'Y' THEN
              validate_wopen_liab;
    null;
           END IF;
        ELSIF A.line_cd = postpar_hull_cd THEN
           NULL;       
        END IF;
     END IF;
    END LOOP;
  ELSE
     IF postpar_line_cd       = postpar_fire_cd THEN
    null;
     ELSIF postpar_line_cd    = postpar_engrng_cd THEN
        NULL;
     ELSIF postpar_line_cd    = postpar_casualty_cd AND
        postpar_subline_cd = subline_bbb  OR 
        postpar_subline_cd = subline_ddd  OR
        postpar_subline_cd = subline_mrsb OR
        postpar_subline_cd = subline_mspr THEN
        NULL;
     ELSIF postpar_line_cd    = postpar_accident_cd THEN
        NULL;
     ELSIF postpar_line_cd    = postpar_surety_cd THEN
        validate_wbond_basic;
     ELSIF postpar_line_cd IN (postpar_hull_cd,postpar_cargo_cd) THEN
        IF postpar_line_cd = postpar_cargo_cd THEN
           IF postpar_line_cd = postpar_cargo_cd AND open_policy_sw = 'Y' THEN
              validate_wopen_policy;
           validate_wves_air;
           END IF;
           IF postpar_line_cd = postpar_cargo_cd AND open_flag = 'Y' THEN
              validate_wopen_liab;     
           END IF;
        ELSIF postpar_line_cd = postpar_hull_cd THEN
           NULL;       
        END IF;
     END IF;
  END IF;
END IF;  
END;
PROCEDURE validate_replcment IS
BEGIN
IF skip_parid = 'N' THEN
  SELECT rec_flag
    INTO postpar_dumm_var
    FROM gipi_wpolnrep 
   WHERE par_id = postpar_par_id AND
         ren_rep_sw = '2';
END IF;     
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       pre_post_error(v_par_id,'PAR should have at least one policy being replaced.');
  WHEN TOO_MANY_ROWS THEN
       NULL;  
END;
PROCEDURE validate_renewal IS
BEGIN
IF skip_parid = 'N' THEN
  SELECT par_id
    INTO postpar_dumm_var
    FROM gipi_wpolnrep
   WHERE par_id     = postpar_par_id AND
         ren_rep_sw = '1';
END IF;     
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       pre_post_error(v_par_id,'PAR should have at least one policy being renewed.');
  WHEN TOO_MANY_ROWS THEN
       NULL;      
END;
PROCEDURE validate_wendttext IS
BEGIN
IF skip_parid = 'N' THEN
  SELECT endt_text01,endt_text02,endt_text03,endt_text04,endt_text05,endt_text06,
         endt_text07,endt_text08,endt_text09,endt_text10,endt_text11,endt_text12,
         endt_text13,endt_text14,endt_text15,endt_text16,endt_text17
    INTO postpar_ws_long_var1,postpar_ws_long_var2,postpar_ws_long_var3,
         postpar_ws_long_var4,postpar_ws_long_var5,postpar_ws_long_var6,
         postpar_ws_long_var7,postpar_ws_long_var8,postpar_ws_long_var9,
         postpar_ws_long_var10,postpar_ws_long_var11,postpar_ws_long_var12,
         postpar_ws_long_var13,postpar_ws_long_var14,postpar_ws_long_var15,
         postpar_ws_long_var16,postpar_ws_long_var17
    FROM gipi_wendttext
   WHERE par_id = postpar_par_id;
END IF;   
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       pre_post_error(v_par_id, 'PAR should have an endorsement text.');
END;
--BETH 03/15/2001
--     If the PAR being posted is tagged as auto-renewal this procedure will check
--    for the existance of records in the following distribution tables:
--     GIUW_POLICYDS 
--     GIUW_ITEMDS  
--     GIUW_ITEMPERILDS  
--     GIUW_PERILDS   
--     if missing records are detected posting process would not be allowed
--     and a message that will prompt the user to recreate records in  Distribution programs
--     would be displayed. 
PROCEDURE VALIDATE_EXISTING_FINAL_DIST(p_dist_no giuw_pol_dist.dist_no%TYPE) IS
  v_hdr_sw   VARCHAR2(1); --field that used as a switch to determine if records exist in header table
  v_dtl_sw   VARCHAR2(1); --field that used as a switch to determine if records exist in detail table
BEGIN
IF skip_parid = 'N' THEN
 v_hdr_sw := 'N';
  --check if there are records in giuw_policyds
  FOR A IN (SELECT dist_no, dist_seq_no
              FROM giuw_policyds
             WHERE dist_no = p_dist_no)
  LOOP  
   v_hdr_sw := 'Y';
   v_dtl_sw := 'N';
   --check if there are records corresponding records in giuw_policyds_dtl  
   -- for every record in giuw_policyds 
   FOR B IN (SELECT '1'
               FROM giuw_policyds_dtl
              WHERE dist_no = a.dist_no
                AND dist_seq_no = a.dist_seq_no)
   LOOP            
    v_dtl_sw := 'Y';
    EXIT;
   END LOOP;  
   IF v_dtl_sw = 'N' THEN
      pre_post_error(v_par_id,'There was an error encountered in distribution records, '||
                'to correct this error please recreate using ' ||
                'any Preliminary Distribution program.');
   END IF;
  END LOOP;
  IF v_hdr_sw = 'N' THEN
     pre_post_error(v_par_id,'There was an error encountered in distribution records, '||
              'to correct this error please recreate using ' ||
              'any Preliminary Distribution program.');
  END IF;
  v_hdr_sw := 'N';
  --check if there are records in giuw_itemds
  FOR A IN (SELECT dist_no, dist_seq_no, item_no
              FROM giuw_itemds
             WHERE dist_no = p_dist_no)
  LOOP  
   v_hdr_sw := 'Y';
   v_dtl_sw := 'N';
   --check if there are records corresponding records in giuw_itemds_dtl  
   -- for every record in giuw_itemds 
   FOR B IN (SELECT '1'
               FROM giuw_itemds_dtl
              WHERE dist_no = a.dist_no
                AND dist_seq_no = a.dist_seq_no
                AND item_no = a.item_no)
   LOOP            
    v_dtl_sw := 'Y';
    EXIT;
   END LOOP;  
   IF v_dtl_sw = 'N' THEN
      pre_post_error(v_par_id,'There was an error encountered in distribution records, '||
                'to correct this error please recreate using ' ||
                'any Preliminary Distribution program.');
   END IF;
  END LOOP;
  IF v_hdr_sw = 'N' THEN
     pre_post_error(v_par_id,'There was an error encountered in distribution records, '||
              'to correct this error please recreate using ' ||
              'any Preliminary Distribution program.');
  END IF;
  v_hdr_sw := 'N';
  --check if there are records in giuw_itemperilds
  FOR A IN (SELECT t1.dist_no,  t1.dist_seq_no, t1.item_no, t1.peril_cd
              FROM giuw_itemperilds t1
             WHERE t1.dist_no  = p_dist_no)
  LOOP  
   v_hdr_sw := 'Y';
   v_dtl_sw := 'N';
   --check if there are records corresponding records in giuw_itemperilds_dtl  
   -- for every record in giuw_itemperilds 
   FOR B IN (SELECT '1'
               FROM giuw_itemperilds_dtl
              WHERE dist_no = a.dist_no
                AND dist_seq_no = a.dist_seq_no
                AND item_no = a.item_no
                AND peril_cd = a.peril_cd)
   LOOP            
    v_dtl_sw := 'Y';
    EXIT;
   END LOOP;  
   IF v_dtl_sw = 'N' THEN
      pre_post_error(v_par_id,'There was an error encountered in distribution records, '||
                'to correct this error please recreate using ' ||
                'any Preliminary Distribution program.');
   END IF;
  END LOOP;
  IF v_hdr_sw = 'N' THEN
     pre_post_error(v_par_id,'There was an error encountered in distribution records, '||
              'to correct this error please recreate using ' ||
              'any Preliminary Distribution program.');
  END IF;
  v_hdr_sw := 'N';
  --check if there are records in giuw_perilds
  FOR A IN (SELECT t1.dist_no,  t1.dist_seq_no, t1.peril_cd
              FROM giuw_perilds t1
             WHERE t1.dist_no  = p_dist_no)
  LOOP  
   v_hdr_sw := 'Y';
   v_dtl_sw := 'N';
   --check if there are records corresponding records in giuw_perilds_dtl  
   -- for every record in giuw_perilds 
   FOR B IN (SELECT '1'
               FROM giuw_perilds_dtl
              WHERE dist_no = a.dist_no
                AND dist_seq_no = a.dist_seq_no
                AND peril_cd = a.peril_cd)
   LOOP            
    v_dtl_sw := 'Y';
    EXIT;
   END LOOP;  
   IF v_dtl_sw = 'N' THEN
      pre_post_error(v_par_id,'There was an error encountered in distribution records, '||
                'to correct this error please recreate using ' ||
                'any Preliminary Distribution program.');
   END IF;
  END LOOP;
  IF v_hdr_sw = 'N' THEN
     pre_post_error(v_par_id,'There was an error encountered in distribution records, '||
              'to correct this error please recreate using ' ||
              'any Preliminary Distribution program.');
  END IF;
END IF;
END;
--beth 03/13/2001 this procedure checks discrepancy of amounts between
--     peril, item and polbasic tables
PROCEDURE VALIDATE_TABLE_AMTS IS
BEGIN
IF skip_parid = 'N' THEN
  --check for discrepancy between peril and item table premium amount
  FOR A IN (SELECT round(SUM(NVL(b.prem_amt,0)),2) peril_prem, 
           round(NVL(a.prem_amt,0),2) item_prem, a.item_no
              FROM gipi_witem a, gipi_witmperl b
             WHERE a.par_id = postpar_par_id
               AND a.par_id = b.par_id 
               AND a.item_no = b.item_no
           GROUP BY a.prem_amt, a.item_no)
  LOOP
   IF a.peril_prem <> a.item_prem THEN
     pre_post_error(v_par_id,'There is a discrepancy between the premiums amounts in item and '||
               'peril table for item no. '|| to_char(a.item_no)||'. To correct this error '||
               'please recreate item and it''s corresponding peril(s).');
   END IF;
  END LOOP;  
  --check for discrepancy between peril and item table TSI amount
  FOR A IN (SELECT round(SUM(NVL(b.tsi_amt,0)),2) peril_tsi, 
                   round(NVL(a.tsi_amt,0),2) item_tsi, a.item_no
              FROM gipi_witem a, gipi_witmperl b, giis_peril c
             WHERE a.par_id = postpar_par_id
               AND a.par_id = b.par_id 
               AND a.item_no = b.item_no               
               AND b.line_cd = c.line_cd
               AND b.peril_cd = c.peril_cd
               AND c.peril_type = 'B'
           GROUP BY a.tsi_amt, a.item_no)
  LOOP
   IF a.peril_tsi <> a.item_tsi THEN
     pre_post_error(v_par_id,'There is a discrepancy between the TSI amounts in item and '||
               'peril table for item no. '|| to_char(a.item_no)||'. To correct this error '||
               'please recreate item and it''s corresponding peril(s).');
   END IF;
  END LOOP;      
  --check for discrepancy between polbasic and item table TSI and premium amounts
  FOR A IN (SELECT round(SUM(NVL(b.tsi_amt,0)* NVL(b.currency_rt,1)),2) item_tsi,
                   round(SUM(NVL(b.prem_amt,0)* NVL(b.currency_rt,1)),2) item_prem,
                   NVL(a.tsi_amt,0) pol_tsi, NVL(a.prem_amt,0) pol_prem
              FROM gipi_wpolbas a, gipi_witem b
             WHERE a.par_id = postpar_par_id
               AND a.par_id = b.par_id                
           GROUP BY a.tsi_amt, a.prem_amt)
  LOOP
   IF a.pol_tsi <> a.item_tsi THEN
     pre_post_error(v_par_id,'There is a discrepancy between the TSI amounts in item and '||
               'polbasic table . To correct this error please recreate item(s) and it''s corresponding peril(s).');
   END IF;
   IF a.pol_prem <> a.item_prem THEN
     pre_post_error(v_par_id,'There is a discrepancy between the premium amounts in item and '||
               'polbasic table . To correct this error please recreate item(s) and it''s corresponding peril(s).');
   END IF;
  END LOOP;
END IF;                
END;
PROCEDURE validate_in_wpolbas IS
BEGIN  
IF skip_parid = 'N' THEN
  SELECT line_cd
    INTO postpar_dumm_var
    FROM gipi_wpolbas
   WHERE par_id = postpar_par_id;
--beth 121599 disallow POSTING if booking date is null
 FOR CHK_BOOKING IN
     ( SELECT booking_mth, booking_year
         FROM gipi_wpolbas
        WHERE par_id = postpar_par_id
     ) LOOP
     IF chk_booking.booking_mth IS NULL AND chk_booking.booking_year IS NULL THEN
       pre_post_error(v_par_id,'Unable to post PAR, please enter booking date in Basic Information screen.');
     ELSIF chk_booking.booking_mth IS NULL THEN
       pre_post_error(v_par_id,'Unable to post PAR, please enter booking month in Basic Information screen.');
      ELSIF chk_booking.booking_year IS NULL THEN
       pre_post_error(v_par_id,'Unable to post PAR, please enter booking year in Basic Information screen.');
      END IF;
  END LOOP; 
END IF;        
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       pre_post_error(v_par_id, 'INFORMATION in WPOLBAS TABLE NOT YET ENTERED.');
  WHEN TOO_MANY_ROWS THEN
       NULL;
END;
PROCEDURE validate_in_PARLIST IS
BEGIN
IF skip_parid = 'N' THEN  
  SELECT line_cd
    INTO postpar_dumm_var
    FROM gipi_parlist
   WHERE line_cd    = postpar_line_cd AND
         par_yy     = postpar_par_yy AND
         par_seq_no = postpar_par_seq_no;
END IF;     
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       pre_post_error(v_par_id, 'PAR no. does not exist in the PAR files.');
  WHEN TOO_MANY_ROWS THEN
       NULL;  
END;
PROCEDURE validate_par IS
BEGIN
IF skip_parid = 'N' THEN
  validate_in_parlist;
  validate_in_wpolbas;
  validate_table_amts; --BETH validate if amounts in polbasic, item and item peril tallies
  --beth 04152001 if auto_dist = 'Y' validate distribution tables records
  FOR A IN (SELECT dist_no
              FROM giuw_pol_dist
             WHERE par_id = postpar_par_id
               AND auto_dist = 'Y' )             
  LOOP             
   validate_existing_final_dist(a.dist_no);
  END LOOP; 
  IF postpar_par_type = 'E' THEN
     validate_wendttext;
  END IF;
  IF postpar_pol_stat = '2' THEN
      validate_renewal;   
  ELSIF postpar_pol_stat = '3' THEN
      validate_replcment;  
  END IF;
  IF postpar_par_type = 'P' THEN
     validate_addl_items;
  END IF;
  IF NVL(open_flag,'N') <> 'Y' THEN
     validate_witem;
  END IF;
  validate_witem_grouping;
  validate_invoice_info;
  validate_prelimds;
END IF;  
END;
PROCEDURE copy_pol_wpolbas IS
  loc_incept_dt         gipi_polbasic.incept_date%TYPE;
  loc_expiry_dt          gipi_polbasic.expiry_date%TYPE;
  loc_expiry_tag          gipi_polbasic.expiry_tag%TYPE;
  loc_incept_tag          gipi_polbasic.incept_tag%TYPE;
  loc_eff_dt            gipi_polbasic.eff_date%TYPE;
  loc_issue_dt          gipi_polbasic.issue_date%TYPE;
  loc_pol_flag          gipi_polbasic.pol_flag%TYPE;
  loc_assd_no            gipi_polbasic.assd_no%TYPE;
  loc_designation        gipi_polbasic.designation%TYPE;
  loc_pol_addr1          gipi_polbasic.address1%TYPE;
  loc_pol_addr2          gipi_polbasic.address2%TYPE;
  loc_pol_addr3          gipi_polbasic.address3%TYPE;
  loc_mortg_name        gipi_polbasic.mortg_name%TYPE;
  loc_tsi_amt            gipi_polbasic.tsi_amt%TYPE;
  loc_prem_amt          gipi_polbasic.prem_amt%TYPE;
  loc_ann_tsi            gipi_polbasic.ann_tsi_amt%TYPE;
  loc_ann_prem          gipi_polbasic.ann_prem_amt%TYPE;
  loc_invoices          gipi_polbasic.invoice_sw%TYPE;    
  loc_user_id            gipi_polbasic.user_id%TYPE;
  loc_pool_pol_no        gipi_polbasic.pool_pol_no%TYPE;
  loc_foreign_acc_tag    gipi_polbasic.foreign_acc_sw%TYPE;
  loc_policy_id          gipi_polbasic.policy_id%TYPE;      
  loc_issue_yy          gipi_polbasic.issue_yy%TYPE;
  loc_renew_no          gipi_polbasic.renew_no%TYPE;
  loc_subline_cd        gipi_polbasic.subline_cd%TYPE;
  loc_auto_renew_flag     gipi_polbasic.auto_renew_flag%TYPE;
  loc_no_of_items        gipi_polbasic.no_of_items%TYPE;
  loc_endt_yy            gipi_polbasic.endt_yy%TYPE := 0;
  loc_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE;
  loc_endt_expiry_date   gipi_polbasic.endt_expiry_date%TYPE;
  loc_subline_type_cd     gipi_polbasic.subline_type_cd%TYPE;
  loc_prorate_flag       gipi_polbasic.prorate_flag%TYPE;
  loc_short_rt_percent   gipi_polbasic.short_rt_percent%TYPE;
  loc_prov_prem_tag       gipi_polbasic.prov_prem_tag%TYPE;
  loc_type_cd             gipi_polbasic.type_cd%TYPE;
  loc_acct_of_cd          gipi_polbasic.acct_of_cd%TYPE;
  loc_pack_pol_flag       gipi_polbasic.pack_pol_flag%TYPE;
  loc_prem_warr_tag       gipi_polbasic.prem_warr_tag%TYPE;  --BETH
  loc_ref_pol_no          gipi_polbasic.ref_pol_no%TYPE;     --010799
  loc_reg_policy_sw       gipi_polbasic.reg_policy_sw%TYPE;   --LOTH
  loc_co_insurance_sw     gipi_polbasic.co_insurance_sw%TYPE; --012799
  loc_discount_sw         gipi_polbasic.discount_sw%TYPE;     --020499
  loc_surcharge_sw        gipi_polbasic.surcharge_sw%TYPE;     --RBD (08162002)
  loc_ref_open_pol_no     gipi_polbasic.ref_open_pol_no%TYPE; --020499
  loc_booking_mth         gipi_polbasic.booking_mth%TYPE;     --022799
  loc_booking_year        gipi_polbasic.booking_mth%TYPE;     --040899
  loc_fleet_print_tag     gipi_polbasic.fleet_print_tag%TYPE; --042099
  loc_endt_expiry_tag     gipi_polbasic.endt_expiry_tag%TYPE;  --BETH
  loc_manual_renew_no     gipi_polbasic.manual_renew_no%TYPE;  --BETH
  loc_with_tariff_sw      gipi_polbasic.with_tariff_sw%TYPE;   --BETH 120199
  --BETH  01-27-2000  
  loc_comp_sw             gipi_polbasic.comp_sw%TYPE;
  loc_orig_policy_id      gipi_polbasic.orig_policy_id%TYPE;
  loc_prov_prem_pct       gipi_polbasic.prov_prem_pct%TYPE;
  -- jpc 08/02/2001
  loc_region_cd         gipi_polbasic.region_cd%TYPE;
  loc_industry_cd        gipi_polbasic.industry_cd%TYPE;
  --BETH 06-21-2000
  loc_place_cd            gipi_polbasic.place_cd%TYPE;
  --BETH 04-16-2001
  loc_actual_renew_no     gipi_polbasic.actual_renew_no%TYPE;
  loc_count_id            gipi_polbasic.policy_id%TYPE; --store policy_id of renewed policy
  loc_exit_sw             VARCHAR2(1); --switch that will be use in counting actual_renew_n
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
  --added by iris 07.11.2002
  --for the added column acct_of_cd_sw
  loc_acct_of_cd_sw       gipi_polbasic.acct_of_cd_sw%TYPE;
  --added by grace 01.06.2003
  --for the added column cred_branch
  loc_cred_branch         gipi_polbasic.cred_branch%TYPE;
  loc_old_assd_no         gipi_polbasic.old_assd_no%TYPE;
  loc_old_address1        gipi_polbasic.old_address1%TYPE;
  loc_old_address2        gipi_polbasic.old_address2%TYPE;  
  loc_old_address3        gipi_polbasic.old_address3%TYPE;        
  loc_cancel_date     gipi_polbasic.cancel_date%TYPE;
  loc_label_tag           gipi_polbasic.label_tag%TYPE;
  loc_survey_agent_cd     gipi_polbasic.survey_agent_cd%TYPE;
  loc_settling_agent_cd   gipi_polbasic.settling_agent_cd%TYPE;
  --added by iris bordey 09.30.2003
  --for added column risk_tag
  loc_risk_tag            gipi_polbasic.risk_tag%TYPE;
BEGIN
IF skip_parid = 'N' THEN
  BEGIN
    SELECT polbasic_policy_id_s.NEXTVAL
      INTO postpar_policy_id 
      FROM DUAL;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         pre_post_error(v_par_id, 'Cannot generate new POLICY ID.');
  END;
  BEGIN
    SELECT COUNT(*)
      INTO loc_no_of_items
      FROM gipi_witem
     WHERE par_id = postpar_par_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         NULL;
  END;
  SELECT issue_yy,incept_date,expiry_date,NVL(eff_date,incept_date),NVL(issue_date,TRUNC(SYSDATE)),pol_flag,
         assd_no,designation,address1,address2,address3,mortg_name,tsi_amt,prem_amt,ann_tsi_amt,
         ann_prem_amt,invoice_sw,user_id,pool_pol_no,foreign_acc_sw,renew_no,subline_cd,
         auto_renew_flag,pol_seq_no,
         endt_expiry_date,subline_type_cd,prorate_flag,short_rt_percent,
         prov_prem_tag,type_cd,acct_of_cd,pack_pol_flag, expiry_tag,
  --BETH 010799 add transfering of new fields prem_warr_tag and ref_pol_no
         prem_warr_tag, ref_pol_no, reg_policy_sw, co_insurance_sw,discount_sw,
         ref_open_pol_no, incept_tag, booking_mth, booking_year,fleet_print_tag,
         endt_expiry_tag, manual_renew_no, with_tariff_sw, --BETH
         comp_sw, orig_policy_id, prov_prem_pct, place_cd, region_cd, industry_cd,
         acct_of_cd_sw, surcharge_sw, cred_branch, old_assd_no, 
         old_address1, old_address2, old_address3, risk_tag, label_tag, 
         survey_agent_cd, settling_agent_cd
    INTO loc_issue_yy,loc_incept_dt,loc_expiry_dt,
         loc_eff_dt,loc_issue_dt,loc_pol_flag,loc_assd_no,
         loc_designation,loc_pol_addr1,loc_pol_addr2,loc_pol_addr3, 
         loc_mortg_name,loc_tsi_amt,loc_prem_amt,
         loc_ann_tsi,loc_ann_prem,loc_invoices,
         loc_user_id,loc_pool_pol_no,loc_foreign_acc_tag,loc_renew_no,loc_subline_cd,
         loc_auto_renew_flag,loc_pol_seq_no,
         loc_endt_expiry_date,loc_subline_type_cd,loc_prorate_flag,loc_short_rt_percent,
         loc_prov_prem_tag,loc_type_cd,loc_acct_of_cd,loc_pack_pol_flag, loc_expiry_tag,
         loc_prem_warr_tag, loc_ref_pol_no, loc_reg_policy_sw, loc_co_insurance_sw, 
         loc_discount_sw, loc_ref_open_pol_no, loc_incept_tag, loc_booking_mth,
         loc_booking_year, loc_fleet_print_tag, loc_endt_expiry_tag, loc_manual_renew_no,
         loc_with_tariff_sw, loc_comp_sw, loc_orig_policy_id, loc_prov_prem_pct, loc_place_cd,
         loc_region_cd, loc_industry_cd, loc_acct_of_cd_sw, loc_surcharge_sw, loc_cred_branch, 
         loc_old_assd_no, loc_old_address1, loc_old_address2, loc_old_address3, 
         loc_risk_tag, loc_label_tag, loc_survey_agent_cd, loc_settling_agent_cd
    FROM gipi_wpolbas
   WHERE par_id  = postpar_par_id;
  -- for endorsement year value --
  IF postpar_par_type = 'E' THEN
     --loc_endt_yy    := TO_NUMBER(TO_CHAR(SYSDATE,'YY'));
     loc_endt_yy    := loc_issue_yy;
     --iris bordey (09.20.2002)
     --parameter.change_stat determines if user chooses to continue
     --posting after prompting that status of PAR will change to cancellation
     --endt since effective tsi = 0
     IF parameter_change_stat = 'Y' THEN 
        loc_pol_flag := 4;
        parameter_change_stat := 'N';
     END IF;
     --BETH 041599 update pol_flag of the policy and all previous endorsement to 4 
     --            and save the current pol_flag to old_pol_flag
     IF loc_pol_flag = '4' THEN
        UPDATE gipi_polbasic
           SET old_pol_flag =  pol_flag,
               pol_flag     =  '4'  ,
               eis_flag     =  'N'           
         WHERE line_cd     = postpar_line_cd
           AND subline_cd  = loc_subline_cd
           AND iss_cd      = postpar_iss_cd
           AND issue_yy    = loc_issue_yy
           AND pol_seq_no  = loc_pol_seq_no
           AND renew_no    = loc_renew_no
           AND pol_flag  IN ('1','2','3');
        loc_cancel_date := SYSDATE;
     END IF;    
  --BETH 102299 for renewal/replacement policies that will use same policy no 
  --            extract the policy no of policy to be renew
  --BETH 102299 for renewal/replacement policies that will use same policy no 
  --            extract the policy no of policy to be renew
  --BETH 02062001 for renewal or replacement renew_no must accumulate
  --       regardless if it will use same policy or not
  ELSE
     FOR RENEW IN
         ( SELECT b.old_policy_id id, NVL(a.same_polno_sw,'N') same_sw,
                  a.pol_flag --beth 04162001 to be use in determining value of actual_renew_no   
             FROM gipi_wpolbas a, gipi_wpolnrep b
            WHERE a.par_id = b.par_id
              and a.par_id = postpar_par_id
              AND a.pol_flag in ('2','3'))
              --BETH 02062001 comment out validation for same policy no 
              --     so that renew no. will accumulate regardless if it will
              --     use same policy no or not 
              --AND NVL(a.same_polno_sw,'N') = 'Y'   
     LOOP 
       FOR OLD_DATA IN
           ( SELECT line_cd, subline_cd, iss_cd,issue_yy, pol_seq_no, renew_no, actual_renew_no,
                    manual_renew_no
               FROM gipi_polbasic
              WHERE policy_id  = renew.id)
       LOOP
         -- for policy that will use same no. copy pol_seq_no and issue_yy 
         -- from the old policy  
         IF renew.same_sw = 'Y' THEN 
            loc_issue_yy   := old_data.issue_yy;
            loc_pol_seq_no := old_data.pol_seq_no;
         END IF;   
         --BETH 04162001
         --     get max renew_no for the policy to be renewed 
         --     so that error for unique constraints will be eliminated 
         FOR  MAX_REN IN (SELECT renew_no, 
                                 DECODE(policy_id, renew.id,manual_renew_no, 0) manual_renew_no
                            FROM gipi_polbasic
                           WHERE line_cd = old_data.line_cd       
                             AND subline_cd = old_data.subline_cd
                             AND iss_cd = old_data.iss_cd
                             AND issue_yy = old_data.issue_yy
                             AND pol_seq_no = old_data.pol_seq_no
                          ORDER BY renew_no desc)
         LOOP                    
           --if old policy has an existing manual_renew_no the renew no of the 
           --new policy will be the manual_renew_no + 1 else the renew_no is the 
           --old renew_no + 1
           IF NVL(max_ren.manual_renew_no,0) > 0 THEN
             loc_renew_no   := nvl(max_ren.manual_renew_no,0) + 1;
           ELSE 
              -- if policy is for replacement and new policy number is to be generated then 
              -- renew number must be retained else renew number must be incremented
              -- added by aivhie 120601
              IF renew.pol_flag = '3' AND renew.same_sw = 'N' THEN 
               loc_renew_no   := nvl(max_ren.renew_no,0);
              --added by iris bordey (09.18.2002)
              --to handle a special case (for AUII) of renewing 1 policy to many/several policies.
              --if renewing policy and nwe polict is to be generated then
              --renew_no must be incremented from the renew_no(old_date.renew_no) of the policy to be renewed.
              ELSIF renew.pol_flag = '2' AND renew.same_sw = 'N' THEN 
               loc_renew_no := nvl(old_data.renew_no,0) + 1;
              ELSE
                loc_renew_no   := nvl(max_ren.renew_no,0) + 1;
              END IF;
           END IF;   
           EXIT;
         END LOOP;    
         --BETH 04162001 for renewal populate field actual_renew_no if actual_renew_no
         --     is already existing in policy being renewd just accumulate it by 1 but if it is not yet 
         --     existing retrieved it by counting no. of renewals for the policy in gipi_polnrep for policy
         --     that is not spoiled           
         IF renew.pol_flag = '2' THEN
            --if actual_renew_no is already populated in the policy being renewed
            --then add 1 to its actual renewed no  
            IF NVL(old_data.actual_renew_no,0) > 0 THEN
              loc_actual_renew_no := old_data.actual_renew_no + 1;              
            ELSE
              --if actual_renew_no of the policy being renew is null then
              --actual_renew_no would be 1 + manual_renew_no 
              loc_actual_renew_no := NVL(old_data.manual_renew_no,0) +1;
              loc_count_id := renew.id;
              loc_exit_sw := 'Y';
              --check history of renewal of policy and for every renewal that is 
              --not spoiled add 1 to actual_renew_no
              WHILE loc_exit_sw = 'Y'
              LOOP
                 loc_exit_sw := 'N';   
                FOR A IN (SELECT b610.old_policy_id, 
                                 b250a.manual_renew_no
                            FROM gipi_polbasic b250, gipi_polbasic b250a,
                                 gipi_polnrep b610
                           WHERE b250.policy_id = b610.new_policy_id
                             AND b250a.policy_id = b610.old_policy_id
                             AND b250.pol_flag NOT IN( '4','5')
                             AND b610.new_policy_id = loc_count_id)
                LOOP
                  loc_actual_renew_no := loc_actual_renew_no + NVL(a.manual_renew_no,0) + 1;
                  loc_count_id := a.old_policy_id;              
                  loc_exit_sw := 'Y'; 
                  EXIT;
                END LOOP;
                IF loc_exit_sw = 'N' THEN
                   EXIT;
                END IF;
              END LOOP;               
            END IF;  
         END IF;
       END LOOP;
     END LOOP;
  END IF;
  BEGIN
    /* Revised on 04 September 1997.
    */
    INSERT INTO gipi_polbasic
               (policy_id, line_cd, subline_cd, iss_cd,  issue_yy,
                pol_seq_no, endt_iss_cd, endt_yy, endt_seq_no, renew_no,
              endt_type, par_id,  incept_date, expiry_date, eff_date,
              issue_date, pol_flag, assd_no, designation, address1,
              address2, address3, mortg_name, tsi_amt, prem_amt,
              ann_tsi_amt, ann_prem_amt, pool_pol_no, foreign_acc_sw, invoice_sw,
               user_id, last_upd_date, spld_flag, dist_flag, endt_expiry_date,
                no_of_items, subline_type_cd,auto_renew_flag,prorate_flag, short_rt_percent,
              prov_prem_tag, type_cd, acct_of_cd,     pack_pol_flag, expiry_tag,
                prem_warr_tag,  ref_pol_no,     reg_policy_sw,  co_insurance_sw,discount_sw,
                ref_open_pol_no,incept_tag ,    booking_mth,    endt_expiry_tag,
                booking_year,   fleet_print_tag, manual_renew_no, with_tariff_sw,
                comp_sw, orig_policy_id, prov_prem_pct, place_cd,
                actual_renew_no, region_cd, industry_cd,acct_of_cd_sw,
                surcharge_sw, cred_branch, old_assd_no, cancel_date,
                old_address1, old_address2, old_address3, risk_tag, label_tag, 
                survey_agent_cd, settling_agent_cd)
         VALUES(postpar_policy_id, postpar_line_cd, loc_subline_cd, postpar_iss_cd, loc_issue_yy,
                loc_pol_seq_no,  postpar_iss_cd, loc_endt_yy,0, loc_renew_no, 
              affecting, postpar_par_id, loc_incept_dt, loc_expiry_dt,
              loc_eff_dt,  loc_issue_dt,  loc_pol_flag, loc_assd_no,
              decode(loc_designation, NULL, ' ', loc_designation),
              loc_pol_addr1,  loc_pol_addr2, loc_pol_addr3,
              loc_mortg_name,  
              decode(loc_tsi_amt, NULL, 0, loc_tsi_amt),
              decode(loc_prem_amt, NULL, 0, loc_prem_amt),
              decode(loc_ann_tsi, NULL, 0, loc_ann_tsi),
              decode(loc_ann_prem, NULL, 0, loc_ann_prem),
              decode(loc_pool_pol_no, NULL, ' ', loc_pool_pol_no),
              loc_foreign_acc_tag,  loc_invoices,
              USER, SYSDATE,  '1',  '1',
              loc_endt_expiry_date, loc_no_of_items,  loc_subline_type_cd,
              decode(loc_auto_renew_flag, NULL, ' ', loc_auto_renew_flag),
              loc_prorate_flag,  
              decode(loc_short_rt_percent,NULL, 0, loc_short_rt_percent),
              loc_prov_prem_tag, loc_type_cd,loc_acct_of_cd,loc_pack_pol_flag,  
              decode(loc_expiry_tag, NULL, 'N', loc_expiry_tag),
                loc_prem_warr_tag, loc_ref_pol_no, loc_reg_policy_sw, loc_co_insurance_sw, 
                loc_discount_sw, loc_ref_open_pol_no, loc_incept_tag, loc_booking_mth,
                loc_endt_expiry_tag, loc_booking_year, loc_fleet_print_tag,
                loc_manual_renew_no, loc_with_tariff_sw, loc_comp_sw, loc_orig_policy_id,
                loc_prov_prem_pct, loc_place_cd,
                loc_actual_renew_no, loc_region_cd, loc_industry_cd, loc_acct_of_cd_sw, 
                loc_surcharge_sw, loc_cred_branch, loc_old_assd_no, loc_cancel_date,
                loc_old_address1, loc_old_address2, loc_old_address3,loc_risk_tag, loc_label_tag,
                loc_survey_agent_cd, loc_settling_agent_cd);
  END;
END IF;  
END;
PROCEDURE copy_pol_wpolgenin IS
  p_first_info      gipi_wpolgenin.first_info%TYPE;
  p_user_id         gipi_wpolgenin.user_id%TYPE;
  p_last_update     gipi_wpolgenin.last_update%TYPE;
  p_genin_info_cd   gipi_wpolgenin.genin_info_cd%TYPE;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN  
   BEGIN
    SELECT  gen_info,gen_info01,gen_info02,gen_info03,gen_info04,gen_info05,gen_info06,
            gen_info07,gen_info08,gen_info09,gen_info10,gen_info11,gen_info12,
            gen_info13,gen_info14,gen_info15,gen_info16,gen_info17,
            initial_info01,initial_info02,initial_info03,
            initial_info04,initial_info05,initial_info06,initial_info07,initial_info08,
            initial_info09,initial_info10,initial_info11,initial_info12,initial_info13,
            initial_info14,initial_info15,initial_info16,initial_info17,
            first_info, user_id,last_update, genin_info_cd
      INTO  postpar_ws_long_var,postpar_ws_long_var1,postpar_ws_long_var2,
         postpar_ws_long_var3,postpar_ws_long_var4,postpar_ws_long_var5,
         postpar_ws_long_var6,postpar_ws_long_var7,postpar_ws_long_var8,
         postpar_ws_long_var9,postpar_ws_long_var10,postpar_ws_long_var11,
         postpar_ws_long_var12,postpar_ws_long_var13,postpar_ws_long_var14,
         postpar_ws_long_var15,postpar_ws_long_var16,postpar_ws_long_var17, 
         postpar_ws_initial,postpar_ws_initial02,
         postpar_ws_initial03,postpar_ws_initial04,postpar_ws_initial05,
         postpar_ws_initial06,postpar_ws_initial07,postpar_ws_initial08,
         postpar_ws_initial09,postpar_ws_initial10,postpar_ws_initial11,
         postpar_ws_initial12,postpar_ws_initial13,postpar_ws_initial14,
         postpar_ws_initial15,postpar_ws_initial16,postpar_ws_initial17, 
         p_first_info,p_user_id, p_last_update, p_genin_info_cd
      FROM gipi_wpolgenin
     WHERE par_id = postpar_par_id;
     INSERT INTO gipi_polgenin(policy_id,gen_info01,gen_info02,gen_info03,gen_info04,
                 gen_info05,gen_info06,gen_info07,gen_info08,gen_info09,gen_info10,
                 gen_info11,gen_info12,gen_info13,gen_info14,gen_info15,gen_info16,
                 gen_info17,gen_info, initial_info01,initial_info02,initial_info03,
                 initial_info04,initial_info05,initial_info06,initial_info07,initial_info08,
                 initial_info09,initial_info10,initial_info11,initial_info12,initial_info13,
                 initial_info14,initial_info15,initial_info16,initial_info17, first_info,
                 user_id,last_update, genin_info_cd)
          VALUES (postpar_policy_id,postpar_ws_long_var1,postpar_ws_long_var2,
                 postpar_ws_long_var3,postpar_ws_long_var4,postpar_ws_long_var5,
                 postpar_ws_long_var6,postpar_ws_long_var7,postpar_ws_long_var8,
                 postpar_ws_long_var9,postpar_ws_long_var10,postpar_ws_long_var11,
                 postpar_ws_long_var12,postpar_ws_long_var13,postpar_ws_long_var14,
                 postpar_ws_long_var15,postpar_ws_long_var16,postpar_ws_long_var17,
                 postpar_ws_long_var,postpar_ws_initial,postpar_ws_initial02,
            postpar_ws_initial03,postpar_ws_initial04,postpar_ws_initial05,
            postpar_ws_initial06,postpar_ws_initial07,postpar_ws_initial08,
             postpar_ws_initial09,postpar_ws_initial10,postpar_ws_initial11,
            postpar_ws_initial12,postpar_ws_initial13,postpar_ws_initial14,
            postpar_ws_initial15,postpar_ws_initial16,postpar_ws_initial17,
                 p_first_info,p_user_id,p_last_update, p_genin_info_cd);
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
    WHEN TOO_MANY_ROWS THEN
     pre_post_error(v_par_id,'General information has more than one record for a single PAR, '||
               'cannot proceed.');
   END;
END IF;   
END;
PROCEDURE copy_pol_wpolnrep IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN 
      INSERT INTO gipi_polnrep
        (PAR_ID,   OLD_POLICY_ID,   NEW_POLICY_ID,
         REC_FLAG, REN_REP_SW)
      SELECT par_id,old_policy_id,postpar_policy_id,
             rec_flag,ren_rep_sw
        FROM gipi_wpolnrep
       WHERE par_id  =  postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_winpolbas IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN 
  INSERT INTO giri_inpolbas
             (accept_no,policy_id,ri_policy_no,ri_endt_no,
              ri_binder_no,ri_cd,writer_cd,
              accept_date,offer_date,accept_by,orig_tsi_amt,orig_prem_amt,remarks,ref_accept_no)
      SELECT  accept_no,postpar_policy_id,ri_policy_no,ri_endt_no,ri_binder_no,
              ri_cd,writer_cd,accept_date,offer_date,accept_by,orig_tsi_amt,
              orig_prem_amt,remarks, ref_accept_no
         FROM giri_winpolbas
        WHERE par_id  = postpar_par_id;
END IF;  
END;
PROCEDURE copy_pol_wpack_line_subline IS
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_pack_line_subline
    (policy_id,pack_line_cd,pack_subline_cd,line_cd,remarks)
       SELECT postpar_policy_id,pack_line_cd,pack_subline_cd,
              line_cd,remarks
         FROM gipi_wpack_line_subline
        WHERE par_id  =  postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wlim_liab IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN  
  INSERT INTO gipi_lim_liab
              (policy_id,line_cd,liab_cd,limit_liability,currency_cd
              ,currency_rt) 
       SELECT postpar_policy_id,line_cd,liab_cd,limit_liability,currency_cd,
              currency_rt
         FROM gipi_wlim_liab
        WHERE par_id  =  postpar_par_id;
END IF;  
END;
PROCEDURE copy_pol_wdiscounts2(p_item_no   gipi_wperil_discount.item_no%TYPE) IS
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_peril_discount
           (policy_id,item_no,line_cd,peril_cd,sequence,
            disc_rt,disc_amt,net_gross_tag,discount_tag,level_tag,
            subline_cd,orig_peril_prem_amt,surcharge_rt,surcharge_amt)
       SELECT   postpar_policy_id,item_no,line_cd,peril_cd,sequence,
                disc_rt,disc_amt,net_gross_tag,discount_tag,level_tag,
                subline_cd,orig_peril_prem_amt,surcharge_rt,surcharge_amt
         FROM   gipi_wperil_discount
        WHERE   par_id  =  postpar_par_id
          AND   item_no =  p_item_no;
END IF;    
END;
PROCEDURE copy_pol_witmperl2(p_item_no IN gipi_witmperl.item_no%TYPE) IS
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_itmperil
             (policy_id,line_cd,item_no,peril_cd,tsi_amt,prem_amt,
              ann_tsi_amt,ann_prem_amt,rec_flag,comp_rem,discount_sw,tarf_cd,
              prem_rt,ri_comm_rate,ri_comm_amt,surcharge_sw, no_of_days, base_amt, 
              aggregate_sw)
      SELECT postpar_policy_id,line_cd,item_no,peril_cd,tsi_amt,prem_amt,
             ann_tsi_amt,ann_prem_amt,NVL(rec_flag,'A'),comp_rem,discount_sw,tarf_cd,
              prem_rt,ri_comm_rate,ri_comm_amt,surcharge_sw, no_of_days, base_amt, 
              aggregate_sw
         FROM gipi_witmperl
        WHERE par_id  = postpar_par_id
          AND item_no = p_item_no;
   copy_pol_wdiscounts2(p_item_no);
END IF;
END;
  /* Revised to add prorate_flag, comp_sw, short_rt_percent to be passed from gipi_witem to gipi_item
  ** Updated by   : bdarusin
  ** Last Update  : 022703
  */
PROCEDURE copy_pol_witem2(p_line_cd     IN VARCHAR2,
                          p_subline_cd  IN VARCHAR2)IS
BEGIN
IF skip_parid = 'N' THEN    
  FOR A IN (
         SELECT item_no,item_grp,item_title,item_desc,tsi_amt,
                prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,
                currency_rt,group_cd,from_date,to_date,pack_line_cd,
                pack_subline_cd,discount_sw,surcharge_sw, region_cd, changed_tag,
                prorate_flag, comp_sw, short_rt_percent, PACK_BEN_CD, PAYT_TERMS, -- gmi 09/21/05 ; added columns
                risk_no, risk_item_no -- grace 05/24/06
           FROM gipi_witem
          WHERE par_id         = postpar_par_id
            AND pack_line_cd   = p_line_cd
            AND pack_subline_cd= p_subline_cd) LOOP
    INSERT INTO gipi_item
               (policy_id,item_no,item_grp,item_title,item_desc,tsi_amt,
              prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,
              currency_rt,group_cd,from_date,to_date,pack_line_cd,
                pack_subline_cd,discount_sw,surcharge_sw, region_cd, changed_tag,
                prorate_flag, comp_sw, short_rt_percent, PACK_BEN_CD, PAYT_TERMS, -- gmi 09/21/05 ; added columns)
                risk_no, risk_item_no) -- grace 05/24/06
        VALUES (postpar_policy_id,A.item_no,A.item_grp,A.item_title,A.item_desc,A.tsi_amt,
                A.prem_amt,A.ann_tsi_amt,A.ann_prem_amt,A.rec_flag,A.currency_cd,
                A.currency_rt,A.group_cd,A.from_date,A.to_date,A.pack_line_cd,
                A.pack_subline_cd, A.discount_sw, A.surcharge_sw, A.region_cd, 
                A.changed_tag, A.prorate_flag, A.comp_sw, A.short_rt_percent, A.PACK_BEN_CD, A.PAYT_TERMS, -- gmi 09/21/05 ; added columns);
                A.risk_no, A.risk_item_no); -- grace 05/24/06
          copy_pol_witmperl2(A.item_no);
  END LOOP;
END IF;  
END;
PROCEDURE copy_pol_wbeneficiary IS
/* Revised to have conformity with the objects in the database;
** the columns in the policy table should not be indicated to determine
** whether the inserted records maintain their integrity with the objects
** in the database.
** Updated by   : Daphne
** Last Update  : 060798
*/
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_beneficiary
               (policy_id,item_no,beneficiary_name,beneficiary_addr,
                relation,
                beneficiary_no,delete_sw) 
   SELECT postpar_policy_id,item_no,beneficiary_name,beneficiary_addr,
          relation,beneficiary_no,delete_sw  
         FROM gipi_wbeneficiary
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_waccident_item IS
/* This procedure was added by ramil 09/03/96
** This procedure had been modified by bismark on 06/07/98 due to the table
** alterations made on the database.
** Updated by   :   Daphne
** Last Update  :   060798
*/
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_accident_item
              (policy_id,item_no,date_of_birth,age,civil_status,position_cd,
               monthly_salary,salary_grade,no_of_persons,destination,height,weight,
               sex,ac_class_cd,group_print_sw)
       SELECT postpar_policy_id,item_no,date_of_birth,age,civil_status,position_cd,
              monthly_salary,salary_grade,no_of_persons,destination,height,
              weight,sex,ac_class_cd,group_print_sw
         FROM gipi_waccident_item
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE COPY_POL_WGROUP_PACK_ITEM (p_item_no IN gipi_witem.item_no%TYPE) IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  ** Modified by   : Loth
  ** Date modified : 020499
  */
BEGIN
IF skip_parid = 'N' THEN
      INSERT INTO gipi_grouped_items
                  (policy_id,item_no,grouped_item_no,include_tag,grouped_item_title,
                   sex,position_cd,civil_status,date_of_birth,age,salary,salary_grade,
                   amount_coverage,remarks,line_cd, subline_cd,delete_sw, group_cd,
                   from_date, to_date, payt_terms, pack_ben_cd,--added columns by : gmi 09/20/05
                   ann_tsi_amt, ann_prem_amt,           --gmi
                   control_cd, control_type_cd,         --added columns by gmi 10/17/05
                   tsi_amt, prem_amt) 
      SELECT postpar_policy_id,item_no,grouped_item_no,include_tag,grouped_item_title,
             sex,position_cd,civil_status,date_of_birth,age,salary,salary_grade,
             amount_covered,remarks,line_cd, subline_cd,delete_sw,group_cd,
             from_date, to_date, payt_terms, pack_ben_cd,--added columns by : gmi 09/20/05
             ann_tsi_amt, ann_prem_amt,           --gmi
             control_cd, control_type_cd,         --added columns by gmi 10/17/05
             tsi_amt, prem_amt
            FROM gipi_wgrouped_items
            WHERE item_no = p_item_no
              AND par_id  = postpar_par_id;
END IF;     
END;
PROCEDURE copy_pol_wgrp_pack_item_ben (p_item_no IN gipi_witem.item_no%TYPE) IS
  /* Created By   : GRACE
     Date Created : 05/15/200 */
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_grp_items_beneficiary
        (policy_id,item_no,grouped_item_no,beneficiary_no,beneficiary_name,
         beneficiary_addr,relation,date_of_birth,age,civil_status,sex)
  SELECT postpar_policy_id,item_no,grouped_item_no,beneficiary_no,beneficiary_name,
         beneficiary_addr,relation,date_of_birth,age,civil_status,sex
    FROM gipi_wgrp_items_beneficiary
   WHERE item_no = p_item_no
     AND par_id  = postpar_par_id;
END IF;  
END;
PROCEDURE copy_pol_witmperl_pack_grouped(p_item_no IN gipi_witem.item_no%TYPE) IS
-- by: gmi 09/21/05
BEGIN
IF skip_parid = 'N' THEN
     INSERT INTO gipi_itmperil_grouped
                  (POLICY_ID, ITEM_NO, GROUPED_ITEM_NO, LINE_CD, PERIL_CD, REC_FLAG, 
                  PREM_RT, TSI_AMT, PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT, AGGREGATE_SW, 
                  BASE_AMT, NO_OF_DAYS)
     SELECT postpar_policy_id, ITEM_NO, GROUPED_ITEM_NO, LINE_CD, PERIL_CD, REC_FLAG, 
              PREM_RT, TSI_AMT, PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT, AGGREGATE_SW, 
              BASE_AMT, NO_OF_DAYS
             FROM gipi_witmperl_grouped
            WHERE par_id  = postpar_par_id
             AND item_no = p_item_no;
END IF;
END;
PROCEDURE copy_pol_witmperl_pack_ben(p_item_no IN gipi_witem.item_no%TYPE) IS
-- by: gmi 09/21/05
BEGIN
IF skip_parid = 'N' THEN
     INSERT INTO gipi_itmperil_beneficiary
                  (POLICY_ID, ITEM_NO, GROUPED_ITEM_NO, BENEFICIARY_NO, 
                  LINE_CD, PERIL_CD, REC_FLAG, PREM_RT, TSI_AMT, 
                  PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT)
     SELECT postpar_policy_id,ITEM_NO, GROUPED_ITEM_NO, BENEFICIARY_NO, 
            LINE_CD, PERIL_CD, REC_FLAG, PREM_RT, TSI_AMT, 
            PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT
             FROM gipi_witmperl_beneficiary
            WHERE item_no = p_item_no
             AND par_id  = postpar_par_id;
END IF;
END;
 PROCEDURE copy_pol_pack_wdeductibles(p_item_no IN gipi_witem.item_no%TYPE) IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
 BEGIN
 IF skip_parid = 'N' THEN
       INSERT INTO gipi_deductibles(
            policy_id, item_no, ded_line_cd, ded_subline_cd, ded_deductible_cd,
            deductible_text,deductible_amt, deductible_rt, peril_cd)
            SELECT postpar_policy_id,item_no,ded_line_cd,ded_subline_cd,ded_deductible_cd,
                   deductible_text,deductible_amt, deductible_rt, peril_cd
              FROM gipi_wdeductibles
             WHERE item_no  = p_item_no
               AND par_id  =  postpar_par_id;
END IF;
 END;
PROCEDURE copy_pol_wopen_policy IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN 
IF skip_parid = 'N' THEN
  INSERT INTO gipi_open_policy
              (policy_id,line_cd,op_subline_cd,op_iss_cd,
               op_pol_seqno,decltn_no,op_issue_yy,op_renew_no,eff_date) 
       SELECT postpar_policy_id,line_cd,op_subline_cd,op_iss_cd,
              op_pol_seqno,decltn_no,op_issue_yy,op_renew_no,eff_date
         FROM gipi_wopen_policy
        WHERE par_id = postpar_par_id;
END IF;
END; 
PROCEDURE copy_POL_WREQDOCS IS
  CURSOR reqdocs_cur IS 
     SELECT doc_cd,par_id,doc_sw,line_cd,
            date_submitted,user_id,last_update,remarks
    FROM gipi_wreqdocs
      WHERE par_id  = postpar_par_id;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  IF v_line_cd = line_su THEN
      FOR cur_rec IN REQDOCS_CUR LOOP
             IF cur_rec.doc_sw = 'Y' AND cur_rec.date_submitted IS NULL THEN
              pre_post_error(v_par_id,'Dates should not be null for required document.PAR should have submitted date for documents.');
             END IF;
      END LOOP;        
   END IF;
  for REQDOCS_cur_rec in REQDOCS_cur loop
  INSERT INTO gipi_reqdocs(doc_cd,policy_id,doc_sw,line_cd,date_submitted,user_id,
                           last_update,remarks)
       VALUES(reqdocs_cur_rec.doc_cd,postpar_policy_id,reqdocs_cur_rec.doc_sw,
       reqdocs_cur_rec.line_cd,reqdocs_cur_rec.date_submitted,user,
              sysdate,reqdocs_cur_rec.remarks);
  end loop;
END IF;
END;
/* beth 08251998 revised to conform with new table structure 
**               of gipi_polwc and gipi_wpolwc
** revised by Loth 060199
*/
PROCEDURE copy_pol_wpolwc IS
  CURSOR polwc_cur IS SELECT par_id,line_cd,wc_cd,swc_seq_no,print_seq_no,
        wc_title,wc_title2/*issa@fpac06.26.2006*/,wc_text02,wc_text03,wc_text04,wc_text05,
        wc_text06,wc_text07,wc_text08,wc_text09,wc_text10,
          wc_text11,wc_text12,wc_text13,wc_text14,wc_text15,
        wc_text16,wc_text17,
                             wc_remarks,rec_flag,print_sw,change_tag 
                 FROM gipi_wpolwc
                       WHERE par_id  = postpar_par_id;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  FOR polwc_cur_rec IN polwc_cur LOOP
      SELECT wc_text01
        INTO postpar_ws_long_var
        FROM gipi_wpolwc
       WHERE par_id     = postpar_par_id AND
             line_cd    = polwc_cur_rec.line_cd AND
             wc_cd = polwc_cur_rec.wc_cd AND
             swc_seq_no = polwc_cur_rec.swc_seq_no;
      INSERT INTO gipi_polwc
                 (policy_id,line_cd,wc_cd,swc_seq_no,print_seq_no,
                  wc_title,wc_title2/*issa@fpac06.26.2006*/,wc_remarks,wc_text01,
                  wc_text02,wc_text03,
    wc_text04,wc_text05,
                  wc_text06,wc_text07,
                  wc_text08,wc_text09,
                  wc_text10,wc_text11,
                  wc_text12,wc_text13,
                  wc_text14,wc_text15,
                  wc_text16,wc_text17, 
                  rec_flag, print_sw,
                  change_tag) 
           VALUES(postpar_policy_id,polwc_cur_rec.line_cd,
    polwc_cur_rec.wc_cd,polwc_cur_rec.swc_seq_no,
    polwc_cur_rec.print_seq_no,polwc_cur_rec.wc_title,polwc_cur_rec.wc_title2,/*issa@fpac06.26.2006*/
    polwc_cur_rec.wc_remarks,postpar_ws_long_var,
                  polwc_cur_rec.wc_text02,polwc_cur_rec.wc_text03,
    polwc_cur_rec.wc_text04,polwc_cur_rec.wc_text05,
    polwc_cur_rec.wc_text06,polwc_cur_rec.wc_text07,
    polwc_cur_rec.wc_text08,polwc_cur_rec.wc_text09,
    polwc_cur_rec.wc_text10,polwc_cur_rec.wc_text11,
                  polwc_cur_rec.wc_text12,polwc_cur_rec.wc_text13,
    polwc_cur_rec.wc_text14,polwc_cur_rec.wc_text15,
     polwc_cur_rec.wc_text16,polwc_cur_rec.wc_text17,
    polwc_cur_rec.rec_flag, polwc_cur_rec.print_sw,
                  polwc_cur_rec.change_tag);
  END LOOP;
END IF;  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;
END;
PROCEDURE copy_pol_wmortgagee IS
BEGIN
IF skip_parid = 'N' THEN
      INSERT INTO gipi_mortgagee
        (policy_id, iss_cd, mortg_cd,
         item_no, amount, remarks,
         last_update, user_id, delete_sw)
      SELECT postpar_policy_id, iss_cd, mortg_cd,
             item_no, amount, remarks,
             last_update, user_id, delete_sw
        FROM gipi_wmortgagee
       WHERE par_id  =  postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_winvperl(p_item_grp IN gipi_winvperl.item_grp%TYPE) IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN 
      INSERT INTO gipi_invperil
                 (iss_cd,prem_seq_no,peril_cd,tsi_amt,prem_amt,item_grp,ri_comm_amt,
                  ri_comm_rt)
           SELECT postpar_iss_cd,postpar_prem_seq_no,peril_cd,tsi_amt,prem_amt,
                  item_grp,ri_comm_amt,ri_comm_rt
             FROM gipi_winvperl
            WHERE par_id   = postpar_par_id
              AND item_grp = p_item_grp;
END IF;
END;
PROCEDURE copy_pol_winstallment(p_item_grp IN gipi_winvoice.item_grp%TYPE) IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
      INSERT INTO gipi_installment
                 (iss_cd,prem_seq_no,item_grp,inst_no,share_pct,
                tax_amt,prem_amt,due_date) 
           SELECT postpar_iss_cd,postpar_prem_seq_no,item_grp,inst_no,
                  share_pct,tax_amt,prem_amt,due_date
             FROM gipi_winstallment
            WHERE par_id   =  postpar_par_id
              AND item_grp =  p_item_grp;
END IF;
END;
PROCEDURE copy_pol_winv_tax(p_item_grp IN gipi_winv_tax.item_grp%TYPE) IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN 
  INSERT INTO gipi_inv_tax
             (prem_seq_no,iss_cd,tax_cd,tax_amt,line_cd,item_grp,tax_id,
              tax_allocation,fixed_tax_allocation,rate)
       SELECT postpar_prem_seq_no,iss_cd,tax_cd,tax_amt,line_cd,item_grp,tax_id,
              tax_allocation,fixed_tax_allocation,rate
         FROM gipi_winv_tax
        WHERE item_grp = p_item_grp AND
              par_id  = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wpackage_inv_tax(p_item_grp  IN gipi_invoice.item_grp%TYPE) IS
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_package_inv_tax
   (policy_id,item_grp,line_cd,iss_cd,prem_seq_no,prem_amt,tax_amt,
    other_charges)
  SELECT postpar_policy_id,item_grp,line_cd,postpar_iss_cd,
         postpar_prem_seq_no,prem_amt,tax_amt,other_charges
    FROM gipi_wpackage_inv_tax
   WHERE par_id   =  postpar_par_id
     AND item_grp =  p_item_grp;
END IF;
END;
PROCEDURE copy_pol_wcomm_inv_perils(p_iss_cd       VARCHAR2,
                                    p_prem_seq_no  NUMBER,
                                    p_item_grp     NUMBER) IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_comm_inv_peril
              (INTRMDRY_INTM_NO,ISS_CD,PREM_SEQ_NO,POLICY_ID,
               PERIL_CD,PREMIUM_AMT,COMMISSION_AMT,COMMISSION_RT,WHOLDING_TAX)
       SELECT intrmdry_intm_no,p_iss_cd,p_prem_seq_no,postpar_policy_id,
              peril_cd,premium_amt,commission_amt,commission_rt,wholding_tax
         FROM gipi_wcomm_inv_perils
        WHERE par_id   =  postpar_par_id
          AND item_grp =  p_item_grp;
END IF;
END;
PROCEDURE copy_pol_wcomm_invoices IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  FOR A IN (SELECT iss_cd,prem_seq_no,item_grp
              FROM gipi_invoice
             WHERE policy_id = postpar_policy_id) LOOP
         INSERT INTO gipi_comm_invoice
              (policy_id,intrmdry_intm_no,iss_cd,prem_seq_no,share_percentage,
               premium_amt,commission_amt,wholding_tax,bond_rate,parent_intm_no)
           SELECT postpar_policy_id,intrmdry_intm_no,A.iss_cd,A.prem_seq_no,
                  share_percentage,premium_amt,commission_amt,wholding_tax,
                  bond_rate,parent_intm_no
             FROM gipi_wcomm_invoices
            WHERE par_id    =  postpar_par_id
              AND item_grp  =  A.item_grp;
         --added by A.R.C. 02.15.2005     
         INSERT INTO gipi_comm_inv_dtl
              (policy_id,intrmdry_intm_no,iss_cd,prem_seq_no,share_percentage,
               premium_amt,commission_amt,wholding_tax,parent_intm_no)
           SELECT postpar_policy_id,intrmdry_intm_no,A.iss_cd,A.prem_seq_no,
                  share_percentage,premium_amt,commission_amt,wholding_tax,
                  parent_intm_no
             FROM gipi_wcomm_inv_dtl
            WHERE par_id    =  postpar_par_id
              AND item_grp  =  A.item_grp;
           copy_pol_wcomm_inv_perils(A.iss_cd,A.prem_seq_no,A.item_grp);
  END LOOP;
END IF;
END;
PROCEDURE copy_pol_winvoice IS
  p_exist      NUMBER;
  prem_seq     NUMBER;
  CURSOR invoice_cur IS SELECT item_grp,property,prem_amt,
                               tax_amt,payt_terms,insured,due_date,currency_cd,
                               currency_rt,remarks,other_charges,ri_comm_amt,
                               ref_inv_no,notarial_fee,policy_currency,      
                               bond_rate,bond_tsi_amt,ri_comm_vat
                          FROM gipi_winvoice
                         WHERE par_id = postpar_par_id;
BEGIN
IF skip_parid = 'N' THEN
  IF issue_ri = postpar_iss_cd THEN
    FOR A IN (
       SELECT   '1'
         FROM   GIRI_INPOLBAS
        WHERE   policy_id = postpar_policy_id) LOOP
      p_exist  :=  1;
      EXIT;
    END LOOP;
    IF p_exist IS NULL THEN
        pre_post_error(v_par_id, 'Please enter the initial acceptance.');
    END IF;
  END IF;
  FOR invoice_cur_rec IN invoice_cur LOOP
    BEGIN
        FOR A IN (
            SELECT prem_seq_no
       FROM giis_prem_seq
             WHERE iss_cd = postpar_iss_cd) LOOP
          prem_seq := A.prem_seq_no+1;
          EXIT;
        END LOOP;
      INSERT INTO gipi_invoice
                 (iss_cd,policy_id,item_grp,property,prem_amt,tax_amt,payt_terms,
                  insured,user_id,last_upd_date,due_date,ri_comm_amt,currency_cd,
                  prem_seq_no,ref_inv_no,  -- beth 
                  currency_rt,remarks,other_charges,notarial_fee,policy_currency,
                  bond_rate,bond_tsi_amt,ri_comm_vat)
           VALUES(postpar_iss_cd,postpar_policy_id,
    invoice_cur_rec.item_grp,invoice_cur_rec.property,
    invoice_cur_rec.prem_amt,invoice_cur_rec.tax_amt,
    invoice_cur_rec.payt_terms,invoice_cur_rec.insured,
    USER,SYSDATE,invoice_cur_rec.due_date,invoice_cur_rec.ri_comm_amt,
                  invoice_cur_rec.currency_cd,
                  nvl(prem_seq,1), invoice_cur_rec.ref_inv_no,
                  invoice_cur_rec.currency_rt,
                  invoice_cur_rec.remarks,invoice_cur_rec.other_charges,
                  invoice_cur_rec.notarial_fee,invoice_cur_rec.policy_currency,
                  invoice_cur_rec.bond_rate, invoice_cur_rec.bond_tsi_amt,
                  invoice_cur_rec.ri_comm_vat);
        /* This statement has been revised since the GIIS_GIISSEQ table
        ** has already been replaced by several parameter tables such
        ** as the giis_prem_seq which would generate the prem_seq_no
        ** to be used by this procedure.
        */
        FOR A IN (
            SELECT prem_seq_no
       FROM giis_prem_seq
             WHERE iss_cd = postpar_iss_cd) LOOP
          postpar_prem_seq_no := A.prem_seq_no;
          EXIT;
        END LOOP;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
             pre_post_error(v_par_id, 'Duplicate record on GIPI_INVOICE with ISS_CD = '||postpar_iss_cd||
                       ' and PREM_SEQ_NO = '||to_char(prem_seq)||'.');
    END;
        copy_pol_winvperl(invoice_cur_rec.item_grp);
        copy_pol_winstallment(invoice_cur_rec.item_grp);
        copy_pol_winv_tax(invoice_cur_rec.item_grp);
        IF postpar_pack = 'Y' THEN
          copy_pol_wpackage_inv_tax(invoice_cur_rec.item_grp);
        END IF;
END LOOP;
  copy_pol_wcomm_invoices; -- beth 10-02-98 uncomment the calling of copy_pol_wcomm_invoices
END IF;  
END;
PROCEDURE UPDATE_CO_INS IS
BEGIN
IF skip_parid = 'N' THEN
  UPDATE  gipi_main_co_ins
     SET  policy_id = postpar_policy_id
   WHERE  par_id = postpar_par_id;
  UPDATE  gipi_co_insurer
     SET  policy_id = postpar_policy_id
   WHERE  par_id = postpar_par_id;
  UPDATE  gipi_orig_itmperil
     SET  policy_id = postpar_policy_id
   WHERE  par_id = postpar_par_id;
  UPDATE  gipi_orig_invoice
     SET  policy_id = postpar_policy_id
   WHERE  par_id = postpar_par_id;
  UPDATE  gipi_orig_inv_tax
     SET  policy_id = postpar_policy_id
   WHERE  par_id = postpar_par_id;
  UPDATE  gipi_orig_invperl
     SET  policy_id = postpar_policy_id
   WHERE  par_id = postpar_par_id;
  UPDATE  gipi_orig_comm_invoice
     SET  policy_id   = postpar_policy_id 
   WHERE  par_id      = postpar_par_id;
  UPDATE  gipi_orig_comm_inv_peril
     SET  policy_id   = postpar_policy_id
   WHERE  par_id      = postpar_par_id;
  FOR inv_seq IN (
    SELECT prem_seq_no, iss_cd, item_grp
      FROM gipi_invoice
     WHERE policy_id = postpar_policy_id)
  LOOP
    UPDATE  gipi_orig_comm_invoice
       SET  prem_seq_no = inv_seq.prem_seq_no,
            iss_cd      = inv_seq.iss_cd  
     WHERE  policy_id   = postpar_policy_id
       AND  item_grp    = inv_seq.item_grp;
    UPDATE  gipi_orig_comm_inv_peril
       SET  prem_seq_no = inv_seq.prem_seq_no,
            iss_cd      = inv_seq.iss_cd 
     WHERE  policy_id   = postpar_policy_id
       AND  item_grp    = inv_seq.item_grp;          
  END LOOP;
END IF;
END;
PROCEDURE copy_pol_wbank_sched IS
    v_renew_no    GIPI_WPOLBAS.RENEW_NO%TYPE;
    v_eff_date    GIPI_WPOLBAS.EFF_DATE%TYPE;
    v_issue_yy    GIPI_WPOLBAS.ISSUE_YY%TYPE;
    v_line_cd     GIPI_WPOLBAS.LINE_CD%TYPE;
    v_subline_cd  GIPI_WPOLBAS.SUBLINE_CD%TYPE;
    v_pol_seq_no  GIPI_WPOLBAS.POL_SEQ_NO%TYPE;
    v_endt_seq_no GIPI_WPOLBAS.ENDT_SEQ_NO%TYPE;
    v_iss_cd      GIPI_WPOLBAS.ISS_CD%TYPE;
BEGIN
IF skip_parid = 'N' THEN
  FOR pol IN (
     SELECT line_cd,subline_cd,iss_cd,endt_seq_no,
            renew_no,eff_date,issue_yy,pol_seq_no
       FROM gipi_polbasic
      WHERE policy_id = postpar_policy_id)
  LOOP
    v_renew_no    := pol.renew_no;
    v_eff_date    := pol.eff_date;
    v_issue_yy    := pol.issue_yy;
    v_line_cd     := pol.line_cd;
    v_subline_cd  := pol.subline_cd;
    v_pol_seq_no  := pol.pol_seq_no;
    v_endt_seq_no := pol.endt_seq_no;
    v_iss_cd      := pol.iss_cd;
  END LOOP;
  INSERT INTO gipi_bank_schedule
               (policy_id,     bank_item_no,  bank_line_cd,    bank_subline_cd,
                bank_iss_cd,   bank_issue_yy, bank_pol_seq_no, bank_endt_seq_no,
                bank_renew_no, bank_eff_date, bank,bank_address,
                cash_in_vault,cash_in_transit,include_tag) 
       SELECT postpar_policy_id,bank_item_no,  v_line_cd,    v_subline_cd,
              v_iss_cd,   v_issue_yy, v_pol_seq_no, 0,
              v_renew_no, v_eff_date, bank,bank_address,
                cash_in_vault,cash_in_transit,include_tag
         FROM gipi_wbank_schedule
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_POL_WCASUALTY_ITEM IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
   INSERT INTO gipi_casualty_item
         (policy_id,item_no,section_line_cd,section_subline_cd,section_or_hazard_cd,
          capacity_cd,property_no_type,property_no,location,conveyance_info,
          interest_on_premises,limit_of_liability,section_or_hazard_info)
   SELECT postpar_policy_id,item_no,section_line_cd,section_subline_cd,
          section_or_hazard_cd,capacity_cd,property_no_type,
          property_no,location,conveyance_info,interest_on_premises,
          limit_of_liability,section_or_hazard_info
     FROM gipi_wcasualty_item
    WHERE par_id = postpar_par_id;
END IF; 
END;
PROCEDURE copy_pol_wcasualty_personnel IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
 INSERT INTO gipi_casualty_personnel
             (policy_id,item_no,personnel_no,name,include_tag,capacity_cd,
              amount_covered,remarks, delete_sw)
      SELECT postpar_policy_id,item_no,personnel_no,name,include_tag,capacity_cd,
             amount_covered,remarks, delete_sw
        FROM gipi_wcasualty_personnel
       WHERE par_id  =  postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wengg_basic IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_engg_basic
   (policy_id,engg_basic_infonum,contract_proj_buss_title,site_location,
    construct_start_date,construct_end_date,maintain_start_date,
    maintain_end_date,weeks_test,time_excess,mbi_policy_no,
    testing_start_date,testing_end_date)
   SELECT postpar_policy_id,engg_basic_infonum,contract_proj_buss_title,
          site_location,construct_start_date,construct_end_date,
          maintain_start_date,maintain_end_date,weeks_test,time_excess,
          mbi_policy_no, testing_start_date,testing_end_date
     FROM gipi_wengg_basic
    WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wprincipal IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN 
  INSERT INTO gipi_principal
              (policy_id,principal_cd,engg_basic_infonum,subcon_sw)
       SELECT postpar_policy_id,principal_cd,engg_basic_infonum,subcon_sw
         FROM gipi_wprincipal
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wlocation IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
    INSERT INTO gipi_location
                (policy_id,item_no,region_cd,province_cd) 
         SELECT postpar_policy_id,item_no,region_cd,province_cd
           FROM gipi_wlocation
          WHERE par_id = postpar_par_id;
END IF;
END;
/* Feb. 13, 2001  Grace                                                                      *
 * this procedure checks if there are existing perils in GIPI_WITMPERL with zone_type != '4' *
 * if these perils exists then check for the existence of zones in GIPI_WFIREITM             */
PROCEDURE CHECK_ZONE_TYPE IS
  v_exist1       VARCHAR2(1) := 'N'; 
  v_exist2       VARCHAR2(1) := 'N'; 
  v_exist3       VARCHAR2(1) := 'N'; 
  v_item         gipi_item.item_no%TYPE;
BEGIN
IF skip_parid = 'N' THEN  
  FOR A IN (SELECT item_no 
              FROM gipi_witem
             WHERE par_id = postpar_par_id) LOOP
    FOR B IN (SELECT zone_type
                FROM giis_peril
               WHERE zone_type IS NOT NULL
                 AND zone_type != '4'
                 AND line_cd = postpar_line_cd
                 AND peril_cd IN (SELECT peril_cd
                                    FROM gipi_witmperl
                                   WHERE par_id  = postpar_par_id
                                     AND item_no = a.item_no)) LOOP
      IF b.zone_type = '1' THEN
        FOR B IN (SELECT flood_zone
                    FROM gipi_wfireitm                          
                   WHERE par_id = postpar_par_id
                      AND item_no = a.item_no
                      AND flood_zone IS NULL) LOOP             
               v_exist1 := 'Y';
               v_item   := a.item_no;
               EXIT;
         END LOOP;
      ELSIF b.zone_type = '2' THEN
        FOR B IN (SELECT typhoon_zone
                    FROM gipi_wfireitm                          
                   WHERE par_id = postpar_par_id
                      AND item_no = a.item_no
                      AND typhoon_zone IS NULL) LOOP             
               v_exist2 := 'Y';
               v_item   := a.item_no;
               EXIT;
         END LOOP;
      ELSE 
        FOR C IN (SELECT eq_zone
                    FROM gipi_wfireitm                          
                   WHERE par_id = postpar_par_id
                      AND item_no = a.item_no
                      AND eq_zone IS NULL) LOOP             
               v_exist3 := 'Y';
               v_item   := a.item_no;
               EXIT;
         END LOOP;         
      END IF;               
      IF v_exist1 = 'Y' OR v_exist2 = 'Y' OR v_exist3 = 'Y' THEN
        EXIT;
      END IF;  
    END LOOP;    
    IF v_exist1 = 'Y' OR v_exist2 = 'Y' OR v_exist3 = 'Y' THEN
       EXIT;
    END IF;  
  END LOOP;                                  
  IF v_exist1 = 'Y' THEN
     pre_post_error(v_par_id,'Flood zone must be entered for item no '||v_item);
  END IF;
  IF v_exist2 = 'Y' THEN
     pre_post_error(v_par_id,'Typhoon zone must be entered for item no '||v_item);
  END IF;   
  IF v_exist3 = 'Y' THEN  
     pre_post_error(v_par_id,'Earthquake zone must be entered for item no '||v_item);
  END IF;
END IF;    
END;
PROCEDURE copy_pol_wfireitm IS
  /*Modified by Iris Bordey 10.30.2003
  **See spec# UW-SPECS-GIPIS055-003-0026
  **To populate risk_cd.
  */
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_fireitem
             (policy_id,item_no,district_no,eq_zone,tarf_cd,block_no,fr_item_type,
              loc_risk1,loc_risk2,loc_risk3,tariff_zone,typhoon_zone,construction_cd,
              construction_remarks,front,right,left,rear,occupancy_cd,occupancy_remarks, flood_zone,
              assignee, block_id, risk_cd)
       SELECT postpar_policy_id,item_no,district_no,eq_zone,tarf_cd,block_no,fr_item_type,
              loc_risk1,loc_risk2,loc_risk3,tariff_zone,typhoon_zone,construction_cd,
              construction_remarks,front,right,left,rear,occupancy_cd,occupancy_remarks, flood_zone,
              assignee, block_id, risk_cd
         FROM gipi_wfireitm
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_POL_WFIRE IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  copy_pol_wfireitm;
END IF;  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;  
END;
PROCEDURE copy_pol_wvehicle IS
  CURSOR c1 IS SELECT item_no,plate_no,subline_cd,motor_no,est_value,
                      make,mot_type,color,type_of_body_cd,repair_lim,serial_no,
                      coc_seq_no,coc_serial_no,coc_type,assignee,
                      model_year,coc_issue_date,
                      NVL(coc_yy,TO_NUMBER(TO_CHAR(SYSDATE,'RR'))) coc_yy,towing,
                      subline_type_cd,no_of_pass,tariff_zone,ctv_tag,
                      mv_file_no,acquired_from, car_company_cd,
                      basic_color_cd, series_cd, make_cd, color_cd, unladen_wt,
                      motor_coverage, origin, destination, coc_atcn
                 FROM gipi_wvehicle
                WHERE par_id = postpar_par_id;
  v_coc_type          gipi_wvehicle.coc_type%TYPE;
  v_coc_serial_no     gipi_wvehicle.coc_serial_no%TYPE;
  v_coc_seq_no        gipi_wvehicle.coc_seq_no%TYPE;  
  v_coc_yy            gipi_wvehicle.coc_yy%TYPE;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  FOR c1_rec IN c1 LOOP 
      v_coc_type        := c1_rec.coc_type;
      v_coc_serial_no   := NVL(c1_rec.coc_serial_no,0);
      v_coc_seq_no      := NVL(c1_rec.coc_seq_no,0);
      v_coc_yy          := NVL(c1_rec.coc_yy,0);
          -- grace 09/07/00
          -- requested by ms.rose
          --GENERATE_COC_SEQ_NO(postpar_policy_id,
          --                    c1_rec.item_no,
          --                    v_coc_type,
          --                    v_coc_serial_no,
          --                    v_coc_seq_no,
          --                    v_coc_yy);
      INSERT INTO gipi_vehicle 
        (policy_id,item_no,subline_cd,coc_yy,coc_seq_no,coc_serial_no,
          coc_type,repair_lim,color,type_of_body_cd,motor_no,model_year,make,
          mot_type,est_value,serial_no,towing,assignee,plate_no,subline_type_cd,
          no_of_pass,tariff_zone,ctv_tag,mv_file_no,acquired_from,
          coc_issue_date, car_company_cd,
          basic_color_cd, series_cd, make_cd, color_cd,unladen_wt, motor_coverage,
          origin, destination, coc_atcn)
      VALUES
         (postpar_policy_id,c1_rec.item_no,c1_rec.subline_cd,v_coc_yy,v_coc_seq_no,v_coc_serial_no,
          v_coc_type,c1_rec.repair_lim,c1_rec.color,c1_rec.type_of_body_cd,c1_rec.motor_no,
          c1_rec.model_year,c1_rec.make,c1_rec.mot_type,c1_rec.est_value,c1_rec.serial_no,
          c1_rec.towing,c1_rec.assignee,c1_rec.plate_no,c1_rec.subline_type_cd,
          c1_rec.no_of_pass,c1_rec.tariff_zone,c1_rec.ctv_tag,
          c1_rec.mv_file_no,c1_rec.acquired_from, c1_rec.coc_issue_date,c1_rec.car_company_cd,
          c1_rec.basic_color_cd, c1_rec.series_cd, c1_rec.make_cd, c1_rec.color_cd, c1_rec.unladen_wt,
          c1_rec.motor_coverage, c1_rec.origin, c1_rec.destination, c1_rec.coc_atcn);
  END LOOP;
END IF;
END;
PROCEDURE copy_pol_wmcacc IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN 
   INSERT INTO gipi_mcacc
               (policy_id,accessory_cd,item_no,acc_amt,user_id,last_update,delete_sw)
       SELECT postpar_policy_id,accessory_cd,item_no, acc_amt,user_id,last_update ,delete_sw  
         FROM gipi_wmcacc
        WHERE par_id  =  postpar_par_id;
END IF;    
exception when no_data_found then
           null;   
END;
PROCEDURE copy_pol_wbond_basic IS
  /* This procedure was created for the purpose of extracting information from gipi_wbond_basic
  ** and inserting this information to gipi_bond_basic.
  ** Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_bond_basic
                  (policy_id,obligee_no,val_period,val_period_unit,np_NO,
                   contract_dtl,contract_date,prin_id,coll_flag,co_prin_sw,
                   waiver_limit,indemnity_text,bond_dtl,endt_eff_date,clause_type,
                   remarks)
  SELECT postpar_policy_id,obligee_no,val_period,val_period_unit,np_no,
         contract_dtl,contract_date,prin_id,coll_flag,co_prin_sw,
         waiver_limit,indemnity_text,bond_dtl,endt_eff_date,clause_type,
         remarks
    FROM gipi_wbond_basic
   WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wcosigntry IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_cosigntry(
       policy_id,cosign_id,assd_no,
       indem_flag,bonds_flag,bonds_ri_flag)
       SELECT postpar_policy_id,cosign_id,assd_no,
              indem_flag,bonds_flag,bonds_ri_flag
         FROM gipi_wcosigntry
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE update_collateral_par IS
BEGIN
IF skip_parid = 'N' THEN
  UPDATE gipi_collateral_par
     SET policy_id = postpar_policy_id
   WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wves_air IS
  v_vessel_cd  gipi_wves_air.vessel_cd%TYPE;
  v_voy_limit  gipi_wves_air.voy_limit%TYPE;
  v_rec_flag  gipi_wves_air.rec_flag%TYPE;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN 
  INSERT INTO gipi_ves_air
              (policy_id,vessel_cd,vescon,voy_limit,rec_flag)
  SELECT postpar_policy_id,vessel_cd,vescon,voy_limit,rec_flag 
    FROM gipi_wves_air
   WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wcargo IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_cargo
              (policy_id,item_no,vessel_cd,geog_cd,cargo_class_cd,bl_awb,
               rec_flag,origin,destn,etd,eta,cargo_type,deduct_text,pack_method,
               tranship_origin,tranship_destination,print_tag, lc_no, voyage_no)
      SELECT postpar_policy_id,item_no,vessel_cd,geog_cd,cargo_class_cd,bl_awb,
              rec_flag,origin,destn,etd,eta,cargo_type,deduct_text,pack_method,
              tranship_origin,tranship_destination,print_tag, lc_no, voyage_no
         FROM gipi_wcargo
        WHERE par_id = postpar_par_id;
  INSERT INTO gipi_cargo_carrier
              (policy_id,item_no,vessel_cd,last_update,user_id,
               voy_limit, vessel_limit_of_liab,eta,etd,origin,destn,delete_sw)
      SELECT postpar_policy_id,item_no,vessel_cd,last_update,user_id,
             voy_limit, vessel_limit_of_liab,eta,etd,origin,destn,delete_sw
         FROM gipi_wcargo_carrier
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wopen_liab IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN 
  INSERT INTO gipi_open_liab
             (policy_id,geog_cd,limit_liability,currency_cd,currency_rt,
              voy_limit,rec_flag,with_invoice_tag,multi_geog_tag)
       SELECT postpar_policy_id,geog_cd,limit_liability,currency_cd,currency_rt,
              voy_limit,rec_flag, with_invoice_tag,multi_geog_tag
         FROM gipi_wopen_liab
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wopen_peril IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_open_peril(policy_id,geog_cd,line_cd,peril_cd,rec_flag,prem_rate,remarks,with_invoice_tag)
       SELECT postpar_policy_id,geog_cd,line_cd,peril_cd,rec_flag,prem_rate, remarks,with_invoice_tag
         FROM gipi_wopen_peril
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wopen_cargo IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN 
  INSERT INTO gipi_open_cargo(policy_id,geog_cd,cargo_class_cd,rec_flag)
       SELECT postpar_policy_id,geog_cd,cargo_class_cd,rec_flag
         FROM gipi_wopen_cargo
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_witem_ves IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_item_ves
             (policy_id,item_no,vessel_cd,geog_limit,rec_flag,
              deduct_text,dry_date,dry_place)
       SELECT postpar_policy_id,item_no,vessel_cd,geog_limit,rec_flag,
              deduct_text,dry_date,dry_place
         FROM gipi_witem_ves
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_waviation_item IS
/* Revised to have conformity with the objects in the database;
** the columns in the policy table should not be indicated to determine
** whether the inserted records maintain their integrity with the objects
** in the database.
** Updated by   : Daphne
** Last Update  : 060798
*/
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_aviation_item
             (policy_id,item_no,vessel_cd,total_fly_time,qualification,
              purpose,geog_limit,deduct_text,rec_flag,fixed_wing,
              rotor,prev_util_hrs,est_util_hrs)
       SELECT postpar_policy_id,item_no,vessel_cd,total_fly_time,qualification,
              purpose,geog_limit,deduct_text,rec_flag,fixed_wing,
              rotor,prev_util_hrs,est_util_hrs
         FROM gipi_waviation_item
        WHERE par_id = postpar_par_id;
END IF;  
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
       null;
END;
PROCEDURE copy_pol_wcargo_hull(p_line    IN giis_subline.line_cd%TYPE,
                               p_subline IN giis_subline.subline_cd%TYPE) IS
BEGIN
IF skip_parid = 'N' THEN
  IF p_line = postpar_cargo_cd THEN
     --IF p_subline <> subline_mop THEN --issa@fpac08.14.2006
     --issa@fpac08.14.2006, replacement, since FPAC has more than 1 open policy in marine
     IF (v_line_cd = 'MN' OR v_menu_ln_cd = 'MN') AND open_flag = 'N' THEN
        copy_pol_wves_air;
        copy_pol_wcargo;
       /* IF p_subline = subline_mrn THEN
          copy_pol_wopen_policy;
        END IF;
      */  
     --ELSIF p_subline = subline_mop THEN --issa@fpac08.14.2006
     --issa@fpac08.14.2006, replacement, since FPAC has more than 1 open policy in marine
     ELSIF (v_line_cd = 'MN' OR v_menu_ln_cd = 'MN') AND open_flag = 'Y' THEN  
    copy_pol_wopen_liab;
    copy_pol_wopen_peril;
    copy_pol_wopen_cargo;
     END IF;   
  ELSIF p_line = postpar_hull_cd THEN
 copy_pol_witem_ves;
  ELSIF p_line = postpar_aviation_cd THEN
     copy_pol_waviation_item;
  END IF;
END IF;
END;
PROCEDURE copy_pol_wves_accumulation IS
  v_issue_yy gipi_polbasic.issue_yy%TYPE;
  v_pol_seq_no gipi_polbasic.pol_seq_no%TYPE;
  CURSOR c IS SELECT vessel_cd,item_no,eta,etd,tsi_amt,rec_flag,eff_date
                FROM gipi_wves_accumulation
               WHERE par_id = postpar_par_id;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN  
  FOR A IN (
  SELECT issue_yy,pol_seq_no
    FROM gipi_polbasic
   WHERE policy_id = postpar_policy_id) LOOP
    FOR c_rec IN c LOOP
     BEGIN
      INSERT INTO gipi_ves_accumulation
                 (line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,
                  item_no,vessel_cd,eta,etd,tsi_amt,rec_flag,eff_date)
          VALUES (postpar_line_cd,postpar_subline_cd,
                  postpar_iss_cd,A.issue_yy,A.pol_seq_no,
                  c_rec.item_no,c_rec.vessel_cd,c_rec.eta,
                  c_rec.etd,c_rec.tsi_amt,c_rec.rec_flag,c_rec.eff_date);
     EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         UPDATE  gipi_ves_accumulation
            SET  vessel_cd = c_rec.vessel_cd,
                 eta       = NVL(c_rec.eta,eta),
                 etd       = NVL(c_rec.etd,etd),
                 tsi_amt   = NVL(c_rec.tsi_amt,tsi_amt),
                 rec_flag  = NVL(c_rec.rec_flag,rec_flag),
                 eff_date  = NVL(c_rec.eff_date,eff_date)
          WHERE  line_cd   = postpar_line_cd
            AND  subline_cd= postpar_subline_cd
            AND  iss_cd    = postpar_iss_cd
            AND  issue_yy  = A.issue_yy
            AND  pol_seq_no= A.pol_seq_no
            AND  item_no   = c_rec.item_no;
     END;
    END LOOP;
    EXIT;
  END LOOP;
END IF;  
END;
PROCEDURE copy_pol_witem IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  ** Revised to add region_cd to be passed from gipi_witem to gipi_item
  ** Updated by   : bdarusin
  ** Last Update  : 010303
  ** Added prorate_flag, comp_sw, short_rt_percent to be passed from gipi_witem to gipi_item
  ** Updated by   : bdarusin
  ** Last Update  : 022603
  */
BEGIN
IF skip_parid = 'N' THEN
    INSERT INTO gipi_item
               (policy_id,item_no,item_grp,item_title,item_desc,tsi_amt,
              prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,
              currency_rt,group_cd,from_date,to_date,pack_line_cd,
                pack_subline_cd,discount_sw,other_info, coverage_cd,item_desc2,
                surcharge_sw, region_cd, changed_tag, prorate_flag, comp_sw,
                short_rt_percent, PACK_BEN_CD, PAYT_TERMS, -- gmi 09/21/05 ; added columns
                risk_no, risk_item_no) -- grace 05/24/06
         SELECT postpar_policy_id,item_no,item_grp,item_title,item_desc,tsi_amt,
                prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,currency_rt,
              group_cd,from_date,to_date,pack_line_cd,
              pack_subline_cd,discount_sw,other_info, coverage_cd, item_desc2,
              surcharge_sw, region_cd, changed_tag, prorate_flag, comp_sw,
                short_rt_percent, PACK_BEN_CD, PAYT_TERMS, -- gmi 09/21/05 ; added columns
                risk_no, risk_item_no -- grace 05/24/06
           FROM gipi_witem
          WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE COPY_POL_WDISCOUNT_POLBAS IS
   cursor discount is  SELECT  line_cd,       subline_cd,    disc_rt,         
                  disc_amt,      net_gross_tag, sequence,     orig_prem_amt,
                               net_prem_amt,  last_update,   remarks,      surcharge_rt,
                               surcharge_amt
                         FROM  gipi_wpolbas_discount
                        WHERE  par_id  =  postpar_par_id;
BEGIN
IF skip_parid = 'N' THEN
 FOR D1 in DISCOUNT LOOP 
INSERT INTO gipi_polbasic_discount
           (policy_id,    line_cd,       subline_cd,    disc_rt,
            disc_amt,     net_gross_tag, sequence,      orig_prem_amt,
            net_prem_amt, last_update,   remarks,       surcharge_rt,
            surcharge_amt)
     VALUES(postpar_policy_id, D1.line_cd,       D1.subline_cd,  D1.disc_rt,
            D1.disc_amt,        D1.net_gross_tag, D1.sequence,    D1.orig_prem_amt,
            D1.net_prem_amt,    D1.last_update,   D1.remarks,     D1.surcharge_rt,
            D1.surcharge_amt);
END LOOP;
END IF;
END;
PROCEDURE COPY_POL_WDISCOUNT_ITEM IS
   cursor discount is  SELECT  line_cd,       subline_cd,    disc_rt,         
                               disc_amt,      net_gross_tag, sequence,     orig_prem_amt,   
                               net_prem_amt,  last_update,   remarks,      item_no,       
                               surcharge_rt,  surcharge_amt
                         FROM  gipi_wITEM_discount
                        WHERE  par_id  =  postpar_par_id;
BEGIN
IF skip_parid = 'N' THEN
FOR D1 in DISCOUNT LOOP 
INSERT INTO gipi_item_discount
           (policy_id,    line_cd,       subline_cd,    disc_rt,
            disc_amt,     net_gross_tag, sequence,      orig_prem_amt,
            net_prem_amt, last_update,   remarks,       item_no,
            surcharge_rt, surcharge_amt)
     VALUES(postpar_policy_id, D1.line_cd,       D1.subline_cd,  D1.disc_rt,
            D1.disc_amt,        D1.net_gross_tag, D1.sequence,    D1.orig_prem_amt,
            D1.net_prem_amt,    D1.last_update,   D1.remarks,     D1.item_no,
            D1.surcharge_rt,    D1.surcharge_amt);
END LOOP;
END IF;
END;
PROCEDURE copy_pol_wdiscount_perils IS
   cursor discount_peril is   SELECT  item_no,line_cd,peril_cd,disc_rt,disc_amt,
                                      net_gross_tag,discount_tag,sequence,
                                      level_tag,subline_cd,orig_peril_prem_amt,
                                      net_prem_amt,last_update,remarks,
                                      surcharge_rt,surcharge_amt
                                FROM  gipi_wperil_discount
                               WHERE  par_id  =  postpar_par_id;
 /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by    : Daphne
  ** Last Update   : 060798
  ** Modified by   : Loth
  ** Date modified : 090998
  */
BEGIN
IF skip_parid = 'N' THEN
  copy_pol_wdiscount_polbas;
  copy_pol_wdiscount_item;
 FOR D1 in DISCOUNT_PERIL LOOP 
INSERT INTO gipi_peril_discount
           (policy_id,item_no,line_cd,peril_cd,sequence,
            disc_rt,disc_amt,net_gross_tag,discount_tag,level_tag,
            subline_cd,orig_peril_prem_amt,
            net_prem_amt,last_update,remarks,surcharge_rt,surcharge_amt)
     VALUES(postpar_policy_id,D1.item_no,D1.line_cd,D1.peril_cd,D1.sequence,
            D1.disc_rt,D1.disc_amt,D1.net_gross_tag,D1.discount_tag,
            D1.level_tag,D1.subline_cd,D1.orig_peril_prem_amt,
            D1.net_prem_amt,D1.last_update,D1.remarks,D1.surcharge_rt,D1.surcharge_amt);
END LOOP;
END IF;
END;
PROCEDURE copy_pol_witmperl IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
IF skip_parid = 'N' THEN 
  INSERT INTO gipi_itmperil
             (policy_id,line_cd,item_no,peril_cd,tarf_cd,prem_rt,tsi_amt,
              prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,comp_rem,
              discount_sw,ri_comm_rate,ri_comm_amt,prt_flag,as_charge_sw,
              surcharge_sw, aggregate_sw, base_amt, no_of_days) --issa@fpac09.13.2006, added aggregate_sw, base_amt, no_of_days
      SELECT postpar_policy_id,line_cd,item_no,peril_cd,tarf_cd,prem_rt,tsi_amt,
             prem_amt,ann_tsi_amt,ann_prem_amt,NVL(rec_flag,'A'),comp_rem,
             discount_sw,ri_comm_rate,ri_comm_amt,prt_flag,as_charge_sw,
             surcharge_sw, aggregate_sw, base_amt, no_of_days --issa@fpac09.13.2006, added aggregate_sw, base_amt, no_of_days
        FROM gipi_witmperl
        WHERE line_cd = postpar_line_cd AND
              par_id  = postpar_par_id;
  copy_pol_wdiscount_perils;
END IF;
END;
PROCEDURE copy_pol_wgroup_item IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  ** Modified by   : Loth
  ** Date modified : 020499
  ** mod1
  ** modified by: a_poncedeleon
  ** date:        07-04-06
  ** purpose:     added field principal_cd 
  */
BEGIN
IF skip_parid = 'N' THEN
      INSERT INTO gipi_grouped_items
                  (policy_id,item_no,grouped_item_no,include_tag,grouped_item_title,
                   sex,position_cd,civil_status,date_of_birth,age,salary,salary_grade,
                   amount_coverage, remarks,line_cd, subline_cd,delete_sw, group_cd,                   
                   from_date, to_date, payt_terms, pack_ben_cd,--added columns by : gmi 09/20/05
                   ann_tsi_amt, ann_prem_amt,                  -- gmi
                   control_cd, control_type_cd,         --added columns by gmi 10/17/05
                   tsi_amt, prem_amt, principal_cd)       -- mod1 start/end   
     SELECT postpar_policy_id,item_no,grouped_item_no,include_tag,grouped_item_title,
            sex,position_cd,civil_status,date_of_birth,age,salary,salary_grade,
                   amount_covered,remarks,line_cd, subline_cd,delete_sw, group_cd,
                   from_date, to_date, payt_terms, pack_ben_cd, --added columns by : gmi 09/20/05
                   ann_tsi_amt, ann_prem_amt,                   -- gmi
                   control_cd, control_type_cd,         --added columns by gmi 10/17/05
                   tsi_amt,prem_amt, principal_cd        --mod1 start/end
             FROM gipi_wgrouped_items
            WHERE par_id  = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_wgrp_items_ben IS
/* Created By  : GRACE
   Date Created: 05/15/2000 */
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_grp_items_beneficiary
        (policy_id,item_no,grouped_item_no,beneficiary_no,beneficiary_name,
         beneficiary_addr,relation,date_of_birth,age,civil_status,sex)
  SELECT postpar_policy_id,item_no,grouped_item_no,beneficiary_no,beneficiary_name,
         beneficiary_addr,relation,date_of_birth,age,civil_status,sex
    FROM gipi_wgrp_items_beneficiary
   WHERE par_id  = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_witmperl_grouped IS
-- by: gmi 09/21/05
BEGIN
IF skip_parid = 'N' THEN
     INSERT INTO gipi_itmperil_grouped
                  (POLICY_ID, ITEM_NO, GROUPED_ITEM_NO, LINE_CD, PERIL_CD, REC_FLAG, 
                  PREM_RT, TSI_AMT, PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT, AGGREGATE_SW, 
                  BASE_AMT, NO_OF_DAYS)
     SELECT postpar_policy_id, ITEM_NO, GROUPED_ITEM_NO, LINE_CD, PERIL_CD, REC_FLAG, 
              PREM_RT, TSI_AMT, PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT, AGGREGATE_SW, 
              BASE_AMT, NO_OF_DAYS
             FROM gipi_witmperl_grouped
            WHERE par_id  = postpar_par_id;
END IF;
END;
PROCEDURE copy_pol_witmperl_beneficiary IS
-- by: gmi 09/21/05
BEGIN
IF skip_parid = 'N' THEN
     INSERT INTO gipi_itmperil_beneficiary
                  (POLICY_ID, ITEM_NO, GROUPED_ITEM_NO, BENEFICIARY_NO, 
                  LINE_CD, PERIL_CD, REC_FLAG, PREM_RT, TSI_AMT, 
                  PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT)
     SELECT postpar_policy_id,ITEM_NO, GROUPED_ITEM_NO, BENEFICIARY_NO, 
            LINE_CD, PERIL_CD, REC_FLAG, PREM_RT, TSI_AMT, 
            PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT
             FROM gipi_witmperl_beneficiary
            WHERE par_id  = postpar_par_id;
END IF;
END;
PROCEDURE COPY_POL_WPICTURES IS
/* This procedure was added by rolandmm 01/15/2004
/* This was created for the purpose of extracting information from gipi_wpictures
** and inserting this information to gipi_pictures.
** Modified by Lhen 031904
*/
  v_item   gipi_pictures.item_no%TYPE;
  v_file   gipi_pictures.file_name%TYPE;
  v_file_type gipi_pictures.file_type%TYPE;
  v_file_ext gipi_pictures.file_ext%TYPE;
  v_remarks  gipi_pictures.remarks%TYPE;
  v_exist   varchar2(1) := 'N';
BEGIN
IF skip_parid = 'N' THEN
/**  INSERT INTO gipi_pictures
              (policy_id,item_no,file_name,file_type,
               file_ext,remarks,user_id,last_update)
       SELECT postpar_policy_id,item_no,file_name,file_type,
               file_ext,remarks,user_id,last_update
         FROM gipi_wpictures
        WHERE par_id = postpar_par_id;**/--commented out by Lhen 031904
  FOR pol IN (
    SELECT 'a'
      FROM gipi_wpictures
     WHERE par_id = postpar_par_id ) 
  LOOP
   v_exist := 'Y';
   EXIT;
  END LOOP;  
  IF v_exist = 'Y' THEN
     FOR pic IN (
       SELECT item_no,     
           file_name, 
           file_type, 
           file_ext, 
           remarks
         FROM gipi_wpictures
        WHERE par_id = postpar_par_id) 
     LOOP
       v_item    := pic.item_no;
       v_file    := pic.file_name;
       v_file_type := pic.file_type;
       v_file_ext  := pic.file_ext;
       v_remarks  := pic.remarks;
       INSERT INTO gipi_pictures(
         policy_id,         item_no, 
         file_name,      file_type, 
         file_ext,       remarks, 
         user_id,       last_update, 
         pol_file_name)
       VALUES ( 
         postpar_policy_id, v_item,
         v_file,            v_file_type,
         v_file_ext,     v_remarks,
         user,        trunc(sysdate),
         null);
         v_item    := NULL;
         v_file    := NULL;
         v_file_type := NULL;
         v_file_ext  := NULL;
         v_remarks  := NULL;
       END LOOP;
    END IF;
END IF;
END;
 PROCEDURE copy_pol_wdeductibles IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
  v_exist VARCHAR2(1) := 'N'; --**gmi**--
 BEGIN
 IF skip_parid = 'N' THEN
  --**gmi 09/26/05**-- 
  --added condition to determine whether gipi_wdeductibles have existing record or not--
  --insert process is halt if there are no records to transfer--
  FOR a IN (SELECT 1 
            FROM gipi_wdeductibles
           WHERE par_id = postpar_par_id) LOOP
  v_exist := 'Y';
  EXIT;
  END LOOP;
  IF v_exist = 'Y' THEN         
       INSERT INTO gipi_deductibles(
            policy_id, item_no, ded_line_cd, ded_subline_cd, ded_deductible_cd,
            deductible_text,deductible_amt, deductible_rt, peril_cd)
            SELECT postpar_policy_id,item_no,ded_line_cd,ded_subline_cd,ded_deductible_cd,
                   deductible_text,deductible_amt, deductible_rt, peril_cd
              FROM gipi_wdeductibles
             WHERE par_id  =  postpar_par_id;
  ELSE
   null;
  END IF;
END IF;  
 END;
PROCEDURE post_pol_par IS
 v_menu_ln_cd        giis_line.menu_line_cd%TYPE;
BEGIN
IF skip_parid = 'N' THEN
  copy_pol_wpolbas;
  copy_pol_wpolgenin;
  copy_pol_wpolnrep;
  IF postpar_iss_cd = issue_ri THEN
     copy_pol_winpolbas;
  END IF;
  IF postpar_pack = 'Y' THEN
     copy_pol_wpack_line_subline;
  END IF;  
  IF postpar_pack = 'Y' THEN
    FOR A IN (SELECT   a.pack_line_cd line_cd, a.pack_subline_cd subline_cd,
                       b.item_no
                FROM   gipi_wpack_line_subline a, gipi_witem b
               WHERE   a.pack_subline_cd = b.pack_subline_cd
                 AND   a.pack_line_cd    = b.pack_line_cd
                 AND   a.par_id          = b.par_id
                 AND   a.par_id          =  postpar_par_id) LOOP
          v_menu_ln_cd := NULL;
          FOR menu_line IN ( SELECT menu_line_cd code
                               FROM giis_line
                              WHERE line_cd = A.line_cd )
          LOOP     
             v_menu_ln_cd := menu_line.code;
             v_menu_ln_cd  := menu_line.code; --issa@fpac08.14.2006 
          END LOOP;
      IF (v_menu_ln_cd = 'MN' OR A.line_cd = postpar_cargo_cd)AND open_flag = 'Y' THEN
         NULL;
      ELSE
         IF A.line_cd != postpar_accident_cd THEN
--           copy_pol_winspection; -- 081699 Commented by loth table has been dropped
           copy_pol_wlim_liab;
         END IF;        
         copy_pol_witem2(A.line_cd,A.subline_cd);
      END IF;
      IF (v_menu_ln_cd = 'AC' OR A.line_cd = postpar_accident_cd) THEN
         copy_pol_wbeneficiary;
         copy_pol_waccident_item;  -- ramil 09/03/96
         copy_pol_wgroup_pack_item(a.item_no);     -- beth 11/05/98 loth 080499
         copy_pol_wgrp_pack_item_ben(a.item_no);   -- grace 05/15/00
         copy_pol_witmperl_pack_grouped(a.item_no); --gmi 09/20/05
         copy_pol_witmperl_pack_ben(a.item_no); --gmi 09/20/05
         copy_pol_pack_wdeductibles(a.item_no);
      ELSIF (v_menu_ln_cd = 'CA' OR A.line_cd = postpar_casualty_cd) THEN
         copy_pol_wbank_sched;
         copy_pol_wcasualty_item;
         copy_pol_wcasualty_personnel;
         copy_pol_pack_wdeductibles(a.item_no);
         copy_pol_wgroup_pack_item(a.item_no);     -- beth 11/05/98 loth 080499
         copy_pol_wgrp_pack_item_ben(a.item_no);   -- grace 05/15/00
         copy_pol_witmperl_pack_grouped(a.item_no); --gmi 09/20/05
         copy_pol_witmperl_pack_ben(a.item_no); --gmi 09/20/05
      ELSIF (v_menu_ln_cd = 'EN' OR A.line_cd = postpar_engrng_cd) THEN
         copy_pol_wengg_basic;
         copy_pol_wprincipal;
         copy_pol_pack_wdeductibles(a.item_no);
         BEGIN
           SELECT param_value_v
             INTO subline_bpv
             FROM giis_parameters
            WHERE param_name = bpv;
   IF SQL%NOTFOUND THEN
    null;
   END IF;   
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
              pre_post_error(v_par_id, 'No record in giis_parameters for engrng. subline '||postpar_subline_cd);
         END;
         IF A.subline_cd = subline_bpv THEN
            copy_pol_wlocation;
         END IF;
      ELSIF (v_menu_ln_cd = 'FI' OR A.line_cd = postpar_fire_cd) THEN      
         check_zone_type; -- Grace 02/13/2001
         copy_pol_wfire;
         copy_pol_pack_wdeductibles(a.item_no);
      ELSIF (v_menu_ln_cd = 'MC' OR A.line_cd = postpar_motor_cd) THEN      
         copy_pol_wvehicle;
         copy_pol_wmcacc;
         copy_pol_pack_wdeductibles(a.item_no);     -- beth 11/05/98
      ELSIF (v_menu_ln_cd = 'SU' OR A.line_cd = postpar_surety_cd)  THEN
         copy_pol_wbond_basic;
         copy_pol_wcosigntry;
         copy_pol_pack_wdeductibles(a.item_no);
         update_collateral_par;
      ELSIF v_menu_ln_cd IN ('MH','MN','AV') OR (A.line_cd IN
           (postpar_hull_cd,postpar_cargo_cd,postpar_aviation_cd)) THEN
         copy_pol_wcargo_hull(A.line_cd,A.subline_cd);
         IF A.line_cd = postpar_cargo_cd THEN
            copy_pol_wves_accumulation;            
         END IF;
         copy_pol_pack_wdeductibles(a.item_no);
     END IF; 
  END LOOP;
  --BETH 01-06-2000 
  FOR CHK_OPEN IN
      ( SELECT '1'
          FROM giis_subline
         WHERE line_cd = postpar_line_cd
           AND subline_cd = postpar_subline_cd
           AND NVL(open_policy_sw,'N') = 'Y'
      ) LOOP
       copy_pol_wopen_policy;
 END LOOP;            
  copy_pol_wreqdocs;
  copy_pol_wpolwc;
  copy_pol_wmortgagee;
  copy_pol_winvoice;
  update_co_ins; --BETH 020699
ELSE    
      v_menu_ln_cd := NULL;      
      FOR menu_line IN ( SELECT menu_line_cd code
                         FROM giis_line
                        WHERE line_cd = postpar_line_cd )
      LOOP
       v_menu_ln_cd := menu_line.code;
      END LOOP;                       
      IF (v_menu_ln_cd = 'MN' OR postpar_line_cd = postpar_cargo_cd )
         AND open_flag = 'Y' THEN 
         copy_pol_witem;   --BETH   transfer data from gipi_witem and gipi_witmperl to
         copy_pol_witmperl;--011399 its final table
         copy_pol_winvoice;--032999 loth
      ELSE
         IF postpar_line_cd != postpar_accident_cd THEN
--           copy_pol_winspection; -- 081699 Commented by loth table has been dropped
           copy_pol_wlim_liab;
         END IF;
         --BETH 01-06-2000 
         FOR CHK_OPEN IN
            ( SELECT '1'
                FROM giis_subline
               WHERE line_cd = postpar_line_cd
                 AND subline_cd = postpar_subline_cd
                 AND NVL(open_policy_sw,'N') = 'Y'
             ) LOOP
             copy_pol_wopen_policy;
         END LOOP;    
         IF open_flag = 'Y' THEN
            copy_pol_wopen_liab;
            copy_pol_wopen_peril;
         END IF;
         copy_pol_wreqdocs;
         copy_pol_witem; 
         copy_pol_witmperl;
         copy_pol_winvoice;
         update_co_ins; --BETH 020699
         copy_pol_wmortgagee;
      END IF;      
      copy_pol_wpolwc;
      IF (v_menu_ln_cd = 'AC' OR postpar_line_cd = postpar_accident_cd) THEN
         copy_pol_wbeneficiary;
         copy_pol_waccident_item;  -- ramil 09/03/96
         copy_pol_wgroup_item;     -- beth 11/05/98
         copy_pol_wgrp_items_ben;  -- grace 05/15/00
         copy_pol_witmperl_grouped; -- gmi 09/21/05
         copy_pol_witmperl_beneficiary; --gmi 09/21/05
         copy_pol_wpictures;       -- rolandmm 01/16/04
         copy_pol_wdeductibles;
      ELSIF (v_menu_ln_cd = 'CA' OR postpar_line_cd = postpar_casualty_cd) THEN
         copy_pol_wbank_sched;
         copy_pol_wcasualty_item;
        copy_pol_wcasualty_personnel;
         copy_pol_wdeductibles;
         copy_pol_wgroup_item;     -- beth 11/05/98
         copy_pol_wgrp_items_ben;  -- grace 05/15/00
         copy_pol_witmperl_grouped; -- gmi 09/21/05
         copy_pol_witmperl_beneficiary; --gmi 09/21/05    
         copy_pol_wpictures;       -- rolandmm 01/16/04      
      ELSIF (v_menu_ln_cd = 'EN' OR postpar_line_cd = postpar_engrng_cd) THEN
         copy_pol_wengg_basic;
         copy_pol_wprincipal;
         copy_pol_wdeductibles;
         copy_pol_wpictures;       -- rolandmm 01/16/04
         BEGIN
           SELECT param_value_v
             INTO subline_bpv
             FROM giis_parameters
            WHERE param_name = bpv;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
              pre_post_error(v_par_id,'No record in giis_parameters for engrng. subline '||postpar_subline_cd);
         END;
         IF postpar_subline_cd = subline_bpv THEN
            copy_pol_wlocation;
         END IF;
      ELSIF (v_menu_ln_cd = 'FI' OR postpar_line_cd = postpar_fire_cd) THEN
         check_zone_type;          -- Grace 02/13/2001
         copy_pol_wpictures;       -- rolandmm 01/16/04
         copy_pol_wfire;
         copy_pol_wdeductibles;
      ELSIF (v_menu_ln_cd = 'MC' OR postpar_line_cd = postpar_motor_cd) THEN
         copy_pol_wvehicle;
         copy_pol_wmcacc;
         copy_pol_wdeductibles;    -- beth 11/05/98
         copy_pol_wpictures;       -- rolandmm 01/16/04
      ELSIF (v_menu_ln_cd = 'SU' OR postpar_line_cd = postpar_surety_cd) THEN
         copy_pol_wbond_basic;
         copy_pol_wcosigntry;
         copy_pol_wdeductibles;
         update_collateral_par;
      ELSIF v_menu_ln_cd IN ('MN','MH','AV') OR (postpar_line_cd IN
           (postpar_hull_cd,postpar_cargo_cd,postpar_aviation_cd)) THEN
         copy_pol_wcargo_hull(postpar_line_cd,postpar_subline_cd);
         copy_pol_wpictures;       -- rolandmm 01/16/04
         IF NVL(v_menu_ln_cd,postpar_line_cd) = postpar_cargo_cd THEN
            copy_pol_wves_accumulation;
         END IF;
         copy_pol_wdeductibles;
     ELSE 
         copy_pol_wbeneficiary;
         copy_pol_wdeductibles;
         copy_pol_wpictures;       -- rolandmm 01/16/04
     END IF;
  END IF;
END IF;
END;
PROCEDURE read_into_postpar IS
BEGIN
IF skip_parid = 'N' THEN    
  SELECT param_value_v INTO postpar_accident_cd
    FROM giis_parameters
   WHERE param_name = 'LINE_CODE_AC';
  SELECT param_value_v INTO postpar_aviation_cd
    FROM giis_parameters
   WHERE param_name = 'LINE_CODE_AV';
  SELECT param_value_v INTO postpar_casualty_cd
    FROM giis_parameters
   WHERE param_name = 'LINE_CODE_CA';
  SELECT param_value_v INTO postpar_engrng_cd
    FROM giis_parameters
   WHERE param_name = 'LINE_CODE_EN';
  SELECT param_value_v INTO postpar_fire_cd
    FROM giis_parameters
   WHERE param_name = 'LINE_CODE_FI';
  SELECT param_value_v INTO postpar_motor_cd
    FROM giis_parameters
   WHERE param_name = 'LINE_CODE_MC';
  SELECT param_value_v INTO postpar_hull_cd
    FROM giis_parameters
   WHERE param_name = 'LINE_CODE_MH';
  SELECT param_value_v INTO postpar_cargo_cd
    FROM giis_parameters
   WHERE param_name = 'LINE_CODE_MN';
  SELECT param_value_v INTO postpar_surety_cd
    FROM giis_parameters
   WHERE param_name = 'LINE_CODE_SU';
END IF;        
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       PRE_POST_ERROR(v_par_id, 'No parameter record found. Please report error to CSD');         
END;
/* Created by   : iris bordey
**    date      : 08.28.2003
** Modification : 2. To update refresh_sw of gicl_claims when posting with
                     pending claims.
*/
PROCEDURE update_pending_claims IS
BEGIN
IF skip_parid = 'N' THEN
   FOR d IN (SELECT a.claim_id
                FROM gicl_claims a
               WHERE 1=1
                 AND a.line_cd        = postpar_line_cd
                 AND a.subline_cd     = postpar_subline_cd
                 AND a.pol_iss_cd     = postpar_iss_cd 
                 AND a.issue_yy       = postpar_issue_yy 
                 AND a.pol_seq_no     = postpar_pol_seq_no
                 AND a.renew_no       = postpar_renew_no
                 AND a.dsp_loss_date >= eff_date)
   LOOP
    UPDATE gicl_claims
        SET refresh_sw = 'Y'
      WHERE claim_id   = d.claim_id;
   END LOOP;
END IF;               
END;
PROCEDURE upd_back_endt IS
  v_eff_date          gipi_wpolbas.eff_date%TYPE;
  v_endt_expiry_date  gipi_wpolbas.eff_date%TYPE;
  v_expiry_date       gipi_wpolbas.eff_date%TYPE;
  v_line_cd           gipi_wpolbas.line_cd%TYPE;
  v_subline_cd        gipi_wpolbas.subline_cd%TYPE;
  v_iss_cd            gipi_wpolbas.iss_cd%TYPE;   
  v_issue_yy          gipi_wpolbas.issue_yy%TYPE;
  v_pol_seq_no        gipi_wpolbas.pol_seq_no%TYPE;
  v_renew_no          gipi_wpolbas.renew_no%TYPE;
  v_prorate           gipi_witmperl.prem_rt%TYPE;
  v_comp_prem         gipi_witmperl.tsi_amt%TYPE;
  v_prorate_flag      gipi_wpolbas.prorate_flag%TYPE;
  v_short_rt          gipi_wpolbas.short_rt_percent%TYPE;
  v_comp_sw           gipi_wpolbas.comp_sw%TYPE;
BEGIN
IF skip_parid = 'N' THEN
  FOR eff_dt IN
      ( SELECT eff_date,endt_expiry_date, expiry_date, line_cd, subline_cd, iss_cd, 
               issue_yy, pol_seq_no, renew_no,prorate_flag, short_rt_percent,comp_sw
          FROM gipi_wpolbas
         WHERE par_id = postpar_par_id
       )LOOP
       v_eff_date := eff_dt.eff_date;
       v_endt_expiry_date := eff_dt.endt_expiry_date;
       v_expiry_date := eff_dt.expiry_date;
       v_line_cd  := eff_dt.line_cd;
       v_subline_cd := eff_dt.subline_cd;
       v_iss_cd := eff_dt.iss_cd;
       v_issue_yy := eff_dt.issue_yy;
       v_pol_seq_no := eff_dt.pol_seq_no;
       v_renew_no := eff_dt.renew_no;
       v_prorate_flag := eff_dt.prorate_flag;
       v_comp_sw  := eff_dt.comp_sw;
       v_short_rt := eff_dt.short_rt_percent;
       EXIT;
  END LOOP;   
  FOR itmperl IN
      ( SELECT b480.item_no,  b480.currency_rt, a170.peril_type,
               b490.peril_cd, b490.tsi_amt, b490.prem_amt
          FROM gipi_witem b480, gipi_witmperl b490, giis_peril a170
         WHERE b480.par_id = b490.par_id
           AND b480.item_no =b490.item_no
           AND b490.line_cd = a170.line_cd
           AND b490.peril_cd = a170.peril_cd
           AND b490.par_id = postpar_par_id
      )LOOP
        v_comp_prem := NULL;
        IF v_prorate_flag = 1 THEN
           IF v_endt_expiry_date <= v_eff_date THEN
              pre_post_error(v_par_id,'Your endorsement expiry date is equal to or less than your effectivity date.'||
                        ' Restricted condition.');
           ELSE
              IF v_comp_sw = 'Y' THEN
                 v_prorate  :=  ((TRUNC( v_endt_expiry_date) - TRUNC(v_eff_date )) + 1 )/
                                (ADD_MONTHS(v_eff_date,12) - v_eff_date);
              ELSIF v_comp_sw = 'M' THEN
                 v_prorate  :=  ((TRUNC( v_endt_expiry_date) - TRUNC(v_eff_date )) - 1 )/
                                (ADD_MONTHS(v_eff_date,12) - v_eff_date);
              ELSE 
                 v_prorate  :=  (TRUNC( v_endt_expiry_date) - TRUNC(v_eff_date ))/
                             (ADD_MONTHS(v_eff_date,12) - v_eff_date);
              END IF;
           END IF;
           v_comp_prem  := itmperl.prem_amt/v_prorate;
        ELSIF v_prorate_flag = 2 THEN
           v_comp_prem  := itmperl.prem_amt;
        ELSE
           v_comp_prem :=  itmperl.prem_amt/(v_short_rt/100);  
        END IF;
      FOR A1 IN
          ( SELECT policy_id
              FROM gipi_polbasic b250
             WHERE b250.line_cd = v_line_cd
               AND b250.subline_cd = v_subline_cd
               AND b250.iss_cd = v_iss_cd
               AND b250.issue_yy = v_issue_yy
               AND b250.pol_seq_no = v_pol_seq_no
               AND b250.renew_no = v_renew_no
               AND b250.eff_date > v_eff_date
               AND b250.endt_seq_no > 0 
               AND b250.pol_flag in('1','2','3')  
               AND NVL(b250.endt_expiry_date,b250.expiry_date) >=  v_eff_date
          )LOOP
          FOR PERL IN 
              ( SELECT '1'
                  FROM gipi_itmperil b380
                 WHERE b380.item_no = itmperl.item_no
                   AND b380.peril_cd = itmperl.peril_cd  
                   AND b380.policy_id = a1.policy_id
               ) LOOP
               UPDATE gipi_itmperil
                  SET ann_tsi_amt  = ann_tsi_amt + itmperl.tsi_amt,
                      ann_prem_amt = ann_prem_amt + NVL(v_comp_prem,itmperl.prem_amt)
                WHERE policy_id = a1.policy_id
                  AND item_no = itmperl.item_no
                  AND peril_cd = itmperl.peril_cd;
          END LOOP;
          IF itmperl.peril_type = 'B' THEN
             UPDATE gipi_item
                SET ann_tsi_amt  = ann_tsi_amt + itmperl.tsi_amt,
                    ann_prem_amt = ann_prem_amt + NVL(v_comp_prem,itmperl.prem_amt)
              WHERE policy_id = a1.policy_id
                AND item_no = itmperl.item_no;
             UPDATE gipi_polbasic
                SET ann_tsi_amt  = ann_tsi_amt + ROUND((itmperl.tsi_amt * NVL(itmperl.currency_rt,1)),2),
                    ann_prem_amt = ann_prem_amt + ROUND((NVL(v_comp_prem,itmperl.prem_amt) * NVL(itmperl.currency_rt,1)),2)
              WHERE policy_id = a1.policy_id;
          ELSE
             UPDATE gipi_item
                SET ann_prem_amt = ann_prem_amt + NVL(v_comp_prem,itmperl.prem_amt)
              WHERE policy_id = a1.policy_id
                AND item_no = itmperl.item_no;
             UPDATE gipi_polbasic
                SET ann_prem_amt = ann_prem_amt + ROUND((NVL(v_comp_prem,itmperl.prem_amt) * NVL(itmperl.currency_rt,1)),2)
              WHERE policy_id = a1.policy_id;
          END IF;
      END LOOP;
  END LOOP;      
END IF;
END;
PROCEDURE update_par_status IS
BEGIN
IF skip_parid = 'N' THEN
  FOR A IN (
     SELECT par_id ,par_status
       FROM gipi_parlist
      WHERE par_id = v_par_id
     FOR UPDATE OF par_id, par_status) LOOP
     UPDATE gipi_parlist
        SET par_status = 10
      WHERE par_id = v_par_id;
     EXIT;
  END LOOP;
END IF;
END;
PROCEDURE insert_parhist IS
BEGIN
IF skip_parid = 'N' THEN
  INSERT INTO gipi_parhist
             (par_id,user_id,parstat_date,entry_source,parstat_cd)
       VALUES(v_par_id,USER,SYSDATE,
              NULL,'10');
END IF;
END;
PROCEDURE dist_giuw_pol_dist IS
  v_endt_type  gipi_polbasic.endt_type%TYPE;
  v_tsi_amt  gipi_polbasic.tsi_amt%TYPE;
  v_prem_amt  gipi_polbasic.prem_amt%TYPE;
  v_ann_tsi_amt  gipi_polbasic.ann_tsi_amt%TYPE;
  v_eff_date  gipi_polbasic.eff_date%TYPE;
  v_expiry_date  gipi_polbasic.expiry_date%TYPE;
  v_user_id  gipi_polbasic.user_id%TYPE;
BEGIN
IF skip_parid = 'N' THEN
  BEGIN
    SELECT pol_dist_dist_no_s.NEXTVAL
      INTO postpar_dist_no 
      FROM DUAL;
  EXCEPTION
    WHEN NO_DATA_FOUND then
         pre_post_error(v_par_id,'Cannot generate new POLICY ID.');
  END;
  SELECT endt_type,NVL(tsi_amt,0),NVL(prem_amt,0),NVL(ann_tsi_amt,0),eff_date,expiry_date,user_id
    INTO v_endt_type,v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_eff_date,v_expiry_date,v_user_id
    FROM gipi_polbasic
   WHERE policy_id = postpar_policy_id;
  /* modified by bdarusin
  ** modified on jan312003
  ** changed 'user_id' into v_user_id*/
  INSERT INTO giuw_pol_dist
              (dist_no,par_id,policy_id,endt_type,tsi_amt,prem_amt,ann_tsi_amt,dist_flag,
              redist_flag,eff_date,expiry_date,negate_date,dist_type,item_posted_sw,ex_loss_sw,
              acct_ent_date,acct_neg_date,create_date,user_id,last_upd_date,auto_dist)
       VALUES (postpar_dist_no,postpar_par_id,postpar_policy_id,v_endt_type,
              v_tsi_amt,v_prem_amt,v_ann_tsi_amt,'1',1,v_eff_date,v_expiry_date,NULL,'1',
              --'N','N',NULL,NULL,SYSDATE,'user_id',SYSDATE,'N');
              'N','N',NULL,NULL,SYSDATE,v_user_id,SYSDATE,'N');
END IF;
END;
/* Create default distribution records in all distribution tables namely:
** GIUW_WPOLICYDS, GIUW_WPOLICYDS_DTL, GIUW_WITEMDS, GIUW_WITEMDS_DTL,
** GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL, GIUW_WPERILDS and GIUW_WPERILDS_DTL.
** The default records inserted to the detail tables were driven from the default
** distribution tables:  GIIS_DEFAULT_DIST, GIIS_DEFAULT_DIST_GROUP and 
** GIIS_DEFAULT_DIST_PERIL. */
PROCEDURE process_distribution(v_check_on OUT NUMBER) IS
  loc_par_id      giuw_pol_dist.par_id%TYPE;
  loc_policy_id  giuw_pol_dist.policy_id%TYPE;
  var           VARCHAR2(1) := 'N';
BEGIN
IF skip_parid = 'N' THEN
  SELECT par_id,dist_no,policy_id
    INTO loc_par_id,postpar_dist_no,loc_policy_id
    FROM giuw_pol_dist
   WHERE par_id = postpar_par_id;
  IF loc_policy_id IS NULL THEN
     UPDATE giuw_pol_dist
        SET policy_id = postpar_policy_id
      WHERE par_id = postpar_par_id;
  END IF;
  --beth 06212000 if auto_dist = 'Y' update tables giuw_pol_dist and gipi_polbasic
  FOR A IN (SELECT '1'
              FROM giuw_pol_dist
             WHERE par_id = postpar_par_id
               AND auto_dist = 'Y')             
  LOOP             
   var := 'Y';
    UPDATE giuw_pol_dist
       SET dist_flag = '3',
           post_flag = 'P',
           user_id   = USER, 
           last_upd_date =SYSDATE
     WHERE par_id = postpar_par_id;
    UPDATE gipi_polbasic
       SET dist_flag = '3'
     WHERE policy_id = postpar_policy_id;
    EXIT;
  END LOOP;    
  BEGIN
    SELECT dist_no
      INTO postpar_dist_no
      FROM giuw_wpolicyds
     WHERE dist_no = postpar_dist_no;
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
         NULL;
    WHEN NO_DATA_FOUND THEN
      /* Create records in distribution tables GIUW_WPOLICYDS, GIUW_WPOLICYDS_DTL,
      ** GIUW_WITEMDS, GIUW_WITEMDS_DTL, GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
      ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
      IF var = 'N' THEN
         /*CREATE_PAR_DISTRIBUTION_RECS
            (postpar_dist_no    , postpar_par_id , postpar_line_cd ,
             postpar_subline_cd , postpar_iss_cd , postpar_pack);*/ --gmi LAST
    v_check_on := 1;
      ELSE
        NULL;
      END IF;  
  END;
END IF;  
EXCEPTION 
  WHEN NO_DATA_FOUND THEN   
    dist_giuw_pol_dist;
    v_check_on := 1;
    /* Create records in distribution tables GIUW_WPOLICYDS, GIUW_WPOLICYDS_DTL,
    ** GIUW_WITEMDS, GIUW_WITEMDS_DTL, GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
    ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
    /*CREATE_PAR_DISTRIBUTION_RECS
          (postpar_dist_no    , postpar_par_id , postpar_line_cd , 
           postpar_subline_cd , postpar_iss_cd , postpar_pack);*/ --gmi LAST
END;
/* Delete existing records related to the current DIST_NO from the 
** distribution and RI working tables.
** Distribution tables affected:
**      GIUW_WPERILDS  and DTL, GIUW_WITEMPERILDS and DTL, GIUW_WITEMDS and DTL
**      ,and GIUW_WPOLICYDS and DTL.
** RI tables affected:
**      GIRI_WBINDER_PERIL, GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI and
**      GIRI_WDISTFRPS */
PROCEDURE DELETE_DIST_WORKING_TABLES (v_dist_no giuw_pol_dist.dist_no%TYPE) IS
BEGIN
IF skip_parid = 'N' THEN
  DELETE giuw_wperilds_dtl
   WHERE dist_no = v_dist_no;
  DELETE giuw_wperilds
   WHERE dist_no = v_dist_no;
  DELETE giuw_witemperilds_dtl
   WHERE dist_no = v_dist_no;
  DELETE giuw_witemperilds
   WHERE dist_no = v_dist_no;
  DELETE giuw_witemds_dtl
   WHERE dist_no = v_dist_no;
  DELETE giuw_witemds
   WHERE dist_no = v_dist_no;
  DELETE giuw_wpolicyds_dtl
   WHERE dist_no = v_dist_no;
  FOR c1 IN (SELECT frps_yy, frps_seq_no
               FROM giri_wdistfrps
              WHERE dist_no = v_dist_no)
  LOOP
    FOR c2 IN (SELECT pre_binder_id
                 FROM giri_wfrps_ri
                WHERE frps_yy     = c1.frps_yy 
                  AND frps_seq_no = c1.frps_seq_no) 
    LOOP
      DELETE giri_wbinder_peril
       WHERE pre_binder_id = c2.pre_binder_id; 
      DELETE giri_wbinder
       WHERE pre_binder_id = c2.pre_binder_id;
    END LOOP;
    DELETE giri_wfrperil
     WHERE frps_yy     = c1.frps_yy
       AND frps_seq_no = c1.frps_seq_no;
    DELETE giri_wfrps_ri
     WHERE frps_yy     = c1.frps_yy
       AND frps_seq_no = c1.frps_seq_no;
  END LOOP;
  DELETE giri_wdistfrps
   WHERE dist_no = v_dist_no;
  DELETE giuw_wpolicyds
   WHERE dist_no = v_dist_no;
END IF;   
END;
--BETH 03/14/2001
--     This procedure checks for the existance of records in the following distribution tables:
--     GIUW_WPOLICYDS 
--     GIUW_WITEMDS  
--     GIUW_WITEMPERILDS  
--     GIUW_WPERILDS   
--     if missing records are detected recreation of distribution records would be done
PROCEDURE VALIDATE_EXISTING_WORKING_DIST(p_dist_no giuw_pol_dist.dist_no%TYPE,
                                         p_check_on OUT NUMBER) IS
  v_hdr_sw   VARCHAR2(1); --field that used as a switch to determing if records rexist in header table
  v_dtl_sw   VARCHAR2(1); --field that used as a switch to determing if records rexist in header table
  v_check_on NUMBER:= 0;
BEGIN
IF skip_parid = 'N' THEN
 v_hdr_sw := 'N';
  --check if there are records in giuw_wpolicyds
  FOR A IN (SELECT dist_no, dist_seq_no
              FROM giuw_wpolicyds
             WHERE dist_no = p_dist_no)
  LOOP  
   v_hdr_sw := 'Y';
   v_dtl_sw := 'N';
   --check if there are records corresponding records in giuw_wpolicyds_dtl  
   -- for every record in giuw_wpolicyds 
   FOR B IN (SELECT '1'
               FROM giuw_wpolicyds_dtl
              WHERE dist_no = a.dist_no
                AND dist_seq_no = a.dist_seq_no)
   LOOP            
    v_dtl_sw := 'Y';
    EXIT;
   END LOOP;  
   IF v_dtl_sw = 'N' THEN
     EXIT; 
   END IF;
  END LOOP;
  IF v_hdr_sw = 'N' or v_dtl_sw = 'N' THEN  --records not existing
    --delete first all existing data in preliminary dist. table 
    DELETE_DIST_WORKING_TABLES(p_dist_no);
  v_check_on := 1;                      
    --recreate data in preliminary dist. table 
     /*CREATE_PAR_DISTRIBUTION_RECS
     (p_dist_no    , postpar_par_id , postpar_line_cd , 
     postpar_subline_cd , postpar_iss_cd , postpar_pack);*/ --gmi
  ELSE
     v_hdr_sw := 'N';
     --check if there are records in giuw_witemds
     FOR A IN (SELECT dist_no, dist_seq_no, item_no
                 FROM giuw_witemds
                WHERE dist_no = p_dist_no)
     LOOP  
      v_hdr_sw := 'Y';
      v_dtl_sw := 'N';
      --check if there are records corresponding records in giuw_witemds_dtl  
      -- for every record in giuw_witemds 
      FOR B IN (SELECT '1'
                  FROM giuw_witemds_dtl
                 WHERE dist_no = a.dist_no
                   AND dist_seq_no = a.dist_seq_no
                   AND item_no = a.item_no)
      LOOP            
       v_dtl_sw := 'Y';
       EXIT;
      END LOOP;  
      IF v_dtl_sw = 'N' THEN
         EXIT;
      END IF;
     END LOOP;
     IF v_hdr_sw = 'N' or v_dtl_sw = 'N' THEN --records not existing
       --delete first all existing data in preliminary dist. table 
       DELETE_DIST_WORKING_TABLES(p_dist_no);
   v_check_on := 1;                        
       --recreate data in preliminary dist. table 
        /*CREATE_PAR_DISTRIBUTION_RECS
        (p_dist_no    , postpar_par_id , postpar_line_cd , 
        postpar_subline_cd , postpar_iss_cd , postpar_pack);*/ --gmi last
     ELSE
        v_hdr_sw := 'N';
        --check if there are records in giuw_witemperilds
        FOR A IN (SELECT t1.dist_no, t1.dist_seq_no, t1.item_no, t1.peril_cd
                    FROM giuw_witemperilds t1
                   WHERE t1.dist_no  = p_dist_no)
        LOOP  
         v_hdr_sw := 'Y';
         v_dtl_sw := 'N';
         --check if there are records corresponding records in giuw_witemperilds_dtl  
         -- for every record in giuw_witemperilds 
         FOR B IN (SELECT '1'
                     FROM giuw_witemperilds_dtl
                    WHERE dist_no = a.dist_no
                      AND dist_seq_no = a.dist_seq_no
                      AND item_no = a.item_no
                      AND peril_cd = a.peril_cd)
         LOOP            
          v_dtl_sw := 'Y';
          EXIT;
         END LOOP;  
         IF v_dtl_sw = 'N' THEN
            EXIT;
         END IF;
        END LOOP;
        IF v_hdr_sw = 'N' or v_dtl_sw = 'N' THEN--records not existing
         --delete first all existing data in preliminary dist. table 
         DELETE_DIST_WORKING_TABLES(p_dist_no);
        v_check_on := 1;                          
         --recreate data in preliminary dist. table 
          /*CREATE_PAR_DISTRIBUTION_RECS
          (p_dist_no    , postpar_par_id , postpar_line_cd , 
          postpar_subline_cd , postpar_iss_cd , postpar_pack);*/ --gmi last
        ELSE
           v_hdr_sw := 'N';
           --check if there are records in giuw_wperilds
           FOR A IN (SELECT t1.dist_no, t1.dist_seq_no, t1.peril_cd
                       FROM giuw_wperilds t1
                      WHERE t1.dist_no  = p_dist_no)
           LOOP  
            v_hdr_sw := 'Y';
            v_dtl_sw := 'N';
            --check if there are records corresponding records in giuw_wperilds_dtl  
            -- for every record in giuw_wperilds 
            FOR B IN (SELECT '1'
                        FROM giuw_wperilds_dtl
                       WHERE dist_no = a.dist_no
                         AND dist_seq_no = a.dist_seq_no
                         AND peril_cd = a.peril_cd)
            LOOP            
             v_dtl_sw := 'Y';
             EXIT;
            END LOOP;  
            IF v_dtl_sw = 'N' THEN
               EXIT;
            END IF;
           END LOOP;
           IF v_hdr_sw = 'N' or v_dtl_sw = 'N' THEN --records not existing
             --delete first all existing data in preliminary dist. table 
             DELETE_DIST_WORKING_TABLES(p_dist_no);
     v_check_on := 1;                      
             --recreate data in preliminary dist. table 
              /*CREATE_PAR_DISTRIBUTION_RECS
              (p_dist_no    , postpar_par_id , postpar_line_cd , 
              postpar_subline_cd , postpar_iss_cd , postpar_pack);*/ --gmi last
           END IF;
        END IF;   
     END IF; 
  END IF;
  p_check_on := v_check_on;
END IF;
END;
PROCEDURE copy_pol_wendttext IS
  --p_endt_tax        gipi_endtttext.endt_tax%TYPE;
  p_endt_tax        VARCHAR2(1);
  p_endt_cd     VARCHAR2(4);
  p_user_id         gipi_endttext.user_id%TYPE;
  p_last_update     gipi_endttext.last_update%TYPE;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
  /* beth 02132001 add transfering of field endt_tax from work to final table*/
  /* loreen 04012005 add transfering of field endt_cd from work to final table*/
BEGIN
IF skip_parid = 'N' THEN
  SELECT endt_text01,endt_text02,endt_text03,endt_text04,endt_text05,endt_text06,
         endt_text07,endt_text08,endt_text09,endt_text10,endt_text11,endt_text12,
         endt_text13,endt_text14,endt_text15,endt_text16,endt_text17,
         endt_text, user_id, last_update, endt_tax, endt_cd            --loreen     
    INTO postpar_ws_long_var1,postpar_ws_long_var2,postpar_ws_long_var3,
         postpar_ws_long_var4,postpar_ws_long_var5,postpar_ws_long_var6,
         postpar_ws_long_var7,postpar_ws_long_var8,postpar_ws_long_var9,
         postpar_ws_long_var10,postpar_ws_long_var11,postpar_ws_long_var12,
         postpar_ws_long_var13,postpar_ws_long_var14,postpar_ws_long_var15,
         postpar_ws_long_var16,postpar_ws_long_var17,
         postpar_ws_long_var, p_user_id,p_last_update, p_endt_tax, p_endt_cd
    FROM gipi_wendttext
   WHERE par_id = postpar_par_id;
  INSERT INTO gipi_endttext
              (policy_id,endt_text01,endt_text02,endt_text03,endt_text04,endt_text05,
               endt_text06,endt_text07,endt_text08,endt_text09,endt_text10,
               endt_text11,endt_text12,endt_text13,endt_text14,endt_text15,
               endt_text16,endt_text17, endt_text, user_id,last_update, 
               endt_tax, endt_cd)
       VALUES (postpar_policy_id,postpar_ws_long_var1,postpar_ws_long_var2,
               postpar_ws_long_var3,postpar_ws_long_var4,postpar_ws_long_var5,
               postpar_ws_long_var6,postpar_ws_long_var7,postpar_ws_long_var8,
               postpar_ws_long_var9,postpar_ws_long_var10,postpar_ws_long_var11,
               postpar_ws_long_var12,postpar_ws_long_var13,postpar_ws_long_var14,
               postpar_ws_long_var15,postpar_ws_long_var16,postpar_ws_long_var17,
               postpar_ws_long_var, p_user_id,p_last_update, p_endt_tax, p_endt_cd);
END IF;      
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       pre_post_error(v_par_id,'PAR must have an endorsement text existing.');
  WHEN TOO_MANY_ROWS THEN
       pre_post_error(v_par_id,'PAR must have only one Policy/Endorsement text.');
END;
PROCEDURE UPDATE_QUOTE IS
BEGIN
IF skip_parid = 'N' THEN
  FOR A IN
      ( SELECT a.quote_id
          FROM gipi_quote a, gipi_parlist b
         WHERE a.quote_id  = b.quote_id
           AND b.par_id    = postpar_par_id 
      ) LOOP
      UPDATE gipi_quote
         SET status = 'P',
             post_dt = sysdate,
             last_update = sysdate,
             user_id= USER
       WHERE quote_id = a.quote_id;
  END LOOP;     
END IF;
END;
PROCEDURE DELETE_WPICTURES IS
/*
** This procedure will delete all data for a given par_id.
** Done by rolandmm 0101604
*/
BEGIN
IF skip_parid = 'N' THEN
  DELETE FROM gipi_wpictures
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE delete_casualty_workfile IS
BEGIN
IF skip_parid = 'N' THEN
  DELETE FROM gipi_wcasualty_item
        WHERE par_id = postpar_par_id;
  DELETE FROM GIPI_WCASUALTY_PERSONNEL 
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE delete_fire_workfile IS
BEGIN
IF skip_parid = 'N' THEN
  DELETE FROM gipi_wfireitm
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE delete_marav_workfile IS
BEGIN
IF skip_parid = 'N' THEN
  DELETE FROM gipi_wcargo_carrier
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_wves_air
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_wcargo
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_wopen_peril
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_wopen_cargo
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_wopen_liab
        WHERE par_id = postpar_par_id;
END IF;      
END;
PROCEDURE delete_motcar_workfile IS
BEGIN
IF skip_parid = 'N' THEN
  DELETE FROM gipi_wvehicle
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_wmcacc
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE delete_engineering_workfile IS
BEGIN
IF skip_parid = 'N' THEN
  DELETE FROM gipi_wprincipal
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_wengg_basic
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE delete_open IS
BEGIN
IF skip_parid = 'N' THEN
  DELETE FROM gipi_wopen_peril
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_wopen_cargo
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_wopen_liab
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE delete_item_package(p_line_cd    IN VARCHAR2) IS
BEGIN
IF skip_parid = 'N' THEN
  IF postpar_pack = 'Y' THEN
    FOR A IN (SELECT   distinct pack_line_cd
                FROM   gipi_wpack_line_subline
               WHERE   par_id  =  postpar_par_id) LOOP
     IF A.pack_line_cd = postpar_casualty_cd THEN
        delete_casualty_workfile;
     ELSIF A.pack_line_cd = postpar_fire_cd THEN
        delete_fire_workfile;
     ELSIF A.pack_line_cd = postpar_hull_cd OR
        A.pack_line_cd = postpar_cargo_cd THEN
        delete_marav_workfile;
     ELSIF A.pack_line_cd = postpar_motor_cd THEN
        delete_motcar_workfile;
     ELSIF A.pack_line_cd = postpar_engrng_cd THEN
        delete_engineering_workfile;
     END IF;
     IF NVL(open_policy_sw,'N') = 'Y' and 
        A.pack_line_cd <> postpar_hull_cd AND
        A.pack_line_cd <> postpar_cargo_cd THEN
        delete_open;   
     END IF;   
    END LOOP;
  ELSE
     IF p_line_cd = postpar_casualty_cd THEN
        delete_casualty_workfile;
     ELSIF p_line_cd = postpar_fire_cd THEN
        delete_fire_workfile;
     ELSIF p_line_cd = postpar_hull_cd OR
        p_line_cd = postpar_cargo_cd THEN
        delete_marav_workfile;
     ELSIF p_line_cd = postpar_motor_cd THEN
        delete_motcar_workfile;
     ELSIF p_line_cd = postpar_engrng_cd THEN
        delete_engineering_workfile;
     END IF;
     IF NVL(open_policy_sw,'N') = 'Y' and 
        p_line_cd <> postpar_hull_cd AND
        p_line_cd <> postpar_cargo_cd THEN
        delete_open;   
     END IF;
  END IF;
END IF;
END;
PROCEDURE delete_wpolnrep IS
BEGIN
IF skip_parid = 'N' THEN
  DELETE FROM gipi_wpolnrep
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE delete_oth_workfile IS
BEGIN
IF skip_parid = 'N' THEN
  DELETE GIPI_WCOMM_INV_PERILS
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_winvperl
        WHERE par_id = postpar_par_id;
  DELETE GIPI_WPACKAGE_INV_TAX
        WHERE par_id = postpar_par_id;
  DELETE GIPI_WCOMM_INVOICES
        WHERE par_id = postpar_par_id;
  DELETE GIPI_WINV_TAX
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_winstallment
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_winvoice
        WHERE par_id = postpar_par_id;
  DELETE FROM  gipi_wpolbas_discount
        WHERE par_id = postpar_par_id;
  DELETE FROM  gipi_witem_discount
        WHERE par_id = postpar_par_id;
  DELETE FROM  gipi_wperil_discount
        WHERE par_id = postpar_par_id;
  DELETE FROM  gipi_witmperl_beneficiary
        WHERE par_id = postpar_par_id;
  DELETE FROM  gipi_witmperl_grouped
        WHERE par_id = postpar_par_id;
  DELETE FROM  gipi_witmperl
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_wdeductibles
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_wpolwc
       WHERE  par_id = postpar_par_id;       
  DELETE FROM gipi_wcasualty_item
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_wcasualty_personnel
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_wlocation
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_wgrp_items_beneficiary
       WHERE  par_id = postpar_par_id;     
  DELETE FROM gipi_wgrouped_items
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_wfireitm
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_wcasualty_item
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_wcargo
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_wbeneficiary
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_waviation_item
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_waccident_item
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_witem_ves
       WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_wvehicle
       WHERE  par_id = postpar_par_id;
  --DELETE FROM rmd_fire_basic_info
  --     WHERE  par_id = postpar_par_id;
  DELETE FROM gipi_witem
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE delete_wpolbas IS
BEGIN
IF skip_parid = 'N' THEN
  DELETE FROM gipi_wendttext
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_wpolgenin
        WHERE par_id = postpar_par_id;
  DELETE FROM GIPI_WBANK_SCHEDULE     
     WHERE par_id  =  postpar_par_id;
  DELETE   GIPI_WPACK_LINE_SUBLINE 
     WHERE par_id  =  postpar_par_id;
  DELETE   GIPI_WBOND_BASIC
     WHERE par_id  =  postpar_par_id;
  DELETE FROM gipi_wpolbas
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE delete_winpolbas IS
BEGIN
IF skip_parid = 'N' THEN
  DELETE FROM giri_winpolbas
        WHERE par_id = postpar_par_id;
END IF;
END;
PROCEDURE delete_par IS
BEGIN
IF skip_parid = 'N' THEN 
  DELETE FROM gipi_wmortgagee
        WHERE par_id = postpar_par_id;
  DELETE FROM gipi_wopen_policy
        WHERE par_id = postpar_par_id;    
  delete_wpictures;
  delete_item_package(postpar_line_cd);
  IF quote_seq_no = 1 THEN
     IF postpar_pol_stat IN ('2','3') THEN
        delete_wpolnrep;
     END IF;
     delete_oth_workfile;
     IF postpar_iss_cd = issue_ri THEN
        delete_winpolbas;
     END IF;
     delete_wpolbas;
  ELSE 
     BEGIN
       DECLARE
         CURSOR c IS SELECT a.par_id,a.line_cd,b.pol_flag
                       FROM gipi_parlist a, gipi_wpolbas b
                      WHERE a.line_cd    = postpar_line_cd    AND
                            a.iss_cd     = postpar_iss_cd     AND
                            a.par_yy     = postpar_par_yy     AND
                            a.par_seq_no = postpar_par_seq_no AND
                            a.par_id     = b.par_id(+)
                   ORDER BY a.par_id;
         p_par_id        gipi_parlist.par_id%TYPE;
       BEGIN
         p_par_id   :=  postpar_par_id;
         FOR c1 IN c LOOP
             postpar_par_id := c1.par_id;
             delete_item_package(c1.line_cd);
             IF c1.pol_flag IN ('2','3') THEN
                delete_wpolnrep;
             END IF;
             delete_oth_workfile;
             delete_wpolbas;
         END LOOP;
         postpar_par_id := p_par_id;
       END;
     END;
  END IF;
END IF;
END;
FUNCTION DELAY(p_event_user_mod IN NUMBER,
                p_event_col_cd   IN NUMBER,
                p_tran_id        IN NUMBER) RETURN DATE IS                
  v_time        DATE := NULL;
BEGIN
IF skip_parid = 'N' THEN
 FOR c1 IN (SELECT MAX(date_received) date_received
            FROM gipi_user_events_hist
           WHERE event_user_mod = p_event_user_mod
             AND event_col_cd = p_event_col_cd
             AND tran_id = p_tran_id)
  LOOP             
   v_time := c1.date_received;
 END LOOP;
 IF v_time >= SYSDATE THEN
   v_time := v_time+(1/(24*60*60));
 ELSE 
     v_time := SYSDATE;
 END IF; 
 RETURN(v_time);
END IF;
END;  
PROCEDURE DELETE_WORKFLOW_REC(p_event_desc  IN VARCHAR2,
                              p_module_id  IN VARCHAR2,
                              p_user       IN VARCHAR2,
                              p_col_value IN VARCHAR2) IS
  v_tran_id            gipi_user_events.tran_id%TYPE;    
  v_date_received      DATE;                        
BEGIN
IF skip_parid = 'N' THEN
  FOR B_REC IN ( SELECT c.col_value, c.tran_id , c.event_col_cd, c.event_user_mod, c.switch, c.userid
          FROM gipi_user_events c,
               giis_event_modules b,
              giis_events a
         WHERE c.event_cd = b.event_cd
           AND c.event_mod_cd = b.event_mod_cd
           AND c.event_mod_cd > 0
           AND b.module_id = p_module_id
           AND b.event_cd = a.event_cd
           AND a.event_desc = p_event_desc)
  LOOP
   IF b_rec.col_value = p_col_value THEN
      BEGIN
         v_date_received := DELAY(b_rec.event_user_mod,b_rec.event_col_cd,b_rec.tran_id);  --A.R.C. 01.18.2007
         INSERT INTO gipi_user_events_hist(event_user_mod, event_col_cd, tran_id, col_value, date_received, old_userid, new_userid)
              VALUES(b_rec.event_user_mod, b_rec.event_col_cd, b_rec.tran_id, b_rec.col_value, v_date_received, USER, '-'); 
         DELETE FROM gipi_user_events
               WHERE event_user_mod = b_rec.event_user_mod
                 AND event_col_cd = b_rec.event_col_cd
                 AND tran_id = b_rec.tran_id;
      END;
   ELSE 
     IF b_rec.switch = 'N' AND b_rec.userid = p_user THEN
        UPDATE gipi_user_events
           SET switch = 'Y'
         WHERE event_user_mod = b_rec.event_user_mod
           AND event_col_cd = b_rec.event_col_cd
           AND tran_id = b_rec.tran_id;
     END IF;        
   END IF;  
  END LOOP;
END IF;
END;
PROCEDURE DELETE_OTHER_WORKFLOW_REC(p_event_desc  IN VARCHAR2,
                                    p_module_id  IN VARCHAR2,
                                    p_user       IN VARCHAR2,
                                    p_col_value IN VARCHAR2) IS
  v_tran_id            gipi_user_events.tran_id%TYPE;    
  v_date_received      DATE;                            
BEGIN
IF skip_parid = 'N' THEN
    FOR B_REC IN ( SELECT a.col_value, a.tran_id , a.event_col_cd, a.event_user_mod, a.switch, a.user_id
           FROM giis_events_column b,
             gipi_user_events a  
          WHERE 1=1
            AND a.userid = p_user
            AND b.event_col_cd = a.event_col_cd
            AND a.col_value = p_col_value
            AND EXISTS (SELECT 'X'
                          FROM giis_events z
                         WHERE z.event_type IN (2,4)
                           AND z.event_cd = a.event_cd)  
            AND EXISTS (SELECT 1
                          FROM giis_events_column x, 
                               giis_event_modules y,
                          giis_events z
                         WHERE 1=1
                   AND x.table_name = b.table_name
                   AND x.column_name = b.column_name
                   AND x.event_mod_cd = y.event_mod_cd
                    AND x.event_cd = y.event_cd
                   AND y.module_id = p_module_id
                   AND y.event_cd = z.event_cd
                   AND z.event_desc = p_event_desc))
   LOOP
    BEGIN       
       v_date_received := DELAY(b_rec.event_user_mod,b_rec.event_col_cd,b_rec.tran_id);
       INSERT INTO gipi_user_events_hist(event_user_mod, event_col_cd, tran_id, col_value, date_received, old_userid, new_userid)
            VALUES(b_rec.event_user_mod, b_rec.event_col_cd, b_rec.tran_id, b_rec.col_value, v_date_received, USER, '-'); 
       DELETE FROM gipi_user_events
             WHERE event_user_mod = b_rec.event_user_mod
               AND event_col_cd = b_rec.event_col_cd
               AND tran_id = b_rec.tran_id;
    END;
   END LOOP;
END IF;
END;
PROCEDURE CREATE_TRANSFER_WORKFLOW_REC(p_event_desc IN VARCHAR2,
                                       p_module_id  IN VARCHAR2,
                                       p_user       IN VARCHAR2,
                                       p_col_value  IN VARCHAR2,
                                       p_info       IN VARCHAR2) IS
  v_event_user_mod     gipi_user_events.event_user_mod%TYPE; 
  v_event_col_cd       gipi_user_events.event_col_cd%TYPE;
  v_event_user_mod_old gipi_user_events.event_user_mod%TYPE; 
  v_event_col_cd_old   gipi_user_events.event_col_cd%TYPE;
  v_tran_id            gipi_user_events.tran_id%TYPE;
  v_event_mod_cd       giis_event_modules.event_mod_cd%TYPE;
  v_count              NUMBER;
  v_counthist          NUMBER;
  v_gem_event_mod_cd   giis_event_modules.event_mod_cd%TYPE:=NULL;  --A.R.C. 01.24.2006
  v_date_received      DATE;
BEGIN
IF skip_parid = 'N' THEN
 --A.R.C. 01.24.2006 
 FOR c1 IN (SELECT b.event_mod_cd  
             FROM giis_event_modules b, giis_events a
        WHERE 1=1
           AND b.module_id = p_module_id
           AND b.event_cd = a.event_cd
           AND a.event_desc = p_event_desc )
 LOOP
   v_gem_event_mod_cd := c1.event_mod_cd;
 END LOOP;  
 IF wf.check_wf_user(v_gem_event_mod_cd,USER,p_user) THEN
  BEGIN
    SELECT b.event_user_mod, c.event_col_cd  
     INTO v_event_user_mod, v_event_col_cd
     FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
    WHERE 1=1
       AND c.event_cd = a.event_cd
       AND c.event_mod_cd = a.event_mod_cd
       AND b.event_mod_cd = a.event_mod_cd
      --AND b.userid = p_user
      AND b.passing_userid = USER  --A.R.C. 01.30.2006
      AND NVL(b.userid,p_user) = p_user  --A.R.C. 01.30.2006      
       AND a.module_id = p_module_id
       AND a.event_cd = d.event_cd
       AND d.event_desc = p_event_desc;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        pre_post_error(v_par_Id,'Invalid user.');
  END;
  BEGIN
    SELECT workflow_tran_id_s.NEXTVAL
      INTO v_tran_id
      FROM dual;       
  END;
  BEGIN
   SELECT COUNT(*)
     INTO v_count
     FROM gipi_user_events
    WHERE event_user_mod = v_event_user_mod
      AND event_col_cd = v_event_col_cd
      AND col_value = p_col_value
      AND rownum = 1;
  END; 
   IF v_count = 0 THEN
      INSERT INTO gipi_user_events(event_user_mod, event_col_cd, tran_id, switch, col_value, user_id)
            VALUES(v_event_user_mod, v_event_col_cd, v_tran_id, 'N', p_col_value, p_user);
       BEGIN
         SELECT b.event_user_mod, c.event_col_cd  
          INTO v_event_user_mod_old, v_event_col_cd_old
     FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
    WHERE 1=1
       AND c.event_cd = a.event_cd
       AND c.event_mod_cd = a.event_mod_cd
       AND b.event_mod_cd = a.event_mod_cd
      --AND b.userid = USER  --A.R.C. 01.30.2006
      AND b.passing_userid = USER  --A.R.C. 01.30.2006
      AND NVL(b.userid,p_user) = p_user  --A.R.C. 01.30.2006      
       AND a.module_id = p_module_id
       AND a.event_cd = d.event_cd
       AND d.event_desc = p_event_desc;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             pre_post_error(v_par_id,'Invalid user.');
       END;       
     v_date_received := DELAY(v_event_user_mod_old, v_event_col_cd_old, v_tran_id); --A.R.C. 01.18.2006
       INSERT INTO gipi_user_events_hist(event_user_mod, event_col_cd, tran_id, col_value, date_received, old_userid, new_userid)
            VALUES(v_event_user_mod_old, v_event_col_cd_old, v_tran_id, p_col_value, v_date_received, USER, p_user);
       /*IF Giisp.v('WORKFLOW_MSGR') IS NOT NULL THEN       
         HOST(WF.GET_POPUP_DIR||'realpopup.exe -send '||p_user||' "'||user||' assigned a new transaction.'||' - '||p_info||'" -noactivate');     
       END IF;*/
    END IF;  
 END IF;
END IF;
END;
/*Modified by : iris bordey
**    date    : 08.27.2003
**Modification: Commented script on validation for pending claims.  It will now
**              allow posting even with pending claims but will have to do 
**              neccessary update on gicl_claims. (see update_pending_claims).
**              Replaced commented script a call to program unit update_pending_claims
*/
PROCEDURE posting_process IS
  v_exist      VARCHAR2(1) := 'N';
  v_param      giis_parameters.param_value_v%TYPE;
BEGIN
IF skip_parid = 'N' THEN
  read_into_postpar;
  IF postpar_par_type = 'E' THEN
     BEGIN 
      /* modified by bdarusin
      ** modified on jan312003
      ** shld use pol_iss_cd instead of iss_cd for policy_number */
      IF postpar_pol_stat = '4' OR postpar_ann_tsi_amt = 0 THEN
         FOR A2 IN (SELECT claim_id
                      FROM gicl_claims
                     WHERE line_cd = postpar_line_cd
                       AND subline_cd = postpar_subline_cd
                       --AND iss_cd = postpar_iss_cd   --bdarusin, jan312003
                       AND pol_iss_cd = postpar_iss_cd --bdarusin, jan312003
                       AND issue_yy = postpar_issue_yy 
                       AND pol_seq_no = postpar_pol_seq_no
                       AND renew_no = postpar_renew_no
                       AND clm_stat_cd NOT IN ('CC','WD','DN','CD'))
         LOOP
          pre_post_error(v_par_id, 'The policy has pending claims, cannot cancel policy.');          
         END LOOP;
      END IF;
     END;  
     /*Commented by iris bordey 08.28.2003*/
      /* modified by bdarusin
      ** modified on jan312003
      ** shld use pol_iss_cd instead of iss_cd for policy_number */
    update_pending_claims;
     /*BEGIN
      FOR I IN (SELECT item_no, peril_cd
                  FROM gipi_witmperl
                 WHERE par_id = v_par_id) LOOP
        FOR D IN (SELECT item_no, peril_cd
                    FROM gicl_item_peril a,
                         gicl_claims b
                   WHERE b.claim_id = a.claim_id
                     AND a.item_no        = i.item_no
                     AND a.peril_cd       = i.peril_cd
                     AND b.dsp_loss_date >=  eff_date
                     AND b.line_cd        = postpar_line_cd
                     AND b.subline_cd     = postpar_subline_cd
                     --AND b.iss_cd         = postpar_iss_cd    --bdarusin, jan312003
                     AND b.pol_iss_cd         = postpar_iss_cd  --bdarusin, jan312003
                     AND b.issue_yy       = postpar_issue_yy 
                     AND b.pol_seq_no     = postpar_pol_seq_no
                     AND b.renew_no       = postpar_renew_no
                     AND b.clm_stat_cd NOT IN ('CC','WD','DN','CD'))
        LOOP
          msg_alert('Policy has pending claims, cannot post endorsement.','I',FALSE);
          SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
          EXIT_FORM;
        END LOOP;               
      END LOOP;               
     END;*/
     BEGIN
       FOR S IN (SELECT spld_flag
                   FROM gipi_polbasic
                  WHERE line_cd     = postpar_line_cd
                   AND subline_cd  = postpar_subline_cd
                   AND iss_cd      = postpar_iss_cd
                   AND issue_yy    = postpar_issue_yy 
                   AND pol_seq_no  = postpar_pol_seq_no
                   AND renew_no    = postpar_renew_no
                   AND endt_seq_no = 0 ) 
      LOOP                
        IF s.spld_flag = 2 THEN
          pre_post_error(v_par_id, 'Policy has been tagged for spoilage, cannot post endorsement.');
        END IF;
      END LOOP;  
    END;
    BEGIN
      FOR A IN (
       SELECT 1
         FROM gipi_winvoice
        WHERE par_id = v_par_id) LOOP
         affecting  := 'A';
      END LOOP;
      IF  affecting IS NULL THEN
             affecting := 'N';
      END IF;
     END;
     IF affecting = 'A' THEN
        validate_par;
     ELSIF affecting = 'N' THEN
        validate_in_wpolbas;
        IF postpar_line_cd = postpar_surety_cd THEN
           validate_wbond_basic;     
        END IF;
     END IF;
  ELSE -- postpar_par_type = 'P'
     validate_par;     
  END IF;
  post_pol_par;
  /* ASI 082399  for backward endorsement update of posted endorsements for those
  **             that will be affected of the changes made in this current endorsement
  */
  IF postpar_par_type = 'E' THEN
     IF v_BACK_ENDT = 'Y' THEN  
        upd_back_endt;  
     END IF;
  END IF;
  insert_parhist;
  update_par_status;
/* 
**
** moved to GIPIS207 FINAL_POST_PROCESS (stored procedure) 
**
*/
  IF skip_parid = 'Y' THEN
   ROLLBACK;
  ELSE 
   COMMIT;
  END IF;
END IF;  
END;
PROCEDURE determine_package IS
  /* Procedure created to determine whether the PAR being 
  ** processed has been tagged as a package policy or not.
  ** Created by  : Daphne
  ** Last Update : 06081998
  */
BEGIN
IF skip_parid = 'N' THEN
  FOR A IN (SELECT pack_pol_flag FROM gipi_wpolbas
             WHERE par_id  =  postpar_par_id) LOOP
             postpar_pack  :=  A.pack_pol_flag;
             EXIT;
  END LOOP;
END IF;
END;
PROCEDURE initialize_global IS
BEGIN
IF skip_parid = 'N' THEN  
 --BETH 04192000 get value of iss_cd to be use in posting process 
 --     in gipi_wpolbas instead of getting it from gipi_parlist
  SELECT par_seq_no,par_yy,--iss_cd,
         par_id,line_cd,par_type,
         quote_seq_no
    INTO postpar_par_seq_no,postpar_par_yy, --postpar_iss_cd,
         postpar_par_id,postpar_line_cd,postpar_par_type,
          quote_seq_no
    FROM gipi_parlist
   WHERE par_id = v_par_id;
  SELECT subline_cd,pol_flag,iss_cd,issue_yy,pol_seq_no,renew_no,ann_tsi_amt,eff_date
    INTO postpar_subline_cd,postpar_pol_stat,postpar_iss_cd,
         postpar_issue_yy, postpar_pol_seq_no, postpar_renew_no,
         postpar_ann_tsi_amt,  eff_date
    FROM gipi_wpolbas
   WHERE par_id = v_par_id;
  SELECT op_flag,open_policy_sw
    INTO  open_flag, open_policy_sw
    FROM giis_subline
   WHERE line_cd    = v_line_cd AND
         subline_cd = postpar_subline_cd;
  FOR A IN (SELECT    param_value_v
              FROM    giis_parameters
             WHERE    param_name     =  'ISS_CD_RI') LOOP
       issue_ri :=  a.param_value_v;
      EXIT;
  END LOOP;   
   DETERMINE_PACKAGE; 
   posting_process;
END IF;     
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     PRE_POST_ERROR(v_par_id, 'NO DATA FOUND');
END;
PROCEDURE POST(p_par_id               IN  NUMBER,
               p_line_cd              IN  VARCHAR2,
      p_iss_cd               IN  VARCHAR2,
      p_par_type             IN  VARCHAR2,
      p_back_endt            IN  VARCHAR2,
      out_postpar_policy_id  OUT giuw_pol_dist.policy_id%TYPE,              
      out_postpar_dist_no    OUT giuw_pol_dist.dist_no%TYPE,
      out_postpar_par_id     OUT gipi_parlist.par_id%TYPE,
      out_postpar_line_cd    OUT gipi_parlist.line_cd%TYPE,  
      out_postpar_subline_cd OUT gipi_wpolbas.subline_cd%TYPE,
      out_postpar_iss_cd     OUT gipi_wpolbas.iss_cd%TYPE,
      out_postpar_pack       OUT gipi_wpolbas.pack_pol_flag%TYPE,
      out_affecting          OUT VARCHAR2
) IS      
BEGIN
v_par_id    := p_par_id;
v_line_cd   := p_line_cd;
v_iss_cd    := p_iss_cd;
v_par_type  := p_par_type;
v_back_endt := p_back_endt;
skip_parid  := 'N';
  /* 
 **              Allow posting even with pending claims but will have to do 
 **              neccessary update on gicl_claims. (see update_pending_claims)
 */ 
 --        Promt that when effective tsi of the policy is 0 (zero)
 --              then policy status will change to cancellation endt. (pol_flag := 4)
 --
 -- This trigger call a program unit which implements the 
 -- initialization of global  
 DECLARE  
  loc_eff_date      DATE;
  loc_peril_name      giis_peril.peril_name%TYPE;
  loc_line_cd         gipi_polbasic.line_cd%TYPE;
  loc_subline_cd      gipi_polbasic.subline_cd%TYPE;
  loc_iss_cd          gipi_polbasic.iss_cd%TYPE;
  loc_issue_yy        gipi_polbasic.issue_yy%TYPE;
  loc_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE;
  loc_renew_no        gipi_polbasic.renew_no%TYPE;
  loc_pol_flag        gipi_polbasic.pol_flag%TYPE;
  loc_ann_tsi_amt     gipi_polbasic.ann_tsi_amt%TYPE;
  loc_endt_type       gipi_polbasic.endt_type%TYPE;
  loc_allow        giis_parameters.param_value_v%TYPE := 'Y';
  loc_dist        giuw_pol_dist.auto_dist%TYPE;
  alert_button      NUMBER;
  loc_par_type      gipi_parlist.par_type%TYPE;
  loc_exist               VARCHAR2(1)                        := 'N';
  loc_op_switch           VARCHAR2(1)                        := 'N';
  loc_booking_year    gipi_polbasic.booking_year%TYPE;          
  loc_booking_mth     gipi_polbasic.booking_mth%TYPE;           
  loc_update       giis_parameters.param_value_v%TYPE;       
  loc_booked_tag     giis_booking_month.booked_tag%TYPE;       
   loc_req_deduct     giis_parameters.param_value_v%TYPE;       
   loc_ver_flag      NUMBER;                                   
   loc_ver_flag1      NUMBER                              := 0; 
   loc_deduct_msg          VARCHAR2(32767); 
   loc_post_limit     giis_posting_limit.post_limit%TYPE;    
  loc_all_amt_sw     giis_posting_limit.all_amt_sw%TYPE;    
  loc_item_no       gipi_witem.item_no%TYPE;         
 BEGIN 
   --to check if co-insurer exists
   IF NVL(GIISP.V('CHECK_CO_INSURER'),'N') = 'Y' THEN
   FOR c2 IN (SELECT 1
           FROM gipi_wpolbas a
         WHERE 1=1
           AND co_insurance_sw <> 1
           AND par_id =  v_par_id
           AND NOT EXISTS (SELECT 1
                             FROM gipi_main_co_ins z
                            WHERE z.par_id = a.par_id))
   LOOP
     PRE_POST_ERROR( v_par_id, 'The PAR has no Co-insurance.');     
   END LOOP;  
   END IF; 
 --validate if user is allowed to post a policy 
   BEGIN
    SELECT post_limit, all_amt_sw
      INTO loc_post_limit, loc_all_amt_sw
       FROM giis_posting_limit
      WHERE line_cd =  v_line_cd
        AND iss_cd  =  v_iss_cd
        AND upper(posting_user) = USER;
   EXCEPTION
    WHEN no_data_found THEN
     PRE_POST_ERROR( v_par_id, 'User has no authority to post a policy. Reassign the PAR to another user or set-up the posting limit of user '||USER||'.');     
   END;
   IF loc_all_amt_sw IS NULL OR loc_all_amt_sw = 'N' THEN
    IF loc_post_limit IS NULL OR loc_post_limit = 0 THEN
     PRE_POST_ERROR( v_par_id, 'User has no authority to post a policy. Reassign the PAR to another user or set-up the posting limit of user '||USER||'.');
    ELSIF loc_post_limit IS NOT NULL OR loc_post_limit <> 0 THEN     
     FOR p1 IN (SELECT SUM(ann_tsi_amt*currency_rt) ann_tsi_amt    
             FROM gipi_witem
          WHERE par_id =  v_par_id)
    LOOP     
     loc_ann_tsi_amt := p1.ann_tsi_amt;
     IF NVL(loc_ann_tsi_amt,0) > NVL(loc_post_limit,0) THEN
       PRE_POST_ERROR( v_par_id, 'Total TSI amount exceeds the allowable TSI amount of the user '||USER||'. Reassign the PAR to another user with higher authority.');
     END IF;
    END LOOP;
   END IF;
   END IF;      
   --Validation for posting policy with pending claims on particular item and peril(s).
   --Disallow posting if there are pending claims on specified item and peril(s).
   FOR  dt IN (SELECT TRUNC(eff_date) eff_date, line_cd, subline_cd, iss_cd, 
                      pol_seq_no, issue_yy, renew_no, pol_flag,
                      ann_tsi_amt, endt_type,
                      booking_year, booking_mth
                 FROM gipi_wpolbas
                WHERE par_id =  v_par_id)
   LOOP
    loc_eff_date     := dt.eff_date;
    loc_line_cd      := dt.line_cd;
    loc_subline_cd   := dt.subline_cd;
    loc_iss_cd       := dt.iss_cd;
    loc_issue_yy     := dt.issue_yy;
    loc_pol_seq_no   := dt.pol_seq_no;
    loc_renew_no     := dt.renew_no;
    loc_pol_flag     := dt.pol_flag;
    loc_ann_tsi_amt  := dt.ann_tsi_amt;
    loc_endt_type    := dt.endt_type;
    loc_booking_year := dt.booking_year;
    loc_booking_mth  := dt.booking_mth;    
    EXIT;
   END LOOP;      
  -- check if posting is allowed for undistributed policies
  FOR a IN (SELECT param_value_v
              FROM giis_parameters
             WHERE param_name = 'ALLOW_POSTING_OF_UNDIST')
  LOOP
   loc_allow := a.param_value_v;
   EXIT;
  END LOOP; 
   FOR b IN (SELECT auto_dist
              FROM giuw_pol_dist
             WHERE par_id =  v_par_id)
  LOOP
   loc_dist := b.auto_dist;
   EXIT;
  END LOOP;
   FOR d IN (SELECT a.par_type par_type, c.op_flag op_flag
              FROM gipi_parlist a, gipi_wpolbas b, giis_subline c
             WHERE a.par_id = b.par_id
               AND b.subline_cd = c.subline_cd
               AND b.line_cd = c.line_cd
               AND a.par_id =  v_par_id)
  LOOP
   loc_par_type := d.par_type;
    loc_op_switch := d.op_flag;
   EXIT;
  END LOOP; 
   FOR d IN (SELECT 1
               FROM gipi_witmperl
              WHERE par_id =  v_par_id)
  LOOP
   loc_exist := 'Y';
   EXIT;
  END LOOP;  
  FOR d1 IN (SELECT 1
               FROM gipi_witmperl_grouped
              WHERE par_id =  v_par_id)
  LOOP
   loc_exist := 'Y';
   EXIT;
  END LOOP;
 /* this validates if all the items of the given PAR have at least 1 record
          in GIPI_DEDUCTIBLES, if not posting will not continue.
 */  
  FOR ver_rec1 in (SELECT param_value_v
                     FROM giis_parameters
                    WHERE param_name = 'REQUIRE_DEDUCTIBLES')
  LOOP
   loc_req_deduct := ver_rec1.param_value_v;
  END LOOP;     
   IF loc_par_type = 'P' THEN
     IF nvl(loc_req_deduct,'N') = 'Y' THEN 
       FOR ver_rec2 IN (SELECT item_no 
                            FROM gipi_witem
                           WHERE par_id =  v_par_id)
        LOOP
         FOR ver_rec3 IN (SELECT 'VER'
                   FROM gipi_wdeductibles
                  WHERE par_id =  v_par_id
                    AND item_no = ver_rec2.item_no)
         LOOP
           loc_ver_flag:=1;
         END LOOP;
         IF loc_ver_flag = 1 THEN
             loc_ver_flag :=0;           
         ELSE
           loc_deduct_msg:=loc_deduct_msg||ver_rec2.item_no||', ';
            loc_ver_flag :=0;
            loc_ver_flag1 := loc_ver_flag1+1;
         END IF;
        END LOOP;
        IF loc_ver_flag1 > 0 THEN          
          loc_deduct_msg:=substr(loc_deduct_msg,1,instr(loc_deduct_msg,', ',-1)-1);
          PRE_POST_ERROR( v_par_id, 'The ff. must have at least 1 deductible: Item no(s) '||loc_deduct_msg||'.');       
        END IF;
     END IF;
   ELSIF loc_par_type = 'E' THEN
     IF nvl(loc_req_deduct,'N') = 'Y' THEN 
       FOR ver_rec2 IN (SELECT item_no 
                        FROM gipi_witem
                       WHERE par_id =  v_par_id
                         AND rec_flag = 'A')
        LOOP
         FOR ver_rec3 IN (SELECT 'VER'
                   FROM gipi_wdeductibles
                   WHERE par_id =  v_par_id
                    AND item_no = ver_rec2.item_no)
         LOOP
          loc_ver_flag:=1;
         END LOOP;
         IF loc_ver_flag = 1 THEN
           loc_ver_flag :=0;           
         ELSE
          loc_deduct_msg:=loc_deduct_msg||ver_rec2.item_no||', ';
          loc_ver_flag :=0;
          loc_ver_flag1 := loc_ver_flag1+1;
         END IF;
        END LOOP;
        IF loc_ver_flag1 > 0 THEN          
          loc_deduct_msg:=substr(loc_deduct_msg,1,instr(loc_deduct_msg,', ',-1)-1);
          PRE_POST_ERROR( v_par_id, 'The ff. must have at least 1 deductible: Item no(s) '||loc_deduct_msg||'.');       
        END IF;
     END IF;
   END IF;
   IF loc_par_type = 'P' THEN
      IF nvl(loc_allow,'Y') = 'N' AND nvl(loc_dist,'N') = 'N' AND loc_op_switch = 'N' THEN
        PRE_POST_ERROR( v_par_id, 'Distribute the PAR before posting the policy.');      
      END IF; 
   ELSIF loc_par_type = 'E' AND loc_exist = 'Y' THEN
      IF nvl(loc_allow,'Y') = 'N' AND nvl(loc_dist,'N') = 'N' AND loc_op_switch = 'N' THEN
         PRE_POST_ERROR( v_par_id, 'Distribute the PAR before posting the policy.');
      END IF; 
   END IF;   
  -- checks if update booking is allowed
  FOR a IN (SELECT param_value_v
              FROM giis_parameters
             WHERE param_name = 'UPDATE_BOOKING')
  LOOP
   loc_update := a.param_value_v;
   EXIT;
  END LOOP;  
  -- checks if the value of the booked tag of the PAR
  FOR a IN (SELECT booked_tag
        FROM giis_booking_month
        WHERE booking_year = loc_booking_year
          AND booking_mth  = loc_booking_mth)
  LOOP
   loc_booked_tag := a.booked_tag;
   EXIT;
  END LOOP;  
  -- if the value of the parameter update_booking is set to Y
  -- and the booked_tag of the booking date is set to Y
  -- then it updates the booking date to the next available booking date
  IF loc_update = 'Y' AND loc_booked_tag = 'Y' THEN
   FOR C IN (SELECT BOOKING_YEAR, 
                    TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'), 
                    BOOKING_MTH 
               FROM GIIS_BOOKING_MONTH
              WHERE (NVL(BOOKED_TAG, 'N') != 'Y')
                AND (BOOKING_YEAR > loc_booking_year
                 OR (BOOKING_YEAR = loc_booking_year 
                 AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'))>= TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(loc_BOOKING_MTH,1, 3)|| loc_BOOKING_YEAR), 'MM'))))
            ORDER BY 1, 2 ) 
    LOOP
      loc_booking_year := TO_NUMBER(C.BOOKING_YEAR);       
      loc_booking_mth  := C.BOOKING_MTH;       
      EXIT;   
    END LOOP; 
    PRE_POST_ERROR( v_par_id, 'Booking date has been closed.');   
  END IF;  
  -- validation for plate_no,serial_no and motor_no  
  IF  v_line_cd='MC' THEN
        validate_carnap;
     validate_plate_no;
     validate_serial_motor;
     validate_serial_no;
     validate_motor_no;
     validate_coc_serial_no;
  END IF;
   IF loc_pol_flag = '4' AND loc_ann_tsi_amt = 0 THEN
    FOR a IN (SELECT SUM(c.total_payments) paid_amt
                FROM gipi_polbasic a, gipi_invoice b, giac_aging_soa_details c
               WHERE a.line_cd     = v_line_cd
                 AND a.subline_cd  = loc_subline_cd
                 AND a.iss_cd      = v_iss_cd
                 AND a.issue_yy    = loc_issue_yy
              AND a.pol_seq_no  = loc_pol_seq_no
              AND a.renew_no    = loc_renew_no
              AND a.pol_flag IN ('1','2','3')
              AND a.policy_id = b.policy_id
              AND b.iss_cd = c.iss_cd
              AND b.prem_seq_no = c.prem_seq_no) LOOP
      IF a.paid_amt <> 0 THEN
       PRE_POST_ERROR( v_par_id, 'Payments have been made to the policy to be cancelled.');     
    END IF;
   END LOOP;
   END IF;  
   INITIALIZE_GLOBAL;
     out_postpar_policy_id  := postpar_policy_id;              
    out_postpar_dist_no    := postpar_dist_no;
    out_postpar_par_id     := postpar_par_id;
    out_postpar_line_cd    := postpar_line_cd;  
    out_postpar_subline_cd := postpar_subline_cd;
    out_postpar_iss_cd     := postpar_iss_cd;
    out_postpar_pack       := postpar_pack;
    out_affecting          := affecting;   
   IF skip_parid = 'Y' THEN
      out_postpar_par_id := NULL;
   END IF;
 END;    
END;
END;
/



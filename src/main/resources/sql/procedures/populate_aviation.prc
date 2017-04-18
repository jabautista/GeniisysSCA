DROP PROCEDURE CPI.POPULATE_AVIATION;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_AVIATION (
    v_item_no          IN  NUMBER,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wopen_policy.par_id%TYPE,
    p_msg             OUT  VARCHAR2
) 
IS
  --rg_id              RECORDGROUP;
  rg_name            VARCHAR2(30) := 'GROUP_POLICY';
  rg_count           NUMBER;
  rg_count2          NUMBER;
  rg_col             VARCHAR2(50) := rg_name || '.policy_id';
  item_exist         VARCHAR2(1); 
  v_row              NUMBER;
  v_policy_id        gipi_polbasic.policy_id%TYPE;
  v_endt_id          gipi_polbasic.policy_id%TYPE;
  v_vessel_cd        gipi_waviation_item.vessel_cd%TYPE;
  v_total_fly_time   gipi_waviation_item.total_fly_time%TYPE;
  v_qualification    gipi_waviation_item.qualification%TYPE;
  v_purpose          gipi_waviation_item.purpose%TYPE;
  v_geog_limit       gipi_waviation_item.geog_limit%TYPE;
  v_deduct_text      gipi_waviation_item.deduct_text%TYPE;
  v_fixed_wing       gipi_waviation_item.fixed_wing%TYPE;
  v_rotor            gipi_waviation_item.rotor%TYPE; 
  v_prev_util_hrs    gipi_waviation_item.prev_util_hrs%TYPE;
  v_est_util_hrs     gipi_waviation_item.est_util_hrs%TYPE;  
  
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;
BEGIN    
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-21-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_AVIATION program unit 
  */ 
   GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, x_line_cd, x_subline_cd, x_iss_cd, x_issue_yy, x_pol_seq_no, x_renew_no, p_msg);
   IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
                AND NVL(endt_seq_no,0) = 0
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id  := b.policy_id;
          FOR DATA IN
              ( SELECT vessel_cd,     total_fly_time,  qualification, purpose,         geog_limit,
                   deduct_text,   fixed_wing,      rotor,         prev_util_hrs,   est_util_hrs
                  FROM gipi_aviation_item
                 WHERE item_no = v_item_no
                   AND policy_id = v_policy_id               
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_waviation_item
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
                 v_vessel_cd        := data.vessel_cd;
                 v_total_fly_time   := data.total_fly_time;
                 v_qualification    := data.qualification;
                 v_purpose          := data.purpose;
                 v_geog_limit       := data.geog_limit;
                 v_deduct_text      := data.deduct_text;
                 v_fixed_wing       := data.fixed_wing;
                 v_rotor            := data.rotor; 
                 v_prev_util_hrs    := data.prev_util_hrs;
                 v_est_util_hrs     := data.est_util_hrs;
                      FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                                  FROM gipi_polbasic
                              WHERE line_cd     =  x_line_cd
                                AND subline_cd  =  x_subline_cd
                                AND iss_cd      =  x_iss_cd
                                AND issue_yy    =  to_char(x_issue_yy)
                                AND pol_seq_no  =  to_char(x_pol_seq_no)
                                AND renew_no    =  to_char(x_renew_no)
                                AND (endt_seq_no = 0 OR 
                                    (endt_seq_no > 0 AND 
                                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                                AND pol_flag In ('1','2','3')
                                AND NVL(endt_seq_no,0) = 0
                              ORDER BY eff_date, endt_seq_no)
                     LOOP      
                        v_endt_id   := b1.policy_id;
                         FOR DATA2 IN
                                ( SELECT vessel_cd,     total_fly_time,  qualification, purpose,         geog_limit,
                                           deduct_text,   fixed_wing,      rotor,         prev_util_hrs,   est_util_hrs
                                  FROM gipi_aviation_item
                                WHERE item_no = v_item_no 
                                  AND policy_id = v_endt_id
                             ) LOOP
                            v_vessel_cd        := NVL(data2.vessel_cd, v_vessel_cd);
                            v_total_fly_time   := NVL(data2.total_fly_time, v_total_fly_time);
                            v_qualification    := NVL(data2.qualification, v_qualification);
                            v_purpose          := NVL(data2.purpose, v_purpose);
                            v_geog_limit       := NVL(data2.geog_limit, v_geog_limit);
                            v_deduct_text      := NVL(data2.deduct_text, v_deduct_text);
                            v_fixed_wing       := NVL(data2.fixed_wing, v_fixed_wing);
                            v_rotor            := NVL(data2.rotor, v_rotor); 
                            v_prev_util_hrs    := NVL(data2.prev_util_hrs, v_prev_util_hrs);
                            v_est_util_hrs     := NVL(data.est_util_hrs, v_est_util_hrs);
                         END LOOP;   
                     END LOOP;
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying aviation info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                   INSERT INTO gipi_waviation_item (
                               par_id,               item_no,         vessel_cd,
                               total_fly_time,       qualification,   purpose,
                               geog_limit,           deduct_text,     fixed_wing,
                               rotor,                prev_util_hrs,   est_util_hrs,
                               rec_flag )
                        VALUES(p_new_par_id,         v_item_no,       v_vessel_cd,
                               v_total_fly_time,     v_qualification, v_purpose,
                               v_geog_limit,         v_deduct_text,   v_fixed_wing,
                               v_rotor,              v_prev_util_hrs, v_est_util_hrs,
                               'A');              
                  v_vessel_cd        := NULL;
                  v_total_fly_time   := NULL;
                  v_qualification    := NULL;
                  v_purpose          := NULL;
                  v_geog_limit       := NULL;
                  v_deduct_text      := NULL;
                  v_fixed_wing       := NULL;
                  v_rotor            := NULL; 
                  v_prev_util_hrs    := NULL;
                  v_est_util_hrs     := NULL;
              ELSE
                 EXIT;             
              END IF;                        
          END LOOP;
     END LOOP;
   ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id  := b.policy_id;
          FOR DATA IN
              ( SELECT vessel_cd,     total_fly_time,  qualification, purpose,         geog_limit,
                   deduct_text,   fixed_wing,      rotor,         prev_util_hrs,   est_util_hrs
                  FROM gipi_aviation_item
                 WHERE item_no = v_item_no
                   AND policy_id = v_policy_id               
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_waviation_item
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
                 v_vessel_cd        := data.vessel_cd;
                 v_total_fly_time   := data.total_fly_time;
                 v_qualification    := data.qualification;
                 v_purpose          := data.purpose;
                 v_geog_limit       := data.geog_limit;
                 v_deduct_text      := data.deduct_text;
                 v_fixed_wing       := data.fixed_wing;
                 v_rotor            := data.rotor; 
                 v_prev_util_hrs    := data.prev_util_hrs;
                 v_est_util_hrs     := data.est_util_hrs;
                      FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                                  FROM gipi_polbasic
                              WHERE line_cd     =  x_line_cd
                                AND subline_cd  =  x_subline_cd
                                AND iss_cd      =  x_iss_cd
                                AND issue_yy    =  to_char(x_issue_yy)
                                AND pol_seq_no  =  to_char(x_pol_seq_no)
                                AND renew_no    =  to_char(x_renew_no)
                                AND (endt_seq_no = 0 OR 
                                    (endt_seq_no > 0 AND 
                                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                                AND pol_flag In ('1','2','3')
                              ORDER BY eff_date, endt_seq_no)
                     LOOP      
                        v_endt_id   := b1.policy_id;
                         FOR DATA2 IN
                                ( SELECT vessel_cd,     total_fly_time,  qualification, purpose,         geog_limit,
                                           deduct_text,   fixed_wing,      rotor,         prev_util_hrs,   est_util_hrs
                                  FROM gipi_aviation_item
                                WHERE item_no = v_item_no 
                                  AND policy_id = v_endt_id
                             ) LOOP
                            v_vessel_cd        := NVL(data2.vessel_cd, v_vessel_cd);
                            v_total_fly_time   := NVL(data2.total_fly_time, v_total_fly_time);
                            v_qualification    := NVL(data2.qualification, v_qualification);
                            v_purpose          := NVL(data2.purpose, v_purpose);
                            v_geog_limit       := NVL(data2.geog_limit, v_geog_limit);
                            v_deduct_text      := NVL(data2.deduct_text, v_deduct_text);
                            v_fixed_wing       := NVL(data2.fixed_wing, v_fixed_wing);
                            v_rotor            := NVL(data2.rotor, v_rotor); 
                            v_prev_util_hrs    := NVL(data2.prev_util_hrs, v_prev_util_hrs);
                            v_est_util_hrs     := NVL(data.est_util_hrs, v_est_util_hrs);
                         END LOOP;   
                     END LOOP;
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying aviation info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                   INSERT INTO gipi_waviation_item (
                               par_id,               item_no,         vessel_cd,
                               total_fly_time,       qualification,   purpose,
                               geog_limit,           deduct_text,     fixed_wing,
                               rotor,                prev_util_hrs,   est_util_hrs,
                               rec_flag )
                        VALUES(p_new_par_id,         v_item_no,       v_vessel_cd,
                               v_total_fly_time,     v_qualification, v_purpose,
                               v_geog_limit,         v_deduct_text,   v_fixed_wing,
                               v_rotor,              v_prev_util_hrs, v_est_util_hrs,
                               'A');              
                  v_vessel_cd        := NULL;
                  v_total_fly_time   := NULL;
                  v_qualification    := NULL;
                  v_purpose          := NULL;
                  v_geog_limit       := NULL;
                  v_deduct_text      := NULL;
                  v_fixed_wing       := NULL;
                  v_rotor            := NULL; 
                  v_prev_util_hrs    := NULL;
                  v_est_util_hrs     := NULL;
              ELSE
                 EXIT;             
              END IF;                        
          END LOOP;
     END LOOP;
   END IF;
END;
/



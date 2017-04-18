DROP PROCEDURE CPI.POPULATE_ACCIDENT;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_ACCIDENT (
    v_item_no          IN  NUMBER,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_pack_wpolwc.pack_par_id%TYPE,
    p_line_ac          IN  VARCHAR2,
    p_menu_line_cd     IN  VARCHAR2,
    p_line_ca          IN  VARCHAR2,
    p_msg             OUT  VARCHAR2
) 
IS
  --rg_id              RECORDGROUP;
  rg_name            VARCHAR2(30) := 'GROUP_POLICY';
  rg_count           NUMBER;
  rg_count2          NUMBER;
  rg_col             VARCHAR2(50) := rg_name || '.policy_id';
  item_exist         VARCHAR2(1); 
  v_row              NUMBER := 0;
  v_policy_id        gipi_polbasic.policy_id%TYPE;
  v_endt_id          gipi_polbasic.policy_id%TYPE;
  v_date_of_birth    gipi_waccident_item.date_of_birth%TYPE;
  v_age              gipi_waccident_item.age%TYPE;
  v_civil_status     gipi_waccident_item.civil_status%TYPE;
  v_position_cd      gipi_waccident_item.position_cd%TYPE;
  v_monthly_salary   gipi_waccident_item.monthly_salary%TYPE;
  v_salary_grade     gipi_waccident_item.salary_grade%TYPE;
  v_no_of_persons    gipi_waccident_item.no_of_persons%TYPE;
  v_destination      gipi_waccident_item.destination%TYPE;
  v_height           gipi_waccident_item.height%TYPE;
  v_weight           gipi_waccident_item.weight%TYPE;
  v_sex              gipi_waccident_item.sex%TYPE;
  v_ac_class_cd      gipi_waccident_item.ac_class_cd%TYPE;
  v_group_print_sw   gipi_waccident_item.group_print_sw%TYPE;
  
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
  **  Description  : POPULATE_ACCIDENT program unit 
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
          v_policy_id   := b.policy_id;
          FOR DATA IN
              ( SELECT  date_of_birth,    sex,            ac_class_cd,    
                        age,              civil_status,   position_cd,
                        monthly_salary,   salary_grade,   no_of_persons,
                        destination,      height,         weight,
                        group_print_sw
                  FROM gipi_accident_item
                 WHERE item_no = v_item_no
                   AND policy_id = v_policy_id               
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_waccident_item
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
                 v_date_of_birth    := data.date_of_birth;
                 v_age              := data.age; 
                 v_civil_status     := data.civil_status;
                 v_position_cd      := data.position_cd;
                 v_monthly_salary   := data.monthly_salary;
                 v_salary_grade     := data.salary_grade;
                 v_no_of_persons    := data.no_of_persons;
                 v_destination      := data.destination;
                 v_height           := data.height;
                 v_weight           := data.weight;
                 v_sex              := data.sex;
                 v_ac_class_cd      := data.ac_class_cd;             
                 v_group_print_sw   := data.group_print_sw;
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
                            ( SELECT date_of_birth,        sex,            ac_class_cd,    
                                   age,                  civil_status,   position_cd,
                                   monthly_salary,       salary_grade,   no_of_persons,
                                   destination,          height,         weight,
                                   group_print_sw
                              FROM gipi_accident_item
                            WHERE item_no = v_item_no 
                              AND policy_id = v_endt_id
                         ) LOOP
                         v_date_of_birth    := NVL(data2.date_of_birth, v_date_of_birth);
                         v_age              := NVL(data2.age, v_age); 
                         v_civil_status     := NVL(data2.civil_status, v_civil_status);
                         v_position_cd      := NVL(data2.position_cd, v_position_cd);
                         v_monthly_salary   := NVL(data2.monthly_salary, v_monthly_salary);
                         v_salary_grade     := NVL(data2.salary_grade, v_salary_grade);
                         v_no_of_persons    := NVL(data2.no_of_persons, v_no_of_persons);
                         v_destination      := NVL(data2.destination, v_destination);
                         v_height           := NVL(data2.height, v_height);
                         v_weight           := NVL(data2.weight, v_weight);
                         v_sex              := NVL(data2.sex, v_sex);
                         v_ac_class_cd      := NVL(data2.ac_class_cd, v_ac_class_cd);                     
                         v_group_print_sw   := NVL(data2.group_print_sw, v_group_print_sw);                                          
                     END LOOP; 
                 END LOOP;   
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying accident info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE;
                   INSERT INTO gipi_waccident_item (
                        par_id,               item_no,        date_of_birth, 
                        age,                  civil_status,   position_cd,
                        monthly_salary,       salary_grade,   no_of_persons,
                        destination,          height,         weight,
                        sex,                  ac_class_cd,    group_print_sw)
                 VALUES(p_new_par_id, v_item_no,      v_date_of_birth, 
                        v_age,                v_civil_status, v_position_cd,
                        v_monthly_salary,     v_salary_grade, v_no_of_persons,
                        v_destination,        v_height,       v_weight,
                        v_sex,                v_ac_class_cd,  v_group_print_sw);              
                  --POPULATE_GROUP_ITEMS(v_item_no);  /*Commented by aivhie 111601 */
                  POPULATE_GROUP_ITEM(v_item_no, p_old_pol_id, p_line_ac, p_menu_line_cd, p_new_par_id, p_line_ca, p_proc_summary_sw, p_msg); /*Added by aivhie 111601*/
                  POPULATE_BENEFICIARY(v_item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
                  --POPULATE_GROUP_BENEFICIARY(v_item_no);  
                  v_group_print_sw   := NULL;
                  v_date_of_birth    := NULL;
                  v_age              := NULL; 
                  v_civil_status     := NULL;
                  v_position_cd      := NULL;
                  v_monthly_salary   := NULL;
                  v_salary_grade     := NULL;
                  v_no_of_persons    := NULL;
                  v_destination      := NULL;
                  v_height           := NULL;
                  v_weight           := NULL;
                  v_sex              := NULL;
                  v_ac_class_cd      := NULL;              
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
        v_policy_id   := b.policy_id;
          FOR DATA IN
              ( SELECT  date_of_birth,    sex,            ac_class_cd,    
                        age,              civil_status,   position_cd,
                        monthly_salary,   salary_grade,   no_of_persons,
                        destination,      height,         weight,
                        group_print_sw
                  FROM gipi_accident_item
                 WHERE item_no = v_item_no
                   AND policy_id = v_policy_id               
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_waccident_item
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
                 v_date_of_birth    := data.date_of_birth;
                 v_age              := data.age; 
                 v_civil_status     := data.civil_status;
                 v_position_cd      := data.position_cd;
                 v_monthly_salary   := data.monthly_salary;
                 v_salary_grade     := data.salary_grade;
                 v_no_of_persons    := data.no_of_persons;
                 v_destination      := data.destination;
                 v_height           := data.height;
                 v_weight           := data.weight;
                 v_sex              := data.sex;
                 v_ac_class_cd      := data.ac_class_cd;             
                 v_group_print_sw   := data.group_print_sw;
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
                            ( SELECT date_of_birth,        sex,            ac_class_cd,    
                                   age,                  civil_status,   position_cd,
                                   monthly_salary,       salary_grade,   no_of_persons,
                                   destination,          height,         weight,
                                   group_print_sw
                              FROM gipi_accident_item
                            WHERE item_no = v_item_no 
                              AND policy_id = v_endt_id
                         ) LOOP
                         v_date_of_birth    := NVL(data2.date_of_birth, v_date_of_birth);
                         v_age              := NVL(data2.age, v_age); 
                         v_civil_status     := NVL(data2.civil_status, v_civil_status);
                         v_position_cd      := NVL(data2.position_cd, v_position_cd);
                         v_monthly_salary   := NVL(data2.monthly_salary, v_monthly_salary);
                         v_salary_grade     := NVL(data2.salary_grade, v_salary_grade);
                         v_no_of_persons    := NVL(data2.no_of_persons, v_no_of_persons);
                         v_destination      := NVL(data2.destination, v_destination);
                         v_height           := NVL(data2.height, v_height);
                         v_weight           := NVL(data2.weight, v_weight);
                         v_sex              := NVL(data2.sex, v_sex);
                         v_ac_class_cd      := NVL(data2.ac_class_cd, v_ac_class_cd);                     
                         v_group_print_sw   := NVL(data2.group_print_sw, v_group_print_sw);                                          
                     END LOOP; 
                 END LOOP;   
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying accident info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE;
                   INSERT INTO gipi_waccident_item (
                        par_id,               item_no,        date_of_birth, 
                        age,                  civil_status,   position_cd,
                        monthly_salary,       salary_grade,   no_of_persons,
                        destination,          height,         weight,
                        sex,                  ac_class_cd,    group_print_sw)
                 VALUES(p_new_par_id, v_item_no,      v_date_of_birth, 
                        v_age,                v_civil_status, v_position_cd,
                        v_monthly_salary,     v_salary_grade, v_no_of_persons,
                        v_destination,        v_height,       v_weight,
                        v_sex,                v_ac_class_cd,  v_group_print_sw);              
                  --POPULATE_GROUP_ITEMS(v_item_no);  /*Commented by aivhie 111601 */
                  POPULATE_GROUP_ITEM(v_item_no, p_old_pol_id, p_line_ac, p_menu_line_cd, p_new_par_id, p_line_ca, p_proc_summary_sw, p_msg); /*Added by aivhie 111601*/
                  POPULATE_BENEFICIARY(v_item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_msg);
                  --POPULATE_GROUP_BENEFICIARY(v_item_no);  
                  v_group_print_sw   := NULL;
                  v_date_of_birth    := NULL;
                  v_age              := NULL; 
                  v_civil_status     := NULL;
                  v_position_cd      := NULL;
                  v_monthly_salary   := NULL;
                  v_salary_grade     := NULL;
                  v_no_of_persons    := NULL;
                  v_destination      := NULL;
                  v_height           := NULL;
                  v_weight           := NULL;
                  v_sex              := NULL;
                  v_ac_class_cd      := NULL;              
              ELSE
                 EXIT;             
              END IF;                        
          END LOOP;
     END LOOP;
   END IF;
END;
/



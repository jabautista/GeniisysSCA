CREATE OR REPLACE PROCEDURE CPI.POPULATE_MOTORCAR (
    v_item_no          IN  NUMBER,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wvehicle.par_id%TYPE,
    p_user             IN  gipi_wmcacc.user_id%TYPE,
    p_msg             OUT  VARCHAR2
) 
IS
  --rg_id                   RECORDGROUP;
  rg_name                 VARCHAR2(30) := 'GROUP_POLICY';
  rg_count                NUMBER;
  rg_count2               NUMBER;
  rg_col                  VARCHAR2(50) := rg_name || '.policy_id';
  item_exist              VARCHAR2(1); 
  v_row                   NUMBER;
  v_policy_id             gipi_polbasic.policy_id%TYPE;
  v_endt_id               gipi_polbasic.policy_id%TYPE;
  v_subline_cd            gipi_wvehicle.subline_cd%TYPE;
  v_coc_yy                gipi_wvehicle.coc_yy%TYPE;
  v_coc_type              gipi_wvehicle.coc_type%TYPE;
  v_repair_lim            gipi_wvehicle.repair_lim%TYPE;
  v_color                 gipi_wvehicle.color%TYPE;
  v_motor_no              gipi_wvehicle.motor_no%TYPE;
  v_model_year            gipi_wvehicle.model_year%TYPE;
  v_make                  gipi_wvehicle.make%TYPE;
  v_mot_type              gipi_wvehicle.mot_type%TYPE;
  v_est_value             gipi_wvehicle.est_value%TYPE;
  v_serial_no             gipi_wvehicle.serial_no%TYPE;
  v_towing                gipi_wvehicle.towing%TYPE;
  v_assignee              gipi_wvehicle.assignee%TYPE;
  v_plate_no              gipi_wvehicle.plate_no%TYPE;
  v_no_of_pass            gipi_wvehicle.no_of_pass%TYPE;
  v_tariff_zone           gipi_wvehicle.tariff_zone%TYPE;
  v_coc_issue_date        gipi_wvehicle.coc_issue_date%TYPE;
  v_subline_type_cd       gipi_wvehicle.subline_type_cd%TYPE;
  v_ctv_tag               gipi_wvehicle.ctv_tag%TYPE;
  v_mv_file_no            gipi_wvehicle.mv_file_no%TYPE;
  v_acquired_from         gipi_wvehicle.acquired_from%TYPE;
  v_car_company_cd        gipi_wvehicle.car_company_cd%TYPE;
  v_type_of_body_cd       gipi_wvehicle.type_of_body_cd%TYPE;
  v_make_cd               gipi_wvehicle.make_cd%TYPE;
  v_series_cd             gipi_wvehicle.series_cd%TYPE;
  v_basic_color_cd        gipi_wvehicle.basic_color_cd%TYPE;
  v_color_cd              gipi_wvehicle.color_cd%TYPE;
  v_unladen_wt            gipi_wvehicle.unladen_wt%TYPE;
  v_origin                gipi_wvehicle.origin%TYPE;
  v_destination           gipi_wvehicle.destination%TYPE;
  v_motor_coverage        gipi_wvehicle.motor_coverage%TYPE;
  v_reg_type			  gipi_wvehicle.reg_type%TYPE;
  v_tax_type			  gipi_wvehicle.tax_type%TYPE;
  v_mv_type				  gipi_wvehicle.mv_type%TYPE;
  v_mv_prem_type		  gipi_wvehicle.mv_prem_type%TYPE;
  
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;  
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-24-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_MOTORCAR program unit 
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
              ( SELECT subline_cd,
                       coc_yy,               coc_type,          repair_lim,    
                       color,                motor_no,          model_year,
                       make,                 mot_type,          est_value,      
                       serial_no,            towing,            assignee,       
                       plate_no,             no_of_pass,        tariff_zone,    
                       coc_issue_date,       subline_type_cd,   ctv_tag,
                       mv_file_no,           acquired_from,     car_company_cd,    
                       type_of_body_cd,      make_cd,           series_cd,         
                       basic_color_cd,       color_cd,          unladen_wt,        
                       origin,               destination,       motor_coverage,
                       reg_type,		     mv_type, 			mv_prem_type,
                       tax_type
                  FROM gipi_vehicle
                 WHERE item_no = v_item_no
                   AND policy_id = v_policy_id               
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wvehicle
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN         
                 v_subline_cd       := data.subline_cd;
                 v_coc_yy           := data.coc_yy;
                 v_coc_type         := data.coc_type; 
                 v_repair_lim       := data.repair_lim;
                 v_color            := data.color;
                 v_motor_no         := data.motor_no;
                 v_model_year       := data.model_year;
                 v_make             := data.make;
                 v_mot_type         := data.mot_type;
                 v_est_value        := data.est_value;
                 v_serial_no        := data.serial_no;
                 v_towing           := data.towing;
                 v_assignee         := data.assignee;
                 v_plate_no         := data.plate_no;
                 v_no_of_pass       := data.no_of_pass;
                 v_tariff_zone      := data.tariff_zone;
                 v_coc_issue_date   := data.coc_issue_date;       
                 v_subline_type_cd  := data.subline_type_cd;
                 v_ctv_tag          := data.ctv_tag;
                 v_mv_file_no       := data.mv_file_no;
                 v_acquired_from    := data.acquired_from;
                 v_car_company_cd   := data.car_company_cd;
                 v_type_of_body_cd  := data.type_of_body_cd;
                 v_make_cd          := data.make_cd;
                 v_series_cd        := data.series_cd;
                 v_basic_color_cd   := data.basic_color_cd;
                 v_color_cd         := data.color_cd;
                 v_unladen_wt       := data.unladen_wt;
                 v_origin           := data.origin;
                 v_destination      := data.destination;
                 v_motor_coverage   := data.motor_coverage;
                 v_reg_type   		:= data.reg_type;
                 v_mv_type   		:= data.mv_type;
                 v_mv_prem_type   	:= data.mv_prem_type;
                 v_tax_type   		:= data.tax_type;                 
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
                            ( SELECT subline_cd,    coc_yy,           coc_type,         repair_lim,    
                                   color,           motor_no,         model_year,       make,                 
                                   mot_type,        est_value,        serial_no,        towing,            
                                   assignee,        plate_no,         no_of_pass,       tariff_zone,    
                                   coc_issue_date,  subline_type_cd,  ctv_tag,          mv_file_no,           
                                   acquired_from,   car_company_cd,   type_of_body_cd,  make_cd,                      
                                   series_cd,       basic_color_cd,   color_cd,         unladen_wt,
                                   origin,          destination,      motor_coverage
                              FROM gipi_vehicle
                             WHERE item_no = v_item_no 
                               AND policy_id = v_endt_id
                         ) LOOP
                         v_subline_cd       := NVL(data2.subline_cd, v_subline_cd);
                         v_coc_yy           := NVL(data2.coc_yy, v_coc_yy);
                         v_coc_type         := NVL(data2.coc_type, v_coc_type); 
                         v_repair_lim       := NVL(data2.repair_lim, v_repair_lim);
                         v_color            := NVL(data2.color, v_color);
                         v_motor_no         := NVL(data2.motor_no,v_motor_no);
                         v_model_year       := NVL(data2.model_year, v_model_year);
                         v_make             := NVL(data2.make, v_make);
                         v_mot_type         := NVL(data2.mot_type, v_mot_type);
                         v_est_value        := NVL(data2.est_value, v_est_value);
                         v_serial_no        := NVL(data2.serial_no, v_serial_no);
                         v_towing           := NVL(data2.towing, v_towing);
                         v_assignee         := NVL(data2.assignee, v_assignee);
                         v_plate_no         := NVL(data2.plate_no, v_plate_no);
                         v_no_of_pass       := NVL(data2.no_of_pass, v_no_of_pass);
                         v_tariff_zone      := NVL(data2.tariff_zone, v_tariff_zone);
                         v_coc_issue_date   := NVL(data2.coc_issue_date, v_coc_issue_date);       
                         v_subline_type_cd  := NVL(data2.subline_type_cd, v_subline_type_cd);
                         v_ctv_tag          := NVL(data2.ctv_tag, v_ctv_tag);
                         v_mv_file_no       := NVL(data2.mv_file_no, v_mv_file_no);
                         v_acquired_from    := NVL(data2.acquired_from, v_acquired_from);
                         v_car_company_cd   := NVL(data2.car_company_cd, v_car_company_cd);
                         v_type_of_body_cd  := NVL(data2.type_of_body_cd, v_type_of_body_cd);
                         v_make_cd          := NVL(data2.make_cd, v_make_cd);
                         v_series_cd        := NVL(data2.series_cd, v_series_cd);
                         v_basic_color_cd   := NVL(data2.basic_color_cd, v_basic_color_cd);
                         v_color_cd         := NVL(data2.color_cd, v_color_cd);
                         v_unladen_wt       := NVL(data2.unladen_wt, v_unladen_wt);
                         v_origin           := NVL(data2.origin, v_origin);
                         v_destination      := NVL(data2.destination, v_destination);
                         v_motor_coverage   := NVL(data2.motor_coverage, v_motor_coverage);
                     END LOOP;
                 END LOOP;    
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying vehicle info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                   INSERT INTO gipi_wvehicle(
                               par_id,               item_no,           subline_cd,
                               coc_yy,               coc_type,          repair_lim,    
                               color,                motor_no,          model_year,
                               make,                 mot_type,          est_value,      
                               serial_no,            towing,            assignee,       
                               plate_no,             no_of_pass,        tariff_zone,    
                               coc_issue_date,       subline_type_cd,   ctv_tag,
                               mv_file_no,           acquired_from,          car_company_cd,   
                               type_of_body_cd,      make_cd,                      series_cd,       
                               basic_color_cd,       color_cd,          unladen_wt,
                               origin,               destination,       motor_coverage,
                               mv_type,              mv_prem_type,		 tax_type)          
                       VALUES(p_new_par_id,          v_item_no,         v_subline_cd,
                               v_coc_yy,             v_coc_type,        v_repair_lim,   
                               v_color,              v_motor_no,        v_model_year,    
                               v_make,               v_mot_type,        v_est_value,     
                               v_serial_no,          v_towing,          v_assignee,      
                               v_plate_no,           v_no_of_pass,      v_tariff_zone,  
                               v_coc_issue_date,     v_subline_type_cd, v_ctv_tag,
                               v_mv_file_no,         v_acquired_from,   v_car_company_cd,   
                               v_type_of_body_cd,    v_make_cd,         v_series_cd,       
                               v_basic_color_cd,     v_color_cd,        v_unladen_wt,
                               v_origin,             v_destination,     v_motor_coverage,
                               v_mv_type,         	 v_mv_prem_type,	v_tax_type);
                 populate_accessory(v_item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_user, p_msg);        
                 v_subline_cd       := NULL;
                 v_coc_yy           := NULL;
                 v_coc_type         := NULL; 
                 v_repair_lim       := NULL;
                 v_color            := NULL;
                 v_motor_no         := NULL;
                 v_model_year       := NULL;
                 v_make             := NULL;
                 v_mot_type         := NULL;
                 v_est_value        := NULL;
                 v_serial_no        := NULL;
                 v_towing           := NULL;
                 v_assignee         := NULL;
                 v_plate_no         := NULL;
                 v_no_of_pass       := NULL;
                 v_tariff_zone      := NULL;
                 v_coc_issue_date   := NULL;       
                 v_subline_type_cd  := NULL;
                 v_ctv_tag          := NULL;
                 v_mv_file_no       := NULL;    
                 v_acquired_from    := NULL;    
                 v_car_company_cd   := NULL;    
                 v_type_of_body_cd  := NULL;    
                 v_make_cd          := NULL;    
                 v_series_cd        := NULL;    
                 v_basic_color_cd   := NULL;    
                 v_color_cd         := NULL;    
                 v_unladen_wt       := NULL;    
                 v_origin           := NULL;    
                 v_destination      := NULL;    
                 v_motor_coverage   := NULL;
                 v_reg_type   		:= NULL;
                 v_mv_type   		:= NULL;
                 v_mv_prem_type   	:= NULL;
                 v_tax_type   		:= NULL;                 
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
              ( SELECT subline_cd,
                       coc_yy,               coc_type,          repair_lim,    
                       color,                motor_no,          model_year,
                       make,                 mot_type,          est_value,      
                       serial_no,            towing,            assignee,       
                       plate_no,             no_of_pass,        tariff_zone,    
                       coc_issue_date,       subline_type_cd,   ctv_tag,
                       mv_file_no,           acquired_from,     car_company_cd,    
                       type_of_body_cd,      make_cd,           series_cd,         
                       basic_color_cd,       color_cd,          unladen_wt,        
                       origin,               destination,       motor_coverage,
                       reg_type, 			 mv_type,			mv_prem_type,
                       tax_type
                  FROM gipi_vehicle
                 WHERE item_no = v_item_no
                   AND policy_id = v_policy_id               
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wvehicle
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN         
                 v_subline_cd       := data.subline_cd;
                 v_coc_yy           := data.coc_yy;
                 v_coc_type         := data.coc_type; 
                 v_repair_lim       := data.repair_lim;
                 v_color            := data.color;
                 v_motor_no         := data.motor_no;
                 v_model_year       := data.model_year;
                 v_make             := data.make;
                 v_mot_type         := data.mot_type;
                 v_est_value        := data.est_value;
                 v_serial_no        := data.serial_no;
                 v_towing           := data.towing;
                 v_assignee         := data.assignee;
                 v_plate_no         := data.plate_no;
                 v_no_of_pass       := data.no_of_pass;
                 v_tariff_zone      := data.tariff_zone;
                 v_coc_issue_date   := data.coc_issue_date;       
                 v_subline_type_cd  := data.subline_type_cd;
                 v_ctv_tag          := data.ctv_tag;
                 v_mv_file_no       := data.mv_file_no;
                 v_acquired_from    := data.acquired_from;
                 v_car_company_cd   := data.car_company_cd;
                 v_type_of_body_cd  := data.type_of_body_cd;
                 v_make_cd          := data.make_cd;
                 v_series_cd        := data.series_cd;
                 v_basic_color_cd   := data.basic_color_cd;
                 v_color_cd         := data.color_cd;
                 v_unladen_wt       := data.unladen_wt;
                 v_origin           := data.origin;
                 v_destination      := data.destination;
                 v_motor_coverage   := data.motor_coverage;
                 v_reg_type   		:= data.reg_type;
                 v_mv_type   		:= data.mv_type;
                 v_mv_prem_type   	:= data.mv_prem_type;
                 v_tax_type   		:= data.tax_type;
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
                            ( SELECT subline_cd,    coc_yy,           coc_type,         repair_lim,    
                                   color,           motor_no,         model_year,       make,                 
                                   mot_type,        est_value,        serial_no,        towing,            
                                   assignee,        plate_no,         no_of_pass,       tariff_zone,    
                                   coc_issue_date,  subline_type_cd,  ctv_tag,          mv_file_no,           
                                   acquired_from,   car_company_cd,   type_of_body_cd,  make_cd,                      
                                   series_cd,       basic_color_cd,   color_cd,         unladen_wt,
                                   origin,          destination,      motor_coverage
                              FROM gipi_vehicle
                             WHERE item_no = v_item_no 
                               AND policy_id = v_endt_id
                         ) LOOP
                         v_subline_cd       := NVL(data2.subline_cd, v_subline_cd);
                         v_coc_yy           := NVL(data2.coc_yy, v_coc_yy);
                         v_coc_type         := NVL(data2.coc_type, v_coc_type); 
                         v_repair_lim       := NVL(data2.repair_lim, v_repair_lim);
                         v_color            := NVL(data2.color, v_color);
                         v_motor_no         := NVL(data2.motor_no,v_motor_no);
                         v_model_year       := NVL(data2.model_year, v_model_year);
                         v_make             := NVL(data2.make, v_make);
                         v_mot_type         := NVL(data2.mot_type, v_mot_type);
                         v_est_value        := NVL(data2.est_value, v_est_value);
                         v_serial_no        := NVL(data2.serial_no, v_serial_no);
                         v_towing           := NVL(data2.towing, v_towing);
                         v_assignee         := NVL(data2.assignee, v_assignee);
                         v_plate_no         := NVL(data2.plate_no, v_plate_no);
                         v_no_of_pass       := NVL(data2.no_of_pass, v_no_of_pass);
                         v_tariff_zone      := NVL(data2.tariff_zone, v_tariff_zone);
                         v_coc_issue_date   := NVL(data2.coc_issue_date, v_coc_issue_date);       
                         v_subline_type_cd  := NVL(data2.subline_type_cd, v_subline_type_cd);
                         v_ctv_tag          := NVL(data2.ctv_tag, v_ctv_tag);
                         v_mv_file_no       := NVL(data2.mv_file_no, v_mv_file_no);
                         v_acquired_from    := NVL(data2.acquired_from, v_acquired_from);
                         v_car_company_cd   := NVL(data2.car_company_cd, v_car_company_cd);
                         v_type_of_body_cd  := NVL(data2.type_of_body_cd, v_type_of_body_cd);
                         v_make_cd          := NVL(data2.make_cd, v_make_cd);
                         v_series_cd        := NVL(data2.series_cd, v_series_cd);
                         v_basic_color_cd   := NVL(data2.basic_color_cd, v_basic_color_cd);
                         v_color_cd         := NVL(data2.color_cd, v_color_cd);
                         v_unladen_wt       := NVL(data2.unladen_wt, v_unladen_wt);
                         v_origin           := NVL(data2.origin, v_origin);
                         v_destination      := NVL(data2.destination, v_destination);
                         v_motor_coverage   := NVL(data2.motor_coverage, v_motor_coverage);
                     END LOOP;
                 END LOOP;    
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying vehicle info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                   INSERT INTO gipi_wvehicle(
                               par_id,               item_no,           subline_cd,
                               coc_yy,               coc_type,          repair_lim,    
                               color,                motor_no,          model_year,
                               make,                 mot_type,          est_value,      
                               serial_no,            towing,            assignee,       
                               plate_no,             no_of_pass,        tariff_zone,    
                               coc_issue_date,       subline_type_cd,   ctv_tag,
                               mv_file_no,           acquired_from,          car_company_cd,   
                               type_of_body_cd,      make_cd,                      series_cd,       
                               basic_color_cd,       color_cd,          unladen_wt,
                               origin,               destination,       motor_coverage,		 
                               mv_type,              mv_prem_type,		tax_type)          
                       VALUES(p_new_par_id,          v_item_no,         v_subline_cd,
                               v_coc_yy,             v_coc_type,        v_repair_lim,   
                               v_color,              v_motor_no,        v_model_year,    
                               v_make,               v_mot_type,        v_est_value,     
                               v_serial_no,          v_towing,          v_assignee,      
                               v_plate_no,           v_no_of_pass,      v_tariff_zone,  
                               v_coc_issue_date,     v_subline_type_cd, v_ctv_tag,
                               v_mv_file_no,         v_acquired_from,   v_car_company_cd,   
                               v_type_of_body_cd,    v_make_cd,         v_series_cd,       
                               v_basic_color_cd,     v_color_cd,        v_unladen_wt,
                               v_origin,             v_destination,     v_motor_coverage,
                               v_mv_type,            v_mv_prem_type,	v_tax_type);
                 populate_accessory(v_item_no, p_old_pol_id, p_proc_summary_sw, p_new_par_id, p_user, p_msg);        
                 v_subline_cd       := NULL;
                 v_coc_yy           := NULL;
                 v_coc_type         := NULL; 
                 v_repair_lim       := NULL;
                 v_color            := NULL;
                 v_motor_no         := NULL;
                 v_model_year       := NULL;
                 v_make             := NULL;
                 v_mot_type         := NULL;
                 v_est_value        := NULL;
                 v_serial_no        := NULL;
                 v_towing           := NULL;
                 v_assignee         := NULL;
                 v_plate_no         := NULL;
                 v_no_of_pass       := NULL;
                 v_tariff_zone      := NULL;
                 v_coc_issue_date   := NULL;       
                 v_subline_type_cd  := NULL;
                 v_ctv_tag          := NULL;
                 v_mv_file_no       := NULL;    
                 v_acquired_from    := NULL;    
                 v_car_company_cd   := NULL;    
                 v_type_of_body_cd  := NULL;    
                 v_make_cd          := NULL;    
                 v_series_cd        := NULL;    
                 v_basic_color_cd   := NULL;    
                 v_color_cd         := NULL;    
                 v_unladen_wt       := NULL;    
                 v_origin           := NULL;    
                 v_destination      := NULL;    
                 v_motor_coverage   := NULL;
                 v_reg_type   		:= NULL;
                 v_mv_type   		:= NULL;
                 v_mv_prem_type   	:= NULL;
                 v_tax_type   		:= NULL;
              ELSE
                 EXIT;         
              END IF;                        
          END LOOP;
     END LOOP;
   END IF;   
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.GIXX_VEHICLE_PKG AS

   FUNCTION get_pol_doc_vehicle (p_extract_id GIXX_VEHICLE.extract_id%TYPE)
     RETURN pol_doc_vehicle_tab PIPELINED IS
   
     v_vehicle pol_doc_vehicle_type;
   
   BEGIN
     FOR i IN (
        SELECT ALL vehicle.extract_id           extract_id, 
                   vehicle.item_no              vehicle_item_no,
                   vehicle.assignee             vehicle_assignee, 
                   vehicle.origin               vehicle_origin,
                   vehicle.destination          vehicle_destination,
                   vehicle.model_year           vehicle_model_year,
                   carcoy.car_company           vehicle_car_coy, 
                   vehicle.make                 vehicle_make,
                   bodytype.type_of_body        bodytype_type_of_body,
                   vehicle.color                vehicle_color, 
                   vehicle.mv_file_no           vehicle_mv_file_no,
                   LPAD (vehicle.coc_serial_no, 7, 0)
                   || '-'
                   || LPAD (vehicle.coc_yy, 2, 0) vehicle_coc_no,
                   vehicle.coc_issue_date       vehicle_coc_issue_date,
                   vehicle.coc_serial_no        vehicle_coc_serial_no,
                   vehicle.serial_no            vehicle_serial_no,
                   sublinetype.subline_type_desc sublinetype_subline_type_desc,
                   vehicle.acquired_from        vehicle_acquired_from,
                   vehicle.plate_no             vehicle_plate_no,
                   vehicle.no_of_pass           vehicle_no_of_pass,
                   vehicle.unladen_wt           vehicle_unladen_wt,
                   motortype.motor_type_desc    motortyp_motor_type_desc,
                   vehicle.motor_no             vehicle_motor_no,
                   TO_CHAR (NVL (vehicle.towing, 0), '999,999,990.00') vehicle_towing,
                   TO_CHAR (vehicle.repair_lim, '999,999,990.00') vehicle_repair_lim,
                   vehicle.repair_lim,          
                   vehicle.series_cd            vehicle_series_cd,
                   vehicle.make_cd              vehicle_make_cd,
                   vehicle.car_company_cd       vehicle_car_company_cd
              FROM GIXX_VEHICLE         vehicle,
                   GIIS_TYPE_OF_BODY    bodytype,
                   GIIS_MC_SUBLINE_TYPE sublinetype,
                   GIIS_MOTORTYPE       motortype,
                   GIIS_MC_CAR_COMPANY  carcoy
             --,GIXX_DEDUCTIBLES                            DEDUCTIBLES
             WHERE vehicle.extract_id       = p_extract_id
               AND vehicle.type_of_body_cd  = bodytype.type_of_body_cd(+)
               AND vehicle.subline_cd       = sublinetype.subline_cd(+)
               AND vehicle.subline_type_cd  = sublinetype.subline_type_cd(+)
               AND vehicle.subline_cd       = motortype.subline_cd(+)
               AND vehicle.mot_type         = motortype.type_cd(+)
               AND vehicle.car_company_cd   = carcoy.car_company_cd(+))
     LOOP
        v_vehicle.extract_id                      := i.extract_id;
        v_vehicle.vehicle_item_no                 := i.vehicle_item_no;
        v_vehicle.vehicle_assignee                := i.vehicle_assignee;
        v_vehicle.vehicle_origin                  := i.vehicle_origin;
        v_vehicle.vehicle_destination             := i.vehicle_destination;
        v_vehicle.vehicle_model_year              := i.vehicle_model_year;
        v_vehicle.vehicle_car_coy                 := i.vehicle_car_coy;
        v_vehicle.vehicle_make                    := i.vehicle_make;
        v_vehicle.bodytype_type_of_body           := i.bodytype_type_of_body;
        v_vehicle.vehicle_color                   := i.vehicle_color;
        v_vehicle.vehicle_mv_file_no              := i.vehicle_mv_file_no;
        v_vehicle.vehicle_coc_no                  := i.vehicle_coc_no;
        v_vehicle.vehicle_coc_issue_date          := i.vehicle_coc_issue_date;    
        v_vehicle.vehicle_coc_serial_no           := i.vehicle_coc_serial_no;
        v_vehicle.vehicle_serial_no               := i.vehicle_serial_no;
        v_vehicle.sublinetype_subline_type_desc   := i.sublinetype_subline_type_desc;
        v_vehicle.vehicle_acquired_from           := i.vehicle_acquired_from;
        v_vehicle.vehicle_plate_no                := i.vehicle_plate_no;
        v_vehicle.vehicle_no_of_pass              := i.vehicle_no_of_pass;
        v_vehicle.vehicle_unladen_wt              := i.vehicle_unladen_wt;
        v_vehicle.motortyp_motor_type_desc        := i.motortyp_motor_type_desc;
        v_vehicle.vehicle_motor_no                := i.vehicle_motor_no;
        v_vehicle.vehicle_towing                  := i.vehicle_towing;
        v_vehicle.vehicle_repair_lim              := i.vehicle_repair_lim;
        v_vehicle.repair_lim                      := i.repair_lim;
        v_vehicle.vehicle_series_cd               := i.vehicle_series_cd;
        v_vehicle.vehicle_make_cd                 := i.vehicle_make_cd;
        v_vehicle.vehicle_car_company_cd          := i.vehicle_car_company_cd;
       PIPE ROW(v_vehicle);
     END LOOP;
     RETURN;
   END get_pol_doc_vehicle; 
   
   
   
    /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 7, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves vehicle information
  */
  FUNCTION get_vehicle_info(
        p_extract_id    gixx_vehicle.extract_id%TYPE,
        p_item_no       gixx_vehicle.item_no%TYPE,
        p_policy_id     gipi_polbasic.policy_id%TYPE
   ) RETURN gixx_vehicle_tab PIPELINED
   IS
    v_vehicle   gixx_vehicle_type;
   BEGIN
        FOR rec IN (SELECT extract_id, item_no,
                           assignee, coc_type, coc_serial_no, coc_yy,
                           acquired_from, type_of_body_cd,
                           plate_no, model_year, car_company_cd,
                           mv_file_no, no_of_pass, make,
                           basic_color_cd, color_cd, color, 
                           series_cd, make_cd,
                           towing, mot_type, unladen_wt,
                           serial_no, subline_cd, subline_type_cd,
                           repair_lim, motor_no
                      FROM gixx_vehicle
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)
        LOOP
            v_vehicle.extract_id := rec.extract_id;
            v_vehicle.item_no := rec.item_no;
            v_vehicle.assignee := rec.assignee;
            v_vehicle.coc_type := rec.coc_type;
            v_vehicle.coc_serial_no := rec.coc_serial_no;
            v_vehicle.coc_yy := rec.coc_yy;
            v_vehicle.acquired_from := rec.acquired_from;
            v_vehicle.type_of_body_cd := rec.type_of_body_cd;
            v_vehicle.plate_no := rec.plate_no;
            v_vehicle.model_year := rec.model_year;
            v_vehicle.car_company_cd := rec.car_company_cd;
            v_vehicle.mv_file_no := rec.mv_file_no;
            v_vehicle.no_of_pass := rec.no_of_pass;
            v_vehicle.make := rec.make;
            v_vehicle.basic_color_cd := rec.basic_color_cd;
            v_vehicle.color_cd := rec.color_cd;
            v_vehicle.color := rec.color;
            v_vehicle.series_cd := rec.series_cd;
            v_vehicle.make_cd := rec.make_cd;
            v_vehicle.towing := rec.towing;
            v_vehicle.mot_type := rec.mot_type;
            v_vehicle.unladen_wt := rec.unladen_wt;
            v_vehicle.serial_no := rec.serial_no;
            v_vehicle.subline_cd := rec.subline_cd;
            v_vehicle.subline_type_cd := rec.subline_type_cd;
            v_vehicle.repair_lim := rec.repair_lim;
            v_vehicle.motor_no := rec.motor_no;
                   
            FOR a IN (SELECT type_of_body
                        FROM giis_type_of_body
                       WHERE type_of_body_cd = rec.type_of_body_cd)
            LOOP
                v_vehicle.type_of_body := a.type_of_body;
                EXIT;
            END LOOP;	 
            
            FOR b IN (SELECT car_company
                        FROM giis_mc_car_company
                       WHERE car_company_cd = rec.car_company_cd )
            LOOP
	            v_vehicle.car_company := b.car_company;
	            EXIT;
            END LOOP; 
            
            FOR c IN (SELECT series_cd, make_cd, car_company_cd
                        FROM gipi_vehicle
                       WHERE policy_id = p_policy_id
                         AND item_no = p_item_no)
            LOOP
                FOR car IN (SELECT engine_series
                              FROM giis_mc_eng_series
                             WHERE series_cd = c.series_cd
                               AND make_cd = c.make_cd
                               AND car_company_cd = c.car_company_cd)
                LOOP
                    v_vehicle.engine_series := car.engine_series;
                END LOOP;
            END LOOP;            
                        
            FOR d IN (SELECT motor_type_desc
                        FROM giis_motortype
                       WHERE type_cd = rec.mot_type)
            LOOP
                v_vehicle.motor_type_desc := d.motor_type_desc;
            END LOOP;
            
            FOR e IN (SELECT SUM(deductible_amt) amt
                        FROM gixx_deductibles
                       WHERE extract_id = rec.extract_id
                         AND item_no   = rec.item_no)
            LOOP
                v_vehicle.deductible := e.amt;
            END LOOP;
            
            FOR f IN (SELECT subline_type_desc
                        FROM giis_mc_subline_type
                       WHERE subline_cd = rec.subline_cd
                         AND subline_type_cd = rec.subline_type_cd)
            LOOP
                v_vehicle.subline_type_desc := f.subline_type_desc;
            END LOOP;
            
            FOR g IN (SELECT basic_color
                        FROM giis_mc_color
                       WHERE basic_color_cd = rec.basic_color_cd) 
            LOOP
                v_vehicle.basic_color := g.basic_color;
            END LOOP;
            
            PIPE ROW(v_vehicle);
        END LOOP;
   END get_vehicle_info;

END GIXX_VEHICLE_PKG;
/



DROP PROCEDURE CPI.GIPIS031_CREATE_VEHICLE_ITEM;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_CREATE_VEHICLE_ITEM (
	p_par_id IN gipi_witem.par_id%TYPE,
	p_item_no IN gipi_witem.item_no%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.03.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description     : This procedure is used for inserting records to GIPI_VEHICLE table
    */
    v_eff_date           gipi_polbasic.eff_date%TYPE;
    v_max_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE;
    v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE;
    
    CURSOR A IS
        SELECT a.policy_id policy_id, a.eff_date eff_date
          FROM gipi_polbasic a
         WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
               (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
           AND a.pol_flag                IN ('1','2','3')
           AND EXISTS (SELECT '1'
                         FROM gipi_vehicle b
                        WHERE b.item_no = p_item_no
                          AND b.policy_id = a.policy_id)      
      ORDER BY eff_date DESC;
      
    CURSOR B (p_policy_id  GIPI_ITEM.policy_id%TYPE) IS
        SELECT *
          FROM gipi_vehicle
         WHERE policy_id   =  p_policy_id
           AND item_no     =  p_item_no;
           
    CURSOR D IS
        SELECT a.policy_id policy_id, a.eff_date eff_date
          FROM gipi_polbasic a
         WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
               (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
           AND a.pol_flag    IN( '1','2','3')
           AND NVL(a.back_stat,5) = 2
           AND EXISTS (SELECT '1'
                         FROM gipi_vehicle b
                        WHERE b.item_no = p_item_no
                          AND a.policy_id = b.policy_id)      
           AND a.endt_seq_no = (SELECT MAX(endt_seq_no)
                                  FROM gipi_polbasic c
                                 WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
                                       (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                                          FROM gipi_wpolbas
                                         WHERE par_id = p_par_id)
                                   AND pol_flag  IN( '1','2','3')
                                   AND NVL(c.back_stat,5) = 2
                                   AND EXISTS (SELECT '1'
                                                 FROM gipi_vehicle d
                                                WHERE d.item_no = p_item_no
                                                  AND c.policy_id = d.policy_id))                        
      ORDER BY   eff_date DESC;

    v_new_item   VARCHAR2(1) := 'Y'; 
    v_expired_sw   VARCHAR2(1) := 'N';
BEGIN
    FOR Z IN (
        SELECT MAX(endt_seq_no) endt_seq_no
          FROM gipi_polbasic a
         WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
               (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
           AND pol_flag  IN( '1','2','3')
           AND EXISTS (SELECT '1'
                         FROM gipi_vehicle b
                        WHERE b.item_no = p_item_no
                          AND a.policy_id = b.policy_id))
    LOOP
        v_max_endt_seq_no := z.endt_seq_no;
        EXIT;
    END LOOP;
    
    FOR X IN (
        SELECT MAX(endt_seq_no) endt_seq_no
          FROM gipi_polbasic a
         WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
               (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM GIPI_WPOLBAS
                 WHERE par_id = p_par_id)
           AND pol_flag  IN( '1','2','3')
           AND NVL(a.back_stat,5) = 2
           AND EXISTS (SELECT '1'
                         FROM gipi_vehicle b
                        WHERE b.item_no = p_item_no
                          AND a.policy_id = b.policy_id))
    LOOP
        v_max_endt_seq_no1 := X.endt_seq_no;
        EXIT;
    END LOOP;
    
    IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN                                 
        FOR D1 IN D LOOP
            FOR B1 IN B(D1.policy_id) LOOP
                IF v_eff_date  IS NULL THEN
                    INSERT INTO gipi_wvehicle (
                        par_id,            item_no,        subline_cd,            motor_no,
                        plate_no,        est_value,        make,                mot_type,
                        color,            repair_lim,        serial_no,            coc_seq_no,
                        coc_serial_no,    coc_type,        assignee,            model_year,
                        coc_issue_date,    coc_yy,            towing,                subline_type_cd,
                        no_of_pass,        tariff_zone,    mv_file_no,            acquired_from,
                        ctv_tag,        car_company_cd,    type_of_body_cd,    unladen_wt,
                        make_cd,        series_cd,        basic_color_cd,        color_cd,
                        origin,            destination,    coc_atcn,            motor_coverage,
                        coc_serial_sw)
                    VALUES (
                        p_par_id,           p_item_no,        b1.subline_cd,            b1.motor_no,
                        b1.plate_no,        b1.est_value,        b1.make,            b1.mot_type,
                        b1.color,            b1.repair_lim,        b1.serial_no,        b1.coc_seq_no,
                        b1.coc_serial_no,    b1.coc_type,        b1.assignee,        b1.model_year,
                        b1.coc_issue_date,    b1.coc_yy,            b1.towing,            b1.subline_type_cd,
                        b1.no_of_pass,        b1.tariff_zone,        b1.mv_file_no,        b1.acquired_from,
                        b1.ctv_tag,            b1.car_company_cd,    b1.type_of_body_cd,    b1.unladen_wt,
                        b1.make_cd,            b1.series_cd,        b1.basic_color_cd,    b1.color_cd,
                        b1.origin,            b1.destination,        b1.coc_atcn,        b1.motor_coverage,
                        b1.coc_serial_sw);                    
                END IF;
                IF D1.eff_date > v_eff_date THEN
                    INSERT INTO gipi_wvehicle (
                        par_id,            item_no,        subline_cd,            motor_no,
                        plate_no,        est_value,        make,                mot_type,
                        color,            repair_lim,        serial_no,            coc_seq_no,
                        coc_serial_no,    coc_type,        assignee,            model_year,
                        coc_issue_date,    coc_yy,            towing,                subline_type_cd,
                        no_of_pass,        tariff_zone,    mv_file_no,            acquired_from,
                        ctv_tag,        car_company_cd,    type_of_body_cd,    unladen_wt,
                        make_cd,        series_cd,        basic_color_cd,        color_cd,
                        origin,            destination,    coc_atcn,            motor_coverage,
                        coc_serial_sw)
                    VALUES (
                        p_par_id,           p_item_no,        b1.subline_cd,            b1.motor_no,
                        b1.plate_no,        b1.est_value,        b1.make,            b1.mot_type,
                        b1.color,            b1.repair_lim,        b1.serial_no,        b1.coc_seq_no,
                        b1.coc_serial_no,    b1.coc_type,        b1.assignee,        b1.model_year,
                        b1.coc_issue_date,    b1.coc_yy,            b1.towing,            b1.subline_type_cd,
                        b1.no_of_pass,        b1.tariff_zone,        b1.mv_file_no,        b1.acquired_from,
                        b1.ctv_tag,            b1.car_company_cd,    b1.type_of_body_cd,    b1.unladen_wt,
                        b1.make_cd,            b1.series_cd,        b1.basic_color_cd,    b1.color_cd,
                        b1.origin,            b1.destination,        b1.coc_atcn,        b1.motor_coverage,
                        b1.coc_serial_sw);
                END IF;
            END LOOP;
            EXIT;
        END LOOP;
    ELSE
        FOR A1 IN A LOOP     
            FOR B1 IN B(A1.policy_id) LOOP
                IF v_eff_date  IS NULL THEN
                    v_eff_date  :=  A1.eff_date;
                    INSERT INTO gipi_wvehicle (
                        par_id,            item_no,        subline_cd,            motor_no,
                        plate_no,        est_value,        make,                mot_type,
                        color,            repair_lim,        serial_no,            coc_seq_no,
                        coc_serial_no,    coc_type,        assignee,            model_year,
                        coc_issue_date,    coc_yy,            towing,                subline_type_cd,
                        no_of_pass,        tariff_zone,    mv_file_no,            acquired_from,
                        ctv_tag,        car_company_cd,    type_of_body_cd,    unladen_wt,
                        make_cd,        series_cd,        basic_color_cd,        color_cd,
                        origin,            destination,    coc_atcn,            motor_coverage,
                        coc_serial_sw)
                    VALUES (
                        p_par_id,           p_item_no,        b1.subline_cd,            b1.motor_no,
                        b1.plate_no,        b1.est_value,        b1.make,            b1.mot_type,
                        b1.color,            b1.repair_lim,        b1.serial_no,        b1.coc_seq_no,
                        b1.coc_serial_no,    b1.coc_type,        b1.assignee,        b1.model_year,
                        b1.coc_issue_date,    b1.coc_yy,            b1.towing,            b1.subline_type_cd,
                        b1.no_of_pass,        b1.tariff_zone,        b1.mv_file_no,        b1.acquired_from,
                        b1.ctv_tag,            b1.car_company_cd,    b1.type_of_body_cd,    b1.unladen_wt,
                        b1.make_cd,            b1.series_cd,        b1.basic_color_cd,    b1.color_cd,
                        b1.origin,            b1.destination,        b1.coc_atcn,        b1.motor_coverage,
                        b1.coc_serial_sw);
                END IF;
                IF A1.eff_date > v_eff_date THEN
                    v_eff_date  :=  A1.eff_date;
                    INSERT INTO gipi_wvehicle (
                        par_id,            item_no,        subline_cd,            motor_no,
                        plate_no,        est_value,        make,                mot_type,
                        color,            repair_lim,        serial_no,            coc_seq_no,
                        coc_serial_no,    coc_type,        assignee,            model_year,
                        coc_issue_date,    coc_yy,            towing,                subline_type_cd,
                        no_of_pass,        tariff_zone,    mv_file_no,            acquired_from,
                        ctv_tag,        car_company_cd,    type_of_body_cd,    unladen_wt,
                        make_cd,        series_cd,        basic_color_cd,        color_cd,
                        origin,            destination,    coc_atcn,            motor_coverage,
                        coc_serial_sw)
                    VALUES (
                        p_par_id,           p_item_no,        b1.subline_cd,            b1.motor_no,
                        b1.plate_no,        b1.est_value,        b1.make,            b1.mot_type,
                        b1.color,            b1.repair_lim,        b1.serial_no,        b1.coc_seq_no,
                        b1.coc_serial_no,    b1.coc_type,        b1.assignee,        b1.model_year,
                        b1.coc_issue_date,    b1.coc_yy,            b1.towing,            b1.subline_type_cd,
                        b1.no_of_pass,        b1.tariff_zone,        b1.mv_file_no,        b1.acquired_from,
                        b1.ctv_tag,            b1.car_company_cd,    b1.type_of_body_cd,    b1.unladen_wt,
                        b1.make_cd,            b1.series_cd,        b1.basic_color_cd,    b1.color_cd,
                        b1.origin,            b1.destination,        b1.coc_atcn,        b1.motor_coverage,
                        b1.coc_serial_sw);
                END IF;
            END LOOP;     
            EXIT;
        END LOOP;  
    END IF;
END GIPIS031_CREATE_VEHICLE_ITEM;
/



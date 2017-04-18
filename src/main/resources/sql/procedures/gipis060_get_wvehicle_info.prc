DROP PROCEDURE CPI.GIPIS060_GET_WVEHICLE_INFO;

CREATE OR REPLACE PROCEDURE CPI.gipis060_get_wvehicle_info (
   p_policy_id                   gipi_polbasic.policy_id%TYPE,
   p_item_no                     gipi_witem.item_no%TYPE,
   p_subline_cd            OUT   gipi_wvehicle.subline_cd%TYPE,
   p_motor_coverage        OUT   gipi_wvehicle.motor_coverage%TYPE,
   p_motor_coverage_desc   OUT   cg_ref_codes.rv_meaning%TYPE,
   p_assignee              OUT   gipi_wvehicle.assignee%TYPE,
   p_origin                OUT   gipi_wvehicle.origin%TYPE,
   p_plate_no              OUT   gipi_wvehicle.plate_no%TYPE,
   p_mv_file_no            OUT   gipi_wvehicle.mv_file_no%TYPE,
   p_basic_color_cd        OUT   gipi_wvehicle.basic_color_cd%TYPE,
   p_mot_type              OUT   gipi_wvehicle.mot_type%TYPE,
   p_motor_type_desc       OUT   giis_motortype.motor_type_desc%TYPE,
   p_serial_no             OUT   gipi_wvehicle.serial_no%TYPE,
   p_coc_type              OUT   gipi_wvehicle.coc_type%TYPE,
   p_coc_yy                OUT   gipi_wvehicle.coc_yy%TYPE,
   p_coc_serial_no         OUT   gipi_wvehicle.coc_serial_no%TYPE,
   p_acquired_from         OUT   gipi_wvehicle.acquired_from%TYPE,
   p_destination           OUT   gipi_wvehicle.destination%TYPE,
   p_model_year            OUT   gipi_wvehicle.model_year%TYPE,
   p_no_of_pass            OUT   gipi_wvehicle.no_of_pass%TYPE,
   p_color_cd              OUT   gipi_wvehicle.color_cd%TYPE,
   p_color                 OUT   gipi_wvehicle.color%TYPE,
   p_unladen_wt            OUT   gipi_wvehicle.unladen_wt%TYPE,
   p_subline_type_cd       OUT   giis_mc_subline_type.subline_type_cd%TYPE,
   p_subline_type_desc     OUT   giis_mc_subline_type.subline_type_desc%TYPE,
   p_motor_no              OUT   gipi_wvehicle.motor_no%TYPE,
   p_type_of_body_cd       OUT   gipi_wvehicle.type_of_body_cd%TYPE,
   p_car_company_cd        OUT   gipi_wvehicle.car_company_cd%TYPE,
   p_car_company           OUT   giis_mc_car_company.car_company%TYPE,
   p_make                  OUT   gipi_wvehicle.make%TYPE,
   p_make_cd               OUT   gipi_wvehicle.make_cd%TYPE,
   p_series_cd             OUT   gipi_wvehicle.series_cd%TYPE,
   p_towing                OUT   gipi_wvehicle.towing%TYPE,
   p_repair_lim            OUT   gipi_wvehicle.repair_lim%TYPE
)
IS
BEGIN
   FOR c2 IN (SELECT subline_cd, assignee, motor_coverage, origin, plate_no,
                     mv_file_no, basic_color_cd, mot_type, serial_no,
                     coc_type, coc_yy, coc_serial_no, acquired_from,
                     destination, model_year, no_of_pass, color_cd, color,
                     unladen_wt, subline_type_cd, motor_no, type_of_body_cd,
                     car_company_cd, make, make_cd, series_cd, towing,
                     repair_lim
                FROM gipi_vehicle
               WHERE policy_id = p_policy_id AND item_no = p_item_no)
   LOOP
      p_subline_cd := c2.subline_cd;
      p_motor_coverage := c2.motor_coverage;
      p_assignee := c2.assignee;
      p_origin := c2.origin;
      p_plate_no := c2.plate_no;
      p_mv_file_no := c2.mv_file_no;
      p_basic_color_cd := c2.basic_color_cd;
      p_mot_type := c2.mot_type;
      p_serial_no := c2.serial_no;
      p_coc_type := c2.coc_type;
      p_coc_yy := c2.coc_yy;
      p_coc_serial_no := c2.coc_serial_no;
      p_acquired_from := c2.acquired_from;
      p_destination := c2.destination;
      p_model_year := c2.model_year;
      p_no_of_pass := c2.no_of_pass;
      p_color_cd := c2.color_cd;
      p_color := c2.color;
      p_unladen_wt := c2.unladen_wt;
      p_subline_type_cd := c2.subline_type_cd;
      p_motor_no := c2.motor_no;
      p_type_of_body_cd := c2.type_of_body_cd;
      p_car_company_cd := c2.car_company_cd;
      p_make := c2.make;
      p_make_cd := c2.make_cd;
      p_series_cd := c2.series_cd;
      p_towing := c2.towing;
      p_repair_lim := c2.repair_lim;
      EXIT;
   END LOOP;

   /*yvette,06.05.2006 to retrieve values of motor type description, subline type and motor coverage.*/
   FOR d2 IN (SELECT motor_type_desc
                FROM giis_motortype
               WHERE type_cd = p_mot_type AND subline_cd = p_subline_cd)
   LOOP
      p_motor_type_desc := d2.motor_type_desc;
   END LOOP;

   FOR e2 IN (SELECT subline_type_desc
                FROM giis_mc_subline_type a, gipi_vehicle b
               WHERE a.subline_type_cd = b.subline_type_cd
                 AND a.subline_cd = b.subline_cd
                 AND a.subline_cd = p_subline_cd
                 AND a.subline_type_cd = p_subline_type_cd
                 AND b.policy_id = p_policy_id)
   LOOP
      p_subline_type_desc := e2.subline_type_desc;
   END LOOP;

   FOR f2 IN (SELECT rv_meaning mc_desc
                FROM cg_ref_codes
               WHERE rv_low_value = p_motor_coverage
                 AND rv_domain = 'GIPI_VEHICLE.MOTOR_COVERAGE')
   LOOP
      p_motor_coverage_desc := f2.mc_desc;
   END LOOP;

   FOR car IN (SELECT car_company
                 FROM giis_mc_car_company
                WHERE car_company_cd = p_car_company_cd)
   LOOP
      p_car_company := car.car_company;
   END LOOP;
END;
/



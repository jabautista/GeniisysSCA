CREATE OR REPLACE PACKAGE BODY CPI.gipi_vehicle_pkg
AS
/*
**  Created by   : Menandro G.C. Robes
**  Date Created : June 3, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril Information)
**  Description  : Function to retrieve motor type code from GIPI_VEHICLE.
*/
   FUNCTION get_mot_type (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_eff_date      gipi_wpolbas.eff_date%TYPE;
      v_line_cd       gipi_wpolbas.line_cd%TYPE;
      v_subline_cd    gipi_wpolbas.subline_cd%TYPE;
      v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
      v_issue_yy      gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no      gipi_wpolbas.renew_no%TYPE;
      v_expiry_date   gipi_wpolbas.expiry_date%TYPE;
      v_mot_type      gipi_vehicle.mot_type%TYPE;
   BEGIN
      v_expiry_date := extract_expiry (p_par_id);

      FOR i IN (SELECT incept_date, eff_date, endt_expiry_date, expiry_date,
                       short_rt_percent, line_cd, subline_cd, iss_cd,
                       issue_yy, pol_seq_no, renew_no, comp_sw, prorate_flag
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
      LOOP
         v_eff_date := i.eff_date;
         v_expiry_date := i.expiry_date;
         v_line_cd := i.line_cd;
         v_subline_cd := i.subline_cd;
         v_iss_cd := i.iss_cd;
         v_issue_yy := i.issue_yy;
         v_pol_seq_no := i.pol_seq_no;
         v_renew_no := i.renew_no;
         EXIT;
      END LOOP;

      FOR motor1 IN (SELECT   mot_type
                         FROM gipi_vehicle A, gipi_polbasic b
                        WHERE b.policy_id = A.policy_id
                          AND b.pol_flag IN ('1', '2', '3', 'X')
                          AND A.mot_type IS NOT NULL
                          AND b.line_cd = v_line_cd
                          AND b.subline_cd = v_subline_cd
                          AND b.iss_cd = v_iss_cd
                          AND b.issue_yy = v_issue_yy
                          AND b.pol_seq_no = v_pol_seq_no
                          AND b.renew_no = v_renew_no
                          AND A.item_no = p_item_no
                          AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                          AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                  b.expiry_date
                                                 ),
                                             b.expiry_date, v_expiry_date,
                                             b.endt_expiry_date, b.endt_expiry_date
                                            )
                                    ) >= v_eff_date
                     ORDER BY b.eff_date DESC)
      LOOP
         v_mot_type := motor1.mot_type;
         EXIT;
      END LOOP;

      RETURN v_mot_type;
   END get_mot_type;

/*
**  Created by   : Menandro G.C. Robes
**  Date Created : June 3, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril Information)
**  Description  : Function to retrieve subline type code from GIPI_VEHICLE.
*/
   FUNCTION get_subline_type_cd (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_eff_date          gipi_wpolbas.eff_date%TYPE;
      v_line_cd           gipi_wpolbas.line_cd%TYPE;
      v_subline_cd        gipi_wpolbas.subline_cd%TYPE;
      v_iss_cd            gipi_wpolbas.iss_cd%TYPE;
      v_issue_yy          gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no        gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no          gipi_wpolbas.renew_no%TYPE;
      v_expiry_date       gipi_wpolbas.expiry_date%TYPE;
      v_subline_type_cd   gipi_vehicle.subline_type_cd%TYPE;
   BEGIN
      v_expiry_date := extract_expiry (p_par_id);

      FOR i IN (SELECT incept_date, eff_date, endt_expiry_date, expiry_date,
                       short_rt_percent, line_cd, subline_cd, iss_cd,
                       issue_yy, pol_seq_no, renew_no, comp_sw, prorate_flag
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
      LOOP
         v_eff_date := i.eff_date;
         v_expiry_date := i.expiry_date;
         v_line_cd := i.line_cd;
         v_subline_cd := i.subline_cd;
         v_iss_cd := i.iss_cd;
         v_issue_yy := i.issue_yy;
         v_pol_seq_no := i.pol_seq_no;
         v_renew_no := i.renew_no;
         EXIT;
      END LOOP;

      FOR motor2 IN (SELECT   A.subline_type_cd
                         FROM gipi_vehicle A, gipi_polbasic b
                        WHERE b.policy_id = A.policy_id
                          AND b.pol_flag IN ('1', '2', '3', 'X')
                          AND A.subline_type_cd IS NOT NULL
                          AND b.line_cd = v_line_cd
                          AND b.subline_cd = v_subline_cd
                          AND b.iss_cd = v_iss_cd
                          AND b.issue_yy = v_issue_yy
                          AND b.pol_seq_no = v_pol_seq_no
                          AND b.renew_no = v_renew_no
                          AND A.item_no = p_item_no
                          AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                          AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                  b.expiry_date
                                                 ),
                                             b.expiry_date, v_expiry_date,
                                             b.endt_expiry_date, b.endt_expiry_date
                                            )
                                    ) >= v_eff_date
                     ORDER BY b.eff_date DESC)
      LOOP
         v_subline_type_cd := motor2.subline_type_cd;
         EXIT;
      END LOOP;

      RETURN v_subline_type_cd;
   END get_subline_type_cd;

/*
**  Created by   : Menandro G.C. Robes
**  Date Created : June 3, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril Information)
**  Description  : Function to retrieve tariff zone from GIPI_VEHICLE.
*/
   FUNCTION get_mc_tariff_zone (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_eff_date      gipi_wpolbas.eff_date%TYPE;
      v_line_cd       gipi_wpolbas.line_cd%TYPE;
      v_subline_cd    gipi_wpolbas.subline_cd%TYPE;
      v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
      v_issue_yy      gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no      gipi_wpolbas.renew_no%TYPE;
      v_expiry_date   gipi_wpolbas.expiry_date%TYPE;
      v_tariff_zone   gipi_vehicle.tariff_zone%TYPE;
   BEGIN
      v_expiry_date := extract_expiry (p_par_id);

      FOR i IN (SELECT incept_date, eff_date, endt_expiry_date, expiry_date,
                       short_rt_percent, line_cd, subline_cd, iss_cd,
                       issue_yy, pol_seq_no, renew_no, comp_sw, prorate_flag
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
      LOOP
         v_eff_date := i.eff_date;
         v_expiry_date := i.expiry_date;
         v_line_cd := i.line_cd;
         v_subline_cd := i.subline_cd;
         v_iss_cd := i.iss_cd;
         v_issue_yy := i.issue_yy;
         v_pol_seq_no := i.pol_seq_no;
         v_renew_no := i.renew_no;
         EXIT;
      END LOOP;

      FOR motor3 IN (SELECT   tariff_zone
                         FROM gipi_vehicle A, gipi_polbasic b
                        WHERE b.policy_id = A.policy_id
                          AND b.pol_flag IN ('1', '2', '3', 'X')
                          AND A.tariff_zone IS NOT NULL
                          AND b.line_cd = v_line_cd
                          AND b.subline_cd = v_subline_cd
                          AND b.iss_cd = v_iss_cd
                          AND b.issue_yy = v_issue_yy
                          AND b.pol_seq_no = v_pol_seq_no
                          AND b.renew_no = v_renew_no
                          AND A.item_no = p_item_no
                          AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                          AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                  b.expiry_date
                                                 ),
                                             b.expiry_date, v_expiry_date,
                                             b.endt_expiry_date, b.endt_expiry_date
                                            )
                                    ) >= v_eff_date
                     ORDER BY b.eff_date DESC)
      LOOP
         v_tariff_zone := motor3.tariff_zone;
         EXIT;
      END LOOP;

      RETURN v_tariff_zone;
   END;

   FUNCTION get_gipi_vehicle_rep (p_policy_id gipi_vehicle.policy_id%TYPE)
      --Created by Alfred  03/10/2011
   RETURN gipi_vehicle_rep_tab PIPELINED
   IS
      v_gipi_vehicle_rep   gipi_vehicle_rep_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT b290.policy_id policy_id2, b290.item_no item_no1,
                          b290.model_year model_year,
                             b.car_company
                          || ' '
                          || b290.make
                          || ' '
                          || a008.engine_series make,
                          A.type_of_body,
                          DECODE (b290.mot_type,
                                  NULL, NULL,
                                  a550.motor_type_desc
                                 ) motor_type_desc,
                          DECODE (b290.mot_type,
                                  NULL, NULL,
                                  a550.unladen_wt
                                 ) unladen_wt,
                          b290.color color,
                          LTRIM
                               (   LTRIM (TO_CHAR (b290.coc_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (b290.coc_seq_no, '099999')),
                                '-'
                               ) coc_seq_no1,
                          b290.plate_no plate_no, b290.serial_no serial_no,
                          b290.motor_no motor_no, b290.assignee assignee,
                          b290.no_of_pass no_of_pass,
                          b290.coc_serial_no coc_serial_no,
                          b290.mv_file_no blt_no, b290.coc_atcn coc_atcn,
                          c.assignee assignee2, c.model_year model_year2,
                          c.make make2, f.type_of_body type_of_body2,
                          c.color color2, c.plate_no plate_no2,
                          c.serial_no serial_no2, c.motor_no motor_no2,
                          c.no_of_pass no_of_pass2, c.unladen_wt unladen_wt2
                     FROM gipi_vehicle b290,
                          giis_motortype a550,
                          giis_mc_car_company b,
                          giis_mc_eng_series a008,
                          giis_type_of_body A,
                          gipi_vehicle c,
                          gipi_polbasic d,
                          gipi_polbasic E,
                          giis_type_of_body f
                    WHERE a550.type_cd = NVL (b290.mot_type, a550.type_cd)
                      AND b290.subline_cd = a550.subline_cd
                      AND b290.car_company_cd = b.car_company_cd(+)
                      AND b290.make_cd = a008.make_cd(+)
                      AND b290.series_cd = a008.series_cd(+)
                      AND b290.car_company_cd = a008.car_company_cd(+)
                      AND b290.type_of_body_cd = A.type_of_body_cd(+)
                      AND b290.policy_id = p_policy_id
                      AND E.policy_id = p_policy_id
                      AND c.policy_id = d.policy_id
                      AND d.line_cd = E.line_cd
                      AND d.subline_cd = E.subline_cd
                      AND d.iss_cd = E.iss_cd
                      AND d.issue_yy = E.issue_yy
                      AND d.pol_seq_no = E.pol_seq_no
                      AND d.renew_no = E.renew_no
                      AND d.endt_seq_no = 0
                      AND f.type_of_body_cd = c.type_of_body_cd)
      LOOP
         v_gipi_vehicle_rep.policy_id := i.policy_id2;
         v_gipi_vehicle_rep.item_no := i.item_no1;
         v_gipi_vehicle_rep.model_year := i.model_year;
         v_gipi_vehicle_rep.make := i.make;
         v_gipi_vehicle_rep.type_of_body := i.type_of_body;
         v_gipi_vehicle_rep.motor_type_desc := i.motor_type_desc;
         v_gipi_vehicle_rep.unladen_wt := i.unladen_wt;
         v_gipi_vehicle_rep.color := i.color;
         v_gipi_vehicle_rep.coc_seq_no1 := i.coc_seq_no1;
         v_gipi_vehicle_rep.plate_no := i.plate_no;
         v_gipi_vehicle_rep.serial_no := i.serial_no;
         v_gipi_vehicle_rep.motor_no := i.motor_no;
         v_gipi_vehicle_rep.assignee := i.assignee;
         v_gipi_vehicle_rep.no_of_pass := i.no_of_pass;
         v_gipi_vehicle_rep.coc_serial_no := i.coc_serial_no;
         v_gipi_vehicle_rep.blt_no := i.blt_no;
         v_gipi_vehicle_rep.coc_atcn := i.coc_atcn;
         v_gipi_vehicle_rep.assignee2 := i.assignee2;
         v_gipi_vehicle_rep.model_year2 := i.model_year2;
         v_gipi_vehicle_rep.make2 := i.make2;
         v_gipi_vehicle_rep.type_of_body2 := i.type_of_body2;
         v_gipi_vehicle_rep.color2 := i.color2;
         v_gipi_vehicle_rep.plate_no2 := i.plate_no2;
         v_gipi_vehicle_rep.serial_no2 := i.serial_no2;
         v_gipi_vehicle_rep.motor_no2 := i.motor_no2;
         v_gipi_vehicle_rep.no_of_pass2 := i.no_of_pass2;
         v_gipi_vehicle_rep.unladen_wt2 := i.unladen_wt2;
         PIPE ROW (v_gipi_vehicle_rep);
      END LOOP;

      RETURN;
   END get_gipi_vehicle_rep;

   FUNCTION get_motor_cars
      RETURN motor_cars_tab PIPELINED
   IS
      v_motor_cars   motor_cars_type;
   BEGIN
      FOR i IN (SELECT   A.policy_id, A.item_no, A.motor_no, A.plate_no,
                         A.serial_no, A.model_year, A.coc_type,
                         A.coc_serial_no, A.coc_yy, b.pol_flag, b.line_cd,
                         b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no,
                         b.renew_no,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || TO_CHAR (b.issue_yy, '09')
                         || '-'
                         || TO_CHAR (b.pol_seq_no, '0000009')
                         || '-'
                         || TO_CHAR (b.renew_no, '09') policy_no
                    FROM gipi_vehicle A, gipi_polbasic b
                   WHERE A.policy_id = b.policy_id
                ORDER BY A.motor_no,
                         A.plate_no,
                         A.serial_no,
                         A.model_year,
                         A.coc_type,
                         A.coc_seq_no,
                         A.coc_yy)
      LOOP
         v_motor_cars.coc_serial_no := i.coc_serial_no;
         v_motor_cars.model_year := i.model_year;
         v_motor_cars.policy_id := i.policy_id;
         v_motor_cars.serial_no := i.serial_no;
         v_motor_cars.policy_no := i.policy_no;
         v_motor_cars.motor_no := i.motor_no;
         v_motor_cars.plate_no := i.plate_no;
         v_motor_cars.pol_flag := i.pol_flag;
         v_motor_cars.coc_type := i.coc_type;
         v_motor_cars.item_no := i.item_no;
         v_motor_cars.coc_yy := i.coc_yy;
         v_motor_cars.iss_cd := i.iss_cd;
         v_motor_cars.line_cd := i.line_cd;
         v_motor_cars.renew_no := i.renew_no;
         v_motor_cars.issue_yy := i.issue_yy;
         v_motor_cars.subline_cd := i.subline_cd;
         v_motor_cars.pol_seq_no := i.pol_seq_no;

         SELECT rv_meaning
           INTO v_motor_cars.status
           FROM cg_ref_codes
          WHERE rv_domain = 'GIPI_POLBASIC.POL_FLAG'
            AND rv_low_value = i.pol_flag;
         
         --added by apollo cruz 07.11.2014   
         BEGIN
            SELECT 'Y'
              INTO v_motor_cars.has_attachment
              FROM gipi_pictures
             WHERE policy_id = i.policy_id
               AND item_no = i.item_no;
         EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                v_motor_cars.has_attachment := 'N';     
             WHEN TOO_MANY_ROWS THEN    --MJ Fabroa 2014-12-05: Added to resolve SR# 17786
                v_motor_cars.has_attachment := 'Y';               
         END;   

         PIPE ROW (v_motor_cars);
      END LOOP;
   END get_motor_cars;

   --MOSES 04122011

   /*
   **  Created by        : Andrew
   **  Date Created     : 5.16.2010
   **  Reference By     : (GIPIS060 - Item Information - Motorcar - Endorsement)
   **  Description     : Retrieves record on GIPI_VEHICLE based on the given par_id and item_no
   */
   FUNCTION get_gipi_vehicle (
      p_policy_id   IN   gipi_vehicle.policy_id%TYPE,
      p_item_no     IN   gipi_vehicle.item_no%TYPE
   )
      RETURN gipi_vehicle_tab_all_cols PIPELINED
   IS
      v_gipi_vehicle_tab   gipi_vehicle_par_type;
   BEGIN
      FOR i IN
         (SELECT A.policy_id, A.item_no, A.subline_cd, A.motor_no,
                 A.plate_no, A.est_value, A.make, A.mot_type, A.color,
                 A.repair_lim, A.serial_no, A.coc_seq_no, A.coc_serial_no,
                 A.coc_type, A.assignee, A.model_year, A.coc_issue_date,
                 A.coc_yy, A.towing, A.subline_type_cd, A.no_of_pass,
                 A.tariff_zone, A.mv_file_no, A.acquired_from, A.ctv_tag,
                 A.car_company_cd, A.type_of_body_cd, A.unladen_wt,
                 A.make_cd, A.series_cd, A.basic_color_cd, A.color_cd,
                 A.origin, A.destination, A.coc_atcn, A.motor_coverage,
                 A.coc_serial_sw, A.reg_type, A.mv_type, A.mv_prem_type,
                 A.tax_type,
                 (SELECT b.car_company
                    FROM giis_mc_car_company b 
                   WHERE b.car_company_cd = a.car_company_cd) car_company,
                 (SELECT c.engine_series
                    FROM giis_mc_eng_series c
                   WHERE c.car_company_cd = a.car_company_cd
                     AND c.make_cd = a.make_cd
                     AND c.series_cd = a.series_cd) engine_series,
--                 giis_mc_car_company_pkg.get_car_company
--                                                (A.car_company_cd)
--                                                                car_company,
--                 giis_mc_eng_series_pkg.get_engine_series
--                                             (A.car_company_cd,
--                                              A.make_cd,
--                                              A.series_cd
--                                             ) engine_series,
                 giis_mc_color_pkg.get_basic_color
                                                (A.basic_color_cd)
                                                                 basic_color
            FROM gipi_vehicle A
           WHERE A.policy_id = p_policy_id
             AND A.item_no = p_item_no)
      LOOP
         v_gipi_vehicle_tab.policy_id := i.policy_id;
         v_gipi_vehicle_tab.item_no := i.item_no;
         v_gipi_vehicle_tab.subline_cd := i.subline_cd;
         v_gipi_vehicle_tab.motor_no := i.motor_no;
         v_gipi_vehicle_tab.plate_no := i.plate_no;
         v_gipi_vehicle_tab.est_value := i.est_value;
         v_gipi_vehicle_tab.make := i.make;
         v_gipi_vehicle_tab.mot_type := i.mot_type;
         v_gipi_vehicle_tab.color := i.color;
         v_gipi_vehicle_tab.repair_lim := i.repair_lim;
         v_gipi_vehicle_tab.serial_no := i.serial_no;
         v_gipi_vehicle_tab.coc_seq_no := i.coc_seq_no;
         v_gipi_vehicle_tab.coc_serial_no := i.coc_serial_no;
         v_gipi_vehicle_tab.coc_type := i.coc_type;
         v_gipi_vehicle_tab.assignee := i.assignee;
         v_gipi_vehicle_tab.model_year := i.model_year;
         v_gipi_vehicle_tab.coc_issue_date := i.coc_issue_date;
         v_gipi_vehicle_tab.coc_yy := i.coc_yy;
         v_gipi_vehicle_tab.towing := i.towing;
         v_gipi_vehicle_tab.subline_type_cd := i.subline_type_cd;
         v_gipi_vehicle_tab.no_of_pass := i.no_of_pass;
         v_gipi_vehicle_tab.tariff_zone := i.tariff_zone;
         v_gipi_vehicle_tab.mv_file_no := i.mv_file_no;
         v_gipi_vehicle_tab.acquired_from := i.acquired_from;
         v_gipi_vehicle_tab.ctv_tag := i.ctv_tag;
         v_gipi_vehicle_tab.car_company_cd := i.car_company_cd;
         v_gipi_vehicle_tab.type_of_body_cd := i.type_of_body_cd;
         v_gipi_vehicle_tab.unladen_wt := i.unladen_wt;
         v_gipi_vehicle_tab.make_cd := i.make_cd;
         v_gipi_vehicle_tab.series_cd := i.series_cd;
         v_gipi_vehicle_tab.basic_color_cd := i.basic_color_cd;
         v_gipi_vehicle_tab.basic_color := i.basic_color;
         v_gipi_vehicle_tab.color_cd := i.color_cd;
         v_gipi_vehicle_tab.origin := i.origin;
         v_gipi_vehicle_tab.destination := i.destination;
         v_gipi_vehicle_tab.coc_atcn := i.coc_atcn;
         v_gipi_vehicle_tab.motor_coverage := i.motor_coverage;
         v_gipi_vehicle_tab.coc_serial_sw := i.coc_serial_sw;
         v_gipi_vehicle_tab.car_company := i.car_company;
         v_gipi_vehicle_tab.engine_series := i.engine_series;
		 
		 --additional columns added by Nica 10.19.2012 - needed for COC authentication
		 v_gipi_vehicle_tab.reg_type 	 := i.reg_type;
		 v_gipi_vehicle_tab.mv_type  	 := i.mv_type;
		 v_gipi_vehicle_tab.mv_prem_type := i.mv_prem_type;
		 v_gipi_vehicle_tab.tax_type := i.tax_type;
		 
         PIPE ROW (v_gipi_vehicle_tab);
      END LOOP;

      RETURN;
   END get_gipi_vehicle;

   /*
   **  Created by   : Moses Calma
   **  Date Created : 06 02 2011
   **  Reference By : (gipis100 - policy information)
   **  Description  : retrieves vehicle item information
   */
   FUNCTION get_vehicle_info (
      p_policy_id   gipi_vehicle.policy_id%TYPE,
      p_item_no     gipi_vehicle.item_no%TYPE
   )
      RETURN vehicle_info_tab PIPELINED
   IS
      v_vehicle_info   vehicle_info_type;
   BEGIN
      FOR i IN (SELECT policy_id, item_no, assignee, subline_cd, model_year,
                       coc_yy, coc_serial_no, coc_type, make, mot_type,
                       unladen_wt, color, towing, repair_lim,
                       subline_type_cd, plate_no, serial_no, motor_no,
                       origin, destination, est_value, acquired_from,
                       mv_file_no, no_of_pass, type_of_body_cd, series_cd,
                       make_cd, car_company_cd, coc_atcn, motor_coverage,
                       basic_color_cd, color_cd
                  FROM gipi_vehicle
                 WHERE policy_id = p_policy_id AND item_no = p_item_no)
      LOOP
         v_vehicle_info.policy_id := i.policy_id;
         v_vehicle_info.item_no := i.item_no;
         v_vehicle_info.assignee := i.assignee;
         v_vehicle_info.origin := i.origin;
         v_vehicle_info.coc_yy := i.coc_yy;
         v_vehicle_info.make := i.make;
         v_vehicle_info.color := i.color;
         v_vehicle_info.towing := i.towing;
         v_vehicle_info.plate_no := i.plate_no;
         v_vehicle_info.serial_no := i.serial_no;
         v_vehicle_info.motor_no := i.motor_no;
         v_vehicle_info.make_cd := i.make_cd;
         v_vehicle_info.est_value := i.est_value;
         v_vehicle_info.mv_file_no := i.mv_file_no;
         v_vehicle_info.no_of_pass := i.no_of_pass;
         v_vehicle_info.series_cd := i.series_cd;
         v_vehicle_info.coc_atcn := i.coc_atcn;
         v_vehicle_info.color_cd := i.color_cd;
         v_vehicle_info.coc_type := i.coc_type;
         v_vehicle_info.mot_type := i.mot_type;
         v_vehicle_info.subline_cd := i.subline_cd;
         v_vehicle_info.model_year := i.model_year;
         v_vehicle_info.repair_lim := i.repair_lim;
         v_vehicle_info.unladen_wt := i.unladen_wt;
         v_vehicle_info.coc_serial_no := i.coc_serial_no;
         v_vehicle_info.basic_color_cd := i.basic_color_cd;
         v_vehicle_info.subline_type_cd := i.subline_type_cd;
         v_vehicle_info.car_company_cd := i.car_company_cd;
         v_vehicle_info.acquired_from := i.acquired_from;
         v_vehicle_info.destination := i.destination;

         BEGIN
            SELECT item_title
              INTO v_vehicle_info.item_title
              FROM gipi_item
             WHERE policy_id = i.policy_id AND item_no = i.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_vehicle_info.item_title := '';
         END;

         BEGIN
            SELECT motor_type_desc
              INTO v_vehicle_info.type_desc
              FROM giis_motortype
             WHERE type_cd = i.mot_type AND subline_cd = i.subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_vehicle_info.type_desc := '';
         END;

         BEGIN
            SELECT SUM (deductible_amt) amt
              INTO v_vehicle_info.deductible
              FROM gipi_deductibles
             WHERE policy_id = i.policy_id AND item_no = i.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_vehicle_info.deductible := '';
         END;

         BEGIN
            SELECT type_of_body
              INTO v_vehicle_info.type_of_body
              FROM giis_type_of_body
             WHERE type_of_body_cd = i.type_of_body_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_vehicle_info.type_of_body := '';
         END;

         BEGIN
            SELECT car_company
              INTO v_vehicle_info.car_company
              FROM giis_mc_car_company
             WHERE car_company_cd = i.car_company_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_vehicle_info.car_company := '';
         END;

         BEGIN
            SELECT engine_series
              INTO v_vehicle_info.engine_series
              FROM giis_mc_eng_series
             WHERE series_cd = i.series_cd
               AND make_cd = i.make_cd
               AND car_company_cd = i.car_company_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_vehicle_info.engine_series := '';
         END;

         BEGIN
            SELECT subline_type_desc
              INTO v_vehicle_info.subline_type_desc
              FROM giis_mc_subline_type
             WHERE subline_cd = i.subline_cd
               AND subline_type_cd = i.subline_type_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_vehicle_info.subline_type_desc := '';
         END;

         BEGIN
            SELECT DISTINCT (basic_color)
                       INTO v_vehicle_info.basic_color
                       FROM giis_mc_color
                      WHERE color_cd = i.color_cd
                        AND basic_color_cd = i.basic_color_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_vehicle_info.basic_color := '';
         END;

         BEGIN
            SELECT rv_meaning
              INTO v_vehicle_info.motor_coverage
              FROM cg_ref_codes
             WHERE rv_low_value = i.motor_coverage
               AND rv_domain = 'GIPI_VEHICLE.MOTOR_COVERAGE';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_vehicle_info.motor_coverage := '';
         END;

         PIPE ROW (v_vehicle_info);
      END LOOP;
   END get_vehicle_info;

   /*
   **  Created by   : D.Alcantara
   **  Date Created : June 15, 2010
   **  Reference By : (GIPIS091)
   **  Description  : Function to retrieve records from GIPI_VEHICLE to populate COC.
   */
   FUNCTION get_motor_coverage (p_policy_id gipi_vehicle.policy_id%TYPE)
      RETURN gipi_vehicle_coc_tab PIPELINED
   IS
      v_vehicle   gipi_vehicle_coc_type;
   BEGIN
      FOR i IN (SELECT    c.line_cd
                       || '-'
                       || c.subline_cd
                       || '-'
                       || c.iss_cd
                       || '-'
                       || c.issue_yy
                       || '-'
                       || c.pol_seq_no
                       || '-'
                       || c.renew_no policy_no,
                       A.model_year || ' ' || A.make vehicle_model,
                       A.serial_no, A.motor_no, A.plate_no, d.item_title,
                       d.item_desc, d.item_no,
                       b.car_company || ' ' || A.color car, A.policy_id,
                       A.coc_type, A.coc_yy, A.coc_serial_no, A.coc_atcn
                  FROM gipi_vehicle A,
                       giis_mc_car_company b,
                       gipi_polbasic c,
                       gipi_item d
                 WHERE A.car_company_cd = b.car_company_cd (+) -- andrew - 06.05.2012 - added outer join
                   AND A.policy_id = c.policy_id
                   AND A.policy_id = d.policy_id
                   AND c.policy_id = d.policy_id
                   AND A.item_no = d.item_no
                   AND A.policy_id = p_policy_id)
      LOOP
         v_vehicle.policy_id := i.policy_id;
         v_vehicle.policy_no := i.policy_no;
         v_vehicle.vehicle_model := i.vehicle_model;
         v_vehicle.serial_no := i.serial_no;
         v_vehicle.motor_no := i.motor_no;
         v_vehicle.plate_no := i.plate_no;
         v_vehicle.item_title := i.item_title;
         v_vehicle.item_desc := i.item_desc;
         v_vehicle.item_no := i.item_no;
         v_vehicle.car := i.car;
         v_vehicle.coc_type := i.coc_type;
         v_vehicle.coc_yy := i.coc_yy;
         v_vehicle.coc_serial_no := i.coc_serial_no;
         v_vehicle.coc_atcn := i.coc_atcn;

         SELECT gipi_itmperil_pkg.check_ctpl_coc_printing (i.item_no,
                                                           i.policy_id
                                                          )
           INTO v_vehicle.compulsory_flag
           FROM DUAL;

         PIPE ROW (v_vehicle);
      END LOOP;
   END get_motor_coverage;

   /*
   **  Created by   : Andrew Robes
   **  Date Created : 12.11.2012
   **  Reference By : (GIPIS091)
   **  Description  : Function to retrieve records from GIPI_VEHICLE to populate COC for policy.
   */
   FUNCTION get_motor_coverage2 (p_policy_id gipi_vehicle.policy_id%TYPE, 
                                 p_pack_pol_flag gipi_polbasic.pack_pol_flag%TYPE)
      RETURN gipi_vehicle_coc_tab PIPELINED
   IS
      v_vehicle   gipi_vehicle_coc_type;
   BEGIN
      IF NVL(p_pack_pol_flag, 'N') = 'Y' THEN
          FOR i IN (SELECT    c.line_cd
                           || '-'
                           || c.subline_cd
                           || '-'
                           || c.iss_cd
                           || '-'
                           || c.issue_yy
                           || '-'
                           || c.pol_seq_no
                           || '-'
                           || c.renew_no policy_no,
                           A.model_year || ' ' || A.make vehicle_model,
                           A.serial_no, A.motor_no, A.plate_no, (d.item_title) item_title, --removed escape_value robert 03252014
                           d.item_desc, d.item_no,
                           b.car_company || ' ' || A.color car, A.policy_id,
                           A.coc_type, A.coc_yy, A.coc_serial_no, A.coc_atcn
                      FROM gipi_vehicle A,
                           giis_mc_car_company b,
                           gipi_polbasic c,
                           gipi_item d
                     WHERE A.car_company_cd = b.car_company_cd (+) -- andrew - 06.05.2012 - added outer join
                       AND A.policy_id = c.policy_id
                       AND A.policy_id = d.policy_id
                       AND c.policy_id = d.policy_id
                       AND A.item_no = d.item_no
                       AND c.pack_policy_id = p_policy_id)
          LOOP
             v_vehicle.policy_id := i.policy_id;
             v_vehicle.policy_no := i.policy_no;
             v_vehicle.vehicle_model := i.vehicle_model;
             v_vehicle.serial_no := i.serial_no;
             v_vehicle.motor_no := i.motor_no;
             v_vehicle.plate_no := i.plate_no;
             v_vehicle.item_title := i.item_title;
             --v_vehicle.item_desc := i.item_desc; commented out by reymon 03052013 it cause JSON.parse at coc printing
             v_vehicle.item_no := i.item_no;
             v_vehicle.car := i.car;
             v_vehicle.coc_type := i.coc_type;
             v_vehicle.coc_yy := i.coc_yy;
             v_vehicle.coc_serial_no := i.coc_serial_no;
             v_vehicle.coc_atcn := i.coc_atcn;

             SELECT gipi_itmperil_pkg.check_ctpl_coc_printing (i.item_no,
                                                               i.policy_id
                                                              )
               INTO v_vehicle.compulsory_flag
               FROM DUAL;

             PIPE ROW (v_vehicle);
          END LOOP;
      ELSE 
          FOR i IN (SELECT    c.line_cd
                           || '-'
                           || c.subline_cd
                           || '-'
                           || c.iss_cd
                           || '-'
                           || c.issue_yy
                           || '-'
                           || c.pol_seq_no
                           || '-'
                           || c.renew_no policy_no,
                           A.model_year || ' ' || A.make vehicle_model,
                           A.serial_no, A.motor_no, A.plate_no, (d.item_title) item_title, --removed escape_value robert 03252014
                           d.item_desc, d.item_no,
                           b.car_company || ' ' || A.color car, A.policy_id,
                           A.coc_type, A.coc_yy, A.coc_serial_no, A.coc_atcn
                      FROM gipi_vehicle A,
                           giis_mc_car_company b,
                           gipi_polbasic c,
                           gipi_item d
                     WHERE A.car_company_cd = b.car_company_cd (+) -- andrew - 06.05.2012 - added outer join
                       AND A.policy_id = c.policy_id
                       AND A.policy_id = d.policy_id
                       AND c.policy_id = d.policy_id
                       AND A.item_no = d.item_no
                       AND A.policy_id = p_policy_id)
          LOOP
             v_vehicle.policy_id := i.policy_id;
             v_vehicle.policy_no := i.policy_no;
             v_vehicle.vehicle_model := i.vehicle_model;
             v_vehicle.serial_no := i.serial_no;
             v_vehicle.motor_no := i.motor_no;
             v_vehicle.plate_no := i.plate_no;
             v_vehicle.item_title := i.item_title;
             --v_vehicle.item_desc := i.item_desc; commented out by reymon 03052013 it cause JSON.parse at coc printing
             v_vehicle.item_no := i.item_no;
             v_vehicle.car := i.car;
             v_vehicle.coc_type := i.coc_type;
             v_vehicle.coc_yy := i.coc_yy;
             v_vehicle.coc_serial_no := i.coc_serial_no;
             v_vehicle.coc_atcn := i.coc_atcn;

             SELECT gipi_itmperil_pkg.check_ctpl_coc_printing (i.item_no,
                                                               i.policy_id
                                                              )
               INTO v_vehicle.compulsory_flag
               FROM DUAL;

             PIPE ROW (v_vehicle);
          END LOOP;
      END IF;
   END get_motor_coverage2;

   PROCEDURE set_gipi_vehicle_gipis091 (
      p_policy_id       gipi_vehicle.policy_id%TYPE,
      p_item_no         gipi_vehicle.item_no%TYPE,
      p_coc_yy          gipi_vehicle.coc_yy%TYPE,
      p_coc_serial_no   gipi_vehicle.coc_serial_no%TYPE,
      p_coc_atcn        gipi_vehicle.coc_atcn%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_vehicle
         SET coc_yy = p_coc_yy,
             coc_serial_no = p_coc_serial_no,
             coc_atcn = p_coc_atcn
       WHERE policy_id = p_policy_id AND item_no = p_item_no;
   END set_gipi_vehicle_gipis091;

   /*
   **  Created by   : D.Alcantara
   **  Date Created : June 17, 2010
   **  Reference By : (GIPIS091)
   **  Description  :
   */
   FUNCTION check_existing_coc_serial (
      p_policy_id       gipi_vehicle.policy_id%TYPE,
      p_item_no         gipi_vehicle.item_no%TYPE,
      p_coc_serial_no   gipi_vehicle.coc_serial_no%TYPE,
      p_coc_type        gipi_vehicle.coc_type%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      v_exist := 'N';

      FOR chk_rec IN (SELECT coc_serial_no
                        FROM gipi_vehicle
                       WHERE coc_serial_no = p_coc_serial_no
                         AND coc_type = p_coc_type
                         AND (   policy_id != p_policy_id
                              OR (    policy_id = p_policy_id
                                  AND item_no != p_item_no
                                 )
                             ))
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exist;
   END check_existing_coc_serial;

   FUNCTION get_gipi_vehicle_rep2 (
      p_policy_id   gipi_vehicle.policy_id%TYPE
   )
      RETURN gipi_vehicle_rep_tab PIPELINED
   IS
      v_gipi_vehicle_rep   gipi_vehicle_rep_type;
   BEGIN
      FOR i IN (SELECT b290.policy_id policy_id2, b290.item_no item_no1,
                       b290.model_year model_year,
                          b.car_company
                       || ' '
                       || b290.make
                       || ' '
                       || a008.engine_series make,
                       A.type_of_body,
                       DECODE (b290.mot_type,
                               NULL, NULL,
                               a550.motor_type_desc
                              ) motor_type_desc,
                       DECODE (b290.mot_type,
                               NULL, NULL,
                               a550.unladen_wt
                              ) unladen_wt,
                       b290.color color,
                       LTRIM (   LTRIM (TO_CHAR (b290.coc_yy, '09'))
                              || '-'
                              || LTRIM (TO_CHAR (b290.coc_seq_no, '099999')),
                              '-'
                             ) coc_seq_no1,
                       b290.plate_no plate_no, b290.serial_no serial_no,
                       b290.motor_no motor_no, b290.assignee assignee,
                       b290.no_of_pass no_of_pass,
                       b290.coc_serial_no coc_serial_no,
                       b290.mv_file_no blt_no, b290.coc_atcn coc_atcn,
                       b290.assignee assignee2, b290.model_year model_year2,
                       b290.make make2, A.type_of_body type_of_body2,
                       b290.color color2, b290.plate_no plate_no2,
                       b290.serial_no serial_no2, b290.motor_no motor_no2,
                       b290.no_of_pass no_of_pass2, b290.unladen_wt unladen_wt2
                  FROM gipi_vehicle b290,
                       giis_motortype a550,
                       giis_mc_car_company b,
                       giis_mc_eng_series a008,
                       giis_type_of_body A
                 WHERE A550.TYPE_CD = NVL(B290.MOT_TYPE, A550.TYPE_CD)
                       AND B290.SUBLINE_CD = A550.SUBLINE_CD
                       AND B290.CAR_COMPANY_CD = B.CAR_COMPANY_CD(+)
                       AND B290.MAKE_CD = A008.MAKE_CD(+)
                       AND B290.SERIES_CD = A008.SERIES_CD(+)
                       AND B290.CAR_COMPANY_CD = A008.CAR_COMPANY_CD(+)
                       AND B290.TYPE_OF_BODY_CD = A.TYPE_OF_BODY_CD(+)
                       AND B290.POLICY_ID = P_POLICY_ID)
      LOOP
         v_gipi_vehicle_rep.policy_id := i.policy_id2;
         v_gipi_vehicle_rep.item_no := i.item_no1;
         v_gipi_vehicle_rep.model_year := i.model_year;
         v_gipi_vehicle_rep.make := i.make;
         v_gipi_vehicle_rep.type_of_body := i.type_of_body;
         v_gipi_vehicle_rep.motor_type_desc := i.motor_type_desc;
         v_gipi_vehicle_rep.unladen_wt := i.unladen_wt;
         v_gipi_vehicle_rep.color := i.color;
         v_gipi_vehicle_rep.coc_seq_no1 := i.coc_seq_no1;
         v_gipi_vehicle_rep.plate_no := i.plate_no;
         v_gipi_vehicle_rep.serial_no := i.serial_no;
         v_gipi_vehicle_rep.motor_no := i.motor_no;
         v_gipi_vehicle_rep.assignee := i.assignee;
         v_gipi_vehicle_rep.no_of_pass := i.no_of_pass;
         v_gipi_vehicle_rep.coc_serial_no := i.coc_serial_no;
         v_gipi_vehicle_rep.blt_no := i.blt_no;
         v_gipi_vehicle_rep.coc_atcn := i.coc_atcn;
         v_gipi_vehicle_rep.assignee2 := i.assignee2;
         v_gipi_vehicle_rep.model_year2 := i.model_year2;
         v_gipi_vehicle_rep.make2 := i.make2;
         v_gipi_vehicle_rep.type_of_body2 := i.type_of_body2;
         v_gipi_vehicle_rep.color2 := i.color2;
         v_gipi_vehicle_rep.plate_no2 := i.plate_no2;
         v_gipi_vehicle_rep.serial_no2 := i.serial_no2;
         v_gipi_vehicle_rep.motor_no2 := i.motor_no2;
         v_gipi_vehicle_rep.no_of_pass2 := i.no_of_pass2;
         v_gipi_vehicle_rep.unladen_wt2 := i.unladen_wt2;
         PIPE ROW (v_gipi_vehicle_rep);
      END LOOP;

      RETURN;
   END get_gipi_vehicle_rep2;

   FUNCTION get_plate_lov_gicl010
      RETURN gipi_vehicle_gicl010_tab PIPELINED
   IS
      v_vehicle   gipi_vehicle_gicl010_type;
   BEGIN
      FOR i IN (SELECT DISTINCT A.plate_no, c.assd_name
                           FROM gipi_vehicle A,
                                gipi_polbasic b,
                                giis_assured c,
                                gipi_parlist d
                          WHERE plate_no IS NOT NULL
                            AND b.par_id = d.par_id
                            AND d.assd_no = c.assd_no
                            AND A.policy_id = b.policy_id
                            AND b.endt_seq_no =
                                   (SELECT MAX (endt_seq_no)
                                      FROM gipi_polbasic
                                     WHERE line_cd = b.line_cd
                                       AND subline_cd = b.subline_cd
                                       AND iss_cd = b.iss_cd
                                       AND issue_yy = b.issue_yy
                                       AND pol_seq_no = b.pol_seq_no
                                       AND renew_no = b.renew_no)
                            AND NOT EXISTS (
                                   SELECT '1'
                                     FROM gicl_claims
                                    WHERE line_cd = b.line_cd
                                      AND subline_cd = b.subline_cd
                                      AND pol_iss_cd = b.iss_cd
                                      AND issue_yy = b.issue_yy
                                      AND pol_seq_no = b.pol_seq_no
                                      AND renew_no = b.renew_no
                                      AND total_tag = 'Y')
                       ORDER BY plate_no)
      LOOP
         v_vehicle.plate_no := i.plate_no;
         v_vehicle.assured_name := i.assd_name;
         PIPE ROW (v_vehicle);
      END LOOP;
   END get_plate_lov_gicl010;

   FUNCTION get_motor_lov_gicl010 
      RETURN gipi_vehicle_motor_tab PIPELINED
   IS
      v_vehicle   gipi_vehicle_motor_type;
   BEGIN
      FOR i IN (SELECT DISTINCT A.motor_no, c.assd_name
                           FROM gipi_vehicle A,
                                gipi_polbasic b,
                                giis_assured c,
                                gipi_parlist d
                          WHERE motor_no IS NOT NULL
                            AND b.par_id = d.par_id
                            AND d.assd_no = c.assd_no
                            AND A.policy_id = b.policy_id
                            AND b.endt_seq_no =
                                   (SELECT MAX (endt_seq_no)
                                      FROM gipi_polbasic
                                     WHERE line_cd = b.line_cd
                                       AND subline_cd = b.subline_cd
                                       AND iss_cd = b.iss_cd
                                       AND issue_yy = b.issue_yy
                                       AND pol_seq_no = b.pol_seq_no
                                       AND renew_no = b.renew_no)
                            AND NOT EXISTS (
                                   SELECT '1'
                                     FROM gicl_claims
                                    WHERE line_cd = b.line_cd
                                      AND subline_cd = b.subline_cd
                                      AND pol_iss_cd = b.iss_cd
                                      AND issue_yy = b.issue_yy
                                      AND pol_seq_no = b.pol_seq_no
                                      AND renew_no = b.renew_no
                                      AND total_tag = 'Y')
                       ORDER BY motor_no)
      LOOP
         v_vehicle.motor_no := i.motor_no;
         v_vehicle.assured_name := i.assd_name;
         PIPE ROW (v_vehicle);
      END LOOP;
   END get_motor_lov_gicl010;

   FUNCTION get_serial_lov_gicl010 
      RETURN gipi_vehicle_serial_tab PIPELINED
   IS
      v_vehicle   gipi_vehicle_serial_type;
   BEGIN
      FOR i IN (SELECT DISTINCT A.serial_no, c.assd_name
                           FROM gipi_vehicle A,
                                gipi_polbasic b,
                                giis_assured c,
                                gipi_parlist d
                          WHERE serial_no IS NOT NULL
                            AND b.par_id = d.par_id
                            AND d.assd_no = c.assd_no
                            AND A.policy_id = b.policy_id
                            AND b.endt_seq_no =
                                   (SELECT MAX (endt_seq_no)
                                      FROM gipi_polbasic
                                     WHERE line_cd = b.line_cd
                                       AND subline_cd = b.subline_cd
                                       AND iss_cd = b.iss_cd
                                       AND issue_yy = b.issue_yy
                                       AND pol_seq_no = b.pol_seq_no
                                       AND renew_no = b.renew_no)
                            AND NOT EXISTS (
                                   SELECT '1'
                                     FROM gicl_claims
                                    WHERE line_cd = b.line_cd
                                      AND subline_cd = b.subline_cd
                                      AND pol_iss_cd = b.iss_cd
                                      AND issue_yy = b.issue_yy
                                      AND pol_seq_no = b.pol_seq_no
                                      AND renew_no = b.renew_no
                                      AND total_tag = 'Y')
                       ORDER BY serial_no)
      LOOP
         v_vehicle.serial_no := i.serial_no;
         v_vehicle.assured_name := i.assd_name;
         PIPE ROW (v_vehicle);
      END LOOP;
   END get_serial_lov_gicl010;
   
   /**
    **  Created by      : Niknok Orio 
    **  Date Created    : 09.30.2011 
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : get valid plate nos, motor nos  nos 
    **/  
    FUNCTION get_valid_plate_nos(
        p_line_cd          GIPI_POLBASIC.line_cd%TYPE,  
        p_subline_cd       GIPI_POLBASIC.subline_cd%TYPE,
        p_pol_iss_cd       GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy         GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no       GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no         GIPI_POLBASIC.renew_no%TYPE
        )  
    RETURN motor_cars_tab PIPELINED IS
      v_list        motor_cars_type; 
      v_plate_no    gipi_vehicle.plate_no%TYPE;
      v_motor_no    gipi_vehicle.motor_no%TYPE;  
      v_serial_no   gipi_vehicle.serial_no%TYPE;  
    BEGIN

        FOR i IN (SELECT DISTINCT A.item_no item_no
                              FROM gipi_vehicle A , gipi_polbasic b
                   WHERE A.policy_id   = b.policy_id
                       AND b.line_cd   = p_line_cd
                     AND b.subline_cd  = p_subline_cd
                     AND b.iss_cd      = p_pol_iss_cd     
                     AND b.issue_yy    = p_issue_yy   
                     AND b.pol_seq_no  = p_pol_seq_no
                     AND b.renew_no    = p_renew_no
                     AND b.pol_flag IN ('1','2','3','X'))  
        LOOP
          --call db function
            v_plate_no := get_latest_plate_no_basic(p_line_cd,p_subline_cd,p_pol_iss_cd,
                                                    p_issue_yy,p_pol_seq_no,p_renew_no,i.item_no); 
            DECLARE
                v_total_tag  gicl_claims.total_tag%TYPE;
            BEGIN
              FOR j IN (SELECT 'Y' total_tag
                          FROM gicl_claims A, 
                               gicl_clm_item b
                         WHERE 1=1
                           AND A.line_cd    = p_line_cd
                           AND A.subline_cd = p_subline_cd
                           AND A.pol_iss_cd = p_pol_iss_cd
                           AND A.issue_yy   = p_issue_yy
                           AND A.pol_seq_no = p_pol_seq_no
                           AND A.renew_no   = p_renew_no
                           AND A.claim_id   = b.claim_id
                           AND b.item_no    = i.item_no
                           AND A.total_tag  = 'Y'
                           AND A.clm_stat_cd NOT IN ('CC','WD','DN'))
              LOOP
                v_total_tag := j.total_tag;
              END LOOP;
              
              IF NVL(v_total_tag,'N') = 'N' THEN  
                 FOR rec IN (SELECT y.item_no, y.motor_no, y.serial_no, x.endt_seq_no
                               FROM gipi_polbasic x,
                                    gipi_vehicle  y
                              WHERE 1=1
                                AND x.policy_id  = y.policy_id
                                AND x.line_cd    = p_line_cd
                                AND x.subline_cd = p_subline_cd
                                AND x.iss_cd     = p_pol_iss_cd
                                AND x.issue_yy   = p_issue_yy
                                AND x.pol_seq_no = p_pol_seq_no
                                AND x.renew_no   = p_renew_no
                                AND y.item_no    = i.item_no
                                AND x.pol_flag  IN  ('1','2','3','4','X')                
                           ORDER BY x.eff_date DESC,x.endt_seq_no DESC)             
                 LOOP
                   v_serial_no  := rec.serial_no;
                   v_motor_no   := rec.motor_no;
                   
                   FOR rec2 IN (SELECT b.item_no, b.motor_no, b.serial_no, A.endt_seq_no
                                  FROM gipi_polbasic A,
                                       gipi_vehicle  b
                                 WHERE 1=1
                                   AND A.policy_id  = b.policy_id
                                   AND A.line_cd    = p_line_cd
                                   AND A.subline_cd = p_subline_cd
                                   AND A.iss_cd     = p_pol_iss_cd
                                   AND A.issue_yy   = p_issue_yy
                                   AND A.pol_seq_no = p_pol_seq_no
                                   AND A.renew_no   = p_renew_no
                                   AND b.item_no    = i.item_no
                                   AND A.pol_flag  IN  ('1','2','3','4','X')
                                   AND NVL(A.endt_seq_no,0) > 0 
                                   AND NVL(A.back_stat,5) = 2    
                                   AND NVL(A.endt_seq_no,0) > rec.endt_seq_no           
                              ORDER BY A.endt_seq_no DESC)
                   LOOP
                     v_serial_no  := rec2.serial_no;
                     v_motor_no  := rec2.motor_no;
                     EXIT;
                   END LOOP;
                   EXIT;
                 END LOOP;
              END IF;
            END;
            
            IF v_plate_no = 'NULL' THEN 
                  v_plate_no := NULL;
            END IF; 
            IF v_motor_no = 'NULL' THEN 
                  v_motor_no := NULL;
            END IF;                                                                                        
            IF v_serial_no = 'NULL' THEN
                  v_motor_no := NULL;
            END IF;                
            
            v_list.item_no      := i.item_no;
            v_list.plate_no     := v_plate_no;
            v_list.motor_no     := v_motor_no;  
            v_list.serial_no     := v_serial_no;  
        PIPE ROW(v_list);
        END LOOP;
      RETURN;  
    END; 
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 12.13.2011 
    **  Reference By    : (GICLS026 - No Claim)
    **  Description     : motcar_item_lov 
    */   
    FUNCTION get_motcar_item_gicls026( 
        p_line_cd          GIPI_POLBASIC.line_cd%TYPE,  
        p_subline_cd       GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd           GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy         GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no       GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no         GIPI_POLBASIC.renew_no%TYPE,
        p_item_no          GIPI_ITEM.item_no%TYPE
   )
   RETURN motcar_item_tab PIPELINED
   IS
        v_list             motcar_item_type;
        previous_item_no   GIPI_VEHICLE.ITEM_NO%TYPE := -1; 
   BEGIN
        FOR cur IN (SELECT A.item_no, b.item_title, A.model_year, d.car_company_cd, 
                           d.car_company, E.make_cd, E.make, A.motor_no, A.serial_no, 
                           A.plate_no, f.basic_color_cd, f.basic_color, f.color_cd, f.color 
                      FROM gipi_vehicle A, gipi_item b, gipi_polbasic c, 
                           giis_mc_car_company d, giis_mc_make E, giis_mc_color f 
                     WHERE A.item_no = b.item_no 
                       AND A.policy_id = b.policy_id 
                       AND b.policy_id = c.policy_id 
                       AND c.line_cd = p_line_cd 
                       AND c.subline_cd = p_subline_cd 
                       AND c.iss_cd = p_iss_cd 
                       AND c.issue_yy = p_issue_yy 
                       AND c.pol_seq_no = p_pol_seq_no 
                       AND c.renew_no = p_renew_no 
                       AND A.item_no = NVL(p_item_no, A.item_no)
                       AND A.car_company_cd = d.car_company_cd(+)
                       AND A.make_cd = E.make_cd(+)
                       AND A.basic_color_cd = f.basic_color_cd(+)
                       AND A.color_cd = f.color_cd(+)
                     ORDER BY A.item_no,A.policy_id)
        LOOP
            IF cur.item_no <> previous_item_no THEN
                v_list.item_no             := cur.item_no;
                v_list.item_title          := cur.item_title;
                v_list.model_year          := cur.model_year;
                v_list.car_company_cd      := cur.car_company_cd;
                v_list.car_company         := cur.car_company;
                v_list.make_cd             := cur.make_cd;
                v_list.make                := cur.make;
                v_list.motor_no            := cur.motor_no;
                v_list.serial_no           := cur.serial_no;
                v_list.plate_no            := cur.plate_no;
                v_list.basic_color_cd      := cur.basic_color_cd;
                v_list.basic_color         := cur.basic_color;
                v_list.color_cd            := cur.color_cd;
                v_list.color               := cur.color;
                previous_item_no           := cur.item_no;
                PIPE ROW(v_list);
            END IF;
        END LOOP;
   END get_motcar_item_gicls026;
   
   FUNCTION get_ctpl_policy_listing(
      p_cred_branch        GIPI_POLBASIC.cred_branch%TYPE,
      p_as_of_date         VARCHAR2,
      p_from_date          VARCHAR2,
      p_to_date            VARCHAR2,
      p_plate_ending       VARCHAR2,
      p_date_basis         VARCHAR2,
      p_date_range         VARCHAR2,
      p_reinsurance        VARCHAR2,
      p_module_id          GIIS_MODULES.module_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN ctpl_policy_listing_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;
      
      v_row                ctpl_policy_listing_type;
      v_line_cd_mc         VARCHAR2(10);
      v_query              VARCHAR2(5000);
      c                    cur_typ;
      
      v_clause1 				VARCHAR(3000) := 'policy_id IN (SELECT policy_id 
		                                                       FROM gipi_polbasic 
		                                                      WHERE pol_flag IN ('||''''||'1'||''''||','||''''||'2'||''''||','||''''||'3'||''''||','||''''||'X'||''''||') 
		                                                        AND line_cd = giisp.v('||''''||'LINE_CODE_MC'||''''||') 
		                                                        AND endt_seq_no = 0
		                                                        AND (check_user_per_iss_cd2(line_cd, iss_cd, ''' || p_module_id || ''', ''' || p_user_id || ''') = 1 ' ||
		                                                        'OR check_user_per_iss_cd2(line_cd, cred_branch, ''' || p_module_id || ''', ''' || p_user_id || ''') = 1)) ' ||
		                                                       'AND policy_id IN (SELECT policy_id
		                                                       FROM gipi_itmperil a, giis_parameters b
		                                                      WHERE a.peril_cd = b.param_value_n
		                                                        AND b.param_name = ''CTPL''
		                                                        AND item_no = gipi_vehicle.item_no) ';
                                                             
      v_clause2 			   VARCHAR2(1000) := ' policy_id IN (SELECT policy_id
                           										 	   FROM gipi_polbasic
                      											        WHERE trunc(incept_date) '; 
                                                                                					  
      v_clause3 			   VARCHAR2(1000) := ' policy_id IN (SELECT policy_id
                       												      FROM gipi_polbasic
                       											        WHERE trunc(eff_date) ';
                                                                                      						  
      v_clause4 				VARCHAR2(1000) := ' policy_id IN (SELECT policy_id
                        												   FROM gipi_polbasic
                       											        WHERE trunc(expiry_date) ';
                                                             
      v_clause5 		 		VARCHAR2(1000) := ' policy_id IN (SELECT policy_id
                                                               FROM gipi_polbasic
                                                              WHERE trunc(issue_date) ';
                                                             
      v_clause6			   VARCHAR2(1000) := ' policy_id IN (SELECT a.policy_id
                                                               FROM gipi_polbasic a
                                                              WHERE 1=1
                                                                AND a.iss_cd = giisp.v(''ISS_CD_RI'')) ';
                                                               
      v_clause7 				VARCHAR2(1000) := ' policy_id IN (SELECT a.policy_id
                                                               FROM gipi_polbasic a
                                                              WHERE 1=1
                                                                AND a.iss_cd != giisp.v(''ISS_CD_RI'')) ';
                                                               
      v_clause8 				VARCHAR2(1000) := ' 1=1 ';
      
      v_clause9 				VARCHAR2(1000) := ' substr(plate_no,length(plate_no),1)= ';
      
      v_clause             VARCHAR2(1000);
      v_wclause            VARCHAR2(5000);
      
      v_max_eff_date       DATE;
   BEGIN
      IF p_date_basis IS NULL THEN
         RETURN;
      END IF;
   
      BEGIN
         SELECT GIISP.v('LINE_CODE_MC')
           INTO v_line_cd_mc
           FROM DUAL;
      EXCEPTION
         WHEN OTHERS THEN
            v_line_cd_mc := NULL;
      END;
      
      v_query := 'SELECT policy_id, item_no, plate_no, serial_no' ||
                  ' FROM GIPI_VEHICLE' ||
                 ' WHERE policy_id IN (SELECT policy_id' ||
                                       ' FROM GIPI_POLBASIC' ||
                                      ' WHERE pol_flag IN (''1'', ''2'', ''3'', ''X'')' ||
                                        ' AND line_cd = ''' || v_line_cd_mc || '''' ||
                                        ' AND endt_seq_no = 0' ||
                                        ' AND check_user_per_iss_cd2(line_cd, iss_cd, ''' || p_module_id || ''', ''' || p_user_id || ''') = 1) ';
                                        
      IF p_date_basis = 'incept' THEN
         v_clause := v_clause2;
      ELSIF p_date_basis = 'issue' THEN
         v_clause := v_clause5;
      ELSIF p_date_basis = 'effectivity' THEN
         v_clause := v_clause3;
      ELSIF p_date_basis = 'expiry' THEN
         v_clause := v_clause4;
      END IF;
      
      IF p_reinsurance = 'direct' THEN
         v_wclause := v_clause7;
      ELSIF p_reinsurance = 'assumed' THEN
         v_wclause := v_clause6;
      ELSE
         v_wclause := v_clause8;
      END IF;
                                        
      IF p_date_range = 'fromDate' THEN
         IF p_plate_ending IS NULL THEN
            v_query := v_query || ' AND ' || v_wclause ||' and '|| v_clause1 || ' AND ' || v_clause || ' BETWEEN ' || '''' || 
                        TO_DATE(p_from_date, 'mm-dd-yyyy') || '''' || ' AND ' || '''' || TO_DATE(p_to_date, 'mm-dd-yyyy') || '''' || ') ';
         ELSE
            v_query := v_query || ' AND ' || v_clause9 || '''' || p_plate_ending || '''' || ' AND ' || v_wclause || ' AND ' || v_clause1 || ' AND ' ||
                        v_clause || ' BETWEEN ' || '''' || TO_DATE(p_from_date, 'mm-dd-yyyy') || '''' || ' AND ' ||
                        '''' || TO_DATE(p_to_date, 'mm-dd-yyyy') || '''' || ') ';
         
         END IF;
      ELSE
         IF p_plate_ending IS NULL THEN
            v_query := v_query || ' AND ' || v_wclause || ' AND ' || v_clause1 || ' AND ' || v_clause || ' <= ' || '''' ||
                        TO_DATE(p_as_of_date, 'mm-dd-yyyy') || '''' || ') ';
         ELSE
            v_query := v_query || ' AND ' || v_clause9 || '''' || p_plate_ending || '''' || ' AND ' || v_wclause || ' AND ' || v_clause1 || ' AND '||
                        v_clause || ' <= ' || '''' || TO_DATE(p_as_of_date, 'mm-dd-yyyy') || '''' || ') ';
         END IF;
      END IF;
      
      IF p_cred_branch IS NOT NULL THEN
         IF check_user_per_line2(NULL, p_cred_branch, p_module_id, p_user_id) = 1 THEN
            v_query := v_query || ' and policy_id IN (SELECT policy_id
			                                               FROM gipi_polbasic
			                                              WHERE check_user_per_line2(line_cd, cred_branch, ''' || p_module_id || ''', ''' || p_user_id || ''') = 1
		                                                   AND cred_branch = ''' || p_cred_branch || ''') ';
         ELSE
            v_query := v_query || ' and policy_id IN (SELECT policy_id
			                                               FROM gipi_polbasic
			                                              WHERE check_user_per_line2(line_cd, iss_cd, ''' || p_module_id || ''', ''' || p_user_id || ''') = 1
		                                                   AND cred_branch = ''' || p_cred_branch || '''' ||
		                                                 ' AND cred_branch IS NOT NULL) ';
         END IF;
      ELSE
         v_query := v_query || ' and policy_id IN (SELECT policy_id
                                                     FROM gipi_polbasic
                                                    WHERE check_user_per_line2(line_cd, iss_cd, ''' || p_module_id || ''', ''' || p_user_id || ''') = 1
		                                                 OR (check_user_per_line2(line_cd, cred_branch, ''' || p_module_id || ''', ''' || p_user_id || ''') = 1
		                                                AND cred_branch IS NOT NULL)) ';
      END IF;
      
      v_query := v_query || ' ORDER BY (SELECT eff_date
                                          FROM GIPI_POLBASIC
                                         WHERE GIPI_POLBASIC.policy_id = GIPI_VEHICLE.policy_id) DESC';
      
      OPEN c FOR v_query;
      LOOP
         v_row := NULL;
      
         FETCH c
          INTO v_row.policy_id, v_row.item_no, v_row.plate_no, v_row.serial_no;
          
         EXIT WHEN c%NOTFOUND;
         
         FOR A IN (SELECT line_cd || '-' || subline_cd || '-' || iss_cd || '-' || LTRIM(TO_CHAR(issue_yy, '09')) || '-' || 
                          LTRIM(TO_CHAR(pol_seq_no, '0999999')) || '-' || LTRIM(TO_CHAR(renew_no, '09')) policy_no
                     FROM GIPI_POLBASIC
                    WHERE policy_id = v_row.policy_id)
         LOOP
	         v_row.policy_no := A.policy_no;
            EXIT;
         END LOOP;
         
         FOR d IN (SELECT A.assd_name
                     FROM GIIS_ASSURED A,
                          GIPI_POLBASIC b,
                          GIPI_PARLIST c
                    WHERE b.par_id = c.par_id
                      AND c.assd_no = A.assd_no
                      AND b.policy_id = v_row.policy_id)
         LOOP
	         v_row.assd_name := d.assd_name;
            EXIT;
         END LOOP;
         
         FOR d IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                     FROM GIPI_POLBASIC
                    WHERE policy_id = v_row.policy_id)
         LOOP 
            FOR E IN (SELECT MAX(eff_date) max_date
	                     FROM GIPI_POLBASIC
	                    WHERE line_cd = d.line_cd
	                      AND subline_cd = d.subline_cd
	                      AND iss_cd = d.iss_cd
	                      AND issue_yy = d.issue_yy
	                      AND pol_seq_no = d.pol_seq_no
	                      AND renew_no = d.renew_no)
            LOOP
	  	         v_max_eff_date := E.max_date;
               
	  	         FOR f IN (SELECT incept_date
	  	                     FROM GIPI_POLBASIC
	  	                    WHERE line_cd = d.line_cd
                            AND subline_cd = d.subline_cd
                            AND iss_cd = d.iss_cd
                            AND issue_yy = d.issue_yy
                            AND pol_seq_no = d.pol_seq_no
                            AND renew_no = d.renew_no
                            AND eff_date LIKE TO_DATE(v_max_eff_date))
               LOOP
                  v_row.incept_date := TO_CHAR(f.incept_date, 'mm-dd-yyyy');
	            END LOOP;
            END LOOP;
         END LOOP;
         
         FOR d IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                     FROM GIPI_POLBASIC
                    WHERE policy_id = v_row.policy_id)
         LOOP
            FOR f IN (SELECT MAX(A.endt_seq_no) endt_no
                        FROM GIPI_POLBASIC A,
                             GIPI_VEHICLE b
                       WHERE A.line_cd = d.line_cd
                         AND A.subline_cd = d.subline_cd
                         AND A.iss_cd = d.iss_cd
                         AND A.issue_yy = d.issue_yy
                         AND A.pol_seq_no = d.pol_seq_no
                         AND A.renew_no = d.renew_no
                         AND A.policy_id = b.policy_id
                         AND b.item_no = v_row.item_no)
            LOOP
	    	      DECLARE
	    	         v_endt_no         NUMBER;
	    	      BEGIN
	    	         v_endt_no := f.endt_no;
                  
                  FOR G IN (SELECT b.plate_no, b.serial_no
                              FROM GIPI_POLBASIC A,
                                   GIPI_VEHICLE b
                             WHERE A.line_cd = d.line_cd
                               AND A.subline_cd = d.subline_cd
                               AND A.iss_cd = d.iss_cd
                               AND A.issue_yy = d.issue_yy
                               AND A.pol_seq_no = d.pol_seq_no
                               AND A.renew_no = d.renew_no
                               AND A.policy_id = b.policy_id
                               AND b.item_no = v_row.item_no)
                  LOOP
                     FOR i IN 0..v_endt_no 
                     LOOP
                        IF G.plate_no IS NOT NULL THEN
                           v_row.dsp_plate_no := G.plate_no; 
                        END IF;
                           
                        IF G.serial_no IS NOT NULL THEN
                           v_row.dsp_serial_no := G.serial_no;
                        END IF;
                     END LOOP;
                  END LOOP;
	    	      END;
            END LOOP;
         END LOOP;
         
         FOR d IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                     FROM GIPI_POLBASIC
                    WHERE policy_id = v_row.policy_id)
         LOOP
            FOR f IN (SELECT MAX(A.endt_seq_no) endt_no
                        FROM gipi_polbasic A, gipi_vehicle b
                       WHERE A.line_cd = d.line_cd
                         AND A.subline_cd = d.subline_cd
                         AND A.iss_cd = d.iss_cd
                         AND A.issue_yy = d.issue_yy
                         AND A.pol_seq_no = d.pol_seq_no
                         AND A.renew_no = d.renew_no
                         AND A.policy_id = b.policy_id
                         AND b.item_no = v_row.item_no)
            LOOP
	    	      DECLARE
                  v_endt_no      NUMBER;
                  v_make         VARCHAR2(50);
                  v_company      VARCHAR2(50);
	    	      BEGIN
	    	         v_endt_no := f.endt_no;
                  
	    	         FOR G IN (SELECT b.car_company_cd, b.make_cd
                              FROM GIPI_VEHICLE b,
                                   GIPI_POLBASIC A
                             WHERE 1 = 1 
                               AND b.policy_id = A.policy_id
                               AND A.subline_cd = d.subline_cd
                               AND A.iss_cd = d.iss_cd
                               AND A.issue_yy = d.issue_yy
                               AND A.pol_seq_no = d.pol_seq_no
                               AND A.renew_no = d.renew_no   
                               AND b.item_no = v_row.item_no)
	    	         LOOP
	    		         FOR h IN (SELECT M.car_company
	    		                     FROM GIIS_MC_CAR_COMPANY M
	    		                    WHERE M.car_company_cd = G.car_company_cd)
	    		         LOOP
	    		            v_company := h.car_company;
	    		         END LOOP;
	    		  
	    		         FOR i IN (SELECT K.make
	    		                     FROM GIIS_MC_MAKE K
	    		                    WHERE K.make_cd = G.make_cd
	    		                      AND K.car_company_cd = G.car_company_cd)
	    		         LOOP
	    		  	         v_make := i.make;
	    		         END LOOP;
	    		  
	    		         v_row.dsp_co_make := v_company || ' ' || v_make;
                  END LOOP;
               END;
            END LOOP;
         END LOOP;
         
         FOR d IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                     FROM GIPI_POLBASIC
                    WHERE policy_id = v_row.policy_id)
         LOOP 
	         FOR c IN (SELECT SUM(prem_amt) ctpl_amt
                        FROM GIPI_ITMPERIL A,
                             GIIS_PARAMETERS b 
        	              WHERE item_no = v_row.item_no
	                      AND A.peril_cd = b.param_value_n
	                      AND b.param_name = 'CTPL'
	                      AND policy_id IN (SELECT policy_id
                                             FROM GIPI_POLBASIC
												        WHERE line_cd = d.line_cd
													       AND subline_cd = d.subline_cd
													       AND iss_cd = d.iss_cd
													       AND issue_yy = d.issue_yy
													       AND pol_seq_no = d.pol_seq_no
 													       AND renew_no = d.renew_no))
            LOOP
	            v_row.ctpl_premium := NVL(c.ctpl_amt,'0.00');
            END LOOP;

            IF d.iss_cd = GIISP.v('LINE_CODE_RI') THEN
               FOR c IN (SELECT A.ri_name
                           FROM GIIS_REINSURER A,
                                GIRI_INPOLBAS c
                          WHERE 1=1
                            AND c.ri_cd = A.ri_cd
                            AND c.policy_id = v_row.policy_id)
               LOOP
                  v_row.reinsurer := c.ri_name;
               END LOOP;
            END IF;
            
            BEGIN
               SELECT DISTINCT cred_branch
                 INTO v_row.cred_branch
                 FROM GIPI_POLBASIC A,
                      GIPI_VEHICLE b 
                WHERE 1=1 
                  AND A.policy_id = b.policy_id
                  AND b.policy_id = v_row.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_row.cred_branch := NULL;
            END;
         END LOOP;
          
         PIPE ROW(v_row);
      END LOOP;
      
      CLOSE c;
   END;
       
END gipi_vehicle_pkg;
/



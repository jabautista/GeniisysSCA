CREATE OR REPLACE PACKAGE BODY CPI.GIISS103_PKG
AS

   FUNCTION get_make_listing(
      p_make_cd               giis_mc_make.make_cd%TYPE,
      p_make                  giis_mc_make.make%TYPE,
      p_no_of_pass            giis_mc_make.no_of_pass%TYPE,
      p_subline_cd            giis_mc_make.subline_cd%TYPE,
      p_car_company_cd        giis_mc_make.car_company_cd%TYPE
   )
     RETURN make_tab PIPELINED
   IS
      v_row                   make_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_mc_make
                WHERE make_cd = NVL(p_make_cd, make_cd)
                  AND UPPER(make) LIKE UPPER(NVL(p_make, '%'))
                  AND NVL(no_of_pass, 0) = NVL(p_no_of_pass, NVL(no_of_pass, 0))
                  AND UPPER(NVL(subline_cd, '%')) LIKE UPPER(NVL(p_subline_cd, NVL(subline_cd, '%')))
                  AND car_company_cd = NVL(p_car_company_cd, car_company_cd)
                ORDER BY make_cd, make)
      LOOP
         v_row.make_cd := i.make_cd;
         v_row.make := i.make;
         v_row.car_company_cd := i.car_company_cd;
         v_row.subline_cd := i.subline_cd;
         v_row.no_of_pass := i.no_of_pass;
         v_row.remarks := i.remarks;
         v_row.user_id := i.user_id;
         v_row.last_update := i.last_update;
         v_row.dsp_last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         v_row.subline_name := NULL;
         FOR c IN(SELECT subline_name
	  		  		     FROM giis_subline
		  			    WHERE subline_cd = i.subline_cd)
         LOOP
            v_row.subline_name := c.subline_name;
            EXIT;
         END LOOP;
         
         v_row.car_company := NULL;
         FOR c IN(SELECT car_company
	  	  			     FROM giis_mc_car_company
		  			    WHERE car_company_cd = i.car_company_cd)
         LOOP
            v_row.car_company := c.car_company;
            EXIT;
         END LOOP;
            
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_eng_listing(
      p_make_cd               giis_mc_make.make_cd%TYPE,
      p_car_company_cd        giis_mc_make.car_company_cd%TYPE,
      p_series_cd             giis_mc_eng_series.series_cd%TYPE,
      p_engine_series         giis_mc_eng_series.engine_series%TYPE
   )
     RETURN eng_tab PIPELINED
   IS
      v_row                   eng_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_mc_eng_series
                WHERE make_cd = p_make_cd
                  AND car_company_cd = p_car_company_cd
                  AND series_cd = NVL(p_series_cd, series_cd)
                  AND UPPER(engine_series) LIKE UPPER(NVL(p_engine_series, '%')))
      LOOP
         v_row.make_cd := i.make_cd;
         v_row.car_company_cd := i.car_company_cd;
         v_row.series_cd := i.series_cd;
         v_row.engine_series := i.engine_series;
         v_row.remarks := i.remarks;
         v_row.user_id := i.user_id;
         v_row.last_update := i.last_update;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_subline_lov(
      p_find_text             VARCHAR2
   )
     RETURN subline_tab PIPELINED
   IS
      v_row                   subline_type;
      v_line_cd_mc            giis_subline.line_cd%TYPE;
   BEGIN
      FOR i IN(SELECT param_value_v
                 FROM giis_parameters
                WHERE param_name LIKE 'LINE_CODE_MC')
      LOOP
         v_line_cd_mc := i.param_value_v;
         EXIT;
      END LOOP;
      
      FOR i IN(SELECT subline_cd, subline_name
                 FROM giis_subline
                WHERE line_cd = v_line_cd_mc
                  AND (UPPER(subline_cd) LIKE UPPER(NVL(p_find_text, '%'))
                       OR UPPER(subline_name) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.subline_cd := i.subline_cd;
         v_row.subline_name := i.subline_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_company_lov(
      p_find_text             VARCHAR2
   )
     RETURN company_tab PIPELINED
   IS
      v_row                   company_type;
   BEGIN
      FOR i IN(SELECT car_company, car_company_cd 
                 FROM giis_mc_car_company
                WHERE (UPPER(car_company) LIKE UPPER(NVL(p_find_text, '%'))
                      OR TO_CHAR(car_company_cd) LIKE NVL(p_find_text, TO_CHAR(car_company_cd))))
      LOOP
         v_row.car_company := i.car_company;
         v_row.car_company_cd := i.car_company_cd;
         PIPE ROW(v_row);
      END LOOP;
   END;

   PROCEDURE val_del_rec(
      p_make_cd               giis_mc_make.make_cd%TYPE,
      p_car_company_cd        giis_mc_make.car_company_cd%TYPE
   )
   IS
      v_exist                 VARCHAR2(1) := 'N';
   BEGIN
      FOR c IN(SELECT 1
	  			     FROM gipi_wvehicle
				    WHERE make_cd = p_make_cd
					   AND car_company_cd = p_car_company_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_MC_MAKE while dependent record(s) in GIPI_WVEHICLE exists.');
      END LOOP;
      
      FOR c IN(SELECT 1
	    			  FROM gipi_vehicle
					 WHERE make_cd = p_make_cd
					   AND car_company_cd = p_car_company_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_MC_MAKE while dependent record(s) in GIPI_VEHICLE exists.');
      END LOOP;
      
      FOR c IN(SELECT 1
                 FROM giis_mc_eng_series
                WHERE make_cd = p_make_cd
                  and car_company_cd = p_car_company_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_MC_MAKE while dependent record(s) in GIIS_MC_ENG_SERIES exists.');
      END LOOP;
   END;
   
   PROCEDURE del_rec(
      p_make_cd               giis_mc_make.make_cd%TYPE,
      p_car_company_cd        giis_mc_make.car_company_cd%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_mc_make
       WHERE make_cd = p_make_cd
         AND car_company_cd = p_car_company_cd;
   END;
   
   PROCEDURE val_add_rec(
      p_action                VARCHAR2,      -- andrew - 08052015 - SR 19241
      p_make_cd               giis_mc_make.make_cd%TYPE,
      p_car_company_cd        giis_mc_make.car_company_cd%TYPE,
      p_make                  giis_mc_make.make%TYPE,-- andrew - 08052015 - SR 19241
      p_subline_cd            giis_mc_make.subline_cd%TYPE,-- andrew - 08052015 - SR 19241
      p_no_of_pass            giis_mc_make.no_of_pass%TYPE-- andrew - 08052015 - SR 19241
   )
   IS
   BEGIN
      IF p_action = 'ADD'-- andrew - 08052015 - SR 19241
      THEN
          FOR i IN(SELECT 1
                     FROM giis_mc_make
                    WHERE make_cd = p_make_cd
                      AND car_company_cd = p_car_company_cd)
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same make_cd and car_company_cd.');
          END LOOP;
      ELSIF p_action = 'UPDATE'-- andrew - 08052015 - SR 19241
      THEN
          FOR i IN(SELECT 1
                     FROM gipi_wvehicle a
                         ,giis_mc_make b
                    WHERE a.make_cd = b.make_cd
                      AND a.car_company_cd = b.car_company_cd
                      AND b.make_cd = p_make_cd
                      AND b.car_company_cd = p_car_company_cd  -- added by robert 02.24.15
                      AND (UPPER(b.make) <> UPPER(p_make) OR NVL(b.subline_cd, 'NULL') <> p_subline_cd OR NVL(b.no_of_pass, -1) <> p_no_of_pass)-- andrew - 08052015 - SR 19241
                      )
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Cannot update record from GIIS_MC_MAKE while dependent record(s) in GIPI_WVEHICLE exists.');-- andrew - 08052015 - SR 19241
          END LOOP;
          
          FOR i IN(SELECT 1
                     FROM gipi_vehicle a
                         ,giis_mc_make b
                    WHERE a.make_cd = b.make_cd
                      AND a.car_company_cd = b.car_company_cd
                      AND b.make_cd = p_make_cd
                      AND b.car_company_cd = p_car_company_cd  -- added by robert 02.24.15
                      AND (UPPER(b.make) <> UPPER(p_make) OR NVL(b.subline_cd, 'NULL') <> p_subline_cd OR NVL(b.no_of_pass, -1) <> p_no_of_pass)-- andrew - 08052015 - SR 19241
                      )
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Cannot update record from GIIS_MC_MAKE while dependent record(s) in GIPI_VEHICLE exists.');-- andrew - 08052015 - SR 19241
          END LOOP;
      END IF;
   END;
   
   PROCEDURE set_rec(
      p_rec                   giis_mc_make%ROWTYPE
   )
   IS
      v_make_cd               giis_mc_make.make_cd%TYPE;
   BEGIN
      IF p_rec.make_cd IS NULL THEN
         BEGIN
            SELECT NVL(MAX(make_cd), 0) + 1
              INTO v_make_cd
              FROM giis_mc_make
             WHERE car_company_cd = p_rec.car_company_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_make_cd := 1; 
         END;
      ELSE
         v_make_cd := p_rec.make_cd;
      END IF;
   
      MERGE INTO giis_mc_make
      USING DUAL
         ON (make_cd = v_make_cd
            AND car_company_cd = p_rec.car_company_cd)
       WHEN NOT MATCHED THEN
            INSERT (make, car_company_cd, subline_cd, remarks, user_id, last_update, make_cd, no_of_pass)
            VALUES (p_rec.make, p_rec.car_company_cd, p_rec.subline_cd, p_rec.remarks, p_rec.user_id,
                    SYSDATE, v_make_cd, p_rec.no_of_pass)
       WHEN MATCHED THEN
            UPDATE SET make = p_rec.make,
                       subline_cd = p_rec.subline_cd,
                       remarks = p_rec.remarks,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE,
                       no_of_pass = p_rec.no_of_pass;
   END;
   
   PROCEDURE val_del_eng(
      p_make_cd               giis_mc_eng_series.make_cd%TYPE,
      p_car_company_cd        giis_mc_eng_series.car_company_cd%TYPE,
      p_series_cd             giis_mc_eng_series.series_cd%TYPE
   )
   IS
   BEGIN
      FOR c IN(SELECT 1
  					  FROM gipi_wvehicle
				    WHERE series_cd = p_series_cd
					   AND make_cd = p_make_cd
					   AND car_company_cd = p_car_company_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_MC_ENG_SERIES while dependent record(s) in GIPI_WVEHICLE exists.');
      END LOOP;
      
      FOR c IN (SELECT series_cd
	  					FROM gipi_vehicle
					  WHERE series_cd = p_series_cd
					    AND make_cd = p_make_cd
					    AND car_company_cd = p_car_company_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_MC_ENG_SERIES while dependent record(s) in GIPI_VEHICLE exists.');
      END LOOP;
   END;
   
   PROCEDURE del_eng(
      p_make_cd               giis_mc_eng_series.make_cd%TYPE,
      p_car_company_cd        giis_mc_eng_series.car_company_cd%TYPE,
      p_series_cd             giis_mc_eng_series.series_cd%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_mc_eng_series
       WHERE make_cd = p_make_cd
         AND car_company_cd = p_car_company_cd
         AND series_cd = p_series_cd;
   END;
   
   PROCEDURE val_add_eng(
      p_action                VARCHAR2,  -- andrew - 08052015 - SR 19241
      p_make_cd               giis_mc_eng_series.make_cd%TYPE,
      p_car_company_cd        giis_mc_eng_series.car_company_cd%TYPE,
      p_series_cd             giis_mc_eng_series.series_cd%TYPE,
      p_engine_series         giis_mc_eng_series.engine_series%TYPE
   )
   IS
   BEGIN
      IF p_action = 'ADD' -- andrew - 08052015 - SR 19241
      THEN
          FOR i IN(SELECT 1
                     FROM giis_mc_eng_series
                    WHERE make_cd = p_make_cd
                      AND car_company_cd = p_car_company_cd
                      AND series_cd = p_series_cd)
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same make_cd, car_company_cd and series_cd.');
          END LOOP;
          
          FOR i IN(SELECT 1
                     FROM giis_mc_eng_series
                    WHERE make_cd = p_make_cd
                      AND car_company_cd = p_car_company_cd
                      AND engine_series = p_engine_series)
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same engine_series.');
          END LOOP;
      ELSIF p_action = 'UPDATE' -- andrew - 08052015 - SR 19241
      THEN
          FOR i IN(SELECT 1
                     FROM gipi_wvehicle a
                         ,giis_mc_eng_series b
                    WHERE a.make_cd = b.make_cd
                      AND a.car_company_cd = b.car_company_cd
                      AND a.series_cd = b.series_cd
                      AND b.make_cd = p_make_cd
                      AND b.car_company_cd = p_car_company_cd
                      AND b.series_cd = p_series_cd
                      AND UPPER(b.engine_series) <> UPPER(p_engine_series))
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Cannot update record from GIIS_MC_ENG_SERIES while dependent record(s) in GIPI_WVEHICLE exists.');-- andrew - 08052015 - SR 19241
          END LOOP;         

          FOR i IN(SELECT 1
                     FROM gipi_vehicle a
                         ,giis_mc_eng_series b
                    WHERE a.make_cd = b.make_cd
                      AND a.car_company_cd = b.car_company_cd
                      AND a.series_cd = b.series_cd
                      AND b.make_cd = p_make_cd
                      AND b.car_company_cd = p_car_company_cd
                      AND b.series_cd = p_series_cd
                      AND UPPER(b.engine_series) <> UPPER(p_engine_series))
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Cannot update record from GIIS_MC_ENG_SERIES while dependent record(s) in GIPI_VEHICLE exists.');-- andrew - 08052015 - SR 19241
          END LOOP;         
      END IF;
   END;
   
   PROCEDURE set_eng(
      p_rec                   giis_mc_eng_series%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO giis_mc_eng_series
      USING DUAL
         ON (make_cd = p_rec.make_cd
            AND car_company_cd = p_rec.car_company_cd
            AND series_cd = p_rec.series_cd)
       WHEN NOT MATCHED THEN
            INSERT (make_cd, car_company_cd, series_cd, engine_series, user_id, last_update)
            VALUES (p_rec.make_cd, p_rec.car_company_cd, p_rec.series_cd, p_rec.engine_series, p_rec.user_id, SYSDATE)
       WHEN MATCHED THEN
            UPDATE SET engine_series = p_rec.engine_series,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE;
   END;
   
END;
/



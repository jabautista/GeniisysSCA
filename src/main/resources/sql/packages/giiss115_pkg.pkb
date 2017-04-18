CREATE OR REPLACE PACKAGE BODY CPI.giiss115_pkg
AS
   FUNCTION get_rec_list(
      p_car_company_cd     giis_mc_car_company.car_company_cd%TYPE,
      p_car_company        giis_mc_car_company.car_company%TYPE
   )
     RETURN rec_tab PIPELINED
   IS 
      v_rec                rec_type;
   BEGIN
      FOR i IN (SELECT a.car_company_cd, a.car_company, a.remarks, a.user_id, a.last_update
                  FROM giis_mc_car_company a
                 WHERE a.car_company_cd = NVL(p_car_company_cd, a.car_company_cd)
                   AND UPPER (a.car_company) LIKE UPPER (NVL (p_car_company, '%'))
                 ORDER BY a.car_company_cd)
      LOOP
         v_rec.car_company_cd := i.car_company_cd;
         v_rec.car_company := i.car_company;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE set_rec(
      p_rec                giis_mc_car_company%ROWTYPE
   )
   IS
      v_car_company_cd     giis_mc_car_company.car_company_cd%TYPE;
   BEGIN
      IF p_rec.car_company_cd IS NULL THEN
         SELECT car_company_car_company_cd_s.NEXTVAL
           INTO v_car_company_cd
           FROM DUAL;
      ELSE
         v_car_company_cd := p_rec.car_company_cd;
      END IF;
   
      MERGE INTO giis_mc_car_company
      USING DUAL
         ON (car_company_cd = v_car_company_cd)
       WHEN NOT MATCHED THEN
            INSERT (car_company_cd, car_company, remarks, user_id, last_update)
            VALUES (v_car_company_cd, p_rec.car_company, p_rec.remarks, p_rec.user_id, SYSDATE)
       WHEN MATCHED THEN
            UPDATE SET car_company = p_rec.car_company,
                       remarks = p_rec.remarks,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE;
   END;

   PROCEDURE del_rec(
      p_car_company_cd     giis_mc_car_company.car_company_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_mc_car_company
       WHERE car_company_cd = p_car_company_cd;
   END;

   PROCEDURE val_del_rec(
      p_car_company_cd     giis_mc_car_company.car_company_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_mc_make a
                 WHERE a.car_company_cd = p_car_company_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_MC_CAR_COMPANY while dependent record(s) in GIIS_MC_MAKE exists.');
      END LOOP;
   
      FOR i IN (SELECT '1'
                  FROM gicl_mc_part_cost a
                 WHERE a.car_company_cd = p_car_company_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_MC_CAR_COMPANY while dependent record(s) in GICL_MC_PART_COST exists.');
      END LOOP;
      
      FOR i IN (SELECT '1'
                  FROM gicl_motor_car_dtl a
                 WHERE a.motcar_comp_cd = p_car_company_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_MC_CAR_COMPANY while dependent record(s) in GICL_MOTOR_CAR_DTL exists.');
      END LOOP;
      
      FOR i IN (SELECT '1'
                  FROM gipi_quote_item_mc a
                 WHERE a.car_company_cd = p_car_company_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_MC_CAR_COMPANY while dependent record(s) in GIPI_QUOTE_ITEM_MC exists.');
      END LOOP;
   END;

  PROCEDURE val_add_rec(
      p_car_company        giis_mc_car_company.car_company%TYPE,
      p_car_company_cd     giis_mc_car_company.car_company_cd%TYPE, -- carlo - 08052015 - SR 19241
      p_action             VARCHAR2 -- carlo - 08052015 - SR 19241
   )
   AS
      v_exists   VARCHAR2 (1);
    BEGIN   
      IF UPPER(p_action) = 'ADD'
      THEN
          FOR i IN (SELECT '1'
                      FROM giis_mc_car_company a
                     WHERE a.car_company = p_car_company)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;

          IF v_exists = 'Y'
          THEN
             raise_application_error
                (-20001,
                 'Geniisys Exception#E#Record already exists with the same car_company.'
                );
             RETURN;
          END IF;

          
      ELSIF UPPER(p_action) = 'UPDATE'
      THEN      
          FOR i IN(SELECT 1
             FROM gipi_wvehicle a
                 ,giis_mc_car_company b
            WHERE a.car_company_cd = b.car_company_cd
              AND b.car_company_cd = p_car_company_cd
              AND UPPER(b.car_company) <> UPPER(p_car_company))
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Cannot update record from GIIS_MC_CAR_COMPANY while dependent record(s) in GIPI_WVEHICLE exists.');-- carlo - 08052015 - SR 19241
          END LOOP;
          
           FOR i IN(SELECT 1
             FROM gipi_vehicle a
                 ,giis_mc_car_company b
            WHERE a.car_company_cd = b.car_company_cd
              AND b.car_company_cd = p_car_company_cd
              AND UPPER(b.car_company) <> UPPER(p_car_company))
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Cannot update record from GIIS_MC_CAR_COMPANY while dependent record(s) in GIPI_VEHICLE exists.');-- carlo - 08052015 - SR 19241
          END LOOP;        
      END IF;
   END;
   
END;
/
CREATE OR REPLACE PACKAGE BODY CPI.giiss049_pkg
AS
   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (
                  SELECT vessel_cd, vessel_name, vessel_old_name, rpc_no, year_built,
                         air_type_cd, no_crew, no_pass, remarks, user_id, last_update
                    FROM giis_vessel
                   WHERE vessel_flag = 'A'
                ORDER BY vessel_name, vessel_cd
               )                   
      LOOP
         v_rec.vessel_cd         := i.vessel_cd;   
         v_rec.vessel_name       := i.vessel_name;
         v_rec.vessel_old_name   := i.vessel_old_name; 
         v_rec.rpc_no            := i.rpc_no;      
         v_rec.year_built        := i.year_built;  
         v_rec.air_type_cd       := i.air_type_cd;
         v_rec.no_crew           := i.no_crew;     
         v_rec.no_pass           := i.no_pass;    
         v_rec.remarks           := i.remarks;
         v_rec.user_id           := i.user_id;
         v_rec.last_update       := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         v_rec.air_desc       := '';
         
         IF i.air_type_cd IS NOT NULL THEN
            SELECT AIR_DESC 
              INTO v_rec.air_desc
              FROM GIIS_AIR_TYPE
             WHERE air_type_cd = i.air_type_cd;
         END IF;
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_vessel%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIIS_VESSEL
         USING DUAL
         ON (vessel_cd = p_rec.vessel_cd)
         WHEN NOT MATCHED THEN
            INSERT (vessel_cd, vessel_name, vessel_old_name, rpc_no, year_built, air_type_cd, no_crew, no_pass, remarks, user_id, last_update, vessel_flag)
            VALUES (p_rec.vessel_cd, p_rec.vessel_name, p_rec.vessel_old_name, p_rec.rpc_no, p_rec.year_built, p_rec.air_type_cd, p_rec.no_crew, p_rec.no_pass, p_rec.remarks, p_rec.user_id,  SYSDATE, 'A')
         WHEN MATCHED THEN
            UPDATE
               SET vessel_name = p_rec.vessel_name, vessel_old_name = p_rec.vessel_old_name, rpc_no = p_rec.rpc_no, year_built = p_rec.year_built,
                   air_type_cd = p_rec.air_type_cd, no_crew = p_rec.no_crew, no_pass = p_rec.no_pass,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_vessel_cd giis_vessel.vessel_cd%TYPE)
   AS
   BEGIN
      DELETE FROM GIIS_VESSEL
            WHERE vessel_cd = p_vessel_cd;
   END;

   FUNCTION val_del_rec (p_vessel_cd giis_vessel.vessel_cd%TYPE)
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (1) := 'N';
      v_table    VARCHAR2(30) := '';
   BEGIN
      IF v_exists = 'N' THEN
      	FOR a IN (
              SELECT 1
                FROM gipi_aviation_item
               WHERE vessel_cd = p_vessel_cd
        )
        LOOP
            v_exists := 'Y';
            v_table  := 'gipi_aviation_item';
            EXIT;
        END LOOP;
      END IF;
      
      IF v_exists = 'N' THEN
      	FOR a IN (
              SELECT 1
                FROM gipi_cargo_carrier
               WHERE vessel_cd = p_vessel_cd
        )
        LOOP
            v_exists := 'Y';
            v_table  := 'gipi_cargo_carrier';
            EXIT;
        END LOOP;
      END IF;
      
      IF v_exists = 'N' THEN
      	FOR a IN (
              SELECT 1
                FROM gipi_item_ves
               WHERE vessel_cd = p_vessel_cd
        )
        LOOP
            v_exists := 'Y';
            v_table  := 'gipi_item_ves';
            EXIT;
        END LOOP;
      END IF;
      
      IF v_exists = 'N' THEN
      	FOR a IN (
              SELECT 1
                FROM gipi_ves_accumulation
               WHERE vessel_cd = p_vessel_cd
        )
        LOOP
            v_exists := 'Y';
            v_table  := 'gipi_ves_accumulation';
            EXIT;
        END LOOP;
      END IF;
      
      IF v_exists = 'N' THEN
      	FOR a IN (
              SELECT 1
                FROM gipi_ves_air
               WHERE vessel_cd = p_vessel_cd
        )
        LOOP
            v_exists := 'Y';
            v_table  := 'gipi_ves_air';
            EXIT;
        END LOOP;
      END IF;
      
      IF v_exists = 'N' THEN
      	FOR a IN (
              SELECT 1
                FROM gipi_waviation_item
               WHERE vessel_cd = p_vessel_cd
        )
        LOOP
            v_exists := 'Y';
            v_table  := 'gipi_waviation_item';
            EXIT;
        END LOOP;
      END IF;
      
      IF v_exists = 'N' THEN
      	FOR a IN (
              SELECT 1
                FROM gipi_wcargo_carrier
               WHERE vessel_cd = p_vessel_cd
        )
        LOOP
            v_exists := 'Y';
            v_table  := 'gipi_wcargo_carrier';
            EXIT;
        END LOOP;
      END IF;
      
      IF v_exists = 'N' THEN
      	FOR a IN (
              SELECT 1
                FROM gipi_witem_ves
               WHERE vessel_cd = p_vessel_cd
        )
        LOOP
            v_exists := 'Y';
            v_table  := 'gipi_witem_ves';
            EXIT;
        END LOOP;
      END IF;
      
      IF v_exists = 'N' THEN
      	FOR a IN (
              SELECT 1
                FROM gipi_wves_air
               WHERE vessel_cd = p_vessel_cd
        )
        LOOP
            v_exists := 'Y';
            v_table  := 'gipi_wves_air';
            EXIT;
        END LOOP;
      END IF;
      
      IF v_exists = 'N' THEN
      	FOR a IN (
              SELECT 1
                FROM gipi_wves_accumulation
               WHERE vessel_cd = p_vessel_cd
        )
        LOOP
            v_exists := 'Y';
            v_table  := 'gipi_wves_accumulation';
            EXIT;
        END LOOP;
      END IF;
      
      
      
      
      
      RETURN (UPPER(v_table));
   END;

   PROCEDURE val_add_rec (p_vessel_cd giis_vessel.vessel_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_vessel
                 WHERE vessel_cd = p_vessel_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same vessel_cd.'
                                 );
      END IF;
   END;
   
   FUNCTION get_giiss049_lov(
        p_search        VARCHAR2
   ) 
      RETURN giiss049_lov_tab PIPELINED
   IS
      v_list giiss049_lov_type;
   BEGIN
        FOR i IN (
                SELECT air_type_cd, air_desc
                  FROM giis_air_type
                 WHERE (air_type_cd LIKE (p_search)
                    OR UPPER(air_desc) LIKE UPPER(p_search))
                 ORDER BY air_type_cd
        )
        LOOP
            v_list.air_type_cd  := i.air_type_cd;
            v_list.air_desc     := i.air_desc;   
        
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   
   END;
   
   PROCEDURE validate_air_type_cd(
        p_air_type_cd   IN OUT VARCHAR2,
        p_air_desc      IN OUT VARCHAR2
    )
    IS
    BEGIN
        SELECT air_type_cd, air_desc
          INTO p_air_type_cd, p_air_desc 
          FROM giis_air_type
         WHERE (UPPER(air_desc) LIKE UPPER(p_air_desc)
            OR (air_type_cd) LIKE (p_air_desc));
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_air_type_cd   := '---';
            p_air_desc      := '---';
        WHEN OTHERS THEN
            p_air_type_cd := NULL;
            p_air_desc    := NULL;
    END;
   
END;
/



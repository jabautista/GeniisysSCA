CREATE OR REPLACE PACKAGE BODY CPI.giiss056_pkg
AS
   FUNCTION get_main
      RETURN main_tab PIPELINED
   IS
      v_list main_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_mc_subline_type
              ORDER BY subline_cd, subline_type_cd)
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_type_cd := i.subline_type_cd;
         v_list.subline_type_desc := i.subline_type_desc;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         PIPE ROW(v_list);
      END LOOP;
   END get_main;
   
   FUNCTION get_subline_lov
      RETURN subline_lov_tab PIPELINED
   IS
      v_list subline_lov_type;
   BEGIN
      FOR i IN (SELECT subline_cd, subline_name
                  FROM giis_subline
                 WHERE line_cd = (SELECT param_value_v
                                    FROM giis_parameters
                                   WHERE param_name = 'LINE_CODE_MC'))
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         
         PIPE ROW(v_list);
      END LOOP;      
   END get_subline_lov;
   
 PROCEDURE val_add_rec (
      p_subline_cd              VARCHAR2,
      p_old_subline_type_cd     VARCHAR2,
      p_new_subline_type_cd     VARCHAR2,
      p_action                  VARCHAR2,
      p_old_subline_type_desc   VARCHAR2,
      p_new_subline_type_desc   VARCHAR2     
     
   )
   IS
      v_exists VARCHAR2(1) := 'N';
      v_error_type VARCHAR2(4);
 BEGIN
   IF UPPER(p_action) = 'ADD' THEN
         BEGIN
            SELECT 'Y', 'TYPE'
              INTO v_exists, v_error_type
              FROM giis_mc_subline_type
             WHERE subline_cd = p_subline_cd
               AND subline_type_cd = p_new_subline_type_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_exists := 'N';      
         END;
                     
         IF v_exists = 'N' THEN
            BEGIN
               SELECT 'Y', 'DESC'
                 INTO v_exists, v_error_type
                 FROM giis_mc_subline_type
                WHERE subline_cd = p_subline_cd
                  AND subline_type_desc = p_new_subline_type_desc;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_exists := 'N';       
            END;
         END IF;
                     
   ELSE   -- carlo - 08052015 - SR 19241
    IF v_exists = 'N' THEN
      
       BEGIN
            SELECT 'Y' 
              INTO v_exists
              FROM giis_mc_subline_type
             WHERE subline_cd = p_subline_cd
               AND subline_type_cd = p_new_subline_type_cd
               AND subline_type_desc != p_new_subline_type_desc;
        EXCEPTION WHEN NO_DATA_FOUND THEN
                v_exists := 'N';      
       END;
       
     
   
   
      IF v_exists = 'N' THEN
      
        BEGIN
            SELECT 'Y', 'TYPE'
              INTO v_exists, v_error_type
              FROM giis_mc_subline_type
             WHERE subline_cd = p_subline_cd
               AND subline_type_cd = p_new_subline_type_cd
               AND subline_type_cd != p_old_subline_type_cd;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_exists := 'N';      
        END;
         
         IF v_exists = 'N' THEN
            BEGIN
               SELECT 'Y', 'DESC'
                 INTO v_exists, v_error_type
                 FROM giis_mc_subline_type
                WHERE subline_cd = p_subline_cd
                  AND subline_type_desc = p_new_subline_type_desc
                  AND subline_type_desc != p_old_subline_type_desc;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_exists := 'N';       
            END;
         END IF;
        
         
      ELSE
      
        IF v_exists = 'Y' THEN
      
 
         
               BEGIN
                SELECT 'Y','PAR'
                  INTO v_exists,v_error_type
                  FROM DUAL 
                 WHERE EXISTS (SELECT 1               
                  FROM gipi_wvehicle
                 WHERE subline_cd = p_subline_cd
                   AND subline_type_cd = p_new_subline_type_cd);
               EXCEPTION WHEN NO_DATA_FOUND THEN
               v_exists := 'N';       
               END;
                
                   
                   
        ELSE
              BEGIN
                      SELECT 'Y','POST'
                      INTO v_exists,v_error_type
                      FROM DUAL 
                      WHERE EXISTS (SELECT 1 
                      FROM gipi_vehicle
                     WHERE subline_cd = p_subline_cd
                       AND subline_type_cd = p_new_subline_type_cd);
                 EXCEPTION WHEN NO_DATA_FOUND THEN
                    v_exists := 'N';  
                                                             
              END;
            
        END IF; 
          
      END IF; 
    END IF;
  END IF;
      
       
      IF v_exists = 'Y' THEN
         IF v_error_type = 'TYPE' THEN
            raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same subline_cd and subline_type_cd.');
         ELSIF v_error_type = 'DESC' THEN
            raise_application_error (-20001, 'Geniisys Exception#E#Subline Description must be unique per subline.');
         ELSIF v_error_type = 'PAR' THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Cannot update DESCRIPTION from GIIS_MC_SUBLINE_TYPE while dependent record(s) in GIPI_WVEHICLE.');
         ELSIF v_error_type = 'POST' THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Cannot update DESCRIPTION from GIIS_MC_SUBLINE_TYPE while dependent record(s) in GIPI_VEHICLE.');
         
         END IF;   
      END IF;               
        
     
      
   END val_add_rec;
   
   
   
 
   
 
PROCEDURE save_rec (p_rec giis_mc_subline_type%ROWTYPE)
   IS
   BEGIN
      
      MERGE INTO giis_mc_subline_type
      USING DUAL
      ON (subline_cd = p_rec.subline_cd AND subline_type_cd = p_rec.subline_type_cd)
      WHEN MATCHED THEN
         UPDATE
            SET subline_type_desc = p_rec.subline_type_desc,
                user_id = p_rec.user_id,
                last_update = SYSDATE,
                remarks = p_rec.remarks
      WHEN NOT MATCHED THEN
         INSERT (subline_cd, subline_type_cd, subline_type_desc,
                    user_id, last_update, remarks)
            VALUES (p_rec.subline_cd, p_rec.subline_type_cd, p_rec.subline_type_desc,
                    p_rec.user_id, SYSDATE, p_rec.remarks);
   END save_rec;
   
   PROCEDURE val_del_rec (p_subline_type_cd VARCHAR2)
   IS
      v_exists VARCHAR2(1) := 'N';
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM giis_mc_peril_rate
          WHERE subline_type_cd = p_subline_type_cd
            AND ROWNUM = 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';      
      END;
      
      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_MC_SUBLINE_TYPE while dependent record(s) in GIIS_MC_PERIL_RATE exists.');
      ELSE
         BEGIN
            SELECT 'Y'
           INTO v_exists
           FROM giis_tariff_rates_hdr
          WHERE subline_type_cd = p_subline_type_cd
            AND ROWNUM = 1;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_exists := 'N';   
         END;   
      END IF;
      
      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_MC_SUBLINE_TYPE while dependent record(s) in GIIS_TARIFF_RATES_HDR exists.');
      END IF;         
      
      
   END val_del_rec;
   
   PROCEDURE del_rec (p_subline_cd VARCHAR2, p_subline_type_cd VARCHAR2)
   IS
   BEGIN
      DELETE FROM giis_mc_subline_type
       WHERE subline_cd = p_subline_cd
         AND subline_type_cd = p_subline_type_cd; 
   END del_rec;
   
   PROCEDURE w_rec (p_subline_cd VARCHAR2, p_subline_type_cd VARCHAR2)
   IS
   BEGIN
      DELETE FROM giis_mc_subline_type
       WHERE subline_cd = p_subline_cd
         AND subline_type_cd = p_subline_type_cd; 
   END w_rec;
      
   
END;
/
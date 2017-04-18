CREATE OR REPLACE PACKAGE BODY CPI.gicls184_pkg
AS
   FUNCTION get_rec_list (
      p_nationality_cd     giis_nationality.nationality_cd%TYPE,
      p_nationality_desc   giis_nationality.nationality_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.nationality_cd, a.nationality_desc, a.remarks, a.user_id,
                       a.last_update
                  FROM giis_nationality a
                 WHERE UPPER (a.nationality_cd) LIKE UPPER (NVL (p_nationality_cd, '%'))
                   AND UPPER (a.nationality_desc) LIKE UPPER (NVL (p_nationality_desc, '%'))
                 ORDER BY a.nationality_cd
                   )                   
      LOOP
         v_rec.nationality_cd := i.nationality_cd;
         v_rec.nationality_desc := i.nationality_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_nationality%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_nationality
         USING DUAL
         ON (nationality_cd = p_rec.nationality_cd)
         WHEN NOT MATCHED THEN
            INSERT (nationality_cd, nationality_desc, remarks, user_id, last_update)
            VALUES (p_rec.nationality_cd, p_rec.nationality_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET nationality_desc = p_rec.nationality_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_nationality_cd giis_nationality.nationality_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_nationality
            WHERE nationality_cd = p_nationality_cd;
   END;

   PROCEDURE val_del_rec (p_nationality_cd giis_nationality.nationality_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
   
    FOR i IN (SELECT '1'
                  FROM gicl_motor_car_dtl a
                 WHERE UPPER(a.nationality_cd) = UPPER(p_nationality_cd))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Cannot delete record from GIIS_NATIONALITY while dependent record(s) in GICL_MOTOR_CAR_DTL exists.'
                                 );
      ELSE
          FOR i IN (SELECT '1'
                      FROM gicl_mc_tp_dtl a
                     WHERE UPPER(a.nationality_cd) = UPPER(p_nationality_cd))
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;
          
          IF v_exists = 'Y'
          THEN
             raise_application_error (-20001,
                                      'Geniisys Exception#E#Cannot delete record from GIIS_NATIONALITY while dependent record(s) in GICL_MC_TP_DTL exists.'
                                     );
          END IF;                                       
      END IF;
   END;
   
   PROCEDURE val_add_rec (p_nationality_cd giis_nationality.nationality_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_nationality a
                 WHERE a.nationality_cd = p_nationality_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same nationality_cd.'
                                 );
      END IF;
   END;
END;
/



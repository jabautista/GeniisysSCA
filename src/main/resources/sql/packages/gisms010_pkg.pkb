CREATE OR REPLACE PACKAGE BODY CPI.gisms010_pkg
AS
   FUNCTION get_rec_list (
      p_keyword           gism_user_route.keyword%TYPE,
      p_remarks           gism_user_route.remarks%TYPE,
      p_validate_pin      gism_user_route.validate_pin%TYPE,
      p_restrict_number   gism_user_route.restrict_number%TYPE,
      p_valid_sw          gism_user_route.valid_sw%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT a.keyword, a.remarks, a.validate_pin, a.pin_sw,
                 a.restrict_number, a.number_sw, a.valid_sw, a.user_id,
                 a.last_update
            FROM gism_user_route a
           WHERE UPPER (a.keyword) LIKE UPPER (NVL (p_keyword, '%'))
             AND NVL (UPPER (a.remarks), '%') LIKE
                                                  UPPER (NVL (p_remarks, '%'))
             AND NVL (a.validate_pin, '%') LIKE NVL (p_validate_pin, '%')
             AND NVL (a.restrict_number, '%') LIKE
                                                  NVL (p_restrict_number, '%')
             AND NVL (a.valid_sw, '%') LIKE NVL (p_valid_sw, '%'))
      LOOP
         v_rec.keyword := i.keyword;
         v_rec.remarks := i.remarks;
         v_rec.validate_pin := i.validate_pin;
         v_rec.pin_sw := i.pin_sw;
         v_rec.restrict_number := i.restrict_number;
         v_rec.number_sw := i.number_sw;
         v_rec.valid_sw := i.valid_sw;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec gism_user_route%ROWTYPE)
   IS
   BEGIN
      MERGE INTO gism_user_route
         USING DUAL
         ON (keyword = p_rec.keyword)
         WHEN MATCHED THEN
            UPDATE
               SET remarks = p_rec.remarks,
                   validate_pin = p_rec.validate_pin,
                   restrict_number = p_rec.restrict_number,
                   valid_sw = p_rec.valid_sw, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giiss085_pkg
AS
   FUNCTION get_rec (p_param_name giis_parameters.param_name%TYPE)
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.param_name, a.param_type, a.param_length,
                       a.param_value_v, a.remarks, a.user_id, a.last_update
                  FROM giis_parameters a
                 WHERE a.param_name = p_param_name)
      LOOP
         v_rec.param_name := i.param_name;
         v_rec.param_type := i.param_type;
         v_rec.param_length := i.param_length;
         v_rec.param_value_v := i.param_value_v;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_parameters%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_parameters
         USING DUAL
         ON (param_name = p_rec.param_name AND param_type = p_rec.param_type)
         WHEN NOT MATCHED THEN
            INSERT (param_name, param_length, param_type, param_value_v,
                    remarks, user_id, last_update)
            VALUES (p_rec.param_name, p_rec.param_length, p_rec.param_type,
                    p_rec.param_value_v, p_rec.remarks, p_rec.user_id,
                    SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET param_value_v = p_rec.param_value_v,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;
END;
/



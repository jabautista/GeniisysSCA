CREATE OR REPLACE PACKAGE BODY CPI.giiss061_pkg
AS
   FUNCTION get_rec_list (
      p_param_name            giis_parameters.param_name%TYPE,
      p_param_type            giis_parameters.param_type%TYPE,
      p_param_length          giis_parameters.param_length%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
      v_format_mask           VARCHAR2(100) := 'MM-DD-RRRR';
      v_param_type            VARCHAR2(100);
   BEGIN
      
      BEGIN
       
        FOR param IN (SELECT param_value_v format_mask
                        FROM giis_parameters
                       WHERE param_name = 'FORMAT_MASK')
        LOOP
            v_format_mask := param.format_mask;
            EXIT;
        END LOOP;
        
        v_rec.format_mask := NVL(v_format_mask, 'MM-DD-RRRR');
      
      END;
   
      FOR i IN (SELECT a.param_type, a.param_name,
                       a.param_value_n, a.param_value_v, a.param_value_d,
                       a.param_length, a.remarks, a.user_id, a.last_update
                  FROM giis_parameters a
                 WHERE UPPER(a.param_name) LIKE UPPER(NVL (p_param_name, '%'))
                   AND NVL(a.param_length,0) = NVL(p_param_length, NVL(a.param_length,0))
                   --AND (    UPPER(NVL(a.param_value_v, '%')) LIKE UPPER (NVL (p_param_value_v, '%'))
                        -- OR UPPER(a.param_value_d) LIKE UPPER (NVL (p_param_value_d, '%'))
                   --      OR a.param_value_n = NVL (p_param_value_n, a.param_value_n) )
              ORDER BY a.param_name)
      LOOP
         v_rec.param_type       := i.param_type;
         v_rec.param_name       := i.param_name;
         v_rec.param_value_n    := i.param_value_n;
         v_rec.param_value_v    := i.param_value_v;
         v_rec.param_length     := i.param_length;
         v_rec.remarks          := i.remarks;
         v_rec.user_id          := i.user_id;
         v_rec.last_update      := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         v_rec.param_value_d_str := NULL;
         IF i.param_value_d IS NOT NULL THEN
             v_rec.param_value_d := TO_DATE(TO_CHAR(i.param_value_d, v_rec.format_mask), v_rec.format_mask);
             v_rec.param_value_d_str := TO_CHAR(i.param_value_d, v_rec.format_mask);
             v_rec.param_value_d_str1 := TO_CHAR(i.param_value_d, 'MM-DD-YYYY');
         ELSE
             v_rec.param_value_d := i.param_value_d;
         END IF;

         BEGIN
            SELECT UPPER (rv_meaning)
              INTO v_rec.param_type_mean
              FROM cg_ref_codes
             WHERE (   (    rv_high_value IS NULL
                        AND i.param_type IN
                                              (rv_low_value, rv_abbreviation)
                       )
                    OR (i.param_type BETWEEN rv_low_value AND rv_high_value
                       )
                   )
               AND ROWNUM = 1
               AND rv_domain = 'GIIS_PARAMETERS.PARAM_TYPE';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.param_type_mean := NULL;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_parameters%ROWTYPE)
   IS
   BEGIN
      
      MERGE INTO giis_parameters
         USING DUAL
         ON (param_name = p_rec.param_name)
         WHEN NOT MATCHED THEN
            INSERT (param_type,          param_name,          param_length,
                    param_value_n,       param_value_v,       param_value_d,
                    remarks,             user_id,             last_update)
            VALUES (p_rec.param_type,    p_rec.param_name,    p_rec.param_length,
                    p_rec.param_value_n, p_rec.param_value_v, p_rec.param_value_d,
                    p_rec.remarks,       p_rec.user_id,       SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET param_type = p_rec.param_type,
                   param_length = p_rec.param_length, 
                   param_value_n = p_rec.param_value_n,
                   param_value_v = p_rec.param_value_v,
                   param_value_d = p_rec.param_value_d, 
                   remarks = p_rec.remarks,
                   user_id = p_rec.user_id, 
                   last_update = SYSDATE
            ;
   END;

   
   PROCEDURE val_add_rec (p_param_name giis_parameters.param_name%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_parameters a
                 WHERE UPPER(a.param_name) = UPPER(p_param_name))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with same param_name.');
      END IF;
   END;
   
   PROCEDURE val_del_rec (p_param_name giis_parameters.param_name%TYPE)
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
    
      FOR i IN (SELECT '1'
                  FROM giis_parameters a
                 WHERE UPPER(a.param_name) = UPPER(p_param_name))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Record cannot be deleted.');
      END IF;
   END;
   
END;
/



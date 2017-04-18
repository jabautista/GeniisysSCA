CREATE OR REPLACE PROCEDURE cpi.gicls010_create_override_req (
   p_line_cd       VARCHAR2,
   p_iss_cd        VARCHAR2,
   p_user_id       VARCHAR2,
   p_ovr_remarks   VARCHAR2
)
IS
   v_ovrd_id      NUMBER;
   v_mod_id       NUMBER (3);
   v_func_cl_cd   NUMBER (12);
BEGIN
   SELECT NVL (MAX (override_id), 0) + 1
     INTO v_ovrd_id
     FROM gicl_function_override;

   SELECT module_id
     INTO v_mod_id
     FROM giac_modules
    WHERE module_name = 'GICLS010';

   BEGIN
      SELECT function_col_cd
        INTO v_func_cl_cd
        FROM giac_function_columns
       WHERE module_id = v_mod_id AND function_cd = 'CP';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_func_cl_cd := 0;
   END;

   INSERT INTO gicl_function_override
               (override_id, line_cd, iss_cd, module_id, function_cd,
                display, request_date,
                request_by, remarks
               )
        VALUES (v_ovrd_id, p_line_cd, p_iss_cd, v_mod_id, 'CP',
                'For CANCELLED_POLICY_OVERRIDE', SYSDATE,
                NVL (p_user_id, USER), p_ovr_remarks
               );

   INSERT INTO gicl_function_override_dtl
               (override_id, function_col_cd, function_col_val
               )
        VALUES (v_ovrd_id, v_func_cl_cd, 0
               );
END gicls010_create_override_req;
/
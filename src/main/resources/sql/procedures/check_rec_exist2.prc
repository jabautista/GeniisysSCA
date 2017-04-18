DROP PROCEDURE CPI.CHECK_REC_EXIST2;

CREATE OR REPLACE PROCEDURE CPI.check_rec_exist2 (
   p_claim_id        IN       gicl_eval_csl.claim_id%TYPE,
   p_eval_id         IN       gicl_eval_csl.eval_id%TYPE,
   p_clm_loss_id     IN       gicl_eval_csl.clm_loss_id%TYPE,
   p_payee_type_cd   IN       gicl_eval_csl.payee_type_cd%TYPE,
   p_payee_cd        IN       gicl_eval_csl.payee_cd%TYPE,
   p_rec_exist       OUT      number
)
AS
   --cursor of all override_id that has a function_col_cd = 5 and function_col_val equal to the record's claim_id
   CURSOR override_id_cursor (p_claim gicl_eval_loa.claim_id%TYPE)
   IS
       SELECT override_id 
          FROM GICL_FUNCTION_OVERRIDE_DTL A,
               GIAC_FUNCTION_COLUMNS b,
               GIAC_MODULES c
         WHERE b.table_name = 'GICL_EVAL_LOA'
           AND b.function_cd = 'LO'
           AND b.column_name = 'CLAIM_ID'
           AND b.module_id = c.module_id
           AND c.module_name = 'GICLS070'
           AND A.function_col_cd = b.function_col_cd
           AND function_col_val = p_claim;

   --cursor of all the function_col_cd excluding the function_col_cd = 5
   CURSOR function_col_cd_cursor
   IS
     SELECT UPPER(COLUMN_NAME) column_name, function_col_cd
        FROM GIAC_FUNCTION_COLUMNS a, 
             GIAC_MODULES b
       WHERE a.module_id = b.module_id
         AND b.module_name = 'GICLS070'
         AND function_cd = 'LO'
         AND table_name = 'GICL_EVAL_LOA'
         AND UPPER(COLUMN_NAME) <> 'CLAIM_ID';

   v_exist   NUMBER := 0;
   v_value   NUMBER := 0;
BEGIN
   FOR rec IN override_id_cursor (p_claim_id)
   LOOP
      p_rec_exist := 0;

      FOR rec2 IN function_col_cd_cursor
      LOOP
         --assign values according to the current function_col_cd
         IF rec2.function_col_cd = 6
         THEN
            v_value := p_eval_id;
         ELSIF rec2.function_col_cd = 7
         THEN
            GOTO SKIP;                       -- skip checking the clm_loss_id
         ELSIF rec2.function_col_cd = 8
         THEN
            v_value := p_payee_type_cd;
         ELSIF rec2.function_col_cd = 9
         THEN
            v_value := p_payee_cd;
         END IF;

         --check if record exists
         BEGIN
            SELECT 1
              INTO v_exist
              FROM gicl_function_override_dtl
             WHERE function_col_cd = rec2.function_col_cd
               AND function_col_val = v_value
               AND override_id = rec.override_id;

            p_rec_exist := NVL (p_rec_exist, 0) + NVL (v_exist, 0);

            IF p_rec_exist = 3
            THEN
--there is an existing record for claim_id, payee_type_cd, payee_cd and eval_id in gicl_function_override_dtl
               BEGIN
                  --check if override_id exist in gicl_function_override and that override_user is not null
                  SELECT 1
                    INTO v_exist
                    FROM gicl_function_override
                   WHERE override_id = rec.override_id
                     AND override_user IS NOT NULL;

                  p_rec_exist := NVL (p_rec_exist, 0) + NVL (v_exist, 0);
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     p_rec_exist := NVL (p_rec_exist, 0) + 2;
                     RETURN;
               END;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_rec_exist := 0;
               EXIT;
         END;

         <<skip>>
         NULL;
      END LOOP;
   END LOOP;
END;
/



SET serveroutput on;

DECLARE
   v_exists1   NUMBER        := 0;
   v_exists2   NUMBER        := 0;
   v_exists3   NUMBER        := 0;
   v_fund_cd   VARCHAR2 (10) := CPI.giacp.v ('FUND_CD');
BEGIN
   BEGIN
      SELECT 1
        INTO v_exists1
        FROM giac_deferred_procedures
       WHERE procedure_id = 2
         AND fund_cd = v_fund_cd
         AND procedure_desc = 'STRAIGHT';

      IF v_exists1 = 1
      THEN
         DBMS_OUTPUT.put_line
             ('STRAIGHT method already existing in GIAC_DEFERRED_PROCEDURES.');
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO cpi.giac_deferred_procedures
                     (procedure_id, fund_cd, procedure_desc, user_id,
                      last_update
                     )
              VALUES (2, 'UGC', 'STRAIGHT', USER,
                      SYSDATE
                     );

         DBMS_OUTPUT.put_line ('STRAIGHT method inserted.');
   END;

   BEGIN
      SELECT 1
        INTO v_exists2
        FROM giac_deferred_procedures
       WHERE procedure_id = 1
         AND fund_cd = v_fund_cd
         AND procedure_desc = '24TH METHOD';

      IF v_exists2 = 1
      THEN
         DBMS_OUTPUT.put_line
            ('24TH METHOD method already existing in GIAC_DEFERRED_PROCEDURES.'
            );
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO cpi.giac_deferred_procedures
                     (procedure_id, fund_cd, procedure_desc,
                      denominator_factor, user_id, last_update
                     )
              VALUES (1, 'UGC', '24TH METHOD',
                      24, USER, SYSDATE
                     );

         DBMS_OUTPUT.put_line ('24TH METHOD method inserted.');
   END;

   BEGIN
      SELECT 1
        INTO v_exists3
        FROM giac_deferred_procedures
       WHERE procedure_id = 3
         AND fund_cd = v_fund_cd
         AND procedure_desc = '1/365';

      IF v_exists3 = 1
      THEN
         DBMS_OUTPUT.put_line
                ('1/365 method already existing in GIAC_DEFERRED_PROCEDURES.');
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO cpi.giac_deferred_procedures
                     (procedure_id, fund_cd, procedure_desc,
                      denominator_factor, user_id, last_update
                     )
              VALUES (3, 'UGC', '1/365',
                      365, USER, SYSDATE
                     );

         DBMS_OUTPUT.put_line ('1/365 method inserted.');
   END;

   COMMIT;
END;
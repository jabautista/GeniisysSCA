CREATE OR REPLACE PACKAGE BODY CPI.GIAC_USER_FUNCTIONS_PKG
AS
   FUNCTION validate_user (
      p_function_code    GIAC_FUNCTIONS.function_code%TYPE,
      p_function_name    GIAC_FUNCTIONS.function_name%TYPE,
      p_module_name      GIAC_MODULES.module_name%TYPE,
      p_valid_tag        GIAC_USER_FUNCTIONS.valid_tag%TYPE)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      SELECT 'Y'
        INTO v_exist
        FROM giac_user_functions
       WHERE     user_id = USER
             AND function_code =
                    (SELECT DISTINCT function_code
                       FROM giac_functions
                      WHERE     function_code = p_function_code
                            AND function_name LIKE p_function_name)
             AND module_id = (SELECT module_id
                                FROM giac_modules
                               WHERE module_name = p_module_name)
             AND valid_tag = p_valid_tag
             AND validity_dt <= SYSDATE
             AND (termination_dt > SYSDATE OR termination_dt IS NULL);

      RETURN v_exist;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
   END;

   FUNCTION check_if_user_has_function (
      p_function_cd    GIAC_FUNCTIONS.function_code%TYPE,
      p_module_name    GIAC_MODULES.module_name%TYPE,
      p_user_id        GIAC_USER_FUNCTIONS.user_id%TYPE)
      RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i
         IN (SELECT C.USER_ID
               FROM GIAC_MODULES A, GIAC_FUNCTIONS B, GIAC_USER_FUNCTIONS C
              WHERE     A.MODULE_ID = B.MODULE_ID
                    AND B.MODULE_ID = C.MODULE_ID
                    AND B.FUNCTION_CODE = C.FUNCTION_CODE
                    AND A.MODULE_NAME LIKE p_module_name
                    AND B.FUNCTION_CODE = p_function_cd
                    AND C.USER_ID = p_user_id
                    AND c.valid_tag = 'Y' -- Added by Jerome Bautista 11.02.2015 SR 3338
                    AND c.validity_dt <= SYSDATE -- Added by Jerome Bautista 11.02.2015 SR 3338
                    AND (c.termination_dt >= SYSDATE OR c.termination_dt IS NULL)) -- Added by Jerome Bautista 11.02.2015 SR 3338
      LOOP
         v_exists := 'Y';
      END LOOP;

      RETURN v_exists;
   END check_if_user_has_function;

   /*
   **  Created by   :  Emman
   **  Date Created :  06.16.2011
   **  Reference By : (GIACS020 - Comm Payts)
   **  Description  : Executes VALIDATE_USER function, this second function accepts user_id parameter
   */
   FUNCTION validate_user2 (
      p_function_code    GIAC_FUNCTIONS.function_code%TYPE,
      p_function_name    GIAC_FUNCTIONS.function_name%TYPE,
      p_module_name      GIAC_MODULES.module_name%TYPE,
      p_valid_tag        GIAC_USER_FUNCTIONS.valid_tag%TYPE,
      p_user_id          GIAC_USER_FUNCTIONS.user_id%TYPE)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      SELECT DISTINCT 'Y' --robert 02.05.2013 added distinct
        INTO v_exist
        FROM giac_user_functions
       WHERE     user_id = NVL (p_user_id, USER)
             AND function_code =
                    (SELECT DISTINCT function_code
                       FROM giac_functions
                      WHERE     function_code = p_function_code
                            AND function_name LIKE p_function_name)
             AND module_id = (SELECT module_id
                                FROM giac_modules
                               WHERE module_name = p_module_name)
             AND valid_tag = p_valid_tag
             AND validity_dt <= SYSDATE
             AND (termination_dt > SYSDATE OR termination_dt IS NULL);

      RETURN v_exist;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
   END validate_user2;


   /*
     **  Created by   :  Tonio
     **  Date Created :  08.22.2011
     **  Reference By : GICLS010 Claims Basic Info
     */
   FUNCTION check_overdue (p_func_name    VARCHAR2,
                           p_module_id    VARCHAR2,
                           p_user         VARCHAR2)
      RETURN VARCHAR2
   IS
      v_select   VARCHAR2 (1) := NULL;
   BEGIN
      FOR rec
         IN (SELECT '1' one
               FROM giac_user_functions a, giac_modules b, giac_functions c
              WHERE     a.module_id = b.module_id
                    AND a.module_id = c.module_id
                    AND a.function_code = c.function_code
                    AND module_name = p_module_id                 --'GICLS010'
                    AND valid_tag = 'Y'
                    AND c.function_name = p_func_name --'OVERDUE_PREMIUM_OVERRIDE'
                    AND a.user_id = p_user
                    AND validity_dt < SYSDATE
                    AND NVL (termination_dt, SYSDATE) >= SYSDATE
                    AND ROWNUM = 1)
      LOOP
         v_select := rec.one;
      END LOOP;

      IF v_select = '1'
      THEN
         RETURN 'Y';
      ELSE
         RETURN 'N';
      END IF;
   END;

   /*
     **  Created by   :  Andrew robes
     **  Date Created :  03.28.2012
     **  Reference By : GICLS032 - Generate Advice
     **  Description : Function to validate if the user has the authority to approve csr
     */
   FUNCTION CHECK_OVR_CSR (p_user_id GIIS_USERS.user_id%TYPE)
      RETURN BOOLEAN
   IS
   BEGIN
      FOR rec
         IN (SELECT '1'
               FROM giac_user_functions a, giac_modules b, giac_functions c
              WHERE     a.module_id = b.module_id
                    AND a.module_id = c.module_id
                    AND a.function_code = c.function_code
                    AND module_name = 'GICLS032'
                    AND valid_tag = 'Y'
                    AND c.function_name = 'APPROVE CSR'
                    AND a.user_id = p_user_id
                    AND validity_dt < SYSDATE
                    AND NVL (termination_dt, SYSDATE) >= SYSDATE
                    AND ROWNUM = 1)
      LOOP
         RETURN (TRUE);
      END LOOP;

      RETURN (FALSE);
   END;

   FUNCTION validate_user3 (
      p_user_id       IN giac_users.user_id%TYPE,
      p_function_cd   IN giac_functions.function_code%TYPE,
      p_module_name   IN giac_modules.module_name%TYPE,
      p_valid_tag     IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_user_function_id   giac_user_functions.user_function_id%TYPE;
   BEGIN
      SELECT c.user_function_id
        INTO v_user_function_id
        FROM giac_modules a, giac_functions b, giac_user_functions c
       WHERE     1 = 1
             AND a.module_name = p_module_name
             AND b.module_id = a.module_id
             AND b.function_code = p_function_cd
             AND c.user_id = p_user_id
             AND c.function_code = b.function_code
             AND c.module_id = b.module_id
             AND c.valid_tag = 'Y'
             AND TRUNC (c.validity_dt) <= TRUNC (SYSDATE)
             AND (   TRUNC (c.termination_dt) > SYSDATE
                  OR TRUNC (c.termination_dt) IS NULL);

      RETURN ('Y');
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN ('N');
   END;
   
   PROCEDURE check_user_validity (
      p_user_id       IN        giac_user_functions.user_id%TYPE,
      p_validity_dt      OUT    VARCHAR2,
      p_termination_dt   OUT    VARCHAR2,
      p_valid_tag        OUT    VARCHAR2
   )
   IS
   BEGIN
      SELECT TO_CHAR (validity_dt, 'MM-DD-YYYY'), TO_CHAR (termination_dt, 'MM-DD-YYYY'), valid_tag
        INTO p_validity_dt, p_termination_dt, p_valid_tag 
        --FROM giac_user_functions
		FROM giac_user_functions a, giac_modules b -- added giac_modules by robert
       WHERE A.USER_ID = p_user_id
         AND FUNCTION_CODE = 'OR'
         --AND MODULE_ID = 46;
		 AND a.module_id = b.module_id
   		 AND module_name = 'GIACM000';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         p_validity_dt      := '';
         p_termination_dt   := '';
         p_valid_tag        := '';
   END;
END GIAC_USER_FUNCTIONS_PKG;
/



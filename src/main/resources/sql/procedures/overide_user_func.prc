DROP PROCEDURE CPI.OVERIDE_USER_FUNC;

CREATE OR REPLACE PROCEDURE CPI.overide_user_func(
   p_username                    VARCHAR2,
   p_password                    VARCHAR2,
   p_databasename                VARCHAR2,
   p_inst_overdue       IN OUT   VARCHAR2,
   p_overide_called     OUT      VARCHAR2,
   p_overide            OUT      VARCHAR2,
   p_overide_ok         IN OUT   VARCHAR2,
   p_overdue_override   OUT      VARCHAR2,
   p_collect_amt_tag    OUT      VARCHAR2,
   p_msg                OUT      VARCHAR2
)
AUTHID CURRENT_USER
IS
   v_validate_user   NUMBER       := NULL;
   v_usr_exist       BOOLEAN; --VARCHAR2 (10); modified by alfie 01.05.2011: to avoid wrong datatype error
   v_oa_user         BOOLEAN;
BEGIN
   p_msg := 'SUCCESS';
   v_usr_exist := verify_user (p_username, p_password, p_databasename);
   --dbms_output.put_line('user exist?: ' || v_usr_exist); modified by alfie 01.05.2011: to avoid wrong datatype error

   IF (v_usr_exist) --IF v_usr_exist = 'TRUE' modified by alfie 01.05.2011: to avoid wrong datatype error
   THEN
      IF p_inst_overdue = 'N'
      THEN
         IF giac_validate_user_fn (p_username, 'CC', 'GIACS007') = 'TRUE'
         THEN
            v_validate_user := 1;
         END IF;

         IF v_validate_user IS NOT NULL
         THEN
            p_overide_called := 'Y';
            p_overide := 'N';
            p_overide_ok := 'Y';
         ELSE
            p_msg :=
                  p_username
               || ' is not allowed to process collections for policies with existing claims.';
         END IF;
      ELSE
         IF giac_validate_user_fn (p_username, 'AO', 'GIACS007') = 'TRUE'
         THEN
            v_oa_user := TRUE;
         END IF;

         IF v_oa_user
         THEN
            p_overide_called := 'Y';
            p_overide := 'N';
            p_overide_ok := 'Y';
            p_overdue_override := 'Y';
            p_inst_overdue := 'N';
            p_collect_amt_tag := 'Y';
         ELSE
            p_msg :=
                  p_username
               || ' is not allowed to process collections for overdue bill.';
         END IF;
      END IF;
   ELSE
      p_msg := 'Invalid username/password.';
   END IF;
END;
/



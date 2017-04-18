CREATE OR REPLACE PACKAGE BODY CPI.GIAC_PARAMETERS_PKG
AS
   /*
   **  Created by  : Mark JM
   **  Date Created  : 04.26.2010
   **  Reference By  : (Policy Documents)
   **  Description  : Returns the default currency
   */
   FUNCTION get_pol_doc_param_value_v (
      p_param_name IN GIAC_PARAMETERS.param_name%TYPE)
      RETURN VARCHAR2
   IS
      v_currency   GIIS_CURRENCY.short_name%TYPE;
   BEGIN
      FOR a IN (SELECT param_value_v
                  FROM GIAC_PARAMETERS
                 WHERE param_name = 'DEFAULT_CURRENCY')
      LOOP
         v_currency := a.param_value_v;
      END LOOP;

      RETURN v_currency;
   END get_pol_doc_param_value_v;

   FUNCTION v (var_param_name GIAC_PARAMETERS.param_name%TYPE)
      RETURN VARCHAR2
   IS
      CURSOR get_v (var_param_name GIAC_PARAMETERS.param_name%TYPE)
      IS
         SELECT param_value_v
           FROM GIAC_PARAMETERS
          WHERE param_name = var_param_name;

      var_return   GIAC_PARAMETERS.param_value_v%TYPE := NULL;
   BEGIN
      OPEN get_v (var_param_name);

      FETCH get_v INTO var_return;

      CLOSE get_v;

      RETURN (VAR_RETURN);
   END v;

   FUNCTION d (var_param_name GIAC_PARAMETERS.param_name%TYPE)
      RETURN DATE
   IS
      CURSOR get_d (var_param_name GIAC_PARAMETERS.param_name%TYPE)
      IS
         SELECT param_value_d
           FROM GIAC_PARAMETERS
          WHERE param_name = var_param_name;

      var_return   GIAC_PARAMETERS.param_value_d%TYPE := NULL;
   BEGIN
      OPEN get_d (var_param_name);

      FETCH get_d INTO var_return;

      CLOSE get_d;

      RETURN (var_return);
   END d;

   FUNCTION n (var_param_name GIAC_PARAMETERS.param_name%TYPE)
      RETURN NUMBER
   IS
      CURSOR get_n (var_param_name GIAC_PARAMETERS.param_name%TYPE)
      IS
         SELECT param_value_n
           FROM GIAC_PARAMETERS
          WHERE param_name = var_param_name;

      var_return   GIAC_PARAMETERS.param_value_n%TYPE := NULL;
   BEGIN
      OPEN get_n (var_param_name);

      FETCH get_n INTO var_return;

      CLOSE get_n;

      RETURN (var_return);
   END n;

   FUNCTION get_parameter_values (
      var_param_name GIAC_PARAMETERS.param_name%TYPE)
      RETURN GIAC_parameters_tab
      PIPELINED
   IS
      v_GIAC_parameters   GIAC_parameters_type;
   BEGIN
      FOR i IN (SELECT param_type,
                       param_value_v,
                       param_name,
                       param_value_n,
                       param_value_d
                  FROM GIAC_PARAMETERS
                 WHERE param_name LIKE var_param_name)
      LOOP
         v_GIAC_parameters.param_type := i.param_type;
         v_GIAC_parameters.param_value_v := i.param_value_v;
         v_GIAC_parameters.param_name := i.param_name;
         v_GIAC_parameters.param_value_n := i.param_value_n;
         v_GIAC_parameters.param_value_d := i.param_value_d;

         PIPE ROW (v_GIAC_parameters);
      END LOOP;

      RETURN;
   END;


   FUNCTION get_branch_cd_by_user_id (p_user_id VARCHAR2)
      RETURN VARCHAR2
   IS
      CURSOR br
      IS
         SELECT b.grp_iss_cd
           FROM giis_users a, giis_user_grp_hdr b
          WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id;

      branch_cd GIAC_PARAMETERS.param_value_v%TYPE;
   BEGIN
      OPEN br;

      FETCH br INTO branch_cd;

      CLOSE br;
	  
	  return branch_cd;
   END;
   
   PROCEDURE toggle_or_flag_sw (p_switch NUMBER) IS
   		v_value		NUMBER(1) := nvl(p_switch, 0);
   BEGIN
          MERGE INTO giac_parameters
            USING DUAL
               ON (param_name = 'OR_FLAG_SW')
       WHEN NOT MATCHED THEN
               INSERT (param_type, param_name,param_value_n, user_id, last_update)
            VALUES ('N', 'OR_FLAG_SW', v_value, USER, SYSDATE)
       WHEN MATCHED THEN
            UPDATE
               SET param_value_n = v_value;
     /*  UPDATE giac_parameters
                       SET param_value_n = 1
                     WHERE param_name = 'OR_FLAG_SW'; */
   END toggle_or_flag_sw;
END GIAC_PARAMETERS_PKG;
/



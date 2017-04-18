CREATE OR REPLACE PACKAGE BODY CPI.giacs190_pkg
AS
   FUNCTION get_sl_type_cd
      RETURN VARCHAR
   IS
      v_sl_type_cd   giac_sl_types.sl_type_cd%TYPE;
   BEGIN
      SELECT sl_type_cd
        INTO v_sl_type_cd
        FROM giac_sl_types
       WHERE sl_type_name IN (SELECT param_value_v
                                FROM giac_parameters
                               WHERE param_name = 'EXPENSE_PER_DEPT');

      RETURN v_sl_type_cd;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END;

   FUNCTION get_branch_lov (
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED
   IS
      v_rec   branch_lov_type;
   BEGIN
      FOR i IN (SELECT   branch_cd, branch_name
                    FROM giac_branches
                   WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                       branch_cd,
                                                       p_module_id,
                                                       p_user_id
                                                      ) = 1
                ORDER BY branch_cd
                                  /* commented out and changed by reymon 05242012
                                  select e.gibr_branch_cd,f.branch_name from giac_acctrans e,giac_branches f where e.gfun_fund_cd=f.gfun_fund_cd and e.gibr_branch_cd=f.branch_cd group by e.gibr_branch_cd,f.branch_name order by e.gibr_branch_cd*/
              )
      LOOP
         v_rec.branch_cd := i.branch_cd;
         v_rec.branch_name := i.branch_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;
END;
/



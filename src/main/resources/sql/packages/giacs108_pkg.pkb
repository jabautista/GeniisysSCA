CREATE OR REPLACE PACKAGE BODY CPI.giacs108_pkg
   /*
   **  Created by        : bonok
   **  Date Created      : 07.18.2013
   **  Reference By      : GIACS108 - EVAT
   **
   */
AS
   FUNCTION get_branch_cd_giacs108_lov(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE
   ) RETURN branch_cd_giacs108_lov_tab PIPELINED AS
      res               branch_cd_giacs108_lov_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE iss_cd IN (SELECT iss_cd 
                                    FROM giis_issource
                                   WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2(NULL, iss_cd, p_module_id, p_user_id), 1, iss_cd, NULL)))
      LOOP
         res.iss_cd := i.iss_cd;
         res.iss_name := i.iss_name;
         
         PIPE ROW(res);
      END LOOP;
   END;
   
   FUNCTION get_line_cd_giacs108_lov   
   RETURN line_cd_giacs108_lov_tab PIPELINED AS
      res               line_cd_giacs108_lov_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line 
                 ORDER BY line_name)
      LOOP
         res.line_cd := i.line_cd;
         res.line_name := i.line_name;
         
         PIPE ROW(res);
      END LOOP;
   END;
END giacs108_pkg;
/


